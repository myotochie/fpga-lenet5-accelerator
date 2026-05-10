# extract_lenet_qdq_to_h.py
import onnx
import numpy as np
from onnx import numpy_helper

MODEL_INT8 = "lenet_int8_qdq.onnx"
MODEL_FP32 = "lenet_fp32.onnx"
OUT_PARAMS_H = "lenet_params_int8.h"

def tensor_map(model):
    return {init.name: numpy_helper.to_array(init) for init in model.graph.initializer}

def node_maps(model):
    out2node = {}
    for n in model.graph.node:
        for o in n.output:
            out2node[o] = n
    return out2node

def resolve_qdq_tensor(name, init, out2node):
    prod = out2node.get(name, None)
    if prod and prod.op_type == "DequantizeLinear":
        q = init[prod.input[0]]
        scale = init[prod.input[1]]
        zp = init.get(prod.input[2], np.array([0], dtype=np.int8))
        return q, float(scale), int(zp)
    return None, None, None

def get_input_activation_qparams(node, init, out2node):
    x_name = node.input[0]
    prod = out2node.get(x_name, None)
    if prod.op_type != "DequantizeLinear":
        raise RuntimeError("Input activation not quantized")
    Sx = float(init[prod.input[1]])
    Zx = int(init.get(prod.input[2], np.array([0])))
    return Sx, Zx

def write_array(f, ctype, name, arr):
    shape = "".join([f"[{d}]" for d in arr.shape])
    f.write(f"static const {ctype} {name}{shape} = {{\n")
    flat = arr.flatten()
    for i,v in enumerate(flat):
        f.write(f"{int(v)}, ")
        if (i+1)%16==0: f.write("\n")
    f.write("\n};\n\n")

model_i8 = onnx.load(MODEL_INT8)
model_fp = onnx.load(MODEL_FP32)
init_i8 = tensor_map(model_i8)
init_fp = tensor_map(model_fp)
out2node = node_maps(model_i8)

conv_nodes = [n for n in model_i8.graph.node if n.op_type=="Conv"]
gemm_nodes = [n for n in model_i8.graph.node if n.op_type=="Gemm"]

layer_names = ["C1", "C2", "FC"]

with open(OUT_PARAMS_H,"w") as f:
    f.write("#include <stdint.h>\n\n")

    for idx, node in enumerate(conv_nodes + gemm_nodes):
        layer_name = layer_names[idx] if idx < len(layer_names) else f"L{idx}"

        Wq, Sw, Zw = resolve_qdq_tensor(node.input[1], init_i8, out2node)
        Sx, Zx = get_input_activation_qparams(node, init_i8, out2node)

        b = init_fp.get(node.input[2])
        b_int32 = np.round(b / (Sx * Sw)).astype(np.int32)

        write_array(f, "int8_t", f"LENET_{layer_name}_W", Wq)
        write_array(f, "int32_t", f"LENET_{layer_name}_B", b_int32)

        f.write(f"static const float LENET_{layer_name}_W_SCALE = {Sw}f;\n")
        f.write(f"static const int LENET_{layer_name}_W_ZP = {Zw};\n\n")

print("[OK] Updated variable names to match the specified format.")
