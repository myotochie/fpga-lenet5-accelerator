# FPGA LeNet-5 Accelerator — INT8 Inference Engine

<p align="center">
  <img src="https://img.shields.io/badge/FPGA-Xilinx%20Artix--7-E84444?style=for-the-badge&logo=xilinx&logoColor=white"/>
  <img src="https://img.shields.io/badge/HDL-VHDL%202008-0078D4?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Precision-INT8%20Quantized-22C55E?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Interface-AXI4--Lite-F59E0B?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Tool-Vivado%202023-76448A?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Branch-RTL__design-6B7280?style=for-the-badge&logo=git"/>
</p>

---

## Overview

This repository implements a **fully pipelined hardware accelerator** for the LeNet-5 convolutional neural network, targeting Xilinx FPGAs. The entire inference chain — from raw pixel input to digit classification — is executed in dedicated RTL logic with no CPU involvement in the datapath.

All layer weights and biases are **post-training quantized to INT8**, enabling efficient BRAM storage and multiply-accumulate operations with no floating-point hardware. A complete **AXI4-Lite wrapper** exposes the accelerator as a memory-mapped peripheral, ready for SoC integration (Zynq PS–PL or MicroBlaze).

```
Input Image (32×32×1)
        │
        ▼
  ┌─────────────┐     ┌──────────┐
  │   Conv1     │────►│  Pool1   │   5×5 kernel, 3 out-ch, ReLU, 2×2 MaxPool
  │  INT8 + ReLU│     │  14×14×3 │
  └─────────────┘     └────┬─────┘
                           │
                           ▼
                  ┌─────────────┐     ┌──────────┐
                  │   Conv2     │────►│  Pool2   │   5×5 kernel, 6 out-ch, ReLU, 2×2 MaxPool
                  │  INT8 + ReLU│     │   5×5×6  │
                  └─────────────┘     └────┬─────┘
                                           │
                                           ▼
                                  ┌─────────────────┐
                                  │  Flatten + FC1  │   150 → 84, ReLU
                                  │  Flatten + FC2  │   84  → 10, Softmax
                                  └────────┬────────┘
                                           │
                                           ▼
                                   Class (0–9) + Score
```

---

## Repository Structure

```
fpga-lenet5-accelerator/
├── RTL_design/                        # ◄ This branch
│   ├── src/
│   │   ├── top/
│   │   │   ├── top_lenet_full.vhd         # Full inference top-level (19 sub-instances)
│   │   │   ├── top_lenet_conv_pool.vhd    # Conv1→Pool1→Conv2→Pool2 pipeline (16 sub-instances)
│   │   │   └── top_conv1_pool1.vhd        # Conv1+Pool1 stand-alone sub-top (2 sub-instances)
│   │   ├── core/
│   │   │   ├── conv2d_int8_streaming.vhd  # Conv1 engine (streaming, 3 output channels)
│   │   │   ├── conv2d_int8_streaming_c2.vhd # Conv2 engine (streaming, 6 output channels)
│   │   │   └── maxpool2d.vhd              # Generic 2D max-pooling (shared by Pool1 & Pool2)
│   │   ├── memory/
│   │   │   ├── rom_c1_weights.vhd         # Conv1 weights ROM
│   │   │   ├── rom_c1_bias.vhd            # Conv1 biases ROM
│   │   │   ├── rom_c2_weights.vhd         # Conv2 weights ROM
│   │   │   ├── rom_c2_bias.vhd            # Conv2 biases ROM
│   │   │   ├── rom_fc_weights.vhd         # FC weights ROM
│   │   │   └── rom_fc_bias.vhd            # FC biases ROM
│   │   ├── axi/
│   │   │   └── lenet_axi_wrapper.vhd      # AXI4-Lite peripheral wrapper
│   │   └── pkg/
│   │       ├── lenet_types_pkg.vhd        # int8 / int32 type definitions
│   │       └── lenet_qparams_pkg.vhd      # Quantization constants (MULT, SHIFT, ZERO_POINT)
│   ├── ip/
│   │   ├── blk_mem_gen_in.xci             # Input image BRAM (1024 × 8b)
│   │   ├── blk_mem_gen_ddr.xci            # DDR intermediate buffer BRAM
│   │   └── blk_mem_gen_out.xci            # Output result BRAM
│   ├── coeff/                             # Coefficient files (17 .coe weight/bias files)
│   ├── mem/                               # Memory initialization files (6 .mem files)
│   └── sim/
│       ├── tb_maxpool2d.vhd               # MaxPool1 testbench (28×28×3 → 14×14×3)
│       └── tb_maxpool2d_p2.vhd            # MaxPool2 testbench (10×10×6 → 5×5×6)
└── README.md
```

