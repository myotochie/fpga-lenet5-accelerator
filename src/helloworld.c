/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
******************************************************************************/

/*
 * helloworld.c: LeNet accelerator HW validation
 *
 * UART: ps7_uart @ 115200 (configured by bootrom/bsp)
 */

#include "xparameters.h"
#include "xil_printf.h"
#include "xil_cache.h"
#include "sleep.h"
#include "xtime_l.h"        // Global Timer PS7 (64-bit @ CPU_CLK/2)
#include <stdint.h>

#include "xlenet_accel.h"
#include "golden_lenet_int8.h"

// ---------- Paramètres ----------
#define N_TEST        500    // nombre d'images à tester (≤ GOLDEN_N)
#define RUNS_IGNORE   10     // premières inférences ignorées (warm-up cache/BRAM)

// Input quantization : float [0,1] → uint8
#define LENET_S_IN    (3.92156886e-03f)
#define LENET_Z_IN    (0)

// Offset invalidation : couvre au moins une ligne de cache (64 B) au-delà des scores
#define OFFSET_CACHE  (u32)24
// --------------------------------

// Buffers DDR alignés (hors stack)
static uint8_t  img_u8[GOLDEN_SIZE]            __attribute__((aligned(64)));
static int32_t  scores_i32[GOLDEN_NUM_CLASSES] __attribute__((aligned(64)));

// ----------------------------------------------------------------
// Helpers
// ----------------------------------------------------------------
static inline uint8_t clamp_u8_int(int32_t x) {
    if (x < 0)   return 0;
    if (x > 255) return 255;
    return (uint8_t)x;
}

static inline uint8_t float01_to_u8(float x01) {
    float qf = x01 / LENET_S_IN + (float)LENET_Z_IN;
    int32_t qi = (int32_t)(qf + (qf >= 0 ? 0.5f : -0.5f));
    return clamp_u8_int(qi);
}

static int argmax_i32_10(const int32_t *y) {
    int best = 0;
    int32_t bestv = y[0];
    for (int i = 1; i < 10; i++) {
        if (y[i] > bestv) { bestv = y[i]; best = i; }
    }
    return best;
}

static void clear_scores(int32_t *y, int n) {
    for (int i = 0; i < n; i++) y[i] = 0;
}

