
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
			rw 			: in STD_LOGIC;	
			en 			: in STD_LOGIC;	
			data_in		: in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			
			full		: out STD_LOGIC;
			empty		: out STD_LOGIC;
			data_out	: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
           );										
end fifo_input;


architecture Behavioral of fifo_input is

type 	fsm_type is (reset,wait_cmd,write_buffer,read_buffer);
type 	fifo_buffer_type is array (0 to BUF_SIZE-1) of STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);	

signal 	fifo_buffer : fifo_buffer_type;													
signal	ps,ns : fsm_type;




signal 	reg_full : std_logic ;
signal 	reg_empty : std_logic ;

begin

full 	<= reg_full;
empty <= reg_empty;

sequential_proc: process(clk)
begin
	if rising_edge(clk) then
		if rst = '1' then
			ps <= reset;
		else
			ps <= ns;
		end if;
	end if;
end process;



comb_process: process(ps,rw,en)	

variable 	head : natural range 0 to BUF_SIZE - 1 ;									
variable 	tail : natural range 0 to BUF_SIZE - 1 ;							
variable 	num_elements : natural range 0 to BUF_SIZE ;				
begin
case ps is
	when reset => 
		head := 0;
		tail := 0;
		reg_full <= '0';
		reg_empty <= '1';
		num_elements := 0;
		if en = '1' then 
			ns <= wait_cmd;
		else
			ns <= reset;
		end if;
	when wait_cmd =>
		if en = '1' then	
			if rw = '0' then
				if reg_empty = '0' then
					data_out <= fifo_buffer(head);
					num_elements := num_elements - 1;
				else
					data_out <= (others => 'Z');
					num_elements := num_elements;
				end if;
				ns <= read_buffer;
			else
				if reg_full = '0' then 
					fifo_buffer(tail) <= data_in;
					num_elements := num_elements + 1;
				else
					fifo_buffer(tail) <= fifo_buffer(tail);
					num_elements := num_elements;
				end if;
				data_out <= (others => 'Z');
				ns <= write_buffer;
			end if;
		else
			data_out <= (others => 'Z');
			ns <= wait_cmd;
		end if;
	when read_buffer =>
		if num_elements /= 0 then
			head := head + 1; 
			reg_empty <= '0';
		else
			reg_empty <= '1';
			head := head;
		end if;
		tail := tail;
		reg_full <= '0';
		ns <= wait_cmd;
		
	when write_buffer => 
		if num_elements = BUF_SIZE then
			reg_full <= '1';
			tail:= tail;
		else
			tail := tail + 1;
			reg_full <= '0';
		end if;
		reg_empty <= '0';
		head := head;
		ns <= wait_cmd;
	end case;
	
end process;


end Behavioral;

