// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Thu Feb 12 14:41:44 2026
// Host        : LAPTOP-KS0KAFEO running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/myodo/Desktop/Lenet_RTL/Lenet_vhdl/Lenet_vhdl.gen/sources_1/ip/blk_mem_fc_w/blk_mem_fc_w_sim_netlist.v
// Design      : blk_mem_fc_w
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_fc_w,blk_mem_gen_v8_4_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module blk_mem_fc_w
   (clka,
    ena,
    addra,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [10:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [7:0]douta;

  wire [10:0]addra;
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
  wire [10:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [10:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "11" *) 
  (* C_ADDRB_WIDTH = "11" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     1.2196 mW" *) 
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
  (* C_INIT_FILE = "blk_mem_fc_w.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_fc_w.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "1500" *) 
  (* C_READ_DEPTH_B = "1500" *) 
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
  (* C_WRITE_DEPTH_A = "1500" *) 
  (* C_WRITE_DEPTH_B = "1500" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "8" *) 
  (* C_WRITE_WIDTH_B = "8" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_fc_w_blk_mem_gen_v8_4_6 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[10:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[10:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 18000)
`pragma protect data_block
iwn2nq8RHmx9p1pNDrlVaqca8CS9oBWA95GG0mocqmsUxB3SeDM6fdzHGYAP3df5/wkK+Xgl/vqi
EhiwmNVs491/v93uCh7tS9Aa0Cn2QKkXmJeYzWl4QYHmL0xe4vtuPRPsWgiz8IXTqukqHi3FJwug
BvqUJB0eWCxbirMW882fjCLB/pVMhnHbiw5d4hGjRnfqBebFOAVue4aSX/NQ23rlhwmvWny+pKU8
gvVzkVXdMUo7qghNS2p7rjnmNDRt5ECUjc789HCLwiudIzr9tqYFDstGnTsrTE92yWsI96HessCI
twrXEiVNKeF24XnB2HYXCgfs3FNT51gqdhhnQVfk+S5wrq7U+veSc9niAKDWwQt+dy9+uAPGgE9H
QRnnb1cEaoUjioHueLFlihJUQ40JxKGf+Zg+Ul4BHmfNZHerTcxHVCPTEw8HzXYtUnMsZvtadiqn
+yARtVmfwqYCnx2awISFs0Y6xe/BK6SWAVTGVCFNTLRelWuHxl9grYTGg9W2LMcjIXIKB/cfUsZa
UQvikELH2Uw23i2uRWjEivQmlqjulrrsituQ+Pa+lGAPRG0+yU9LpTTIgF9B8sDQzDDli3FRZDM4
Mu1BfDWneUCuNwQS6GccRwLvleD/h01+WygonQTRGhtFOBIAnDUY7WJUm0moZN9WZ42YEwsn9MRT
Kt5kaxtAixxsLnfDZYOoWrkHtrhMxEM/SzvBV4HX0VD1vKDztF4Y2uMcZDxrZ+o5tnV1aBpyq3Fo
KLF0sGdgD8dzd8z0lIcb0fq+WNSdiFBzebRgvUrKi/0HTZCCXALpffrJ+tpMtPshhT9EPxeR+faj
DrMGfnBgzVOY3+hEsBfgewNNovmDyznMyE/FQo4l7X5ewqIr2kRGJHUsXB9jyshk1lLJ1iOFwfS6
1igOBTPdWTfuHO4K+BKKNX9HW45gqzub3NobFEJq34t/Iruk40REmwAnSquV+RxAtBwMRlakl8jM
yJJ/lOnMi12NLgeeM6I5UyS5/lyrKgA86DVEDF6MOeLCbMyNTOrAMmpd93pkZW7NNGd5QLQT6DKG
9oJ5r/BoZkx666UgP9SlhJvVOJFvc+csCYs2QaSuwDDl2iRFGSFQhLg3nHUtjLaiCcGWvPgB6t6o
oStvwjRDS5kFx9bFhvhL+hp7z9gUh7Qj/6E4+X4n2/oHjuYHwcOv7nGfJRyMrEw7nQ4ZMgDYwiGG
rCH8PoVGTIzM9RLOyXz9gLZWsD3i0l/C7rKaiaiq5N5qNkM3kIffz3yFVToRLdBN8TLd2vaW/m3h
fJliMIlk/r1J8tey40nAbMLZCO8MJzhAy27KU4MJYqzvN2WDIX7Jh9n7aWN6tLvSPHm5ttDWERtc
+PilmpOXWWjUe8JjYEjGB9XOBJ3R7qjS1n0YiZtObOhaNJrDHx4fBL3JF1ecPmyu3Aa4GDI2HKbe
CWnDINiierAU4vzalcJ+hOPtKigQj4f5ePnXX1dzKQiAhgtAbULrwIU2MU3MzwEj2RL60fZqm5UZ
oohLE8XwuDGLOAL2Cr+DETws4Qzx6jbugzLkb87rUUfhXmMTfkzzGDBhYN2sfi+kNr6ATnqwLsaN
E2SI6BiXJIf3qrU5dljtOlw9YvdaNphtCGG0BkqUzc60p9+sVQc7blVZSwbLrJYhzMmAoyFZh21g
eR8ElUx8DsiHgyjnkeEYvEWoVVw0qPuptz0i+H1etH6IeN/4wS2jW/zLNl3KuZcBIsxsH8QF44fD
iXVeFnnBu3AcS+ucb466XI3YYagx9cd/8GRoGunPRFU5M5yBN0kRtYPHhr1pXyxZ5zRjVBG5DuZM
V98o20Xv9IqSw/7X6Xwmtyh09dQ14B6liC4OVfCpQCtF/T/lqAjMQ1QA/qxFd3M8P5ztEM4pt2w/
/tvIcSM3EEaqCTsn9p3h1Vyib5wK50I3Uc6BmCk4xcPo+Woij0/mXbPmMF7TriUDtFz0a/chi2qb
KmPNNDrgR+ZeXjeTbPAWGyVcHNjtZAcpZ5392YGO1+FuRBynI6E/8Sflqj5eoJblezhkVG9w642x
wQNjUYBaHo6LZHlgEZLXrd4PxjDIB2Tp0l8X6sQJu6L5dQ8RZ3eanZgJ+172gebgKSww2TakJrbJ
WGkj0D/WM8r6RUztV3otEBD9zDw6CXCQ0/xPzBGZ5oSSLWh0U/ByYRJeZGUWsq/QCCFXFEBIFWN3
4GUn+geKLA6NVcAVXwIXH6RJkaPiyIyNJtRp/sXAc5xNjOKW8rJImCwFaQuVPqTBtkHLrc2CJGkh
nR6nOxTFVQhb187HFSnKyT5Lv5cz4lAQjph3oEywNAcbD8CrBjBoA03fi/XgmODVOQoAiCqsqz5/
T2dyE+axV/1IbL//7cnLG4UkoHnDTBHuXnK+XGkkBn4+fdLKeDK70NOqgYkk2eUQyxxwhXxWZQDy
A3RAT5XvWHmaz1ZLeOYeXaKpozTOwnVZMefmaSTfVyYjM7g6eIWn9CenrB2qMDZVxLTuCaD9Zevq
U07rDYldbsEBbgLnz4m6i6GMV9DW+yPGfoek5BfBjGnLOOWl7/x91qFKOAUO4nYZsdXq1xoMfz1R
R5ROQNqpYZwoboi4pHUQ/E70+m2IDPn/HPnqjoMUUK8V0/xDxe0CYeKAmFgYE6hJqNwYVSw22P17
zNabPMukdKbp0WavNlxxzmnUiYke5CZZY9orVnkUIthJ+QjEYtvt9ZS6YAL2u5Kvf11629TTUdEe
fy0QK8WS0QCd10Wq3eo1aNgkrfm457QtC6FH1fUFcAMKOS8Z0uufzmHCPjnVM8BS8AUtq9NSRVDB
tsfKL8RAU+GLika419FMQWAflx9KiuzuZkrcNWxpIZto5NrsojUr8hGbUnLqUuWd0mE+gjGprO1O
pSX6wCK31yvnNQTdKdWYDX8TurwSjr0xNjFginQLv6P6WT7uuMeAo+rHNslYvf+fpL/UC7dtK+W/
gWIkwCinqSFuXBsXIY+VekXw73u6/68UxUjBOdf5BdKIdAIm3e/gY48mdxCmIQrhyJprsbd69ly7
2Gn2VvogCTDla0aqFBQkPTrcUfR2TlngQjGi5ARsDmnLOwinDNzQrDgO57yfFJoYF1XMPlwYTk7r
YMlUnGDBBCw2I3/SWgmZBuMlZfrYzyYt6FpMOuh5zS8b5FAX9M3E8lkSfm5ReKjPDzik3yOkWLnh
NlEzHlHgneXHCvfNPJSmNv1iIfd6msCCeCpuiJk8bKMTQgCILMWUU/Qyl9DZpyPU77Airci3cLPf
v0v6nGu+1cvUMGJh96cYGjhvo8/7Mt3uRi15g8hD3c2wN6TuuQ4G5T+h4aPrgRtCr1ZObKn3fd2g
uPc6oClKTWs4gcd+8XSUFzOcUMCozC/2tHe45lkvJx2NDvWl6gS8wxTeUSjb3vgyKBYtvGOoKwlL
yoBHcHKl261Q2YififxJGoOoFJ14aNPidxcRi3rIn7ZlYn9nGGYt5Nq3L0jPqYjdTeyrepAtCyRz
T+PEuZ+akxEuovBGlBEnh+Rk/EwK9CksqkvJNUId6jQfNh0u+O7bJnKlY//yKayNcwl5WUmsXwp+
FuJzlutbSg3HAVt03LSIlj/A44eKi3coJYCgvfyHvClQl/IGVeP+2+y/TI8ofb23RHblOHjdSqUK
b+KOVsNlUSmFhUVexQgDFOHMoxeJO+Qz5o88Hy6hqSgrUDz3eXFCwj5+FVlJeO2UyGxVVLkto8WJ
D163rXXTTyBcA0FCLn6xPqmTzWdEtcRA+Lqli2WbfCrntarajbQCpfxovLsG6OwhrYRBKMasFN0x
aFyS2p2Pl1HXJ6saJ6We8S10yUdJVhCu0jQiA1r0zXkNEPf6k7SRygAFtysf1vC3c5pXELTVBQ5b
o1t/HbLdXbjGZbvj9Rm5dDT6cCzaFAFL4aEAcMnKCnRqbtM6ybCuCVo79EjN+HyE7+HOkw7cBWaf
N+KQ2iL3ac8LRL075X4ZtpPkImtwRxIaORKtwIxg9cdfr/k8nPWfOTE4/KUwPCWqvXL+r20g7f3a
EkTt2xdofSAs/GuV6DTT5yv/GehPkMfRpeFuh5vPtcDD/HQtA16GK63nKW6rjLUhSOAPsVE/uGvy
Dt6mJQ/3AEJCyyNzVRRWW8Rzb349dvekn9mt2fZ94l7SnCLj0b8TN4EIiH8yOHSSJ8zeHUesfLiT
uJahNXBWSkBn0BwpZz6bXm1a5+OOVuzvWhzWViac4zl2lv5JZDsRFAuDcZpHAyPt4p/cXJcomFRs
rNAIpCtKXfjx8hJ6VKlCXcaWND8KYyTkknk/4047sSPz9V9JyIcLsO4m1uuhgKLBEc3XtECkt4Vl
GjfzpQZwzvWnwcaWK6W1dmrRfzAETn0jAorLKlLe/YP+LJOWKvkZ1Zb0oVkkVEer7uZUcRpTHNj/
HFpFJ1dDyl6puxLDF77hsj3iAFViUtwLuwU8pN77QconC91xU9ntAN54uTb43btcHjbyoXeZPuQE
MajZY6v2t4lyXPVcDZ/Lg4LwAAGaiiJhKFhwjT+FEyMLF61K2XvVgeRFwWqj1rIblg9gXW6wOQgI
SlLGUAM/54gRNHYW6TJpZNFVqIcwhp0o3M/WJaEduGvBPL572aRJ7w2NLMGc5t8c9/n+/Bb8FPwG
PToYq3N11MSXagMyF3hhCzetPfux6mZm3lemMQVdHt7wgP18p02RzMjWOaSPLMESfpRSI6uq0m12
Za2p442/mul4p3BmxZbqjPSSIHrO52C0+CYFGJGdwpSiHrCHdNDrSt/lYGr3kqImzj/+H4bRw8kh
rqhzUrt+mgmG/flvC02Ydtm1TGkgErlvjzpfzgg3IxbGc1dT2Ip/k2P5r5xy+Q6U4IzK3I6v2dAg
YpvLXs6zQY8GJreo7I6HcrM9jZIEYfpkM7W3AomT+oi0HJMvegpx2cn+LYaWkIgSDHy3tgeIBqk3
5t81Rbwi9GLEzyI0iBFuGBHoKqQOJzmVX4uK8AjvB+K1hCwDbn7YKcCIUeXrJJdhMpsRjZeluy3q
6k0UAjQkkcqsG7Cq3BCpcAEXW1cHH3LplzilU9Wk5mW3EQneK8wyi8O9Jadmy60QfTnG5exR992j
RR3dzVU+KLIn6h5CzftKWoXRjf4vOS3jN1tNB0sf8plomxsfnaxkKh1EBTsxAJvs6umiI2NPdwpg
A9KQDsG4UkoVXJ/LhWAaZ6ITayNnujLxogcoxnMDC068huReAIT1McM4nmZW8cphdtbQGvLYEFz5
P3cMvW+79z6zGJO11J3rbai/Lcb/w2YTzb9HP/2Iuk0vjmWMEzk7BOjKEt8CgE+TUDzDBXsyEs1W
FTpNSS2F1DNF1UTWsYEzdMjUDJ/1y9rfdAoNuZn59fqFD1uN3BxRdSSswc4ktqj8PB6XTG5/8t8I
hkIZKkN4a11JY2Jy/D6Yo7pa6+WQr/I13a9JwmYSKCxz3ZEP0Z8oV39iL37SQ8ANtaWSRjEDMc8V
mRK5N82lAJm+aIc7fRwjlvLx8qiz7gLdoUz83N1UQ05sgPlffcF16hWEN8ieYMy7fnMd8iaUWOFZ
jey4LS2KKeZDTU0RaqqXxRJiq3q7o+/3LlQedMhgK11ruSypau6TZS5ic1CczsCU19Va920PacNv
o5D62sKyEFbceDgdW0xOjff4fqUvo8Qs25lMgohHRfXWyJ+MJh4KdB92Iry1m+pS2crBnDt9xLx3
yPNmwyaq1H+fDhf29QLiAHJCXp7HDJ/lcaLSW3tfs2hyZ3ytkUarFOSHrb/JHWw2LHULLq0ZwpDO
CallQwr90fvUYMW+qOGb1EvvTlpgo5oBC8Wg/2FxPewtAk/+WUgiYblpHDLWpQB6qb8MvYCybb+X
YVGB2o16XnpaWQQ/ymBVTy4iDT0APtz911zF9RpzPZj8LcKYlvX1IxkFgLtMgLiHOolk2WwAzA13
z2x34xgZIRUTEacXkicX9xQjnVydYIRY+fwJc/9N+SdQTNVsvMvNNTTvxRdNf3K94BZne5zdU3AL
M9xw95J3p5pBYi/EgP0euwLnoXmfhWQZGzT8fk5RfS0aH2v393vw09JRuORF6ndFcF4+5MjcRvmg
WpR4DwjDtY0O8fHTSI89odaitBxEtQfI5eQx3XLEpbtkhiADkkFROLuVGjuRVG9IP4o9/Eo+QHrV
w9VeyMMYNcleC1mPnyJ9Xxc5Mxy4O4/6+PpNLb2rngDWpq06oa0/8mbg8DPWjPoN5VlFhT1CpEni
6OGCP8yA4tpLfoA4nDoHMhu6SMFZTCcA+mcslY0Rsi0Vaptv/dyG9ZnId1r+QR6YgY9HUGbAEwlH
IiBmyRnYfnDHBLlAlk30kGwWFAsJuUlgFKDvRawUGd8RSqBH77M6Pcb82CvRislUYbVLyWzcO1AV
FZbtkOZkotatfPnsDUejJ/RNM8lbY4MusAE44DIJeOZrO3JzFEuPouRxjBsAcIVrA3D1avL+VmHH
lTMXfDQTZFv/WsQe7nJEp0rZj9AdYA2D9CfUCHEaK0Hj51i3wcHG837Jbs9udw1SB4IdfqAYglvR
YCnqoEMWCshHfOcZepzpar3A8gxTM9xMRn9oTuYEwXKnICQ7ZpV7fLVs4z0NNnymzqHHzSsnPhqO
saqCHT1vwMVPi5Azh+ohhEF/Ehi9f3e7XU0G3yLJzrKe1aKUXjzOlT/ExSkBNcFvHrq2i98B9nFH
VNni2hPMRndvOOFPTOnLAG0W4G3VlS3JTV0XBa7C2GZZBNZPGioWwIT55UXU1HdU8mqwWsuMBObJ
OkVEp27h1ALBe6+V8w+/HwbF8azEYs3aQZPbbU37jBvgIUxlEz2AXxAOZHv8ITCubIwyhyW81m1t
t+uBE37PfCXjKkuIPkWFeBBPL/7XyHNMNaDBDE0fCpLq9pNfUqrHbHkuMWS7yg6w8IxJu/9WpTDS
VYnvXr3OqrLFYILL9Wp1YnLlREZTeDwcYRvPQEFwJ0F3vwzUe3k839lr2dEgzA0iekM/xKlzFmUX
36dI5lYEAb32IC2zj3E58lWsaCmTgaIb8sby/2MpNBBu6GU6gKT22mmy84Yk9lMPsFBkTwpVMLi0
aCOvCytXil8ltT0Uv9UIaJsdwODpo8qaLuVGRlPFx/yNuJxShOO2QQnb+xuKZFKCc/AiiGxdsri1
nnyyN1hFpKiJBG6ludNPQNCFuyUVQQaHCxjAeCCdqVLBz327kergwiK7L6/O8Z157Uzc8mQMH3Bn
irQ4N+QvWB+ZCJOQ7oq3mzcAw8GrvKgU2bTkiqwrWabstw3X8pldpWAb2ODqqaNwaCFxZ6kJdDT4
W1qJCSYyNF9d6ra079YuUlX7hhFCW1vFX0F2ZIsd+jo3oPVX3vkxWG4j9Hd8CqYFf/se7uSR3uhF
Tfk481TiU5UsX6PNuqNAt+EqPyNjmwfzuoTQg4QCIubrjn+4zDgqNQIFdeF9vMuuO2t1/UToAdK8
tBX1cbc3KrcQ6e6/qB9EtNOs3xEkJgy+G6+dXnb4IgWDUryr9o7yBfMcKmmBZVQ/OWBs3cBj9SvC
akmWrtRlQeDMOBZnUQX5ItgrqlA7QizW3rAdPPOH5gH154sHfE5/agbcsuWLBSPy6aYwOve2zyMW
XIguwlHO9NwEPifPZ5yyho8+Mz/FiGJULoDxwaaBbNUxHBEssTY64nKrO2Y//hfX2u/pbhGz/AaZ
+RQqHM95AK7B5FKYDFjTVUxun8G6Xouo3g/vometaKJ7Fox90bQzy9lBts++RieiTtlW2I2OxfK2
+qFEM7V9lp0l+tdz8rQRxNsVD827/2s5vxXokc+rfcYAeNjJRTjcx7Xhi92Ng9i7EaFTDmT3u/i2
/dWi2PKj1uSjsllH+vJd6ouQ7/ZZG6vzwivyDGsEx4OjjHVNmiZO3tVhuKY71uazMdkZIwCFn2vb
Mg5YKw3IZkbj3udHMvei9KEU031R4vhg6BxfC4cvXYUpa1RGanNbZPR454TturHE48Bg9r2B9mSa
nUAY+XyAdP+Equ5UBCbhJXAC0q7q2U0cX0vt4ZrjCI8QsLsMcaSoexQ0pEJW1ybdgUnUJfugyVWc
DWs04FK6FNG/FWj5l3cJ49DC+iEyQJkbWQ2cgmLKoaILlwkxdb4tEaEWaNFF7WxdaXikBHRiUPDB
wq61HlYi19UCfFGlkBnI//F5qSnCpJO5n8VRLONLWzPIRbAyZeXUVrJkpGsFIhBNYTWA42BXGdLS
d0wKqw1fHvgmk0YQQYmr43cAlbBKin5rcucS/ac3hr93QW8LZYNTDhZMqmAcuLYe+pxgkAkPkvgO
ZVtIKqKnBZ8ZuXRtKlUHoW1nVTDHtot0KY5wFbxWEHS0WvwZO1J/hB0o4sQVGq0HrhgtCGQwy8rA
OW9xAa9JB2EjFTj+4/YQUY7wuckEAfO07XUPfw3C35AR9Qk0WJA0o6oJ55/fHMArLYGigvo/Zegx
E+N3WOt0AESzfaA+V7q1kQWt2iQOS2EQFEiuIfsZsJOkJdDq0MCisUnLJhvWp0axOghu0EvZ8D7U
0T+UF8SquWAe0pbSyQYUGjGiD+edDjziHDOJMPoLF0qdz5pJTyUUISUT+9gNS8bH6AWiz821dkTE
1sjtSR+uhBPwrIAON1mMO2wmob9YXsCe8PPzzl2qS7mlSkL1v0zQ6Repg+8KxrtSVAFbQcRUFHIP
js4sCTGlPh0zcmlMPrWDUfIqLMSSrvQWh8F73Wn6IdPwSUHFpIa9nCYkGfu5qFkTJpaKGHISdIZN
omYPNyYQQ8kdy7Eui/W++dji4d+UWRBOHOdpIhN0rt1DKYEdUZZmK0VjqqZNcITI2EDU+YN44oGT
LtLs+zUFs6P1o45LTNrJdBuA+EDsMVZBb/x7h0W8tqmipHorh1pOVzAzM4NIel8lfzsLAzMxf47V
s8xGu5TFPq45ybjQ+2mUF9qNxdqgH+0leeH2xwS1XbD4yEKVW+e/wB7kQQpiC16YTAFf9IpVYIcc
cNA6qpr9vEFc8EyWR+halXLeAxhqa4Ag4ucsOZ51GG1KBv9wdfde+VgGJcr7oHQtbQHAY7V29aD2
zWspVkGLMIH3mDOJKMbAa4mp0g3faK90dKgPusmTAC5sq7t+TxD++6uI8etiyUMT7HOmzFffMIE2
PScA82/bz3sMi2YTZlSbTrj1vGGU+14wJukJ5Ha4HtiEG5fRfSTwobn0k8N/1LzAH4lPQEsYtu2P
PA1CF/x6FTOMaSUqmeIcy/LLhBO8PJk+xh8eAwU5M/5CUYiAWvQz3jsz6A0ibMvFmZicRBAgJ2mK
gOyryHobiFF8j5aTD6SKavrPjX5tQLQT+1MQyiG98paZ5YqDwbnoAg0PR50r86CvEoAfo0fwyd0j
d0taf0pnND2aA56oRXf8A0SJnwS9aenubxc0bLVCMf7EtgTeFIU5P02w8Eg2QVJkiwKw8nAT0PMA
0alkBg6cJOKXj43zE4oXx1KU36gkYCUlnnvN/0uAuKYeO4HcfRQca9mA29nLoJgpWrHHxoKgLP8i
5IkBlVhFXtYTA+03hg/XwFc7Gt4dOMGOEURYN0f8dXKMpgU//FvbeqRfWXPEePsgU/rpXUax052X
TNvUTOv1/U3O0WR4HckIPW3WgyfRFRfRtZn6YeJNuXWYSrOGg9QkQcoY12Cors+1GuEIytMyfPEp
N/qs/3cNagMHh3lNlv1bosZvei9jUb29xxtvfjzsK6DQ5AI7rnW39PjsTuJ6hbQYbLklWAPCRIv3
8L+j8u9ai1r0DSubmNiaVAX+3OXvLrjWriKY6CDR9oqobm+rpZT1yTVQMZ1q2KRrBQm728zPMY3V
MzlYNYMFHK3deyGUXcI3HsnMQTyEvjrmXEOqVAmQFtebrkt5THXYHrUsH26fUEkLOnLmAYVwg9zL
e6qn0+tGtWW22pqj33jmhbxaQmmFbY1LcikZ9Tfo8zYszkvs0xNq0NVJHB8QxRBkOMRneaLBRqpY
JA34DGnAv/aIK5dVuhftMplNsV6L15QN0Hm7Pk9YaRjrewrmvwj4SAFAK2n4JRm2wsqOQN2jBOfz
al/ko8kZP8E147F6oqRkfuvOkSFQxKfMYUUq82fzXzP873JSNPHNhfiyYOpVT1RQHI+CPuJx8u+W
w4t5f8GivaRrGPcbvtFRTMm5LZVB5CwMUpyNbgLwiAfErnN/MV8KUkITJP98PGhrmf+89YHPih3r
fdJu3ww5FPMhPXxA+oiEti1afTCo2c6XcMcJdkW1do8vFT+SUTTQ8V5U5Ls8PzK4dP8vE8eKZRwe
suh7v/n78H+YdCT4cxX7MjBQvMaJNTvolY3xZSf/3TEIK1teFaUxBsLHq/B/hQW/qeIz3DH/cnTY
WIM6zMvaDZCmQG4p4v4YO7kR65IOY2ATuNsHbTFuxw7DW8AlRDcvwfWIlG8YDeSlclo10PCv2/DZ
+/ORqioXixGXDwZ8GxirKNQx39exECFhzlCzKj1ru21nQGjusLJDaxV5QB9/QwUXP4steSWkLTHM
1zPy6rmY6O8xC0dUjCVpJvUmQhT9uo55MSJ+DYAHjpuCpfRiDAhC12vPPrjBkbY3KiDvYKLwLE5G
rPXjs0iYMmLybQNE0gDRidfElh0N4H9XbZ6w67TKINtUiFmDcX4LjoILQ20S+adfyzLfNqX3tLnf
zy/jOwEznRboiJyjDjKjOPtsZB8FJ081BzEQaR60CgG5xLeWTyHBEOPQ14+Kt6HNd+qsaUVDQGpU
R1+2bg2MB7tK6ayRsick7EqzhEzLH1e1qNfaEpjZuk/Tc/uguTjzmbZnpdj/1JZRAbozwUhDIZ1v
R2NFvcWgc3oSwoNbzV9fF4NJPPbY0jFz/BW410NIxLmSSQufqf3gqMMFyzDrahDbWjG0xEexZFPd
6Q2hvLGpCDbSNKoKnUmeuAftNuNCPZ//Duiz8IKZ5JMltWfuVI3mT5ZwgVoDWj7pNeB1GyDPBfDS
BbPZH/JafVdFfs4ydggNvSsiQ/uyFLqDrxqByn6Gr/3sjkdIaLDg/eILg256udQ3+K6eJyu+BAPr
MWabWq2Lu/bpxQDlmv3xgmDlCNZvvfPXYKAHGxcCQG53srMUwsGMj35s2ZvUkFwf52nbq1m3q9+c
YBeOsh9ozM+bf4Xa6SapHDMbYRT4t+H3zcuxrr2n0le79nPwJA7pLIQ7A2e1M/LpKswyNxTqxS4I
VquFw3IpQtW/9ajemHfQZ0MCR6YWPnqWGM5twZPMnbKVAyOorVxt60AfzhNJNEJNcfvZPGx0tSru
fhdp/RM5Yys7dTJE7jia0NBwVidRuk9HiGlJJ19Taw6EjOxC1MXv25h6BfnS2220IQTAQ4fr/9SR
IpFQEyryeb9XZbDsNBtgAVHlBIf4+jzD6faqntYTgl2Y1wPMa4i+pqOar8hQQXc2qXN2ctagkUCA
N5Ea/EYtdWq1UAZ9Wq6k3RCs7Ykvedh9ldmesEyYtcQ1oLv1O981/pG7qSpGWrPcSULJg0QGPMc3
TQnxwZX8NZK8JJHtdjzUV9YDV/ccpHmt9g52jN3TRDR8IBa6EbUQPepHnD3o69HhBLvXDMZx/7An
GptLnQr/QUN/zcafOaIH0/9l5fDPcI1/yac8gBM+RaO02ZjbnckPl8RwHoi7ooNW+9YBt19IVpqq
aFAUNMTJpsdQEaxOeO/viXB5CV6dKvuUWf7xMSX9sss3DO6hpdznHQBu8A7oDclwRkt0U5wU4hlK
1jIY78lWn67ZlN9eupxdk96WhhvlagXs5Cfm2zSBSfd8efZF61L3UeQKJgLbvyHu1R+ve1MXAaIb
wWqGp1q70dXmHXFtcJs59wk5cqfXwNHS6K3vole2rnlD0HlaTSzm2ZCH6gurrAZ4s/rPb5IZFitF
B0dwbor1PQYV6pJs9SRGHxQLECCklmghJ0bvhai4pK4XNRaECTpon2fczmVs1/KyxUaKz+RbB1bQ
oS3uS8o9eR/99C0tri7Lkr3nAsjsbTqpJ195JrmcJKWTFEPLNJcywUyFKqjbjlG1Won6jHI5r+1S
Go7k60y748UDINAiY42kl9ShRDznG/LN5XL5UzD1DyrJcmNpfF7FuzabKrqT2VC0O+9KICpow3Qv
o+YL7wS5V2nMAzs1h7LhQQk918FFFF+UitVB1ISpXrjPGFYIZI9DfusL3P7LXnVj4JUmb41dsWvc
Ceq9PloGlGiQjRutSopTgZR21xy7VN4D8YzWPX5qo+Q1QYsh+AvTK2rjwj7LYpjQGVQObgbXhQeM
Y7ehIhf8CwmMPFY7jwB58y8jhSEj+v1rMDmEh7TchxwqjXTubp7IUgS9hySqA+BSkxn57DKZoEbY
zVGA8O+bHaXyKVkctpe0BmWqQXzSH1rpgjrx3FmEAJkiE4LN5SJaHE825NSVL6meb4V5+xDoewk9
qKbIBoUiR3w8/j6k3+oy08fkJ9BWWOlpIoHIgZb0N+L/NTKfFJ+PDoNtzY9F2BwgY0FPxplWlo8z
S2CAhIhQuxhCX27VWw4rPsYhS42axM2RIAMBLdiFooEDfn3z13OyPXW/tS54jT5MYrnrcOe5Dv6N
zd+wTSXH93Bn9VaFwgWFP6MWcw9afErzT106hDLi8Nwqa6T/Euog5in/0d0CXR3bfPdaaYlQS87q
CrDDsGsUYLZV3pPdv6opbO3EdNQ3NjQRE27wB+q1+IHyBIoyKE/wOTaUGhGEIj6Sg81P6IrM2fVi
sIxA6DDhH9bqtWpT3hAo/ns7pSQyC4e+st1gEKR8OHWu9fe1FB15Zmf94+pDcOCO0ZjyZ1q4SpfS
+oNEfks8zTQ9ZdONsYtEXAwmCGwdTeqfPF1XLtM81qoB30A3BKQy+d45gLhFCsORQAC6+OONalai
OV3v5CuB98Hj6BQ00Oen5mHbs14vlXwHOsvr2K+EXDeeUbyDkOsBKCCIqMMaBoXKqC8Tzs1R7Mq/
JYmVSCKYm3TiyemEJOiL0DvXJQSRrzLOlqt1t0TCZZE80+eYI09w5RMTB6FeancRVCEsDaiqAvFs
47jaHDWjFdHk9EN8FpR4hr+cTU1/fVx8du1i6abAZSA1SB/ONi6EEfna/jTKPS7SL7+1SAbfc2x0
FGTijn4KPYuUVU0DxCoemrCj2zJfeQwLwQevraWhIZHtbfnPfhjqteYXXzZve/ZeHuXOaAcQEtNX
HgvFBoBaDX/GZu/64Njn5TmqXgN7R+wjdbYUVwVeT8AsX1X1O2XQBUXZpvw2I+DKiM4lZD5igaAL
mUIsUqIjjXyrw9mok4keAhFzUvuRzHBDoJbhrcqr8rFaQkF6BSHDydgdTOq1fiZnniLHyoLT2EBM
XphuNypQJ+c4tjlOJK89NOHWbg+ZLxtyFex/q0ARWZqauAKelLYQK1ZqyQdDOmxA9Gvx4Rcbi3nA
rOiBDMMjD+JYKIMcoCtfLPZ1Q87HV1DqYqQmX7L7hMb30JBgZC2dm5qXllho36EnwlHkOGS1r+k5
RPMjDDhqRCoxXnZErrFl4U5rFa8jD6/Q/H12Fne/ZnNTpDGr891aSFQC/6Cjp/nQbrIA22wEzrKT
GWBPM4i9W7IrKMIcsC0aFT0mQ59F55zvr2ZyHrzWx1zIn2oGKE+dSXY/2fplOT8xlhjEN+A40w0K
+dgRnWH0tO0ns4UONQaFZoosm+wvePQkFU2yjG7PwyP6GriaBUKOrNa17fF9vxi3e5/a2dC51Vu8
e1ctq12J6pEiESmWzrP/wEwm7ypIXSE6fjYCl2uYNwgwsMBa/asU4Tv/kHHW18bC5VNLJeCwDIrg
fwZe8dLGO8W3l5K8bvDsv5/7Ib82RWt3rJ7jGj8YzxT1KrbxUCc5rbYsZXmTBT8JlQKk03TKEE1r
eOQuXtJau5dfdysefLqFay9bBugEaMGqS/E1RIlhR9A+Hv9Fe4EFultzSw3dmcev2XhzF9xKWZDl
1GD6pBN/vyuWqIBOhYAT60tm/0kqqMdaYBQoaXQSArRJJXURVsWciDvcPB0TfOzTn3BFNRyEaqle
sKU2RLGSH0d94VuNVz2d674UymjNyoeRV/VaDH3xrLE0cF7TwpMrB6/Vey0boCzIYAmNAZGYTsc9
2RlOSho2ChHA+lM+IIo7jll1RAC60bt/jkp6RYfZxUCWsPnP5UIAB+KoioXC8uZ/HhdDsQi96q0q
DR/rk0F+rQewEpY0Z1Tte4kaaeqBPlzkyldLU/QwEA8JP3PmT777gjA06bapdjEKCt+17xLbHKtf
fhVznlyf8H35eHA1cmc1CRReiGHNnIRd40sK1D0Ty+D1qqFn+YQuE79VOFpY/pgQLIXRR+yn1U8A
tCvbGrbOK9uYIP1N/rMzMPiRJYjk9FdSv/db1BRbLRCkcOwWLmeKkqf4TVzYlLKWOrxSsd1fUfqY
zcgnueyZqsefINIMcQyo0lRXmxvRlt/S+R0Wv2eJcNORk/XLDHH7WAUWLBHRbtqQ66kl+noWBFPS
8qmhNNl3Uae+12xOU9iPeoaGx6TeLvR2d1GtCFbFPWi9+3b2Til8ln57xswHFMUariNwmiHWygY/
KXtgz3cesHKzjzxyq11VTuOE0mAu43yzP2yqgn9YWfCrw/sF5kc+VoWBWx+cMS20sOjtQ4lq6+yQ
x06Mpa9FJY2ptXeub34FicqtC8aw5i+5/zb4geA4VEhGf9GfUTss95opqXtVERxRekHYphI6Of8s
EkLvW4cmG0gNg1UhWeEB/ee4oYxnVPRo7Ix3gOu8WsvBaebjFN3RLShOzjVm9d3mUU/Q1dv9dIsX
kA0Mv36MInmtlwAx4qKwCjs34Y70HnpMsEossr9b6ITtCBiLWPKTBBswVdxHrs+DG5UsDAhLHK6B
ffQ7useOARHXSwibCg5lL4PxmGo18Bc6qJuuJcXupbg5VJhXzxkbJ532iixpFqqLuG3LM1clWmqj
0p6vOolTDSXHSRsQKZYWa8GT9ESZblFd1DqrpV2bAYQWcjRId+Z8kQINWeK/fLfgj3lXUwlD+ajL
9NXULd+uclyFZFvjZ+0jgtrqVdX2OOxzu2AiYliKERNTgo4oWf6FtH1np+LTBB3U3dcQD9Pia7+O
SabkYUNJN9uc8HS14bAz0F7W3XGwkQUdecPiD08rwHnuJ8ni5apj/OjN/d0gv47Y72+B1h/XCcj/
mJpdawuMRQBi0DGv5yKXAbCDTdD5uVCMy6q+3RaHIh1d4XA1/7a439WMqNJmgSKapoGJe+NFkFQt
DCRwaTGPE96igG3mUYl1/mVYbi1ITRwe2QIb4QGiU9ESaFEatL0yMio/X7OceaVRyJxQm2iBqZKk
OVGNI/MTo93VXMDB+N4W2bivAXhPhHb+193igPFPmeL7pPeqCrYqf5dATYA7CA7mWwupQxy6Jbzk
X3kLtT0cZ3joxvIYHg1gvTPINzk7YOBCrfWMRZU1ua0OXKACCu9SStQ/PeM4zh81nd7bk7CCthNF
QwlseXLWwPGHJs5NuqB9uPqTvVHlnEHzouWFliI2ePcS3B8/bYHTdJY1kWxbGMTYfJs2dkYQAl9u
jN1w9Vn1U2xNnodvkp+B5b+h54aCzb00mQpYQ6s5TO1Vcc9g0T/x3iBmIGIX3iNv4atcfkv6U4VJ
5WCJzK+Ei6PbyRf5xg22fV+RFBZGo+KBQx7T1mJx5NQSgWWS21bHTbngtTW5qFYRHJvpd5OxjE/u
+l916Rj9AxhTBTO7HbXNopFC/CYnShioPIW7NMoRZcKkp6r+fqZRd1bWNnXUvvrHHbNxHqAK+eMT
pZ5wdYpV4xGga6meGNqKzotfEoh+1W5aD8WYHHCYSKpem1KA9EQXyJ0mD6I6dxFxxjvo8l7PF9NA
10gjg27/5eVxgFJwholNmjE5eZHidj6SiGla8NX0MA9hQPoYTb5HturNourkVynzwhQGujspD6BM
thslGHi9aXFDGjdyGKhcRVmxFqs0GKASMR6xBxmRMu9PjrTrcWRQtZZmPMPoUNhc9pxkeSv1wG5V
zCNOAx2VaZLEDF/rcz/UyCg+K39LGG8Mcx1ay6Zswr3NNPBT/+eNKw1d3xzTuKeY76npYqrw3e4j
Dw35860qolytSZ23mOuvzs/zvhGw4cOgcddoCYtILoijneZ5rI2AaJg03iDNkSaaU1xYol/lTQN2
Vs+zQO8VxtWhnUWvFYJ/zyDpSH6giNs3AHL7okBrihluF5UaZDHRQEV4gZMP8jM09LHQ+AqSKQFA
hasei9DHMnKdVVfl2z1p8RzSkNMHzyLLP7/qfkK0azwIgL/C4SnrZ0nvhiijcBG/hTogX/TUXoa2
+2NkdhkGj2AwP6cZItK+aXJGWHOtw0ncB0VnYAx61RvVZf/9jbACFfWUNQxvOefxFcdQefM3f2xe
rFWUmRW6Ha1oXKexxyTq52tNI7Z3pSCQdSLJ0SvapU4sXQ9fpyFvScn91ZySilnbe1T/AMmcxsE4
22lC4I5iKhkqYRP3vyRZaICaKmhLSKCVhCgC9Yw3hM6dQGP94bWwWvGmvMu9Ol8HS3CiVzkUcInh
CvTQbY4D3S9QtKmsbDCqjYXa5A9p5R0FkwLT49FSMTu/TJGRX4BTVTot2mvm2L6i1SHl6Gl1NJUV
LntOkw8luJ6eZvx+pY4yxmRui7zvYMq68N6vOYhv/c/tdWIJg91AcbKpAvGKnuaAX1FNLoHdSApG
fiMwWcaQP15YhRTORdFd4fptjuR0WicTTMYNbIm2CkVPTJMXvPIpkekf+w17grW2FJjze5ZsKYc0
TmAE4e1m7LAq6aTzVfYUYCLIxDChvZdPNOc4t4bP65OTANsjg6yaEQ39gmPq483uP+/hWjnawGQg
04COB73CCQrEeovrRL5ERtmWhblm1OTqa7DIQRwdyRv2DYlSp4hcR2JCLI4XF87eYwvqjAbbupWi
5HngXQXFLVkRy4mt/EonIhJpIr82sZPEPsfMyPyTHwGDArs36yxhDmDze429hq06Sag1U1lLm/27
5nDzH9ubH8nOSRpznGeKMqcmTVzMbcGNtENTseAf8kIfcvtGy5XA3Pe64u1sXSs2uCxh0Vhlxa1w
HNrn/wwl6kyI4v+e9omB7DozpoIE4PGCg2QSX0YuVXQlW52Prc+QruuImBGE/Ebufhv2dl32zazJ
EdRkPxpDxuvsQ4knPhg5XGSCrRQfaPd9mE2wKWyuaxJ1yTcRXcvEN6U00LVeM1OAThOPaWtyU6zu
e0DBrSGwY32nPsqfXWgXsEwTCBrBZXPwiGBflISX7IyzI9t/IOjpvBVrc2y1CARQpES/IgklBOf4
MBTRJHjHEH4V+aFwUBG/x/j6v9L7zZw8213g7PgoJxHNHxAJmOhv2srr9Q8L1gsgo/jMRLgO41tc
7azCWlEpAIP5K6Isyed/6Pw6VsKYylqITFw4r2CepwG+g9obMG2yrjnz3YCkSA4L4Dacj5BBX5SV
dFRWyv8tbWXfuYCbAW3JFysO64WMrUQfJuUVut8vlszYrrntzyG8YHD1KHYanUzpfnYG0QXFVZvi
yRtfKGAR+HLrtFb/q6AZkDHn+heuaNL+4u1/e3lhyCgybHKe0vX+08IdW8uUkBwR9yQv4u3kP59D
soQMoPE7c1ah0OKivaelIEmZDS9rBuhon+ARzWrZmmOGIk72G1IN5nezVt+ehowHk4oNXMsHYdEa
6SAX3uc9xXzFJOVyjHwhc8bY2mv4rEJZYvFzLTilIRCNJoH/05b/ImW6LTBSd5dxUdQ3ryK6iRAC
PzYoM8uYduTD2iEBPwjlwQobbnBfCSKdsdypNlpG4d5znEOdCL7XBzKUJ6q/XU1JHjvU9MtyD7Pn
vkocKhqMJ5cRs+vzS1pic+eT9me7dWUtXXEUhXfZ2ZKwcqgi8/Yeqv5HotqOAnBASWYe1yYNoJnn
nKjOmFuY5HTi3UnXhzIJn02pTR/yIXGPeAJok9+28cNE736G2oftm0tUe8krsL6TXBkDnBMG8FEc
8vHE7TWAiJnFmV1U/XrHXWJdfdXS5oTyueFxrXuO5HqnTDgbuVcikBlYOA2+hxsDqaHxHoiLE/1b
COGsSRkzG0BzPRbZqNCcYYDrLbnyu4rwbvg1ZwPikksLihKA+mG4MYFfnw3eMWpT0UWz8P6ovj5D
H4RLPI41Iy8w1c5Z4BZHLtB463uOYIldPvxkeic64Vzxhu/B3k/gXJoFZ7o4CHlfkvJAFuOLN7uh
GHAeTtmYzWC4zv9gIXepY5MxFlK2RfbKnmR+XKceR/z+VX9mROs3rsPFGnMrnrS13Bzx+JRYV4CP
MSI67/sjukiSyKqIbk/rg+d4Able3LTC+bFhJ49OmFTXL9snb/yFZXOuaUvPzh1Z5IKKkcOz4q1s
acEqsJR/txJQ6QnZxrF+etaejJ1e6HAVp25lN5jCMMeMTObaynwPIrHeQUO2fCMDFTGZlwHlSkRS
07Aq/zs0nHDRf6d52uwGoT3lZ/Un7U6Wm88BnIaQFCrbA1Iy8hcRw0Vg77pYOyxMzuiZXEzu+YVT
2jqs10iMqBj45H2nhdaq7nTk2qvlcetJ+LwE2knzhhJPT38ASM8XcNjfuE++BUZo7wxO92CY81dp
TGUQx+eKrwgH9sOCTUR82r0K2UitxnoazDTEvB+CBhT8n3pAvFWU8eQfxZFRQPDBTfxPcYp6NG5H
sZqzC+U/lPoGEFJ1/BVzbf9J5XYaBOqEv6uUwIGKXnWQj10joQ1wisKwme9UXDWFy9KGZoKo+mrQ
bYLb6KSKfhgc/JdMpQPuAHL9Ox8F5SVPGpQWpfWwYrJgySwA81d3PoSgiCtydMxTCz8b5Krr+vrz
SYPob3/Z8jZvE4Rby2tWAoGWojP0+IQ0nCk51TVfWfiP+1WoIif7D8GSlqek5sDTb9KcET5TKr15
xL8LwPT+1jSOwKgl0yyLPQCuhJ524kD/xK9j5i7BKWcKomCc1nXsf8RRPAiQJR9vy1M6G1SGWp0q
jzm43vHMeC/nQGQmp/FajDamg2wEn4pBUQbeIW5zmIbC9cvtI5zhbjNtCXO0PMzC5SMtNr9CKGsc
7udb6dISIUcLTrvchHSFQ6JsKzQpqPWD93gfWJHLTLDSXSCFWcVU+D3Xw7FSFzTUa/573HPfLNNE
XkucRkSjCmxkA0mNiLR/kzwwo4T9BU1vXmznL7hch3oakDwe8Mb9PKppkwkXOEIki/BI+kbjISBu
w2pdbFAeRm4EX/DXLrjgINmpd+8OyNie8IlkCzNjPT2K08caQgziXqcfTJkrvFmcWjQHBEMtGnlH
qqIysQoaTzgYyrRLjOejaB92hCc9V6nIjfdH+2qREf5fp1FLEo7nwC7ZXB0IesZHhgj3xy9Os3Ul
Ohy4ZCr1tUW1IhEueMQLdNyxALTmlSU+ICkSKFEWWg5J64mCc0cYUHTxoXrDzOB+kuLbVbE2eAmX
UUHdSYYeCgwqSLg5f2eusba60Ovo7P/4ATK8zahzOE0nwFZJIjggM8/jpxd2Z/ExgzU+mFbEhg9D
ROVK+XudGpkm75YvAsYdCXVa8A6t4hpTJXOPIg9T7CiCkAfNwwrgie9QJy9Lw8HSXIryvXg8eioj
HU8K06I8UogrFpWpBqbKaQ8XonzR2RUBxQScmuXgASl50zteVy1s6FZibSmnb5VOVy70dU8sEIwG
wo1xwWHXRvHT+MAq/GlPPIgvFszkvgZ4CCa6c2VFRKX5/dhsd8Nsph060ONiNAXNykz7BvETTq+K
Bf15UI9UgJEMUvbm3CAkCO8VpiTXZVKm/eSw6eNDTmIWhWZOAUPpDHxaXzEXTYb8GTzPfFGmbh7/
ev3SMswX6+Wb/7n5xFS8ajS0Sm3aUqkxfbLcHBMkEFZPXqZj8QIftCCUMn9CjRCiE6+i5xF/vzHL
GC+94b0vat+3Tbesn0kZqJAz1pwtmHb7xQkQAWMbuQUh33GRYtxovices+QLWixyyiMaI1KumOLj
//BpXfNutNzw55cJSVkCClu5iKZmMmFH6bhwKL5iXCk/I/dlE9D6QRiAp71g9pFzFCmXH3LhbjyG
ClaZ8KOj8iVwi12fUwneKTtEl3p2r/y2RsMjlMorowRfLfMfXWttiJpjUNilpcGH0+kD37UQIMVe
YAqDi6o87WUZHbk/8mKtegqC76dbRvI62YiBGwPZLU+1z7baps8cmFIOoXj0SV/HZXenk5KVAscd
Bita9PHiXw1spp+j5UqZnXii9rF6xGhHaanIIDoDZGL3lBeIPdp6pU9czZ9XdValwUctFxXtTfJf
NCb63Yr2vfXblWAiu5bQsuUSj4/MW2t+VosP4GhVO0HMmyxWC1PUD5Y+liPhbyXJPYn1g6YEmJSJ
xYI0H7thCTvgVF6XxnpTJ0UaCPTRhDwuiAsQvbWMQ9I8GAgyRIQNaPac+wy10Z9RUkj7VJkj6ZOh
xZy+v5jbOkLmvASNOFSHHXn+d8C0RlU8Gv6AH5uyfZ5RD3CCjoIOTaaaLCGwA2NPDIv6qlXWV4dL
0dwFgMve/8HgrTdfaqHDKcy6M9/MCqvQVWDpranIOCVQCfAQTGaJUs2WtrVkQQqpBuAVFNiemdQl
KSw0R8iq3hHIWAZZOVhhnxi+bng5VcnuZuO8kJV9F/KTWjkw8CDSkmZ/Gq9/5UaqtJ6OZraSFK7R
/AeigVid8uVziQjMIZb1udJDj87wF1bXLcrGVPYdE03ILt1abQ+7zVFTcfR9xwBNl3gNF65/z9hd
nCkIzbPEP4JamICm/acI6boSdWFiXfacYwsNJ5r5Utz5yKT++WnI8HNUasD3VM8ji6jpxaU6oaID
LpLPsz4zK5EBacB3108lUP/ugztAfXRjf0wcOxAdArk3LJFG5meNN6vUhWJdzkw1wK8Qk6AxCyFO
wdUIUydnX/FdGqbYUGPRiJSkd7itSqlZTKIVcIuc920yu5t3SoZMbUcFEd0CBm3sKkrq1bNn9BS0
FEPu5bU0GQZQuFsZAtt+MceB7HQsOWN1spYIFDEfJiv/p82FP4eMAerVOV5P8LY/ewvlDZny+NS6
0M266lz0hJyNka3XwyzTV1KdVCFTOv1l3bIb+FbxAGsydZ6AtcMErB89J5JV6shaI4ScFj8u2iiV
l6AoYzUANeWIeWVZ0kHt2Die6PXNDGaP5tZxYT+mIF9Lap8sxZ+Lq7y8ZcrIVUj6ZFlkl+F9YAzi
iCFjEZrxFbP7C0YkIbcZ/he673RrMK+QRaDvh/GX+j2vlElpEozYrYKK+elqn++i3PNM7SZMo7rM
hYFv8rAeGuWkJp08nwwz665sztxnsAMCugvq1xRoHrbk5RS/r65EFEnVPZS6o/7MpsfdLUjsRHj+
4Wi0pLiJmcLrDZbf02iOyV+H6V+PiV0xy87VYfIjAwvPlkYVjvTpQJQtTfGWETgpL99FSeI8JoPk
ZYZa4C5L2mEv7zU2h7+iJC9zTv//sQnPvGCxfg7WKK6DWYKyFdBBstWgGxw9zJi/U3lapMmTStYf
svfpFDK2o3ogYBEICmpCVeFIFPH2/LQ1Ao/GKvaGdfxL1HhtQUiSKgy8c+QsJ3HE3t22v4qX6Fer
kISEGE8TXWcduMewGO8pM1SKHGnhbygWOpSJTmynzYkI1GxutihjoTNOKmDDht9XVNdGUhC0Le8I
WlKZuBMwadYIEP3Q+xOTwF4hTa8PHbXSwZ7TFz+IUez7xCOzSKU4N6mC/0hDJ8u7ijIgubokIZos
PO0/qvTpHquHfKyfA4O329Bt4UoahIU3kdiz9ZwCscyL83o2yhNWKsiV4ehm3L6XlCFsA7RBtLju
D47ihQAsohabl8uE8DM+zH13lKaBXvQGNFlR7rrEDnbnuYSBXEeUZz4SJmtpTyFrnN9by+rcTO9T
JpO3asucq0INyRVusF2nXiVGRrYQd4SK5genHU2G1YLgSLoAqlz91jP8hAPgvajv7DrTweVLlRE/
Gh3z/saOPUBvgwsqH1nY6XLF9BEB2vXzi35z5QpM0yyDp7DUz8/OyW+kkMiH/fEoCeEQmhjyMKBm
F3eFsQx93PeaBRIsHDGLKWkbLoeD2ZlwE7Y8fxcr3kFRx/XS90BSOhMFh2ZfdkuHpt542OeDwi09
gsnh1lW6Xpgqgfsrb/FDzAyp9kv+OcCyr9ee/uPI8fm/Jny0jhQm54MJZWI9atIoAQBsOZVKdQ+9
Js2+6lJjootMnNG1+7asyYLU0h0x93QV/4184hTSx7yzo3MfoyfWcHwd+ds2TB73lHjEH2zbtzlU
itJR+OfwVIOTSZt2rP+lNMPMmRVZm+qSGNbLZGb2rqGNjeC+YV9RExFAivKTEclmy1OzfRLWr8bW
8N5TLOFbVKPXevbWplMJbxsnxH56P0fMv0k+Piwkbn3pWrjlC2TiI3zRnZLzLsQ79/tbpXSvucQp
lDlf0zvVlpfP7jShUqrnW1K8Vqkp3AHQy6DM/8Ds0qqOm8URR7CtFPCLAolH5+IxatE8C66sG97d
bMg1zkIvJaH/r5ZmpoGJpOM9+Qak0us6GlJyOmGGk50qS9JwQ5Ug2cgjHO0qn/3vAKJCntZh8q4z
nk33PCcWHBHmsqHP5/orUWUPFFdcy3O89ykrA0GdVrNeKgr9r3RoXaca2/rP0nfVndK1wUuiM7Dm
gozdjuyjRtxQhx7PdEiiWfX2loNzbmmkPU4m6eBSYvfLIDWC5E3/OiqK9XaOmRBzCtsv830Kq0fT
l8FewMCyt1lV5OY/CwhoF6k82FD5TabL/CdwypeW8bUBmolPx+X68LZ9GMEvDGZO7e2/R5fPqKBd
g6qeYcS2BcpBlv2pgMwHNyXmtLZJyNHt8nBwEX7pATbS/xH8zUZkVMpOrPmoCuUIddEzjUNtlr9D
w65tDVpJXIM4F9YysFE58P9936PrwmDsCTF0asJJykQxehyD5mkV3JdxCkionl+j8hGz9M0l8tIJ
qmQihds3eLN887EtC7XHKGVoThJrVMVHBIB+ko2CT5BHGCNbwj63ImXMBRW+NKp+E0jzCxlXevJM
iLRC17GJh4HI84+iCzZNcVLK2EHbJSxo5qiEKXCI2i9auInXk1p7zoUF5QUMalGPRAOjoxWTKJDZ
EOYqTkwYqq+W3i3ZZbjImD6Sao0oCEiW5oENAw6imcPD9V0ym7q7i5US2hwm4jX1qF+uBWzGLgFe
mFj3RlyZbcEcQYSxPpH4Cbv+Ov2aoY2DDLq8mD1B7+asEvlc/BDasX7eFYLfyCRZmUKmH+HeuyFl
eoAeZxh0Kr9UJPKRx6TYNCr0s+DlR0NSk2Dv8IaqHy3+dsCpjko2+Ux2QhnUlM4LfMxHLhAglY1N
tWYTtlISy1fIYfXW3PcGTzF8471usodV9R1ueCp+I6ynFgTMqc+Y21WbiWjh0FXIGLgD8HjGa81h
V4WyJFZw96V94dNwhNgq3rPdHA4CfpLKmjTsdduDpd2MzJ/LORzcS97/BUYoriTwMuRcgmF1CKP9
TvsHbjw7zE82ztGGHhg18HKpKUGorxZLFT6y8PUvdlFRfRwz4BqrheWjtu4F4R1HJWr8BoKIb8FW
jFnh1R5OEQWCbBDxyVTBx29ke12m7SQJaMpNY13ZRVbyEOG82iZxFRYCXLqU4lUOjOTkI5bs51z1
I0qCo9aKCYoAf8cXlmq3oocMr+dYcHpoIrC1cYiJxb2qv47gx/E+1LzOuJJ7MrRpiJbuB0zvRzML
Z44EAuWSdc4/b6e3uaSOp6LunMUccJZz87d3YRaGf4WDZ2eD66/RPHXwpFSwkk7q73VZ2VYW5pAw
x4JvuTIACbbeDeAxwhQ7+tXdVsD29Ac4hDoTfr5oft3eiKOoVh3HPtYvTwxtxrWSLB3vtPsLjqxr
MHwte83ZErWbYjBxIt+u9F4usBo4Zpd61EJMcK0YCNEB1Pgq+6vmZk1lUTvTnosVKlYgeyvD/T4F
6293csHQJ6YUvbnJnHZSV36z8QfLEoEW0Txkb1ldKOpTjM+vfUfVZ3q+EexkIv8axc1SvX29APSv
Du4MAFWU3LXxBg51lPFKH8ZEMYKvdk7HzkGVxiH2/2JOt9Pz+NsUCaneUtTO
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
