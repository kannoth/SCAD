library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;

entity MIB is
	port ( 	
			clk 		:in std_logic;
			rst			:in std_logic; 
			--Signals from/to controller
			ctrl 		: in mib_ctrl_out;
			stat 		: out mib_stalls;
			mib_ctrl 	: out mib_ctrl_bus;
			mib_stat 	: in mib_status_bus
		);
end entity;

architecture RTL of MIB is
--output registers
signal ctrl_reg : mib_ctrl_out;
signal stat_reg : mib_stalls;
signal dest_addr_reg : address_fu;

begin

stat	<= stat_reg;

process(clk)
variable dest_addr : address_fu ;
begin
	if rising_edge(clk) then
		if rst = '1' then
		--TODO:Create default value types for records!
			dest_addr := (others => '0');
			dest_addr_reg <= (others => '0');
		else
			dest_addr := ctrl.dest.fu;
			dest_addr_reg <= dest_addr;
			mib_ctrl(to_integer(unsigned(dest_addr))) <= ctrl;
			stat_reg <= mib_stat (to_integer(unsigned(dest_addr)));
			--assign default value to unused outputs
			mib_ctrl(to_integer(unsigned(dest_addr_reg))) <= mib_ctrl_default;
		end if;
	end if;
end process;

end architecture;