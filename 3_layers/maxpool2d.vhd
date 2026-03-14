----------------------------------------------------------------------------------
--! @file    maxpool2d.vhd
--! @brief   Max Pooling 2D générique - FSM à adresse registrée
--!
--! @details Ce module implémente une opération de max pooling 2D quantifiée
--!          en entier 8 bits signé. Il parcourt séquentiellement toutes les
--!          fenêtres de taille POOL_SIZE×POOL_SIZE de l'activation d'entrée,
--!          retient la valeur maximale de chaque fenêtre et l'écrit dans le
--!          buffer de sortie. Le module est entièrement générique et est
--!          instancié deux fois dans le pipeline LeNet-5 modifié :
--!            - Pool1 : 28×28×3  ? 14×14×3  (après Conv1)
--!            - Pool2 : 10×10×6  ? 5×5×6    (après Conv2)
--!
--! @section correction Correction clé - adresse registrée
--!   Dans la version originale, in_addr était combinatoire et recalculée
--!   en permanence depuis cur_x_in/cur_y_in. Pendant les états COMPUTE_MAX,
--!   WRITE_OUT et NEXT_POS, pix_idx revenait à 0, ce qui provoquait un retour
--!   parasite de in_addr à 0 alors que la BRAM ne devait pas être lue.
--!
--!   Solution : in_addr_reg est un signal registré mis à jour UNIQUEMENT
--!   dans l'état ADDR_PIX et gelé dans tous les autres états.
--!
--! @section fsm Machine d'états (7 états)
--!   @code
--!   IDLE ??start='1'??? ADDR_PIX ??? READ_PIX ??pix_idx<KK-1??? ADDR_PIX
--!                           ?                  ???pix_idx=KK-1??? COMPUTE_MAX
--!                           ?                                          ?
--!                        NEXT_POS ??? WRITE_OUT ??????????????????????
--!                           ?
--!                    (tous pixels traités)
--!                           ?
--!                       DONE_STATE ??start='0'??? IDLE
--!   @endcode
--!
--! @section ordre Ordre de parcours (format HWC)
--!   Les activations sont stockées en mémoire dans l'ordre HWC :
--!   index = (y × IN_WIDTH + x) × IN_CHANNELS + ch
--!   Le parcours s'effectue dans l'ordre : y_out ? x_out ? ch ? pix_idx
--!
--! @author  Donald MYO
--! @date    2026
--! @version 2.0 - Correction adresse registrée (in_addr_reg), NEXT_POS revu
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.lenet_types_pkg.all;

--! @brief Max Pooling 2D générique - entité principale
--!
--! @details Instanciation pour Pool1 (LeNet-5 modifié) :
--! @code
--!   pool1 : entity work.maxpool2d
--!     generic map (
--!       IN_WIDTH    => 28, IN_HEIGHT => 28,
--!       IN_CHANNELS => 3,  POOL_SIZE => 2
--!     )
--!     port map (
--!       clk => clk, rst => rst, start => start_pool1, done => done_pool1,
--!       in_addr => buf1_addr, in_data => buf1_data,
--!       out_addr => buf2_addr, out_data => buf2_data, out_we => buf2_we
--!     );
--! @endcode
entity maxpool2d is
    generic (
        IN_WIDTH    : integer := 28;  --! Largeur de la carte d'activation d'entrée (pixels)
        IN_HEIGHT   : integer := 28;  --! Hauteur de la carte d'activation d'entrée (pixels)
        IN_CHANNELS : integer := 3;   --! Nombre de canaux d'entrée
        POOL_SIZE   : integer := 2    --! Taille de la fenêtre de pooling (carré POOL_SIZE×POOL_SIZE)
    );
    port (
        --! @name Contrôle
        --! @{
        clk   : in  std_logic;  --! Horloge système (front montant actif)
        rst   : in  std_logic;  --! Reset synchrone actif haut
        start : in  std_logic;  --! Impulsion de démarrage (1 cycle, top-level FSM)
        done  : out std_logic;  --! Signal de fin de pooling (actif haut)
        --! @}

        --! @name Interface buffer d'entrée (lecture aléatoire)
        --! @{
        in_addr : out std_logic_vector(11 downto 0);
        --! Adresse de lecture dans le buffer d'entrée (format HWC, 0 à IN_W×IN_H×C-1)
        --! Connecté au registre in_addr_reg - stable pendant au moins 2 cycles
        --! (ADDR_PIX + READ_PIX) pour respecter la latence synchrone de la BRAM.
        in_data : in  int8;
        --! Donnée lue depuis le buffer d'entrée (disponible 1 cycle après in_addr)
        --! @}

        --! @name Interface buffer de sortie (écriture adressée)
        --! @{
        out_addr : out std_logic_vector(11 downto 0);
        --! Adresse d'écriture dans le buffer de sortie (format HWC,
        --! index = (y_out×OUT_WIDTH + x_out)×IN_CHANNELS + ch)
        out_data : out int8;
        --! Valeur maximale de la fenêtre POOL_SIZE×POOL_SIZE à écrire
        out_we   : out std_logic
        --! Signal d'écriture : actif haut pendant 1 cycle dans l'état WRITE_OUT
        --! @}
    );
