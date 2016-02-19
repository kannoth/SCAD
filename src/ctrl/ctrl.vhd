LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


LIBRARY work;
USE work.common.ALL;
USE work.instruction.ALL;


ENTITY ctrl IS
	PORT(
		-- data network: output connection
		data_out: OUT data_port_sending;
		data_out_feedback: IN data_port_receiving;
		-- data network: input connection
		data_in: IN data_port_sending;
		data_in_feedback: OUT data_port_receiving;
		
		-- move instruction bus
		mib_out: OUT mib_ctrl_out;
		mib_stalls: IN mib_stalls
		
		-- memory interface for instruction fetch
		-- TODO
	);
END ctrl;

ARCHITECTURE ctrl OF ctrl IS
	SIGNAL current_instruction: instruction;
	SIGNAL stall_branch,
	       stall_immediate,
	       stall_move_instr,
	       is_stalled: STD_LOGIC;
BEGIN	
	branch: ENTITY work.ctrl_branch
		PORT MAP (
			instruction => current_instruction,
			stall => stall_branch);
	
	is_stalled <= stall_branch or
	              stall_immediate or
	              stall_move_instr;
	
END ctrl;
