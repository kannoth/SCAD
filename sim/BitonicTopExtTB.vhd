library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

library work;
use work.glbSharedTypes.all;

entity BitonicExtTopTB is
end entity;

architecture Behaviour of BitonicExtTopTB is
  type      testVector_t 	is array (0 to FU_INPUT_W) of integer range 0 to 63;
  type      vldVector_t 	is array (0 to FU_INPUT_W) of std_logic;
  signal		clk_s			 : std_logic := '0';
  signal		reset_s		 : std_logic := '0';
  signal 	clk_period 	 : time := 20ns;
  signal    inp_vector_s : bitonStageBus_t;
  signal    out_vector_s : bitonStageBus_t;
	-- Best case : all inputs are valid
  constant  testVector_1 : testVector_t := (16,1,4,2,29,3,7,8,9,28,10,30,11,20,24,12,13,26,14,15,17,18,19,21,22,23,25,27,31,5,6,0);
  constant  vld_vector_1 : validVector_t    := ('1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1',
															'1','1','1','1','1','1','1','1','1');
	-- Randomn case : some inputs are valid and some are invalid
  constant  testVector_2 : testVector_t := (16,1,4,2,29,3,7,8,9,28,10,30,11,20,24,12,13,26,14,15,17,18,19,21,22,23,25,27,31,5,6,0);
  constant  vld_vector_2 : validVector_t    := ('0','0','0','0','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1',
															'1','1','1','1','1','1','1','1','0');
	-- Worst case : all inputs are invalid
  constant  testVector_3 : testVector_t := (16,1,4,2,29,3,7,8,9,28,10,30,11,20,24,12,13,26,14,15,17,18,19,21,22,23,25,27,31,5,6,0);
  constant  vld_vector_3 : validVector_t    := ('0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0',
															'0','0','0','0','0','0','0','0','0');
begin
	swapInst: entity work.BitonicExtTop(Behaviour) port map (clk => clk_s, reset => reset_s,vld_vector => vld_vector_1, inp_vector => inp_vector_s,out_vector => out_vector_s);
	clk_p  : process begin
			clk_s <= not clk_s;
			wait for clk_period/2;
	end process;
	main_p : process begin
		wait for 500 ns;
			reset_s <= '0';
		for i in 0 to 31 loop
			--inp_vector_s(i).vld		<= vld_vector_1(i);
			inp_vector_s(i).tarAddr <= std_logic_vector(to_unsigned(testVector_1(i),6));
			inp_vector_s(i).srcAddr <= std_logic_vector(to_unsigned(testVector_1(i),5));
			inp_vector_s(i).data	   <= std_logic_vector(to_unsigned(0,5));
			inp_vector_s(i).fifoIDX <= std_logic_vector(to_unsigned(0,1));
		end loop;
		wait for 500 ns;
			reset_s <= '0';
		for i in 0 to 31 loop
			--inp_vector_s(i).vld		<= vld_vector_2(i);
			inp_vector_s(i).tarAddr <= std_logic_vector(to_unsigned(testVector_2(i),6));
			inp_vector_s(i).srcAddr <= std_logic_vector(to_unsigned(testVector_1(i),5));
			inp_vector_s(i).data	   <= std_logic_vector(to_unsigned(0,5));
			inp_vector_s(i).fifoIDX <= std_logic_vector(to_unsigned(0,1));
		end loop;
		wait for 500 ns;
			reset_s <= '0';
		for i in 0 to 31 loop
			--inp_vector_s(i).vld		<= vld_vector_3(i);
			inp_vector_s(i).tarAddr <= std_logic_vector(to_unsigned(testVector_3(i),6));
			inp_vector_s(i).srcAddr <= std_logic_vector(to_unsigned(testVector_1(i),5));
			inp_vector_s(i).data	   <= std_logic_vector(to_unsigned(0,5));
			inp_vector_s(i).fifoIDX <= std_logic_vector(to_unsigned(0,1));
		end loop;
		wait for 20 ns;
	end process;
end architecture;
