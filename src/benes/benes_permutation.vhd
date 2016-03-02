LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;


ENTITY benes_permutation IS
	GENERIC (
		log_size: INTEGER := 3 -- given as log2(number of elements)
	);
	
	PORT (
		--input_messages: IN data_message(((2**log_size) - 1) DOWNTO 0);
		input_messages: IN data_message_array(0 TO 2**log_size - 1);
		output_messages: OUT data_message_array(0 TO ((2**log_size) - 1))
	);
	
	CONSTANT size: INTEGER := 2**log_size;
END benes_permutation;

ARCHITECTURE benes_permutation of benes_permutation IS
BEGIN
	gen_mapping: FOR index IN 0 TO size-1 GENERATE
		CONSTANT source_bits: STD_LOGIC_VECTOR(log_size-1 DOWNTO 0) :=
			std_logic_vector(to_unsigned(index, log_size));
		
		-- inverse perfect shuffle permutation to get destination bits
		CONSTANT dest_bits: STD_LOGIC_VECTOR(log_size-1 DOWNTO 0) :=
			--(log_size-1 => source_bits(0),
			-- 0 TO log_size-2 => source_bits(1 TO log_size-1));
			to_stdlogicvector(to_bitvector(source_bits) ror 1);
			
		CONSTANT dest_index: integer := to_integer(unsigned(dest_bits));
	BEGIN
		
		output_messages(dest_index) <= input_messages(index);
		
	END GENERATE gen_mapping;
END benes_permutation;