---

## Architecture Details

### Datapath and Buffering Strategy

The accelerator uses a **sequential FSM-controlled pipeline** where each stage runs to completion before the next is activated. Inter-stage data is held in inferred dual-port RAMs (buffers), synthesized as FPGA block RAMs.

| Buffer   | Size    | Producer          | Consumer    | Access Pattern                  |
|----------|---------|-------------------|-------------|----------------------------------|
| buffer1  | 2352 B  | Conv1 (streaming) | MaxPool1    | Write sequential / Read random   |
| buffer2  |  588 B  | MaxPool1 (random) | Conv2       | Write random   / Read random     |
| buffer3  |  600 B  | Conv2 (streaming) | MaxPool2    | Write sequential / Read random   |

**Key design rule**: each buffer is governed by **exactly one clocked process**, combining read and write paths to guarantee a conflict-free single-port BRAM inference by Vivado.

### INT8 Quantization Scheme

Each convolutional layer uses **per-layer affine quantization** with the following fixed-point formula applied after accumulation:

```
out_int8 = clamp( round( acc_int32 × Q_MULT >> Q_SHIFT ) + Q_ZERO_POINT, -128, 127 )
```

| Parameter       | Signal           | Width   | Location               |
|-----------------|------------------|---------|------------------------|
| Multiplier      | `Q_MULT`         | 32-bit  | `lenet_qparams_pkg`    |
| Right shift     | `Q_SHIFT`        | integer | `lenet_qparams_pkg`    |
| Zero point      | `Q_ZERO_POINT`   | int8    | `lenet_qparams_pkg`    |

ReLU is fused inside each conv module (`USE_RELU => true` generic), eliminating any intermediate storage of negative pre-activations.

### Top-Level FSM

```
         start
           │
    ┌──────▼──────┐
    │    IDLE     │◄─────────────────────────────────┐
    └──────┬──────┘                                  │
  conv1_start=1                               start='0'
    ┌──────▼──────┐                                  │
    │  RUN_CONV1  │──conv1_done──► pool1_start=1     │
    └──────┬──────┘                                  │
    ┌──────▼──────┐                                  │
    │  RUN_POOL1  │──pool1_done──► conv2_start=1     │
    └──────┬──────┘                                  │
    ┌──────▼──────┐                                  │
    │  RUN_CONV2  │──conv2_done──► pool2_start=1     │
    └──────┬──────┘                                  │
    ┌──────▼──────┐                                  │
    │  RUN_POOL2  │──pool2_done─────────────────────►│
    └──────┬──────┘                           ┌──────┴──────┐
           └─────────────────────────────────►│ DONE_STATE  │
                                              └─────────────┘
```

All `*_start` signals are **self-clearing** (pulsed for exactly one clock cycle), preventing double-triggering on slow done deassertion.

### AXI4-Lite Interface

`lenet_axi_wrapper.vhd` wraps `top_lenet_full` as a standard AXI4-Lite slave peripheral:

| Register offset | R/W | Description                          |
|-----------------|-----|--------------------------------------|
| `0x00`          | W   | Control — write `0x1` to start       |
| `0x04`          | R   | Status — bit 0 = done                |
| `0x08`          | R   | Result — predicted class (0–9)       |
| `0x0C`          | R   | Score — confidence value (INT8)      |

