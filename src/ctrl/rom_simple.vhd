LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;
USE work.instruction.ALL;


ENTITY rom_simple IS
	PORT (
		clk: IN STD_LOGIC;
		address: IN data_word;
		read: IN STD_LOGIC;
		instr: OUT instruction
		);
END rom_simple;

ARCHITECTURE rom_simple OF rom_simple IS
signal reg_output : instruction;

-- TODO: the functional unit addresses are strictly imaginary
--       and only for demonstration for now
CONSTANT content: instruction_array(0 TO 16) := (
	-- Insert a faux instruction to first index
	0 => to_instruction(MOVE, 0,0 , 1,0),
	1 => to_instruction(IMMEDIATE, 512),
	-- move(src.fu, src.buff, dest.fu, dest.buff)
	2 => to_instruction(MOVE, 0,0 , 1,0), -- immediate to load.0
	
	3 => to_instruction(IMMEDIATE, 8),
	4 => to_instruction(MOVE, 0,0 , 1,1), -- immediate to load.0
	
--	4 => to_instruction(IMMEDIATE, 3),
--	5 => to_instruction(MOVE, 0,0 , 2,0), -- immediate to store.0
--	
--	6 => to_instruction(MOVE, 1,0 , 3,0), -- load.0 to cmp.0
--	7 => to_instruction(MOVE, 1,0 , 3,1), -- load.0 to cmp.1
--	
--	8 => to_instruction(MOVE, 3,0 , 0,0), -- cmp.0 to ctrl.branch
--	
--	9 => to_instruction(BRANCH, 12), -- cmp.0 to ctrl.branch
--	
--	10 => to_instruction(IMMEDIATE, 27),
--	11 => to_instruction(JUMP, 13),
	
	--4 => to_instruction(IMMEDIATE, 16),
	5	=> to_instruction(MOVE, 2,0 , 28,0), -- immediate to store.1
	
	6	=> to_instruction(MOVE, 1,0 , 28,1), -- immediate to store.1
	
	OTHERS => to_instruction(JUMP, 0)
	);
BEGIN

	instr <= content(to_integer(unsigned(address)));
--	proc: PROCESS(clk)
--		
--	BEGIN
--		IF rising_edge(clk) THEN
--			IF read = '1' THEN
--				reg_output <= content(to_integer(unsigned(address)));
--			ELSE
--				reg_output <= to_instruction(JUMP, 0);
--			END IF;
--		END IF;
--	END PROCESS;
--	
--	instr <= reg_output;
END rom_simple;
