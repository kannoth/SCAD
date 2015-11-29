
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 

 
ENTITY fifo_input_tb IS
END fifo_input_tb;
 
ARCHITECTURE behavior OF fifo_input_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fifo_input
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         rw : IN  std_logic;
         en : IN  std_logic;
         data_in : IN  std_logic_vector(31 downto 0);
         full : OUT  std_logic;
         empty : OUT  std_logic;
         data_out : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal rw : std_logic := '0';
   signal en : std_logic := '0';
   signal data_in : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal full : std_logic;
   signal empty : std_logic;
   signal data_out : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fifo_input PORT MAP (
          clk => clk,
          rst => rst,
          rw => rw,
          en => en,
          data_in => data_in,
          full => full,
          empty => empty,
          data_out => data_out
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
      rst <= '1';
      wait for 5*clk_period;
		rst <= '0';
		
		wait for clk_period;
		en <= '1';
		rw <= '1';
		data_in <= X"FF00FF00";
		wait for 2*clk_period;
		data_in <= X"FF00FF01";
		wait for 2*clk_period;
		data_in <= X"FF00FF02";
		wait for 2*clk_period;
		data_in <= X"FF00FF03";
		wait for 2*clk_period;
		data_in <= X"FF00FF04";
		wait for 2*clk_period;
		data_in <= X"FF00FF05";
		wait for 2*clk_period;
		
		wait for clk_period;
		en <= '0';
		
		wait for 2*clk_period;
		en <= '1';
		rw <= '0';
		 wait for clk_period;
		 en <= '0';

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
