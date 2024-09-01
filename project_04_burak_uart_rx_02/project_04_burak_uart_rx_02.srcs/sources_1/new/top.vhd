library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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
        led_color_o	: out std_logic_vector (5 downto 0) -- transistor base'sine giden led output
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
            c_initval : std_logic	:= '0'
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

	signal led : std_logic_vector(15 downto 0) := (others => '0');
	signal dout : std_logic_vector(7 downto 0) := (others => '0');
	signal rx_done_tick : std_logic := '0';
	
	constant c_timer1mslim : integer := c_clkfreq/1000;
    constant c_salise_counter_lim : integer := c_clkfreq/100;
    constant c_saniye_counter_lim : integer := 100;	-- 100 saliseye kadar sayacak ve 1 artacak saniye
    constant c_dakika_counter_lim : integer := 60;	-- 60 saniyeye kadar sayacak ve 1 artacak dakika

    constant c_counterlim : integer := 100;
    constant c_timer50hzlim	: integer := c_clkfreq/50;
    
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
    
    signal timer1ms : integer range 0 to c_timer1mslim 			:= 0;
    signal salise_counter : integer range 0 to c_salise_counter_lim 	:= 0;
    signal saniye_counter : integer range 0 to c_saniye_counter_lim 	:= 0;
    signal dakika_counter : integer range 0 to c_dakika_counter_lim 	:= 0;

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
              ----
	end if;
end process;

P_REG_OUT : process (clk) begin
    if (rising_edge(clk)) then
		if (rx_done_tick = '1') then
		    if (dout = x"52") then 
                led(7 downto 0) <= dout;
                led_color_o(5) <= pwm_ld17;
                led_color_o(2) <= pwm_ld16;
            elsif (dout = x"47") then
                led(7 downto 0) <= dout;
                led_color_o(4) <= pwm_ld17;   
                led_color_o(1) <= pwm_ld16;         
            elsif (dout = x"42") then
                led(7 downto 0) <= dout;
                led_color_o(3) <= pwm_ld17;  
                led_color_o(0) <= pwm_ld16;      
            else
                led(15 downto 0) <= (others => '0');
                led_color_o <= (others => '0');
            end if;
		end if;
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

--led diye ayri bir sinyal olusturduk
-- leds_o denen output sinyalleri esitligin sag tarafinda kullanilamazlar, sadece atama yapilabilir,
-- read yapamayiz o yuzden sinyal olustururuz.
leds_o <= led;

anodes_o <= anodes;

end Behavioral;
