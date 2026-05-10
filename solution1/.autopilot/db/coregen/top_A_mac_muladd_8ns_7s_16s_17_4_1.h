// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __top_A_mac_muladd_8ns_7s_16s_17_4_1__HH__
#define __top_A_mac_muladd_8ns_7s_16s_17_4_1__HH__
#include "top_A_mac_muladd_8ns_7s_16s_17_4_1_DSP48_11.h"

template<
    int ID,
    int NUM_STAGE,
    int din0_WIDTH,
    int din1_WIDTH,
    int din2_WIDTH,
    int dout_WIDTH>
SC_MODULE(top_A_mac_muladd_8ns_7s_16s_17_4_1) {
    sc_core::sc_in_clk clk;
    sc_core::sc_in<sc_dt::sc_logic> reset;
    sc_core::sc_in<sc_dt::sc_logic> ce;
    sc_core::sc_in< sc_dt::sc_lv<din0_WIDTH> >   din0;
    sc_core::sc_in< sc_dt::sc_lv<din1_WIDTH> >   din1;
    sc_core::sc_in< sc_dt::sc_lv<din2_WIDTH> >   din2;
    sc_core::sc_out< sc_dt::sc_lv<dout_WIDTH> >   dout;



    top_A_mac_muladd_8ns_7s_16s_17_4_1_DSP48_11 top_A_mac_muladd_8ns_7s_16s_17_4_1_DSP48_11_U;

    SC_CTOR(top_A_mac_muladd_8ns_7s_16s_17_4_1):  top_A_mac_muladd_8ns_7s_16s_17_4_1_DSP48_11_U ("top_A_mac_muladd_8ns_7s_16s_17_4_1_DSP48_11_U") {
        top_A_mac_muladd_8ns_7s_16s_17_4_1_DSP48_11_U.clk(clk);
        top_A_mac_muladd_8ns_7s_16s_17_4_1_DSP48_11_U.rst(reset);
        top_A_mac_muladd_8ns_7s_16s_17_4_1_DSP48_11_U.ce(ce);
        top_A_mac_muladd_8ns_7s_16s_17_4_1_DSP48_11_U.in0(din0);
        top_A_mac_muladd_8ns_7s_16s_17_4_1_DSP48_11_U.in1(din1);
        top_A_mac_muladd_8ns_7s_16s_17_4_1_DSP48_11_U.in2(din2);
        top_A_mac_muladd_8ns_7s_16s_17_4_1_DSP48_11_U.dout(dout);

    }

};

#endif //
