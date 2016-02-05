LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


LIBRARY work;
USE work.common.ALL;
USE work.instruction.ALL;


ENTITY ctrl_branch IS
	PORT(
		-- Instruction input
		instruction: IN instruction;
		
		-- data network: input connection
		data_in: IN data_port_sending;
		data_in_feedback: OUT data_port_receiving;
		
		stall: OUT STD_LOGIC
	);
END ctrl_branch;

ARCHITECTURE ctrl_branch OF ctrl_branch IS
BEGIN
	
	-- TODO: functionality
	stall <= '1';
END ctrl_branch;

