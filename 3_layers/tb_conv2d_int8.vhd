----------------------------------------------------------------------------------
--! @file    tb_conv2d_int8_streaming.vhd
--! @brief   Testbench de validation - conv2d_int8_streaming (mode streaming)
--!
--! @details Ce testbench valide le comportement fonctionnel du module
--!          conv2d_int8_streaming en mode streaming direct (sans ping-pong).
--!          Il instancie le DUT avec les BRAMs réelles (poids, biais, image)
--!          initialisées par fichiers .coe, capture les 784 pixels de sortie
--!          (28×28×3 = 2352 octets en interleaved HWC) et les sauvegarde
--!          dans output_conv1_streaming.txt pour comparaison avec le modèle
--!          Python de référence.
--!
--! @section configuration Configuration du DUT
--!   - Entrée  : 32×32×1 (image MNIST redimensionnée, INT8 signé)
--!   - Sortie  : 28×28×3 (3 filtres 5×5, ReLU intégré, INT8)
--!   - Paramètres quantification : C1_MULT, C1_SHIFT, C1_ZERO_POINT
--!     (définis dans lenet_qparams_pkg.vhd)
--!
--! @section bramsext BRAMs externes instanciées
--!   - blk_mem_c11_w / c12_w / c13_w : poids des 3 filtres (25×8b chacune)
--!   - blk_mem_c1_b                  : biais des 3 filtres (96b = 3×32b)
--!   - blk_mem_in                    : image d'entrée (1024×8b)
--!
--! @section flux Flux de validation
--!   @code
--!   Reset (10 cycles) ? Démarrage (start='1' 1 cycle) ? Attente done
--!   ? Rapport performances ? Aperçu 5 premiers pixels ? Sauvegarde fichier
--!   @endcode
--!
--! @section corrections Corrections apportées
--!   - Variables locales v_start_cycle / v_end_cycle pour la mesure de cycles
--!     (évite le problème de delta-delay des signaux en VHDL)
--!   - Sauvegarde fichier output_conv1_streaming.txt (format entier, 1 valeur/ligne)
--!   - Ping-pong retiré (mode streaming direct uniquement)
--!
--! @author  Donald MYO
--! @date    2025
--! @version 2.0 - Streaming direct, variables locales cycles, sauvegarde fichier
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

--! @brief Entité testbench - aucun port (entité de simulation pure)
entity tb_conv2d_int8 is
end tb_conv2d_int8;

