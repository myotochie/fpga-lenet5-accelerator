----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2026 15:38:24
-- Design Name: 
-- Module Name: lenet_axi_wrapper - Behavioral
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

----------------------------------------------------------------------------------
-- lenet_axi_wrapper.vhd
-- Wrapper AXI-Lite pour top_lenet_full
--
-- RÔLE :
--   Expose top_lenet_full à la PS Zynq via un bus AXI-Lite (S_AXI_CTRL).
--   La BRAM d'entrée (blk_mem_in) est rendue dual-port :
--     - Port A interne : lu par top_lenet_full (inchangé)
--     - Port B externe : connecté à un axi_bram_ctrl dans le BD
--       ? la PS écrit l'image (1024 octets) via ce second port
--
-- MAP MÉMOIRE AXI-Lite (offset depuis base addr) :
--
--   Offset | Accès | Signal          | Description
--   -------|-------|-----------------|------------------------------------
--   0x00   | W/R   | CTRL            | bit0=ap_start(W), bit1=ap_done(R),
--           |       |                 | bit2=ap_idle(R)
--   0x04   | R     | STATUS          | bit0=done, bit1=idle (alias)
--   0x10   | R     | SCORE_0         | logit[0] int8 ? int32 sign-extended
--   0x14   | R     | SCORE_1         | logit[1]
--   0x18   | R     | SCORE_2
--   0x1C   | R     | SCORE_3
--   0x20   | R     | SCORE_4
--   0x24   | R     | SCORE_5
--   0x28   | R     | SCORE_6
--   0x2C   | R     | SCORE_7
--   0x30   | R     | SCORE_8
--   0x34   | R     | SCORE_9
--
-- MÉCANISME ap_start :
--   La PS écrit 0x1 sur CTRL offset 0x00.
--   Le wrapper génère un pulse 1 cycle sur start interne.
--   ap_done se set quand top_lenet_full lève done.
--   ap_done et ap_idle lisibles sur CTRL[1:2] et STATUS[0:1].
--   ap_done s'efface au prochain ap_start.
--
-- BRAM d'entrée dual-port :
--   Ce module NE gère PAS le Port B de blk_mem_in.
--   blk_mem_in doit être reconfigurée en True Dual Port dans Vivado :
--     Port A : clka, addra(9:0), douta(7:0)       ? inchangé (top_lenet_full)
--     Port B : clkb, web(0:0), addrb(9:0), dinb(7:0), doutb(7:0)
--                                                 ? connecté à axi_bram_ctrl_0
--
-- INTERFACE :
--   s_axi_*   : AXI-Lite slave (connecté au PS via AXI Interconnect)
--   Toutes les BRAMs sauf blk_mem_in sont instanciées dans top_lenet_full
--
-- NOTE BLOCK DESIGN :
--   - lenet_axi_wrapper ? S_AXI_CTRL ? AXI Interconnect ? PS7 M_AXI_GP0
--   - axi_bram_ctrl_0   ? BRAM_PORTA  ? blk_mem_in Port B
--   - axi_bram_ctrl_0   ? S_AXI       ? AXI Interconnect ? PS7 M_AXI_GP0
--   - blk_mem_in Port A reste câblé à l'intérieur de top_lenet_full
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

entity lenet_axi_wrapper is
    generic (
        C_S_AXI_DATA_WIDTH : integer := 32;
        C_S_AXI_ADDR_WIDTH : integer := 6    -- 64 octets suffisent (0x00..0x34)
    );
    port (
        -- AXI-Lite Slave Clock / Reset
        s_axi_aclk    : in  std_logic;
        s_axi_aresetn : in  std_logic;

        -- AXI-Lite Write Address
        s_axi_awaddr  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        s_axi_awprot  : in  std_logic_vector(2 downto 0);
        s_axi_awvalid : in  std_logic;
        s_axi_awready : out std_logic;

        -- AXI-Lite Write Data
        s_axi_wdata   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        s_axi_wstrb   : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        s_axi_wvalid  : in  std_logic;
        s_axi_wready  : out std_logic;

        -- AXI-Lite Write Response
        s_axi_bresp   : out std_logic_vector(1 downto 0);
        s_axi_bvalid  : out std_logic;
        s_axi_bready  : in  std_logic;

        -- AXI-Lite Read Address
        s_axi_araddr  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        s_axi_arprot  : in  std_logic_vector(2 downto 0);
        s_axi_arvalid : in  std_logic;
        s_axi_arready : out std_logic;

        -- AXI-Lite Read Data
        s_axi_rdata   : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        s_axi_rresp   : out std_logic_vector(1 downto 0);
        s_axi_rvalid  : out std_logic;
        s_axi_rready  : in  std_logic;
        
        bram_in_addr : out std_logic_vector(9 downto 0);
        bram_in_data : in  std_logic_vector(7 downto 0)
    );
