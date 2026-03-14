----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2026 11:07:26
-- Design Name: 
-- Module Name: top_lenet_full - Behavioral
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
-- top_lenet_full.vhd
-- Chaîne complète LeNet modifié :
--   Conv1?ReLU?MaxPool1?Conv2?ReLU?MaxPool2?FC
--
-- ARCHITECTURE :
--
--   blk_mem_in ???????????? CONV1 ??out_valid??? buffer1 (2352 B)
--   blk_mem_c11/12/13_w ???                           ? pool1_in_addr
--   blk_mem_c1_b ??????????                           ?
--                                                   POOL1 ??out_we??? buffer2 (588 B)
--                                                                           ? c2_in_addr
--   blk_mem_c21..c26_w ??? CONV2 ???????????????????????????????????????????
--   blk_mem_c2_b ??????????      ??out_valid??? buffer3 (600 B)
--                                                    ? pool2_in_addr
--                                                 POOL2 ??out_we??? buffer4 (150 B)
--                                                                         ? fc_in_bram_addr
--   blk_mem_fc_w ????????? FC ????????????????????????????????????????????
--   blk_mem_fc_b ??????????    ??out_valid??? fc_out_data (port externe)
--
-- BRAMs instanciées dans ce module :
--   Conv1 : blk_mem_c11_w, blk_mem_c12_w, blk_mem_c13_w, blk_mem_c1_b, blk_mem_in
--   Conv2 : blk_mem_c21_w .. blk_mem_c26_w, blk_mem_c2_b
--   FC    : blk_mem_fc_w, blk_mem_fc_b
--
-- Buffers internes (RAM inférée) :
--   buffer1 : 2352 B  Conv1 streaming ? MaxPool1 random
--   buffer2 :  588 B  MaxPool1 out_we ? Conv2 random
--   buffer3 :  600 B  Conv2 streaming ? MaxPool2 random
--   buffer4 :  150 B  MaxPool2 out_we ? FC in_bram
--
-- FSM : IDLE?RUN_CONV1?RUN_POOL1?RUN_CONV2?RUN_POOL2?RUN_FC?DONE_STATE
--
-- Ports externes :
--   clk, rst, start, done
--   fc_out_data  : int8_vector(0 to 9)  - logits des 10 classes
--   fc_out_valid : std_logic            - pulse 1 cycle quand logits valides
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

entity top_lenet_full2 is
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
end top_lenet_full2;

