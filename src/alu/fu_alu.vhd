library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;
use work.buf_pkg.ALL;
use work.alu_components.ALL;

entity fu_alu is
	 Generic ( 	fu_addr 		: address_fu := (others => '0');
					fu_type		: fu_alu_type := ADD );

    Port ( 		clk	 		: in std_logic;
					rst			: in std_logic;
					-- signals from MIB
					mib_inp 		: in mib_ctrl_out;
					-- signals to MIB
					status		: out mib_stalls;
					--signals from DTN
					ack			: in data_port_receiving;
					dtn_data_in	: in data_port_sending;
					--signals to DTN
					dtn_data_out: out data_port_sending
         );
end fu_alu;


architecture Structural of fu_alu is


signal inp_stall	: std_logic := '0';
signal outp_stall	: std_logic := '0';
signal mib_fu_to_buf1_addr 	: std_logic_vector(FU_ADDRESS_W-1 downto 0);
signal mib_fu_to_buf2_addr 	: std_logic_vector(FU_ADDRESS_W-1 downto 0);
signal dtn_fu_to_buf1_addr 	: std_logic_vector(FU_ADDRESS_W-1 downto 0);
signal dtn_fu_to_buf2_addr 	: std_logic_vector(FU_ADDRESS_W-1 downto 0);
signal dtn_fu_to_buf1_valid: std_logic := '0';
signal dtn_fu_to_buf2_valid: std_logic := '0';
signal mib_fu_to_buf1_en	: std_logic := '0';
signal mib_fu_to_buf2_en	: std_logic := '0';
signal fu_to_buf1_read		: std_logic := '0';
signal fu_to_buf2_read		: std_logic := '0';

signal buf1_available		: std_logic;
signal buf2_available		: std_logic;
signal buf1_full				: std_logic;
signal buf2_full				: std_logic;
signal buf1_empty				: std_logic;
signal buf2_empty				: std_logic;
signal buf1_dout				: std_logic_vector(FU_DATA_W-1 downto 0);
signal buf2_dout				: std_logic_vector(FU_DATA_W-1 downto 0);
signal buf_out_rw				: std_logic := '0';
signal buf_out_en				: std_logic := '0';

signal outp_din				: std_logic_vector(FU_DATA_W-1 downto 0);
signal buf_outp_full			: std_logic;
signal buf_outp_empty		: std_logic;
signal outp_dout				: std_logic_vector(FU_DATA_W-1 downto 0);

signal available				: std_logic;
signal alu_enable				: std_logic := '0';
signal alu_valid				: std_logic;
signal reg_dout				: data_port_sending;
signal alu_busy				: std_logic;

begin
inp_1 : fu_input_buffer 
	port map (
		clk 			=> clk,
		rst 			=> rst,
		mib_addr		=> mib_fu_to_buf1_addr,
		mib_en		=> mib_fu_to_buf1_en,
		dtn_valid	=> dtn_fu_to_buf1_valid,
		dtn_data		=> dtn_data_in.message.data,
		dtn_addr		=> dtn_fu_to_buf1_addr,
		fu_read		=> fu_to_buf1_read,
		available	=> buf1_available,
		full			=> buf1_full,
		empty			=> buf1_empty,
		data_out		=> buf1_dout
);

inp_2 : fu_input_buffer 
	port map (
		clk 			=> clk,
		rst 			=> rst,
		mib_addr		=> mib_fu_to_buf2_addr,
		mib_en		=> mib_fu_to_buf2_en,
		dtn_valid	=> dtn_fu_to_buf2_valid,
		dtn_data		=> dtn_data_in.message.data,
		dtn_addr		=> dtn_fu_to_buf2_addr,
		fu_read		=> fu_to_buf2_read,
		available	=> buf2_available,
		full			=> buf2_full,
		empty			=> buf2_empty,
		data_out		=> buf2_dout
);
		
outp_1 : fifo_alu 
	port map (
		clk 		=> clk,
		rst 		=> rst,
		rw  		=> buf_out_rw,
		en  		=> buf_out_en,
		data_in 	=> std_logic_vector(outp_din),
		full 		=> buf_outp_full,
		empty 	=> buf_outp_empty,
		data_out => outp_dout );

 
alu_instance : alu
		generic map ( op_type => fu_type)
		port map (
		clk 		=> clk,
		op1 		=> buf1_dout,
		op2 		=> buf2_dout,
		en			=> alu_enable,
		busy		=> alu_busy,
		valid		=> alu_valid,
		res 		=> outp_din 
);


		
mib_fu_to_buf1_addr <= mib_inp.src.fu ;
mib_fu_to_buf2_addr <= mib_inp.src.fu ;

status.src_stalled  <= inp_stall;
status.dest_stalled <= outp_stall;

dtn_fu_to_buf1_addr <= dtn_data_in.message.src.fu when dtn_data_in.valid = '1' else (others => 'X');
dtn_fu_to_buf2_addr <= dtn_data_in.message.src.fu when dtn_data_in.valid = '1' else (others => 'X');

dtn_data_out			<= reg_dout;

--TODO: Handle the case where HEAD of inputs get available when output buffer is full
available <= buf1_available and buf2_available;
fu_to_buf1_read <= available and not alu_busy;
fu_to_buf2_read <= available and not alu_busy;

process(clk)
variable mib_valid : std_logic;
variable idx	: std_logic;
variable phase	: mib_phase;

begin
	if rising_edge(clk) then
		if rst = '1' then
			mib_valid := '0';
			idx	:= '0';
			phase	:= CHECK;
		else
			dtn_fu_to_buf1_valid <= dtn_data_in.valid;
			dtn_fu_to_buf2_valid <= dtn_data_in.valid;
			mib_valid := mib_inp.valid;
			phase := mib_inp.phase;
			idx	:= mib_inp.dest.buff;
			if mib_valid = '1' then
				if phase = COMMIT then
					if fu_addr = mib_inp.src.fu then --we are source
						--assemble output packet and send
						reg_dout.message.src.fu <= fu_addr;
						reg_dout.message.src.buff <= 'X';
						reg_dout.message.dest <= mib_inp.dest;
						reg_dout.message.data <= outp_dout;
						reg_dout.valid <= '1';
						mib_fu_to_buf1_en <= '0';
						mib_fu_to_buf2_en <= '0';
						buf_out_en <= '1';
						buf_out_rw <= '0';
					else
						reg_dout.valid <= '0';
						if idx = '0' then
							mib_fu_to_buf1_en <= '1';
							mib_fu_to_buf2_en <= '0';
						else
							mib_fu_to_buf1_en <= '0';
							mib_fu_to_buf2_en <= '1';
						end if;
					end if;
				else
					mib_fu_to_buf1_en <= '0';
					mib_fu_to_buf2_en <= '0';
					inp_stall 		<= buf1_full or buf2_full;
					outp_stall 		<= buf_outp_full or buf_outp_empty;
				end if;
			else
				if alu_valid = '1' then
					buf_out_en <= '1';
					buf_out_rw <= '1';
				else
					buf_out_en <= '0';
				end if;
				
				if available = '1' and alu_busy = '0' then
					alu_enable <= '1';
				else
					alu_enable <= '0';
				end if;
				
				mib_fu_to_buf1_en <= '0';
				mib_fu_to_buf2_en <= '0';					
			end if;
		end if;
	end if;
end process;




end Structural;

