----------------------------------------------------------------------------------
--! @file    top_lenet_full.vhd
--! @brief   Top-level du pipeline LeNet-5 modifié complet - Conv1?Pool1?Conv2?Pool2?FC
--!
--! @details Ce module est le bloc de plus haut niveau du design LeNet-5 modifié.
--!          Il instancie et interconnecte l'ensemble des étages du pipeline
--!          d'inférence, gère les 14 BRAMs de paramètres, les 4 buffers
--!          intermédiaires en RAM inférée, et pilote la FSM séquentielle
--!          enchaînant les 6 étapes de traitement.
--!
--! @section architecture Architecture interne
--!   @code
--!   blk_mem_in ??????????? CONV1 ??out_valid??? buffer1 (2352 B)
--!   blk_mem_c11/12/13_w ???                          ? pool1_in_addr
--!   blk_mem_c1_b ??????????                          ?
--!                                                  POOL1 ??out_we??? buffer2 (588 B)
--!                                                                          ? c2_in_addr
--!   blk_mem_c21..c26_w ??? CONV2 ?????????????????????
--!   blk_mem_c2_b ??????????      ??out_valid??? buffer3 (600 B)
--!                                                   ? pool2_in_addr
--!                                                POOL2 ??out_we??? buffer4 (150 B)
--!                                                                        ? fc_in_bram
--!   blk_mem_fc_w ?????????? FC ??????????????????????
--!   blk_mem_fc_b ??????????    ??out_valid??? fc_out_data (port externe)
--!   @endcode
--!
--! @section brams BRAMs instanciées (14 total)
--!   - Conv1 : blk_mem_c11_w, blk_mem_c12_w, blk_mem_c13_w (poids 3 filtres)
--!             blk_mem_c1_b (biais 3×32b), blk_mem_in (image 32×32)
--!   - Conv2 : blk_mem_c21_w .. blk_mem_c26_w (poids 6 filtres)
--!             blk_mem_c2_b (biais 6×32b)
--!   - FC    : blk_mem_fc_w (1500 poids), blk_mem_fc_b (10 biais)
--!
--! @section buffers Buffers intermédiaires (RAM inférée, format HWC)
--!   | Buffer  | Taille  | Source              | Destination        |
--!   |---------|---------|---------------------|--------------------|
--!   | buffer1 | 2352 B  | Conv1 streaming     | MaxPool1 (random)  |
--!   | buffer2 |  588 B  | MaxPool1 out_we     | Conv2 (random)     |
--!   | buffer3 |  600 B  | Conv2 streaming     | MaxPool2 (random)  |
--!   | buffer4 |  150 B  | MaxPool2 out_we     | FC in_bram         |
--!
--! @section buffers_protocole Protocole buffers (lecture/écriture)
--!   Buffers 1 et 3 (streaming) : écriture N canaux/cycle sur out_valid,
--!   compteur séquentiel (buf1_wr_count, buf3_wr_count). Lecture synchrone
--!   1 cycle latence depuis le module de pooling aval.
--!
--!   Buffers 2 et 4 (aléatoire) : écriture adressée sur out_we depuis le
--!   pooling amont. Lecture synchrone 1 cycle latence depuis le module aval.
--!
--! @section fsm Machine d'états Top (7 états)
--!   @code
--!   IDLE ??start='1'??? RUN_CONV1 ??conv1_done??? RUN_POOL1
--!                                                      ? pool1_done
--!                                                      ?
--!                                                 RUN_CONV2 ??conv2_done??? RUN_POOL2
--!                                                                               ? pool2_done
--!                                                                               ?
--!                                                                           RUN_FC ??fc_done??? DONE_STATE
--!                                                                                                   ? start='0'
--!                                                                                                   ?
--!                                                                                                  IDLE
--!   @endcode
--!
--! @section cycles Cycles par étage (estimés, 100 MHz)
--!   - RUN_CONV1 : ~1 134 cycles  (28×28 pixels, pipeline 8 stages)
--!   - RUN_POOL1 : ~6 050 cycles  (28×28×3, FSM 7 états × KK=4)
--!   - RUN_CONV2 :   ~830 cycles  (10×10 pixels, pipeline 10 stages)
--!   - RUN_POOL2 : ~1 690 cycles  (10×10×6, FSM 7 états × KK=4)
--!   - RUN_FC    : ~1 660 cycles  (LOAD_WEIGHTS 1513 + ACCUMULATE 152 + pipeline 4)
--!   - Total     : ~11 364 cycles (~114 µs)
--!
--! @author  Donald MYO
--! @date    2025
--! @version 1.0 - Pipeline complet LeNet-5 modifié, 14 BRAMs, 4 buffers RAM
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