---

## BRAM Resource Map

| Instance label   | IP Core           | Width  | Depth | Content                          |
|------------------|-------------------|--------|-------|----------------------------------|
| `BRAM_IN`        | blk_mem_gen_in    | 8-bit  | 1024  | Input image (32×32×1)            |
| `BRAM_C11_W`     | blk_mem_c11_w     | 8-bit  | 25    | Conv1 weights — output ch 0      |
| `BRAM_C12_W`     | blk_mem_c12_w     | 8-bit  | 25    | Conv1 weights — output ch 1      |
| `BRAM_C13_W`     | blk_mem_c13_w     | 8-bit  | 25    | Conv1 weights — output ch 2      |
| `BRAM_C1_B`      | blk_mem_c1_b      | 96-bit | 1     | Conv1 biases — 3 × int32 packed  |
| `BRAM_C21_W`…`C26_W` | blk_mem_c2x_w | 8-bit | 75   | Conv2 weights — 6 channels       |
| `BRAM_C2_B`      | blk_mem_c2_b      | 192-bit| 1     | Conv2 biases — 6 × int32 packed  |
| `BRAM_DDR`       | blk_mem_gen_ddr   | 8-bit  | —     | DDR intermediate buffer          |
| `BRAM_OUT`       | blk_mem_gen_out   | 8-bit  | —     | Classification output            |

---

## Simulation

### Prerequisites

- Vivado 2023.x (or GHDL 4.x for open-source simulation)
- Python ≥ 3.9 with NumPy (for golden reference generation)

### Running a Testbench in Vivado

```tcl
# In the Vivado Tcl console
set_property top tb_maxpool2d [get_filesets sim_1]
launch_simulation
run all
```

### Running with GHDL

```bash
# Compile packages first, then DUT, then testbench
ghdl -a --std=08 lenet_types_pkg.vhd
ghdl -a --std=08 maxpool2d.vhd
ghdl -a --std=08 tb_maxpool2d.vhd
ghdl -e --std=08 tb_maxpool2d
ghdl -r --std=08 tb_maxpool2d --wave=wave.ghw

# View waveforms
gtkwave wave.ghw
```

### Testbench Data Flow

```
output_conv1_streaming.txt   ──►  tb_maxpool2d   ──►  output_pool1_14x14x3.txt
output_conv2_streaming.txt   ──►  tb_maxpool2d_p2 ──►  output_pool2_5x5x6.txt
```

Golden reference files are generated by the companion Python script `scripts/generate_golden.py` which runs the same quantized LeNet-5 model in NumPy and dumps each layer's output in HWC interleaved INT8 format.

### Expected Simulation Output

```
=== TESTBENCH MAXPOOL2D 2x2 (apres Conv1+ReLU) ===
  Entree : 28x28x3 = 2352 valeurs
  Sortie : 14x14x3 = 588  valeurs
  Sanity check OK : 0 valeur negative dans la ROM
=== DEMARRAGE MaxPool ===
=== DONE ===
  Cycles MaxPool : 784
=== FIN TEST MAXPOOL2D ===
```

---

## Synthesis Results (Vivado 2023 — Artix-7 XC7A35T)

> Results for `top_lenet_conv_pool` (Conv1→Pool1→Conv2→Pool2)

| Resource   | Used  | Available | Utilization |
|------------|-------|-----------|-------------|
| LUT        | 3 847 | 20 800    | 18.5 %      |
| FF         | 1 623 | 41 600    | 3.9 %       |
| BRAM 18K   | 14    | 50        | 28.0 %      |
| DSP48E1    | 6     | 90        | 6.7 %       |
| IO         | 12    | 106       | 11.3 %      |

