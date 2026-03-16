#ifndef LENET_QPARAMS_MIN_H
#define LENET_QPARAMS_MIN_H

#include <stdint.h>

// Input quantization (float input in [0,1] -> int8/uint8 quant domain)
#define LENET_S_IN (3.92156886e-03f)
#define LENET_Z_IN (0)

// After Conv1/ReLU/Pool1 (same scale appears for relu1 and pool1)
#define LENET_S_L1 (2.22108141e-02f)
#define LENET_Z_L1 (0)

// After Conv2/ReLU/Pool2/Flatten (same scale appears for these tensors)
#define LENET_S_L2 (5.31273969e-02f)
#define LENET_Z_L2 (0)

// After Conv2/ReLU/Pool2/Flatten (same scale appears for these tensors)
#define LENET_S_L2 (5.31273969e-02f)
#define LENET_Z_L2 (0)

// (Optional) Quantized logits tensor (if you ever keep output in int8 domain)
#define LENET_S_OUT (2.15736702e-01f)
#define LENET_Z_OUT (150)

#endif
