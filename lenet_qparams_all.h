#ifndef LENET_QPARAMS_ALL_H
#define LENET_QPARAMS_ALL_H

#include <stdint.h>

typedef struct {
  const char* tensor_name;
  float scale;
  int32_t zero_point;
} lenet_qparam_t;

#define LENET_NUM_QPARAMS 7

static const lenet_qparam_t LENET_QPARAMS[LENET_NUM_QPARAMS] = {
  {"input_QuantizeLinear_Output", 3.92156886e-03f, 0},
  {"/c1/c1/relu1/Relu_output_0_QuantizeLinear_Output", 2.22108141e-02f, 0},
  {"/s1/s1/MaxPool_output_0_QuantizeLinear_Output", 2.22108141e-02f, 0},
  {"/c2/c2/relu2/Relu_output_0_QuantizeLinear_Output", 5.31273969e-02f, 0},
  {"/s2/s2/MaxPool_output_0_QuantizeLinear_Output", 5.31273969e-02f, 0},
  {"/f4/f4/flatten/Flatten_output_0_QuantizeLinear_Output", 5.31273969e-02f, 0},
  {"logits_QuantizeLinear_Output", 2.15736702e-01f, 150},
};

#endif
