/******************************************************************************
 * Testbench INT8 - ORDRE [H][W][C] compatible VHDL
 ******************************************************************************/

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>

// Dimensions
#define IN_H  32
#define IN_W  32
#define C1_OUT 3
#define C1_H  28
#define C1_W  28
#define P1_H  14
#define P1_W  14

// Fonctions à tester (ordre [H][W][C])
extern void conv1_q_int8_hwc(const int8_t x[IN_H][IN_W],
                             int8_t y[C1_H][C1_W][C1_OUT]);

extern void maxpool2x2_s2_c1_hwc(const int8_t x[C1_H][C1_W][C1_OUT],
                                 int8_t y[P1_H][P1_W][C1_OUT]);

/******************************************************************************
 * Charger image INT8 directement [-128,127]
 ******************************************************************************/
int load_image_from_file(const char* filename,
                         int8_t img[IN_H][IN_W]) {

    FILE* f = fopen(filename, "r");
    if (!f) {
        printf("ERROR: Cannot open %s\n", filename);
        return -1;
    }

    for (int h = 0; h < IN_H; h++) {
        for (int w = 0; w < IN_W; w++) {
            int val;
            if (fscanf(f, "%d", &val) != 1) {
                printf("ERROR: Failed to read pixel [%d][%d]\n", h, w);
                fclose(f);
                return -1;
            }

            // Saturation
            if (val > 127) val = 127;
            if (val < -128) val = -128;

            img[h][w] = (int8_t)val;
        }
    }

    fclose(f);
    printf("✓ Image loaded (INT8) from %s\n", filename);
    return 0;
}

/******************************************************************************
 * Sauvegarde sortie Conv1 - ORDRE [H][W][C] (compatible VHDL)
 ******************************************************************************/
void save_conv1_output(const char* filename,
                       int8_t y[C1_H][C1_W][C1_OUT]) {

    FILE* f = fopen(filename, "w");
    if (!f) {
        printf("ERROR: Cannot create %s\n", filename);
        return;
    }

    //  Ordre [H][W][C] - IDENTIQUE À VHDL
    for (int h = 0; h < C1_H; h++) {
        for (int w = 0; w < C1_W; w++) {
            for (int c = 0; c < C1_OUT; c++) {
                fprintf(f, "%d\n", y[h][w][c]);
            }
        }
    }

    fclose(f);
    printf("✓ Conv1 output saved to %s (order: [H][W][C])\n", filename);
}

/******************************************************************************
 * Sauvegarde sortie Pool1 - ORDRE [H][W][C]
 ******************************************************************************/
void save_pool1_output(const char* filename,
                       int8_t y[P1_H][P1_W][C1_OUT]) {

    FILE* f = fopen(filename, "w");
    if (!f) {
        printf("ERROR: Cannot create %s\n", filename);
        return;
    }

    // Ordre [H][W][C]
    for (int h = 0; h < P1_H; h++) {
        for (int w = 0; w < P1_W; w++) {
            for (int c = 0; c < C1_OUT; c++) {
                fprintf(f, "%d\n", y[h][w][c]);
            }
        }
    }

    fclose(f);
    printf("✓ Pool1 output saved to %s (order: [H][W][C])\n", filename);
}

/******************************************************************************
 * Comparaison directe HLS vs RTL (INT8) - ORDRE [H][W][C]
 ******************************************************************************/
int compare_conv1_with_rtl(const char* rtl_file,
                           int8_t hls_output[C1_H][C1_W][C1_OUT]) {

    FILE* f = fopen(rtl_file, "r");
    if (!f) {
        printf("WARNING: Cannot open RTL reference %s\n", rtl_file);
        return -1;
    }

    int errors = 0;
    int max_diff = 0;

    // Parcourir dans l'ordre [H][W][C]
    for (int h = 0; h < C1_H; h++) {
        for (int w = 0; w < C1_W; w++) {
            for (int c = 0; c < C1_OUT; c++) {

                int rtl_val;
                if (fscanf(f, "%d", &rtl_val) != 1) {
                    printf("ERROR: Failed to read RTL value at [%d][%d][%d]\n", h, w, c);
                    fclose(f);
                    return -1;
                }

                int diff = abs(hls_output[h][w][c] - rtl_val);

                if (diff > 0) {
                    errors++;
                    if (errors <= 10) {  // Afficher les 10 premières erreurs
                        printf("  Diff[%d][%d][%d]: HLS=%d RTL=%d diff=%d\n",
                               h, w, c,
                               hls_output[h][w][c],
                               rtl_val,
                               diff);
                    }
                }

                if (diff > max_diff) max_diff = diff;
            }
        }
    }

    fclose(f);

    printf("\n========================================\n");
    printf("=== Conv1 Comparison (HLS vs RTL) ===\n");
    printf("========================================\n");
    printf("Total pixels: %d\n", C1_H * C1_W * C1_OUT);
    printf("Errors: %d\n", errors);
    printf("Max difference: %d\n", max_diff);

    if (errors == 0) {
        printf("✓PERFECT MATCH - HLS == RTL\n");
    } else {
        printf(" WARNING: %d differences found\n", errors);
    }
    printf("========================================\n");

    return errors;
}

