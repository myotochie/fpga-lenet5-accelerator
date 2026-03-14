----------------------------------------------------------------------------------
-- tb_maxpool2d.vhd
-- ROM initialisée depuis output_conv1_streaming.txt (sortie Conv1 + ReLU)
-- Toutes les valeurs sont >= 0 après ReLU intégré dans Conv1.
--
-- La procédure read_signed_int est conservée par robustesse
-- (fonctionne sur valeurs positives ET négatives).
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.lenet_types_pkg.all;

entity tb_maxpool2d is
end tb_maxpool2d;

architecture Behavioral of tb_maxpool2d is

    ---------------------------------------------------------------------------
    -- Paramètres
    ---------------------------------------------------------------------------
    constant IN_WIDTH    : integer := 28;
    constant IN_HEIGHT   : integer := 28;
    constant IN_CHANNELS : integer := 3;
    constant POOL_SIZE   : integer := 2;
    constant OUT_WIDTH   : integer := 14;
    constant OUT_HEIGHT  : integer := 14;

    constant IN_SIZE  : integer := IN_WIDTH  * IN_HEIGHT  * IN_CHANNELS;  -- 2352
    constant OUT_SIZE : integer := OUT_WIDTH * OUT_HEIGHT * IN_CHANNELS;  -- 588

    constant CLK_PERIOD : time := 10 ns;

    ---------------------------------------------------------------------------
    -- Type ROM
    ---------------------------------------------------------------------------
    type rom_type is array (0 to IN_SIZE-1) of int8;

    ---------------------------------------------------------------------------
    -- Procédure : parse un entier signé depuis une ligne textio
    -- Conservée pour robustesse même si les valeurs sont >= 0 après ReLU
    ---------------------------------------------------------------------------
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
                if c = '-' then
                    is_neg := true;
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

    ---------------------------------------------------------------------------
    -- Initialisation ROM depuis fichier
    ---------------------------------------------------------------------------
    impure function init_rom_from_file(filename : string) return rom_type is
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

    ---------------------------------------------------------------------------
    -- ROM Conv1 + ReLU
    -- Source : output_conv1_streaming.txt
    -- Toutes les valeurs sont dans [0, 127] grâce au ReLU intégré dans Conv1
    ---------------------------------------------------------------------------
    constant CONV1_ROM : rom_type :=
        init_rom_from_file("output_conv1_streaming.txt");

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

    signal sim_done      : boolean := false;
    signal cycle_counter : integer := 0;

    ---------------------------------------------------------------------------
    -- Composant
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
    -- DUT
    ---------------------------------------------------------------------------
    DUT : maxpool2d
        generic map (
            IN_WIDTH    => IN_WIDTH,
            IN_HEIGHT   => IN_HEIGHT,
            IN_CHANNELS => IN_CHANNELS,
            POOL_SIZE   => POOL_SIZE
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
    -- ROM Conv1+ReLU : BRAM synchrone 1 cycle latence
    ---------------------------------------------------------------------------
    rom_proc : process(clk)
        variable addr_v : integer;
    begin
        if rising_edge(clk) then
            addr_v := to_integer(unsigned(in_addr));
            if addr_v >= 0 and addr_v < IN_SIZE then
                in_data <= CONV1_ROM(addr_v);
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
            if rst = '1' then
                cycle_counter <= 0;
            else
                cycle_counter <= cycle_counter + 1;
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
        variable neg_count   : integer := 0;
    begin
        report "=====================================================" severity note;
        report "=== TESTBENCH MAXPOOL2D 2x2 (apres Conv1+ReLU) ===" severity note;
        report "  Source : output_conv1_streaming.txt (valeurs >= 0)" severity note;
        report "  Entree : " & integer'image(IN_WIDTH)  & "x" &
               integer'image(IN_HEIGHT) & "x" & integer'image(IN_CHANNELS) &
               " = " & integer'image(IN_SIZE) & " valeurs" severity note;
        report "  Sortie : " & integer'image(OUT_WIDTH) & "x" &
               integer'image(OUT_HEIGHT) & "x" & integer'image(IN_CHANNELS) &
               " = " & integer'image(OUT_SIZE) & " valeurs" severity note;

        -- Vérification ROM : 6 premières valeurs (toutes >= 0 après ReLU)
        report "  Verification ROM[0..5] (attendu : valeurs >= 0) :" severity note;
        report "  ROM[0]=" & integer'image(to_integer(CONV1_ROM(0))) &
               " ROM[1]=" & integer'image(to_integer(CONV1_ROM(1))) &
               " ROM[2]=" & integer'image(to_integer(CONV1_ROM(2))) &
               " ROM[3]=" & integer'image(to_integer(CONV1_ROM(3))) &
               " ROM[4]=" & integer'image(to_integer(CONV1_ROM(4))) &
               " ROM[5]=" & integer'image(to_integer(CONV1_ROM(5))) severity note;

        -- Vérification sanity : compter les valeurs négatives (doit être 0)
        neg_count := 0;
        for i in 0 to IN_SIZE-1 loop
            if CONV1_ROM(i) < to_signed(0, 8) then
                neg_count := neg_count + 1;
            end if;
        end loop;
        if neg_count = 0 then
            report "  Sanity check OK : 0 valeur negative dans la ROM" severity note;
        else
            report "  ATTENTION : " & integer'image(neg_count) &
                   " valeurs negatives detectees (ReLU actif ?)" severity warning;
        end if;
        report "=====================================================" severity note;

        rst   <= '1';
        start <= '0';
        wait for CLK_PERIOD * 5;
        rst   <= '0';
        wait for CLK_PERIOD * 3;

        -- Démarrage
        wait until rising_edge(clk);
        v_start_cyc := cycle_counter;
        report "=== DEMARRAGE MaxPool ===" severity note;

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
            report "=== DONE ===" severity note;
            report "  Cycles MaxPool : " &
                   integer'image(v_end_cyc - v_start_cyc) severity note;
        else
            report "=== TIMEOUT apres " & integer'image(timeout_cnt) &
                   " cycles ===" severity error;
        end if;

        wait for CLK_PERIOD * 5;

        -- Aperçu résultats : 3 premiers pixels de sortie
        -- Toutes valeurs >= 0 car max(valeurs >= 0) >= 0
        report "=== APERCU SORTIES (3 premiers pixels) ===" severity note;
        for pix in 0 to 2 loop
            report "  pool[" & integer'image(pix) & "] = [ch0=" &
                   integer'image(to_integer(output_memory(pix*3+0))) & " ch1=" &
                   integer'image(to_integer(output_memory(pix*3+1))) & " ch2=" &
                   integer'image(to_integer(output_memory(pix*3+2))) & "]"
                   severity note;
        end loop;

        -- Vérification fenêtre (0,0) par canal
        -- Adresses : ch0 ? 0,3,84,87 | ch1 ? 1,4,85,88 | ch2 ? 2,5,86,89
        -- max pooling 2x2 sur valeurs >= 0 ? résultat >= 0
        report "=== VERIFICATION fenetre (0,0) ===" severity note;
        report "  Canal 0 : in=" &
               integer'image(to_integer(CONV1_ROM(0)))  & "," &
               integer'image(to_integer(CONV1_ROM(3)))  & "," &
               integer'image(to_integer(CONV1_ROM(84))) & "," &
               integer'image(to_integer(CONV1_ROM(87))) &
               " ? pool=" & integer'image(to_integer(output_memory(0))) severity note;
        report "  Canal 1 : in=" &
               integer'image(to_integer(CONV1_ROM(1)))  & "," &
               integer'image(to_integer(CONV1_ROM(4)))  & "," &
               integer'image(to_integer(CONV1_ROM(85))) & "," &
               integer'image(to_integer(CONV1_ROM(88))) &
               " ? pool=" & integer'image(to_integer(output_memory(1))) severity note;
        report "  Canal 2 : in=" &
               integer'image(to_integer(CONV1_ROM(2)))  & "," &
               integer'image(to_integer(CONV1_ROM(5)))  & "," &
               integer'image(to_integer(CONV1_ROM(86))) & "," &
               integer'image(to_integer(CONV1_ROM(89))) &
               " ? pool=" & integer'image(to_integer(output_memory(2))) severity note;

        -- Sauvegarde output_pool1_14x14x3.txt
        -- Format interleaved identique ? compatible avec la suite du réseau
        file_open(f_out, "output_pool1_14x14x3.txt", write_mode);
        for i in 0 to OUT_SIZE-1 loop
            write(line_v, to_integer(output_memory(i)));
            writeline(f_out, line_v);
        end loop;
        file_close(f_out);

        report "  " & integer'image(OUT_SIZE) &
               " valeurs sauvegardees dans output_pool1_14x14x3.txt" severity note;
        report "=== FIN TEST MAXPOOL2D ===" severity note;
        report "=====================================================" severity note;

        sim_done <= true;
        wait;
    end process;

end Behavioral;