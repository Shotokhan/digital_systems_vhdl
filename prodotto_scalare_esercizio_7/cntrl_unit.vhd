----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:34:21 11/20/2020 
-- Design Name: 
-- Module Name:    cntrl_unit - Behavioral 
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

entity cntrl_unit is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           step : in  STD_LOGIC;
           en_S : out  STD_LOGIC;
           en_R : out  STD_LOGIC);
end cntrl_unit;

architecture Structural of cntrl_unit is

signal PC : unsigned(0 downto 0) := (others => '0');
signal jstep : std_logic := '0';
signal PC_next : unsigned(0 downto 0) := (others => '0');

component rom is
    Port ( PC : in unsigned(0 downto 0);
           en_S : out  STD_LOGIC;
           en_R : out  STD_LOGIC;
           jstep : out  STD_LOGIC;
			  PC_next : out unsigned(0 downto 0));
end component;

begin

micro_rom : rom port map(
	PC => PC, en_S => en_S, en_R => en_R, jstep => jstep, PC_next => PC_next
);

cntrl : process(clk, rst)
begin
	if (rst = '1') then
		PC <= (others => '0');
	elsif (clk = '1' and clk'event) then
		if (jstep = '1' and step = '1') then
			PC <= (others => '1');
		else
			PC <= PC_next;
		end if;
	end if;
end process;

end Structural;