--! @brief Top-level pipeline LeNet-5 modifié - entité principale
--!
--! @details Interface minimale : seuls les signaux de contrôle (clk, rst, start,
--!          done) et les logits de sortie FC (fc_out_data, fc_out_valid) sont
--!          exposés. Toutes les BRAMs et interconnexions internes sont encapsulées.
entity top_lenet_full is
    port (
        --! @name Contrôle
        --! @{
        clk   : in  std_logic;  --! Horloge système (front montant actif, 100 MHz)
        rst   : in  std_logic;  --! Reset synchrone actif haut
        start : in  std_logic;  --! Impulsion de démarrage d'une inférence (1 cycle)
        done  : out std_logic;  --! Fin de l'inférence complète (FC terminée)
        --! @}

        --! @name Sorties FC - logits des 10 classes MNIST
        --! @{
        fc_out_data  : out int8_vector(0 to 9);
        --! Vecteur des 10 logits int8 (classe N = chiffre MNIST N)
        --! Stable après fc_out_valid='1' jusqu'à la prochaine inférence

        fc_out_valid : out std_logic
        --! Pulse 1 cycle indiquant que fc_out_data contient les logits finaux
        --! @}
    );
end top_lenet_full;

architecture Behavioral of top_lenet_full is

    ---------------------------------------------------------------------------
    --! @name Constantes - tailles des buffers intermédiaires
    --! @{
    ---------------------------------------------------------------------------
    constant BUF1_SIZE : integer := 28 * 28 * 3;
    --! Buffer1 : sortie Conv1 = OUT_W×OUT_H×OUT_C = 28×28×3 = 2352 octets

    constant BUF2_SIZE : integer := 14 * 14 * 3;
    --! Buffer2 : sortie MaxPool1 = 14×14×3 = 588 octets

    constant BUF3_SIZE : integer := 10 * 10 * 6;
    --! Buffer3 : sortie Conv2 = 10×10×6 = 600 octets

    constant BUF4_SIZE : integer :=  5 *  5 * 6;
    --! Buffer4 : sortie MaxPool2 = 5×5×6 = 150 octets (entrée FC)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Buffer 1 - Conv1 streaming ? MaxPool1 (lecture aléatoire)
    --! @{
    ---------------------------------------------------------------------------

    --! @brief RAM inférée 2352 octets - Vivado l'infère en LUTRAM ou BRAM selon placement
    type buf1_type is array (0 to BUF1_SIZE-1) of int8;
    signal buffer1 : buf1_type := (others => (others => '0'));

    signal buf1_wr_count : integer range 0 to BUF1_SIZE := 0;
    --! Compteur d'écriture séquentiel : avance de +3 à chaque pixel Conv1 valide
    --! (3 canaux écrits simultanément aux positions buf1_wr_count+0, +1, +2)

    signal buf1_rd_data : int8 := (others => '0');
    --! Donnée lue depuis buffer1 avec 1 cycle de latence, connectée à pool1_in_data
    --! @}

    ---------------------------------------------------------------------------
    --! @name Buffer 2 - MaxPool1 (out_we) ? Conv2 (lecture aléatoire)
    --! @{
    ---------------------------------------------------------------------------

    --! @brief RAM inférée 588 octets - écrite par adresse (pool1_out_addr)
    type buf2_type is array (0 to BUF2_SIZE-1) of int8;
    signal buffer2 : buf2_type := (others => (others => '0'));

    signal buf2_rd_data : int8 := (others => '0');
    --! Donnée lue depuis buffer2 avec 1 cycle de latence, connectée à c2_in_data
    --! @}

    ---------------------------------------------------------------------------
    --! @name Buffer 3 - Conv2 streaming ? MaxPool2 (lecture aléatoire)
    --! @{
    ---------------------------------------------------------------------------

    --! @brief RAM inférée 600 octets - écriture streaming 6 canaux/cycle
    type buf3_type is array (0 to BUF3_SIZE-1) of int8;
    signal buffer3 : buf3_type := (others => (others => '0'));

    signal buf3_wr_count : integer range 0 to BUF3_SIZE := 0;
    --! Compteur d'écriture séquentiel : avance de +6 à chaque pixel Conv2 valide

    signal buf3_rd_data : int8 := (others => '0');
    --! Donnée lue depuis buffer3 avec 1 cycle de latence, connectée à pool2_in_data
    --! @}

    ---------------------------------------------------------------------------
    --! @name Buffer 4 - MaxPool2 (out_we) ? FC (lecture aléatoire)
    --! @{
    ---------------------------------------------------------------------------

    --! @brief RAM inférée 150 octets - écrite par adresse (pool2_out_addr)
    type buf4_type is array (0 to BUF4_SIZE-1) of int8;
    signal buffer4 : buf4_type := (others => (others => '0'));

    signal buf4_rd_data : int8 := (others => '0');
    --! Donnée lue depuis buffer4 avec 1 cycle de latence, connectée à fc_in_bram_data
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux BRAMs Conv1
    --! @{
    ---------------------------------------------------------------------------
    signal c1_weight_addr_0 : std_logic_vector(4 downto 0);   --! Adresse BRAM filtre 0 (0..24)
    signal c1_weight_addr_1 : std_logic_vector(4 downto 0);
    signal c1_weight_addr_2 : std_logic_vector(4 downto 0);
    signal c1_weight_slv_0  : std_logic_vector(7 downto 0);   --! Poids filtre 0 (SLV brut)
    signal c1_weight_slv_1  : std_logic_vector(7 downto 0);
    signal c1_weight_slv_2  : std_logic_vector(7 downto 0);
    signal c1_weight_data_0 : int8;                           --! Poids filtre 0 (INT8 signé)
    signal c1_weight_data_1 : int8;
    signal c1_weight_data_2 : int8;

    signal c1_bias_slv    : std_logic_vector(95 downto 0);
    --! Biais Conv1 concaténés 96b : [31:0]=b0, [63:32]=b1, [95:64]=b2
    signal c1_bias_data_0 : int32;
    signal c1_bias_data_1 : int32;
    signal c1_bias_data_2 : int32;

    signal c1_in_addr : std_logic_vector(9 downto 0);   --! Adresse image d'entrée (0..1023)
    signal c1_in_slv  : std_logic_vector(7 downto 0);   --! Pixel brut BRAM (SLV)
    signal c1_in_data : int8;                           --! Pixel INT8 signé
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux BRAMs Conv2
    --! @{
    ---------------------------------------------------------------------------
    signal c2_weight_addr_0 : std_logic_vector(6 downto 0);  --! Adresse BRAM filtre 0 (0..74)
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
    --! Biais Conv2 concaténés 192b : [31:0]=b0, ..., [191:160]=b5
    signal c2_bias_data_0 : int32;
    signal c2_bias_data_1 : int32;
    signal c2_bias_data_2 : int32;
    signal c2_bias_data_3 : int32;
    signal c2_bias_data_4 : int32;
    signal c2_bias_data_5 : int32;

    signal c2_in_addr : std_logic_vector(9 downto 0);  --! Adresse buffer2 (0..587)
    signal c2_in_data : int8;                          --! Donnée buffer2 ? Conv2
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux BRAMs FC
    --! @{
    ---------------------------------------------------------------------------
    signal fc_weight_addr : std_logic_vector(10 downto 0);  --! Adresse BRAM poids FC (0..1499)
    signal fc_weight_slv  : std_logic_vector(7 downto 0);
    signal fc_weight_data : int8;

    signal fc_bias_addr : std_logic_vector(3 downto 0);    --! Adresse BRAM biais FC (0..9)
    signal fc_bias_slv  : std_logic_vector(31 downto 0);
    signal fc_bias_data : int32;

    signal fc_in_bram_addr : std_logic_vector(7 downto 0); --! Adresse buffer4 (0..149)
    signal fc_in_bram_data : int8;                         --! Donnée buffer4 ? FC
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de contrôle Conv1
    --! @{
    ---------------------------------------------------------------------------
    signal conv1_start : std_logic := '0';  --! Démarrage Conv1 (impulsion 1 cycle)
    signal conv1_done  : std_logic;         --! Fin Conv1 (784 pixels émis)
    signal conv1_out_0 : int8;              --! Pixel sortie canal 0 (après ReLU)
    signal conv1_out_1 : int8;
    signal conv1_out_2 : int8;
    signal conv1_valid : std_logic;         --! Validité sorties Conv1
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de contrôle MaxPool1
    --! @{
    ---------------------------------------------------------------------------
    signal pool1_start    : std_logic := '0';              --! Démarrage MaxPool1
    signal pool1_done     : std_logic;                     --! Fin MaxPool1 (588 pixels écrits)
    signal pool1_in_addr  : std_logic_vector(11 downto 0); --! Adresse lecture buffer1
    signal pool1_in_data  : int8;                          --! Donnée buffer1 ? MaxPool1
    signal pool1_out_addr : std_logic_vector(11 downto 0); --! Adresse écriture buffer2
    signal pool1_out_data : int8;                          --! Valeur max fenêtre 2×2
    signal pool1_out_we   : std_logic;                     --! Écriture buffer2 (1 cycle)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de contrôle Conv2
    --! @{
    ---------------------------------------------------------------------------
    signal conv2_start : std_logic := '0';
    signal conv2_done  : std_logic;         --! Fin Conv2 (100 pixels émis)
    signal conv2_out_0 : int8;
    signal conv2_out_1 : int8;
    signal conv2_out_2 : int8;
    signal conv2_out_3 : int8;
    signal conv2_out_4 : int8;
    signal conv2_out_5 : int8;
    signal conv2_valid : std_logic;
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de contrôle MaxPool2
    --! @{
    ---------------------------------------------------------------------------
    signal pool2_start    : std_logic := '0';
    signal pool2_done     : std_logic;                     --! Fin MaxPool2 (150 pixels écrits)
    signal pool2_in_addr  : std_logic_vector(11 downto 0);
    signal pool2_in_data  : int8;
    signal pool2_out_addr : std_logic_vector(11 downto 0);
    signal pool2_out_data : int8;
    signal pool2_out_we   : std_logic;
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de contrôle FC
    --! @{
    ---------------------------------------------------------------------------
    signal fc_start : std_logic := '0';  --! Démarrage FC
    signal fc_done  : std_logic;         --! Fin FC (logits disponibles)
    --! @}

    ---------------------------------------------------------------------------
    --! @brief États de la FSM top-level
    --!
    --! @details FSM séquentielle à 7 états pilotant l'enchaînement des 5 étages
    --!          de traitement. Les signaux de démarrage (conv1_start, pool1_start,
    --!          conv2_start, pool2_start, fc_start) sont des impulsions d'1 cycle
    --!          remises à '0' par défaut à chaque cycle.
    ---------------------------------------------------------------------------
    type state_type is (
        IDLE,        --! Attente du signal start
        RUN_CONV1,   --! Conv1 en cours - buffer1 alimenté par buf1_ram_proc
        RUN_POOL1,   --! MaxPool1 en cours - buffer1 lu, buffer2 écrit
        RUN_CONV2,   --! Conv2 en cours - buffer2 lu, buffer3 alimenté
        RUN_POOL2,   --! MaxPool2 en cours - buffer3 lu, buffer4 écrit
        RUN_FC,      --! FC en cours - buffer4 lu, logits calculés
        DONE_STATE   --! Assertion done, attente relâchement de start
    );
    signal state : state_type := IDLE;

    ---------------------------------------------------------------------------
    -- Déclarations des composants RTL
    ---------------------------------------------------------------------------

    --! @brief Composant Conv1 - conv2d_int8_streaming (32×32×1 ? 28×28×3)
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

    --! @brief Composant Conv2 - conv2d_int8_streaming_c2 (14×14×3 ? 10×10×6)
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

    --! @brief Composant MaxPool1 et MaxPool2 - maxpool2d (générique)
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

    --! @brief Composant FC - fc_int8 (150?10, USE_RELU=false)
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
    --! @brief BRAM poids filtre 0 Conv1 (25×8b, blk_mem_c11_w.coe)
    component blk_mem_c11_w
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(4 downto 0);
              douta:out std_logic_vector(7 downto 0));
    end component;
    --! @brief BRAM poids filtre 1 Conv1 (blk_mem_c12_w.coe)
    component blk_mem_c12_w
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(4 downto 0);
              douta:out std_logic_vector(7 downto 0));
    end component;
    --! @brief BRAM poids filtre 2 Conv1 (blk_mem_c13_w.coe)
    component blk_mem_c13_w
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(4 downto 0);
              douta:out std_logic_vector(7 downto 0));
    end component;
    --! @brief BRAM biais Conv1 - 3 biais int32 sur 96 bits (blk_mem_c1_b.coe)
    component blk_mem_c1_b
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic;
              douta:out std_logic_vector(95 downto 0));
    end component;
    --! @brief BRAM image d'entrée - 1024 pixels INT8 (32×32, blk_mem_in.coe)
    component blk_mem_in
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(9 downto 0);
              douta:out std_logic_vector(7 downto 0));
    end component;

    ---------------------------------------------------------------------------
    -- BRAMs Conv2
    ---------------------------------------------------------------------------
    --! @brief BRAM poids filtre 0 Conv2 (75×8b, addr 7b, blk_mem_c21_w.coe)
    component blk_mem_c21_w
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(6 downto 0);
              douta:out std_logic_vector(7 downto 0));
    end component;
    --! @brief BRAM poids filtre 1 Conv2 (blk_mem_c22_w.coe)
    component blk_mem_c22_w
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(6 downto 0);
              douta:out std_logic_vector(7 downto 0));
    end component;
    --! @brief BRAM poids filtre 2 Conv2 (blk_mem_c23_w.coe)
    component blk_mem_c23_w
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(6 downto 0);
              douta:out std_logic_vector(7 downto 0));
    end component;
    --! @brief BRAM poids filtre 3 Conv2 (blk_mem_c24_w.coe)
    component blk_mem_c24_w
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(6 downto 0);
              douta:out std_logic_vector(7 downto 0));
    end component;
    --! @brief BRAM poids filtre 4 Conv2 (blk_mem_c25_w.coe)
    component blk_mem_c25_w
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(6 downto 0);
              douta:out std_logic_vector(7 downto 0));
    end component;
    --! @brief BRAM poids filtre 5 Conv2 (blk_mem_c26_w.coe)
    component blk_mem_c26_w
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(6 downto 0);
              douta:out std_logic_vector(7 downto 0));
    end component;
    --! @brief BRAM biais Conv2 - 6 biais int32 sur 192 bits (blk_mem_c2_b.coe)
    component blk_mem_c2_b
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic;
              douta:out std_logic_vector(191 downto 0));
    end component;

    ---------------------------------------------------------------------------
    -- BRAMs FC
    ---------------------------------------------------------------------------
    --! @brief BRAM poids FC - 1500 coefficients INT8 (addr 11b, blk_mem_fc_w.coe)
    component blk_mem_fc_w
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(10 downto 0);
              douta:out std_logic_vector(7 downto 0));
    end component;
    --! @brief BRAM biais FC - 10 biais INT32 (addr 4b, blk_mem_fc_b.coe)
    component blk_mem_fc_b
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(3 downto 0);
              douta:out std_logic_vector(31 downto 0));
    end component;

