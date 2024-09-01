--20 mayis gunu saat 13:00
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity top is
	generic
	(
		c_clkfreq : integer := 100_000_000;
		c_baudrate : integer := 115_200;
		c_pwmfreq : integer := 10_000
	);
	port
	(
		clk : in std_logic;
		rx_i : in std_logic; -- bilgisayardan gelen data
		leds_o : out std_logic_vector(15 downto 0);
		start_i : in std_logic;
        reset_i	: in std_logic;
        seven_seg_o	: out std_logic_vector (7 downto 0);
        anodes_o : out std_logic_vector (7 downto 0);
        led_color_i	: in std_logic_vector (5 downto 0); -- switches
        led_color_o	: out std_logic_vector (5 downto 0); -- transistor base'sine giden led output
		-- CLK_I : in STD_LOGIC;
	    VGA_HS_O : out STD_LOGIC;
        VGA_VS_O : out STD_LOGIC;
        VGA_RED_O : out STD_LOGIC_VECTOR (3 downto 0);
        VGA_BLUE_O : out STD_LOGIC_VECTOR (3 downto 0);
        VGA_GREEN_O : out STD_LOGIC_VECTOR (3 downto 0);
        PS2_CLK : inout STD_LOGIC;
        PS2_DATA : inout STD_LOGIC
	);
end top;