architecture Behavioral of top_lenet_full2 is

    ---------------------------------------------------------------------------
    -- Tailles buffers
    ---------------------------------------------------------------------------
    constant BUF1_SIZE : integer := 28 * 28 * 3;   -- 2352
    constant BUF2_SIZE : integer := 14 * 14 * 3;   --  588
    constant BUF3_SIZE : integer := 10 * 10 * 6;   --  600
    constant BUF4_SIZE : integer :=  5 *  5 * 6;   --  150

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
    signal buffer2      : buf2_type := (others => (others => '0'));
    signal buf2_rd_data : int8 := (others => '0');

    ---------------------------------------------------------------------------
    -- Buffer 3 : Conv2 streaming ? MaxPool2 random
    ---------------------------------------------------------------------------
    type buf3_type is array (0 to BUF3_SIZE-1) of int8;
    signal buffer3       : buf3_type := (others => (others => '0'));
    signal buf3_wr_count : integer range 0 to BUF3_SIZE := 0;
    signal buf3_rd_data  : int8 := (others => '0');

    ---------------------------------------------------------------------------
    -- Buffer 4 : MaxPool2 out_we ? FC in_bram
    ---------------------------------------------------------------------------
    type buf4_type is array (0 to BUF4_SIZE-1) of int8;
    signal buffer4      : buf4_type := (others => (others => '0'));
    signal buf4_rd_data : int8 := (others => '0');

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
    -- Signaux BRAMs FC
    ---------------------------------------------------------------------------
    signal fc_weight_addr : std_logic_vector(10 downto 0);
    signal fc_weight_slv  : std_logic_vector(7 downto 0);
    signal fc_weight_data : int8;

    signal fc_bias_addr : std_logic_vector(3 downto 0);
    signal fc_bias_slv  : std_logic_vector(31 downto 0);
    signal fc_bias_data : int32;

    signal fc_in_bram_addr : std_logic_vector(7 downto 0);
    signal fc_in_bram_data : int8;

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
    signal pool2_start    : std_logic := '0';
    signal pool2_done     : std_logic;
    signal pool2_in_addr  : std_logic_vector(11 downto 0);
    signal pool2_in_data  : int8;
    signal pool2_out_addr : std_logic_vector(11 downto 0);
    signal pool2_out_data : int8;
    signal pool2_out_we   : std_logic;

    ---------------------------------------------------------------------------
    -- Signaux FC
    ---------------------------------------------------------------------------
    signal fc_start : std_logic := '0';
    signal fc_done  : std_logic;

    ---------------------------------------------------------------------------
    -- FSM Top
    ---------------------------------------------------------------------------
    type state_type is (
        IDLE, RUN_CONV1, RUN_POOL1, RUN_CONV2, RUN_POOL2, RUN_FC, DONE_STATE
    );
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

    component fc_int8
        generic (
            FC_IN        : integer;
            FC_OUT       : integer;
            Q_MULT       : int32;
            Q_SHIFT      : integer;
            Q_ZERO_POINT : int8;
            USE_RELU     : boolean
        );
        port (
            clk          : in  std_logic;
            rst          : in  std_logic;
            start        : in  std_logic;
            done         : out std_logic;
            weight_addr  : out std_logic_vector(10 downto 0);
            weight_data  : in  int8;
            bias_addr    : out std_logic_vector(3 downto 0);
            bias_data    : in  int32;
            in_bram_addr : out std_logic_vector(7 downto 0);
            in_bram_data : in  int8;
            out_data     : out int8_vector(0 to FC_OUT-1);
            out_valid    : out std_logic
        );
    end component;

    ---------------------------------------------------------------------------
    -- BRAMs Conv1
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
    ---------------------------------------------------------------------------
    -- BRAMs Conv2
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

    ---------------------------------------------------------------------------
    -- BRAMs FC
    ---------------------------------------------------------------------------
    component blk_mem_fc_w
        port (clka  : in  std_logic; ena : in std_logic;
              addra : in  std_logic_vector(10 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;
    component blk_mem_fc_b
        port (clka  : in  std_logic; ena : in std_logic;
              addra : in  std_logic_vector(3 downto 0);
              douta : out std_logic_vector(31 downto 0));
    end component;

begin

    ---------------------------------------------------------------------------
    -- Conversions SLV ? int8/int32
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

    fc_weight_data <= signed(fc_weight_slv);
    fc_bias_data   <= signed(fc_bias_slv);

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

    c1_in_bram_addr <= c1_in_addr;
    c1_in_slv       <= c1_in_bram_data;
    ---------------------------------------------------------------------------
    -- Instanciations BRAMs Conv2
    ---------------------------------------------------------------------------je
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
    -- Instanciations BRAMs FC
    ---------------------------------------------------------------------------
    BRAM_FC_W : blk_mem_fc_w port map(
        clka=>clk, ena=>'1', addra=>fc_weight_addr, douta=>fc_weight_slv);
    BRAM_FC_B : blk_mem_fc_b port map(
        clka=>clk, ena=>'1', addra=>fc_bias_addr,   douta=>fc_bias_slv);

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
    -- Instanciation FC
    ---------------------------------------------------------------------------
    FC : fc_int8
        generic map(
            FC_IN        => 150,
            FC_OUT       => 10,
            Q_MULT       => FC_MULT,
            Q_SHIFT      => FC_SHIFT,
            Q_ZERO_POINT => FC_ZERO_POINT,
            USE_RELU     => false)
        port map(
            clk          => clk,
            rst          => rst,
            start        => fc_start,
            done         => fc_done,
            weight_addr  => fc_weight_addr,
            weight_data  => fc_weight_data,
            bias_addr    => fc_bias_addr,
            bias_data    => fc_bias_data,
            in_bram_addr => fc_in_bram_addr,
            in_bram_data => fc_in_bram_data,
            out_data     => fc_out_data,
            out_valid    => fc_out_valid);

    fc_in_bram_data <= buf4_rd_data;

    ---------------------------------------------------------------------------
    -- BUFFER 1 : Conv1 streaming ? MaxPool1
    -- Écriture : 3 canaux/cycle sur conv1_valid en RUN_CONV1
    -- Lecture  : synchrone 1 cycle latence
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
    -- BUFFER 2 : MaxPool1 ? Conv2
    -- Écriture : sur pool1_out_we (adresse aléatoire)
    -- Lecture  : synchrone 1 cycle latence
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
    -- BUFFER 3 : Conv2 streaming ? MaxPool2
    -- Écriture : 6 canaux/cycle sur conv2_valid en RUN_CONV2
    -- Lecture  : synchrone 1 cycle latence
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
    -- BUFFER 4 : MaxPool2 ? FC
    -- Écriture : sur pool2_out_we (adresse aléatoire, 12b ? 0..149)
    -- Lecture  : synchrone 1 cycle latence ? fc_in_bram_data
    ---------------------------------------------------------------------------
    buf4_ram_proc : process(clk)
        variable wr_addr_v : integer;
        variable rd_addr_v : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                buf4_rd_data <= (others => '0');
            else
                if pool2_out_we = '1' then
                    wr_addr_v := to_integer(unsigned(pool2_out_addr));
                    if wr_addr_v >= 0 and wr_addr_v < BUF4_SIZE then
                        buffer4(wr_addr_v) <= pool2_out_data;
                    end if;
                end if;
                rd_addr_v := to_integer(unsigned(fc_in_bram_addr));
                if rd_addr_v >= 0 and rd_addr_v < BUF4_SIZE then
                    buf4_rd_data <= buffer4(rd_addr_v);
                else
                    buf4_rd_data <= (others => '0');
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
                state       <= IDLE;
                done        <= '0';
                conv1_start <= '0';
                pool1_start <= '0';
                conv2_start <= '0';
                pool2_start <= '0';
                fc_start    <= '0';
            else
                conv1_start <= '0';
                pool1_start <= '0';
                conv2_start <= '0';
                pool2_start <= '0';
                fc_start    <= '0';

                case state is

                    when IDLE =>
                        done <= '0';
                        if start = '1' then
                            conv1_start <= '1';
                            state       <= RUN_CONV1;
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
                            fc_start <= '1';
                            state    <= RUN_FC;
                        end if;

                    when RUN_FC =>
                        if fc_done = '1' then
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