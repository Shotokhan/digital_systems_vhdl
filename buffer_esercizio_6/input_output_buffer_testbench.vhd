--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:47:08 11/14/2020
-- Design Name:   
-- Module Name:   /home/marcofelix98/Architettura_dei_Sistemi_Digitali/my_projects/buffer_esercizio_6/input_output_buffer_testbench.vhd
-- Project Name:  buffer_esercizio_6
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: input_output_buffer
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY input_output_buffer_testbench IS
END input_output_buffer_testbench;
 
ARCHITECTURE behavior OF input_output_buffer_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT input_output_buffer
    PORT(
         x : IN  std_logic_vector(3 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         in_ready : IN  std_logic;
         out_received : IN  std_logic;
         y : OUT  std_logic_vector(7 downto 0);
         in_received : OUT  std_logic;
         out_ready : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal x : std_logic_vector(3 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal in_ready : std_logic := '0';
   signal out_received : std_logic := '0';

 	--Outputs
   signal y : std_logic_vector(7 downto 0) := (others => '0');
   signal in_received : std_logic := '0';
   signal out_ready : std_logic := '0';

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
	-- Test
	signal word_recv : std_logic_vector(15 downto 0) := (others => '0');
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: input_output_buffer PORT MAP (
          x => x,
          clk => clk,
          rst => rst,
          in_ready => in_ready,
          out_received => out_received,
          y => y,
          in_received => in_received,
          out_ready => out_ready
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
	
   begin		
      wait for clk_period*10;
		rst <= '1';
		wait for clk_period;
		rst <= '0';
		wait for clk_period;
		
		-- client che invia (A); word: 1000010000100001
		x <= "0001";
		in_ready <= '1';
		wait until in_received = '1';
		in_ready <= '0';
		wait until in_received = '0';
		
		x <= "0010";
		in_ready <= '1';
		wait until in_received = '1';
		in_ready <= '0';
		wait until in_received = '0';
		
		x <= "0100";
		in_ready <= '1';
		wait until in_received = '1';
		in_ready <= '0';
		wait until in_received = '0';
		
		x <= "1000";
		in_ready <= '1';
		wait until in_received = '1';
		in_ready <= '0';
		wait until in_received = '0';
		
		-- client che riceve (B)
		wait until out_ready = '1';
		word_recv(7 downto 0) <= y;
		out_received <= '1';
		wait until out_ready = '0';
		out_received <= '0';
		
		wait until out_ready = '1';
		word_recv(15 downto 8) <= y;
		out_received <= '1';
		wait until out_ready = '0';
		out_received <= '0';
		
		assert word_recv = "1000010000100001";
		
		-- client che invia (A); word: 0111101111011110
		x <= "1110";
		in_ready <= '1';
		wait until in_received = '1';
		in_ready <= '0';
		wait until in_received = '0';
		
		x <= "1101";
		in_ready <= '1';
		wait until in_received = '1';
		in_ready <= '0';
		wait until in_received = '0';
		
		x <= "1011";
		in_ready <= '1';
		wait until in_received = '1';
		in_ready <= '0';
		wait until in_received = '0';
		
		x <= "0111";
		in_ready <= '1';
		wait until in_received = '1';
		in_ready <= '0';
		wait until in_received = '0';
		
		-- client che riceve (B)
		wait until out_ready = '1';
		word_recv(7 downto 0) <= y;
		out_received <= '1';
		wait until out_ready = '0';
		out_received <= '0';
		
		wait until out_ready = '1';
		word_recv(15 downto 8) <= y;
		out_received <= '1';
		wait until out_ready = '0';
		out_received <= '0';
		
		assert word_recv = "0111101111011110";
		
      wait;
   end process;

END;