architecture Behavioral of top is
	component uart_rx is
		generic
		(
			c_clkfreq : integer := 100_000_000;
			c_baudrate : integer := 115_200
		);
		port
		(
			clk : in std_logic;
			rx_i : in std_logic;
			dout_o : out std_logic_vector(7 downto 0);
			rx_done_tick_o : out std_logic
		);
	end component;
	
	component pwm is
        generic 
        (
            c_clkfreq : integer := 100_000_000;
            c_pwmfreq : integer := 1000
        );
        port 
        (
            clk	: in std_logic;
            duty_cycle_i : in std_logic_vector (6 downto 0);
            pwm_o : out std_logic
        );
    end component;
        
	component debounce is
        generic 
        (
            c_clkfreq : integer := 100_000_000;
            c_debtime : integer := 1000;
            c_initval : std_logic := '0'
        );
        port 
        (
            clk : in std_logic;
            signal_i : in std_logic;
            signal_o : out std_logic
        );
	end component;
	
	component bcd_incrementor is
        generic 
        (
            c_birlerlim : integer := 9;
            c_onlarlim : integer := 5
        );
        port 
        (
            clk : in std_logic;
            increment_i : in std_logic;
            reset_i : in std_logic;
            birler_o : out std_logic_vector (3 downto 0);
            onlar_o : out std_logic_vector (3 downto 0)
        );
     end component;
     
     component bcd_to_sevenseg is
        port 
        (
            bcd_i : in std_logic_vector (3 downto 0);
            sevenseg_o : out std_logic_vector (7 downto 0)
        );
    end component;
    
    component MouseCtl
      generic
      (
         SYSCLK_FREQUENCY_HZ : integer := 100000000;
         CHECK_PERIOD_MS     : integer := 500;
         TIMEOUT_PERIOD_MS   : integer := 100
      );
      port
      (
          clk : IN std_logic;
          rst : IN std_logic;
          value : IN std_logic_vector(11 downto 0);
          setx : IN std_logic;
          sety : IN std_logic;
          setmax_x : IN std_logic;
          setmax_y : IN std_logic;    
          ps2_clk : INOUT std_logic;
          ps2_data : INOUT std_logic;      
          xpos : OUT std_logic_vector(11 downto 0);
          ypos : OUT std_logic_vector(11 downto 0);
          zpos : OUT std_logic_vector(3 downto 0);
          left : OUT std_logic;
          middle : OUT std_logic;
          right : OUT std_logic;
          new_event : OUT std_logic
          );
    end component;

    component MouseDisplay
      port
      (
          pixel_clk : IN std_logic;
          xpos : IN std_logic_vector(11 downto 0);
          ypos : IN std_logic_vector(11 downto 0);
          hcount : IN std_logic_vector(11 downto 0);
          vcount : IN std_logic_vector(11 downto 0);          
          enable_mouse_display_out : OUT std_logic;
          red_out : OUT std_logic_vector(3 downto 0);
          green_out : OUT std_logic_vector(3 downto 0);
          blue_out : OUT std_logic_vector(3 downto 0)
       );
    end component;
  
	component clk_wiz_0
		port
		 (
			-- Clock in ports
			clk_in1 : in std_logic;
			-- Clock out ports
			clk_out1 : out std_logic
		 );
	end component;   
	
	constant c_timer1mslim : integer := c_clkfreq/1000;
    constant c_salise_counter_lim : integer := c_clkfreq/100;
    constant c_saniye_counter_lim : integer := 100;	-- 100 saliseye kadar sayacak ve 1 artacak saniye
    constant c_dakika_counter_lim : integer := 60;	-- 60 saniyeye kadar sayacak ve 1 artacak dakika

    constant c_counterlim : integer := 100;
    constant c_timer50hzlim	: integer := c_clkfreq/50;
    
    --***1280x1024@60Hz***--
    constant FRAME_WIDTH : natural := 1280;   -- belki 680x340 olabilir
    constant FRAME_HEIGHT : natural := 1024;
    constant H_FP : natural := 48; --H front porch width (pixels)
    constant H_PW : natural := 112; --H sync pulse width (pixels)
    constant H_MAX : natural := 1688; --H total period (pixels)
    constant V_FP : natural := 1; --V front porch width (lines)
    constant V_PW : natural := 3; --V sync pulse width (lines)
    constant V_MAX : natural := 1066; --V total period (lines)
    constant H_POL : std_logic := '1';
    constant V_POL : std_logic := '1'; 
    
    constant Clock_Freq : integer := 100_000_000; -- 100 Mhz
    constant Delay_Cycles : integer := 1000000;
    
    type state_type is (IDLE, WAIT_STATE); --- (IDLE, RED_STATE, GREEN_STATE, BLUE_STATE, WAIT_STATE)
    signal state_first : state_type := IDLE;
    -- signal counter_delay : integer := 0;
    signal counter_delay_2 : integer range 0 to 1000 * 60;
    
    signal duty_cycle_ld17 : std_logic_vector (6 downto 0) := (others => '0');
    signal duty_cycle_ld16 : std_logic_vector (6 downto 0) := (others => '0');
    signal pwm_ld17 : std_logic	:= '0';
    signal pwm_ld16 : std_logic	:= '0';
    signal counter : integer range 0 to c_counterlim := 0;
    signal timer50hz : integer range 0 to c_timer50hzlim := 0;

	signal salise_increment : std_logic := '0';
    signal saniye_increment : std_logic := '0';
    signal dakika_increment : std_logic := '0';
    signal start_deb : std_logic := '0';
    signal reset_deb : std_logic := '0';
    signal continue : std_logic := '0';
    signal start_deb_prev : std_logic := '0';
    
    signal salise_birler : std_logic_vector (3 downto 0) := (others => '0');
    signal salise_onlar : std_logic_vector (3 downto 0) := (others => '0');
    signal saniye_birler : std_logic_vector (3 downto 0) := (others => '0');
    signal saniye_onlar : std_logic_vector (3 downto 0) := (others => '0');
    signal dakika_birler : std_logic_vector (3 downto 0) := (others => '0');
    signal dakika_onlar : std_logic_vector (3 downto 0) := (others => '0');
    signal salise_birler_7seg : std_logic_vector (7 downto 0) := (others => '1');
    signal salise_onlar_7seg : std_logic_vector (7 downto 0) := (others => '1');
    signal saniye_birler_7seg : std_logic_vector (7 downto 0) := (others => '1');
    signal saniye_onlar_7seg : std_logic_vector (7 downto 0) := (others => '1');
    signal dakika_birler_7seg : std_logic_vector (7 downto 0) := (others => '1');
    signal dakika_onlar_7seg : std_logic_vector (7 downto 0) := (others => '1');
    signal anodes : std_logic_vector (7 downto 0) := "11111110";
    
    signal timer1ms : integer range 0 to c_timer1mslim := 0;
    signal salise_counter : integer range 0 to c_salise_counter_lim := 0;
    signal saniye_counter : integer range 0 to c_saniye_counter_lim := 0;
    signal dakika_counter : integer range 0 to c_dakika_counter_lim := 0;
    
    signal led : std_logic_vector(15 downto 0) := (others => '0');
	signal dout : std_logic_vector(7 downto 0) := (others => '0');
	signal rx_done_tick : std_logic := '0';
    
	-------------------------------------------------------------------------
    -- VGA Controller specific signals: Counters, Sync, R, G, B
    -------------------------------------------------------------------------
    -- Pixel clock, in this case 108 MHz
    signal pxl_clk : std_logic;
    -- The active signal is used to signal the active region of the screen (when not blank)
    signal active : std_logic;
  
    -- Horizontal and Vertical counters
    signal h_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0');
    signal v_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0');
  
    -- Pipe Horizontal and Vertical Counters
    signal h_cntr_reg_dly : std_logic_vector(11 downto 0) := (others => '0');
    signal v_cntr_reg_dly : std_logic_vector(11 downto 0) := (others => '0');
  
    -- Horizontal and Vertical Sync
    signal h_sync_reg : std_logic := not(H_POL);
    signal v_sync_reg : std_logic := not(V_POL);
    
    -- Pipe Horizontal and Vertical Sync
    signal h_sync_reg_dly : std_logic := not(H_POL);
    signal v_sync_reg_dly : std_logic :=  not(V_POL);
  
    -- VGA R, G and B signals coming from the main multiplexers
    signal vga_red_cmb : std_logic_vector(3 downto 0);
    signal vga_green_cmb : std_logic_vector(3 downto 0);
    signal vga_blue_cmb  : std_logic_vector(3 downto 0);
    
    --The main VGA R, G and B signals, validated by active
    signal vga_red : std_logic_vector(3 downto 0);
    signal vga_green : std_logic_vector(3 downto 0);
    signal vga_blue : std_logic_vector(3 downto 0);
    
    -- Register VGA R, G and B signals
    signal vga_red_reg : std_logic_vector(3 downto 0) := (others =>'0');
    signal vga_green_reg : std_logic_vector(3 downto 0) := (others =>'0');
    signal vga_blue_reg : std_logic_vector(3 downto 0) := (others =>'0');
	
	-- Mouse data signals
    signal MOUSE_X_POS: std_logic_vector (11 downto 0);
    signal MOUSE_Y_POS: std_logic_vector (11 downto 0);
    signal MOUSE_X_POS_REG: std_logic_vector (11 downto 0);
    signal MOUSE_Y_POS_REG: std_logic_vector (11 downto 0);
  
    -- Mouse cursor display signals
    signal mouse_cursor_red    : std_logic_vector (3 downto 0) := (others => '0');
    signal mouse_cursor_blue   : std_logic_vector (3 downto 0) := (others => '0');
    signal mouse_cursor_green  : std_logic_vector (3 downto 0) := (others => '0');
    
    -- Mouse cursor enable display signals
    signal enable_mouse_display:  std_logic;
    
    -- Registered Mouse cursor display signals
    signal mouse_cursor_red_dly   : std_logic_vector (3 downto 0) := (others => '0');
    signal mouse_cursor_blue_dly  : std_logic_vector (3 downto 0) := (others => '0');
    signal mouse_cursor_green_dly : std_logic_vector (3 downto 0) := (others => '0');
    
    -- Registered Mouse cursor enable display signals
    signal enable_mouse_display_dly  :  std_logic;
    
	-----------------------------------------------------------
    -- Signals for generating the background (moving colorbar)
    -----------------------------------------------------------
    signal cntDyn : integer range 0 to 2**28-1; -- counter for generating the colorbar
    signal intHcnt : integer range 0 to H_MAX - 1;
    signal intVcnt : integer range 0 to V_MAX - 1;
    
    -- Colorbar red, greeen and blue signals
    signal bg_red : std_logic_vector(3 downto 0);
    signal bg_blue : std_logic_vector(3 downto 0);
    signal bg_green : std_logic_vector(3 downto 0);
    
    -- Pipe the colorbar red, green and blue signals
    signal bg_red_dly : std_logic_vector(3 downto 0) := (others => '0');
    signal bg_green_dly : std_logic_vector(3 downto 0) := (others => '0');
    signal bg_blue_dly : std_logic_vector(3 downto 0) := (others => '0');   

