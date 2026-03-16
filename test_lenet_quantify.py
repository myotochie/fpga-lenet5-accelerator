import numpy as np
import torch
from torchvision.datasets import MNIST
import torchvision.transforms as transforms
from torch.utils.data import DataLoader

from load_lenet_int8_from_h import load_lenet_params

# 🔥 Charger les paramètres depuis les .h
params = load_lenet_params("lenet_params_int8.h", "lenet_qparams_mind.h")

# -------------------------------------------------
# DATASET
# -------------------------------------------------
data_test = MNIST("./data/mnist", train=False, download=True,
                  transform=transforms.Compose([
                      transforms.Resize((32, 32)),
                      transforms.ToTensor(),
                  ]))
loader = DataLoader(data_test, batch_size=1, shuffle=False)

# -------------------------------------------------
# OUTILS QUANTIFICATION
# -------------------------------------------------
def quantize(x, scale, zp):
    return np.clip(np.round(x / scale + zp), -128, 127).astype(np.int8)

def requantize(acc, scale_acc, scale_out, zp_out):
    return np.clip(np.round(acc * (scale_acc / scale_out) + zp_out), -128, 127).astype(np.int8)

# -------------------------------------------------
# CONV
# -------------------------------------------------
def conv2d_int8(x, W, B, Sx, Sw, Zx, Zw, Sy, Zy):
    Cout, Cin, kH, kW = W.shape
    H, W_in = x.shape[1:]
    outH, outW = H - kH + 1, W_in - kW + 1
    out = np.zeros((Cout, outH, outW), dtype=np.int32)

    for co in range(Cout):
        for h in range(outH):
            for w in range(outW):
                acc = 0
                for ci in range(Cin):
                    for kh in range(kH):
                        for kw in range(kW):
                            acc += (int(x[ci,h+kh,w+kw]) - Zx) * (int(W[co,ci,kh,kw]) - Zw)
                acc += int(B[co])
                out[co,h,w] = acc

    return requantize(out, Sx*Sw, Sy, Zy)

# -------------------------------------------------
# FC
# -------------------------------------------------
def fc_int8(x, W, B, Sx, Sw, Zx, Zw, Sy, Zy):
    acc = (x.astype(np.int32) - Zx) @ (W.astype(np.int32).T - Zw)
    acc += B
    return requantize(acc, Sx*Sw, Sy, Zy)

# -------------------------------------------------
# MAXPOOL
# -------------------------------------------------
def maxpool2x2(x):
    C,H,W = x.shape
    y = np.zeros((C,H//2,W//2), dtype=x.dtype)
    for c in range(C):
        for i in range(0,H,2):
            for j in range(0,W,2):
                y[c,i//2,j//2] = np.max(x[c,i:i+2,j:j+2])
    return y

# -------------------------------------------------
# TEST LOOP
# -------------------------------------------------
correct = 0
num_samples = 500

for idx, (img, label) in enumerate(loader):
    if idx >= num_samples:
        break

    x = img.numpy()[0]
    xq = quantize(x, params["S_IN"], params["Z_IN"])

    x1 = conv2d_int8(xq, params["C1_W"], params["C1_B"],
                     params["S_IN"], params["C1_W_SCALE"],
                     params["Z_IN"], params["C1_W_ZP"],
                     params["S_L1"], params["Z_L1"])
    x1 = maxpool2x2(x1)

    x2 = conv2d_int8(x1, params["C2_W"], params["C2_B"],
                     params["S_L1"], params["C2_W_SCALE"],
                     params["Z_L1"], params["C2_W_ZP"],
                     params["S_L2"], params["Z_L2"])
    x2 = maxpool2x2(x2)

    x2f = x2.reshape(-1)

    out = fc_int8(x2f, params["FC_W"], params["FC_B"],
                  params["S_L2"], params["FC_W_SCALE"],
                  params["Z_L2"], params["FC_W_ZP"],
                  params["S_OUT"], params["Z_OUT"])

    pred = int(np.argmax(out))
    gt = int(label.numpy()[0])

    if pred == gt:
        correct += 1

acc = correct / num_samples
print(f"\n🔥 INT8 Hardware-Equivalent Accuracy: {acc*100:.2f}%")
