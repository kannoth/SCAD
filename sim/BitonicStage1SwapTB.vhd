--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Testbench for statge 1		                                                      +
--                                                                                  +
-- File : BitonicStage1SwapTB.vhd                                                   +
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
  signal inp_vector_s : bitonStageBus_t;
  signal out_vector_s: bitonStageBus_t;
begin
	swapInst: entity work.BitonicStage1Swap(Behaviour) port map (inp_vector => inp_vector_s,out_vector => out_vector_s);

	main_p : process begin
		wait for 20 ns;
		for i in 0 to 31 loop
			inp_vector_s(i).address <= std_logic_vector(to_unsigned(31 - i,5));
			inp_vector_s(i).data	<= std_logic_vector(to_unsigned(31 - i,5));
			inp_vector_s(i).fifoIDX <= std_logic_vector(to_unsigned(31 - i,1));
		end loop;
		wait for 20 ns;
	end process;
end architecture;