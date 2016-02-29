library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;
entity BanyanNetwork is
	port (
		clk 	: in std_logic;
		reset	: in std_logic;
		in_data_packets	: in data_packets_t;
		out_data_packets	: out data_packets_t);
end entity;
architecture RTL of BanyanNetwork is


--wiring signals
signal stage0_sig0 : data_port_sending;
signal stage0_sig1 : data_port_sending;
signal stage0_sig2 : data_port_sending;
signal stage0_sig3 : data_port_sending;
signal stage0_sig4 : data_port_sending;
signal stage0_sig5 : data_port_sending;
signal stage0_sig6 : data_port_sending;
signal stage0_sig7 : data_port_sending;
signal stage0_sig8 : data_port_sending;
signal stage0_sig9 : data_port_sending;
signal stage0_sig10 : data_port_sending;
signal stage0_sig11 : data_port_sending;
signal stage0_sig12 : data_port_sending;
signal stage0_sig13 : data_port_sending;
signal stage0_sig14 : data_port_sending;
signal stage0_sig15 : data_port_sending;
signal stage0_sig16 : data_port_sending;
signal stage0_sig17 : data_port_sending;
signal stage0_sig18 : data_port_sending;
signal stage0_sig19 : data_port_sending;
signal stage0_sig20 : data_port_sending;
signal stage0_sig21 : data_port_sending;
signal stage0_sig22 : data_port_sending;
signal stage0_sig23 : data_port_sending;
signal stage0_sig24 : data_port_sending;
signal stage0_sig25 : data_port_sending;
signal stage0_sig26 : data_port_sending;
signal stage0_sig27 : data_port_sending;
signal stage0_sig28 : data_port_sending;
signal stage0_sig29 : data_port_sending;
signal stage0_sig30 : data_port_sending;
signal stage0_sig31 : data_port_sending;
signal stage1_sig0 : data_port_sending;
signal stage1_sig1 : data_port_sending;
signal stage1_sig2 : data_port_sending;
signal stage1_sig3 : data_port_sending;
signal stage1_sig4 : data_port_sending;
signal stage1_sig5 : data_port_sending;
signal stage1_sig6 : data_port_sending;
signal stage1_sig7 : data_port_sending;
signal stage1_sig8 : data_port_sending;
signal stage1_sig9 : data_port_sending;
signal stage1_sig10 : data_port_sending;
signal stage1_sig11 : data_port_sending;
signal stage1_sig12 : data_port_sending;
signal stage1_sig13 : data_port_sending;
signal stage1_sig14 : data_port_sending;
signal stage1_sig15 : data_port_sending;
signal stage1_sig16 : data_port_sending;
signal stage1_sig17 : data_port_sending;
signal stage1_sig18 : data_port_sending;
signal stage1_sig19 : data_port_sending;
signal stage1_sig20 : data_port_sending;
signal stage1_sig21 : data_port_sending;
signal stage1_sig22 : data_port_sending;
signal stage1_sig23 : data_port_sending;
signal stage1_sig24 : data_port_sending;
signal stage1_sig25 : data_port_sending;
signal stage1_sig26 : data_port_sending;
signal stage1_sig27 : data_port_sending;
signal stage1_sig28 : data_port_sending;
signal stage1_sig29 : data_port_sending;
signal stage1_sig30 : data_port_sending;
signal stage1_sig31 : data_port_sending;
signal stage2_sig0 : data_port_sending;
signal stage2_sig1 : data_port_sending;
signal stage2_sig2 : data_port_sending;
signal stage2_sig3 : data_port_sending;
signal stage2_sig4 : data_port_sending;
signal stage2_sig5 : data_port_sending;
signal stage2_sig6 : data_port_sending;
signal stage2_sig7 : data_port_sending;
signal stage2_sig8 : data_port_sending;
signal stage2_sig9 : data_port_sending;
signal stage2_sig10 : data_port_sending;
signal stage2_sig11 : data_port_sending;
signal stage2_sig12 : data_port_sending;
signal stage2_sig13 : data_port_sending;
signal stage2_sig14 : data_port_sending;
signal stage2_sig15 : data_port_sending;
signal stage2_sig16 : data_port_sending;
signal stage2_sig17 : data_port_sending;
signal stage2_sig18 : data_port_sending;
signal stage2_sig19 : data_port_sending;
signal stage2_sig20 : data_port_sending;
signal stage2_sig21 : data_port_sending;
signal stage2_sig22 : data_port_sending;
signal stage2_sig23 : data_port_sending;
signal stage2_sig24 : data_port_sending;
signal stage2_sig25 : data_port_sending;
signal stage2_sig26 : data_port_sending;
signal stage2_sig27 : data_port_sending;
signal stage2_sig28 : data_port_sending;
signal stage2_sig29 : data_port_sending;
signal stage2_sig30 : data_port_sending;
signal stage2_sig31 : data_port_sending;
signal stage3_sig0 : data_port_sending;
signal stage3_sig1 : data_port_sending;
signal stage3_sig2 : data_port_sending;
signal stage3_sig3 : data_port_sending;
signal stage3_sig4 : data_port_sending;
signal stage3_sig5 : data_port_sending;
signal stage3_sig6 : data_port_sending;
signal stage3_sig7 : data_port_sending;
signal stage3_sig8 : data_port_sending;
signal stage3_sig9 : data_port_sending;
signal stage3_sig10 : data_port_sending;
signal stage3_sig11 : data_port_sending;
signal stage3_sig12 : data_port_sending;
signal stage3_sig13 : data_port_sending;
signal stage3_sig14 : data_port_sending;
signal stage3_sig15 : data_port_sending;
signal stage3_sig16 : data_port_sending;
signal stage3_sig17 : data_port_sending;
signal stage3_sig18 : data_port_sending;
signal stage3_sig19 : data_port_sending;
signal stage3_sig20 : data_port_sending;
signal stage3_sig21 : data_port_sending;
signal stage3_sig22 : data_port_sending;
signal stage3_sig23 : data_port_sending;
signal stage3_sig24 : data_port_sending;
signal stage3_sig25 : data_port_sending;
signal stage3_sig26 : data_port_sending;
signal stage3_sig27 : data_port_sending;
signal stage3_sig28 : data_port_sending;
signal stage3_sig29 : data_port_sending;
signal stage3_sig30 : data_port_sending;
signal stage3_sig31 : data_port_sending;
signal stage4_sig0 : data_port_sending;
signal stage4_sig1 : data_port_sending;
signal stage4_sig2 : data_port_sending;
signal stage4_sig3 : data_port_sending;
signal stage4_sig4 : data_port_sending;
signal stage4_sig5 : data_port_sending;
signal stage4_sig6 : data_port_sending;
signal stage4_sig7 : data_port_sending;
signal stage4_sig8 : data_port_sending;
signal stage4_sig9 : data_port_sending;
signal stage4_sig10 : data_port_sending;
signal stage4_sig11 : data_port_sending;
signal stage4_sig12 : data_port_sending;
signal stage4_sig13 : data_port_sending;
signal stage4_sig14 : data_port_sending;
signal stage4_sig15 : data_port_sending;
signal stage4_sig16 : data_port_sending;
signal stage4_sig17 : data_port_sending;
signal stage4_sig18 : data_port_sending;
signal stage4_sig19 : data_port_sending;
signal stage4_sig20 : data_port_sending;
signal stage4_sig21 : data_port_sending;
signal stage4_sig22 : data_port_sending;
signal stage4_sig23 : data_port_sending;
signal stage4_sig24 : data_port_sending;
signal stage4_sig25 : data_port_sending;
signal stage4_sig26 : data_port_sending;
signal stage4_sig27 : data_port_sending;
signal stage4_sig28 : data_port_sending;
signal stage4_sig29 : data_port_sending;
signal stage4_sig30 : data_port_sending;
signal stage4_sig31 : data_port_sending;
signal stage5_sig0 : data_port_sending;
signal stage5_sig1 : data_port_sending;
signal stage5_sig2 : data_port_sending;
signal stage5_sig3 : data_port_sending;
signal stage5_sig4 : data_port_sending;
signal stage5_sig5 : data_port_sending;
signal stage5_sig6 : data_port_sending;
signal stage5_sig7 : data_port_sending;
signal stage5_sig8 : data_port_sending;
signal stage5_sig9 : data_port_sending;
signal stage5_sig10 : data_port_sending;
signal stage5_sig11 : data_port_sending;
signal stage5_sig12 : data_port_sending;
signal stage5_sig13 : data_port_sending;
signal stage5_sig14 : data_port_sending;
signal stage5_sig15 : data_port_sending;
signal stage5_sig16 : data_port_sending;
signal stage5_sig17 : data_port_sending;
signal stage5_sig18 : data_port_sending;
signal stage5_sig19 : data_port_sending;
signal stage5_sig20 : data_port_sending;
signal stage5_sig21 : data_port_sending;
signal stage5_sig22 : data_port_sending;
signal stage5_sig23 : data_port_sending;
signal stage5_sig24 : data_port_sending;
signal stage5_sig25 : data_port_sending;
signal stage5_sig26 : data_port_sending;
signal stage5_sig27 : data_port_sending;
signal stage5_sig28 : data_port_sending;
signal stage5_sig29 : data_port_sending;
signal stage5_sig30 : data_port_sending;
signal stage5_sig31 : data_port_sending;


