library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;


entity store is
    Port ( 	--signals to/from FU
			clk  		: in std_logic;
			en  		: in std_logic;	
			fu_data		: in std_Logic_vector (MEM_WORD_LENGTH-1 downto 0);
			fu_addr		: in std_Logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
			busy		: out std_logic;
			valid  		: out std_logic;		--valid signal from FU structure or fifo_input
			--signals to/from memory unit
			ack			: in std_logic;
			data		: out std_Logic_vector (MEM_WORD_LENGTH-1 downto 0);
			addr		: out std_Logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
			we			: out std_logic
			);
end store;

architecture RTL of store is

signal reg_busy		: std_logic := '0';
signal reg_valid	: std_logic := '0';
signal reg_addr		: std_logic_vector(addr'range) := (others => 'X');
signal reg_data		: std_logic_vector(data'range) := (others => 'X');
signal reg_we		: std_logic;

begin

addr		<= reg_addr;
data 		<= reg_data;
busy 		<= reg_busy;
valid 		<= reg_valid;
we			<= reg_we;


process(clk)
begin
	if rising_edge(clk) then
		if ack = '1' then
			reg_valid 	<= '1';
			reg_busy 	<= '0';
			reg_we		<= '0';
		elsif en = '1' then
			reg_addr 	<= fu_addr;
			reg_data	<= fu_data;
			reg_busy 	<= '1';
			reg_valid	<= '0';
			reg_we		<= '1';
		else
			reg_valid 	<= '0';
			reg_we		<= '0';
		end if;
	end if;
end process;

end RTL;
