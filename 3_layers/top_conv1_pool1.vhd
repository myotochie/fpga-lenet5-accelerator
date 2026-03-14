----------------------------------------------------------------------------------
--! @file    top_conv1_pool1.vhd
--! @brief   Bloc de haut niveau - Conv1 + MaxPool1 avec buffer intermédiaire
--!
--! @details Ce module instancie et connecte la première couche de convolution
--!          (conv2d_int8_streaming) et le premier max pooling (maxpool2d) du
--!          pipeline LeNet-5 modifié. Un buffer RAM intermédiaire de 2352 octets
--!          (28×28×3, format HWC) stocke les activations produites par Conv1
--!          avant leur consommation par MaxPool1.
--!
--! @section architecture Architecture interne
--!   @code
--!   ????????????????????  out_data_0/1/2  ????????????????  in_data  ????????????
--!   ? conv2d_int8      ?  out_valid        ?  buffer_ram  ?           ? maxpool  ?
--!   ? streaming        ? ????????????????? ?  2352 bytes  ? ??????????? 2d       ?
--!   ? (32×32 ? 28×28×3)?                  ?  (RAM simple)?  in_addr  ?          ?
--!   ????????????????????                  ????????????????           ????????????
--!   @endcode
--!
--! @section correction Correction clé - process RAM unique
--!   La version précédente utilisait deux process séparés (buf_write et
--!   buf_write_ctrl) pour gérer buffer_ram, provoquant un conflit de drivers
--!   et des valeurs indéterminées (0X) dans XSim.
--!
--!   Solution : un seul process (buf_ram_proc) gère l'intégralité des accès
--!   en lecture et en écriture sur buffer_ram, éliminant tout conflit.
--!
--! @section buffer Protocole buffer_ram
--!   - Écriture : prioritaire, sur conv_valid='1' en état RUN_CONV.
--!                3 canaux écrits simultanément (ch0, ch1, ch2) en 1 cycle.
--!                write_counter avance de 3 à chaque pixel Conv1 valide.
--!   - Lecture  : synchrone, 1 cycle de latence (compatible BRAM Xilinx).
--!                pool_in_addr posé dans ADDR_PIX ? buf_rd_data disponible
--!                dans READ_PIX 1 cycle après.
--!
--! @section fsm Machine d'états Top
--!   @code
--!   IDLE ??start='1'??? RUN_CONV ??conv_done='1'??? RUN_POOL
--!                                                        ?
--!                                              pool_done='1'
--!                                                        ?
--!                                                  DONE_STATE ??start='0'??? IDLE
--!   @endcode
--!
--! @author  Donald MYO
--! @date    2026
--! @version 2.0 - Correction conflit drivers buffer_ram (process unique)
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.lenet_types_pkg.all;
use work.lenet_qparams_pkg.all;

--! @brief Bloc Conv1 + MaxPool1 - entité principale
--!
--! @details Ce bloc est instancié dans top_lenet_full et constitue les
--!          deux premiers étages du pipeline d'inférence LeNet-5 modifié.
--!          Il expose directement les interfaces BRAMs de Conv1 (poids,
--!          biais, image) et le port de sortie de MaxPool1 vers le niveau
--!          supérieur.
entity top_conv1_pool1 is
    port (
        --! @name Contrôle
        --! @{
        clk   : in  std_logic;  --! Horloge système (front montant actif)
        rst   : in  std_logic;  --! Reset synchrone actif haut
        start : in  std_logic;  --! Impulsion de démarrage (top_lenet_full FSM)
        done  : out std_logic;  --! Fin du bloc Conv1+Pool1 (MaxPool1 terminé)
        --! @}

        --! @name BRAMs poids Conv1 - 3 BRAMs indépendantes (lecture parallèle)
        --! @{
        weight_addr_0 : out std_logic_vector(4 downto 0);  --! Adresse BRAM filtre 0 (0..24)
        weight_data_0 : in  int8;                          --! Poids filtre 0
        weight_addr_1 : out std_logic_vector(4 downto 0);  --! Adresse BRAM filtre 1 (0..24)
        weight_data_1 : in  int8;                          --! Poids filtre 1
        weight_addr_2 : out std_logic_vector(4 downto 0);  --! Adresse BRAM filtre 2 (0..24)
        weight_data_2 : in  int8;                          --! Poids filtre 2
        --! @}

        --! @name BRAM biais Conv1 - biais int32 compensés pour entrée INT8
        --! @{
        bias_data_0 : in int32;  --! Biais filtre 0 (b_compensé = b_HLS - 128×?w)
        bias_data_1 : in int32;  --! Biais filtre 1
        bias_data_2 : in int32;  --! Biais filtre 2
        --! @}

        --! @name BRAM image d'entrée Conv1 (32×32 = 1024 octets)
        --! @{
        in_bram_addr : out std_logic_vector(9 downto 0);  --! Adresse pixel d'entrée (0..1023)
        in_bram_data : in  int8;                          --! Pixel INT8 signé
        --! @}

        --! @name Sortie MaxPool1 vers buffer2 (14×14×3 = 588 octets, format HWC)
        --! @{
        pool_out_addr : out std_logic_vector(11 downto 0);  --! Adresse d'écriture buffer2
        pool_out_data : out int8;                           --! Valeur max de la fenêtre 2×2
        pool_out_we   : out std_logic                       --! Signal d'écriture (1 cycle)
        --! @}
    );
