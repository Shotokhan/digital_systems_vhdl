--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:30:30 11/09/2020
-- Design Name:   
-- Module Name:   /home/marcofelix98/Architettura_dei_Sistemi_Digitali/my_projects/shift_register_esercizio_4/shift_register_testbench.vhd
-- Project Name:  shift_register_esercizio_4
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: shift_register
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
use work.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY shift_register_testbench IS
END shift_register_testbench;
 
ARCHITECTURE behavior OF shift_register_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT shift_register
    PORT(
         x : IN  std_logic;
         rst : IN  std_logic;
         load : IN  std_logic;
         val : IN  std_logic_vector(3 downto 0);
         mode_sel : IN  std_logic_vector(1 downto 0);
         shift : IN  std_logic;
         y : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal x : std_logic := '0';
   signal rst : std_logic := '0';
   signal load : std_logic := '0';
   signal val : std_logic_vector(3 downto 0) := (others => '0');
   signal mode_sel : std_logic_vector(1 downto 0) := (others => '0');
   signal shift : std_logic := '0';

 	--Outputs
   signal y : std_logic := '0'; 
 
   constant shift_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.shift_register(Behavioral) PORT MAP (
          x => x,
          rst => rst,
          load => load,
          val => val,
          mode_sel => mode_sel,
          shift => shift,
          y => y
        );

   -- Clock process definitions
   clk_process :process
   begin
		shift <= '0';
		wait for shift_period/2;
		shift <= '1';
		wait for shift_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		rst <= '1';
      wait for shift_period;
		rst <= '0';
		
		wait for shift_period;
		x <= '1';
		wait for shift_period;
		x <= '0';
		wait for shift_period;
		x <= '1';
		wait for shift_period;
		x <= '1';
		mode_sel <= "00";
		wait for shift_period*5;
		
		mode_sel <= "00";
		wait for shift_period;
		x <= '1';
		wait for shift_period;
		x <= '0';
		wait for shift_period;
		x <= '1';
		wait for shift_period;
		x <= '1';
		mode_sel <= "11";
		wait for shift_period*8;
		
		rst <= '1';
      wait for shift_period;
		rst <= '0';
		mode_sel <= "00";
		wait for shift_period;
		x <= '1';
		wait for shift_period;
		x <= '0';
		wait for shift_period;
		x <= '1';
		wait for shift_period;
		x <= '1';
		wait for shift_period;
		mode_sel <= "10";
		wait for shift_period*2;
		mode_sel <= "01";
		wait for shift_period*2;
		
		load <= '1';
		val <= "1111";
		wait for shift_period;
		load <= '0';
		val <= "0000";
		wait for shift_period*4;
		
      wait;
   end process;

END;
