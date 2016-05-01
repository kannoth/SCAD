--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 4 X 4 ascending swappers of stage-2                                              +
--                                                                                  +
-- File : BitonicStage2Swap.vhd                                                     +
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

library work;
use work.common.all;

entity BitonicStage2Swap is
  port (
	inp_vector : in  bitonStageBus_t;
	out_vector : out bitonStageBus_t
  );
end entity;

architecture Behaviour of BitonicStage2Swap is

    signal wire_out : bitonStageBus_t;

begin

  -- 4 x 4 Ascending swappers 
  gen_2_1: for i in 0 to FU_INPUT_W/4 generate
      swapInst_1: entity work.SwapAsc(Behaviour) port map ( inp_a  => inp_vector( 4*i),
					                  inp_b  => inp_vector((4*i) + 3),
					       		  out_a  => wire_out  ( 4*i) ,
					       	          out_b  => wire_out  ((4*i) + 3));
  end generate;
  
  gen_2_2: for i in 0 to FU_INPUT_W/4 generate
      swapInst_2: entity work.SwapAsc(Behaviour) port map ( inp_a  => inp_vector((4*i) + 1),
					                  inp_b  => inp_vector((4*i) + 2),
					       		  out_a  => wire_out  ((4*i) + 1),
					       	          out_b  => wire_out  ((4*i) + 2));
  end generate;
  
  gen_2_3: for i in 0 to FU_INPUT_W/2 generate
      swapInst_3: entity work.SwapAsc(Behaviour) port map ( inp_a  => wire_out  ( 2*i),
					                  inp_b  => wire_out  ((2*i) + 1),
					       		  out_a  => out_vector( 2*i) ,
					       	          out_b  => out_vector((2*i) + 1));
  end generate;

end architecture;