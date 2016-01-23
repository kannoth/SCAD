library IEEE;
use IEEE.STD_LOGIC_1164.all;

--Add FIFO component declarations here

package fifo is 

component fifo_input is
	Generic (
                        DATA_WIDTH      : natural := 32;
                        BUF_SIZE        : natural := 6
                        );
                        
    	Port (     	clk                     : in STD_LOGIC;                 
                        rst                     : in STD_LOGIC;                                                                 	     
								rw                      : in STD_LOGIC; 
                        en                      : in STD_LOGIC; 
                        data_in        		 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
                        full           		 : out STD_LOGIC;
                        empty           	 : out STD_LOGIC;
                        data_out        	 : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
           );                                                                           
end component;

end fifo;
