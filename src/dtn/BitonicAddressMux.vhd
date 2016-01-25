--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The module feeds invalid address to the sorter for incomplete inputs					+
--																												+
-- File : BitonicAddressMux.vhd																		+
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.glbSharedTypes.all;

entity BitonicAddressMux is
	port(
		inp_vector : in  bitonStageBus_t;
		out_vector : out bitonStageBus_t
	);
end entity;

architecture Behaviour of BitonicAddressMux is	
begin
	gen_main:for i in 0 to FU_INPUT_W generate
					out_vector(i).vld			<= inp_vector(i).vld;
					out_vector(i).address 	<= InvAddr(i) when (inp_vector(i).vld = '0') else inp_vector(i).address ;
					out_vector(i).data    	<= inp_vector(i).data ;
					out_vector(i).fifoIdx   <= inp_vector(i).fifoIdx ;
				end generate;
end architecture;