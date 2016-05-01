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
signal stage0_sig : data_packets_t;
signal stage1_sig : data_packets_t;
signal stage2_sig : data_packets_t;
signal stage3_sig : data_packets_t;
signal stage4_sig : data_packets_t;
signal stage0_reg : data_packets_t;
signal stage1_reg : data_packets_t;
signal stage2_reg : data_packets_t;
signal stage3_reg : data_packets_t;
signal stage4_reg : data_packets_t;


begin


--Input,output port assignments





STAGE0_SWITCH0 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_reg(0),stage0_reg(16),stage1_sig(0),stage1_sig(16));

STAGE0_SWITCH1 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_reg(1),stage0_reg(17),stage1_sig(1),stage1_sig(17));

STAGE0_SWITCH2 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_reg(2),stage0_reg(18),stage1_sig(2),stage1_sig(18));

STAGE0_SWITCH3 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_reg(3),stage0_reg(19),stage1_sig(3),stage1_sig(19));

STAGE0_SWITCH4 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_reg(4),stage0_reg(20),stage1_sig(4),stage1_sig(20));

STAGE0_SWITCH5 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_reg(5),stage0_reg(21),stage1_sig(5),stage1_sig(21));

STAGE0_SWITCH6 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_reg(6),stage0_reg(22),stage1_sig(6),stage1_sig(22));

STAGE0_SWITCH7 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_reg(7),stage0_reg(23),stage1_sig(7),stage1_sig(23));

STAGE0_SWITCH8 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_reg(8),stage0_reg(24),stage1_sig(8),stage1_sig(24));

STAGE0_SWITCH9 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_reg(9),stage0_reg(25),stage1_sig(9),stage1_sig(25));

STAGE0_SWITCH10 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_reg(10),stage0_reg(26),stage1_sig(10),stage1_sig(26));

STAGE0_SWITCH11 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_reg(11),stage0_reg(27),stage1_sig(11),stage1_sig(27));

STAGE0_SWITCH12 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_reg(12),stage0_reg(28),stage1_sig(12),stage1_sig(28));

STAGE0_SWITCH13 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_reg(13),stage0_reg(29),stage1_sig(13),stage1_sig(29));

STAGE0_SWITCH14 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_reg(14),stage0_reg(30),stage1_sig(14),stage1_sig(30));

STAGE0_SWITCH15 : entity work.BanyanSwitch(RTL)
	generic map(idx => 4)
	 port map(
	stage0_reg(15),stage0_reg(31),stage1_sig(15),stage1_sig(31));

STAGE1_SWITCH0 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_reg(0),stage1_reg(8),stage2_sig(0),stage2_sig(8));

STAGE1_SWITCH1 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_reg(1),stage1_reg(9),stage2_sig(1),stage2_sig(9));

STAGE1_SWITCH2 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_reg(2),stage1_reg(10),stage2_sig(2),stage2_sig(10));

STAGE1_SWITCH3 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_reg(3),stage1_reg(11),stage2_sig(3),stage2_sig(11));

STAGE1_SWITCH4 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_reg(4),stage1_reg(12),stage2_sig(4),stage2_sig(12));

STAGE1_SWITCH5 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_reg(5),stage1_reg(13),stage2_sig(5),stage2_sig(13));

STAGE1_SWITCH6 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_reg(6),stage1_reg(14),stage2_sig(6),stage2_sig(14));

STAGE1_SWITCH7 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_reg(7),stage1_reg(15),stage2_sig(7),stage2_sig(15));

STAGE1_SWITCH8 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_reg(16),stage1_reg(24),stage2_sig(16),stage2_sig(24));

STAGE1_SWITCH9 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_reg(17),stage1_reg(25),stage2_sig(17),stage2_sig(25));

STAGE1_SWITCH10 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_reg(18),stage1_reg(26),stage2_sig(18),stage2_sig(26));

STAGE1_SWITCH11 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_reg(19),stage1_reg(27),stage2_sig(19),stage2_sig(27));

STAGE1_SWITCH12 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_reg(20),stage1_reg(28),stage2_sig(20),stage2_sig(28));

STAGE1_SWITCH13 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_reg(21),stage1_reg(29),stage2_sig(21),stage2_sig(29));

STAGE1_SWITCH14 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_reg(22),stage1_reg(30),stage2_sig(22),stage2_sig(30));

STAGE1_SWITCH15 : entity work.BanyanSwitch(RTL)
	generic map(idx => 3)
	 port map(
	stage1_reg(23),stage1_reg(31),stage2_sig(23),stage2_sig(31));

STAGE2_SWITCH0 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_reg(0),stage2_reg(4),stage3_sig(0),stage3_sig(4));

STAGE2_SWITCH1 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_reg(1),stage2_reg(5),stage3_sig(1),stage3_sig(5));

STAGE2_SWITCH2 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_reg(2),stage2_reg(6),stage3_sig(2),stage3_sig(6));

STAGE2_SWITCH3 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_reg(3),stage2_reg(7),stage3_sig(3),stage3_sig(7));

STAGE2_SWITCH4 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_reg(8),stage2_reg(12),stage3_sig(8),stage3_sig(12));

STAGE2_SWITCH5 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_reg(9),stage2_reg(13),stage3_sig(9),stage3_sig(13));

STAGE2_SWITCH6 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_reg(10),stage2_reg(14),stage3_sig(10),stage3_sig(14));

STAGE2_SWITCH7 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_reg(11),stage2_reg(15),stage3_sig(11),stage3_sig(15));

