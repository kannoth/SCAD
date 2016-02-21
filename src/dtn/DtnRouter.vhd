library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

library work;
use work.glbSharedTypes.all;

entity DtnRouter is
  generic ( Address : natural := 0);	-- Harcoded self address ( To determine the router position to load the corresponding routing table)
  port (
    clk			:in	std_logic;-- system clock
    reset		:in	std_logic;-- synchronous system reset ( Active HIGH )
    consumed	:in	std_logic;-- from FU indicate the functional unit has consumend the data ( Active HIGH )
    valid 		:out 	std_logic;-- indicated the data packet is analyzed by the router. ( Active HIGH )
	 stall		:out 	std_logic;-- stall the previous pipeline stages ( Active HIGH )
    inpBus		:in	sorterIOVector_t;--input paket from the sorter
    outBus		:out	sorterIOVector_t;--output packet to the FU
    upOutBus	:out	sorterIOVector_t;--upward path output bus
    dwnOutBus	:out	sorterIOVector_t;--downward path output bus
    upInBus		:in	sorterIOVector_t;--upward path input bus
    dwnInBus	:in	sorterIOVector_t -- downward path input bus
);
end entity;

architecture Behaviour of DtnRouter is
  signal toUpPacketReg	:sorterIOVector_t;
  signal toDownPacketReg:sorterIOVector_t;
  signal outPacketReg	:sorterIOVector_t;
  signal RTR_STATE		:dtnRouterStates_t;
  signal NXT_RTR_STATE	:dtnRouterStates_t;
begin
	
-- immediate assignments
	outBus		<= outPacketReg;
	upOutBus		<= toUpPacketReg;
	dwnOutBus	<= toDownPacketReg;
	--selfAddr		<= std_logic_vector(to_unsigned(Address, selfAddr'length));
-- sequencial process for router  FSM
sm_proc : process begin
  wait until rising_edge(clk);
  if reset = '1' then
    RTR_STATE <= DETERMINE;
  else
    RTR_STATE <= NXT_RTR_STATE;
  end if;
end process;
-- combinatorial process for  FSM 
main_proc : process (RTR_STATE,inpBus,upInBus,dwnInBus,consumed) begin
	case RTR_STATE is
		when	DETERMINE	=>
			valid		<= '0';
			stall		<= '1';
			--outBus	<= dtnRtrDefVal;

			if ( isAddrValid(inpBus.tarAddr) = '1') then
				if (inpBus.tarAddr = std_logic_vector(to_unsigned(Address, FU_ADDRESS_W))) then
					NXT_RTR_STATE	<= LOCKED;
					outPacketReg	<= inpBus;
					toUpPacketReg 	<= dtnRtrDefVal;
					toDownPacketReg<= dtnRtrDefVal;
				else
					NXT_RTR_STATE	<= ROUTE;
					outPacketReg	<= dtnRtrDefVal;
					-- Determine the shortest route from the table and route the packet up or down
					if FW_RT(Address,getAddressIdx(inpBus.tarAddr)) < RV_RT(Address,getAddressIdx(inpBus.tarAddr)) then
						toUpPacketReg	<= dtnRtrDefVal;
						toDownPacketReg<= inpBus;
					else
						toDownPacketReg<= dtnRtrDefVal;
						toUpPacketReg<= inpBus;
					end if;
				end if;
			else
				NXT_RTR_STATE	<= ROUTE;
				outPacketReg	<= dtnRtrDefVal;
				toUpPacketReg 	<= dtnRtrDefVal;
				toDownPacketReg<= dtnRtrDefVal;
			end if;

		when	ROUTE	=>
			valid	<= '0';
			stall	<= '1';
			--outBus	<= dtnRtrDefVal;
			if ( isAddrValid(upInBus.tarAddr) = '1') then
				if upInBus.tarAddr = std_logic_vector(to_unsigned(Address, FU_ADDRESS_W)) then
					NXT_RTR_STATE	<= LOCKED;
					outPacketReg	<= upInBus;
					toUpPacketReg 	<= dtnRtrDefVal;
				else
					NXT_RTR_STATE	<= ROUTE;
					outPacketReg	<= dtnRtrDefVal;
					toUpPacketReg 	<= upInBus;		
				end if;
			else
				NXT_RTR_STATE	<= ROUTE;
				outPacketReg	<= dtnRtrDefVal;
				toUpPacketReg 	<= dtnRtrDefVal;					
			end if;

			if ( isAddrValid(dwnInBus.tarAddr) = '1') then
				if dwnInBus.tarAddr = std_logic_vector(to_unsigned(Address, FU_ADDRESS_W)) then
					NXT_RTR_STATE	<= LOCKED;
					outPacketReg	<= dwnInBus;
					toDownPacketReg<= dtnRtrDefVal;
				else
					NXT_RTR_STATE	<= ROUTE;
					outPacketReg	<= dtnRtrDefVal;	
					toDownPacketReg<= dwnInBus;		
				end if;
			else
				NXT_RTR_STATE	<= ROUTE;
				outPacketReg	<= dtnRtrDefVal;
				toDownPacketReg<= dtnRtrDefVal;				
			end if;
			
		when	LOCKED	=>
			valid	<= '1';
			stall		<= '0';
			outPacketReg <= inpBus;
			if consumed = '1' then
				NXT_RTR_STATE <= DETERMINE;
			else
				NXT_RTR_STATE <= LOCKED;
			end if;
		
			if ( isAddrValid(upInBus.tarAddr) = '1') then
				toUpPacketReg 	<= upInBus;
				toDownPacketReg<= dtnRtrDefVal;
			else
				toUpPacketReg 	<= dtnRtrDefVal;
				toDownPacketReg<= dtnRtrDefVal;
			end if;
			if ( isAddrValid(dwnInBus.tarAddr) = '1') then
				toDownPacketReg<= dwnInBus;
				toUpPacketReg 	<= dtnRtrDefVal;
			else
				toDownPacketReg<= dtnRtrDefVal;
				toUpPacketReg 	<= dtnRtrDefVal;
			end if;	
	end case;
end process;
end architecture;

