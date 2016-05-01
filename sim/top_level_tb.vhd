library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_unsigned.all;
library work;
use work.common.ALL;
use work.alu_components.ALL;
use work.buf_pkg.ALL;
use work.common_component.ALL;
use work.mem_components.ALL;
use work.instruction.all;

 
ENTITY top_level_tb IS
END top_level_tb;
 
ARCHITECTURE behavior OF top_level_tb IS 
 
 
    COMPONENT top_level
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic
        );
    END COMPONENT;
    

   
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

   
   constant clk_period : time := 10 ns;
 
BEGIN
 
	
   uut: top_level PORT MAP (
          clk => clk,
          reset => reset
        );

   
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

  
   stim_proc: process
   begin		
		reset <= '1';
		wait for clk_period*10;
		reset <= '0';

      wait for 5 us;

      wait;
   end process;

END;
