library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.glbSharedTypes.ALL;
use work.fifo_pkg.ALL;
use work.alu_components.ALL;

  ENTITY fu_alu_tb IS
  END fu_alu_tb;

  ARCHITECTURE behavior OF fu_alu_tb IS 

			signal clk 				: std_logic := '0';
			signal rst 				: std_logic := '0';
			signal en 				: std_logic := '0';
			signal rw 				: std_logic := '0';
			signal valid_inst 	: std_logic := '0';
         signal inp 				: sorterIOVector_t;
			signal outp 			: sorterIOVector_t;
			signal busy 			: std_logic := '0';
			
			constant clk_period 	: time := 10 ns;
			
			procedure fu_write(constant fifo_idx 	: in std_logic;
									 constant data	  		: in std_logic_vector(inp.data'range);
									 signal fu_data  		: out sorterIOVector_t;
									 signal fu_en	  		: out std_logic;
									 signal fu_rw    		: out std_logic ) is
			begin
				wait for clk_period;
				fu_en				<= '1';
				fu_rw				<= '1';
				fu_data			<= (address => "00000", data => data, fifoIdx =>fifo_idx );
				wait for clk_period;
				fu_en				<= '0';
			end fu_write;
			
				
			procedure execute(signal valid_inst		: out std_logic) is
			begin
				valid_inst		<= '1';
				wait for clk_period;
				valid_inst		<= '0';
				wait for clk_period;
			end execute;	
			
			procedure fu_read(constant fifo_idx		: in std_logic;
									constant address		: in std_logic_vector(inp.address'range);
									signal fu_data  		: out sorterIOVector_t;
									signal fu_en			: out	std_logic;
									signal fu_rw			: out std_logic) is
			begin
				fu_en				<= '1';
				fu_rw				<= '0';
				fu_data			<= (address => address, data=>(others => 'X'), fifoIdx =>fifo_idx );
				wait for clk_period;
				fu_en				<= '0';
				wait for 2*clk_period;
			end fu_read;

  BEGIN
          uut: fu_adder PORT MAP(
                  clk 			=> clk,
						rst 			=> rst,
						en  			=> en,
						rw 			=> rw,
						valid_inst	=> valid_inst,
						inp			=> inp,
						outp			=> outp,
						busy			=> busy
          );
			 
		clk_process :process
		begin
				clk <= '0';
				wait for clk_period/2;
				clk <= '1';
				wait for clk_period/2;
		end process;
  
		tb : PROCESS
		BEGIN
			inp		<= (address => "00000", data => X"00000000", fifoIdx =>'0' );
			rst		<= '1';
			wait for clk_period + 5 ns;
			rst 		<= '0';
			wait for clk_period;
			--Fill the input buffers 
			fu_write('1',X"00000000",inp,en,rw);
			fu_write('0',X"11111111",inp,en,rw);
			fu_write('1',X"22222222",inp,en,rw);
			fu_write('0',X"33333333",inp,en,rw);
			fu_write('1',X"44444444",inp,en,rw);
			fu_write('0',X"55555555",inp,en,rw);
			fu_write('1',X"66666666",inp,en,rw);
			fu_write('0',X"77777777",inp,en,rw);
			fu_write('1',X"88888888",inp,en,rw);
			fu_write('0',X"99999999",inp,en,rw);
			fu_write('1',X"AAAAAAAA",inp,en,rw);
			fu_write('0',X"BBBBBBBB",inp,en,rw);
			
			--Issue command to FU
			execute(valid_inst);
			execute(valid_inst);
			execute(valid_inst);
			execute(valid_inst);
			execute(valid_inst);
			execute(valid_inst);
			
			wait for clk_period;
			
			fu_read('1',"00001",inp,en,rw);
			fu_read('1',"00011",inp,en,rw);
			fu_read('1',"00111",inp,en,rw);
			fu_read('1',"01111",inp,en,rw);
			fu_read('1',"11111",inp,en,rw);
			fu_read('1',"00111",inp,en,rw);
			

			wait;
		END PROCESS tb;

  END;
