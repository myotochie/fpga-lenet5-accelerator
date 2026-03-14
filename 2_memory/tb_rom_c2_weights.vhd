----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.02.2026 13:54:36
-- Design Name: 
-- Module Name: tb_rom_c2_weights - Behavioral
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

entity tb_rom_c2_weights is
--  Port ( );
end tb_rom_c2_weights;

architecture sim of tb_rom_c2_weights is

    -- DUT signals
    signal clk  : std_logic := '0';
    signal addr : std_logic_vector(8 downto 0) := (others => '0');
    signal data : std_logic_vector(7 downto 0);
    
 component rom_c2_weights
 
  port(
       clk :in std_logic;
       addr: in std_logic_vector(8 downto 0);
       data : out std_logic_vector(7 downto 0)
  );
  
  end component;   

    -- Clock period
    constant CLK_PERIOD : time := 10 ns;

begin

    --------------------------------------------------------------------
    -- Instantiate DUT
    --------------------------------------------------------------------
    inst_rom_c2_weights: rom_c2_weights
        port map (
            clk  => clk,
            addr => addr,
            data => data
        );

    --------------------------------------------------------------------
    -- Clock generation
    --------------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    --------------------------------------------------------------------
    -- Stimulus
    --------------------------------------------------------------------
    stim_proc: process
    begin

        -- Read all 450 weights
        for i in 0 to 449 loop
            addr <= std_logic_vector(to_unsigned(i, 9));
            wait for CLK_PERIOD;  -- wait 1 clock (BRAM latency)
        end loop;

        wait for 4000 ns;
        assert false report "Simulation Finished" severity failure;
    end process;

end sim;

