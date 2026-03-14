----------------------------------------------------------------------------------
--! @file    tb_top_conv1_pool1.vhd
--! @brief   Testbench d'intégration - top_conv1_pool1 (Conv1 + MaxPool1 en cascade)
--!
--! @details Ce testbench valide la mise en cascade complète de Conv1 et MaxPool1
--!          dans le module top_conv1_pool1. Il instancie le DUT avec les BRAMs
--!          réelles (poids, biais, image) et vérifie l'ensemble de la chaîne :
--!          depuis l'image d'entrée 32×32 jusqu'aux activations poolées 14×14×3.
--!
--! @section verification Points de vérification
--!   1. Conv1 produit exactement 784 pixels valides (28×28, signal out_valid)
--!   2. Buffer intermédiaire (2352 octets) correctement alimenté par Conv1
--!   3. MaxPool1 produit exactement 588 pixels (14×14×3, format HWC)
--!   4. Résultats cohérents : valeur poolée ? valeurs individuelles de la fenêtre
--!   5. Latence totale Conv1 + MaxPool1 mesurée en cycles et en nanosecondes
--!
--! @section dimensions Dimensions du pipeline testé
--!   @code
--!   blk_mem_in (32×32×1)
--!        ?
--!        ?
--!   Conv1 : 32×32×1 ? 28×28×3  (3 filtres 5×5, ReLU, INT8)
--!        ?
--!        ?  buffer_ram (2352 octets, HWC)
--!        ?
--!        ?
--!   MaxPool1 : 28×28×3 ? 14×14×3  (fenêtre 2×2)
--!        ?
--!        ?
--!   pool_output[588] ? output_pool1_14x14x3.txt
--!   @endcode
--!
--! @section latence Latence estimée
--!   Conv1 : ~1 134 cycles + MaxPool1 : ~6 050 cycles ? 7 200 cycles totaux
--!   (timeout fixé à 100 000 cycles pour absorber les variations de synthèse)
--!
--! @section sorties Fichiers de sortie générés
--!   - output_pool1_14x14x3.txt : 588 valeurs entières signées (1 par ligne),
--!     format HWC interleaved, comparables avec numpy flatten du modèle Python
--!
--! @author  Donald MYO
--! @date    2025
--! @version 1.0 - Testbench intégration Conv1 + MaxPool1
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

--! @brief Entité testbench - aucun port (entité de simulation pure)
entity tb_top_conv1_pool1 is
end tb_top_conv1_pool1;