// ----------------------------------------------------------------
int main() {
    xil_printf("\r\n--- LeNet_accel HW validation ---\r\n");
    xil_printf("Golden: N=%d, H=%d, W=%d, size=%d\r\n",
               GOLDEN_N, GOLDEN_H, GOLDEN_W, GOLDEN_SIZE);

    // 1) Init IP
    XLenet_accel ip;
    int st = XLenet_accel_Initialize(&ip, XPAR_LENET_ACCEL_0_DEVICE_ID);
    if (st != XST_SUCCESS) {
        xil_printf("[ERROR] XLenet_accel_Initialize failed (%d)\r\n", st);
        return -1;
    }
    xil_printf("[OK] IP init\r\n");

    int correct = 0;
    int nrun = (N_TEST <= GOLDEN_N) ? N_TEST : GOLDEN_N;

    // ----------------------------------------------------------------
    // Stats latence (cycles du Global Timer PS7)
    //   COUNTS_PER_SECOND = CPU_CLK / 2  (défini dans xtime_l.h)
    //   Ex : CPU @ 666 MHz → timer @ 333 MHz → 1 tick ≈ 3 ns
    // ----------------------------------------------------------------
    uint64_t sum_cycles = 0;
    uint64_t min_cycles = (uint64_t)-1;
    uint64_t max_cycles = 0;
    int      n_meas     = 0;

    const double cps = (double)COUNTS_PER_SECOND;

    for (int n = 0; n < nrun; n++) {

        // 2) Préparer image u8 depuis golden float [0,1]
        for (int i = 0; i < GOLDEN_SIZE; i++)
            img_u8[i] = float01_to_u8(golden_images[n][i]);

        clear_scores(scores_i32, GOLDEN_NUM_CLASSES);

        // 3) Cache flush avant transfert DMA
        Xil_DCacheFlushRange((UINTPTR)img_u8,     sizeof(img_u8));
        Xil_DCacheFlushRange((UINTPTR)scores_i32, sizeof(scores_i32) + OFFSET_CACHE);

        // 4) Passer les pointeurs DDR à l'IP
        XLenet_accel_Set_in_img_u8(&ip,      (u64)(UINTPTR)img_u8);
        XLenet_accel_Set_out_scores_i32(&ip, (u64)(UINTPTR)scores_i32);

        // ----------------------------------------------------------------
        // 5) Mesure HW-only : Start → Done
        //    On utilise uint64_t pour éviter tout overflow sur XTime (u64)
        //    et pour rester cohérent avec les opérations sur sum/min/max.
        // ----------------------------------------------------------------
        XTime t0, t1;
        XTime_GetTime(&t0);

        XLenet_accel_Start(&ip);
        while (!XLenet_accel_IsDone(&ip)) { }

        XTime_GetTime(&t1);
        uint64_t dt = (uint64_t)(t1 - t0);
        // ----------------------------------------------------------------

        // 6) Invalidate cache pour relire ce que le HW a écrit en DDR
        Xil_DCacheInvalidateRange((UINTPTR)scores_i32, sizeof(scores_i32) + OFFSET_CACHE);

        // 7) Décision
        int pred_hw     = argmax_i32_10(scores_i32);
        int pred_golden = golden_preds[n];
        int label       = golden_labels[n];

        if (pred_hw == label) correct++;

        // 8) Accumulation stats (on ignore les RUNS_IGNORE premières)
        if (n >= RUNS_IGNORE) {
            sum_cycles += dt;
            if (dt < min_cycles) min_cycles = dt;
            if (dt > max_cycles) max_cycles = dt;
            n_meas++;
        }

        // 9) Log par image
        xil_printf("n=%3d label=%d golden=%d hw=%d  scores=[",
                   n, label, pred_golden, pred_hw);
        for (int k = 0; k < GOLDEN_NUM_CLASSES; k++) {
            xil_printf("%ld", (long)scores_i32[k]);
            if (k < GOLDEN_NUM_CLASSES - 1) xil_printf(",");
        }
        xil_printf("]\r\n");
    }

    // ----------------------------------------------------------------
    // 10) Résumé accuracy
    // ----------------------------------------------------------------
    xil_printf("\r\nDone. correct=%d/%d  acc=%d%%\r\n",
               correct, nrun, (correct * 100) / nrun);

    // ----------------------------------------------------------------
    // 11) Résumé latence
    //     xil_printf ne supporte pas %f → on affiche en entier
    //     en multipliant par 1000 pour garder 3 décimales (×1000 us = ns).
    // ----------------------------------------------------------------
    if (n_meas > 0) {
        double avg_cycles = (double)sum_cycles / (double)n_meas;
        double avg_us     = (avg_cycles   * 1e6) / cps;
        double min_us     = ((double)min_cycles * 1e6) / cps;
        double max_us     = ((double)max_cycles * 1e6) / cps;
        double fps        = 1e6 / avg_us;
        double ap_clk_hz   = 100e6;   // à adapter si tu changes la fréquence
        double cycles_ip   = (avg_us * 1e-6) * ap_clk_hz;

        xil_printf("\r\n--- IP latency (Start->Done) ---\r\n");
        xil_printf("Warm-up ignores   : %d runs\r\n", RUNS_IGNORE);
        xil_printf("Measured runs     : %d\r\n", n_meas);
        xil_printf("COUNTS_PER_SECOND : %lu\r\n", (unsigned long)COUNTS_PER_SECOND);
        // Valeurs multipliées par 1000 → lire comme X.XXX us / X.XXX img/s
        xil_printf("min  : %lu cycles  (%lu /1000 us)\r\n",
                   (unsigned long)min_cycles,
                   (unsigned long)(min_us * 1000));
        xil_printf("avg  : %lu cycles  (%lu /1000 us)\r\n",
                   (unsigned long)(uint64_t)avg_cycles,
                   (unsigned long)(avg_us * 1000));
        xil_printf("max  : %lu cycles  (%lu /1000 us)\r\n",
                   (unsigned long)max_cycles,
                   (unsigned long)(max_us * 1000));
        xil_printf("throughput ~ %lu /1000 img/s\r\n",
                   (unsigned long)(fps * 1000));
        xil_printf("Cycles ap_clk (calcule) : %lu\r\n",
        		(unsigned long)cycles_ip);
    }

    return 0;
}
