
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;



entity alu is
		Generic (op_type : fu_alu_type := ADD) ;
		Port ( 	clk : in std_logic;
				op1 : in  	std_logic_vector (FU_DATA_W-1 downto 0);
				op2 : in  	std_logic_vector (FU_DATA_W-1 downto 0);
				en	: in 	std_logic;
				busy : out std_logic;
				res : out  	std_logic_vector (FU_DATA_W-1 downto 0);
				valid : out std_logic);
end alu;

architecture RTL of alu is

signal reg_valid 	: std_logic := '0';
signal reg_busy		: std_logic := '0';
signal reg_out		: std_logic_vector(res'range);

begin

valid 	<= reg_valid;
res		<= reg_out;
busy		<= reg_busy;

GEN_ADDER : if op_type = ADD generate
	process(clk)
	begin
	if rising_edge(clk) then
		if en = '1' then	
			reg_out 	<= std_logic_vector(signed(op1) + signed(op2));
			reg_valid 	<= '1';
			reg_busy 	<= '1';
		else
			reg_out 	<= reg_out;
			reg_valid 	<= '0';
			reg_busy	<= '0';
		end if;
	end if;
	end process;
end generate GEN_ADDER;

GEN_SUBTRACTOR : if op_type = SUBTRACT generate
process(clk)
	begin
	if rising_edge(clk) then
		if en = '1' then	
			reg_out 	<= std_logic_vector(signed(op1) - signed(op2));
			reg_valid 	<= '1';
			reg_busy 	<= '1';
		else
			reg_out 	<= reg_out;
			reg_valid 	<= '0';
			reg_busy	<= '0';
		end if;
	end if;
	end process;
end generate GEN_SUBTRACTOR;

GEN_LT : if op_type = LT generate
process(clk)
	begin
	if rising_edge(clk) then
		reg_out(reg_out'left downto 1) <= (others => '0');
		if en = '1' then	
			if signed(op1) < signed(op2) then
				reg_out(0) <= '1';
			else
				reg_out(1) <= '0';
			end if;
			reg_valid 	<= '1';
			reg_busy 	<= '1';
		else
			reg_out 	<= reg_out;
			reg_valid 	<= '0';
			reg_busy	<= '0';
		end if;
	end if;
	end process;
end generate GEN_LT;

GEN_GT : if op_type = GT generate
process(clk)
	begin
	if rising_edge(clk) then
		reg_out(reg_out'left downto 1) <= (others => '0');
		if en = '1' then	
			if signed(op1) > signed(op2) then
				reg_out(0) <= '1';
			else
				reg_out(1) <= '0';
			end if;
			reg_valid 	<= '1';
			reg_busy 	<= '1';
		else
			reg_out 	<= reg_out;
			reg_valid 	<= '0';
			reg_busy	<= '0';
		end if;
	end if;
	end process;
end generate GEN_GT;

GEN_LTE : if op_type = LTE generate
process(clk)
	begin
	if rising_edge(clk) then
		reg_out(reg_out'left downto 1) <= (others => '0');
		if en = '1' then	
			if signed(op1) <= signed(op2) then
				reg_out(0) <= '1';
			else
				reg_out(1) <= '0';
			end if;
			reg_valid 	<= '1';
			reg_busy 	<= '1';
		else
			reg_out 	<= reg_out;
			reg_valid 	<= '0';
			reg_busy	<= '0';
		end if;
	end if;
	end process;
end generate GEN_LTE;

GEN_GTE : if op_type = GTE generate
process(clk)
	begin
	if rising_edge(clk) then
		reg_out(reg_out'left downto 1) <= (others => '0');
		if en = '1' then	
			if signed(op1) >= signed(op2) then
				reg_out(0) <= '1';
			else
				reg_out(1) <= '0';
			end if;
			reg_valid 	<= '1';
			reg_busy 	<= '1';
		else
			reg_out 	<= reg_out;
			reg_valid 	<= '0';
			reg_busy	<= '0';
		end if;
	end if;
	end process;
end generate GEN_GTE;

GEN_EQ : if op_type = EQ generate
process(clk)
	begin
	if rising_edge(clk) then
		reg_out(reg_out'left downto 1) <= (others => '0');
		if en = '1' then	
			if signed(op1) = signed(op2) then
				reg_out(0) <= '1';
			else
				reg_out(1) <= '0';
			end if;
			reg_valid 	<= '1';
			reg_busy 	<= '1';
		else
			reg_out 	<= reg_out;
			reg_valid 	<= '0';
			reg_busy	<= '0';
		end if;
	end if;
	end process;
end generate EQ;

GEN_NEQ : if op_type = NEQ generate
process(clk)
	begin
	if rising_edge(clk) then
		reg_out(reg_out'left downto 1) <= (others => '0');
		if en = '1' then	
			if signed(op1) /= signed(op2) then
				reg_out(0) <= '1';
			else
				reg_out(1) <= '0';
			end if;
			reg_valid 	<= '1';
			reg_busy 	<= '1';
		else
			reg_out 	<= reg_out;
			reg_valid 	<= '0';
			reg_busy	<= '0';
		end if;
	end if;
	end process;
end generate NEQ;



end RTL;

