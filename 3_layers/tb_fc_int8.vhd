----------------------------------------------------------------------------------
--! @file    tb_fc_int8.vhd
--! @brief   Testbench de validation - fc_int8 (couche Fully Connected 150?10)
--!
--! @details Ce testbench valide le comportement fonctionnel du module fc_int8,
--!          couche finale du pipeline LeNet-5 modifié. Il lit les activations
--!          de sortie de MaxPool2 depuis output_pool2_5x5x6.txt (150 valeurs int8),
--!          instancie les BRAMs réelles de poids et biais FC, et affiche dans la
--!          console XSim les 10 logits de sortie ainsi que la classe prédite
--!          (argmax des logits).
--!
--! @section configuration Configuration du DUT
--!   - Entrée  : 150 activations INT8 (sortie aplatie MaxPool2, 5×5×6)
--!   - Sortie  : 10 logits INT8 (classes MNIST 0..9)
--!   - Poids   : blk_mem_fc_w (1500 coefficients INT8, addr 11 bits, depth=2048)
--!   - Biais   : blk_mem_fc_b (10 biais INT32, addr 4 bits, depth=16)
--!   - Paramètres : FC_MULT, FC_SHIFT, FC_ZERO_POINT=150 (int32)
--!   - USE_RELU=false (logits bruts pour argmax)
--!
--! @section rom ROM d'entrée (simulation buffer4)
--!   La mémoire d'entrée est simulée par une ROM VHDL pure (POOL2_ROM) chargée
--!   à l'élaboration depuis output_pool2_5x5x6.txt via init_rom().
--!   Une ROM synchrone (process rom_pool2_proc, latence 1 cycle) émule le
--!   comportement de buffer4 (BRAM Xilinx, identique à blk_mem_in dans Conv1).
--!
--! @section sortie Sortie console XSim
--!   @code
--!   logit[0] = XX   (classe 0 : chiffre "0")
--!   logit[1] = XX
--!   ...
--!   logit[9] = XX   (classe 9 : chiffre "9")
--!   CLASSE PREDITE : N  (logit=XX)
--!   @endcode
--!   La classe prédite est déterminée par argmax(out_data[0..9]) calculé
--!   dans le process stimulus (variables locales best_class, best_val).
--!
--! @section chaine Chaîne de validation complète
--!   Ce testbench est le maillon final de la chaîne de validation :
--!   @code
--!   tb_conv2d_int8       ? output_conv1_streaming.txt
--!   tb_top_conv1_pool1   ? output_pool1_14x14x3.txt
--!   tb_conv2d_int8_c2    ? output_conv2_streaming.txt
--!   tb_top_conv2_pool2   ? output_pool2_5x5x6.txt   ? entrée de ce TB
--!   tb_fc_int8           ? console (logits + classe)  ? ce TB
--!   @endcode
--!
--! @section latence Latence estimée
--!   LOAD_WEIGHTS : ~1513 cycles (1500 poids + 12 cycles biais)
--!   ACCUMULATE   : ~152 cycles (150 pixels + 2 cycles latence)
--!   Pipeline     : ~4 cycles (req ? off ? sat ? out)
--!   Total        : ~1 669 cycles (~16,7 µs à 100 MHz)
--!
--! @author  Donald MYO
--! @date    2025
--! @version 1.0 - ROM Pool2, BRAMs FC réelles, affichage logits + argmax
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

--! @brief Entité testbench - aucun port (entité de simulation pure)
entity tb_fc_int8 is
end tb_fc_int8;

