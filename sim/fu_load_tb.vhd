library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.ALL;
use work.buf_pkg.ALL;
use work.mem_components.ALL;

  ENTITY fu_load_tb IS
  END fu_load_tb;

  ARCHITECTURE behavior OF fu_load_tb IS 

			--common signals including DTN
			signal clk 					: std_logic := '0';
			signal rst 					: std_logic := '0';
			signal dtn_data_in		: data_port_sending;
			signal dtn_data_out		: data_port_sending;
			
			--signals to/from load unit
			signal mib_inp_load 		: mib_ctrl_out;
			signal status_load		: mib_stalls;
			signal ack_load			: data_port_receiving;
			signal data_load			: std_Logic_vector (MEM_WORD_LENGTH-1 downto 0);
			signal mem_ack_load		: std_logic;
			signal addr_load			: std_Logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
			signal re_load				: std_logic;
			
			--signals to/from store unit
			signal mib_inp_store		: mib_ctrl_out;
			signal status_store		: mib_stalls;
			signal ack_store			: data_port_receiving;
			signal mem_ack_store		: std_logic;
			signal addr_store			: std_Logic_vector (MEM_BANK_ADDR_LENGTH-1 downto 0);
			signal we_store			: std_logic;
			signal data_store			: std_Logic_vector (MEM_WORD_LENGTH-1 downto 0);
			
			
			
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
          load: fu_load PORT MAP(
                  clk 			=> clk,
						rst 			=> rst,
						mib_inp		=> mib_inp_load,
						status		=> status_load,
						ack			=> ack_load,
						dtn_data_in	=> dtn_data_in,
						dtn_data_out	=> dtn_data_out,
						data			=> data_load,
						mem_ack			=> mem_ack_load,
						addr			=> addr_load,
						re				=> re_load 
          );
			 
			 store : fu_store PORT MAP (
						clk 			=> clk,
						rst 			=> rst,
						mib_inp		=> mib_inp_store,
						status		=> status_store,
						ack			=> ack_store,
						dtn_data_in	=> dtn_data_in,
						mem_ack		=> mem_ack_store,
						data			=> data_store,
						addr			=> addr_store,
						we				=> we_store
			);
						
			 
			 top : memory_top PORT MAP (
						clk			=> clk,
						rst			=> rst,
						inp(0).re	=> re_load,
						inp(0).we	=> we_store,
						inp(0).r_addr => addr_load,
						inp(0).w_addr => addr_store,
						inp(0).data_in => data_store,
						outp(0).r_ack	=> mem_ack_load,
						outp(0).w_ack	=> mem_ack_store,
						outp(0).data_out	=> data_load
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
			mib_inp_store.valid <= '0';
			mib_inp_load.valid <= '0';
			dtn_data_in.message.src.fu	<= (others=> 'X'); 
			wait for clk_period + 5 ns;
			rst 		<= '0';
			wait for clk_period;
			--Store some values in memory through store unit
			--First reserve the address on designated buffer
			--Second buffer of store unit stores the address to be accessed,while first one
			--holds the data to be written
			fu_mib_write('0',"00000",mib_inp_store);
			fu_mib_write('1',"00001",mib_inp_store);
			fu_mib_write('0',"00010",mib_inp_store);
			fu_mib_write('1',"00011",mib_inp_store);
			fu_mib_write('0',"00100",mib_inp_store);
			fu_mib_write('1',"00101",mib_inp_store);
			fu_mib_write('0',"00110",mib_inp_store);
			fu_mib_write('1',"00111",mib_inp_store);
			fu_mib_write('0',"01000",mib_inp_store);
			fu_mib_write('1',"01001",mib_inp_store);
			fu_mib_write('0',"01010",mib_inp_store);
			fu_mib_write('1',"01011",mib_inp_store);
			--asssign memory address to be stored as 0x0
			
			dtn_to_fu_write("00000",X"00000000",dtn_data_in);
			dtn_to_fu_write("00001",X"11111111",dtn_data_in);
			wait until status_store.dest_stalled = '1';
			wait until status_store.dest_stalled = '0';
			dtn_to_fu_write("00010",X"00000001",dtn_data_in);
			dtn_to_fu_write("00011",X"22222222",dtn_data_in);
			wait until status_store.dest_stalled = '1';
			wait until status_store.dest_stalled = '0';
			dtn_to_fu_write("00100",X"00000002",dtn_data_in);
			dtn_to_fu_write("00101",X"33333333",dtn_data_in);
			wait until status_store.dest_stalled = '1';
			wait until status_store.dest_stalled = '0';
			dtn_to_fu_write("00110",X"00000003",dtn_data_in);
			dtn_to_fu_write("00111",X"44444444",dtn_data_in);
			wait until status_store.dest_stalled = '1';
			wait until status_store.dest_stalled = '0';
			dtn_to_fu_write("01000",X"00000004",dtn_data_in);
			dtn_to_fu_write("01001",X"55555555",dtn_data_in);
			wait until status_store.dest_stalled = '1';
			wait until status_store.dest_stalled = '0';
			dtn_to_fu_write("01010",X"00000005",dtn_data_in);
			dtn_to_fu_write("01011",X"66666666",dtn_data_in);
			wait until status_store.dest_stalled = '1';
			wait until status_store.dest_stalled = '0';
			--read from that address, index is not used in load unit,since it has only one buffer
			--wait until mem_ack_store = '1';
			--wait until mem_ack_store = '0';
			--fu_mib_write('X',"11111",mib_inp_load);
			--dtn_to_fu_write("11111",X"00000000",dtn_data_in);
			--send the read value to some other FU
			--wait for 10*clk_period;
			--fu_mib_read('1',"00001",mib_inp_load);
			
			--fu_mib_read('0',"00011",mib_inp);
			

			wait;
		END PROCESS tb;

  END;
