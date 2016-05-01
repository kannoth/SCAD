library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.common.all;

entity BitonicExtTop is 
	port (
			clk 			: in std_logic;
			reset			: in std_logic;
			vld_vector	: in 	validVector_t;
    		inp_vector	: in  bitonStageBus_t;
    		out_vector	: out bitonStageBus_t		
	);
end entity;

architecture Behaviour of BitonicExtTop is
	signal wire  : bitonStageBus_t;
begin
	bitonAddrMuxInst:entity	work.BitonicAddressMux(Behaviour)port map(vld_vector => vld_vector, inp_vector => inp_vector, out_vector => wire );
	bitonNetworkInst:entity	work.BitonicTop(Behaviour)port map(clk => clk, reset => reset, inp_vector => wire , out_vector => out_vector);
end architecture;
