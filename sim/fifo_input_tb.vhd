
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.buf_pkg.all;

 

 
ENTITY fifo_input_tb IS
END fifo_input_tb;
 
ARCHITECTURE behavior OF fifo_input_tb IS 
 
	constant clk_period : time := 10 ns;
	
	procedure read_fifo (signal en : out std_logic;
								signal rw : out std_logic) is 
	begin
		en <= '1';
		rw <= '0';
		wait for clk_period;
		en <= '0';
		wait for clk_period;
	end read_fifo;
	
	
	procedure write_fifo (signal en : out std_logic;
								 signal rw : out std_logic;
								 signal data_in : out std_logic_vector(31 downto 0);
								 constant tmp : in std_logic_vector(31 downto 0) ) is 
	begin
		en <= '1';
		rw <= '1';
		data_in <= tmp;
		wait for clk_period;
		en <= '0';
		wait for clk_period;
	end write_fifo;
	
	procedure read_before_write(signal en : out std_logic;
										 signal rw : out std_logic;
										 signal data_in : out std_logic_vector(31 downto 0) ) is
		begin
		report "Read before write test";
		read_fifo(en,rw);
		read_fifo(en,rw);
		write_fifo(en,rw,data_in,X"FF00FF00");
		read_fifo(en,rw);
	end read_before_write;
	
	signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal rw : std_logic := '0';
   signal en : std_logic := '0';
   signal data_in : std_logic_vector(31 downto 0) := (others => '0');

   signal full : std_logic;
   signal empty : std_logic;
   signal data_out : std_logic_vector(31 downto 0);
 
BEGIN
 
   uut: fifo_alu PORT MAP (
          clk => clk,
          rst => rst,
          rw => rw,
          en => en,
          data_in => data_in,
          full => full,
          empty => empty,
          data_out => data_out
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
      rst <= '1';
      wait for 5*clk_period - 5 ns;
		rst <= '0';
		read_before_write(en,rw,data_in);
      wait;
   end process;

END;
