----------------------------------------------------------------------------------
--! @file       top_lenet_conv_pool.vhd
--! @brief      Top-level RTL integrating the full Conv+Pool pipeline of LeNet-5.
--!
--! @details    Implements the sequential datapath:
--!               Conv1 ? ReLU ? MaxPool1 ? Conv2 ? ReLU ? MaxPool2
--!
--!             All sub-modules are connected through three inferred dual-port
--!             RAM buffers. Weights and biases are stored in Xilinx BRAMs
--!             (Block Memory Generator IP cores).
--!
--!             @par Datapath overview
--!             @code
--!               blk_mem_in ??????????????> CONV1 ??out_valid??> buffer1 (2352 B)
--!               blk_mem_c11/12/13_w ??>                               ? pool1_in_addr
--!               blk_mem_c1_b ????????>                                ?
--!                                                                   POOL1 ??out_we??> buffer2 (588 B)
--!                                                                                          ? c2_in_addr
--!               blk_mem_c21..c26_w ??> CONV2 <???????????????????????????????????????????
--!               blk_mem_c2_b ????????>       ??out_valid??> buffer3 (600 B)
--!                                                                  ? pool2_in_addr
--!                                                                POOL2 ??> pool2_out_* (external ports)
--!             @endcode
--!
--!             @par FSM states
--!             IDLE ? RUN_CONV1 ? RUN_POOL1 ? RUN_CONV2 ? RUN_POOL2 ? DONE_STATE
--!
--!             @par Internal BRAMs
--!             - Conv1: blk_mem_c11_w, blk_mem_c12_w, blk_mem_c13_w,
--!                      blk_mem_c1_b, blk_mem_in
--!             - Conv2: blk_mem_c21_w … blk_mem_c26_w, blk_mem_c2_b
--!
--!             @par Internal buffers (inferred RAM, one process each)
--!             - buffer1 : 2352 B - Conv1 streaming output ? MaxPool1 random read
--!             - buffer2 :  588 B - MaxPool1 out_we        ? Conv2 random read
--!             - buffer3 :  600 B - Conv2 streaming output ? MaxPool2 random read
--!
--! @note       pool2_out_addr/data/we are exposed as external ports so the
--!             testbench can capture the final 5×5×6 feature map directly.
--!
--! @author     myotochie
--! @date       2026-03-10
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

--! @brief Top-level entity for the Conv1?Pool1?Conv2?Pool2 pipeline.
--!
--! @details Exposes a simple handshake interface (start/done) and the raw
--!          MaxPool2 write-bus so that the testbench can capture outputs
--!          without an additional read-back BRAM.
entity top_lenet_conv_pool is
    port (
        clk   : in  std_logic; --!< System clock
        rst   : in  std_logic; --!< Synchronous active-high reset
        start : in  std_logic; --!< Single-cycle start pulse
        done  : out std_logic; --!< Asserted when the full pipeline has completed

        --! @name MaxPool2 Output Bus
        --! @details Carries the final 5×5×6 = 150 int8 feature map in HWC
        --!          interleaved order. Captured by the testbench on pool2_out_we.
        --! @{
        pool2_out_addr : out std_logic_vector(11 downto 0); --!< Write address (0-149)
        pool2_out_data : out int8;                          --!< Pooled int8 value
        pool2_out_we   : out std_logic                      --!< Write-enable strobe
        --! @}
    );
end top_lenet_conv_pool;

