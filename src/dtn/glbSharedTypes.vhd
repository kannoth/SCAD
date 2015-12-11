--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- All globally shared constants are defined in this package.                       +
--                                                                                  +
-- File : glbSharedTypes.vhd                                                        +
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

package glbSharedTypes is

	constant   FU_ADDRESS_W    : integer   := 5;
	constant   FU_DATA_W       : integer   := 5;
	constant   FU_FIFO_IDX_W   : integer   := 1; 
	constant   FU_INPUT_W      : integer   := (2 ** FU_ADDRESS_W)-1;
	
	type sorterIOVector_t is record
			address 	: std_logic_vector(FU_ADDRESS_W  -1 	downto 0);
			data		: std_logic_vector(FU_DATA_W     -1 	downto 0);
			fifoIdx  : std_logic_vector(FU_FIFO_IDX_W -1 	downto 0);
	end record;
	
	type bitonStageBus_t is array (0 to FU_INPUT_W) of sorterIOVector_t;
	
end glbSharedTypes;



--package body glbSharedTypes is
--end glbSharedTypes;