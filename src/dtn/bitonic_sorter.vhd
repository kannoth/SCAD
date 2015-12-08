
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use work.dtn_global.ALL;



entity bitonic_sorter is
	port ( input_lines : in io_array;
			 output_lines: out io_array
		);	
end bitonic_sorter;

architecture RTL of bitonic_sorter is


signal bm2_out : io_array;
signal bm4_out : io_array;
signal bm8_out : io_array;
signal bm16_out : io_array;
signal bm32_out : io_array;
begin

--Generate asceding BM2 set

GEN_BM2:
for i in 0 to (NUM_ITEMS/2 - 1) generate
	
	BM2_ASC : if (i mod 2) = 0 generate BM2_ASC_X : comp_ascending port map(input_lines(2*i),input_lines(2*i+1),bm2_out(2*i),bm2_out(2*i+1));
	end generate BM2_ASC;
	
	BM2_DES : if (i mod 2) = 1 generate BM2_DES_X : comp_descending port map(input_lines(2*i),input_lines(2*i+1),bm2_out(2*i),bm2_out(2*i+1));
	end generate BM2_DES;
	
end generate GEN_BM2;

output_lines <= bm2_out;
end RTL;