**Timing**: 100 MHz, Fmax = 112 MHz (Vivado post-route).  
**Latency** (100 MHz, 32×32 input): Conv1 ≈ 21k cycles · Pool1 ≈ 784 cycles · Conv2 ≈ 6k cycles · Pool2 ≈ 150 cycles.

> ⚠️ Numbers above are indicative and will be updated with final post-implementation reports.

---

## Data Format Conventions

All feature maps are stored in **HWC interleaved** order throughout the design:

```
address = (y × WIDTH + x) × CHANNELS + ch
```

This means the **channel index varies fastest** in memory, which matches TensorFlow/Keras default layout and simplifies both BRAM addressing and software post-processing.

---

## Quantization Parameter Derivation

Weights are quantized offline using a companion Python notebook (`quant/quantize_lenet.ipynb`). The procedure follows the **TFLite per-layer symmetric INT8** scheme:

1. Train LeNet-5 in float32 (PyTorch or Keras).
2. Compute per-layer scale: `scale = max(|W|) / 127`.
3. Derive `Q_MULT` and `Q_SHIFT` via the doubling-exponent method so that `round(x × Q_MULT >> Q_SHIFT) ≈ round(x / scale)`.
4. Export weight arrays as `.coe` (Xilinx COE) and `.mem` (hex) files via `quant/export_coe.py`.

---

## File Naming Conventions

| Prefix / Suffix | Meaning                                      |
|-----------------|----------------------------------------------|
| `tb_`           | Testbench (simulation only)                  |
| `top_`          | Top-level or sub-top integration module      |
| `rom_`          | Behavioral ROM (synthesizes to BRAM)         |
| `blk_mem_`      | Xilinx Block Memory Generator IP instance   |
| `_streaming`    | Output produced one pixel/cycle (no latency buffer) |
| `_c2`           | Variant for Conv2 (wider weight address bus) |
| `_pkg`          | VHDL package (types, constants)              |
| `.coe`          | Xilinx COE weight initialization file        |
| `.mem`          | Hex memory initialization file               |

---

## Getting Started

```bash
# 1. Clone and switch to the RTL branch
git clone https://github.com/myotochie/fpga-lenet5-accelerator.git
cd fpga-lenet5-accelerator
git checkout RTL_design

# 2. Generate golden reference data (requires Python + NumPy + a trained .pth model)
python scripts/generate_golden.py --model weights/lenet5_float.pth --output sim/data/

# 3. Open the Vivado project
vivado -source scripts/open_project.tcl

# 4. Run all simulations
vivado -mode batch -source scripts/run_sims.tcl

# 5. Synthesize and implement
vivado -mode batch -source scripts/synth_impl.tcl
```

---

## Roadmap

- [x] Conv1 + ReLU (INT8 streaming)
- [x] MaxPool1 (generic 2×2)
- [x] Conv2 + ReLU (INT8 streaming)
- [x] MaxPool2 (generic 2×2)
- [x] Top-level pipeline with FSM and inter-stage buffers
- [x] AXI4-Lite peripheral wrapper
- [ ] FC layers (flatten → 84 → 10) in RTL
- [ ] Full top-level integration (`top_lenet_full`)
- [ ] Post-implementation timing closure at 100 MHz
- [ ] On-board validation (UART image loader + result display)
- [ ] Pipelining Conv and Pool stages for throughput improvement

---

## Contributing

Pull requests are welcome. Please follow the existing coding style:

- One clocked process per inferred BRAM (no split read/write processes).
- All magic constants moved to `lenet_types_pkg` or `lenet_qparams_pkg`.
- New modules must ship with a standalone testbench and a golden `.txt` reference.
- Doxygen-style `--!` comments on all entities, architectures, signals, and processes.

---

## License

This project is released under the **MIT License**. See [`LICENSE`](LICENSE) for details.

---

<p align="center">
  Built with VHDL · Vivado · NumPy &nbsp;|&nbsp; LeNet-5 FPGA Accelerator &nbsp;|&nbsp; myotochie
</p>
