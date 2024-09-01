----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.05.2024 13:19:20
-- Design Name: 
-- Module Name: and2 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL;
-- use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity and2 is
	Port ( 
		in1_i     : in std_logic_vector(7 downto 0);
		in2_i     : in std_logic_vector(7 downto 0);
		and_out_o : out STD_LOGIC
	);
end and2;

architecture Behavioral of and2 is
signal and_out_int : integer range 0 to 255 := 0;
	begin
	and_out_int <= TO_INTEGER(unsigned(in1_i) + unsigned(in2_i));
	process (and_out_int) 
		begin
			if (and_out_int > 20) then
				and_out_o <= '1';
			else
				and_out_o <= '0';
			end if;
	end process;
end Behavioral;
