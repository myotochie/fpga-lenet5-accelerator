----------------------------------------------------------------------------------
-- top_lenet_conv_pool.vhd
-- Cha頽e compl鑤e : Conv1?ReLU?MaxPool1?Conv2?ReLU?MaxPool2
--
-- ARCHITECTURE (m阭e style que top_conv1_pool1) :
--
--   blk_mem_in ??????????????? CONV1 ??out_valid??? buffer1 (2352 B)
--   blk_mem_c11/12/13_w ??????                           ? pool1_in_addr
--   blk_mem_c1_b ?????????????                           ?
--                                                      POOL1 ??out_we??? buffer2 (588 B)
--                                                                              ? c2_in_addr
--   blk_mem_c21..c26_w ??????? CONV2 ???????????????????????????????????????????
--   blk_mem_c2_b ?????????????       ??out_valid??? buffer3 (600 B)
--                                                         ? pool2_in_addr
--                                                         ?
--                                                      POOL2 ??pool2_out_we??? port externe
--                                                             ??pool2_out_addr?
--                                                             ??pool2_out_data?
--
-- BRAMs instanci閑s dans ce module (m阭e style top_conv1_pool1) :
--   Conv1 : blk_mem_c11_w, blk_mem_c12_w, blk_mem_c13_w, blk_mem_c1_b, blk_mem_in
--   Conv2 : blk_mem_c21_w .. blk_mem_c26_w, blk_mem_c2_b
--
-- Buffers internes (RAM inf閞閑, 1 seul process par buffer) :
--   buffer1 : 2352 B  Conv1 streaming ? MaxPool1 random
--   buffer2 :  588 B  MaxPool1 out_we ? Conv2 random
--   buffer3 :  600 B  Conv2 streaming ? MaxPool2 random
--
-- Ports externes :
--   clk, rst, start, done
--   pool2_out_addr (12b), pool2_out_data (int8), pool2_out_we
--   ? captur閟 directement par le testbench dans un tableau (comme tb_top_conv1_pool1)
--
-- FSM : IDLE ? RUN_CONV1 ? RUN_POOL1 ? RUN_CONV2 ? RUN_POOL2 ? DONE_STATE
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

entity top_lenet_conv_pool is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        start : in  std_logic;
        done  : out std_logic;

        -- Sortie MaxPool2 (5󬊆 = 150 bytes, HWC interleaved)
        -- Captur� par le testbench dans un tableau sur pool2_out_we
        pool2_out_addr : out std_logic_vector(11 downto 0);
        pool2_out_data : out int8;
        pool2_out_we   : out std_logic
    );
end top_lenet_conv_pool;