begin


--Input,output port assignments


stage0_sig0 	<= in_data_packets(0);
stage0_sig1 	<= in_data_packets(1);
stage0_sig2 	<= in_data_packets(2);
stage0_sig3 	<= in_data_packets(3);
stage0_sig4 	<= in_data_packets(4);
stage0_sig5 	<= in_data_packets(5);
stage0_sig6 	<= in_data_packets(6);
stage0_sig7 	<= in_data_packets(7);
stage0_sig8 	<= in_data_packets(8);
stage0_sig9 	<= in_data_packets(9);
stage0_sig10 	<= in_data_packets(10);
stage0_sig11 	<= in_data_packets(11);
stage0_sig12 	<= in_data_packets(12);
stage0_sig13 	<= in_data_packets(13);
stage0_sig14 	<= in_data_packets(14);
stage0_sig15 	<= in_data_packets(15);
stage0_sig16 	<= in_data_packets(16);
stage0_sig17 	<= in_data_packets(17);
stage0_sig18 	<= in_data_packets(18);
stage0_sig19 	<= in_data_packets(19);
stage0_sig20 	<= in_data_packets(20);
stage0_sig21 	<= in_data_packets(21);
stage0_sig22 	<= in_data_packets(22);
stage0_sig23 	<= in_data_packets(23);
stage0_sig24 	<= in_data_packets(24);
stage0_sig25 	<= in_data_packets(25);
stage0_sig26 	<= in_data_packets(26);
stage0_sig27 	<= in_data_packets(27);
stage0_sig28 	<= in_data_packets(28);
stage0_sig29 	<= in_data_packets(29);
stage0_sig30 	<= in_data_packets(30);
stage0_sig31 	<= in_data_packets(31);
out_data_packets(0) 	<= stage5_sig0;
out_data_packets(1) 	<= stage5_sig1;
out_data_packets(2) 	<= stage5_sig2;
out_data_packets(3) 	<= stage5_sig3;
out_data_packets(4) 	<= stage5_sig4;
out_data_packets(5) 	<= stage5_sig5;
out_data_packets(6) 	<= stage5_sig6;
out_data_packets(7) 	<= stage5_sig7;
out_data_packets(8) 	<= stage5_sig8;
out_data_packets(9) 	<= stage5_sig9;
out_data_packets(10) 	<= stage5_sig10;
out_data_packets(11) 	<= stage5_sig11;
out_data_packets(12) 	<= stage5_sig12;
out_data_packets(13) 	<= stage5_sig13;
out_data_packets(14) 	<= stage5_sig14;
out_data_packets(15) 	<= stage5_sig15;
out_data_packets(16) 	<= stage5_sig16;
out_data_packets(17) 	<= stage5_sig17;
out_data_packets(18) 	<= stage5_sig18;
out_data_packets(19) 	<= stage5_sig19;
out_data_packets(20) 	<= stage5_sig20;
out_data_packets(21) 	<= stage5_sig21;
out_data_packets(22) 	<= stage5_sig22;
out_data_packets(23) 	<= stage5_sig23;
out_data_packets(24) 	<= stage5_sig24;
out_data_packets(25) 	<= stage5_sig25;
out_data_packets(26) 	<= stage5_sig26;
out_data_packets(27) 	<= stage5_sig27;
out_data_packets(28) 	<= stage5_sig28;
out_data_packets(29) 	<= stage5_sig29;
out_data_packets(30) 	<= stage5_sig30;
out_data_packets(31) 	<= stage5_sig31;



