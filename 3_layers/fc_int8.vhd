----------------------------------------------------------------------------------
--! @file    fc_int8.vhd
--! @brief   Couche Fully Connected INT8 - LeNet-5 modifié (150 ? 10)
--!
--! @details Ce module implémente la couche entièrement connectée finale du
--!          pipeline LeNet-5 modifié. Il reçoit un vecteur de FC_IN=150 activations
--!          INT8 (sortie aplatie de MaxPool2), effectue la multiplication matricielle
--!          W×x + b (FC_OUT=10 neurones), requantifie le résultat en INT8 et produit
--!          les 10 logits de classification en un seul cycle de sortie valide.
--!
--! @section differences Différences vs conv2d_int8_streaming
--!   Contrairement aux couches de convolution, la FC n'utilise pas de sliding window
--!   ni d'adder tree pipeliné. Elle charge tous les poids (1500 = 150×10) et biais
--!   (10×32b) en BRAM une seule fois, puis effectue l'accumulation MAC séquentielle
--!   pixel par pixel avec un compteur local (mac_counter) garantissant l'alignement
--!   pixel/poids indépendamment de la FSM.
--!
--! @section pipeline Pipeline de traitement (5 stages post-accumulation)
--!   - ACCUMULATE : MAC séquentielle (FC_IN=150 cycles, accumulateurs 40 bits)
--!   - stage_req  : Requantification (acc+bias) × Q_MULT >> Q_SHIFT ? int32
--!   - stage_off  : Ajout zero-point Q_ZERO_POINT
--!   - stage_sat  : Saturation int8 (clamp [-128, 127])
--!   - stage_out  : ReLU optionnel (USE_RELU=false pour la FC finale)
--!   - out_reg    : Registre de sortie final (out_data + out_valid)
--!
--! @section corrections Corrections appliquées
--!   1. weight_addr gelée à 0 pendant la phase biais (évite addr hors-range BRAM)
--!   2. in_data_ready piloté uniquement par main_controller (un seul driver)
--!   3. mac_counter LOCAL à mac_proc (correction décalage pixel/poids) :
--!      @code
--!        Problème original : FSM et mac_proc lisaient pixel_counter dans le
--!        même rising edge ? mac_proc voyait pixel_counter déjà incrémenté
--!        alors que pixel_reg contenait encore le pixel du cycle précédent.
--!        Solution : mac_counter incrémenté DANS mac_proc ? alignement garanti.
--!      @endcode
--!
--! @section timing Timing MAC (correction #3)
--!   @code
--!   mac_counter | pixel_reg         | weight utilisé | action
--!   ------------|-------------------|----------------|------------------------
--!       0       | invalide (1er cy) | -              | capture pixel[0] seul
--!       1       | pixel[0]          | w(neu,0)       | acc += pixel[0]×w[0]
--!       2       | pixel[1]          | w(neu,1)       | acc += pixel[1]×w[1]
--!     ...       | ...               | ...            | ...
--!     150       | pixel[149]        | w(neu,149)     | acc += pixel[149]×w[149]
--!               |                   |                | ? acc_done='1' (pulse)
--!   @endcode
--!
--! @section fsm Machine d'états (5 états)
--!   @code
--!   IDLE ??start='1'??? LOAD_WEIGHTS ??idx=W_TOTAL+FC_OUT+2??? ACCUMULATE
--!                                                                    ?
--!                                                          pixel_counter=FC_IN
--!                                                                    ?
--!                                                           COMPUTE_OUTPUT
--!                                                                    ?
--!                                                        stage_out_valid='1'
--!                                                                    ?
--!                                                            DONE_STATE ??start='0'??? IDLE
--!   @endcode
--!
--! @author  Donald MYO
--! @date    2025
--! @version 2.0 - mac_counter local, weight_addr gelée, in_data_ready single driver
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

--! @brief Couche FC INT8 - entité principale
--!
--! @details Instanciation pour la couche FC de LeNet-5 modifié :
--! @code
--!   fc : entity work.fc_int8
--!     generic map (
--!       FC_IN=>150, FC_OUT=>10,
--!       Q_MULT=>FC_MULT, Q_SHIFT=>FC_SHIFT,
--!       Q_ZERO_POINT=>FC_ZERO_POINT, USE_RELU=>false
--!     )
--!     port map ( clk=>clk, rst=>rst, start=>start, done=>done, ... );
--! @endcode
entity fc_int8 is
    generic (
        FC_IN  : integer := 150;  --! Nombre d'entrées (150 = 6×5×5, sortie MaxPool2 aplatie)
        FC_OUT : integer := 10;   --! Nombre de neurones de sortie (10 classes MNIST)

        Q_MULT       : int32   := FC_MULT;        --! Multiplicateur requantification Q30
        Q_SHIFT      : integer := FC_SHIFT;       --! Décalage arithmétique requantification
        Q_ZERO_POINT : int8    := FC_ZERO_POINT;  --! Zero-point sortie FC (=150 en int32 !)

        --! @brief Active ou désactive le ReLU en sortie
        --! @details FALSE pour la couche FC finale (logits bruts transmis au softmax).
        --!          TRUE possible pour des couches FC cachées intermédiaires.
        USE_RELU : boolean := false
    );
    port (
        --! @name Contrôle
        --! @{
        clk   : in  std_logic;  --! Horloge système (front montant actif)
        rst   : in  std_logic;  --! Reset synchrone actif haut
        start : in  std_logic;  --! Impulsion de démarrage (1 cycle)
        done  : out std_logic;  --! Signal de fin (out_valid reçu, logits disponibles)
        --! @}

        --! @name Interface BRAM poids FC (W_TOTAL=1500 coefficients, addr 11 bits)
        --! @details Adresse séquentielle ordre neurone-majeur :
        --!          addr = neu × FC_IN + pix (neu=0..9, pix=0..149)
        --!          Gelée à 0 dès weight_load_idx ? W_TOTAL (correction #1).
        --! @{
        weight_addr : out std_logic_vector(10 downto 0);  --! Adresse poids (0..1499)
        weight_data : in  int8;                           --! Poids int8 signé
        --! @}

        --! @name Interface BRAM biais FC (FC_OUT=10 biais int32, addr 4 bits)
        --! @{
        bias_addr : out std_logic_vector(3 downto 0);  --! Adresse biais (0..9)
        bias_data : in  int32;                         --! Biais int32 signé
        --! @}

        --! @name Interface mémoire d'entrée (buffer4, 150 octets, addr 8 bits)
        --! @{
        in_bram_addr : out std_logic_vector(7 downto 0);  --! Adresse pixel d'entrée (0..149)
        in_bram_data : in  int8;                          --! Pixel int8 signé (sortie MaxPool2)
        --! @}

        --! @name Sorties FC - vecteur de FC_OUT=10 logits
        --! @{
        out_data  : out int8_vector(0 to FC_OUT-1);
        --! Logits int8 des 10 classes (valides quand out_valid='1')
        --! Index 0=chiffre 0, ..., Index 9=chiffre 9
        out_valid : out std_logic
        --! Pulse 1 cycle indiquant que out_data contient les logits finaux
        --! @}
    );
end fc_int8;

architecture Behavioral of fc_int8 is

    ---------------------------------------------------------------------------
    --! @name Constantes dérivées
    --! @{
    ---------------------------------------------------------------------------
    constant W_TOTAL : integer := FC_IN * FC_OUT;
    --! Nombre total de poids = FC_IN × FC_OUT = 150 × 10 = 1500
    --! Correspond à la profondeur utile de la BRAM poids (blk_mem_fc_w.coe)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Caches poids et biais
    --! @{
    ---------------------------------------------------------------------------

    --! @brief Cache des W_TOTAL=1500 poids chargés depuis blk_mem_fc_w
    --! @details Organisé en [FC_OUT=10 neurones][FC_IN=150 pixels].
    --!          Chargé séquentiellement en ordre neurone-majeur pendant LOAD_WEIGHTS.
    type weight_cache_type is array (0 to FC_OUT-1, 0 to FC_IN-1) of int8;
    signal weight_cache : weight_cache_type :=
        (others => (others => (others => '0')));

    --! @brief Cache des FC_OUT=10 biais int32 chargés depuis blk_mem_fc_b
    --! @details Chargés après les poids, aux adresses W_TOTAL+1..W_TOTAL+FC_OUT.
    type bias_cache_type is array (0 to FC_OUT-1) of int32;
    signal bias_cache : bias_cache_type := (others => (others => '0'));
    --! @}

    ---------------------------------------------------------------------------
    --! @name Accumulateurs MAC
    --! @{
    ---------------------------------------------------------------------------

    --! @brief Accumulateurs 40 bits pour les FC_OUT=10 neurones
    --! @details 40 bits = 8 (pixel) + 8 (poids) + log2(FC_IN) + marge = 16+8+1=25b min.
    --!          40 bits garantit l'absence d'overflow pour FC_IN=150 produits int16.
    type acc_type is array (0 to FC_OUT-1) of signed(39 downto 0);
    signal acc : acc_type := (others => (others => '0'));
    --! @}

    ---------------------------------------------------------------------------
    --! @name Types pipeline post-accumulation
    --! @{
    ---------------------------------------------------------------------------
    type requant_type is array (0 to FC_OUT-1) of int32;  --! Type requantification int32
    type out_type     is array (0 to FC_OUT-1) of int8;   --! Type sortie int8

    -- Stage requantification
    signal stage_req_valid : std_logic := '0';
    signal stage_req_data  : requant_type;
    --! Résultat (acc+bias) × Q_MULT >> Q_SHIFT pour chaque neurone

    -- Stage offset
    signal stage_off_valid : std_logic := '0';
    signal stage_off_data  : requant_type;
    --! Résultat après ajout de Q_ZERO_POINT

    -- Stage saturation
    signal stage_sat_valid : std_logic := '0';
    signal stage_sat_data  : out_type;
    --! Résultat saturé dans [-128, 127]

    -- Stage sortie (ReLU optionnel)
    signal stage_out_valid : std_logic := '0';
    signal stage_out_data  : out_type;
    --! Résultat final après ReLU (ou bypass si USE_RELU=false)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux FSM
    --! @{
    ---------------------------------------------------------------------------

    --! @brief États de la machine d'états principale
    --! @details
    --!   - IDLE          : attente du signal start
    --!   - LOAD_WEIGHTS  : chargement 1500 poids + 10 biais depuis BRAMs
    --!   - ACCUMULATE    : MAC séquentielle sur FC_IN=150 pixels
    --!   - COMPUTE_OUTPUT: attente de la fin du pipeline post-accumulation
    --!   - DONE_STATE    : assertion de done, attente relâchement de start
    type state_type is (IDLE, LOAD_WEIGHTS, ACCUMULATE, COMPUTE_OUTPUT, DONE_STATE);
    signal state : state_type := IDLE;

    signal weight_load_idx : integer range 0 to W_TOTAL + 15 := 0;
    --! Index de chargement poids+biais (0 à W_TOTAL+FC_OUT+2 = 1512)

    signal pixel_counter : integer range 0 to FC_IN + 1 := 0;
    --! Compteur FSM : avance input_addr_int et coupe in_data_ready à FC_IN cycles

    signal input_addr_int : integer range 0 to FC_IN - 1 := 0;
    --! Adresse courante dans buffer4 (0..149), incrémentée par main_controller

    signal in_data_ready : std_logic := '0';
    --! Autorise la lecture séquentielle de buffer4 et le MAC
    --! Piloté UNIQUEMENT par main_controller (correction #2 : un seul driver)

    signal acc_done : std_logic := '0';
    --! Pulse 1 cycle émis par mac_proc quand mac_counter = FC_IN
    --! Piloté UNIQUEMENT par mac_proc (un seul driver)

    signal mac_counter : integer range 0 to FC_IN + 1 := 0;
    --! Compteur LOCAL à mac_proc - indépendant de pixel_counter (correction #3)
    --! Garantit l'alignement pixel_reg/weight_cache :
    --! à mac_counter=k, pixel_reg = pixel[k-1] et weight = w(neu, k-1)

    signal pixel_reg : int8 := (others => '0');
    --! Registre de retard d'un cycle pour in_bram_data (latence BRAM synchrone)
    --! @}

begin

    ---------------------------------------------------------------------------
    --! @brief Adresse mémoire d'entrée (combinatoire)
    --!
    --! @details input_addr_int est incrémenté par main_controller en ACCUMULATE.
    --!          La BRAM buffer4 présente in_bram_data 1 cycle après, capturé
    --!          dans pixel_reg par mac_proc (correction #3 : latence absorbée
    --!          par le premier cycle "vide" mac_counter=0).
    ---------------------------------------------------------------------------
    in_bram_addr <= std_logic_vector(to_unsigned(input_addr_int, 8));

    ---------------------------------------------------------------------------
    --! @brief Chargement des poids et biais depuis les BRAMs FC
    --!
    --! @details Séquence de chargement sur W_TOTAL+FC_OUT+2 = 1512 cycles :
    --!
    --!          Poids (1500 cycles) :
    --!          @code
    --!            idx=0      : weight_addr ? 0
    --!            idx=1      : weight_addr ? 1, capture weight_data ? cache(0,0)
    --!            idx=2      : weight_addr ? 2, capture weight_data ? cache(0,1)
    --!            ...
    --!            idx=1500   : weight_addr ? 0*, capture weight_data ? cache(9,149)
    --!            (* gelée à 0, correction #1)
    --!          @endcode
    --!
    --!          Biais (FC_OUT+2=12 cycles) :
    --!          @code
    --!            idx=1501   : bias_addr ? 0
    --!            idx=1502   : bias_addr ? 1, capture bias_data ? bias_cache(0)
    --!            ...
    --!            idx=1511   : bias_addr ? 9, capture bias_data ? bias_cache(9)
    --!          @endcode
    --!
    --! @note    Correction #1 : weight_addr est gelée à 0 dès weight_load_idx ? W_TOTAL
    --!          pour éviter d'envoyer des adresses hors-range à la BRAM poids
    --!          (depth=1500, range valide 0..1499).
    ---------------------------------------------------------------------------
    weight_loading : process(clk)
        variable neu : integer;
        variable pix : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                weight_cache <= (others => (others => (others => '0')));
                bias_cache   <= (others => (others => '0'));
                weight_addr  <= (others => '0');
                bias_addr    <= (others => '0');

            elsif state = LOAD_WEIGHTS then

                -- Adresse poids : gelée à 0 dès idx ? W_TOTAL (correction #1)
                if weight_load_idx < W_TOTAL then
                    weight_addr <= std_logic_vector(to_unsigned(weight_load_idx, 11));
                else
                    weight_addr <= (others => '0');
                end if;

                -- Capture poids (1 cycle de latence BRAM)
                if weight_load_idx >= 1 and weight_load_idx <= W_TOTAL then
                    neu := (weight_load_idx - 1) / FC_IN;
                    pix := (weight_load_idx - 1) mod FC_IN;
                    weight_cache(neu, pix) <= weight_data;
                end if;

                -- Adresse biais
                if weight_load_idx >= W_TOTAL + 1 and
                   weight_load_idx <= W_TOTAL + FC_OUT then
                    bias_addr <= std_logic_vector(
                        to_unsigned(weight_load_idx - W_TOTAL - 1, 4));
                end if;

                -- Capture biais (1 cycle de latence BRAM)
                if weight_load_idx >= W_TOTAL + 2 and
                   weight_load_idx <= W_TOTAL + FC_OUT + 1 then
                    bias_cache(weight_load_idx - W_TOTAL - 2) <= bias_data;
                end if;

            elsif state = IDLE then
                weight_addr <= (others => '0');
                bias_addr   <= (others => '0');
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Accumulation MAC séquentielle avec mac_counter LOCAL (correction #3)
    --!
    --! @details Ce process est le seul driver de acc, pixel_reg, mac_counter
    --!          et acc_done. L'utilisation d'un compteur LOCAL (mac_counter)
    --!          indépendant de pixel_counter (FSM) garantit l'alignement parfait
    --!          entre pixel_reg et weight_cache à chaque cycle d'accumulation.
    --!
    --!          Mécanisme :
    --!            - Cycle T   : capture in_bram_data ? pixel_reg (latence BRAM)
    --!                          mac_counter incrémenté ? mac_counter = k
    --!            - Cycle T+1 : pixel_reg = pixel[k-1], weight = w(neu, k-1)
    --!                          ? accumulation correcte
    --!
    --!          acc_done est un pulse d'1 cycle émis quand mac_counter = FC_IN,
    --!          signalant que les 150 produits ont été accumulés et que le
    --!          pipeline post-accumulation peut démarrer.
    --!
    --! @warning acc est remis à zéro sur rst='1' OU state=IDLE. Cela permet
    --!          de réinitialiser les accumulateurs entre deux inférences sans
    --!          reset matériel explicite.
    ---------------------------------------------------------------------------
    mac_proc : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' or state = IDLE then
                acc         <= (others => (others => '0'));
                pixel_reg   <= (others => '0');
                mac_counter <= 0;
                acc_done    <= '0';

            else
                acc_done <= '0';  --! Remise à zéro par défaut (pulse 1 cycle)

                if state = ACCUMULATE and in_data_ready = '1' then
                    -- Capture pixel courant (sortie BRAM synchrone ce cycle)
                    pixel_reg   <= in_bram_data;
                    mac_counter <= mac_counter + 1;

                    -- MAC sur pixel_reg (pixel du cycle précédent, aligné avec w[k-1])
                    -- mac_counter=1 ? pixel_reg=pixel[0], weight=w(neu,0) ?
                    -- mac_counter=k ? pixel_reg=pixel[k-1], weight=w(neu,k-1) ?
                    if mac_counter >= 1 and mac_counter <= FC_IN then
                        for neu in 0 to FC_OUT-1 loop
                            acc(neu) <= acc(neu) +
                                resize(pixel_reg *
                                    weight_cache(neu, mac_counter - 1), 40);
                        end loop;
                    end if;

                    -- Pulse acc_done quand tous les FC_IN=150 pixels sont accumulés
                    if mac_counter = FC_IN then
                        acc_done <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Stage requantification - (acc + bias) × Q_MULT >> Q_SHIFT
    --!
    --! @details Le biais est ajouté AVANT la requantification (contrairement aux
    --!          couches Conv où il est ajouté après l'adder tree mais avant la
    --!          requantification). L'accumulation est étendue à 64 bits pour
    --!          éviter l'overflow du produit (acc 40b × Q_MULT 32b = 72b max).
    --!
    --! @note    FC_ZERO_POINT = 150 (int32, non int8 !) - valeur inhabituelle
    --!          due à la calibration ONNX de la couche FC sur MNIST.
    --!          Cette valeur est ajoutée au stage_off, pas ici.
    ---------------------------------------------------------------------------
    stage_requant : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                stage_req_valid <= '0';
            else
                stage_req_valid <= acc_done;
                if acc_done = '1' then
                    for neu in 0 to FC_OUT-1 loop
                        stage_req_data(neu) <=
                            resize(shift_right(
                                resize(acc(neu) + resize(bias_cache(neu), 40), 64)
                                * resize(Q_MULT, 64),
                                Q_SHIFT), 32);
                    end loop;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Stage offset - ajout du zero-point FC_ZERO_POINT
    --!
    --! @details FC_ZERO_POINT = 150 (défini comme int8 dans le générique mais
    --!          utilisé comme int32 ici via resize). Cette valeur décale la
    --!          distribution de sortie pour compenser le zero-point ONNX de
    --!          la couche FC calibrée sur MNIST.
    ---------------------------------------------------------------------------
    stage_offset : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                stage_off_valid <= '0';
            else
                stage_off_valid <= stage_req_valid;
                if stage_req_valid = '1' then
                    for neu in 0 to FC_OUT-1 loop
                        stage_off_data(neu) <=
                            stage_req_data(neu) + resize(Q_ZERO_POINT, 32);
                    end loop;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Stage saturation int8 - clamp [-128, 127]
    --!
    --! @details Identique aux stages de saturation des couches Conv.
    --!          Traite les FC_OUT=10 neurones simultanément en un cycle.
    ---------------------------------------------------------------------------
    stage_saturation : process(clk)
        variable sat_val : int8;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                stage_sat_valid <= '0';
            else
                stage_sat_valid <= stage_off_valid;
                if stage_off_valid = '1' then
                    for neu in 0 to FC_OUT-1 loop
                        if stage_off_data(neu) > INT8_MAX_VAL then
                            sat_val := resize(INT8_MAX_VAL, 8);
                        elsif stage_off_data(neu) < INT8_MIN_VAL then
                            sat_val := resize(INT8_MIN_VAL, 8);
                        else
                            sat_val := resize(stage_off_data(neu), 8);
                        end if;
                        stage_sat_data(neu) <= sat_val;
                    end loop;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Stage sortie - ReLU optionnel
    --!
    --! @details USE_RELU=false pour la couche FC finale : les logits bruts
    --!          (valeurs signées représentant les scores de classification)
    --!          sont propagés tels quels. La classe prédite est déterminée
    --!          par argmax(out_data) dans le Processing System ARM.
    --!
    --! @note    USE_RELU=true est disponible pour des variantes de réseau
    --!          avec couches FC cachées (ex: FC?ReLU?FC).
    ---------------------------------------------------------------------------
    stage_output : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                stage_out_valid <= '0';
            else
                stage_out_valid <= stage_sat_valid;
                if stage_sat_valid = '1' then
                    for neu in 0 to FC_OUT-1 loop
                        if USE_RELU then
                            if stage_sat_data(neu) < to_signed(0, 8) then
                                stage_out_data(neu) <= to_signed(0, 8);
                            else
                                stage_out_data(neu) <= stage_sat_data(neu);
                            end if;
                        else
                            stage_out_data(neu) <= stage_sat_data(neu);
                        end if;
                    end loop;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Registre de sortie final - out_data + out_valid
    --!
    --! @details out_valid est un pulse d'1 cycle (out_valid='0' sinon).
    --!          out_data contient les FC_OUT=10 logits int8 valides ce cycle.
    --!          La FSM principale détecte stage_out_valid pour transitionner
    --!          vers DONE_STATE (out_reg est transparent pour la FSM).
    ---------------------------------------------------------------------------
    out_reg : process(clk)
    begin
        if rising_edge(clk) then
            if stage_out_valid = '1' then
                for neu in 0 to FC_OUT-1 loop
                    out_data(neu) <= stage_out_data(neu);
                end loop;
                out_valid <= '1';
            else
                out_valid <= '0';
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief FSM principale - contrôle du flot d'exécution
    --!
    --! @details in_data_ready est piloté ICI SEULEMENT (correction #2).
    --!          acc_done est piloté dans mac_proc (séparation des responsabilités).
    --!          pixel_counter avance input_addr_int et coupe in_data_ready
    --!          après FC_IN=150 cycles de lecture.
    --!
    --! @note    La transition ACCUMULATE ? COMPUTE_OUTPUT intervient quand
    --!          pixel_counter = FC_IN, soit 1 cycle APRÈS que mac_proc ait
    --!          lu le dernier pixel (pixel_counter=FC_IN ? mac_counter=FC_IN
    --!          au cycle suivant ? acc_done='1'). La FSM n'attend pas acc_done
    --!          mais stage_out_valid (fin du pipeline post-accumulation, 4 cycles
    --!          après acc_done).
    ---------------------------------------------------------------------------
    main_controller : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state           <= IDLE;
                done            <= '0';
                weight_load_idx <= 0;
                pixel_counter   <= 0;
                input_addr_int  <= 0;
                in_data_ready   <= '0';
            else
                case state is

                    --! @brief IDLE : réinitialisation et attente de start
                    when IDLE =>
                        done            <= '0';
                        pixel_counter   <= 0;
                        in_data_ready   <= '0';
                        weight_load_idx <= 0;
                        if start = '1' then
                            state <= LOAD_WEIGHTS;
                        end if;

                    --! @brief LOAD_WEIGHTS : chargement 1500 poids + 10 biais
                    --! Durée totale = W_TOTAL + FC_OUT + 2 + 1 = 1513 cycles
                    when LOAD_WEIGHTS =>
                        if weight_load_idx = W_TOTAL + FC_OUT + 2 then
                            weight_load_idx <= 0;
                            input_addr_int  <= 0;
                            pixel_counter   <= 0;
                            in_data_ready   <= '1';
                            state           <= ACCUMULATE;
                        else
                            weight_load_idx <= weight_load_idx + 1;
                        end if;

                    --! @brief ACCUMULATE : lecture séquentielle des FC_IN=150 pixels
                    --! in_data_ready coupé après FC_IN cycles (pixel_counter=FC_IN)
                    --! mac_proc accumule 1 cycle de plus grâce à pixel_reg
                    when ACCUMULATE =>
                        if in_data_ready = '1' then
                            if input_addr_int < FC_IN - 1 then
                                input_addr_int <= input_addr_int + 1;
                            end if;
                            pixel_counter <= pixel_counter + 1;

                            -- Couper in_data_ready après FC_IN pixels envoyés
                            -- mac_proc accumule encore 1 cycle (mac_counter=FC_IN)
                            if pixel_counter = FC_IN then
                                in_data_ready <= '0';
                                state         <= COMPUTE_OUTPUT;
                            end if;
                        end if;

                    --! @brief COMPUTE_OUTPUT : attente fin pipeline post-accumulation
                    --! (4 cycles : stage_req ? stage_off ? stage_sat ? stage_out)
                    when COMPUTE_OUTPUT =>
                        if stage_out_valid = '1' then
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