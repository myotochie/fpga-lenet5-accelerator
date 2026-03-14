----------------------------------------------------------------------------------
--! @file    conv2d_int8_streaming.vhd
--! @brief   Convolution 2D INT8 streaming avec adder tree pipeliné
--!
--! @details Ce module implémente une convolution 2D quantifiée en entier 8 bits
--!          signé, utilisant un adder tree pipeliné sur 5 niveaux pour sommer
--!          les 25 produits partiels d'un noyau 5×5. La sortie est produite en
--!          mode streaming (un pixel de sortie par cycle en régime établi).
--!          Le module supporte jusqu'à 3 canaux de sortie en parallèle et
--!          intègre optionnellement une activation ReLU en fin de pipeline.
--!
--! @section pipeline Pipeline de traitement (10 stages)
--!   - Stage 0  : Extraction de la fenêtre glissante (sliding window)
--!   - Stage 1  : Fetch des poids depuis le cache (weight_cache)
--!   - Stage 2  : Multiplications int8 × int8 ? int16 (25 produits/canal)
--!   - Stage 3  : Registre buffer des produits (isolation timing)
--!   - Tree 0-5 : Adder tree pipeliné sur 6 cycles (réduction 32 ? 1 nœud)
--!   - Stage B  : Ajout du biais int32
--!   - Stage 5  : Requantification entière (× Q_MULT, >> Q_SHIFT)
--!   - Stage 6  : Ajout du zero-point (Q_ZERO_POINT)
--!   - Stage 7  : Saturation int8 (clamp [-128, 127])
--!   - Stage 8  : ReLU = max(0, x) - activable via générique USE_RELU
--!
--! @section optim Optimisations FSM
--!   - OPT-1 : FILL_WINDOW réduit à 128 cycles (au lieu de 160)
--!   - OPT-2 : Prefetch BRAM pendant LOAD_WEIGHTS (état WAIT_BRAM supprimé)
--!   - OPT-3 : Pipeline actif dès FILL_WINDOW (état FLUSH supprimé)
--!
--! @section quantif Schéma de requantification
--!   La requantification suit le schéma Q30 :
--!   @code
--!     out_int8 = sat8( (acc_int32 * Q_MULT) >> Q_SHIFT + Q_ZERO_POINT )
--!   @endcode
--!   Les constantes Q_MULT, Q_SHIFT, Q_ZERO_POINT sont définies dans
--!   lenet_qparams_pkg.vhd et précalculées depuis les facteurs d'échelle ONNX.
--!
--! @author  Donald MYO
--! @date    2026
--! @version 2.0 - ReLU intégré en stage 8, OPT-1/2/3 appliquées
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

