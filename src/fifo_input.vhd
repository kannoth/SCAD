
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


type 	fifo_buffer_type is array (0 to BUF_SIZE-1) of STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);	
signal 	fifo_buffer : fifo_buffer_type;													

signal 	head : natural range 0 to BUF_SIZE - 1 ;									
signal 	tail : natural range 0 to BUF_SIZE - 1 ;							

signal 	reg_empty : std_logic := '1';
signal 	reg_full : std_logic := '0' ;


begin

full <= sig_full;
empty <= sig_empty;



read_process: process(clk,rst)									
begin
end process;



write_process: process(clk,rst)
begin
end process;

end Behavioral;

