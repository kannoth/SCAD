LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


LIBRARY work;
USE work.common.ALL;


PACKAGE instruction IS
	--
	TYPE opcode IS (MOVE, JUMP, BRANCH, IMMEDIATE);
	
	-- All but the move instruction have one parameter
	TYPE instruction IS RECORD
		op: opcode;
		param: data_word;
	END RECORD;
	
	TYPE move_instruction IS RECORD
		op: opcode;
		src: address_fu_buff;
		dest: address_fu_buff;
	END RECORD;
	
	FUNCTION to_move_instruction(instr: instruction) RETURN move_instruction;
	FUNCTION to_instruction(instr: move_instruction) RETURN instruction;
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
		
		result.src.buff((ADDRESS_BUFF_WIDTH - 1) DOWNTO 0) :=
			instr.param((DATA_WIDTH - ADDRESS_FU_WIDTH - 1) DOWNTO
			(DATA_WIDTH - ADDRESS_FU_WIDTH - ADDRESS_BUFF_WIDTH));
		
		result.dest.fu((ADDRESS_FU_WIDTH - 1) DOWNTO 0) :=
			instr.param((DATA_WIDTH - ADDRESS_FU_WIDTH - ADDRESS_BUFF_WIDTH - 1) DOWNTO
			(DATA_WIDTH - (2 * ADDRESS_FU_WIDTH) - ADDRESS_BUFF_WIDTH));
		
		result.dest.buff((ADDRESS_BUFF_WIDTH - 1) DOWNTO 0) :=
			instr.param((DATA_WIDTH - (2 * ADDRESS_FU_WIDTH) - ADDRESS_BUFF_WIDTH - 1) DOWNTO
			(DATA_WIDTH - (2 * ADDRESS_FU_WIDTH) - (2 * ADDRESS_BUFF_WIDTH)));
		
		return result;
	END to_move_instruction;

	-- Most probably not required
	FUNCTION to_instruction(instr: move_instruction)
		RETURN instruction IS
		-- TODO: Do we really want bits not used by the move instruction to be 0?
		VARIABLE result: instruction :=
			(op => JUMP, param => (OTHERS => '0'));
	BEGIN
		result.op := instr.op;
		result.param((DATA_WIDTH - 1) DOWNTO
			(DATA_WIDTH - ADDRESS_FU_WIDTH)) :=
				instr.src.fu((ADDRESS_FU_WIDTH - 1) DOWNTO 0);
		
		result.param((DATA_WIDTH - ADDRESS_FU_WIDTH - 1) DOWNTO
			(DATA_WIDTH - ADDRESS_FU_WIDTH - ADDRESS_BUFF_WIDTH)) :=
				instr.src.buff((ADDRESS_BUFF_WIDTH - 1) DOWNTO 0);
		
		result.param((DATA_WIDTH - ADDRESS_FU_WIDTH - ADDRESS_BUFF_WIDTH - 1) DOWNTO
			(DATA_WIDTH - (2 * ADDRESS_FU_WIDTH) - ADDRESS_BUFF_WIDTH)) :=
				instr.dest.fu((ADDRESS_FU_WIDTH - 1) DOWNTO 0);
		
		result.param((DATA_WIDTH - (2 * ADDRESS_FU_WIDTH) - ADDRESS_BUFF_WIDTH - 1) DOWNTO
			(DATA_WIDTH - (2 * ADDRESS_FU_WIDTH) - (2 * ADDRESS_BUFF_WIDTH))) :=
				instr.dest.buff((ADDRESS_BUFF_WIDTH - 1) DOWNTO 0);
		
		return result;
	END to_instruction;
END instruction;
