library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_unsigned.all;
library work;
use work.common.ALL;
use work.alu_components.ALL;
use work.buf_pkg.ALL;
use work.common_component.ALL;
use work.mem_components.ALL;
use work.instruction.all;


entity top_level is 
  port (
	 clk			: in std_logic;
	 reset		: in std_logic
  );
end entity;

architecture RTL of top_level is

signal controller_mib_out 	: mib_ctrl_out;
signal controller_mib_in 	: mib_status_bus;
signal mib_out		 			: mib_ctrl_out;
signal mib_bus_in			 	: mib_status_bus;
signal instruction_next		: instruction;
signal instruction_mem_re		: std_logic;
signal instruction_mem_addr	: data_word;
signal instruction_mem_valid	: std_logic := '1'; --for now, assume every instruction is valid
signal dtn_in						: data_packets_t;
signal dtn_out						: data_packets_t;
signal memory_in				: mem_inp_port;
signal memory_out				: mem_out_port;
signal reg_dtn_data_in 		: data_port_sending;
signal reg_dtn_data_out 	: data_port_sending;

begin

--Instantiate MIB
	mib_instance : MIB port map (
		clk		=> clk,
		reset 		=> reset,
		ctrl 		=> controller_mib_out,
		stat		=> controller_mib_in,
		mib_ctrl	=> mib_out,
		mib_stat	=>	mib_bus_in
	);

--Instantiate controller
	ctrl_instance : ctrl port map (
		clk 				=> clk,
		reset 			=> reset,
		mib_out 			=> controller_mib_out,
		fu_stalls 		=> controller_mib_in,
		mem_instr		=> instruction_next,
		read_en_wire 	=> instruction_mem_re,
		mem_addr_wire 	=> instruction_mem_addr,
		mem_data_valid => instruction_mem_valid,
		dtn_data_in		=> reg_dtn_data_in,
		dtn_data_out	=> reg_dtn_data_out
	);
	
--Instantiate instruction ROM
	rom_instance : rom_simple port map (
		clk 		=> clk,
		address	=>	instruction_mem_addr,
		read 		=> instruction_mem_re,
		instr		=> instruction_next
	);
	
	dtn_instance : Dtn32 port map (
		clk	=> clk,
		reset	=> reset,
		packets_in32 	=> dtn_in,
		packets_out32	=> dtn_out
	);
	
	
--Instantiate data memory unit
	mem_instance : memory_top port map (
		clk	=> clk,
		rst	=> reset,
		inp	=> memory_in,
		outp	=> memory_out
);
	
--address 0 is reserverd for controller, branch conditions are redirected to controller through dtn_in
dtn_in(0) 		<= reg_dtn_data_out;
dtn_out(0) 		<= reg_dtn_data_in;


--Instantiate 11 adder units,
ADDER_GEN: for i in 1 to 11 generate
addX : fu_alu 
		generic map ( fu_addr => std_logic_vector(to_unsigned(i, address_fu'length)), fu_type => ADD)
		port map 	(clk => clk, rst => reset, mib_inp => mib_out, status => mib_bus_in(i), ack => (is_read => '1'), dtn_data_in => dtn_out(i), dtn_data_out => dtn_in(i)) ;
end generate ADDER_GEN;

--Instantiate 12 subtractor units
SUB_GEN: for i in 12 to 23 generate
subX : fu_alu 
		generic map ( fu_addr => std_logic_vector(to_unsigned(i, address_fu'length)), fu_type => SUBTRACT)
		port map 	(clk => clk, rst => reset, mib_inp => mib_out, status => mib_bus_in(i), ack => (is_read => '1'), dtn_data_in => dtn_out(i), dtn_data_out => dtn_in(i)) ;
end generate SUB_GEN;

--Instantiate 4 load units
LOAD_GEN: for i in 0 to 3 generate
loadX : fu_load 
		generic map ( fu_addr => std_logic_vector(to_unsigned(i + 24, address_fu'length)))
		port map 	(	clk => clk, rst => reset, mib_inp => mib_out, status => mib_bus_in(i + 24), ack => (is_read => '1'), dtn_data_in => dtn_out(i + 24), dtn_data_out => dtn_in(i + 24), 
						data => memory_out(i).data_out, mem_ack => memory_out(i).r_ack, addr => memory_in(i).r_addr, re => memory_in(i).re ) ;
end generate LOAD_GEN;

--Instantiate 4 store units
STORE_GEN: for i in 0 to 3 generate
storeX : fu_store 
		generic map ( fu_addr => std_logic_vector(to_unsigned(i + 28, address_fu'length)))
		port map 	(	clk => clk, rst => reset, mib_inp => mib_out, status => mib_bus_in(i + 28), ack => (is_read => '1'), dtn_data_in => dtn_out(i + 28), 
						data => memory_in(i).data_in, mem_ack => memory_out(i).w_ack, addr => memory_in(i).w_addr, we => memory_in(i).we ) ;
end generate STORE_GEN;

--Since store units do not have output buffers, assign network inputs to default
dtn_in(28 to 31) <= (others => dtn_default);


end architecture;
