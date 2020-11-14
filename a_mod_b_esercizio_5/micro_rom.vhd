----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:11:15 11/12/2020 
-- Design Name: 
-- Module Name:    micro_rom - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity micro_rom is
    Port ( PC : in  unsigned(3 downto 0);
           PC_next : out  unsigned(3 downto 0);
           en_a : out  STD_LOGIC;
           en_b : out  STD_LOGIC;
           sel_a : out  STD_LOGIC;
           sel_b : out  STD_LOGIC;
           received_a : out  STD_LOGIC;
           received_b : out  STD_LOGIC;
           end_operation : out  STD_LOGIC);
end micro_rom;

architecture Behavioral of micro_rom is

type cntrl_record is record
	PC_next : unsigned(3 downto 0);
	en_a : STD_LOGIC;
	en_b : STD_LOGIC;
	sel_a : STD_LOGIC;
	sel_b : STD_LOGIC;
	received_a : STD_LOGIC;
	received_b : STD_LOGIC;
	end_operation : STD_LOGIC;
end record;

Constant idle_no_start : cntrl_record := (
	PC_next => "0000", sel_a => '0', sel_b => '0', en_a => '0',
	en_b => '0', received_a => '0', received_b => '0', end_operation => '0'
);

Constant idle_start : cntrl_record := (
	PC_next => "0010", sel_a => '0', sel_b => '0', en_a => '0',
	en_b => '0', received_a => '0', received_b => '0', end_operation => '0'
);

Constant in1_start_a : cntrl_record := (
	PC_next => "0010", sel_a => '1', sel_b => '0', en_a => '0',
	en_b => '0', received_a => '1', received_b => '0', end_operation => '0'
);

Constant in1_start_b : cntrl_record := (
	PC_next => "0101", sel_a => '1', sel_b => '0', en_a => '0',
	en_b => '0', received_a => '0', received_b => '0', end_operation => '0'
);

Constant in1_no_start : cntrl_record := (
	PC_next => "0100", sel_a => '1', sel_b => '0', en_a => '1',
	en_b => '0', received_a => '0', received_b => '0', end_operation => '0'
);

Constant in2_start_b : cntrl_record := (
	PC_next => "0101", sel_a => '0', sel_b => '1', en_a => '0',
	en_b => '0', received_a => '0', received_b => '1', end_operation => '0'
);

Constant in2_no_start : cntrl_record := (
	PC_next => "0111", sel_a => '0', sel_b => '0', en_a => '0',
	en_b => '1', received_a => '0', received_b => '0', end_operation => '0'
);

Constant op1_cout_0 : cntrl_record := (
	PC_next => "1001", sel_a => '0', sel_b => '0', en_a => '1',
	en_b => '0', received_a => '0', received_b => '0', end_operation => '0'
);

Constant op1_cout_1 : cntrl_record := (
	PC_next => "1011", sel_a => '0', sel_b => '0', en_a => '0',
	en_b => '1', received_a => '0', received_b => '0', end_operation => '0'
);

Constant op2_cout_0 : cntrl_record := (
	PC_next => "0111", sel_a => '0', sel_b => '0', en_a => '0',
	en_b => '0', received_a => '0', received_b => '0', end_operation => '0'
);

Constant op2_cout_1 : cntrl_record := (
	PC_next => "1011", sel_a => '0', sel_b => '0', en_a => '0',
	en_b => '1', received_a => '0', received_b => '0', end_operation => '0'
);

Constant end_op_no_ack : cntrl_record := (
	PC_next => "1011", sel_a => '0', sel_b => '0', en_a => '0',
	en_b => '0', received_a => '0', received_b => '0', end_operation => '1'
);

Constant end_op_ack : cntrl_record := (
	PC_next => "0000", sel_a => '0', sel_b => '0', en_a => '0',
	en_b => '0', received_a => '0', received_b => '0', end_operation => '0'
);

type rom_type is array(0 to 12) of cntrl_record;

Constant rom : rom_type := (
	0 => idle_no_start, 1 => idle_start, 2 => in1_start_a, 3 => in1_start_b,
	4 => in1_no_start, 5 => in2_start_b, 6 => in2_no_start, 7 => op1_cout_0,
	8 => op1_cout_1, 9 => op2_cout_0, 10 => op2_cout_1, 11 => end_op_no_ack,
	12 => end_op_ack
);

signal next_cntrl : cntrl_record;

begin

next_cntrl <= rom(to_integer(PC));

PC_next <= next_cntrl.PC_next;
sel_a <= next_cntrl.sel_a;
sel_b <= next_cntrl.sel_b;
en_a <= next_cntrl.en_a;
en_b <= next_cntrl.en_b;
received_a <= next_cntrl.received_a;
received_b <= next_cntrl.received_b;
end_operation <= next_cntrl.end_operation;

end Behavioral;

