----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.02.2026 14:24:28
-- Design Name: 
-- Module Name: tb_rom_c2_bias - Behavioral
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

entity tb_rom_c2_bias is
--  Port ( );
end tb_rom_c2_bias;

architecture sim of tb_rom_c2_bias is

    signal clk  : std_logic := '0';
    signal addr : std_logic_vector(2 downto 0) := (others => '0');
    signal data : std_logic_vector(31 downto 0);

    component rom_c2_bias
        port(clk : in std_logic;
             addr: in std_logic_vector(2 downto 0);
             data: out std_logic_vector(31 downto 0));
    end component;

    constant CLK_PERIOD : time := 10 ns;

begin

        inst_rom_c2_bias: rom_c2_bias
        port map (
            clk  => clk,
            addr => addr,
            data => data
        );

-- Génération de l'horloge 
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Ton processus de stimulus 
    stim: process
    begin 
        for i in 0 to 5 loop
            addr <= std_logic_vector(to_unsigned(i, 3)); 
            wait for CLK_PERIOD;
        end loop;
   wait for CLK_PERIOD;
    end process;
end sim;