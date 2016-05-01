LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;


ENTITY benes_switchcolumn_in IS
	GENERIC (
		log_size: INTEGER := 3; -- given as log2(number of elements)
		log_size_network: INTEGER := 3
	);
	
	PORT (
		clk: IN STD_LOGIC;
		rst: IN STD_LOGIC;
		inputs: IN data_port_sending_array(0 TO 2**log_size - 1);
		inputs_fb: OUT data_port_receiving_array(0 TO 2**log_size - 1);
		outputs: OUT data_port_sending_array(0 TO ((2**log_size) - 1));
		outputs_fb: IN data_port_receiving_array(0 TO ((2**log_size) - 1))
	);
	
	CONSTANT size: INTEGER := 2**log_size;
END benes_switchcolumn_in;

ARCHITECTURE benes_switchcolumn_in OF benes_switchcolumn_in IS
	SUBTYPE taken_vector IS STD_LOGIC_VECTOR(size-1 DOWNTO 0);
	-- ((n/2)+1)xn matrix for reservation
	TYPE taken_matrix IS ARRAY((size/2) DOWNTO 0) OF taken_vector; -- N+1
	
	-- There are two arrays of std_logic_vector that pass through all input switches:
	-- One to register data values going to the upper subnetwork
	-- and one to register data values going down
	-- These are used to reduce/eliminate conflicts in later stages.
	SIGNAL up_reservation, down_reservation: taken_matrix;
	
	-- Reservations for stalled data are applied before other
	SIGNAL up_stalled_reservation, down_stalled_reservation: taken_matrix;
	
	
BEGIN
	up_reservation(0) <= up_stalled_reservation(0);
	down_reservation(0) <= down_stalled_reservation(0);
	
	up_stalled_reservation((size/2)) <= (OTHERS => '0');
	down_stalled_reservation((size/2)) <= (OTHERS => '0');
	
	switches: FOR I IN 0 TO (size/2)-1 GENERATE
		switch: ENTITY work.benes_switch_in
			GENERIC MAP(log_size, log_size_network) -- '0' is normal permutation
			PORT MAP(clk, rst,
			         inputs((I*2) TO (I*2)+1), inputs_fb((I*2) TO (I*2)+1),
			         outputs((I*2) TO (I*2)+1), outputs_fb((I*2) TO (I*2)+1),
			         up_stalled_reservation(I+1), up_stalled_reservation(I),
			         down_stalled_reservation(I+1), down_stalled_reservation(I),
			         up_reservation(I), up_reservation(I+1),
			         down_reservation(I), down_reservation(I+1));
	END GENERATE switches;
END benes_switchcolumn_in;
