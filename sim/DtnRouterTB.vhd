library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

library work;
use work.common.all;

entity DtnRouterTB is
end entity;

architecture Behaviour of DtnRouterTB is
	signal clk_period_s	:time := 40 ns;
	signal clk_s		:std_logic := '0';
	signal reset_s		:std_logic := '0';
	signal consumed_s	:std_logic;
	signal valid_s		:std_logic;
	signal stall_s		:std_logic;
	signal inaddrPrUp_s	:std_logic;
	signal inaddrPrDwn_s	:std_logic;
	signal outaddrPrUp_s	:std_logic;
	signal outaddrPrDwn_s	:std_logic;
	signal inpBus_s		:sorterIOVector_t;
	signal outBus_s		:sorterIOVector_t;
	signal upOutBus_s	:sorterIOVector_t;
	signal dwnOutBus_s	:sorterIOVector_t;
	signal upInBus_s	:sorterIOVector_t;
	signal dwnInBus_s	:sorterIOVector_t;
	
	constant ALLZEROS	: sorterIOVector_t := ('1',"000000","00000", "00000000000000000000000000000000","0","0");
	constant INVALADDR  	: sorterIOVector_t := ('0',"100000","00000", "00000000000000000000000000000000","0","0");
	constant TAR_ADDR_2  	: sorterIOVector_t := ('1',"000010","00000", "00000000000000000000000000000000","0","0");
	constant TAR_ADDR_3  	: sorterIOVector_t := ('1',"000011","00000", "00000000000000000000000000000000","0","0");
	constant TAR_ADDR_4  	: sorterIOVector_t := ('1',"000100","00000", "00000000000000000000000000000000","0","0");
	constant TAR_ADDR_5  	: sorterIOVector_t := ('1',"000101","00000", "00000000000000000000000000000000","0","0");
	constant TAR_ADDR_7  	: sorterIOVector_t := ('1',"000111","00000", "00000000000000000000000000000000","0","0");
	constant TAR_ADDR_8  	: sorterIOVector_t := ('1',"001000","00000", "00000000000000000000000000000000","0","0");
	constant TAR_ADDR_31  	: sorterIOVector_t := ('1',"011111","00000", "00000000000000000000000000000000","0","0");
	
