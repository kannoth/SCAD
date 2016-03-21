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
		clk:IN STD_LOGIC;
		reset:IN STD_LOGIC;
		valid_IF:IN STD_LOGIC;
		stall: IN STD_LOGIC
	);
END ctrl_move_instr;

ARCHITECTURE behaviour OF ctrl_move_instr IS
	TYPE state_set IS (IDLE,COMMIT_CU,FDBCK_FU,CHECK_FU);
	SIGNAL mov_instr_reg: move_instruction;
	SIGNAL pr_state,nx_state:state_set;
BEGIN	
	mov_instr_reg <= to_move_instruction(instruction_input);
	process(clk,reset,nx_state)
	begin
	   if(rising_edge(clk))then
	   end if;
	   if(reset = '1') then
	       pr_state <= IDLE;	       	      	           
	   else
	       pr_state <= nx_state; 
	   end if;	   
	end process;
	process(clk,pr_state,mov_instr_reg,stall)		
	begin
	   if(rising_edge(clk))then -- positive edge
	       if(stall = '1')then -- stall raised
	           nx_state <= CHECK_FU;
	           ctrl_mib.phase <= CHECK;
               ctrl_mib.valid <= '0';	           
	       elsif(pr_state = IDLE )then -- idle
	           -- idle state
	           if(valid_IF = '1')then
					nx_state <= CHECK_FU;
			   end if;
	           ctrl_mib <= ctrl_mib_INIT;	           
	       elsif(pr_state = CHECK_FU)then -- CHECK_FU
	           -- new instruction
	           nx_state <= FDBCK_FU;
	           ctrl_mib.phase	  <= CHECK;
               ctrl_mib.valid 	  <= '1';
               ctrl_mib.src.fu 	  <= mov_instr_reg.src.fu;
               ctrl_mib.src.buff  <= mov_instr_reg.src.buff;
               ctrl_mib.dest.fu   <= mov_instr_reg.dest.fu;
               ctrl_mib.dest.buff <= mov_instr_reg.dest.buff;
	       elsif(pr_state = FDBCK_FU)then 
	           nx_state <= COMMIT_CU;
	           ctrl_mib.phase	  <= CHECK;
               ctrl_mib.valid 	  <= '0';
               ctrl_mib.src.fu 	  <= mov_instr_reg.src.fu;
               ctrl_mib.src.buff  <= mov_instr_reg.src.buff;
               ctrl_mib.dest.fu   <= mov_instr_reg.dest.fu;
               ctrl_mib.dest.buff <= mov_instr_reg.dest.buff;
	       elsif(pr_state = COMMIT_CU) then
	           ctrl_mib.phase	  <= CHECK;
               ctrl_mib.valid 	  <= '1';
               ctrl_mib.src.fu 	  <= mov_instr_reg.src.fu;
               ctrl_mib.src.buff  <= mov_instr_reg.src.buff;
               ctrl_mib.dest.fu   <= mov_instr_reg.dest.fu;
               ctrl_mib.dest.buff <= mov_instr_reg.dest.buff;
			   nx_state <= IDLE;
           end if;		   
	   end if;   
	end process;
END behaviour;

