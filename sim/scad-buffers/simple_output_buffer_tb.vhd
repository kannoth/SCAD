library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library std;
use std.env.all;

library scad_lib;
use scad_lib.Datatypes.ALL;
use scad_lib.Constants.ALL;

entity simple_output_buffer_tb is
end simple_output_buffer_tb;

architecture Behavioral of simple_output_buffer_tb is

	signal clk   : STD_LOGIC := '1';
	signal clk2x : STD_LOGIC := '1';
	signal rst   : STD_LOGIC;

	signal instr_bus       : instruction_bus_message_t;
	signal instr_bus_wen   : STD_LOGIC;
	signal instr_bus_full  : STD_LOGIC;
	signal instr_bus_apply : STD_LOGIC;

	signal data_bus      : data_bus_message_t;
	signal data_bus_ren  : STD_LOGIC;
	signal data_bus_valid : STD_LOGIC;

	signal fu_input        : fu_data_t(0 to 1);
	signal fu_input_wen    : STD_LOGIC;
	signal fu_input_full   : STD_LOGIC;


begin
	uut : entity scad_lib.simple_output_buffer
	generic map (
		base_address => to_unsigned(5, buffer_address_base_width_c),
		port_count   => 2,
		buffer_size  => 8
	)
	port map (
		clk   => clk,
		clk2x => clk2x,
		rst   => rst,

		instr_bus       => instr_bus,
		instr_bus_wen   => instr_bus_wen,
		instr_bus_full  => instr_bus_full,
		instr_bus_apply => instr_bus_apply,

		data_bus       => data_bus,
		data_bus_ren   => data_bus_ren,
		data_bus_valid => data_bus_valid,

		fu_input      => fu_input,
		fu_input_wen  => fu_input_wen,
		fu_input_full => fu_input_full
	);

	-- Generate clock
	clk <= not clk after 2 ns;
	clk2x <= not clk2x after 1 ns;

	-- Test program
	process
	begin
		rst <= '0';
		for I in 0 to 10 loop
			wait until rising_edge(clk);
		end loop;
		rst <= '1';
		data_bus_ren <= '0';
		instr_bus_wen <= '0';
		instr_bus_apply <= '0';
		data_bus_ren <= '0';
		fu_input_wen <= '0';

		wait until rising_edge(clk);

		-- Fill Addresses
		for I in 1 to 12 loop
			instr_bus.source_address <= to_unsigned(I, buffer_address_width_c);
			instr_bus.target_address <= to_unsigned(40, buffer_address_width_c);
			instr_bus_wen <= '1';
			wait until rising_edge(clk);
			instr_bus_wen <= '0';
			wait until rising_edge(clk);
			if instr_bus_full /= '1' then
				instr_bus_apply <= '1';
			else
				report "Tried to apply to full buffer";
				instr_bus_apply <= '0';
			end if;
			instr_bus_wen <= '0';
			wait until rising_edge(clk);
			instr_bus_apply <= '0';
		end loop;

		-- Fill Addresses
		for I in 1 to 12 loop
			instr_bus.source_address <= to_unsigned(I, buffer_address_width_c);
			instr_bus.target_address <= to_unsigned(41, buffer_address_width_c);
			instr_bus_wen <= '1';
			wait until rising_edge(clk);
			instr_bus_wen <= '0';
			wait until rising_edge(clk);
			if instr_bus_full /= '1' then
				instr_bus_apply <= '1';
			else
				report "Tried to apply to full buffer";
				instr_bus_apply <= '0';
			end if;
			instr_bus_wen <= '0';
			wait until rising_edge(clk);
			instr_bus_apply <= '0';
		end loop;

		-- Fill Data
		for I in 1 to 12 loop
			wait until rising_edge(clk);
			if not fu_input_full = '1' then
				fu_input <= (others => std_logic_vector(to_unsigned(I, data_word_width_c)));
				fu_input_wen <= '1';
			else
				fu_input_wen <= '0';
				report "Tried to write to full buffer";
			end if;
		end loop;
		wait until rising_edge(clk);
		fu_input_wen <= '0';

		wait until rising_edge(clk);
		wait until rising_edge(clk);

		for I in 1 to 20 loop
			if data_bus_valid = '1' then
				data_bus_ren <= '1';
				report "Read: " & integer'image(to_integer(unsigned(data_bus.source_address))) & " -> " & integer'image(to_integer(unsigned(data_bus.target_address))) & " : " & integer'image(to_integer(unsigned(data_bus.value)));
				wait until rising_edge(clk);
				data_bus_ren <= '0';
			else
				data_bus_ren <= '0';
				report "Tried to read invalid data";
			end if;
			wait until rising_edge(clk);
		end loop;
		data_bus_ren <= '0';

		wait until rising_edge(clk);

		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);

		wait until rising_edge(clk);


		finish(0);

	end process;

end Behavioral;
