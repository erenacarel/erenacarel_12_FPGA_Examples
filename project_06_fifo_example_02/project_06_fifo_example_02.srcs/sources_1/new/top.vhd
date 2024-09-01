library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port
	(
		clk, reset : in std_logic;
		wr, rd : in std_logic;
		full, empty : out std_logic;
		w_addr, r_addr : out std_logic_vector(1 downto 0)
	);
	
end top;


architecture Behavioral of top is

	constant N : natural := 2;
	signal w_ptr_reg, w_ptr_next : unsigned(N downto 0);
	signal r_ptr_reg, r_ptr_next : unsigned(N downto 0);
	signal full_flag, empty_flag : std_logic;
	
	begin
		process(clk, reset)
		begin
			if (reset = '1') then
				w_ptr_reg <= (others => '0');
				r_ptr_reg <= (others => '0');
			elsif (clk'event and clk = '1') then
				w_ptr_reg <= w_ptr_next;
				r_ptr_reg <= r_ptr_next;
			end if;
		end process;
		
		-- write pointer next-state logic
		w_ptr_next <= w_ptr_reg + 1 when wr = '1' and full_flag = '0' else
				w_ptr_reg;
		
		full_flag <= '1' when r_ptr_reg(N) /= w_ptr_reg(N) and r_ptr_reg(N-1 downto 0) = w_ptr_reg(N-1 downto 0)
						 else
						 '0';
						 
		--- write port outputs
		w_addr <= std_logic_vector(w_ptr_reg(N-1 downto 0));
		full <= full_flag;
		
		--- read pointer next state logic
		r_ptr_next <= r_ptr_reg + 1 when rd = '1' and empty_flag = '0' else
				r_ptr_reg;
				
		empty_flag <= '1' when r_ptr_reg = w_ptr_reg else
						'0';
						
		--- read port output
		r_addr <= std_logic_vector(r_ptr_reg(N-1 downto 0));
		empty <= empty_flag;
		
end Behavioral;