--! @brief Behavioral architecture of top_lenet_conv_pool.
architecture Behavioral of top_lenet_conv_pool is

    ---------------------------------------------------------------------------
    --! @name Internal Buffer Size Constants
    --! @{
    ---------------------------------------------------------------------------
    constant BUF1_SIZE : integer := 28 * 28 * 3; --!< Conv1  output buffer : 2352 B (28×28×3 HWC)
    constant BUF2_SIZE : integer := 14 * 14 * 3; --!< Pool1  output buffer :  588 B (14×14×3 HWC)
    constant BUF3_SIZE : integer := 10 * 10 * 6; --!< Conv2  output buffer :  600 B (10×10×6 HWC)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Buffer 1 - Conv1 streaming output ? MaxPool1 random read
    --! @details Written sequentially (3 channels/cycle) on conv1_valid.
    --!          Read with 1-cycle latency by MaxPool1 via pool1_in_addr.
    --! @{
    ---------------------------------------------------------------------------
    type buf1_type is array (0 to BUF1_SIZE-1) of int8;
    signal buffer1       : buf1_type := (others => (others => '0')); --!< 2352-byte inferred RAM
    signal buf1_wr_count : integer range 0 to BUF1_SIZE := 0;        --!< Sequential write pointer
    signal buf1_rd_data  : int8 := (others => '0');                  --!< Registered read output
    --! @}

    ---------------------------------------------------------------------------
    --! @name Buffer 2 - MaxPool1 output ? Conv2 random read
    --! @details Written at random addresses driven by pool1_out_addr/pool1_out_we.
    --!          Read with 1-cycle latency by Conv2 via c2_in_addr.
    --! @{
    ---------------------------------------------------------------------------
    type buf2_type is array (0 to BUF2_SIZE-1) of int8;
    signal buffer2      : buf2_type := (others => (others => '0')); --!< 588-byte inferred RAM
    signal buf2_rd_data : int8 := (others => '0');                  --!< Registered read output
    --! @}

    ---------------------------------------------------------------------------
    --! @name Buffer 3 - Conv2 streaming output ? MaxPool2 random read
    --! @details Written sequentially (6 channels/cycle) on conv2_valid.
    --!          Read with 1-cycle latency by MaxPool2 via pool2_in_addr.
    --! @{
    ---------------------------------------------------------------------------
    type buf3_type is array (0 to BUF3_SIZE-1) of int8;
    signal buffer3       : buf3_type := (others => (others => '0')); --!< 600-byte inferred RAM
    signal buf3_wr_count : integer range 0 to BUF3_SIZE := 0;        --!< Sequential write pointer
    signal buf3_rd_data  : int8 := (others => '0');                  --!< Registered read output
    --! @}

    ---------------------------------------------------------------------------
    --! @name Conv1 BRAM Interface Signals
    --! @details Three per-output-channel weight BRAMs (5×5×1 = 25 entries each)
    --!          and one bias BRAM returning all 3 biases as a 96-bit wide word.
    --! @{
    ---------------------------------------------------------------------------
    signal c1_weight_addr_0 : std_logic_vector(4 downto 0); --!< Weight BRAM address for channel 0 (0-24)
    signal c1_weight_addr_1 : std_logic_vector(4 downto 0); --!< Weight BRAM address for channel 1
    signal c1_weight_addr_2 : std_logic_vector(4 downto 0); --!< Weight BRAM address for channel 2
    signal c1_weight_slv_0  : std_logic_vector(7 downto 0); --!< Raw SLV from BRAM for channel 0
    signal c1_weight_slv_1  : std_logic_vector(7 downto 0); --!< Raw SLV from BRAM for channel 1
    signal c1_weight_slv_2  : std_logic_vector(7 downto 0); --!< Raw SLV from BRAM for channel 2
    signal c1_weight_data_0 : int8;                         --!< Signed int8 weight for channel 0
    signal c1_weight_data_1 : int8;                         --!< Signed int8 weight for channel 1
    signal c1_weight_data_2 : int8;                         --!< Signed int8 weight for channel 2

    signal c1_bias_slv    : std_logic_vector(95 downto 0); --!< Packed 3×int32 bias word from BRAM
    signal c1_bias_data_0 : int32;                         --!< int32 bias for output channel 0
    signal c1_bias_data_1 : int32;                         --!< int32 bias for output channel 1
    signal c1_bias_data_2 : int32;                         --!< int32 bias for output channel 2

    signal c1_in_addr : std_logic_vector(9 downto 0); --!< Read address into input image BRAM (0-1023)
    signal c1_in_slv  : std_logic_vector(7 downto 0); --!< Raw SLV pixel from input BRAM
    signal c1_in_data : int8;                         --!< Signed int8 input pixel
    --! @}

    ---------------------------------------------------------------------------
    --! @name Conv2 BRAM Interface Signals
    --! @details Six per-output-channel weight BRAMs (5×5×3 = 75 entries each)
    --!          and one bias BRAM returning all 6 biases as a 192-bit wide word.
    --! @{
    ---------------------------------------------------------------------------
    signal c2_weight_addr_0 : std_logic_vector(6 downto 0); --!< Weight BRAM address for channel 0 (0-74)
    signal c2_weight_addr_1 : std_logic_vector(6 downto 0); --!< Weight BRAM address for channel 1
    signal c2_weight_addr_2 : std_logic_vector(6 downto 0); --!< Weight BRAM address for channel 2
    signal c2_weight_addr_3 : std_logic_vector(6 downto 0); --!< Weight BRAM address for channel 3
    signal c2_weight_addr_4 : std_logic_vector(6 downto 0); --!< Weight BRAM address for channel 4
    signal c2_weight_addr_5 : std_logic_vector(6 downto 0); --!< Weight BRAM address for channel 5
    signal c2_weight_slv_0  : std_logic_vector(7 downto 0); --!< Raw SLV from BRAM for channel 0
    signal c2_weight_slv_1  : std_logic_vector(7 downto 0); --!< Raw SLV from BRAM for channel 1
    signal c2_weight_slv_2  : std_logic_vector(7 downto 0); --!< Raw SLV from BRAM for channel 2
    signal c2_weight_slv_3  : std_logic_vector(7 downto 0); --!< Raw SLV from BRAM for channel 3
    signal c2_weight_slv_4  : std_logic_vector(7 downto 0); --!< Raw SLV from BRAM for channel 4
    signal c2_weight_slv_5  : std_logic_vector(7 downto 0); --!< Raw SLV from BRAM for channel 5
    signal c2_weight_data_0 : int8;                         --!< Signed int8 weight for channel 0
    signal c2_weight_data_1 : int8;                         --!< Signed int8 weight for channel 1
    signal c2_weight_data_2 : int8;                         --!< Signed int8 weight for channel 2
    signal c2_weight_data_3 : int8;                         --!< Signed int8 weight for channel 3
    signal c2_weight_data_4 : int8;                         --!< Signed int8 weight for channel 4
    signal c2_weight_data_5 : int8;                         --!< Signed int8 weight for channel 5

    signal c2_bias_slv    : std_logic_vector(191 downto 0); --!< Packed 6×int32 bias word from BRAM
    signal c2_bias_data_0 : int32;                          --!< int32 bias for output channel 0
    signal c2_bias_data_1 : int32;                          --!< int32 bias for output channel 1
    signal c2_bias_data_2 : int32;                          --!< int32 bias for output channel 2
    signal c2_bias_data_3 : int32;                          --!< int32 bias for output channel 3
    signal c2_bias_data_4 : int32;                          --!< int32 bias for output channel 4
    signal c2_bias_data_5 : int32;                          --!< int32 bias for output channel 5

    signal c2_in_addr : std_logic_vector(9 downto 0); --!< Read address into buffer2 (0-587)
    signal c2_in_data : int8;                         --!< Signed int8 pixel from buffer2
    --! @}

    ---------------------------------------------------------------------------
    --! @name Conv1 Datapath Signals
    --! @{
    ---------------------------------------------------------------------------
    signal conv1_start : std_logic := '0'; --!< Start pulse issued by FSM to Conv1
    signal conv1_done  : std_logic;        --!< Done flag from Conv1
    signal conv1_out_0 : int8;             --!< Conv1 output channel 0 (with ReLU)
    signal conv1_out_1 : int8;             --!< Conv1 output channel 1 (with ReLU)
    signal conv1_out_2 : int8;             --!< Conv1 output channel 2 (with ReLU)
    signal conv1_valid : std_logic;        --!< Asserted when conv1_out_* are valid (one cycle per pixel)
    --! @}

    ---------------------------------------------------------------------------
    --! @name MaxPool1 Datapath Signals
    --! @{
    ---------------------------------------------------------------------------
    signal pool1_start    : std_logic := '0';          --!< Start pulse issued by FSM to MaxPool1
    signal pool1_done     : std_logic;                 --!< Done flag from MaxPool1
    signal pool1_in_addr  : std_logic_vector(11 downto 0); --!< Read address driven into buffer1
    signal pool1_in_data  : int8;                     --!< Data returned by buffer1 (1-cycle latency)
    signal pool1_out_addr : std_logic_vector(11 downto 0); --!< Write address into buffer2
    signal pool1_out_data : int8;                     --!< Pooled int8 value written to buffer2
    signal pool1_out_we   : std_logic;                --!< Write-enable for buffer2
    --! @}

    ---------------------------------------------------------------------------
    --! @name Conv2 Datapath Signals
    --! @{
    ---------------------------------------------------------------------------
    signal conv2_start : std_logic := '0'; --!< Start pulse issued by FSM to Conv2
    signal conv2_done  : std_logic;        --!< Done flag from Conv2
    signal conv2_out_0 : int8;             --!< Conv2 output channel 0 (with ReLU)
    signal conv2_out_1 : int8;             --!< Conv2 output channel 1 (with ReLU)
    signal conv2_out_2 : int8;             --!< Conv2 output channel 2 (with ReLU)
    signal conv2_out_3 : int8;             --!< Conv2 output channel 3 (with ReLU)
    signal conv2_out_4 : int8;             --!< Conv2 output channel 4 (with ReLU)
    signal conv2_out_5 : int8;             --!< Conv2 output channel 5 (with ReLU)
    signal conv2_valid : std_logic;        --!< Asserted when conv2_out_* are valid (one cycle per pixel)
    --! @}

    ---------------------------------------------------------------------------
    --! @name MaxPool2 Datapath Signals
    --! @{
    ---------------------------------------------------------------------------
    signal pool2_start   : std_logic := '0';          --!< Start pulse issued by FSM to MaxPool2
    signal pool2_done    : std_logic;                 --!< Done flag from MaxPool2
    signal pool2_in_addr : std_logic_vector(11 downto 0); --!< Read address driven into buffer3
    signal pool2_in_data : int8;                     --!< Data returned by buffer3 (1-cycle latency)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Top-Level FSM
    --! @details Linear 6-state machine sequencing each pipeline stage.
    --!          Each sub-module is activated with a 1-cycle start pulse and
    --!          the FSM waits for its done signal before proceeding.
    --! @{
    ---------------------------------------------------------------------------
    --! @brief FSM state enumeration.
    type state_type is (
        IDLE,        --!< Waiting for external start pulse
        RUN_CONV1,   --!< Conv1 + ReLU running; results streamed into buffer1
        RUN_POOL1,   --!< MaxPool1 running; results written into buffer2
        RUN_CONV2,   --!< Conv2 + ReLU running; results streamed into buffer3
        RUN_POOL2,   --!< MaxPool2 running; results available on pool2_out_* ports
        DONE_STATE   --!< Pipeline complete; done asserted until start de-asserts
    );
    signal state : state_type := IDLE; --!< Current FSM state register
    --! @}

    ---------------------------------------------------------------------------
    --! @name RTL Sub-Module Component Declarations
    --! @{
    ---------------------------------------------------------------------------

    --! @brief Streaming 2D convolution with per-pixel quantized int8 output.
    --!        Used for Conv1 (1 input channel, 3 output channels, 5×5 kernel).
    component conv2d_int8_streaming
        generic (
            IN_WIDTH     : integer; IN_HEIGHT    : integer;
            IN_CHANNELS  : integer; OUT_CHANNELS : integer;
            KERNEL_SIZE  : integer;
            Q_MULT       : int32;   Q_SHIFT      : integer;
            Q_ZERO_POINT : int8;    USE_RELU     : boolean
        );
        port (
            clk           : in  std_logic; rst           : in  std_logic;
            start         : in  std_logic; done          : out std_logic;
            weight_addr_0 : out std_logic_vector(4 downto 0); weight_data_0 : in int8;
            weight_addr_1 : out std_logic_vector(4 downto 0); weight_data_1 : in int8;
            weight_addr_2 : out std_logic_vector(4 downto 0); weight_data_2 : in int8;
            bias_data_0   : in  int32; bias_data_1 : in int32; bias_data_2 : in int32;
            in_bram_addr  : out std_logic_vector(9 downto 0); in_bram_data : in int8;
            out_data_0    : out int8;  out_data_1  : out int8; out_data_2  : out int8;
            out_valid     : out std_logic
        );
    end component;

    --! @brief Streaming 2D convolution variant for Conv2 (3 input channels,
    --!        6 output channels, 5×5 kernel, wider weight address bus).
    component conv2d_int8_streaming_c2
        generic (
            IN_WIDTH     : integer; IN_HEIGHT    : integer;
            IN_CHANNELS  : integer; OUT_CHANNELS : integer;
            KERNEL_SIZE  : integer;
            Q_MULT       : int32;   Q_SHIFT      : integer;
            Q_ZERO_POINT : int8;    USE_RELU     : boolean
        );
        port (
            clk           : in  std_logic; rst           : in  std_logic;
            start         : in  std_logic; done          : out std_logic;
            weight_addr_0 : out std_logic_vector(6 downto 0); weight_data_0 : in int8;
            weight_addr_1 : out std_logic_vector(6 downto 0); weight_data_1 : in int8;
            weight_addr_2 : out std_logic_vector(6 downto 0); weight_data_2 : in int8;
            weight_addr_3 : out std_logic_vector(6 downto 0); weight_data_3 : in int8;
            weight_addr_4 : out std_logic_vector(6 downto 0); weight_data_4 : in int8;
            weight_addr_5 : out std_logic_vector(6 downto 0); weight_data_5 : in int8;
            bias_data_0   : in  int32; bias_data_1 : in int32; bias_data_2 : in int32;
            bias_data_3   : in  int32; bias_data_4 : in int32; bias_data_5 : in int32;
            in_bram_addr  : out std_logic_vector(9 downto 0); in_bram_data : in int8;
            out_data_0    : out int8;  out_data_1  : out int8; out_data_2  : out int8;
            out_data_3    : out int8;  out_data_4  : out int8; out_data_5  : out int8;
            out_valid     : out std_logic
        );
    end component;

    --! @brief Generic 2D max-pooling module (reused for both Pool1 and Pool2
    --!        via generics; see maxpool2d.vhd).
    component maxpool2d
        generic (
            IN_WIDTH    : integer; IN_HEIGHT   : integer;
            IN_CHANNELS : integer; POOL_SIZE   : integer
        );
        port (
            clk      : in  std_logic; rst     : in  std_logic;
            start    : in  std_logic; done    : out std_logic;
            in_addr  : out std_logic_vector(11 downto 0); in_data  : in  int8;
            out_addr : out std_logic_vector(11 downto 0);
            out_data : out int8; out_we : out std_logic
        );
    end component;

    --! @name Xilinx BRAM IP Cores - Conv1 Weights and Biases
    --! @{

    --! @brief Conv1 weight BRAM for output channel 0 (25 × int8).
    component blk_mem_c11_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(4 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;

    --! @brief Conv1 weight BRAM for output channel 1 (25 × int8).
    component blk_mem_c12_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(4 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;

    --! @brief Conv1 weight BRAM for output channel 2 (25 × int8).
    component blk_mem_c13_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(4 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;

    --! @brief Conv1 bias BRAM - single address returns 3 × int32 packed (96 bits).
    component blk_mem_c1_b
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic;
              douta : out std_logic_vector(95 downto 0));
    end component;

    --! @brief Input image BRAM - 32×32×1 = 1024 grayscale int8 pixels.
    component blk_mem_in
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(9 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;
    --! @}

    --! @name Xilinx BRAM IP Cores - Conv2 Weights and Biases
    --! @{

    --! @brief Conv2 weight BRAM for output channel 0 (75 × int8).
    component blk_mem_c21_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(6 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;

    --! @brief Conv2 weight BRAM for output channel 1 (75 × int8).
    component blk_mem_c22_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(6 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;

    --! @brief Conv2 weight BRAM for output channel 2 (75 × int8).
    component blk_mem_c23_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(6 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;

    --! @brief Conv2 weight BRAM for output channel 3 (75 × int8).
    component blk_mem_c24_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(6 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;

    --! @brief Conv2 weight BRAM for output channel 4 (75 × int8).
    component blk_mem_c25_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(6 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;

    --! @brief Conv2 weight BRAM for output channel 5 (75 × int8).
    component blk_mem_c26_w
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic_vector(6 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;

    --! @brief Conv2 bias BRAM - single address returns 6 × int32 packed (192 bits).
    component blk_mem_c2_b
        port (clka : in std_logic; ena : in std_logic;
              addra : in std_logic;
              douta : out std_logic_vector(191 downto 0));
    end component;
    --! @}

begin

    ---------------------------------------------------------------------------
    --! @name SLV ? int8 / int32 Type Conversions (concurrent assignments)
    --! @details BRAMs expose std_logic_vector ports; these assignments convert
    --!          the raw bus to signed types expected by the RTL sub-modules.
    --!          Bias words are split from their packed wide SLV representation.
    --! @{
    ---------------------------------------------------------------------------

    -- Conv1 weight and pixel conversions
    c1_weight_data_0 <= signed(c1_weight_slv_0);
    c1_weight_data_1 <= signed(c1_weight_slv_1);
    c1_weight_data_2 <= signed(c1_weight_slv_2);
    c1_in_data       <= signed(c1_in_slv);

    -- Conv1 bias unpacking (96-bit ? 3 × 32-bit, little-endian channel order)
    c1_bias_data_0 <= signed(c1_bias_slv(31 downto  0));
    c1_bias_data_1 <= signed(c1_bias_slv(63 downto 32));
    c1_bias_data_2 <= signed(c1_bias_slv(95 downto 64));

    -- Conv2 weight conversions
    c2_weight_data_0 <= signed(c2_weight_slv_0);
    c2_weight_data_1 <= signed(c2_weight_slv_1);
    c2_weight_data_2 <= signed(c2_weight_slv_2);
    c2_weight_data_3 <= signed(c2_weight_slv_3);
    c2_weight_data_4 <= signed(c2_weight_slv_4);
    c2_weight_data_5 <= signed(c2_weight_slv_5);

    -- Conv2 bias unpacking (192-bit ? 6 × 32-bit, little-endian channel order)
    c2_bias_data_0 <= signed(c2_bias_slv( 31 downto   0));
    c2_bias_data_1 <= signed(c2_bias_slv( 63 downto  32));
    c2_bias_data_2 <= signed(c2_bias_slv( 95 downto  64));
    c2_bias_data_3 <= signed(c2_bias_slv(127 downto  96));
    c2_bias_data_4 <= signed(c2_bias_slv(159 downto 128));
    c2_bias_data_5 <= signed(c2_bias_slv(191 downto 160));
    --! @}

    ---------------------------------------------------------------------------
    --! @name Conv1 BRAM Instantiations
    --! @details All BRAMs are always enabled (ena='1'); the Conv1 module drives
    --!          the addresses combinatorially and reads data one cycle later.
    --! @{
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
    --! @}

    ---------------------------------------------------------------------------
    --! @name Conv2 BRAM Instantiations
    --! @details Six weight BRAMs (one per output channel) and one bias BRAM.
    --!          Bias BRAM is addressed at '0' to return all 6 biases at once.
    --! @{
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
    --! @}

    ---------------------------------------------------------------------------
    --! @brief Conv1 instantiation.
    --!
    --! @details Configured as a 32×32×1 ? 28×28×3 convolution (VALID padding,
    --!          5×5 kernel). ReLU is integrated (USE_RELU=true). Quantization
    --!          parameters (Q_MULT, Q_SHIFT, Q_ZERO_POINT) are sourced from
    --!          lenet_qparams_pkg to match the trained model's fixed-point scheme.
    ---------------------------------------------------------------------------
    CONV1 : conv2d_int8_streaming
        generic map(
            IN_WIDTH     => 32, IN_HEIGHT    => 32,
            IN_CHANNELS  => 1,  OUT_CHANNELS => 3,
            KERNEL_SIZE  => 5,
            Q_MULT       => C1_MULT, Q_SHIFT => C1_SHIFT,
            Q_ZERO_POINT => C1_ZERO_POINT,
            USE_RELU     => true)
        port map(
            clk           => clk, rst           => rst,
            start         => conv1_start, done  => conv1_done,
            weight_addr_0 => c1_weight_addr_0, weight_data_0 => c1_weight_data_0,
            weight_addr_1 => c1_weight_addr_1, weight_data_1 => c1_weight_data_1,
            weight_addr_2 => c1_weight_addr_2, weight_data_2 => c1_weight_data_2,
            bias_data_0   => c1_bias_data_0, bias_data_1 => c1_bias_data_1,
            bias_data_2   => c1_bias_data_2,
            in_bram_addr  => c1_in_addr, in_bram_data => c1_in_data,
            out_data_0    => conv1_out_0, out_data_1 => conv1_out_1,
            out_data_2    => conv1_out_2, out_valid  => conv1_valid);

    ---------------------------------------------------------------------------
    --! @brief MaxPool1 instantiation.
    --!
    --! @details Configured for 28×28×3 ? 14×14×3, 2×2 pool.
    --!          Reads from buffer1 with 1-cycle latency.
    --!          Writes results directly into buffer2 via pool1_out_we.
    ---------------------------------------------------------------------------
    POOL1 : maxpool2d
        generic map(IN_WIDTH=>28, IN_HEIGHT=>28, IN_CHANNELS=>3, POOL_SIZE=>2)
        port map(
            clk      => clk, rst      => rst,
            start    => pool1_start,  done     => pool1_done,
            in_addr  => pool1_in_addr, in_data => pool1_in_data,
            out_addr => pool1_out_addr, out_data => pool1_out_data,
            out_we   => pool1_out_we);

    --! Buffer1 read data routed to MaxPool1 input
    pool1_in_data <= buf1_rd_data;

    ---------------------------------------------------------------------------
    --! @brief Conv2 instantiation.
    --!
    --! @details Configured as a 14×14×3 ? 10×10×6 convolution (VALID padding,
    --!          5×5 kernel). ReLU is integrated. Reads from buffer2 via c2_in_addr.
    ---------------------------------------------------------------------------
    CONV2 : conv2d_int8_streaming_c2
        generic map(
            IN_WIDTH     => 14, IN_HEIGHT    => 14,
            IN_CHANNELS  => 3,  OUT_CHANNELS => 6,
            KERNEL_SIZE  => 5,
            Q_MULT       => C2_MULT, Q_SHIFT => C2_SHIFT,
            Q_ZERO_POINT => C2_ZERO_POINT,
            USE_RELU     => true)
        port map(
            clk           => clk, rst           => rst,
            start         => conv2_start, done  => conv2_done,
            weight_addr_0 => c2_weight_addr_0, weight_data_0 => c2_weight_data_0,
            weight_addr_1 => c2_weight_addr_1, weight_data_1 => c2_weight_data_1,
            weight_addr_2 => c2_weight_addr_2, weight_data_2 => c2_weight_data_2,
            weight_addr_3 => c2_weight_addr_3, weight_data_3 => c2_weight_data_3,
            weight_addr_4 => c2_weight_addr_4, weight_data_4 => c2_weight_data_4,
            weight_addr_5 => c2_weight_addr_5, weight_data_5 => c2_weight_data_5,
            bias_data_0   => c2_bias_data_0, bias_data_1 => c2_bias_data_1,
            bias_data_2   => c2_bias_data_2, bias_data_3 => c2_bias_data_3,
            bias_data_4   => c2_bias_data_4, bias_data_5 => c2_bias_data_5,
            in_bram_addr  => c2_in_addr, in_bram_data => c2_in_data,
            out_data_0    => conv2_out_0, out_data_1 => conv2_out_1,
            out_data_2    => conv2_out_2, out_data_3 => conv2_out_3,
            out_data_4    => conv2_out_4, out_data_5 => conv2_out_5,
            out_valid     => conv2_valid);

    --! Buffer2 read data routed to Conv2 input
    c2_in_data <= buf2_rd_data;

    ---------------------------------------------------------------------------
    --! @brief MaxPool2 instantiation.
    --!
    --! @details Configured for 10×10×6 ? 5×5×6, 2×2 pool.
    --!          Reads from buffer3 with 1-cycle latency.
    --!          Writes directly to the external pool2_out_* ports so the
    --!          testbench can capture the final feature map without an
    --!          additional read port.
    ---------------------------------------------------------------------------
    POOL2 : maxpool2d
        generic map(IN_WIDTH=>10, IN_HEIGHT=>10, IN_CHANNELS=>6, POOL_SIZE=>2)
        port map(
            clk      => clk, rst      => rst,
            start    => pool2_start,  done     => pool2_done,
            in_addr  => pool2_in_addr, in_data => pool2_in_data,
            out_addr => pool2_out_addr, out_data => pool2_out_data,
            out_we   => pool2_out_we);

    --! Buffer3 read data routed to MaxPool2 input
    pool2_in_data <= buf3_rd_data;

    ---------------------------------------------------------------------------
    --! @brief Buffer 1 RAM process.
    --!
    --! @details Implements a single inferred dual-port RAM combining write
    --!          and read in one clocked process (Xilinx read-first policy).
    --!
    --!          Write path: activated in RUN_CONV1 when conv1_valid='1'.
    --!          Writes 3 consecutive addresses per valid cycle (one per output
    --!          channel), incrementing buf1_wr_count by 3. Guarded against
    --!          overflow by checking buf1_wr_count + 2 < BUF1_SIZE.
    --!
    --!          Read path: always active; presents buffer1[pool1_in_addr]
    --!          on buf1_rd_data with 1-cycle latency (BRAM behaviour).
    ---------------------------------------------------------------------------
    buf1_ram_proc : process(clk)
        variable rd_addr_v : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                buf1_wr_count <= 0;
                buf1_rd_data  <= (others => '0');
            else
                -- Write: 3 channels per valid Conv1 output pixel
                if state = RUN_CONV1 and conv1_valid = '1' then
                    if buf1_wr_count + 2 < BUF1_SIZE then
                        buffer1(buf1_wr_count + 0) <= conv1_out_0;
                        buffer1(buf1_wr_count + 1) <= conv1_out_1;
                        buffer1(buf1_wr_count + 2) <= conv1_out_2;
                        buf1_wr_count <= buf1_wr_count + 3;
                    end if;
                end if;
                -- Read: synchronous, 1-cycle latency
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
    --! @brief Buffer 2 RAM process.
    --!
    --! @details Single inferred dual-port RAM (write + read in one process).
    --!
    --!          Write path: activated when pool1_out_we='1'; address is
    --!          pool1_out_addr (random, driven by MaxPool1 FSM).
    --!          No write counter needed - MaxPool1 guarantees no out-of-range
    --!          writes, but an explicit bounds check is kept for safety.
    --!
    --!          Read path: presents buffer2[c2_in_addr] on buf2_rd_data
    --!          with 1-cycle latency.
    ---------------------------------------------------------------------------
    buf2_ram_proc : process(clk)
        variable wr_addr_v : integer;
        variable rd_addr_v : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                buf2_rd_data <= (others => '0');
            else
                -- Write: on MaxPool1 write-enable
                if pool1_out_we = '1' then
                    wr_addr_v := to_integer(unsigned(pool1_out_addr));
                    if wr_addr_v >= 0 and wr_addr_v < BUF2_SIZE then
                        buffer2(wr_addr_v) <= pool1_out_data;
                    end if;
                end if;
                -- Read: synchronous, 1-cycle latency
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
    --! @brief Buffer 3 RAM process.
    --!
    --! @details Single inferred dual-port RAM (write + read in one process).
    --!
    --!          Write path: activated in RUN_CONV2 when conv2_valid='1'.
    --!          Writes 6 consecutive addresses per valid cycle (one per output
    --!          channel), incrementing buf3_wr_count by 6. Guarded against
    --!          overflow by checking buf3_wr_count + 5 < BUF3_SIZE.
    --!
    --!          Read path: presents buffer3[pool2_in_addr] on buf3_rd_data
    --!          with 1-cycle latency.
    ---------------------------------------------------------------------------
    buf3_ram_proc : process(clk)
        variable rd_addr_v : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                buf3_wr_count <= 0;
                buf3_rd_data  <= (others => '0');
            else
                -- Write: 6 channels per valid Conv2 output pixel
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
                -- Read: synchronous, 1-cycle latency
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
    --! @brief Top-level FSM process.
    --!
    --! @details Controls the sequential activation of all pipeline stages.
    --!          All start signals are self-clearing (pulsed for exactly one
    --!          clock cycle) by being reset to '0' at the top of the else
    --!          branch before the case statement.
    --!
    --!          State transitions:
    --!          - IDLE        : waits for start='1', then pulses conv1_start.
    --!          - RUN_CONV1   : waits for conv1_done, then pulses pool1_start.
    --!          - RUN_POOL1   : waits for pool1_done, then pulses conv2_start.
    --!          - RUN_CONV2   : waits for conv2_done, then pulses pool2_start.
    --!          - RUN_POOL2   : waits for pool2_done, then asserts done.
    --!          - DONE_STATE  : holds done='1'; returns to IDLE when start='0'.
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
            else
                -- Default: deassert all start pulses
                conv1_start <= '0';
                pool1_start <= '0';
                conv2_start <= '0';
                pool2_start <= '0';

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