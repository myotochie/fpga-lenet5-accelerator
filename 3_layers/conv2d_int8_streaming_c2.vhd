----------------------------------------------------------------------------------
--! @file    conv2d_int8_streaming_c2.vhd
--! @brief   Convolution 2D INT8 streaming - Couche C2 de LeNet-5 (multi-canal)
--!
--! @details Ce module implémente la deuxième couche de convolution du pipeline
--!          LeNet-5 modifié : 14×14×3 ? 10×10×6, noyau 5×5, IN_CHANNELS=3.
--!          Il étend conv2d_int8_streaming (Conv1) au cas multi-canal en
--!          adaptant le sliding window (3D : KERNEL_SIZE×IN_WIDTH×IN_CHANNELS),
--!          l'adder tree (7 niveaux pour KKC=75 produits) et le chargement
--!          des poids (6 BRAMs × 75 coefficients = 450 poids total).
--!
--! @section differences Différences vs conv2d_int8_streaming (Conv1)
--!   | Paramètre       | Conv1            | Conv2 (ce module)         |
--!   |-----------------|------------------|---------------------------|
--!   | IN_CHANNELS     | 1                | 3                         |
--!   | OUT_CHANNELS    | 3                | 6                         |
--!   | KKC             | 25 (KK×1)        | 75 (KK×3)                 |
--!   | TREE_LEVELS     | 5                | 7                         |
--!   | TREE_WIDTH      | 32               | 128                       |
--!   | BRAMs poids     | 3 × 5b addr      | 6 × 7b addr               |
--!   | FILL_CYCLES     | 127              | 167                       |
--!   | sliding_window  | 2D (KS×W)        | 3D (KS×W×C)               |
--!
--! @section pipeline Pipeline de traitement (10 stages)
--!   - Stage 0  : Extraction fenêtre glissante 3D (KERNEL_SIZE×KERNEL_SIZE×IN_CHANNELS)
--!   - Stage 1  : Fetch des KKC=75 poids depuis weight_cache
--!   - Stage 2  : Multiplications int8×int8 ? int16 (75 produits par canal)
--!   - Stage 3  : Registre tampon produits (isolation timing)
--!   - Tree 0-7 : Adder tree pipeliné 7 niveaux (réduction 128?1, KKC=75 padded)
--!   - Stage B  : Ajout biais int32
--!   - Stage 5  : Requantification (×Q_MULT, >>Q_SHIFT)
--!   - Stage 6  : Ajout zero-point Q_ZERO_POINT
--!   - Stage 7  : Saturation int8 (clamp [-128, 127])
--!   - Stage 8  : ReLU = max(0,x) - activable via USE_RELU
--!
--! @section correction Correction clé - adresse poids registrée
--!   Dans la version originale, weight_addr était combinatoire :
--!   to_unsigned(weight_load_idx, 7). Durant LOAD_WEIGHTS, weight_load_idx
--!   montait jusqu'à KKC+4=79, envoyant les adresses 75..79 aux 6 BRAMs
--!   (profondeur COE = 75, plage valide 0..74). Cela provoquait :
--!     - WARNING "Address 0x4b..0x4e outside range" × 6 BRAMs dans XSim
--!     - weight_cache(ch, 74) = VALEUR ERRONÉE (BRAM invalide à addr=75)
--!
--!   Corrections appliquées :
--!     1. weight_addr devient registré (process weight_addr_proc) :
--!        addr_v = min(weight_load_idx, KKC-1) ? jamais > 74
--!     2. weight_loading décalé d'1 cycle (latence addr registrée) :
--!        capture aux indices 2..KKC+1, biais à KKC+3, done à KKC+4
--!     3. FSM : transition FILL_WINDOW à weight_load_idx = KKC+4 = 79
--!
--! @section quantif Schéma de requantification (identique à Conv1)
--!   @code
--!     out_int8 = sat8( (acc_int32 × Q_MULT) >> Q_SHIFT + Q_ZERO_POINT )
--!   @endcode
--!   C2_MULT, C2_SHIFT, C2_ZERO_POINT définis dans lenet_qparams_pkg.vhd
--!
--! @author  Donald MYO
--! @date    2025
--! @version 2.0 - Adresse poids registrée, adder tree 7 niveaux, sliding window 3D
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

