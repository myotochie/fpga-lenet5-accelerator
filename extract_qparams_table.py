import onnx
import numpy as np
from onnx import numpy_helper

MODEL_PATH = "lenet_int8_qdq.onnx"
OUT_QPARAMS_H = "lenet_qparams_all.h"

def tensor_map(model):
    return {init.name: numpy_helper.to_array(init) for init in model.graph.initializer}

def main():
    model = onnx.load(MODEL_PATH)
    init = tensor_map(model)

    q_nodes = [n for n in model.graph.node if n.op_type == "QuantizeLinear"]
    print(f"Found {len(q_nodes)} QuantizeLinear nodes\n")

    entries = []
    for n in q_nodes:
        out_name = n.output[0]
        scale_name = n.input[1]
        zp_name = n.input[2] if len(n.input) >= 3 else None

        if scale_name not in init:
            continue

        scale = float(np.array(init[scale_name]).reshape(-1)[0])
        zp = 0
        if zp_name and zp_name in init:
            zp = int(np.array(init[zp_name]).reshape(-1)[0])

        entries.append((out_name, scale, zp))

    # Print nicely
    for i, (t, s, z) in enumerate(entries):
        print(f"[{i:02d}] tensor='{t}'  scale={s:.8e}  zp={z}")

    # Write header with all entries
    with open(OUT_QPARAMS_H, "w", encoding="utf-8") as f:
        f.write("#ifndef LENET_QPARAMS_ALL_H\n#define LENET_QPARAMS_ALL_H\n\n")
        f.write("#include <stdint.h>\n\n")
        f.write("typedef struct {\n")
        f.write("  const char* tensor_name;\n")
        f.write("  float scale;\n")
        f.write("  int32_t zero_point;\n")
        f.write("} lenet_qparam_t;\n\n")

        f.write(f"#define LENET_NUM_QPARAMS {len(entries)}\n\n")
        f.write("static const lenet_qparam_t LENET_QPARAMS[LENET_NUM_QPARAMS] = {\n")
        for (t, s, z) in entries:
            f.write(f'  {{"{t}", {s:.8e}f, {z}}},\n')
        f.write("};\n\n")
        f.write("#endif\n")

    print(f"\n[OK] Wrote {OUT_QPARAMS_H}")

if __name__ == "__main__":
    main()
