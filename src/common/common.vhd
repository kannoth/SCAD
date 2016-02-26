library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.math_real.all;



-- TODO: Replace STD_LOGIC by something less prone to error/forgetting cases

PACKAGE common IS
-- BASICS ----------------------------------------------------------------------
	CONSTANT   	FU_ADDRESS_W    		: NATURAL   := 5;
	CONSTANT   	FU_DATA_W       		: NATURAL   := 32;
	CONSTANT   	FU_INPUT_W      		: NATURAL   := (2 ** FU_ADDRESS_W)-1;
	CONSTANT    FU_FIFO_IDX_W   		: NATURAL   := 1; 
	CONSTANT 	DATA_WIDTH				: NATURAL 	:= FU_DATA_W;
	
	-- Memory element CONSTANTs. If there are multiple memory elements, first $MEM_SELECT_BITLENGTH bits
	-- of $MEM_ADDR_LENGTH are used for memory unit selection.
	-- Every unit has $BANK_SIZE long,word addressable flat address space.
	-- At thIS stage, number of load and store units are the same.
	CONSTANT   	MEM_WORD_LENGTH	   		: NATURAL   := 32;	--Number of bytes in each word
	CONSTANT   	MEM_NR_ELEMENTS	   		: NATURAL   := 4;		--Number of load and store elements(for each)
	CONSTANT   	MEM_BANK_SIZE	   		: NATURAL   := 64;	--Memory size in 4-byte words
	CONSTANT   	MEM_ADDR_LENGTH   		: NATURAL   := NATURAL(log2(REAL(MEM_NR_ELEMENTS * MEM_BANK_SIZE)));
	CONSTANT   	MEM_SELECT_BITLENGTH 	: NATURAL 	:= NATURAL(log2(REAL(MEM_NR_ELEMENTS)));
	
	CONSTANT    BUF_SIZE			 	: NATURAL := 6;
	CONSTANT    FIFO_BUF_SIZE		: NATURAL := 6;
	
	CONSTANT	MAX_FUS					: NATURAL := 32;
	
	TYPE ram_TYPE IS ARRAY (0 TO MEM_BANK_SIZE - 1) OF STD_LOGIC_VECTOR (MEM_WORD_LENGTH - 1 downto 0);
	
	SUBTYPE data_word IS STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
	
	TYPE aluFUState_t IS RECORD
			in1_full  	: STD_LOGIC;
			in1_empty 	: STD_LOGIC;
			in2_full		: STD_LOGIC;
			in2_empty 	: STD_LOGIC;
			out_full  	: STD_LOGIC;
			out_empty 	: STD_LOGIC;
	END RECORD;
	
	type sorterIOVector_t is record
		vld			: std_logic;											-- Validity assertion register bits
		tarAddr		: std_logic_vector(FU_ADDRESS_W   downto 0);	-- target FU address ( The validity of address is encapsulated in the msb of the tarAddr (Active Low) VALD=0, INVD=1 )
		srcAddr		: std_logic_vector(FU_ADDRESS_W  -1 downto 0);	-- source FU address 
		data			: std_logic_vector(FU_DATA_W-1  downto 0);	-- data to be routed
		tarfifoIdx	: std_logic_vector(FU_FIFO_IDX_W-1  downto 0);	-- Input fifo index
		srcfifoIdx	: std_logic_vector(FU_FIFO_IDX_W-1  downto 0);	-- Input fifo index
	end record;
	
	-- IO wires for the network
	TYPE bitonStageBus_t is ARRAY (0 TO FU_INPUT_W) OF sorterIOVector_t;
	type validVector_t is array ( 0 to FU_INPUT_W ) of std_logic;
	type testVector_t is array ( 0 to FU_INPUT_W ) of integer range 0 to 31;
	-- Reset values for pipeline stage registers												
	constant pRegDefVal	: bitonStageBus_t := ( others => ('0',"000000","00000", "00000000000000000000000000000000","0","0"));
--	-- Invalid address table
	TYPE invAddArr_t IS ARRAY (0 TO FU_INPUT_W) OF std_logic_vector (FU_ADDRESS_W-1 DOWNTO 0);
	constant InvAddr : invAddArr_t := (	"00000","00001","00010","00011","00100","00101","00110","00111",
													"01000","01001","01010","01011","01100","01101","01110","01111",
													"10000","10001","10010","10011","10100","10101","10110","10111",
													"11000","11001","11010","11011","11100","11101","11110","11111");
--	-- Reset values for pipeline stage registers												
--	CONSTANT pRegDefVal	: bitonStageBus_t := ( others => ( '0',"000000", "00000","0"));
	
	-- instruction memory (i.e. pc) address width
	-- out of comission - pc IS just another data word
	--CONSTANT PC_WIDTH := FU_DATA_W;
	
	TYPE fu_alu_type IS (ADD, SUBTRACT, MULT);
	
	CONSTANT ADDRESS_FU_WIDTH: NATURAL := FU_ADDRESS_W;
	
	SUBTYPE address_fu IS STD_LOGIC_VECTOR((ADDRESS_FU_WIDTH - 1) downto 0);
	SUBTYPE buff_num IS STD_LOGIC;
	
	TYPE address_fu_buff IS RECORD
		fu: address_fu;
		buff: buff_num;
	END RECORD;
	
-- MOVE INSTRUCTION BUS --------------------------------------------------------
	-- 2-phase commit for instructions required for broadcasting to work
	TYPE mib_phase IS (CHECK, COMMIT);
	
	-- input of FU, output of CTRL
	TYPE mib_ctrl_out IS RECORD
		phase: mib_phase;
		valid: STD_LOGIC;
		src: address_fu_buff;
		dest: address_fu_buff;
	END RECORD;
	
	-- output of FU, input of CTRL
	TYPE mib_stalls IS RECORD
		src_stalled: STD_LOGIC;
		dest_stalled: STD_LOGIC;
	END RECORD;
	
-- DATA NETWORK ----------------------------------------------------------------
	TYPE data_message IS RECORD
		src: address_fu_buff;
		dest: address_fu_buff;
		data: data_word;
	END RECORD;
	
	TYPE data_port_sending IS RECORD
		message: data_message;
		valid: STD_LOGIC;
	END RECORD;
	
	TYPE data_port_receiving IS RECORD
		is_read: STD_LOGIC;
	END RECORD;
	
	TYPE data_packets_t is array (0 to FU_INPUT_W ) of  data_port_sending;
	
END common;

