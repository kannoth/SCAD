-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  USE work.dtn_global.ALL;

  ENTITY comparator_tb IS
  END comparator_tb;

  ARCHITECTURE behavior OF comparator_tb IS 

  -- Component Declaration
		COMPONENT comp_ascending 

			port(
				data_in_1			: in fu_type;
				data_in_2			: in fu_type;
				data_out_1			: out fu_type;
				data_out_2			: out fu_type
			);
		 END COMPONENT;
	
		 signal data_in_1 : fu_type;
		 signal data_in_2 : fu_type;
		 signal data_out_1 : fu_type;
		 signal data_out_2 : fu_type;
		 
		 constant clk_period : time := 10 ns;
			 
          

  BEGIN

		 uut: comp_ascending PORT MAP(
					data_in_1 => data_in_1,
					data_in_2 => data_in_2,
					data_out_1 => data_out_1,
					data_out_2 => data_out_2
		 );
		 



     tb : PROCESS
     BEGIN
	  wait for 100 ns;
	  data_in_1.address 		<= "01111";
	  data_in_1.data 			<= X"FFEE0011";
	  data_in_1.buf_select 	<= "00111";
	  
	  data_in_2.address 		<= "00111";
	  data_in_2.data 			<= X"00000011";
	  data_in_2.buf_select 	<= "00111";
	  
	  wait for 100 ns;
	  data_in_1.address 		<= "00011";
	  data_in_1.data 			<= X"12345678";
	  data_in_1.buf_select 	<= "00111";
	  
	  data_in_2.address 		<= "00111";
	  data_in_2.data 			<= X"ABCDEF0";
	  data_in_2.buf_select 	<= "00111";
	  
	  wait for 100 ns;
	  wait;
     END PROCESS tb;


  END;
