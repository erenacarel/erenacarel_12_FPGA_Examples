-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.2.2 (win64) Build 4126759 Thu Feb  8 23:53:51 MST 2024
-- Date        : Wed May 15 15:09:06 2024
-- Host        : ERENACAREL running 64-bit major release  (build 9200)
-- Command     : write_vhdl -mode funcsim -nolib -force -file
--               C:/Users/eren1/VivadoProjects/project_03_burak_uart_rx_01/project_03_burak_uart_rx_01.sim/sim_1/synth/func/xsim/tb_uart_rx_func_synth.vhd
-- Design      : uart_rx
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity uart_rx is
  port (
    clk : in STD_LOGIC;
    rx_i : in STD_LOGIC;
    dout_o : out STD_LOGIC_VECTOR ( 7 downto 0 );
    rx_done_tick_o : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of uart_rx : entity is true;
  attribute c_baudrate : integer;
  attribute c_baudrate of uart_rx : entity is 115200;
  attribute c_clkfreq : integer;
  attribute c_clkfreq of uart_rx : entity is 100000000;
end uart_rx;

architecture STRUCTURE of uart_rx is
  signal \FSM_sequential_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state[0]_i_2_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state[1]_i_2_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state[1]_i_3_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state[1]_i_4_n_0\ : STD_LOGIC;
  signal \bitcntr[0]_i_1_n_0\ : STD_LOGIC;
  signal \bitcntr[1]_i_1_n_0\ : STD_LOGIC;
  signal \bitcntr[2]_i_1_n_0\ : STD_LOGIC;
  signal \bitcntr[2]_i_2_n_0\ : STD_LOGIC;
  signal \bitcntr_reg_n_0_[0]\ : STD_LOGIC;
  signal \bitcntr_reg_n_0_[1]\ : STD_LOGIC;
  signal \bitcntr_reg_n_0_[2]\ : STD_LOGIC;
  signal \bittimer[0]_i_1_n_0\ : STD_LOGIC;
  signal \bittimer[10]_i_1_n_0\ : STD_LOGIC;
  signal \bittimer[10]_i_2_n_0\ : STD_LOGIC;
  signal \bittimer[1]_i_1_n_0\ : STD_LOGIC;
  signal \bittimer[2]_i_1_n_0\ : STD_LOGIC;
  signal \bittimer[3]_i_1_n_0\ : STD_LOGIC;
  signal \bittimer[4]_i_1_n_0\ : STD_LOGIC;
  signal \bittimer[5]_i_1_n_0\ : STD_LOGIC;
  signal \bittimer[6]_i_1_n_0\ : STD_LOGIC;
  signal \bittimer[6]_i_2_n_0\ : STD_LOGIC;
  signal \bittimer[6]_i_3_n_0\ : STD_LOGIC;
  signal \bittimer[6]_i_4_n_0\ : STD_LOGIC;
  signal \bittimer[6]_i_5_n_0\ : STD_LOGIC;
  signal \bittimer[6]_i_6_n_0\ : STD_LOGIC;
  signal \bittimer[7]_i_1_n_0\ : STD_LOGIC;
  signal \bittimer[8]_i_1_n_0\ : STD_LOGIC;
  signal \bittimer[9]_i_1_n_0\ : STD_LOGIC;
  signal \bittimer[9]_i_2_n_0\ : STD_LOGIC;
  signal \bittimer_reg_n_0_[0]\ : STD_LOGIC;
  signal \bittimer_reg_n_0_[10]\ : STD_LOGIC;
  signal \bittimer_reg_n_0_[1]\ : STD_LOGIC;
  signal \bittimer_reg_n_0_[2]\ : STD_LOGIC;
  signal \bittimer_reg_n_0_[3]\ : STD_LOGIC;
  signal \bittimer_reg_n_0_[4]\ : STD_LOGIC;
  signal \bittimer_reg_n_0_[5]\ : STD_LOGIC;
  signal \bittimer_reg_n_0_[6]\ : STD_LOGIC;
  signal \bittimer_reg_n_0_[7]\ : STD_LOGIC;
  signal \bittimer_reg_n_0_[8]\ : STD_LOGIC;
  signal \bittimer_reg_n_0_[9]\ : STD_LOGIC;
  signal clk_IBUF : STD_LOGIC;
  signal clk_IBUF_BUFG : STD_LOGIC;
  signal dout_o_OBUF : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal rx_done_tick_o0 : STD_LOGIC;
  signal rx_done_tick_o_OBUF : STD_LOGIC;
  signal rx_done_tick_o_i_2_n_0 : STD_LOGIC;
  signal rx_i_IBUF : STD_LOGIC;
  signal \state__0\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_sequential_state[0]_i_2\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \FSM_sequential_state[1]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \FSM_sequential_state[1]_i_4\ : label is "soft_lutpair5";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[0]\ : label is "s_idle:00,s_start:01,s_data:10,s_stop:11";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[1]\ : label is "s_idle:00,s_start:01,s_data:10,s_stop:11";
  attribute SOFT_HLUTNM of \bitcntr[0]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \bitcntr[1]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \bitcntr[2]_i_2\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \bittimer[0]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \bittimer[10]_i_2\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \bittimer[1]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \bittimer[3]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \bittimer[4]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \bittimer[6]_i_2\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \bittimer[7]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \bittimer[8]_i_1\ : label is "soft_lutpair2";
begin
\FSM_sequential_state[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"22222222000F555F"
    )
        port map (
      I0 => \FSM_sequential_state[1]_i_3_n_0\,
      I1 => \FSM_sequential_state[1]_i_2_n_0\,
      I2 => \state__0\(1),
      I3 => rx_i_IBUF,
      I4 => \FSM_sequential_state[0]_i_2_n_0\,
      I5 => \state__0\(0),
      O => \FSM_sequential_state[0]_i_1_n_0\
    );
\FSM_sequential_state[0]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"7F"
    )
        port map (
      I0 => \bitcntr_reg_n_0_[2]\,
      I1 => \bitcntr_reg_n_0_[1]\,
      I2 => \bitcntr_reg_n_0_[0]\,
      O => \FSM_sequential_state[0]_i_2_n_0\
    );
