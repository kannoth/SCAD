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
	
	CONSTANT 	DATA_WIDTH				: NATURAL 	:= FU_DATA_W;
	
	-- Memory element constants. If there are multiple memory elements, first $MEM_SELECT_BITLENGTH bits
	-- of $MEM_ADDR_LENGTH are used for memory unit selection.
	-- Every unit has $BANK_SIZE long,word addressable flat address space.
	-- At this stage, number of load and store units are the same.
	CONSTANT   	MEM_WORD_LENGTH	   		: NATURAL   := 32;	--Number of bytes in each word
	CONSTANT   	MEM_NR_ELEMENTS	   		: NATURAL   := 1;		--Number of load and store elements(for each)
	CONSTANT   	MEM_BANK_SIZE	   		: NATURAL   := 64;	--Memory size in 4-byte words
	CONSTANT   	MEM_ADDR_LENGTH   		: NATURAL   := NATURAL(log2(REAL(MEM_NR_ELEMENTS * MEM_BANK_SIZE)));
	CONSTANT   	MEM_SELECT_BITLENGTH 	: NATURAL 	:= NATURAL(log2(REAL(MEM_NR_ELEMENTS)));
	CONSTANT		MEM_BANK_ADDR_LENGTH	: NATURAL   := NATURAL(log2(REAL(MEM_BANK_SIZE)));
	
	CONSTANT    BUF_SIZE			 	: NATURAL := 6;
	CONSTANT    FIFO_BUF_SIZE			: NATURAL := 6;
	
	CONSTANT	MAX_FUS					: NATURAL := 32;
	
	TYPE ram_type IS ARRAY (0 TO MEM_BANK_SIZE - 1) OF STD_LOGIC_VECTOR (MEM_WORD_LENGTH - 1 downto 0);
	
	TYPE mem_inp	IS RECORD 
		re	: STD_LOGIC;
		we	: STD_LOGIC;
		r_addr	: STD_LOGIC_VECTOR (MEM_BANK_ADDR_LENGTH-1 downto 0);
		w_addr	: STD_LOGIC_VECTOR (MEM_BANK_ADDR_LENGTH-1 downto 0);
		data_in : STD_LOGIC_VECTOR (MEM_WORD_LENGTH-1 downto 0);
	END RECORD;
	
	TYPE mem_out	IS RECORD
		r_ack	: STD_LOGIC;
		w_ack	: STD_LOGIC;
		data_out :   STD_LOGIC_VECTOR (MEM_WORD_LENGTH-1 downto 0);
	END RECORD;
	
	TYPE mem_inp_port IS ARRAY (0 TO MEM_NR_ELEMENTS-1) OF mem_inp;
	TYPE mem_out_port IS ARRAY (0 TO MEM_NR_ELEMENTS-1) OF mem_out;
	
	
	SUBTYPE data_word IS STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		
	
	TYPE aluFUState_t IS RECORD
			in1_full  	: STD_LOGIC;
			in1_empty 	: STD_LOGIC;
			in2_full		: STD_LOGIC;
			in2_empty 	: STD_LOGIC;
			out_full  	: STD_LOGIC;
			out_empty 	: STD_LOGIC;
	END RECORD;
	
	TYPE sorterIOVector_t IS RECORD
		vld				: STD_LOGIC;						-- Validity assertion register bits
		address			: STD_LOGIC_VECTOR(FU_ADDRESS_W  -1 DOWNTO 0);	-- FU address 
		data			: STD_LOGIC_VECTOR(FU_DATA_W     -1 DOWNTO 0);	-- data to be routed
		fifoIdx  		: STD_LOGIC;
	END RECORD;
	
	-- IO wires for the network
--	TYPE bitonStageBus_t is ARRAY (0 TO FU_INPUT_W) OF sorterIOVector_t;
--	-- Invalid address table
--	TYPE invAddArr_t IS ARRAY (0 TO FU_INPUT_W) OF std_logic_vector (FU_ADDRESS_W-1 DOWNTO 0);
--	
--	CONSTANT InvAddr : invAddArr_t := (	"100000","100001","100010","100011","100100","100101","100110","100111",
--													"101000","101001","101010","101011","101100","101101","101110","101111",
--													"110000","110001","110010","110011","110100","110101","110110","110111",
--													"111000","111001","111010","111011","111100","111101","111110","111111");
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
	
END common;