STAGE0_SWITCH0 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_sig0,stage0_sig16,stage1_sig0,stage1_sig16);

STAGE0_SWITCH1 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_sig1,stage0_sig17,stage1_sig1,stage1_sig17);

STAGE0_SWITCH2 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_sig2,stage0_sig18,stage1_sig2,stage1_sig18);

STAGE0_SWITCH3 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_sig3,stage0_sig19,stage1_sig3,stage1_sig19);

STAGE0_SWITCH4 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_sig4,stage0_sig20,stage1_sig4,stage1_sig20);

STAGE0_SWITCH5 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_sig5,stage0_sig21,stage1_sig5,stage1_sig21);

STAGE0_SWITCH6 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_sig6,stage0_sig22,stage1_sig6,stage1_sig22);

STAGE0_SWITCH7 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_sig7,stage0_sig23,stage1_sig7,stage1_sig23);

STAGE0_SWITCH8 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_sig8,stage0_sig24,stage1_sig8,stage1_sig24);

STAGE0_SWITCH9 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_sig9,stage0_sig25,stage1_sig9,stage1_sig25);

STAGE0_SWITCH10 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_sig10,stage0_sig26,stage1_sig10,stage1_sig26);

STAGE0_SWITCH11 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_sig11,stage0_sig27,stage1_sig11,stage1_sig27);

