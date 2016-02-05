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
		result.src.fu(4 downto 0) := instr.param(15 downto 11);
		result.src.buff(1 downto 0) := instr.param(10 downto 9);
		result.src.fu(4 downto 0) := instr.param(7 downto 3);
		result.src.buff(1 downto 0) := instr.param(2 downto 1);
		return result;
	END to_move_instruction;

	-- Most probably not required
	FUNCTION to_instruction(instr: move_instruction)
		RETURN instruction IS
		VARIABLE result: instruction;
	BEGIN
		result.op := instr.op;
		-- TODO: insert known (0) values for missing bits?
		result.param(15 downto 11) := instr.src.fu(4 downto 0);
		result.param(10 downto 9) := instr.src.buff(1 downto 0);
		result.param(7 downto 3) := instr.src.fu(4 downto 0);
		result.param(2 downto 1) := instr.src.buff(1 downto 0);
	END to_instruction;
END instruction;
