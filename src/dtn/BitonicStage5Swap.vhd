--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 32 X 32 ascending swappers of stage-5                                            +
--                                                                                  +
-- File : BitonicStage4Swap.vhd                                                     +
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

library work;
use work.glbSharedTypes.all;

entity BitonicStage5Swap is
  port (
	inp_vector : in  bitonStageBus_t;
	out_vector : out bitonStageBus_t
  );
end entity;

architecture Behaviour of BitonicStage5Swap is

    signal wire_out_1 : bitonStageBus_t;
    signal wire_out_2 : bitonStageBus_t;
    signal wire_out_3 : bitonStageBus_t;
    signal wire_out_4 : bitonStageBus_t;

begin

  gen_5_1  : for j in 0 to (FU_INPUT_W)/2 generate
    gen_5_1_1: for i in 0 to FU_INPUT_W/32 generate
	swapInst_1: entity work.SwapAsc(Behaviour) port map ( inp_a  => inp_vector((32*i) + j),
							      inp_b  => inp_vector((32*i) + (FU_INPUT_W - j)),
							      out_a  => wire_out_1((32*i) + j) ,
							      out_b  => wire_out_1((32*i) + (FU_INPUT_W - j)));
    end generate;
  end generate;

  gen_5_2:for j in 0 to (FU_INPUT_W/4) generate
    gen_5_2_1: for i in 0 to (FU_INPUT_W/16) generate
       swapInst_2: entity work.SwapAsc(Behaviour) port map ( inp_a  => wire_out_1((16*i) + j),
					                     inp_b  => wire_out_1((16*i) + j + 8),
					       		     out_a  => wire_out_2((16*i) + j),
					       	             out_b  => wire_out_2((16*i) + j + 8));
      end generate;
  end generate;
  
  gen_5_3:for j in 0 to FU_INPUT_W/8 generate
    gen_5_3_1: for i in 0 to FU_INPUT_W/8 generate
      swapInst_3: entity work.SwapAsc(Behaviour) port map  ( inp_a  => wire_out_2((8*i) + j),
					                     inp_b  => wire_out_2((8*i) + j + 4),
					       		     out_a  => wire_out_3((8*i) + j),
					       	             out_b  => wire_out_3((8*i) + j + 4));
      end generate;
  end generate;
  
  gen_5_4:for j in 0 to FU_INPUT_W/16 generate
    gen_5_4_1: for i in 0 to FU_INPUT_W/4 generate
      swapInst_4: entity work.SwapAsc(Behaviour) port map (  inp_a  => wire_out_3((4*i) + j),
					                     inp_b  => wire_out_3((4*i) + 2 + j),
					       		     out_a  => wire_out_4((4*i) + j),
         				       	             out_b  => wire_out_4((4*i) + 2 + j));
      end generate;   				       	             
  end generate;
  
  gen_5_5: for i in 0 to FU_INPUT_W/2 generate
     swapInst_5: entity work.SwapAsc(Behaviour) port map (  inp_a  => wire_out_4( 2*i),
					                    inp_b  => wire_out_4((2*i) + 1),
					       		    out_a  => out_vector( 2*i),
					       	            out_b  => out_vector((2*i) + 1));					       	            
  end generate;
  
end architecture;