begin
i_uart_rx : uart_rx
	-- buranin saginda icerde tanimladigim sinyalleri ya da inputlari yaziyorum
	generic map
	(
		c_clkfreq => c_clkfreq,
		c_baudrate => c_baudrate
	)
	port map
	(
		clk => clk,
		rx_i => rx_i,
		dout_o => dout,
		rx_done_tick_o => rx_done_tick
	);
	
i_pwm_ld17 : pwm
    generic map
    (
        c_clkfreq => c_clkfreq,
        c_pwmfreq => c_pwmfreq
    )
    port map
    (
        clk => clk,
        duty_cycle_i => duty_cycle_ld17,
        pwm_o => pwm_ld17
    );

i_pwm_ld16 : pwm
    generic map
    (
        c_clkfreq => c_clkfreq,
        c_pwmfreq => c_pwmfreq
    )
    port map
    (
        clk => clk,
        duty_cycle_i => duty_cycle_ld16,
        pwm_o => pwm_ld16
    );
    
duty_cycle_ld16	<= CONV_STD_LOGIC_VECTOR((50 - CONV_INTEGER(duty_cycle_ld17)),7);
	
i_start_deb : debounce
    generic map
    (
        c_clkfreq => c_clkfreq,
        c_debtime => 1000,
        c_initval => '0'
    )
    port map
    (
        clk => clk,
        signal_i => start_i,
        signal_o => start_deb
    );

