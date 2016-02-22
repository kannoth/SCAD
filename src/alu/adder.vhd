
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;



entity adder is
    Port ( 	clk : in std_logic;
				op1 : in  std_logic_vector (FU_DATA_W-1 downto 0);
				op2 : in  std_logic_vector (FU_DATA_W-1 downto 0);
				en	: in 	std_logic;
				res : out  std_logic_vector (FU_DATA_W-1 downto 0);
				valid : out std_logic);
end adder;

architecture RTL of adder is

signal reg_valid 	: std_logic := '0';
signal reg_out		: std_logic_vector(res'range);

begin

valid 	<= reg_valid;
res		<= reg_out;

process(clk)
begin
if rising_edge(clk) then
	if en = '1' then	
		reg_out <= std_logic_vector(signed(op1) + signed(op2));
		reg_valid <= '1';
	else
		reg_out <= reg_out;
		reg_valid <= '0';
	end if;
end if;
end process;

end RTL;

