// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Tue Mar 10 13:10:09 2026
// Host        : LAPTOP-KS0KAFEO running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/myodo/Desktop/Lenet_RTL/Lenet_vhdl/Lenet_vhdl.gen/sources_1/ip/blk_mem_c23_w/blk_mem_c23_w_sim_netlist.v
// Design      : blk_mem_c23_w
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_c23_w,blk_mem_gen_v8_4_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module blk_mem_c23_w
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
  (* C_INIT_FILE = "blk_mem_c23_w.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_c23_w.mif" *) 
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
  blk_mem_c23_w_blk_mem_gen_v8_4_6 U0
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
