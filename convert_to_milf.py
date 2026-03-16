import re
import os

def parse_header_file(header_file):
    """
    Parse the header file to extract the arrays, their values, and their types.
    """
    arrays = {}
    with open(header_file, 'r') as file:
        content = file.read()

    # On modifie la RegEx pour capturer le type (int8_t ou int32_t) dans le groupe 1
    # Groupe 1: Type, Groupe 2: Nom, Groupe 3: Valeurs
    matches = re.finditer(r'static const (int8_t|int32_t) (\w+)\[.*?\] = \{(.*?)\};', content, re.S)

    for match in matches:
        array_type = match.group(1)
        array_name = match.group(2)
        array_values = match.group(3)

        # Clean up the values and convert to a list of integers
        values = re.findall(r'-?\d+', array_values)
        
        # On stocke un dictionnaire contenant les valeurs ET le type
        arrays[array_name] = {
            'type': array_type,
            'values': list(map(int, values))
        }

    return arrays

def convert_to_mif(arrays, output_dir):
    """
    Convert the extracted arrays to .mif format with dynamic WIDTH.
    """
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    for name, data in arrays.items():
        values = data['values']
        array_type = data['type']
        
        # Détermination de la largeur (WIDTH) selon le type ou le nom
        # Si c'est int32_t OU si le mot "bias" est dans le nom
        if array_type == "int32_t" or "bias" in name.lower():
            width = 32
        else:
            width = 8

        file_name = name.lower().replace("lenet_", "") + ".mif"
        file_path = os.path.join(output_dir, file_name)

        with open(file_path, 'w') as file:
            file.write(f"-- Memory Initialization File for {name}\n")
            file.write(f"WIDTH={width};\n") # Utilisation de la variable dynamique
            file.write(f"DEPTH={len(values)};\n")
            file.write("ADDRESS_RADIX=UNS;\n")
            file.write("DATA_RADIX=DEC;\n")
            file.write("CONTENT BEGIN\n")

            for i, value in enumerate(values):
                file.write(f"    {i} : {value};\n")

            file.write("END;\n")

def main():
    header_file = "lenet_params_int8.h"
    output_dir = "mif_files"

    arrays = parse_header_file(header_file)
    convert_to_mif(arrays, output_dir)

    print(f"Conversion complete. MIF files saved in {output_dir}")

if __name__ == "__main__":
    main()