i_reset_deb : debounce
    generic map
    (
        c_clkfreq => c_clkfreq,
        c_debtime => 1000,
        c_initval => '0'
    )
    port map
    (
        clk => clk,
        signal_i => reset_i,
        signal_o => reset_deb
    );

---------------------------------------------------------------------------------------
-- BCD INCREMENTOR INSTANTIATIONS
---------------------------------------------------------------------------------------
i_salise_bcd_increment : bcd_incrementor
    generic map
    (
        c_birlerlim	=> 9,
        c_onlarlim	=> 9
    )
    port map
    (
        clk	=> clk,
        increment_i	=> salise_increment,
        reset_i => reset_deb,
        birler_o => salise_birler,
        onlar_o => salise_onlar
    );

i_saniye_bcd_increment : bcd_incrementor
    generic map
    (
        c_birlerlim	=> 9,
        c_onlarlim	=> 5
    )
    port map
    (
        clk => clk,
        increment_i	=> saniye_increment,
        reset_i	=> reset_deb,
        birler_o => saniye_birler,
        onlar_o	=> saniye_onlar
    );

i_dakika_bcd_increment : bcd_incrementor
    generic map
    (
        c_birlerlim	=> 9,
        c_onlarlim	=> 5
    )
    port map
    (
        clk => clk,
        increment_i	=> dakika_increment,
        reset_i	=> reset_deb,
        birler_o => dakika_birler,
        onlar_o	=> dakika_onlar
    );

---------------------------------------------------------------------------------------
-- BCD TO SEVENSEGMENT INSTANTIATIONS
---------------------------------------------------------------------------------------
i_salise_birler_sevensegment : bcd_to_sevenseg
    port map
    (
        bcd_i => salise_birler,
        sevenseg_o => salise_birler_7seg
    );

i_salise_onlar_sevensegment : bcd_to_sevenseg
    port map
    (
        bcd_i => salise_onlar,
        sevenseg_o => salise_onlar_7seg
    );

i_saniye_birler_sevensegment : bcd_to_sevenseg
    port map
    (
        bcd_i => saniye_birler,
        sevenseg_o => saniye_birler_7seg
    );

