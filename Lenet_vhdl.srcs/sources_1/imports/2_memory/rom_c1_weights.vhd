----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.02.2026 13:53:06
-- Design Name: 
-- Module Name: rom_c1_weights - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rom_c1_weights is
    Port ( clk : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (6 downto 0);-- 75 ? 7 bits
           data : out STD_LOGIC_VECTOR (7 downto 0));
end rom_c1_weights;

architecture Behavioral of rom_c1_weights is

component blk_mem_c1_w
 
  port(
       clka :in std_logic;
       ena: in std_logic;
       addra: in std_logic_vector(6 downto 0);
       douta : out std_logic_vector(7 downto 0)
  );
  
  end component;
  
  
begin

rom_inst :blk_mem_c1_w

 port map(
   clka=>clk,
   ena=>'1',
   addra=>addr,
   douta=>data
 );
 


end Behavioral;
