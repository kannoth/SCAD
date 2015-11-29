
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity fifo_input is

	Generic (
			DATA_WIDTH	: natural := 32;
			BUF_SIZE	: natural := 6
			);
			
    Port (	clk			: in STD_LOGIC;			
			rst			: in STD_LOGIC;									
			read_data 	: in STD_LOGIC;	
			write_data	: in STD_LOGIC;
			data_in		: in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			
			full		: out STD_LOGIC;
			empty		: out STD_LOGIC;
			data_out	: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
           );										
end fifo_input;


architecture Behavioral of fifo_input is

type 	write_fsm_type is (reset,wait_cmd,write_buffer,inc);
type 	read_fsm_type is (reset,wait_cmd,read_buffer,dec);
type 	fifo_buffer_type is array (0 to BUF_SIZE-1) of STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);	

signal 	fifo_buffer : fifo_buffer_type;													
signal	ps_write,ns_write : write_fsm_type;
signal	ps_read,ns_read : read_fsm_type;

signal 	head : natural range 0 to BUF_SIZE - 1 ;									
signal 	tail : natural range 0 to BUF_SIZE - 1 ;							


signal 	write_flag : std_logic ;
signal 	data_available : std_logic ;

begin

full <= not write_flag;
empty <= not data_available;

sequential_proc: process(rst,clk)
begin
	if rising_edge(clk) then
		if rst = '1' then
			ps_write <= reset;
			ps_read  <= reset ;
		else
			ps_write <= ns_write;
			ps_read	 <= ns_write;
		end if;
	end if;
end process;



read_process: process(ps_read,read_data)									
begin
case ps_read is
	when reset => 
		head <= 0;
		ns_write <= wait_cmd;
	when wait_cmd =>
		if read_data = '1' then
			if data_available = '1' then
				ns_read => read_buffer;
			else
				ns_read => wait_cmd;
			end if;
		else
			ns_read => wait_cmd;
		end if;
	when read_buffer =>
		data_out <= fifo_buffer(head);
		ns_read <= dec;
	when dec =>
		head <= head + 1;
		ns_read <= wait_cmd;
	end case;
end process;



write_process: process(ps_write,write_data)
begin
case ps_write is
	when reset =>
		tail <= 0;
		data_available <= '0';
		write_flag <= '1';
		ns_write => wait_cmd;
	when wait_cmd =>
		if write_data = '1' then
			if write_flag then 
				ns_write => write_buffer;
			else
				ns_write => wait_cmd;
			end if;
		else
			ns_write <= wait_cmd;
		end if;
	when write_buffer =>
		data_available <= '1';
		fifo_buffer(tail) <= data_in;
		ns_write <= inc;
	when inc =>
		tail <= tail + 1;
		if tail = head then
			write_flag <= '0';
		else
			write_flag <= '1';
		end if;
		ns_write <= wait_cmd;
	end case;
			
		
end process;

end Behavioral;

