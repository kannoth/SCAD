
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;

-- Input buffer for functional units (FU).
-- This component is instantiated inside FU and snoops DTN. A place is reserved with address mib_addr when mib_en is '1'.
-- If DTN has valid data and its source address (routed from FU) matches with any of the reserved addresses inside buffer, then corresponding buffer entry is marked
-- as 'ready'. When head of the buffer has both address and data(when ready bit is set for head), available signal is asserted for FU to read the data.
-- Data is held at the output until FU reads the data by asserting 'fu_read' signal. A common agreement between buffer and FU is FU asserts
-- fu_read iff available bit is '1'. 

-- For searching addresses inside buffer, a look-up table is used. It contains #MAX_FUS pairs of 'found,idx'; where index to the LUT determines FU address, found 
-- specifies if it is reserved in buffer and idx stores adress' index in buffer in case it is found. For example, if a MIB packet with source address 15 arrives when
-- buffer is empty, 14th entry of lut is set to (found = '1',idx = 0x0).

-- Every entry in the buffer consists of (ready, address, data); where ready is asserted when both address and data is available. Following the previous MIB example,
-- if a DTN packet arrives with source 15, since a reservation has been made from MIB for address 15, entry in the head of buffer will look like 
-- (ready = '1', addr = 15, data = others => ('X')). Besides, since head of the buffer contains a stable packet, available signal is set to 1, until functional unit reads
-- performs read.
entity fu_input_buffer is

    Port (	clk			: in STD_LOGIC;			
			rst			: in STD_LOGIC;	
			--- Signals from MIB
			mib_addr	: in STD_LOGIC_VECTOR(FU_ADDRESS_W-1 downto 0);		-- Source address field of MIB bus
			mib_en		: in STD_LOGIC;										-- Enable strobe from functional unit
			--- Signals from DTN
			dtn_valid: in std_logic;										-- Directly from DTN bus
			dtn_data	: in STD_LOGIC_VECTOR(FU_DATA_W-1 downto 0);
			dtn_addr	: in STD_LOGIC_VECTOR(FU_ADDRESS_W-1 downto 0);		-- Source address field of DTN bus, routed by FU
			--- Signals from FU 
			fu_read		: in std_logic;										-- Read signal from FU, is only set by FU when available is '1'
			--- Signals to FU
			available	: out STD_LOGIC;									-- Available signal to FU, de-asserted when data at the head is read
			full		: out STD_LOGIC;
			empty		: out STD_LOGIC;
			data_out	: out STD_LOGIC_VECTOR(FU_DATA_W-1 downto 0)
           );										
end fu_input_buffer;


architecture Behavioral of fu_input_buffer is

type buffer_entry is record
	ready: std_logic;
	data : std_logic_vector(FU_DATA_W-1 downto 0);
	addr : std_logic_vector(FU_ADDRESS_W-1 downto 0);
end record;

type lut_entry is record
	found 	: std_logic;
	idx		: natural range 0 to BUF_SIZE - 1;
end record;



type 	buffer_type is array (0 to BUF_SIZE-1) of buffer_entry;
type 	lut_type is array (0 to MAX_FUS-1) of lut_entry;

signal 	buf : buffer_type := (others => (ready => '0', data => (others => 'X'), addr => (others => '0')));													
signal  	lut : lut_type 	:= (others => (found => '0', idx => 0 ));


signal 	head : natural range 0 to BUF_SIZE - 1 ;									
signal 	tail : natural range 0 to BUF_SIZE - 1 ;							
signal 	num_elements : natural range 0 to BUF_SIZE ;	

signal 	reg_full : std_logic ;
signal 	reg_empty : std_logic ;
signal 	reg_available : std_logic;