--! @brief Convolution 2D INT8 multi-canal - entité principale Conv2
--!
--! @details Instanciation minimale pour Conv2 (LeNet-5 modifié) :
--! @code
--!   conv2 : entity work.conv2d_int8_streaming_c2
--!     generic map (
--!       IN_WIDTH=>14, IN_HEIGHT=>14, IN_CHANNELS=>3,
--!       OUT_CHANNELS=>6, KERNEL_SIZE=>5,
--!       Q_MULT=>C2_MULT, Q_SHIFT=>C2_SHIFT,
--!       Q_ZERO_POINT=>C2_ZERO_POINT, USE_RELU=>true
--!     )
--!     port map ( clk=>clk, rst=>rst, start=>start, ... );
--! @endcode
entity conv2d_int8_streaming_c2 is
    generic (
        IN_WIDTH     : integer := 14;  --! Largeur carte d'entrée (pixels)
        IN_HEIGHT    : integer := 14;  --! Hauteur carte d'entrée (pixels)
        IN_CHANNELS  : integer := 3;   --! Nombre de canaux d'entrée
        OUT_CHANNELS : integer := 6;   --! Nombre de filtres / canaux de sortie
        KERNEL_SIZE  : integer := 5;   --! Taille du noyau (carré KERNEL_SIZE×KERNEL_SIZE)

        Q_MULT       : int32   := C2_MULT;        --! Multiplicateur requantification Q30
        Q_SHIFT      : integer := C2_SHIFT;       --! Décalage arithmétique requantification
        Q_ZERO_POINT : int8    := C2_ZERO_POINT;  --! Zero-point activation de sortie

        --! @brief Active ou désactive le ReLU intégré en stage 8
        --! @details TRUE=max(0,x) - FALSE=bypass (couches sans activation)
        USE_RELU     : boolean := true
    );
    port (
        --! @name Contrôle
        --! @{
        clk   : in  std_logic;  --! Horloge système (front montant actif)
        rst   : in  std_logic;  --! Reset synchrone actif haut
        start : in  std_logic;  --! Impulsion de démarrage (1 cycle)
        done  : out std_logic;  --! Signal de fin (pipeline vidé, 100 pixels émis)
        --! @}

        --! @name Interface poids - 6 BRAMs indépendantes (addr 7 bits, depth=128)
        --! @details Les 6 BRAMs sont adressées en parallèle à la même adresse,
        --!          permettant le chargement simultané des 6 canaux de sortie.
        --!          Adresse registrée (process weight_addr_proc) : jamais > KKC-1=74.
        --! @{
        weight_addr_0 : out std_logic_vector(6 downto 0);  --! Adresse BRAM filtre 0 (0..74)
        weight_data_0 : in  int8;                          --! Poids filtre 0
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
        --! @}

        --! @name Interface biais - 6 biais int32 (compensés pour entrée INT8)
        --! @{
        bias_data_0 : in int32;  --! Biais filtre 0
        bias_data_1 : in int32;
        bias_data_2 : in int32;
        bias_data_3 : in int32;
        bias_data_4 : in int32;
        bias_data_5 : in int32;
        --! @}

        --! @name Interface mémoire d'entrée (buffer2, 14×14×3 = 588 octets HWC)
        --! @{
        in_bram_addr : out std_logic_vector(9 downto 0);  --! Adresse pixel d'entrée
        in_bram_data : in  int8;                          --! Pixel INT8 signé
        --! @}

        --! @name Sortie streaming - 6 canaux par cycle valide
        --! @{
        out_data_0 : out int8;      --! Canal 0 (après ReLU si USE_RELU)
        out_data_1 : out int8;
        out_data_2 : out int8;
        out_data_3 : out int8;
        out_data_4 : out int8;
        out_data_5 : out int8;
        out_valid  : out std_logic  --! Validité des sorties (1 cycle par pixel)
        --! @}
    );
end conv2d_int8_streaming_c2;

