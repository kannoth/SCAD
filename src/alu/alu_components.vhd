library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.glbSharedTypes.ALL;

package alu_components is 

component adder is
    Port ( op1 : in  signed (FU_DATA_W-1 downto 0);
           op2 : in  signed (FU_DATA_W-1 downto 0);
           res : out  signed (FU_DATA_W-1 downto 0));
end component;

component subtractor is
    Port ( op1 : in  signed (FU_DATA_W-1 downto 0);
           op2 : in  signed (FU_DATA_W-1 downto 0);
           res : out  signed (FU_DATA_W-1 downto 0));
end component;

component multiplier is
  Port (
    a : in std_logic_vector(8 downto 0);
    b : in std_logic_vector(8 downto 0);
    p : out std_logic_vector(17 downto 0)
  );
end component;
  
component fu_adder is
    Port ( 		clk	 		: in std_logic;
				rst			: in std_logic;
				en 			: in std_logic;
				valid_inst 	: in std_logic;
				rw 			: in std_logic;
				inp 		: in sorterIOVector_t
         );
end component;

end alu_components;