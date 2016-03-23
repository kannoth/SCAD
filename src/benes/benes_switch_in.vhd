LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;


ENTITY benes_switch_in IS
	GENERIC (
		log_step: INTEGER; -- given as log2(number of elements)
		log_size_network: INTEGER
	);
	
	PORT (
		clk: IN STD_LOGIC;
		rst: IN STD_LOGIC;
		inputs: IN data_port_sending_array(0 TO 1);
		inputs_fb: OUT data_port_receiving_array(0 TO 1);
		outputs: OUT data_port_sending_array(0 TO 1);
		outputs_fb: IN data_port_receiving_array(0 TO 1)
	);
	
	CONSTANT size: INTEGER := 2;
END benes_switch_in;

ARCHITECTURE benes_switch_in OF benes_switch_in IS

BEGIN
	-- TODO: implement functionality
	outputs <= inputs;
	inputs_fb <= outputs_fb;
END benes_switch_in;

