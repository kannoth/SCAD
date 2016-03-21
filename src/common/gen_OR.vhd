
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.common.ALL;

entity gen_OR is
  GENERIC (N: positive := 2*FU_DATA_W );
  Port ( input: IN STD_LOGIC_VECTOR (N-1 downto 0);
        output:OUT STD_LOGIC
  );
end gen_OR;

architecture Behavioral of gen_OR is
    signal temp: std_logic_vector (N-1 downto 0);
begin
    temp(0) <= input(0);
    gen: for i in 1 to N-1 generate
        temp(i) <= temp(i-1) or input(i);
    end generate; 
    output <= temp(N-1);
end Behavioral;
