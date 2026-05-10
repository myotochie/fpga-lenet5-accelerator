import numpy as np
import onnxruntime as ort
import torch
from torchvision.datasets.mnist import MNIST
import torchvision.transforms as transforms
from torch.utils.data import DataLoader


onnx_path = "lenet_int8_qdq.onnx"
num_samples = 500
num_golden_samples = 500

# 1) Dataset MNIST -> 32x32 -> Tensor float32 [0,1]
data_test = MNIST(
    "./data/mnist",
    train=False,
    download=True,
    transform=transforms.Compose([
        transforms.Resize((32, 32)),
        transforms.ToTensor(),  # float32, shape (1,32,32)
    ])
)
data_test_loader = DataLoader(data_test, batch_size=1, shuffle=False, num_workers=0)



def write_golden_header(golden_list, out_path="golden_lenet_int8.h"):
    """
    golden_list: list of dicts with keys:
      - "img": np.ndarray shape (1,32,32) float32 in [0,1]
      - "gt": int
      - "pred": int
      - "logits": list[float] length 10
      - "idx": int (optional, for info)
    """
    N = len(golden_list)
    if N == 0:
        raise RuntimeError("golden_list is empty. Nothing to write.")

    def f32(x):
        return f"{float(x):.8e}f"

    with open(out_path, "w", encoding="utf-8") as f:
        f.write("#ifndef GOLDEN_LENET_INT8_H\n#define GOLDEN_LENET_INT8_H\n\n")
        f.write("// Auto-generated golden data from ONNX Runtime\n")
        f.write("// Model: lenet_int8_qdq.onnx\n\n")
        f.write("#include <stdint.h>\n\n")
        f.write(f"#define GOLDEN_N {N}\n")
        f.write("#define GOLDEN_H 32\n")
        f.write("#define GOLDEN_W 32\n")
        f.write("#define GOLDEN_SIZE (GOLDEN_H*GOLDEN_W)\n")
        f.write("#define GOLDEN_NUM_CLASSES 10\n\n")

        # labels
        f.write("static const int32_t golden_labels[GOLDEN_N] = { ")
        f.write(", ".join(str(int(e["gt"])) for e in golden_list))
        f.write(" };\n\n")

        # preds
        f.write("static const int32_t golden_preds[GOLDEN_N] = { ")
        f.write(", ".join(str(int(e["pred"])) for e in golden_list))
        f.write(" };\n\n")

        # optional indices
        if "idx" in golden_list[0]:
            f.write("static const int32_t golden_indices[GOLDEN_N] = { ")
            f.write(", ".join(str(int(e.get("idx", -1))) for e in golden_list))
            f.write(" };\n\n")

        # images flattened
        f.write("// Images are float32 in [0,1], flattened row-major\n")
        f.write("static const float golden_images[GOLDEN_N][GOLDEN_SIZE] = {\n")
        for n, e in enumerate(golden_list):
            img = e["img"]  # (1,32,32)
            flat = img.reshape(-1)
            f.write("  {\n    ")
            for i, v in enumerate(flat):
                f.write(f32(v))
                if i != flat.size - 1:
                    f.write(", ")
                if (i + 1) % 16 == 0 and i != flat.size - 1:
                    f.write("\n    ")
            f.write("\n  }")
            f.write(",\n" if n != N - 1 else "\n")
        f.write("};\n\n")

        # logits
        f.write("// Logits are float32 (output of ONNX model)\n")
        f.write("static const float golden_logits[GOLDEN_N][GOLDEN_NUM_CLASSES] = {\n")
        for n, e in enumerate(golden_list):
            logits = e["logits"]
            if len(logits) != 10:
                raise RuntimeError("Each logits must have length 10")
            f.write("  { ")
            f.write(", ".join(f32(v) for v in logits))
            f.write(" }")
            f.write(",\n" if n != N - 1 else "\n")
        f.write("};\n\n")

        f.write("#endif\n")

    print(f"[OK] Wrote header: {out_path}")



def main():
    
    # 2) ONNX Runtime session
    sess_opts = ort.SessionOptions()
    sess = ort.InferenceSession(onnx_path, sess_options=sess_opts, providers=["CPUExecutionProvider"])

    input_name = sess.get_inputs()[0].name
    output_name = sess.get_outputs()[0].name

    print(f"Model: {onnx_path}")
    print(f"Input name: {input_name} | Output name: {output_name}")
    print("Running inference...")

    correct = 0
    shown = 0
    golden_examples = []  # store some outputs for later comparison

    for idx, (img, label) in enumerate(data_test_loader):
        if idx >= num_samples:
            break

        # img: torch tensor shape (1,1,32,32)
        x = img.numpy().astype(np.float32)

        # 3) Run
        y = sess.run([output_name], {input_name: x})[0]  # shape (1,10)

        pred = int(np.argmax(y, axis=1)[0])
        gt = int(label.numpy()[0])

        if pred == gt:
            correct += 1

        # 4) Print a few logits as "golden"
        if shown < num_golden_samples:
            logits = y[0].tolist()
            print(f"\nExample {shown+1}")
            #print(f"  idx={idx}  Target={gt}  Prediction={pred}")
            #print(f"  logits={logits}")
            print(f"\n Sample {idx}: Target={gt} Prediction={pred} {'OK' if pred == gt else 'FAIL'}")
            golden_examples.append({
                "idx": idx,
                "gt": gt,
                "pred": pred,
                "logits": logits,
                "img": x[0],  # (1,32,32) float32
            })
            shown += 1

    acc = correct / num_samples
    print("\n======================")
    print(f"Accuracy on {num_samples} samples: {acc*100:.2f}% (Correct: {correct})")
    print("======================")

    np.savez("golden_outputs_int8.npz", examples=np.array(golden_examples, dtype=object))
    print("[OK] Saved golden outputs: golden_outputs_int8.npz")

    # Génère le .h pour HLS
    write_golden_header(golden_examples, out_path="golden_lenet_int8.h")



if __name__ == "__main__":
    main()
