
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.glbSharedTypes.ALL;



entity multiplicator is
	 Generic (
			  INPUT_WIDTH : natural := FU_DATA_W/2;
			  OUTPUT_WIDTH: natural := FU_DATA_W
			 );
    Port ( op1 : in  signed (INPUT_WIDTH -1 downto 0);
           op2 : in  signed (INPUT_WIDTH -1 downto 0);
           res : out  signed (OUTPUT_WIDTH - 1 downto 0));
end multiplicator;

architecture RTL of adder is

begin

res <= op1 - op2;

end RTL;

