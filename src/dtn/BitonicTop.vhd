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
	 clk			: in std_logic;
	 reset		: in std_logic;
    inp_vector : in  bitonStageBus_t;
    out_vector : out bitonStageBus_t
  );
end entity;

architecture Behaviour of BitonicTop is
	 -- connection wires
    signal wire_out_1 : bitonStageBus_t;
    signal wire_out_2 : bitonStageBus_t;
    signal wire_out_3 : bitonStageBus_t;
    signal wire_out_4 : bitonStageBus_t;
	 signal wire_out_5 : bitonStageBus_t;
	 -- pipeline registers
	 signal reg_1 	 : bitonStageBus_t;
	 signal reg_2 	 : bitonStageBus_t;
	 signal reg_3 	 : bitonStageBus_t;
	 signal reg_4 	 : bitonStageBus_t;
	 signal reg_5 	 : bitonStageBus_t;
begin
      swapInst_1: entity work.BitonicStage1Swap(Behaviour) port map (inp_vector => reg_1		,out_vector => wire_out_1);
      swapInst_2: entity work.BitonicStage2Swap(Behaviour) port map (inp_vector => reg_2		,out_vector => wire_out_2);
      swapInst_3: entity work.BitonicStage3Swap(Behaviour) port map (inp_vector => reg_3		,out_vector => wire_out_3);
      swapInst_4: entity work.BitonicStage4Swap(Behaviour) port map (inp_vector => reg_4		,out_vector => wire_out_4);
      swapInst_5: entity work.BitonicStage5Swap(Behaviour) port map (inp_vector => reg_5		,out_vector => out_vector);
		-- 5 stage pipeline
		stage_proc : process ( clk ) begin
		
			if rising_edge(clk) then
				if reset = '1' then
					reg_1	<=	pRegDefVal;
					reg_2	<= pRegDefVal;	
					reg_3	<=	pRegDefVal;
					reg_4	<=	pRegDefVal;
					reg_5	<=	pRegDefVal;
				else
					reg_1	<= inp_vector;
					reg_2	<= wire_out_1;
					reg_3	<= wire_out_2;
					reg_4	<= wire_out_3;
					reg_5	<= wire_out_4;
				end if;
			end if;
			
		end process;
end architecture;
