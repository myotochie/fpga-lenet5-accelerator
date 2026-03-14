--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
--Date        : Wed Feb 11 15:59:31 2026
--Host        : LAPTOP-KS0KAFEO running 64-bit major release  (build 9200)
--Command     : generate_target blk_mem_c1_w_wrapper.bd
--Design      : blk_mem_c1_w_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity blk_mem_c1_w_wrapper is
end blk_mem_c1_w_wrapper;

architecture STRUCTURE of blk_mem_c1_w_wrapper is
  component blk_mem_c1_w is
  end component blk_mem_c1_w;
begin
blk_mem_c1_w_i: component blk_mem_c1_w
 ;
end STRUCTURE;
