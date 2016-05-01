class SE():
	def __init__(self, inp_a, inp_b, out_a, out_b):
		self.inp_a = inp_a
		self.inp_b = inp_b
		self.out_a = out_a
		self.out_b = out_b

def gen_network(nr_of_stages):
	stage_list = []
	num_elements = pow(2,nr_of_stages)
	for idx in range(nr_of_stages-1, -1, -1):
		switch_list = []
		inp_list = (list(range(0,num_elements)))
		while len(inp_list) > 0:
			elem=inp_list[0]
			pair = elem | (1 << idx)
			s = SE(elem,pair,elem,pair)
			switch_list.append(s)
			inp_list.remove(elem)
			inp_list.remove(pair)
		stage_list.append(switch_list)
	return stage_list
	
def gen_vhdl(nr_of_stages,is_pipelined):
	
	cmd_list=[]
	num_elements = pow(2,nr_of_stages)
	stages = gen_network(nr_of_stages)
	cmd_list.append("library IEEE;")
	cmd_list.append("use IEEE.STD_LOGIC_1164.ALL;\n"
	"use IEEE.NUMERIC_STD.ALL;\nuse work.common.ALL;")
	cmd_list.append("entity BanyanNetwork is")
	cmd_list.append("\tport (\n\t\tclk 	: in std_logic;\n\t\treset	: in std_logic;\n"
	"\t\tin_data_packets	: in data_packets_t;\n"
	"\t\tout_data_packets	: out data_packets_t);\nend entity;")
	cmd_list.append("architecture RTL of BanyanNetwork is\n\n")
	cmd_list.append("--wiring signals")
	for i in range(0,nr_of_stages):
		cmd_list.append("signal stage%s_sig : data_packets_t;" % i)
	if is_pipelined == True:
		for i in range(0,nr_of_stages):
			cmd_list.append("signal stage%s_reg : data_packets_t;" % i)
	cmd_list.append("\n\nbegin\n\n")
	cmd_list.append("--Input,output port assignments\n\n")
	if is_pipelined == False:
		cmd_list.append("stage0_sig \t<= in_data_packets;")
	cmd_list.append("\n\n")
	src = "reg" if is_pipelined == True else "sig";
	for i in range(0,nr_of_stages-1):
		inp_base = "stage%s" % i
		out_base = "stage%s" % (i+1) if i != nr_of_stages-1 else "out_data_packets";
		for j in range(0, num_elements/2):
			cmd_list.append("STAGE%s_SWITCH%s : entity work.BanyanSwitch(RTL)\n\tgeneric map(idx => %s)\n\t port map(" % (i,j,nr_of_stages-1-i))
			cmd_list.append("\t%s_%s(%s),%s_%s(%s)"			
			",%s_sig(%s),%s_sig(%s));\n" % (inp_base,src,stages[i][j].inp_a,
			inp_base,src,stages[i][j].inp_b,out_base,stages[i][j].out_a,out_base,
			stages[i][j].out_b))
	inp_base = "stage%s" % (nr_of_stages-1)
	out_base = "out_data_packets";
	for j in range(0, num_elements/2):
			cmd_list.append("STAGE%s_SWITCH%s : entity work.BanyanSwitch(RTL)\n\tgeneric map(idx => %s)\n\t port map(" % (nr_of_stages-1,j,0))
			cmd_list.append("\t%s_%s(%s),%s_%s(%s)"			
			",%s(%s),%s(%s));\n" % (inp_base,src,stages[nr_of_stages-1][j].inp_a,
			inp_base,src,stages[nr_of_stages-1][j].inp_b,out_base,stages[nr_of_stages-1][j].out_a,out_base,
			stages[nr_of_stages-1][j].out_b))	
	
	cmd_list.append("\n\n")
	if is_pipelined == True:
		cmd_list.append("pipe_proc: process(clk)\n\tbegin")
		cmd_list.append("\t\tif rising_edge(clk) then")
		cmd_list.append("\t\t\tif reset = '1' then")
		cmd_list.append("\t\t\t\tnull;")
		cmd_list.append("\t\t\telse")
		cmd_list.append("\t\t\t\tstage0_reg \t<= in_data_packets;")
		for i in range(1,nr_of_stages):
			cmd_list.append("\t\t\t\tstage%s_reg \t<= stage%s_sig;" % (i,i))
		cmd_list.append("\t\t\tend if;")
		cmd_list.append("\t\tend if;")
		cmd_list.append("\tend process;")
		
	cmd_list.append("\n\nend architecture;\n\n")
	file = open("banyan_cube.vhdl",'w')
	for l in cmd_list:
		file.write(l + "\n")
	file.close()
		
			