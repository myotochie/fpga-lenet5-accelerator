----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.02.2026 15:22:24
-- Design Name: 
-- Module Name: conv2d_int8 - Behavioral
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

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

entity conv2d_int8 is
    generic (
        IN_WIDTH     : integer := 32;    -- Largeur entrée
        IN_HEIGHT    : integer := 32;    -- Hauteur entrée
        IN_CHANNELS  : integer := 1;     -- Canaux entrée
        OUT_CHANNELS : integer := 3;     -- Canaux sortie
        KERNEL_SIZE  : integer := 5;     -- Taille kernel (5x5)
        
        -- Paramètres de quantification
        Q_MULT       : int32   := C1_MULT;
        Q_SHIFT      : integer := C1_SHIFT;
        Q_ZERO_POINT : int8    := C1_ZERO_POINT
    );
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        
        -- Interface de contrôle
        start        : in  std_logic;
        done         : out std_logic;
        
        -- Adresse mémoire lecture poids/biais
        weight_addr  : out std_logic_vector(15 downto 0);
        weight_data  : in  int8;
        bias_addr    : out std_logic_vector(7 downto 0);
        bias_data    : in  int32;
        
        -- Interface données entrée
        in_addr      : out std_logic_vector(15 downto 0);
        in_data      : in  int8;
        
        -- Interface données sortie
        out_addr     : out std_logic_vector(15 downto 0);
        out_data     : out int8;
        out_we       : out std_logic
    );
end conv2d_int8;

architecture Behavioral of conv2d_int8 is

    -- Calcul dimensions sortie
    constant OUT_WIDTH  : integer := IN_WIDTH - KERNEL_SIZE + 1;
    constant OUT_HEIGHT : integer := IN_HEIGHT - KERNEL_SIZE + 1;
    
    -- Machine à états
    type state_type is (
        IDLE,
        LOAD_BIAS,
        CONV_LOOP,
        ACCUMULATE,
        REQUANTIZE,
        WRITE_OUTPUT,
        NEXT_POSITION,
        DONE_STATE
    );
    signal state : state_type := IDLE;
    
    -- Compteurs position
    signal x_out      : integer range 0 to OUT_WIDTH-1  := 0;
    signal y_out      : integer range 0 to OUT_HEIGHT-1 := 0;
    signal c_out      : integer range 0 to OUT_CHANNELS-1 := 0;
    
    -- Compteurs kernel
    signal kx         : integer range 0 to KERNEL_SIZE-1 := 0;
    signal ky         : integer range 0 to KERNEL_SIZE-1 := 0;
    signal c_in       : integer range 0 to IN_CHANNELS := 0;
    
    -- Accumulateurs parallèles (un par canal de sortie)
    type acc_array is array (0 to OUT_CHANNELS-1) of int32;
    signal accumulators : acc_array := (others => (others => '0'));
    
    -- Registre pour pixel d'entrée et poids
    signal pixel_reg  : int8 := (others => '0');
    signal weight_reg : int8 := (others => '0');
    
    -- Produit temporaire
    signal product    : int32 := (others => '0');
    
    -- Résultat requantifié
    signal requant_result : int8 := (others => '0');
    
    -- Pipeline de latence pour les lectures mémoire
    signal latency_counter : integer range 0 to 3 := 0;
    
    -- Flag pour distinguer lecture bias vs weights
    signal loading_bias : std_logic := '0';

