// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Wed Feb 11 16:29:42 2026
// Host        : LAPTOP-KS0KAFEO running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/myodo/Desktop/Lenet_RTL/Lenet_vhdl/Lenet_vhdl.gen/sources_1/ip/blk_mem_c1_w/blk_mem_c1_w_sim_netlist.v
// Design      : blk_mem_c1_w
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_c1_w,blk_mem_gen_v8_4_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module blk_mem_c1_w
   (clka,
    ena,
    addra,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [6:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [7:0]douta;

  wire [6:0]addra;
  wire clka;
  wire [7:0]douta;
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
  wire [7:0]NLW_U0_doutb_UNCONNECTED;
  wire [6:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [6:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "7" *) 
  (* C_ADDRB_WIDTH = "7" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.3768 mW" *) 
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
  (* C_INIT_FILE = "blk_mem_c1_w.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_c1_w.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "75" *) 
  (* C_READ_DEPTH_B = "75" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "8" *) 
  (* C_READ_WIDTH_B = "8" *) 
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
  (* C_WRITE_DEPTH_A = "75" *) 
  (* C_WRITE_DEPTH_B = "75" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "8" *) 
  (* C_WRITE_WIDTH_B = "8" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_c1_w_blk_mem_gen_v8_4_6 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[7:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[6:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[6:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[7:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20096)
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