STAGE0_SWITCH12 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_sig12,stage0_sig28,stage1_sig12,stage1_sig28);

STAGE0_SWITCH13 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_sig13,stage0_sig29,stage1_sig13,stage1_sig29);

STAGE0_SWITCH14 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_sig14,stage0_sig30,stage1_sig14,stage1_sig30);

STAGE0_SWITCH15 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_sig15,stage0_sig31,stage1_sig15,stage1_sig31);

STAGE1_SWITCH0 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_sig0,stage1_sig8,stage2_sig0,stage2_sig8);

STAGE1_SWITCH1 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_sig1,stage1_sig9,stage2_sig1,stage2_sig9);

STAGE1_SWITCH2 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_sig2,stage1_sig10,stage2_sig2,stage2_sig10);

STAGE1_SWITCH3 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_sig3,stage1_sig11,stage2_sig3,stage2_sig11);

STAGE1_SWITCH4 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_sig4,stage1_sig12,stage2_sig4,stage2_sig12);

STAGE1_SWITCH5 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_sig5,stage1_sig13,stage2_sig5,stage2_sig13);

STAGE1_SWITCH6 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_sig6,stage1_sig14,stage2_sig6,stage2_sig14);

STAGE1_SWITCH7 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_sig7,stage1_sig15,stage2_sig7,stage2_sig15);

