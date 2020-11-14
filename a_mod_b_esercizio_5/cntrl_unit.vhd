----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:13:39 11/10/2020 
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
           start_a : in  STD_LOGIC;
			  start_b : in  STD_LOGIC;
           cout : in  STD_LOGIC;
			  ack : in STD_LOGIC;
			  rst : in STD_LOGIC;
           sel_a : out  STD_LOGIC;
           sel_b : out  STD_LOGIC;
           en_a : out  STD_LOGIC;
           en_b : out  STD_LOGIC;
           received_a : out  STD_LOGIC;
			  received_b : out  STD_LOGIC;
			  end_operation : out STD_LOGIC);
end cntrl_unit;

architecture Cablata of cntrl_unit is
type stato_enum is (in1, in2, op1, op2, idle, end_op);
signal current_state : stato_enum;

begin

cntrl_func : process(clk, rst)
begin
	if (rst = '1') then
		current_state <= idle; sel_a <= '0'; sel_b <= '0'; en_a <= '0';
		en_b <= '0'; received_a <= '0'; received_b <= '0'; end_operation <= '0';
	elsif (clk = '1' and clk'event) then
		case current_state is
			when idle =>
				if (start_a = '1') then
					current_state <= in1; sel_a <= '0'; sel_b <= '0'; en_a <= '0';
					en_b <= '0'; received_a <= '0'; received_b <= '0'; end_operation <= '0';
				else
					current_state <= idle; sel_a <= '0'; sel_b <= '0'; en_a <= '0';
					en_b <= '0'; received_a <= '0'; received_b <= '0'; end_operation <= '0';
				end if;
			when in1 =>
				if (start_a = '1') then
					current_state <= in1; sel_a <= '1'; sel_b <= '0'; en_a <= '0';
					en_b <= '0'; received_a <= '1'; received_b <= '0'; end_operation <= '0';
				elsif (start_b = '1') then
					current_state <= in2; sel_a <= '1'; sel_b <= '0'; en_a <= '0';
					en_b <= '0'; received_a <= '0'; received_b <= '0'; end_operation <= '0';
				else
					current_state <= in1; sel_a <= '1'; sel_b <= '0'; en_a <= '1';
					en_b <= '0'; received_a <= '0'; received_b <= '0'; end_operation <= '0';
				end if;
			when in2 =>
				if (start_b = '1') then
					current_state <= in2; sel_a <= '0'; sel_b <= '1'; en_a <= '0';
					en_b <= '0'; received_a <= '0'; received_b <= '1'; end_operation <= '0';
				else
					current_state <= op1; sel_a <= '0'; sel_b <= '0'; en_a <= '0';
					en_b <= '1'; received_a <= '0'; received_b <= '0'; end_operation <= '0';
				end if;
			when op1 =>
				if (cout = '0') then
					current_state <= op2; sel_a <= '0'; sel_b <= '0'; en_a <= '1';
					en_b <= '0'; received_a <= '0'; received_b <= '0'; end_operation <= '0';
				else
					current_state <= end_op; sel_a <= '0'; sel_b <= '0'; en_a <= '0';
					en_b <= '1'; received_a <= '0'; received_b <= '0'; end_operation <= '0';
				end if;
			when op2 =>
				if (cout = '0') then
					current_state <= op1; sel_a <= '0'; sel_b <= '0'; en_a <= '0';
					en_b <= '0'; received_a <= '0'; received_b <= '0'; end_operation <= '0';
				else
					current_state <= end_op; sel_a <= '0'; sel_b <= '0'; en_a <= '0';
					en_b <= '1'; received_a <= '0'; received_b <= '0'; end_operation <= '0';
				end if;
			when end_op =>
				if (ack = '0') then
					current_state <= end_op; sel_a <= '0'; sel_b <= '0'; en_a <= '0';
					en_b <= '0'; received_a <= '0'; received_b <= '0'; end_operation <= '1';
				else
					current_state <= idle; sel_a <= '0'; sel_b <= '0'; en_a <= '0';
					en_b <= '0'; received_a <= '0'; received_b <= '0'; end_operation <= '0';
				end if;
			when others =>
				current_state <= idle; sel_a <= '0'; sel_b <= '0'; en_a <= '0';
				en_b <= '0'; received_a <= '0'; received_b <= '0'; end_operation <= '0';
			end case;
	end if;
end process;

end Cablata;

architecture Microprogrammata of cntrl_unit is
signal PC, PC_next : unsigned(3 downto 0);

constant idle_no_start : unsigned(3 downto 0) := "0000";
constant idle_start : unsigned(3 downto 0) := "0001";
constant in1_start_a : unsigned(3 downto 0) := "0010";
constant in1_start_b : unsigned(3 downto 0) := "0011";
constant in1_no_start : unsigned(3 downto 0) := "0100";
constant in2_start_b : unsigned(3 downto 0) := "0101";
constant in2_no_start : unsigned(3 downto 0) := "0110";
constant op1_cout_0 : unsigned(3 downto 0) := "0111";
constant op1_cout_1 : unsigned(3 downto 0) := "1000";
constant op2_cout_0 : unsigned(3 downto 0) := "1001";
constant op2_cout_1 : unsigned(3 downto 0) := "1010";
constant end_op_no_ack : unsigned(3 downto 0) := "1011";
constant end_op_ack : unsigned(3 downto 0) := "1100";

component micro_rom is
    Port ( PC : in  unsigned(3 downto 0);
           PC_next : out  unsigned(3 downto 0);
           en_a : out  STD_LOGIC;
           en_b : out  STD_LOGIC;
           sel_a : out  STD_LOGIC;
           sel_b : out  STD_LOGIC;
           received_a : out  STD_LOGIC;
           received_b : out  STD_LOGIC;
           end_operation : out  STD_LOGIC);
end component;

begin

rom : micro_rom port map(
	PC => PC, PC_next => PC_next, en_a => en_a, en_b => en_b, sel_a => sel_a,
	sel_b => sel_b, received_a => received_a, received_b => received_b,
	end_operation => end_operation
);

PC_logic : process(clk, rst)
begin
	if (rst = '1') then
		PC <= idle_no_start;
	elsif (clk = '1' and clk'event) then
		case PC_next is
			when idle_no_start =>
				if (start_a = '1') then
					PC <= idle_start;
				else PC <= idle_no_start;
				end if;
			when idle_start =>
				PC <= PC_next;
			when in1_start_a =>
				if (start_a = '0') then
					if (start_b = '1') then
						PC <= in1_start_b;
					else PC <= in1_no_start;
					end if;
				else PC <= PC_next;
				end if;
			when in1_start_b =>
				PC <= PC_next;
			when in1_no_start =>
				if (start_b = '1') then
					PC <= in2_start_b;
				else PC <= PC_next;
				end if;
			when in2_start_b =>
				if (start_b = '0') then
					PC <= in2_no_start;
				else PC <= PC_next;
				end if;
			when in2_no_start =>
				PC <= PC_next;
			when op1_cout_0 =>
				if (cout = '1') then
					PC <= op1_cout_1;
				else PC <= PC_next;
				end if;
			when op1_cout_1 =>
				PC <= PC_next;
			when op2_cout_0 =>
				if (cout = '1') then
					PC <= op2_cout_1;
				else PC <= PC_next;
				end if;
			when op2_cout_1 =>
				PC <= PC_next;
			when end_op_no_ack =>
				if (ack = '1') then
					PC <= end_op_ack;
				else PC <= PC_next;
				end if;
			when end_op_ack =>
				PC <= PC_next;
			when others =>
				PC <= idle_no_start;
			end case;
	end if;
end process;

end Microprogrammata;