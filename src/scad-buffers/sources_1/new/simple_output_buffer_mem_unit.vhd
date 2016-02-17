library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.ALL;

library scad_lib;
use scad_lib.Datatypes.ALL;
use scad_lib.Constants.ALL;

entity simple_output_buffer_mem_unit is

	generic (
		size : integer := 16
	);

	port (
		clk : in std_logic;
		rst 	: in std_logic;

		addr_full  : out std_logic;
		addr_empty : out std_logic;
		fu_full  : out std_logic;
		fu_empty : out std_logic;

		address_in  : in buffer_address_t;
		address_wen : in std_logic;

		data_value_out   : out data_value_t;
		data_address_out : out buffer_address_t;
		data_ren         : in  std_logic;

		fu_in  : in data_value_t;
		fu_wen : in  std_logic
	);

end simple_output_buffer_mem_unit;

architecture Behavioral of simple_output_buffer_mem_unit is

	constant buffer_mem_address_width_c : integer := integer(ceil(log2(real(size))));
	subtype buffer_mem_address_t is unsigned (buffer_mem_address_width_c-1 downto 0);

	signal mem_addr_we : std_logic;
	signal mem_addr_waddr  : buffer_mem_address_t;
	signal mem_addr_wdata  : buffer_address_t;
	signal mem_data_we : std_logic;
	signal mem_data_waddr  : buffer_mem_address_t;
	signal mem_data_wdata  : data_value_t;

	signal mem_raddr : buffer_mem_address_t;
	signal mem_dout  : output_buffer_entry_t;

	signal read_pt : buffer_mem_address_t;

begin
	mem : entity scad_lib.output_buffer_memory
	generic map (
		size => size,
		addr_width => buffer_mem_address_width_c
	)

	port map (
		clk => clk,
		rst => rst,

		addr_we => mem_addr_we,
		addr_waddr => mem_addr_waddr,
		addr_wdata => mem_addr_wdata,

		data_we => mem_data_we,
		data_waddr => mem_data_waddr,
		data_wdata => mem_data_wdata,

		raddr => mem_raddr,
		dout => mem_dout
	);

	mem_raddr <= read_pt;
	data_value_out <= mem_dout.value;
	data_address_out <= mem_dout.target_address;

	process(clk)
	variable addr_write_pt   : buffer_mem_address_t;
	variable data_write_pt   : buffer_mem_address_t;
	variable next_addr_full  : std_logic;
	variable next_addr_empty : std_logic;
	variable next_fu_full  : std_logic;
	variable next_fu_empty : std_logic;
	begin
		if rising_edge(clk) then
			if rst = '0' then
				next_addr_full := '0';
				next_addr_empty := '1';
				next_fu_full := '0';
				next_fu_empty := '1';

				read_pt <= to_unsigned(0, buffer_mem_address_width_c);
				addr_write_pt := to_unsigned(0, buffer_mem_address_width_c);
				data_write_pt := to_unsigned(0, buffer_mem_address_width_c);

				mem_addr_we <= '0';
				mem_data_we <= '0';
			else
				-- Write new address
				if next_addr_full /= '1' and address_wen = '1' then
					mem_addr_we <= '1';
					mem_addr_waddr <= addr_write_pt;
					mem_addr_wdata <= address_in;
					if addr_write_pt = size-1 then
						addr_write_pt := to_unsigned(0, buffer_mem_address_width_c);
					else
						addr_write_pt := addr_write_pt+1;
					end if;
					if addr_write_pt = read_pt then
						next_addr_full := '1';
					end if;
					next_addr_empty := '0';
				else
					mem_addr_we <= '0';
				end if;
				-- Write data
				if next_fu_full /= '1' and fu_wen = '1' then
					mem_data_we <= '1';
					mem_data_waddr <= data_write_pt;
					mem_data_wdata <= fu_in;
					if data_write_pt = size-1 then
						data_write_pt := to_unsigned(0, buffer_mem_address_width_c);
					else
						data_write_pt := data_write_pt+1;
					end if;
					if data_write_pt = read_pt then
						next_fu_full := '1';
					end if;
					next_fu_empty := '0';
				else
					mem_data_we <= '0';
				end if;

				-- Read
				if data_ren = '1' and next_fu_empty /= '1' and next_addr_empty /= '1' then
					if read_pt = size-1 then
						read_pt <= to_unsigned(0, buffer_mem_address_width_c);
					else
						read_pt <= read_pt+1;
					end if;
					if data_write_pt = read_pt+1 then
						next_fu_empty := '1';
					end if;
					if addr_write_pt = read_pt+1 then
						next_addr_empty := '1';
					end if;
					next_fu_full := '0';
					next_addr_full := '0';
				end if;

				fu_full <= next_fu_full;
				fu_empty <= next_fu_empty;
				addr_full <= next_addr_full;
				addr_empty <= next_addr_empty;
			end if;
		end if;
	end process;
end architecture;
