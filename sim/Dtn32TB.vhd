library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

library work;
use work.common.all;

entity Dtn32TB is
	--port (
		--clk 		: in  std_logic;
		--reset		: in  std_logic;
		--packets_in32	: in  data_packets_t;
		--packets_out32	: out data_packets_t
	--);
end entity;

architecture Behaviour of Dtn32TB is
		signal clk_period		:time 		:= 40 ns;
		signal clk_s 			:std_logic  := '0';
		signal reset_s			:std_logic  := '1';
		signal packets_in32_s	:data_packets_t;
		signal packets_out32_s	:data_packets_t;
		
	  constant  des_addr_1   : testVector_t := (16,1,4,2,29,3,7,8,9,28,10,30,11,20,24,12,13,26,14,15,17,18,19,21,22,23,25,27,31,5,6,0);
 	  constant  src_addr_1   : testVector_t := (16,1,4,2,29,3,7,8,9,28,10,30,11,20,24,12,13,26,14,15,17,18,19,21,22,23,25,27,31,5,6,0);
	  constant  vld_vector_1 : std_logic_vector(FU_DATA_W-1  downto 0) := x"ffffffff";
				--00000000000000000000000000000001											
	-- Randomn case : some inputs are valid
	  constant  des_addr_2 	 : testVector_t := (0,1,4,2,29,3,7,8,9,28,10,30,11,20,24,12,13,26,14,15,17,18,19,21,22,23,25,27,31,5,6,16);
	  constant  src_addr_2 	 : testVector_t := (0,1,4,2,29,3,7,8,9,28,10,30,11,20,24,12,13,26,14,15,17,18,19,21,22,23,25,27,31,5,6,16);
	  constant  vld_vector_2 : std_logic_vector(FU_DATA_W-1  downto 0) := "01111111111111111111111111110000";
	-- Worst case : all inputs are invalid
	  constant  des_addr_3   : testVector_t := (4,1,16,2,29,3,7,8,9,28,10,30,11,20,24,12,13,26,14,15,17,18,19,21,22,23,25,27,31,5,6,0);
	  constant  src_addr_3   : testVector_t := (4,1,16,2,29,3,7,8,9,28,10,30,11,20,24,12,13,26,14,15,17,18,19,21,22,23,25,27,31,5,6,0);
	  constant  vld_vector_3 : std_logic_vector(FU_DATA_W-1  downto 0) := x"00000000";
																																									
begin
	UUT : entity work.Dtn32(Behaviour) port map(	clk 		=> clk_s,
							reset		=> reset_s,
							packets_in32	=> packets_in32_s ,
							packets_out32	=> packets_out32_s);
								
								
	clk_p : process begin
		wait for clk_period / 2;
		clk_s <= not clk_s;
	end process;
	
	stim_p : process begin
		reset_s <= '1';
		wait for clk_period *4 ;
			reset_s <= '0';
			for i in 0 to 31 loop
				packets_in32_s(i).valid			<= vld_vector_1(i);
				packets_in32_s(i).message.dest.fu 	<= std_logic_vector(to_unsigned(des_addr_1(i),5));
				packets_in32_s(i).message.src.fu 	<= std_logic_vector(to_unsigned(src_addr_1(i),5));
				packets_in32_s(i).message.data		<= std_logic_vector(to_unsigned(0,32));
				packets_in32_s(i).message.dest.buff 	<='1';
				packets_in32_s(i).message.src.buff 	<='1';
			end loop;
		wait for clk_period *4 ;
			for i in 0 to 31 loop
				packets_in32_s(i).valid			<= vld_vector_2(i);
				packets_in32_s(i).message.dest.fu 	<= std_logic_vector(to_unsigned(des_addr_2(i),5));
				packets_in32_s(i).message.src.fu 	<= std_logic_vector(to_unsigned(src_addr_2(i),5));
				packets_in32_s(i).message.data		<= std_logic_vector(to_unsigned(0,32));
				packets_in32_s(i).message.dest.buff 	<='1';
				packets_in32_s(i).message.src.buff 	<='1';
			end loop;
		wait for clk_period *4 ;
			for i in 0 to 31 loop
				packets_in32_s(i).valid			<= vld_vector_3(i);
				packets_in32_s(i).message.dest.fu 	<= std_logic_vector(to_unsigned(des_addr_3(i),5));
				packets_in32_s(i).message.src.fu 	<= std_logic_vector(to_unsigned(src_addr_3(i),5));
				packets_in32_s(i).message.data		<= std_logic_vector(to_unsigned(0,32));
				packets_in32_s(i).message.dest.buff 	<='1';
				packets_in32_s(i).message.src.buff 	<='1';
			end loop;
		wait;
	end process;
								
end architecture;
