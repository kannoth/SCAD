library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.ALL;

library scad_lib;
use scad_lib.Constants.ALL;
use scad_lib.Datatypes.ALL;

entity input_buffer_memory is

	generic (
		size 	     : integer;
		addr_width : integer
 	);

	port (
		clk : in std_logic;
		rst : in std_logic;

		we 		: in std_logic;
		waddr : in unsigned(addr_width-1 downto 0);
		wdata : in input_buffer_entry_t;

		raddra : in unsigned(addr_width-1 downto 0);
		douta  : out input_buffer_entry_t

	);

end input_buffer_memory;

architecture Behavioral of input_buffer_memory is
	type ram_t is array (size-1 downto 0) of std_logic_vector(buffer_address_width_c + data_word_width_c downto 0);

	signal RAM : ram_t;

begin
	process(clk)
	begin
		if rising_edge(clk) then
				if we = '1' then
					RAM(to_integer(waddr)) <= from_input_buffer_entry(wdata);
				end if;
			end if;
	end process;
	douta <= to_input_buffer_entry(RAM(to_integer(raddra)));
end Behavioral;
