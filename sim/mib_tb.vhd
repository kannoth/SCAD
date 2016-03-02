library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.common.ALL;
use work.common_component.ALL;

entity mib_tb is
end mib_tb;

architecture testbench of mib_tb is

	constant clk_period : time := 10 ns;
	signal clk : std_logic;
	signal rst : std_logic;
	signal ctrl : mib_ctrl_out;
	signal stat : mib_stalls;
	signal mib_ctrl : mib_ctrl_bus;
	signal mib_stat : mib_status_bus;
	
  
begin

	uut: MIB port map(
		clk => clk,
		rst => rst,
		ctrl => ctrl,
		stat => stat,
		mib_ctrl => mib_ctrl,
		mib_stat => mib_stat
	);
	
	
clk_process :process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
tb_process : process
	begin
	rst <= '1';
	ctrl.valid <= '1';
	ctrl.phase <= COMMIT;
	ctrl.src <= (fu => (others => '1'), buff => '1');
	ctrl.dest <= (fu => "11111" , buff => 'X');
	wait for 5*clk_period;
	rst <= '0';
	wait for 5*clk_period;
	ctrl.dest <= (fu => "01111" , buff => 'X');
	
	wait;
	end process;

end architecture;