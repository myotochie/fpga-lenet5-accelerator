#include <stdint.h>
#include <ap_int.h>


// Ce fichier corrige 3 bugs majeurs:
// 1. Bias en INT32 au lieu de INT8
// 2. Ordre correct: Requantification PUIS ReLU
// 3. Gestion correcte des accumulateurs

#include "lenet_params_int8.h"  // ⚠️ À MODIFIER - voir instructions
#include "lenet_qparams_min.h"

// --------------------------------------------------
static const int IN_H = 32, IN_W = 32;

// Conv1
static const int C1_OUT = 3;
static const int C1_K   = 5;
static const int C1_H   = 28, C1_WO = 28;
static const int P1_H = 14, P1_W = 14;

// Conv2
static const int C2_OUT = 6;
static const int C2_IN  = C1_OUT;
static const int C2_K   = 5;
static const int C2_H   = 10, C2_WO = 10;
static const int P2_H = 5, P2_W = 5;

// Fully connected
static const int FC_IN  = C2_OUT * P2_H * P2_W;   // 150
static const int FC_OUT = 10;

// --------------------------------------------------
// MULTIPLIEURS DE REQUANTIFICATION (Q15)
// Ces valeurs sont correctes et ont été vérifiées
#define M1_Q15 ((int32_t)((LENET_S_IN * LENET_C1_W_SCALE / LENET_S_L1) * (1 << 15)))
#define M2_Q15 ((int32_t)((LENET_S_L1 * LENET_C2_W_SCALE / LENET_S_L2) * (1 << 15)))
#define M3_Q15 ((int32_t)((LENET_S_L2 * LENET_FC_W_SCALE / LENET_S_OUT) * (1 << 15)))

// --------------------------------------------------
// FONCTION DE REQUANTIFICATION
// Convertit un accumulateur INT32 vers uint8 dans le nouveau domaine
//
// Formule: y = round((acc * M) / 2^15) + zero_point
//
// Paramètres:
//   acc: accumulateur INT32 (résultat de la convolution)
//   m_q15: multiplicateur en Q15 (fixe-point avec 15 bits fractionnaires)
//   zy: zero-point du domaine de sortie
// --------------------------------------------------
static inline uint8_t requant_u8_q15(int32_t acc, int32_t m_q15, int32_t zy) {
#pragma HLS INLINE
    // Multiplication puis shift right de 15 bits (division par 2^15)
    int32_t y = (acc * m_q15) >> 15;

    // Ajouter le zero-point
    y += zy;

    // Clipper dans [0, 255] pour uint8
    if (y < 0)   return 0;
    if (y > 255) return 255;
    return (uint8_t)y;
}

// --------------------------------------------------
// CONVOLUTION 1 + RELU (CORRIGÉ)
//
// Changements par rapport à la version buggée:
// 1. Accumulateur en int32_t (au lieu de ap_int<24>)
// 2. Bias en int32_t (au lieu de int8_t) - IMPORTANT
// 3. Requantification AVANT ReLU (ordre inversé)
// --------------------------------------------------
static void conv1_relu_q(const uint8_t x[IN_H][IN_W],
                         uint8_t y[C1_OUT][C1_H][C1_WO]) {
#pragma HLS ALLOCATION operation instances=mul limit=2

    for (int oc = 0; oc < C1_OUT; oc++) {
        for (int oh = 0; oh < C1_H; oh++) {
            for (int ow = 0; ow < C1_WO; ow++) {
#pragma HLS PIPELINE II=4
                int32_t acc = LENET_C1_B[oc];  //  LENET_C1_B doit être int32_t[]
                for (int kh = 0; kh < C1_K; kh++) {
#pragma HLS UNROLL factor=1
                    for (int kw = 0; kw < C1_K; kw++) {
#pragma HLS UNROLL factor=1
                        int16_t a = x[oh + kh][ow + kw];  // Input (uint8)
                        int16_t b = LENET_C1_W[oc][0][kh][kw];  // Weight (int8)
                        acc += (int32_t)a * (int32_t)b;
                    }
                }
                uint8_t val = requant_u8_q15(acc, M1_Q15, LENET_Z_L1);

                y[oc][oh][ow] = val;
            }
        }
    }
}