i_saniye_onlar_sevensegment : bcd_to_sevenseg
    port map
    (
        bcd_i => saniye_onlar,
        sevenseg_o => saniye_onlar_7seg
    );

i_dakika_birler_sevensegment : bcd_to_sevenseg
    port map
    (
        bcd_i => dakika_birler,
        sevenseg_o => dakika_birler_7seg
    );

i_dakika_onlar_sevensegment : bcd_to_sevenseg
    port map
    (
        bcd_i => dakika_onlar,
        sevenseg_o => dakika_onlar_7seg
    );
    
clk_wiz_0_inst : clk_wiz_0
	port map
    (
		clk_in1 => clk,
		clk_out1 => pxl_clk
	);
	
----------------------------------------------------------------------------------
-- Mouse Controller
----------------------------------------------------------------------------------
Inst_MouseCtl: MouseCtl
    generic map
    (
       SYSCLK_FREQUENCY_HZ => 108000000,
       CHECK_PERIOD_MS     => 500,
       TIMEOUT_PERIOD_MS   => 100
    )
    port map
    (
      clk            => clk,
      rst            => '0',
      xpos           => MOUSE_X_POS,
      ypos           => MOUSE_Y_POS,
      zpos           => open,
      left           => open,
      middle         => open,
      right          => open,
      new_event      => open,
      value          => x"000",
      setx           => '0',
      sety           => '0',
      setmax_x       => '0',
      setmax_y       => '0',
      ps2_clk        => PS2_CLK,
      ps2_data       => PS2_DATA
    );
    
----------------------------------
-- Mouse Cursor display instance
----------------------------------
Inst_MouseDisplay: MouseDisplay
    port map 
    (
       pixel_clk  => clk,
       xpos  => MOUSE_X_POS_REG, 
       ypos  => MOUSE_Y_POS_REG,
       hcount => h_cntr_reg,
       vcount => v_cntr_reg,
       enable_mouse_display_out => enable_mouse_display,
       red_out  => mouse_cursor_red,
       green_out => mouse_cursor_green,
       blue_out => mouse_cursor_blue
    );   
     
---------------------------------------------------------------   
-- Generate Horizontal, Vertical counters and the Sync signals   
---------------------------------------------------------------
-- Horizontal counter
process (clk) 
begin
    if (rising_edge(clk)) then
        if (h_cntr_reg = (H_MAX - 1)) then
            h_cntr_reg <= (others =>'0');
        else
            h_cntr_reg <= h_cntr_reg + 1;
        end if;
    end if;
end process;

-- Vertical counter
process (clk)
begin
    if (rising_edge(clk)) then
        if ((h_cntr_reg = (H_MAX - 1)) and (v_cntr_reg = (V_MAX - 1))) then
            v_cntr_reg <= (others =>'0');
        elsif (h_cntr_reg = (H_MAX - 1)) then
            v_cntr_reg <= v_cntr_reg + 1;
        end if;
    end if;
end process;

-- Horizontal sync
process (clk)
begin
    if (rising_edge(clk)) then
        if (h_cntr_reg >= (H_FP + FRAME_WIDTH - 1)) and (h_cntr_reg < (H_FP + FRAME_WIDTH + H_PW - 1)) then
            h_sync_reg <= H_POL;
        else
            h_sync_reg <= not(H_POL);
        end if;
    end if;
end process;

 -- Vertical sync
process (clk)
begin
    if (rising_edge(clk)) then
        if (v_cntr_reg >= (V_FP + FRAME_HEIGHT - 1)) and (v_cntr_reg < (V_FP + FRAME_HEIGHT + V_PW - 1)) then
            v_sync_reg <= V_POL;
        else
            v_sync_reg <= not(V_POL);
        end if;
    end if;
end process;
	
--------------------   
-- The active    
--------------------  
-- active signal
active <= '1' when h_cntr_reg_dly < FRAME_WIDTH and v_cntr_reg_dly < FRAME_HEIGHT
               else '0';