\FSM_sequential_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6A66"
    )
        port map (
      I0 => \state__0\(1),
      I1 => \state__0\(0),
      I2 => \FSM_sequential_state[1]_i_2_n_0\,
      I3 => \FSM_sequential_state[1]_i_3_n_0\,
      O => \FSM_sequential_state[1]_i_1_n_0\
    );
\FSM_sequential_state[1]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000020"
    )
        port map (
      I0 => \bittimer[6]_i_4_n_0\,
      I1 => \bittimer_reg_n_0_[9]\,
      I2 => \bittimer_reg_n_0_[7]\,
      I3 => \bittimer_reg_n_0_[6]\,
      I4 => \FSM_sequential_state[1]_i_4_n_0\,
      O => \FSM_sequential_state[1]_i_2_n_0\
    );
\FSM_sequential_state[1]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFBFF"
    )
        port map (
      I0 => \bittimer[6]_i_5_n_0\,
      I1 => \bittimer_reg_n_0_[1]\,
      I2 => \bittimer_reg_n_0_[4]\,
      I3 => \bittimer_reg_n_0_[6]\,
      I4 => \FSM_sequential_state[1]_i_4_n_0\,
      O => \FSM_sequential_state[1]_i_3_n_0\
    );
\FSM_sequential_state[1]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"7F"
    )
        port map (
      I0 => \bittimer_reg_n_0_[8]\,
      I1 => \bittimer_reg_n_0_[0]\,
      I2 => \bittimer_reg_n_0_[5]\,
      O => \FSM_sequential_state[1]_i_4_n_0\
    );
\FSM_sequential_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \FSM_sequential_state[0]_i_1_n_0\,
      Q => \state__0\(0),
      R => '0'
    );
\FSM_sequential_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \FSM_sequential_state[1]_i_1_n_0\,
      Q => \state__0\(1),
      R => '0'
    );
\bitcntr[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \bitcntr_reg_n_0_[0]\,
      O => \bitcntr[0]_i_1_n_0\
    );
\bitcntr[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \bitcntr_reg_n_0_[0]\,
      I1 => \bitcntr_reg_n_0_[1]\,
      O => \bitcntr[1]_i_1_n_0\
    );
\bitcntr[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \state__0\(0),
      I1 => \FSM_sequential_state[1]_i_3_n_0\,
      O => \bitcntr[2]_i_1_n_0\
    );
