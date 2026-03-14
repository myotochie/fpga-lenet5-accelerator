----------------------------------------------------------------------------------
--! @file    tb_top_lenet_full.vhd
--! @brief   Testbench d'intégration système - pipeline LeNet-5 modifié complet
--!
--! @details Ce testbench valide l'intégralité du pipeline d'inférence LeNet-5
--!          modifié en instanciant le module top_lenet_full comme DUT unique.
--!          Contrairement aux testbenches unitaires précédents, aucune BRAM
--!          externe ni ROM d'entrée n'est instanciée ici : toutes les BRAMs
--!          (paramètres et image) sont encapsulées dans top_lenet_full et
--!          initialisées par leurs fichiers .coe respectifs.
--!
--! @section pipeline Pipeline validé
--!   @code
--!   blk_mem_in (32×32)
--!        ?
--!        ?
--!   Conv1  : 32×32×1  ? 28×28×3   (ReLU, noyau 5×5, INT8)
--!        ?
--!        ?
--!   Pool1  : 28×28×3  ? 14×14×3   (MaxPool 2×2)
--!        ?
--!        ?
--!   Conv2  : 14×14×3  ? 10×10×6   (ReLU, noyau 5×5, INT8)
--!        ?
--!        ?
--!   Pool2  : 10×10×6  ?  5×5×6    (MaxPool 2×2)
--!        ?
--!        ?
--!   FC     : 150      ? 10         (logits INT8, USE_RELU=false)
--!        ?
--!        ?
--!   fc_out_data[0..9] ? fc_logits.txt + console
--!   @endcode
--!
--! @section brams BRAMs encapsulées dans le DUT (14 total)
--!   Le testbench n'instancie AUCUNE BRAM externe - toutes sont dans top_lenet_full :
--!   blk_mem_in, blk_mem_c11/12/13_w, blk_mem_c1_b,
--!   blk_mem_c21..c26_w, blk_mem_c2_b, blk_mem_fc_w, blk_mem_fc_b
--!
--! @section sorties Fichiers et sorties générés
--!   - Console XSim : logits[0..9], classe prédite (argmax), latence cycles+ns
--!   - fc_logits.txt : 10 valeurs int8 (1 par ligne), comparables avec Python
--!   - Signal latency_cycles : visible dans le chronogramme Vivado waveform
--!
--! @section latence Latence estimée par étage (100 MHz)
--!   | Étage  | Cycles estimés | Description                        |
--!   |--------|----------------|------------------------------------|
--!   | Conv1  |  ~1 134        | Pipeline 8 stages, 28×28 pixels    |
--!   | Pool1  |  ~6 050        | FSM 7 états, 28×28×3, KK=4         |
--!   | Conv2  |    ~830        | Pipeline 10 stages, 10×10 pixels   |
--!   | Pool2  |  ~1 690        | FSM 7 états, 10×10×6, KK=4         |
--!   | FC     |  ~1 660        | LOAD 1513 + ACC 152 + pipeline 4   |
--!   | Total  | ~11 364        | ? 114 µs                           |
--!   Timeout fixé à 250 000 cycles pour absorber les variations de synthèse.
--!
--! @section chaine Position dans la chaîne de validation
--!   Ce testbench est le test d'intégration finale - il valide le pipeline
--!   bout en bout avec les vrais paramètres .coe chargés dans les BRAMs :
--!   @code
--!   Tests unitaires   : tb_conv2d_int8, tb_maxpool2d, tb_fc_int8
--!   Tests intégration : tb_top_conv1_pool1, tb_conv2d_int8_c2
--!   Test système      : tb_top_lenet_full ? CE TESTBENCH
--!   @endcode
--!
--! @author  Donald MYO
--! @date    2025
--! @version 1.0 - Test système complet, toutes BRAMs dans DUT, fc_logits.txt
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

--! @brief Entité testbench - aucun port (entité de simulation pure)
entity tb_top_lenet_full is
end tb_top_lenet_full;

