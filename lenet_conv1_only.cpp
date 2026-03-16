// =============================================================================
// FICHIER DE TEST HLS : Conv1 + MaxPool1 — Étude des pragmas Vitis HLS
// =============================================================================
//
// Paramètres réels issus de lenet_params_int8.h et lenet_qparams_min.h
//
// STRUCTURE DU FICHIER :
//   - Section A : Version de référence (aucun pragma)
//   - Section B : Version avec PIPELINE uniquement
//   - Section C : Version avec PIPELINE + UNROLL
//   - Section D : Version avec PIPELINE + ALLOCATION
//   - Section E : Variantes BIND_STORAGE (RAM_1P / RAM_2P / LUTRAM)
//   - Section F : Version optimale combinée (issue du LeNet corrigé)
//   - Section G : Testbench
//
// =============================================================================

#include <stdint.h>
#include <ap_int.h>

// --------------------------------------------------
// VRAIS POIDS ET BIAIS CONV1 (issus de lenet_params_int8.h)
// --------------------------------------------------
static const int8_t LENET_C1_W[3][1][5][5] = {
45, 90, 68, 80, 125, 61, 39, 102, 77, 49, 29, 66, -6, -60, -61, 51,
-9, -58, -32, -101, -45, 31, 7, 50, -14, 65, 68, -15, 26, -61, 66, 19,
101, 84, 95, 76, 33, 107, 118, 94, 4, 86, 80, 79, 127, 28, -33, -54,
41, 64, 30, 88, 70, 49, -49, 49, 51, 59, -14, -113, 89, 71, 54, -68,
-89, 93, 34, -2, -49, -102, 71, 69, -39, -82, -102,
};

// Biais en INT32 — IMPORTANT : pas INT8 !
// Valeurs = biais_float / (S_IN x S_W) = biais_float / (3.92e-3 x 4.256e-3)
// Ex : biais[0] float ≈ +0.0152  →  3563 en domaine quantifié
static const int32_t LENET_C1_B[3] = {3563, -209, -9502};

// --------------------------------------------------
// PARAMÈTRES DE QUANTIFICATION (issus de lenet_qparams_min.h)
// --------------------------------------------------
#define LENET_S_IN          (3.92156886e-03f)   // Scale entrée image
#define LENET_Z_IN          (0)
#define LENET_C1_W_SCALE    (0.004256003070622683f)  // Scale poids Conv1
#define LENET_C1_W_ZP       (0)
#define LENET_S_L1          (2.22108141e-02f)   // Scale sortie Conv1/Pool1
#define LENET_Z_L1          (0)                 // Zero-point = 0 → ReLU implicite
#define LENET_S_L2          (5.31273969e-02f)
#define LENET_Z_L2          (0)
#define LENET_S_OUT         (2.15736702e-01f)
#define LENET_Z_OUT         (150)

// --------------------------------------------------
// PARAMÈTRES RÉSEAU
// --------------------------------------------------
static const int IN_H  = 32, IN_W  = 32;
static const int C1_OUT = 3, C1_K  = 5;
static const int C1_H  = 28, C1_WO = 28;
static const int P1_H  = 14, P1_W  = 14;

// --------------------------------------------------
// MULTIPLICATEUR DE REQUANTIFICATION Q15
//
// M = (S_in x S_w / S_L1) x 2^15
//   = (3.92156886e-3 x 4.256003e-3 / 2.22108141e-2) x 32768
//   = 7.514e-4 x 32768
//   ≈ 28
//
// Ce calcul est résolu à la compilation : constante entière pure.
// Le FPGA ne voit jamais de flottant.
// --------------------------------------------------
#define M1_Q15 ((int32_t)((LENET_S_IN * LENET_C1_W_SCALE / LENET_S_L1) * (1 << 15)))

