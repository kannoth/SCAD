library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;
use work.mem_components.ALL;

entity memory_top is 
	Port (
		clk 		: in std_logic;
		rst 		: in std_logic;
		inp		: in mem_inp_port;
		outp		: out mem_out_port
	);
end memory_top;

architecture RTL of memory_top is

type bc_ram_signal is record
	re_out 	: std_logic;
	we_out 	: std_logic;
	busy 		: std_logic;
end record;

type bc_ram_signal_type is array (0 to MEM_NR_ELEMENTS-1) of bc_ram_signal;

signal bc_to_ram_sig_array : bc_ram_signal_type;

begin
GEN: for i in 0 to MEM_NR_ELEMENTS-1 generate
	controllerX : bank_controller port map (clk => clk, rst => rst, re => inp(i).re, we => inp(i).we, 
		r_addr => inp(i).r_addr, w_addr => inp(i).w_addr, re_out => bc_to_ram_sig_array(i).re_out,
		we_out => bc_to_ram_sig_array(i).we_out, busy => bc_to_ram_sig_array(i).busy);
		
	ramX : ram port map ( clk => clk, rst => rst, re => bc_to_ram_sig_array(i).re_out,
		we => bc_to_ram_sig_array(i).we_out, r_addr => inp(i).r_addr, w_addr => inp(i).w_addr,
		data_in => inp(i).data_in, r_ack => outp(i).r_ack, w_ack => outp(i).w_ack,
		data_out => outp(i).data_out);
end generate GEN;
	
end RTL;