library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.math_real.all;
use work.common.all;
use work.instruction.all;


package common_component is

component MIB is
	port ( 	
			clk 			:in std_logic;
			reset			:in std_logic; 
			--Signals from/to controller
			ctrl 			: in mib_ctrl_out;
			stat 			: out mib_status_bus;
			mib_ctrl 	: out mib_ctrl_out;
			mib_stat 	: in mib_status_bus
		);
end component;

component BitonicTop is 
  port (
	 clk					: in std_logic;
	 reset				: in std_logic;
    inp_vector			: in  bitonStageBus_t;
    out_vector			: out bitonStageBus_t
  );
end component;

component ctrl is
	port(
		mem_instr		: in instruction;
		read_en_wire	: out std_logic;
		mem_addr_wire	: out data_word;
		mem_data_valid	: in std_logic;
		-- move instruction bus
		mib_out			: out mib_ctrl_out;
		fu_stalls		: in mib_status_bus;
		dtn_data_in		: in data_port_sending;
		dtn_data_out	: out data_port_sending;
		clk				: in std_logic;
		reset				: in std_logic		
	);
end component;

component rom_simple is
	PORT (
		clk				: in std_logic;
		address			: in data_word;
		read				: in std_logic;
		instr				: out instruction
	);
end component;

component Dtn32 is
	port (
		clk 		: in  std_logic;
		reset		: in  std_logic;
		packets_in32	: in  data_packets_t;
		packets_out32	: out data_packets_t
	);
end component;

end common_component;