begin

    -- Process principal de convolution
    process(clk)
        variable temp_acc     : int32;
        variable scaled       : signed(63 downto 0);
        variable shifted      : int32;
        variable with_offset  : int32;
        variable saturated    : int32;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= IDLE;
                done <= '0';
                out_we <= '0';
                x_out <= 0;
                y_out <= 0;
                c_out <= 0;
                kx <= 0;
                ky <= 0;
                c_in <= 0;
                accumulators <= (others => (others => '0'));
                latency_counter <= 0;
                loading_bias <= '0';
                
            else
                case state is
                
                    -- État IDLE
                    when IDLE =>
                        done <= '0';
                        out_we <= '0';
                        if start = '1' then
                            x_out <= 0;
                            y_out <= 0;
                            c_out <= 0;
                            state <= LOAD_BIAS;
                            loading_bias <= '1';
                        end if;
                    
                    -- Chargement du biais pour le canal courant
                    when LOAD_BIAS =>
                        bias_addr <= std_logic_vector(to_unsigned(c_out, 8));
                        
                        if latency_counter < 2 then
                            latency_counter <= latency_counter + 1;
                        else
                            -- Initialiser l'accumulateur avec le biais
                            accumulators(c_out) <= bias_data;
                            latency_counter <= 0;
                            loading_bias <= '0';
                            
                            -- Initialiser les compteurs de convolution
                            kx <= 0;
                            ky <= 0;
                            c_in <= 0;
                            state <= CONV_LOOP;
                        end if;
                    
                    -- Boucle de convolution
                    when CONV_LOOP =>
                        -- Calculer adresse pixel d'entrée
                        -- Position absolue : (y_out + ky, x_out + kx, c_in)
                        in_addr <= std_logic_vector(
                            to_unsigned(
                                ((y_out + ky) * IN_WIDTH + (x_out + kx)) * IN_CHANNELS + c_in,
                                16
                            )
                        );
                        
                        -- Calculer adresse poids
                        -- Organisation : [c_out][c_in][ky][kx]
                        weight_addr <= std_logic_vector(
                            to_unsigned(
                                c_out * (IN_CHANNELS * KERNEL_SIZE * KERNEL_SIZE) +
                                c_in * (KERNEL_SIZE * KERNEL_SIZE) +
                                ky * KERNEL_SIZE +
                                kx,
                                16
                            )
                        );
                        
                        state <= ACCUMULATE;
                        latency_counter <= 0;
                    
                    -- Accumulation du produit
                    when ACCUMULATE =>
                        if latency_counter < 2 then
                            latency_counter <= latency_counter + 1;
                            if latency_counter = 1 then
                                -- Capturer les données
                                pixel_reg <= in_data;
                                weight_reg <= weight_data;
                            end if;
                        else
                            -- Calculer produit
                            product <= resize(pixel_reg * weight_reg, 32);
                            
                            -- Accumuler
                            accumulators(c_out) <= accumulators(c_out) + product;
                            
                            latency_counter <= 0;
                            
                            -- Incrémenter compteurs
                            if c_in < IN_CHANNELS - 1 then
                                c_in <= c_in + 1;
                                state <= CONV_LOOP;
                            elsif kx < KERNEL_SIZE - 1 then
                                kx <= kx + 1;
                                c_in <= 0;
                                state <= CONV_LOOP;
                            elsif ky < KERNEL_SIZE - 1 then
                                ky <= ky + 1;
                                kx <= 0;
                                c_in <= 0;
                                state <= CONV_LOOP;
                            else
                                -- Convolution terminée pour cette position
                                state <= REQUANTIZE;
                            end if;
                        end if;
                    
                    -- Requantification
                    when REQUANTIZE =>
                        temp_acc := accumulators(c_out);
                        
                        -- Multiplication par facteur d'échelle
                        scaled := resize(temp_acc * Q_MULT, 64);
                        
                        -- Décalage arithmétique à droite
                        shifted := resize(shift_right(scaled, Q_SHIFT), 32);
                        
                        -- Ajout du zero point
                        with_offset := shifted + resize(Q_ZERO_POINT, 32);
                        
                        -- Saturation à [-128, 127]
                        if with_offset > INT8_MAX_VAL then
                            saturated := INT8_MAX_VAL;
                        elsif with_offset < INT8_MIN_VAL then
                            saturated := INT8_MIN_VAL;
                        else
                            saturated := with_offset;
                        end if;
                        
                        requant_result <= resize(saturated, 8);
                        state <= WRITE_OUTPUT;
                    
                    -- Écriture en mémoire de sortie
                    when WRITE_OUTPUT =>
                        -- Adresse de sortie : [y_out][x_out][c_out]
                        out_addr <= std_logic_vector(
                            to_unsigned(
                                (y_out * OUT_WIDTH + x_out) * OUT_CHANNELS + c_out,
                                16
                            )
                        );
                        out_data <= requant_result;
                        out_we <= '1';
                        
                        state <= NEXT_POSITION;
                    
                    -- Passage à la position suivante
                    when NEXT_POSITION =>
                        out_we <= '0';
                        
                        if c_out < OUT_CHANNELS - 1 then
                            -- Canal suivant
                            c_out <= c_out + 1;
                            state <= LOAD_BIAS;
                            loading_bias <= '1';
                        elsif x_out < OUT_WIDTH - 1 then
                            -- Colonne suivante
                            x_out <= x_out + 1;
                            c_out <= 0;
                            state <= LOAD_BIAS;
                            loading_bias <= '1';
                        elsif y_out < OUT_HEIGHT - 1 then
                            -- Ligne suivante
                            y_out <= y_out + 1;
                            x_out <= 0;
                            c_out <= 0;
                            state <= LOAD_BIAS;
                            loading_bias <= '1';
                        else
                            -- Traitement terminé
                            state <= DONE_STATE;
                        end if;
                    
                    -- État final
                    when DONE_STATE =>
                        done <= '1';
                        if start = '0' then
                            state <= IDLE;
                        end if;
                        
                end case;
            end if;
        end if;
    end process;

end Behavioral;
