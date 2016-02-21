--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Asceding swapper 					                                                   +
--                                                                                  +
-- File : SwapAsc.vhd                                                               +
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

library work;
use work.glbSharedTypes.all;

entity SwapAsc is
	port(	
			inp_a  : in  sorterIOVector_t;
			inp_b  : in  sorterIOVector_t;
			out_a  : out sorterIOVector_t;
			out_b  : out sorterIOVector_t
	);
end entity;

architecture Behaviour of SwapAsc is
begin
	comb_main_proc : process ( inp_a, inp_b ) begin
		if inp_a.tarAddr > inp_b.tarAddr then
			out_a <= inp_b;
			out_b <= inp_a;
		else
			out_a <= inp_a;
			out_b <= inp_b;
		end if;
	end process;
end architecture;
