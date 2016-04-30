LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;


ENTITY banyan_stall_permutation IS
	GENERIC (
		log_size: INTEGER := 3; -- given as log2(number of elements)
		inverse: STD_LOGIC := '0'
	);
	
	PORT (
		--input_messages: IN data_message(((2**log_size) - 1) DOWNTO 0);
		inputs: IN data_port_sending_array(0 TO 2**log_size - 1);
		inputs_fb: OUT data_port_receiving_array(0 TO 2**log_size - 1);
		outputs: OUT data_port_sending_array(0 TO ((2**log_size) - 1));
		outputs_fb: IN data_port_receiving_array(0 TO ((2**log_size) - 1))
	);
	
	CONSTANT size: INTEGER := 2**log_size;
END banyan_stall_permutation;

ARCHITECTURE banyan_stall_permutation of banyan_stall_permutation IS
BEGIN
	gen_mapping: FOR index IN 0 TO size-1 GENERATE
		CONSTANT source_bits: STD_LOGIC_VECTOR(log_size-1 DOWNTO 0) :=
			std_logic_vector(to_unsigned(index, log_size));
		
		-- inverse perfect shuffle permutation to get destination bits
		-- (right-rolling the bits of our address range)
		CONSTANT dest_bits: STD_LOGIC_VECTOR(log_size-1 DOWNTO 0) :=
			to_stdlogicvector(to_bitvector(source_bits) ror 1);
			
		CONSTANT dest_index: integer := to_integer(unsigned(dest_bits));
	BEGIN
		
		regular_case: IF inverse = '0' GENERATE
			outputs(dest_index) <= inputs(index);
			inputs_fb(index) <= outputs_fb(dest_index);
		END GENERATE regular_case;
		
		inverse_case: IF inverse = '1' GENERATE
			outputs(index) <= inputs(dest_index);
			inputs_fb(dest_index) <= outputs_fb(index);
		END GENERATE inverse_case;
		
	END GENERATE gen_mapping;
END banyan_stall_permutation;

