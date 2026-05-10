#!/usr/bin/env python3
"""
Script pour vérifier les paramètres de quantification du modèle ONNX
et comparer avec les valeurs dans lenet_params_int8.h
"""

import onnx
import numpy as np
from onnx import numpy_helper

def analyze_onnx_model(onnx_path):
    """Analyse le modèle ONNX et extrait tous les paramètres de quantification"""
    
    print("=" * 80)
    print(f"ANALYSE DU MODÈLE ONNX: {onnx_path}")
    print("=" * 80)
    
    model = onnx.load(onnx_path)
    
    # Extraire tous les tensors (poids, bias, scales, zero-points)
    initializers = {init.name: init for init in model.graph.initializer}
    
    print(f"\n📊 Nombre total de tensors: {len(initializers)}")
    print("\n" + "=" * 80)
    print("LISTE DES TENSORS")
    print("=" * 80)
    
    scales = {}
    zero_points = {}
    weights = {}
    biases = {}
    
    for name, tensor in initializers.items():
        data = numpy_helper.to_array(tensor)
        shape = data.shape
        dtype = data.dtype
        
        print(f"\n📌 {name}")
        print(f"   Shape: {shape}")
        print(f"   Dtype: {dtype}")
        
        # Classifier les tensors
        if 'scale' in name.lower():
            scales[name] = data
            print(f"   Type: SCALE")
            print(f"   Value: {data}")
        elif 'zero_point' in name.lower() or 'zp' in name.lower():
            zero_points[name] = data
            print(f"   Type: ZERO_POINT")
            print(f"   Value: {data}")
        elif 'weight' in name.lower() or '.w' in name.lower():
            weights[name] = data
            print(f"   Type: WEIGHT")
            print(f"   Min/Max: [{data.min()}, {data.max()}]")
        elif 'bias' in name.lower() or '.b' in name.lower():
            biases[name] = data
            print(f"   Type: BIAS")
            print(f"   Values: {data}")
    
    return {
        'scales': scales,
        'zero_points': zero_points,
        'weights': weights,
        'biases': biases
    }


def verify_bias_quantization(params, layer_name, s_input, s_weight):
    """
    Vérifie si le bias est correctement quantifié
    
    Pour une convolution quantifiée:
    - Input scale: S_IN
    - Weight scale: S_WEIGHT
    - Bias scale: S_BIAS = S_IN * S_WEIGHT (car bias est ajouté après multiplication)
    - Bias quantifié: bias_q = round(bias_float / S_BIAS)
    """
    
    print("\n" + "=" * 80)
    print(f"VÉRIFICATION BIAS POUR {layer_name}")
    print("=" * 80)
    
    biases = params['biases']
    
    # Chercher le bias correspondant
    bias_tensor = None
    for name, data in biases.items():
        if layer_name.lower() in name.lower():
            bias_tensor = data
            print(f"\n✓ Bias trouvé: {name}")
            print(f"  Shape: {data.shape}")
            print(f"  Dtype: {data.dtype}")
            print(f"  Values: {data}")
            break
    
    if bias_tensor is None:
        print(f"\n❌ Aucun bias trouvé pour {layer_name}")
        return
    
    # Calculer le scale du bias
    s_bias = s_input * s_weight
    print(f"\n📐 Calculs de quantification:")
    print(f"  S_INPUT  = {s_input:.10e}")
    print(f"  S_WEIGHT = {s_weight:.10e}")
    print(f"  S_BIAS   = S_INPUT * S_WEIGHT = {s_bias:.10e}")
    
    # Si le bias est en INT8, il devrait être en INT32 !
    if bias_tensor.dtype == np.int8:
        print(f"\n⚠️  WARNING: Bias est en INT8, devrait être INT32 !")
        print(f"  Les valeurs INT8 peuvent perdre en précision.")
    
    # Si on a un bias float, calculer sa version quantifiée
    if bias_tensor.dtype in [np.float32, np.float64]:
        print(f"\n✓ Bias en float, calcul de la version quantifiée:")
        bias_q = np.round(bias_tensor / s_bias).astype(np.int32)
        print(f"  Bias quantifié (INT32): {bias_q}")
        print(f"  Range: [{bias_q.min()}, {bias_q.max()}]")
        return bias_q
    elif bias_tensor.dtype in [np.int8, np.int32]:
        print(f"\n✓ Bias déjà quantifié:")
        print(f"  Valeurs actuelles: {bias_tensor}")
        return bias_tensor
    
    return None


