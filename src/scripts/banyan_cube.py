

class SE():
	def __init__(self, inp_a, inp_b, out_a, out_b):
		self.inp_a = inp_a
		self.inp_b = inp_b
		self.out_a = out_a
		self.out_b = out_b
	def __repr__(self):
		return "I1:%s, I2:%s" % (self.inp_a, self.inp_b)



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
	
def gen_vhdl(nr_of_stages):
	
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
	for j in range (0,num_elements):
		cmd_list.append("signal stage%s_sig%s : data_port_sending;" % (0,j))
	for i in range(1,nr_of_stages+1):
		for k in range (0,num_elements):
			cmd_list.append("signal stage%s_sig%s : data_port_sending;" % (i,k))
	cmd_list.append("\n\nbegin\n\n")
	cmd_list.append("--Input,output port assignments\n\n")
	for j in range (0,num_elements):
		cmd_list.append("stage0_sig%s \t<= in_data_packets(%s);" % (j,j))
	for j in range (0,num_elements):
		cmd_list.append("out_data_packets(%s) \t<= stage%s_sig%s;" % (j,nr_of_stages,j))
	cmd_list.append("\n\n")
	for i in range(0,nr_of_stages):
		inp_base = "stage%s" % i
		out_base = "stage%s" % (i+1)
		for j in range(0, num_elements/2):
			cmd_list.append("STAGE%s_SWITCH%s : entity work.BanyanSwitch(RTL)\n\tgeneric map(idx => %s)\n\t port map(" % (i,j,nr_of_stages-1-i))
			cmd_list.append("\t%s_sig%s,%s_sig%s"			
			",%s_sig%s,%s_sig%s);\n" % (inp_base,stages[i][j].inp_a,
			inp_base,stages[i][j].inp_b,out_base,stages[i][j].out_a,out_base,
			stages[i][j].out_b))
	cmd_list.append("\n\nend architecture;\n\n")
	file = open("banyan_cube.vhdl",'w')
	for l in cmd_list:
		file.write(l + "\n")
	file.close()
		
			