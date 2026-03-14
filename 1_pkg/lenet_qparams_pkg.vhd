----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.02.2026 11:11:26
-- Design Name: 
-- Module Name: lenet_qparams_pkg - Behavioral
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

library work;
use work.lenet_types_pkg.all;

package lenet_qparams_pkg is

    -- Décalage fixé à 30 bits
    constant Q_SHIFT : integer := 30;
    
     --  FORMULE DE REQUANTIFICATION UTILISÉE
    --
    -- output_int8 = (acc_int32 * MULT) srl SHIFT + ZERO_POINT
    --
    -- MULT  : multiplicateur fixe (approx scale factor)
    -- SHIFT : décalage à droite (division par 2^SHIFT)
    -- ZERO_POINT : offset (souvent 0 pour poids symétriques)
    ------------------------------------------------------------------

    ------------------------------------------------------------------
    --  CONV1
    ------------------------------------------------------------------
    constant C1_MULT        : int32 := to_signed(806824, 32);
    constant C1_SHIFT       : integer := Q_SHIFT;
    constant C1_ZERO_POINT  : int8 := to_signed(0, 8);

    ------------------------------------------------------------------
    --  CONV2
    ------------------------------------------------------------------
    constant C2_MULT        : int32 := to_signed(2078663, 32);
    constant C2_SHIFT       : integer := Q_SHIFT;
    constant C2_ZERO_POINT  : int8 := to_signed(0, 8);

    ------------------------------------------------------------------
    --  FULLY CONNECTED
    ------------------------------------------------------------------
    constant FC_MULT        : int32 := to_signed(1342082, 32);
    constant FC_SHIFT       : integer := Q_SHIFT;
    constant FC_ZERO_POINT  : int8 := to_signed(-106, 8); -- Z_OUT = 150

    ------------------------------------------------------------------
    -- BORNES DE SATURATION (Pour rester en INT8 après calcul)
    ------------------------------------------------------------------
    constant INT8_MAX_VAL : int32 := to_signed(127, 32);
    constant INT8_MIN_VAL : int32 := to_signed(-128, 32);

end package;