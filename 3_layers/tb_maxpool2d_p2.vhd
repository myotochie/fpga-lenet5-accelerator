----------------------------------------------------------------------------------
--! @file       tb_maxpool2d_p2.vhd
--! @brief      Testbench for the MaxPool2 stage: 10×10×6 ? 5×5×6 (pool 2×2).
--!
--! @details    Validates the maxpool2d module (reused without modification,
--!             configured via generics only) on the output of the Conv2 layer.
--!
--!             The testbench:
--!               - Loads Conv2 output from output_conv2_streaming.txt into a ROM
--!                 at elaboration time (600 int8 values, HWC interleaved).
--!               - Drives the DUT with a 1-cycle start pulse and polls done.
--!               - Captures all output writes into an internal memory array.
--!               - Measures and reports DUT latency in cycles and nanoseconds.
--!               - Verifies the 2×2 pooling window at position (0,0) for channel 0.
--!               - Saves the 150-value result to output_pool2_5x5x6.txt.
--!
--! @note       Input  format: HWC interleaved - index = (y*WIDTH + x)*CH + ch
--!                            10×10×6 = 600 int8 values.
--! @note       Output format: HWC interleaved - 5×5×6 = 150 int8 values.
--! @note       The maxpool2d RTL module is instantiated unchanged; only generics differ
--!             from the Pool1 testbench.
--!
--! @author     myotochie
--! @date       2026-03-10
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.lenet_types_pkg.all;

--! @brief Top-level testbench entity for the MaxPool2 stage.
--! @details No ports - self-contained simulation entity.
entity tb_maxpool2d_p2 is
end tb_maxpool2d_p2;

