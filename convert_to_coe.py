import re
import os

def parse_header_file(header_file):
    arrays = {}
    with open(header_file, 'r') as file:
        content = file.read()
    
    # Capture type, nom et valeurs
    matches = re.finditer(r'static const (int8_t|int32_t) (\w+)\[.*?\] = \{(.*?)\};', content, re.S)
    for match in matches:
        array_type = match.group(1)
        array_name = match.group(2)
        array_values = match.group(3)
        values = re.findall(r'-?\d+', array_values)
        arrays[array_name] = {'type': array_type, 'values': list(map(int, values))}
    return arrays

def convert_to_coe(arrays, output_dir):
    """
    Convertit les tableaux extraits au format .coe pour Vivado.
    """
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    for name, data in arrays.items():
        values = data['values']
        array_type = data['type']
        
        # Déterminer la largeur (WIDTH) pour le complément à deux
        width = 32 if (array_type == "int32_t" or "bias" in name.lower()) else 8
        num_chars = width // 4  # 8 bits = 2 hex chars, 32 bits = 8 hex chars

        file_name = name.lower().replace("lenet_", "") + ".coe"
        file_path = os.path.join(output_dir, file_name)

        with open(file_path, 'w') as file:
            # En-tête obligatoire pour le Block Memory Generator de Vivado
            file.write("memory_initialization_radix=16;\n")
            file.write("memory_initialization_vector=\n")

            for i, val in enumerate(values):
                # Gestion des nombres négatifs (complément à deux)

                
                # Conversion en hexadécimal
                hex_val = format(val, f'0{num_chars}x')
                
                # Séparateur : virgule pour toutes les lignes sauf la dernière qui prend un point-virgule
                if i == len(values) - 1:
                    file.write(f"{hex_val};\n")
                else:
                    file.write(f"{hex_val},\n")

def main():
    header_file = "lenet_params_int8.h"  # Ton fichier source
    output_dir = "coe_files"            # Dossier de sortie
    
    arrays = parse_header_file(header_file)
    convert_to_coe(arrays, output_dir)
    
    print(f"Conversion complete. COE files saved in {output_dir}")

if __name__ == "__main__":
    main()