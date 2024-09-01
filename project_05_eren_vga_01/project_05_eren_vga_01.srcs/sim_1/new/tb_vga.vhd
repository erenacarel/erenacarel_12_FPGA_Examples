library ieee;
use ieee.std_logic_1164.all;

entity tb_top is
end tb_top;

architecture Behavioral of tb_top is

    component top
        port (CLK_I       : in std_logic;
              VGA_HS_O    : out std_logic;
              VGA_VS_O    : out std_logic;
              VGA_RED_O   : out std_logic_vector (3 downto 0);
              VGA_BLUE_O  : out std_logic_vector (3 downto 0);
              VGA_GREEN_O : out std_logic_vector (3 downto 0);
              PS2_CLK     : inout std_logic;
              PS2_DATA    : inout std_logic);
    end component;

    signal CLK_I       : std_logic;
    signal VGA_HS_O    : std_logic;
    signal VGA_VS_O    : std_logic;
    signal VGA_RED_O   : std_logic_vector (3 downto 0);
    signal VGA_BLUE_O  : std_logic_vector (3 downto 0);
    signal VGA_GREEN_O : std_logic_vector (3 downto 0);
    signal PS2_CLK     : std_logic;
    signal PS2_DATA    : std_logic;

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : top
    port map (CLK_I       => CLK_I,
              VGA_HS_O    => VGA_HS_O,
              VGA_VS_O    => VGA_VS_O,
              VGA_RED_O   => VGA_RED_O,
              VGA_BLUE_O  => VGA_BLUE_O,
              VGA_GREEN_O => VGA_GREEN_O,
              PS2_CLK     => PS2_CLK,
              PS2_DATA    => PS2_DATA);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK_I is really your main clock signal
    CLK_I <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed

        -- Reset generation
        --  EDIT: Replace YOURRESETSIGNAL below by the name of your reset as I haven't guessed it
        YOURRESETSIGNAL <= '1';
        wait for 100 ns;
        YOURRESETSIGNAL <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_top of tb_top is
    for tb
    end for;
end cfg_tb_top;