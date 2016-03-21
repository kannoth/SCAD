LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


LIBRARY work;
USE work.common.ALL;
USE work.instruction.ALL;
USE work.ctrl_move_instr;
USE work.ctrl_pc;
USE work.ctrl_instruction_fetch;
USE work.gen_OR;
ENTITY ctrl IS
	PORT(
		mem_instr:IN instruction;
		read_en_wire:OUT STD_LOGIC;
		mem_addr_wire:OUT data_word;
		mem_data_valid:IN STD_LOGIC;
		-- move instruction bus
		mib_out: OUT mib_ctrl_out;
		fu_stalls: IN mib_stalls;
		clk:IN STD_LOGIC;
		reset:IN STD_LOGIC		
	);
END ctrl;

ARCHITECTURE ctrl OF ctrl IS
	SIGNAL current_instr:instruction;	
	SIGNAL pc_out: data_word;
	SIGNAL gstall:STD_LOGIC;
	SIGNAL taken_wire:STD_LOGIC;
	SIGNAL branch_offset_wire:data_word;
	SIGNAL current_instr_internal_wire:instruction;
	SIGNAL valid_IF_gen:STD_LOGIC;	
	COMPONENT ctrl_pc is
		PORT(
		clk: IN STD_LOGIC;
		reset: IN STD_LOGIC;		
		stall: IN STD_LOGIC;		
		-- input that tells the pc whether a branch was taken.
		taken: IN STD_LOGIC;		
		branch_offset: IN data_word;		
		pc: OUT data_word);
	END COMPONENT;	
	
	COMPONENT ctrl_instruction_fetch IS
	PORT(
		-- Instruction To Sub Components
		instr_to_sub_comp: OUT instruction;
		-- memory interface for instruction fetch
		instr_from_mem:IN instruction;
		read_en:OUT STD_LOGIC;
		mem_addr:OUT data_word;
		mem_data_valid:IN STD_LOGIC;
		valid_IF:OUT STD_LOGIC;
		-- PC Interface for instruction address
		pc_addr:IN data_word;		
		-- Global Stall 
		stall: IN STD_LOGIC;
		clk:IN STD_LOGIC;
		reset:IN STD_LOGIC);
	END COMPONENT;
	
	COMPONENT ctrl_move_instr IS
	PORT(
		-- Instruction input
		instruction_input: IN instruction;
		ctrl_mib: OUT mib_ctrl_out;
		clk:IN STD_LOGIC;
		reset:IN STD_LOGIC;
		valid_IF:IN STD_LOGIC;
		stall: IN STD_LOGIC);
	END COMPONENT;
	
	COMPONENT gen_OR IS
	GENERIC (N: positive := 2*FU_DATA_W );
	PORT ( input: IN STD_LOGIC_VECTOR (N-1 downto 0);
            output:OUT STD_LOGIC
      );
	END COMPONENT;
BEGIN
	pc : ctrl_pc PORT MAP (clk => clk, reset => reset, stall => gstall, taken => taken_wire, branch_offset => branch_offset_wire,pc => pc_out);
	
    instr_fetch: ctrl_instruction_fetch PORT MAP(valid_IF => valid_IF_gen, instr_to_sub_comp => current_instr,instr_from_mem=>mem_instr, read_en => read_en_wire ,mem_addr => mem_addr_wire,mem_data_valid => mem_data_valid,pc_addr => pc_out,stall => gstall,clk => clk,reset => reset);
		
	to_mib : ctrl_move_instr PORT MAP (instruction_input => current_instr, ctrl_mib => mib_out, clk => clk, reset => reset, stall => gstall, valid_IF => valid_IF_gen);
    
    or_stalls: gen_OR PORT MAP (input => fu_stalls.src_stalled & fu_stalls.dest_stalled, output =>gstall);

END ctrl;
