LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;
USE work.instruction.ALL;


ENTITY ctrl_pc_tb IS
END ctrl_pc_tb;

ARCHITECTURE ctrl_pc_tb OF ctrl_pc_tb IS
	SIGNAL clk: STD_LOGIC;
	SIGNAL reset: STD_LOGIC;
	SIGNAL stall: STD_LOGIC;
	SIGNAL taken: STD_LOGIC;
	SIGNAL branch_offset: data_word;
	SIGNAL pc: data_word;
	
	constant clk_period : time := 10 ns;
BEGIN
	uut: ENTITY work.ctrl_pc PORT MAP(clk, reset, stall, taken, branch_offset, pc);
	
	test: PROCESS BEGIN
		-- precondition
		stall <= '1';
		taken <= '0';
		
		-- do a reset
		wait for clk_period;
		reset <= '1';
		wait for clk_period;
		reset <= '0';
		assert pc = X"00000000" report "reset failed - pc != 0";
		
		-- regular stepwise increasing PC
		wait for clk_period;
		stall <= '0';
		wait for clk_period;
		assert pc = X"00000001" report "inc failed";
		wait for clk_period;
		assert pc = X"00000002" report "inc 2nd time failed";
		stall <= '1';
		
		-- preparing a branch
		wait for clk_period;
		stall <= '0';
		branch_offset <= std_logic_vector(to_unsigned(5, branch_offset'LENGTH));
		--branch_offset <= X"00000005";
		taken <= '0';
		wait for clk_period;
		-- not branching yet
		assert pc = std_logic_vector(to_unsigned(3, pc'LENGTH))
			report "non-branch failed";
		
		-- now branch
		stall <= '0';
		taken <= '1';
		wait for clk_period;
		assert pc = X"00000008" report "branch failed";
		
		taken <= '0';
		wait for clk_period;
		assert pc = X"00000009" report "post-branch non-branch failed";
		
		
		wait;
	END PROCESS;
	
	clk_proc: PROCESS BEGIN
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
	END PROCESS;
END ctrl_pc_tb;

