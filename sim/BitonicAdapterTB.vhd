library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.common.all;

entity BitonicAdapterTB is 
end entity;

architecture Behaviour of BitonicAdapterTB is
	signal	clk_period_s		: time := 40ns;
	signal	clk_s			: std_logic := '0';
	signal	reset_s			: std_logic := '0';
	signal	in_data_packets_s	: data_packets_t;
	signal	out_data_packets_s	: data_packets_t;

	--data sets
	  constant  des_addr_1 : testVector_t := (16,1,4,2,29,3,7,8,9,28,10,30,11,20,24,12,13,26,14,15,17,18,19,21,22,23,25,27,31,5,6,0);
 	  constant  src_addr_1 : testVector_t := (16,1,4,2,29,3,7,8,9,28,10,30,11,20,24,12,13,26,14,15,17,18,19,21,22,23,25,27,31,5,6,0);
	  constant  vld_vector_1 : validVector_t    := ('1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1',
															'1','1','1','1','1','1','1','1','1');
	-- Randomn case : some inputs are valid
	  constant  des_addr_2 : testVector_t := (0,1,4,2,29,3,7,8,9,28,10,30,11,20,24,12,13,26,14,15,17,18,19,21,22,23,25,27,31,5,6,16);
	  constant  src_addr_2 : testVector_t := (0,1,4,2,29,3,7,8,9,28,10,30,11,20,24,12,13,26,14,15,17,18,19,21,22,23,25,27,31,5,6,16);
	  constant  vld_vector_2 : validVector_t    := ('0','0','0','0','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1',
															'1','1','1','1','1','1','1','1','0');
	-- Worst case : all inputs are invalid
	  constant  des_addr_3 : testVector_t := (4,1,16,2,29,3,7,8,9,28,10,30,11,20,24,12,13,26,14,15,17,18,19,21,22,23,25,27,31,5,6,0);
	  constant  src_addr_3 : testVector_t := (4,1,16,2,29,3,7,8,9,28,10,30,11,20,24,12,13,26,14,15,17,18,19,21,22,23,25,27,31,5,6,0);
	  constant  vld_vector_3 : validVector_t    := ('0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0',
															'0','0','0','0','0','0','0','0','0');
begin
	BitonicAdapter_Inst : entity work.BitonicAdapter(Behaviour) port
				map ( 	clk => clk_s,
					reset => reset_s,
					in_data_packets => in_data_packets_s,
					out_data_packets => out_data_packets_s );

	clk_p : process begin
		wait for clk_period_s / 2;
		clk_s <= not clk_s;
	end process;
	
		main_p : process begin
--		wait for 500 ns;
--			reset_s <= '0';
--		for i in 0 to 31 loop
--			in_data_packets_s(i).valid		<= vld_vector_1(i);
--			in_data_packets_s(i).message.dest.fu 	<= std_logic_vector(to_unsigned(des_addr_1(i),5));
--			in_data_packets_s(i).message.src.fu 	<= std_logic_vector(to_unsigned(src_addr_1(i),5));
--			in_data_packets_s(i).message.data	<= std_logic_vector(to_unsigned(0,32));
--			in_data_packets_s(i).message.dest.buff 	<= '1';
--			in_data_packets_s(i).message.src.buff 	<= '1';
--		end loop;
		wait for 500 ns;
			reset_s <= '0';
		for i in 0 to 31 loop
			in_data_packets_s(i).valid		<= vld_vector_2(i);
			in_data_packets_s(i).message.dest.fu 	<= std_logic_vector(to_unsigned(des_addr_2(i),5));
			in_data_packets_s(i).message.src.fu 	<= std_logic_vector(to_unsigned(src_addr_2(i),5));
			in_data_packets_s(i).message.data	<= std_logic_vector(to_unsigned(0,32));
			in_data_packets_s(i).message.dest.buff 	<='1';
			in_data_packets_s(i).message.src.buff 	<='1';
		end loop;
--		wait for 500 ns;
--			reset_s <= '0';
--		for i in 0 to 31 loop
--			in_data_packets_s(i).valid		<= vld_vector_3(i);
--			in_data_packets_s(i).message.dest.fu 	<= std_logic_vector(to_unsigned(des_addr_3(i),5));
--			in_data_packets_s(i).message.src.fu 	<= std_logic_vector(to_unsigned(src_addr_3(i),5));
--			in_data_packets_s(i).message.data	<= std_logic_vector(to_unsigned(0,32));
--			in_data_packets_s(i).message.dest.buff 	<= '1';
--			in_data_packets_s(i).message.src.buff 	<= '1';
--		end loop;
		wait for 20 ns;
	end process;

end architecture;