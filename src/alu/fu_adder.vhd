library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.glbSharedTypes.ALL;
use work.fifo_pkg.ALL;
use work.common.ALL;

entity fu_adder is

    Port ( 		clk	 		: in std_logic;
					rst			: in std_logic;
					-- signals from MIB
					inp 			: in mib_ctrl_out;
					-- signals to MIB
					status		: out mib_stalls;
					--signals from DTN
					data_in		: in data_port_receiving;
					--signals to DTN
					data_out		: out data_port_sending
         );
end fu_adder;


architecture Structural of fu_adder is


end Structural;

