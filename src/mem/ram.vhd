library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.glbSharedTypes.ALL;


entity ram is
    Port ( 	clk  : in std_logic;
			rst	 : in std_logic;
			re	 : in std_logic;
			we	 : in std_logic;
			r_addr : in  std_logic_vector (MEM_ADDR_LENGTH-MEM_SELECT_BITLENGTH-1 downto 0);
			w_addr : in  std_logic_vector (MEM_ADDR_LENGTH-MEM_SELECT_BITLENGTH-1 downto 0);
			data_in : in  std_logic_vector (MEM_WORD_LENGTH-1 downto 0);
			r_ack  	: out std_logic;
			w_ack  	: out std_logic;
			data_out : out  std_logic_vector (MEM_WORD_LENGTH-1 downto 0));
end ram;

architecture RTL of ram is

signal sram: ram_type := (others=> (others=>'0'));
signal reg_data_out: std_logic_vector(data_out'range);
signal reg_r_ack: std_logic;
signal reg_w_ack: std_logic;

begin

data_out <= reg_data_out;
r_ack <= reg_r_ack;
w_ack <= reg_w_ack;

read_proc: process(clk)
begin 
	if rising_edge(clk) then
		if rst = '1' then
			reg_data_out <= (others => '0');
			reg_r_ack <= '0';
		elsif re = '1' then
			reg_data_out <= sram(to_integer(unsigned(r_addr)));
			reg_r_ack <= '1';
		else
			reg_r_ack <= '0';
		end if;
	end if;
end process;

write_proc: process(clk)
begin 
	if rising_edge(clk) then
		if rst = '1' then
			sram <= (others=> (others=>'0'));
			reg_w_ack <= '0';
		elsif we = '1' then
			sram(to_integer(unsigned(w_addr))) <= data_in;
			reg_w_ack <= '1';
		else
			reg_w_ack <= '0';
		end if;
	end if;
end process;

end RTL;