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
        addr : in  STD_LOGIC_VECTOR (1 downto 0); -- 3 biais ?
        data : out STD_LOGIC_VECTOR (31 downto 0)
    );
end rom_c1_bias;

architecture Behavioral of rom_c1_bias is

    component blk_mem_c1_b
        port (
            clka  : in  std_logic;
            ena   : in  std_logic;
            addra : in  std_logic_vector(1 downto 0);
            douta : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    rom_inst : blk_mem_c1_b
        port map (
            clka  => clk,
            ena   => '1',
            addra => addr,
            douta => data
        );

end Behavioral;
