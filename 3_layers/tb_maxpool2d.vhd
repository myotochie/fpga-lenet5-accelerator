----------------------------------------------------------------------------------
--! @file       tb_maxpool2d.vhd
--! @brief      Testbench for the maxpool2d module (2x2 Max Pooling Layer).
--!
--! @details    Validates the MaxPool2D module using as input the output of
--!             Conv1 + ReLU layer, loaded from an external text file
--!             (output_conv1_streaming.txt). Since ReLU is applied upstream,
--!             all input values are guaranteed to be in [0, 127].
--!
--!             The testbench:
--!               - Loads input data into a ROM from a text file at elaboration time.
--!               - Drives the DUT with a start pulse and waits for done.
--!               - Captures output values written by the DUT into an output memory.
--!               - Performs a sanity check (no negative values after ReLU).
--!               - Verifies the 2x2 pooling window for the first pixel, per channel.
--!               - Saves results to output_pool1_14x14x3.txt (interleaved format).
--!
--! @note       Input format  : interleaved HWC - 28x28x3 = 2352 int8 values.
--! @note       Output format : interleaved HWC - 14x14x3 = 588  int8 values.
--!
--! @author     myotochie
--! @date       2025
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.lenet_types_pkg.all;

--! @brief Top-level testbench entity for maxpool2d.
--! @details No ports - this is a self-contained simulation entity.
entity tb_maxpool2d is
end tb_maxpool2d;

