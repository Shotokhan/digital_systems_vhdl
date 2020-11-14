----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:16:14 11/14/2020 
-- Design Name: 
-- Module Name:    input_output_buffer - Behavioral 
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

entity input_output_buffer is
    Port ( x : in  STD_LOGIC_VECTOR(3 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           in_ready : in  STD_LOGIC;
           out_received : in  STD_LOGIC;
           y : out  STD_LOGIC_VECTOR(7 downto 0);
           in_received : out  STD_LOGIC;
           out_ready : out  STD_LOGIC);
end input_output_buffer;

architecture Structural of input_output_buffer is

signal buf_data : std_logic_vector(15 downto 0) := (others => '0');
signal enable_reg : std_logic_vector(3 downto 0) := (others => '0');
signal enc_enable : std_logic_vector(1 downto 0) := (others => '0');
signal master_enable : std_logic := '0';
signal out_mux_sel : std_logic_vector(1 downto 0) := (others => '0');
signal buffer_full : std_logic := '0';
signal buffer_picked : std_logic := '0';

component registro_4_bit is
    Port ( d : in  STD_LOGIC_VECTOR(3 downto 0);
           en : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           q : out  STD_LOGIC_VECTOR(3 downto 0));
end component;

component decoder_2_4_en is
    Port ( x : in  STD_LOGIC_VECTOR(1 downto 0);
           en : in  STD_LOGIC;
           y : out  STD_LOGIC_VECTOR(3 downto 0));
end component;

component mux_2_1_parallelo_8_bit is
    Port ( a : in  STD_LOGIC_VECTOR(7 downto 0);
           b : in  STD_LOGIC_VECTOR(7 downto 0);
           sel : in  STD_LOGIC;
           y : out  STD_LOGIC_VECTOR(7 downto 0));
end component;

component fsm_A is
    Port ( in_ready : in  STD_LOGIC;
           buffer_picked : in  STD_LOGIC;
			  clk : in STD_LOGIC;
			  rst : in STD_LOGIC;
           in_received : out  STD_LOGIC;
           reg_enable : out  STD_LOGIC_VECTOR(1 downto 0);
			  write_buf : out STD_LOGIC;
           buffer_full : out  STD_LOGIC);
end component;

component fsm_B is
    Port ( buffer_full : in  STD_LOGIC;
           out_received : in  STD_LOGIC;
			  clk : in STD_LOGIC;
			  rst : in STD_LOGIC;
           out_ready : out  STD_LOGIC;
           buffer_picked : out  STD_LOGIC;
           sel : out  STD_LOGIC_VECTOR(1 downto 0));
end component;

begin

buf_16bit : for i in 0 to 3 generate
	reg_4bit : registro_4_bit port map(
		d => x, rst => rst, en => enable_reg(i), q => buf_data(4*i + 3 downto 4*i)
	);
end generate;

master_buf : decoder_2_4_en port map(
	x => enc_enable, en => master_enable, y => enable_reg
);

out_word : mux_2_1_parallelo_8_bit port map(
	a => buf_data(7 downto 0), b => buf_data(15 downto 8), sel => out_mux_sel(0), y => y
);

receiver : fsm_A port map(
	in_ready => in_ready, buffer_picked => buffer_picked, clk => clk, rst => rst,
	in_received => in_received, reg_enable => enc_enable, write_buf => master_enable,
	buffer_full => buffer_full
);

sender : fsm_B port map(
	buffer_full => buffer_full, out_received => out_received, clk => clk, rst => rst,
	out_ready => out_ready, buffer_picked => buffer_picked, sel => out_mux_sel
);

end Structural;

