-- =============================================================================
-- conv2d_pingpong_core.vhd - VERSION CORRIGÉE multiply driven
-- Corrections :
--   ? out_cnt   : retiré de p_fsm, géré uniquement dans p_out_cnt
--   ? out_addr_r: retiré de p_fsm (rst ET S_IDLE), géré uniquement dans p_out_cnt
--   ? col_cnt, row_cnt retirés du reset hardware (rst='1') dans p_fsm
--     car ils sont déjà réinitialisés dans S_IDLE
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

entity conv2d_pingpong_core is
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
        clk   : in  std_logic;
        rst   : in  std_logic;
        start : in  std_logic;
        done  : out std_logic;

        calc_bank : out std_logic;

        pix_addr  : out std_logic_vector(9 downto 0);
        in_pixel  : in  std_logic_vector(7 downto 0);

        out_wr_addr  : out std_logic_vector(9 downto 0);
        out_wr_valid : out std_logic;
        out_data_0   : out std_logic_vector(7 downto 0);
        out_data_1   : out std_logic_vector(7 downto 0);
        out_data_2   : out std_logic_vector(7 downto 0);

        weight_addr   : out std_logic_vector(4 downto 0);
        weight_data_0 : in  std_logic_vector(7 downto 0);
        weight_data_1 : in  std_logic_vector(7 downto 0);
        weight_data_2 : in  std_logic_vector(7 downto 0);

        bias_addr : out std_logic_vector(1 downto 0);
        bias_data : in  std_logic_vector(31 downto 0)
    );
end conv2d_pingpong_core;

architecture rtl of conv2d_pingpong_core is

    constant OCH    : integer := 3;
    constant KSIZE  : integer := 5;
    constant KSIZE2 : integer := KSIZE * KSIZE;
    constant OUT_W  : integer := IN_WIDTH  - KSIZE + 1;
    constant OUT_H  : integer := IN_HEIGHT - KSIZE + 1;
    constant OUT_SZ : integer := OUT_W * OUT_H;
    constant TOTAL  : integer := IN_WIDTH * IN_HEIGHT;

    type window_t  is array (0 to KSIZE-1, 0 to KSIZE-1) of signed(7 downto 0);
    type weights_t is array (0 to OCH-1,   0 to KSIZE2-1) of signed(7 downto 0);
    type acc_t     is array (0 to OCH-1)                   of signed(31 downto 0);
    type out8_t    is array (0 to OCH-1)                   of signed(7 downto 0);
    type prods_t   is array (0 to OCH-1,   0 to KSIZE2-1) of signed(15 downto 0);
    type atl0_t    is array (0 to OCH-1, 0 to 12) of signed(16 downto 0);
    type atl1_t    is array (0 to OCH-1, 0 to 6)  of signed(17 downto 0);
    type atl2_t    is array (0 to OCH-1, 0 to 3)  of signed(18 downto 0);
    type atl3_t    is array (0 to OCH-1, 0 to 1)  of signed(19 downto 0);
    type atl4_t    is array (0 to OCH-1)           of signed(20 downto 0);
    type line_t    is array (0 to IN_WIDTH-1)      of signed(7 downto 0);
    type linebuf_t is array (0 to KSIZE-2)         of line_t;

    signal weight_buf : weights_t := (others => (others => (others => '0')));
    signal bias_buf   : acc_t     := (others => (others => '0'));

    type state_t is (S_IDLE, S_LOAD_W, S_LOAD_B, S_RUN, S_FLUSH, S_DONE);
    signal state : state_t := S_IDLE;

    signal wload_idx : integer range 0 to 63    := 0;
    signal bload_idx : integer range 0 to OCH+1 := 0;
    signal params_ok : std_logic := '0';

    signal calc_bank_r : std_logic := '0';
    signal pipe_en     : std_logic := '0';
    signal col_cnt     : integer range 0 to IN_WIDTH-1  := 0;
    signal row_cnt     : integer range 0 to IN_HEIGHT-1 := 0;
    signal pix_addr_r  : integer range 0 to TOTAL-1     := 0;

    -- ? CORRECTION : out_cnt et out_addr_r gérés UNIQUEMENT dans p_out_cnt
    signal out_cnt     : integer range 0 to OUT_SZ+8    := 0;
    signal out_addr_r  : integer range 0 to OUT_SZ-1    := 0;

    -- Signal d'état pour que p_out_cnt sache quand remettre à zéro
    -- (remplace le reset depuis p_fsm)
    signal in_idle     : std_logic := '0';

    signal line_buf  : linebuf_t := (others => (others => (others => '0')));
    signal cur_pixel : signed(7 downto 0) := (others => '0');
    signal win_reg   : window_t  := (others => (others => (others => '0')));

    signal s0_win   : window_t;  signal s0_valid : std_logic := '0';
    signal s1_prods : prods_t;   signal s1_valid : std_logic := '0';
    signal s2_atl0  : atl0_t;    signal s2_valid : std_logic := '0';
    signal s3_atl1  : atl1_t;    signal s3_valid : std_logic := '0';
    signal s4_atl2  : atl2_t;    signal s4_valid : std_logic := '0';
    signal s5_atl3  : atl3_t;    signal s5_valid : std_logic := '0';
    signal s6_atl4  : atl4_t;    signal s6_valid : std_logic := '0';
    signal s7_acc   : acc_t;     signal s7_valid : std_logic := '0';
    signal s8_out   : out8_t;    signal s8_valid : std_logic := '0';