end top_conv1_pool1;

architecture Behavioral of top_conv1_pool1 is

    ---------------------------------------------------------------------------
    --! @name Constantes
    --! @{
    ---------------------------------------------------------------------------
    constant BUF_SIZE : integer := 28 * 28 * 3;
    --! Taille du buffer intermédiaire Conv1?MaxPool1 en octets
    --! = OUT_WIDTH × OUT_HEIGHT × OUT_CHANNELS = 28×28×3 = 2352 (format HWC)
    --! @}

    ---------------------------------------------------------------------------
    --! @name Buffer intermédiaire Conv1 ? MaxPool1
    --! @{
    ---------------------------------------------------------------------------

    --! @brief RAM simple port inférée par Vivado (LUTRAM ou BRAM selon placement)
    --!
    --! @details Stocke les activations de sortie de Conv1 (après ReLU et
    --!          requantification INT8) en attendant leur lecture par MaxPool1.
    --!          Le format de stockage est HWC :
    --!          index = (y × 28 + x) × 3 + ch, avec ch ? {0,1,2}
    --!
    --! @warning Un seul process (buf_ram_proc) doit piloter ce signal.
    --!          Tout second driver provoquerait un conflit et des valeurs
    --!          indéterminées (0X) en simulation XSim.
    type buf_type is array (0 to BUF_SIZE-1) of int8;
    signal buffer_ram : buf_type := (others => (others => '0'));

    signal write_counter : integer range 0 to BUF_SIZE := 0;
    --! Pointeur d'écriture dans buffer_ram, incrémenté de 3 à chaque pixel
    --! Conv1 valide (3 canaux écrits simultanément par cycle)

    signal buf_rd_data : int8 := (others => '0');
    --! Données lues depuis buffer_ram avec 1 cycle de latence synchrone,
    --! connectées directement au port in_data de MaxPool1
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux internes Conv1
    --! @{
    ---------------------------------------------------------------------------
    signal conv_start : std_logic := '0';  --! Signal de démarrage vers conv2d_int8_streaming
    signal conv_done  : std_logic;         --! Fin de Conv1 (pipeline vidé, 784 pixels émis)
    signal conv_out_0 : int8;              --! Pixel de sortie canal 0 (après ReLU)
    signal conv_out_1 : int8;             --! Pixel de sortie canal 1
    signal conv_out_2 : int8;             --! Pixel de sortie canal 2
    signal conv_valid : std_logic;        --! Validité des sorties conv_out_0/1/2
    --! @}

    ---------------------------------------------------------------------------
    --! @name Signaux internes MaxPool1
    --! @{
    ---------------------------------------------------------------------------
    signal pool_start   : std_logic := '0';            --! Signal de démarrage vers maxpool2d
    signal pool_done    : std_logic;                   --! Fin de MaxPool1 (588 pixels écrits)
    signal pool_in_addr : std_logic_vector(11 downto 0); --! Adresse lecture buffer_ram par MaxPool1
    signal pool_in_data : int8;                        --! Données buffer_ram ? MaxPool1
    --! @}

    ---------------------------------------------------------------------------
    --! @brief États de la FSM top-level
    --!
    --! @details FSM séquentielle à 4 états pilotant le démarrage successif
    --!          de Conv1 puis MaxPool1. Le buffer intermédiaire est rempli
    --!          automatiquement par buf_ram_proc pendant RUN_CONV.
    ---------------------------------------------------------------------------
    type state_type is (
        IDLE,       --! Attente du signal start
        RUN_CONV,   --! Conv1 en cours - buffer_ram alimenté par buf_ram_proc
        RUN_POOL,   --! MaxPool1 en cours - buffer_ram lu par maxpool2d
        DONE_STATE  --! Assertion de done, attente relâchement de start
    );
    signal state : state_type := IDLE;  --! État courant de la FSM top

    ---------------------------------------------------------------------------
    -- Déclarations des composants
    ---------------------------------------------------------------------------

    --! @brief Composant conv2d_int8_streaming - convolution 2D INT8 pipelinée
    component conv2d_int8_streaming
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

    --! @brief Composant maxpool2d - max pooling 2D générique
    component maxpool2d
        generic (
            IN_WIDTH    : integer;
            IN_HEIGHT   : integer;
            IN_CHANNELS : integer;
            POOL_SIZE   : integer
        );
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            start    : in  std_logic;
            done     : out std_logic;
            in_addr  : out std_logic_vector(11 downto 0);
            in_data  : in  int8;
            out_addr : out std_logic_vector(11 downto 0);
            out_data : out int8;
            out_we   : out std_logic
        );
    end component;

