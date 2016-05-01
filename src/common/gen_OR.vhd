
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.common.ALL;

entity gen_OR is
  Port ( 	input: IN mib_status_bus;
				output:OUT STD_LOGIC
  );
end gen_OR;

architecture Behavioral of gen_OR is
    signal temp: std_logic;
begin
	output <= temp;
	process (input)
		begin
				temp <= '0';
				for i in 0 to FU_DATA_W - 1 loop
					if input(i).src_stalled = '1' or input(i).dest_stalled = '1' then
						temp <= '1';
					end if;
			end loop;
		end process;
end Behavioral;