begin

    calc_bank    <= calc_bank_r;
    pix_addr     <= std_logic_vector(to_unsigned(pix_addr_r, 10));
    out_wr_addr  <= std_logic_vector(to_unsigned(out_addr_r, 10));
    out_wr_valid <= s8_valid;
    out_data_0   <= std_logic_vector(s8_out(0));
    out_data_1   <= std_logic_vector(s8_out(1));
    out_data_2   <= std_logic_vector(s8_out(2));
    weight_addr  <= std_logic_vector(to_unsigned(wload_idx, 5));
    bias_addr    <= std_logic_vector(to_unsigned(bload_idx, 2));

    -- Signal combinatoire : indique que la FSM est en S_IDLE
    in_idle <= '1' when state = S_IDLE else '0';

    -- =========================================================================
    -- CHARGEMENT POIDS
    -- =========================================================================
    p_wload : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                weight_buf <= (others => (others => (others => '0')));
            elsif state = S_LOAD_W then
                if wload_idx >= 1 and wload_idx <= KSIZE2 then
                    weight_buf(0, wload_idx-1) <= signed(weight_data_0);
                    weight_buf(1, wload_idx-1) <= signed(weight_data_1);
                    weight_buf(2, wload_idx-1) <= signed(weight_data_2);
                end if;
            end if;
        end if;
    end process;

    -- =========================================================================
    -- CHARGEMENT BIAIS
    -- =========================================================================
    p_bload : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                bias_buf  <= (others => (others => '0'));
                params_ok <= '0';
            elsif state = S_LOAD_B then
                case bload_idx is
                    when 1 => bias_buf(0) <= signed(bias_data);
                    when 2 => bias_buf(1) <= signed(bias_data);
                    when 3 =>
                        bias_buf(2) <= signed(bias_data);
                        params_ok   <= '1';
                    when others => null;
                end case;
            end if;
        end if;
    end process;

    -- =========================================================================
    -- FSM PRINCIPALE
    -- ? CORRECTION : out_cnt et out_addr_r SUPPRIMÉS de ce processus
    --   Ils étaient la cause du "multiply driven"
    --   p_fsm ne gère que : state, done, pipe_en, calc_bank_r,
    --                       pix_addr_r, col_cnt, row_cnt, wload_idx, bload_idx
    -- =========================================================================
    p_fsm : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state       <= S_IDLE;
                done        <= '0';
                pipe_en     <= '0';
                calc_bank_r <= '0';
                pix_addr_r  <= 0;
                col_cnt     <= 0;
                row_cnt     <= 0;
                wload_idx   <= 0;
                bload_idx   <= 0;
                -- ? out_cnt et out_addr_r ABSENTS ici
            else
                done <= '0';

                case state is

                    when S_IDLE =>
                        pipe_en    <= '0';
                        pix_addr_r <= 0;
                        col_cnt    <= 0;
                        row_cnt    <= 0;
                        -- ? out_cnt et out_addr_r ABSENTS ici aussi
                        if start = '1' then
                            if params_ok = '0' then
                                wload_idx <= 0;
                                state     <= S_LOAD_W;
                            else
                                pipe_en <= '1';
                                state   <= S_RUN;
                            end if;
                        end if;

                    when S_LOAD_W =>
                        if wload_idx < KSIZE2 + 1 then
                            wload_idx <= wload_idx + 1;
                        else
                            bload_idx <= 0;
                            state     <= S_LOAD_B;
                        end if;

                    when S_LOAD_B =>
                        if bload_idx < OCH + 1 then
                            bload_idx <= bload_idx + 1;
                        else
                            pipe_en <= '1';
                            state   <= S_RUN;
                        end if;

                    when S_RUN =>
                        if col_cnt = IN_WIDTH-1 then
                            col_cnt <= 0;
                            if row_cnt = IN_HEIGHT-1 then
                                pipe_en <= '0';
                                state   <= S_FLUSH;
                            else
                                row_cnt <= row_cnt + 1;
                            end if;
                        else
                            col_cnt <= col_cnt + 1;
                        end if;
                        if pix_addr_r < TOTAL-1 then
                            pix_addr_r <= pix_addr_r + 1;
                        end if;

                    when S_FLUSH =>
                        if out_cnt >= OUT_SZ then
                            state <= S_DONE;
                        end if;

                    when S_DONE =>
                        done        <= '1';
                        calc_bank_r <= not calc_bank_r;
                        state       <= S_IDLE;

                end case;
            end if;
        end if;
    end process;

    -- =========================================================================
    -- COMPTEUR SORTIES
    -- ? CORRECTION : seul processus à driver out_cnt et out_addr_r
    --   Reset déclenché par rst='1' OU in_idle='1' (état S_IDLE de la FSM)
    --   Remplace le double driver précédent
    -- =========================================================================
    p_out_cnt : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' or in_idle = '1' then
                -- ? Reset centralisé ici uniquement
                out_cnt    <= 0;
                out_addr_r <= 0;
            elsif s8_valid = '1' then
                out_cnt    <= out_cnt + 1;
                if out_addr_r < OUT_SZ-1 then
                    out_addr_r <= out_addr_r + 1;
                end if;
            end if;
        end if;
    end process;

    -- =========================================================================
    -- LINE BUFFER
    -- =========================================================================
    p_linebuf : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                line_buf  <= (others => (others => (others => '0')));
                cur_pixel <= (others => '0');
            elsif pipe_en = '1' then
                cur_pixel <= signed(in_pixel);
                for ln in 0 to KSIZE-3 loop
                    for c in 0 to IN_WIDTH-2 loop
                        line_buf(ln)(c) <= line_buf(ln)(c+1);
                    end loop;
                    line_buf(ln)(IN_WIDTH-1) <= line_buf(ln+1)(0);
                end loop;
                for c in 0 to IN_WIDTH-2 loop
                    line_buf(KSIZE-2)(c) <= line_buf(KSIZE-2)(c+1);
                end loop;
                line_buf(KSIZE-2)(IN_WIDTH-1) <= cur_pixel;
            end if;
        end if;
    end process;

    -- =========================================================================
    -- WINDOW REGISTER 5×5
    -- =========================================================================
    p_window : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                win_reg  <= (others => (others => (others => '0')));
                s0_valid <= '0';
                s0_win   <= (others => (others => (others => '0')));
            elsif pipe_en = '1' then
                for ky in 0 to KSIZE-1 loop
                    for kx in 0 to KSIZE-2 loop
                        win_reg(ky, kx) <= win_reg(ky, kx+1);
                    end loop;
                end loop;
                for ky in 0 to KSIZE-2 loop
                    win_reg(ky, KSIZE-1) <= line_buf(ky)(0);
                end loop;
                win_reg(KSIZE-1, KSIZE-1) <= cur_pixel;
                s0_win <= win_reg;
                if row_cnt >= KSIZE-1 and col_cnt >= KSIZE-1 then
                    s0_valid <= '1';
                else
                    s0_valid <= '0';
                end if;
            else
                s0_valid <= '0';
            end if;
        end if;
    end process;

    -- =========================================================================
    -- PE ARRAY
    -- =========================================================================
    p_pe : process(clk)
        variable flat : integer;
    begin
        if rising_edge(clk) then
            s1_valid <= s0_valid;
            if s0_valid = '1' then
                for ch in 0 to OCH-1 loop
                    for ky in 0 to KSIZE-1 loop
                        for kx in 0 to KSIZE-1 loop
                            flat := ky * KSIZE + kx;
                            s1_prods(ch, flat) <=
                                resize(s0_win(ky,kx) * weight_buf(ch,flat), 16);
                        end loop;
                    end loop;
                end loop;
            end if;
        end if;
    end process;

    -- =========================================================================
    -- ADDER TREE
    -- =========================================================================
    p_at0: process(clk) begin
        if rising_edge(clk) then
            s2_valid <= s1_valid;
            if s1_valid='1' then
                for ch in 0 to OCH-1 loop
                    for i in 0 to 11 loop
                        s2_atl0(ch,i) <= resize(s1_prods(ch,2*i),17)
                                       + resize(s1_prods(ch,2*i+1),17);
                    end loop;
                    s2_atl0(ch,12) <= resize(s1_prods(ch,24),17);
                end loop;
            end if;
        end if;
    end process;

    p_at1: process(clk) begin
        if rising_edge(clk) then
            s3_valid <= s2_valid;
            if s2_valid='1' then
                for ch in 0 to OCH-1 loop
                    for i in 0 to 5 loop
                        s3_atl1(ch,i) <= resize(s2_atl0(ch,2*i),18)
                                       + resize(s2_atl0(ch,2*i+1),18);
                    end loop;
                    s3_atl1(ch,6) <= resize(s2_atl0(ch,12),18);
                end loop;
            end if;
        end if;
    end process;

    p_at2: process(clk) begin
        if rising_edge(clk) then
            s4_valid <= s3_valid;
            if s3_valid='1' then
                for ch in 0 to OCH-1 loop
                    for i in 0 to 2 loop
                        s4_atl2(ch,i) <= resize(s3_atl1(ch,2*i),19)
                                       + resize(s3_atl1(ch,2*i+1),19);
                    end loop;
                    s4_atl2(ch,3) <= resize(s3_atl1(ch,6),19);
                end loop;
            end if;
        end if;
    end process;

    p_at3: process(clk) begin
        if rising_edge(clk) then
            s5_valid <= s4_valid;
            if s4_valid='1' then
                for ch in 0 to OCH-1 loop
                    s5_atl3(ch,0) <= resize(s4_atl2(ch,0),20)
                                   + resize(s4_atl2(ch,1),20);
                    s5_atl3(ch,1) <= resize(s4_atl2(ch,2),20)
                                   + resize(s4_atl2(ch,3),20);
                end loop;
            end if;
        end if;
    end process;

    p_at4: process(clk) begin
        if rising_edge(clk) then
            s6_valid <= s5_valid;
            if s5_valid='1' then
                for ch in 0 to OCH-1 loop
                    s6_atl4(ch) <= resize(s5_atl3(ch,0),21)
                                 + resize(s5_atl3(ch,1),21);
                end loop;
            end if;
        end if;
    end process;

    -- =========================================================================
    -- REQUANTISATION + BIAIS
    -- =========================================================================
    p_req: process(clk)
        variable biased : signed(31 downto 0);
        variable mul64  : signed(63 downto 0);
    begin
        if rising_edge(clk) then
            s7_valid <= s6_valid;
            if s6_valid='1' then
                for ch in 0 to OCH-1 loop
                    biased     := resize(s6_atl4(ch), 32) + bias_buf(ch);
                    mul64      := resize(biased * Q_MULT, 64);
                    s7_acc(ch) <= resize(shift_right(mul64, Q_SHIFT), 32)
                                  + resize(Q_ZERO_POINT, 32);
                end loop;
            end if;
        end if;
    end process;

    -- =========================================================================
    -- SATURATION INT8
    -- =========================================================================
    p_sat: process(clk) begin
        if rising_edge(clk) then
            if rst='1' then
                s8_valid <= '0';
            else
                s8_valid <= s7_valid;
                if s7_valid='1' then
                    for ch in 0 to OCH-1 loop
                        if    s7_acc(ch) > INT8_MAX_VAL then
                            s8_out(ch) <= resize(INT8_MAX_VAL, 8);
                        elsif s7_acc(ch) < INT8_MIN_VAL then
                            s8_out(ch) <= resize(INT8_MIN_VAL, 8);
                        else
                            s8_out(ch) <= resize(s7_acc(ch), 8);
                        end if;
                    end loop;
                end if;
            end if;
        end if;
    end process;

end rtl;