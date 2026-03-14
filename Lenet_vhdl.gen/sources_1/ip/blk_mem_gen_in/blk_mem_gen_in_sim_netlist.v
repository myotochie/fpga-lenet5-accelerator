// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Tue Mar  3 21:40:18 2026
// Host        : LAPTOP-KS0KAFEO running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/myodo/Desktop/Lenet_RTL/Lenet_vhdl/Lenet_vhdl.gen/sources_1/ip/blk_mem_gen_in/blk_mem_gen_in_sim_netlist.v
// Design      : blk_mem_gen_in
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_in,blk_mem_gen_v8_4_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module blk_mem_gen_in
   (clka,
    wea,
    addra,
    dina,
    clkb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [7:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [9:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [7:0]doutb;

  wire [9:0]addra;
  wire [9:0]addrb;
  wire clka;
  wire clkb;
  wire [7:0]dina;
  wire [7:0]doutb;
  wire [0:0]wea;
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
  wire [7:0]NLW_U0_douta_UNCONNECTED;
  wire [9:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "10" *) 
  (* C_ADDRB_WIDTH = "10" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.59405 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "1" *) 
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
  (* C_INIT_FILE = "blk_mem_gen_in.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "1024" *) 
  (* C_READ_DEPTH_B = "1024" *) 
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
  (* C_WRITE_DEPTH_A = "1024" *) 
  (* C_WRITE_DEPTH_B = "1024" *) 
  (* C_WRITE_MODE_A = "READ_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "8" *) 
  (* C_WRITE_WIDTH_B = "8" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_in_blk_mem_gen_v8_4_6 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[7:0]),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[9:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[9:0]),
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
        .wea(wea),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19744)
`pragma protect data_block
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
XZM8pEZmkRbFqjg2cNPC9wLmtaCf6Q==
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
