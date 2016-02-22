library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.common.ALL;

--Add FIFO component declarations here

package buf_pkg is 

component fifo_alu is
             
    	Port (     	clk                     : in STD_LOGIC;                 
                        rst                     : in STD_LOGIC;                                                                 	     
								rw                      : in STD_LOGIC; 
                        en                      : in STD_LOGIC; 
                        data_in        		 : in STD_LOGIC_VECTOR(FU_DATA_W-1 downto 0);
                        full           		 : out STD_LOGIC;
                        empty           	 : out STD_LOGIC;
                        data_out        	 : out STD_LOGIC_VECTOR(FU_DATA_W-1 downto 0)
           );                                                                           
end component;

component fu_input_buffer is

    Port (	clk			: in STD_LOGIC;			
			rst			: in STD_LOGIC;	
			--- Signals from MIB
			mib_addr	: in STD_LOGIC_VECTOR(FU_ADDRESS_W-1 downto 0);
			mib_en		: in STD_LOGIC;
			--- Signals from DTN
			dtn_data	: in STD_LOGIC_VECTOR(FU_DATA_W-1 downto 0);
			dtn_addr	: in STD_LOGIC_VECTOR(FU_ADDRESS_W-1 downto 0);
			--- Signals from FU 
			fu_read		: in std_logic;
			--- Signals to FU
			available	: out STD_LOGIC;
			full		: out STD_LOGIC;
			empty		: out STD_LOGIC;
			data_out	: out STD_LOGIC_VECTOR(FU_DATA_W-1 downto 0)
           );										
end component;

end buf_pkg;
