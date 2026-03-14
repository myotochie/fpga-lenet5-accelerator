----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.03.2026 13:43:52
-- Design Name: 
-- Module Name: tb_maxpool2d_p2 - Behavioral
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
-- tb_maxpool2d_p2.vhd
-- Testbench MaxPool2 : 10×10×6 ? 5×5×6, pool 2×2
--
-- Réutilise maxpool2d.vhd SANS modification (génériques seulement)
--
-- Entrée : output_conv2_streaming.txt  (600 valeurs, HWC interleaved)
-- Sortie : output_pool2_5x5x6.txt      (150 valeurs, HWC interleaved)
--
-- FORMAT DONNÉES (identique à Pool1) :
--   index = (y * WIDTH + x) * CHANNELS + ch
--   ? ch varie le plus vite (HWC)
--
-- VÉRIFICATION ADRESSAGE MaxPool2 :
--   ADDR_PIX calcule :
--     next_addr = (cur_y * IN_WIDTH + cur_x) * IN_CHANNELS + ch
--   Avec IN_WIDTH=10, IN_CHANNELS=6 ? compatible avec Conv2 HWC ?
--
--   WRITE_OUT écrit :
--     out_addr = (y_out * OUT_WIDTH + x_out) * IN_CHANNELS + ch
--   Avec OUT_WIDTH=5, IN_CHANNELS=6 ? sortie HWC 5×5×6 ?
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.lenet_types_pkg.all;

entity tb_maxpool2d_p2 is
end tb_maxpool2d_p2;

architecture Behavioral of tb_maxpool2d_p2 is

    ---------------------------------------------------------------------------
    -- Paramètres
    ---------------------------------------------------------------------------
    constant IN_WIDTH    : integer := 10;
    constant IN_HEIGHT   : integer := 10;
    constant IN_CHANNELS : integer := 6;
    constant POOL_SIZE   : integer := 2;
    constant OUT_WIDTH   : integer := 5;
    constant OUT_HEIGHT  : integer := 5;

    constant IN_SIZE  : integer := IN_WIDTH  * IN_HEIGHT  * IN_CHANNELS;  -- 600
    constant OUT_SIZE : integer := OUT_WIDTH * OUT_HEIGHT * IN_CHANNELS;  -- 150

    constant CLK_PERIOD : time := 10 ns;

    ---------------------------------------------------------------------------
    -- ROM entrée (Conv2 output)
    ---------------------------------------------------------------------------
    type rom_type is array (0 to IN_SIZE-1) of int8;

    procedure read_signed_int(l      : inout line;
                               result : out   integer) is
        variable c      : character;
        variable is_neg : boolean := false;
        variable val    : integer := 0;
        variable good   : boolean;
    begin
        loop
            exit when l = null or l'length = 0;
            read(l, c, good);
            exit when not good;
            if c /= ' ' and c /= HT then
                if c = '-' then is_neg := true;
                elsif c >= '0' and c <= '9' then
                    val := character'pos(c) - character'pos('0');
                end if;
                exit;
            end if;
        end loop;
        loop
            exit when l = null or l'length = 0;
            read(l, c, good);
            exit when not good;
            exit when c < '0' or c > '9';
            val := val * 10 + (character'pos(c) - character'pos('0'));
        end loop;
        if is_neg then result := -val; else result := val; end if;
    end procedure;

    impure function init_rom(filename : string) return rom_type is
        file     f   : text;
        variable l   : line;
        variable val : integer;
        variable mem : rom_type := (others => (others => '0'));
    begin
        file_open(f, filename, read_mode);
        for i in 0 to IN_SIZE-1 loop
            if not endfile(f) then
                readline(f, l);
                read_signed_int(l, val);
                if val >  127 then val :=  127; end if;
                if val < -128 then val := -128; end if;
                mem(i) := to_signed(val, 8);
            end if;
        end loop;
        file_close(f);
        return mem;
    end function;

    constant CONV2_ROM : rom_type := init_rom("output_conv2_streaming.txt");

    ---------------------------------------------------------------------------
    -- Signaux DUT
    ---------------------------------------------------------------------------
    signal clk   : std_logic := '0';
    signal rst   : std_logic := '0';
    signal start : std_logic := '0';
    signal done  : std_logic;

    signal in_addr  : std_logic_vector(11 downto 0);
    signal in_data  : int8;

    signal out_addr : std_logic_vector(11 downto 0);
    signal out_data : int8;
    signal out_we   : std_logic;

    ---------------------------------------------------------------------------
    -- Mémoire de sortie
    ---------------------------------------------------------------------------
    type out_mem_type is array (0 to OUT_SIZE-1) of int8;
    signal output_memory : out_mem_type := (others => (others => '0'));

    ---------------------------------------------------------------------------
    -- Supervision
    ---------------------------------------------------------------------------
    signal sim_done       : boolean   := false;
    signal cycle_counter  : integer   := 0;
    signal latency_cycles : integer   := 0;
    signal measuring      : std_logic := '0';

    ---------------------------------------------------------------------------
    -- Composant (maxpool2d.vhd inchangé)
    ---------------------------------------------------------------------------
    component maxpool2d
        generic (
            IN_WIDTH    : integer;
            IN_HEIGHT   : integer;
            IN_CHANNELS : integer;
            POOL_SIZE   : integer
        );
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            start    : in  std_logic;
            done     : out std_logic;
            in_addr  : out std_logic_vector(11 downto 0);
            in_data  : in  int8;
            out_addr : out std_logic_vector(11 downto 0);
            out_data : out int8;
            out_we   : out std_logic
        );
    end component;