STAGE1_SWITCH8 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_sig16,stage1_sig24,stage2_sig16,stage2_sig24);

STAGE1_SWITCH9 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_sig17,stage1_sig25,stage2_sig17,stage2_sig25);

STAGE1_SWITCH10 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_sig18,stage1_sig26,stage2_sig18,stage2_sig26);

STAGE1_SWITCH11 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_sig19,stage1_sig27,stage2_sig19,stage2_sig27);

STAGE1_SWITCH12 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_sig20,stage1_sig28,stage2_sig20,stage2_sig28);

STAGE1_SWITCH13 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_sig21,stage1_sig29,stage2_sig21,stage2_sig29);

STAGE1_SWITCH14 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_sig22,stage1_sig30,stage2_sig22,stage2_sig30);

STAGE1_SWITCH15 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_sig23,stage1_sig31,stage2_sig23,stage2_sig31);

STAGE2_SWITCH0 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_sig0,stage2_sig4,stage3_sig0,stage3_sig4);

STAGE2_SWITCH1 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_sig1,stage2_sig5,stage3_sig1,stage3_sig5);

STAGE2_SWITCH2 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_sig2,stage2_sig6,stage3_sig2,stage3_sig6);

STAGE2_SWITCH3 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_sig3,stage2_sig7,stage3_sig3,stage3_sig7);

STAGE2_SWITCH4 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_sig8,stage2_sig12,stage3_sig8,stage3_sig12);

STAGE2_SWITCH5 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_sig9,stage2_sig13,stage3_sig9,stage3_sig13);

STAGE2_SWITCH6 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_sig10,stage2_sig14,stage3_sig10,stage3_sig14);

STAGE2_SWITCH7 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_sig11,stage2_sig15,stage3_sig11,stage3_sig15);

STAGE2_SWITCH8 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_sig16,stage2_sig20,stage3_sig16,stage3_sig20);

STAGE2_SWITCH9 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_sig17,stage2_sig21,stage3_sig17,stage3_sig21);

STAGE2_SWITCH10 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_sig18,stage2_sig22,stage3_sig18,stage3_sig22);

STAGE2_SWITCH11 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_sig19,stage2_sig23,stage3_sig19,stage3_sig23);

STAGE2_SWITCH12 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_sig24,stage2_sig28,stage3_sig24,stage3_sig28);

STAGE2_SWITCH13 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_sig25,stage2_sig29,stage3_sig25,stage3_sig29);

STAGE2_SWITCH14 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_sig26,stage2_sig30,stage3_sig26,stage3_sig30);

STAGE2_SWITCH15 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_sig27,stage2_sig31,stage3_sig27,stage3_sig31);

STAGE3_SWITCH0 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_sig0,stage3_sig2,stage4_sig0,stage4_sig2);

STAGE3_SWITCH1 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_sig1,stage3_sig3,stage4_sig1,stage4_sig3);

STAGE3_SWITCH2 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_sig4,stage3_sig6,stage4_sig4,stage4_sig6);

STAGE3_SWITCH3 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_sig5,stage3_sig7,stage4_sig5,stage4_sig7);

STAGE3_SWITCH4 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_sig8,stage3_sig10,stage4_sig8,stage4_sig10);

STAGE3_SWITCH5 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_sig9,stage3_sig11,stage4_sig9,stage4_sig11);

STAGE3_SWITCH6 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_sig12,stage3_sig14,stage4_sig12,stage4_sig14);

STAGE3_SWITCH7 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_sig13,stage3_sig15,stage4_sig13,stage4_sig15);

STAGE3_SWITCH8 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_sig16,stage3_sig18,stage4_sig16,stage4_sig18);

STAGE3_SWITCH9 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_sig17,stage3_sig19,stage4_sig17,stage4_sig19);

STAGE3_SWITCH10 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_sig20,stage3_sig22,stage4_sig20,stage4_sig22);

