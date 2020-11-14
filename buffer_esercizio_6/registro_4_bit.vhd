----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:55:27 11/14/2020 
-- Design Name: 
-- Module Name:    registro_4_bit - Behavioral 
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

entity registro_4_bit is
    Port ( d : in  STD_LOGIC_VECTOR(3 downto 0);
           en : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           q : out  STD_LOGIC_VECTOR(3 downto 0));
end registro_4_bit;

architecture Structural of registro_4_bit is

component ff_D is
    Port ( en : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           d : in  STD_LOGIC;
           q : out  STD_LOGIC);
end component;

begin
banco : for i in 0 to 3 generate
	cella : ff_D port map(
		en => en, rst => rst, d => d(i), q => q(i)
	);
end generate;

end Structural;

