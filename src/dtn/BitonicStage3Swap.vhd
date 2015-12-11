
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 8 X 8 ascending swappers of stage-3                                              +
--                                                                                  +
-- File : BitonicStage3Swap.vhd                                                     +
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

library work;
use work.glbSharedTypes.all;

entity BitonicStage3Swap is
  port (
	inp_vector : in  bitonStageBus_t;
	out_vector : out bitonStageBus_t
  );
end entity;

architecture Behaviour of BitonicStage3Swap is

    signal wire_out : bitonStageBus_t;

begin

  -- 4 x 4 Ascending swappers 
  gen_3_1_1: for i in 0 to FU_INPUT_W/8 generate
      swapInst: entity work.SwapAsc(Behaviour) port map ( inp_a  => inp_vector( 8*i),
					                  inp_b  => inp_vector((8*i) + 7),
					       		  out_a  => wire_out  ( 8*i) ,
					       	          out_b  => wire_out  ((8*i) + 7));
  end generate;
  
  gen_3_1_2: for i in 0 to FU_INPUT_W/8 generate
      swapInst: entity work.SwapAsc(Behaviour) port map ( inp_a  => inp_vector((8*i) + 1),
					                  inp_b  => inp_vector((8*i) + 6),
					       		  out_a  => wire_out  ((8*i) + 1) ,
					       	          out_b  => wire_out  ((8*i) + 6));
  end generate;
  
  gen_3_1_3: for i in 0 to FU_INPUT_W/8 generate
      swapInst: entity work.SwapAsc(Behaviour) port map ( inp_a  => inp_vector((8*i) + 2),
					                  inp_b  => inp_vector((8*i) + 5),
					       		  out_a  => wire_out  ((8*i) + 2) ,
					       	          out_b  => wire_out  ((8*i) + 5));
  end generate;

  gen_3_1_4: for i in 0 to FU_INPUT_W/8 generate
      swapInst: entity work.SwapAsc(Behaviour) port map ( inp_a  => inp_vector((8*i) + 3),
					                  inp_b  => inp_vector((8*i) + 4),
					       		  out_a  => wire_out  ((8*i) + 3) ,
					       	          out_b  => wire_out  ((8*i) + 4));
  end generate;

end architecture;