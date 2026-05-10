set SynModuleInfo {
  {SRCNAME conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3 MODELNAME conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3 RTLNAME top_A_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3
    SUBMODULES {
      {MODELNAME top_A_mul_8ns_7ns_15_1_1 RTLNAME top_A_mul_8ns_7ns_15_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME top_A_mul_8ns_8s_16_1_1 RTLNAME top_A_mul_8ns_8s_16_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME top_A_mac_muladd_8ns_7ns_15s_17_4_1 RTLNAME top_A_mac_muladd_8ns_7ns_15s_17_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME top_A_mac_muladd_8ns_7ns_16s_17_4_1 RTLNAME top_A_mac_muladd_8ns_7ns_16s_17_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME top_A_mac_muladd_8ns_8s_17s_18_4_1 RTLNAME top_A_mac_muladd_8ns_8s_17s_18_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME top_A_mac_muladd_8ns_7ns_17s_18_4_1 RTLNAME top_A_mac_muladd_8ns_7ns_17s_18_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME top_A_mac_muladd_8ns_7ns_15ns_16_4_1 RTLNAME top_A_mac_muladd_8ns_7ns_15ns_16_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME top_A_mac_muladd_8ns_8s_16s_17_4_1 RTLNAME top_A_mac_muladd_8ns_8s_16s_17_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME top_A_mac_muladd_8ns_8s_16ns_17_4_1 RTLNAME top_A_mac_muladd_8ns_8s_16ns_17_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME top_A_mac_muladd_8ns_6ns_15ns_16_4_1 RTLNAME top_A_mac_muladd_8ns_6ns_15ns_16_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME top_A_mac_muladd_8ns_7ns_16ns_16_4_1 RTLNAME top_A_mac_muladd_8ns_7ns_16ns_16_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME top_A_mac_muladd_8ns_6ns_17s_17_4_1 RTLNAME top_A_mac_muladd_8ns_6ns_17s_17_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME top_A_mac_muladd_8ns_8s_16s_16_4_1 RTLNAME top_A_mac_muladd_8ns_8s_16s_16_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME top_A_mac_muladd_8ns_7s_16s_17_4_1 RTLNAME top_A_mac_muladd_8ns_7s_16s_17_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME top_A_mac_muladd_8ns_7s_17s_17_4_1 RTLNAME top_A_mac_muladd_8ns_7s_17s_17_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME top_A_flow_control_loop_pipe_sequential_init RTLNAME top_A_flow_control_loop_pipe_sequential_init BINDTYPE interface TYPE internal_upc_flow_control INSTNAME top_A_flow_control_loop_pipe_sequential_init_U}
    }
  }
  {SRCNAME conv1_pragma MODELNAME conv1_pragma RTLNAME top_A_conv1_pragma
    SUBMODULES {
      {MODELNAME top_A_mux_4_2_15_1_1 RTLNAME top_A_mux_4_2_15_1_1 BINDTYPE op TYPE mux IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_0_0_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_0_0_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_0_1_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_0_1_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_0_2_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_0_2_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_0_3_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_0_3_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_0_4_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_0_4_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_1_0_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_1_0_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_1_1_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_1_1_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_1_2_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_1_2_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_1_3_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_1_3_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_1_4_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_1_4_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_2_0_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_2_0_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_2_1_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_2_1_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_2_2_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_2_2_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_2_3_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_2_3_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_2_4_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_2_4_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_3_0_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_3_0_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_3_1_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_3_1_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_3_2_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_3_2_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_3_3_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_3_3_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_3_4_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_3_4_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_4_0_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_4_0_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_4_1_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_4_1_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_4_2_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_4_2_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_4_3_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_4_3_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME top_A_conv1_pragma_LENET_C1_W_0_4_4_ROM_AUTO_1R RTLNAME top_A_conv1_pragma_LENET_C1_W_0_4_4_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME top_A MODELNAME top_A RTLNAME top_A IS_TOP 1
    SUBMODULES {
      {MODELNAME top_A_y1_0_RAM_2P_BRAM_1R1W RTLNAME top_A_y1_0_RAM_2P_BRAM_1R1W BINDTYPE storage TYPE ram_2p IMPL bram LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
}
