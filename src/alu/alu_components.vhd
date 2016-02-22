library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.common.ALL;

package alu_components is 

component adder is
    Port ( op1 : in  signed (FU_DATA_W-1 downto 0);
           op2 : in  signed (FU_DATA_W-1 downto 0);
           res : out  signed (FU_DATA_W-1 downto 0));
end component;

component subtractor is
    Port ( op1 : in  signed (FU_DATA_W-1 downto 0);
           op2 : in  signed (FU_DATA_W-1 downto 0);
           res : out  signed (FU_DATA_W-1 downto 0));
end component;

component multiplier is
  Port (
    a : in std_logic_vector(8 downto 0);
    b : in std_logic_vector(8 downto 0);
    p : out std_logic_vector(17 downto 0)
  );
end component;


component fu_adder is
	 Generic ( 	fu_addr 		: address_fu := (others => '0') );

    Port ( 		clk	 		: in std_logic;
					rst			: in std_logic;
					-- signals from MIB
					mib_inp 		: in mib_ctrl_out;
					-- signals to MIB
					status		: out mib_stalls;
					--signals from DTN
					ack			: in data_port_receiving;
					dtn_data_in	: in data_port_sending;
					--signals to DTN
					dtn_data_out: out data_port_sending
         );
end component;
  

end alu_components;