STAGE3_SWITCH11 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_sig21,stage3_sig23,stage4_sig21,stage4_sig23);

STAGE3_SWITCH12 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_sig24,stage3_sig26,stage4_sig24,stage4_sig26);

STAGE3_SWITCH13 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_sig25,stage3_sig27,stage4_sig25,stage4_sig27);

STAGE3_SWITCH14 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_sig28,stage3_sig30,stage4_sig28,stage4_sig30);

STAGE3_SWITCH15 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_sig29,stage3_sig31,stage4_sig29,stage4_sig31);

STAGE4_SWITCH0 : entity work.BanyanSwitch(RTL)
	generic map(idx => 0)
	 port map(
	stage4_sig0,stage4_sig1,stage5_sig0,stage5_sig1);

STAGE4_SWITCH1 : entity work.BanyanSwitch(RTL)
	generic map(idx => 0)
	 port map(
	stage4_sig2,stage4_sig3,stage5_sig2,stage5_sig3);

STAGE4_SWITCH2 : entity work.BanyanSwitch(RTL)
	generic map(idx => 0)
	 port map(
	stage4_sig4,stage4_sig5,stage5_sig4,stage5_sig5);

STAGE4_SWITCH3 : entity work.BanyanSwitch(RTL)
	generic map(idx => 0)
	 port map(
	stage4_sig6,stage4_sig7,stage5_sig6,stage5_sig7);

STAGE4_SWITCH4 : entity work.BanyanSwitch(RTL)
	generic map(idx => 0)
	 port map(
	stage4_sig8,stage4_sig9,stage5_sig8,stage5_sig9);

STAGE4_SWITCH5 : entity work.BanyanSwitch(RTL)
	generic map(idx => 0)
	 port map(
	stage4_sig10,stage4_sig11,stage5_sig10,stage5_sig11);

STAGE4_SWITCH6 : entity work.BanyanSwitch(RTL)
	generic map(idx => 0)
	 port map(
	stage4_sig12,stage4_sig13,stage5_sig12,stage5_sig13);

STAGE4_SWITCH7 : entity work.BanyanSwitch(RTL)
	generic map(idx => 0)
	 port map(
	stage4_sig14,stage4_sig15,stage5_sig14,stage5_sig15);

STAGE4_SWITCH8 : entity work.BanyanSwitch(RTL)
	generic map(idx => 0)
	 port map(
	stage4_sig16,stage4_sig17,stage5_sig16,stage5_sig17);

STAGE4_SWITCH9 : entity work.BanyanSwitch(RTL)
	generic map(idx => 0)
	 port map(
	stage4_sig18,stage4_sig19,stage5_sig18,stage5_sig19);

STAGE4_SWITCH10 : entity work.BanyanSwitch(RTL)
	generic map(idx => 0)
	 port map(
	stage4_sig20,stage4_sig21,stage5_sig20,stage5_sig21);

STAGE4_SWITCH11 : entity work.BanyanSwitch(RTL)
	generic map(idx => 0)
	 port map(
	stage4_sig22,stage4_sig23,stage5_sig22,stage5_sig23);

STAGE4_SWITCH12 : entity work.BanyanSwitch(RTL)
	generic map(idx => 0)
	 port map(
	stage4_sig24,stage4_sig25,stage5_sig24,stage5_sig25);

STAGE4_SWITCH13 : entity work.BanyanSwitch(RTL)
	generic map(idx => 0)
	 port map(
	stage4_sig26,stage4_sig27,stage5_sig26,stage5_sig27);

STAGE4_SWITCH14 : entity work.BanyanSwitch(RTL)
	generic map(idx => 0)
	 port map(
	stage4_sig28,stage4_sig29,stage5_sig28,stage5_sig29);

STAGE4_SWITCH15 : entity work.BanyanSwitch(RTL)
	generic map(idx => 0)
	 port map(
	stage4_sig30,stage4_sig31,stage5_sig30,stage5_sig31);



end architecture;