--! @brief Behavioral architecture of tb_maxpool2d.
architecture Behavioral of tb_maxpool2d is

    ---------------------------------------------------------------------------
    --! @name Simulation Parameters
    --! @{
    ---------------------------------------------------------------------------
    constant IN_WIDTH    : integer := 28;   --!< Input feature map width  (pixels)
    constant IN_HEIGHT   : integer := 28;   --!< Input feature map height (pixels)
    constant IN_CHANNELS : integer := 3;    --!< Number of input channels
    constant POOL_SIZE   : integer := 2;    --!< Pooling window size (2x2)
    constant OUT_WIDTH   : integer := 14;   --!< Output feature map width  (= IN_WIDTH  / POOL_SIZE)
    constant OUT_HEIGHT  : integer := 14;   --!< Output feature map height (= IN_HEIGHT / POOL_SIZE)

    constant IN_SIZE  : integer := IN_WIDTH  * IN_HEIGHT  * IN_CHANNELS; --!< Total input  elements (2352)
    constant OUT_SIZE : integer := OUT_WIDTH * OUT_HEIGHT * IN_CHANNELS; --!< Total output elements (588)

    constant CLK_PERIOD : time := 10 ns; --!< Clock period (100 MHz)
    --! @}

    ---------------------------------------------------------------------------
    --! @brief ROM type storing the Conv1+ReLU output as signed 8-bit integers.
    ---------------------------------------------------------------------------
    type rom_type is array (0 to IN_SIZE-1) of int8;

    ---------------------------------------------------------------------------
    --! @brief Parse a signed integer from a textio line.
    --!
    --! @details Reads leading whitespace, an optional '-' sign, then decimal
    --!          digits. Kept for robustness even though all values after ReLU
    --!          are non-negative.
    --!
    --! @param[inout] l      The textio line being parsed (consumed in place).
    --! @param[out]   result The parsed integer value.
    ---------------------------------------------------------------------------
    procedure read_signed_int(l      : inout line;
                               result : out   integer) is
        variable c      : character;
        variable is_neg : boolean := false;
        variable val    : integer := 0;
        variable good   : boolean;
    begin
        -- Skip leading whitespace and parse optional sign or first digit
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
        -- Parse remaining digits
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
    --! @brief Initialize the ROM from a plain-text file of signed integers.
    --!
    --! @details Each line of the file contains one integer value (one per
    --!          element in HWC order). Values are clamped to the int8 range
    --!          [-128, 127] before storage.
    --!
    --! @param[in] filename Path to the source text file.
    --! @return            Initialized ROM array (rom_type).
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
                -- Clamp to int8 range to prevent overflow
                if val >  127 then val :=  127; end if;
                if val < -128 then val := -128; end if;
                mem(i) := to_signed(val, 8);
            end if;
        end loop;
        file_close(f);
        return mem;
    end function;

    ---------------------------------------------------------------------------
    --! @brief ROM holding Conv1+ReLU output data.
    --!
    --! @details Loaded at elaboration time from output_conv1_streaming.txt.
    --!          All values are in [0, 127] because ReLU zeroes negative outputs.
    ---------------------------------------------------------------------------
    constant CONV1_ROM : rom_type :=
        init_rom_from_file("output_conv1_streaming.txt");

    ---------------------------------------------------------------------------
    --! @name DUT Interface Signals
    --! @{
    ---------------------------------------------------------------------------
    signal clk   : std_logic := '0'; --!< System clock
    signal rst   : std_logic := '0'; --!< Synchronous active-high reset
    signal start : std_logic := '0'; --!< Single-cycle start pulse
    signal done  : std_logic;        --!< Asserted by DUT when pooling is complete

    signal in_addr  : std_logic_vector(11 downto 0); --!< Read address into input ROM  (max 4096)
    signal in_data  : int8;                           --!< Data returned by input ROM (1-cycle latency)

    signal out_addr : std_logic_vector(11 downto 0); --!< Write address into output memory
    signal out_data : int8;                           --!< Pooled output value from DUT
    signal out_we   : std_logic;                      --!< Write-enable for output memory
    --! @}

    ---------------------------------------------------------------------------
    --! @name Output Capture Memory
    --! @{
    ---------------------------------------------------------------------------
    --! @brief Array type for capturing DUT outputs (588 int8 values).
    type out_mem_type is array (0 to OUT_SIZE-1) of int8;

    --! @brief Output memory written whenever out_we is asserted.
    signal output_memory : out_mem_type := (others => (others => '0'));
    --! @}

    ---------------------------------------------------------------------------
    --! @name Simulation Control
    --! @{
    ---------------------------------------------------------------------------
    signal sim_done      : boolean := false; --!< Set to true to stop the clock process
    signal cycle_counter : integer := 0;     --!< Free-running cycle counter (reset on rst)
    --! @}

    ---------------------------------------------------------------------------
    --! @brief Component declaration for the Device Under Test.
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
    --! @brief DUT instantiation.
    --! @details Generic map sets all dimension and pooling parameters.
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
    --! @brief Synchronous ROM process - models a 1-cycle-latency BRAM.
    --!
    --! @details On each rising clock edge, the ROM outputs the value at in_addr.
    --!          Out-of-range addresses return 0x00 to prevent simulation errors.
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
    --! @brief Output capture process.
    --!
    --! @details Writes DUT output data into output_memory whenever out_we
    --!          is asserted. Out-of-range addresses are silently ignored.
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
    --! @brief Clock generation process.
    --!
    --! @details Generates a symmetric clock with period CLK_PERIOD.
    --!          Stops automatically when sim_done is asserted.
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
    --! @brief Cycle counter process.
    --!
    --! @details Increments on every rising clock edge.
    --!          Resets to 0 while rst is asserted.
    --!          Used to measure DUT latency in clock cycles.
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
    --! @brief Main stimulus process.
    --!
    --! @details Sequence:
    --!          1. Print testbench header and ROM sanity information.
    --!          2. Assert reset for 5 cycles, then deassert.
    --!          3. Issue a 1-cycle start pulse and record the start cycle.
    --!          4. Poll done with a 50 000-cycle timeout.
    --!          5. Display latency, output preview and window verification.
    --!          6. Save all 588 output values to output_pool1_14x14x3.txt.
    --!          7. Assert sim_done to terminate the clock process.
    ---------------------------------------------------------------------------
    stimulus : process
        variable line_v      : line;
        file f_out           : text;
        variable v_start_cyc : integer := 0; --!< Cycle number when start was issued
        variable v_end_cyc   : integer := 0; --!< Cycle number when done was observed
        variable timeout_cnt : integer := 0; --!< Watchdog counter
        variable neg_count   : integer := 0; --!< Number of negative values in ROM (expect 0)
    begin
        -- ---------------------------------------------------------------
        -- Header
        -- ---------------------------------------------------------------
        report "=====================================================" severity note;
        report "=== TESTBENCH MAXPOOL2D 2x2 (apres Conv1+ReLU) ===" severity note;
        report "  Source : output_conv1_streaming.txt (valeurs >= 0)" severity note;
        report "  Entree : " & integer'image(IN_WIDTH)  & "x" &
               integer'image(IN_HEIGHT) & "x" & integer'image(IN_CHANNELS) &
               " = " & integer'image(IN_SIZE) & " valeurs" severity note;
        report "  Sortie : " & integer'image(OUT_WIDTH) & "x" &
               integer'image(OUT_HEIGHT) & "x" & integer'image(IN_CHANNELS) &
               " = " & integer'image(OUT_SIZE) & " valeurs" severity note;

        -- ---------------------------------------------------------------
        -- ROM spot-check: print first 6 values (all expected >= 0 after ReLU)
        -- ---------------------------------------------------------------
        report "  Verification ROM[0..5] (attendu : valeurs >= 0) :" severity note;
        report "  ROM[0]=" & integer'image(to_integer(CONV1_ROM(0))) &
               " ROM[1]=" & integer'image(to_integer(CONV1_ROM(1))) &
               " ROM[2]=" & integer'image(to_integer(CONV1_ROM(2))) &
               " ROM[3]=" & integer'image(to_integer(CONV1_ROM(3))) &
               " ROM[4]=" & integer'image(to_integer(CONV1_ROM(4))) &
               " ROM[5]=" & integer'image(to_integer(CONV1_ROM(5))) severity note;

        -- ---------------------------------------------------------------
        -- Sanity check: count negative values - must be 0 after ReLU
        -- ---------------------------------------------------------------
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

        -- ---------------------------------------------------------------
        -- Reset sequence
        -- ---------------------------------------------------------------
        rst   <= '1';
        start <= '0';
        wait for CLK_PERIOD * 5;
        rst   <= '0';
        wait for CLK_PERIOD * 3;

        -- ---------------------------------------------------------------
        -- Start pulse (1 clock cycle)
        -- ---------------------------------------------------------------
        wait until rising_edge(clk);
        v_start_cyc := cycle_counter;
        report "=== DEMARRAGE MaxPool ===" severity note;

        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        -- ---------------------------------------------------------------
        -- Wait for done with watchdog timeout
        -- ---------------------------------------------------------------
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

        -- ---------------------------------------------------------------
        -- Output preview: first 3 output pixels (one per channel group)
        -- All values expected >= 0 : max(values >= 0) >= 0
        -- ---------------------------------------------------------------
        report "=== APERCU SORTIES (3 premiers pixels) ===" severity note;
        for pix in 0 to 2 loop
            report "  pool[" & integer'image(pix) & "] = [ch0=" &
                   integer'image(to_integer(output_memory(pix*3+0))) & " ch1=" &
                   integer'image(to_integer(output_memory(pix*3+1))) & " ch2=" &
                   integer'image(to_integer(output_memory(pix*3+2))) & "]"
                   severity note;
        end loop;

        -- ---------------------------------------------------------------
        -- Window verification for pixel (0,0) - addresses per channel:
        --   ch0: ROM[0], ROM[3], ROM[84], ROM[87]
        --   ch1: ROM[1], ROM[4], ROM[85], ROM[88]
        --   ch2: ROM[2], ROM[5], ROM[86], ROM[89]
        -- Expected result = max of the four values in each channel.
        -- ---------------------------------------------------------------
        report "=== VERIFICATION fenetre (0,0) ===" severity note;
        report "  Canal 0 : in=" &
               integer'image(to_integer(CONV1_ROM(0)))  & "," &
               integer'image(to_integer(CONV1_ROM(3)))  & "," &
               integer'image(to_integer(CONV1_ROM(84))) & "," &
               integer'image(to_integer(CONV1_ROM(87))) &
               " -> pool=" & integer'image(to_integer(output_memory(0))) severity note;
        report "  Canal 1 : in=" &
               integer'image(to_integer(CONV1_ROM(1)))  & "," &
               integer'image(to_integer(CONV1_ROM(4)))  & "," &
               integer'image(to_integer(CONV1_ROM(85))) & "," &
               integer'image(to_integer(CONV1_ROM(88))) &
               " -> pool=" & integer'image(to_integer(output_memory(1))) severity note;
        report "  Canal 2 : in=" &
               integer'image(to_integer(CONV1_ROM(2)))  & "," &
               integer'image(to_integer(CONV1_ROM(5)))  & "," &
               integer'image(to_integer(CONV1_ROM(86))) & "," &
               integer'image(to_integer(CONV1_ROM(89))) &
               " -> pool=" & integer'image(to_integer(output_memory(2))) severity note;

        -- ---------------------------------------------------------------
        -- Save output to file (interleaved HWC format, one value per line)
        -- Compatible with subsequent network layers.
        -- ---------------------------------------------------------------
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

        -- ---------------------------------------------------------------
        -- End simulation
        -- ---------------------------------------------------------------
        sim_done <= true;
        wait;
    end process;

end Behavioral;