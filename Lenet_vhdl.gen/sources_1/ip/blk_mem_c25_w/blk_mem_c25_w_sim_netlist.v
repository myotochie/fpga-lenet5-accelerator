// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Tue Mar 10 13:15:39 2026
// Host        : LAPTOP-KS0KAFEO running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/myodo/Desktop/Lenet_RTL/Lenet_vhdl/Lenet_vhdl.gen/sources_1/ip/blk_mem_c25_w/blk_mem_c25_w_sim_netlist.v
// Design      : blk_mem_c25_w
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_c25_w,blk_mem_gen_v8_4_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module blk_mem_c25_w
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
  (* C_INIT_FILE = "blk_mem_c25_w.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_c25_w.mif" *) 
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
  blk_mem_c25_w_blk_mem_gen_v8_4_6 U0
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
