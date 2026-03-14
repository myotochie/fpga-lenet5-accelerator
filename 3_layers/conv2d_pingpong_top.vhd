----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.03.2026 15:52:17
-- Design Name: 
-- Module Name: conv2d_pingpong_top - Behavioral
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
-- =============================================================================
-- conv2d_pingpong_top.vhd
-- Instancie les IPs Catalog Vivado :
--   • blk_mem_gen_in     (×2) : BRAMs input  ping-pong
--   • blk_mem_gen_out    (×6) : BRAMs output ping-pong (3 canaux × 2 banks)
--   • blk_mem_gen_weights(×1) : BRAM poids (ROM, init .coe)
-- Les IPs sont connectées au core via des signaux natifs (pas AXI).
-- Le DMA Xilinx (axi_dma) est connecté en dehors via le port AXI-Stream.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

entity conv2d_pingpong_top is
    generic (
        IN_WIDTH     : integer := 32;
        IN_HEIGHT    : integer := 32;
        OUT_CHANNELS : integer := 3;
        KERNEL_SIZE  : integer := 5;
        Q_MULT       : int32   := C1_MULT;
        Q_SHIFT      : integer := C1_SHIFT;
        Q_ZERO_POINT : int8    := C1_ZERO_POINT
    );
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        start    : in  std_logic;
        done     : out std_logic;
        bank_sel : out std_logic;

        -- Port DMA ? BRAM input (bank libre)
        dma_wr_en   : in  std_logic;
        dma_wr_addr : in  std_logic_vector(9 downto 0);
        dma_wr_data : in  std_logic_vector(7 downto 0);

        -- Port lecture output (couche suivante)
        out_rd_en   : in  std_logic;
        out_rd_addr : in  std_logic_vector(9 downto 0);
        out_rd_ch   : in  std_logic_vector(1 downto 0);
        out_rd_data : out std_logic_vector(7 downto 0)
    );
end conv2d_pingpong_top;

