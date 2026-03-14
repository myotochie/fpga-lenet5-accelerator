----------------------------------------------------------------------------------
--! @file    tb_conv2d_int8_streaming_c2.vhd
--! @brief   Testbench de validation - conv2d_int8_streaming_c2 (Conv2, multi-canal)
--!
--! @details Ce testbench valide le comportement fonctionnel du module
--!          conv2d_int8_streaming_c2 (couche Conv2 du pipeline LeNet-5 modifié).
--!          Il lit les activations de sortie de MaxPool1 depuis un fichier texte
--!          (output_pool1_14x14x3.txt), les présente au DUT via une ROM synchrone
--!          simulant le buffer2, capture les 100 pixels de sortie (10×10×6 = 600
--!          octets en interleaved HWC) et les sauvegarde dans
--!          output_conv2_streaming.txt pour comparaison avec le modèle Python.
--!
--! @section configuration Configuration du DUT
--!   - Entrée  : 14×14×3 = 588 octets (sortie MaxPool1, format HWC interleaved)
--!   - Sortie  : 10×10×6 = 600 octets (6 filtres 5×5, ReLU, INT8)
--!   - Paramètres quantification : C2_MULT, C2_SHIFT, C2_ZERO_POINT
--!     (définis dans lenet_qparams_pkg.vhd)
--!
--! @section bramsext BRAMs externes instanciées
--!   - blk_mem_c21_w .. blk_mem_c26_w : poids des 6 filtres (75×8b, addr 7 bits)
--!   - blk_mem_c2_b                   : biais des 6 filtres (192b = 6×32b)
--!
--! @section rom ROM d'entrée (simulation buffer2)
--!   La mémoire d'entrée est simulée par une ROM VHDL pure (POOL1_ROM) chargée
--!   à l'élaboration depuis output_pool1_14x14x3.txt via la fonction impure
--!   init_rom(). Une ROM synchrone (process rom_proc, latence 1 cycle) émule
--!   le comportement d'une BRAM Xilinx.
--!
--! @section flux Flux de validation
--!   @code
--!   Lecture output_pool1_14x14x3.txt ? POOL1_ROM (élaboration)
--!        ?
--!        ?
--!   Reset (10 cycles) ? start (1 cycle) ? Attente done
--!        ?
--!        ?
--!   Rapport performances ? Aperçu 3 premiers pixels
--!        ?
--!        ?
--!   Sauvegarde output_conv2_streaming.txt
--!   @endcode
--!
--! @section chaine Chaîne de validation complète
--!   Ce testbench est le maillon 2 de la chaîne de validation :
--!   @code
--!   tb_conv2d_int8  ? output_conv1_streaming.txt
--!   tb_top_conv1_pool1 ? output_pool1_14x14x3.txt  ? entrée de ce TB
--!   tb_conv2d_int8_c2  ? output_conv2_streaming.txt ? sortie de ce TB
--!   @endcode
--!
--! @author  Donald MYO
--! @date    2025
--! @version 1.0 - ROM Pool1, capture 6 canaux interleaved, sauvegarde fichier
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

--! @brief Entité testbench - aucun port (entité de simulation pure)
entity tb_conv2d_int8_c2 is
end tb_conv2d_int8_c2;

