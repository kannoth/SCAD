library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;

library scad_lib;
use scad_lib.Datatypes.ALL;
use scad_lib.Constants.ALL;

entity simple_output_buffer is

    Generic (
      base_address : buffer_base_address_t := to_unsigned(0, buffer_address_base_width_c);
      port_count   : integer := 4;
      buffer_size  : integer := 16
    );

    Port ( clk   : in STD_LOGIC;
           clk2x : in STD_LOGIC;
           rst   : in STD_LOGIC;

           instr_bus       : in  instruction_bus_message_t;
           instr_bus_wen   : in  STD_LOGIC;
           instr_bus_full  : out STD_LOGIC;
           instr_bus_apply : in  STD_LOGIC;

           data_bus       : out data_bus_message_t;
           data_bus_ren   : in  STD_LOGIC;
           data_bus_valid : out STD_LOGIC;

           fu_input      : in  fu_data_t(0 to port_count-1);
           fu_input_wen  : in  STD_LOGIC;
           -- TODO make this an ACK
           fu_input_full : out STD_LOGIC
    );

end simple_output_buffer;

architecture Behavioral of simple_output_buffer is
  type logic_array is array (0 to port_count-1) of std_logic;
  type address_array is array (0 to port_count-1) of buffer_address_t;
  type data_array is array (0 to port_count-1) of data_value_t;

  signal addr_full : logic_array;
  signal addr_empty : logic_array;
  signal fu_full : logic_array;
  signal fu_empty : logic_array;

  signal address_in : address_array;
  signal address_wen : logic_array;

  signal data_value_out : data_array;
  signal data_address_out : address_array;
  signal data_ren : logic_array;

  -- Buffers
  signal instr_buffer : instruction_bus_message_t;
  signal instr_buffer_valid : std_logic;
  signal current_full : std_logic;

  -- Addresses
  signal instr_target_base : buffer_base_address_t;
  signal instr_target_ext  : buffer_ext_address_t;
  signal instr_buffer_ext  : buffer_ext_address_t;

  -- Helpers
  signal full_help : logic_array;
  signal valid_help : std_logic;
  signal current_port : integer := 0;

begin

  -- Create buffer units
  gen_buffers : for I in 0 to port_count-1 generate
    buf : entity scad_lib.simple_output_buffer_mem_unit
    generic map (
      size => buffer_size
    )

    port map (
      clk => clk,
      rst => rst,

      addr_full => addr_full(I),
      addr_empty => addr_empty(I),
      fu_full => fu_full(I),
      fu_empty => fu_empty(I),

      address_in => address_in(I),
      address_wen => address_wen(I),

      data_value_out => data_value_out(I),
  		data_address_out => data_address_out(I),
  		data_ren => data_ren(I),

      fu_in => fu_input(I),
      fu_wen => fu_input_wen
    );
  end generate gen_buffers;

  -- Decode addresses
  instr_target_base <= get_base_address(instr_bus.target_address);
  instr_target_ext <= get_ext_address(instr_bus.target_address);
  instr_buffer_ext <= get_ext_address(instr_buffer.target_address);

  -- Manage instruction bus
  instr_bus_full <= addr_full(to_integer(instr_target_ext));

  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        instr_buffer_valid <= '0';
        for I in 0 to port_count-1 loop
          address_wen(I) <= '0';
        end loop;
      else
        for I in 0 to port_count-1 loop
          address_wen(I) <= '0';
        end loop;
        -- Write buffered input if not full
        if instr_buffer_valid = '1' and instr_bus_apply = '1' then
          address_wen(to_integer(instr_buffer_ext)) <= '1';
          address_in(to_integer(instr_buffer_ext)) <= instr_buffer.source_address;
          instr_buffer_valid <= '0';
        end if;
        -- Handle new input
        if instr_bus_wen = '1' and instr_target_base = base_address
          and to_integer(instr_target_ext) < port_count then
          if not addr_full(to_integer(instr_target_ext)) = '1' then
            instr_buffer <= instr_bus;
            instr_buffer_valid <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;

  -- Manage data bus
  valid_help <= '1' when addr_empty(current_port) /= '1' and fu_empty(current_port) /= '1' else '0';
  data_bus_valid <= valid_help;
  data_bus <= (
    source_address => get_full_address(base_address, to_unsigned(current_port, buffer_address_ext_width_c)),
    target_address => data_address_out(current_port),
    value => data_value_out(current_port)
  );

  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        for I in 0 to port_count-1 loop
          data_ren(I) <= '0';
        end loop;
        current_port <= 0;
      else
        for I in 0 to port_count-1 loop
          data_ren(I) <= '0';
        end loop;

        if not valid_help = '1' or data_bus_ren = '1'  then
          if valid_help = '1' and data_bus_ren = '1' then
            data_ren(current_port) <= '1';
          end if;

          for I in 1 to port_count loop
            if addr_empty((current_port+I) mod port_count) /= '1' and fu_empty((current_port+I) mod port_count) /= '1' then
              current_port <= (current_port+I) mod port_count;
              exit;
            end if;
          end loop;
        end if;
      end if;
    end if;
  end process;

  -- Manage FU communication
  fu_full_or : for I in 0 to port_count-1 generate
    first: if I = 0 generate
      full_help(I) <= fu_full(I);
    end generate first;

    last: if I = port_count-1 generate
      fu_input_full <= fu_full(I) or full_help(I-1);
    end generate last;

    other: if I > 0 and I < port_count-1 generate
      full_help(I) <= fu_full(I) or full_help(I-1);
    end generate other;
  end generate fu_full_or;


end Behavioral;
