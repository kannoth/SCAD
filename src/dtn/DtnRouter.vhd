library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

library work;
use work.common.all;

entity DtnRouter is
  generic ( Address : natural := 0);	-- Harcoded self address ( To determine the router position to load the corresponding routing table)
  port (
	clk		:in	std_logic;-- system clock
	reset		:in	std_logic;-- synchronous system reset ( Active HIGH )
	consumed	:in	std_logic;-- from FU indicate the functional unit has consumend the data ( Active HIGH )
	valid 		:out 	std_logic;-- indicated the data packet is analyzed by the router. ( Active HIGH )
	stall		:out 	std_logic;-- stall the previous pipeline stages ( Active HIGH )
	inaddrPrUp	:in 	std_logic;-- valid packet present in the upInBus port ( Active HIGH )
	inaddrPrDwn	:in 	std_logic;-- valid packet present in the dwnInBus port ( Active HIGH )
	outaddrPrUp	:out 	std_logic;-- valid packet routed to in the upOutBus port ( Active HIGH )
	outaddrPrDwn	:out 	std_logic;-- valid packet routed in the dwnOutBus port ( Active HIGH )
    	inpBus		:in	sorterIOVector_t;--input paket from the sorter
    	outBus		:out	sorterIOVector_t;--output packet to the FU
    	upOutBus	:out	sorterIOVector_t;--upward path output bus
    	dwnOutBus	:out	sorterIOVector_t;--downward path output bus
    	upInBus		:in	sorterIOVector_t;--upward path input bus
    	dwnInBus	:in	sorterIOVector_t -- downward path input bus
);
end entity;

architecture Behaviour of DtnRouter is
  signal toUpPacketReg		:sorterIOVector_t;
  signal toDownPacketReg	:sorterIOVector_t;
  signal outPacketReg		:sorterIOVector_t;
  signal RTR_STATE		:dtnRouterStates_t;
  signal NXT_RTR_STATE		:dtnRouterStates_t;
  signal lockoutBus		:std_logic;
begin
	
	
port_proc :process ( clk ) begin
	if rising_edge(clk) then
		if reset = '1' or consumed ='1' then
			outBus		<= RTR_DEF_VAL;
			upOutBus	<= RTR_DEF_VAL;
			dwnOutBus	<= RTR_DEF_VAL;	
		else
			-- Gate the outBus incase the router recieves its packet.
			if lockoutBus = '0' then
				outBus <= outPacketReg;
			end if;
		upOutBus <= toUpPacketReg;
		dwnOutBus <= toDownPacketReg;
		end if;
	end if;
end process;

-- sequencial process for router  FSM
sm_proc : process begin
  wait until rising_edge(clk);
  if reset = '1' then
    RTR_STATE <= AWAIT;
  else
    RTR_STATE <= NXT_RTR_STATE;
  end if;