--! @brief Convolution 2D INT8 streaming - entité principale
--!
--! @details Instanciation minimale pour Conv1 (LeNet-5 modifié) :
--! @code
--!   conv1 : entity work.conv2d_int8_streaming
--!     generic map (
--!       IN_WIDTH     => 32, IN_HEIGHT => 32, IN_CHANNELS  => 1,
--!       OUT_CHANNELS => 3,  KERNEL_SIZE => 5,
--!       Q_MULT       => C1_MULT, Q_SHIFT => C1_SHIFT,
--!       Q_ZERO_POINT => C1_ZERO_POINT, USE_RELU => true
--!     )
--!     port map ( clk => clk, rst => rst, start => start, ... );
--! @endcode
entity conv2d_int8_streaming is
    generic (
        IN_WIDTH     : integer := 32;   --! Largeur de l'image d'entrée (pixels)
        IN_HEIGHT    : integer := 32;   --! Hauteur de l'image d'entrée (pixels)
        IN_CHANNELS  : integer := 1;    --! Nombre de canaux d'entrée
        OUT_CHANNELS : integer := 3;    --! Nombre de canaux de sortie (filtres)
        KERNEL_SIZE  : integer := 5;    --! Taille du noyau de convolution (carré)

        Q_MULT       : int32   := C1_MULT;        --! Multiplicateur de requantification (Q30)
        Q_SHIFT      : integer := C1_SHIFT;       --! Décalage arithmétique de requantification
        Q_ZERO_POINT : int8    := C1_ZERO_POINT;  --! Zero-point de l'activation de sortie

        --! @brief Active ou désactive le ReLU intégré en stage 8
        --! @details
        --!   - TRUE  : sortie = max(0, conv(x))  - mode normal LeNet
        --!   - FALSE : sortie = conv(x) brut      - debug / couches sans activation
        USE_RELU     : boolean := true
    );
    port (
        --! @name Contrôle
        --! @{
        clk   : in  std_logic;  --! Horloge système (front montant actif)
        rst   : in  std_logic;  --! Reset synchrone actif haut
        start : in  std_logic;  --! Impulsion de démarrage (1 cycle)
        done  : out std_logic;  --! Signal de fin d'inférence (actif haut)
        --! @}

        --! @name Interface poids - 3 BRAMs indépendantes (lecture parallèle)
        --! @{
        weight_addr_0 : out std_logic_vector(4 downto 0);  --! Adresse BRAM filtre 0 (0..24)
        weight_data_0 : in  int8;                          --! Donnée poids filtre 0
        weight_addr_1 : out std_logic_vector(4 downto 0);  --! Adresse BRAM filtre 1 (0..24)
        weight_data_1 : in  int8;                          --! Donnée poids filtre 1
        weight_addr_2 : out std_logic_vector(4 downto 0);  --! Adresse BRAM filtre 2 (0..24)
        weight_data_2 : in  int8;                          --! Donnée poids filtre 2
        --! @}

        --! @name Interface biais - chargés une fois en début de couche
        --! @{
        bias_data_0 : in int32;  --! Biais int32 du filtre 0 (compensé pour entrée INT8)
        bias_data_1 : in int32;  --! Biais int32 du filtre 1
        bias_data_2 : in int32;  --! Biais int32 du filtre 2
        --! @}

        --! @name Interface mémoire d'entrée (BRAM image)
        --! @{
        in_bram_addr : out std_logic_vector(9 downto 0);  --! Adresse pixel d'entrée (0..1023)
        in_bram_data : in  int8;                          --! Donnée pixel int8 signé
        --! @}

        --! @name Sortie streaming - un vecteur de OUT_CHANNELS octets par cycle valide
        --! @{
        out_data_0 : out int8;      --! Pixel de sortie canal 0 (après ReLU si USE_RELU)
        out_data_1 : out int8;      --! Pixel de sortie canal 1
        out_data_2 : out int8;      --! Pixel de sortie canal 2
        out_valid  : out std_logic  --! Indique que out_data_0/1/2 sont valides ce cycle
        --! @}
    );
end conv2d_int8_streaming;

