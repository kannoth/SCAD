library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dtn_global.all;

entity comp_descending is

        port(
               data_in_1			: in fu_type;
					data_in_2			: in fu_type;
					data_out_1			: out fu_type;
					data_out_2			: out fu_type
        );
end entity comp_descending;

-------------------------------------
---Descending comparator arch.-------
-------------------------------------
architecture RTL of comp_descending is

begin

data_out_1 <= data_in_1 when data_in_1.address > data_in_2.address else data_in_2;
data_out_2 <= data_in_2 when data_in_1.address > data_in_2.address else data_in_1;

end architecture RTL;