end lenet_axi_wrapper;

architecture Behavioral of lenet_axi_wrapper is

    ---------------------------------------------------------------------------
    -- Signaux internes AXI-Lite
    ---------------------------------------------------------------------------
    signal axi_awready : std_logic := '0';
    signal axi_wready  : std_logic := '0';
    signal axi_bvalid  : std_logic := '0';
    signal axi_arready : std_logic := '0';
    signal axi_rvalid  : std_logic := '0';
    signal axi_rdata   : std_logic_vector(31 downto 0) := (others => '0');

    -- Adresses capturées
    signal aw_addr_reg : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal ar_addr_reg : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);

    -- Registres AXI internes
    signal reg_ctrl   : std_logic_vector(31 downto 0) := (others => '0');
    -- reg_ctrl[0] = ap_start (auto-clear après 1 cycle)
    -- reg_ctrl[1] = ap_done  (read-only, mis à jour par le top)
    -- reg_ctrl[2] = ap_idle  (read-only)

    type score_reg_type is array (0 to 9) of std_logic_vector(31 downto 0);
    signal score_regs : score_reg_type := (others => (others => '0'));

    ---------------------------------------------------------------------------
    -- Signaux vers/depuis top_lenet_full
    ---------------------------------------------------------------------------
    signal top_start     : std_logic := '0';
    signal top_done      : std_logic;
    signal top_fc_valid  : std_logic;
    signal top_fc_data   : int8_vector(0 to 9);

    signal ap_start_pulse : std_logic := '0';  -- pulse 1 cycle
    signal ap_done_reg    : std_logic := '0';
    signal ap_idle_reg    : std_logic := '1';

    -- top_lenet_full reset (actif haut depuis aresetn actif bas)
    signal top_rst : std_logic;

    ---------------------------------------------------------------------------
    -- Composant top_lenet_full
    ---------------------------------------------------------------------------
    component top_lenet_full2
        port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        start : in  std_logic;
        done  : out std_logic;

        -- Logits FC (10 classes)
        fc_out_data  : out int8_vector(0 to 9);
        fc_out_valid : out std_logic;
               -- Port A de blk_mem_in (image input depuis BD)
        c1_in_bram_addr : out std_logic_vector(9 downto 0);
        c1_in_bram_data : in  std_logic_vector(7 downto 0)
        );
    end component;

