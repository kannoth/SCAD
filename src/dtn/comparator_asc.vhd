library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dtn_global.all;

entity comp_ascending is

				port(
					clk					: in std_logic;
					data_in_1			: in fu_type;
					data_in_2			: in fu_type;
					data_out_1			: out fu_type;
					data_out_2			: out fu_type
				);
end entity comp_ascending;



-------------------------------------
---Ascending comparator arch.--------
-------------------------------------
architecture RTL of comp_ascending is

signal reg1 : fu_type;
signal reg2 : fu_type;

begin

data_out_1 <= reg1;
data_out_2 <= reg2;

process(clk)
	begin
		if rising_edge(clk) then
			if data_in_1.address > data_in_2.address then
				reg2 <= data_in_1;
				reg1 <= data_in_2;
			else
				reg1 <= data_in_1;
				reg2 <= data_in_2;
			end if;
		end if;
end process;

end architecture RTL;