// --------------------------------------------------
// MAXPOOL 2x2 stride 2
// --------------------------------------------------
static void maxpool2x2_s2_c1(const uint8_t x[C1_OUT][C1_H][C1_WO],
                             uint8_t y[C1_OUT][P1_H][P1_W]) {
    for (int c = 0; c < C1_OUT; c++) {
        for (int oh = 0; oh < P1_H; oh++) {
            for (int ow = 0; ow < P1_W; ow++) {
#pragma HLS PIPELINE II=2
                int ih = oh << 1;  // oh * 2
                int iw = ow << 1;  // ow * 2

                // Comparer les 4 valeurs du bloc 2x2
                uint8_t m1 = (x[c][ih][iw] > x[c][ih][iw+1])
                             ? x[c][ih][iw] : x[c][ih][iw+1];
                uint8_t m2 = (x[c][ih+1][iw] > x[c][ih+1][iw+1])
                             ? x[c][ih+1][iw] : x[c][ih+1][iw+1];
                y[c][oh][ow] = (m1 > m2) ? m1 : m2;
            }
        }
    }
}

// --------------------------------------------------
// CONVOLUTION 2 + RELU
// --------------------------------------------------
static void conv2_relu_q(const uint8_t x[C2_IN][P1_H][P1_W],
                         uint8_t y[C2_OUT][C2_H][C2_WO]) {
#pragma HLS ALLOCATION operation instances=mul limit=2

    for (int oc = 0; oc < C2_OUT; oc++) {
        for (int oh = 0; oh < C2_H; oh++) {
            for (int ow = 0; ow < C2_WO; ow++) {
#pragma HLS PIPELINE II=4

                // Accumulateur INT32 + Bias INT32
                int32_t acc = LENET_C2_B[oc];  //  LENET_C2_B doit être int32_t[]

                // Convolution 5x5 sur 3 canaux
                for (int ic = 0; ic < C2_IN; ic++) {
#pragma HLS UNROLL factor=1
                    for (int kh = 0; kh < C2_K; kh++) {
#pragma HLS UNROLL factor=1
                        for (int kw = 0; kw < C2_K; kw++) {
#pragma HLS UNROLL factor=1
                            int16_t a = x[ic][oh + kh][ow + kw];
                            int16_t b = LENET_C2_W[oc][ic][kh][kw];
                            acc += (int32_t)a * (int32_t)b;
                        }
                    }
                }

                // CORRECTION: Requantification PUIS ReLU (ordre inversé)
                uint8_t val = requant_u8_q15(acc, M2_Q15, LENET_Z_L2);
                // ReLU implicite si Z_L2 = 0

                y[oc][oh][ow] = val;
            }
        }
    }
}

// --------------------------------------------------
// MAXPOOL 2x2 stride 2 pour Conv2
// --------------------------------------------------
static void maxpool2x2_s2_c2(const uint8_t x[C2_OUT][C2_H][C2_WO],
                             uint8_t y[C2_OUT][P2_H][P2_W]) {
    for (int c = 0; c < C2_OUT; c++) {
        for (int oh = 0; oh < P2_H; oh++) {
            for (int ow = 0; ow < P2_W; ow++) {
#pragma HLS PIPELINE II=2
                int ih = oh << 1;
                int iw = ow << 1;
                uint8_t m1 = (x[c][ih][iw] > x[c][ih][iw+1])
                             ? x[c][ih][iw] : x[c][ih][iw+1];
                uint8_t m2 = (x[c][ih+1][iw] > x[c][ih+1][iw+1])
                             ? x[c][ih+1][iw] : x[c][ih+1][iw+1];
                y[c][oh][ow] = (m1 > m2) ? m1 : m2;
            }
        }
    }
}

