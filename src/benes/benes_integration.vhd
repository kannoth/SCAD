LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;


ENTITY benes_integration IS
	PORT (
		clk: IN STD_LOGIC;
		rst: IN STD_LOGIC
	);
	
	CONSTANT log_size: INTEGER := 5;
	CONSTANT size: INTEGER := 2**log_size;
END benes_integration;

ARCHITECTURE benes_integration OF benes_integration IS
	-- data network connections
	SIGNAL fu_to_data: data_port_sending_array(0 TO size-1);
	SIGNAL fu_to_data_fb: data_port_receiving_array(0 TO size-1);
	SIGNAL data_to_fu: data_port_sending_array(0 TO size-1);
	SIGNAL data_to_fu_fb: data_port_receiving_array(0 TO size-1);
	
	-- mib connections
	SIGNAL mib_ctrl_to_fu: mib_ctrl_out;
	SIGNAL mib_fu_to_ctrl: mib_status_bus;
	
	-- TODO: ROM connection signals
	-- TODO: Memory connection signals
	
BEGIN
	--control: ENTITY work.ctrl
	--	PORT MAP(clk, rst,
	--	         fu_to_data(1), fu_to_data_fb(1),
	--	         data_to_fu(1), data_to_fu_fb(1),
	--	         mib_ctrl_to_fu, mib_fu_to_ctrl);
	-- TODO: ROM
	
	
	-- instantiate data network
	data_network: ENTITY work.benes_network
		GENERIC MAP (log_size, log_size)
		PORT MAP(clk, rst, fu_to_data, fu_to_data_fb, data_to_fu, data_to_fu_fb);
	
	
	--fu_adder: ENTITY work.fu_alu
	--	GENERIC MAP(std_logic_vector(to_unsigned(1, 5)), ADD)
	--	PORT MAP(clk,
	--	         rst,
	--	         mib_ctrl_to_fu,
	--	         mib_fu_to_ctrl(1),
	--	         data_to_fu_fb(1), data_to_fu(1),
	--	         fu_to_data_fb(1), fu_to_data(1));
	
	
	-- TODO: Other FUs
	-- TODO: Memory

END benes_integration;
