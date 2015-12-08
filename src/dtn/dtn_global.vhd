library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package dtn_global is

	constant ADDRESS_WIDTH 		: natural := 5;
	constant DATA_WIDTH    		: natural := 32;
	constant BUFFER_SEL_WIDTH	: natural := 1;


	type fu_type is record
		address		: unsigned(ADDRESS_WIDTH-1 downto 0);
		data			: std_logic_vector(DATA_WIDTH-1 downto 0);
		buf_select	: std_logic_vector(BUFFER_SEL_WIDTH -1 downto 0);
	end record;


end package dtn_global;

package body dtn_global is
end package body dtn_global;