architecture Behavioral of top_lenet_conv_pool is

    ---------------------------------------------------------------------------
    -- Tailles buffers
    ---------------------------------------------------------------------------
    constant BUF1_SIZE : integer := 28 * 28 * 3;   -- 2352
    constant BUF2_SIZE : integer := 14 * 14 * 3;   --  588
    constant BUF3_SIZE : integer := 10 * 10 * 6;   --  600

    ---------------------------------------------------------------------------
    -- Buffer 1 : Conv1 streaming ? MaxPool1 random
    ---------------------------------------------------------------------------
    type buf1_type is array (0 to BUF1_SIZE-1) of int8;
    signal buffer1       : buf1_type := (others => (others => '0'));
    signal buf1_wr_count : integer range 0 to BUF1_SIZE := 0;
    signal buf1_rd_data  : int8 := (others => '0');

    ---------------------------------------------------------------------------
    -- Buffer 2 : MaxPool1 out_we ? Conv2 random
    ---------------------------------------------------------------------------
    type buf2_type is array (0 to BUF2_SIZE-1) of int8;
    signal buffer2       : buf2_type := (others => (others => '0'));
    signal buf2_rd_data  : int8 := (others => '0');

    ---------------------------------------------------------------------------
    -- Buffer 3 : Conv2 streaming ? MaxPool2 random
    ---------------------------------------------------------------------------
    type buf3_type is array (0 to BUF3_SIZE-1) of int8;
    signal buffer3       : buf3_type := (others => (others => '0'));
    signal buf3_wr_count : integer range 0 to BUF3_SIZE := 0;
    signal buf3_rd_data  : int8 := (others => '0');

    ---------------------------------------------------------------------------
    -- Signaux BRAMs Conv1
    ---------------------------------------------------------------------------
    signal c1_weight_addr_0 : std_logic_vector(4 downto 0);
    signal c1_weight_addr_1 : std_logic_vector(4 downto 0);
    signal c1_weight_addr_2 : std_logic_vector(4 downto 0);
    signal c1_weight_slv_0  : std_logic_vector(7 downto 0);
    signal c1_weight_slv_1  : std_logic_vector(7 downto 0);
    signal c1_weight_slv_2  : std_logic_vector(7 downto 0);
    signal c1_weight_data_0 : int8;
    signal c1_weight_data_1 : int8;
    signal c1_weight_data_2 : int8;

    signal c1_bias_slv    : std_logic_vector(95 downto 0);
    signal c1_bias_data_0 : int32;
    signal c1_bias_data_1 : int32;
    signal c1_bias_data_2 : int32;

    signal c1_in_addr : std_logic_vector(9 downto 0);
    signal c1_in_slv  : std_logic_vector(7 downto 0);
    signal c1_in_data : int8;

    ---------------------------------------------------------------------------
    -- Signaux BRAMs Conv2
    ---------------------------------------------------------------------------
    signal c2_weight_addr_0 : std_logic_vector(6 downto 0);
    signal c2_weight_addr_1 : std_logic_vector(6 downto 0);
    signal c2_weight_addr_2 : std_logic_vector(6 downto 0);
    signal c2_weight_addr_3 : std_logic_vector(6 downto 0);
    signal c2_weight_addr_4 : std_logic_vector(6 downto 0);
    signal c2_weight_addr_5 : std_logic_vector(6 downto 0);
    signal c2_weight_slv_0  : std_logic_vector(7 downto 0);
    signal c2_weight_slv_1  : std_logic_vector(7 downto 0);
    signal c2_weight_slv_2  : std_logic_vector(7 downto 0);
    signal c2_weight_slv_3  : std_logic_vector(7 downto 0);
    signal c2_weight_slv_4  : std_logic_vector(7 downto 0);
    signal c2_weight_slv_5  : std_logic_vector(7 downto 0);
    signal c2_weight_data_0 : int8;
    signal c2_weight_data_1 : int8;
    signal c2_weight_data_2 : int8;
    signal c2_weight_data_3 : int8;
    signal c2_weight_data_4 : int8;
    signal c2_weight_data_5 : int8;

    signal c2_bias_slv    : std_logic_vector(191 downto 0);
    signal c2_bias_data_0 : int32;
    signal c2_bias_data_1 : int32;
    signal c2_bias_data_2 : int32;
    signal c2_bias_data_3 : int32;
    signal c2_bias_data_4 : int32;
    signal c2_bias_data_5 : int32;

    signal c2_in_addr : std_logic_vector(9 downto 0);
    signal c2_in_data : int8;

    ---------------------------------------------------------------------------
    -- Signaux Conv1
    ---------------------------------------------------------------------------
    signal conv1_start : std_logic := '0';
    signal conv1_done  : std_logic;
    signal conv1_out_0 : int8;
    signal conv1_out_1 : int8;
    signal conv1_out_2 : int8;
    signal conv1_valid : std_logic;

    ---------------------------------------------------------------------------
    -- Signaux MaxPool1
    ---------------------------------------------------------------------------
    signal pool1_start    : std_logic := '0';
    signal pool1_done     : std_logic;
    signal pool1_in_addr  : std_logic_vector(11 downto 0);
    signal pool1_in_data  : int8;
    signal pool1_out_addr : std_logic_vector(11 downto 0);
    signal pool1_out_data : int8;
    signal pool1_out_we   : std_logic;

    ---------------------------------------------------------------------------
    -- Signaux Conv2
    ---------------------------------------------------------------------------
    signal conv2_start : std_logic := '0';
    signal conv2_done  : std_logic;
    signal conv2_out_0 : int8;
    signal conv2_out_1 : int8;
    signal conv2_out_2 : int8;
    signal conv2_out_3 : int8;
    signal conv2_out_4 : int8;
    signal conv2_out_5 : int8;
    signal conv2_valid : std_logic;

    ---------------------------------------------------------------------------
    -- Signaux MaxPool2
    ---------------------------------------------------------------------------
    signal pool2_start   : std_logic := '0';
    signal pool2_done    : std_logic;
    signal pool2_in_addr : std_logic_vector(11 downto 0);
    signal pool2_in_data : int8;

    ---------------------------------------------------------------------------
    -- FSM Top
    ---------------------------------------------------------------------------
    type state_type is (IDLE, RUN_CONV1, RUN_POOL1, RUN_CONV2, RUN_POOL2, DONE_STATE);
    signal state : state_type := IDLE;

    ---------------------------------------------------------------------------
    -- Composants RTL
    ---------------------------------------------------------------------------
    component conv2d_int8_streaming
        generic (
            IN_WIDTH : integer; IN_HEIGHT : integer; IN_CHANNELS : integer;
            OUT_CHANNELS : integer; KERNEL_SIZE : integer;
            Q_MULT : int32; Q_SHIFT : integer; Q_ZERO_POINT : int8;
            USE_RELU : boolean
        );
        port (
            clk : in std_logic; rst : in std_logic;
            start : in std_logic; done : out std_logic;
            weight_addr_0 : out std_logic_vector(4 downto 0); weight_data_0 : in int8;
            weight_addr_1 : out std_logic_vector(4 downto 0); weight_data_1 : in int8;
            weight_addr_2 : out std_logic_vector(4 downto 0); weight_data_2 : in int8;
            bias_data_0 : in int32; bias_data_1 : in int32; bias_data_2 : in int32;
            in_bram_addr : out std_logic_vector(9 downto 0); in_bram_data : in int8;
            out_data_0 : out int8; out_data_1 : out int8; out_data_2 : out int8;
            out_valid : out std_logic
        );
    end component;

    component conv2d_int8_streaming_c2
        generic (
            IN_WIDTH : integer; IN_HEIGHT : integer; IN_CHANNELS : integer;
            OUT_CHANNELS : integer; KERNEL_SIZE : integer;
            Q_MULT : int32; Q_SHIFT : integer; Q_ZERO_POINT : int8;
            USE_RELU : boolean
        );
        port (
            clk : in std_logic; rst : in std_logic;
            start : in std_logic; done : out std_logic;
            weight_addr_0 : out std_logic_vector(6 downto 0); weight_data_0 : in int8;
            weight_addr_1 : out std_logic_vector(6 downto 0); weight_data_1 : in int8;
            weight_addr_2 : out std_logic_vector(6 downto 0); weight_data_2 : in int8;
            weight_addr_3 : out std_logic_vector(6 downto 0); weight_data_3 : in int8;
            weight_addr_4 : out std_logic_vector(6 downto 0); weight_data_4 : in int8;
            weight_addr_5 : out std_logic_vector(6 downto 0); weight_data_5 : in int8;
            bias_data_0 : in int32; bias_data_1 : in int32; bias_data_2 : in int32;
            bias_data_3 : in int32; bias_data_4 : in int32; bias_data_5 : in int32;
            in_bram_addr : out std_logic_vector(9 downto 0); in_bram_data : in int8;
            out_data_0 : out int8; out_data_1 : out int8; out_data_2 : out int8;
            out_data_3 : out int8; out_data_4 : out int8; out_data_5 : out int8;
            out_valid : out std_logic
        );
    end component;

    component maxpool2d
        generic (IN_WIDTH : integer; IN_HEIGHT : integer;
                 IN_CHANNELS : integer; POOL_SIZE : integer);
        port (
            clk : in std_logic; rst : in std_logic;
            start : in std_logic; done : out std_logic;
            in_addr : out std_logic_vector(11 downto 0); in_data : in int8;
            out_addr : out std_logic_vector(11 downto 0);
            out_data : out int8; out_we : out std_logic
        );
    end component;

    ---------------------------------------------------------------------------
    -- Composants BRAMs Xilinx (Conv1)
    ---------------------------------------------------------------------------
    component blk_mem_c11_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(4 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;
    component blk_mem_c12_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(4 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;
    component blk_mem_c13_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(4 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;
    component blk_mem_c1_b
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic;
              douta : out std_logic_vector(95 downto 0));
    end component;
    component blk_mem_in
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(9 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;

    ---------------------------------------------------------------------------
    -- Composants BRAMs Xilinx (Conv2)
    ---------------------------------------------------------------------------
    component blk_mem_c21_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(6 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;
    component blk_mem_c22_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(6 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;
    component blk_mem_c23_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(6 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;
    component blk_mem_c24_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(6 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;
    component blk_mem_c25_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(6 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;
    component blk_mem_c26_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(6 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;
    component blk_mem_c2_b
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic;
              douta : out std_logic_vector(191 downto 0));
    end component;

begin

    ---------------------------------------------------------------------------
    -- Conversions SLV ? int8/int32 (m阭e style top_conv1_pool1)
    ---------------------------------------------------------------------------
    c1_weight_data_0 <= signed(c1_weight_slv_0);
    c1_weight_data_1 <= signed(c1_weight_slv_1);
    c1_weight_data_2 <= signed(c1_weight_slv_2);
    c1_in_data       <= signed(c1_in_slv);

    c1_bias_data_0 <= signed(c1_bias_slv(31 downto  0));
    c1_bias_data_1 <= signed(c1_bias_slv(63 downto 32));
    c1_bias_data_2 <= signed(c1_bias_slv(95 downto 64));

    c2_weight_data_0 <= signed(c2_weight_slv_0);
    c2_weight_data_1 <= signed(c2_weight_slv_1);
    c2_weight_data_2 <= signed(c2_weight_slv_2);
    c2_weight_data_3 <= signed(c2_weight_slv_3);
    c2_weight_data_4 <= signed(c2_weight_slv_4);
    c2_weight_data_5 <= signed(c2_weight_slv_5);

    c2_bias_data_0 <= signed(c2_bias_slv( 31 downto   0));
    c2_bias_data_1 <= signed(c2_bias_slv( 63 downto  32));
    c2_bias_data_2 <= signed(c2_bias_slv( 95 downto  64));
    c2_bias_data_3 <= signed(c2_bias_slv(127 downto  96));
    c2_bias_data_4 <= signed(c2_bias_slv(159 downto 128));
    c2_bias_data_5 <= signed(c2_bias_slv(191 downto 160));

    ---------------------------------------------------------------------------
    -- Instanciations BRAMs Conv1
    ---------------------------------------------------------------------------
    BRAM_C11_W : blk_mem_c11_w port map(
        clka=>clk, ena=>'1', addra=>c1_weight_addr_0, douta=>c1_weight_slv_0);
    BRAM_C12_W : blk_mem_c12_w port map(
        clka=>clk, ena=>'1', addra=>c1_weight_addr_1, douta=>c1_weight_slv_1);
    BRAM_C13_W : blk_mem_c13_w port map(
        clka=>clk, ena=>'1', addra=>c1_weight_addr_2, douta=>c1_weight_slv_2);
    BRAM_C1_B  : blk_mem_c1_b  port map(
        clka=>clk, ena=>'1', addra=>'0',              douta=>c1_bias_slv);
    BRAM_IN    : blk_mem_in    port map(
        clka=>clk, ena=>'1', addra=>c1_in_addr,       douta=>c1_in_slv);

    ---------------------------------------------------------------------------
    -- Instanciations BRAMs Conv2
    ---------------------------------------------------------------------------
    BRAM_C21_W : blk_mem_c21_w port map(
        clka=>clk, ena=>'1', addra=>c2_weight_addr_0, douta=>c2_weight_slv_0);
    BRAM_C22_W : blk_mem_c22_w port map(
        clka=>clk, ena=>'1', addra=>c2_weight_addr_1, douta=>c2_weight_slv_1);
    BRAM_C23_W : blk_mem_c23_w port map(
        clka=>clk, ena=>'1', addra=>c2_weight_addr_2, douta=>c2_weight_slv_2);
    BRAM_C24_W : blk_mem_c24_w port map(
        clka=>clk, ena=>'1', addra=>c2_weight_addr_3, douta=>c2_weight_slv_3);
    BRAM_C25_W : blk_mem_c25_w port map(
        clka=>clk, ena=>'1', addra=>c2_weight_addr_4, douta=>c2_weight_slv_4);
    BRAM_C26_W : blk_mem_c26_w port map(
        clka=>clk, ena=>'1', addra=>c2_weight_addr_5, douta=>c2_weight_slv_5);
    BRAM_C2_B  : blk_mem_c2_b  port map(
        clka=>clk, ena=>'1', addra=>'0',              douta=>c2_bias_slv);

    ---------------------------------------------------------------------------
    -- Instanciation Conv1
    ---------------------------------------------------------------------------
    CONV1 : conv2d_int8_streaming
        generic map(
            IN_WIDTH=>32, IN_HEIGHT=>32, IN_CHANNELS=>1, OUT_CHANNELS=>3,
            KERNEL_SIZE=>5, Q_MULT=>C1_MULT, Q_SHIFT=>C1_SHIFT,
            Q_ZERO_POINT=>C1_ZERO_POINT, USE_RELU=>true)
        port map(
            clk=>clk, rst=>rst, start=>conv1_start, done=>conv1_done,
            weight_addr_0=>c1_weight_addr_0, weight_data_0=>c1_weight_data_0,
            weight_addr_1=>c1_weight_addr_1, weight_data_1=>c1_weight_data_1,
            weight_addr_2=>c1_weight_addr_2, weight_data_2=>c1_weight_data_2,
            bias_data_0=>c1_bias_data_0, bias_data_1=>c1_bias_data_1,
            bias_data_2=>c1_bias_data_2,
            in_bram_addr=>c1_in_addr, in_bram_data=>c1_in_data,
            out_data_0=>conv1_out_0, out_data_1=>conv1_out_1,
            out_data_2=>conv1_out_2, out_valid=>conv1_valid);

    ---------------------------------------------------------------------------
    -- Instanciation MaxPool1
    ---------------------------------------------------------------------------
    POOL1 : maxpool2d
        generic map(IN_WIDTH=>28, IN_HEIGHT=>28, IN_CHANNELS=>3, POOL_SIZE=>2)
        port map(
            clk=>clk, rst=>rst, start=>pool1_start, done=>pool1_done,
            in_addr=>pool1_in_addr, in_data=>pool1_in_data,
            out_addr=>pool1_out_addr, out_data=>pool1_out_data,
            out_we=>pool1_out_we);

    pool1_in_data <= buf1_rd_data;

    ---------------------------------------------------------------------------
    -- Instanciation Conv2
    ---------------------------------------------------------------------------
    CONV2 : conv2d_int8_streaming_c2
        generic map(
            IN_WIDTH=>14, IN_HEIGHT=>14, IN_CHANNELS=>3, OUT_CHANNELS=>6,
            KERNEL_SIZE=>5, Q_MULT=>C2_MULT, Q_SHIFT=>C2_SHIFT,
            Q_ZERO_POINT=>C2_ZERO_POINT, USE_RELU=>true)
        port map(
            clk=>clk, rst=>rst, start=>conv2_start, done=>conv2_done,
            weight_addr_0=>c2_weight_addr_0, weight_data_0=>c2_weight_data_0,
            weight_addr_1=>c2_weight_addr_1, weight_data_1=>c2_weight_data_1,
            weight_addr_2=>c2_weight_addr_2, weight_data_2=>c2_weight_data_2,
            weight_addr_3=>c2_weight_addr_3, weight_data_3=>c2_weight_data_3,
            weight_addr_4=>c2_weight_addr_4, weight_data_4=>c2_weight_data_4,
            weight_addr_5=>c2_weight_addr_5, weight_data_5=>c2_weight_data_5,
            bias_data_0=>c2_bias_data_0, bias_data_1=>c2_bias_data_1,
            bias_data_2=>c2_bias_data_2, bias_data_3=>c2_bias_data_3,
            bias_data_4=>c2_bias_data_4, bias_data_5=>c2_bias_data_5,
            in_bram_addr=>c2_in_addr, in_bram_data=>c2_in_data,
            out_data_0=>conv2_out_0, out_data_1=>conv2_out_1,
            out_data_2=>conv2_out_2, out_data_3=>conv2_out_3,
            out_data_4=>conv2_out_4, out_data_5=>conv2_out_5,
            out_valid=>conv2_valid);

    c2_in_data <= buf2_rd_data;

    ---------------------------------------------------------------------------
    -- Instanciation MaxPool2
    ---------------------------------------------------------------------------
    POOL2 : maxpool2d
        generic map(IN_WIDTH=>10, IN_HEIGHT=>10, IN_CHANNELS=>6, POOL_SIZE=>2)
        port map(
            clk=>clk, rst=>rst, start=>pool2_start, done=>pool2_done,
            in_addr=>pool2_in_addr, in_data=>pool2_in_data,
            out_addr=>pool2_out_addr, out_data=>pool2_out_data,
            out_we=>pool2_out_we);

    pool2_in_data <= buf3_rd_data;

    ---------------------------------------------------------------------------
    -- BUFFER 1 : un seul process (m阭e r鑗le que top_conv1_pool1)
    -- 蒫riture : 3 canaux/cycle sur conv1_valid en RUN_CONV1
    -- Lecture  : synchrone 1 cycle latence ? pool1_in_data
    ---------------------------------------------------------------------------
    buf1_ram_proc : process(clk)
        variable rd_addr_v : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                buf1_wr_count <= 0;
                buf1_rd_data  <= (others => '0');
            else
                if state = RUN_CONV1 and conv1_valid = '1' then
                    if buf1_wr_count + 2 < BUF1_SIZE then
                        buffer1(buf1_wr_count + 0) <= conv1_out_0;
                        buffer1(buf1_wr_count + 1) <= conv1_out_1;
                        buffer1(buf1_wr_count + 2) <= conv1_out_2;
                        buf1_wr_count <= buf1_wr_count + 3;
                    end if;
                end if;
                rd_addr_v := to_integer(unsigned(pool1_in_addr));
                if rd_addr_v >= 0 and rd_addr_v < BUF1_SIZE then
                    buf1_rd_data <= buffer1(rd_addr_v);
                else
                    buf1_rd_data <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- BUFFER 2 : un seul process
    -- 蒫riture : sur pool1_out_we (adresse al閍toire)
    -- Lecture  : synchrone 1 cycle latence ? c2_in_data
    ---------------------------------------------------------------------------
    buf2_ram_proc : process(clk)
        variable wr_addr_v : integer;
        variable rd_addr_v : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                buf2_rd_data <= (others => '0');
            else
                if pool1_out_we = '1' then
                    wr_addr_v := to_integer(unsigned(pool1_out_addr));
                    if wr_addr_v >= 0 and wr_addr_v < BUF2_SIZE then
                        buffer2(wr_addr_v) <= pool1_out_data;
                    end if;
                end if;
                rd_addr_v := to_integer(unsigned(c2_in_addr));
                if rd_addr_v >= 0 and rd_addr_v < BUF2_SIZE then
                    buf2_rd_data <= buffer2(rd_addr_v);
                else
                    buf2_rd_data <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- BUFFER 3 : un seul process
    -- 蒫riture : 6 canaux/cycle sur conv2_valid en RUN_CONV2
    -- Lecture  : synchrone 1 cycle latence ? pool2_in_data
    ---------------------------------------------------------------------------
    buf3_ram_proc : process(clk)
        variable rd_addr_v : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                buf3_wr_count <= 0;
                buf3_rd_data  <= (others => '0');
            else
                if state = RUN_CONV2 and conv2_valid = '1' then
                    if buf3_wr_count + 5 < BUF3_SIZE then
                        buffer3(buf3_wr_count + 0) <= conv2_out_0;
                        buffer3(buf3_wr_count + 1) <= conv2_out_1;
                        buffer3(buf3_wr_count + 2) <= conv2_out_2;
                        buffer3(buf3_wr_count + 3) <= conv2_out_3;
                        buffer3(buf3_wr_count + 4) <= conv2_out_4;
                        buffer3(buf3_wr_count + 5) <= conv2_out_5;
                        buf3_wr_count <= buf3_wr_count + 6;
                    end if;
                end if;
                rd_addr_v := to_integer(unsigned(pool2_in_addr));
                if rd_addr_v >= 0 and rd_addr_v < BUF3_SIZE then
                    buf3_rd_data <= buffer3(rd_addr_v);
                else
                    buf3_rd_data <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- FSM Top
    ---------------------------------------------------------------------------
    fsm_top : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state         <= IDLE;
                done          <= '0';
                conv1_start   <= '0';
                pool1_start   <= '0';
                conv2_start   <= '0';
                pool2_start   <= '0';
            else
                conv1_start <= '0';
                pool1_start <= '0';
                conv2_start <= '0';
                pool2_start <= '0';

                case state is

                    when IDLE =>
                        done <= '0';
                        if start = '1' then
                            conv1_start   <= '1';
                            state         <= RUN_CONV1;
                        end if;

                    when RUN_CONV1 =>
                        if conv1_done = '1' then
                            pool1_start <= '1';
                            state       <= RUN_POOL1;
                        end if;

                    when RUN_POOL1 =>
                        if pool1_done = '1' then
                            conv2_start <= '1';
                            state       <= RUN_CONV2;
                        end if;

                    when RUN_CONV2 =>
                        if conv2_done = '1' then
                            pool2_start <= '1';
                            state       <= RUN_POOL2;
                        end if;

                    when RUN_POOL2 =>
                        if pool2_done = '1' then
                            state <= DONE_STATE;
                        end if;

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