--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Adapter module for standard interfaces									
-- Underlying module is 5 stage piplined 32 X 32 bitonic sorter										
-- IOs are adapted to package common																
--																												
-- File : BitonicAdapter.vhd																		
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.common.all;


entity BitonicAdapter is
	port (
		clk 	: in std_logic;
		reset	: in std_logic;
		in_data_packets	: in data_packets_t;
		out_data_packets	: out data_packets_t
	);
end entity;

architecture Behaviour of BitonicAdapter is
	signal	adapterPortFrom_s : data_packets_t;
	signal	adapterPortToIn_s : bitonStageBus_t;
	signal	adapterPortToOut_s: bitonStageBus_t;
begin
	BitonicTopInst : entity work.BitonicTop(Behaviour) 
							port map (
								clk	=> clk,
								reset	=> reset,
								inp_vector=> adapterPortToIn_s,
								out_vector=> adapterPortToOut_s
							);
	
	GEN_ADAPTER : for i in 0 to FU_INPUT_W generate
		process ( in_data_packets,adapterPortToOut_s ) begin
			adapterPortToIn_s(i).tarAddr		<= '0' & in_data_packets(i).message.dest.fu;
			adapterPortToIn_s(i).vld		<= in_data_packets(i).valid;
			adapterPortToIn_s(i).srcAddr		<= in_data_packets(i).message.src.fu;										
			adapterPortToIn_s(i).data		<= in_data_packets(i).message.data;
			adapterPortToIn_s(i).tarfifoIdx(0)	<= in_data_packets(i).message.dest.buff;
			adapterPortToIn_s(i).srcfifoIdx(0)	<= in_data_packets(i).message.src.buff;
			-- output lines
			out_data_packets(i).valid		<=adapterPortToOut_s(i).vld;
			out_data_packets(i).message.dest.fu	<=adapterPortToOut_s(i).tarAddr(FU_ADDRESS_W-1 downto 0);
			out_data_packets(i).message.src.fu	<=adapterPortToOut_s(i).srcAddr;
			out_data_packets(i).message.data	<=adapterPortToOut_s(i).data;
			out_data_packets(i).message.dest.buff	<=adapterPortToOut_s(i).tarfifoIdx(0);
			out_data_packets(i).message.src.buff	<=adapterPortToOut_s(i).srcfifoIdx(0);
		end process;
	end generate;
	
end architecture;
