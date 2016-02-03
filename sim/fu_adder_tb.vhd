library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.glbSharedTypes.ALL;
use work.fifo_pkg.ALL;
use work.alu_components.ALL;

  ENTITY fu_alu_tb IS
  END fu_alu_tb;

  ARCHITECTURE behavior OF fu_alu_tb IS 

			signal clk : std_logic := '0';
			signal rst : std_logic := '0';
			signal en : std_logic := '0';
			signal rw : std_logic := '0';
			signal valid_inst : std_logic := '0';
         signal inp : sorterIOVector_t;
			signal busy : std_logic := '0';
			constant clk_period : time := 10 ns;

  BEGIN

  -- Component Instantiation
          uut: fu_adder PORT MAP(
                  clk 			=> clk,
						rst 			=> rst,
						en  			=> en,
						rw 			=> rw,
						valid_inst	=> valid_inst,
						inp			=> inp,
						busy			=> busy
          );


		clk_process :process
		begin
				clk <= '0';
				wait for clk_period/2;
				clk <= '1';
				wait for clk_period/2;
		end process;
  
		tb : PROCESS
		BEGIN
			inp		<= (address => "00000", data => X"00000000", fifoIdx =>'0' );
			rst		<= '1';
			wait for 20 ns;
			rst 		<= '0';
			en			<=	'1';
			rw			<= '1';
			inp		<= ( address => "00000", data => X"FFEEFFEE", fifoIdx => '0' );
			wait for 10 ns;
			inp		<= ( address => "00000", data => X"AABBAABB", fifoIdx => '1' );
			wait for 10 ns;
			en			<= '0';
			wait for 10 ns;
			valid_inst <= '1';
			wait for 10 ns;
			valid_inst <= '0';
			wait;
		END PROCESS tb;

  END;
