LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;


ENTITY benes_network IS
	GENERIC (
		log_size: INTEGER := 5; -- given as log2(number of elements)
		log_size_network: INTEGER := 5
	);
	
	PORT (
		clk: IN STD_LOGIC;
		--input_messages: IN data_message(((2**log_size) - 1) DOWNTO 0);
		input_messages: IN data_message_array(0 TO 2**log_size - 1);
		output_messages: OUT data_message_array(0 TO ((2**log_size) - 1))
	);
	
	CONSTANT size: INTEGER := 2**log_size;
END benes_network;

ARCHITECTURE benes_network of benes_network IS
	-- network structure:
	
	-- input_messages
	-- input_switches
	SIGNAL post_input: data_message_array(0 TO size - 1);
	-- permutation
	SIGNAL subnetworks_input: data_message_array(0 TO size - 1);
	-- split
	SIGNAL subnetwork1_input: data_message_array(0 TO (size/2) - 1);
	SIGNAL subnetwork2_input: data_message_array(0 TO (size/2) - 1);
	-- subnetworks
	SIGNAL subnetwork1_output: data_message_array(0 TO (size/2) - 1);
	SIGNAL subnetwork2_output: data_message_array(0 TO (size/2) - 1);
	-- merge
	SIGNAL subnetworks_output: data_message_array(0 TO size - 1);
	-- permutation
	SIGNAL pre_output: data_message_array(0 TO size - 1);
	-- output_switches
	-- output_messages
	
BEGIN
	assert log_size > 0
		report "making a benes network for 1 element or less is not supported";
	
	-- TODO: There is no feedback (acks being sent)
	-- TODO: There are no registers
	
	-- recursion stops at log_size = 1
	simple_case: IF log_size = 1 GENERATE
	BEGIN
		simple_switches: ENTITY work.benes_switches_out GENERIC MAP(log_size, log_size_network) PORT MAP(clk, input_messages, output_messages);
	END GENERATE simple_case;
	
	-- RECURSION
	recursive_case: if log_size > 1 GENERATE
		-- input messages
		
		input_switches: ENTITY work.benes_switches_in GENERIC MAP(log_size, log_size_network) PORT MAP(clk, input_messages, post_input);
		
		-- post_input
		
		input_permutation: ENTITY work.benes_permutation GENERIC MAP(log_size, '0') PORT MAP(post_input, subnetworks_input);
		
		array_split: FOR I IN 0 TO size-1 GENERATE
			array_split_first_half: IF I < (size/2) GENERATE
				subnetwork1_input(I) <= subnetworks_input(I);
			END GENERATE array_split_first_half;
			
			array_split_second_half: IF I >= (size/2) GENERATE
				subnetwork2_input(I - (size/2)) <= subnetworks_input(I);
			END GENERATE array_split_second_half;
		END GENERATE array_split;
		
		subnetwork1: ENTITY work.benes_network GENERIC MAP (log_size - 1, log_size_network) PORT MAP(clk, subnetwork1_input, subnetwork1_output);
		
		subnetwork2: ENTITY work.benes_network GENERIC MAP (log_size - 1, log_size_network) PORT MAP(clk, subnetwork2_input, subnetwork2_output);
		
		array_merge: FOR I IN 0 TO size-1 GENERATE
			array_merge_first_half: IF I < (size/2) GENERATE
				subnetworks_output(I) <= subnetwork1_output(I);
			END GENERATE array_merge_first_half;
			
			array_merge_second_half: IF I >= (size/2) GENERATE
				subnetworks_output(I) <= subnetwork2_output(I - (size/2));
			END GENERATE array_merge_second_half;
		END GENERATE array_merge;
		
		output_permutation: ENTITY work.benes_permutation GENERIC MAP(log_size, '1') PORT MAP(subnetworks_output, pre_output);
		
		-- pre_output
		
		output_switches: ENTITY work.benes_switches_out GENERIC MAP(log_size, log_size_network) PORT MAP(clk, pre_output, output_messages);
		
		-- output_messages
	END GENERATE recursive_case;
END benes_network;


