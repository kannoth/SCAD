
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.glbSharedTypes.ALL;



entity subtractor is
	 Generic (
			  OP_WIDTH : natural := FU_DATA_W
			 );
    Port ( op1 : in  signed (OP_WIDTH-1 downto 0);
           op2 : in  signed (OP_WIDTH-1 downto 0);
           res : out  signed (OP_WIDTH-1 downto 0));
end subtractor;

architecture RTL of adder is

begin

res <= op1 - op2;

end RTL;