architecture Behavioral of tb_fc_int8 is

    ---------------------------------------------------------------------------
    --! @name Constantes de configuration
    --! @{
    ---------------------------------------------------------------------------
    constant CLK_PERIOD : time    := 10 ns;
    --! Période d'horloge simulée = 10 ns ? fréquence 100 MHz

    constant FC_IN_N  : integer := 150;
    --! Nombre d'entrées FC = 6×5×5 = 150 (sortie aplatie MaxPool2)

    constant FC_OUT_N : integer := 10;
    --! Nombre de neurones de sortie = 10 classes MNIST (chiffres 0..9)
    --! @}

    ---------------------------------------------------------------------------
    --! @name ROM d'entrée - simulation de buffer4 (sortie MaxPool2)
    --! @{
    ---------------------------------------------------------------------------

    --! @brief Type tableau ROM : FC_IN_N=150 entrées int8
    type rom_type is array (0 to FC_IN_N-1) of int8;

    ---------------------------------------------------------------------------
    --! @brief Procédure de lecture d'un entier signé depuis une ligne textio
    --!
    --! @details Identique à tb_conv2d_int8_streaming_c2 et tb_top_conv1_pool1.
    --!          Gère espaces, tabulations, signe négatif et chiffres successifs.
    --!
    --! @param l      Ligne textio en entrée/sortie
    --! @param result Entier signé résultant
    ---------------------------------------------------------------------------
    procedure read_signed_int(l      : inout line;
                               result : out   integer) is
        variable c      : character;
        variable is_neg : boolean := false;
        variable val    : integer := 0;
        variable good   : boolean;
    begin
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
    --! @details Appelée une seule fois à l'élaboration. Lit FC_IN_N=150 lignes
    --!          de output_pool2_5x5x6.txt, convertit chaque valeur en int8
    --!          avec saturation [-128, 127].
    --!
    --! @param filename Chemin du fichier texte (relatif au répertoire XSim)
    --! @return ROM initialisée avec les 150 activations de sortie MaxPool2
    --!
    --! @note    Le fichier doit être généré au préalable par tb_top_conv2_pool2.
    --!          Si le fichier est absent, XSim lève une erreur à l'élaboration.
    ---------------------------------------------------------------------------
    impure function init_rom(filename : string) return rom_type is
        file     f   : text;
        variable l   : line;
        variable val : integer;
        variable mem : rom_type := (others => (others => '0'));
    begin
        file_open(f, filename, read_mode);
        for i in 0 to FC_IN_N-1 loop
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

    --! @brief ROM constante chargée à l'élaboration depuis output_pool2_5x5x6.txt
    --! @details 150 valeurs int8 représentant les activations aplaties de MaxPool2.
    --!          Immutable après élaboration - accès en lecture seule pendant la sim.
    constant POOL2_ROM : rom_type := init_rom("output_pool2_5x5x6.txt");
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de contrôle du DUT
    --! @{
    ---------------------------------------------------------------------------
    signal clk   : std_logic := '0';  --! Horloge simulée (100 MHz)
    signal rst   : std_logic := '0';  --! Reset synchrone actif haut
    signal start : std_logic := '0';  --! Impulsion de démarrage (1 cycle)
    signal done  : std_logic;         --! Fin du DUT (logits disponibles sur out_data)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux interface poids FC
    --! @{
    ---------------------------------------------------------------------------
    signal weight_addr : std_logic_vector(10 downto 0);
    --! Adresse BRAM poids (0..1499 en phase chargement, gelée à 0 ensuite)

    signal weight_data : int8;
    --! Poids INT8 signé lu depuis blk_mem_fc_w
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux interface biais FC
    --! @{
    ---------------------------------------------------------------------------
    signal bias_addr : std_logic_vector(3 downto 0);
    --! Adresse BRAM biais (0..9)

    signal bias_data : int32;
    --! Biais INT32 signé lu depuis blk_mem_fc_b
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux interface mémoire d'entrée (ROM Pool2)
    --! @{
    ---------------------------------------------------------------------------
    signal in_bram_addr : std_logic_vector(7 downto 0);
    --! Adresse lecture ROM Pool2 (0..149, produite par le DUT)

    signal in_bram_data : int8;
    --! Donnée lue depuis POOL2_ROM avec 1 cycle de latence (process rom_pool2_proc)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de sortie FC
    --! @{
    ---------------------------------------------------------------------------
    signal out_data : int8_vector(0 to FC_OUT_N-1);
    --! Vecteur des FC_OUT_N=10 logits int8 (valides quand out_valid='1')
    --! Index neu correspond à la classe MNIST chiffre neu

    signal out_valid : std_logic;
    --! Pulse 1 cycle - logits disponibles sur out_data
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux intermédiaires SLV pour BRAMs Xilinx
    --! @{
    ---------------------------------------------------------------------------
    signal weight_data_slv : std_logic_vector(7 downto 0);
    --! Poids brut BRAM (SLV), converti en int8 signé par assignation concurrente

    signal bias_data_slv : std_logic_vector(31 downto 0);
    --! Biais brut BRAM (SLV 32b), converti en int32 signé
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de supervision et métrologie
    --! @{
    ---------------------------------------------------------------------------
    signal cycle_counter : integer := 0;
    --! Compteur de cycles depuis la fin du reset

    signal latency_cycles : integer := 0;
    --! Latence totale FC en cycles, visible dans Vivado waveform (gelé à done)

    signal measuring : std_logic := '0';
    --! Drapeau interne : '1' pendant la mesure (entre start et done)

    signal sim_done : boolean := false;
    --! Drapeau de fin de simulation - arrête clk_process proprement
    --! @}

    ---------------------------------------------------------------------------
    -- Déclarations des composants
    ---------------------------------------------------------------------------

    --! @brief DUT - fc_int8 (Fully Connected 150?10, USE_RELU=false)
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

    --! @brief BRAM poids FC - 1500 coefficients INT8 (blk_mem_fc_w.coe, addr 11b)
    --! @details depth=2048 (puissance de 2 ? 1500), plage valide 0..1499.
    --!          L'adresse est gelée à 0 par fc_int8 dès weight_load_idx ? W_TOTAL.
    component blk_mem_fc_w
        port (
            clka  : in  std_logic;
            ena   : in  std_logic;
            addra : in  std_logic_vector(10 downto 0);
            douta : out std_logic_vector(7 downto 0)
        );
    end component;

    --! @brief BRAM biais FC - 10 biais INT32 (blk_mem_fc_b.coe, addr 4b)
    --! @details depth=16, données 32 bits, plage valide 0..9.
    --!          Chaque adresse contient un biais int32 pour un neurone de sortie.
    component blk_mem_fc_b
        port (
            clka  : in  std_logic;
            ena   : in  std_logic;
            addra : in  std_logic_vector(3 downto 0);
            douta : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    ---------------------------------------------------------------------------
    --! @brief Conversions std_logic_vector ? signed (int8 / int32)
    --!
    --! @details Même pattern que les autres testbenches de la chaîne.
    --!          weight_data_slv (8b) ? int8, bias_data_slv (32b) ? int32.
    ---------------------------------------------------------------------------
    weight_data <= signed(weight_data_slv);
    bias_data   <= signed(bias_data_slv);

    ---------------------------------------------------------------------------
    --! @brief Instanciation du DUT - fc_int8 (USE_RELU=false)
    --!
    --! @details Paramètres de quantification issus de lenet_qparams_pkg :
    --!   FC_MULT=1 342 110, FC_SHIFT=30, FC_ZERO_POINT=150 (int32 !)
    --!
    --! @note    FC_ZERO_POINT=150 est une valeur inhabituellement élevée
    --!          (non représentable en int8 standard) due à la calibration ONNX
    --!          de la couche FC sur MNIST avec un zero-point de sortie non nul.
    ---------------------------------------------------------------------------
    DUT : fc_int8
        generic map (
            FC_IN        => FC_IN_N,
            FC_OUT       => FC_OUT_N,
            Q_MULT       => FC_MULT,
            Q_SHIFT      => FC_SHIFT,
            Q_ZERO_POINT => FC_ZERO_POINT,
            USE_RELU     => false
        )
        port map (
            clk          => clk,
            rst          => rst,
            start        => start,
            done         => done,
            weight_addr  => weight_addr,
            weight_data  => weight_data,
            bias_addr    => bias_addr,
            bias_data    => bias_data,
            in_bram_addr => in_bram_addr,
            in_bram_data => in_bram_data,
            out_data     => out_data,
            out_valid    => out_valid
        );

    ---------------------------------------------------------------------------
    --! @brief BRAM poids FC (ena='1' permanent, addr 11 bits)
    ---------------------------------------------------------------------------
    BRAM_FC_W : blk_mem_fc_w
        port map (
            clka  => clk,
            ena   => '1',
            addra => weight_addr,
            douta => weight_data_slv
        );

    ---------------------------------------------------------------------------
    --! @brief BRAM biais FC (ena='1' permanent, addr 4 bits)
    ---------------------------------------------------------------------------
    BRAM_FC_B : blk_mem_fc_b
        port map (
            clka  => clk,
            ena   => '1',
            addra => bias_addr,
            douta => bias_data_slv
        );

    ---------------------------------------------------------------------------
    --! @brief ROM Pool2 synchrone - simulation de buffer4 avec latence 1 cycle
    --!
    --! @details Émule le comportement de buffer4 (BRAM Xilinx synchrone) :
    --!          adresse posée au cycle T ? donnée disponible au cycle T+1.
    --!          Identique au process rom_proc de tb_conv2d_int8_streaming_c2.
    --!          Les accès hors-range (addr ? FC_IN_N=150) retournent 0.
    ---------------------------------------------------------------------------
    rom_pool2_proc : process(clk)
        variable addr_v : integer;
    begin
        if rising_edge(clk) then
            addr_v := to_integer(unsigned(in_bram_addr));
            if addr_v >= 0 and addr_v < FC_IN_N then
                in_bram_data <= POOL2_ROM(addr_v);
            else
                in_bram_data <= (others => '0');
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Génération de l'horloge simulée à 100 MHz
    ---------------------------------------------------------------------------
    clk_process : process
    begin
        while not sim_done loop
            clk <= '0'; wait for CLK_PERIOD / 2;
            clk <= '1'; wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Compteur de cycles depuis la fin du reset
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
    --! @brief Mesure de latence synchrone - visible dans Vivado waveform
    --!
    --! @details Identique aux testbenches précédents : latency_cycles incrémenté
    --!          entre start='1' et done='1', puis gelé. Lisible directement
    --!          dans le chronogramme Vivado sans post-traitement.
    ---------------------------------------------------------------------------
    latency_proc : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                latency_cycles <= 0;
                measuring      <= '0';
            else
                if start = '1' then
                    latency_cycles <= 0;
                    measuring      <= '1';
                elsif done = '1' and measuring = '1' then
                    latency_cycles <= latency_cycles + 1;
                    measuring      <= '0';
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
    --!   1. Affichage configuration et vérification ROM Pool2[0..5]
    --!   2. Reset 10 cycles
    --!   3. Stabilisation 5 cycles
    --!   4. Capture v_start_cyc (variable locale, pas de delta-delay)
    --!   5. Impulsion start (1 cycle)
    --!   6. Attente done avec timeout 50 000 cycles
    --!   7. Rapport final (cycles, nanosecondes, latency_cycles waveform)
    --!   8. Affichage des 10 logits dans la console XSim
    --!   9. Calcul et affichage de la classe prédite (argmax)
    --!  10. sim_done=true ? arrêt propre
    --!
    --! @note    L'argmax est calculé via les variables locales best_class et
    --!          best_val, comparant to_integer(out_data(neu)) pour chaque neurone.
    --!          Une valeur best_val initialisée à -128 garantit que même un logit
    --!          de valeur minimale int8 sera correctement sélectionné.
    --!
    --! @note    out_data est stable après out_valid='1' car le registre out_reg
    --!          de fc_int8 conserve les logits jusqu'au prochain out_valid.
    --!          La lecture est effectuée 3 cycles après done pour garantir
    --!          la propagation correcte du registre de sortie.
    --!
    --! @warning Timeout fixé à 50 000 cycles. La latence estimée est ~1 669 cycles
    --!          (LOAD_WEIGHTS ~1513 + ACCUMULATE ~152 + pipeline ~4).
    --!          En cas de timeout, vérifier : ROM correctement lue (POOL2_ROM[0..5]),
    --!          weight_addr dans range [0..1499], bias_addr dans range [0..9].
    ---------------------------------------------------------------------------
    stimulus : process
        variable v_start_cyc : integer := 0;
        --! Cycle de démarrage (variable locale, évite delta-delay)
        variable v_end_cyc   : integer := 0;
        --! Cycle de réception de done
        variable timeout_cnt : integer := 0;
        variable best_class  : integer := 0;
        --! Index du neurone ayant le logit maximal (classe prédite)
        variable best_val    : integer := -128;
        --! Valeur du logit maximal (initialisée à -128 = INT8_MIN)
        variable cur_val     : integer := 0;
        --! Valeur courante du logit examiné
    begin
        report "========================================================" severity note;
        report "=== TESTBENCH FULLY CONNECTED : 150 -> 10 ===" severity note;
        report "  Entree : output_pool2_5x5x6.txt (150 valeurs int8)" severity note;
        report "  Poids  : blk_mem_fc_w (1500 poids, 10x150)" severity note;
        report "  Biais  : blk_mem_fc_b (10 biais int32)" severity note;
        report "  Sortie : 10 logits int8 + classe predite" severity note;
        report "  Q_MULT=" & integer'image(to_integer(FC_MULT)) &
               " Q_SHIFT=30 Z_OUT=150 (int32)" severity note;
        report "========================================================" severity note;

        -- Phase 1 : Vérification ROM Pool2
        report "  ROM pool2[0..5] :" severity note;
        report "  [0]=" & integer'image(to_integer(POOL2_ROM(0))) &
               " [1]=" & integer'image(to_integer(POOL2_ROM(1))) &
               " [2]=" & integer'image(to_integer(POOL2_ROM(2))) &
               " [3]=" & integer'image(to_integer(POOL2_ROM(3))) &
               " [4]=" & integer'image(to_integer(POOL2_ROM(4))) &
               " [5]=" & integer'image(to_integer(POOL2_ROM(5))) severity note;

        -- Phase 2 : Reset
        rst   <= '1';
        start <= '0';
        wait for CLK_PERIOD * 10;
        rst   <= '0';
        wait for CLK_PERIOD * 5;

        -- Phase 3 : Démarrage
        wait until rising_edge(clk);
        v_start_cyc := cycle_counter;
        report "=== DEMARRAGE au cycle " &
               integer'image(v_start_cyc) & " ===" severity note;

        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        -- Phase 4 : Attente done avec timeout
        timeout_cnt := 0;
        while done /= '1' and timeout_cnt < 50000 loop
            wait until rising_edge(clk);
            timeout_cnt := timeout_cnt + 1;
        end loop;

        v_end_cyc := cycle_counter;

        -- Phase 5 : Rapport final
        if done = '1' then
            report "========================================================" severity note;
            report "=== DONE ===" severity note;
            report "  Cycle start    : " & integer'image(v_start_cyc) severity note;
            report "  Cycle done     : " & integer'image(v_end_cyc)   severity note;
            report "  Latence totale : " &
                   integer'image(v_end_cyc - v_start_cyc) & " cycles" severity note;
            report "  Latence totale : " &
                   integer'image((v_end_cyc - v_start_cyc) * 10) & " ns" severity note;
            report "  (signal latency_cycles visible dans Vivado waveform)" severity note;
            report "========================================================" severity note;
        else
            report "=== TIMEOUT apres 50000 cycles ===" severity error;
            report "  Verifier : POOL2_ROM[0..5], weight_addr [0..1499]," severity note;
            report "             bias_addr [0..9], FSM fc_int8 non bloquee" severity note;
        end if;

        -- Phase 6 : Attente stabilisation out_data (3 cycles après done)
        wait for CLK_PERIOD * 3;

        -- Phase 7 : Affichage des 10 logits et calcul argmax
        report "=== LOGITS FC (10 classes MNIST) ===" severity note;
        best_val   := -128;
        best_class := 0;
        for neu in 0 to FC_OUT_N-1 loop
            cur_val := to_integer(out_data(neu));
            report "  logit[" & integer'image(neu) & "] = " &
                   integer'image(cur_val) severity note;
            if cur_val > best_val then
                best_val   := cur_val;
                best_class := neu;
            end if;
        end loop;
        report "========================================================" severity note;
        report "  CLASSE PREDITE : " & integer'image(best_class) &
               "  (logit=" & integer'image(best_val) & ")" severity note;
        report "  (comparer avec numpy argmax sur logits modele Python)"
               severity note;
        report "========================================================" severity note;
        report "=== FIN TEST FC ===" severity note;

        -- Phase 8 : arrêt propre
        sim_done <= true;
        wait;
    end process;

end Behavioral;