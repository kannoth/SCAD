library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;

entity MIB is
	port ( 	
			clk 		:in std_logic;
			reset			:in std_logic; 
			--Signals from/to controller
			ctrl 		: in mib_ctrl_out;
			stat 		: out mib_status_bus;
			mib_ctrl 	: out mib_ctrl_out;
			mib_stat 	: in mib_status_bus
		);
end entity;

architecture RTL of MIB is
--output registers
signal ctrl_reg : mib_ctrl_out;
signal stat_reg : mib_status_bus;

begin

stat			<= stat_reg;
mib_ctrl		<= ctrl_reg;

process(clk)
variable dest_addr : address_fu ;
begin
	if rising_edge(clk) then
		if reset = '1' then
		--TODO:Create default value types for records!
			--dest_addr := (others => '0');
			--dest_addr_reg <= (others => '0');
		else
			ctrl_reg	<=	ctrl;
			stat_reg <= mib_stat;
			--assign default value to unused outputs
			--mib_ctrl(to_integer(unsigned(dest_addr_reg))) <= mib_ctrl_default;
		end if;
	end if;
end process;

end architecture;