def main():
    """Fonction principale"""
    
    # Chemins des modèles
    fp32_model = "lenet_fp32.onnx"
    int8_model = "lenet_int8_qdq.onnx"
    
    # Scales extraits de lenet_qparams_min.h
    S_IN = 3.92156886e-03
    S_L1 = 2.03764345e-02
    S_L2 = 6.23761304e-02
    S_OUT = 1.92038208e-01
    
    # Scales des poids extraits de lenet_params_int8.h
    C1_W_SCALE = 4.53366758e-03
    C2_W_SCALE = 4.75998269e-03
    FC_W_SCALE = 4.64022905e-03
    
    print("\n" + "=" * 80)
    print("ANALYSE DU MODÈLE INT8 QUANTIFIÉ")
    print("=" * 80)
    
    try:
        params = analyze_onnx_model(int8_model)
        
        # Vérifier chaque layer
        print("\n\n" + "=" * 80)
        print("VÉRIFICATION DES BIAS")
        print("=" * 80)
        
        bias_c1 = verify_bias_quantization(params, "c1", S_IN, C1_W_SCALE)
        bias_c2 = verify_bias_quantization(params, "c2", S_L1, C2_W_SCALE)
        bias_fc = verify_bias_quantization(params, "f4", S_L2, FC_W_SCALE)
        
        # Comparaison avec les valeurs dans le .h
        print("\n\n" + "=" * 80)
        print("COMPARAISON AVEC lenet_params_int8.h")
        print("=" * 80)
        
        h_file_biases = {
            'C1': [0, 46, 23],
            'C2': [5, -14, 43, -82, 48, -47],
            'FC': [14, 26, -1, -54, 8, 2, 26, -19, 7, 7]
        }
        
        print("\n📋 Valeurs dans lenet_params_int8.h:")
        print(f"  LENET_C1_B = {h_file_biases['C1']}")
        print(f"  LENET_C2_B = {h_file_biases['C2']}")
        print(f"  LENET_FC_B = {h_file_biases['FC']}")
        
        if bias_c1 is not None:
            print(f"\n📋 Comparaison C1:")
            print(f"  ONNX: {bias_c1}")
            print(f"  .h  : {h_file_biases['C1']}")
            if np.array_equal(bias_c1, h_file_biases['C1']):
                print("  ✓ MATCH")
            else:
                print("  ❌ MISMATCH!")
        
    except FileNotFoundError:
        print(f"\n❌ Fichier {int8_model} non trouvé.")
        print("   Veuillez d'abord exécuter train_quantize.py pour générer le modèle.")
    
    # Analyse du graphe ONNX pour vérifier l'ordre des opérations
    print("\n\n" + "=" * 80)
    print("ANALYSE DE L'ORDRE DES OPÉRATIONS")
    print("=" * 80)
    print("\nPour vérifier si ReLU est avant ou après la quantification,")
    print("il faut examiner le graphe ONNX en détail...")
    
    try:
        model = onnx.load(int8_model)
        print(f"\n📊 Nombre de nodes: {len(model.graph.node)}")
        print("\nPremiers 20 nodes:")
        for i, node in enumerate(model.graph.node[:20]):
            print(f"  {i}: {node.op_type} - {node.name}")
            if node.op_type in ['QuantizeLinear', 'DequantizeLinear', 'Relu']:
                print(f"      Inputs: {list(node.input)}")
                print(f"      Outputs: {list(node.output)}")
    except:
        pass


if __name__ == "__main__":
    main()