architecture Behavioral of tb_conv2d_int8 is

    ---------------------------------------------------------------------------
    --! @name Constantes de configuration
    --! @{
    ---------------------------------------------------------------------------
    constant IN_WIDTH     : integer := 32;   --! Largeur image d'entrée (pixels)
    constant IN_HEIGHT    : integer := 32;   --! Hauteur image d'entrée (pixels)
    constant IN_CHANNELS  : integer := 1;    --! Nombre de canaux d'entrée
    constant OUT_CHANNELS : integer := 3;    --! Nombre de filtres / canaux de sortie
    constant KERNEL_SIZE  : integer := 5;    --! Taille du noyau de convolution
    constant OUT_WIDTH    : integer := 28;   --! Largeur carte de sortie = IN_WIDTH - KERNEL_SIZE + 1
    constant OUT_HEIGHT   : integer := 28;   --! Hauteur carte de sortie = IN_HEIGHT - KERNEL_SIZE + 1

    constant PP_SIZE  : integer := OUT_WIDTH * OUT_HEIGHT;
    --! Nombre de pixels par carte de caractéristiques = 28×28 = 784

    constant PP_TOTAL : integer := OUT_CHANNELS * PP_SIZE;
    --! Taille totale du buffer de capture en octets = 3×784 = 2352 (format HWC interleaved)

    constant CLK_PERIOD : time := 10 ns;
    --! Période d'horloge simulée = 10 ns ? fréquence 100 MHz
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de contrôle du DUT
    --! @{
    ---------------------------------------------------------------------------
    signal clk   : std_logic := '0';  --! Horloge simulée (générée par clk_process)
    signal rst   : std_logic := '0';  --! Reset synchrone actif haut
    signal start : std_logic := '0';  --! Impulsion de démarrage DUT (1 cycle)
    signal done  : std_logic;         --! Signal de fin DUT (pipeline vidé)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux interface poids - 3 BRAMs (SLV + int8 signé)
    --! @{
    ---------------------------------------------------------------------------
    signal weight_addr_0     : std_logic_vector(4 downto 0);   --! Adresse BRAM filtre 0
    signal weight_data_0_slv : std_logic_vector(7 downto 0);   --! Donnée brute BRAM filtre 0 (SLV)
    signal weight_data_0     : int8;                           --! Donnée signée filtre 0

    signal weight_addr_1     : std_logic_vector(4 downto 0);
    signal weight_data_1_slv : std_logic_vector(7 downto 0);
    signal weight_data_1     : int8;

    signal weight_addr_2     : std_logic_vector(4 downto 0);
    signal weight_data_2_slv : std_logic_vector(7 downto 0);
    signal weight_data_2     : int8;
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux interface biais - BRAM 96 bits (3×32b)
    --! @{
    ---------------------------------------------------------------------------
    signal bias_data_0_slv : std_logic_vector(31 downto 0);  --! Biais filtre 0 (SLV)
    signal bias_data_0     : int32;                          --! Biais filtre 0 (signé)
    signal bias_data_1_slv : std_logic_vector(31 downto 0);
    signal bias_data_1     : int32;
    signal bias_data_2_slv : std_logic_vector(31 downto 0);
    signal bias_data_2     : int32;
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux interface image d'entrée
    --! @{
    ---------------------------------------------------------------------------
    signal in_bram_addr     : std_logic_vector(9 downto 0);  --! Adresse pixel d'entrée (0..1023)
    signal in_bram_data_slv : std_logic_vector(7 downto 0);  --! Pixel brut BRAM (SLV)
    signal in_bram_data     : int8;                          --! Pixel signé INT8
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de sortie streaming DUT
    --! @{
    ---------------------------------------------------------------------------
    signal out_data_0 : int8;      --! Pixel sortie canal 0 (après ReLU)
    signal out_data_1 : int8;      --! Pixel sortie canal 1
    signal out_data_2 : int8;      --! Pixel sortie canal 2
    signal out_valid  : std_logic; --! Validité des sorties (1 cycle par pixel)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux de supervision / métrologie
    --! @{
    ---------------------------------------------------------------------------
    signal sim_done : boolean := false;
    --! Drapeau de fin de simulation - arrête le process clk_process

    signal cycle_counter : integer := 0;
    --! Compteur de cycles depuis la fin du reset (incrémenté par cycle_cnt_proc)

    signal output_pixel_idx : integer := 0;
    --! Index courant d'écriture dans output_memory_stream (avance de +3 par pixel)

    --! @brief Buffer de capture des sorties streaming (format HWC interleaved)
    --! @details Stocke les valeurs dans l'ordre ch0,ch1,ch2 pour chaque pixel :
    --!          output_memory_stream(pix×3+0) = canal 0, +1 = canal 1, +2 = canal 2
    type output_mem_type is array (0 to PP_TOTAL-1) of int8;
    signal output_memory_stream : output_mem_type := (others => (others => '0'));

    signal last_out_valid  : std_logic := '0';
    --! Registre de retard pour la détection du front montant de out_valid

    signal out_valid_count : integer := 0;
    --! Nombre de fronts montants détectés sur out_valid (doit valoir 1 en fin de sim)
    --! @}

    ---------------------------------------------------------------------------
    -- Déclarations des composants
    ---------------------------------------------------------------------------

    --! @brief DUT - conv2d_int8_streaming (sans générique USE_RELU pour compatibilité)
    component conv2d_int8_streaming
        generic (
            IN_WIDTH     : integer;
            IN_HEIGHT    : integer;
            IN_CHANNELS  : integer;
            OUT_CHANNELS : integer;
            KERNEL_SIZE  : integer;
            Q_MULT       : int32;
            Q_SHIFT      : integer;
            Q_ZERO_POINT : int8
        );
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
            out_data_0    : out int8;
            out_data_1    : out int8;
            out_data_2    : out int8;
            out_valid     : out std_logic
        );
    end component;

    --! @brief BRAM poids filtre 0 - 25 coefficients INT8 (fichier blk_mem_c11_w.coe)
    component blk_mem_c11_w
        port (
            clka  : in  std_logic;
            ena   : in  std_logic;
            addra : in  std_logic_vector(4 downto 0);
            douta : out std_logic_vector(7 downto 0)
        );
    end component;

    --! @brief BRAM poids filtre 1 - 25 coefficients INT8 (fichier blk_mem_c12_w.coe)
    component blk_mem_c12_w
        port (
            clka  : in  std_logic;
            ena   : in  std_logic;
            addra : in  std_logic_vector(4 downto 0);
            douta : out std_logic_vector(7 downto 0)
        );
    end component;

    --! @brief BRAM poids filtre 2 - 25 coefficients INT8 (fichier blk_mem_c13_w.coe)
    component blk_mem_c13_w
        port (
            clka  : in  std_logic;
            ena   : in  std_logic;
            addra : in  std_logic_vector(4 downto 0);
            douta : out std_logic_vector(7 downto 0)
        );
    end component;

    --! @brief BRAM biais Conv1 - 3 biais int32 concaténés sur 96 bits
    --! @details Le port douta(95:0) est décomposé en trois tranches de 32 bits :
    --!          bits[31:0]=biais0, bits[63:32]=biais1, bits[95:64]=biais2
    component blk_mem_c1_b
        port (
            clka  : in  std_logic;
            ena   : in  std_logic;
            addra : in  std_logic;
            douta : out std_logic_vector(95 downto 0)
        );
    end component;

    --! @brief BRAM image d'entrée - 1024 pixels INT8 (32×32, fichier .coe image test)
    component blk_mem_in
        port (
            clka  : in  std_logic;
            ena   : in  std_logic;
            addra : in  std_logic_vector(9 downto 0);
            douta : out std_logic_vector(7 downto 0)
        );
    end component;

begin

    ---------------------------------------------------------------------------
    --! @brief Conversions std_logic_vector ? signed (int8 / int32)
    --!
    --! @details Les BRAMs Xilinx exposent leurs données en std_logic_vector.
    --!          Ces assignations concurrentes convertissent les sorties SLV
    --!          en types signés utilisés par le DUT et les processus de capture.
    ---------------------------------------------------------------------------
    weight_data_0 <= signed(weight_data_0_slv);
    weight_data_1 <= signed(weight_data_1_slv);
    weight_data_2 <= signed(weight_data_2_slv);
    bias_data_0   <= signed(bias_data_0_slv);
    bias_data_1   <= signed(bias_data_1_slv);
    bias_data_2   <= signed(bias_data_2_slv);
    in_bram_data  <= signed(in_bram_data_slv);

    ---------------------------------------------------------------------------
    --! @brief Instanciation du DUT - conv2d_int8_streaming (Conv1, LeNet-5)
    --!
    --! @details Paramètres de quantification issus de lenet_qparams_pkg :
    --!   C1_MULT=806858, C1_SHIFT=30, C1_ZERO_POINT=0
    ---------------------------------------------------------------------------
    DUT : conv2d_int8_streaming
        generic map (
            IN_WIDTH     => IN_WIDTH,
            IN_HEIGHT    => IN_HEIGHT,
            IN_CHANNELS  => IN_CHANNELS,
            OUT_CHANNELS => OUT_CHANNELS,
            KERNEL_SIZE  => KERNEL_SIZE,
            Q_MULT       => C1_MULT,
            Q_SHIFT      => C1_SHIFT,
            Q_ZERO_POINT => C1_ZERO_POINT
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
            bias_data_0   => bias_data_0,
            bias_data_1   => bias_data_1,
            bias_data_2   => bias_data_2,
            in_bram_addr  => in_bram_addr,
            in_bram_data  => in_bram_data,
            out_data_0    => out_data_0,
            out_data_1    => out_data_1,
            out_data_2    => out_data_2,
            out_valid     => out_valid
        );

    ---------------------------------------------------------------------------
    --! @brief Instanciation BRAMs poids - ena='1' permanent (pas de contrôle CE)
    ---------------------------------------------------------------------------
    BRAM_WEIGHT_0 : blk_mem_c11_w
        port map (clka => clk, ena => '1',
                  addra => weight_addr_0, douta => weight_data_0_slv);

    BRAM_WEIGHT_1 : blk_mem_c12_w
        port map (clka => clk, ena => '1',
                  addra => weight_addr_1, douta => weight_data_1_slv);

    BRAM_WEIGHT_2 : blk_mem_c13_w
        port map (clka => clk, ena => '1',
                  addra => weight_addr_2, douta => weight_data_2_slv);

    --! @brief BRAM biais - lecture unique à l'adresse 0 (tous les biais en un mot 96b)
    BRAM_BIAS : blk_mem_c1_b
        port map (
            clka  => clk, ena => '1', addra => '0',
            douta(31 downto 0)  => bias_data_0_slv,
            douta(63 downto 32) => bias_data_1_slv,
            douta(95 downto 64) => bias_data_2_slv
        );

    --! @brief BRAM image d'entrée - adressée directement par le DUT
    BRAM_INPUT : blk_mem_in
        port map (clka => clk, ena => '1',
                  addra => in_bram_addr, douta => in_bram_data_slv);

    ---------------------------------------------------------------------------
    --! @brief Génération de l'horloge simulée à 100 MHz
    --!
    --! @details Le process s'arrête dès que sim_done=true pour libérer
    --!          le simulateur proprement (évite une simulation infinie).
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
    --! @brief Compteur de cycles de simulation
    --!
    --! @details Remis à zéro sur rst='1', puis incrémenté chaque cycle.
    --!          Utilisé par le process stimulus via les variables locales
    --!          v_start_cycle et v_end_cycle pour mesurer la latence du DUT.
    ---------------------------------------------------------------------------
    cycle_cnt_proc : process(clk)
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
    --! @brief Moniteur out_valid - détection du premier front montant
    --!
    --! @details Détecte le premier front montant de out_valid par comparaison
    --!          avec last_out_valid (registre de retard d'un cycle).
    --!          Affiche dans la console XSim le numéro de cycle et les valeurs
    --!          du premier pixel valide (3 canaux) pour diagnostic rapide.
    --!
    --! @note    out_valid_count devrait valoir exactement 1 en fin de simulation
    --!          (out_valid reste haut en continu pendant les 784 pixels).
    ---------------------------------------------------------------------------
    monitor_out_valid : process(clk)
    begin
        if rising_edge(clk) then
            last_out_valid <= out_valid;
            if out_valid = '1' and last_out_valid = '0' then
                out_valid_count <= out_valid_count + 1;
                report "[" & integer'image(cycle_counter) & "] out_valid actif ! " &
                       "pixel=[" & integer'image(to_integer(out_data_0)) &
                       "," & integer'image(to_integer(out_data_1)) &
                       "," & integer'image(to_integer(out_data_2)) & "]"
                       severity note;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Capture streaming - stockage interleaved HWC dans output_memory_stream
    --!
    --! @details À chaque cycle où out_valid='1', les 3 canaux de sortie sont
    --!          écrits aux positions output_pixel_idx+0, +1, +2 dans le buffer
    --!          de capture. output_pixel_idx avance de 3 par pixel produit.
    --!
    --!          Format final du buffer (interleaved HWC) :
    --!          @code
    --!            [pix0_ch0, pix0_ch1, pix0_ch2, pix1_ch0, pix1_ch1, pix1_ch2, ...]
    --!          @endcode
    --!          Ce format est directement comparable avec la sortie Python
    --!          (numpy array de shape (28, 28, 3) aplati en C-order).
    ---------------------------------------------------------------------------
    output_capture_stream : process(clk)
    begin
        if rising_edge(clk) then
            if out_valid = '1' then
                if output_pixel_idx + 2 < PP_TOTAL then
                    output_memory_stream(output_pixel_idx + 0) <= out_data_0;
                    output_memory_stream(output_pixel_idx + 1) <= out_data_1;
                    output_memory_stream(output_pixel_idx + 2) <= out_data_2;
                    output_pixel_idx <= output_pixel_idx + 3;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief Process stimulus principal - séquence de test complète
    --!
    --! @details Séquence :
    --!   1. Reset 10 cycles
    --!   2. Attente 5 cycles de stabilisation
    --!   3. Capture v_start_cycle (variable locale, pas de delta-delay)
    --!   4. Impulsion start (1 cycle)
    --!   5. Boucle d'attente done avec rapport de progression tous les 200 cycles
    --!   6. Rapport final (cycles, pixels capturés, fronts out_valid)
    --!   7. Aperçu des 5 premiers pixels dans la console
    --!   8. Sauvegarde output_conv1_streaming.txt (1 valeur entière par ligne)
    --!   9. sim_done=true ? arrêt propre du simulateur
    --!
    --! @note    v_start_cycle et v_end_cycle sont des variables VHDL (pas des
    --!          signaux) pour éviter le delta-delay : leur valeur est immédiate
    --!          au moment de l'assignation, sans attendre un cycle supplémentaire.
    --!
    --! @warning Le timeout est fixé à 200 000 cycles. Si done n'est pas reçu
    --!          dans ce délai, le test échoue avec severity error. Vérifier
    --!          la FSM du DUT et les signaux start/rst en cas de timeout.
    ---------------------------------------------------------------------------
    stimulus : process
        variable line_v      : line;
        file f_stream        : text;
        variable timeout_cnt : integer := 0;

        variable v_start_cycle : integer := 0;
        --! Cycle de simulation au moment du démarrage (capturé via variable)

        variable v_end_cycle : integer := 0;
        --! Cycle de simulation au moment de la réception de done
    begin
        report "====================================================================" severity note;
        report "=== TESTBENCH CONV2D STREAMING + ADDER TREE ===" severity note;
        report "====================================================================" severity note;

        -- Phase 1 : Reset
        rst   <= '1';
        start <= '0';
        wait for CLK_PERIOD * 10;
        rst   <= '0';
        wait for CLK_PERIOD * 5;

        -- Phase 2 : Démarrage - capture immédiate du cycle via variable locale
        wait until rising_edge(clk);
        v_start_cycle := cycle_counter;
        report "=== DÉMARRAGE au cycle " & integer'image(v_start_cycle) &
               " ===" severity note;

        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        -- Phase 3 : Attente done avec timeout et rapport de progression
        timeout_cnt := 0;
        while done /= '1' and timeout_cnt < 200000 loop
            wait until rising_edge(clk);
            timeout_cnt := timeout_cnt + 1;

            -- Rapport de progression tous les 200 cycles
            if timeout_cnt mod 200 = 0 then
                report "  [" & integer'image(cycle_counter) &
                       "] En cours... pixels_captures=" &
                       integer'image(output_pixel_idx / OUT_CHANNELS) &
                       " out_valid_count=" & integer'image(out_valid_count)
                       severity note;
            end if;
        end loop;

        -- Phase 4 : Rapport final
        v_end_cycle := cycle_counter;

        if done = '1' then
            report "=== DONE reçu ===" severity note;
            report "  Cycles accélérateur : " &
                   integer'image(v_end_cycle - v_start_cycle) severity note;
            report "  Pixels capturés     : " &
                   integer'image(output_pixel_idx / OUT_CHANNELS) &
                   " / " & integer'image(OUT_WIDTH * OUT_HEIGHT) severity note;
            report "  Fronts out_valid    : " &
                   integer'image(out_valid_count) severity note;
        else
            report "=== TIMEOUT après " & integer'image(timeout_cnt) &
                   " cycles - vérifier FSM DUT ===" severity error;
            report "  Pixels capturés : " &
                   integer'image(output_pixel_idx / OUT_CHANNELS) severity note;
        end if;

        -- Phase 5 : marge de vidange pipeline
        wait for CLK_PERIOD * 10;

        -- Phase 6 : Aperçu des 5 premiers pixels dans la console XSim
        report "=== APERÇU 5 PREMIERS PIXELS (format [ch0,ch1,ch2]) ===" severity note;
        for pix in 0 to 4 loop
            report "  pixel[" & integer'image(pix) & "] = [" &
                   integer'image(to_integer(
                       output_memory_stream(pix * OUT_CHANNELS + 0))) & "," &
                   integer'image(to_integer(
                       output_memory_stream(pix * OUT_CHANNELS + 1))) & "," &
                   integer'image(to_integer(
                       output_memory_stream(pix * OUT_CHANNELS + 2))) & "]"
                   severity note;
        end loop;

        -- Phase 7 : Sauvegarde fichier texte pour comparaison Python
        -- Format : 1 valeur entière signée par ligne, ordre HWC interleaved
        if output_pixel_idx > 0 then
            file_open(f_stream, "output_conv1_streaming.txt", write_mode);
            for i in 0 to output_pixel_idx - 1 loop
                write(line_v, to_integer(output_memory_stream(i)));
                writeline(f_stream, line_v);
            end loop;
            file_close(f_stream);
            report "  " & integer'image(output_pixel_idx) &
                   " valeurs sauvegardées dans output_conv1_streaming.txt" &
                   " (comparer avec numpy flatten du modèle Python)"
                   severity note;
        end if;

        -- Phase 8 : arrêt propre du simulateur
        sim_done <= true;
        wait;
    end process;

end Behavioral;