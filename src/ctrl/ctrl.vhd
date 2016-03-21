LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


LIBRARY work;
USE work.common.ALL;
USE work.instruction.ALL;
USE work.ctrl_move_instr.ALL;
USE work.ctrl_pc.ALL;
USE work.ctrl_immediate.ALL;

ENTITY ctrl IS
	PORT(
		-- data network: output connection
		--data_out: OUT data_port_sending;
		--data_out_feedback: IN data_port_receiving;
		-- data network: input connection
		--data_in: IN data_port_sending;
		--data_in_feedback: OUT data_port_receiving;
		
		-- move instruction bus
		mib_out: OUT mib_ctrl_out;
		mib_stalls: IN mib_stalls
		clk:IN STD_LOGIC;
		reset:IN STD_LOGIC;
		-- memory interface for instruction fetch
		-- TODO
	);
END ctrl;

ARCHITECTURE ctrl OF ctrl IS
	--SIGNAL current_instruction: instruction;
	--SIGNAL stall_branch,
	--       stall_immediate,
	--       stall_move_instr,
	--       is_stalled: STD_LOGIC;
	SIGNAL pc_out: data_word;
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
		-- PC Interface for instruction address
		pc_addr:IN data_word;		
		-- Global Stall 
		stall: IN STD_LOGIC;
		clk:IN STD_LOGIC;
		reset:IN STD_LOGIC;
	);
	END COMPONENT;
	COMPONENT ctrl_move_instr IS
	PORT(
		-- Instruction input
		instruction_input: IN instruction;
		ctrl_mib: OUT mib_ctrl_out;
		clk:IN STD_LOGIC;
		reset:IN STD_LOGIC;
		valid_IF:IN STD_LOGIC;
		stall: IN STD_LOGIC
	);
	END COMPONENT;
BEGIN
	ctrl_pc PORT MAP (
		clk => clk,
		reset => reset,
		stall => OPEN,		
		taken => --from branch
		branch_offset => -- from branch
		pc => pc_out);
	
	ctrl_instruction_fetch PORT MAP(
		-- Instruction To Sub Components
		instr_to_sub_comp: OUT instruction;
		-- memory interface for instruction fetch
		instr_from_mem:IN instruction;
		read_en:OUT STD_LOGIC;
		mem_addr:OUT data_word;
		mem_data_valid:IN STD_LOGIC;		
		pc_addr => pc_out,
		stall => stall,-- TODO change to gstall
		clk => clk,
		reset => reset);
	--branch: COMPONENT work.ctrl_branch
	--	PORT MAP (
	--		instruction => current_instruction,
	--		stall => stall_branch);
	--
	--is_stalled <= stall_branch or
	--              stall_immediate or
	--              stall_move_instr;
	--
END ctrl;
