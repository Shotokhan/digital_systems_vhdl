----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:54:53 11/09/2020 
-- Design Name: 
-- Module Name:    mux - Behavioral 
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
use IEEE.math_real.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux is
	 Generic (n_sel : positive := 2);
    Port ( x : in  STD_LOGIC_VECTOR((2**n_sel - 1) downto 0);
           sel : in  STD_LOGIC_VECTOR((n_sel - 1) downto 0);
           y : out  STD_LOGIC);
end mux;

architecture Behavioral of mux is

begin
mux : process(x, sel)
begin
	y <= x(to_integer(unsigned(sel)));
end process;

end Behavioral;

