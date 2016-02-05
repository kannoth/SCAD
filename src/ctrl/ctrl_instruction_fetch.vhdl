LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


LIBRARY work;
USE work.common.ALL;
USE work.instruction.ALL;


ENTITY ctrl_instruction_fetch IS
	PORT(
		-- Instruction input
		instruction: OUT instruction;
		
		-- TODO: memory interface
		
		-- TODO: interface to ctrl_branch?
		
		stall: IN STD_LOGIC
	);
END ctrl_instruction_fetch;

ARCHITECTURE ctrl_instruction_fetch OF ctrl_instruction_fetch IS
BEGIN	
	-- TODO: functionality
	
END ctrl_instruction_fetch;

