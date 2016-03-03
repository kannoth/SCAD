library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;
use work.buf_pkg.ALL;
use work.alu_components.ALL;

  ENTITY fu_alu_tb IS
  END fu_alu_tb;

  ARCHITECTURE behavior OF fu_alu_tb IS 

			signal clk 				: std_logic := '0';
			signal rst 				: std_logic := '0';
			signal mib_inp 		: mib_ctrl_out;
			signal status			: mib_stalls;
			signal ack				: data_port_receiving;
			signal dtn_data_in	: data_port_sending;
			signal dtn_data_out	: data_port_sending;
			
			constant clk_period 	: time := 10 ns;
			
			procedure fu_mib_write(	constant fifo_idx 	: in std_logic;
											constant addr	  		: in std_logic_vector(FU_ADDRESS_W-1 downto 0);
											signal mib_out  		: out mib_ctrl_out
			) is
			begin
				
				wait for clk_period;
				mib_out.valid <= '1';
				mib_out.src.fu <= addr;
				mib_out.dest.fu <= "00000";
				mib_out.dest.buff <= fifo_idx;
				mib_out.phase <= COMMIT;
				mib_out.valid <= '1';
				wait for clk_period;
				mib_out.valid <= '0';
				
			end fu_mib_write;
			
			procedure fu_mib_dtn_write( 	constant fifo_idx 	: in std_logic;
													constant addr	  		: in std_logic_vector(FU_ADDRESS_W-1 downto 0);
													constant data			: in std_logic_vector(FU_DATA_W-1 downto 0);
													signal mib_out  		: out mib_ctrl_out;
													signal dtn_packet 	: out data_port_sending
			) is
			begin
			
			wait for clk_period;
			mib_out.valid <= '1';
			mib_out.src.fu <= addr;
			mib_out.dest.fu <= "00000";
			mib_out.dest.buff <= fifo_idx;
			mib_out.phase <= COMMIT;
			mib_out.valid <= '1';
			dtn_packet.message.src.fu	<= addr;
			dtn_packet.message.data <= data;
			dtn_packet.valid	<= '1';
			wait for clk_period;
			mib_out.valid <= '0';
			dtn_packet.valid	<= '0';	
			end fu_mib_dtn_write;
			
			
			procedure dtn_to_fu_write( constant addr  : in std_logic_vector(FU_ADDRESS_W-1 downto 0);
												constant data	: in std_logic_vector(FU_DATA_W-1 downto 0);
												signal dtn_packet : out data_port_sending
			) is
			begin
			
			wait for clk_period;
			dtn_packet.message.src.fu	<= addr;
			dtn_packet.message.data <= data;
			dtn_packet.valid	<= '1';
			wait for clk_period;
			dtn_packet.valid	<= '0';
			
			end dtn_to_fu_write;
			
			procedure fu_mib_read (	constant idx : std_logic;
											constant addr : in std_logic_vector(FU_ADDRESS_W-1 downto 0);
											signal mib_out  		: out mib_ctrl_out
			) is 
			begin
				wait for clk_period;
				mib_out.valid <= '1';
				mib_out.src.fu <= "00000"; --use only address 0 for now
				mib_out.dest.fu <= addr;
				mib_out.dest.buff <= idx;
				mib_out.phase <= COMMIT;
				mib_out.valid <= '1';
				wait for clk_period;
				mib_out.valid <= '0';
			end fu_mib_read;
												
			

  BEGIN
          uut: fu_alu PORT MAP(
                  clk 			=> clk,
						rst 			=> rst,
						mib_inp		=> mib_inp,
						status		=> status,
						ack			=> ack,
						dtn_data_in	=> dtn_data_in,
						dtn_data_out	=> dtn_data_out
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
			
			rst		<= '1';
			wait for clk_period + 5 ns;
			rst 		<= '0';
			wait for clk_period;
			--Fill the input buffers 
			fu_mib_write('0',"11111",mib_inp);
			fu_mib_write('1',"11110",mib_inp);
			fu_mib_write('1',"11111",mib_inp);
			dtn_to_fu_write("11111",X"00000001",dtn_data_in);
			dtn_to_fu_write("11110",X"00000009",dtn_data_in);
			wait for 5*clk_period;
			fu_mib_read('0',"00011",mib_inp);
			wait for 5*clk_period;
			fu_mib_dtn_write('0',"11111",X"00000002",mib_inp,dtn_data_in);
			fu_mib_dtn_write('1',"11110",X"00000005",mib_inp,dtn_data_in);
			fu_mib_read('0',"00011",mib_inp);

			wait;
		END PROCESS tb;

  END;
