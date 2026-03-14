----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.02.2026 14:25:25
-- Design Name: 
-- Module Name: lenet_types_pkg - Behavioral
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package lenet_types_pkg is

    -- Types numériques
    ------------------------------------------------------------------
    subtype int8  is signed(7 downto 0);
    subtype int16 is signed(15 downto 0);
    subtype int32 is signed(31 downto 0);

    -- Dimensions image entrée (MNIST étendu 32x32)
    ------------------------------------------------------------------
    constant IMG_WIDTH      : integer := 32;
    constant IMG_HEIGHT     : integer := 32;
    constant IMG_CHANNELS   : integer := 1;

    --  CONVOLUTION 1
    ------------------------------------------------------------------
    constant C1_KERNEL_SIZE : integer := 5;
    constant C1_IN_CH       : integer := 1;
    constant C1_OUT_CH      : integer := 3;

    constant C1_OUT_WIDTH   : integer := 28; -- (32 - 5 + 1)
    constant C1_OUT_HEIGHT  : integer := 28;


    -- POOLING 1
    ------------------------------------------------------------------
    constant P1_SIZE        : integer := 2;

    constant P1_OUT_WIDTH   : integer := 14;
    constant P1_OUT_HEIGHT  : integer := 14;
    constant P1_OUT_CH      : integer := 3;

    -- CONVOLUTION 2
    ------------------------------------------------------------------
    constant C2_KERNEL_SIZE : integer := 5;
    constant C2_IN_CH       : integer := 3;
    constant C2_OUT_CH      : integer := 6;

    constant C2_OUT_WIDTH   : integer := 10; -- (14 - 5 + 1)
    constant C2_OUT_HEIGHT  : integer := 10;

    --  POOLING 2
    ------------------------------------------------------------------
    constant P2_SIZE        : integer := 2;

    constant P2_OUT_WIDTH   : integer := 5;
    constant P2_OUT_HEIGHT  : integer := 5;
    constant P2_OUT_CH      : integer := 6;

    -- FLATTEN
    ------------------------------------------------------------------
    constant FLATTEN_SIZE : integer := 5 * 5 * 6; -- 150

    --  FULLY CONNECTED
    ------------------------------------------------------------------
    constant FC_IN_SIZE  : integer := FLATTEN_SIZE;
    constant FC_OUT_SIZE : integer := 10;

    --Types tableaux utiles
    ------------------------------------------------------------------

    -- Vecteur générique INT8
    type int8_vector  is array (natural range <>) of int8;

    -- Vecteur générique INT32
    type int32_vector is array (natural range <>) of int32;

end package;

package body lenet_types_pkg is
end package body;
