// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Tue Mar  3 21:43:49 2026
// Host        : LAPTOP-KS0KAFEO running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/myodo/Desktop/Lenet_RTL/Lenet_vhdl/Lenet_vhdl.gen/sources_1/ip/blk_mem_gen_out/blk_mem_gen_out_sim_netlist.v
// Design      : blk_mem_gen_out
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_out,blk_mem_gen_v8_4_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_6,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module blk_mem_gen_out
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
  (* C_INIT_FILE = "blk_mem_gen_out.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "784" *) 
  (* C_READ_DEPTH_B = "784" *) 
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
  (* C_WRITE_DEPTH_A = "784" *) 
  (* C_WRITE_DEPTH_B = "784" *) 
  (* C_WRITE_MODE_A = "READ_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "8" *) 
  (* C_WRITE_WIDTH_B = "8" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_out_blk_mem_gen_v8_4_6 U0
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
+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
5fnz4RnOWPtxW/kcVvQoguAryyTYFA==
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
