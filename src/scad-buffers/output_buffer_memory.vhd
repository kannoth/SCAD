library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.ALL;

library scad_lib;
use scad_lib.Constants.ALL;
use scad_lib.Datatypes.ALL;

entity output_buffer_memory is

	generic (
		size 	     : integer;
		addr_width : integer
 	);

	port (
		clk : in std_logic;
		rst : in std_logic;

		addr_we 		: in std_logic;
		addr_waddr : in unsigned(addr_width-1 downto 0);
		addr_wdata : in buffer_address_t;

		data_we 		: in std_logic;
		data_waddr : in unsigned(addr_width-1 downto 0);
		data_wdata : in data_value_t;

		raddr   : in unsigned(addr_width-1 downto 0);
		dout    : out output_buffer_entry_t
	);

end output_buffer_memory;

architecture Behavioral of output_buffer_memory is
	type a_ram_t is array (size-1 downto 0) of buffer_address_t;
	type d_ram_t is array (size-1 downto 0) of data_value_t;

	signal ARAM : a_ram_t;
	signal DRAM : d_ram_t;

begin
	process(clk)
	begin
		if rising_edge(clk) then
				if addr_we = '1' then
					ARAM(to_integer(addr_waddr)) <= addr_wdata;
				end if;
			end if;
	end process;
	process(clk)
	begin
		if rising_edge(clk) then
				if data_we = '1' then
					DRAM(to_integer(data_waddr)) <= data_wdata;
				end if;
			end if;
	end process;
	dout <= (
		target_address => ARAM(to_integer(raddr)),
		value => DRAM(to_integer(raddr))
	);
end Behavioral;
