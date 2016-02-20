library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;
use work.fifo_pkg.ALL;
use work.alu_components.ALL;

entity fu_adder is

    Port ( 		clk	 		: in std_logic;
					rst			: in std_logic;
					-- signals from MIB
					mib_inp 		: in mib_ctrl_out;
					-- signals to MIB
					status		: out mib_stalls;
					--signals from DTN
					ack			: in data_port_receiving;
					dtn_data_in	: out data_port_sending
					--signals to DTN
					dtn_data_out: out data_port_sending
         );
end fu_adder;


architecture Structural of fu_adder is

type 	op_state_type is (read_input, write_output);
type	read_state_type is (issue_cmd, read_output, write_output);

signal operand_available	: std_logic := '0';
signal inp_full	: std_logic := '0';
signal outp_full	: std_logic := '0';
signal outp_empty	: std_logic := '1';
signal mib_fu_to_buf_addr 	: std_logic_vector(FU_ADDRESS_W-1 downto 0);
signal dtn_fu_to_buf_data 	: std_logic_vector(FU_DATA_W-1 downto 0);
signal dtn_fu_to_buf_addr 	: std_logic_vector(FU_ADDRESS_W-1 downto 0);
signal mib_fu1_to_buf_en	: std_logic;
signal mib_fu2_to_buf_en	: std_logic;
signal fu_to_buf1_read		: std_logic;
signal fu_to_buf2_read		: std_logic;

signal buf1_available		: std_logic;
signal buf2_available		: std_logic;
signal buf1_full				: std_logic;
signal buf2_full				: std_logic;
signal buf1_empty				: std_logic;
signal buf2_empty				: std_logic;
signal buf1_dout				: std_logic_vector(FU_DATA_W-1 downto 0);
signal buf2_dout				: std_logic_vector(FU_DATA_W-1 downto 0);
signal buf_out_rw				: std_logic;
signal buf_out_en				: std_logic;

signal outp_din				: signed(FU_DATA_W-1 downto 0);
signal outp_full				: std_logic;
signal outp_empty				: std_logic;
signal outp_dout				: signed(FU_DATA_W-1 downto 0);

begin
inp_1 : fu_input_buffer 
	port map (
		clk 		=> clk,
		rst 		=> rst,
		mib_addr	=> mib_fu_to_buf_addr;
		mib_en	=> mib_fu1_to_buf_en;
		dtn_data	=> dtn_fu_to_buf_data;
		dtn_addr	=> dtn_fu_to_buf_addr;
		fu_read	=> fu_to_buf1_read;
		available	=> buf1_available;
		full		=> buf1_full;
		empty		=> buf1_empty;
		data_out	=> buf1_dout
);

inp_2 : fu_input_buffer 
	port map (
		clk 		=> clk,
		rst 		=> rst,
		mib_addr	=> mib_fu_to_buf_addr;
		mib_en	=> mib_fu2_to_buf_en;
		dtn_data	=> dtn_fu_to_buf_data;
		dtn_addr	=> dtn_fu_to_buf_addr;
		fu_read	=> fu_to_buf2_read;
		available	=> buf2_available;
		full		=> buf2_full;
		empty		=> buf2_empty;
		data_out	=> buf2_dout
);
		
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
		op1 		=> signed(buf1_dout),
		op2 		=> signed(buf2_dout),
		res 		=> outp_din );
		



end Structural;

