-- =============================================================================
-- tb_conv2d_pingpong.vhd - VERSION BRAM COE, SANS DMA / SANS CPU
--
-- L'image source est stockée dans blk_mem_gen_ddr (Single Port ROM)
-- initialisée au démarrage par input_image_32x32.coe.
--
-- Le stimulus lit la ROM pixel par pixel et écrit dans le DUT
-- via dma_wr_en / dma_wr_addr / dma_wr_data.
--
-- IP à créer dans Vivado IP Catalog :
--   blk_mem_gen_ddr :
--     Memory Type   : Single Port ROM
--     Port A Width  : 8 bits
--     Port A Depth  : 1024
--     Operating Mode: Read First  (ou No Change)
--     Pipeline Reg  : 1 (latence 1 cycle sur douta)
--     Init File     : coe/input_image_32x32.coe
--
-- Aucune autre IP AXI requise.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

entity tb_conv2d_pingpong is
end entity;

architecture sim of tb_conv2d_pingpong is

    -- =========================================================================
    -- Paramètres
    -- =========================================================================
    constant IN_W   : integer := 32;
    constant IN_H   : integer := 32;
    constant KS     : integer := 5;
    constant OCH    : integer := 3;
    constant OUT_W  : integer := IN_W - KS + 1;   -- 28
    constant OUT_H  : integer := IN_H - KS + 1;   -- 28
    constant OUT_SZ : integer := OUT_W * OUT_H;    -- 784
    constant TOTAL  : integer := IN_W * IN_H;      -- 1024
    constant CLK_P  : time    := 10 ns;

    -- =========================================================================
    -- Signaux globaux
    -- =========================================================================
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';

    -- =========================================================================
    -- Signaux DUT
    -- =========================================================================
    signal start    : std_logic := '0';
    signal done     : std_logic := '0';
    signal bank_sel : std_logic := '0';

    signal dma_wr_en   : std_logic := '0';
    signal dma_wr_addr : std_logic_vector(9 downto 0) := (others => '0');
    signal dma_wr_data : std_logic_vector(7 downto 0) := (others => '0');

    signal out_rd_en   : std_logic := '0';
    signal out_rd_addr : std_logic_vector(9 downto 0) := (others => '0');
    signal out_rd_ch   : std_logic_vector(1 downto 0) := (others => '0');
    signal out_rd_data : std_logic_vector(7 downto 0);

    -- =========================================================================
    -- Signaux ROM DDR (blk_mem_gen_ddr)
    -- =========================================================================
    signal rom_addr : std_logic_vector(9 downto 0) := (others => '0');
    signal rom_data : std_logic_vector(7 downto 0);

    -- =========================================================================
    -- Composant blk_mem_gen_ddr
    -- Single Port ROM, 8b × 1024, init par input_image_32x32.coe
    -- Latence : 1 cycle (Primitives Output Register)
    -- =========================================================================
    component blk_mem_gen_ddr is
        port (
            clka  : in  std_logic;
            ena   : in  std_logic;
            addra : in  std_logic_vector(9 downto 0);
            douta : out std_logic_vector(7 downto 0)
        );
    end component;

    -- =========================================================================
    -- Composant DUT
    -- =========================================================================
    component conv2d_pingpong_top is
        generic (
            IN_WIDTH     : integer;
            IN_HEIGHT    : integer;
            OUT_CHANNELS : integer;
            KERNEL_SIZE  : integer;
            Q_MULT       : signed(31 downto 0);
            Q_SHIFT      : integer;
            Q_ZERO_POINT : signed(7 downto 0)
        );
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            start    : in  std_logic;
            done     : out std_logic;
            bank_sel : out std_logic;
            dma_wr_en   : in  std_logic;
            dma_wr_addr : in  std_logic_vector(9 downto 0);
            dma_wr_data : in  std_logic_vector(7 downto 0);
            out_rd_en   : in  std_logic;
            out_rd_addr : in  std_logic_vector(9 downto 0);
            out_rd_ch   : in  std_logic_vector(1 downto 0);
            out_rd_data : out std_logic_vector(7 downto 0)
        );
    end component;