architecture rtl of conv2d_pingpong_top is

    constant OCH    : integer := 3;
    constant KSIZE  : integer := 5;
    constant OUT_W  : integer := IN_WIDTH  - KSIZE + 1;
    constant OUT_H  : integer := IN_HEIGHT - KSIZE + 1;
    constant OUT_SZ : integer := OUT_W * OUT_H;

    -- =========================================================================
    -- Déclarations composants IPs Catalog
    -- =========================================================================

    -- BRAM input : Simple Dual Port, 1024×8b
    component blk_mem_gen_in is
        port (
            clka  : in  std_logic;
            ena   : in  std_logic;
            wea   : in  std_logic_vector(0 downto 0);
            addra : in  std_logic_vector(9 downto 0);
            dina  : in  std_logic_vector(7 downto 0);
            clkb  : in  std_logic;
            enb   : in  std_logic;
            addrb : in  std_logic_vector(9 downto 0);
            doutb : out std_logic_vector(7 downto 0)
        );
    end component;

    -- BRAM output : Simple Dual Port, 784×8b
    component blk_mem_gen_out is
        port (
            clka  : in  std_logic;
            ena   : in  std_logic;
            wea   : in  std_logic_vector(0 downto 0);
            addra : in  std_logic_vector(9 downto 0);
            dina  : in  std_logic_vector(7 downto 0);
            clkb  : in  std_logic;
            enb   : in  std_logic;
            addrb : in  std_logic_vector(9 downto 0);
            doutb : out std_logic_vector(7 downto 0)
        );
    end component;

    --  3 BRAMs poids séparées (une par canal, même IP)
    -- Chaque BRAM contient les 25 poids d'un canal
    -- Même adresse broadcast ? 3 sorties en parallèle
    
    component blk_mem_c11_w
        port (
            clka  : in  std_logic;
            ena   : in  std_logic;
            addra : in  std_logic_vector(4 downto 0);
            douta : out std_logic_vector(7 downto 0)
        );
    end component;
    
    component blk_mem_c12_w
        port (
            clka  : in  std_logic;
            ena   : in  std_logic;
            addra : in  std_logic_vector(4 downto 0);
            douta : out std_logic_vector(7 downto 0)
        );
    end component;
    
    component blk_mem_c13_w
        port (
            clka  : in  std_logic;
            ena   : in  std_logic;
            addra : in  std_logic_vector(4 downto 0);
            douta : out std_logic_vector(7 downto 0)
        );
    end component;

    -- BRAM biais : Single Port ROM, 4×32b
    component blk_mem_c1_b is
        port (
            clka  : in  std_logic;
            ena   : in  std_logic;
            addra : in  std_logic_vector(1 downto 0);
            douta : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Core datapath
    component conv2d_pingpong_core is
        generic (
            IN_WIDTH, IN_HEIGHT, OUT_CHANNELS, KERNEL_SIZE : integer;
            Q_MULT : int32; Q_SHIFT : integer; Q_ZERO_POINT : int8
        );
        port (
            clk, rst, start : in  std_logic;
            done            : out std_logic;
            calc_bank       : out std_logic;
            pix_addr        : out std_logic_vector(9 downto 0);
            in_pixel        : in  std_logic_vector(7 downto 0);
            out_wr_addr     : out std_logic_vector(9 downto 0);
            out_wr_valid    : out std_logic;
            out_data_0      : out std_logic_vector(7 downto 0);
            out_data_1      : out std_logic_vector(7 downto 0);
            out_data_2      : out std_logic_vector(7 downto 0);
            weight_addr     : out std_logic_vector(4 downto 0);
            weight_data_0   : in  std_logic_vector(7 downto 0);
            weight_data_1   : in  std_logic_vector(7 downto 0);
            weight_data_2   : in  std_logic_vector(7 downto 0);
            bias_addr       : out std_logic_vector(1 downto 0);
            bias_data       : in  std_logic_vector(31 downto 0)
        );
    end component;

    -- =========================================================================
    -- Signaux internes
    -- =========================================================================
    signal calc_bank_i   : std_logic := '0';
    signal calc_bank_d1  : std_logic := '0';

    -- Adresses et données core
    signal core_pix_addr : std_logic_vector(9 downto 0);
    signal core_out_addr : std_logic_vector(9 downto 0);
    signal core_out_we   : std_logic;
    signal core_out_d0   : std_logic_vector(7 downto 0);
    signal core_out_d1   : std_logic_vector(7 downto 0);
    signal core_out_d2   : std_logic_vector(7 downto 0);

    -- Pixels input
    signal in_a_dout     : std_logic_vector(7 downto 0);
    signal in_b_dout     : std_logic_vector(7 downto 0);
    signal in_pixel_mux  : std_logic_vector(7 downto 0);

    --  3 signaux de sortie poids séparés
    signal weight_addr_i : std_logic_vector(4 downto 0);
    signal w_dout_0      : std_logic_vector(7 downto 0);
    signal w_dout_1      : std_logic_vector(7 downto 0);
    signal w_dout_2      : std_logic_vector(7 downto 0);

    -- Biais
    signal bias_addr_i   : std_logic_vector(1 downto 0);
    signal bias_data_i   : std_logic_vector(31 downto 0);

    -- Write enables
    signal dma_we_a      : std_logic_vector(0 downto 0);
    signal dma_we_b      : std_logic_vector(0 downto 0);
    signal we_out_a      : std_logic_vector(0 downto 0);
    signal we_out_b      : std_logic_vector(0 downto 0);

    -- Sorties output BRAMs
    signal rd_a0, rd_a1, rd_a2 : std_logic_vector(7 downto 0);
    signal rd_b0, rd_b1, rd_b2 : std_logic_vector(7 downto 0);

begin

    bank_sel <= calc_bank_i;

    -- =========================================================================
    -- MUX DMA ? BRAM input (écrit dans la bank libre)
    -- =========================================================================
        dma_we_a(0) <= dma_wr_en and calc_bank_i;          -- DMA écrit A quand core lit B
        dma_we_b(0) <= dma_wr_en and (not calc_bank_i);

    -- =========================================================================
    -- INPUT BRAM A
    -- =========================================================================
    u_in_bram_a : blk_mem_gen_in
        port map (
            clka  => clk, ena => dma_wr_en, wea => dma_we_a,
            addra => dma_wr_addr,           dina => dma_wr_data,
            clkb  => clk, enb => not calc_bank_i,
            addrb => core_pix_addr,         doutb => in_a_dout
        );

    -- =========================================================================
    -- INPUT BRAM B
    -- =========================================================================
    u_in_bram_b : blk_mem_gen_in
        port map (
            clka  => clk, ena => dma_wr_en, wea => dma_we_b,
            addra => dma_wr_addr,           dina => dma_wr_data,
            clkb  => clk, enb => calc_bank_i,
            addrb => core_pix_addr,         doutb => in_b_dout
        );

    -- MUX pixel vers core
    in_pixel_mux <= in_a_dout when calc_bank_i = '0' else in_b_dout;

    -- =========================================================================
    -- 3 BRAMs poids séparées (ch0, ch1, ch2)
    -- Même adresse broadcast, données sorties indépendantes
    -- =========================================================================
    u_weight_bram_0 : blk_mem_c11_w
        port map (
            clka  => clk, ena => '1',
            addra => weight_addr_i,
            douta => w_dout_0
        );

    u_weight_bram_1 : blk_mem_c12_w
        port map (
            clka  => clk, ena => '1',
            addra => weight_addr_i,
            douta => w_dout_1
        );

    u_weight_bram_2 : blk_mem_c13_w
        port map (
            clka  => clk, ena => '1',
            addra => weight_addr_i,
            douta => w_dout_2
        );

    -- =========================================================================
    --  : BRAM biais instanciée SÉPARÉMENT (pas dans un port map)
    -- =========================================================================
    u_bias_bram : blk_mem_c1_b
        port map (
            clka  => clk,
            ena   => '1',
            addra => bias_addr_i,
            douta => bias_data_i
        );

    -- =========================================================================
    -- Write enables output BRAMs
    -- =========================================================================
    we_out_a(0) <= core_out_we and (not calc_bank_i);
    we_out_b(0) <= core_out_we and calc_bank_i;

    -- =========================================================================
    -- OUTPUT BRAMs BANK A (3 canaux)
    -- =========================================================================
    u_out_bram_a0 : blk_mem_gen_out
        port map (
            clka  => clk, ena => core_out_we, wea => we_out_a,
            addra => core_out_addr, dina => core_out_d0,
            clkb  => clk, enb => out_rd_en,
            addrb => out_rd_addr,   doutb => rd_a0
        );
    u_out_bram_a1 : blk_mem_gen_out
        port map (
            clka  => clk, ena => core_out_we, wea => we_out_a,
            addra => core_out_addr, dina => core_out_d1,
            clkb  => clk, enb => out_rd_en,
            addrb => out_rd_addr,   doutb => rd_a1
        );
    u_out_bram_a2 : blk_mem_gen_out
        port map (
            clka  => clk, ena => core_out_we, wea => we_out_a,
            addra => core_out_addr, dina => core_out_d2,
            clkb  => clk, enb => out_rd_en,
            addrb => out_rd_addr,   doutb => rd_a2
        );

    -- =========================================================================
    -- OUTPUT BRAMs BANK B (3 canaux)
    -- =========================================================================
    u_out_bram_b0 : blk_mem_gen_out
        port map (
            clka  => clk, ena => core_out_we, wea => we_out_b,
            addra => core_out_addr, dina => core_out_d0,
            clkb  => clk, enb => out_rd_en,
            addrb => out_rd_addr,   doutb => rd_b0
        );
    u_out_bram_b1 : blk_mem_gen_out
        port map (
            clka  => clk, ena => core_out_we, wea => we_out_b,
            addra => core_out_addr, dina => core_out_d1,
            clkb  => clk, enb => out_rd_en,
            addrb => out_rd_addr,   doutb => rd_b1
        );
    u_out_bram_b2 : blk_mem_gen_out
        port map (
            clka  => clk, ena => core_out_we, wea => we_out_b,
            addra => core_out_addr, dina => core_out_d2,
            clkb  => clk, enb => out_rd_en,
            addrb => out_rd_addr,   doutb => rd_b2
        );

    -- =========================================================================
    -- MUX lecture output (aligné avec latence BRAM 1 cycle)
    -- =========================================================================
    p_rd_align : process(clk)
    begin
        if rising_edge(clk) then
            calc_bank_d1 <= calc_bank_i;
        end if;
    end process;

    p_out_mux : process(clk)
    begin
        if rising_edge(clk) then
            if out_rd_en = '1' then
                case to_integer(unsigned(out_rd_ch)) is
                    when 0 =>
                        out_rd_data <= rd_b0 when calc_bank_d1='0' else rd_a0;
                    when 1 =>
                        out_rd_data <= rd_b1 when calc_bank_d1='0' else rd_a1;
                    when 2 =>
                        out_rd_data <= rd_b2 when calc_bank_d1='0' else rd_a2;
                    when others =>
                        out_rd_data <= (others => '0');
                end case;
            end if;
        end if;
    end process;

    -- =========================================================================
    -- CORE DATAPATH
    -- =========================================================================
    u_core : conv2d_pingpong_core
        generic map (
            IN_WIDTH     => IN_WIDTH,     IN_HEIGHT    => IN_HEIGHT,
            OUT_CHANNELS => OUT_CHANNELS, KERNEL_SIZE  => KERNEL_SIZE,
            Q_MULT       => Q_MULT,       Q_SHIFT      => Q_SHIFT,
            Q_ZERO_POINT => Q_ZERO_POINT
        )
        port map (
            clk          => clk,
            rst          => rst,
            start        => start,
            done         => done,
            calc_bank    => calc_bank_i,
            pix_addr     => core_pix_addr,
            in_pixel     => in_pixel_mux,
            out_wr_addr  => core_out_addr,
            out_wr_valid => core_out_we,
            out_data_0   => core_out_d0,
            out_data_1   => core_out_d1,
            out_data_2   => core_out_d2,
            --  weight_addr unique, weight_data_x séparés
            weight_addr   => weight_addr_i,
            weight_data_0 => w_dout_0,
            weight_data_1 => w_dout_1,
            weight_data_2 => w_dout_2,
            --  biais via BRAM
            bias_addr     => bias_addr_i,
            bias_data     => bias_data_i
        );

end rtl;