library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.glbSharedTypes.ALL;

--Add FIFO component declarations here

package fifo_pkg is 

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

end fifo_pkg;
