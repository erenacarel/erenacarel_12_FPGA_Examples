----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2024 10:00:27
-- Design Name: 
-- Module Name: full_adder - rtl
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity full_adder is
    Port 
	( 
		i_bit1 : in std_logic;
	    i_bit2 : in std_logic;
	    i_carry : in std_logic;
	
		o_sum : out std_logic;
	    o_carry : out std_logic
	);
end full_adder;

architecture rtl of full_adder is

	signal w_WIRE_1 : std_logic;
	signal w_WIRE_2 : std_logic;
	signal w_WIRE_3 : std_logic;

begin
	w_WIRE_1 <= i_bit1 xor i_bit2;
	w_WIRE_2 <= w_WIRE_1 and i_carry;
	w_WIRE_3 <= i_bit1 and i_bit2;

	o_sum <= w_WIRE_1 xor i_carry;
	o_carry <= w_WIRE_2 or w_WIRE_3;

end rtl;
