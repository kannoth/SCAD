
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;



entity subtractor is
    Port ( op1 : in  signed (FU_DATA_W-1 downto 0);
           op2 : in  signed (FU_DATA_W-1 downto 0);
           res : out  signed (FU_DATA_W-1 downto 0));
end subtractor;

architecture RTL of subtractor is

begin

res <= op1 - op2;

end RTL;

