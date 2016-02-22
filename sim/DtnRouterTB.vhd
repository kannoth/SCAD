library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

library work;
use work.glbSharedTypes.all;

entity DtnRouterTB is
end entity;

architecture Behaviour of DtnRouterTB is
	signal clk_period_s	:time := 40 ns;
    signal clk_s		:std_logic := '0';
    signal reset_s		:std_logic := '0';
    signal consumed_s	:std_logic;
    signal valid_s 		:std_logic;
	signal stall_s		:std_logic;
    signal inpBus_s		:sorterIOVector_t;
    signal outBus_s		:sorterIOVector_t;
    signal upOutBus_s	:sorterIOVector_t;
    signal dwnOutBus_s	:sorterIOVector_t;
    signal upInBus_s	:sorterIOVector_t;
    signal dwnInBus_s	:sorterIOVector_t;
begin

	ROUTER_UUT : entity work.DtnRouter 
				generic map ( Address => 0 )
				port	map (	clk => clk_s,
								reset => reset_s,
								consumed => consumed_s,
								valid => valid_s,
								stall => stall_s,
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
		--TODO : Test cases 
		reset_s <= '0';
		wait for clk_period_s;
		
	end process;
end architecture;