end maxpool2d;

architecture Behavioral of maxpool2d is

    ---------------------------------------------------------------------------
    --! @name Constantes dérivées des génériques
    --! @{
    ---------------------------------------------------------------------------
    constant OUT_WIDTH  : integer := IN_WIDTH  / POOL_SIZE;
    --! Largeur de la carte de sortie = IN_WIDTH / POOL_SIZE (ex: 14 pour Pool1)

    constant OUT_HEIGHT : integer := IN_HEIGHT / POOL_SIZE;
    --! Hauteur de la carte de sortie = IN_HEIGHT / POOL_SIZE (ex: 14 pour Pool1)

    constant KK : integer := POOL_SIZE * POOL_SIZE;
    --! Nombre de pixels dans une fenêtre de pooling = POOL_SIZE² (4 pour POOL_SIZE=2)
    --! @}

    ---------------------------------------------------------------------------
    --! @brief États de la machine d'états principale
    --!
    --! @details Protocole d'accès BRAM en deux temps (ADDR_PIX ? READ_PIX) :
    --!   - ADDR_PIX  : calcul et enregistrement de l'adresse dans in_addr_reg
    --!   - READ_PIX  : capture de in_data (disponible 1 cycle après l'adresse)
    --!
    --! Ce découpage est imposé par la latence synchrone d'un cycle des BRAMs
    --! Xilinx en mode "Read First" ou "Write First" (pas de lecture combinatoire).
    ---------------------------------------------------------------------------
    type state_type is (
        IDLE,        --! Attente du signal start
        ADDR_PIX,    --! Calcul et enregistrement de l'adresse BRAM (in_addr_reg mis à jour)
        READ_PIX,    --! Capture de in_data dans window(pix_idx)
        COMPUTE_MAX, --! Réduction max sur les KK pixels de la fenêtre
        WRITE_OUT,   --! Écriture du maximum dans le buffer de sortie (out_we='1')
        NEXT_POS,    --! Avance vers la prochaine position (ch ? x_out ? y_out)
        DONE_STATE   --! Assertion de done, attente du relâchement de start
    );
    signal state : state_type := IDLE;  --! État courant de la FSM

    ---------------------------------------------------------------------------
    --! @name Compteurs de position
    --! @{
    ---------------------------------------------------------------------------
    signal x_out : integer range 0 to OUT_WIDTH-1   := 0;
    --! Coordonnée x courante dans la carte de sortie (0 à OUT_WIDTH-1)

    signal y_out : integer range 0 to OUT_HEIGHT-1  := 0;
    --! Coordonnée y courante dans la carte de sortie (0 à OUT_HEIGHT-1)

    signal ch : integer range 0 to IN_CHANNELS-1 := 0;
    --! Canal courant traité (0 à IN_CHANNELS-1)

    signal pix_idx : integer range 0 to KK := 0;
    --! Index du pixel courant dans la fenêtre POOL_SIZE×POOL_SIZE (0 à KK-1)
    --! Utilisé pour adresser séquentiellement les KK pixels d'une fenêtre
    --! @}

    ---------------------------------------------------------------------------
    --! @name Registres de calcul
    --! @{
    ---------------------------------------------------------------------------

    --! Fenêtre de pooling : capture des KK pixels lus depuis le buffer d'entrée
    type window_type is array (0 to KK-1) of int8;
    signal window : window_type := (others => (others => '0'));

    signal max_val : int8 := (others => '0');
    --! Valeur maximale calculée dans COMPUTE_MAX, mémorisée jusqu'à WRITE_OUT
    --! @}

    ---------------------------------------------------------------------------
    --! @brief Registre d'adresse d'entrée - correction adresse flottante
    --!
    --! @details in_addr_reg remplace le signal combinatoire de la version
    --!          originale. Il est mis à jour UNIQUEMENT dans l'état ADDR_PIX
    --!          et conserve sa dernière valeur valide dans tous les autres états,
    --!          éliminant les retours parasites à 0 pendant COMPUTE_MAX,
    --!          WRITE_OUT et NEXT_POS.
    --!
    --! @note    La sortie in_addr est directement connectée à in_addr_reg
    --!          par une assignation concurrente (pas de logique combinatoire
    --!          supplémentaire sur le chemin d'adresse).
    ---------------------------------------------------------------------------
    signal in_addr_reg : std_logic_vector(11 downto 0) := (others => '0');

begin

    ---------------------------------------------------------------------------
    --! @brief Connexion directe du registre d'adresse vers le port de sortie
    --!
    --! @details In_addr est stable pendant au moins 2 cycles consécutifs
    --!          (ADDR_PIX + READ_PIX), ce qui satisfait le protocole de lecture
    --!          synchrone des BRAMs Xilinx (latence 1 cycle).
    ---------------------------------------------------------------------------
    in_addr <= in_addr_reg;

    ---------------------------------------------------------------------------
    --! @brief Process principal - FSM + datapath
    --!
    --! @details Processus synchrone unique gérant l'intégralité de la FSM
    --!          et du chemin de données. Les variables locales cur_x_in,
    --!          cur_y_in et next_addr sont utilisées pour le calcul combinatoire
    --!          de l'adresse HWC avant son enregistrement dans in_addr_reg.
    --!
    --! @note    out_we est remis à '0' en début de cycle (hors état WRITE_OUT)
    --!          pour garantir une impulsion d'écriture d'exactement 1 cycle.
    ---------------------------------------------------------------------------
    process(clk)
        variable temp_max  : int8;     --! Accumulateur temporaire pour la réduction max
        variable cur_x_in  : integer;  --! Coordonnée x du pixel courant dans l'image d'entrée
        variable cur_y_in  : integer;  --! Coordonnée y du pixel courant dans l'image d'entrée
        variable next_addr : integer;  --! Adresse HWC calculée avant enregistrement
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state       <= IDLE;
                done        <= '0';
                out_we      <= '0';
                x_out       <= 0;
                y_out       <= 0;
                ch          <= 0;
                pix_idx     <= 0;
                in_addr_reg <= (others => '0');
            else
                out_we <= '0';  --! Remise à zéro systématique - out_we='1' seulement dans WRITE_OUT

                case state is

                    --! @brief IDLE : initialisation et attente du démarrage
                    when IDLE =>
                        done <= '0';
                        if start = '1' then
                            x_out   <= 0;
                            y_out   <= 0;
                            ch      <= 0;
                            pix_idx <= 0;
                            state   <= ADDR_PIX;
                        end if;

                    --! @brief ADDR_PIX : calcul et enregistrement de l'adresse BRAM
                    --!
                    --! @details Seul état où in_addr_reg est modifié. L'adresse
                    --!          est calculée selon le format HWC :
                    --!          @code
                    --!            cur_x_in  = x_out × POOL_SIZE + (pix_idx mod POOL_SIZE)
                    --!            cur_y_in  = y_out × POOL_SIZE + (pix_idx / POOL_SIZE)
                    --!            next_addr = (cur_y_in × IN_WIDTH + cur_x_in)
                    --!                        × IN_CHANNELS + ch
                    --!          @endcode
                    --!          La transition immédiate vers READ_PIX laisse
                    --!          1 cycle de latence pour que la BRAM présente
                    --!          la donnée valide sur in_data.
                    when ADDR_PIX =>
                        cur_x_in  := x_out * POOL_SIZE + (pix_idx mod POOL_SIZE);
                        cur_y_in  := y_out * POOL_SIZE + (pix_idx / POOL_SIZE);
                        next_addr := (cur_y_in * IN_WIDTH + cur_x_in) * IN_CHANNELS + ch;
                        in_addr_reg <= std_logic_vector(to_unsigned(next_addr, 12));
                        state <= READ_PIX;

                    --! @brief READ_PIX : capture de la donnée BRAM dans la fenêtre
                    --!
                    --! @details in_data est valide ce cycle (1 cycle après ADDR_PIX).
                    --!          Si pix_idx < KK-1 : retour en ADDR_PIX pour le pixel suivant.
                    --!          Si pix_idx = KK-1 : tous les KK pixels sont capturés,
                    --!          transition vers COMPUTE_MAX. in_addr_reg reste sur
                    --!          la dernière adresse lue (pas de retour parasite à 0).
                    when READ_PIX =>
                        window(pix_idx) <= in_data;
                        if pix_idx < KK-1 then
                            pix_idx <= pix_idx + 1;
                            state   <= ADDR_PIX;
                        else
                            pix_idx <= 0;
                            state   <= COMPUTE_MAX;
                        end if;

                    --! @brief COMPUTE_MAX : réduction max sur les KK pixels de la fenêtre
                    --!
                    --! @details Parcours séquentiel du tableau window(0..KK-1).
                    --!          La boucle for est déroulée par Vivado en logique
                    --!          combinatoire (KK=4, donc 3 comparaisons int8).
                    --!          Le résultat est stocké dans max_val pour WRITE_OUT.
                    --!          in_addr_reg reste gelé sur la dernière adresse lue.
                    when COMPUTE_MAX =>
                        temp_max := window(0);
                        for i in 1 to KK-1 loop
                            if window(i) > temp_max then
                                temp_max := window(i);
                            end if;
                        end loop;
                        max_val <= temp_max;
                        state   <= WRITE_OUT;

                    --! @brief WRITE_OUT : écriture du maximum dans le buffer de sortie
                    --!
                    --! @details out_addr est calculé en format HWC :
                    --!          index = (y_out × OUT_WIDTH + x_out) × IN_CHANNELS + ch
                    --!          out_we est levé pendant exactement 1 cycle (remis à '0'
                    --!          en début du cycle suivant par l'assignation par défaut).
                    when WRITE_OUT =>
                        out_addr <= std_logic_vector(
                            to_unsigned(
                                (y_out * OUT_WIDTH + x_out) * IN_CHANNELS + ch,
                                12
                            )
                        );
                        out_data <= max_val;
                        out_we   <= '1';
                        state    <= NEXT_POS;

                    --! @brief NEXT_POS : avance vers la prochaine position de pooling
                    --!
                    --! @details Ordre de parcours : ch (le plus rapide) ?
                    --!          x_out ? y_out (le plus lent), conforme au
                    --!          format HWC des buffers intermédiaires.
                    --!          Quand tous les pixels ont été traités
                    --!          (y_out = OUT_HEIGHT-1, x_out = OUT_WIDTH-1,
                    --!          ch = IN_CHANNELS-1), transition vers DONE_STATE.
                    when NEXT_POS =>
                        if ch < IN_CHANNELS-1 then
                            ch    <= ch + 1;
                            state <= ADDR_PIX;
                        elsif x_out < OUT_WIDTH-1 then
                            x_out <= x_out + 1;
                            ch    <= 0;
                            state <= ADDR_PIX;
                        elsif y_out < OUT_HEIGHT-1 then
                            y_out <= y_out + 1;
                            x_out <= 0;
                            ch    <= 0;
                            state <= ADDR_PIX;
                        else
                            state <= DONE_STATE;
                        end if;

                    --! @brief DONE_STATE : assertion de done et attente du handshake
                    --!
                    --! @details done reste à '1' jusqu'au relâchement de start
                    --!          par le top-level FSM (top_lenet_full), qui désactive
                    --!          start dès réception de done. Ce handshake garantit
                    --!          que le module ne redémarre pas intempestivement.
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