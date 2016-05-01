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
		fu_stalls: IN mib_status_bus;
		-- DTN
		dtn_data_in	: in data_port_sending;
		dtn_data_out: out data_port_sending;
		
		clk:IN STD_LOGIC;
		reset:IN STD_LOGIC		
	);
END ctrl;

ARCHITECTURE ctrl OF ctrl IS
	SIGNAL current_instr:instruction;	
	SIGNAL pc_out: data_word;
	SIGNAL taken_wire:STD_LOGIC;
	SIGNAL branch_offset_wire:data_word;
	SIGNAL valid_IF_gen:STD_LOGIC;	
	SIGNAL reg_active : STD_LOGIC;

	
	COMPONENT ctrl_pc is
		PORT(
		clk: IN STD_LOGIC;
		reset: IN STD_LOGIC;		
		active: IN STD_LOGIC;		
		-- input that tells the pc whether a branch was taken.
		taken: IN STD_LOGIC;		
		branch_offset: IN data_word;		
		pc: OUT data_word);
	END COMPONENT;	
	
	COMPONENT ctrl_instruction_fetch IS
	PORT(
		read_en:OUT STD_LOGIC;
		mem_addr:OUT data_word;
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
		active : out std_logic;
		clk:IN STD_LOGIC;
		reset:IN STD_LOGIC;
		valid_IF:IN STD_LOGIC;
		dtn_data_in	: in data_port_sending;
		dtn_data_out: out data_port_sending;
		stall: IN mib_status_bus);
	END COMPONENT;
	
BEGIN

		pc : ctrl_pc PORT MAP (clk => clk, reset => reset, active => reg_active, taken => taken_wire, branch_offset => branch_offset_wire,pc => pc_out);
	
		instr_fetch: ctrl_instruction_fetch PORT MAP(read_en => read_en_wire ,mem_addr => mem_addr_wire,pc_addr => pc_out,stall => reg_active,clk => clk,reset => reset);
		
		to_mib : ctrl_move_instr PORT MAP (instruction_input => mem_instr, ctrl_mib => mib_out, clk => clk, reset => reset, stall => fu_stalls, active => reg_active,  
		valid_IF => mem_data_valid, dtn_data_out => dtn_data_out, dtn_data_in => dtn_data_in);
    
		
		

END ctrl;
