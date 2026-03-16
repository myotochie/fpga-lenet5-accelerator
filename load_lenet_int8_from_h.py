import numpy as np
import re


def extract_block(text, varname):
    """
    Extracts the full { ... } block of a C array
    """
    pattern = rf"{varname}.*?=\s*\{{(.*?)\}};"
    match = re.search(pattern, text, re.S)
    if not match:
        raise ValueError(f"Array {varname} not found in header.")
    return match.group(1)


def parse_c_array(text, varname, dtype, shape):
    block = extract_block(text, varname)
    nums = list(map(int, re.findall(r"-?\d+", block)))
    arr = np.array(nums, dtype=dtype)

    expected = np.prod(shape)
    if arr.size != expected:
        raise ValueError(f"{varname} size mismatch. Got {arr.size}, expected {expected}")

    return arr.reshape(shape)


def parse_float(text, varname):
    m = re.search(rf"{varname}\s*=\s*([0-9eE\.\-]+)f?", text)
    return float(m.group(1)) if m else None


def parse_int(text, varname):
    m = re.search(rf"{varname}\s*=\s*(\d+)", text)
    return int(m.group(1)) if m else None


def load_lenet_params(weights_path, qparams_path):
    with open(weights_path, "r") as f:
        wtxt = f.read()

    with open(qparams_path, "r") as f:
        qtxt = f.read()

    p = {}

    # ------------------ C1 ------------------
    p["C1_W"] = parse_c_array(wtxt, "LENET_C1_W", np.int8, (3, 1, 5, 5))
    p["C1_B"] = parse_c_array(wtxt, "LENET_C1_B", np.int32, (3,))
    p["C1_W_SCALE"] = parse_float(wtxt, "LENET_C1_W_SCALE")
    p["C1_W_ZP"] = parse_int(wtxt, "LENET_C1_W_ZP")

    # ------------------ C2 ------------------
    p["C2_W"] = parse_c_array(wtxt, "LENET_C2_W", np.int8, (6, 3, 5, 5))
    p["C2_B"] = parse_c_array(wtxt, "LENET_C2_B", np.int32, (6,))
    p["C2_W_SCALE"] = parse_float(wtxt, "LENET_C2_W_SCALE")
    p["C2_W_ZP"] = parse_int(wtxt, "LENET_C2_W_ZP")

    # ------------------ FC ------------------
    p["FC_W"] = parse_c_array(wtxt, "LENET_FC_W", np.int8, (10, 150))
    p["FC_B"] = parse_c_array(wtxt, "LENET_FC_B", np.int32, (10,))
    p["FC_W_SCALE"] = parse_float(wtxt, "LENET_FC_W_SCALE")
    p["FC_W_ZP"] = parse_int(wtxt, "LENET_FC_W_ZP")

    # ------------------ Quant params ------------------
    p["S_IN"] = parse_float(qtxt, "LENET_S_IN")
    p["Z_IN"] = parse_int(qtxt, "LENET_Z_IN")

    p["S_L1"] = parse_float(qtxt, "LENET_S_L1")
    p["Z_L1"] = parse_int(qtxt, "LENET_Z_L1")

    p["S_L2"] = parse_float(qtxt, "LENET_S_L2")
    p["Z_L2"] = parse_int(qtxt, "LENET_Z_L2")

    p["S_OUT"] = parse_float(qtxt, "LENET_S_OUT")
    p["Z_OUT"] = parse_int(qtxt, "LENET_Z_OUT")

    # Debug: Print extracted parameters
    print("Extracted parameters:")
    for key, value in p.items():
        print(f"{key}: {value}")

    return p


def validate_params(params):
    required_keys = [
        "S_IN", "Z_IN", "S_L1", "Z_L1", "S_L2", "Z_L2", "S_OUT", "Z_OUT",
        "C1_W", "C1_B", "C1_W_SCALE", "C1_W_ZP",
        "C2_W", "C2_B", "C2_W_SCALE", "C2_W_ZP",
        "FC_W", "FC_B", "FC_W_SCALE", "FC_W_ZP"
    ]

    for key in required_keys:
        if key not in params or params[key] is None:
            raise ValueError(f"Missing or invalid parameter: {key}")
