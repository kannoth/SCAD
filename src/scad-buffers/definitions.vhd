library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
package Constants is
	constant data_word_width_c : natural := 32;
	constant buffer_address_base_width_c : natural := 5;
	constant buffer_address_ext_width_c : natural := 3;

	constant buffer_address_width_c : natural := buffer_address_base_width_c + buffer_address_ext_width_c;
end Constants;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library scad_lib;
use scad_lib.Constants.ALL;
package Datatypes is
	subtype buffer_address_t is unsigned(buffer_address_width_c-1 downto 0);
	subtype buffer_base_address_t is unsigned(buffer_address_base_width_c-1 downto 0);
	subtype buffer_ext_address_t is unsigned(buffer_address_ext_width_c-1 downto 0);
	subtype data_value_t is std_logic_vector(data_word_width_c-1 downto 0);

	type reordered_data_t is
		record
			data       : data_value_t;
			jump_count : integer;
		end record;

	type instruction_bus_message_t is
		record
			source_address : buffer_address_t;
			target_address : buffer_address_t;
		end record;

	type data_bus_message_t is
		record
			source_address : buffer_address_t;
			target_address : buffer_address_t;
			value          : data_value_t;
		end record;

	type input_buffer_entry_t is
		record
			source_address : buffer_address_t;
			value          : data_value_t;
			value_valid    : std_logic;
		end record;

	type output_buffer_entry_t is
		record
			target_address : buffer_address_t;
			value          : data_value_t;
		end record;

	type fu_data_t is array(natural range <>) of data_value_t;
	type fu_reorder_data_t is array(natural range <>) of reordered_data_t;

	function to_input_buffer_entry(mem_data : std_logic_vector(buffer_address_width_c + data_word_width_c downto 0))
		return input_buffer_entry_t;

	function from_input_buffer_entry(entry_record : input_buffer_entry_t)
		return std_logic_vector;

	function to_output_buffer_entry(mem_data : std_logic_vector(buffer_address_width_c + data_word_width_c - 1 downto 0))
		return output_buffer_entry_t;

	function from_output_buffer_entry(entry_record : output_buffer_entry_t)
		return std_logic_vector;

	function get_base_address(full_addr : buffer_address_t)
		return buffer_base_address_t;

	function get_ext_address(full_addr : buffer_address_t)
		return buffer_ext_address_t;

	function get_full_address(base_addr : buffer_base_address_t; ext_addr : buffer_ext_address_t)
		return buffer_address_t;

end Datatypes;

package body Datatypes is
	function to_input_buffer_entry(mem_data : std_logic_vector(buffer_address_width_c + data_word_width_c downto 0))
		return input_buffer_entry_t is
		variable result : input_buffer_entry_t;
		begin
			result.source_address := unsigned(mem_data(buffer_address_width_c + data_word_width_c downto data_word_width_c + 1));
			result.value := mem_data(data_word_width_c downto 1);
			result.value_valid := mem_data(0);
			return result;
	end function;

	function from_input_buffer_entry(entry_record : in input_buffer_entry_t)
		return std_logic_vector is
		variable result : std_logic_vector(buffer_address_width_c + data_word_width_c downto 0);
		begin
			result(buffer_address_width_c + data_word_width_c downto data_word_width_c + 1) := std_logic_vector(entry_record.source_address);
			result(data_word_width_c downto 1) := entry_record.value;
			result(0) := entry_record.value_valid;
			return result;
	end function;

	function to_output_buffer_entry(mem_data : std_logic_vector(buffer_address_width_c + data_word_width_c - 1 downto 0))
		return output_buffer_entry_t is
		variable result : output_buffer_entry_t;
		begin
			result.target_address := unsigned(mem_data(buffer_address_width_c + data_word_width_c - 1 downto data_word_width_c));
			result.value := mem_data(data_word_width_c - 1 downto 0);
			return result;
	end function;

	function from_output_buffer_entry(entry_record : in output_buffer_entry_t)
		return std_logic_vector is
		variable result : std_logic_vector(buffer_address_width_c + data_word_width_c - 1 downto 0);
		begin
			result(buffer_address_width_c + data_word_width_c - 1 downto data_word_width_c) := std_logic_vector(entry_record.target_address);
			result(data_word_width_c - 1 downto 0) := entry_record.value;
			return result;
	end function;

	function get_base_address(full_addr : buffer_address_t)
		return buffer_base_address_t is
			variable result : buffer_base_address_t;
		begin
			result := full_addr(buffer_address_width_c-1 downto buffer_address_ext_width_c);
			return result;
	end function;

	function get_ext_address(full_addr : buffer_address_t)
		return buffer_ext_address_t is
			variable result : buffer_ext_address_t;
		begin
			result := full_addr(buffer_address_ext_width_c-1 downto 0);
			return result;
	end function;

	function get_full_address(base_addr : buffer_base_address_t; ext_addr : buffer_ext_address_t)
		return buffer_address_t is
			variable result : buffer_address_t;
		begin
			result(buffer_address_width_c-1 downto buffer_address_ext_width_c) := base_addr;
			result(buffer_address_ext_width_c-1 downto 0) := ext_addr;
			return result;
		end function;
end Datatypes;