\bitcntr[2]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => \bitcntr_reg_n_0_[2]\,
      I1 => \bitcntr_reg_n_0_[1]\,
      I2 => \bitcntr_reg_n_0_[0]\,
      O => \bitcntr[2]_i_2_n_0\
    );
\bitcntr_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \bitcntr[2]_i_1_n_0\,
      D => \bitcntr[0]_i_1_n_0\,
      Q => \bitcntr_reg_n_0_[0]\,
      R => '0'
    );
\bitcntr_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \bitcntr[2]_i_1_n_0\,
      D => \bitcntr[1]_i_1_n_0\,
      Q => \bitcntr_reg_n_0_[1]\,
      R => '0'
    );
\bitcntr_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \bitcntr[2]_i_1_n_0\,
      D => \bitcntr[2]_i_2_n_0\,
      Q => \bitcntr_reg_n_0_[2]\,
      R => '0'
    );
\bittimer[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4440"
    )
        port map (
      I0 => \bittimer_reg_n_0_[0]\,
      I1 => \FSM_sequential_state[1]_i_3_n_0\,
      I2 => \state__0\(1),
      I3 => \state__0\(0),
      O => \bittimer[0]_i_1_n_0\
    );
\bittimer[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"09"
    )
        port map (
      I0 => \bittimer_reg_n_0_[10]\,
      I1 => \bittimer[10]_i_2_n_0\,
      I2 => \bittimer[6]_i_1_n_0\,
      O => \bittimer[10]_i_1_n_0\
    );
\bittimer[10]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F7FFFFFF"
    )
        port map (
      I0 => \bittimer_reg_n_0_[8]\,
      I1 => \bittimer_reg_n_0_[6]\,
      I2 => \bittimer[9]_i_2_n_0\,
      I3 => \bittimer_reg_n_0_[7]\,
      I4 => \bittimer_reg_n_0_[9]\,
      O => \bittimer[10]_i_2_n_0\
    );
\bittimer[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \bittimer_reg_n_0_[1]\,
      I1 => \bittimer_reg_n_0_[0]\,
      O => \bittimer[1]_i_1_n_0\
    );
\bittimer[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => \bittimer_reg_n_0_[2]\,
      I1 => \bittimer_reg_n_0_[0]\,
      I2 => \bittimer_reg_n_0_[1]\,
      O => \bittimer[2]_i_1_n_0\
    );
\bittimer[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => \bittimer_reg_n_0_[3]\,
      I1 => \bittimer_reg_n_0_[2]\,
      I2 => \bittimer_reg_n_0_[1]\,
      I3 => \bittimer_reg_n_0_[0]\,
      O => \bittimer[3]_i_1_n_0\
    );
\bittimer[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => \bittimer_reg_n_0_[4]\,
      I1 => \bittimer_reg_n_0_[3]\,
      I2 => \bittimer_reg_n_0_[0]\,
      I3 => \bittimer_reg_n_0_[1]\,
      I4 => \bittimer_reg_n_0_[2]\,
      O => \bittimer[4]_i_1_n_0\
    );
\bittimer[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => \bittimer_reg_n_0_[5]\,
      I1 => \bittimer_reg_n_0_[4]\,
      I2 => \bittimer_reg_n_0_[2]\,
      I3 => \bittimer_reg_n_0_[1]\,
      I4 => \bittimer_reg_n_0_[0]\,
      I5 => \bittimer_reg_n_0_[3]\,
      O => \bittimer[5]_i_1_n_0\
    );
\bittimer[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"444F444F444FFFFF"
    )
        port map (
      I0 => \bittimer[6]_i_3_n_0\,
      I1 => \bittimer[6]_i_4_n_0\,
      I2 => \bittimer[6]_i_5_n_0\,
      I3 => \bittimer[6]_i_6_n_0\,
      I4 => \state__0\(1),
      I5 => \state__0\(0),
      O => \bittimer[6]_i_1_n_0\
    );
\bittimer[6]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \bittimer_reg_n_0_[6]\,
      I1 => \bittimer[9]_i_2_n_0\,
      O => \bittimer[6]_i_2_n_0\
    );
\bittimer[6]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFF7FFFFF"
    )
        port map (
      I0 => \bittimer_reg_n_0_[5]\,
      I1 => \bittimer_reg_n_0_[0]\,
      I2 => \bittimer_reg_n_0_[8]\,
      I3 => \bittimer_reg_n_0_[6]\,
      I4 => \bittimer_reg_n_0_[7]\,
      I5 => \bittimer_reg_n_0_[9]\,
      O => \bittimer[6]_i_3_n_0\
    );