begin

    ---------------------------------------------------------------------------
    -- DUT : maxpool2d instancié avec les paramètres Pool2
    ---------------------------------------------------------------------------
    DUT : maxpool2d
        generic map (
            IN_WIDTH    => IN_WIDTH,    -- 10
            IN_HEIGHT   => IN_HEIGHT,   -- 10
            IN_CHANNELS => IN_CHANNELS, -- 6
            POOL_SIZE   => POOL_SIZE    -- 2
        )
        port map (
            clk      => clk,
            rst      => rst,
            start    => start,
            done     => done,
            in_addr  => in_addr,
            in_data  => in_data,
            out_addr => out_addr,
            out_data => out_data,
            out_we   => out_we
        );

    ---------------------------------------------------------------------------
    -- ROM Conv2 (BRAM synchrone 1 cycle latence)
    ---------------------------------------------------------------------------
    rom_proc : process(clk)
        variable addr_v : integer;
    begin
        if rising_edge(clk) then
            addr_v := to_integer(unsigned(in_addr));
            if addr_v >= 0 and addr_v < IN_SIZE then
                in_data <= CONV2_ROM(addr_v);
            else
                in_data <= (others => '0');
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- Capture sortie
    ---------------------------------------------------------------------------
    output_capture : process(clk)
        variable addr_v : integer;
    begin
        if rising_edge(clk) then
            if out_we = '1' then
                addr_v := to_integer(unsigned(out_addr));
                if addr_v >= 0 and addr_v < OUT_SIZE then
                    output_memory(addr_v) <= out_data;
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
            clk <= '0'; wait for CLK_PERIOD/2;
            clk <= '1'; wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    ---------------------------------------------------------------------------
    -- Compteur de cycles
    ---------------------------------------------------------------------------
    cycle_cnt : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then cycle_counter <= 0;
            else cycle_counter <= cycle_counter + 1;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- Mesure latence (visible dans Vivado waveform)
    ---------------------------------------------------------------------------
    latency_proc : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                latency_cycles <= 0; measuring <= '0';
            else
                if start = '1' then
                    latency_cycles <= 0; measuring <= '1';
                elsif done = '1' and measuring = '1' then
                    latency_cycles <= latency_cycles + 1; measuring <= '0';
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
        report "=====================================================" severity note;
        report "=== TESTBENCH MAXPOOL2 : 10x10x6 ? 5x5x6 ===" severity note;
        report "  Entree : output_conv2_streaming.txt (" &
               integer'image(IN_SIZE) & " valeurs)" severity note;
        report "  Sortie : output_pool2_5x5x6.txt (" &
               integer'image(OUT_SIZE) & " valeurs)" severity note;
        report "  Format : HWC interleaved (ch varie le plus vite)" severity note;
        report "=====================================================" severity note;

        -- Vérification ROM
        report "  ROM Conv2[0..5] :" severity note;
        report "  [0]=" & integer'image(to_integer(CONV2_ROM(0))) &
               " [1]=" & integer'image(to_integer(CONV2_ROM(1))) &
               " [2]=" & integer'image(to_integer(CONV2_ROM(2))) &
               " [3]=" & integer'image(to_integer(CONV2_ROM(3))) &
               " [4]=" & integer'image(to_integer(CONV2_ROM(4))) &
               " [5]=" & integer'image(to_integer(CONV2_ROM(5))) severity note;

        rst   <= '1';
        start <= '0';
        wait for CLK_PERIOD * 5;
        rst   <= '0';
        wait for CLK_PERIOD * 3;

        -- Démarrage
        wait until rising_edge(clk);
        v_start_cyc := cycle_counter;
        report "=== DEMARRAGE MaxPool2 au cycle " &
               integer'image(v_start_cyc) & " ===" severity note;

        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        -- Attente done avec timeout
        timeout_cnt := 0;
        while done /= '1' and timeout_cnt < 50000 loop
            wait until rising_edge(clk);
            timeout_cnt := timeout_cnt + 1;
        end loop;

        v_end_cyc := cycle_counter;

        if done = '1' then
            report "=====================================================" severity note;
            report "=== DONE ===" severity note;
            report "  Cycle start    : " & integer'image(v_start_cyc) severity note;
            report "  Cycle done     : " & integer'image(v_end_cyc)   severity note;
            report "  Latence totale : " &
                   integer'image(v_end_cyc - v_start_cyc) & " cycles" severity note;
            report "  Latence totale : " &
                   integer'image((v_end_cyc - v_start_cyc) * 10) & " ns" severity note;
            report "  (signal latency_cycles visible dans Vivado)" severity note;
            report "=====================================================" severity note;
        else
            report "=== TIMEOUT apres " & integer'image(timeout_cnt) &
                   " cycles ===" severity error;
        end if;

        wait for CLK_PERIOD * 5;

        -- Aperçu : 3 premiers pixels de sortie (6 canaux chacun)
        report "=== APERCU SORTIE (3 premiers pixels) ===" severity note;
        for pix in 0 to 2 loop
            report "  pool2[" & integer'image(pix) & "] = [" &
                   integer'image(to_integer(output_memory(pix*6+0))) & "," &
                   integer'image(to_integer(output_memory(pix*6+1))) & "," &
                   integer'image(to_integer(output_memory(pix*6+2))) & "," &
                   integer'image(to_integer(output_memory(pix*6+3))) & "," &
                   integer'image(to_integer(output_memory(pix*6+4))) & "," &
                   integer'image(to_integer(output_memory(pix*6+5))) & "]"
                   severity note;
        end loop;

        -- Vérification fenêtre (0,0) canal 0
        -- Pixels de la fenêtre 2×2 pour (x=0,y=0), ch=0 :
        --   pixel(0,0)ch0 = addr 0   pixel(1,0)ch0 = addr 6
        --   pixel(0,1)ch0 = addr 60  pixel(1,1)ch0 = addr 66
        report "=== VERIFICATION fenetre (0,0) canal 0 ===" severity note;
        report "  in[0]="  & integer'image(to_integer(CONV2_ROM(0)))  &
               " in[6]="  & integer'image(to_integer(CONV2_ROM(6)))  &
               " in[60]=" & integer'image(to_integer(CONV2_ROM(60))) &
               " in[66]=" & integer'image(to_integer(CONV2_ROM(66))) &
               "  ? pool=" & integer'image(to_integer(output_memory(0))) severity note;

        -- Sauvegarde output_pool2_5x5x6.txt
        file_open(f_out, "output_pool2_5x5x6.txt", write_mode);
        for i in 0 to OUT_SIZE-1 loop
            write(line_v, to_integer(output_memory(i)));
            writeline(f_out, line_v);
        end loop;
        file_close(f_out);

        report "  " & integer'image(OUT_SIZE) &
               " valeurs sauvegardees dans output_pool2_5x5x6.txt" severity note;
        report "=== FIN TEST MAXPOOL2 ===" severity note;
        report "=====================================================" severity note;

        sim_done <= true;
        wait;
    end process;

end Behavioral;