begin

    -- =========================================================================
    -- Horloge
    -- =========================================================================
    clk <= not clk after CLK_P / 2;

    -- =========================================================================
    -- ROM DDR - image source initialisée par COE
    -- =========================================================================
    u_rom_ddr : blk_mem_gen_ddr
        port map (
            clka  => clk,
            ena   => '1',
            addra => rom_addr,
            douta => rom_data
        );

    -- =========================================================================
    -- DUT
    -- =========================================================================
    u_dut : conv2d_pingpong_top
        generic map (
            IN_WIDTH     => IN_W,
            IN_HEIGHT    => IN_H,
            OUT_CHANNELS => OCH,
            KERNEL_SIZE  => KS,
            -- ? Vrais paramètres de quantisation LeNet C1
            -- définis dans lenet_qparams_pkg.vhd
            Q_MULT       => C1_MULT,
            Q_SHIFT      => C1_SHIFT,
            Q_ZERO_POINT => C1_ZERO_POINT
        )
        port map (
            clk         => clk,
            rst         => rst,
            start       => start,
            done        => done,
            bank_sel    => bank_sel,
            dma_wr_en   => dma_wr_en,
            dma_wr_addr => dma_wr_addr,
            dma_wr_data => dma_wr_data,
            out_rd_en   => out_rd_en,
            out_rd_addr => out_rd_addr,
            out_rd_ch   => out_rd_ch,
            out_rd_data => out_rd_data
        );

    -- =========================================================================
    -- STIMULUS
    -- =========================================================================
    p_stim : process

        -- ?? Charger l'image depuis la ROM vers la BRAM input du DUT ??????????
        -- Cycle N   : présenter rom_addr = i
        -- Cycle N+1 : rom_data valide (latence 1 cycle ROM)
        --             ? écrire dans DUT via dma_wr_*
        -- Durée totale : TOTAL + 1 cycles
        procedure load_image_from_rom is
        begin
            -- Cycle 0 : présenter adresse 0
            wait until rising_edge(clk);
            rom_addr    <= std_logic_vector(to_unsigned(0, 10));
            dma_wr_en   <= '0';

            -- Cycles 1..TOTAL : rom_data valide pour addr i-1
            --                   on présente addr i en parallèle
            for i in 1 to TOTAL loop
                wait until rising_edge(clk);
                -- Écrire le pixel de l'adresse précédente (latence 1 cycle)
                dma_wr_en   <= '1';
                dma_wr_addr <= std_logic_vector(to_unsigned(i-1, 10));
                dma_wr_data <= rom_data;
                -- Présenter l'adresse suivante (sauf dernier cycle)
                if i < TOTAL then
                    rom_addr <= std_logic_vector(to_unsigned(i, 10));
                end if;
            end loop;

            -- Cycle TOTAL+1 : fin
            wait until rising_edge(clk);
            dma_wr_en   <= '0';
            dma_wr_addr <= (others => '0');
            dma_wr_data <= (others => '0');
            rom_addr    <= (others => '0');
        end procedure;

        -- ?? Lire et afficher les résultats ???????????????????????????????????
        procedure read_results(frame_id : integer) is
            variable val : integer;
        begin
            report "--- Résultats frame " & integer'image(frame_id) & " ---";
            for ch in 0 to OCH-1 loop
                for i in 0 to OUT_SZ-1 loop
                    wait until rising_edge(clk);
                    out_rd_en   <= '1';
                    out_rd_addr <= std_logic_vector(to_unsigned(i, 10));
                    out_rd_ch   <= std_logic_vector(to_unsigned(ch, 2));
                    wait until rising_edge(clk);
                    out_rd_en <= '0';
                    wait until rising_edge(clk);  -- latence BRAM sortie 1 cycle
                    val := to_integer(signed(out_rd_data));
                    if val /= 0 then
                        report "  ch=" & integer'image(ch)
                             & " px=" & integer'image(i)
                             & " val=" & integer'image(val);
                    end if;
                end loop;
            end loop;
            report "--- Fin frame " & integer'image(frame_id) & " ---";
        end procedure;

    begin
        -- ?? Reset ?????????????????????????????????????????????????????????????
        rst <= '1';
        wait for 10 * CLK_P;
        rst <= '0';
        wait for 5 * CLK_P;

        -- =====================================================================
        -- FRAME 0 : charger image depuis ROM ? start ? done
        -- =====================================================================
        report "?? FRAME 0 : chargement depuis ROM ??";
        load_image_from_rom;
        wait for 2 * CLK_P;

        report "?? FRAME 0 : start convolution ??";
        wait until rising_edge(clk);
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        wait until done = '1';
        wait for 2 * CLK_P;
        report "?? FRAME 0 : done ??";
        read_results(0);
        wait for 4 * CLK_P;

        -- =====================================================================
        -- FRAME 1 - ping-pong
        -- Calcul frame 1 ET chargement frame 2 en parallèle
        -- =====================================================================
        report "?? FRAME 1 : ping-pong ??";

        wait until rising_edge(clk);
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        -- Pendant le calcul de frame 1, charger frame 2 dans la bank libre
        load_image_from_rom;

        wait until done = '1';
        wait for 2 * CLK_P;
        report "?? FRAME 1 : done ??";
        read_results(1);
        wait for 4 * CLK_P;

        -- =====================================================================
        -- FRAME 2
        -- =====================================================================
        report "?? FRAME 2 ??";

        wait until rising_edge(clk);
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        wait until done = '1';
        wait for 2 * CLK_P;
        report "?? FRAME 2 : done ??";
        read_results(2);

        report "?? SIMULATION TERMINÉE ??";
        wait;
    end process;

end sim;