LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;


ENTITY benes_switch_in IS
	GENERIC (
		log_step: INTEGER := 3; -- given as log2(number of elements)
		log_size_network: INTEGER := 3
	);
	
	PORT (
		clk: IN STD_LOGIC;
		rst: IN STD_LOGIC;
		inputs: IN data_port_sending_array(0 TO 1);
		inputs_fb: OUT data_port_receiving_array(0 TO 1);
		outputs: OUT data_port_sending_array(0 TO 1);
		outputs_fb: IN data_port_receiving_array(0 TO 1);
		up_in: IN STD_LOGIC_VECTOR((2**log_step)-1 DOWNTO 0);
		up_out: OUT STD_LOGIC_VECTOR((2**log_step)-1 DOWNTO 0);
		down_in: IN STD_LOGIC_VECTOR((2**log_step)-1 DOWNTO 0);
		down_out: OUT STD_LOGIC_VECTOR((2**log_step)-1 DOWNTO 0)
	);
	
	CONSTANT size: INTEGER := 2;
	CONSTANT column_size: INTEGER := 2**log_step;
END benes_switch_in;


ARCHITECTURE benes_switch_in OF benes_switch_in IS
	CONSTANT PORTZERO: data_port_sending := (
		valid => '0',
		message => (
			data => (OTHERS => '0'),
			src => (fu => (OTHERS => '0'), buff => '0'),
			dest => (fu => (OTHERS => '0'), buff => '0')
		)
	);
	
	SIGNAL stalls: STD_LOGIC_VECTOR(0 TO 1);

	SIGNAL reservation_mask_stall_up, reservation_mask_stall_down: STD_LOGIC_VECTOR((2**log_step)-1 DOWNTO 0);
	
	-- reservations including stalls at output
	SIGNAL up_reserved_stalled, down_reserved_stalled: STD_LOGIC_VECTOR((2**log_step)-1 DOWNTO 0);
	-- reservations including first halfswitch
	SIGNAL up_reserved_first, down_reserved_first: STD_LOGIC_VECTOR((2**log_step)-1 DOWNTO 0);
	
	-- Halfswitch decisions:
	SIGNAL first_up, first_down, second_up, second_down: STD_LOGIC;
	-- output regiters, only part that is written on clock edge
	SIGNAL output_regs: data_port_sending_array(0 TO 1) := (OTHERS => PORTZERO);
	
	SIGNAL inputs_fb_regs: data_port_receiving_array(0 TO 1) := (OTHERS => (is_read => '0'));


BEGIN
	stalls <= (output_regs(0).valid AND (NOT outputs_fb(0).is_read),
	           output_regs(1).valid AND (NOT outputs_fb(1).is_read));
	
	-- Reservation for output registers
	-- TODO: There are cases where this leads to conflicts
	--       (No catastrophic failure, but not entirely good either.)
	reservation_mask_stall_up <= STD_LOGIC_VECTOR(
		shift_left(resize(unsigned'("1"), up_in'length),
		           to_integer(unsigned(output_regs(0).message.dest.fu))));
	reservation_mask_stall_down <= STD_LOGIC_VECTOR(
		shift_left(resize(unsigned'("1"), up_in'length),
		           to_integer(unsigned(output_regs(1).message.dest.fu))));
	up_reserved_stalled <= (up_in OR reservation_mask_stall_up) WHEN stalls(0) = '1'
	                        ELSE up_in;
	down_reserved_stalled <= (down_in OR reservation_mask_stall_down) WHEN stalls(1) = '1'
	                          ELSE down_in;
	
	
	first_half: ENTITY work.benes_halfswitch_in
		GENERIC MAP (log_step, log_size_network)
		PORT MAP(inputs(0), inputs_fb_regs(0),
		         up_reserved_stalled, up_reserved_first,
		         down_reserved_stalled, down_reserved_first,
		         stalls(0), stalls(1),
		         first_up, first_down);
	
	second_half: ENTITY work.benes_halfswitch_in
		GENERIC MAP (log_step, log_size_network)
		PORT MAP(inputs(1), inputs_fb_regs(1),
		         up_reserved_first, up_out,
		         down_reserved_first, down_out,
		         stalls(0) OR first_up, stalls(1) OR first_down,
		         second_up, second_down);
	
	
	-- Registers to outputs
	outputs <= output_regs;
	inputs_fb <= inputs_fb_regs;
	
	clocked: PROCESS(clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF rst = '1' THEN
				inputs_fb_regs <= (OTHERS => (is_read => ('0')));
				output_regs <= (OTHERS => PORTZERO);
			ELSE
				-- Acknowledge messages that are passed on
				inputs_fb_regs <= (0 => (is_read => (first_up OR first_down)),
				                   1 => (is_read => (second_up OR second_down)));
				
				
				-- Upper output
				IF first_up = '1' THEN
					output_regs(0) <= inputs(0);
				ELSIF second_up = '1' THEN
					output_regs(0) <= inputs(1);
				ELSIF outputs_fb(0).is_read = '1' THEN
					output_regs(0) <= PORTZERO;
				END IF;
				-- ELSE: keep last output
				
				-- Lower output
				IF first_down = '1' THEN
					output_regs(1) <= inputs(0);
				ELSIF second_down = '1' THEN
					output_regs(1) <= inputs(1);
				ELSIF outputs_fb(1).is_read = '1' THEN
					output_regs(1) <= PORTZERO;
				END IF;
				-- ELSE: keep last output
			END IF;
		END IF;
	END PROCESS clocked;
	
	-- TODO HERE BE REDUNDANT CODE
	-- outputs <= inputs;
	-- inputs_fb <= outputs_fb;
END benes_switch_in;

