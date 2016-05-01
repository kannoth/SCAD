--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Asceding swapper testbench					                                          +
--                                                                                  +
-- File : SwapAscTB.vhd                                                             +
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

library work;
use work.glbSharedTypes.all;

entity SwapAscTB is
end entity;

architecture Behaviour of SwapAscTB is
	component SwapAsc is
	port(	
			inp_a : in  sorterIOVector_t;
			inp_b : in  sorterIOVector_t;
			op_a  : out sorterIOVector_t;
			op_b  : out sorterIOVector_t
	);
	end component;

	signal inp_a_s :   sorterIOVector_t;
	signal inp_b_s :   sorterIOVector_t;
	signal op_a_s  :   sorterIOVector_t;
	signal op_b_s  :   sorterIOVector_t;
begin
	UUT : SwapAsc port map(inp_a => inp_a_s ,inp_b => inp_b_s, op_a => op_a_s, op_b=> op_b_s);

	main_proc : process begin
		wait for 20 ns;
		inp_a_s.fifoIdx <= "1";
		inp_a_s.data    <= "00000";
		inp_a_s.tarAddr <= "111111";
		inp_a_s.srcAddr <= "11111";
		inp_b_s.fifoIdx <= "1";
		inp_b_s.data    <= "00000";
		inp_b_s.tarAddr <= "111110";
		inp_b_s.srcAddr <= "11110";
		wait for 20 ns;		
		inp_a_s.fifoIdx <= "1";
		inp_a_s.data    <= "00000";
		inp_a_s.tarAddr <= "111100";
		inp_a_s.srcAddr <= "11100";
		inp_b_s.fifoIdx <= "1";
		inp_b_s.data    <= "00000";
		inp_b_s.tarAddr <= "111110";
		inp_b_s.srcAddr <= "11110";
		wait for 20 ns;
		
		wait;
	end process;
end architecture;
