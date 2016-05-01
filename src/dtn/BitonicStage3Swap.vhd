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
use work.common.all;

entity BitonicStage3Swap is
  port (
	inp_vector : in  bitonStageBus_t;
	out_vector : out bitonStageBus_t
  );
end entity;

architecture Behaviour of BitonicStage3Swap is

    signal wire_out_1 : bitonStageBus_t;
    signal wire_out_2 : bitonStageBus_t;

begin

  -- 4 x 4 Ascending swappers 
  gen_3_1_1: for i in 0 to FU_INPUT_W/8 generate
      swapInst_1: entity work.SwapAsc(Behaviour) port map ( inp_a  => inp_vector( 8*i),
					                    inp_b  => inp_vector((8*i) + 7),
					       		    out_a  => wire_out_1( 8*i) ,
					       	            out_b  => wire_out_1((8*i) + 7));
  end generate;
  
  gen_3_1_2: for i in 0 to FU_INPUT_W/8 generate
      swapInst_2: entity work.SwapAsc(Behaviour) port map ( inp_a  => inp_vector((8*i) + 1),
					                    inp_b  => inp_vector((8*i) + 6),
					       		    out_a  => wire_out_1((8*i) + 1) ,
					       	            out_b  => wire_out_1((8*i) + 6));
  end generate;
  
  gen_3_1_3: for i in 0 to FU_INPUT_W/8 generate
      swapInst_3: entity work.SwapAsc(Behaviour) port map ( inp_a  => inp_vector((8*i) + 2),
					                    inp_b  => inp_vector((8*i) + 5),
					       		    out_a  => wire_out_1((8*i) + 2) ,
					       	            out_b  => wire_out_1((8*i) + 5));
  end generate;

  gen_3_1_4: for i in 0 to FU_INPUT_W/8 generate
      swapInst_4: entity work.SwapAsc(Behaviour) port map ( inp_a  => inp_vector((8*i) + 3),
					                    inp_b  => inp_vector((8*i) + 4),
					       		    out_a  => wire_out_1((8*i) + 3) ,
					       	            out_b  => wire_out_1((8*i) + 4));
  end generate;

  gen_3_2_1: for i in 0 to FU_INPUT_W/4 generate
      swapInst_5: entity work.SwapAsc(Behaviour) port map ( inp_a  => wire_out_1( 4*i),
					                    inp_b  => wire_out_1((4*i) + 2),
					       		    out_a  => wire_out_2( 4*i) ,
					       	            out_b  => wire_out_2((4*i) + 2));
  end generate;
  
  gen_3_2_2: for i in 0 to FU_INPUT_W/4 generate
      swapInst_6: entity work.SwapAsc(Behaviour) port map ( inp_a  => wire_out_1((4*i) + 1),
					                    inp_b  => wire_out_1((4*i) + 3),
					       		    out_a  => wire_out_2((4*i) + 1),
					       	            out_b  => wire_out_2((4*i) + 3));
  end generate;
  
  gen_3_2_3: for i in 0 to FU_INPUT_W/2 generate
      swapInst_7: entity work.SwapAsc(Behaviour) port map ( inp_a  => wire_out_2( 2*i),
					                    inp_b  => wire_out_2((2*i) + 1),
					       		    out_a  => out_vector( 2*i) ,
					       	            out_b  => out_vector((2*i) + 1));
  end generate;
  
end architecture;