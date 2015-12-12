--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Top module for 32 X 32 Bitonic sorter                                            +
--                                                                                  +
-- File : BitonicTop.vhd                                                            +
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

library work;
use work.glbSharedTypes.all;

entity BitonicTop is 
  port (
    inp_vector : in  bitonStageBus_t;
    out_vector : out bitonStageBus_t
  );
end entity;

architecture Behaviour of BitonicTop is
    signal wire_out_1 : bitonStageBus_t;
    signal wire_out_2 : bitonStageBus_t;
    signal wire_out_3 : bitonStageBus_t;
    signal wire_out_4 : bitonStageBus_t;
begin
      swapInst_1: entity work.BitonicStage1Swap(Behaviour) port map (inp_vector => inp_vector,out_vector => wire_out_1);
      swapInst_2: entity work.BitonicStage2Swap(Behaviour) port map (inp_vector => wire_out_1,out_vector => wire_out_2);
      swapInst_3: entity work.BitonicStage3Swap(Behaviour) port map (inp_vector => wire_out_2,out_vector => wire_out_3);
      swapInst_4: entity work.BitonicStage4Swap(Behaviour) port map (inp_vector => wire_out_3,out_vector => wire_out_4);
      swapInst_5: entity work.BitonicStage5Swap(Behaviour) port map (inp_vector => wire_out_4,out_vector => out_vector);
end architecture;
