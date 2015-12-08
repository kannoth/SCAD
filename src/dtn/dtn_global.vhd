library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

package dtn_global is

	constant ADDRESS_WIDTH 		: natural := 5;
	constant DATA_WIDTH    		: natural := 32;
	constant BUFFER_SEL_WIDTH	: natural := 1;
	constant SORTER_DEPTH		: natural := 5;
	
	constant NUM_ITEMS			: natural := 2**SORTER_DEPTH;

	type fu_type is record
		address		: unsigned(ADDRESS_WIDTH-1 downto 0);
		data			: std_logic_vector(DATA_WIDTH-1 downto 0);
		buf_select	: std_logic_vector(BUFFER_SEL_WIDTH -1 downto 0);
	end record;

	type io_array is array (NUM_ITEMS -1 downto 0) of fu_type;
	
	component comp_ascending 
			port(
				data_in_1			: in fu_type;
				data_in_2			: in fu_type;
				data_out_1			: out fu_type;
				data_out_2			: out fu_type
			);
	end component;
	
	component comp_descending 
			port(
				data_in_1			: in fu_type;
				data_in_2			: in fu_type;
				data_out_1			: out fu_type;
				data_out_2			: out fu_type
			);
	end component;
	
end package dtn_global;

package body dtn_global is
end package body dtn_global;
