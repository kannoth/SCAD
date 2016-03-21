LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


LIBRARY work;
USE work.common.ALL;
USE work.instruction.ALL;


ENTITY ctrl_instruction_fetch IS
	PORT(
		-- Instruction To Sub Components
		instr_to_sub_comp: OUT instruction;
		-- memory interface for instruction fetch
		instr_from_mem:IN instruction;
		read_en:OUT STD_LOGIC;
		mem_addr:OUT data_word;
		mem_data_valid:IN STD_LOGIC;
		-- PC Interface for instruction address
		pc_addr:IN data_word;		
		-- Global Stall 
		stall: IN STD_LOGIC;
		clk:IN STD_LOGIC;
		reset:IN STD_LOGIC;
	);
END ctrl_instruction_fetch;

ARCHITECTURE ctrl_instruction_fetch OF ctrl_instruction_fetch IS
	SIGNAL pc_addr_reg:data_word;
	SIGNAL change : STD_LOGIC;
BEGIN		
	change <= '0' when(pc_addr_reg = pc_addr) else '1'; 
	process(clk,reset,pc_addr)
	begin
		if(rising_edge(clk))then
			if(stall /= '1')then
				if chage = '1' then
					-- Instruction fetch from mem
					read_en <= '1';
					mem_addr <= pc_addr;
					pc_addr_reg <= pc_addr;
				elsif mem_data_valid = '1' then
					-- Instruction to CU subcomponents
					instr_to_sub_comp <= instr_from_mem;
				end if;
			end if;	
		end if;
	end process;
	
END ctrl_instruction_fetch;

