library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;

library scad_lib;
use scad_lib.Datatypes.ALL;
use scad_lib.Constants.ALL;

entity simple_input_buffer is

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

           data_bus     : in  data_bus_message_t;
           data_bus_wen : in  STD_LOGIC;
           data_bus_ack : out STD_LOGIC;

           fu_output       : out fu_data_t(0 to port_count-1);
           fu_output_valid : out STD_LOGIC;
           fu_output_ren   : in  STD_LOGIC
    );

end simple_input_buffer;

architecture Behavioral of simple_input_buffer is
  type logic_array is array (0 to port_count-1) of std_logic;
  type address_array is array (0 to port_count-1) of buffer_address_t;
  type data_array is array (0 to port_count-1) of data_value_t;

  signal full : logic_array;
  signal empty : logic_array;
  signal busy : logic_array;

  signal address_in : address_array;
  signal address_wen : logic_array;

  signal data_value_in : data_array;
  signal data_address_in : address_array;
  signal data_wen : logic_array;

  signal fu_out : fu_data_t(0 to port_count-1);
  signal fu_valid : logic_array;
  signal fu_ren : std_logic;

  -- Buffers
  signal instr_buffer : instruction_bus_message_t;
  signal instr_buffer_valid : std_logic;

  signal current_full : std_logic;

  -- Addresses
  signal instr_target_base : buffer_base_address_t;
  signal instr_target_ext  : buffer_ext_address_t;
  signal instr_buffer_ext  : buffer_ext_address_t;
  signal data_target_base  : buffer_base_address_t;
  signal data_target_ext   : buffer_ext_address_t;

  -- Helpers
  signal valid_help : logic_array;

begin

  -- Create buffer units
  gen_buffers : for I in 0 to port_count-1 generate
    buf : entity scad_lib.simple_input_buffer_mem_unit
    generic map (
      size => buffer_size
    )

    port map (
      clk2x => clk2x,
      rst => rst,

      full => full(I),
      empty => empty(I),
      busy => busy(I),

      address_in => address_in(I),
      address_wen => address_wen(I),

      data_value_in => data_value_in(I),
      data_address_in => data_address_in(I),
      data_wen => data_wen(I),

      fu_out => fu_out(I),
      fu_valid => fu_valid(I),
      fu_ren => fu_ren
    );
  end generate gen_buffers;

  -- Decode addresses
  instr_target_base <= get_base_address(instr_bus.target_address);
  instr_target_ext <= get_ext_address(instr_bus.target_address);
  instr_buffer_ext <= get_ext_address(instr_buffer.target_address);
  data_target_base <= get_base_address(data_bus.target_address);
  data_target_ext <= get_ext_address(data_bus.target_address);

  -- Manage instruction bus
  instr_bus_full <= full(to_integer(instr_target_ext));

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
          if not full(to_integer(instr_target_ext)) = '1' then
            instr_buffer <= instr_bus;
            instr_buffer_valid <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;

  -- Manage data bus
  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        data_bus_ack <= '0';
        for I in 0 to port_count-1 loop
          data_wen(I) <= '0';
        end loop;
      else
        data_bus_ack <= '0';
        for I in 0 to port_count-1 loop
          data_wen(I) <= '0';
        end loop;
        if data_bus_wen = '1' and data_target_base = base_address
          and to_integer(data_target_ext) < port_count then

          if not busy(to_integer(data_target_ext)) = '1' then
            data_value_in(to_integer(data_target_ext)) <= data_bus.value;
            data_address_in(to_integer(data_target_ext)) <= data_bus.source_address;
            data_wen(to_integer(data_target_ext)) <= '1';
            data_bus_ack <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;

  -- Manage FU communication
  fu_ren <= fu_output_ren;
  fu_output <= fu_out;

  valid_and : for I in 0 to port_count-1 generate
    first: if I = 0 generate
      valid_help(I) <= fu_valid(I) and not empty(I);
    end generate first;

    last: if I = port_count-1 generate
      fu_output_valid <= fu_valid(I) and not empty(I) and valid_help(I-1);
    end generate last;

    other: if I > 0 and I < port_count-1 generate
      valid_help(I) <= fu_valid(I) and not empty(I) and valid_help(I-1);
    end generate other;
  end generate valid_and;

end Behavioral;
