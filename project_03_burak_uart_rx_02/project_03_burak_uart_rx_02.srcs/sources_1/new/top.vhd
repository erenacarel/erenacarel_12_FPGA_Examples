library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    generic
    (
        c_clkfreq : integer := 100_000_000;
        c_baudrate : integer := 115_200
    );
	port
	(
		clk : in std_logic;
		rx_i : in std_logic;
		leds_o : out std_logic_vector(15 downto 0)
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
end component;  -- begin altinda instantiate et

signal led : std_logic_vector(15 downto 0) := (others => '0');
signal dout : std_logic_vector(7 downto 0) := (others =>'0');
signal rx_done_tick : std_logic := '0';

begin

i_uart_rx : uart_rx
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

P_MAIN : process(clk) begin
    if (rising_edge(clk)) then
        led(15 downto 8) <= led(7 downto 0);
        led(7 downto 0) <= dout;
    end if;
end process;

leds_o <= led;

end Behavioral;

