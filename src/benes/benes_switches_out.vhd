LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;


ENTITY benes_switches_out IS
	GENERIC (
		log_size: INTEGER; -- given as log2(number of elements)
		log_size_network: INTEGER
	);
	
	PORT (
		clk: IN STD_LOGIC;
		--input_messages: IN data_message(((2**log_size) - 1) DOWNTO 0);
		input_messages: IN data_message_array(0 TO 2**log_size - 1);
		output_messages: OUT data_message_array(0 TO ((2**log_size) - 1))
	);
	
	CONSTANT size: INTEGER := 2**log_size;
END benes_switches_out;

ARCHITECTURE benes_switches_out OF benes_switches_out IS

BEGIN
	-- TODO: local choice switching
	-- placeholder:
	output_messages <= input_messages;
END benes_switches_out;
