library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.common.ALL;

package mem_components is 

component load is
    Port ( 	--signals to/from FU
			clk  		: in std_logic;
			en  		: in std_logic;	
			operand		: in std_Logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
			busy		: out std_logic;
			valid  		: out std_logic;		--valid signal from FU structure or fifo_input
			data_out 	: out  std_logic_vector (MEM_WORD_LENGTH-1 downto 0);
			--signals to/from memory unit
			data		: in std_Logic_vector (MEM_WORD_LENGTH-1 downto 0);
			ack			: in std_logic;
			addr		: out std_Logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
			re			: out std_logic
			);
end component;

component store is
	Port ( 	--signals to/from FU
			clk  		: in std_logic;
			en  		: in std_logic;	
			fu_data		: in std_Logic_vector (MEM_WORD_LENGTH-1 downto 0);
			fu_addr		: in std_Logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
			busy		: out std_logic;
			valid  		: out std_logic;		--valid signal from FU structure or fifo_input
			--signals to/from memory unit
			ack			: in std_logic;
			data		: out std_Logic_vector (MEM_WORD_LENGTH-1 downto 0);
			addr		: out std_Logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
			we			: out std_logic
			);
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
			re	 : in std_logic;
			we	 : in std_logic;
			r_addr : in  std_logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
			w_addr : in  std_logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
			data_in : in  std_logic_vector (MEM_WORD_LENGTH-1 downto 0);
			r_ack 	: out std_logic;
			w_ack  	: out std_logic;
			data_out : out  std_logic_vector (MEM_WORD_LENGTH-1 downto 0));
end component;

component fu_load is 
		Generic ( 		fu_addr 		: address_fu 	:= (others => '0') );

		Port ( 			
					clk	 		: in std_logic;
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
end component;

component fu_store is 

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
					--signals to/from memory unit
					mem_ack		: in std_logic;
					data		: out std_Logic_vector (MEM_WORD_LENGTH-1 downto 0);
					addr		: out std_Logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
					we			: out std_logic
         );
end component;


component memory_top is

Port (
		clk 		: in std_logic;
		rst 		: in std_logic;
		inp		: in mem_inp_port;
		outp		: out mem_out_port
	);
	
end component;


end mem_components;