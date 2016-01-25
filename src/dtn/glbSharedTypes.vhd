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

	constant   FU_ADDRESS_W    : integer   := 6;
	constant   FU_DATA_W       : integer   := 5;
	constant   FU_FIFO_IDX_W   : integer   := 1; 
	constant   FU_INPUT_W      : integer   := (2 ** FU_DATA_W)-1;
	
	type sorterIOVector_t is record
		vld		: std_logic;												-- Validity assertion register bits
		address	: std_logic_vector(FU_ADDRESS_W  -1 downto 0);	-- FU address 
		data		: std_logic_vector(FU_DATA_W     -1 downto 0);	-- data to be routed
		fifoIdx	: std_logic_vector(FU_FIFO_IDX_W -1 downto 0);	-- Input fifo index
	end record;
	
	-- IO wires for the network
	type bitonStageBus_t is array (0 to FU_INPUT_W) of sorterIOVector_t;
	-- Invalid address table
	type invAddArr_t is array ( 0 to FU_INPUT_W) of std_logic_vector (FU_ADDRESS_W-1 downto 0);
	constant InvAddr : invAddArr_t := (	"100000","100001","100010","100011","100100","100101","100110","100111",
													"101000","101001","101010","101011","101100","101101","101110","101111",
													"110000","110001","110010","110011","110100","110101","110110","110111",
													"111000","111001","111010","111011","111100","111101","111110","111111");
end glbSharedTypes;



--package body glbSharedTypes is
--end glbSharedTypes;