--------------------
-- Register Inputs
--------------------
register_inputs: process (clk)
begin
    if (rising_edge(clk)) then
        if v_sync_reg = V_POL then
            MOUSE_X_POS_REG <= MOUSE_X_POS;
            MOUSE_Y_POS_REG <= MOUSE_Y_POS;
        end if;   
    end if;
end process register_inputs;
    	
process(clk)
begin
    if(rising_edge(clk)) then
        cntdyn <= cntdyn + 1;
    end if;
end process;

intHcnt <= conv_integer(h_cntr_reg);
intVcnt <= conv_integer(v_cntr_reg);
 
bg_red <= conv_std_logic_vector((-intvcnt - inthcnt - cntDyn/2**20),8)(7 downto 4);
bg_green <= conv_std_logic_vector((inthcnt - cntDyn/2**20),8)(7 downto 4);
bg_blue <= conv_std_logic_vector((intvcnt - cntDyn/2**20),8)(7 downto 4);
    
---------------------------------------------------------------------------------------------------
-- Register Outputs coming from the displaying components and the horizontal and vertical counters
---------------------------------------------------------------------------------------------------
process (clk)
begin
    if (rising_edge(clk)) then
        bg_red_dly <= bg_red;
        bg_green_dly <= bg_green;
        bg_blue_dly <= bg_blue;
        
        mouse_cursor_red_dly <= mouse_cursor_red;
        mouse_cursor_blue_dly <= mouse_cursor_blue;
        mouse_cursor_green_dly <= mouse_cursor_green;
        
        enable_mouse_display_dly <= enable_mouse_display;
        
        h_cntr_reg_dly <= h_cntr_reg;
        v_cntr_reg_dly <= v_cntr_reg;
    end if;
end process;
    
----------------------------------
-- VGA Output Muxing
----------------------------------
vga_red <= mouse_cursor_red_dly when enable_mouse_display_dly = '1' else
           bg_red_dly;
vga_green <= mouse_cursor_green_dly when enable_mouse_display_dly = '1' else
           bg_green_dly;
vga_blue <= mouse_cursor_blue_dly when enable_mouse_display_dly = '1' else
           bg_blue_dly;  


P_MAIN : process(clk) begin
	if (rising_edge(clk)) then
	    start_deb_prev <= start_deb;
	    
	   	if (start_deb = '1' and start_deb_prev = '0') then
		  continue <= not continue;
	    end if;
	
        salise_increment <= '0';
        saniye_increment <= '0';
        dakika_increment <= '0';

        if (continue = '1') then
            if (salise_counter = c_salise_counter_lim-1) then
                salise_counter <= 0;
                salise_increment <= '1';
                saniye_counter <= saniye_counter + 1;	-- 1 salise gecti			
            else
                salise_counter <= salise_counter + 1;
            end if;
            
            if (saniye_counter = c_saniye_counter_lim) then	-- c_saniye_counter_lim 100 salise olur
                saniye_counter <= 0;
                saniye_increment <= '1';
                dakika_counter <= dakika_counter + 1;
            end if;
            
            if (dakika_counter = c_dakika_counter_lim) then	-- c_dakika_counter_lim 60 salise olur
                dakika_counter <= 0;
                dakika_increment <= '1';			
            end if;		
        end if;
        
        if (reset_deb = '1') then
            salise_counter <= 0;
            saniye_counter <= 0;
            dakika_counter <= 0;
        end if;   
             
        if (counter < c_counterlim/2) then
            if (timer50hz = c_timer50hzlim-1) then
                duty_cycle_ld17	<= duty_cycle_ld17 + 1;
                timer50hz <= 0;
                counter <= counter + 1;
            else
                timer50hz <= timer50hz + 1;
            end if;	
        else
            if (timer50hz = c_timer50hzlim-1) then
                if (counter = c_counterlim) then
                    counter <= 0;
                else
                    counter <= counter + 1;	
                    duty_cycle_ld17	<= duty_cycle_ld17 - 1;				
                end if;			
                timer50hz <= 0;
            else
                timer50hz <= timer50hz + 1;
            end if;		
        end if; 
        
        counter_delay_2 <= counter_delay_2 + 1;
        case state_first is
            when IDLE =>
                if (rx_done_tick = '1') then
                    if (dout = x"52") then
                        state_first <= WAIT_STATE;
                    elsif (dout = x"47") then
                        state_first <= WAIT_STATE;
                    elsif (dout = x"42") then
                        state_first <= WAIT_STATE;
                    else 
                        state_first <= IDLE; --- dusun
                    end if;    
                end if;
            when WAIT_STATE =>
                if counter_delay_2 = Delay_Cycles*500 -1 then
                    counter_delay_2 <= 0;
                    state_first <= IDLE; 
                end if;
        end case;
	end if;