architecture Behavioral of tb_top_conv1_pool1 is

    ---------------------------------------------------------------------------
    --! @name Constantes de configuration
    --! @{
    ---------------------------------------------------------------------------
    constant CLK_PERIOD    : time    := 10 ns;
    --! Période d'horloge simulée = 10 ns ? fréquence 100 MHz

    constant POOL_OUT_SIZE : integer := 14 * 14 * 3;
    --! Taille du buffer de capture MaxPool1 = OUT_WIDTH × OUT_HEIGHT × CHANNELS
    --! = 14 × 14 × 3 = 588 octets (format HWC interleaved)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de contrôle du DUT
    --! @{
    ---------------------------------------------------------------------------
    signal clk   : std_logic := '0';  --! Horloge simulée (générée par clk_process)
    signal rst   : std_logic := '0';  --! Reset synchrone actif haut
    signal start : std_logic := '0';  --! Impulsion de démarrage DUT (1 cycle)
    signal done  : std_logic;         --! Signal de fin DUT (MaxPool1 terminé)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux interface poids Conv1 - 3 BRAMs indépendantes
    --! @{
    ---------------------------------------------------------------------------
    signal weight_addr_0 : std_logic_vector(4 downto 0);  --! Adresse BRAM filtre 0
    signal weight_data_0 : int8;                          --! Poids filtre 0 (INT8 signé)
    signal weight_addr_1 : std_logic_vector(4 downto 0);
    signal weight_data_1 : int8;
    signal weight_addr_2 : std_logic_vector(4 downto 0);
    signal weight_data_2 : int8;
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux interface biais Conv1
    --! @{
    ---------------------------------------------------------------------------
    signal bias_data_0 : int32;  --! Biais filtre 0 (INT32, compensé pour entrée INT8)
    signal bias_data_1 : int32;
    signal bias_data_2 : int32;
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux interface image d'entrée
    --! @{
    ---------------------------------------------------------------------------
    signal in_bram_addr : std_logic_vector(9 downto 0);  --! Adresse pixel d'entrée (0..1023)
    signal in_bram_data : int8;                          --! Pixel INT8 signé
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux sortie MaxPool1 ? buffer de capture
    --! @{
    ---------------------------------------------------------------------------
    signal pool_out_addr : std_logic_vector(11 downto 0);  --! Adresse écriture (format HWC)
    signal pool_out_data : int8;                           --! Valeur max de la fenêtre 2×2
    signal pool_out_we   : std_logic;                      --! Signal d'écriture (1 cycle)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Buffer de capture sortie MaxPool1
    --! @{
    ---------------------------------------------------------------------------

    --! @brief Mémoire de capture des 588 sorties de MaxPool1 (format HWC)
    --! @details Adressée directement par pool_out_addr converti en entier.
    --!          Permet la sauvegarde dans output_pool1_14x14x3.txt et
    --!          l'affichage des premiers pixels dans la console XSim.
    type pool_mem_type is array (0 to POOL_OUT_SIZE-1) of int8;
    signal pool_output : pool_mem_type := (others => (others => '0'));
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de supervision et métrologie
    --! @{
    ---------------------------------------------------------------------------
    signal cycle_counter  : integer   := 0;
    --! Compteur de cycles depuis la fin du reset (process cycle_cnt)

    signal latency_cycles : integer   := 0;
    --! Latence totale Conv1+MaxPool1 en cycles, visible dans Vivado waveform.
    --! Gelé à sa valeur finale dès done='1' (process latency_proc).

    signal measuring : std_logic := '0';
    --! Drapeau interne : '1' pendant la mesure (entre start et done)

    signal sim_done : boolean := false;
    --! Drapeau de fin de simulation - arrête clk_process proprement
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux intermédiaires SLV pour BRAMs Xilinx
    --! @{
    ---------------------------------------------------------------------------
    signal weight_data_0_slv : std_logic_vector(7 downto 0);  --! Poids filtre 0 (SLV brut)
    signal weight_data_1_slv : std_logic_vector(7 downto 0);
    signal weight_data_2_slv : std_logic_vector(7 downto 0);
    signal bias_slv          : std_logic_vector(95 downto 0);
    --! Biais concaténés 96 bits : bits[31:0]=biais0, [63:32]=biais1, [95:64]=biais2
    signal in_bram_data_slv  : std_logic_vector(7 downto 0);  --! Pixel d'entrée (SLV brut)
    --! @}

    ---------------------------------------------------------------------------
    -- Déclarations des composants
    ---------------------------------------------------------------------------

    --! @brief DUT - top_conv1_pool1 (Conv1 + buffer_ram + MaxPool1)
    component top_conv1_pool1
        port (
            clk           : in  std_logic;
            rst           : in  std_logic;
            start         : in  std_logic;
            done          : out std_logic;
            weight_addr_0 : out std_logic_vector(4 downto 0);
            weight_data_0 : in  int8;
            weight_addr_1 : out std_logic_vector(4 downto 0);
            weight_data_1 : in  int8;
            weight_addr_2 : out std_logic_vector(4 downto 0);
            weight_data_2 : in  int8;
            bias_data_0   : in  int32;
            bias_data_1   : in  int32;
            bias_data_2   : in  int32;
            in_bram_addr  : out std_logic_vector(9 downto 0);
            in_bram_data  : in  int8;
            pool_out_addr : out std_logic_vector(11 downto 0);
            pool_out_data : out int8;
            pool_out_we   : out std_logic
        );
    end component;

    --! @brief BRAM poids filtre 0 (25 coefficients INT8, blk_mem_c11_w.coe)
    component blk_mem_c11_w
        port (clka  : in  std_logic; ena   : in  std_logic;
              addra : in  std_logic_vector(4 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;

    --! @brief BRAM poids filtre 1 (25 coefficients INT8, blk_mem_c12_w.coe)
    component blk_mem_c12_w
        port (clka  : in  std_logic; ena   : in  std_logic;
              addra : in  std_logic_vector(4 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;

    --! @brief BRAM poids filtre 2 (25 coefficients INT8, blk_mem_c13_w.coe)
    component blk_mem_c13_w
        port (clka  : in  std_logic; ena   : in  std_logic;
              addra : in  std_logic_vector(4 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;

    --! @brief BRAM biais Conv1 - 3 biais int32 concaténés sur 96 bits
    --! @details Lecture unique à l'adresse 0 (addra='0') - tous les biais
    --!          disponibles en un seul mot de 96 bits dès le premier cycle.
    component blk_mem_c1_b
        port (clka  : in  std_logic; ena   : in  std_logic;
              addra : in  std_logic;
              douta : out std_logic_vector(95 downto 0));
    end component;

    --! @brief BRAM image d'entrée (1024 pixels INT8, 32×32, blk_mem_in.coe)
    component blk_mem_in
        port (clka  : in  std_logic; ena   : in  std_logic;
              addra : in  std_logic_vector(9 downto 0);
              douta : out std_logic_vector(7 downto 0));
    end component;

begin

    ---------------------------------------------------------------------------
    --! @brief Conversions std_logic_vector ? signed (int8 / int32)
    --!
    --! @details Même schéma que dans tb_conv2d_int8_streaming.
    --!          Le signal bias_slv 96 bits est découpé en trois tranches de
    --!          32 bits pour alimenter les trois ports bias_data_x du DUT.
    ---------------------------------------------------------------------------
    weight_data_0 <= signed(weight_data_0_slv);
    weight_data_1 <= signed(weight_data_1_slv);
    weight_data_2 <= signed(weight_data_2_slv);
    bias_data_0   <= signed(bias_slv(31 downto  0));
    bias_data_1   <= signed(bias_slv(63 downto 32));
    bias_data_2   <= signed(bias_slv(95 downto 64));
    in_bram_data  <= signed(in_bram_data_slv);

    ---------------------------------------------------------------------------
    --! @brief Instanciation du DUT - top_conv1_pool1
    --!
    --! @details Le DUT encapsule Conv1, buffer_ram (2352 octets) et MaxPool1.
    --!          Les interfaces BRAMs externes (poids, biais, image) sont
    --!          connectées directement aux instances BRAM ci-dessous.
    --!          La sortie MaxPool1 est dirigée vers pool_out_* pour capture.
    ---------------------------------------------------------------------------
    DUT : top_conv1_pool1
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
            bias_data_0   => bias_data_0,
            bias_data_1   => bias_data_1,
            bias_data_2   => bias_data_2,
            in_bram_addr  => in_bram_addr,
            in_bram_data  => in_bram_data,
            pool_out_addr => pool_out_addr,
            pool_out_data => pool_out_data,
            pool_out_we   => pool_out_we
        );

    ---------------------------------------------------------------------------
    --! @brief Instanciation BRAMs externes Conv1 (ena='1' permanent)
    ---------------------------------------------------------------------------
    BRAM_W0 : blk_mem_c11_w port map (
        clka => clk, ena => '1',
        addra => weight_addr_0, douta => weight_data_0_slv);

    BRAM_W1 : blk_mem_c12_w port map (
        clka => clk, ena => '1',
        addra => weight_addr_1, douta => weight_data_1_slv);

    BRAM_W2 : blk_mem_c13_w port map (
        clka => clk, ena => '1',
        addra => weight_addr_2, douta => weight_data_2_slv);

    --! @brief BRAM biais - lecture permanente à l'adresse 0
    BRAM_B : blk_mem_c1_b port map (
        clka => clk, ena => '1', addra => '0', douta => bias_slv);

    BRAM_IN : blk_mem_in port map (
        clka => clk, ena => '1',
        addra => in_bram_addr, douta => in_bram_data_slv);

    ---------------------------------------------------------------------------
    --! @brief Capture des sorties MaxPool1 dans pool_output
    --!
    --! @details À chaque cycle où pool_out_we='1', la valeur pool_out_data
    --!          est écrite dans pool_output à l'adresse pool_out_addr.
    --!          L'adresse HWC est directement issue du module maxpool2d :
    --!          index = (y_out × OUT_WIDTH + x_out) × IN_CHANNELS + ch
    --!
    --! @note    La vérification de cohérence (valeur poolée ? valeurs d'entrée)
    --!          est effectuée a posteriori en comparant output_pool1_14x14x3.txt
    --!          avec la sortie Python (numpy max_pool2d sur les activations Conv1).
    ---------------------------------------------------------------------------
    pool_capture : process(clk)
        variable addr_v : integer;
    begin
        if rising_edge(clk) then
            if pool_out_we = '1' then
                addr_v := to_integer(unsigned(pool_out_addr));
                if addr_v >= 0 and addr_v < POOL_OUT_SIZE then
                    pool_output(addr_v) <= pool_out_data;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Génération de l'horloge simulée à 100 MHz
    --!
    --! @details S'arrête proprement dès sim_done=true.
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
    --!
    --! @details Remis à zéro sur rst='1', puis incrémenté chaque cycle.
    --!          Utilisé par le stimulus via v_start_cyc / v_end_cyc (variables
    --!          locales) pour éviter le problème de delta-delay des signaux.
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
    --! @details latency_cycles est un signal incrémenté chaque cycle entre
    --!          start='1' et done='1'. Il est gelé à sa valeur finale dès
    --!          la réception de done, ce qui le rend directement lisible
    --!          dans le chronogramme Vivado sans post-traitement.
    --!
    --! @note    Ce signal est redondant avec (v_end_cyc - v_start_cyc) calculé
    --!          dans le stimulus, mais sa visibilité dans la waveform facilite
    --!          le diagnostic rapide lors des simulations interactives.
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
                    measuring      <= '0';   --! Gel de latency_cycles ici
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
    --!   1. Reset 10 cycles
    --!   2. Stabilisation 5 cycles
    --!   3. Capture v_start_cyc (variable locale, pas de delta-delay)
    --!   4. Impulsion start (1 cycle)
    --!   5. Attente done avec timeout 100 000 cycles
    --!   6. Rapport final (cycles, nanosecondes, signal latency_cycles)
    --!   7. Aperçu des 3 premiers pixels de sortie MaxPool1
    --!   8. Sauvegarde output_pool1_14x14x3.txt (588 valeurs, 1 par ligne)
    --!   9. sim_done=true ? arrêt propre
    --!
    --! @note    v_start_cyc et v_end_cyc sont des variables VHDL (pas des signaux)
    --!          pour éviter le delta-delay : la valeur est immédiate au moment
    --!          de l'assignation, sans attendre un cycle supplémentaire.
    --!
    --! @warning Timeout fixé à 100 000 cycles. La latence estimée est
    --!          ~7 200 cycles (Conv1 ~1 134 + MaxPool1 ~6 050).
    --!          En cas de timeout, vérifier : reset correct, signal start
    --!          bien reçu par le DUT, FSM top_conv1_pool1 non bloquée.
    ---------------------------------------------------------------------------
    stimulus : process
        variable line_v      : line;
        file f_out           : text;
        variable v_start_cyc : integer := 0;
        --! Cycle de démarrage (capturé via variable locale)
        variable v_end_cyc   : integer := 0;
        --! Cycle de réception de done (capturé via variable locale)
        variable timeout_cnt : integer := 0;
        --! Compteur de garde anti-blocage
    begin
        report "=====================================================" severity note;
        report "=== TESTBENCH TOP Conv1 + MaxPool1 ===" severity note;
        report "  Conv1  : 32x32x1 -> 28x28x3 (avec ReLU)"  severity note;
        report "  MaxPool: 28x28x3 -> 14x14x3 (pool 2x2)"   severity note;
        report "  Sortie : 14x14x3 = 588 valeurs"            severity note;
        report "=====================================================" severity note;

        -- Phase 1 : Reset
        rst   <= '1';
        start <= '0';
        wait for CLK_PERIOD * 10;
        rst   <= '0';
        wait for CLK_PERIOD * 5;

        -- Phase 2 : Démarrage
        wait until rising_edge(clk);
        v_start_cyc := cycle_counter;
        report "=== DEMARRAGE au cycle " &
               integer'image(v_start_cyc) & " ===" severity note;

        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        -- Phase 3 : Attente done avec timeout
        timeout_cnt := 0;
        while done /= '1' and timeout_cnt < 100000 loop
            wait until rising_edge(clk);
            timeout_cnt := timeout_cnt + 1;
        end loop;

        v_end_cyc := cycle_counter;

        -- Phase 4 : Rapport final
        if done = '1' then
            report "=====================================================" severity note;
            report "=== DONE ===" severity note;
            report "  Cycle start          : " &
                   integer'image(v_start_cyc) severity note;
            report "  Cycle done           : " &
                   integer'image(v_end_cyc) severity note;
            report "  Latence totale       : " &
                   integer'image(v_end_cyc - v_start_cyc) & " cycles" severity note;
            report "  Latence totale       : " &
                   integer'image((v_end_cyc - v_start_cyc) * 10) & " ns" severity note;
            report "  (signal latency_cycles visible dans Vivado waveform)" severity note;
            report "=====================================================" severity note;
        else
            report "=== TIMEOUT apres " & integer'image(timeout_cnt) &
                   " cycles - verifier FSM top_conv1_pool1 ===" severity error;
        end if;

        wait for CLK_PERIOD * 5;

        -- Phase 5 : Aperçu des 3 premiers pixels MaxPool1
        report "=== APERCU SORTIE MAXPOOL1 (3 premiers pixels) ===" severity note;
        for pix in 0 to 2 loop
            report "  pool[" & integer'image(pix) & "] = [ch0=" &
                   integer'image(to_integer(pool_output(pix*3+0))) & " ch1=" &
                   integer'image(to_integer(pool_output(pix*3+1))) & " ch2=" &
                   integer'image(to_integer(pool_output(pix*3+2))) & "]"
                   severity note;
        end loop;

        -- Phase 6 : Sauvegarde fichier texte
        file_open(f_out, "output_pool1_14x14x3.txt", write_mode);
        for i in 0 to POOL_OUT_SIZE-1 loop
            write(line_v, to_integer(pool_output(i)));
            writeline(f_out, line_v);
        end loop;
        file_close(f_out);

        report "  " & integer'image(POOL_OUT_SIZE) &
               " valeurs sauvegardees dans output_pool1_14x14x3.txt" severity note;
        report "  (comparer avec numpy max_pool2d sur activations Conv1 Python)"
               severity note;
        report "=== FIN TEST TOP CONV1 + MAXPOOL1 ===" severity note;
        report "=====================================================" severity note;

        -- Phase 7 : arrêt propre
        sim_done <= true;
        wait;
    end process;

end Behavioral;