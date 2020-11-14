----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:07:00 11/14/2020 
-- Design Name: 
-- Module Name:    fsm_B - Behavioral 
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

entity fsm_B is
    Port ( buffer_full : in  STD_LOGIC;
           out_received : in  STD_LOGIC;
			  clk : in STD_LOGIC;
			  rst : in STD_LOGIC;
           out_ready : out  STD_LOGIC;
           buffer_picked : out  STD_LOGIC;
           sel : out  STD_LOGIC_VECTOR(1 downto 0));
end fsm_B;

architecture Behavioral of fsm_B is
type state is (idle, word_out, prepare_next, picked);
signal cont : unsigned(1 downto 0) := "00";
signal current : state := idle;

begin
protocol : process(clk, rst)
begin
	if (rst = '1') then
		current <= idle; cont <= "00";
	elsif (clk = '1' and clk'event) then
		case current is
			when idle =>
				if (buffer_full = '0') then
					current <= idle; out_ready <= '0'; cont <= "00";
					buffer_picked <= '0'; sel <= "00";
				else
					current <= word_out; out_ready <= '0'; cont <= "00";
					buffer_picked <= '0'; sel <= "00";
				end if;
			when word_out =>
				if (out_received = '0') then
					current <= word_out; out_ready <= '1'; cont <= cont;
					buffer_picked <= '0'; sel <= std_logic_vector(cont);
				else
					current <= prepare_next; out_ready <= '0'; cont <= cont + 1;
					buffer_picked <= '0'; sel <= std_logic_vector(cont);
				end if;
			when prepare_next =>
				if (cont = 2) then
					current <= picked; out_ready <= '0'; cont <= "00";
					buffer_picked <= '1'; sel <= "00";
				else
					current <= word_out; out_ready <= '0'; cont <= cont;
					buffer_picked <= '0'; sel <= std_logic_vector(cont);
				end if;
			when picked =>
				if (buffer_full = '1') then
					current <= picked; out_ready <= '0'; cont <= "00";
					buffer_picked <= '1'; sel <= "00";
				else
					current <= idle; out_ready <= '0'; cont <= "00";
					buffer_picked <= '0'; sel <= "00";
				end if;
		end case;
	end if;
end process;

end Behavioral;

