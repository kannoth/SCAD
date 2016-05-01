library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;
use work.buf_pkg.ALL;
use work.mem_components.ALL;


--Load functional unit. Component has connections to DTN, MIB and memory bank controller for memory accesses.
--Unlike the rest, this FU has only one input buffer to store the address to be accessed. Whenever address(transferred via DTN) is available-
--,load unit performs memory access,reads the value and copies it into the output buffer,which then can be transferred over DTN to any other FU.
--During memory operation, output_stall of status signal is asserted to prevent memory access conflicts. Order of accesses depends on reservation order
--on input buffer. 
entity fu_load is
	Generic ( 		fu_addr 		: address_fu 	:= (others => '0') );

    Port ( 			clk	 		: in std_logic;
					rst			: in std_logic;
					-- signals from MIB
					mib_inp 	: in mib_ctrl_out;
					-- signals to MIB
					status		: out mib_stalls;
					--signals from DTN
					ack			: in data_port_receiving;
					dtn_data_in	: in data_port_sending;
					--signals to DTN
					dtn_data_out: out data_port_sending;
					--signals to/from memory unit
					data		: in std_Logic_vector (MEM_WORD_LENGTH-1 downto 0);
					mem_ack	: in std_logic;
					addr		: out std_Logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
					re			: out std_logic
         );
end fu_load;


architecture Structural of fu_load is


signal mib_fu_to_buf_addr 	: std_logic_vector(FU_ADDRESS_W-1 downto 0);
signal dtn_fu_to_buf_addr 	: std_logic_vector(FU_ADDRESS_W-1 downto 0);
signal dtn_fu_to_buf_valid: std_logic := '0';
signal mib_fu_to_buf_en	: std_logic := '0';
signal fu_to_buf_read		: std_logic := '0';

signal buf_available			: std_logic;
signal buf_full					: std_logic;
signal buf_empty				: std_logic;
signal buf_dout					: std_logic_vector(FU_DATA_W-1 downto 0);
signal buf_out_rw				: std_logic := '0';
signal buf_out_en				: std_logic := '0';

signal load_out					: std_logic_vector(MEM_WORD_LENGTH-1 downto 0);
signal buf_outp_full			: std_logic;
signal buf_outp_empty			: std_logic;
signal outp_dout				: std_logic_vector(FU_DATA_W-1 downto 0);

signal mem_enable				: std_logic;
signal mem_valid				: std_logic;
signal reg_dout					: data_port_sending;
signal mem_busy					: std_logic;

begin
inp : fu_input_buffer 
	port map (
		clk 			=> clk,
		rst 			=> rst,
		mib_addr		=> mib_fu_to_buf_addr,
		mib_en			=> mib_fu_to_buf_en,
		dtn_valid	=> dtn_fu_to_buf_valid,
		dtn_data		=> dtn_data_in.message.data,
		dtn_addr		=> dtn_fu_to_buf_addr,
		fu_read			=> fu_to_buf_read,
		available		=> buf_available,
		full			=> buf_full,
		empty			=> buf_empty,
		data_out		=> buf_dout
);

		
outp_1 : fifo_alu 
	port map (
		clk 		=> clk,
		rst 		=> rst,
		rw  		=> buf_out_rw,
		en  		=> buf_out_en,
		data_in 	=> load_out,
		full 		=> buf_outp_full,
		empty 		=> buf_outp_empty,
		data_out 	=> outp_dout );
		
load_component : load
	port map (
		clk 		=> clk,
		en			=> mem_enable,
		operand		=> buf_dout(MEM_BANK_ADDR_LENGTH-1 downto 0),
		busy		=> mem_busy,
		valid		=> mem_valid,
		data_out	=> load_out,
		data		=> data,
		ack			=> mem_ack,
		addr		=> addr,
		re			=> re
	);
		


		
mib_fu_to_buf_addr 	<= mib_inp.src.fu ;

status.src_stalled  <= buf_full;
--status.dest_stalled <= buf_outp_full or buf_outp_empty or mem_busy or buf_available or mem_enable ;
status.dest_stalled <= buf_outp_full or mem_busy or buf_available or mem_enable ;

dtn_fu_to_buf_addr 	<= dtn_data_in.message.src.fu when dtn_data_in.valid = '1' else (others => 'X');

dtn_data_out		<= reg_dout;

--TODO: Handle the case where HEAD of input get available when output buffer is full
fu_to_buf_read 		<= buf_available and not mem_busy;

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
			mem_enable <= '0';
		else
			dtn_fu_to_buf_valid <= dtn_data_in.valid;
			mib_valid := mib_inp.valid;
			phase := mib_inp.phase;
			idx	:= mib_inp.dest.buff;
			if mib_valid = '1' then
				reg_dout.valid <= '0';
				if phase = COMMIT then
					if fu_addr = mib_inp.src.fu then --we are source
						--assemble output packet and send
						reg_dout.message.src.fu <= fu_addr;
						reg_dout.message.src.buff <= 'X';
						reg_dout.message.dest <= mib_inp.dest;
						reg_dout.message.data <= outp_dout;
						reg_dout.valid <= '1';
						mib_fu_to_buf_en <= '0';
						buf_out_en <= '1';
						buf_out_rw <= '0';
					else
						mib_fu_to_buf_en <= '1';
					end if;
				else
					mib_fu_to_buf_en <= '0';
				end if;
			else
				if mem_valid = '1' then
					buf_out_en <= '1';
					buf_out_rw <= '1';
				else
					buf_out_en <= '0';
				end if;
				
				if buf_available = '1' and mem_busy = '0' then
					mem_enable <= '1';
				else
					mem_enable <= '0';
				end if;
				mib_fu_to_buf_en <= '0';					
			end if;
		end if;
	end if;
end process;




end Structural;

