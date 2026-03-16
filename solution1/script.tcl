############################################################
## This file is generated automatically by Vitis HLS.
## Please DO NOT edit it.
## Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
## Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
############################################################
open_project Lenet_RTL_test
set_top top_A
add_files Lenet_RTL_test/lenet_conv1_only.cpp
add_files Lenet_RTL_test/lenet_inderence.cpp
add_files Lenet_RTL_test/lenet_params_int8.h
add_files Lenet_RTL_test/lenet_qparams_min.h
add_files -tb Lenet_RTL_test/tb_conv1_maxpool.cpp -cflags "-Wno-unknown-pragmas"
open_solution "solution1" -flow_target vivado
set_part {xc7z010-clg400-1}
create_clock -period 10 -name default
config_cosim -rtl vhdl -tool xsim
#source "./Lenet_RTL_test/solution1/directives.tcl"
csim_design
csynth_design
cosim_design -rtl vhdl
export_design -format ip_catalog
