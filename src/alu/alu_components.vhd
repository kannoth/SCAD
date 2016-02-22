library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.common.ALL;


--Component declaration for ALU elements with 2 operands and 1 result. Future or customized types declarations will be made on a seperate file!
--Interface consists of two inputs with length of FU_DATA_W, 1 output as the same length of the inputs,a valid signal(output) which must be asserted
--by the ALU component for one cycle duration to signal operation completion and enable signal(input) as strobe. Enable signal is asserted by the functional
--unit when both inputs of the ALU is in stable state. All components should be synchronized with FU clock.
package alu_components is 

component adder is
    Port ( 	clk : in std_logic;
				op1 : in  std_logic_vector (FU_DATA_W-1 downto 0);
				op2 : in  std_logic_vector (FU_DATA_W-1 downto 0);
				en	: in 	std_logic;
				res : out  std_logic_vector (FU_DATA_W-1 downto 0);
				valid : out std_logic);
end component;

component subtractor is
    Port ( 	clk : in std_logic;
				op1 : in  std_logic_vector (FU_DATA_W-1 downto 0);
				op2 : in  std_logic_vector (FU_DATA_W-1 downto 0);
				en		: in 	std_logic;
				res : out  std_logic_vector (FU_DATA_W-1 downto 0);
				valid : out std_logic);
end component;


--Let's forget about multiplication for now
component multiplier is
  Port (
    a : in std_logic_vector(8 downto 0);
    b : in std_logic_vector(8 downto 0);
    p : out std_logic_vector(17 downto 0)
  );
end component;


component fu_adder is
	 Generic ( 	fu_addr 		: address_fu := (others => '0');
					fu_type		: fu_alu_type := ADD );

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