library ieee;
use ieee.std_logic_1164.all;

entity tb_top is
end tb_top;

architecture tb of tb_top is

    component top
        port (clk         : in std_logic;
              start_i     : in std_logic;
              reset_i     : in std_logic;
              seven_seg_o : out std_logic_vector (7 downto 0);
              anodes_o    : out std_logic_vector (7 downto 0));
    end component;

    signal clk         : std_logic;
    signal start_i     : std_logic;
    signal reset_i     : std_logic;
    signal seven_seg_o : std_logic_vector (7 downto 0);
    signal anodes_o    : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : top
    port map (clk         => clk,
              start_i     => start_i,
              reset_i     => reset_i,
              seven_seg_o => seven_seg_o,
              anodes_o    => anodes_o);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        start_i <= '0';

        -- Reset generation
        -- EDIT: Check that reset_i is really your reset signal
        reset_i <= '1';
        wait for 100 ns;
        reset_i <= '0';
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