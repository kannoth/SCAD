library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;


entity load is
    Port ( 	--signals to/from FU
			clk  		: in std_logic;
			en  		: in std_logic;	
			operand		: in std_Logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
			busy		: out std_logic;
			valid  		: out std_logic;		--valid signal from FU structure or fifo_input
			data_out 	: out  std_logic_vector (MEM_WORD_LENGTH-1 downto 0);
			--signals to/from memory unit
			data		: in std_Logic_vector (MEM_WORD_LENGTH-1 downto 0);
			ack			: in std_logic;
			addr		: out std_Logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
			we			: out std_logic
			);
end load;

architecture RTL of load is

signal reg_busy		: std_logic := '0';
signal reg_valid	: std_logic := '0';
signal reg_dout		: std_logic_vector(data_out'range) := (others => 'X');
signal reg_addr		: std_logic_vector(addr'range) := (others => 'X');
signal reg_we		: std_logic;

begin

data_out 	<= reg_dout;
busy 		<= reg_busy;
valid 		<= reg_valid;
we			<= reg_we;
addr		<= reg_addr;

process(clk)
begin
	if rising_edge(clk) then
		if ack = '1' then
			reg_dout 	<= data;
			reg_valid 	<= '1';
			reg_busy 	<= '0';
			reg_we		<= '0';
		elsif en = '1' then
			reg_addr 	<= operand;
			reg_dout 	<= (others => 'X');
			reg_busy 	<= '1';
			reg_valid	<= '0';
			reg_we		<= '1';
		else
			reg_we		<= '0';
		end if;
	end if;
end process;

end RTL;
