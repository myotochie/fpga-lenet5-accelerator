# generate_input_image.py
import numpy as np
from PIL import Image


def generate_input_image_32x32():
    """
    Génère une image 32x32 et exporte en format COE pour Vivado BRAM
    """

    # Charger image MNIST
    mnist_img = Image.open('mnist_digit.png').convert('L')
    mnist_img = mnist_img.resize((32, 32))

    image = np.array(mnist_img, dtype=np.int8)
    image = image.reshape(32, 32, 1)

    # ==============================
    # Export COE
    # ==============================
    with open('input_image_32x32.coe', 'w') as f:

        f.write("memory_initialization_radix=10;\n")
        f.write("memory_initialization_vector=\n")

        values = []

        for y in range(32):
            for x in range(32):
                for c in range(1):
                    values.append(str(int(image[y, x, c])))

        # écrire toutes les valeurs
        f.write(",\n".join(values))
        f.write(";")

    print(f"✓ Image générée : {image.shape}")
    print(f"Min: {image.min()}, Max: {image.max()}")
    print("✓ Fichier COE créé : input_image_32x32.coe")

    return image


if __name__ == "__main__":
    print("Génération image FPGA...")
    generate_input_image_32x32()