--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
--Date        : Wed Feb 11 15:59:31 2026
--Host        : LAPTOP-KS0KAFEO running 64-bit major release  (build 9200)
--Command     : generate_target blk_mem_c1_w.bd
--Design      : blk_mem_c1_w
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity blk_mem_c1_w is
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of blk_mem_c1_w : entity is "blk_mem_c1_w,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=blk_mem_c1_w,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of blk_mem_c1_w : entity is "blk_mem_c1_w.hwdef";
end blk_mem_c1_w;

architecture STRUCTURE of blk_mem_c1_w is
  component blk_mem_c1_w_blk_mem_gen_0_0 is
  port (
    clka : in STD_LOGIC;
    ena : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 6 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component blk_mem_c1_w_blk_mem_gen_0_0;
  signal NLW_blk_mem_gen_0_douta_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
begin
blk_mem_gen_0: component blk_mem_c1_w_blk_mem_gen_0_0
     port map (
      addra(6 downto 0) => B"0000000",
      clka => '0',
      douta(7 downto 0) => NLW_blk_mem_gen_0_douta_UNCONNECTED(7 downto 0),
      ena => '0'
    );
end STRUCTURE;
