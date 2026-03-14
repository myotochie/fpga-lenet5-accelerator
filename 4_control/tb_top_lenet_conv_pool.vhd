----------------------------------------------------------------------------------
-- tb_top_lenet_conv_pool.vhd
-- Testbench de la chaîne complète :
--   Conv1 ? ReLU ? MaxPool1 ? Conv2 ? ReLU ? MaxPool2
--
-- Style identique à tb_top_conv1_pool1.vhd :
--   - BRAMs Xilinx instanciées dans le testbench (reliées au DUT via ports)
--   - Capture sortie sur pool2_out_we dans un tableau VHDL (pool2_output)
--   - Sauvegarde output_pool2_5x5x6.txt
--
-- Timeout : 200 000 cycles
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

entity tb_top_lenet_conv_pool is
end tb_top_lenet_conv_pool;

architecture Behavioral of tb_top_lenet_conv_pool is

    ---------------------------------------------------------------------------
    -- Paramètres
    ---------------------------------------------------------------------------
    constant CLK_PERIOD     : time    := 10 ns;
    constant POOL2_OUT_SIZE : integer := 5 * 5 * 6;  -- 150

    ---------------------------------------------------------------------------
    -- Signaux DUT
    ---------------------------------------------------------------------------
    signal clk   : std_logic := '0';
    signal rst   : std_logic := '0';
    signal start : std_logic := '0';
    signal done  : std_logic;

    -- Sortie MaxPool2 (port externe du top)
    signal pool2_out_addr : std_logic_vector(11 downto 0);
    signal pool2_out_data : int8;
    signal pool2_out_we   : std_logic;

    ---------------------------------------------------------------------------
    -- Mémoire de sortie MaxPool2 (capturée sur pool2_out_we)
    ---------------------------------------------------------------------------
    type pool2_mem_type is array (0 to POOL2_OUT_SIZE-1) of int8;
    signal pool2_output : pool2_mem_type := (others => (others => '0'));

    ---------------------------------------------------------------------------
    -- Supervision
    ---------------------------------------------------------------------------
    signal cycle_counter  : integer   := 0;
    signal latency_cycles : integer   := 0;
    signal measuring      : std_logic := '0';
    signal sim_done       : boolean   := false;

    ---------------------------------------------------------------------------
    -- Composant DUT
    ---------------------------------------------------------------------------
    component top_lenet_conv_pool
        port (
            clk            : in  std_logic;
            rst            : in  std_logic;
            start          : in  std_logic;
            done           : out std_logic;
            pool2_out_addr : out std_logic_vector(11 downto 0);
            pool2_out_data : out int8;
            pool2_out_we   : out std_logic
        );
    end component;

