// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Thu Feb 12 14:27:47 2026
// Host        : LAPTOP-KS0KAFEO running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/myodo/Desktop/Lenet_RTL/Lenet_vhdl/Lenet_vhdl.gen/sources_1/ip/blk_mem_c2_b/blk_mem_c2_b_sim_netlist.v
// Design      : blk_mem_c2_b
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_c2_b,blk_mem_gen_v8_4_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module blk_mem_c2_b
   (clka,
    ena,
    addra,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [2:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;

  wire [2:0]addra;
  wire clka;
  wire [31:0]douta;
  wire ena;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_doutb_UNCONNECTED;
  wire [2:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [2:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "3" *) 
  (* C_ADDRB_WIDTH = "3" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     3.375199 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_c2_b.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_c2_b.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "6" *) 
  (* C_READ_DEPTH_B = "6" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "6" *) 
  (* C_WRITE_DEPTH_B = "6" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_c2_b_blk_mem_gen_v8_4_6 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[31:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[2:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[2:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(1'b0),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2023.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
aMT3usC6uizzcwnzOCX4OsS16Ob+YxFcsGovFpFklbnaIaD1S0lVdxenTwHPp6ByIEi+ehwr6Rgg
z/3AlTheI5NFTM8ihiMA18/wmUxI7EbaftJACA1LykUKCuj5myy0T+DACuv3sGYIZS38TZTZnnBC
FGAlvTZmRWs+JzneH3o=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
lR9ZerhYSAb39nzEkeYvhnwEs5t9y/+yTDf8KuoUtR1BGeHZq8pA/YxtjzQLtaOW1R1IQUb0FtSI
e3CYAb7WHYbIjcpw3vKHvW1SqcGn9CMGa556CYKmD2oF12Kow8xRaFvMSBUVxX7HsHxNWnRd+PU1
+C0YayU2KFIY/7Yl6cZ5luAzhw/6SW3PFYUIyyqWy5MCIXweHOwQR2IpQEdlDur5nluN7i7BeB+i
fxwwHh8TU/g7T4mhZFkiTuBKdLAtQOjxWxzqTMxgcuAjlTylY16FgMFOASdvvSbqBZJjbxMdVloU
rYjS8O/8rWktv8GXcaIdBJ2BRj01q7jsChsbwA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
Qvl63GHz9mq2xOB7elt/vAQ7URLGdD1Lkcz7f3Wtw31dwjjjbP62Ny/Jr6OmBIheWlgejx38qxAT
TrHiiEyjKmGcnPn1Tn2n+cH4RAxCbOFnCI9n6+YsYMTe9JkplGhGGr39SkFgJz0I2IKpPsuqTjCj
rhf49TAryNMQeRpREJA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
MA+9Ro+dh339m0iZrkKbqTKN8gQ5xkxN/SPCfhkOn+5jjgCTS5IOKLHil+HsZDjX333ebxnornwG
MOBxyEdFfLM8SA+bs2r41J/j0af2VVMmCM3hOh8JmZxB4X9Jg/glegNCbvwzqxMbOQNEy+zt7j5t
TFVD82RtPFmYVVYZZyll/WvAA+0aVpyjzLCIM1GznFky0RWLv65Wp4MJJnNRRrtG3muMznVO/u2s
tACsJ9jzv9M0IlMYjYH9BixhG6cZX02I4LEXXaPkhdOINlMMhsbArXtc9NphzmS4bY1/1yF1D6YD
EKLyS2Sr3HDl0O/lefN+jvfG8iKuVl55PNNrVQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
wpMTg7STjFkUDhOqdNPa0FHXTnHQgKmhvqDv+rRVBvMiQ8O7u8oj7ibITq3o+jugJsMJ60B410gQ
JFTcqCJKYmYJvqi8rPLLOYDmFG6ZLP/Ixr3n62IyIaCeDltBahi3yV009QN0X+iuzuFCL+Y7g9ff
IvAgyBly+Z3Itv2H9EJMZPMl17Sa7IkgjmWqzVXIKNMKn0iDVYsQw6ZgzQDYQ8N8IvTIEggU3/lh
6Nf0hV0ev3qOv/2P+4w0U766Ux3yLuzPJSI7bKm3/ip9NjhOytxOiKKqVXhKG8dzbbuS5u3EE/eq
q6YxkL7gpvNltVqqBnJB6vHSyWrD6+MqsCtR9A==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2022_10", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Q7Q4SSp70lxFryaopuic9VVP/Ire0pSsPEIMYdURBAczC7ShkuYeV02U7L3BlAiyBE4vBKcwYSQd
cWiaj8sVP7q4kxoRHKxLV1R5PIO6l4DsLWE2E+1MLyUPME0w5KTular/oX8EPCJ5n/8VCtW7x4Vf
dpeyki1/IAPJkAyi3zVZKHzgKhEwnZaZZtZYuMWoPZMt4V38sAcE42Raf+7yfFWG5HO74JY6iEnW
gJeRk58K+avB/XLF2/j2RQZfjTYizrprT2tUMBK6e7DRWZZtk8AOcsMhUikev44IFGNbNXjP8BXC
0J3y3P7pCFT6l+saU83nRwi/H25fSA34diJtNw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
a/8ooC+s+6nfvfa1+oBhsvYWLJjFgp83DI1kNyOi5Am+ugPbGRmgGZudfyo6yw6Yd5gGbLm5aToQ
5G4cGF5HaXD5TU6A0ZZFMTIbzFLE76JMjjIxX8JcaJIZpSmrXqlru8l5gDINUEAmwUY3mRQnjcGJ
0Z+kMRH8iAEF+gEviPiFZSBbJeOPqivIS217kimQJX3BeNbNPQTP+GUidcRywpGMh5avxtA0kDRO
F9SoCSyTm9hr2v9hsK1IUAYQLb7n2/R+z5YNKNzt1oN4qgJH1wZfdI8if2K8+ohyOdnxrrgJOWdj
cOqr7cGqEOYfBMTIQeHVZzb7NGWVN+9B8XSUaQ==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
FLPvOUNRWNW2GU+FEGmt2XWthOT5bY/31DRbol2cUmEGNF6b2XzpCosNKGx/o2n6sQvGP39KRFCs
nJu0ihe2dUGee9nEZZUcpwPjnEfXVI3yJaRVYy8iL+rm59lXq0jX4sjAPieDvv8shgAnoXLTZGlq
K+2c1JhaHt+nFi27TDrYar/+P8nP1MhocOS7BjzCvSs0foEXj92/qD+71Sm/LqGr8cjlH2qTJJ8B
ynxoH6iT+bksVA2VbtPT9o6h1kJ/zwP4wcsL9l+qSlJhd4GI11JPux26DlNyIi41WmufQcfiT0PB
r6O9+0E9lV9ODwKdjaxfZRK29rjKeq2yr0jWhMV38XKKqHAJli7MIypGRXcCo+u89H87KgYt+ebw
s3foIqCe0JKR57WzI8VD6XdNtOL8eBxK539oemx4vkE0cGYECZKYru6A2hPeZOYDD5eyWSUlQl1R
EciK49WM8HnssyRVcmE6di6bISMbVi0TZG/v98bz+9UZa8DtqMVYH0tz

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
fphquQOeFuqByo36Gh2C1zEC1J6u9swSMbMzsKldIvLm+SZ6/hr/N8KJ/G2vBABzX6UtbVuP1ZXx
AxdftP4Aqis1B3Bs6989aQG9eo0SOHA7r6aFLtFb3qoD5Pvqw4aVNU4z4EtTpFpn/jCWD21lKROf
q5X32HRfFq1jwqod+9vIbUNRRzz5y9VHvXfacZlxDazSPmcCF4hxB1KqWqT44KmYVkDedgkgnYgb
ZGidHnTb3W7C8tSqC9ac4kNJCL429QndtddweESJNlpX+65pt9Irok9pkOodwoj0QScswOIFjhBZ
/GrzZLQcFWiD3gXRU4DazzxQnGdRH4qEIRWziw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
1lUYYHPCt1BUJOvcBbgMU2GSQiqfxItz4ntieMaenjrtsE9SLwaU6xB0tBl8Atw5yP/RRNww1kX/
9uZbTz5He3r9mPVt+mGxB4N3f9BbCrQRb4USVPgKO/+vWUfMQERGklScy0+fz75WuxH74CjRUoDI
8iyssb2cUNnfDe13jIoI8gM1w4w/Pkxkmb6Mef53QMxacHAWEZeytcH3fuL/adO263D8P90U3XJv
vBXJmbjkRVi9qzjBzfMxuOy2KbZaZgR3BLzaffIfFnMwg/Rb8sGls5pQsZv5jL2wk3+Bj3OXBYdd
pDyjGoalJBzObKzd/t15kNHwY4FXYFcZLQPncw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YRmSEzaa2WFVvMH1BwWc1TIUpVbzSEIP0VbI6n0sEgct/X4PiTfMQmK1jBVCaISIzwBxscKQwZOt
mb/nmINGg6I7ih39LSbBMtx6cdCUiyaLkPeRbqfyPpKhvnUIFmdKVvTd1dYzxeOeuDnhSVaBaAcN
3lngSg7lIbmhLIGjC29yQrBTiLArbVZi6IRGronMK51e3UrYa6GspsznhiuRcXjEb4bHKrJ2CM5Z
BUwA+E9949sQgyOagFZbLVle2ESbwBaoxcAPn2gxfRHlT0leqyLgUGDZLsfArzGzw9BTGzyEG2TR
XOrKFNYRfMXMrnGsBM7acIelY4LdAMgsKgDH/A==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 18816)
`pragma protect data_block
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
R/2i8F5J
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
