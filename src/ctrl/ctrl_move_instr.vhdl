LIBRARY IEEE;
LIBRARY work;
USE IEEE.STD_LOGIC_1164.ALL;
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
		stall: IN STD_LOGIC
	);
END ctrl_move_instr;

ARCHITECTURE behaviour OF ctrl_move_instr IS
	TYPE state_set IS (IDLE,COMMIT_CU,FDBCK_FU,CHECK_FU);
	SIGNAL mov_instr_reg: move_instruction;
	signal reg_active : std_logic;
	SIGNAL state:state_set;
	SIGNAL reg_dtn_data_out : data_port_sending;
	SIGNAL reg_immediate : data_word;

	
		
BEGIN	

	mov_instr_reg 	<= to_move_instruction(instruction_input);
	active 			<= reg_active;
	dtn_data_out	<= reg_dtn_data_out;
	
		process(clk)
		begin
			if rising_edge(clk) then
				if reset = '1' then
					reg_dtn_data_out <= dtn_default;
					reg_immediate <= (others => '0');
				elsif mov_instr_reg.op = IMMEDIATE then
					reg_immediate			<= instruction_input.param;
					reg_dtn_data_out 		<= dtn_default;
				elsif mov_instr_reg.op = MOVE and mov_instr_reg.src.fu = (mov_instr_reg.src.fu'range => '0') 
				and state = COMMIT_CU then
					reg_dtn_data_out.message.src.fu 		<= (others => '0');
					reg_dtn_data_out.message.src.buff 	<= 'X';
					reg_dtn_data_out.message.dest 		<= mov_instr_reg.dest;
					reg_dtn_data_out.message.data			 		<= reg_immediate;
					reg_dtn_data_out.valid <= '1';
				else
					reg_dtn_data_out <= dtn_default;
					reg_immediate <= reg_immediate;
				end if;
					--Assemble a DTN packet with data as immediate
			end if;	
		end process;
		
		
	process(clk)
	variable op : opcode;
	begin
		if(rising_edge(clk))then
			op := mov_instr_reg.op;
			if(reset = '1') then
				state 		<= IDLE;
				reg_active 	<= '0';
				op 			:= MOVE;
			elsif stall = '1' then
				state 				<= CHECK_FU;
				ctrl_mib.phase 	<= CHECK;
				ctrl_mib.valid 	<= '0';
				reg_active 			<= '1';
--			elsif op = IMMEDIATE then
--				state 				<= state;
--				reg_active 			<= '0';
			else
				case state is
					when IDLE =>
						--if(valid_IF = '1')then
						if op /= IMMEDIATE then
							state <= CHECK_FU;
							reg_active <= '1';
						else
							state <= IDLE;
							reg_active <= '0';
						end if;
						ctrl_mib <= ctrl_mib_INIT;
					when COMMIT_CU =>
						reg_active 			<= '0';
						ctrl_mib.phase	  <= COMMIT;
						ctrl_mib.valid 	  <= '1';
						ctrl_mib.src.fu 	  <= mov_instr_reg.src.fu;
						ctrl_mib.src.buff  <= mov_instr_reg.src.buff;
						ctrl_mib.dest.fu   <= mov_instr_reg.dest.fu;
						ctrl_mib.dest.buff <= mov_instr_reg.dest.buff;
						state <= IDLE;
					when FDBCK_FU =>
						reg_active 		<= '1';
						state <= COMMIT_CU;
						ctrl_mib.phase	  <= CHECK;
						ctrl_mib.valid 	  <= '0';
						ctrl_mib.src.fu 	  <= mov_instr_reg.src.fu;
						ctrl_mib.src.buff  <= mov_instr_reg.src.buff;
						ctrl_mib.dest.fu   <= mov_instr_reg.dest.fu;
						ctrl_mib.dest.buff <= mov_instr_reg.dest.buff;
					when CHECK_FU =>
						reg_active 		<= '1';
						state <= FDBCK_FU;
						ctrl_mib.phase	  <= CHECK;
						ctrl_mib.valid 	  <= '1';
						ctrl_mib.src.fu 	  <= mov_instr_reg.src.fu;
						ctrl_mib.src.buff  <= mov_instr_reg.src.buff;
						ctrl_mib.dest.fu   <= mov_instr_reg.dest.fu;
						ctrl_mib.dest.buff <= mov_instr_reg.dest.buff;
				end case;
			end if;
		end if;
	end process;
END behaviour;