/******************************************************************************
 * Comparaison Pool1
 ******************************************************************************/
int compare_pool1_with_rtl(const char* rtl_file,
                           int8_t hls_output[P1_H][P1_W][C1_OUT]) {

    FILE* f = fopen(rtl_file, "r");
    if (!f) {
        printf("WARNING: Cannot open RTL reference %s\n", rtl_file);
        return -1;
    }

    int errors = 0;
    int max_diff = 0;

    for (int h = 0; h < P1_H; h++) {
        for (int w = 0; w < P1_W; w++) {
            for (int c = 0; c < C1_OUT; c++) {

                int rtl_val;
                if (fscanf(f, "%d", &rtl_val) != 1) {
                    printf("ERROR: Failed to read RTL value\n");
                    fclose(f);
                    return -1;
                }

                int diff = abs(hls_output[h][w][c] - rtl_val);

                if (diff > 0) {
                    errors++;
                    if (errors <= 10) {
                        printf("  Diff[%d][%d][%d]: HLS=%d RTL=%d diff=%d\n",
                               h, w, c,
                               hls_output[h][w][c],
                               rtl_val,
                               diff);
                    }
                }

                if (diff > max_diff) max_diff = diff;
            }
        }
    }

    fclose(f);

    printf("\n========================================\n");
    printf("=== Pool1 Comparison (HLS vs RTL) ===\n");
    printf("========================================\n");
    printf("Total pixels: %d\n", P1_H * P1_W * C1_OUT);
    printf("Errors: %d\n", errors);
    printf("Max difference: %d\n", max_diff);

    if (errors == 0) {
        printf("✓✓✓ PERFECT MATCH - HLS == RTL\n");
    } else {
        printf("WARNING: %d differences found\n", errors);
    }
    printf("========================================\n");

    return errors;
}

/******************************************************************************
 * MAIN
 ******************************************************************************/
int main() {

    printf("========================================\n");
    printf("=== HLS Testbench - Order [H][W][C] ===\n");
    printf("========================================\n\n");

    // Allocation des buffers (ordre [H][W][C])
    static int8_t input_img[IN_H][IN_W];
    static int8_t conv1_output[C1_H][C1_W][C1_OUT];
    static int8_t pool1_output[P1_H][P1_W][C1_OUT];

    printf("Step 1: Loading input image...\n");
    if (load_image_from_file("input_image_32x32.txt", input_img) != 0) {
        return 1;
    }

    // Afficher quelques pixels
    printf("  First 10 pixels: ");
    for (int i = 0; i < 10; i++) {
        printf("%d ", input_img[0][i]);
    }
    printf("\n\n");

    printf("Step 2: Running Conv1 (order [H][W][C])...\n");
    conv1_q_int8_hwc(input_img, conv1_output);
    printf("✓ Conv1 done\n");

    // Afficher quelques résultats
    printf("  Conv1[0][0][0:2]: ");
    for (int c = 0; c < 3; c++) {
        printf("%d ", conv1_output[0][0][c]);
    }
    printf("\n\n");

    printf("Step 3: Saving Conv1 output...\n");
    save_conv1_output("hls_output_conv1.txt", conv1_output);
    printf("\n");

    printf("Step 4: Comparing Conv1 with RTL...\n");
    int conv1_errors = compare_conv1_with_rtl("output_conv1_28x28x3.txt", conv1_output);
    printf("\n");

    printf("Step 5: Running MaxPool (order [H][W][C])...\n");
    maxpool2x2_s2_c1_hwc(conv1_output, pool1_output);
    printf("✓ Pool1 done\n");

    // Afficher quelques résultats
    printf("  Pool1[0][0][0:2]: ");
    for (int c = 0; c < 3; c++) {
        printf("%d ", pool1_output[0][0][c]);
    }
    printf("\n\n");

    printf("Step 6: Saving Pool1 output...\n");
    save_pool1_output("hls_output_pool1.txt", pool1_output);
    printf("\n");

    printf("Step 7: Comparing Pool1 with RTL (if available)...\n");
    compare_pool1_with_rtl("output_pool1_14x14x3.txt", pool1_output);
    printf("\n");

    printf("========================================\n");
    printf("=== Testbench Finished ===\n");
    if (conv1_errors == 0) {
        printf("=== ✓✓✓ ALL TESTS PASSED ✓✓✓ ===\n");
    } else {
        printf("===  ERRORS DETECTED  ===\n");
    }
    printf("========================================\n");

    return (conv1_errors == 0) ? 0 : 1;
}
