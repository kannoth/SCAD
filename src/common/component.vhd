library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.math_real.all;
use work.common.all;


package common_component is

component MIB is
	port ( 	
			clk 		:in std_logic;
			rst			:in std_logic; 
			--Signals from/to controller
			ctrl 		: in mib_ctrl_out;
			stat 		: out mib_stalls;
			mib_ctrl 	: out mib_ctrl_bus;
			mib_stat 	: in mib_status_bus
		);
end component;
end common_component;



