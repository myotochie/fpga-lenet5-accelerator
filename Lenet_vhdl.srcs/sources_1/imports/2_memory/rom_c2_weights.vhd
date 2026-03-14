----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.02.2026 13:41:53
-- Design Name: 
-- Module Name: rom_c2_weights - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rom_c2_weights is
    Port ( clk  : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (8 downto 0);
           data : out STD_LOGIC_VECTOR (7 downto 0));
end rom_c2_weights;

architecture Behavioral of rom_c2_weights is
    component blk_mem_c2_w
        port ( clka: in std_logic;
               ena: in std_logic;
               addra: in std_logic_vector(8 downto 0);
               douta: out std_logic_vector(7 downto 0));
    end component;
begin
    rom_inst : blk_mem_c2_w
        port map (
        clka=>clk, 
        ena=>'1',
        addra=>addr,
        douta=>data);
end Behavioral;

