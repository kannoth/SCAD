library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

use work.common.all;

entity BanyanSwitch is
	generic ( idx : natural);
	port(	
			inp_a  : in  data_port_sending;
			inp_b  : in  data_port_sending;
			out_a  : out data_port_sending;
			out_b  : out data_port_sending
	);
end entity;

architecture RTL of BanyanSwitch is
begin
	comb_main_proc : process ( inp_a, inp_b ) begin
		if inp_a.valid = '0' then
			if inp_b.message.dest.fu(idx) = '0' then
				out_a <= inp_b;
				out_b <= inp_a;
			else
				out_a <= inp_a;
				out_b <= inp_b;
			end if;
		elsif inp_b.valid = '0' then
			if inp_a.message.dest.fu(idx) = '0' then
				out_a <= inp_a;
				out_b <= inp_b;
			else
				out_a <= inp_b;
				out_b <= inp_a;
			end if;
		elsif inp_b.message.dest.fu(idx) = '0' then
			out_a <= inp_b;
			out_b <= inp_a;
		else
			out_a <= inp_a;
			out_b <= inp_b;
		end if;
	end process;

end architecture; 