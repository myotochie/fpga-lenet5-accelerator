----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.02.2026 17:55:01
-- Design Name: 
-- Module Name: rom_c1_bias - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_c1_bias is
    Port (
        clk  : in  STD_LOGIC;
        addr : in  STD_LOGIC_VECTOR (9 downto 0); 
        data : out STD_LOGIC_VECTOR (7 downto 0)
    );
end rom_c1_bias;

architecture Behavioral of rom_c1_bias is

component blk_mem_in
 
  port(
       clka :in std_logic;
       ena: in std_logic;
       addra: in std_logic_vector(9 downto 0);
       douta : out std_logic_vector(7 downto 0)
  );
  
  end component;

begin

    BRAM_INPUT : blk_mem_in
        port map (
            clka  => clk,
            ena   => '1',
            addra => addr,
            douta => data
        );

end Behavioral;
