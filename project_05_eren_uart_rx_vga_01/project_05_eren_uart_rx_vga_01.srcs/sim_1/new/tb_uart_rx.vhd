library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_uart_rx is
	generic
	(
		c_clkfreq : integer := 100_000_000;
		c_baudrate : integer := 115_200
	);
end tb_uart_rx;

architecture Behavioral of tb_uart_rx is

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

signal clk : std_logic := '0';
signal rx_i : std_logic := '1'; -- idle durum
signal dout_o : std_logic_vector(7 downto 0);
signal rx_done_tick_o : std_logic;

constant c_clkperiod : time := 10 ns;
constant c_baud115200 : time := 8.68 us; -- her bir rx bitinin beklenip gonderilme suresi

-- rx'i simule etmek icin bu degiskenleri kullandik
constant c_hex52 : std_logic_vector(9 downto 0) := '1' & x"52" & '0';  -- Red -- aslinda 10 bitlik sinyal 
constant c_hex47 : std_logic_vector(9 downto 0) := '1' & x"47" & '0';  -- Green
constant c_hex42 : std_logic_vector(9 downto 0) := '1' & x"42" & '0';  -- Blue

begin

-- Instantiation
DUT : uart_rx  -- Design Under Table
generic map
(
	c_clkfreq => c_clkfreq,
	c_baudrate => c_baudrate
)
port map
(
	clk => clk,
	rx_i => rx_i,
	dout_o => dout_o,
	rx_done_tick_o => rx_done_tick_o
);

P_CLKGEN : process begin

clk <= '0';
wait for c_clkperiod/2;
clk <= '1';
wait for c_clkperiod/2;

end process P_CLKGEN;

P_STIMULI : process begin

wait for c_clkperiod*10;

for i in 0 to 9 loop
	rx_i <= c_hex52(i);
	wait for c_baud115200;
end loop;

wait for 10 us;

for i in 0 to 9 loop
	rx_i <= c_hex47(i);
	wait for c_baud115200;
end loop;

wait for 10 us;

for i in 0 to 9 loop
	rx_i <= c_hex42(i);
	wait for c_baud115200;
end loop;

wait for 20 us;

assert false
report "SIM DONE"
severity failure;

end process P_STIMULI;

end Behavioral;
