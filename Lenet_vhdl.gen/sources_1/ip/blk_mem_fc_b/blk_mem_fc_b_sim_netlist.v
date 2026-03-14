// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Thu Feb 12 15:08:26 2026
// Host        : LAPTOP-KS0KAFEO running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/myodo/Desktop/Lenet_RTL/Lenet_vhdl/Lenet_vhdl.gen/sources_1/ip/blk_mem_fc_b/blk_mem_fc_b_sim_netlist.v
// Design      : blk_mem_fc_b
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_fc_b,blk_mem_gen_v8_4_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module blk_mem_fc_b
   (clka,
    ena,
    addra,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [3:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;

  wire [3:0]addra;
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
  wire [3:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "4" *) 
  (* C_ADDRB_WIDTH = "4" *) 
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
  (* C_INIT_FILE = "blk_mem_fc_b.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_fc_b.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "10" *) 
  (* C_READ_DEPTH_B = "10" *) 
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
  (* C_WRITE_DEPTH_A = "10" *) 
  (* C_WRITE_DEPTH_B = "10" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_fc_b_blk_mem_gen_v8_4_6 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0}),
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
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[3:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[3:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 18896)
`pragma protect data_block
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
NMLIeLCJOcexgAqdXCQfGhNrbaLWowebJnXZG30=
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
