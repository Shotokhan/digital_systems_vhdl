----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:53:31 11/09/2020 
-- Design Name: 
-- Module Name:    mem_cell - Behavioral 
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

entity mem_cell is
    Port ( d : in  STD_LOGIC;
           val : in  STD_LOGIC;
           load : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           q : out  STD_LOGIC);
end mem_cell;

architecture Structural of mem_cell is
signal u : std_logic;

component ff_D is
    Port ( d : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           q : out  STD_LOGIC);
end component;

component mux is
	 Generic (n_sel : positive := 2);
    Port ( x : in  STD_LOGIC_VECTOR((2**n_sel - 1) downto 0);
           sel : in  STD_LOGIC_VECTOR((n_sel - 1) downto 0);
           y : out  STD_LOGIC);
end component;

begin
sel : mux generic map (n_sel => 1) port map(
	x(0) => d, x(1) => val, sel(0) => load, y => u
);

mem : ff_D port map(
	d => u, clk => clk, rst => rst, q => q
);

end Structural;

