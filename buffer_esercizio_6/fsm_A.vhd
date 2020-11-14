----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:08:33 11/14/2020 
-- Design Name: 
-- Module Name:    fsm_A - Behavioral 
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

entity fsm_A is
    Port ( in_ready : in  STD_LOGIC;
           buffer_picked : in  STD_LOGIC;
			  clk : in STD_LOGIC;
			  rst : in STD_LOGIC;
           in_received : out  STD_LOGIC;
           reg_enable : out  STD_LOGIC_VECTOR(1 downto 0);
			  write_buf : out STD_LOGIC;
           buffer_full : out  STD_LOGIC);
end fsm_A;

architecture Behavioral of fsm_A is
type state is (idle, word_in, wait_other, full);
signal cont : unsigned(2 downto 0) := "000";
signal current : state := idle;

begin
protocol : process(clk, rst)
begin
	if (rst = '1') then
		current <= idle; cont <= "000";
	elsif (clk = '1' and clk'event) then
		case current is
			when idle =>
				if (in_ready = '1') then
					current <= word_in; in_received <= '0'; buffer_full <= '0';
					reg_enable <= std_logic_vector(cont(1 downto 0)); cont <= "000"; write_buf <= '0';
				else
					current <= idle; in_received <= '0'; buffer_full <= '0';
					reg_enable <= "00"; cont <= "000"; write_buf <= '0';
				end if;
			when word_in =>
				if (in_ready = '1') then
					current <= word_in; in_received <= '1'; buffer_full <= '0';
					reg_enable <= std_logic_vector(cont(1 downto 0)); cont <= cont;
					write_buf <= '1';
				else
					current <= wait_other; in_received <= '0'; buffer_full <= '0';
					reg_enable <= std_logic_vector(cont(1 downto 0)); cont <= cont + 1; write_buf <= '0';
				end if;
			when wait_other =>
				if (cont = 4) then
					current <= full; in_received <= '0'; buffer_full <= '1';
					reg_enable <= "00"; cont <= "000"; write_buf <= '0';
				elsif (in_ready = '0') then
					current <= wait_other; in_received <= '0'; buffer_full <= '0';
					reg_enable <= std_logic_vector(cont(1 downto 0)); cont <= cont; write_buf <= '0';
				else
					current <= word_in; in_received <= '0'; buffer_full <= '0';
					reg_enable <= std_logic_vector(cont(1 downto 0)); cont <= cont; write_buf <= '0';
				end if;
			when full => 
				if (buffer_picked = '0') then
					current <= full; in_received <= '0'; buffer_full <= '1';
					reg_enable <= "00"; cont <= "000"; write_buf <= '0';
				else
					current <= idle; in_received <= '0'; buffer_full <= '0';
					reg_enable <= "00"; cont <= "000"; write_buf <= '0';
				end if;
			when others =>
				current <= idle; in_received <= '0'; buffer_full <= '0';
				reg_enable <= "00"; cont <= "000"; write_buf <= '0';
		end case;
	end if;
end process;

end Behavioral;

