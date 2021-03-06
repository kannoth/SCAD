--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Testbench for statge 1		                                                    +
--                                                                                  +
-- File : BitonicStage1SwapTB.vhd                                                   +
--																					+
-- This testbecnh can be used to test any stage of the bitonic network				+
-- The values of the testVectpt_1 can be changed and tested.						+
-- Two additional vectors for data and fifoIDX can also be used.					+
-- Both are equated to 0 for simplicity.											+
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

library work;
use work.glbSharedTypes.all;

entity BitonicStage1SwapTB is
end entity;

architecture Behaviour of BitonicStage1SwapTB is
  type      testVector_t is array (0 to FU_INPUT_W) of integer range 0 to 31;
  signal		clk_s			 : std_logic := '0';
  signal		reset_s		 : std_logic := '0';
  signal    inp_vector_s : bitonStageBus_t;
  signal    out_vector_s : bitonStageBus_t;
  constant  testVector_1 : testVector_t := (16,1,4,2,29,3,7,8,9,28,10,30,11,20,24,12,13,26,14,15,17,18,19,21,22,23,25,27,31,5,6,0);
  
begin
	swapInst: entity work.BitonicTop(Behaviour) port map (clk => clk_s, reset => reset_s, inp_vector => inp_vector_s,out_vector => out_vector_s);

	main_p : process begin
		wait for 20 ns;
		for i in 0 to 31 loop
			inp_vector_s(i).tarAddr   <= std_logic_vector(to_unsigned(testVector_1(i),6));
			inp_vector_s(i).srcAddr   <= std_logic_vector(to_unsigned(testVector_1(i),5));
			inp_vector_s(i).data	  <= std_logic_vector(to_unsigned(0,5));
			inp_vector_s(i).fifoIDX   <= std_logic_vector(to_unsigned(0,1));
		end loop;
		wait for 20 ns;
	end process;
end architecture;
