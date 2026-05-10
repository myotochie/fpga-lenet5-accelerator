import re

INPUT_FILE = "lenet_qparams_all.h"
OUTPUT_FILE = "lenet_qparams_mind.h"

def parse_qparams(input_file):
    qparams = []
    with open(input_file, "r") as f:
        for line in f:
            match = re.match(r'\{"(.*?)", ([\d.eE+-]+)f, (\d+)\}', line.strip())
            if match:
                tensor_name, scale, zero_point = match.groups()
                qparams.append((tensor_name, float(scale), int(zero_point)))
    return qparams

def generate_min_header(qparams, output_file):
    with open(output_file, "w") as f:
        f.write("#ifndef LENET_QPARAMS_MIN_H\n")
        f.write("#define LENET_QPARAMS_MIN_H\n\n")
        f.write("#include <stdint.h>\n\n")

        for idx, (tensor_name, scale, zero_point) in enumerate(qparams):
            if "input" in tensor_name:
                f.write(f"// Input quantization (float input in [0,1] -> int8/uint8 quant domain)\n")
                f.write(f"#define LENET_S_IN ({scale:.8e}f)\n")
                f.write(f"#define LENET_Z_IN ({zero_point})\n\n")
            elif "relu1" in tensor_name or "pool1" in tensor_name:
                f.write(f"// After Conv1/ReLU/Pool1 (same scale appears for relu1 and pool1)\n")
                f.write(f"#define LENET_S_L1 ({scale:.8e}f)\n")
                f.write(f"#define LENET_Z_L1 ({zero_point})\n\n")
            elif "relu2" in tensor_name or "pool2" in tensor_name or "flatten" in tensor_name:
                f.write(f"// After Conv2/ReLU/Pool2/Flatten (same scale appears for these tensors)\n")
                f.write(f"#define LENET_S_L2 ({scale:.8e}f)\n")
                f.write(f"#define LENET_Z_L2 ({zero_point})\n\n")
            elif "logits" in tensor_name:
                f.write(f"// (Optional) Quantized logits tensor (if you ever keep output in int8 domain)\n")
                f.write(f"#define LENET_S_OUT ({scale:.8e}f)\n")
                f.write(f"#define LENET_Z_OUT ({zero_point})\n\n")

        f.write("#endif\n")

# Parse the input file and generate the output file
qparams = parse_qparams(INPUT_FILE)
generate_min_header(qparams, OUTPUT_FILE)

print(f"[OK] Generated {OUTPUT_FILE} from {INPUT_FILE}")