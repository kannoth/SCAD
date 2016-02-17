library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library std;
use std.env.all;

library scad_lib;
use scad_lib.Datatypes.ALL;
use scad_lib.Constants.ALL;

entity simple_input_buffer_tb is
end simple_input_buffer_tb;

architecture Behavioral of simple_input_buffer_tb is

	signal clk   : STD_LOGIC := '0';
	signal clk2x : STD_LOGIC := '1';
	signal rst   : STD_LOGIC;

	signal instr_bus       : instruction_bus_message_t;
	signal instr_bus_wen   : STD_LOGIC;
	signal instr_bus_full  : STD_LOGIC;
	signal instr_bus_apply : STD_LOGIC;

	signal data_bus     : data_bus_message_t;
	signal data_bus_wen : STD_LOGIC;
	signal data_bus_ack : STD_LOGIC;

	signal fu_output       : fu_data_t(0 to 1);
	signal fu_output_valid : STD_LOGIC;
	signal fu_output_ren   : STD_LOGIC;

begin
	uut : entity scad_lib.simple_input_buffer
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

		data_bus     => data_bus,
		data_bus_wen => data_bus_wen,
		data_bus_ack => data_bus_ack,

		fu_output       => fu_output,
		fu_output_valid => fu_output_valid,
		fu_output_ren   => fu_output_ren
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
		data_bus_wen <= '0';
		instr_bus_wen <= '0';
		instr_bus_apply <= '0';
		fu_output_ren <= '0';

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

		wait until rising_edge(clk);

		-- Fill Data
		for I in 1 to 7 loop
			data_bus.source_address <= to_unsigned(I, buffer_address_width_c);
			data_bus.target_address <= to_unsigned(40, buffer_address_width_c);
			data_bus.value <= std_logic_vector(to_unsigned(I, data_word_width_c));
			data_bus_wen <= '1';
			loop
				wait until rising_edge(clk);
				data_bus_wen <= '0';
				wait until rising_edge(clk);
				if data_bus_ack = '1' then
					exit;
				else
					data_bus_wen <= '1';
				end if;
			end loop;
		end loop;

		wait until rising_edge(clk);
		for I in 1 to 8 loop
			data_bus.source_address <= to_unsigned(I, buffer_address_width_c);
			data_bus.target_address <= to_unsigned(41, buffer_address_width_c);
			data_bus.value <= std_logic_vector(to_unsigned(I, data_word_width_c));
			data_bus_wen <= '1';
			loop
				wait until rising_edge(clk);
				data_bus_wen <= '0';
				wait until rising_edge(clk);
				if data_bus_ack = '1' then
					exit;
				else
					data_bus_wen <= '1';
				end if;
			end loop;
		end loop;

		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);

		wait until rising_edge(clk);


		for I in 1 to 20 loop
			fu_output_ren <= '0';
			wait until rising_edge(clk);
			if fu_output_valid = '1' then
				fu_output_ren <= '1';
				report "Read values " & integer'image(to_integer(unsigned(fu_output(0)))) & " and " & integer'image(to_integer(unsigned(fu_output(1))));
				wait until rising_edge(clk);
			end if;
		end loop;
		fu_output_ren <= '0';

		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);

		wait until rising_edge(clk);


		finish(0);

	end process;

end Behavioral;