begin

    ---------------------------------------------------------------------------
    -- Connexion signaux AXI-Lite vers sorties
    ---------------------------------------------------------------------------
    s_axi_awready <= axi_awready;
    s_axi_wready  <= axi_wready;
    s_axi_bresp   <= "00";   -- OKAY
    s_axi_bvalid  <= axi_bvalid;
    s_axi_arready <= axi_arready;
    s_axi_rdata   <= axi_rdata;
    s_axi_rresp   <= "00";   -- OKAY
    s_axi_rvalid  <= axi_rvalid;

    -- Reset top (actif haut = aresetn bas)
    top_rst <= not s_axi_aresetn;

    ---------------------------------------------------------------------------
    -- Instanciation top_lenet_full
    ---------------------------------------------------------------------------
    U_TOP : top_lenet_full2
        port map (
            clk          => s_axi_aclk,
            rst          => top_rst,
            start        => top_start,
            done         => top_done,
            fc_out_data  => top_fc_data,
            fc_out_valid => top_fc_valid,
           c1_in_bram_addr  => bram_in_addr,
           c1_in_bram_data  => bram_in_data
        );

    ---------------------------------------------------------------------------
    -- Capture scores FC dans registres AXI (sur fc_out_valid)
    ---------------------------------------------------------------------------
    score_capture : process(s_axi_aclk)
    begin
        if rising_edge(s_axi_aclk) then
            if s_axi_aresetn = '0' then
                for i in 0 to 9 loop
                    score_regs(i) <= (others => '0');
                end loop;
            elsif top_fc_valid = '1' then
                for i in 0 to 9 loop
                    -- Sign-extend int8 ? int32
                    score_regs(i) <= std_logic_vector(
                        resize(top_fc_data(i), 32));
                end loop;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- Gestion ap_done / ap_idle
    ---------------------------------------------------------------------------
    ap_ctrl : process(s_axi_aclk)
    begin
        if rising_edge(s_axi_aclk) then
            if s_axi_aresetn = '0' then
                ap_done_reg <= '0';
                ap_idle_reg <= '1';
            else
                -- ap_done : set sur top_done, clear sur nouvel ap_start
                if top_done = '1' then
                    ap_done_reg <= '1';
                    ap_idle_reg <= '1';
                end if;
                if ap_start_pulse = '1' then
                    ap_done_reg <= '0';
                    ap_idle_reg <= '0';
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- AXI-Lite Write : AWReady / WReady
    ---------------------------------------------------------------------------
    axi_aw_proc : process(s_axi_aclk)
    begin
        if rising_edge(s_axi_aclk) then
            if s_axi_aresetn = '0' then
                axi_awready    <= '0';
                axi_wready     <= '0';
                aw_addr_reg    <= (others => '0');
                axi_bvalid     <= '0';
                top_start      <= '0';
                ap_start_pulse <= '0';
            else
                top_start      <= '0';
                ap_start_pulse <= '0';

                -- Accepte write address + write data ensemble (simplification)
                if axi_awready = '0' and s_axi_awvalid = '1' and
                   axi_wready  = '0' and s_axi_wvalid  = '1' then
                    axi_awready <= '1';
                    axi_wready  <= '1';
                    aw_addr_reg <= s_axi_awaddr;
                else
                    axi_awready <= '0';
                    axi_wready  <= '0';
                end if;

                -- Décodage registre écrit
                if axi_awready = '1' and s_axi_awvalid = '1' and
                   axi_wready  = '1' and s_axi_wvalid  = '1' then

                    case aw_addr_reg(5 downto 2) is
                        when "0000" =>   -- offset 0x00 : CTRL
                            -- bit0 = ap_start
                            if s_axi_wdata(0) = '1' then
                                top_start      <= '1';
                                ap_start_pulse <= '1';
                            end if;
                        when others =>
                            null;  -- autres offsets : lecture seule
                    end case;

                    -- Réponse write
                    axi_bvalid <= '1';
                else
                    if s_axi_bready = '1' and axi_bvalid = '1' then
                        axi_bvalid <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- AXI-Lite Read : ARReady / RValid / RData
    ---------------------------------------------------------------------------
    axi_ar_proc : process(s_axi_aclk)
    begin
        if rising_edge(s_axi_aclk) then
            if s_axi_aresetn = '0' then
                axi_arready <= '0';
                axi_rvalid  <= '0';
                axi_rdata   <= (others => '0');
                ar_addr_reg <= (others => '0');
            else
                if axi_arready = '0' and s_axi_arvalid = '1' then
                    axi_arready <= '1';
                    ar_addr_reg <= s_axi_araddr;
                else
                    axi_arready <= '0';
                end if;

                if axi_arready = '1' and s_axi_arvalid = '1' and
                   axi_rvalid  = '0' then
                    axi_rvalid <= '1';

                    -- Décodage registre lu
                    case ar_addr_reg(5 downto 2) is
                        when "0000" =>   -- 0x00 : CTRL
                            axi_rdata <= (31 downto 3 => '0') &
                                         ap_idle_reg &
                                         ap_done_reg &
                                         '0';   -- bit0 : ap_start toujours 0 en lecture
                        when "0001" =>   -- 0x04 : STATUS (alias)
                            axi_rdata <= (31 downto 2 => '0') &
                                         ap_idle_reg &
                                         ap_done_reg;
                        when "0100" =>   -- 0x10 : SCORE_0
                            axi_rdata <= score_regs(0);
                        when "0101" =>   -- 0x14 : SCORE_1
                            axi_rdata <= score_regs(1);
                        when "0110" =>   -- 0x18 : SCORE_2
                            axi_rdata <= score_regs(2);
                        when "0111" =>   -- 0x1C : SCORE_3
                            axi_rdata <= score_regs(3);
                        when "1000" =>   -- 0x20 : SCORE_4
                            axi_rdata <= score_regs(4);
                        when "1001" =>   -- 0x24 : SCORE_5
                            axi_rdata <= score_regs(5);
                        when "1010" =>   -- 0x28 : SCORE_6
                            axi_rdata <= score_regs(6);
                        when "1011" =>   -- 0x2C : SCORE_7
                            axi_rdata <= score_regs(7);
                        when "1100" =>   -- 0x30 : SCORE_8
                            axi_rdata <= score_regs(8);
                        when "1101" =>   -- 0x34 : SCORE_9
                            axi_rdata <= score_regs(9);
                        when others =>
                            axi_rdata <= (others => '0');
                    end case;

                elsif s_axi_rready = '1' and axi_rvalid = '1' then
                    axi_rvalid <= '0';
                end if;
            end if;
        end if;
    end process;

end Behavioral;
