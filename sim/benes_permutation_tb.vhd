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
	CONSTANT ZERO: data_word :=
		(DATA_WIDTH-1 downto 0 => '0');
	CONSTANT ONE: data_word :=
		(DATA_WIDTH-1 downto 1 => '0',
		 0 => '1');
	
	SIGNAL inputs: data_message_array(0 TO (SIZE - 1)) :=
		(OTHERS => (data => ZERO,
		            src  => (fu => (OTHERS => '0'), buff => (OTHERS => '0')),
		            dest => (fu => (OTHERS => '0'), buff => (OTHERS => '0'))));
	SIGNAL outputs: data_message_array(0 TO (SIZE - 1)) :=
		(OTHERS => (data => ZERO,
		            src  => (fu => (OTHERS => '0'), buff => (OTHERS => '0')),
		            dest => (fu => (OTHERS => '0'), buff => (OTHERS => '0'))));
	
	SIGNAL clk: STD_LOGIC;
	
	constant clk_period : time := 10 ns;
BEGIN
	uut: ENTITY work.benes_permutation GENERIC MAP(LOG_SIZE, '0') PORT MAP(inputs, outputs);
	
	test: PROCESS BEGIN
		iterations: FOR iteration IN 0 TO SIZE-1 LOOP
			-- pre-input sanity check
			IF (iteration mod 2) = 0 THEN
				assert outputs(iteration/2).data = ZERO report "pre-input mismatch!";
			ELSE
				assert outputs((size/2) + (iteration/2)).data = ZERO report "pre-input mismatch!";
			END IF;
			
			-- change one input
			wait for clk_period;
			inputs(iteration).data <= ONE;
			wait for clk_period;
			
			-- check inverse perfect shuffle permutation output
			IF (iteration mod 2) = 0 THEN
				assert outputs(iteration/2).data = ONE report "post-mismatch!";
			ELSE
				assert outputs((size/2) + (iteration/2)).data = ONE report "postmismatch!";
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
