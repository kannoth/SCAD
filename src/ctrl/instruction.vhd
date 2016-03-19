LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;


PACKAGE instruction IS
	CONSTANT ADDRESS_BUFF_WIDTH: NATURAL := 1;
	--
	TYPE opcode IS (MOVE, JUMP, BRANCH, IMMEDIATE);
	
	-- All but the move instruction have one parameter
	TYPE instruction IS RECORD
		op: opcode;
		param: data_word;
	END RECORD;
	TYPE instruction_array IS ARRAY(NATURAL RANGE <>) OF instruction;
	
	TYPE move_instruction IS RECORD
		op: opcode;
		src: address_fu_buff;
		dest: address_fu_buff;
	END RECORD;
	TYPE move_instruction_array IS ARRAY(NATURAL RANGE <>) OF move_instruction;
	
	FUNCTION to_move_instruction(instr: instruction)
		RETURN move_instruction;
	FUNCTION to_instruction(instr: move_instruction)
		RETURN instruction;
	
	FUNCTION to_instruction(op:opcode; param: INTEGER)
		RETURN instruction;
	FUNCTION to_instruction(op:opcode; from_fu, from_buff, to_fu, to_buff: INTEGER)
		RETURN instruction;
END instruction;

PACKAGE BODY instruction IS
	FUNCTION to_move_instruction(instr: instruction)
		RETURN move_instruction IS
		VARIABLE result: move_instruction;
	BEGIN
		result.op := instr.op;
		
		result.src.fu((ADDRESS_FU_WIDTH - 1) DOWNTO 0) :=
			instr.param((DATA_WIDTH - 1) DOWNTO
			(DATA_WIDTH - ADDRESS_FU_WIDTH));
		
		--result.src.buff((ADDRESS_BUFF_WIDTH - 1) DOWNTO 0) :=
		--	instr.param((DATA_WIDTH - ADDRESS_FU_WIDTH - 1) DOWNTO
		--	(DATA_WIDTH - ADDRESS_FU_WIDTH - ADDRESS_BUFF_WIDTH));
		result.src.buff := instr.param((DATA_WIDTH - ADDRESS_FU_WIDTH - 1));
		
		result.dest.fu((ADDRESS_FU_WIDTH - 1) DOWNTO 0) :=
			instr.param((DATA_WIDTH - ADDRESS_FU_WIDTH - ADDRESS_BUFF_WIDTH - 1) DOWNTO
			(DATA_WIDTH - (2 * ADDRESS_FU_WIDTH) - ADDRESS_BUFF_WIDTH));
		
		--result.dest.buff((ADDRESS_BUFF_WIDTH - 1) DOWNTO 0) :=
		--	instr.param((DATA_WIDTH - (2 * ADDRESS_FU_WIDTH) - ADDRESS_BUFF_WIDTH - 1) DOWNTO
		--	(DATA_WIDTH - (2 * ADDRESS_FU_WIDTH) - (2 * ADDRESS_BUFF_WIDTH)));
		result.dest.buff :=
			instr.param((DATA_WIDTH - (2 * ADDRESS_FU_WIDTH) - ADDRESS_BUFF_WIDTH - 1));
		
		return result;
	END to_move_instruction;
	
	FUNCTION to_instruction(instr: move_instruction)
		RETURN instruction IS
		VARIABLE result: instruction :=
			(op => JUMP, param => (OTHERS => '0'));
	BEGIN
		result.op := instr.op;
		result.param((DATA_WIDTH - 1) DOWNTO
			(DATA_WIDTH - ADDRESS_FU_WIDTH)) :=
				instr.src.fu((ADDRESS_FU_WIDTH - 1) DOWNTO 0);
		
		result.param(DATA_WIDTH - ADDRESS_FU_WIDTH - 1) :=
				instr.src.buff;
		
		result.param((DATA_WIDTH - ADDRESS_FU_WIDTH - ADDRESS_BUFF_WIDTH - 1) DOWNTO
			(DATA_WIDTH - (2 * ADDRESS_FU_WIDTH) - ADDRESS_BUFF_WIDTH)) :=
				instr.dest.fu((ADDRESS_FU_WIDTH - 1) DOWNTO 0);
		
		result.param(DATA_WIDTH - (2 * ADDRESS_FU_WIDTH) - ADDRESS_BUFF_WIDTH - 1) :=
				instr.dest.buff;
		
		return result;
	END to_instruction;
	
	FUNCTION to_instruction(op:opcode; param: INTEGER)
		RETURN instruction IS
		VARIABLE result: instruction :=
			(op => JUMP, param => (OTHERS => '0'));
	BEGIN
		result.op := op;
		
		result.param := std_logic_vector(to_unsigned(param, DATA_WIDTH));
		
		return result;
	END to_instruction;
	
	FUNCTION to_instruction(op:opcode; from_fu, from_buff, to_fu, to_buff: INTEGER)
		RETURN instruction IS
			
		VARIABLE intermediate_from_buff: STD_LOGIC_VECTOR (0 TO 0);
		VARIABLE intermediate_to_buff: STD_LOGIC_VECTOR (0 TO 0);
		VARIABLE intermediate: move_instruction :=
			(op => JUMP, OTHERS => (buff => '0', OTHERS => (OTHERS => '0')));
			
		VARIABLE result: instruction :=
			(op => JUMP, param => (OTHERS => '0'));
	BEGIN
		intermediate.op := op;
		intermediate.src.fu := std_logic_vector(to_unsigned(from_fu, ADDRESS_FU_WIDTH));
		intermediate_from_buff := std_logic_vector(to_unsigned(from_buff, ADDRESS_BUFF_WIDTH));
		intermediate.src.buff := intermediate_from_buff(0);
		intermediate.dest.fu := std_logic_vector(to_unsigned(to_fu, ADDRESS_FU_WIDTH));
		intermediate_to_buff := std_logic_vector(to_unsigned(to_buff, ADDRESS_BUFF_WIDTH));
		intermediate.dest.buff := intermediate_to_buff(0);
		
		result := to_instruction(intermediate);
		return result;
	END to_instruction;
END instruction;