architecture Behavioral of tb_conv2d_int8_c2 is

    ---------------------------------------------------------------------------
    --! @name Constantes de configuration
    --! @{
    ---------------------------------------------------------------------------
    constant IN_WIDTH     : integer := 14;  --! Largeur carte d'entrée (pixels)
    constant IN_HEIGHT    : integer := 14;  --! Hauteur carte d'entrée (pixels)
    constant IN_CHANNELS  : integer := 3;   --! Canaux d'entrée (sortie MaxPool1)
    constant OUT_CHANNELS : integer := 6;   --! Canaux de sortie (filtres Conv2)
    constant KERNEL_SIZE  : integer := 5;   --! Taille noyau de convolution
    constant OUT_WIDTH    : integer := 10;  --! Largeur carte de sortie = 14-5+1
    constant OUT_HEIGHT   : integer := 10;  --! Hauteur carte de sortie = 14-5+1

    constant IN_SIZE : integer := IN_WIDTH * IN_HEIGHT * IN_CHANNELS;
    --! Taille buffer d'entrée = 14×14×3 = 588 octets (format HWC interleaved)

    constant OUT_TOTAL : integer := OUT_WIDTH * OUT_HEIGHT * OUT_CHANNELS;
    --! Taille buffer de sortie = 10×10×6 = 600 octets (format HWC interleaved)

    constant CLK_PERIOD : time := 10 ns;
    --! Période d'horloge simulée = 10 ns ? fréquence 100 MHz
    --! @}

    ---------------------------------------------------------------------------
    --! @name ROM d'entrée - simulation du buffer2 (sortie MaxPool1)
    --! @{
    ---------------------------------------------------------------------------

    --! @brief Type tableau ROM : IN_SIZE=588 entrées int8
    type rom_type is array (0 to IN_SIZE-1) of int8;

    ---------------------------------------------------------------------------
    --! @brief Procédure de lecture d'un entier signé depuis une ligne textio
    --!
    --! @details Gère les espaces, tabulations, signe négatif et chiffres
    --!          successifs. Utilisée par init_rom pour parser les lignes du
    --!          fichier output_pool1_14x14x3.txt (1 entier signé par ligne).
    --!
    --! @param l      Ligne textio en entrée/sortie (consommée au fur et à mesure)
    --! @param result Entier signé résultant
    ---------------------------------------------------------------------------
    procedure read_signed_int(l      : inout line;
                               result : out   integer) is
        variable c      : character;
        variable is_neg : boolean := false;
        variable val    : integer := 0;
        variable good   : boolean;
    begin
        -- Saut des espaces/tabulations initiaux
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
        -- Lecture des chiffres restants
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
    --! @brief Fonction impure de chargement de la ROM depuis fichier texte
    --!
    --! @details Appelée une seule fois à l'élaboration (impure : accès fichier).
    --!          Lit IN_SIZE=588 lignes de output_pool1_14x14x3.txt, convertit
    --!          chaque valeur en int8 avec saturation [-128, 127].
    --!
    --! @param filename Chemin du fichier texte (relatif au répertoire XSim)
    --! @return ROM initialisée avec les activations de sortie MaxPool1
    --!
    --! @note    Le fichier doit être généré au préalable par tb_top_conv1_pool1.
    --!          Si le fichier est absent, XSim lève une erreur à l'élaboration.
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
                if val >  127 then val :=  127; end if;
                if val < -128 then val := -128; end if;
                mem(i) := to_signed(val, 8);
            end if;
        end loop;
        file_close(f);
        return mem;
    end function;

    --! @brief ROM constante chargée à l'élaboration depuis output_pool1_14x14x3.txt
    --! @details Immutable après élaboration - accès en lecture seule pendant la sim.
    constant POOL1_ROM : rom_type := init_rom("output_pool1_14x14x3.txt");
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de contrôle du DUT
    --! @{
    ---------------------------------------------------------------------------
    signal clk   : std_logic := '0';  --! Horloge simulée (100 MHz)
    signal rst   : std_logic := '0';  --! Reset synchrone actif haut
    signal start : std_logic := '0';  --! Impulsion de démarrage (1 cycle)
    signal done  : std_logic;         --! Fin du DUT (pipeline vidé, 100 pixels émis)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux interface poids Conv2 - 6 BRAMs (addr 7 bits, depth=128)
    --! @{
    ---------------------------------------------------------------------------
    signal weight_addr_0 : std_logic_vector(6 downto 0);   --! Adresse BRAM filtre 0
    signal weight_addr_1 : std_logic_vector(6 downto 0);
    signal weight_addr_2 : std_logic_vector(6 downto 0);
    signal weight_addr_3 : std_logic_vector(6 downto 0);
    signal weight_addr_4 : std_logic_vector(6 downto 0);
    signal weight_addr_5 : std_logic_vector(6 downto 0);

    signal weight_data_0_slv : std_logic_vector(7 downto 0);  --! Poids filtre 0 (SLV brut)
    signal weight_data_1_slv : std_logic_vector(7 downto 0);
    signal weight_data_2_slv : std_logic_vector(7 downto 0);
    signal weight_data_3_slv : std_logic_vector(7 downto 0);
    signal weight_data_4_slv : std_logic_vector(7 downto 0);
    signal weight_data_5_slv : std_logic_vector(7 downto 0);

    signal weight_data_0 : int8;  --! Poids filtre 0 (INT8 signé)
    signal weight_data_1 : int8;
    signal weight_data_2 : int8;
    signal weight_data_3 : int8;
    signal weight_data_4 : int8;
    signal weight_data_5 : int8;
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux interface biais Conv2 - BRAM 192 bits (6×32b)
    --! @{
    ---------------------------------------------------------------------------
    signal bias_slv    : std_logic_vector(191 downto 0);
    --! Biais concaténés 192 bits : bits[31:0]=b0, [63:32]=b1, ..., [191:160]=b5

    signal bias_data_0 : int32;  --! Biais filtre 0 (INT32 signé)
    signal bias_data_1 : int32;
    signal bias_data_2 : int32;
    signal bias_data_3 : int32;
    signal bias_data_4 : int32;
    signal bias_data_5 : int32;
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux interface mémoire d'entrée (ROM Pool1)
    --! @{
    ---------------------------------------------------------------------------
    signal in_bram_addr : std_logic_vector(9 downto 0);
    --! Adresse lecture ROM Pool1 (0..587, produite par le DUT)

    signal in_bram_data : int8;
    --! Donnée lue depuis POOL1_ROM avec 1 cycle de latence (process rom_proc)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de sortie streaming DUT - 6 canaux par cycle valide
    --! @{
    ---------------------------------------------------------------------------
    signal out_data_0 : int8;      --! Canal 0 (après ReLU)
    signal out_data_1 : int8;
    signal out_data_2 : int8;
    signal out_data_3 : int8;
    signal out_data_4 : int8;
    signal out_data_5 : int8;
    signal out_valid  : std_logic; --! Validité des sorties (1 cycle par pixel)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Buffer de capture sortie Conv2
    --! @{
    ---------------------------------------------------------------------------

    --! @brief Mémoire de capture des OUT_TOTAL=600 sorties (format HWC interleaved)
    --! @details Stocke les valeurs dans l'ordre ch0..ch5 pour chaque pixel :
    --!          output_memory(pix×6+ch) = canal ch du pixel pix
    type out_mem_type is array (0 to OUT_TOTAL-1) of int8;
    signal output_memory : out_mem_type := (others => (others => '0'));

    signal output_pixel_idx : integer := 0;
    --! Index courant d'écriture dans output_memory (avance de +OUT_CHANNELS=6 par pixel)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de supervision et métrologie
    --! @{
    ---------------------------------------------------------------------------
    signal sim_done : boolean := false;
    --! Drapeau de fin de simulation - arrête clk_process proprement

    signal cycle_counter : integer := 0;
    --! Compteur de cycles depuis la fin du reset

    signal latency_cycles : integer := 0;
    --! Latence totale Conv2 en cycles, visible dans Vivado waveform (gelé à done)

    signal measuring : std_logic := '0';
    --! Drapeau interne : '1' pendant la mesure (entre start et done)
    --! @}

    ---------------------------------------------------------------------------
    -- Déclarations des composants
    ---------------------------------------------------------------------------

    --! @brief DUT - conv2d_int8_streaming_c2 (Conv2 multi-canal)
    component conv2d_int8_streaming_c2
        generic (
            IN_WIDTH     : integer;
            IN_HEIGHT    : integer;
            IN_CHANNELS  : integer;
            OUT_CHANNELS : integer;
            KERNEL_SIZE  : integer;
            Q_MULT       : int32;
            Q_SHIFT      : integer;
            Q_ZERO_POINT : int8;
            USE_RELU     : boolean
        );
        port (
            clk           : in  std_logic;
            rst           : in  std_logic;
            start         : in  std_logic;
            done          : out std_logic;
            weight_addr_0 : out std_logic_vector(6 downto 0);
            weight_data_0 : in  int8;
            weight_addr_1 : out std_logic_vector(6 downto 0);
            weight_data_1 : in  int8;
            weight_addr_2 : out std_logic_vector(6 downto 0);
            weight_data_2 : in  int8;
            weight_addr_3 : out std_logic_vector(6 downto 0);
            weight_data_3 : in  int8;
            weight_addr_4 : out std_logic_vector(6 downto 0);
            weight_data_4 : in  int8;
            weight_addr_5 : out std_logic_vector(6 downto 0);
            weight_data_5 : in  int8;
            bias_data_0   : in  int32;
            bias_data_1   : in  int32;
            bias_data_2   : in  int32;
            bias_data_3   : in  int32;
            bias_data_4   : in  int32;
            bias_data_5   : in  int32;
            in_bram_addr  : out std_logic_vector(9 downto 0);
            in_bram_data  : in  int8;
            out_data_0    : out int8;
            out_data_1    : out int8;
            out_data_2    : out int8;
            out_data_3    : out int8;
            out_data_4    : out int8;
            out_data_5    : out int8;
            out_valid     : out std_logic
        );
    end component;

    --! @brief BRAM poids filtre 0 - 75 coefficients INT8 (blk_mem_c21_w.coe, addr 7b)
    component blk_mem_c21_w
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(6 downto 0);
              douta:out std_logic_vector(7 downto 0));
    end component;

    --! @brief BRAM poids filtre 1 (blk_mem_c22_w.coe)
    component blk_mem_c22_w
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(6 downto 0);
              douta:out std_logic_vector(7 downto 0));
    end component;

    --! @brief BRAM poids filtre 2 (blk_mem_c23_w.coe)
    component blk_mem_c23_w
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(6 downto 0);
              douta:out std_logic_vector(7 downto 0));
    end component;

    --! @brief BRAM poids filtre 3 (blk_mem_c24_w.coe)
    component blk_mem_c24_w
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(6 downto 0);
              douta:out std_logic_vector(7 downto 0));
    end component;

    --! @brief BRAM poids filtre 4 (blk_mem_c25_w.coe)
    component blk_mem_c25_w
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(6 downto 0);
              douta:out std_logic_vector(7 downto 0));
    end component;

    --! @brief BRAM poids filtre 5 (blk_mem_c26_w.coe)
    component blk_mem_c26_w
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic_vector(6 downto 0);
              douta:out std_logic_vector(7 downto 0));
    end component;

    --! @brief BRAM biais Conv2 - 6 biais int32 concaténés sur 192 bits
    --! @details Lecture unique à l'adresse 0 (addra='0').
    --!          Décomposition : bits[31:0]=b0, [63:32]=b1, ..., [191:160]=b5
    component blk_mem_c2_b
        port (clka:in std_logic; ena:in std_logic;
              addra:in std_logic;
              douta:out std_logic_vector(191 downto 0));
    end component;

begin

    ---------------------------------------------------------------------------
    --! @brief Conversions std_logic_vector ? signed (int8 / int32)
    --!
    --! @details Les 6 BRAMs de poids exposent leurs données en SLV 8 bits.
    --!          La BRAM biais expose ses données en SLV 192 bits découpé en
    --!          6 tranches de 32 bits pour alimenter les ports bias_data_x.
    ---------------------------------------------------------------------------
    weight_data_0 <= signed(weight_data_0_slv);
    weight_data_1 <= signed(weight_data_1_slv);
    weight_data_2 <= signed(weight_data_2_slv);
    weight_data_3 <= signed(weight_data_3_slv);
    weight_data_4 <= signed(weight_data_4_slv);
    weight_data_5 <= signed(weight_data_5_slv);

    bias_data_0 <= signed(bias_slv( 31 downto   0));
    bias_data_1 <= signed(bias_slv( 63 downto  32));
    bias_data_2 <= signed(bias_slv( 95 downto  64));
    bias_data_3 <= signed(bias_slv(127 downto  96));
    bias_data_4 <= signed(bias_slv(159 downto 128));
    bias_data_5 <= signed(bias_slv(191 downto 160));

    ---------------------------------------------------------------------------
    --! @brief Instanciation du DUT - conv2d_int8_streaming_c2 (Conv2, USE_RELU=true)
    --!
    --! @details Paramètres de quantification issus de lenet_qparams_pkg :
    --!   C2_MULT=2 078 762, C2_SHIFT=30, C2_ZERO_POINT=0
    ---------------------------------------------------------------------------
    DUT : conv2d_int8_streaming_c2
        generic map (
            IN_WIDTH     => IN_WIDTH,
            IN_HEIGHT    => IN_HEIGHT,
            IN_CHANNELS  => IN_CHANNELS,
            OUT_CHANNELS => OUT_CHANNELS,
            KERNEL_SIZE  => KERNEL_SIZE,
            Q_MULT       => C2_MULT,
            Q_SHIFT      => C2_SHIFT,
            Q_ZERO_POINT => C2_ZERO_POINT,
            USE_RELU     => true
        )
        port map (
            clk           => clk,
            rst           => rst,
            start         => start,
            done          => done,
            weight_addr_0 => weight_addr_0,
            weight_data_0 => weight_data_0,
            weight_addr_1 => weight_addr_1,
            weight_data_1 => weight_data_1,
            weight_addr_2 => weight_addr_2,
            weight_data_2 => weight_data_2,
            weight_addr_3 => weight_addr_3,
            weight_data_3 => weight_data_3,
            weight_addr_4 => weight_addr_4,
            weight_data_4 => weight_data_4,
            weight_addr_5 => weight_addr_5,
            weight_data_5 => weight_data_5,
            bias_data_0   => bias_data_0,
            bias_data_1   => bias_data_1,
            bias_data_2   => bias_data_2,
            bias_data_3   => bias_data_3,
            bias_data_4   => bias_data_4,
            bias_data_5   => bias_data_5,
            in_bram_addr  => in_bram_addr,
            in_bram_data  => in_bram_data,
            out_data_0    => out_data_0,
            out_data_1    => out_data_1,
            out_data_2    => out_data_2,
            out_data_3    => out_data_3,
            out_data_4    => out_data_4,
            out_data_5    => out_data_5,
            out_valid     => out_valid
        );

    ---------------------------------------------------------------------------
    --! @brief Instanciation BRAMs poids Conv2 (ena='1' permanent, addr 7 bits)
    ---------------------------------------------------------------------------
    BRAM_W0 : blk_mem_c21_w port map(
        clka=>clk, ena=>'1', addra=>weight_addr_0, douta=>weight_data_0_slv);
    BRAM_W1 : blk_mem_c22_w port map(
        clka=>clk, ena=>'1', addra=>weight_addr_1, douta=>weight_data_1_slv);
    BRAM_W2 : blk_mem_c23_w port map(
        clka=>clk, ena=>'1', addra=>weight_addr_2, douta=>weight_data_2_slv);
    BRAM_W3 : blk_mem_c24_w port map(
        clka=>clk, ena=>'1', addra=>weight_addr_3, douta=>weight_data_3_slv);
    BRAM_W4 : blk_mem_c25_w port map(
        clka=>clk, ena=>'1', addra=>weight_addr_4, douta=>weight_data_4_slv);
    BRAM_W5 : blk_mem_c26_w port map(
        clka=>clk, ena=>'1', addra=>weight_addr_5, douta=>weight_data_5_slv);

    --! @brief BRAM biais - lecture permanente à l'adresse 0 (tous les biais en 192b)
    BRAM_BIAS : blk_mem_c2_b port map(
        clka=>clk, ena=>'1', addra=>'0', douta=>bias_slv);

    ---------------------------------------------------------------------------
    --! @brief ROM Pool1 synchrone - simulation du buffer2 avec latence 1 cycle
    --!
    --! @details Émule le comportement d'une BRAM Xilinx en mode lecture synchrone :
    --!          l'adresse est posée à un cycle T, la donnée est disponible à T+1.
    --!          Ce protocole est compatible avec le module conv2d_int8_streaming_c2
    --!          qui attend in_bram_data 1 cycle après avoir posé in_bram_addr.
    --!
    --! @note    Les accès hors-range (addr ? IN_SIZE=588) retournent 0 pour
    --!          éviter des valeurs indéterminées pendant LOAD_WEIGHTS
    --!          (le DUT incrémente input_addr en parallèle du chargement des poids).
    ---------------------------------------------------------------------------
    rom_proc : process(clk)
        variable addr_v : integer;
    begin
        if rising_edge(clk) then
            addr_v := to_integer(unsigned(in_bram_addr));
            if addr_v >= 0 and addr_v < IN_SIZE then
                in_bram_data <= POOL1_ROM(addr_v);
            else
                in_bram_data <= (others => '0');
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Capture streaming - stockage interleaved HWC dans output_memory
    --!
    --! @details À chaque cycle où out_valid='1', les OUT_CHANNELS=6 canaux sont
    --!          écrits aux positions output_pixel_idx+0 .. +5.
    --!          output_pixel_idx avance de +6 par pixel produit.
    --!
    --!          Format final du buffer (HWC interleaved) :
    --!          @code
    --!            [pix0_ch0..ch5, pix1_ch0..ch5, ..., pix99_ch0..ch5]
    --!          @endcode
    --!          Comparable avec numpy array de shape (10,10,6) aplati en C-order.
    ---------------------------------------------------------------------------
    output_capture : process(clk)
    begin
        if rising_edge(clk) then
            if out_valid = '1' then
                if output_pixel_idx + OUT_CHANNELS - 1 < OUT_TOTAL then
                    output_memory(output_pixel_idx + 0) <= out_data_0;
                    output_memory(output_pixel_idx + 1) <= out_data_1;
                    output_memory(output_pixel_idx + 2) <= out_data_2;
                    output_memory(output_pixel_idx + 3) <= out_data_3;
                    output_memory(output_pixel_idx + 4) <= out_data_4;
                    output_memory(output_pixel_idx + 5) <= out_data_5;
                    output_pixel_idx <= output_pixel_idx + OUT_CHANNELS;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Génération de l'horloge simulée à 100 MHz
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
    --! @brief Compteur de cycles depuis la fin du reset
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
    --! @brief Mesure de latence synchrone - visible dans Vivado waveform
    --!
    --! @details Identique à tb_top_conv1_pool1 : latency_cycles gelé à done='1',
    --!          directement lisible dans le chronogramme Vivado.
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
    --! @brief Process stimulus - séquence de test complète
    --!
    --! @details Séquence :
    --!   1. Vérification ROM (affichage POOL1_ROM[0..5] dans console)
    --!   2. Reset 10 cycles
    --!   3. Stabilisation 5 cycles
    --!   4. Capture v_start_cycle (variable locale, pas de delta-delay)
    --!   5. Impulsion start (1 cycle)
    --!   6. Attente done avec timeout 50 000 cycles
    --!   7. Rapport final (latence cycles + ns, pixels capturés)
    --!   8. Aperçu des 3 premiers pixels de sortie Conv2 (6 canaux chacun)
    --!   9. Sauvegarde output_conv2_streaming.txt (1 valeur entière par ligne)
    --!  10. sim_done=true ? arrêt propre
    --!
    --! @note    La vérification ROM en étape 1 permet de confirmer que
    --!          output_pool1_14x14x3.txt a été correctement lu à l'élaboration,
    --!          avant même le démarrage de la simulation.
    --!
    --! @warning Timeout fixé à 50 000 cycles. La latence estimée est ~830 cycles
    --!          (Conv2 : FILL_CYCLES=167 + OUT_H×OUT_W×IN_C=300 + pipeline?11).
    --!          En cas de timeout, vérifier : ROM correctement lue, signal start
    --!          reçu, FSM non bloquée, adresses BRAM poids dans range [0..74].
    ---------------------------------------------------------------------------
    stimulus : process
        variable line_v        : line;
        file f_out             : text;
        variable v_start_cycle : integer := 0;
        --! Cycle de démarrage (variable locale, évite delta-delay)
        variable v_end_cycle   : integer := 0;
        --! Cycle de réception de done
        variable timeout_cnt   : integer := 0;
    begin
        report "=====================================================" severity note;
        report "=== TESTBENCH CONV2 (fenetre multi-canal) ===" severity note;
        report "  Entree  : 14x14x3 = " &
               integer'image(IN_SIZE)   & " valeurs" severity note;
        report "  Sortie  : 10x10x6 = " &
               integer'image(OUT_TOTAL) & " valeurs" severity note;
        report "  TREE_WIDTH=128, TREE_LEVELS=7, KKC=75 produits" severity note;
        report "=====================================================" severity note;

        -- Phase 1 : Vérification ROM (contrôle que le fichier a été lu)
        report "  Verification ROM Pool1[0..5] :" severity note;
        report "  [0]=" & integer'image(to_integer(POOL1_ROM(0))) &
               " [1]=" & integer'image(to_integer(POOL1_ROM(1))) &
               " [2]=" & integer'image(to_integer(POOL1_ROM(2))) &
               " [3]=" & integer'image(to_integer(POOL1_ROM(3))) &
               " [4]=" & integer'image(to_integer(POOL1_ROM(4))) &
               " [5]=" & integer'image(to_integer(POOL1_ROM(5))) severity note;

        -- Phase 2 : Reset
        rst   <= '1';
        start <= '0';
        wait for CLK_PERIOD * 10;
        rst   <= '0';
        wait for CLK_PERIOD * 5;

        -- Phase 3 : Démarrage
        wait until rising_edge(clk);
        v_start_cycle := cycle_counter;
        report "=== DEMARRAGE Conv2 au cycle " &
               integer'image(v_start_cycle) & " ===" severity note;

        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        -- Phase 4 : Attente done avec timeout
        timeout_cnt := 0;
        while done /= '1' and timeout_cnt < 50000 loop
            wait until rising_edge(clk);
            timeout_cnt := timeout_cnt + 1;
        end loop;

        v_end_cycle := cycle_counter;

        -- Phase 5 : Rapport final
        if done = '1' then
            report "=====================================================" severity note;
            report "=== DONE ===" severity note;
            report "  Latence : " &
                   integer'image(v_end_cycle - v_start_cycle) & " cycles  (" &
                   integer'image((v_end_cycle - v_start_cycle)*10) & " ns)"
                   severity note;
            report "  Pixels captures : " &
                   integer'image(output_pixel_idx / OUT_CHANNELS) &
                   " / " & integer'image(OUT_WIDTH * OUT_HEIGHT) severity note;
            report "=====================================================" severity note;
        else
            report "=== TIMEOUT apres " & integer'image(timeout_cnt) &
                   " cycles - verifier FSM DUT et addr BRAM poids [0..74] ==="
                   severity error;
        end if;

        wait for CLK_PERIOD * 5;

        -- Phase 6 : Aperçu des 3 premiers pixels de sortie Conv2
        report "=== APERCU SORTIES Conv2 (3 premiers pixels, 6 canaux) ===" severity note;
        for pix in 0 to 2 loop
            report "  pixel[" & integer'image(pix) & "] = [" &
                   integer'image(to_integer(output_memory(pix*6+0))) & "," &
                   integer'image(to_integer(output_memory(pix*6+1))) & "," &
                   integer'image(to_integer(output_memory(pix*6+2))) & "," &
                   integer'image(to_integer(output_memory(pix*6+3))) & "," &
                   integer'image(to_integer(output_memory(pix*6+4))) & "," &
                   integer'image(to_integer(output_memory(pix*6+5))) & "]"
                   severity note;
        end loop;

        -- Phase 7 : Sauvegarde fichier texte pour comparaison Python
        file_open(f_out, "output_conv2_streaming.txt", write_mode);
        for i in 0 to output_pixel_idx - 1 loop
            write(line_v, to_integer(output_memory(i)));
            writeline(f_out, line_v);
        end loop;
        file_close(f_out);

        report "  " & integer'image(output_pixel_idx) &
               " valeurs sauvegardees dans output_conv2_streaming.txt" severity note;
        report "  (comparer avec numpy conv2d sur activations Pool1 Python)"
               severity note;
        report "=== FIN TEST CONV2 ===" severity note;
        report "=====================================================" severity note;

        -- Phase 8 : arrêt propre
        sim_done <= true;
        wait;
    end process;

end Behavioral;