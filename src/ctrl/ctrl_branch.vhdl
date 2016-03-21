LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


LIBRARY work;
USE work.common.ALL;
USE work.instruction.ALL;


ENTITY ctrl_branch IS
	PORT(
		clock: IN STD_LOGIC;
		
		-- Instruction input
		instruction: IN instruction;
		
		-- data network: input connection
		data_in: IN data_port_sending;
		data_in_feedback: OUT data_port_receiving;
		
		-- ctrl internal
		branch_offset: OUT data_word;
		branch_taken: OUT STD_LOGIC;
		stall_pc: OUT STD_LOGIC := (others => '1');
	);
END ctrl_branch;

ARCHITECTURE ctrl_branch OF ctrl_branch IS
BEGIN
	proc: PROCESS(clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF instruction.op = JUMP THEN
				branch_offset <= instruction.param;
				branch_taken <= '1';
				stall_pc <= '0';
			ELSIF instruction.op = BRANCH THEN
				-- TODO: handle the interesting case - stalling for now
				stall_pc <= '1';
			ELSE
				stall_pc <= '0';
		END IF;
	END PROCESS;
END ctrl_branch;

