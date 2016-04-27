LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;


ENTITY benes_halfswitch_in IS
	GENERIC (
		log_step: INTEGER := 3; -- given as log2(number of elements)
		log_size_network: INTEGER := 3
	);
	
	PORT (
		-- The input for which this halfswitch decides the routing behaviour
		input: IN data_port_sending;
		input_fb: IN data_port_receiving;
		-- reservations of signals going up or down.
		-- these are relevant for both avoiding sending multiple messages
		-- to the same destination as well as making sure the routing
		-- of companions does not produce conflicts in the output stage
		up_reserved_in: IN STD_LOGIC_VECTOR((2**log_step)-1 DOWNTO 0);
		up_reserved_out: OUT STD_LOGIC_VECTOR((2**log_step)-1 DOWNTO 0);
		down_reserved_in: IN STD_LOGIC_VECTOR((2**log_step)-1 DOWNTO 0);
		down_reserved_out: OUT STD_LOGIC_VECTOR((2**log_step)-1 DOWNTO 0);
		
		-- Which path is already blocked
		up_taken: IN STD_LOGIC;
		down_taken: IN STD_LOGIC;
		
		-- Decision for this halfswitch
		up: OUT STD_LOGIC;
		down: OUT STD_LOGIC
	);
	
	CONSTANT size: INTEGER := 2;
	CONSTANT column_size: INTEGER := 2**log_step;
END benes_halfswitch_in;


ARCHITECTURE benes_halfswitch_in OF benes_halfswitch_in IS
	-- Relevant bits of destination address - and companion
	-- The companion of an address is the address with the last bit flipped
	-- Both the address and it's companion can be routed to the same switch
	-- in the second half of the benes network if they do not take the same subnetwork
	-- in between.
	-- (concept by tripti)
	SIGNAL addr: STD_LOGIC_VECTOR(log_step-1 DOWNTO 0);
	SIGNAL companion: STD_LOGIC_VECTOR(log_step-1 DOWNTO 0);
	CONSTANT companion_mask: STD_LOGIC_VECTOR(log_step-1 DOWNTO 0) := (0 => '1', OTHERS => '0');
	
	-- Up/Down reservation by this halfswitch
	SIGNAL up_reserved, down_reserved: STD_LOGIC_VECTOR(column_size - 1 DOWNTO 0);
	-- Which bit to mark as reserved
	SIGNAL reservation_mask: STD_LOGIC_VECTOR(column_size - 1 DOWNTO 0);
	
	SIGNAL up_internal, down_internal: STD_LOGIC;


BEGIN
	-- Take relevant bits from destination addresses
	addr <= input.message.dest.fu(log_size_network-1 DOWNTO log_size_network-log_step);
	companion <= addr xor companion_mask;
	
	-- DECISION
	up_internal <= '1' WHEN (input.valid = '1' AND (input_fb.is_read = '0'))
	                         AND up_taken = '0'
	                         AND up_reserved_in(to_integer(unsigned(addr))) = '0'
	                         AND down_reserved_in(to_integer(unsigned(addr))) = '0'
	                         AND up_reserved_in(to_integer(unsigned(companion))) = '0'
	               ELSE '0';
	
	down_internal <= '1' WHEN (input.valid = '1' AND (input_fb.is_read = '0'))
	                           AND up_internal = '0'
	                           AND down_taken = '0'
	                           AND up_reserved_in(to_integer(unsigned(addr))) = '0'
	                           AND down_reserved_in(to_integer(unsigned(addr))) = '0'
	                           AND down_reserved_in(to_integer(unsigned(companion))) = '0'
	                 ELSE '0';
	
	-- Internal signals to output
	up <= up_internal;
	down <= down_internal;
	
	-- Which bit/line in the reservation to set to 1 when taking a route
	reservation_mask <= STD_LOGIC_VECTOR(
		shift_left(resize(unsigned'("1"), up_reserved_out'length),
		           to_integer(unsigned(addr))));
	
	-- halfswitch combined reservations
	--up_reserved_out <= up_reserved_in OR (reservation_mask WHEN up_internal
	 --                                     ELSE (OTHERS => '0'));
	up_reserved_out <= (up_reserved_in OR reservation_mask) WHEN up_internal = '1'
	                    ELSE up_reserved_in;
	down_reserved_out <= (down_reserved_in OR reservation_mask) WHEN down_internal = '1'
	                      ELSE down_reserved_in;
END benes_halfswitch_in;