architecture Behavioral of conv2d_int8_streaming is

    ---------------------------------------------------------------------------
    --! @name Constantes dérivées des génériques
    --! @{
    ---------------------------------------------------------------------------
    constant OUT_WIDTH   : integer := IN_WIDTH  - KERNEL_SIZE + 1;
    --! Largeur carte de sortie = IN_WIDTH - KERNEL_SIZE + 1 (ex: 28 pour Conv1)

    constant OUT_HEIGHT  : integer := IN_HEIGHT - KERNEL_SIZE + 1;
    --! Hauteur carte de sortie = IN_HEIGHT - KERNEL_SIZE + 1 (ex: 28 pour Conv1)

    constant KK          : integer := KERNEL_SIZE * KERNEL_SIZE;
    --! Nombre de coefficients par filtre = KERNEL_SIZE² (25 pour un noyau 5×5)

    constant TREE_LEVELS : integer := 5;
    --! Nombre de niveaux de l'adder tree = ceil(log2(KK)) = ceil(log2(25)) = 5

    constant TREE_WIDTH  : integer := 32;
    --! Largeur interne de l'arbre (puissance de 2 supérieure à KK=25)

    constant FILL_CYCLES : integer := (KERNEL_SIZE - 1) * IN_WIDTH - 1;
    --! Cycles nécessaires pour remplir le line buffer avant la première sortie valide
    --! = (KERNEL_SIZE-1) × IN_WIDTH - 1 = 4×32 - 1 = 127 cycles pour Conv1
    --! @}

    ---------------------------------------------------------------------------
    --! @name Types internes
    --! @{
    ---------------------------------------------------------------------------

    --! Buffer ligne du sliding window : KERNEL_SIZE lignes × IN_WIDTH colonnes
    type sliding_window_type is array (0 to KERNEL_SIZE-1, 0 to IN_WIDTH-1)    of int8;

    --! Cache des poids : OUT_CHANNELS filtres × KK coefficients
    type weight_cache_type   is array (0 to OUT_CHANNELS-1, 0 to KK-1)         of int8;

    --! Vecteur de biais : un int32 par canal de sortie
    type bias_array          is array (0 to OUT_CHANNELS-1)                     of int32;

    --! Fenêtre de convolution extraite : KERNEL_SIZE × KERNEL_SIZE
    type conv_window_type    is array (0 to KERNEL_SIZE-1, 0 to KERNEL_SIZE-1) of int8;

    --! Tableau de poids pour un pixel : OUT_CHANNELS × KK
    type weights_array_type  is array (0 to OUT_CHANNELS-1, 0 to KK-1)         of int8;

    --! Produits partiels int16 : OUT_CHANNELS × KK
    type products_type       is array (0 to OUT_CHANNELS-1, 0 to KK-1)         of int16;

    --! Accumulateurs int32 : un par canal de sortie
    type acc_array           is array (0 to OUT_CHANNELS-1)                     of int32;

    --! Sorties saturées int8 : un octet par canal
    type output_array        is array (0 to OUT_CHANNELS-1)                     of int8;

    --! Nœud de l'arbre d'additionneur : vecteur de TREE_WIDTH accumulateurs int32
    type tree_node_type  is array (0 to TREE_WIDTH-1)   of int32;

    --! Niveau de l'arbre : un tree_node_type par canal de sortie
    type tree_ch_type    is array (0 to OUT_CHANNELS-1) of tree_node_type;

    --! Arbre complet : (TREE_LEVELS+1) niveaux × OUT_CHANNELS canaux × TREE_WIDTH nœuds
    type tree_array_type is array (0 to TREE_LEVELS)    of tree_ch_type;
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux pipeline - registres inter-stages
    --! @{
    ---------------------------------------------------------------------------

    --! Line buffer du sliding window (KERNEL_SIZE lignes mémorisées)
    signal sliding_window : sliding_window_type := (others => (others => (others => '0')));

    --! Position horizontale courante dans l'image d'entrée (0 à IN_WIDTH-1)
    signal col_index : integer range 0 to IN_WIDTH-1  := 0;

    --! Position verticale courante dans l'image d'entrée (0 à IN_HEIGHT-1)
    signal row_index : integer range 0 to IN_HEIGHT-1 := 0;

    --! Cache des poids chargés depuis les BRAMs en début de couche
    signal weight_cache : weight_cache_type := (others => (others => (others => '0')));

    --! Registres de biais capturés depuis les ports bias_data_x
    signal bias_regs : bias_array := (others => (others => '0'));

    -- Stage 0 : fenêtre extraite
    signal stage0_valid  : std_logic := '0';       --! Validité stage 0
    signal stage0_window : conv_window_type;        --! Fenêtre 5×5 extraite

    -- Stage 1 : fetch poids
    signal stage1_valid   : std_logic := '0';      --! Validité stage 1
    signal stage1_weights : weights_array_type;    --! Poids capturés depuis weight_cache
    signal stage1_window  : conv_window_type;      --! Fenêtre propagée depuis stage 0

    -- Stage 2 : produits partiels
    signal stage2_valid    : std_logic := '0';     --! Validité stage 2
    signal stage2_products : products_type;        --! 25 produits int16 par canal

    -- Stage 3 : buffer produits (isolation timing)
    signal stage3_valid    : std_logic := '0';     --! Validité stage 3
    signal stage3_products : products_type;        --! Copie des produits (registre)

    -- Adder tree
    signal tree_valid : std_logic_vector(0 to TREE_LEVELS) := (others => '0');
    --! Chaîne de validité traversant les TREE_LEVELS niveaux de l'arbre

    signal tree_reg : tree_array_type;
    --! Registres de l'adder tree : tree_reg(lvl)(ch)(node)

    -- Stage B : après ajout biais
    signal stageB_valid : std_logic := '0';        --! Validité stage B
    signal stageB_acc   : acc_array;               --! Accumulateur + biais int32

    -- Stage 5 : requantification
    signal stage5_valid   : std_logic := '0';      --! Validité stage 5
    signal stage5_requant : acc_array;             --! Résultat après (×Q_MULT)>>Q_SHIFT

    -- Stage 6 : ajout zero-point
    signal stage6_valid   : std_logic := '0';      --! Validité stage 6
    signal stage6_shifted : acc_array;             --! Résultat après + Q_ZERO_POINT

    -- Stage 7 : saturation
    signal stage7_valid  : std_logic := '0';       --! Validité stage 7
    signal stage7_output : output_array;           --! Valeur saturée dans [-128, 127]

    -- Stage 8 : ReLU
    signal stage8_valid  : std_logic := '0';       --! Validité stage 8 (sortie finale)
    signal stage8_output : output_array;           --! Sortie finale après ReLU (ou bypass)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux FSM
    --! @{
    ---------------------------------------------------------------------------

    --! @brief États de la machine d'états principale
    --! @details
    --!   - IDLE       : attente du signal start
    --!   - LOAD_WEIGHTS : chargement des 25 poids et 3 biais depuis les BRAMs
    --!   - FILL_WINDOW  : remplissage du line buffer (FILL_CYCLES cycles, OPT-1)
    --!   - STREAMING    : production des pixels de sortie (pipeline actif)
    --!   - DONE_STATE   : assertion du signal done, attente du relâchement de start
    type state_type is (IDLE, LOAD_WEIGHTS, FILL_WINDOW, STREAMING, DONE_STATE);
    signal state : state_type := IDLE;  --! État courant de la FSM

    signal pixel_counter   : integer := 0;
    --! Compteur de pixels d'entrée consommés (FSM FILL_WINDOW et STREAMING)

    signal output_counter  : integer := 0;
    --! Compteur de pixels de sortie produits - détecte la fin de vidange du pipeline

    signal weight_load_idx : integer range 0 to 31 := 0;
    --! Index de chargement des poids (0 à 27 : 25 poids + latence BRAM + biais)

    signal input_addr : integer range 0 to IN_WIDTH*IN_HEIGHT-1 := 0;
    --! Adresse courante dans la BRAM image (0 à IN_WIDTH×IN_HEIGHT-1)

    signal in_data_ready : std_logic := '0';
    --! Active le décalage du sliding window et le stage 0 (OPT-2 : levé dès FILL_WINDOW)

    signal weights_loaded : std_logic := '0';
    --! Indicateur interne : poids et biais correctement chargés dans weight_cache
    --! @}

begin

    ---------------------------------------------------------------------------
    --! @brief Assignations combinatoires des adresses BRAM
    --!
    --! @details Les trois BRAMs de poids partagent la même adresse pour permettre
    --!          un accès parallèle à tous les canaux au même cycle d'horloge.
    --!          L'adresse image est directement issue du compteur input_addr.
    ---------------------------------------------------------------------------
    in_bram_addr  <= std_logic_vector(to_unsigned(input_addr, 10));
    weight_addr_0 <= std_logic_vector(to_unsigned(weight_load_idx, 5));
    weight_addr_1 <= std_logic_vector(to_unsigned(weight_load_idx, 5));
    weight_addr_2 <= std_logic_vector(to_unsigned(weight_load_idx, 5));

    ---------------------------------------------------------------------------
    --! @brief Chargement des poids et biais depuis les BRAMs (état LOAD_WEIGHTS)
    --!
    --! @details Les 25 poids de chaque filtre sont capturés aux cycles 1 à 25
    --!          (décalage d'un cycle dû à la latence synchrone de la BRAM).
    --!          Les 3 biais int32 sont capturés au cycle 27 (weight_load_idx=27).
    --!          Le flag weights_loaded est levé au cycle 28 pour autoriser la
    --!          transition vers FILL_WINDOW.
    ---------------------------------------------------------------------------
    weight_loading : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                weight_cache   <= (others => (others => (others => '0')));
                bias_regs      <= (others => (others => '0'));
                weights_loaded <= '0';
            elsif state = LOAD_WEIGHTS then
                if weight_load_idx >= 1 and weight_load_idx <= 25 then
                    weight_cache(0, weight_load_idx - 1) <= weight_data_0;
                    weight_cache(1, weight_load_idx - 1) <= weight_data_1;
                    weight_cache(2, weight_load_idx - 1) <= weight_data_2;
                end if;
                if weight_load_idx = 27 then
                    bias_regs(0) <= bias_data_0;
                    bias_regs(1) <= bias_data_1;
                    bias_regs(2) <= bias_data_2;
                end if;
                if weight_load_idx = 28 then
                    weights_loaded <= '1';
                end if;
            elsif state = IDLE then
                weights_loaded <= '0';
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Mise à jour du sliding window (line buffer)
    --!
    --! @details Implémente un line buffer de KERNEL_SIZE lignes × IN_WIDTH colonnes.
    --!          À chaque cycle où in_data_ready='1', le pixel lu depuis la BRAM
    --!          image est inséré en fin de la dernière ligne du buffer. Lorsque
    --!          col_index atteint IN_WIDTH-1, les lignes sont décalées vers le haut
    --!          (shift-register vertical), simulant l'avance d'une ligne dans l'image.
    --!
    --! @note    Cette implémentation ne requiert pas de BRAM dédiée pour le line
    --!          buffer : Vivado infère des registres flip-flop (LUTRAM), ce qui
    --!          est optimal pour des buffers de petite taille (KERNEL_SIZE=5).
    ---------------------------------------------------------------------------
    sliding_window_update : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                col_index      <= 0;
                row_index      <= 0;
                sliding_window <= (others => (others => (others => '0')));
            elsif (state = FILL_WINDOW or state = STREAMING) and in_data_ready = '1' then
                -- Décalage horizontal dans la dernière ligne du buffer
                for col in 0 to IN_WIDTH-2 loop
                    sliding_window(KERNEL_SIZE-1, col) <= sliding_window(KERNEL_SIZE-1, col+1);
                end loop;
                sliding_window(KERNEL_SIZE-1, IN_WIDTH-1) <= in_bram_data;

                if col_index = IN_WIDTH-1 then
                    col_index <= 0;
                    -- Décalage vertical : ligne i ? ligne i+1
                    for line in 0 to KERNEL_SIZE-2 loop
                        for col in 0 to IN_WIDTH-1 loop
                            sliding_window(line, col) <= sliding_window(line+1, col);
                        end loop;
                    end loop;
                    if row_index < IN_HEIGHT-1 then
                        row_index <= row_index + 1;
                    end if;
                else
                    col_index <= col_index + 1;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Stage 0 - Extraction de la fenêtre de convolution courante
    --!
    --! @details À chaque position (col_index, row_index) valide (i.e. suffisamment
    --!          éloignée des bords pour qu'un noyau 5×5 tienne), les KERNEL_SIZE²=25
    --!          pixels de la fenêtre sont extraits depuis le sliding_window et
    --!          mémorisés dans stage0_window. Le signal stage0_valid indique qu'une
    --!          fenêtre complète et correcte est disponible.
    --!
    --! @note    La condition x_pos >= KERNEL_SIZE-1 AND y_pos >= KERNEL_SIZE-1
    --!          garantit que les KERNEL_SIZE-1=4 premières lignes et colonnes
    --!          (bord supérieur/gauche) ne génèrent pas de sortie invalide.
    ---------------------------------------------------------------------------
    stage0_extraction : process(clk)
        variable x_pos, y_pos : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                stage0_valid <= '0';
            elsif (state = FILL_WINDOW or state = STREAMING) and in_data_ready = '1' then
                x_pos := col_index;
                y_pos := row_index;
                if x_pos >= KERNEL_SIZE-1 and y_pos >= KERNEL_SIZE-1 and
                   x_pos < IN_WIDTH       and y_pos < IN_HEIGHT then
                    for ky in 0 to KERNEL_SIZE-1 loop
                        for kx in 0 to KERNEL_SIZE-1 loop
                            stage0_window(ky, kx) <=
                                sliding_window(ky, x_pos - (KERNEL_SIZE-1) + kx);
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
    --! @brief Stage 1 - Fetch des poids depuis le cache local
    --!
    --! @details Les KK=25 poids de chacun des OUT_CHANNELS filtres sont copiés
    --!          depuis weight_cache vers stage1_weights. Cette copie en registre
    --!          isole le cache (inféré en LUTRAM) du chemin de données critique
    --!          et permet à Vivado d'optimiser le placement des registres de stage 2.
    ---------------------------------------------------------------------------
    stage1_weight_fetch : process(clk)
    begin
        if rising_edge(clk) then
            stage1_valid  <= stage0_valid;
            stage1_window <= stage0_window;
            if stage0_valid = '1' then
                for ch in 0 to OUT_CHANNELS-1 loop
                    for i in 0 to KK-1 loop
                        stage1_weights(ch, i) <= weight_cache(ch, i);
                    end loop;
                end loop;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Stage 2 - Multiplications partielles int8 × int8 ? int16
    --!
    --! @details Les KK=25 produits partiels sont calculés simultanément pour
    --!          chacun des OUT_CHANNELS canaux. Le résultat est tronqué à 16 bits
    --!          (resize) : le produit de deux int8 tient dans [-16384, 16129]
    --!          ce qui est représentable sur 15 bits signés, donc int16 suffit.
    --!
    --! @warning Sur Zynq-7010, les DSP48E1 sont optimisés pour des opérandes
    --!          int18×int27. Les multiplications int8×int8 sont donc généralement
    --!          absorbées en logique LUT par Vivado, ce qui explique la faible
    --!          utilisation de DSP48 (~12) observée sur ce design.
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
                            flat_idx := ky * KERNEL_SIZE + kx;
                            stage2_products(ch, flat_idx) <=
                                resize(stage1_window(ky, kx) * stage1_weights(ch, flat_idx), 16);
                        end loop;
                    end loop;
                end loop;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Stage 3 - Registre tampon des produits (isolation timing)
    --!
    --! @details Simple registre de pipeline inséré entre la sortie des
    --!          multiplicateurs (stage 2) et l'entrée de l'adder tree (tree level 0).
    --!          Il permet à Vivado de couper le chemin critique entre les
    --!          multiplications et la première addition de l'arbre.
    ---------------------------------------------------------------------------
    stage3_pipe : process(clk)
    begin
        if rising_edge(clk) then
            stage3_valid    <= stage2_valid;
            stage3_products <= stage2_products;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Adder tree pipeliné - réduction de KK=25 produits en une somme int32
    --!
    --! @details Implémente un arbre d'additionneur binaire sur TREE_LEVELS=5 niveaux.
    --!          À chaque niveau lvl, les nœuds sont regroupés deux par deux :
    --!          @code
    --!            tree_reg(lvl)(ch)(node) = tree_reg(lvl-1)(ch)(2*node)
    --!                                    + tree_reg(lvl-1)(ch)(2*node+1)
    --!          @endcode
    --!          Le niveau 0 charge les KK produits int16 étendus à int32 ;
    --!          les positions KK..TREE_WIDTH-1 sont remplies de zéros (padding).
    --!          Le résultat final est disponible en tree_reg(TREE_LEVELS)(ch)(0).
    --!
    --! @details Avantage par rapport à une accumulation séquentielle :
    --!          latence log2(KK)=5 cycles au lieu de KK=25, chemin critique
    --!          réduit à une seule addition par cycle d'horloge.
    ---------------------------------------------------------------------------
    adder_tree_proc : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                tree_valid <= (others => '0');
            else
                tree_valid(0) <= stage3_valid;
                for ch in 0 to OUT_CHANNELS-1 loop
                    for i in 0 to KK-1 loop
                        tree_reg(0)(ch)(i) <= resize(stage3_products(ch, i), 32);
                    end loop;
                    for i in KK to TREE_WIDTH-1 loop
                        tree_reg(0)(ch)(i) <= (others => '0');
                    end loop;
                end loop;

                for lvl in 1 to TREE_LEVELS loop
                    tree_valid(lvl) <= tree_valid(lvl-1);
                    for ch in 0 to OUT_CHANNELS-1 loop
                        for node in 0 to (TREE_WIDTH / (2**lvl)) - 1 loop
                            tree_reg(lvl)(ch)(node) <=
                                tree_reg(lvl-1)(ch)(2*node) +
                                tree_reg(lvl-1)(ch)(2*node+1);
                        end loop;
                        for node in (TREE_WIDTH / (2**lvl)) to TREE_WIDTH-1 loop
                            tree_reg(lvl)(ch)(node) <= (others => '0');
                        end loop;
                    end loop;
                end loop;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Stage B - Ajout du biais int32
    --!
    --! @details Le biais de chaque canal est ajouté à la somme issue de l'adder
    --!          tree. Les biais sont en int32 et ont été compensés pour l'entrée
    --!          signée int8 selon : b_compensé = b_HLS - 128 × ?(w_i), afin
    --!          d'absorber le décalage introduit par la conversion UINT8 ? INT8.
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
    --! @brief Stage 5 - Requantification entière (schéma Q30)
    --!
    --! @details Applique la transformation :
    --!          @code
    --!            stage5_requant = (stageB_acc × Q_MULT) >> Q_SHIFT
    --!          @endcode
    --!          Le produit intermédiaire est étendu à 64 bits pour éviter tout
    --!          dépassement (Q_MULT peut atteindre ~2M et stageB_acc ~±2³¹).
    --!          shift_right effectue un décalage arithmétique (préservation du signe).
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
    --!
    --! @details Ajoute Q_ZERO_POINT (int8 étendu à int32) au résultat requantifié.
    --!          Pour Conv1 et Conv2 (ReLU implicite), Q_ZERO_POINT = 0 et cette
    --!          étape est un simple registre de propagation.
    --!          Pour la couche FC (USE_RELU=false), Q_ZERO_POINT = 150 (int32)
    --!          et cette étape décale effectivement la distribution de sortie.
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
    --!
    --! @details Sature la valeur int32 dans l'intervalle [-128, 127] en comparant
    --!          avec les constantes INT8_MAX_VAL et INT8_MIN_VAL définies dans
    --!          lenet_types_pkg.vhd. Cette saturation est nécessaire car la
    --!          requantification peut produire des valeurs hors de la plage int8
    --!          en cas de dépassement numérique.
    --!
    --! @note    Le compteur output_counter a été déplacé en stage 8 (après ReLU)
    --!          pour ne compter que les pixels effectivement émis en sortie.
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
    --! @brief Stage 8 - Activation ReLU et comptage des pixels de sortie
    --!
    --! @details Applique ReLU = max(0, x) sur les valeurs int8 saturées issues
    --!          du stage 7. Étant donné que la saturation a déjà été appliquée,
    --!          ReLU opère sur des valeurs dans [-128, 127], ce qui est correct :
    --!          ReLU(sat(x)) = max(0, sat(x)).
    --!
    --!          Le générique USE_RELU permet de bypasser cette étape (propagation
    --!          directe) pour les couches sans activation (ex: couche FC).
    --!
    --!          output_counter est incrémenté ici (fin du pipeline) pour que la
    --!          FSM détecte correctement la fin de vidange (OPT-3) : la transition
    --!          vers DONE_STATE intervient quand output_counter = OUT_HEIGHT×OUT_WIDTH.
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
    --!
    --! @details Les trois octets de sortie sont directement connectés aux
    --!          registres du stage 8. Le signal out_valid reflète stage8_valid.
    --!          Le module aval (buffer1 dans top_lenet_full) capture ces données
    --!          directement sur front montant d'horloge sans FIFO intermédiaire.
    ---------------------------------------------------------------------------
    out_data_0 <= stage8_output(0);
    out_data_1 <= stage8_output(1);
    out_data_2 <= stage8_output(2);
    out_valid  <= stage8_valid;

    ---------------------------------------------------------------------------
    --! @brief FSM principale - contrôle du flot d'exécution
    --!
    --! @details Machine d'états à 5 états gérant le séquencement complet :
    --!
    --!   @code
    --!   IDLE ??start='1'??? LOAD_WEIGHTS ??weights_loaded='1'??? FILL_WINDOW
    --!                                                                  ?
    --!                                              pixel_counter?FILL_CYCLES
    --!                                                                  ?
    --!                                                            STREAMING
    --!                                                                  ?
    --!                                          output_counter?OUT_H×OUT_W
    --!                                                                  ?
    --!                                                           DONE_STATE ??start='0'??? IDLE
    --!   @endcode
    --!
    --! @note   OPT-2 : pendant LOAD_WEIGHTS, input_addr est incrémenté en parallèle
    --!         du chargement des poids, de sorte que le premier pixel est disponible
    --!         en BRAM dès le premier cycle de FILL_WINDOW (latence BRAM absorbée).
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

                    --! @brief LOAD_WEIGHTS : chargement des 25 poids + 3 biais
                    --! depuis les BRAMs (28 cycles + latence BRAM = 29 cycles)
                    when LOAD_WEIGHTS =>
                        if input_addr < (IN_WIDTH * IN_HEIGHT) - 1 then
                            input_addr <= input_addr + 1;
                        end if;

                        if weight_load_idx = 28 then
                            weight_load_idx <= 0;
                            input_addr      <= 1;
                            pixel_counter   <= 0;
                            in_data_ready   <= '1';
                            state           <= FILL_WINDOW;
                        else
                            weight_load_idx <= weight_load_idx + 1;
                        end if;

                    --! @brief FILL_WINDOW : remplissage du line buffer
                    --! (FILL_CYCLES = (KERNEL_SIZE-1)×IN_WIDTH - 1 = 127 cycles)
                    when FILL_WINDOW =>
                        if in_data_ready = '1' then
                            pixel_counter <= pixel_counter + 1;
                            if input_addr < (IN_WIDTH * IN_HEIGHT) - 1 then
                                input_addr <= input_addr + 1;
                            end if;
                        end if;
                        if pixel_counter >= FILL_CYCLES then
                            pixel_counter <= 0;
                            state         <= STREAMING;
                        end if;

                    --! @brief STREAMING : production des OUT_HEIGHT×OUT_WIDTH pixels
                    --! Le pipeline continue jusqu'à ce que output_counter atteigne
                    --! OUT_HEIGHT×OUT_WIDTH (tous les pixels valides ont été émis)
                    when STREAMING =>
                        if in_data_ready = '1' then
                            pixel_counter <= pixel_counter + 1;
                            if input_addr < (IN_WIDTH * IN_HEIGHT) - 1 then
                                input_addr <= input_addr + 1;
                            end if;
                        end if;
                        if pixel_counter >= (IN_HEIGHT * IN_WIDTH) - 1 then
                            in_data_ready <= '0';
                        end if;
                        if output_counter >= OUT_HEIGHT * OUT_WIDTH then
                            state <= DONE_STATE;
                        end if;

                    --! @brief DONE_STATE : assertion de done, attente du relâchement
                    --! de start pour retourner en IDLE (handshake avec le top-level)
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