// --------------------------------------------------
// REQUANTIFICATION (partagée par toutes les sections)
//
// Matériel instancié par cette fonction :
//   - 1 multiplieur INT32 x INT32  →  DSP48 (ou LUT selon l'outil)
//   - 1 barrel shifter >>15        →  LUT (zéro DSP, zéro cycle)
//   - 1 additionneur + 2 cmp + mux →  ~30 LUT
//
// Note : le #pragma HLS INLINE force l'inlining dans la fonction appelante,
// ce qui permet au synthétiseur d'optimiser le chemin complet acc→sortie.
// --------------------------------------------------
static inline uint8_t requant_u8_q15(int32_t acc, int32_t m_q15, int32_t zy) {
#pragma HLS INLINE
    int32_t y = (acc * m_q15) >> 15;
    y += zy;
    if (y <   0) return 0;
    if (y > 255) return 255;
    return (uint8_t)y;
}


// =============================================================================
// SECTION A — VERSION DE RÉFÉRENCE : AUCUN PRAGMA
// =============================================================================
//
// Sans directive, Vitis HLS génère un circuit purement séquentiel.
// Un seul multiplieur INT16xINT16 est instancié et réutilisé à chaque cycle.
// Toutes les itérations des 5 boucles imbriquées s'exécutent l'une après l'autre.
//
// Latence Conv1 = C1_OUT x C1_H x C1_WO x C1_K x C1_K
//              = 3 x 28 x 28 x 5 x 5 = 58 800 cycles (conv seule)
//
// Résultat attendu (Zynq-7020, 100 MHz) :
//   DSP  :   1
//   BRAM :   2
//   LUT  :  ~120
//   FF   :  ~80
//   Latence totale (conv + pool) : ~87 000 cycles ≈ 870 µs @ 100 MHz
// =============================================================================

void conv1_pragma(const uint8_t x[IN_H][IN_W],
                     uint8_t y[C1_OUT][C1_H][C1_WO])
{
#pragma HLS ALLOCATION operation instances=mul limit=2
    // Pas de pragma : synthèse séquentielle pure
    for (int oc = 0; oc < C1_OUT; oc++) {
        for (int oh = 0; oh < C1_H; oh++) {
            for (int ow = 0; ow < C1_WO; ow++) {
#pragma HLS PIPELINE II=2
                int32_t acc = LENET_C1_B[oc];
#pragma HLS UNROLL factor=2
                for (int kh = 0; kh < C1_K; kh++) {
#pragma HLS UNROLL factor=2
                    for (int kw = 0; kw < C1_K; kw++) {
                        int16_t a = (int16_t)x[oh + kh][ow + kw];
                        int16_t b = (int16_t)LENET_C1_W[oc][0][kh][kw];
                        acc += (int32_t)a * (int32_t)b;
                    }
                }
                y[oc][oh][ow] = requant_u8_q15(acc, M1_Q15, LENET_Z_L1);
            }
        }
    }
}

void maxpool1_pragma(const uint8_t x[C1_OUT][C1_H][C1_WO],
                        uint8_t y[C1_OUT][P1_H][P1_W])
{
    for (int c = 0; c < C1_OUT; c++) {
        for (int oh = 0; oh < P1_H; oh++) {
            for (int ow = 0; ow < P1_W; ow++) {
#pragma HLS PIPELINE II=2
                int ih = oh << 1;
                int iw = ow << 1;
                uint8_t m1 = (x[c][ih][iw]    > x[c][ih][iw+1])
                              ? x[c][ih][iw]   : x[c][ih][iw+1];
                uint8_t m2 = (x[c][ih+1][iw]  > x[c][ih+1][iw+1])
                              ? x[c][ih+1][iw] : x[c][ih+1][iw+1];
                y[c][oh][ow] = (m1 > m2) ? m1 : m2;
            }
        }
    }
}

void top_A(const uint8_t x[IN_H][IN_W], uint8_t p1[C1_OUT][P1_H][P1_W])
{
    uint8_t y1[C1_OUT][C1_H][C1_WO];
#pragma HLS BIND_STORAGE variable=y1 type=RAM_2P impl=BRAM
    conv1_pragma(x, y1);
    maxpool1_pragma(y1, p1);
}


// =============================================================================
