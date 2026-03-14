// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Tue Mar 10 13:15:08 2026
// Host        : LAPTOP-KS0KAFEO running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/myodo/Desktop/Lenet_RTL/Lenet_vhdl/Lenet_vhdl.gen/sources_1/ip/blk_mem_c24_w/blk_mem_c24_w_sim_netlist.v
// Design      : blk_mem_c24_w
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_c24_w,blk_mem_gen_v8_4_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module blk_mem_c24_w
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
  (* C_INIT_FILE = "blk_mem_c24_w.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_c24_w.mif" *) 
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
  blk_mem_c24_w_blk_mem_gen_v8_4_6 U0
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
