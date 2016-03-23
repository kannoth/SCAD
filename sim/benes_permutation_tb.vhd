LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;
USE work.instruction.ALL;


ENTITY benes_permutation_tb IS
END benes_permutation_tb;

ARCHITECTURE benes_permutation_tb OF benes_permutation_tb IS
	CONSTANT LOG_SIZE: INTEGER := 5;
	CONSTANT SIZE: INTEGER := 2**LOG_SIZE;
	CONSTANT ZERO: data_port_sending := (
		message => (
			src => (fu => (OTHERS => '0'), buff => '0'),
			dest => (fu => (OTHERS => '0'), buff => '0'),
			data => (OTHERS => '0')),
		valid => '0');
	CONSTANT ONE: data_port_sending := (
		message => (
			src => (fu => (OTHERS => '1'), buff => '1'),
			dest => (fu => (OTHERS => '1'), buff => '1'),
			data => (OTHERS => '1')),
		valid => '1');
	
	SIGNAL inputs: data_port_sending_array(0 TO (SIZE - 1)) :=
		(OTHERS => ZERO);
	SIGNAL inputs_fb: data_port_receiving_array(0 TO (SIZE - 1)) :=
		(OTHERS => (OTHERS => '0'));
	SIGNAL outputs: data_port_sending_array(0 TO (SIZE - 1)) :=
		(OTHERS => ONE);
	SIGNAL outputs_fb: data_port_receiving_array(0 TO (SIZE - 1)) :=
		(OTHERS => (OTHERS => '0'));
	
	SIGNAL clk: STD_LOGIC;
	
	constant clk_period : time := 10 ns;
BEGIN
	uut: ENTITY work.benes_permutation
		GENERIC MAP(LOG_SIZE, '0')
		PORT MAP(inputs, inputs_fb, outputs, outputs_fb);
	
	test: PROCESS BEGIN
		wait for clk_period; -- wait for stuff to settle?
		
		iterations: FOR iteration IN 0 TO SIZE-1 LOOP
			-- pre-input sanity check
			IF (iteration mod 2) = 0 THEN
				assert outputs(iteration/2) = ZERO
					report "pre-input mismatch! i=" & integer'image(iteration);
			ELSE
				assert outputs((size/2) + (iteration/2)) = ZERO
					report "pre-input mismatch! i=" & integer'image(iteration);
			END IF;
			
			-- change one input
			wait for clk_period;
			inputs(iteration) <= ONE;
			wait for clk_period;
			
			-- check inverse perfect shuffle permutation output
			IF (iteration mod 2) = 0 THEN
				assert outputs(iteration/2) = ONE
					report "post-mismatch!" & integer'image(iteration);
			ELSE
				assert outputs((size/2) + (iteration/2)) = ONE
					report "postmismatch!" & integer'image(iteration);
			END IF;
			
		END LOOP;
		
		wait;
	END PROCESS;
	
	clk_proc: PROCESS BEGIN
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
	END PROCESS;
END benes_permutation_tb;
