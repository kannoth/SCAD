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
	SIGNAL stall: STD_LOGIC;
	SIGNAL taken: STD_LOGIC;
	SIGNAL branch_offset: STD_LOGIC;
	SIGNAL pc: STD_LOGIC;
BEGIN
	dut: ENTITY ctrl_pc PORT MAP(clk, stall, taken, branch_offset, pc);
END ctrl_pc_tb;
