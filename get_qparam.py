import onnx
import numpy as np
from onnx import numpy_helper

ONNX_MODEL = "lenet_int8_qdq.onnx"
OUTPUT_H_FILE = "lenet_qparams_min.h"

# -------------------------------
# LOAD MODEL
# -------------------------------
model = onnx.load(ONNX_MODEL)

def get_initializer_array(name):
    """Récupère un numpy array depuis l'initializer ONNX"""
    for init in model.graph.initializer:
        if init.name == name:
            return numpy_helper.to_array(init)
    return None

# -------------------------------
# EXTRACTION DES PARAMS QDQ
# -------------------------------
scales = {}
zero_points = {}

for node in model.graph.node:
    if node.op_type in ["QuantizeLinear", "DequantizeLinear"]:
        out_name = node.output[0]
        scale_name = node.input[1]
        zp_name = node.input[2] if len(node.input) > 2 else None

        scale_val = get_initializer_array(scale_name)
        zp_val = get_initializer_array(zp_name) if zp_name else np.array(0, dtype=np.int32)

        # gérer scalaires et tableaux
        if np.ndim(scale_val) == 0:
            scales[out_name] = float(scale_val)
        else:
            scales[out_name] = float(scale_val[0])

        if np.ndim(zp_val) == 0:
            zero_points[out_name] = int(zp_val)
        else:
            zero_points[out_name] = int(zp_val[0])

# -------------------------------
# RENOMMAGE DES TENSORS POUR HEADER
# -------------------------------
# Liste des tensors QDQ en ordre approximatif : entrée, couche1, couche2, sortie
# Ajuster selon ton modèle exact si nécessaire
tensor_order = list(scales.keys())
names = ["input", "c1", "c2", "logits"]

if len(tensor_order) != len(names):
    # S'il y a plus de tensors (ex: chaque DequantizeLinear), on prend les 4 principaux
    tensor_order = tensor_order[:4]

# -------------------------------
# ÉCRITURE DU HEADER
# -------------------------------
with open(OUTPUT_H_FILE, "w") as f:
    f.write("#ifndef LENET_QPARAMS_MIN_H\n")
    f.write("#define LENET_QPARAMS_MIN_H\n\n")
    f.write("#include <stdint.h>\n\n")

    for tensor_name, cname in zip(tensor_order, names):
        s_val = scales[tensor_name]
        z_val = zero_points[tensor_name]
        f.write(f"#define LENET_S_{cname.upper():<5} ({s_val:.8e}f)\n")
        f.write(f"#define LENET_Z_{cname.upper():<5} ({z_val})\n\n")

    f.write("#endif\n")

print(f"[OK] Header généré : {OUTPUT_H_FILE}")