begin

    ---------------------------------------------------------------------------
    -- DUT
    -- Toutes les BRAMs (blk_mem_in, blk_mem_c11_w..c26_w, blk_mem_c1_b,
    -- blk_mem_c2_b) sont instanciées à l'intérieur du top
    ---------------------------------------------------------------------------
    DUT : top_lenet_conv_pool
        port map (
            clk            => clk,
            rst            => rst,
            start          => start,
            done           => done,
            pool2_out_addr => pool2_out_addr,
            pool2_out_data => pool2_out_data,
            pool2_out_we   => pool2_out_we
        );

    ---------------------------------------------------------------------------
    -- Capture sortie MaxPool2
    -- Même principe que pool_capture dans tb_top_conv1_pool1 :
    -- On écoute pool2_out_we et on stocke dans pool2_output(addr)
    ---------------------------------------------------------------------------
    pool2_capture : process(clk)
        variable addr_v : integer;
    begin
        if rising_edge(clk) then
            if pool2_out_we = '1' then
                addr_v := to_integer(unsigned(pool2_out_addr));
                if addr_v >= 0 and addr_v < POOL2_OUT_SIZE then
                    pool2_output(addr_v) <= pool2_out_data;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- Horloge
    ---------------------------------------------------------------------------
    clk_process : process
    begin
        while not sim_done loop
            clk <= '0'; wait for CLK_PERIOD / 2;
            clk <= '1'; wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    ---------------------------------------------------------------------------
    -- Compteur de cycles
    ---------------------------------------------------------------------------
    cycle_cnt : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cycle_counter <= 0;
            else
                cycle_counter <= cycle_counter + 1;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- Mesure de latence synchrone (visible dans Vivado waveform)
    ---------------------------------------------------------------------------
    latency_proc : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                latency_cycles <= 0;
                measuring      <= '0';
            else
                if start = '1' then
                    latency_cycles <= 0;
                    measuring      <= '1';
                elsif done = '1' and measuring = '1' then
                    latency_cycles <= latency_cycles + 1;
                    measuring      <= '0';
                elsif measuring = '1' then
                    latency_cycles <= latency_cycles + 1;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- Stimulus
    ---------------------------------------------------------------------------
    stimulus : process
        variable line_v      : line;
        file f_out           : text;
        variable v_start_cyc : integer := 0;
        variable v_end_cyc   : integer := 0;
        variable timeout_cnt : integer := 0;
    begin
        report "========================================================" severity note;
        report "=== TESTBENCH CHAINE COMPLETE LeNet ===" severity note;
        report "  Conv1  : 32x32x1  ? 28x28x3  (ReLU)" severity note;
        report "  Pool1  : 28x28x3  ? 14x14x3  (MaxPool 2x2)" severity note;
        report "  Conv2  : 14x14x3  ? 10x10x6  (ReLU)" severity note;
        report "  Pool2  : 10x10x6  ? 5x5x6    (MaxPool 2x2)" severity note;
        report "  Sortie : output_pool2_5x5x6.txt (150 valeurs HWC)" severity note;
        report "  Latence estimee : ~9500 cycles / ~95 us" severity note;
        report "========================================================" severity note;

        rst   <= '1';
        start <= '0';
        wait for CLK_PERIOD * 10;
        rst   <= '0';
        wait for CLK_PERIOD * 5;

        -- Démarrage
        wait until rising_edge(clk);
        v_start_cyc := cycle_counter;
        report "=== DEMARRAGE au cycle " &
               integer'image(v_start_cyc) & " ===" severity note;

        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        -- Attente done avec rapport toutes les 2000 cycles
        timeout_cnt := 0;
        while done /= '1' and timeout_cnt < 200000 loop
            wait until rising_edge(clk);
            timeout_cnt := timeout_cnt + 1;
            if timeout_cnt mod 2000 = 0 then
                report "  ... " & integer'image(timeout_cnt) &
                       " cycles ecoules ..." severity note;
            end if;
        end loop;

        v_end_cyc := cycle_counter;

        if done = '1' then
            report "========================================================" severity note;
            report "=== DONE ===" severity note;
            report "  Cycle start    : " & integer'image(v_start_cyc) severity note;
            report "  Cycle done     : " & integer'image(v_end_cyc)   severity note;
            report "  Latence totale : " &
                   integer'image(v_end_cyc - v_start_cyc) & " cycles" severity note;
            report "  Latence totale : " &
                   integer'image((v_end_cyc - v_start_cyc) * 10) & " ns" severity note;
            report "  (signal latency_cycles visible dans Vivado waveform)" severity note;
            report "========================================================" severity note;
        else
            report "=== TIMEOUT apres 200000 cycles ===" severity error;
            report "  Verifier : BRAMs initialisees, FSM top, done signal" severity error;
        end if;

        wait for CLK_PERIOD * 5;

        -- Aperçu : 5 premiers pixels (6 canaux chacun)
        report "=== APERCU Pool2 (5 premiers pixels HWC) ===" severity note;
        for pix in 0 to 4 loop
            report "  pixel[" & integer'image(pix) & "] = [" &
                   integer'image(to_integer(pool2_output(pix*6+0))) & "," &
                   integer'image(to_integer(pool2_output(pix*6+1))) & "," &
                   integer'image(to_integer(pool2_output(pix*6+2))) & "," &
                   integer'image(to_integer(pool2_output(pix*6+3))) & "," &
                   integer'image(to_integer(pool2_output(pix*6+4))) & "," &
                   integer'image(to_integer(pool2_output(pix*6+5))) & "]"
                   severity note;
        end loop;

        -- Sauvegarde output_pool2_5x5x6.txt
        file_open(f_out, "output_pool2_5x5x6.txt", write_mode);
        for i in 0 to POOL2_OUT_SIZE-1 loop
            write(line_v, to_integer(pool2_output(i)));
            writeline(f_out, line_v);
        end loop;
        file_close(f_out);

        report "  " & integer'image(POOL2_OUT_SIZE) &
               " valeurs sauvegardees dans output_pool2_5x5x6.txt" severity note;
        report "=== FIN SIMULATION ===" severity note;
        report "========================================================" severity note;

        sim_done <= true;
        wait;
    end process;

end Behavioral;