\bittimer[6]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => \bittimer_reg_n_0_[10]\,
      I1 => \bittimer_reg_n_0_[3]\,
      I2 => \state__0\(1),
      I3 => \bittimer_reg_n_0_[1]\,
      I4 => \bittimer_reg_n_0_[2]\,
      I5 => \bittimer_reg_n_0_[4]\,
      O => \bittimer[6]_i_4_n_0\
    );
\bittimer[6]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFEFFFFFFFFFF"
    )
        port map (
      I0 => \bittimer_reg_n_0_[10]\,
      I1 => \bittimer_reg_n_0_[3]\,
      I2 => \bittimer_reg_n_0_[2]\,
      I3 => \bittimer_reg_n_0_[9]\,
      I4 => \bittimer_reg_n_0_[7]\,
      I5 => \state__0\(1),
      O => \bittimer[6]_i_5_n_0\
    );
\bittimer[6]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF7FFFFFFFFFFF"
    )
        port map (
      I0 => \bittimer_reg_n_0_[5]\,
      I1 => \bittimer_reg_n_0_[0]\,
      I2 => \bittimer_reg_n_0_[8]\,
      I3 => \bittimer_reg_n_0_[6]\,
      I4 => \bittimer_reg_n_0_[4]\,
      I5 => \bittimer_reg_n_0_[1]\,
      O => \bittimer[6]_i_6_n_0\
    );
\bittimer[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"00D2"
    )
        port map (
      I0 => \bittimer_reg_n_0_[6]\,
      I1 => \bittimer[9]_i_2_n_0\,
      I2 => \bittimer_reg_n_0_[7]\,
      I3 => \bittimer[6]_i_1_n_0\,
      O => \bittimer[7]_i_1_n_0\
    );
\bittimer[8]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000DF20"
    )
        port map (
      I0 => \bittimer_reg_n_0_[6]\,
      I1 => \bittimer[9]_i_2_n_0\,
      I2 => \bittimer_reg_n_0_[7]\,
      I3 => \bittimer_reg_n_0_[8]\,
      I4 => \bittimer[6]_i_1_n_0\,
      O => \bittimer[8]_i_1_n_0\
    );
\bittimer[9]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000DFFF2000"
    )
        port map (
      I0 => \bittimer_reg_n_0_[7]\,
      I1 => \bittimer[9]_i_2_n_0\,
      I2 => \bittimer_reg_n_0_[6]\,
      I3 => \bittimer_reg_n_0_[8]\,
      I4 => \bittimer_reg_n_0_[9]\,
      I5 => \bittimer[6]_i_1_n_0\,
      O => \bittimer[9]_i_1_n_0\
    );
\bittimer[9]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFFFFFFFFFF"
    )
        port map (
      I0 => \bittimer_reg_n_0_[4]\,
      I1 => \bittimer_reg_n_0_[2]\,
      I2 => \bittimer_reg_n_0_[1]\,
      I3 => \bittimer_reg_n_0_[0]\,
      I4 => \bittimer_reg_n_0_[3]\,
      I5 => \bittimer_reg_n_0_[5]\,
      O => \bittimer[9]_i_2_n_0\
    );
\bittimer_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \bittimer[0]_i_1_n_0\,
      Q => \bittimer_reg_n_0_[0]\,
      R => '0'
    );
\bittimer_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \bittimer[10]_i_1_n_0\,
      Q => \bittimer_reg_n_0_[10]\,
      R => '0'
    );
\bittimer_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \bittimer[1]_i_1_n_0\,
      Q => \bittimer_reg_n_0_[1]\,
      R => \bittimer[6]_i_1_n_0\
    );
\bittimer_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \bittimer[2]_i_1_n_0\,
      Q => \bittimer_reg_n_0_[2]\,
      R => \bittimer[6]_i_1_n_0\
    );
\bittimer_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \bittimer[3]_i_1_n_0\,
      Q => \bittimer_reg_n_0_[3]\,
      R => \bittimer[6]_i_1_n_0\
    );
\bittimer_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \bittimer[4]_i_1_n_0\,
      Q => \bittimer_reg_n_0_[4]\,
      R => \bittimer[6]_i_1_n_0\
    );
