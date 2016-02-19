-- TestBench Template 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.mem_components.ALL;
use work.glbSharedTypes.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 
  
  constant clk_period : time := 10 ns;
  
  signal clk : std_logic;
  signal rst : std_logic;
  signal re : std_logic;
  signal we : std_logic;
  signal r_ack : std_logic;
  signal w_ack : std_logic;
  signal re_out : std_logic;
  signal we_out : std_logic;
  signal busy : std_logic;
  signal r_addr : std_logic_vector (MEM_ADDR_LENGTH-MEM_SELECT_BITLENGTH-1 downto 0);
  signal w_addr : std_logic_vector (MEM_ADDR_LENGTH-MEM_SELECT_BITLENGTH-1 downto 0);
  signal w_data_in : std_logic_vector (MEM_WORD_LENGTH-1 downto 0);
  signal r_data_out : std_logic_vector (MEM_WORD_LENGTH-1 downto 0);   

  BEGIN

          bank_controller_instance: bank_controller PORT MAP(
                  clk => clk,
                  rst => rst,
						re => re,
						we => we,
						re_out => re_out,
						we_out => we_out,
						busy  => busy,
						r_addr => r_addr,
						w_addr => w_addr
						
          );
			 
			 ram_instance : ram PORT MAP (
						clk => clk,
                  rst => rst,
						we => we_out,
						re => re_out,
						r_addr => r_addr,
						w_addr => w_addr,
						data_in => w_data_in,
						data_out => r_data_out,
						r_ack => r_ack,
						w_ack => w_ack
			 );

	clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	

	tb : PROCESS
     BEGIN
			rst <= '1';
			wait for 100 ns; 
			rst <= '0';
			wait for 20 ns;
			we <= '1';
			w_addr <= "000000";
			w_data_in <= X"FFFFFFFF";
			wait for 10 ns;
			we <= '0';
			re <= '1';
			r_addr <= "000000";
			wait for 10 ns;
			re <= '0';
			wait for 10 ns;
			we <= '1';
			re <= '1';
			w_addr <= "000001";
			r_addr <= "000010";
			w_data_in <= X"00FF00FF";
			wait for 10 ns;
			we <= '0';
			re <= '0';
			wait for 10 ns;
			we <= '1';
			re <= '1';
			w_addr <= "000011";
			r_addr <= "000011";
			w_data_in <= X"11111111";
			wait for 10 ns;
			we <= '0';
			re <= '1';
			wait for 10 ns;
			re <= '0';
		
        wait; 
   END PROCESS tb;
   

  END;
