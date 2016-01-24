library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.glbSharedTypes.ALL;

--This module controls access to ram banks. It serializes the load/store accesses.
--Writes have priority,in case of read/write request to same address in a cycle
entity bank_controller is
    Port ( 	clk  		: in std_logic;
			rst			: in std_logic;
			re  		: in std_logic;		
			we  		: in std_logic;		
			r_addr 		: in  std_logic_vector (MEM_ADDR_LENGTH-MEM_SELECT_BITLENGTH-1 downto 0);
			w_addr 		: in  std_logic_vector (MEM_ADDR_LENGTH-MEM_SELECT_BITLENGTH-1 downto 0);
			re_out  	: out std_logic;		
			we_out  	: out std_logic;
			busy		: out std_logic );
end bank_controller;

architecture RTL of bank_controller is

signal reg_busy 			: boolean := FALSE;
signal reg_re_out 			: std_logic := '0';
signal reg_wr_out 			: std_logic := '0';
signal reg_read_addr 		: std_logic_vector(r_addr'range) := (others =>'0');



begin

reg_busy <= (re = '1' and we = '1' and r_addr = w_addr);
busy 		<= '1' when reg_busy = TRUE else '0';
re_out 		<= reg_re_out;
we_out		<= reg_wr_out;



--busy_gen_proc: process(clk)
--begin
--	if rising_edge(clk) then
--		reg_busy <= (re = '1' and we = '1' and r_addr = w_addr);
--	end if;
--end process;

read_proc: process(clk)
begin
	if rising_edge(clk) then
		reg_read_addr <= r_addr;
		if rst = '1' then
			reg_re_out <= '0';
		elsif re = '1' then
			if reg_busy = TRUE then
				reg_re_out <= '0';
			else
				reg_re_out <= '1';
			end if;
		else
			reg_re_out <= '0';
		end if;
	end if;
end process;

write_proc: process(clk)
begin
	if rising_edge(clk) then
		if rst = '1' then
			reg_wr_out <= '0';
		elsif we = '1' then
			reg_wr_out <= '1';
		else
			reg_wr_out <= '0';
		end if;
	end if;
end process;


end RTL;
