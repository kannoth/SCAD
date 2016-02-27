library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;
use work.buf_pkg.ALL;
use work.mem_components.ALL;

entity fu_store is
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
					--Data forwarding can be implemented through this signal later on
					--dtn_data_out: out data_port_sending;
					--signals to/from memory unit
					mem_ack		: in std_logic;
					data		: out std_Logic_vector (MEM_WORD_LENGTH-1 downto 0);
					addr		: out std_Logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
					we			: out std_logic
         );
end fu_store;


architecture Structural of fu_store is


signal mib_fu_to_buf1_addr 	: std_logic_vector(FU_ADDRESS_W-1 downto 0);
signal mib_fu_to_buf2_addr 	: std_logic_vector(FU_ADDRESS_W-1 downto 0);
signal dtn_fu_to_buf1_addr 	: std_logic_vector(FU_ADDRESS_W-1 downto 0);
signal dtn_fu_to_buf2_addr 	: std_logic_vector(FU_ADDRESS_W-1 downto 0);
signal mib_fu_to_buf1_en	: std_logic := '0';
signal mib_fu_to_buf2_en	: std_logic := '0';
signal dtn_fu_to_buf1_valid: std_logic := '0';
signal dtn_fu_to_buf2_valid: std_logic := '0';
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


signal available				: std_logic;
signal mem_enable				: std_logic;
signal mem_valid				: std_logic;
signal reg_dout					: data_port_sending;
signal mem_busy					: std_logic;

begin
--for holding the address
inp_1 : fu_input_buffer 
	port map (
		clk 			=> clk,
		rst 			=> rst,
		mib_addr		=> mib_fu_to_buf1_addr,
		mib_en			=> mib_fu_to_buf1_en,
		dtn_valid	=> dtn_fu_to_buf1_valid,
		dtn_data		=> dtn_data_in.message.data,
		dtn_addr		=> dtn_fu_to_buf1_addr,
		fu_read			=> fu_to_buf1_read,
		available		=> buf1_available,
		full			=> buf1_full,
		empty			=> buf1_empty,
		data_out		=> buf1_dout
);
--for holding the data
inp_2 : fu_input_buffer 
	port map (
		clk 			=> clk,
		rst 			=> rst,
		mib_addr		=> mib_fu_to_buf2_addr,
		mib_en			=> mib_fu_to_buf2_en,
		dtn_valid	=> dtn_fu_to_buf2_valid,
		dtn_data		=> dtn_data_in.message.data,
		dtn_addr		=> dtn_fu_to_buf2_addr,
		fu_read			=> fu_to_buf2_read,
		available		=> buf2_available,
		full			=> buf2_full,
		empty			=> buf2_empty,
		data_out		=> buf2_dout
);

		
store_component : store
	port map (
		clk 		=> clk,
		en			=> mem_enable,
		fu_data		=> buf1_dout,
		fu_addr		=> buf2_dout(addr'range),
		busy		=> mem_busy,
		valid		=> mem_valid,
		data		=> data,
		ack			=> mem_ack,
		addr		=> addr,
		we			=> we
);
		


		
mib_fu_to_buf1_addr <= mib_inp.src.fu ;
mib_fu_to_buf2_addr <= mib_inp.src.fu ;

status.src_stalled  <= buf1_full or buf2_full;
status.dest_stalled <= mem_busy or available or mem_enable;

dtn_fu_to_buf1_addr <= dtn_data_in.message.src.fu when dtn_data_in.valid = '1' else (others => 'X');
dtn_fu_to_buf2_addr <= dtn_data_in.message.src.fu when dtn_data_in.valid = '1' else (others => 'X');

available 		<= buf1_available and buf2_available;
fu_to_buf1_read <= available and not mem_busy;
fu_to_buf2_read <= available and not mem_busy;

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
			dtn_fu_to_buf1_valid <= dtn_data_in.valid;
			dtn_fu_to_buf2_valid <= dtn_data_in.valid;
			mib_valid := mib_inp.valid;
			phase := mib_inp.phase;
			idx	:= mib_inp.dest.buff;
			if mib_valid = '1' then
				if phase = COMMIT then
					if idx = '0' then
							mib_fu_to_buf1_en <= '1';
							mib_fu_to_buf2_en <= '0';
					else
							mib_fu_to_buf1_en <= '0';
							mib_fu_to_buf2_en <= '1';
					end if;
				else
					mib_fu_to_buf1_en <= '0';
					mib_fu_to_buf2_en <= '0';
				end if;
			else
				if available = '1' and mem_busy = '0' then
					mem_enable <= '1';
				else
					mem_enable <= '0';
				end if;
				mib_fu_to_buf1_en <= '0';
				mib_fu_to_buf2_en <= '0';					
			end if;
		end if;
	end if;
end process;




end Structural;

