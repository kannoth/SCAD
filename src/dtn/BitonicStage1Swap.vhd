--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 2 X 2 ascending swappers of stage-1                                              +
--                                                                                  +
-- File : BitonicStage1Swap.vhd                                                     +
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

library work;
use work.glbSharedTypes.all;

entity BitonicStage1Swap is
  port (
	inp_vector : in bitonStageBus_t;
	out_vector : out bitonStageBus_t
  );
end entity;

architecture Behaviour of BitonicStage1Swap is

begin

  -- 2 x 2 Ascending swappers 
  gen: for i in 0 to FU_INPUT_W/2 generate
      swapInst: entity work.SwapAsc(Behaviour) port map ( inp_a  => inp_vector( 2*i),
					                  inp_b  => inp_vector((2*i) + 1),
					       		  out_a  => out_vector( 2*i) ,
					       	          out_b  => out_vector((2*i) + 1));
  end generate;

end architecture;