architecture Behavioral of tb_top_lenet_full is

    ---------------------------------------------------------------------------
    --! @name Constantes de configuration
    --! @{
    ---------------------------------------------------------------------------
    constant CLK_PERIOD : time    := 10 ns;
    --! Période d'horloge simulée = 10 ns ? fréquence 100 MHz

    constant FC_OUT_N : integer := 10;
    --! Nombre de classes de sortie FC = 10 (chiffres MNIST 0..9)

    constant TIMEOUT : integer := 250000;
    --! Timeout de sécurité en cycles - largement supérieur à la latence estimée
    --! (~11 364 cycles) pour absorber les variations de synthèse et de placement
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de contrôle et de sortie du DUT
    --! @{
    ---------------------------------------------------------------------------
    signal clk  : std_logic := '0';  --! Horloge simulée (100 MHz)
    signal rst  : std_logic := '0';  --! Reset synchrone actif haut
    signal start: std_logic := '0';  --! Impulsion de démarrage (1 cycle)
    signal done : std_logic;         --! Fin de l'inférence complète (FC terminée)

    signal fc_out_data  : int8_vector(0 to FC_OUT_N-1);
    --! Vecteur des 10 logits int8 - stable après fc_out_valid='1'

    signal fc_out_valid : std_logic;
    --! Pulse 1 cycle indiquant que fc_out_data contient les logits finaux
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de supervision et métrologie
    --! @{
    ---------------------------------------------------------------------------
    signal cycle_counter : integer := 0;
    --! Compteur global de cycles depuis la fin du reset

    signal latency_cycles : integer := 0;
    --! Latence totale pipeline en cycles (gelé à done='1', visible waveform Vivado)

    signal measuring : std_logic := '0';
    --! Drapeau interne : '1' entre start='1' et done='1'

    signal sim_done : boolean := false;
    --! Drapeau de fin - arrête clk_process proprement
    --! @}

    ---------------------------------------------------------------------------
    --! @brief Composant DUT - top_lenet_full (pipeline LeNet-5 complet)
    --!
    --! @details Interface minimale : clk, rst, start, done + logits FC.
    --!          Toutes les BRAMs et interconnexions sont encapsulées dans le DUT.
    ---------------------------------------------------------------------------
    component top_lenet_full
        port (
            clk          : in  std_logic;
            rst          : in  std_logic;
            start        : in  std_logic;
            done         : out std_logic;
            fc_out_data  : out int8_vector(0 to 9);
            fc_out_valid : out std_logic
        );
    end component;

begin

    ---------------------------------------------------------------------------
    --! @brief Instanciation du DUT - top_lenet_full
    --!
    --! @details Le DUT encapsule l'intégralité du pipeline :
    --!          Conv1 ? buffer1 ? MaxPool1 ? buffer2 ? Conv2 ? buffer3
    --!          ? MaxPool2 ? buffer4 ? FC ? fc_out_data.
    --!          Les 14 BRAMs de paramètres sont initialisées en interne par
    --!          leurs fichiers .coe au moment de l'élaboration XSim.
    ---------------------------------------------------------------------------
    DUT : top_lenet_full
        port map (
            clk          => clk,
            rst          => rst,
            start        => start,
            done         => done,
            fc_out_data  => fc_out_data,
            fc_out_valid => fc_out_valid
        );

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
    --! @brief Compteur de cycles global depuis la fin du reset
    --!
    --! @details Remis à zéro sur rst='1', incrémenté chaque cycle.
    --!          Utilisé par le stimulus via v_start_cyc et v_end_cyc (variables
    --!          locales) pour mesurer la latence totale sans delta-delay.
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
    --! @details latency_cycles est incrémenté chaque cycle entre start='1' et
    --!          done='1', puis gelé à sa valeur finale. Ce signal est directement
    --!          lisible dans le chronogramme Vivado sans post-traitement et
    --!          constitue la mesure de référence de la latence totale du pipeline.
    --!
    --! @note    La valeur finale de latency_cycles doit être cohérente avec
    --!          (v_end_cyc - v_start_cyc) calculé dans le stimulus.
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
                    measuring      <= '0';  --! Gel de latency_cycles ici
                elsif measuring = '1' then
                    latency_cycles <= latency_cycles + 1;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Process stimulus - séquence de test système complète
    --!
    --! @details Séquence :
    --!   1. Affichage configuration complète du pipeline
    --!   2. Reset 10 cycles
    --!   3. Stabilisation 5 cycles (BRAMs Xilinx stabilisées)
    --!   4. Capture v_start_cyc (variable locale, pas de delta-delay)
    --!   5. Impulsion start (1 cycle)
    --!   6. Attente done avec rapport de progression tous les 5 000 cycles
    --!   7. Rapport final (cycles, nanosecondes, référence waveform)
    --!   8. Attente 5 cycles pour stabilisation fc_out_data
    --!   9. Affichage des 10 logits dans la console XSim
    --!  10. Calcul argmax ? classe prédite
    --!  11. Sauvegarde fc_logits.txt (10 valeurs, 1 par ligne)
    --!  12. sim_done=true ? arrêt propre
    --!
    --! @note    Le rapport de progression tous les 5 000 cycles (étape 6) permet
    --!          de suivre l'avancement dans la waveform Vivado et de détecter
    --!          un blocage de la FSM top avant le timeout.
    --!
    --! @note    fc_out_data est lu 5 cycles après done (étape 8) pour garantir
    --!          que le registre de sortie out_reg de fc_int8 est stable.
    --!          En pratique, fc_out_valid indique le cycle exact de validité,
    --!          mais done arrive légèrement après (4 cycles de propagation FSM).
    --!
    --! @note    best_val initialisé à -128 (INT8_MIN) garantit que même un logit
    --!          de valeur minimale est correctement sélectionné comme argmax.
    --!
    --! @warning Timeout fixé à 250 000 cycles. En cas de timeout, vérifier :
    --!          (1) fichiers .coe correctement associés aux BRAMs dans Vivado,
    --!          (2) signal done connecté et FSM top non bloquée,
    --!          (3) signaux done des sous-modules (conv1_done..fc_done) actifs,
    --!          (4) reset correctement propagé à tous les sous-modules.
    ---------------------------------------------------------------------------
    stimulus : process
        variable line_v      : line;
        file     f_out       : text;
        variable v_start_cyc : integer := 0;
        --! Cycle de démarrage (variable locale, évite delta-delay)
        variable v_end_cyc   : integer := 0;
        --! Cycle de réception de done
        variable timeout_cnt : integer := 0;
        variable best_class  : integer := 0;
        --! Index du neurone avec le logit maximal (classe prédite)
        variable best_val    : integer := -128;
        --! Logit maximal (initialisé à INT8_MIN = -128)
        variable cur_val     : integer := 0;
        --! Valeur courante du logit examiné
    begin
        -- Phase 1 : Bannière de configuration
        report "========================================================" severity note;
        report "=== TESTBENCH LeNet COMPLET ===" severity note;
        report "  Conv1  : 32x32x1  -> 28x28x3  (ReLU, KS=5)" severity note;
        report "  Pool1  : 28x28x3  -> 14x14x3  (MaxPool 2x2)" severity note;
        report "  Conv2  : 14x14x3  -> 10x10x6  (ReLU, KS=5)" severity note;
        report "  Pool2  : 10x10x6  ->  5x5x6   (MaxPool 2x2)" severity note;
        report "  FC     : 150      ->  10       (logits INT8)" severity note;
        report "  BRAMs  : toutes instanciees dans top_lenet_full" severity note;
        report "  Latence estimee : ~11364 cycles / ~114 us @ 100 MHz" severity note;
        report "  Timeout : " & integer'image(TIMEOUT) & " cycles" severity note;
        report "========================================================" severity note;

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

        -- Phase 4 : Attente done avec rapport de progression tous les 5 000 cycles
        timeout_cnt := 0;
        while done /= '1' and timeout_cnt < TIMEOUT loop
            wait until rising_edge(clk);
            timeout_cnt := timeout_cnt + 1;
            if timeout_cnt mod 5000 = 0 then
                report "  ... " & integer'image(timeout_cnt) &
                       " cycles ecoules ..." severity note;
            end if;
        end loop;

        v_end_cyc := cycle_counter;

        -- Phase 5 : Rapport final latence
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
            report "=== TIMEOUT apres " & integer'image(TIMEOUT) &
                   " cycles ===" severity error;
            report "  Verifier : (1) fichiers .coe associes aux BRAMs" severity error;
            report "             (2) FSM top_lenet_full non bloquee" severity error;
            report "             (3) signaux done sous-modules actifs" severity error;
            report "             (4) reset propage a tous les sous-modules" severity error;
        end if;

        -- Phase 6 : Stabilisation fc_out_data (5 cycles après done)
        wait for CLK_PERIOD * 5;

        -- Phase 7 : Affichage des 10 logits + calcul argmax
        report "========================================================" severity note;
        report "=== LOGITS FC (10 classes MNIST) ===" severity note;

        best_val   := -128;
        best_class := 0;

        for neu in 0 to FC_OUT_N-1 loop
            cur_val := to_integer(fc_out_data(neu));
            report "  logit[" & integer'image(neu) & "] = " &
                   integer'image(cur_val) severity note;
            if cur_val > best_val then
                best_val   := cur_val;
                best_class := neu;
            end if;
        end loop;

        report "========================================================" severity note;
        report "  CLASSE PREDITE : " & integer'image(best_class) &
               "  (logit = " & integer'image(best_val) & ")" severity note;
        report "  (comparer avec numpy argmax sur modele Python float32)" severity note;
        report "========================================================" severity note;

        -- Phase 8 : Sauvegarde fc_logits.txt
        file_open(f_out, "fc_logits.txt", write_mode);
        for neu in 0 to FC_OUT_N-1 loop
            write(line_v, to_integer(fc_out_data(neu)));
            writeline(f_out, line_v);
        end loop;
        file_close(f_out);

        report "  10 logits sauvegardes dans fc_logits.txt" severity note;
        report "  (comparer avec Python : logits = model(img).detach().numpy())"
               severity note;
        report "=== FIN SIMULATION ===" severity note;
        report "========================================================" severity note;

        -- Phase 9 : arrêt propre
        sim_done <= true;
        wait;
    end process;

end Behavioral;