--! @brief Behavioral architecture of tb_maxpool2d_p2.
architecture Behavioral of tb_maxpool2d_p2 is

    ---------------------------------------------------------------------------
    --! @name Simulation Parameters
    --! @{
    ---------------------------------------------------------------------------
    constant IN_WIDTH    : integer := 10; --!< Input feature map width  (pixels)
    constant IN_HEIGHT   : integer := 10; --!< Input feature map height (pixels)
    constant IN_CHANNELS : integer := 6;  --!< Number of input channels (Conv2 output)
    constant POOL_SIZE   : integer := 2;  --!< Pooling window size (2×2)
    constant OUT_WIDTH   : integer := 5;  --!< Output width  (= IN_WIDTH  / POOL_SIZE)
    constant OUT_HEIGHT  : integer := 5;  --!< Output height (= IN_HEIGHT / POOL_SIZE)

    constant IN_SIZE  : integer := IN_WIDTH  * IN_HEIGHT  * IN_CHANNELS; --!< Total input  elements (600)
    constant OUT_SIZE : integer := OUT_WIDTH * OUT_HEIGHT * IN_CHANNELS; --!< Total output elements (150)

    constant CLK_PERIOD : time := 10 ns; --!< Clock period (100 MHz)
    --! @}

    ---------------------------------------------------------------------------
    --! @brief ROM type holding Conv2 output as signed 8-bit integers.
    ---------------------------------------------------------------------------
    type rom_type is array (0 to IN_SIZE-1) of int8;

    ---------------------------------------------------------------------------
    --! @brief Parse a signed integer from a textio line.
    --!
    --! @details Skips leading whitespace, reads an optional '-' sign, then
    --!          accumulates decimal digits. Handles both positive and negative
    --!          values for robustness, even if Conv2 may produce negatives
    --!          before an external ReLU stage.
    --!
    --! @param[inout] l      The textio line being consumed.
    --! @param[out]   result The parsed integer value.
    ---------------------------------------------------------------------------
    procedure read_signed_int(l      : inout line;
                               result : out   integer) is
        variable c      : character;
        variable is_neg : boolean := false;
        variable val    : integer := 0;
        variable good   : boolean;
    begin
        -- Skip leading whitespace; capture sign or first digit
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
        -- Accumulate remaining digits
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
    --! @brief Initialize the input ROM from a plain-text file.
    --!
    --! @details Reads one signed integer per line (HWC order).
    --!          Values are clamped to [-128, 127] before storage.
    --!
    --! @param[in] filename Path to the source text file.
    --! @return            Initialized ROM array (rom_type).
    ---------------------------------------------------------------------------
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
                -- Clamp to int8 range
                if val >  127 then val :=  127; end if;
                if val < -128 then val := -128; end if;
                mem(i) := to_signed(val, 8);
            end if;
        end loop;
        file_close(f);
        return mem;
    end function;

    ---------------------------------------------------------------------------
    --! @brief ROM holding Conv2 output data.
    --!
    --! @details Elaboration-time constant loaded from output_conv2_streaming.txt.
    --!          Values may be positive or negative (no ReLU applied at this stage).
    ---------------------------------------------------------------------------
    constant CONV2_ROM : rom_type := init_rom("output_conv2_streaming.txt");

    ---------------------------------------------------------------------------
    --! @name DUT Interface Signals
    --! @{
    ---------------------------------------------------------------------------
    signal clk   : std_logic := '0'; --!< System clock
    signal rst   : std_logic := '0'; --!< Synchronous active-high reset
    signal start : std_logic := '0'; --!< Single-cycle start pulse to DUT
    signal done  : std_logic;        --!< Asserted by DUT when pooling is complete

    signal in_addr  : std_logic_vector(11 downto 0); --!< Read address into input ROM  (max 4096)
    signal in_data  : int8;                           --!< Data returned by ROM (1-cycle latency)

    signal out_addr : std_logic_vector(11 downto 0); --!< Write address into output memory
    signal out_data : int8;                           --!< Pooled output value from DUT
    signal out_we   : std_logic;                      --!< Write-enable for output memory
    --! @}

    ---------------------------------------------------------------------------
    --! @name Output Capture Memory
    --! @{
    ---------------------------------------------------------------------------
    --! @brief Array type for the 150-element pooled output (5×5×6 int8).
    type out_mem_type is array (0 to OUT_SIZE-1) of int8;

    --! @brief Output memory written on every cycle where out_we is asserted.
    signal output_memory : out_mem_type := (others => (others => '0'));
    --! @}

    ---------------------------------------------------------------------------
    --! @name Simulation Control and Performance Monitoring
    --! @{
    ---------------------------------------------------------------------------
    signal sim_done       : boolean   := false; --!< Terminates the clock process when true
    signal cycle_counter  : integer   := 0;     --!< Free-running cycle counter (resets on rst)
    signal latency_cycles : integer   := 0;     --!< Accumulated cycle count from start to done (Vivado-visible)
    signal measuring      : std_logic := '0';   --!< High while latency measurement is active
    --! @}

    ---------------------------------------------------------------------------
    --! @brief Component declaration for the Device Under Test.
    --! @details Uses the unmodified maxpool2d RTL; Pool2 parameters are
    --!          passed exclusively through the generic map.
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
    --! @brief DUT instantiation - maxpool2d configured for Pool2 dimensions.
    --!
    --! @details Generic map:
    --!            IN_WIDTH=10, IN_HEIGHT=10, IN_CHANNELS=6, POOL_SIZE=2
    --!          Addressing in DUT:
    --!            Read  address = (cur_y * IN_WIDTH + cur_x) * IN_CHANNELS + ch
    --!            Write address = (y_out * OUT_WIDTH + x_out) * IN_CHANNELS + ch
    --!          Both are HWC-interleaved, consistent with Conv2 output format.
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
    --! @brief Synchronous ROM process - models a 1-cycle-latency BRAM.
    --!
    --! @details Presents CONV2_ROM[in_addr] one cycle after the address is driven.
    --!          Out-of-range addresses safely return 0x00.
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
    --! @brief Output capture process.
    --!
    --! @details On every rising edge where out_we is asserted, the DUT output
    --!          is written to output_memory at the index given by out_addr.
    --!          Out-of-range writes are silently discarded.
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
    --! @details Generates a 50 % duty-cycle clock of period CLK_PERIOD.
    --!          Halts automatically when sim_done is asserted.
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
    --! @brief Free-running cycle counter process.
    --!
    --! @details Increments on every rising clock edge.
    --!          Resets to 0 while rst is asserted.
    --!          Used in the stimulus process to measure DUT latency.
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
    --! @brief Hardware latency measurement process.
    --!
    --! @details Drives the latency_cycles and measuring signals, which are
    --!          visible in the Vivado waveform viewer for timing analysis.
    --!
    --!          State machine:
    --!            - IDLE    : measuring = '0', latency_cycles = 0.
    --!            - RUNNING : entered on start pulse; latency_cycles increments
    --!                        each cycle while measuring = '1'.
    --!            - DONE    : last increment is captured on the done cycle,
    --!                        then measuring returns to '0'.
    ---------------------------------------------------------------------------
    latency_proc : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                latency_cycles <= 0;
                measuring      <= '0';
            else
                if start = '1' then
                    -- Begin measurement on start pulse
                    latency_cycles <= 0;
                    measuring      <= '1';
                elsif done = '1' and measuring = '1' then
                    -- Capture final cycle and stop
                    latency_cycles <= latency_cycles + 1;
                    measuring      <= '0';
                elsif measuring = '1' then
                    -- Accumulate running count
                    latency_cycles <= latency_cycles + 1;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Main stimulus process.
    --!
    --! @details Execution sequence:
    --!          1. Print testbench header with tensor dimensions.
    --!          2. Spot-check the first 6 ROM entries.
    --!          3. Assert reset for 5 cycles, then deassert.
    --!          4. Issue a 1-cycle start pulse; record start cycle.
    --!          5. Poll done with a 50 000-cycle watchdog timeout.
    --!          6. Report latency in cycles and nanoseconds.
    --!          7. Display the first 3 output pixels (6 channels each).
    --!          8. Verify the 2×2 pooling window at (x=0, y=0), channel 0.
    --!          9. Save all 150 results to output_pool2_5x5x6.txt (HWC order).
    --!          10. Assert sim_done to terminate the simulation.
    ---------------------------------------------------------------------------
    stimulus : process
        variable line_v      : line;
        file f_out           : text;
        variable v_start_cyc : integer := 0; --!< Cycle number when start was issued
        variable v_end_cyc   : integer := 0; --!< Cycle number when done was observed
        variable timeout_cnt : integer := 0; --!< Watchdog counter (max 50 000 cycles)
    begin
        -- ---------------------------------------------------------------
        -- Header
        -- ---------------------------------------------------------------
        report "=====================================================" severity note;
        report "=== TESTBENCH MAXPOOL2 : 10x10x6 -> 5x5x6 ===" severity note;
        report "  Entree : output_conv2_streaming.txt (" &
               integer'image(IN_SIZE) & " valeurs)" severity note;
        report "  Sortie : output_pool2_5x5x6.txt (" &
               integer'image(OUT_SIZE) & " valeurs)" severity note;
        report "  Format : HWC interleaved (ch varie le plus vite)" severity note;
        report "=====================================================" severity note;

        -- ---------------------------------------------------------------
        -- ROM spot-check: print first 6 values
        -- ---------------------------------------------------------------
        report "  ROM Conv2[0..5] :" severity note;
        report "  [0]=" & integer'image(to_integer(CONV2_ROM(0))) &
               " [1]=" & integer'image(to_integer(CONV2_ROM(1))) &
               " [2]=" & integer'image(to_integer(CONV2_ROM(2))) &
               " [3]=" & integer'image(to_integer(CONV2_ROM(3))) &
               " [4]=" & integer'image(to_integer(CONV2_ROM(4))) &
               " [5]=" & integer'image(to_integer(CONV2_ROM(5))) severity note;

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
        report "=== DEMARRAGE MaxPool2 au cycle " &
               integer'image(v_start_cyc) & " ===" severity note;

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

        -- ---------------------------------------------------------------
        -- Output preview: first 3 pixels, all 6 channels each
        -- ---------------------------------------------------------------
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

        -- ---------------------------------------------------------------
        -- Window verification for pixel (0,0), channel 0.
        -- HWC address of each corner in the 2×2 window (IN_WIDTH=10, IN_CHANNELS=6):
        --   pixel(x=0,y=0) ch0 ? addr  0   (= (0*10 + 0)*6 + 0)
        --   pixel(x=1,y=0) ch0 ? addr  6   (= (0*10 + 1)*6 + 0)
        --   pixel(x=0,y=1) ch0 ? addr 60   (= (1*10 + 0)*6 + 0)
        --   pixel(x=1,y=1) ch0 ? addr 66   (= (1*10 + 1)*6 + 0)
        -- Expected pool output = max of those four values.
        -- ---------------------------------------------------------------
        report "=== VERIFICATION fenetre (0,0) canal 0 ===" severity note;
        report "  in[0]="  & integer'image(to_integer(CONV2_ROM(0)))  &
               " in[6]="  & integer'image(to_integer(CONV2_ROM(6)))  &
               " in[60]=" & integer'image(to_integer(CONV2_ROM(60))) &
               " in[66]=" & integer'image(to_integer(CONV2_ROM(66))) &
               "  -> pool=" & integer'image(to_integer(output_memory(0))) severity note;

        -- ---------------------------------------------------------------
        -- Save output to file (HWC interleaved, one value per line)
        -- Compatible with subsequent FC / flatten layer.
        -- ---------------------------------------------------------------
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

        -- ---------------------------------------------------------------
        -- End simulation
        -- ---------------------------------------------------------------
        sim_done <= true;
        wait;
    end process;

end Behavioral;