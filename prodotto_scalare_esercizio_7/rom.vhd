----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:10:34 11/20/2020 
-- Design Name: 
-- Module Name:    rom - Behavioral 
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

entity rom is
    Port ( PC : in unsigned(0 downto 0);
           en_S : out  STD_LOGIC;
           en_R : out  STD_LOGIC;
           jstep : out  STD_LOGIC;
			  PC_next : out unsigned(0 downto 0));
end rom;

architecture Behavioral of rom is

type cntrl_record is record
	en_S : std_logic;
	en_R : std_logic;
	jstep : std_logic;
	PC_next : unsigned(0 downto 0);
end record;

constant ready : cntrl_record := (
	en_S => '0', en_R => '0', jstep => '1', PC_next => (others => '0')
);

constant op : cntrl_record := (
	en_S => '1', en_R => '1', jstep => '1', PC_next => (others => '0')
);

type rom_type is array(0 to 1) of cntrl_record;

constant micro_rom : rom_type := (
	0 => ready, 1 => op
);

signal next_cntrl : cntrl_record := ready;

begin

next_cntrl <= micro_rom(to_integer(PC));

en_S <= next_cntrl.en_S;
en_R <= next_cntrl.en_R;
jstep <= next_cntrl.jstep;
PC_next <= next_cntrl.PC_next;

end Behavioral;

