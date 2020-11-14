----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:10:21 11/09/2020 
-- Design Name: 
-- Module Name:    shift_register - Behavioral 
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

entity shift_register is
	 Generic(n : positive := 4);
    Port ( x : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           load : in  STD_LOGIC;
           val : in  STD_LOGIC_VECTOR(n-1 downto 0);
           mode_sel : in  STD_LOGIC_VECTOR(1 downto 0);
           shift : in  STD_LOGIC;
           y : out  STD_LOGIC);
end shift_register;

architecture Structural of shift_register is
signal mem_in : std_logic_vector(n-1 downto 0);
signal mem_out : std_logic_vector(n-1 downto 0);

component mux is
	 Generic (n_sel : positive := 2);
    Port ( x : in  STD_LOGIC_VECTOR((2**n_sel - 1) downto 0);
           sel : in  STD_LOGIC_VECTOR((n_sel - 1) downto 0);
           y : out  STD_LOGIC);
end component;

component mem_cell is
    Port ( d : in  STD_LOGIC;
           val : in  STD_LOGIC;
           load : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           q : out  STD_LOGIC);
end component;

begin

frontend : mux generic map(n_sel => 2) port map(
	x(0) => x, x(1) => '0', x(2) => mem_out(1), x(3) => mem_out(n-1),
	sel(0) => mode_sel(0), sel(1) => mode_sel(1), y => mem_in(0)
);

mem_0 : mem_cell port map(
	d => mem_in(0), val => val(0), load => load, clk => shift,
	rst => rst, q => mem_out(0)
);

inner : for i in 1 to n-2 generate
	mux_i : mux generic map(n_sel => 2) port map(
		x(0) => mem_out(i-1), x(1) => mem_out(i-1), x(2) => mem_out(i+1),
		x(3) => mem_out(i-1), sel(0) => mode_sel(0), sel(1) => mode_sel(1),
		y => mem_in(i)
	);
	mem_i : mem_cell port map(
		d => mem_in(i), val => val(i), load => load, clk => shift,
		rst => rst, q => mem_out(i)
	);
end generate;

last_mux : mux generic map(n_sel => 2) port map(
	x(0) => mem_out(n-2), x(1) => mem_out(n-2), x(2) => '0',
	x(3) => mem_out(n-2), sel(0) => mode_sel(0), sel(1) => mode_sel(1),
	y => mem_in(n-1)
);

last_mem : mem_cell port map(
	d => mem_in(n-1), val => val(n-1), load => load, clk => shift,
	rst => rst, q => mem_out(n-1)
);

y <= mem_out(n-1);

end Structural;

architecture Behavioral of shift_register is
signal u : std_logic_vector(n-1 downto 0);

begin
shift_proc : process(shift, rst)
begin
	if (rst = '1') then
		u <= (others => '0');
	elsif (shift = '1' and shift'event) then
		if (load = '1') then
			u <= val;
		else
			case mode_sel is
				when "00" =>
					for i in n-1 downto 1 loop
						u(i) <= u(i-1);
					end loop;
					u(0) <= x;
				when "01" =>
					for i in n-1 downto 1 loop
						u(i) <= u(i-1);
					end loop;
					u(0) <= '0';
				when "10" =>
					for i in 0 downto n-2 loop
						u(i) <= u(i+1);
					end loop;
					u(n-1) <= '0';
				when "11" =>
					for i in n-1 downto 1 loop
						u(i) <= u(i-1);
					end loop;
					u(0) <= u(n-1);
				when others =>
					for i in n-1 downto 1 loop
						u(i) <= u(i-1);
					end loop;
					u(0) <= '0';
			end case;
		end if;
	end if;
end process;

y <= u(n-1);

end Behavioral;