end process;

P_REG_OUT : process (clk, state_first, dout) begin
    if (rising_edge(clk)) then
		if (state_first = WAIT_STATE) then
		    if (dout = x"52") then 
                vga_red_cmb <= (active & active & active & active) and vga_red;
                vga_red_reg <= vga_red_cmb;
                led(7 downto 0) <= dout;
                led_color_o(5) <= pwm_ld17;
                led_color_o(2) <= pwm_ld16;
                
            elsif (dout = x"47") then
                vga_green_cmb <= (active & active & active & active) and vga_green;
                vga_green_reg <= vga_green_cmb;
                led(7 downto 0) <= dout;
                led_color_o(4) <= pwm_ld17;   
                led_color_o(1) <= pwm_ld16;   
                    
            elsif (dout = x"42") then
                vga_blue_cmb <= (active & active & active & active) and vga_blue;
                vga_blue_reg <= vga_blue_cmb;
                led(7 downto 0) <= dout;
                led_color_o(3) <= pwm_ld17;  
                led_color_o(0) <= pwm_ld16; 
                      
            else
                led(15 downto 0) <= (others => '0');
                led_color_o <= (others => '0');
            end if;
		end if;
		
        v_sync_reg_dly <= v_sync_reg;
        h_sync_reg_dly <= h_sync_reg;
        
    end if;
end process;

---------------------------------------------------------------------------------------
-- ANODES PROCESS
---------------------------------------------------------------------------------------
P_ANODES : process (clk) begin
    if (rising_edge(clk)) then
        anodes(7 downto 6)	<= "11";
        if (timer1ms = c_timer1mslim-1) then
            timer1ms <= 0;
            anodes(5 downto 1) <= anodes(4 downto 0);
            anodes(0) <= anodes(5);
        else
            timer1ms <= timer1ms + 1;
        end if;
    end if;
end process;

---------------------------------------------------------------------------------------
-- CATHODES PROCESS
---------------------------------------------------------------------------------------
P_CATHODES	: process (clk) begin
    if (rising_edge(clk)) then
        if (anodes(0) = '0') then
            seven_seg_o	<= salise_birler_7seg;
        elsif (anodes(1) = '0') then
            seven_seg_o	<= salise_onlar_7seg;
        elsif (anodes(2) = '0') then
            seven_seg_o <= saniye_birler_7seg;
            seven_seg_o(0) <= '0';
        elsif (anodes(3) = '0') then	
            seven_seg_o	<= saniye_onlar_7seg;
        elsif (anodes(4) = '0') then	
            seven_seg_o <= dakika_birler_7seg;
            seven_seg_o(0) <= '0';
        elsif (anodes(5) = '0') then	
            seven_seg_o	<= dakika_onlar_7seg;		
        else
            seven_seg_o	<= (others => '1');
        end if;
    end if;
end process;

-- led diye ayri bir sinyal olusturduk
-- leds_o denen output sinyalleri esitligin sag tarafinda kullanilamazlar, sadece atama yapilabilir,
-- read yapamayiz o yuzden sinyal olustururuz.
-- ayni sey diger sinyaller icin de gecerlidir.

-- Assign Outputs
leds_o <= led;
anodes_o <= anodes;
VGA_HS_O <= h_sync_reg_dly;
VGA_VS_O <= v_sync_reg_dly;
VGA_RED_O <= vga_red_reg;
VGA_GREEN_O <= vga_green_reg;
VGA_BLUE_O <= vga_blue_reg;

end Behavioral;
