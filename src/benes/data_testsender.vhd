LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


LIBRARY work;
USE work.common.ALL;


ENTITY data_testsender IS
	GENERIC (
		src: INTEGER; -- given as log2(number of elements)
		dest: INTEGER; -- given as log2(number of elements)
		data: INTEGER -- given as log2(number of elements)
	);
	
	PORT (
		clk: IN STD_LOGIC;
		rst: IN STD_LOGIC;
		output: OUT data_port_sending;
		output_fb: IN data_port_receiving
	);
END data_testsender;

ARCHITECTURE data_testsender OF data_testsender IS
	SIGNAL outreg: data_port_sending;
	CONSTANT PORTZERO: data_port_sending := (
		valid => '0',
		message => (
			data => (OTHERS => '0'),
			src => (fu => (OTHERS => '0'), buff => '0'),
			dest => (fu => (OTHERS => '0'), buff => '0'))
		);
	CONSTANT TO_SEND: data_port_sending := (
		valid => '1',
		message => (
			data => (std_logic_vector(to_unsigned(data, DATA_WIDTH))),
			src => (
				fu => (std_logic_vector(to_unsigned(src, ADDRESS_FU_WIDTH))),
				buff => '0'),
			dest => (
				fu => (std_logic_vector(to_unsigned(dest, ADDRESS_FU_WIDTH))),
				buff => '0')
			)
		);
BEGIN
	output <= outreg;
	behaviour: PROCESS(clk)
	BEGIN
		IF rising_edge(clk) THEN
			-- is_read signals should be reset every cycle
			IF rst = '1' THEN
				outreg <= TO_SEND;
			ELSE
				IF output_fb.is_read = '1' THEN
					outreg <= PORTZERO;
				END IF;
			END IF;
		END IF;
	END PROCESS;
END data_testsender;

