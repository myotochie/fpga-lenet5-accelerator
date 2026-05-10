# generate_input_image.py
import numpy as np

def generate_input_image_32x32():
    """
    Génère une image 32x32 pour tester Conv1
    """
    image = np.zeros((32, 32, 1), dtype=np.int8)
    
    
    # Option 2: Image MNIST redimensionnée (si disponible)
    from PIL import Image
    mnist_img = Image.open('mnist_digit.png').convert('L')
    mnist_img = mnist_img.resize((32, 32))
    image = np.array(mnist_img, dtype=np.int8)  
    image = image.reshape(32, 32, 1)
    
    # Sauvegarder au format texte (un entier par ligne)
    with open('input_image_32x32.txt', 'w') as f:
        for y in range(32):
            for x in range(32):
                for c in range(1):
                    f.write(f"{int(image[y, x, c])}\n")
    
    print(f"✓ Image d'entrée générée: {image.shape}")
    print(f"  Min: {image.min()}, Max: {image.max()}")
    print(f"  Fichier: input_image_32x32.txt ({32*32*1} valeurs)")
    
    return image

if __name__ == "__main__":
    print("Génération de l'image d'entrée pour test Conv1...")
    image = generate_input_image_32x32()
    print("\n✓ Fichier créé : input_image_32x32.txt")
    print("  À copier dans le répertoire de simulation Vivado")