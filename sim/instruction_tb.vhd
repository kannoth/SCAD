LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;
USE work.instruction.ALL;


ENTITY instruction_tb IS
END instruction_tb;

ARCHITECTURE instruction_tb OF instruction_tb IS
	SIGNAL first: move_instruction;
	SIGNAL second: instruction;
	SIGNAL third: move_instruction;
	
	SIGNAL clk: STD_LOGIC;
	
	constant clk_period : time := 10 ns;
BEGIN
	second <= to_instruction(first);
	third <= to_move_instruction(second);
	
	test: PROCESS BEGIN
		-- precondition
		first.src.fu <= (OTHERS => '0');
		first.src.buff <= (OTHERS => '0');
		first.dest.fu <= (OTHERS => '0');
		first.dest.buff <= (OTHERS => '0');
		
		wait for clk_period;
		assert first.src.fu = third.src.fu report "src.fu not equal after conversion";
		assert first.src.buff = third.src.buff report "src.buff not equal after conversion";
		assert first.dest.fu = third.dest.fu report "dest.fu not equal after conversion";
		assert first.dest.fu = third.dest.fu report "dest.buff not equal after conversion";
		
		first.src.fu(0) <= '1';
		first.src.buff(0) <= '1';
		wait for clk_period;
		assert first.src.fu = third.src.fu report "src.fu not equal after conversion";
		assert first.src.buff = third.src.buff report "src.buff not equal after conversion";
		
		first.dest.fu(0) <= '1';
		first.dest.buff(0) <= '1';
		wait for clk_period;
		assert first.dest.fu = third.dest.fu report "dest.fu not equal after conversion";
		assert first.dest.buff = third.dest.buff report "dest.buff not equal after conversion";
		
		first.op <= IMMEDIATE;
		wait for clk_period;
		assert second.op = IMMEDIATE report "opcode not converted properly by to_instruction()";
		
		first.op <= BRANCH;
		wait for clk_period;
		assert second.op = IMMEDIATE report "opcode not converted properly by to_instruction()";
		
		
		wait;
	END PROCESS;
	
	clk_proc: PROCESS BEGIN
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
	END PROCESS;
END instruction_tb;
