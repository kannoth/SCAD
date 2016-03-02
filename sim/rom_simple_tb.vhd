LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;
USE work.instruction.ALL;


ENTITY rom_simple_tb IS
END rom_simple_tb;

ARCHITECTURE rom_simple_tb OF rom_simple_tb IS
	SIGNAL read: STD_LOGIC;
	SIGNAL address: data_word;
	SIGNAL instr: instruction;
	
	SIGNAL clk: STD_LOGIC;
	
	constant clk_period : time := 10 ns;
BEGIN
	uut: ENTITY work.rom_simple PORT MAP(clk, address, read, instr);
	
	test: PROCESS BEGIN
		read <= '0';
		wait for clk_period;
		
		read <= '1';
		address <= (OTHERS => '0');
		wait for clk_period;
		
		assert instr = to_instruction(IMMEDIATE, 1) report "fail";
		read <= '0';
		wait for clk_period;
		
		
		read <= '1';
		address <= (0 => '1', OTHERS => '0');
		wait for clk_period;
		read <= '0';
		wait for clk_period;
		
		read <= '1';
		address <= (0 => '0', 1 => '1', OTHERS => '0');
		wait for clk_period;
		read <= '0';
		wait for clk_period;
		
		read <= '1';
		address <= (0 => '1', 1 => '1', OTHERS => '0');
		wait for clk_period;
		read <= '0';
		wait for clk_period;
		
		wait;
	END PROCESS;
	
	clk_proc: PROCESS BEGIN
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
	END PROCESS;
END rom_simple_tb;