end process;
-- combinatorial process for  FSM 
main_proc : process (RTR_STATE,inpBus,upInBus,dwnInBus,inaddrPrUp,inaddrPrDwn,consumed) begin
	case RTR_STATE is
		------------------------------------------------------------
		when	AWAIT =>
			valid		<= '0';
			stall		<= '1';
			toUpPacketReg 	<= RTR_DEF_VAL;
			toDownPacketReg <= RTR_DEF_VAL;
			outaddrPrUp	<= '0';
			outaddrPrDwn	<= '0';
			lockoutBus	<= '0';

			if ( isAddrValid(inpBus.tarAddr) = '1') then
				if (inpBus.tarAddr = std_logic_vector(to_unsigned(Address, FU_ADDRESS_W))) then
					NXT_RTR_STATE	<= LOCKED;
					outPacketReg	<= inpBus;
				else
					NXT_RTR_STATE	<= DETERMINE;
					outPacketReg	<= RTR_DEF_VAL;

				end if;
			else
				NXT_RTR_STATE	<= DETERMINE;
				outPacketReg	<= RTR_DEF_VAL;
			end if;
		------------------------------------------------------------
		when	DETERMINE =>
			valid		<= '0';
			stall		<= '1';
			outPacketReg	<= RTR_DEF_VAL;
			outaddrPrUp	<= '0';
			outaddrPrDwn	<= '0';
			lockoutBus	<= '0';
			-- Determine the shortest route from the table and route the packet up or down
			if ( isAddrValid(inpBus.tarAddr) = '1') then
			if FW_RT(Address,getAddressIdx(inpBus.tarAddr)) < RV_RT(Address,getAddressIdx(inpBus.tarAddr)) then
				toUpPacketReg	<= RTR_DEF_VAL;
				toDownPacketReg <= inpBus;
			else
				toDownPacketReg <= RTR_DEF_VAL;
				toUpPacketReg	<= inpBus;
			end if;
			else
				toDownPacketReg <= RTR_DEF_VAL;
				toUpPacketReg	<= RTR_DEF_VAL;
			end if;
			NXT_RTR_STATE <= ROUTE;
			
		------------------------------------------------------------
		when	ROUTE =>
			valid	<= '0';
			stall	<= '1';
			lockoutBus	<= '0';
			if (inpBus.tarAddr = std_logic_vector(to_unsigned(Address, FU_ADDRESS_W))) then
				outPacketReg <= inpBus;
				NXT_RTR_STATE <= LOCKED;		
			elsif (upInBus.tarAddr = std_logic_vector(to_unsigned(Address, FU_ADDRESS_W))) then
				outPacketReg <= upInBus;
				NXT_RTR_STATE <= LOCKED;
			elsif (dwnInBus.tarAddr = std_logic_vector(to_unsigned(Address, FU_ADDRESS_W))) then
				outPacketReg <= dwnInBus;
				NXT_RTR_STATE <= LOCKED;
			else
				outPacketReg <= RTR_DEF_VAL;
				NXT_RTR_STATE <= ROUTE;
			end if;

			if    (inaddrPrUp = '1' and inaddrPrDwn = '1') then
				toUpPacketReg 	<= dwnInBus;
				toDownPacketReg <= upInBus;
				outaddrPrUp	<= '1';
				outaddrPrDwn	<= '1';
			elsif (inaddrPrUp = '1' and inaddrPrDwn = '0') then
				toUpPacketReg 	<= RTR_DEF_VAL;
				toDownPacketReg <= upInBus;
				outaddrPrUp	<= '0';
				outaddrPrDwn	<= '1';
			elsif (inaddrPrUp = '0' and inaddrPrDwn = '1') then
				toUpPacketReg 	<= dwnInBus;
				toDownPacketReg <= RTR_DEF_VAL;
				outaddrPrUp	<= '1';
				outaddrPrDwn	<= '0';
			elsif (inaddrPrUp = '0' and inaddrPrDwn = '0') then
				toUpPacketReg 	<= RTR_DEF_VAL;
				toDownPacketReg <= RTR_DEF_VAL;
				outaddrPrUp	<= '0';
				outaddrPrDwn	<= '0';
			else
				toUpPacketReg 	<= RTR_DEF_VAL;
				toDownPacketReg <= RTR_DEF_VAL;	
				outaddrPrUp	<= '0';
				outaddrPrDwn	<= '0';			
			end if;

		------------------------------------------------------------
		when	LOCKED =>
			valid	<= '1';
			stall	<= '0';
			lockoutBus	<= '1';
			outPacketReg	<= inpBus; -- doesn't matter what value outPacketReg has. The value is gated with lockoutBus	<= '1'; 

			if    (inaddrPrUp = '1' and inaddrPrDwn = '1') then
				toUpPacketReg 	<= dwnInBus;
				toDownPacketReg <= upInBus;
				outaddrPrUp	<= '1';
				outaddrPrDwn	<= '1';
			elsif (inaddrPrUp = '1' and inaddrPrDwn = '0') then
				toUpPacketReg 	<= RTR_DEF_VAL;
				toDownPacketReg <= upInBus;
				outaddrPrUp	<= '0';
				outaddrPrDwn	<= '1';
			elsif (inaddrPrUp = '0' and inaddrPrDwn = '1') then
				toUpPacketReg 	<= dwnInBus;
				toDownPacketReg <= RTR_DEF_VAL;
				outaddrPrUp	<= '1';
				outaddrPrDwn	<= '0';
			elsif (inaddrPrUp = '0' and inaddrPrDwn = '0') then
				toUpPacketReg 	<= RTR_DEF_VAL;
				toDownPacketReg <= RTR_DEF_VAL;
				outaddrPrUp	<= '0';
				outaddrPrDwn	<= '0';
			else
				toUpPacketReg 	<= RTR_DEF_VAL;
				toDownPacketReg <= RTR_DEF_VAL;
				outaddrPrUp	<= '0';
				outaddrPrDwn	<= '0';
			end if;

			if consumed = '1' then
				NXT_RTR_STATE <= AWAIT;
			else 
				NXT_RTR_STATE <= LOCKED;
			end if;
	end case;
end process;
end architecture;