architecture Behavioral of conv2d_int8_streaming_c2 is

    ---------------------------------------------------------------------------
    --! @name Constantes dérivées des génériques
    --! @{
    ---------------------------------------------------------------------------
    constant OUT_WIDTH   : integer := IN_WIDTH  - KERNEL_SIZE + 1;
    --! Largeur carte de sortie = 14 - 5 + 1 = 10

    constant OUT_HEIGHT  : integer := IN_HEIGHT - KERNEL_SIZE + 1;
    --! Hauteur carte de sortie = 14 - 5 + 1 = 10

    constant KK  : integer := KERNEL_SIZE * KERNEL_SIZE;
    --! Coefficients par filtre par canal = 5×5 = 25

    constant KKC : integer := KK * IN_CHANNELS;
    --! Coefficients totaux par filtre = KK × IN_CHANNELS = 25×3 = 75
    --! C'est aussi la profondeur utile des BRAMs poids (indices 0..74)

    constant TREE_LEVELS : integer := 7;
    --! Niveaux de l'adder tree = ceil(log2(KKC)) = ceil(log2(75)) = 7

    constant TREE_WIDTH  : integer := 128;
    --! Largeur interne de l'arbre = puissance de 2 ? KKC (128 > 75)
    --! Les positions KKC..127 sont paddées à zéro au niveau 0

    constant FILL_CYCLES : integer := (KERNEL_SIZE-1) * IN_WIDTH * IN_CHANNELS - 1;
    --! Cycles pour remplir le line buffer 3D avant la première sortie valide
    --! = (5-1) × 14 × 3 - 1 = 167 cycles
    --! @}

    ---------------------------------------------------------------------------
    --! @name Types internes
    --! @{
    ---------------------------------------------------------------------------

    --! Buffer ligne 3D : KERNEL_SIZE lignes × IN_WIDTH colonnes × IN_CHANNELS canaux
    type sliding_window_type is
        array (0 to KERNEL_SIZE-1, 0 to IN_WIDTH-1, 0 to IN_CHANNELS-1) of int8;

    --! Cache des poids : OUT_CHANNELS filtres × KKC coefficients (75 par filtre)
    type weight_cache_type is
        array (0 to OUT_CHANNELS-1, 0 to KKC-1) of int8;

    --! Vecteur de biais int32 : un par canal de sortie
    type bias_array_t is array (0 to OUT_CHANNELS-1) of int32;

    --! Fenêtre de convolution extraite : KERNEL_SIZE × KERNEL_SIZE × IN_CHANNELS
    type conv_window_type is
        array (0 to KERNEL_SIZE-1, 0 to KERNEL_SIZE-1, 0 to IN_CHANNELS-1) of int8;

    --! Tableau de poids pour un pixel : OUT_CHANNELS × KKC
    type weights_kk_type is array (0 to OUT_CHANNELS-1, 0 to KKC-1) of int8;

    --! Produits partiels int16 : OUT_CHANNELS × KKC
    type products_type is array (0 to OUT_CHANNELS-1, 0 to KKC-1) of int16;

    --! Accumulateurs int32 : un par canal de sortie
    type acc_array is array (0 to OUT_CHANNELS-1) of int32;

    --! Sorties saturées int8 : un octet par canal
    type output_array is array (0 to OUT_CHANNELS-1) of int8;

    --! Nœud de l'adder tree : vecteur de TREE_WIDTH accumulateurs int32
    type tree_node_type  is array (0 to TREE_WIDTH-1)   of int32;

    --! Niveau de l'arbre : un tree_node_type par canal de sortie
    type tree_ch_type    is array (0 to OUT_CHANNELS-1) of tree_node_type;

    --! Arbre complet : (TREE_LEVELS+1) niveaux × OUT_CHANNELS × TREE_WIDTH
    type tree_array_type is array (0 to TREE_LEVELS)    of tree_ch_type;

    --! Buffer pixel multi-canal : accumule les IN_CHANNELS octets lus séquentiellement
    --! avant insertion dans sliding_window (un octet par cycle car BRAM 8b)
    type pixel_buf_type is array (0 to IN_CHANNELS-1) of int8;
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux sliding window multi-canal
    --! @{
    ---------------------------------------------------------------------------
    signal sliding_window : sliding_window_type :=
        (others => (others => (others => (others => '0'))));
    --! Line buffer 3D : KERNEL_SIZE × IN_WIDTH × IN_CHANNELS registres int8

    signal col_index : integer range 0 to IN_WIDTH-1  := 0;
    --! Position horizontale courante dans l'image d'entrée (0..IN_WIDTH-1)

    signal row_index : integer range 0 to IN_HEIGHT-1 := 0;
    --! Position verticale courante dans l'image d'entrée (0..IN_HEIGHT-1)

    signal pixel_buf : pixel_buf_type := (others => (others => '0'));
    --! Buffer temporaire accumulant les IN_CHANNELS=3 octets d'un pixel
    --! avant décalage dans sliding_window (lecture séquentielle BRAM 8b)

    signal ch_read_idx : integer range 0 to IN_CHANNELS-1 := 0;
    --! Index du canal en cours de lecture (0, 1, 2 ? cycle par cycle)

    signal pixel_complete : std_logic := '0';
    --! Levé pendant 1 cycle quand ch_read_idx = IN_CHANNELS-1 :
    --! signale qu'un pixel complet (tous canaux) est prêt pour le sliding window
    --! @}

    ---------------------------------------------------------------------------
    --! @name Registres poids et biais
    --! @{
    ---------------------------------------------------------------------------
    signal weight_cache : weight_cache_type :=
        (others => (others => (others => '0')));
    --! Cache local des KKC=75 poids de chacun des OUT_CHANNELS=6 filtres

    signal bias_regs : bias_array_t := (others => (others => '0'));
    --! Registres de biais capturés à weight_load_idx = KKC+3 = 78
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux pipeline inter-stages
    --! @{
    ---------------------------------------------------------------------------
    signal stage0_valid  : std_logic := '0';
    signal stage0_window : conv_window_type;

    signal stage1_valid   : std_logic := '0';
    signal stage1_weights : weights_kk_type;
    signal stage1_window  : conv_window_type;

    signal stage2_valid    : std_logic := '0';
    signal stage2_products : products_type;

    signal stage3_valid    : std_logic := '0';
    signal stage3_products : products_type;

    signal tree_valid : std_logic_vector(0 to TREE_LEVELS) := (others => '0');
    signal tree_reg   : tree_array_type;

    signal stageB_valid : std_logic := '0';
    signal stageB_acc   : acc_array;

    signal stage5_valid   : std_logic := '0';
    signal stage5_requant : acc_array;

    signal stage6_valid   : std_logic := '0';
    signal stage6_shifted : acc_array;

    signal stage7_valid  : std_logic := '0';
    signal stage7_output : output_array;

    signal stage8_valid  : std_logic := '0';
    signal stage8_output : output_array;
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux FSM
    --! @{
    ---------------------------------------------------------------------------

    --! @brief États de la machine d'états principale
    --! @details Identiques à Conv1, avec KKC+4=79 comme seuil de transition
    type state_type is (IDLE, LOAD_WEIGHTS, FILL_WINDOW, STREAMING, DONE_STATE);
    signal state : state_type := IDLE;

    signal pixel_counter   : integer := 0;
    --! Compteur pixels d'entrée consommés (avance de 1 par cycle, pas par pixel complet)

    signal output_counter  : integer := 0;
    --! Compteur pixels de sortie produits (fin de pipeline, déclenche DONE_STATE)

    signal weight_load_idx : integer range 0 to 127 := 0;
    --! Index de chargement poids/biais (0 à KKC+4=79)
    --! Plage étendue à 127 pour couvrir le padding de l'adresse registrée

    signal input_addr : integer range 0 to IN_WIDTH*IN_HEIGHT*IN_CHANNELS-1 := 0;
    --! Adresse courante dans la mémoire d'entrée (0 à 587, format HWC séquentiel)

    signal in_data_ready : std_logic := '0';
    --! Active la lecture séquentielle de la mémoire d'entrée (levé dès FILL_WINDOW)

    signal weights_loaded : std_logic := '0';
    --! Flag interne : poids et biais correctement chargés dans weight_cache
    --! @}

begin

    ---------------------------------------------------------------------------
    --! @brief Adresse mémoire d'entrée (combinatoire)
    --!
    --! @details input_addr est incrémenté de 1 par cycle en FILL_WINDOW et
    --!          STREAMING. Il suit le séquencement HWC : ch0, ch1, ch2, puis
    --!          pixel suivant. La BRAM d'entrée (buffer2) est adressée
    --!          directement sans registre intermédiaire (latence 1 cycle).
    ---------------------------------------------------------------------------
    in_bram_addr <= std_logic_vector(to_unsigned(input_addr, 10));

    ---------------------------------------------------------------------------
    --! @brief Adresses BRAMs poids - registrées, gelées à KKC-1=74
    --!
    --! @details Process corrigeant le bug d'adresse hors-range de la version
    --!          originale. Les 6 BRAMs partagent la même adresse (lecture
    --!          parallèle de tous les canaux de sortie au même cycle).
    --!
    --!          Séquence de chargement corrigée :
    --!          @code
    --!            idx=0  : addr_reg ? 0
    --!            idx=1  : addr_reg ? 1,    BRAM présente poids[0]
    --!            idx=2  : addr_reg ? 2,    capture poids[0] ? cache(*,0)
    --!            ...
    --!            idx=75 : addr_reg ? 74*,  capture poids[73] ? cache(*,73)
    --!            idx=76 : addr_reg ? 74*,  capture poids[74] ? cache(*,74) ?
    --!            idx=77 : addr_reg ? 74*   (rien à capturer)
    --!            idx=78 : capture biais
    --!            idx=79 : weights_loaded='1' ? transition FILL_WINDOW
    --!            (* gelée à KKC-1=74, jamais hors plage COE)
    --!          @endcode
    ---------------------------------------------------------------------------
    weight_addr_proc : process(clk)
        variable addr_v : integer range 0 to 127;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                weight_addr_0 <= (others => '0');
                weight_addr_1 <= (others => '0');
                weight_addr_2 <= (others => '0');
                weight_addr_3 <= (others => '0');
                weight_addr_4 <= (others => '0');
                weight_addr_5 <= (others => '0');
            else
                if weight_load_idx < KKC then
                    addr_v := weight_load_idx;
                else
                    addr_v := KKC - 1;  --! Gel à 74 - adresse toujours dans range COE
                end if;
                weight_addr_0 <= std_logic_vector(to_unsigned(addr_v, 7));
                weight_addr_1 <= std_logic_vector(to_unsigned(addr_v, 7));
                weight_addr_2 <= std_logic_vector(to_unsigned(addr_v, 7));
                weight_addr_3 <= std_logic_vector(to_unsigned(addr_v, 7));
                weight_addr_4 <= std_logic_vector(to_unsigned(addr_v, 7));
                weight_addr_5 <= std_logic_vector(to_unsigned(addr_v, 7));
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Chargement des poids et biais depuis les 6 BRAMs
    --!
    --! @details Décalé d'1 cycle supplémentaire par rapport à Conv1 en raison
    --!          de la double latence : addr registrée (weight_addr_proc) +
    --!          latence BRAM (1 cycle). La capture commence donc à idx=2
    --!          (au lieu de idx=1 pour Conv1 avec addr combinatoire).
    --!
    --!          Les 6 canaux de sortie sont capturés simultanément à chaque
    --!          cycle (weight_cache(0..5, idx-2) ? weight_data_0..5).
    --!
    --! @note    Les biais sont capturés à idx=KKC+3=78 (port direct, pas de
    --!          BRAM séparée - connectés aux sorties de blk_mem_c2_b).
    ---------------------------------------------------------------------------
    weight_loading : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                weight_cache   <= (others => (others => (others => '0')));
                bias_regs      <= (others => (others => '0'));
                weights_loaded <= '0';
            elsif state = LOAD_WEIGHTS then
                -- Poids : capture aux indices 2..KKC+1 = 2..76
                if weight_load_idx >= 2 and weight_load_idx <= KKC + 1 then
                    weight_cache(0, weight_load_idx - 2) <= weight_data_0;
                    weight_cache(1, weight_load_idx - 2) <= weight_data_1;
                    weight_cache(2, weight_load_idx - 2) <= weight_data_2;
                    weight_cache(3, weight_load_idx - 2) <= weight_data_3;
                    weight_cache(4, weight_load_idx - 2) <= weight_data_4;
                    weight_cache(5, weight_load_idx - 2) <= weight_data_5;
                end if;
                -- Biais à idx = KKC+3 = 78
                if weight_load_idx = KKC + 3 then
                    bias_regs(0) <= bias_data_0;
                    bias_regs(1) <= bias_data_1;
                    bias_regs(2) <= bias_data_2;
                    bias_regs(3) <= bias_data_3;
                    bias_regs(4) <= bias_data_4;
                    bias_regs(5) <= bias_data_5;
                end if;
                -- Fin chargement à idx = KKC+4 = 79
                if weight_load_idx = KKC + 4 then
                    weights_loaded <= '1';
                end if;
            elsif state = IDLE then
                weights_loaded <= '0';
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Mise à jour du sliding window 3D multi-canal
    --!
    --! @details Contrairement à Conv1 (1 canal, 1 octet par cycle), Conv2 lit
    --!          IN_CHANNELS=3 octets consécutifs pour former un pixel complet.
    --!          pixel_buf accumule les 3 octets sur 3 cycles consécutifs.
    --!          Quand ch_read_idx = IN_CHANNELS-1 (3ème octet), le pixel est
    --!          complet et inséré dans sliding_window par décalage horizontal.
    --!
    --!          Décalage horizontal (dernier canal lu en ligne) :
    --!          @code
    --!            sliding_window(KS-1, 0..W-2, c) ? sliding_window(KS-1, 1..W-1, c)
    --!            sliding_window(KS-1, W-1, c) ? pixel_buf(c) / in_bram_data
    --!          @endcode
    --!
    --!          Décalage vertical (fin de ligne) :
    --!          @code
    --!            sliding_window(0..KS-2, x, c) ? sliding_window(1..KS-1, x, c)
    --!          @endcode
    --!
    --! @note    pixel_complete est levé pendant 1 cycle (ch_read_idx=IN_CHANNELS-1)
    --!          pour synchroniser stage0_extraction avec le sliding window.
    ---------------------------------------------------------------------------
    sliding_window_update : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                col_index      <= 0;
                row_index      <= 0;
                ch_read_idx    <= 0;
                pixel_complete <= '0';
                sliding_window <= (others => (others => (others => (others => '0'))));
                pixel_buf      <= (others => (others => '0'));
            elsif (state = FILL_WINDOW or state = STREAMING) and in_data_ready = '1' then

                pixel_complete <= '0';
                pixel_buf(ch_read_idx) <= in_bram_data;

                if ch_read_idx = IN_CHANNELS - 1 then
                    ch_read_idx    <= 0;
                    pixel_complete <= '1';

                    -- Décalage horizontal sur tous les canaux
                    for c in 0 to IN_CHANNELS-1 loop
                        for col in 0 to IN_WIDTH-2 loop
                            sliding_window(KERNEL_SIZE-1, col, c) <=
                                sliding_window(KERNEL_SIZE-1, col+1, c);
                        end loop;
                    end loop;

                    -- Insertion du nouveau pixel (canaux 0..C-2 depuis pixel_buf,
                    -- canal C-1 directement depuis in_bram_data)
                    for c in 0 to IN_CHANNELS-2 loop
                        sliding_window(KERNEL_SIZE-1, IN_WIDTH-1, c) <= pixel_buf(c);
                    end loop;
                    sliding_window(KERNEL_SIZE-1, IN_WIDTH-1, IN_CHANNELS-1) <= in_bram_data;

                    -- Décalage vertical en fin de ligne
                    if col_index = IN_WIDTH-1 then
                        col_index <= 0;
                        for line in 0 to KERNEL_SIZE-2 loop
                            for col in 0 to IN_WIDTH-1 loop
                                for c in 0 to IN_CHANNELS-1 loop
                                    sliding_window(line, col, c) <=
                                        sliding_window(line+1, col, c);
                                end loop;
                            end loop;
                        end loop;
                        if row_index < IN_HEIGHT-1 then
                            row_index <= row_index + 1;
                        end if;
                    else
                        col_index <= col_index + 1;
                    end if;

                else
                    ch_read_idx <= ch_read_idx + 1;
                end if;

            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Stage 0 - Extraction de la fenêtre 3D courante
    --!
    --! @details Activé uniquement quand ch_read_idx = IN_CHANNELS-1 (pixel
    --!          complet disponible). Extrait les KERNEL_SIZE²×IN_CHANNELS=75
    --!          valeurs de la fenêtre courante depuis sliding_window.
    --!          La condition de validité spatiale est identique à Conv1 :
    --!          x_pos ? KERNEL_SIZE-1 ET y_pos ? KERNEL_SIZE-1.
    ---------------------------------------------------------------------------
    stage0_extraction : process(clk)
        variable x_pos, y_pos : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                stage0_valid <= '0';
            elsif (state = FILL_WINDOW or state = STREAMING)
                  and in_data_ready = '1'
                  and ch_read_idx = IN_CHANNELS-1 then
                x_pos := col_index;
                y_pos := row_index;
                if x_pos >= KERNEL_SIZE-1 and y_pos >= KERNEL_SIZE-1 and
                   x_pos < IN_WIDTH       and y_pos < IN_HEIGHT then
                    for ky in 0 to KERNEL_SIZE-1 loop
                        for kx in 0 to KERNEL_SIZE-1 loop
                            for ic in 0 to IN_CHANNELS-1 loop
                                stage0_window(ky, kx, ic) <=
                                    sliding_window(ky, x_pos-(KERNEL_SIZE-1)+kx, ic);
                            end loop;
                        end loop;
                    end loop;
                    stage0_valid <= '1';
                else
                    stage0_valid <= '0';
                end if;
            else
                stage0_valid <= '0';
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Stage 1 - Fetch des KKC=75 poids depuis weight_cache
    --!
    --! @details Même logique que Conv1 mais avec KKC=75 coefficients par
    --!          canal au lieu de KK=25. Les 6×75=450 poids sont copiés en
    --!          un cycle depuis weight_cache vers stage1_weights.
    ---------------------------------------------------------------------------
    stage1_weight_fetch : process(clk)
    begin
        if rising_edge(clk) then
            stage1_valid  <= stage0_valid;
            stage1_window <= stage0_window;
            if stage0_valid = '1' then
                for ch in 0 to OUT_CHANNELS-1 loop
                    for i in 0 to KKC-1 loop
                        stage1_weights(ch, i) <= weight_cache(ch, i);
                    end loop;
                end loop;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Stage 2 - Multiplications int8×int8 ? int16 (KKC=75 par canal)
    --!
    --! @details L'indexation plate (flat_idx) suit l'ordre KHW×C :
    --!          flat_idx = ky×KERNEL_SIZE×IN_CHANNELS + kx×IN_CHANNELS + ic
    --!          Ce schéma est cohérent avec l'ordre de stockage des poids
    --!          dans les fichiers .coe (généré par le script Python export).
    --!
    --! @warning Sur Zynq-7010, les 6×75=450 multiplications int8×int8 sont
    --!          absorbées en logique LUT (DSP48E1 non utilisés pour int8×int8).
    ---------------------------------------------------------------------------
    stage2_multiplication : process(clk)
        variable flat_idx : integer;
    begin
        if rising_edge(clk) then
            stage2_valid <= stage1_valid;
            if stage1_valid = '1' then
                for ch in 0 to OUT_CHANNELS-1 loop
                    for ky in 0 to KERNEL_SIZE-1 loop
                        for kx in 0 to KERNEL_SIZE-1 loop
                            for ic in 0 to IN_CHANNELS-1 loop
                                flat_idx := ky*KERNEL_SIZE*IN_CHANNELS
                                          + kx*IN_CHANNELS + ic;
                                stage2_products(ch, flat_idx) <=
                                    resize(stage1_window(ky,kx,ic)
                                           * stage1_weights(ch,flat_idx), 16);
                            end loop;
                        end loop;
                    end loop;
                end loop;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Stage 3 - Registre tampon des produits (isolation timing)
    --!
    --! @details Identique à Conv1 - coupe le chemin critique entre les
    --!          multiplicateurs et l'entrée de l'adder tree.
    ---------------------------------------------------------------------------
    stage3_pipe : process(clk)
    begin
        if rising_edge(clk) then
            stage3_valid    <= stage2_valid;
            stage3_products <= stage2_products;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Adder tree pipeliné 7 niveaux - réduction KKC=75 ? somme int32
    --!
    --! @details Extension de l'adder tree de Conv1 (5 niveaux) à 7 niveaux
    --!          pour couvrir KKC=75 produits (TREE_WIDTH=128 > 75).
    --!          Niveau 0 : chargement des 75 produits int16?int32, padding
    --!          des positions 75..127 à zéro.
    --!          Niveaux 1..7 : réduction binaire par paires.
    --!          Résultat en tree_reg(7)(ch)(0).
    ---------------------------------------------------------------------------
    adder_tree_proc : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                tree_valid <= (others => '0');
            else
                tree_valid(0) <= stage3_valid;
                for ch in 0 to OUT_CHANNELS-1 loop
                    for i in 0 to KKC-1 loop
                        tree_reg(0)(ch)(i) <= resize(stage3_products(ch, i), 32);
                    end loop;
                    for i in KKC to TREE_WIDTH-1 loop
                        tree_reg(0)(ch)(i) <= (others => '0');
                    end loop;
                end loop;
                for lvl in 1 to TREE_LEVELS loop
                    tree_valid(lvl) <= tree_valid(lvl-1);
                    for ch in 0 to OUT_CHANNELS-1 loop
                        for node in 0 to (TREE_WIDTH/(2**lvl))-1 loop
                            tree_reg(lvl)(ch)(node) <=
                                tree_reg(lvl-1)(ch)(2*node) +
                                tree_reg(lvl-1)(ch)(2*node+1);
                        end loop;
                        for node in (TREE_WIDTH/(2**lvl)) to TREE_WIDTH-1 loop
                            tree_reg(lvl)(ch)(node) <= (others => '0');
                        end loop;
                    end loop;
                end loop;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Stage B - Ajout des biais int32
    --! @details Identique à Conv1, étendu à OUT_CHANNELS=6.
    ---------------------------------------------------------------------------
    stageB_bias : process(clk)
    begin
        if rising_edge(clk) then
            stageB_valid <= tree_valid(TREE_LEVELS);
            if tree_valid(TREE_LEVELS) = '1' then
                for ch in 0 to OUT_CHANNELS-1 loop
                    stageB_acc(ch) <= tree_reg(TREE_LEVELS)(ch)(0) + bias_regs(ch);
                end loop;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Stage 5 - Requantification entière schéma Q30
    --! @details Identique à Conv1 : (acc × C2_MULT) >> C2_SHIFT, étendu à 6 canaux.
    --!          Produit intermédiaire 64 bits pour éviter l'overflow.
    ---------------------------------------------------------------------------
    stage5_requant_mult : process(clk)
    begin
        if rising_edge(clk) then
            stage5_valid <= stageB_valid;
            if stageB_valid = '1' then
                for ch in 0 to OUT_CHANNELS-1 loop
                    stage5_requant(ch) <=
                        resize(shift_right(
                            resize(stageB_acc(ch) * Q_MULT, 64), Q_SHIFT), 32);
                end loop;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Stage 6 - Ajout du zero-point de sortie
    --! @details C2_ZERO_POINT = 0 (ReLU implicite) ? étape de propagation pure.
    ---------------------------------------------------------------------------
    stage6_offset : process(clk)
    begin
        if rising_edge(clk) then
            stage6_valid <= stage5_valid;
            if stage5_valid = '1' then
                for ch in 0 to OUT_CHANNELS-1 loop
                    stage6_shifted(ch) <= stage5_requant(ch) + resize(Q_ZERO_POINT, 32);
                end loop;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Stage 7 - Saturation int8 (clamp [-128, 127])
    --! @details Identique à Conv1, étendu à OUT_CHANNELS=6.
    ---------------------------------------------------------------------------
    stage7_saturation : process(clk)
        variable sat_val : int8;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                stage7_valid <= '0';
            else
                stage7_valid <= stage6_valid;
                if stage6_valid = '1' then
                    for ch in 0 to OUT_CHANNELS-1 loop
                        if stage6_shifted(ch) > INT8_MAX_VAL then
                            sat_val := resize(INT8_MAX_VAL, 8);
                        elsif stage6_shifted(ch) < INT8_MIN_VAL then
                            sat_val := resize(INT8_MIN_VAL, 8);
                        else
                            sat_val := resize(stage6_shifted(ch), 8);
                        end if;
                        stage7_output(ch) <= sat_val;
                    end loop;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Stage 8 - Activation ReLU et comptage pixels de sortie
    --!
    --! @details Identique à Conv1, étendu à OUT_CHANNELS=6.
    --!          output_counter incrémenté ici (fin de pipeline) pour détecter
    --!          la fin de vidange dans la FSM (OPT-3 identique à Conv1).
    --!          Transition DONE_STATE quand output_counter = OUT_HEIGHT×OUT_WIDTH = 100.
    ---------------------------------------------------------------------------
    stage8_relu : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' or state = IDLE then
                stage8_valid   <= '0';
                output_counter <= 0;
            else
                stage8_valid <= stage7_valid;
                if stage7_valid = '1' then
                    output_counter <= output_counter + 1;
                    for ch in 0 to OUT_CHANNELS-1 loop
                        if USE_RELU then
                            if stage7_output(ch) < to_signed(0, 8) then
                                stage8_output(ch) <= to_signed(0, 8);
                            else
                                stage8_output(ch) <= stage7_output(ch);
                            end if;
                        else
                            stage8_output(ch) <= stage7_output(ch);
                        end if;
                    end loop;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Assignations des sorties streaming (depuis stage 8)
    --! @details 6 octets produits simultanément par cycle valide.
    --!          Le module aval (buffer3 dans top_lenet_full) les capture
    --!          directement sur front montant sans FIFO intermédiaire.
    ---------------------------------------------------------------------------
    out_data_0 <= stage8_output(0);
    out_data_1 <= stage8_output(1);
    out_data_2 <= stage8_output(2);
    out_data_3 <= stage8_output(3);
    out_data_4 <= stage8_output(4);
    out_data_5 <= stage8_output(5);
    out_valid  <= stage8_valid;

    ---------------------------------------------------------------------------
    --! @brief FSM principale - contrôle du flot d'exécution
    --!
    --! @details Identique à Conv1 avec deux différences :
    --!   1. Seuil de transition FILL_WINDOW : KKC+4=79 (au lieu de 28)
    --!      en raison du décalage dû à l'adresse registrée (+2 cycles)
    --!   2. pixel_counter comparé à IN_HEIGHT×IN_WIDTH×IN_CHANNELS-1
    --!      (chaque pixel occupe IN_CHANNELS=3 cycles de lecture BRAM)
    --!
    --! @note    OPT-2 : input_addr est incrémenté dès LOAD_WEIGHTS (en parallèle
    --!          du chargement des poids) pour que le premier pixel soit disponible
    --!          en BRAM dès l'entrée dans FILL_WINDOW.
    ---------------------------------------------------------------------------
    main_controller : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state           <= IDLE;
                done            <= '0';
                pixel_counter   <= 0;
                input_addr      <= 0;
                in_data_ready   <= '0';
            else
                case state is

                    --! @brief IDLE : attente du signal start
                    when IDLE =>
                        done          <= '0';
                        pixel_counter <= 0;
                        in_data_ready <= '0';
                        if start = '1' then
                            input_addr      <= 0;
                            weight_load_idx <= 0;
                            state           <= LOAD_WEIGHTS;
                        end if;

                    --! @brief LOAD_WEIGHTS : chargement 75 poids × 6 filtres + 6 biais
                    --! Durée = KKC+4+1 = 80 cycles (adresse registrée + latence BRAM)
                    when LOAD_WEIGHTS =>
                        if input_addr < IN_WIDTH*IN_HEIGHT*IN_CHANNELS - 1 then
                            input_addr <= input_addr + 1;
                        end if;
                        if weight_load_idx = KKC + 4 then  --! = 79 (correction)
                            weight_load_idx <= 0;
                            input_addr      <= 1;
                            pixel_counter   <= 0;
                            in_data_ready   <= '1';
                            state           <= FILL_WINDOW;
                        else
                            weight_load_idx <= weight_load_idx + 1;
                        end if;

                    --! @brief FILL_WINDOW : remplissage line buffer 3D
                    --! FILL_CYCLES = (KS-1)×W×C - 1 = 4×14×3 - 1 = 167 cycles
                    when FILL_WINDOW =>
                        if in_data_ready = '1' then
                            pixel_counter <= pixel_counter + 1;
                            if input_addr < IN_WIDTH*IN_HEIGHT*IN_CHANNELS - 1 then
                                input_addr <= input_addr + 1;
                            end if;
                        end if;
                        if pixel_counter >= FILL_CYCLES then
                            pixel_counter <= 0;
                            state         <= STREAMING;
                        end if;

                    --! @brief STREAMING : production des 100 pixels de sortie (10×10)
                    when STREAMING =>
                        if in_data_ready = '1' then
                            pixel_counter <= pixel_counter + 1;
                            if input_addr < IN_WIDTH*IN_HEIGHT*IN_CHANNELS - 1 then
                                input_addr <= input_addr + 1;
                            end if;
                        end if;
                        if pixel_counter >= IN_HEIGHT*IN_WIDTH*IN_CHANNELS - 1 then
                            in_data_ready <= '0';
                        end if;
                        if output_counter >= OUT_HEIGHT * OUT_WIDTH then
                            state <= DONE_STATE;
                        end if;

                    --! @brief DONE_STATE : assertion done, handshake avec top-level
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