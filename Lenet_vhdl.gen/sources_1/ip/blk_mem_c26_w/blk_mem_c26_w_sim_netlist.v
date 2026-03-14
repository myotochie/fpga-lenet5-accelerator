// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Tue Mar 10 13:16:14 2026
// Host        : LAPTOP-KS0KAFEO running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/myodo/Desktop/Lenet_RTL/Lenet_vhdl/Lenet_vhdl.gen/sources_1/ip/blk_mem_c26_w/blk_mem_c26_w_sim_netlist.v
// Design      : blk_mem_c26_w
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_c26_w,blk_mem_gen_v8_4_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module blk_mem_c26_w
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
  (* C_INIT_FILE = "blk_mem_c26_w.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_c26_w.mif" *) 
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
  blk_mem_c26_w_blk_mem_gen_v8_4_6 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20112)
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
