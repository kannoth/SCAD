LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;


ENTITY benes_switchcolumn_out IS
	GENERIC (
		log_size: INTEGER; -- given as log2(number of elements)
		log_size_network: INTEGER
	);
	
	PORT (
		clk: IN STD_LOGIC;
		rst: IN STD_LOGIC;
		inputs: IN data_port_sending_array(0 TO 2**log_size - 1);
		inputs_fb: OUT data_port_receiving_array(0 TO 2**log_size - 1);
		outputs: OUT data_port_sending_array(0 TO ((2**log_size) - 1));
		outputs_fb: IN data_port_receiving_array(0 TO ((2**log_size) - 1))
	);
	
	CONSTANT size: INTEGER := 2**log_size;
END benes_switchcolumn_out;

ARCHITECTURE benes_switchcolumn_out OF benes_switchcolumn_out IS

BEGIN
	assert log_size > 0
		report "making a benes network for 1 element or less is not supported";
	
	-- TODO: local choice switching
	-- placeholder:
	switches: FOR I IN 0 TO (size/2)-1 GENERATE
		-- a switch every second row
		CONSTANT POS: integer := I * 2;
	BEGIN
		switch: ENTITY work.benes_switch_out
			GENERIC MAP(log_size, log_size_network)
			PORT MAP(clk, rst,
			         inputs(POS TO POS+1), inputs_fb(POS TO POS+1),
			         outputs(POS TO POS+1), outputs_fb(POS TO POS+1));
	END GENERATE switches;
END benes_switchcolumn_out;
