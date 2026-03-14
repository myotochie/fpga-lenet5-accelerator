// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Tue Mar 10 13:06:34 2026
// Host        : LAPTOP-KS0KAFEO running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/myodo/Desktop/Lenet_RTL/Lenet_vhdl/Lenet_vhdl.gen/sources_1/ip/blk_mem_c21_w/blk_mem_c21_w_sim_netlist.v
// Design      : blk_mem_c21_w
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_c21_w,blk_mem_gen_v8_4_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module blk_mem_c21_w
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
  (* C_INIT_FILE = "blk_mem_c21_w.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_c21_w.mif" *) 
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
  blk_mem_c21_w_blk_mem_gen_v8_4_6 U0
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
