library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;
use work.buf_pkg.ALL;

 
ENTITY fu_input_buffer_tb IS
END fu_input_buffer_tb;
 
ARCHITECTURE behavior OF fu_input_buffer_tb IS 
 


   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal mib_addr : std_logic_vector(FU_ADDRESS_W-1 downto 0) := (others => '0');
   signal mib_en : std_logic := '0';
   signal dtn_data : std_logic_vector(FU_DATA_W-1 downto 0) := (others => '0');
   signal dtn_addr : std_logic_vector(FU_ADDRESS_W-1 downto 0) := (others => '0');
   signal fu_read : std_logic := '0';
	signal dtn_valid : std_logic := '0';

 	--Outputs
   signal available : std_logic;
   signal full : std_logic;
   signal empty : std_logic;
   signal data_out : std_logic_vector(FU_DATA_W-1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
	procedure mib_write(			
										constant addr	 	: in std_logic_vector(FU_ADDRESS_W-1 downto 0);
										signal mib_addr 	: out std_logic_vector(FU_ADDRESS_W-1 downto 0);
										signal mib_en	 	: out std_logic) is 
	begin
	mib_addr		<= addr;
	mib_en		<= '1';
	wait for clk_period;
	mib_en		<= '0';
		
	end mib_write;
	
	
	procedure dtn_write(			
										constant addr		: in std_logic_vector(FU_ADDRESS_W-1 downto 0);
										constant data		: in std_logic_vector(FU_DATA_W-1 downto 0);
										signal dtn_data	: out std_logic_vector(FU_DATA_W-1 downto 0);
										signal dtn_addr	: out std_logic_vector(FU_ADDRESS_W-1 downto 0);
										signal dtn_valid	: out std_logic	) is
	begin
	dtn_valid	<= '1';
	dtn_data 	<= data;
	dtn_addr		<= addr;
	wait for clk_period;
	dtn_valid	<= '0';
	
	end dtn_write;
	
	
	procedure basic_write_test (
										signal mib_addr 	: out std_logic_vector(FU_ADDRESS_W-1 downto 0);
										signal mib_en	 	: out std_logic;
										signal dtn_data	: out std_logic_vector(FU_DATA_W-1 downto 0);
										signal dtn_addr	: out std_logic_vector(FU_ADDRESS_W-1 downto 0);
										signal dtn_valid	: out std_logic ) is 
	begin
	
	mib_write("11111", mib_addr, mib_en);
	dtn_write("11111",X"FFEEFFEE", dtn_data , dtn_addr, dtn_valid);
	wait for clk_period;
	
	end basic_write_test;
	
	procedure reserve_and_issue_test ( 
										signal mib_addr 	: out std_logic_vector(FU_ADDRESS_W-1 downto 0);
										signal mib_en	 	: out std_logic;
										signal dtn_data	: out std_logic_vector(FU_DATA_W-1 downto 0);
										signal dtn_addr	: out std_logic_vector(FU_ADDRESS_W-1 downto 0);
										signal fu_read		: out std_logic;
										signal dtn_valid	: out std_logic ) is 
	begin
	mib_write("11111", mib_addr, mib_en);
	mib_write("00001", mib_addr, mib_en);
	mib_write("00011", mib_addr, mib_en);
	dtn_write("11111",X"11111111", dtn_data , dtn_addr, dtn_valid);
	dtn_write("00001",X"22222222", dtn_data , dtn_addr, dtn_valid);
	dtn_write("00011",X"33333333", dtn_data , dtn_addr, dtn_valid);
	fu_read	<= '1';
	wait for 3*clk_period;
	fu_read 	<= '0';
	wait for clk_period;
	mib_write("11111", mib_addr, mib_en);
	dtn_write("11111",X"11111111", dtn_data , dtn_addr, dtn_valid);
	basic_write_test(mib_addr, mib_en , dtn_data, dtn_addr, dtn_valid);
	basic_write_test(mib_addr, mib_en , dtn_data, dtn_addr, dtn_valid);
	basic_write_test(mib_addr, mib_en , dtn_data, dtn_addr, dtn_valid);
	basic_write_test(mib_addr, mib_en , dtn_data, dtn_addr, dtn_valid);
	basic_write_test(mib_addr, mib_en , dtn_data, dtn_addr, dtn_valid);
	basic_write_test(mib_addr, mib_en , dtn_data, dtn_addr, dtn_valid);
	fu_read	<= '1';
	wait for 6*clk_period;
	fu_read 	<= '0';
	wait for clk_period;
	
	end reserve_and_issue_test;
	
	procedure interleaved_data_test ( 
										signal mib_addr 	: out std_logic_vector(FU_ADDRESS_W-1 downto 0);
										signal mib_en	 	: out std_logic;
										signal dtn_data	: out std_logic_vector(FU_DATA_W-1 downto 0);
										signal dtn_addr	: out std_logic_vector(FU_ADDRESS_W-1 downto 0);
										signal fu_read		: out std_logic;
										signal dtn_valid	: out std_logic ) is
	begin
	mib_write("11111", mib_addr, mib_en);
	mib_write("00001", mib_addr, mib_en);
	mib_write("00011", mib_addr, mib_en);
	dtn_write("00001",X"22222222", dtn_data , dtn_addr, dtn_valid);
	wait for 3*clk_period;
	dtn_write("11111",X"11111111", dtn_data , dtn_addr, dtn_valid);
	fu_read	<= '1';
	wait for clk_period;
	fu_read	<= '0';
	
	end interleaved_data_test;
	
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fu_input_buffer PORT MAP (
          clk => clk,
          rst => rst,
          mib_addr => mib_addr,
          mib_en => mib_en,
          dtn_data => dtn_data,
          dtn_addr => dtn_addr,
			 dtn_valid => dtn_valid,
          fu_read => fu_read,
          available => available,
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
		
		--Test basic functionality by reserving and issuing one addr only
		basic_write_test(mib_addr, mib_en , dtn_data, dtn_addr, dtn_valid);
		wait for 2*clk_period;
		assert (available = '1') report "Data should be available at HEAD" severity error;
		
		rst <= '1';
		wait for 5*clk_period;
		rst <= '0';
		
		--Reserve three addresses and issue the last operand
		reserve_and_issue_test(mib_addr, mib_en , dtn_data, dtn_addr, fu_read, dtn_valid);
		assert (available = '0') report "Buffer should be clear" severity error;
		
		rst <= '1';
		wait for 15*clk_period;
		rst <= '0';
		
		--Interleave MIB and DTN writes
		--interleaved_data_test(mib_addr, mib_en , dtn_data, dtn_addr, fu_read, dtn_valid);
		--assert (available = '1') report "HEAD has valid data" severity error;
		
		
      wait;
   end process;

END;