begin

	DtnRouterInst : entity work.DtnRouter 
				generic map ( Address => 5 ) -- Adress assingne to 5;
				port	map (	clk	=> clk_s,
						reset => reset_s,
						consumed => consumed_s,
						valid => valid_s,
						stall => stall_s,
						inaddrPrUp=>inaddrPrUp_s,
						inaddrPrDwn=>inaddrPrDwn_s,
						outaddrPrUp=>outaddrPrUp_s,
						outaddrPrDwn=>outaddrPrDwn_s,
						inpBus => inpBus_s,
						outBus => outBus_s,
						upOutBus => upOutBus_s,
						dwnOutBus => dwnOutBus_s,
						upInBus => upInBus_s,
						dwnInBus => dwnInBus_s );
	clk_p : process begin
		wait for clk_period_s / 2;
		clk_s <= not clk_s;
	end process;

	stim_p : process begin

		---------------------------------------------------------------------------------------
		reset_s <= '1';
		upInBus_s	<= INVALADDR;
		dwnInBus_s	<= INVALADDR;
		inpBus_s	<= INVALADDR;
		inaddrPrUp_s	<= '0';
		inaddrPrDwn_s	<= '0';
		consumed_s	<= '0';
		wait for clk_period_s;
		assert (upOutBus_s = ALLZEROS) report " upOutBus_s  All zeros expected @ reset " severity error;
		assert (dwnOutBus_s = ALLZEROS) report " dwnOutBus_s  All zeros expected @ reset" severity error;
		assert (outBus_s = ALLZEROS) report " outBus_s  All zeros expected @ reset " severity error;
		assert (valid_s = '0') report " valid_s = false   @ reset" severity error;
		assert (stall_s = '1') report " stall_s = true   @ reset" severity error;
		assert (outaddrPrUp_s = '0') report " outaddrPrUp_s = false  expected @ reset" severity error;
		assert (outaddrPrDwn_s = '0') report " outaddrPrDwn_s = false expected  @ reset" severity error;
		---------------------------------------------------------------------------------------
		wait for clk_period_s;
		reset_s <= '0';
		upInBus_s	<= INVALADDR;
		dwnInBus_s	<= INVALADDR;
		inpBus_s	<= TAR_ADDR_5;
		inaddrPrUp_s	<= '0';
		inaddrPrDwn_s	<= '0';
		consumed_s	<= '0';
		assert (upOutBus_s = ALLZEROS) report " upOutBus_s  All zeros expected @ clk 1 " severity error;
		assert (dwnOutBus_s = ALLZEROS) report " dwnOutBus_s  All zeros expected @ clk 1" severity error;
		assert (outBus_s = ALLZEROS) report " outBus_s  All zeros expected @ clk 1 " severity error;
		assert (valid_s = '0') report " valid_s = false   @ clk 1" severity error;
		assert (stall_s = '1') report " stall_s = true   @ clk 1" severity error;
		assert (outaddrPrUp_s = '0') report " outaddrPrUp_s = false  expected @ clk 1" severity error;
		assert (outaddrPrDwn_s = '0') report " outaddrPrDwn_s = false expected @ clk 1" severity error;
		---------------------------------------------------------------------------------------
		wait for clk_period_s;
		upInBus_s	<= TAR_ADDR_8;
		dwnInBus_s	<= TAR_ADDR_3;
		inpBus_s	<= TAR_ADDR_5;
		inaddrPrUp_s	<= '1';
		inaddrPrDwn_s	<= '1';
		consumed_s	<= '0';	
		assert (upOutBus_s = ALLZEROS) report " upOutBus_s  All zeros expected @ clk 2 " severity error;
		assert (dwnOutBus_s = ALLZEROS) report " dwnOutBus_s  All zeros expected @ clk 2" severity error;
		assert (outBus_s = TAR_ADDR_5) report " outBus_s  = TAR_ADDR_5 expected @ clk 2 " severity error;
		assert (valid_s = '1') report " valid_s = false   clk 2" severity error;
		assert (stall_s = '0') report " stall_s = true @ clk 2" severity error;
		assert (outaddrPrUp_s = '0') report " outaddrPrUp_s = false expected @ clk 2" severity error;
		assert (outaddrPrDwn_s = '0') report " outaddrPrDwn_s = false  expected @ clk 2" severity error;
		---------------------------------------------------------------------------------------
		wait for clk_period_s;
		upInBus_s	<= TAR_ADDR_7;
		dwnInBus_s	<= TAR_ADDR_4;
		inpBus_s	<= TAR_ADDR_5;
		inaddrPrUp_s	<= '1';
		inaddrPrDwn_s	<= '1';
		consumed_s	<= '0';
		assert (upOutBus_s = TAR_ADDR_3) report " upOutBus_s  = TAR_ADDR_4 expected @ clk 3 " severity error;
		assert (dwnOutBus_s = TAR_ADDR_8) report " dwnOutBus_s  = TAR_ADDR_8 expected @ clk 3" severity error;
		assert (outBus_s = TAR_ADDR_5) report " outBus_s  = TAR_ADDR_5 expected @ clk 3 " severity error;
		assert (valid_s = '1') report " valid_s = false  @ clk 3" severity error;
		assert (stall_s = '0') report " stall_s = true  @ clk 3" severity error;
		assert (outaddrPrUp_s = '1') report " outaddrPrUp_s = true expected @ clk 3" severity error;
		assert (outaddrPrDwn_s = '1') report " outaddrPrDwn_s = true expected @ clk 3" severity error;
		---------------------------------------------------------------------------------------
		wait for clk_period_s;
		upInBus_s	<= TAR_ADDR_7;
		dwnInBus_s	<= TAR_ADDR_4;
		inpBus_s	<= TAR_ADDR_5;
		inaddrPrUp_s	<= '1';
		inaddrPrDwn_s	<= '1';
		consumed_s	<= '1';
		assert (upOutBus_s = TAR_ADDR_4) report " upOutBus_s  = TAR_ADDR_4 expected @ clk 4 " severity error;
		assert (dwnOutBus_s = TAR_ADDR_7) report " dwnOutBus_s = TAR_ADDR_7 expected @ clk 4" severity error;
		assert (outBus_s = TAR_ADDR_5) report " outBus_s  = TAR_ADDR_5 expected @ clk 4 " severity error;
		assert (valid_s = '1') report " valid_s = false  @ clk 4" severity error;
		assert (stall_s = '0') report " stall_s = true  @ clk 4" severity error;
		assert (outaddrPrUp_s = '1') report " outaddrPrUp_s = true  expected @ clk 4" severity error; --from previous cycle
		assert (outaddrPrDwn_s = '1') report " outaddrPrDwn_s = true  expected @ clk 4" severity error;--from previous cycle
		---------------------------------------------------------------------------------------
		wait for clk_period_s;
		upInBus_s	<= INVALADDR;
		dwnInBus_s	<= INVALADDR;
		inpBus_s	<= INVALADDR;
		inaddrPrUp_s	<= '0';
		inaddrPrDwn_s	<= '0';
		consumed_s	<= '0';
		assert (upOutBus_s = ALLZEROS) report " upOutBus_s  All zeros expected @ clk 5 " severity error;
		assert (dwnOutBus_s = ALLZEROS) report " dwnOutBus_s  All zeros expected @ clk 5" severity error;
		assert (outBus_s = ALLZEROS) report " outBus_s  All zeros expected @ clk 5 " severity error;
		assert (valid_s = '0') report " valid_s = false   @ clk 5" severity error;
		assert (stall_s = '1') report " stall_s = true   @ clk 5" severity error;
		assert (outaddrPrUp_s = '0') report " outaddrPrUp_s = false  expected @ clk 5" severity error;
		assert (outaddrPrDwn_s = '0') report " outaddrPrDwn_s = false expected  @ clk 5" severity error;
		---------------------------------------------------------------------------------------
		wait for clk_period_s;
		upInBus_s	<= TAR_ADDR_5;
		dwnInBus_s	<= INVALADDR;
		inpBus_s	<= INVALADDR;
		inaddrPrUp_s	<= '0';
		inaddrPrDwn_s	<= '0';
		consumed_s	<= '0';
		assert (upOutBus_s = ALLZEROS) report " upOutBus_s  All zeros expected @ clk 6 " severity error;
		assert (dwnOutBus_s = ALLZEROS) report " dwnOutBus_s  All zeros expected @ clk 6" severity error;
		assert (outBus_s = ALLZEROS) report " outBus_s  All zeros expected @ clk 6 " severity error;
		assert (valid_s = '0') report " valid_s = false   @ clk 6" severity error;
		assert (stall_s = '1') report " stall_s = true   @ clk 6" severity error;
		assert (outaddrPrUp_s = '0') report " outaddrPrUp_s = false  expected @ clk 6" severity error;
		assert (outaddrPrDwn_s = '0') report " outaddrPrDwn_s = false expected  @ clk 6" severity error;
		---------------------------------------------------------------------------------------
		wait for clk_period_s;
		assert (upOutBus_s = ALLZEROS) report " upOutBus_s  All zeros expected @ clk 7 " severity error;
		assert (dwnOutBus_s = ALLZEROS) report " dwnOutBus_s  All zeros expected @ clk 7" severity error;
		assert (outBus_s = ALLZEROS) report " outBus_s  = TAR_ADDR_5 expected @ clk 7 " severity error;
		assert (valid_s = '0') report " valid_s = false   @ clk 7" severity error;
		assert (stall_s = '1') report " stall_s = true   @ clk 7" severity error;
		assert (outaddrPrUp_s = '0') report " outaddrPrUp_s = false  expected @ clk 7" severity error;
		assert (outaddrPrDwn_s = '0') report " outaddrPrDwn_s = false expected  @ clk 7" severity error;
		---------------------------------------------------------------------------------------
		wait for clk_period_s;
		upInBus_s	<= TAR_ADDR_7;
		dwnInBus_s	<= TAR_ADDR_2;
		inpBus_s	<= INVALADDR;
		inaddrPrUp_s	<= '1';
		inaddrPrDwn_s	<= '1';
		consumed_s	<= '0';
		assert (upOutBus_s = ALLZEROS) report " upOutBus_s  All zeros expected @ clk 8 " severity error;
		assert (dwnOutBus_s = ALLZEROS) report " dwnOutBus_s  All zeros expected @ clk 8" severity error;
		assert (outBus_s = TAR_ADDR_5) report " outBus_s  = TAR_ADDR_5 expected @ clk 8 " severity error;
		assert (valid_s = '1') report " valid_s = false   @ clk 8" severity error;
		assert (stall_s = '0') report " stall_s = true   @ clk 8" severity error;
		assert (outaddrPrUp_s = '0') report " outaddrPrUp_s = false  expected @ clk 8" severity error;
		assert (outaddrPrDwn_s = '0') report " outaddrPrDwn_s = false expected  @ clk 8" severity error;
		---------------------------------------------------------------------------------------
		wait for clk_period_s;
		upInBus_s	<= TAR_ADDR_7;
		dwnInBus_s	<= TAR_ADDR_2;
		inpBus_s	<= INVALADDR;
		inaddrPrUp_s	<= '0';
		inaddrPrDwn_s	<= '0';
		consumed_s	<= '0';
		assert (upOutBus_s = TAR_ADDR_2) report " upOutBus_s  =TAR_ADDR_2 expected @ clk 9 " severity error;
		assert (dwnOutBus_s = TAR_ADDR_7) report " dwnOutBus_s  =TAR_ADDR_7 expected @ clk 9" severity error;
		assert (outBus_s = TAR_ADDR_5) report " outBus_s  = TAR_ADDR_5 expected @ clk 9 " severity error;
		assert (valid_s = '1') report " valid_s = false   @ clk 9" severity error;
		assert (stall_s = '0') report " stall_s = true   @ clk 9" severity error;
		assert (outaddrPrUp_s = '1') report " outaddrPrUp_s = true  expected @ clk 9" severity error;
		assert (outaddrPrDwn_s = '1') report " outaddrPrDwn_s = true expected  @ clk 9" severity error;
		---------------------------------------------------------------------------------------
		wait for clk_period_s;
		assert (upOutBus_s = ALLZEROS) report " upOutBus_s  =ALLZEROS expected @ clk 10 " severity error;
		assert (dwnOutBus_s = ALLZEROS) report " dwnOutBus_s  =ALLZEROS expected @ clk 10" severity error;
		assert (outBus_s = TAR_ADDR_5) report " outBus_s  = TAR_ADDR_5 expected @ clk 10 " severity error;
		assert (valid_s = '1') report " valid_s = false   @ clk 10" severity error;
		assert (stall_s = '0') report " stall_s = true   @ clk 10" severity error;
		assert (outaddrPrUp_s = '0') report " outaddrPrUp_s = false  expected @ clk 10" severity error;
		assert (outaddrPrDwn_s = '0') report " outaddrPrDwn_s = false expected  @ clk 10!" severity error;
		---------------------------------------------------------------------------------------
		wait for clk_period_s;
		upInBus_s	<= INVALADDR;
		dwnInBus_s	<= INVALADDR;
		inpBus_s	<= TAR_ADDR_5;
		inaddrPrUp_s	<= '0';
		inaddrPrDwn_s	<= '0';
		consumed_s	<= '0';
		assert (upOutBus_s = ALLZEROS) report " upOutBus_s  =ALLZEROS expected @ clk 11 " severity error;
		assert (dwnOutBus_s = ALLZEROS) report " dwnOutBus_s  =ALLZEROS expected @ clk 11" severity error;
		assert (outBus_s = TAR_ADDR_5) report " outBus_s  = TAR_ADDR_5 expected @ clk 11 " severity error;
		assert (valid_s = '1') report " valid_s = false   @ clk 11" severity error;
		assert (stall_s = '0') report " stall_s = true   @ clk 11" severity error;
		assert (outaddrPrUp_s = '0') report " outaddrPrUp_s = false  expected @ clk 11" severity error;
		assert (outaddrPrDwn_s = '0') report " outaddrPrDwn_s = false expected  @ clk 11!" severity error;
		---------------------------------------------------------------------------------------
		wait for clk_period_s;
		consumed_s	<= '1';
		assert (upOutBus_s = ALLZEROS) report " upOutBus_s  =ALLZEROS expected @ clk 12 " severity error;
		assert (dwnOutBus_s = ALLZEROS) report " dwnOutBus_s  =ALLZEROS expected @ clk 12" severity error;
		assert (outBus_s = TAR_ADDR_5) report " outBus_s  = TAR_ADDR_5 expected @ clk 12 " severity error;
		assert (valid_s = '1') report " valid_s = false   @ clk 12" severity error;
		assert (stall_s = '0') report " stall_s = true   @ clk 12" severity error;
		assert (outaddrPrUp_s = '0') report " outaddrPrUp_s = false  expected @ clk 12" severity error;
		assert (outaddrPrDwn_s = '0') report " outaddrPrDwn_s = false expected  @ clk 12" severity error;
		---------------------------------------------------------------------------------------
		wait for clk_period_s;
		consumed_s	<= '0';
		assert (upOutBus_s = ALLZEROS) report " upOutBus_s  =TAR_ADDR_7 expected @ clk 13 " severity error;
		assert (dwnOutBus_s = ALLZEROS) report " dwnOutBus_s  =TAR_ADDR_2 expected @ clk 13" severity error;
		assert (outBus_s = ALLZEROS) report " outBus_s  = TAR_ADDR_5 expected @ clk 13 " severity error;
		assert (valid_s = '0') report " valid_s = false   @ clk 13" severity error;
		assert (stall_s = '1') report " stall_s = true   @ clk 13" severity error;
		assert (outaddrPrUp_s = '0') report " outaddrPrUp_s = false  expected @ clk 13" severity error;
		assert (outaddrPrDwn_s = '0') report " outaddrPrDwn_s = false expected  @ clk 13" severity error;
		---------------------------------------------------------------------------------------
		wait;
	end process;
end architecture;