signal 	reg_dout  : std_logic_vector(data_out'range);


begin

full 			<= reg_full;
empty 		<= reg_empty;
data_out		<= reg_dout;
available	<= reg_available;

process(clk)
variable index : natural range 0 to BUF_SIZE - 1 := 0;
variable data_addr : std_logic_vector(FU_ADDRESS_W-1 downto 0);
variable tmp_entry : lut_entry;
variable nxt		: natural range 0 to BUF_SIZE - 1 := 0;
variable shared_address : std_logic := '0';
begin
	if rising_edge(clk) then
		if rst = '1' then
			head 					<= 0;
			tail 					<= 0;
			reg_full 			<= '0';
			reg_empty 			<= '1';
			num_elements 		<= 0;
			reg_available		<= '0';
			shared_address		:= '0';
			reg_dout				<= (others => 'X');
			index					:= 0;
			data_addr			:= (others => 'X');
			buf					<= (others => (ready => '0', data => (others => 'X'), addr => (others => '0')));	
			lut					<= (others => (found => '0', idx => 0 ));
		else
			-- This nested check is performed for cases where both MIB and DTN has packets for this buffer
			if mib_en = '1' then
				if dtn_valid = '1' then
						shared_address := '1';
						tmp_entry := lut(to_integer(unsigned(dtn_addr)));
						index 	 := tmp_entry.idx;
						--Check if MIB and DTN addresses are equal
						if mib_addr = dtn_addr then
							buf(tail).data		<= dtn_data;
							if tail = head then
								reg_available <= '1';
							end if;
						--If not equal,modify corresponding buf and lut entries
						else
							if tmp_entry.found = '1' and buf(index).ready = '0' then
								buf(index).data	<= dtn_data;
								buf(index).ready 	<= '1';
								if index = head then
									reg_available <= '1';
								end if;
							end if;
						end if;
					else
						shared_address := '0';
					end if;
				
				--If there is only MIB packet, reserve it if buffer is not full
				if reg_full = '0' then 
						buf(tail).addr 	<= mib_addr;
						if shared_address = '1' then
							buf(tail).ready 	<= '1';
						else
							buf(tail).ready 	<= '0';
						end if;
						lut(to_integer(unsigned(mib_addr))).found 	<= '1';
						lut(to_integer(unsigned(mib_addr))).idx 		<= tail;
						num_elements <= num_elements + 1;
						if num_elements = BUF_SIZE - 1 then
							reg_full <= '1';
						else
							reg_full <= '0';
						end if;
						
						if tail /= BUF_SIZE -1 then
							tail <= tail + 1 ;
						else
							tail <= 0;
						end if;
						reg_empty <= '0';
					else
						buf(tail).addr 	<= buf(tail).addr;
						num_elements 	<= num_elements;
					end if;
			else		--Reads and writes(either from MIB or DTN, or both) cannot occur in same cycle
						--In that sense writes have priority
				if fu_read = '1' then	--FU asserts enable iff available signal is 1
					data_addr		:= buf(head).addr;
					reg_dout 		<= buf(head).data;
					num_elements 	<= num_elements - 1;
					lut(to_integer(unsigned(data_addr))).found 	<= '0';
					buf(head).ready <= '0';
					
					-- signal nxt is used for handling overflows for head counter
					if num_elements /= 0 then
						if head /= BUF_SIZE -1 then
							head <= head + 1 ;
							nxt := head + 1;
						else
							nxt := 0;
							head <= 0;
						end if;
					end if;
					
					if num_elements = 1 then
						reg_empty <= '1';
					else
						reg_empty <= '0';
					end if;
					
					if buf(nxt).ready = '1' then
						reg_available <= '1';
					else
						reg_available <= '0';
					end if;
					reg_full <= '0';
				else	--Actual snooping
					reg_dout <= reg_dout;
					tmp_entry := lut(to_integer(unsigned(dtn_addr)));
					index 	 := tmp_entry.idx;
					if tmp_entry.found = '1' and buf(index).ready = '0' and dtn_valid = '1' then
						buf(index).data	<= dtn_data;
						buf(index).ready 	<= '1';
						if index = head then
							reg_available <= '1';
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
end process;




end Behavioral;

