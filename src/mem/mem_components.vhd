library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.common.ALL;

package mem_components is 

component load is
    Port ( 	clk  		: in std_logic;
			busy  		: in std_logic;		--busy signal from memory unit
			valid  		: in std_logic;		--valid signal from FU structure or fifo_input
			addr 		: in  std_logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
			data_in 	: in  std_logic_vector (MEM_WORD_LENGTH-1 downto 0);
			data_out 	: out  std_logic_vector (MEM_WORD_LENGTH-1 downto 0));
end component;

component bank_controller is
    Port ( 	clk  		: in std_logic;
			rst			: in std_logic;
			re  		: in std_logic;		
			we  		: in std_logic;		
			r_addr 		: in  std_logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
			w_addr 		: in  std_logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
			re_out  	: out std_logic;		
			we_out  	: out std_logic;
			busy		: out std_logic );
end component;

component ram is
    Port ( 	clk  : in std_logic;
			rst	 : in std_logic;
			re	 : in std_logic;
			we	 : in std_logic;
			r_addr : in  std_logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
			w_addr : in  std_logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
			data_in : in  std_logic_vector (MEM_WORD_LENGTH-1 downto 0);
			r_ack 	: out std_logic;
			w_ack  	: out std_logic;
			data_out : out  std_logic_vector (MEM_WORD_LENGTH-1 downto 0));
end component;


end mem_components;