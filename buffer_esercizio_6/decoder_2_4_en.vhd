----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:53:44 11/14/2020 
-- Design Name: 
-- Module Name:    decoder_2_4_en - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder_2_4_en is
    Port ( x : in  STD_LOGIC_VECTOR(1 downto 0);
           en : in  STD_LOGIC;
           y : out  STD_LOGIC_VECTOR(3 downto 0));
end decoder_2_4_en;

architecture Behavioral of decoder_2_4_en is

begin
decode : process(x, en)
begin
	if (en = '1') then
		case x is
			when "00" =>
				y <= "0001";
			when "01" =>
				y <= "0010";
			when "10" =>
				y <= "0100";
			when "11" =>
				y <= "1000";
			when others =>
				y <= "0000";
		end case;
	else
		y <= "0000";
	end if;
end process;

end Behavioral;

