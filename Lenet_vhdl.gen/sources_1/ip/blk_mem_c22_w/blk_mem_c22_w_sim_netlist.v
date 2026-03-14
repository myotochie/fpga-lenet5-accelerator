// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Tue Mar 10 13:07:44 2026
// Host        : LAPTOP-KS0KAFEO running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/myodo/Desktop/Lenet_RTL/Lenet_vhdl/Lenet_vhdl.gen/sources_1/ip/blk_mem_c22_w/blk_mem_c22_w_sim_netlist.v
// Design      : blk_mem_c22_w
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_c22_w,blk_mem_gen_v8_4_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module blk_mem_c22_w
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
  (* C_INIT_FILE = "blk_mem_c22_w.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_c22_w.mif" *) 
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
  blk_mem_c22_w_blk_mem_gen_v8_4_6 U0
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