begin

    ---------------------------------------------------------------------------
    --! @brief Instanciation Conv1 - convolution 32×32×1 ? 28×28×3 (INT8, ReLU)
    --!
    --! @details Paramètres de quantification issus de lenet_qparams_pkg :
    --!   - Q_MULT       = C1_MULT       (~806 858, Q30)
    --!   - Q_SHIFT      = C1_SHIFT      (30)
    --!   - Q_ZERO_POINT = C1_ZERO_POINT (0, ReLU implicite)
    --!   - USE_RELU     = true          (activation ReLU intégrée en stage 8)
    ---------------------------------------------------------------------------
    CONV1 : conv2d_int8_streaming
        generic map (
            IN_WIDTH     => 32,
            IN_HEIGHT    => 32,
            IN_CHANNELS  => 1,
            OUT_CHANNELS => 3,
            KERNEL_SIZE  => 5,
            Q_MULT       => C1_MULT,
            Q_SHIFT      => C1_SHIFT,
            Q_ZERO_POINT => C1_ZERO_POINT,
            USE_RELU     => true
        )
        port map (
            clk           => clk,
            rst           => rst,
            start         => conv_start,
            done          => conv_done,
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
            out_data_0    => conv_out_0,
            out_data_1    => conv_out_1,
            out_data_2    => conv_out_2,
            out_valid     => conv_valid
        );

    ---------------------------------------------------------------------------
    --! @brief Instanciation MaxPool1 - pooling 28×28×3 ? 14×14×3 (fenêtre 2×2)
    --!
    --! @details MaxPool1 lit ses données depuis buffer_ram via pool_in_addr
    --!          et pool_in_data (connecté à buf_rd_data). Ses sorties sont
    --!          dirigées directement vers les ports pool_out_* du top-level,
    --!          qui correspondent au buffer2 dans top_lenet_full.
    ---------------------------------------------------------------------------
    POOL1 : maxpool2d
        generic map (
            IN_WIDTH    => 28,
            IN_HEIGHT   => 28,
            IN_CHANNELS => 3,
            POOL_SIZE   => 2
        )
        port map (
            clk      => clk,
            rst      => rst,
            start    => pool_start,
            done     => pool_done,
            in_addr  => pool_in_addr,
            in_data  => pool_in_data,
            out_addr => pool_out_addr,
            out_data => pool_out_data,
            out_we   => pool_out_we
        );

    --! Connexion directe buf_rd_data ? port in_data de MaxPool1
    pool_in_data <= buf_rd_data;

    ---------------------------------------------------------------------------
    --! @brief Process unique buffer RAM - CORRECTION PRINCIPALE
    --!
    --! @details Ce process est l'unique driver de buffer_ram, buf_rd_data
    --!          et write_counter. Il gère simultanément :
    --!
    --!          PORT ÉCRITURE (Conv1 ? buffer) :
    --!            Actif uniquement si state=RUN_CONV ET conv_valid='1'.
    --!            Les 3 canaux de sortie de Conv1 sont écrits simultanément
    --!            aux adresses write_counter+0, +1, +2 (format HWC).
    --!            write_counter est incrémenté de 3 après chaque écriture.
    --!
    --!          PORT LECTURE (buffer ? MaxPool, latence 1 cycle) :
    --!            Toujours actif : buf_rd_data est mis à jour chaque cycle
    --!            avec buffer_ram(pool_in_addr), émulant le comportement
    --!            d'une BRAM Xilinx en mode lecture synchrone.
    --!            La FSM de maxpool2d tient compte de cette latence d'un cycle
    --!            (protocole ADDR_PIX ? READ_PIX en deux états distincts).
    --!
    --! @warning Ne jamais ajouter de second process pilotant buffer_ram.
    --!          Cela provoquerait un conflit de drivers et des valeurs 0X
    --!          en simulation XSim (comportement indéfini en synthèse).
    ---------------------------------------------------------------------------
    buf_ram_proc : process(clk)
        variable rd_addr_v : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                write_counter <= 0;
                buf_rd_data   <= (others => '0');
            else
                -- PORT ÉCRITURE : Conv1 ? buffer_ram
                -- 3 canaux écrits en 1 cycle (ch0=+0, ch1=+1, ch2=+2)
                if state = RUN_CONV and conv_valid = '1' then
                    if write_counter + 2 < BUF_SIZE then
                        buffer_ram(write_counter + 0) <= conv_out_0;
                        buffer_ram(write_counter + 1) <= conv_out_1;
                        buffer_ram(write_counter + 2) <= conv_out_2;
                        write_counter <= write_counter + 3;
                    end if;
                end if;

                -- PORT LECTURE : buffer_ram ? MaxPool1 (latence 1 cycle)
                rd_addr_v := to_integer(unsigned(pool_in_addr));
                if rd_addr_v >= 0 and rd_addr_v < BUF_SIZE then
                    buf_rd_data <= buffer_ram(rd_addr_v);
                else
                    buf_rd_data <= (others => '0');
                end if;

            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    --! @brief FSM top-level - séquencement Conv1 puis MaxPool1
    --!
    --! @details conv_start et pool_start sont des impulsions d'un cycle :
    --!          remis à '0' par défaut en début de cycle, levés à '1' pendant
    --!          exactement 1 cycle lors de la transition d'état correspondante.
    --!
    --!          Le buffer intermédiaire est alimenté automatiquement par
    --!          buf_ram_proc pendant RUN_CONV, sans intervention de la FSM.
    --!          La FSM surveille uniquement conv_done et pool_done pour
    --!          enchaîner les étages.
    ---------------------------------------------------------------------------
    fsm_top : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state      <= IDLE;
                done       <= '0';
                conv_start <= '0';
                pool_start <= '0';
            else
                conv_start <= '0';  --! Remise à zéro par défaut (impulsion 1 cycle)
                pool_start <= '0';  --! Remise à zéro par défaut (impulsion 1 cycle)

                case state is

                    --! @brief IDLE : attente du démarrage depuis top_lenet_full
                    when IDLE =>
                        done <= '0';
                        if start = '1' then
                            conv_start <= '1';  --! Impulsion démarrage Conv1
                            state      <= RUN_CONV;
                        end if;

                    --! @brief RUN_CONV : Conv1 en cours d'exécution
                    --! buffer_ram alimenté automatiquement par buf_ram_proc.
                    --! Transition vers RUN_POOL dès que conv_done='1'.
                    when RUN_CONV =>
                        if conv_done = '1' then
                            pool_start <= '1';  --! Impulsion démarrage MaxPool1
                            state      <= RUN_POOL;
                        end if;

                    --! @brief RUN_POOL : MaxPool1 lit buffer_ram et écrit buffer2.
                    --! Transition vers DONE_STATE dès que pool_done='1'.
                    when RUN_POOL =>
                        if pool_done = '1' then
                            state <= DONE_STATE;
                        end if;

                    --! @brief DONE_STATE : done levé, attente du relâchement de start
                    --! par top_lenet_full (handshake identique aux sous-modules).
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