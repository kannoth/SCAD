--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- All globally shared constants are defined in this package.                       +
--                                                                                  +
-- File : glbSharedTypes.vhd                                                        +
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.all;

package glbSharedTypes is

	constant   FU_ADDRESS_W    : integer   := 5;
	constant   FU_DATA_W       : integer   := 32;
	constant   FU_INPUT_W      : integer   := (2 ** FU_ADDRESS_W)-1;
	
	-- Memory element constants. If there are multiple memory elements, first $MEM_SELECT_BITLENGTH bits
	-- of $MEM_ADDR_LENGTH are used for memory unit selection.
	-- Every unit has $BANK_SIZE long,word addressable flat address space.
	-- At this stage, number of load and store units are the same.
	constant   MEM_WORD_LENGTH	   	: integer   := 32;	--Number of bytes in each word
	constant   MEM_NR_ELEMENTS	   	: integer   := 4;		--Number of load and store elements(for each)
	constant   MEM_BANK_SIZE	   	: integer   := 64;	--Memory size in 4-byte words
	constant   MEM_ADDR_LENGTH   		: integer   := integer(log2(REAL(MEM_NR_ELEMENTS * MEM_BANK_SIZE)));
	constant   MEM_SELECT_BITLENGTH 	: integer 	:= integer(log2(REAL(MEM_NR_ELEMENTS)));
	
	constant    FIFO_BUF_SIZE		: integer := 6;
	
	
	type ram_type is array (0 to MEM_BANK_SIZE - 1) of std_logic_vector (MEM_WORD_LENGTH - 1 downto 0);
	
	type sorterIOVector_t is record
			address 	: std_logic_vector(FU_ADDRESS_W  -1 	downto 0);
			data		: std_logic_vector(FU_DATA_W     -1 	downto 0);
			fifoIdx  	: std_logic;
	end record;
	
	type aluFUState_t is record
			in1_full  : std_logic;
			in1_empty : std_logic;
			in2_full	 : std_logic;
			in2_empty : std_logic;
			out_full  : std_logic;
			out_empty : std_logic;
	end record;
	
	type bitonStageBus_t is array (0 to FU_INPUT_W) of sorterIOVector_t;
	
end glbSharedTypes;



--package body glbSharedTypes is
--end glbSharedTypes;