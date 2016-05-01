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
	CONSTANT    	FU_FIFO_IDX_W   		: NATURAL   := 1; 
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
	CONSTANT		MEM_BANK_ADDR_LENGTH		: NATURAL   := NATURAL(log2(REAL(MEM_BANK_SIZE)));
	
	CONSTANT    BUF_SIZE			 	: NATURAL := 6;
	CONSTANT    FIFO_BUF_SIZE		: NATURAL := 6;
	
	CONSTANT	MAX_FUS					: NATURAL := 32;
	
	TYPE ram_TYPE IS ARRAY (0 TO MEM_BANK_SIZE - 1) OF STD_LOGIC_VECTOR (MEM_WORD_LENGTH - 1 downto 0);
	
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
-- DTN-----------------------------------------------------------------	
	type sorterIOVector_t is record
		vld		: std_logic;											-- Validity assertion register bits
		tarAddr		: std_logic_vector(FU_ADDRESS_W   downto 0);	-- target FU address ( The validity of address is encapsulated in the msb of the tarAddr (Active Low) VALD=0, INVD=1 )
		srcAddr		: std_logic_vector(FU_ADDRESS_W  -1 downto 0);	-- source FU address 
		data		: std_logic_vector(FU_DATA_W-1  downto 0);	-- data to be routed
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
	constant RTR_DEF_VAL: sorterIOVector_t := ('0',"000000","00000", "00000000000000000000000000000000","0","0");
	-- DTN-Router states
	type dtnRouterStates_t is (AWAIT,DETERMINE ,ROUTE, LOCKED ) ;
	-- DTN-Routing table type
	type dtnRoutTbl_t is array (0 to FU_INPUT_W,0 to FU_INPUT_W) of integer;
	-- Forward routing table
	constant FW_RT : dtnRoutTbl_t:=	(( 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),
					( 31,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30),
					( 30,31,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29),
					( 29,30,31,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28),
					( 28,29,30,31,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27),
					( 27,28,29,30,31,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26),
					( 26,27,28,29,30,31,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25),
					( 25,26,27,28,29,30,31,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24),
					( 24,25,26,27,28,29,30,31,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23),
					( 23,24,25,26,27,28,29,30,31,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22),
					( 22,23,24,25,26,27,28,29,30,31,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21),
					( 21,22,23,24,25,26,27,28,29,30,31,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20),
					( 20,21,22,23,24,25,26,27,28,29,30,31,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19),
					( 19,20,21,22,23,24,25,26,27,28,29,30,31,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18),
					( 18,19,20,21,22,23,24,25,26,27,28,29,30,31,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17),
					( 17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16),
					( 16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15),
					( 15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14),
					( 14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0,1,2,3,4,5,6,7,8,9,10,11,12,13),
					( 13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0,1,2,3,4,5,6,7,8,9,10,11,12),
					( 12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0,1,2,3,4,5,6,7,8,9,10,11),
					( 11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0,1,2,3,4,5,6,7,8,9,10),
					( 10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0,1,2,3,4,5,6,7,8,9),
					( 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0,1,2,3,4,5,6,7,8),
					( 8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0,1,2,3,4,5,6,7),
					( 7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0,1,2,3,4,5,6),
					( 6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0,1,2,3,4,5),
					( 5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0,1,2,3,4),
					( 4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0,1,2,3),
					( 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0,1,2),
					( 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0,1),
					( 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0));
	-- Reverse routing table
	constant RV_RT : dtnRoutTbl_t:=((31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0),
					(0,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1),
					(1,0,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2),
					(2,1,0,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3),
					(3,2,1,0,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4),
					(4,3,2,1,0,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5),
					(5,4,3,2,1,0,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6),
					(6,5,4,3,2,1,0,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7),
					(7,6,5,4,3,2,1,0,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8),
					(8,7,6,5,4,3,2,1,0,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9),
					(9,8,7,6,5,4,3,2,1,0,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10),
					(10,9,8,7,6,5,4,3,2,1,0,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11),
					(11,10,9,8,7,6,5,4,3,2,1,0,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12),
					(12,11,10,9,8,7,6,5,4,3,2,1,0,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13),
					(13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14),
					(14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15),
					(15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16),
					(16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17),
					(17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,30,29,28,27,26,25,24,23,22,21,20,19,18),
					(18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,30,29,28,27,26,25,24,23,22,21,20,19),
					(19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,30,29,28,27,26,25,24,23,22,21,20),
					(20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,30,29,28,27,26,25,24,23,22,21),
					(21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,30,29,28,27,26,25,24,23,22),
					(22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,30,29,28,27,26,25,24,23),
					(23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,30,29,28,27,26,25,24),
					(24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,30,29,28,27,26,25),
					(25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,30,29,28,27,26),
					(26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,30,29,28,27),
					(27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,30,29,28),
					(28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,30,29),
					(29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,30),
					(30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31));
-- DTN-----------------------------------------------------------------

--	-- Reset values for pipeline stage registers												
--	CONSTANT pRegDefVal	: bitonStageBus_t := ( others => ( '0',"000000", "00000","0"));
	
	-- instruction memory (i.e. pc) address width
	-- out of comission - pc IS just another data word
	--CONSTANT PC_WIDTH := FU_DATA_W;
	
	TYPE fu_alu_type IS (ADD, SUBTRACT, MULT, LT, GT, LTE, GTE, EQ, NEQ);
	
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
	
	CONSTANT ctrl_mib_INIT:mib_ctrl_out := ( phase => CHECK,
                               valid => '0',
                               src =>(fu => (OTHERS =>'0'),buff=>'0'),
                               dest => (fu => (OTHERS =>'0'),buff=>'0'));
	-- output of FU, input of CTRL
	TYPE mib_stalls IS RECORD
		src_stalled: STD_LOGIC;
		dest_stalled: STD_LOGIC;
	END RECORD;
	
	--TYPE mib_ctrl_bus is array (0 to FU_INPUT_W ) of  mib_ctrl_out;
	TYPE mib_status_bus is array (0 to FU_INPUT_W ) of  mib_stalls;
	
	
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
	
	-- TYPE DEFAULTS ----------------------------------------------------------------
	constant mib_ctrl_default : mib_ctrl_out := (phase => CHECK, valid => '0', src => ( fu=> (others=>'0'), buff => '0'), dest => ( fu=> (others=>'0'), buff => '0'));
	constant dtn_default : data_port_sending := (valid => '0', message => ( src => (fu => (OTHERS =>'0'),buff=>'0'), dest => (fu => (OTHERS =>'0'),buff=>'0'), data => (others=> '0')));

-- DTN-----------------------------------------------------------------
	function isAddrValid(addr : IN std_logic_vector (FU_ADDRESS_W  downto 0)) return std_logic;
	function getAddressIdx(addr : IN std_logic_vector (FU_ADDRESS_W  downto 0)) return integer;
-- DTN-----------------------------------------------------------------
	
END common;

package body common is
	-- returns true if the address is VALID.
	function isAddrValid(addr : IN std_logic_vector (FU_ADDRESS_W downto 0)) return std_logic is
	begin
		return not (addr(FU_ADDRESS_W ));
	end function isAddrValid;

	function getAddressIdx(addr : IN std_logic_vector (FU_ADDRESS_W  downto 0)) return integer is
	begin
		return to_integer(unsigned(addr));
	end function getAddressIdx;	
	
end common;
