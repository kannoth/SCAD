LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


LIBRARY work;
USE work.common.ALL;
USE work.instruction.ALL;


ENTITY ctrl_instruction_fetch IS
	PORT(
		read_en:OUT STD_LOGIC;
		mem_addr:OUT data_word;
		-- PC Interface for instruction address
		pc_addr:IN data_word;		
		-- Global Stall 
		stall: IN STD_LOGIC;
		clk:IN STD_LOGIC;
		reset:IN STD_LOGIC
	);
END ctrl_instruction_fetch;

ARCHITECTURE ctrl_instruction_fetch OF ctrl_instruction_fetch IS
	SIGNAL pc_addr_reg:data_word;
	signal read_reg : std_logic;
	SIGNAL change : STD_LOGIC;
BEGIN		
	change <= '0' when(pc_addr_reg = pc_addr) else '1';
	read_en <= read_reg;
	process(clk)
	begin
		if(rising_edge(clk))then
			if reset = '1' then
				pc_addr_reg <= (others => '0');
				read_reg		<= '0';
			elsif(stall /= '1')then
					if change = '1' then
						-- Instruction fetch from mem
						read_reg <= '1';
						mem_addr <= pc_addr;
						pc_addr_reg <= pc_addr;									
					end if;
			end if;	
		end if;
	end process;
	
END ctrl_instruction_fetch;