begin

    ---------------------------------------------------------------------------
    --! @brief Conversions std_logic_vector ? signed pour Conv1
    --!
    --! @details Les BRAMs Xilinx exposent leurs données en SLV.
    --!          c1_bias_slv 96b est découpé en 3 tranches de 32 bits.
    ---------------------------------------------------------------------------
    c1_weight_data_0 <= signed(c1_weight_slv_0);
    c1_weight_data_1 <= signed(c1_weight_slv_1);
    c1_weight_data_2 <= signed(c1_weight_slv_2);
    c1_in_data       <= signed(c1_in_slv);
    c1_bias_data_0   <= signed(c1_bias_slv(31 downto  0));
    c1_bias_data_1   <= signed(c1_bias_slv(63 downto 32));
    c1_bias_data_2   <= signed(c1_bias_slv(95 downto 64));

    ---------------------------------------------------------------------------
    --! @brief Conversions std_logic_vector ? signed pour Conv2
    --!
    --! @details c2_bias_slv 192b découpé en 6 tranches de 32 bits.
    ---------------------------------------------------------------------------
    c2_weight_data_0 <= signed(c2_weight_slv_0);
    c2_weight_data_1 <= signed(c2_weight_slv_1);
    c2_weight_data_2 <= signed(c2_weight_slv_2);
    c2_weight_data_3 <= signed(c2_weight_slv_3);
    c2_weight_data_4 <= signed(c2_weight_slv_4);
    c2_weight_data_5 <= signed(c2_weight_slv_5);
    c2_bias_data_0   <= signed(c2_bias_slv( 31 downto   0));
    c2_bias_data_1   <= signed(c2_bias_slv( 63 downto  32));
    c2_bias_data_2   <= signed(c2_bias_slv( 95 downto  64));
    c2_bias_data_3   <= signed(c2_bias_slv(127 downto  96));
    c2_bias_data_4   <= signed(c2_bias_slv(159 downto 128));
    c2_bias_data_5   <= signed(c2_bias_slv(191 downto 160));

    ---------------------------------------------------------------------------
    --! @brief Conversions std_logic_vector ? signed pour FC
    ---------------------------------------------------------------------------
    fc_weight_data <= signed(fc_weight_slv);
    fc_bias_data   <= signed(fc_bias_slv);

    ---------------------------------------------------------------------------
    --! @brief Instanciations BRAMs Conv1 (ena='1' permanent)
    ---------------------------------------------------------------------------
    BRAM_C11_W : blk_mem_c11_w port map(
        clka=>clk, ena=>'1', addra=>c1_weight_addr_0, douta=>c1_weight_slv_0);
    BRAM_C12_W : blk_mem_c12_w port map(
        clka=>clk, ena=>'1', addra=>c1_weight_addr_1, douta=>c1_weight_slv_1);
    BRAM_C13_W : blk_mem_c13_w port map(
        clka=>clk, ena=>'1', addra=>c1_weight_addr_2, douta=>c1_weight_slv_2);
    --! BRAM biais Conv1 - lecture permanente à l'adresse 0 (tous les biais en 96b)
    BRAM_C1_B : blk_mem_c1_b port map(
        clka=>clk, ena=>'1', addra=>'0', douta=>c1_bias_slv);
    BRAM_IN : blk_mem_in port map(
        clka=>clk, ena=>'1', addra=>c1_in_addr, douta=>c1_in_slv);

    ---------------------------------------------------------------------------
    --! @brief Instanciations BRAMs Conv2 (ena='1' permanent)
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
    --! BRAM biais Conv2 - lecture permanente à l'adresse 0 (tous les biais en 192b)
    BRAM_C2_B : blk_mem_c2_b port map(
        clka=>clk, ena=>'1', addra=>'0', douta=>c2_bias_slv);

    ---------------------------------------------------------------------------
    --! @brief Instanciations BRAMs FC (ena='1' permanent)
    ---------------------------------------------------------------------------
    BRAM_FC_W : blk_mem_fc_w port map(
        clka=>clk, ena=>'1', addra=>fc_weight_addr, douta=>fc_weight_slv);
    BRAM_FC_B : blk_mem_fc_b port map(
        clka=>clk, ena=>'1', addra=>fc_bias_addr, douta=>fc_bias_slv);

    ---------------------------------------------------------------------------
    --! @brief Instanciation Conv1 - 32×32×1 ? 28×28×3 (INT8, ReLU, Q=C1_*)
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
    --! @brief Instanciation MaxPool1 - 28×28×3 ? 14×14×3 (fenêtre 2×2)
    --! @details Lit buffer1 via pool1_in_addr/pool1_in_data (buf1_rd_data).
    --!          Écrit buffer2 via pool1_out_addr/pool1_out_data/pool1_out_we.
    ---------------------------------------------------------------------------
    POOL1 : maxpool2d
        generic map(IN_WIDTH=>28, IN_HEIGHT=>28, IN_CHANNELS=>3, POOL_SIZE=>2)
        port map(
            clk=>clk, rst=>rst, start=>pool1_start, done=>pool1_done,
            in_addr=>pool1_in_addr, in_data=>pool1_in_data,
            out_addr=>pool1_out_addr, out_data=>pool1_out_data,
            out_we=>pool1_out_we);

    --! Connexion directe buf1_rd_data ? port in_data de MaxPool1
    pool1_in_data <= buf1_rd_data;

    ---------------------------------------------------------------------------
    --! @brief Instanciation Conv2 - 14×14×3 ? 10×10×6 (INT8, ReLU, Q=C2_*)
    --! @details Lit buffer2 via c2_in_addr/c2_in_data (buf2_rd_data).
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

    --! Connexion directe buf2_rd_data ? port in_bram_data de Conv2
    c2_in_data <= buf2_rd_data;

    ---------------------------------------------------------------------------
    --! @brief Instanciation MaxPool2 - 10×10×6 ? 5×5×6 (fenêtre 2×2)
    --! @details Lit buffer3 via pool2_in_addr/pool2_in_data (buf3_rd_data).
    --!          Écrit buffer4 via pool2_out_addr/pool2_out_data/pool2_out_we.
    ---------------------------------------------------------------------------
    POOL2 : maxpool2d
        generic map(IN_WIDTH=>10, IN_HEIGHT=>10, IN_CHANNELS=>6, POOL_SIZE=>2)
        port map(
            clk=>clk, rst=>rst, start=>pool2_start, done=>pool2_done,
            in_addr=>pool2_in_addr, in_data=>pool2_in_data,
            out_addr=>pool2_out_addr, out_data=>pool2_out_data,
            out_we=>pool2_out_we);

    --! Connexion directe buf3_rd_data ? port in_data de MaxPool2
    pool2_in_data <= buf3_rd_data;

    ---------------------------------------------------------------------------
    --! @brief Instanciation FC - 150?10 (INT8, USE_RELU=false, Q=FC_*)
    --! @details Lit buffer4 via fc_in_bram_addr/fc_in_bram_data (buf4_rd_data).
    --!          Les logits sont exposés directement sur les ports externes
    --!          fc_out_data et fc_out_valid.
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

    --! Connexion directe buf4_rd_data ? port in_bram_data de FC
    fc_in_bram_data <= buf4_rd_data;

    ---------------------------------------------------------------------------
    --! @brief Buffer 1 - Conv1 streaming ? MaxPool1 (process RAM unique)
    --!
    --! @details Écriture : 3 canaux écrits simultanément (conv1_out_0/1/2)
    --!          aux positions buf1_wr_count+0/+1/+2, uniquement en RUN_CONV1
    --!          quand conv1_valid='1'. buf1_wr_count avance de +3 par cycle.
    --!
    --!          Lecture : synchrone 1 cycle latence depuis pool1_in_addr.
    --!          Lecture permanente (active même en RUN_CONV1 - MaxPool1 ne
    --!          démarre qu'en RUN_POOL1, donc pas de conflit de données).
    --!
    --! @warning Ne jamais ajouter de second process pilotant buffer1 ou buf1_rd_data
    --!          (même pattern que buf_ram_proc dans top_conv1_pool1).
    ---------------------------------------------------------------------------
    buf1_ram_proc : process(clk)
        variable rd_addr_v : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                buf1_wr_count <= 0;
                buf1_rd_data  <= (others => '0');
            else
                -- PORT ÉCRITURE : Conv1 ? buffer1 (3 canaux/cycle)
                if state = RUN_CONV1 and conv1_valid = '1' then
                    if buf1_wr_count + 2 < BUF1_SIZE then
                        buffer1(buf1_wr_count + 0) <= conv1_out_0;
                        buffer1(buf1_wr_count + 1) <= conv1_out_1;
                        buffer1(buf1_wr_count + 2) <= conv1_out_2;
                        buf1_wr_count <= buf1_wr_count + 3;
                    end if;
                end if;
                -- PORT LECTURE : buffer1 ? MaxPool1 (latence 1 cycle)
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
    --! @brief Buffer 2 - MaxPool1 (out_we) ? Conv2 (process RAM unique)
    --!
    --! @details Écriture : adressée par pool1_out_addr sur pool1_out_we='1'.
    --!          Format HWC : index = (y_out×OUT_W + x_out)×IN_C + ch.
    --!          Pas de compteur séquentiel - MaxPool1 fournit l'adresse.
    --!
    --!          Lecture : synchrone 1 cycle latence depuis c2_in_addr.
    --!          Lecture permanente (Conv2 ne démarre qu'après RUN_POOL1).
    ---------------------------------------------------------------------------
    buf2_ram_proc : process(clk)
        variable wr_addr_v : integer;
        variable rd_addr_v : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                buf2_rd_data <= (others => '0');
            else
                -- PORT ÉCRITURE : MaxPool1 ? buffer2 (adresse aléatoire)
                if pool1_out_we = '1' then
                    wr_addr_v := to_integer(unsigned(pool1_out_addr));
                    if wr_addr_v >= 0 and wr_addr_v < BUF2_SIZE then
                        buffer2(wr_addr_v) <= pool1_out_data;
                    end if;
                end if;
                -- PORT LECTURE : buffer2 ? Conv2 (latence 1 cycle)
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
    --! @brief Buffer 3 - Conv2 streaming ? MaxPool2 (process RAM unique)
    --!
    --! @details Identique à buffer1 mais pour Conv2 : 6 canaux écrits
    --!          simultanément (conv2_out_0..5) aux positions buf3_wr_count+0..+5.
    --!          buf3_wr_count avance de +6 par pixel Conv2 valide.
    ---------------------------------------------------------------------------
    buf3_ram_proc : process(clk)
        variable rd_addr_v : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                buf3_wr_count <= 0;
                buf3_rd_data  <= (others => '0');
            else
                -- PORT ÉCRITURE : Conv2 ? buffer3 (6 canaux/cycle)
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
                -- PORT LECTURE : buffer3 ? MaxPool2 (latence 1 cycle)
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
    --! @brief Buffer 4 - MaxPool2 (out_we) ? FC (process RAM unique)
    --!
    --! @details Identique à buffer2 mais pour MaxPool2 ? FC.
    --!          pool2_out_addr est sur 12 bits (format maxpool2d générique)
    --!          mais les valeurs effectives sont dans [0..149] (BUF4_SIZE=150).
    --!          fc_in_bram_addr est sur 8 bits (0..149).
    ---------------------------------------------------------------------------
    buf4_ram_proc : process(clk)
        variable wr_addr_v : integer;
        variable rd_addr_v : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                buf4_rd_data <= (others => '0');
            else
                -- PORT ÉCRITURE : MaxPool2 ? buffer4 (adresse aléatoire)
                if pool2_out_we = '1' then
                    wr_addr_v := to_integer(unsigned(pool2_out_addr));
                    if wr_addr_v >= 0 and wr_addr_v < BUF4_SIZE then
                        buffer4(wr_addr_v) <= pool2_out_data;
                    end if;
                end if;
                -- PORT LECTURE : buffer4 ? FC (latence 1 cycle)
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
    --! @brief FSM top-level - séquencement des 5 étages de traitement
    --!
    --! @details Tous les signaux de démarrage (conv1_start .. fc_start) sont
    --!          remis à '0' par défaut en début de cycle (impulsions 1 cycle).
    --!          La FSM surveille uniquement les signaux done de chaque étage
    --!          pour déclencher le suivant - les buffers sont alimentés
    --!          automatiquement par leurs process RAM respectifs.
    --!
    --! @note    Les compteurs buf1_wr_count et buf3_wr_count ne sont PAS remis
    --!          à zéro par la FSM : ils sont remis à zéro uniquement sur rst='1'
    --!          dans leurs process respectifs. Pour une inférence multiple sans
    --!          reset matériel, un signal de remise à zéro explicite devrait
    --!          être ajouté à la FSM (amélioration future).
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
                -- Remise à zéro par défaut (impulsions 1 cycle)
                conv1_start <= '0';
                pool1_start <= '0';
                conv2_start <= '0';
                pool2_start <= '0';
                fc_start    <= '0';

                case state is

                    --! @brief IDLE : attente du démarrage depuis le PS ARM
                    when IDLE =>
                        done <= '0';
                        if start = '1' then
                            conv1_start <= '1';  --! Impulsion démarrage Conv1
                            state       <= RUN_CONV1;
                        end if;

                    --! @brief RUN_CONV1 : Conv1 en cours, buffer1 alimenté automatiquement
                    when RUN_CONV1 =>
                        if conv1_done = '1' then
                            pool1_start <= '1';  --! Impulsion démarrage MaxPool1
                            state       <= RUN_POOL1;
                        end if;

                    --! @brief RUN_POOL1 : MaxPool1 lit buffer1, écrit buffer2
                    when RUN_POOL1 =>
                        if pool1_done = '1' then
                            conv2_start <= '1';  --! Impulsion démarrage Conv2
                            state       <= RUN_CONV2;
                        end if;

                    --! @brief RUN_CONV2 : Conv2 lit buffer2, buffer3 alimenté automatiquement
                    when RUN_CONV2 =>
                        if conv2_done = '1' then
                            pool2_start <= '1';  --! Impulsion démarrage MaxPool2
                            state       <= RUN_POOL2;
                        end if;

                    --! @brief RUN_POOL2 : MaxPool2 lit buffer3, écrit buffer4
                    when RUN_POOL2 =>
                        if pool2_done = '1' then
                            fc_start <= '1';  --! Impulsion démarrage FC
                            state    <= RUN_FC;
                        end if;

                    --! @brief RUN_FC : FC lit buffer4, calcule les 10 logits
                    when RUN_FC =>
                        if fc_done = '1' then
                            state <= DONE_STATE;
                        end if;

                    --! @brief DONE_STATE : done levé, attente relâchement de start
                    --! fc_out_data et fc_out_valid déjà propagés par le module FC
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