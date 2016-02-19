library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.ALL;

library scad_lib;
use scad_lib.Datatypes.ALL;
use scad_lib.Constants.ALL;

entity simple_input_buffer_mem_unit is

	generic (
		size : integer := 16
	);

	port (
		clk2x : in std_logic;
		rst 	: in std_logic;

		full  : out std_logic;
		empty : out std_logic;
		busy  : out std_logic;

		address_in  : in buffer_address_t;
		address_wen : in std_logic;

		data_value_in   : in data_value_t;
		data_address_in : in buffer_address_t;
		data_wen        : in std_logic;

		fu_out   : out data_value_t;
		fu_valid : out std_logic;
		fu_ren   : in std_logic
	);

end simple_input_buffer_mem_unit;

architecture Behavioral of simple_input_buffer_mem_unit is

	constant buffer_mem_address_width_c : integer := integer(ceil(log2(real(size))));
	subtype buffer_mem_address_t is unsigned (buffer_mem_address_width_c-1 downto 0);

	signal mem_we : std_logic;
	signal mem_waddr : buffer_mem_address_t;
	signal mem_wdata : input_buffer_entry_t;
	signal mem_raddr : buffer_mem_address_t;
	signal mem_dout  : input_buffer_entry_t;

	signal search_address : buffer_address_t;
	signal search_value : data_value_t;

	signal clock_cycle : std_logic;

begin
	mem : entity scad_lib.input_buffer_memory
	generic map (
		size => size,
		addr_width => buffer_mem_address_width_c
	)

	port map (
		clk => clk2x,
		rst => rst,

		we => mem_we,
		waddr => mem_waddr,
		wdata => mem_wdata,

		raddra => mem_raddr,
		douta => mem_dout
	);

	process(clk2x)
	variable write_pt       : buffer_mem_address_t;
	variable read_pt        : buffer_mem_address_t;
	variable search_pt      : buffer_mem_address_t;
	variable next_full      : std_logic;
	variable next_empty     : std_logic;
	variable next_busy      : std_logic;
	begin
		if rising_edge(clk2x) then
			if rst = '0' then
				clock_cycle <= '0';

				next_full := '0';
				next_empty := '1';
				next_busy := '0';

				read_pt := to_unsigned(0, buffer_mem_address_width_c);
				write_pt := to_unsigned(0, buffer_mem_address_width_c);
				search_pt := to_unsigned(0, buffer_mem_address_width_c);
				mem_we <= '0';
			else
				-- DoubleClock cycle 0: Write address / read search address
				if clock_cycle = '0' then
					clock_cycle <= '1';
					-- Write new address
					if next_full /= '1' and address_wen = '1' then
						mem_we <= '1';
						mem_waddr <= write_pt;
						mem_wdata <= (
							source_address => address_in,
							value => (others => '0'),
							value_valid => '0'
						);
						if write_pt = size-1 then
							write_pt := to_unsigned(0, buffer_mem_address_width_c);
						else
							write_pt := write_pt+1;
						end if;
						if write_pt = read_pt then
							next_full := '1';
						end if;
						next_empty := '0';
					else
						mem_we <= '0';
					end if;
					-- Move read pointer if fu has read
					if next_empty /= '1' and fu_ren = '1' and mem_dout.value_valid = '1' then
						if read_pt = size-1 then
							read_pt := to_unsigned(0, buffer_mem_address_width_c);
						else
							read_pt := read_pt+1;
						end if;
						if write_pt = read_pt then
							next_empty := '1';
						end if;
						next_full := '0';
					end if;
					fu_valid <= mem_dout.value_valid;
					fu_out <= mem_dout.value;
					-- Set/read search pointer
					if data_wen = '1' and next_busy /= '1' and next_empty /= '1' then
						next_busy := '1';
						search_value <= data_value_in;
						search_address <= data_address_in;
						search_pt := read_pt;
					end if;
					-- Prepare next cycle
					mem_raddr <= search_pt;
				-- DoubleClock Cycle 1: Evaluate search / write data
				elsif clock_cycle = '1' then
					clock_cycle <= '0';

					-- Evaluate running search
					if next_busy = '1' then
						-- Write data if entry is found
						if mem_dout.source_address = search_address and mem_dout.value_valid = '0' then
							mem_we <= '1';
							mem_waddr <= search_pt;
							mem_wdata <= (source_address => mem_dout.source_address, value => search_value, value_valid => '1');
							next_busy := '0';
						else
							mem_we <= '0';
							if search_pt = size-1 then
								search_pt := to_unsigned(0, buffer_mem_address_width_c);
							else
								search_pt := search_pt+1;
							end if;
							if search_pt = write_pt then
								next_busy := '0';
							end if;
						end if;
					else
						mem_we <= '0';
					end if;

					--Prepare next cycle
					mem_raddr <= read_pt;

					full  <= next_full;
					empty <= next_empty;
					busy  <= next_busy;
				end if;
			end if;
		end if;
	end process;
end architecture;
