import re

def extract_and_scale_params(input_file, output_file):
    """
    Extract specific parameters from the input file, scale them by 2^16, and save to the output file.
    """
    params = []

    # Read the input file and extract relevant parameters
    with open(input_file, 'r') as file:
        content = file.read()

    # Match the scale and zero-point definitions
    matches = re.finditer(r'static const float (\w+)_SCALE = ([0-9.eE+-]+)f;\nstatic const int32_t (\w+)_ZP = (-?\d+);', content)

    for match in matches:
        param_name = match.group(1)  # Extract the base name (e.g., LENET_C1_W)
        scale = float(match.group(2))
        zero_point = int(match.group(4))

        # Scale the scale value by 2^16
        scaled_scale = int(scale * (2**16))

        params.append({
            "name": param_name,
            "scale": scaled_scale,
            "zero_point": zero_point
        })

    # Write the scaled parameters to the output file
    with open(output_file, 'w') as file:
        file.write("#ifndef SCALED_PARAMS_H\n")
        file.write("#define SCALED_PARAMS_H\n\n")

        for param in params:
            file.write(f"#define {param['name']}_SCALE {param['scale']}\n")
            file.write(f"#define {param['name']}_ZP {param['zero_point']}\n")

        file.write("\n#endif // SCALED_PARAMS_H\n")

def main():
    input_file = "lenet_params_int8.h"  # Input file
    output_file = "scaled_params.h"  # Output file

    # Extract and scale parameters
    extract_and_scale_params(input_file, output_file)

    print(f"Scaled parameters saved to {output_file}")

if __name__ == "__main__":
    main()