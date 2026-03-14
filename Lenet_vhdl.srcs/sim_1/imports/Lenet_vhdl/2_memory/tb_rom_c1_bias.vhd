----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.02.2026 19:03:49
-- Design Name: 
-- Module Name: tb_rom_c1_bias - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rom_c1_bias is
end tb_rom_c1_bias;

architecture sim of tb_rom_c1_bias is

    signal clk  : std_logic := '0';
    signal addr : std_logic_vector(9 downto 0) := (others => '0');
    signal data : std_logic_vector(7 downto 0);

    component rom_c1_bias
        port(clk : in std_logic;
             addr: in std_logic_vector(9 downto 0);
             data: out std_logic_vector(7 downto 0));
    end component;

    constant CLK_PERIOD : time := 10 ns;

begin

        inst_rom_c1_bias: rom_c1_bias
        port map (
            clk  => clk,
            addr => addr,
            data => data
        );

-- Génération de l'horloge (indispensable)
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Ton processus de stimulus (déjà correct)
    stim: process
    begin 
        for i in 0 to 1023 loop
            addr <= std_logic_vector(to_unsigned(i, 10)); 
            wait for CLK_PERIOD;
        end loop;
   wait for CLK_PERIOD;
    end process;
end sim;

