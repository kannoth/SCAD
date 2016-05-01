--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Data Trasport Network 									
-- 									
-- BitonicSorter -> BanyanCube															
--																												
-- File : Dtn32.vhd																		
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.common.all;

entity Dtn32 is
	port (
		clk 		: in  std_logic;
		reset		: in  std_logic;
		packets_in32	: in  data_packets_t;
		packets_out32	: out data_packets_t
	);
end entity;

architecture Behaviour of Dtn32 is
	signal packetReg32 : data_packets_t;
begin
	BitonicAdapterInst : entity work.BitonicAdapter(Behaviour) port map (	clk 		 => clk,
										reset 		 => reset,
										in_data_packets  => packets_in32 ,
										out_data_packets => packetReg32 );
	BanyanCubeInst	   : entity work.BanyanNetwork (RTL) 	   port map (	clk 		 => clk, 
										reset		 => reset,
										in_data_packets  => packetReg32 ,
										out_data_packets => packets_out32 );
end architecture;
