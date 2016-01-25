
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.glbSharedTypes.ALL;



entity adder is
    Port ( op1 : in  signed (OP_WIDTH-1 downto 0);
           op2 : in  signed (OP_WIDTH-1 downto 0);
           res : out  signed (OP_WIDTH-1 downto 0));
end adder;

architecture RTL of adder is

begin

res <= op1 + op2;

end RTL;

