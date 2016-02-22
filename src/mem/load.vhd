library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;


entity load is
    Port ( 	clk  		: in std_logic;
			busy  		: in std_logic;		--busy signal from memory unit
			valid  		: in std_logic;		--valid signal from FU structure or fifo_input
			addr 		: in  std_logic_vector (MEM_ADDR_LENGTH-MEM_SELECT_BITLENGTH-1 downto 0);
			data_in 	: in  std_logic_vector (MEM_WORD_LENGTH-1 downto 0);
			data_out 	: out  std_logic_vector (MEM_WORD_LENGTH-1 downto 0));
end load;

architecture RTL of load is

signal latch_data_out: std_logic_vector(data'range);

begin

data_out <= latch_data_out;

process(clk)
begin
	if rising_edge(clk) then
		if valid = '1' then
			latch_data_out <= data_in;
		end if;
	end if;
end process;

end RTL;
