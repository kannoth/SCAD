
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.glbSharedTypes.ALL;


entity fifo_alu is

    Port (	clk			: in STD_LOGIC;			
			rst			: in STD_LOGIC;									
			rw 			: in STD_LOGIC;	
			en 			: in STD_LOGIC;	
			data_in		: in STD_LOGIC_VECTOR(FU_DATA_W-1 downto 0);
			
			full		: out STD_LOGIC;
			empty		: out STD_LOGIC;
			data_out	: out STD_LOGIC_VECTOR(FU_DATA_W-1 downto 0)
           );										
end fifo_alu;


architecture Behavioral of fifo_alu is

type 	fifo_buffer_type is array (0 to FIFO_BUF_SIZE-1) of STD_LOGIC_VECTOR (FU_DATA_W-1 downto 0);	

signal 	fifo_buffer : fifo_buffer_type := (others => (others => '0'));													



signal 	head : natural range 0 to FIFO_BUF_SIZE - 1 ;									
signal 	tail : natural range 0 to FIFO_BUF_SIZE - 1 ;							
signal 	num_elements : natural range 0 to FIFO_BUF_SIZE ;	

signal 	reg_full : std_logic ;
signal 	reg_empty : std_logic ;

signal 	reg_dout  : std_logic_vector(data_out'range);

begin


full 			<= reg_full;
empty 		<= reg_empty;
data_out		<= reg_dout;

sequential_proc: process(clk)
begin
	if rising_edge(clk) then
		if rst = '1' then
			head 				<= 0;
			tail 				<= 0;
			reg_full 		<= '0';
			reg_empty 		<= '1';
			num_elements 	<= 0;
			reg_dout			<= (others => 'X');
		else
			if en = '1' then	
				if rw = '0' then
					if reg_empty = '0' then
						reg_dout <= fifo_buffer(head);
						num_elements <= num_elements - 1;
						if num_elements /= 0 then
							if head /= FIFO_BUF_SIZE -1 then
								head <= head + 1 ;
							else
								head <= 0;
							end if;
							reg_empty <= '0';
						else
							reg_empty <= '1';
						end if;
						reg_full <= '0';
					else
						num_elements <= num_elements;
					end if;
				else
					if reg_full = '0' then 
						fifo_buffer(tail) <= data_in;
						num_elements <= num_elements + 1;
						if num_elements = FIFO_BUF_SIZE then
							reg_full <= '1';
						else
							reg_full <= '0';
						end if;
						
						if tail /= FIFO_BUF_SIZE -1 then
							tail <= tail + 1 ;
						else
							tail <= 0;
						end if;
						reg_empty <= '0';
					else
						fifo_buffer(tail) <= fifo_buffer(tail);
						num_elements <= num_elements;
					end if;
				end if;
			else
				null;
			end if;
		end if;
	end if;
end process;




end Behavioral;

