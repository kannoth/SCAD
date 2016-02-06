library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.glbSharedTypes.ALL;
use work.fifo_pkg.ALL;
use work.alu_components.ALL;

entity fu_adder is

    Port ( 		clk	 		: in std_logic;
					rst			: in std_logic;
					en 			: in std_logic;
					valid_inst 	: in std_logic;
					rw 			: in std_logic;
					inp 			: in sorterIOVector_t;
					outp			: out sorterIOVector_t;
					state			: out aluFUState_t;
					busy			: out std_logic
         );
end fu_adder;


architecture Structural of fu_adder is

type 	op_state_type is (read_input, write_output);
type	read_state_type is (issue_cmd, read_output, write_output);

signal inp1_rw, inp2_rw, outp_rw 				: std_logic;
signal inp1_en, inp2_en, outp_en 				: std_logic;
signal outp_din 										: signed(inp.data'range);
signal inp1_din, inp2_din 							: std_logic_vector(inp.data'range);
signal inp1_full, inp2_full, outp_full 		: std_logic;
signal inp1_empty, inp2_empty, outp_empty 	: std_logic;
signal inp1_dout, inp2_dout, outp_dout 		: std_logic_vector(inp.data'range);

signal reg_outp_en 		: std_logic;
signal reg_outp_rw 		: std_logic;
signal reg_inp1_rw 		: std_logic;
signal reg_inp2_rw 		: std_logic;
signal reg_inp1_en 		: std_logic;
signal reg_inp2_en 		: std_logic;
signal read_busy			: std_logic;
signal write_busy			: std_logic;

signal reg_outp			: sorterIOVector_t;

signal op_state 			: op_state_type;
signal write_state		: read_state_type;


begin
inp_1 : fifo_alu 
	port map (
		clk 		=> clk,
		rst 		=> rst,
		rw  		=> inp1_rw,
		en  		=> inp1_en,
		data_in 	=> inp1_din,
		full 		=> inp1_full,
		empty 	=> inp1_empty,
		data_out => inp1_dout );

inp_2 : fifo_alu 
	port map (
		clk 		=> clk,
		rst 		=> rst,
		rw  		=> inp2_rw,
		en  		=> inp2_en,
		data_in 	=> inp2_din,
		full 		=> inp2_full,
		empty 	=> inp2_empty,
		data_out => inp2_dout );
		
outp_1 : fifo_alu 
	port map (
		clk 		=> clk,
		rst 		=> rst,
		rw  		=> outp_rw,
		en  		=> outp_en,
		data_in 	=> std_logic_vector(outp_din),
		full 		=> outp_full,
		empty 	=> outp_empty,
		data_out => outp_dout );

alu_adder : adder
	port map (
		op1 		=> signed(inp1_dout),
		op2 		=> signed(inp2_dout),
		res 		=> outp_din );
		
inp1_rw 	<= rw when en = '1' else reg_inp1_rw;
inp1_en 	<= en and (not inp.fifoIdx) when en = '1' else reg_inp2_en;

inp2_rw 	<= rw when en = '1' else reg_inp2_rw;
inp2_en 	<= en and inp.fifoIdx when en = '1' else reg_inp1_en;

outp_en 	<= '1' when (en = '1' and rw = '0') else reg_outp_en;
outp_rw 	<= '0' when (en = '1' and rw = '0') else reg_outp_rw;

state		<=(in1_full => inp1_full, in1_empty => inp1_empty,in2_full => inp2_full, in2_empty => inp2_empty, out_full => outp_full, out_empty => outp_empty) ;


inp1_din	<= inp.data;
inp2_din <= inp.data;

busy		<= read_busy or write_busy;

outp		<= reg_outp;

read_proc:process(clk)
begin
	if rising_edge(clk) then
		if rst = '1' then
			write_state		<= issue_cmd;
			read_busy		<= '0';
			reg_outp			<= (address => (others => 'X'), data => (others => 'X'), fifoIdx => 'X');
		else
			case write_state is 
				when issue_cmd	=>
					reg_outp				<= reg_outp;
					if en = '1' and rw = '0' then
						read_busy		<= '1';
						write_state		<= read_output;
					else
						read_busy		<= '0';
						write_state		<= issue_cmd;
					end if;
				when read_output	=>	--Output is being written by output functional unit
					read_busy			<= '1';
					write_state			<= write_output;
					reg_outp				<= reg_outp;
				when write_output	=>
					read_busy			<= '0';
					reg_outp				<= (address => inp.address, data => outp_dout, fifoIdx => inp.fifoIdx);
					write_state			<= issue_cmd;
			end case;
		end if;
	end if;
end process;

write_proc:process(clk)
begin
	if rising_edge(clk) then
		if rst = '1' then
			write_busy 	<= '0';
			op_state 	<= read_input;
			reg_inp1_rw <= '0';
			reg_inp2_rw <= '0';
			reg_outp_rw <= '0';
			reg_outp_en <= '0';
			reg_inp1_en <= '0';
			reg_inp2_en <= '0';
		else 
			case op_state is
				when read_input	=> 
					if valid_inst = '1' then
						write_busy			<= '1';
						reg_inp1_rw 	<= '0';
						reg_inp2_rw 	<= '0';
						reg_outp_rw		<= '0';
						reg_outp_en 	<= '0';
						reg_inp1_en 	<= '1';
						reg_inp2_en 	<= '1';
						op_state 		<= write_output;
					else
						write_busy			<= '0';
						reg_inp1_rw 	<= '0';
						reg_inp2_rw 	<= '0';
						reg_outp_rw		<= '0';
						reg_outp_en 	<= '0';
						reg_inp1_en 	<= '0';
						reg_inp2_en 	<= '0';
						op_state 		<= read_input;
					end if;	
				when write_output =>
						write_busy			<= '1';
						reg_inp1_rw 	<= '0';
						reg_inp2_rw 	<= '0';
						reg_outp_rw		<= '1';
						reg_outp_en 	<= '1';
						reg_inp1_en 	<= '0';
						reg_inp2_en 	<= '0';
						op_state 		<= read_input;
			end case;
		end if;
	end if;
end process;


end Structural;

