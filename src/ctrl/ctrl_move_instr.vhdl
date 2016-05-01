LIBRARY IEEE;
LIBRARY work;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE work.common.ALL;
USE work.instruction.ALL;


ENTITY ctrl_move_instr IS
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
		stall: IN mib_status_bus
	);
END ctrl_move_instr;

ARCHITECTURE behaviour OF ctrl_move_instr IS
	TYPE state_set IS (IDLE, READ_OP, CHECK_IMM, COMMIT_CU,FDBCK_FU,CHECK_FU);
	SIGNAL mov_instr_reg: move_instruction;
	signal reg_active : std_logic;
	SIGNAL state:state_set;
	SIGNAL reg_dtn_data_out : data_port_sending;
	SIGNAL reg_immediate : data_word;
	signal instr_reg : move_instruction;

	
		
BEGIN	

	mov_instr_reg 	<= to_move_instruction(instruction_input);
	active 			<= reg_active;
	dtn_data_out	<= reg_dtn_data_out;

	process(clk)
	begin
		if(rising_edge(clk))then
			if(reset = '1') then
				state 		<= IDLE;
				reg_active 	<= '0';
				ctrl_mib.valid 	<= '0';
				reg_immediate <= (others => '0');
			else
				case state is
					when IDLE =>
						if(valid_IF = '1')then
							state <= READ_OP;
							reg_active <= '1';
						else
							state <= IDLE;
							reg_active <= '0';
						end if;
						ctrl_mib <= ctrl_mib_INIT;
					when READ_OP =>
						instr_reg <= mov_instr_reg;
						state <= CHECK_IMM;
						reg_active <= '1';
					when CHECK_IMM =>
						if instr_reg.op = IMMEDIATE then
							reg_immediate			<= instruction_input.param;
							reg_dtn_data_out 		<= dtn_default;
							state <= IDLE;
							reg_active <= '0';
						else
							state <= CHECK_FU;
							reg_active <= '1';
							reg_immediate <= reg_immediate;
						end if;
						
					when COMMIT_CU =>
						reg_active 			<= '0';
						ctrl_mib.phase	  <= COMMIT;
						ctrl_mib.valid 	  <= '1';
						ctrl_mib.src.fu 	  <= instr_reg.src.fu;
						ctrl_mib.src.buff  <= instr_reg.src.buff;
						ctrl_mib.dest.fu   <= instr_reg.dest.fu;
						ctrl_mib.dest.buff <= instr_reg.dest.buff;
						state <= IDLE;
						--if instr_reg.op = MOVE
						if instr_reg.src.fu = (mov_instr_reg.src.fu'range => '0') and instr_reg.op = MOVE then
							reg_dtn_data_out.message.src.fu 		<= (others => '0');
							reg_dtn_data_out.message.src.buff 	<= 'X';
							reg_dtn_data_out.message.dest 		<= instr_reg.dest;
							reg_dtn_data_out.message.data			<= reg_immediate;
							reg_dtn_data_out.valid <= '1';
						else
							reg_dtn_data_out <= dtn_default;
							reg_immediate <= reg_immediate;
						end if;
				
					when FDBCK_FU =>
						reg_active 		<= '1';
						state <= COMMIT_CU;
						ctrl_mib.phase	  <= CHECK;
						ctrl_mib.valid 	  <= '0';
						ctrl_mib.src.fu 	  <= instr_reg.src.fu;
						ctrl_mib.src.buff  <= instr_reg.src.buff;
						ctrl_mib.dest.fu   <= instr_reg.dest.fu;
						ctrl_mib.dest.buff <= instr_reg.dest.buff;
						reg_dtn_data_out <= dtn_default;
						reg_immediate <= reg_immediate;
						--case A: when a FU is used as a source but there is no data in its output buffer
						if  	stall(to_integer(unsigned(instr_reg.src.fu))).dest_stalled = '1' or 
								stall(to_integer(unsigned(instr_reg.dest.fu))).src_stalled = '1'
						then
							state <= CHECK_FU;
						--case B: when a FU is used as destination but there is no space in its buffer(s)
						end if;
					when CHECK_FU =>
						reg_active 		<= '1';
						state <= FDBCK_FU;
						ctrl_mib.phase	  <= CHECK;
						ctrl_mib.valid 	  <= '1';
						ctrl_mib.src.fu 	  <= instr_reg.src.fu;
						ctrl_mib.src.buff  <= instr_reg.src.buff;
						ctrl_mib.dest.fu   <= instr_reg.dest.fu;
						ctrl_mib.dest.buff <= instr_reg.dest.buff;
						reg_dtn_data_out <= dtn_default;
						reg_immediate <= reg_immediate;
				end case;
			end if;
		end if;
	end process;
END behaviour;

