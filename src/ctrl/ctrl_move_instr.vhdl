LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


LIBRARY work;
USE work.common.ALL;
USE work.instruction.ALL;


ENTITY ctrl_move_instr IS
	PORT(
		-- Instruction input
		instruction: IN instruction;
		
		-- data network: input connection
		data_in: IN data_port_sending;
		data_in_feedback: OUT data_port_receiving;
		
		stall: OUT STD_LOGIC
	);
END ctrl_move_instr;

ARCHITECTURE ctrl_move_instr OF ctrl_move_instr IS
	SIGNAL move_instruction: move_instruction;
BEGIN	
	move_instruction <= to_move_instruction(instruction);
	
	-- TODO: functionality
	stall <= '1';
END ctrl_move_instr;

