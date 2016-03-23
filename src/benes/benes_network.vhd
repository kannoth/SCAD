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
		rst: IN STD_LOGIC;
		--input_messages: IN data_message(((2**log_size) - 1) DOWNTO 0);
		inputs: IN data_port_sending_array(0 TO 2**log_size - 1);
		inputs_fb: OUT data_port_receiving_array(0 TO 2**log_size - 1);
		
		outputs: OUT data_port_sending_array(0 TO ((2**log_size) - 1));
		outputs_fb: IN data_port_receiving_array(0 TO ((2**log_size) - 1))
	);
	
	CONSTANT size: INTEGER := 2**log_size;
END benes_network;

ARCHITECTURE benes_network of benes_network IS
	-- network structure:
	
	-- input_messages
	-- input_switches
	SIGNAL post_input: data_port_sending_array(0 TO size - 1);
	SIGNAL post_input_fb: data_port_receiving_array(0 TO size - 1);
	-- permutation
	SIGNAL subnetworks_input: data_port_sending_array(0 TO size - 1);
	SIGNAL subnetworks_input_fb: data_port_receiving_array(0 TO size - 1);
	-- split
	SIGNAL subnetwork1_input: data_port_sending_array(0 TO (size/2) - 1);
	SIGNAL subnetwork1_input_fb: data_port_receiving_array(0 TO (size/2) - 1);
	SIGNAL subnetwork2_input: data_port_sending_array(0 TO (size/2) - 1);
	SIGNAL subnetwork2_input_fb: data_port_receiving_array(0 TO (size/2) - 1);
	-- subnetworks
	SIGNAL subnetwork1_output: data_port_sending_array(0 TO (size/2) - 1);
	SIGNAL subnetwork1_output_fb: data_port_receiving_array(0 TO (size/2) - 1);
	SIGNAL subnetwork2_output: data_port_sending_array(0 TO (size/2) - 1);
	SIGNAL subnetwork2_output_fb: data_port_receiving_array(0 TO (size/2) - 1);
	-- merge
	SIGNAL subnetworks_output: data_port_sending_array(0 TO size - 1);
	SIGNAL subnetworks_output_fb: data_port_receiving_array(0 TO size - 1);
	-- permutation
	SIGNAL pre_output: data_port_sending_array(0 TO size - 1);
	SIGNAL pre_output_fb: data_port_receiving_array(0 TO size - 1);
	-- output_switches
	-- output_messages
	
BEGIN
	assert log_size > 0
		report "making a benes network for 1 element or less is not supported";
	
	-- recursion stops at log_size = 1
	simple_case: IF log_size = 1 GENERATE
	BEGIN
		simple_switches: ENTITY work.benes_switchcolumn_out
			GENERIC MAP(log_size, log_size_network)
			PORT MAP(clk, rst, inputs, inputs_fb, outputs, outputs_fb);
	END GENERATE simple_case;
	
	-- RECURSION
	recursive_case: if log_size > 1 GENERATE
		-- input messages
		
		-- TODO: benes_switchcolumn_in are not done
		input_switches: ENTITY work.benes_switchcolumn_in
			GENERIC MAP(log_size, log_size_network)
			PORT MAP(clk, rst, inputs, inputs_fb, post_input, post_input_fb);
		
		-- post_input
		
		input_permutation: ENTITY work.benes_permutation
			GENERIC MAP(log_size, '0') -- '0' is normal permutation
			PORT MAP(post_input, post_input_fb, subnetworks_input, subnetworks_input_fb);
		
		array_split: FOR I IN 0 TO size-1 GENERATE
			array_split_first_half: IF I < (size/2) GENERATE
				subnetwork1_input(I) <= subnetworks_input(I);
			 subnetworks_input_fb(I) <= subnetwork1_input_fb(I);
			END GENERATE array_split_first_half;
			
			array_split_second_half: IF I >= (size/2) GENERATE
				subnetwork2_input(I - (size/2)) <= subnetworks_input(I);
				subnetworks_input_fb(I) <= subnetwork2_input_fb(I - (size/2));
			END GENERATE array_split_second_half;
		END GENERATE array_split;
		
		subnetwork1: ENTITY work.benes_network
			GENERIC MAP (log_size - 1, log_size_network)
			PORT MAP(clk, rst, subnetwork1_input, subnetwork1_input_fb, subnetwork1_output, subnetwork1_output_fb);
		
		subnetwork2: ENTITY work.benes_network
			GENERIC MAP (log_size - 1, log_size_network)
			PORT MAP(clk, rst, subnetwork2_input, subnetwork2_input_fb, subnetwork2_output, subnetwork2_output_fb);
		
		array_merge: FOR I IN 0 TO size-1 GENERATE
			array_merge_first_half: IF I < (size/2) GENERATE
				subnetworks_output(I) <= subnetwork1_output(I);
				subnetwork1_output_fb(I) <= subnetworks_output_fb(I);
			END GENERATE array_merge_first_half;
			
			array_merge_second_half: IF I >= (size/2) GENERATE
				subnetworks_output(I) <= subnetwork2_output(I - (size/2));
				subnetwork2_output_fb(I - (size/2)) <= subnetworks_output_fb(I);
			END GENERATE array_merge_second_half;
		END GENERATE array_merge;
		
		output_permutation: ENTITY work.benes_permutation
			GENERIC MAP(log_size, '1') -- '1' indicates inverse permutation
			PORT MAP(subnetworks_output, subnetworks_output_fb, pre_output, pre_output_fb);
		
		-- pre_output
		
		-- TODO: benes_switchcolumn_out are not done
		output_switches: ENTITY work.benes_switchcolumn_out
			GENERIC MAP(log_size, log_size_network)
			PORT MAP(clk, rst, pre_output, pre_output_fb, outputs, outputs_fb);
		
		-- output_messages
	END GENERATE recursive_case;
END benes_network;


