// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Wed Feb 11 19:15:57 2026
// Host        : LAPTOP-KS0KAFEO running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/myodo/Desktop/Lenet_RTL/Lenet_vhdl/Lenet_vhdl.gen/sources_1/ip/blk_mem_c1_b/blk_mem_c1_b_sim_netlist.v
// Design      : blk_mem_c1_b
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_c1_b,blk_mem_gen_v8_4_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module blk_mem_c1_b
   (clka,
    ena,
    addra,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [1:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;

  wire [1:0]addra;
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
  wire [1:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "2" *) 
  (* C_ADDRB_WIDTH = "2" *) 
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
  (* C_INIT_FILE = "blk_mem_c1_b.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_c1_b.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "3" *) 
  (* C_READ_DEPTH_B = "3" *) 
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
  (* C_WRITE_DEPTH_A = "3" *) 
  (* C_WRITE_DEPTH_B = "3" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_c1_b_blk_mem_gen_v8_4_6 U0
       (.addra(addra),
        .addrb({1'b0,1'b0}),
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
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[1:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[1:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 18752)
`pragma protect data_block
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
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