STAGE2_SWITCH8 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_reg(16),stage2_reg(20),stage3_sig(16),stage3_sig(20));

STAGE2_SWITCH9 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_reg(17),stage2_reg(21),stage3_sig(17),stage3_sig(21));

STAGE2_SWITCH10 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_reg(18),stage2_reg(22),stage3_sig(18),stage3_sig(22));

STAGE2_SWITCH11 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_reg(19),stage2_reg(23),stage3_sig(19),stage3_sig(23));

STAGE2_SWITCH12 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_reg(24),stage2_reg(28),stage3_sig(24),stage3_sig(28));

STAGE2_SWITCH13 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_reg(25),stage2_reg(29),stage3_sig(25),stage3_sig(29));

STAGE2_SWITCH14 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_reg(26),stage2_reg(30),stage3_sig(26),stage3_sig(30));

STAGE2_SWITCH15 : entity work.BanyanSwitch(RTL)
	generic map(idx => 2)
	 port map(
	stage2_reg(27),stage2_reg(31),stage3_sig(27),stage3_sig(31));

STAGE3_SWITCH0 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_reg(0),stage3_reg(2),stage4_sig(0),stage4_sig(2));

STAGE3_SWITCH1 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_reg(1),stage3_reg(3),stage4_sig(1),stage4_sig(3));

STAGE3_SWITCH2 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_reg(4),stage3_reg(6),stage4_sig(4),stage4_sig(6));

STAGE3_SWITCH3 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_reg(5),stage3_reg(7),stage4_sig(5),stage4_sig(7));

STAGE3_SWITCH4 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_reg(8),stage3_reg(10),stage4_sig(8),stage4_sig(10));

STAGE3_SWITCH5 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_reg(9),stage3_reg(11),stage4_sig(9),stage4_sig(11));

STAGE3_SWITCH6 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_reg(12),stage3_reg(14),stage4_sig(12),stage4_sig(14));

STAGE3_SWITCH7 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_reg(13),stage3_reg(15),stage4_sig(13),stage4_sig(15));

STAGE3_SWITCH8 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_reg(16),stage3_reg(18),stage4_sig(16),stage4_sig(18));

STAGE3_SWITCH9 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_reg(17),stage3_reg(19),stage4_sig(17),stage4_sig(19));

STAGE3_SWITCH10 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_reg(20),stage3_reg(22),stage4_sig(20),stage4_sig(22));

STAGE3_SWITCH11 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_reg(21),stage3_reg(23),stage4_sig(21),stage4_sig(23));

STAGE3_SWITCH12 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_reg(24),stage3_reg(26),stage4_sig(24),stage4_sig(26));

STAGE3_SWITCH13 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_reg(25),stage3_reg(27),stage4_sig(25),stage4_sig(27));

STAGE3_SWITCH14 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_reg(28),stage3_reg(30),stage4_sig(28),stage4_sig(30));

STAGE3_SWITCH15 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage3_reg(29),stage3_reg(31),stage4_sig(29),stage4_sig(31));

STAGE4_SWITCH0 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage4_reg(0),stage4_reg(1),out_data_packets(0),out_data_packets(1));

STAGE4_SWITCH1 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage4_reg(2),stage4_reg(3),out_data_packets(2),out_data_packets(3));

STAGE4_SWITCH2 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage4_reg(4),stage4_reg(5),out_data_packets(4),out_data_packets(5));

STAGE4_SWITCH3 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage4_reg(6),stage4_reg(7),out_data_packets(6),out_data_packets(7));

STAGE4_SWITCH4 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage4_reg(8),stage4_reg(9),out_data_packets(8),out_data_packets(9));

STAGE4_SWITCH5 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage4_reg(10),stage4_reg(11),out_data_packets(10),out_data_packets(11));

STAGE4_SWITCH6 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage4_reg(12),stage4_reg(13),out_data_packets(12),out_data_packets(13));

STAGE4_SWITCH7 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage4_reg(14),stage4_reg(15),out_data_packets(14),out_data_packets(15));

STAGE4_SWITCH8 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage4_reg(16),stage4_reg(17),out_data_packets(16),out_data_packets(17));

STAGE4_SWITCH9 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage4_reg(18),stage4_reg(19),out_data_packets(18),out_data_packets(19));

STAGE4_SWITCH10 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage4_reg(20),stage4_reg(21),out_data_packets(20),out_data_packets(21));

STAGE4_SWITCH11 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage4_reg(22),stage4_reg(23),out_data_packets(22),out_data_packets(23));

STAGE4_SWITCH12 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage4_reg(24),stage4_reg(25),out_data_packets(24),out_data_packets(25));

STAGE4_SWITCH13 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage4_reg(26),stage4_reg(27),out_data_packets(26),out_data_packets(27));

STAGE4_SWITCH14 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage4_reg(28),stage4_reg(29),out_data_packets(28),out_data_packets(29));

STAGE4_SWITCH15 : entity work.BanyanSwitch(RTL)
	generic map(idx => 1)
	 port map(
	stage4_reg(30),stage4_reg(31),out_data_packets(30),out_data_packets(31));




pipe_proc: process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				null;
			else
				stage0_reg 	<= in_data_packets;
				stage1_reg 	<= stage1_sig;
				stage2_reg 	<= stage2_sig;
				stage3_reg 	<= stage3_sig;
				stage4_reg 	<= stage4_sig;
			end if;
		end if;
	end process;


end architecture;


