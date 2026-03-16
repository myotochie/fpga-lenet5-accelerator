from Lenet import LeNet5
import torch
import torch.nn as nn
import torch.optim as optim

from torchvision.datasets.mnist import MNIST
import torchvision.transforms as transforms
from torch.utils.data import DataLoader

import onnx
import numpy as np
import matplotlib.pyplot as plt
import os

from onnxruntime.quantization import (
    quantize_static,
    CalibrationDataReader,
    QuantFormat,
    QuantType,
)

os.environ["KMP_DUPLICATE_LIB_OK"] = "TRUE"

# -------------------------
# 1) CHARGEMENT DU DATASET
# -------------------------
data_train = MNIST('./data/mnist',
                   train=True,
                   download=True,
                   transform=transforms.Compose([
                       transforms.Resize((32, 32)),
                       transforms.ToTensor()]))

data_test = MNIST('./data/mnist',
                  train=False,
                  download=True,
                  transform=transforms.Compose([
                      transforms.Resize((32, 32)),
                      transforms.ToTensor()]))

data_train_loader = DataLoader(data_train, batch_size=256, shuffle=True, num_workers=8)
data_test_loader  = DataLoader(data_test,  batch_size=1024, num_workers=8)

# -------------------------
# 2) CRÉATION DU MODÈLE
# -------------------------
net = LeNet5()
onnx_name = "lenet.onnx"

# -------------------------
# 3) LOSS + OPTIMISEUR
# -------------------------
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(net.parameters(), lr=2e-3)

# -------------------------
# 4) HISTORIQUE (pour les courbes)
# -------------------------
history = {
    "train_loss": [],
    "val_loss":   [],
    "train_acc":  [],
    "val_acc":    [],
}

# -------------------------
# 5) FONCTION D'ENTRAÎNEMENT
# -------------------------
def train(epoch):
    net.train()

    total_loss    = 0.0
    total_correct = 0
    total_samples = 0

    for i, (images, labels) in enumerate(data_train_loader):
        optimizer.zero_grad()
        output = net(images)
        loss   = criterion(output, labels)

        loss.backward()
        optimizer.step()

        total_loss    += loss.item() * images.size(0)
        pred           = output.detach().max(1)[1]
        total_correct += pred.eq(labels).sum().item()
        total_samples += images.size(0)

        if i % 10 == 0:
            print('Train - Epoch %d, Batch: %d, Loss: %f' % (
                epoch, i, loss.detach().cpu().item()))

    avg_loss = total_loss / total_samples
    accuracy = total_correct / total_samples

    history["train_loss"].append(avg_loss)
    history["train_acc"].append(accuracy * 100.0)

    print(f"[Époque {epoch}] Train Loss: {avg_loss:.4f} | Train Acc: {accuracy*100:.2f}%")


# -------------------------
# 6) FONCTION DE TEST
# -------------------------
def test(epoch=None):
    net.eval()

    total_loss    = 0.0
    total_correct = 0
    total_samples = 0

    with torch.no_grad():
        for images, labels in data_test_loader:
            output = net(images)
            loss   = criterion(output, labels)

            total_loss    += loss.item() * images.size(0)
            pred           = output.max(1)[1]
            total_correct += pred.eq(labels).sum().item()
            total_samples += images.size(0)

    avg_loss = total_loss / total_samples
    accuracy = total_correct / total_samples

    history["val_loss"].append(avg_loss)
    history["val_acc"].append(accuracy * 100.0)

    print('Test Avg. Loss: %f, Accuracy: %f' % (avg_loss, accuracy))


# -------------------------
# 7) TRACÉ DES COURBES
# -------------------------
def plot_curves(n_epochs):
    epochs = range(1, n_epochs + 1)

    # Courbe de coût
    fig, ax = plt.subplots(figsize=(6, 4))
    ax.plot(epochs, history["train_loss"], label="Entraînement",
            color="steelblue", linewidth=2)
    ax.plot(epochs, history["val_loss"],   label="Validation",
            color="darkorange", linewidth=2, linestyle="--")
    ax.set_xlabel("Époque")
    ax.set_ylabel("Coût (Loss)")
    ax.set_title("Évolution du coût")
    ax.legend()
    ax.grid(True, linestyle="--", alpha=0.5)
    plt.tight_layout()
    plt.savefig("courbe_cout.png", dpi=150)
    plt.close()
    print("[OK] courbe_cout.png sauvegardée.")

    # Courbe de précision
    fig, ax = plt.subplots(figsize=(6, 4))
    ax.plot(epochs, history["train_acc"], label="Entraînement",
            color="steelblue", linewidth=2)
    ax.plot(epochs, history["val_acc"],   label="Validation",
            color="darkorange", linewidth=2, linestyle="--")
    ax.set_xlabel("Époque")
    ax.set_ylabel("Précision (%)")
    ax.set_title("Évolution de la précision")
    ax.legend()
    ax.grid(True, linestyle="--", alpha=0.5)
    plt.tight_layout()
    plt.savefig("courbe_precision.png", dpi=150)
    plt.close()
    print("[OK] courbe_precision.png sauvegardée.")

    # Métriques finales (Table 3.2)
    print("\n========== Performances finales ==========")
    print(f"  Précision entraînement : {history['train_acc'][-1]:.2f} %")
    print(f"  Précision validation   : {history['val_acc'][-1]:.2f} %")
    print(f"  Coût entraînement      : {history['train_loss'][-1]:.4f}")
    print(f"  Coût validation        : {history['val_loss'][-1]:.4f}")
    print("==========================================\n")