\bittimer_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \bittimer[5]_i_1_n_0\,
      Q => \bittimer_reg_n_0_[5]\,
      R => \bittimer[6]_i_1_n_0\
    );
\bittimer_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \bittimer[6]_i_2_n_0\,
      Q => \bittimer_reg_n_0_[6]\,
      R => \bittimer[6]_i_1_n_0\
    );
\bittimer_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \bittimer[7]_i_1_n_0\,
      Q => \bittimer_reg_n_0_[7]\,
      R => '0'
    );
\bittimer_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \bittimer[8]_i_1_n_0\,
      Q => \bittimer_reg_n_0_[8]\,
      R => '0'
    );
\bittimer_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \bittimer[9]_i_1_n_0\,
      Q => \bittimer_reg_n_0_[9]\,
      R => '0'
    );
clk_IBUF_BUFG_inst: unisim.vcomponents.BUFG
     port map (
      I => clk_IBUF,
      O => clk_IBUF_BUFG
    );
clk_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => clk,
      O => clk_IBUF
    );
\dout_o_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => dout_o_OBUF(0),
      O => dout_o(0)
    );
\dout_o_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => dout_o_OBUF(1),
      O => dout_o(1)
    );
\dout_o_OBUF[2]_inst\: unisim.vcomponents.OBUF
     port map (
      I => dout_o_OBUF(2),
      O => dout_o(2)
    );
\dout_o_OBUF[3]_inst\: unisim.vcomponents.OBUF
     port map (
      I => dout_o_OBUF(3),
      O => dout_o(3)
    );
\dout_o_OBUF[4]_inst\: unisim.vcomponents.OBUF
     port map (
      I => dout_o_OBUF(4),
      O => dout_o(4)
    );
\dout_o_OBUF[5]_inst\: unisim.vcomponents.OBUF
     port map (
      I => dout_o_OBUF(5),
      O => dout_o(5)
    );
\dout_o_OBUF[6]_inst\: unisim.vcomponents.OBUF
     port map (
      I => dout_o_OBUF(6),
      O => dout_o(6)
    );
\dout_o_OBUF[7]_inst\: unisim.vcomponents.OBUF
     port map (
      I => dout_o_OBUF(7),
      O => dout_o(7)
    );
rx_done_tick_o_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => rx_done_tick_o_OBUF,
      O => rx_done_tick_o
    );
rx_done_tick_o_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \state__0\(1),
      I1 => \state__0\(0),
      O => rx_done_tick_o0
    );
rx_done_tick_o_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \state__0\(0),
      I1 => \FSM_sequential_state[1]_i_3_n_0\,
      O => rx_done_tick_o_i_2_n_0
    );
rx_done_tick_o_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => rx_done_tick_o_i_2_n_0,
      D => '1',
      Q => rx_done_tick_o_OBUF,
      R => rx_done_tick_o0
    );
rx_i_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => rx_i,
      O => rx_i_IBUF
    );
\shreg_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \bitcntr[2]_i_1_n_0\,
      D => dout_o_OBUF(1),
      Q => dout_o_OBUF(0),
      R => '0'
    );
\shreg_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \bitcntr[2]_i_1_n_0\,
      D => dout_o_OBUF(2),
      Q => dout_o_OBUF(1),
      R => '0'
    );
\shreg_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \bitcntr[2]_i_1_n_0\,
      D => dout_o_OBUF(3),
      Q => dout_o_OBUF(2),
      R => '0'
    );
\shreg_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \bitcntr[2]_i_1_n_0\,
      D => dout_o_OBUF(4),
      Q => dout_o_OBUF(3),
      R => '0'
    );
\shreg_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \bitcntr[2]_i_1_n_0\,
      D => dout_o_OBUF(5),
      Q => dout_o_OBUF(4),
      R => '0'
    );
\shreg_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \bitcntr[2]_i_1_n_0\,
      D => dout_o_OBUF(6),
      Q => dout_o_OBUF(5),
      R => '0'
    );
\shreg_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \bitcntr[2]_i_1_n_0\,
      D => dout_o_OBUF(7),
      Q => dout_o_OBUF(6),
      R => '0'
    );
\shreg_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \bitcntr[2]_i_1_n_0\,
      D => rx_i_IBUF,
      Q => dout_o_OBUF(7),
      R => '0'
    );
end STRUCTURE;
