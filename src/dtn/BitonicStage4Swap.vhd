--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 16 X 16 ascending swappers of stage-4                                            +
--                                                                                  +
-- File : BitonicStage4Swap.vhd                                                     +
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

library work;
use work.glbSharedTypes.all;

entity BitonicStage4Swap is
  port (
	inp_vector : in  bitonStageBus_t;
	out_vector : out bitonStageBus_t
  );
end entity;

architecture Behaviour of BitonicStage4Swap is

    signal wire_out_1 : bitonStageBus_t;
    signal wire_out_2 : bitonStageBus_t;
    signal wire_out_3 : bitonStageBus_t;

begin

  gen_4_1:for j in 0 to FU_INPUT_W/4 generate
    gen_4_1_1: for i in 0 to FU_INPUT_W/16 generate
	swapInst_1: entity work.SwapAsc(Behaviour) port map ( inp_a  => inp_vector((16*i) + j ),
							      inp_b  => inp_vector((16*i) + (15-j)),
							      out_a  => wire_out_1((16*i) + j ),
							      out_b  => wire_out_1((16*i) + (15-j)));
      end generate;
   end generate;
 
  gen_4_2:for j in 0 to FU_INPUT_W/8 generate
    gen_4_2_1: for i in 0 to FU_INPUT_W/8 generate
      swapInst_10: entity work.SwapAsc(Behaviour) port map ( inp_a  => wire_out_1((8*i) + j),
					                     inp_b  => wire_out_1((8*i) + j + 4),
					       		     out_a  => wire_out_2((8*i) + j),
					       	             out_b  => wire_out_2((8*i) + j + 4));
      end generate;
  end generate;
  
  gen_4_3:for j in 0 to FU_INPUT_W/16 generate
    gen_4_3_1: for i in 0 to FU_INPUT_W/4 generate
      swapInst_11: entity work.SwapAsc(Behaviour) port map ( inp_a  => wire_out_2((4*i) + j),
					                     inp_b  => wire_out_2((4*i) + 2 + j),
					       		     out_a  => wire_out_3((4*i) + j),
         				       	             out_b  => wire_out_3((4*i) + 2 + j));
      end generate;   				       	             
  end generate;

   gen_4_3_3: for i in 0 to FU_INPUT_W/2 generate
     swapInst_14: entity work.SwapAsc(Behaviour) port map ( inp_a  => wire_out_3( 2*i),
					                    inp_b  => wire_out_3((2*i) + 1),
					       		    out_a  => out_vector( 2*i),
					       	            out_b  => out_vector((2*i) + 1));					       	            
  end generate;
  
end architecture;