def print_weights_and_biases(epoch):
    print(f"\n===== Weights & Biases after Epoch {epoch} =====")
    for name, param in net.named_parameters():
        if param.requires_grad:
            print(f"\nLayer: {name}")
            print(f"  Shape: {tuple(param.shape)}")
            print(f"  Values:\n{param.detach().cpu().numpy()}")


# -------------------------
# 8) EXPORT ONNX
# -------------------------
def export_onnx_clean(pt_model, onnx_path="lenet_fp32.onnx", opset=15):
    pt_model.eval()
    dummy_input = torch.randn(1, 1, 32, 32, dtype=torch.float32, requires_grad=True)
    torch.onnx.export(
        pt_model, dummy_input, onnx_path,
        export_params=True, opset_version=opset,
        do_constant_folding=True,
        input_names=["input"], output_names=["logits"],
        dynamic_axes={"input": {0: "batch"}, "logits": {0: "batch"}},
        dynamo=False,
    )
    m = onnx.load(onnx_path)
    onnx.checker.check_model(m)
    print(f"[OK] Export ONNX valide : {onnx_path}")


# -------------------------
# 9) DataReader calibration
# -------------------------
class MnistCalibrationDataReader(CalibrationDataReader):
    def __init__(self, dataloader, input_name="input", num_batches=10):
        self.dataloader  = dataloader
        self.input_name  = input_name
        self.num_batches = num_batches
        self.enum_data   = None

    def get_next(self):
        if self.enum_data is None:
            def _iter():
                count = 0
                for images, _ in self.dataloader:
                    yield {self.input_name: images.numpy().astype(np.float32)}
                    count += 1
                    if count >= self.num_batches:
                        break
            self.enum_data = iter(_iter())
        return next(self.enum_data, None)


# -------------------------
# 10) Quantification INT8
# -------------------------
def quantize_onnx_static_int8(
    fp32_onnx_path="lenet_fp32.onnx",
    int8_onnx_path="lenet_int8_qdq.onnx",
    quant_format=QuantFormat.QDQ,
    num_calib_batches=20,
    batch_size=32,
):
    calib_ds = MNIST("./data/mnist", train=True, download=True,
                     transform=transforms.Compose([
                         transforms.Resize((32, 32)),
                         transforms.ToTensor(),
                     ]))
    calib_loader = DataLoader(calib_ds, batch_size=batch_size,
                              shuffle=True, num_workers=2)
    dr = MnistCalibrationDataReader(calib_loader, input_name="input",
                                    num_batches=num_calib_batches)
    quantize_static(
        model_input=fp32_onnx_path,
        model_output=int8_onnx_path,
        calibration_data_reader=dr,
        quant_format=quant_format,
        activation_type=QuantType.QUInt8,
        weight_type=QuantType.QInt8,
        per_channel=False,
        reduce_range=False,
        extra_options={"ActivationSymmetric": False, "WeightSymmetric": True},
    )
    m = onnx.load(int8_onnx_path)
    onnx.checker.check_model(m)
    print(f"[OK] Modèle INT8 valide : {int8_onnx_path}")


# -------------------------
# 11) MAIN
# -------------------------
def main():
    N_EPOCHS = 6   # ton nombre d'époques original

    for e in range(1, N_EPOCHS + 1):
        train(e)
        test(e)

    # Sauvegarde des courbes après toutes les époques
    plot_curves(N_EPOCHS)

    net.eval()
    export_onnx_clean(net, "lenet_fp32.onnx", opset=15)
    quantize_onnx_static_int8(
        fp32_onnx_path="lenet_fp32.onnx",
        int8_onnx_path="lenet_int8_qdq.onnx",
        quant_format=QuantFormat.QDQ,
        num_calib_batches=30,
        batch_size=32,
    )


if __name__ == '__main__':
    main()