LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;
USE work.instruction.ALL;


ENTITY ctrl_pc IS
	PORT(
		clk: IN STD_LOGIC;
		reset: IN STD_LOGIC;
		
		active: IN STD_LOGIC;
		
		-- input that tells the pc whether a branch was taken.
		taken: IN STD_LOGIC;
		
		branch_offset: IN data_word;
		
		pc: OUT data_word
	);
END ctrl_pc;

ARCHITECTURE ctrl_pc OF ctrl_pc IS
BEGIN
	
	adder: PROCESS ( clk )
		VARIABLE pc_var, offset: data_word;
	BEGIN
		IF rising_edge(clk) THEN
			
			IF reset = '1' THEN
				pc_var := X"00000000";
			ELSE
				offset := (others => '0');
				IF NOT active = '1' THEN
					IF taken = '1' THEN
						offset := branch_offset;
					ELSE
						offset := X"00000001";
					END IF;
				END IF;
				pc_var := pc_var + offset;
			END IF;
			
			pc <= pc_var;
		END IF;
	END PROCESS;
END ctrl_pc;