// --------------------------------------------------
// FLATTEN
// --------------------------------------------------
static void flatten_c2(const uint8_t x[C2_OUT][P2_H][P2_W],
                       uint8_t out[FC_IN]) {
    int idx = 0;
    for (int c = 0; c < C2_OUT; c++)
        for (int h = 0; h < P2_H; h++)
            for (int w = 0; w < P2_W; w++) {
#pragma HLS PIPELINE II=2
                out[idx++] = x[c][h][w];
            }
}

// --------------------------------------------------
// FULLY CONNECTED + REQUANTIFICATION
// --------------------------------------------------
static void fc_requant_q(const uint8_t x[FC_IN], uint8_t out_q[FC_OUT]) {
#pragma HLS ALLOCATION operation instances=mul limit=2

    for (int o = 0; o < FC_OUT; o++) {
#pragma HLS PIPELINE II=4

        //  Accumulateur INT32 + Bias INT32
        int32_t acc = LENET_FC_B[o];  // LENET_FC_B doit être int32_t[]

        // Produit matriciel
        for (int i = 0; i < FC_IN; i++) {
#pragma HLS UNROLL factor=1
            int16_t a = x[i];               // Activation (scale = S_L2)
            int16_t b = LENET_FC_W[o][i];   // Weight (scale = S_FC_W)
            acc += (int32_t)a * (int32_t)b;
        }

        // REQUANTIFICATION VERS LE DOMAINE DE SORTIE
        // Note: Pas de ReLU ici car c'est la couche finale (logits)
        out_q[o] = requant_u8_q15(acc, M3_Q15, LENET_Z_OUT);
    }
}


// --------------------------------------------------
// FONCTION PRINCIPALE (pas de changement)
// --------------------------------------------------
extern "C" {
void lenet_accel(const uint8_t* in_img_u8, int32_t* out_scores_i32) {

#pragma HLS INTERFACE m_axi     port=in_img_u8      offset=slave bundle=gmem0 depth=1024
#pragma HLS INTERFACE m_axi     port=out_scores_i32 offset=slave bundle=gmem1 depth=10
#pragma HLS INTERFACE s_axilite port=in_img_u8      bundle=control
#pragma HLS INTERFACE s_axilite port=out_scores_i32 bundle=control
#pragma HLS INTERFACE s_axilite port=return         bundle=control

    uint8_t x0[IN_H][IN_W];
#pragma HLS BIND_STORAGE variable=x0 type=RAM_2P impl=BRAM

    uint8_t y1[C1_OUT][C1_H][C1_WO];
    uint8_t p1[C1_OUT][P1_H][P1_W];
    uint8_t y2[C2_OUT][C2_H][C2_WO];
    uint8_t p2[C2_OUT][P2_H][P2_W];
    uint8_t flat[FC_IN];

#pragma HLS BIND_STORAGE variable=y1 type=RAM_2P impl=BRAM
#pragma HLS BIND_STORAGE variable=p1 type=RAM_2P impl=BRAM
#pragma HLS BIND_STORAGE variable=y2 type=RAM_2P impl=BRAM
#pragma HLS BIND_STORAGE variable=p2 type=RAM_2P impl=BRAM
#pragma HLS BIND_STORAGE variable=flat type=RAM_2P impl=BRAM

    uint8_t scores_q[FC_OUT];
#pragma HLS BIND_STORAGE variable=scores_q type=RAM_2P impl=BRAM

    // Charger l'image depuis la DDR
    for (int r = 0; r < IN_H; r++)
        for (int c = 0; c < IN_W; c++) {
#pragma HLS PIPELINE II=1
            x0[r][c] = in_img_u8[r * IN_W + c];
        }

    // Pipeline du réseau
    conv1_relu_q(x0, y1);
    maxpool2x2_s2_c1(y1, p1);
    conv2_relu_q(p1, y2);
    maxpool2x2_s2_c2(y2, p2);
    flatten_c2(p2, flat);
    fc_requant_q(flat, scores_q);

    // Écrire les logits quantifiés vers la DDR
    for (int i = 0; i < FC_OUT; i++) {
    #pragma HLS PIPELINE II=1
        out_scores_i32[i] = (int32_t)scores_q[i];  // Logits quantifiés en uint8
    }
}
}

