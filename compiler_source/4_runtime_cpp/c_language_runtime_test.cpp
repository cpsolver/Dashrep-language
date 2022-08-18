// -----------------------------------------------
// -----------------------------------------------
//
//  dashrep_c_language_runtime_in_development.cpp
//
// 
// -----------------------------------------------
//
//  COPYRIGHT
//
//  (c) Copyright 2022 by Richard Fobes at
//  www.Dashrep.org.
//
//
// -----------------------------------------------
//  Begin code.
// -----------------------------------------------


// -----------------------------------------------
//  Specify libraries needed.

#include <iostream>
#include <fstream>
#include <string>
#include <cstring>
#include <cstdio>

//  Temporarily for displaying decimal numbers:
#include <iomanip>


// -----------------------------------------------
//  Reminder:  This software is not an
//  "application" that involves a "user interface"
//  that enables a user to control this software.
//  Therefore some of the coding conventions
//  needed for "application" software -- which
//  often changes to make it increasingly easier
//  to use -- is not relevant to this low-level
//  "utility" software.
//
//  Function-specific variables are avoided for
//  functions that are used frequently.  The
//  result is faster execution.


// -----------------------------------------------
//  Declare constants global_yes and global_no.
//  They are used instead of "true" and "false"
//  values because true and false involve making
//  a claim that might be false, whereas asking a
//  question involves a "yes" or "no" answer.
//  Also, this convention matches earlier versions
//  of the Dashrep compiler in other programming
//  languages.

const int global_no = 0 ;
const int global_yes = 1 ;


// -----------------------------------------------
//  Declare the text storage list.  It contains
//  all the text characters, and all the text item
//  ID pointers that point to either other text
//  items or text characters.  The characters are
//  stored here as INTEGERS, not as bytes!

int global_storage_all_text[ 100000 ] ;


// -----------------------------------------------
//  Declare how much of the text storage area is
//  used for file input and output (each).  And
//  declare the default size of a text item when
//  the full needed size is unknown.

const int global_allocated_length_for_file_input_or_output = 2000 ;
const int global_default_length_for_text_item = 25 ;


// -----------------------------------------------
//  Declare the pointers, lengths, and other
//  information that is needed for each text item.
//
//  If the "begin" text pointer is incremented and
//  there is a need to later move it back to the
//  original beginning, simply point to the prior
//  text item and get the "allocation_end" pointer
//  and add one.

const int global_length_of_lists_for_text = 20000 ;

int global_text_pointer_allocation_end_for_item[ 20005 ] ;
int global_text_pointer_begin_for_item[ 20005 ] ;
int global_text_pointer_end_for_item[ 20005 ] ;
int global_text_category_for_item[ 20005 ] ;
int global_id_of_item_containing_definition_for_item[ 20005 ] ;


// -----------------------------------------------
//  Declare variables that keep track of the next
//  available text item ID number, and the
//  beginning location for storing each new text
//  item, and the length of the storage allocated.

int global_next_available_text_item_id ;
int global_next_available_begin_pointer_for_next_available_text_item_id ;
int global_length_requested_for_next_text_item_storage ;

int global_id_pointer_stack_for_getting_next_character ;


// -----------------------------------------------
//  Declare global variables that hold text item
//  ID numbers.

int global_new_storage_text_item_id ;
int global_text_item_id ;
int global_text_item_id_saved ;
int global_text_item_id_from_origin ;
int global_text_item_id_to_edit ;
int global_text_item_id_to_truncate ;
int global_text_item_id_to_find ;
int global_text_item_id_to_search ;
int global_text_item_id_for_copy ;
int global_text_item_id_for_file_input ;
int global_text_item_id_for_file_output ;
int global_text_item_id_for_valid_filename ;
int global_text_item_id_for_valid_folder_name ;
int global_text_item_id_for_number_as_text ;
int global_text_item_id_for_float_as_text ;
int global_text_item_id_for_integers_as_text ;
int global_text_item_id_for_list_of_integers ;
int global_text_item_id_for_pointer_begin_end ;
int global_text_item_id_for_next_word ;
int global_text_item_id_for_next_word_begin ;
int global_text_item_id_for_next_word_end ;
int global_text_item_id_last_predefined ;

int global_text_item_with_next_character ;
int global_text_item_with_previous_character ;
int global_text_item_one ;
int global_text_item_two ;

int global_text_item_id_for_single_space ;
int global_text_item_id_for_single_hyphen ;
int global_text_item_id_for_single_underscore ;
int global_text_item_id_for_single_newline ;
int global_text_item_id_for_single_carriage_return ;
int global_text_item_id_for_single_open_angle_bracket ;
int global_text_item_id_for_single_close_angle_bracket ;
int global_text_item_id_for_single_slash ;
int global_text_item_id_for_single_backslash ;
int global_text_item_id_for_single_plus ;
int global_text_item_id_for_single_period ;
int global_text_item_id_for_single_apostrophe ;
int global_text_item_id_for_single_quotation_mark ;
int global_text_item_id_for_single_tab ;
int global_text_item_id_for_single_formfeed ;
int global_text_item_id_for_empty_text ;
int global_text_item_id_for_non_breaking_space ;
int global_text_item_id_for_four_hyphens ;

int global_text_item_id_for_word_character ;
int global_text_item_id_for_word_space ;
int global_text_item_id_for_word_hyphen ;
int global_text_item_id_for_word_hyphens ;
int global_text_item_id_for_word_newline ;
int global_text_item_id_for_word_four ;
int global_text_item_id_for_word_non ;
int global_text_item_id_for_word_breaking ;
int global_text_item_id_for_word_tab ;
int global_text_item_id_for_word_empty ;
int global_text_item_id_for_word_text ;
int global_text_item_id_for_word_underscore ;

int global_id_for_phrase_name_hyphen_here ;
int global_id_for_phrase_name_character_hyphen ;
int global_id_for_phrase_name_four_hyphens ;
int global_id_for_phrase_name_no_space ;
int global_id_for_phrase_name_empty_text ;
int global_id_for_phrase_name_one_space ;
int global_id_for_phrase_name_character_space ;
int global_id_for_phrase_name_non_breaking_space ;
int global_id_for_phrase_name_new_line ;
int global_id_for_phrase_name_empty_line ;
int global_id_for_phrase_name_line_break ;
int global_id_for_phrase_name_character_newline ;
int global_id_for_phrase_name_character_tab ;
int global_id_for_phrase_name_character_underscore ;
int global_id_for_phrase_name_expand_text ;
int global_id_for_phrase_name_standard_output ;
int global_id_for_phrase_name_copy_text ;
int global_id_for_phrase_name_append_text ;
int global_id_for_phrase_name_append_text_no_space ;
int global_id_for_phrase_name_append_new_line ;
int global_id_for_phrase_name_append_repeatedly_using_count ;
int global_id_for_phrase_name_prepend_text ;
int global_id_for_phrase_name_prepend_text_no_space ;
int global_id_for_phrase_name_put_into_phrase ;
int global_id_for_phrase_name_get_phrase_name_from_phrase ;
int global_id_for_phrase_name_get_cgi_information ;
int global_id_for_phrase_name_get_definitions_from_phrase ;
int global_id_for_phrase_name_put_listed_phrase_definitions_into_phrase ;
int global_id_for_phrase_name_copy_listed_words_to_phrases_named_in_pattern ;
int global_id_for_phrase_name_append_multiple_from_phrases_named_in_pattern ;
int global_id_for_phrase_name_clear_phrase ;
int global_id_for_phrase_name_clear_listed_phrases ;
int global_id_for_phrase_name_delete_listed_phrases ;
int global_id_for_phrase_name_if_yes_begin ;
int global_id_for_phrase_name_if_no_begin ;
int global_id_for_phrase_name_if_else ;
int global_id_for_phrase_name_if_end ;
int global_id_for_phrase_name_yes_or_no_empty_phrase ;
int global_id_for_phrase_name_yes_or_no_same_two_phrase_definitions ;
int global_id_for_phrase_name_yes_or_no_same_two_words ;
int global_id_for_phrase_name_yes_or_no_opposite ;
int global_id_for_phrase_name_yes_if_all_yes ;
int global_id_for_phrase_name_yes_if_any_yes ;
int global_id_for_phrase_name_no_if_any_no ;
int global_id_for_phrase_name_yes_if_not_no ;
int global_id_for_phrase_name_no_if_not_yes ;
int global_id_for_phrase_name_use_handler_with_each_word_in_phrase ;
int global_id_for_phrase_name_word_to_use_in_handler ;
int global_id_for_phrase_name_get_count_of_words ;
int global_id_for_phrase_name_get_word_at_position ;
int global_id_for_phrase_name_get_position_of_word ;
int global_id_for_phrase_name_copy_word_at_position ;
int global_id_for_phrase_name_copy_words_from_position_to_position ;
int global_id_for_phrase_name_copy_words_offset_skip ;
int global_id_for_phrase_name_copy_words_found_in_both_lists ;
int global_id_for_phrase_name_copy_words_found_in_either_list ;
int global_id_for_phrase_name_copy_words_found_only_in_first_list ;
int global_id_for_phrase_name_copy_words_that_begin_with_text ;
int global_id_for_phrase_name_copy_words_that_begin_with_listed_words ;
int global_id_for_phrase_name_copy_words_that_contain_listed_words ;
int global_id_for_phrase_name_copy_words_unique_only ;
int global_id_for_phrase_name_list_of_unique_word_counts ;
int global_id_for_phrase_name_list_of_pointers_to_unique_words ;
int global_id_for_phrase_name_copy_words_order_reversed ;
int global_id_for_phrase_name_copy_words_sort_numeric ;
int global_id_for_phrase_name_copy_words_rearrange_using_order_sort_numeric ;
int global_id_for_phrase_name_copy_words_sort_alphabetic ;
int global_id_for_phrase_name_copy_words_rearrange_using_order_sort_alphabetic ;
int global_id_for_phrase_name_generate_counts_from_integer_to_integer ;
int global_id_for_phrase_name_generate_every_pairwise_combination_of_words ;
int global_id_for_phrase_name_generate_every_ordered_pairwise_combination_of_words ;
int global_id_for_phrase_name_generate_list_of_all_dashrep_phrases ;
int global_id_for_phrase_name_get_count_of_characters ;
int global_id_for_phrase_name_get_characters_from_position_to_position ;
int global_id_for_phrase_name_copy_characters_from_position_to_position ;
int global_id_for_phrase_name_copy_without_extra_spaces ;
int global_id_for_phrase_name_copy_lowercase_only ;
int global_id_for_phrase_name_copy_uppercase_only ;
int global_id_for_phrase_name_copy_initial_caps ;
int global_id_for_phrase_name_copy_zero_pad_left_to_length ;
int global_id_for_phrase_name_encode_as_cgi_parameter ;
int global_id_for_phrase_name_decode_from_cgi_parameter ;
int global_id_for_phrase_name_convert_unicode_to_html_entities ;
int global_id_for_phrase_name_get_position_of_matching_text ;
int global_id_for_phrase_name_copy_and_replace ;
int global_id_for_phrase_name_copy_and_replace_using_paired_listed_words ;
int global_id_for_phrase_name_generate_positions_of_listed_words ;
int global_id_for_phrase_name_generate_positions_of_delimiter ;
int global_id_for_phrase_name_generate_positions_of_first_matching_delimiter_after_listed_positions ;
int global_id_for_phrase_name_get_current_time_in_epoch_seconds ;
int global_id_for_phrase_name_split_epoch_seconds_into_named_components ;
int global_id_for_phrase_name_split_epoch_seconds_into_named_components_for_zero_meridian ;
int global_id_for_phrase_name_time_day_of_month ;
int global_id_for_phrase_name_time_day_of_week ;
int global_id_for_phrase_name_time_day_of_year ;
int global_id_for_phrase_name_time_hour ;
int global_id_for_phrase_name_time_minute ;
int global_id_for_phrase_name_time_month_number ;
int global_id_for_phrase_name_time_second ;
int global_id_for_phrase_name_time_year ;
int global_id_for_phrase_name_zero_or_nonzero ;
int global_id_for_phrase_name_zero_one_multiple ;
int global_id_for_phrase_name_numeric_equal_greater_less_compare ;
int global_id_for_phrase_name_numeric_add ;
int global_id_for_phrase_name_numeric_minus ;
int global_id_for_phrase_name_numeric_multiply ;
int global_id_for_phrase_name_numeric_divide_by ;
int global_id_for_phrase_name_numeric_maximum ;
int global_id_for_phrase_name_numeric_minimum ;
int global_id_for_phrase_name_numeric_increment ;
int global_id_for_phrase_name_numeric_decrement ;
int global_id_for_phrase_name_numeric_integer ;
int global_id_for_phrase_name_numeric_absolute ;
int global_id_for_phrase_name_numeric_odd_or_even ;
int global_id_for_phrase_name_numeric_square_root ;
int global_id_for_phrase_name_numeric_sine ;
int global_id_for_phrase_name_numeric_cosine ;
int global_id_for_phrase_name_numeric_logarithm_base_e ;
int global_id_for_phrase_name_numeric_logarithm_base_10 ;
int global_id_for_phrase_name_numeric_pi ;
int global_id_for_phrase_name_numeric_vector_add_number ;
int global_id_for_phrase_name_numeric_vector_multiply_by_number ;
int global_id_for_phrase_name_numeric_vectors_add ;
int global_id_for_phrase_name_numeric_vectors_multiply ;
int global_id_for_phrase_name_numeric_vectors_divide_by ;
int global_id_for_phrase_name_numeric_vector_integers ;
int global_id_for_phrase_name_numeric_vector_absolutes ;
int global_id_for_phrase_name_numeric_vectors_from_delta_values_calculate_distances ;
int global_id_for_phrase_name_numeric_two_dimensional_sort_into_columns_and_rows ;
int global_id_for_phrase_name_numeric_y_map_tile_number_based_on_latitude ;
int global_id_for_phrase_name_numeric_map_tile_zoom ;
int global_id_for_phrase_name_copy_and_move_attributes_into_xml_tags ;
int global_id_for_phrase_name_copy_and_remove_attributes_from_xml_tags ;
int global_id_for_phrase_name_yes_or_no_permission_to_append_to_files ;
int global_id_for_phrase_name_yes_or_no_permission_to_delete_or_overwrite_files ;
int global_id_for_phrase_name_dashrep_path_prefix_for_file_reading ;
int global_id_for_phrase_name_dashrep_path_prefix_for_file_writing ;
int global_id_for_phrase_name_operating_system_slash_or_backslash ;
int global_id_for_phrase_name_dashrep_file_name_if_read_file_missing ;
int global_id_for_phrase_name_generate_list_of_files_in_current_read_directory ;
int global_id_for_phrase_name_generate_list_of_folders_in_current_read_directory ;
int global_id_for_phrase_name_yes_or_no_file_exists ;
int global_id_for_phrase_name_yes_or_no_folder_exists ;
int global_id_for_phrase_name_size_of_file ;
int global_id_for_phrase_name_modification_time_of_file ;
int global_id_for_phrase_name_set_file_permission_public_read ;
int global_id_for_phrase_name_set_file_permission_private ;
int global_id_for_phrase_name_set_file_permission_private_but_executable ;
int global_id_for_phrase_name_rename_file ;
int global_id_for_phrase_name_delete_file ;
int global_id_for_phrase_name_create_empty_sub_folder ;
int global_id_for_phrase_name_copy_from_file_to_phrase ;
int global_id_for_phrase_name_end_of_line_indicator ;
int global_id_for_phrase_name_text_end_of_line_here_space_delimited ;
int global_id_for_phrase_name_yes_or_no_trim_spaces_when_copy_from_file ;
int global_id_for_phrase_name_yes_or_no_skip_empty_lines_when_copy_from_file ;
int global_id_for_phrase_name_copy_from_phrase_append_to_file ;
int global_id_for_phrase_name_copy_append_file_to_file ;
int global_id_for_phrase_name_linewise_read_from_file_and_use_handler ;
int global_id_for_phrase_name_linewise_input_line_from_file ;
int global_id_for_phrase_name_linewise_input_line_count ;
int global_id_for_phrase_name_linewise_read_from_standard_input ;
int global_id_for_phrase_name_get_url_resource ;
int global_id_for_phrase_name_trace_from_get_url_resource ;
int global_id_for_phrase_name_find_line_in_file_that_begins_with_text ;
int global_id_for_phrase_name_find_lines_in_file_that_begin_with_any_listed_word ;
int global_id_for_phrase_name_find_lines_in_file_that_begin_with_any_two_words_listed ;
int global_id_for_phrase_name_copy_from_columns_in_file_to_named_phrases ;
int global_id_for_phrase_name_copy_from_columns_in_file_to_column_lists ;
int global_id_for_phrase_name_yes_or_no_use_two_spaces_as_column_delimiter ;
int global_id_for_phrase_name_gather_tagged_info_from_file ;
int global_id_for_phrase_name_gather_from_tagged_file_one_entry ;
int global_id_for_phrase_name_write_gathered_listed_items_to_end_of_file ;
int global_id_for_phrase_name_dashrep_gather_tag_begin ;
int global_id_for_phrase_name_dashrep_gather_tag_end ;
int global_id_for_phrase_name_dashrep_gather_tag_unique ;
int global_id_for_phrase_name_dashrep_gather_tag_delete ;
int global_id_for_phrase_name_dashrep_gather_tag_matching_id ;
int global_id_for_phrase_name_trace_show ;
int global_id_for_phrase_name_trace_show_where ;
int global_id_for_phrase_name_output_trace_file_name ;
int global_id_for_phrase_name_dashrep_comments_ignored ;
int global_id_for_phrase_name_generate_phrase_usage_counts ;
int global_id_for_phrase_name_exit_from_dashrep ;
int global_id_for_phrase_name_dashrep_language_yes ;
int global_id_for_phrase_name_dashrep_version ;
int global_id_for_phrase_name_delayed_nospace ;
int global_id_for_phrase_name_delayed_newline ;
int global_id_for_phrase_name_yes_or_no_permission_administrator ;
int global_id_for_phrase_name_dashrep_endless_loop_counter_limit ;
int global_id_for_phrase_name_dashrep_time_limit ;

int global_id_for_phrase_name_placeholder_for_hyphen_here ;
int global_id_for_phrase_name_placeholder_for_new_line ;
int global_id_for_phrase_name_placeholder_for_empty_line ;

int global_id_for_phrase_word_10 ;
int global_id_for_phrase_word_absolute ;
int global_id_for_phrase_word_absolutes ;
int global_id_for_phrase_word_add ;
int global_id_for_phrase_word_administrator ;
int global_id_for_phrase_word_after ;
int global_id_for_phrase_word_all ;
int global_id_for_phrase_word_alphabetic ;
int global_id_for_phrase_word_and ;
int global_id_for_phrase_word_any ;
int global_id_for_phrase_word_append ;
int global_id_for_phrase_word_as ;
int global_id_for_phrase_word_at ;
int global_id_for_phrase_word_attributes ;
int global_id_for_phrase_word_backslash ;
int global_id_for_phrase_word_base ;
int global_id_for_phrase_word_based ;
int global_id_for_phrase_word_begin ;
int global_id_for_phrase_word_begins ;
int global_id_for_phrase_word_both ;
int global_id_for_phrase_word_break ;
int global_id_for_phrase_word_breaking ;
int global_id_for_phrase_word_but ;
int global_id_for_phrase_word_by ;
int global_id_for_phrase_word_calculate ;
int global_id_for_phrase_word_caps ;
int global_id_for_phrase_word_cgi ;
int global_id_for_phrase_word_character ;
int global_id_for_phrase_word_characters ;
int global_id_for_phrase_word_clear ;
int global_id_for_phrase_word_column ;
int global_id_for_phrase_word_columns ;
int global_id_for_phrase_word_combination ;
int global_id_for_phrase_word_comments ;
int global_id_for_phrase_word_compare ;
int global_id_for_phrase_word_components ;
int global_id_for_phrase_word_contain ;
int global_id_for_phrase_word_convert ;
int global_id_for_phrase_word_copy ;
int global_id_for_phrase_word_cosine ;
int global_id_for_phrase_word_count ;
int global_id_for_phrase_word_counter ;
int global_id_for_phrase_word_counts ;
int global_id_for_phrase_word_create ;
int global_id_for_phrase_word_current ;
int global_id_for_phrase_word_dashrep ;
int global_id_for_phrase_word_day ;
int global_id_for_phrase_word_decode ;
int global_id_for_phrase_word_decrement ;
int global_id_for_phrase_word_definitions ;
int global_id_for_phrase_word_delayed ;
int global_id_for_phrase_word_delete ;
int global_id_for_phrase_word_delimited ;
int global_id_for_phrase_word_delimiter ;
int global_id_for_phrase_word_delta ;
int global_id_for_phrase_word_dimensional ;
int global_id_for_phrase_word_directory ;
int global_id_for_phrase_word_distances ;
int global_id_for_phrase_word_divide ;
int global_id_for_phrase_word_e ;
int global_id_for_phrase_word_each ;
int global_id_for_phrase_word_either ;
int global_id_for_phrase_word_else ;
int global_id_for_phrase_word_empty ;
int global_id_for_phrase_word_encode ;
int global_id_for_phrase_word_end ;
int global_id_for_phrase_word_endless ;
int global_id_for_phrase_word_entities ;
int global_id_for_phrase_word_entry ;
int global_id_for_phrase_word_epoch ;
int global_id_for_phrase_word_equal ;
int global_id_for_phrase_word_even ;
int global_id_for_phrase_word_every ;
int global_id_for_phrase_word_executable ;
int global_id_for_phrase_word_exists ;
int global_id_for_phrase_word_exit ;
int global_id_for_phrase_word_expand ;
int global_id_for_phrase_word_extra ;
int global_id_for_phrase_word_file ;
int global_id_for_phrase_word_files ;
int global_id_for_phrase_word_find ;
int global_id_for_phrase_word_first ;
int global_id_for_phrase_word_folder ;
int global_id_for_phrase_word_folders ;
int global_id_for_phrase_word_for ;
int global_id_for_phrase_word_found ;
int global_id_for_phrase_word_four ;
int global_id_for_phrase_word_from ;
int global_id_for_phrase_word_gather ;
int global_id_for_phrase_word_gathered ;
int global_id_for_phrase_word_generate ;
int global_id_for_phrase_word_get ;
int global_id_for_phrase_word_greater ;
int global_id_for_phrase_word_handler ;
int global_id_for_phrase_word_here ;
int global_id_for_phrase_word_hour ;
int global_id_for_phrase_word_html ;
int global_id_for_phrase_word_hyphen ;
int global_id_for_phrase_word_hyphens ;
int global_id_for_phrase_word_id ;
int global_id_for_phrase_word_if ;
int global_id_for_phrase_word_ignored ;
int global_id_for_phrase_word_in ;
int global_id_for_phrase_word_increment ;
int global_id_for_phrase_word_indicator ;
int global_id_for_phrase_word_info ;
int global_id_for_phrase_word_information ;
int global_id_for_phrase_word_initial ;
int global_id_for_phrase_word_input ;
int global_id_for_phrase_word_integer ;
int global_id_for_phrase_word_integers ;
int global_id_for_phrase_word_into ;
int global_id_for_phrase_word_items ;
int global_id_for_phrase_word_language ;
int global_id_for_phrase_word_latitude ;
int global_id_for_phrase_word_left ;
int global_id_for_phrase_word_length ;
int global_id_for_phrase_word_less ;
int global_id_for_phrase_word_limit ;
int global_id_for_phrase_word_line ;
int global_id_for_phrase_word_lines ;
int global_id_for_phrase_word_linewise ;
int global_id_for_phrase_word_list ;
int global_id_for_phrase_word_listed ;
int global_id_for_phrase_word_lists ;
int global_id_for_phrase_word_logarithm ;
int global_id_for_phrase_word_loop ;
int global_id_for_phrase_word_lowercase ;
int global_id_for_phrase_word_map ;
int global_id_for_phrase_word_matching ;
int global_id_for_phrase_word_maximum ;
int global_id_for_phrase_word_meridian ;
int global_id_for_phrase_word_minimum ;
int global_id_for_phrase_word_minus ;
int global_id_for_phrase_word_minute ;
int global_id_for_phrase_word_missing ;
int global_id_for_phrase_word_modification ;
int global_id_for_phrase_word_month ;
int global_id_for_phrase_word_move ;
int global_id_for_phrase_word_multiple ;
int global_id_for_phrase_word_multiply ;
int global_id_for_phrase_word_name ;
int global_id_for_phrase_word_named ;
int global_id_for_phrase_word_new ;
int global_id_for_phrase_word_newline ;
int global_id_for_phrase_word_no ;
int global_id_for_phrase_word_non ;
int global_id_for_phrase_word_nonzero ;
int global_id_for_phrase_word_nospace ;
int global_id_for_phrase_word_not ;
int global_id_for_phrase_word_number ;
int global_id_for_phrase_word_numeric ;
int global_id_for_phrase_word_odd ;
int global_id_for_phrase_word_of ;
int global_id_for_phrase_word_offset ;
int global_id_for_phrase_word_on ;
int global_id_for_phrase_word_one ;
int global_id_for_phrase_word_only ;
int global_id_for_phrase_word_operating ;
int global_id_for_phrase_word_opposite ;
int global_id_for_phrase_word_or ;
int global_id_for_phrase_word_order ;
int global_id_for_phrase_word_ordered ;
int global_id_for_phrase_word_output ;
int global_id_for_phrase_word_overwrite ;
int global_id_for_phrase_word_pad ;
int global_id_for_phrase_word_paired ;
int global_id_for_phrase_word_pairwise ;
int global_id_for_phrase_word_parameter ;
int global_id_for_phrase_word_path ;
int global_id_for_phrase_word_pattern ;
int global_id_for_phrase_word_permission ;
int global_id_for_phrase_word_phrase ;
int global_id_for_phrase_word_phrases ;
int global_id_for_phrase_word_pi ;
int global_id_for_phrase_word_pointers ;
int global_id_for_phrase_word_position ;
int global_id_for_phrase_word_positions ;
int global_id_for_phrase_word_prefix ;
int global_id_for_phrase_word_prepend ;
int global_id_for_phrase_word_private ;
int global_id_for_phrase_word_public ;
int global_id_for_phrase_word_put ;
int global_id_for_phrase_word_read ;
int global_id_for_phrase_word_reading ;
int global_id_for_phrase_word_rearrange ;
int global_id_for_phrase_word_remove ;
int global_id_for_phrase_word_rename ;
int global_id_for_phrase_word_repeatedly ;
int global_id_for_phrase_word_replace ;
int global_id_for_phrase_word_resource ;
int global_id_for_phrase_word_reversed ;
int global_id_for_phrase_word_root ;
int global_id_for_phrase_word_rows ;
int global_id_for_phrase_word_same ;
int global_id_for_phrase_word_second ;
int global_id_for_phrase_word_seconds ;
int global_id_for_phrase_word_set ;
int global_id_for_phrase_word_show ;
int global_id_for_phrase_word_sine ;
int global_id_for_phrase_word_size ;
int global_id_for_phrase_word_skip ;
int global_id_for_phrase_word_slash ;
int global_id_for_phrase_word_sort ;
int global_id_for_phrase_word_space ;
int global_id_for_phrase_word_spaces ;
int global_id_for_phrase_word_split ;
int global_id_for_phrase_word_square ;
int global_id_for_phrase_word_standard ;
int global_id_for_phrase_word_sub ;
int global_id_for_phrase_word_system ;
int global_id_for_phrase_word_tab ;
int global_id_for_phrase_word_tag ;
int global_id_for_phrase_word_tagged ;
int global_id_for_phrase_word_tags ;
int global_id_for_phrase_word_text ;
int global_id_for_phrase_word_that ;
int global_id_for_phrase_word_tile ;
int global_id_for_phrase_word_time ;
int global_id_for_phrase_word_to ;
int global_id_for_phrase_word_trace ;
int global_id_for_phrase_word_trim ;
int global_id_for_phrase_word_two ;
int global_id_for_phrase_word_underscore ;
int global_id_for_phrase_word_unicode ;
int global_id_for_phrase_word_unique ;
int global_id_for_phrase_word_uppercase ;
int global_id_for_phrase_word_url ;
int global_id_for_phrase_word_usage ;
int global_id_for_phrase_word_use ;
int global_id_for_phrase_word_using ;
int global_id_for_phrase_word_values ;
int global_id_for_phrase_word_vector ;
int global_id_for_phrase_word_vectors ;
int global_id_for_phrase_word_version ;
int global_id_for_phrase_word_week ;
int global_id_for_phrase_word_when ;
int global_id_for_phrase_word_where ;
int global_id_for_phrase_word_with ;
int global_id_for_phrase_word_without ;
int global_id_for_phrase_word_word ;
int global_id_for_phrase_word_words ;
int global_id_for_phrase_word_write ;
int global_id_for_phrase_word_writing ;
int global_id_for_phrase_word_xml ;
int global_id_for_phrase_word_y ;
int global_id_for_phrase_word_year ;
int global_id_for_phrase_word_yes ;
int global_id_for_phrase_word_zero ;
int global_id_for_phrase_word_zoom ;
int global_id_for_phrase_word_placeholder ;

int global_message_trace__expand_phrases__endless_loop ;


// -----------------------------------------------
//  Declare pointers that point to portions of the
//  text items.  These first-in-last-out stacks
//  are overwritten when a new action begins (if
//  the action needs these pointers).

int global_text_id_number_for_action_stack_position[ 2005 ] ;
int global_position_in_text_item_for_action_stack_position[ 2005 ] ;
int global_next_action_stack_position_for_action_stack_position[ 2005 ] ;


// -----------------------------------------------
//  Declare some text pointers.

int global_text_pointer_begin ;
int global_text_pointer_end ;


// -----------------------------------------------
//  Declare a list of hyphenated phrase names that
//  are stored as text items.  Also declare text
//  item pointers that are used when searching for
//  a matching hyphenated phrase name.

const int global_maximum_number_of_hyphenated_phrase_names_in_text_items = 5000 ;
int global_number_of_hyphenated_phrase_names_in_text_items ;
int global_list_of_hyphenated_phrase_text_items[ 5005 ] ;
int global_position_in_list_of_hyphenated_phrase_text_items ;
int global_looking_at_hyphenated_phrase_name_in_text_item_id ;
int global_text_item_id_of_matching_hyphenated_phrase_name ;


// -----------------------------------------------
//  Declare two lists of pointers that point to
//  the words of a hyphenated phrase name.  This
//  is where such a name is stored while checking
//  for a match with an existing hyphenated phrase
//  name.  Allow 30 words for the longest phrase
//  name.  Array position counting starts at 1,
//  not zero.  Also declare related pointers.

const int global_maximum_words_in_hyphenated_phrase_name = 30 ;
int global_word_count_parsed_hyphenated_phrase_name ;
int global_parsed_hyphenated_phrase_name_pointer_begin_for_word[ 32 ] ;
int global_parsed_hyphenated_phrase_name_pointer_end_for_word[ 32 ] ;
int global_word_position_in_parsed_hyphenated_phrase_name ;


// -----------------------------------------------
//  Declare a "char" data type that is used to
//  access a double-quoted text word in this code.

const int global_allocated_length_for_this_word = 200 ;
char global_this_word[ 205 ] ;


// -----------------------------------------------
//  Declare a pointer that is used to store
//  C language text into global_storage_all_text.

int global_next_character_position_in_storage_all_text ;


// -----------------------------------------------
//  Declare lists that are used to more quickly
//  find matching defined phrase names.  Only the
//  hyphenated phrases that are defined are
//  stored here, not all hyphenated phrases.

int global_id_for_defined_phrase_name_number[ 20000 ] ;
int global_first_word_id_for_defined_phrase_name_number[ 20000 ] ;
int global_last_word_id_for_defined_phrase_name_number[ 20000 ] ;


// -----------------------------------------------
//  Declare variables that point to the lists that
//  contain information about defined phrase
//  names.

int global_defined_phrase_number ;
int global_next_available_defined_phrase_number ;


// -----------------------------------------------
//  Declare text "contains" categories.
//
//  A text item can contain any of the following
//  categories.
//
//  * "unicode_anything"
//    Characters of any kind, with each character
//    being stored as an integer.  This allows
//    Unicode characters.  In particular,
//    each integer can represent one
//    Chinese character.
//
//  * "unicode_no_delimiters"
//    A text item of category
//   "unicode_no_delimiters" does not contain any
//    spaces, hyphens, underscores, tabs,
//    newlines, etc.  This category is used to
//    hold the words in a hyphenated phrase name,
//    and to hold one of the words in a list of
//    space-delimited words.  It is used to
//    increase software execution speed.
//
//  * "list_of_text_item_ids"
//    Pointers to other text items that are
//    handled as "sub text items".
//
//  * "pointer_pair"
//    Just one pair of pointers that directly
//    point to the beginning and end of text in
//    the storage area.  This type of item is used
//    to point to a word within a longer text
//    item.
//
//  * "hyphenated_phrase"
//    A list of text item IDs that only point to
//    "unicode_no_delimiters" text items.  The result is
//    a valid hyphenated phrase name -- which is
//    not necessarily a defined phrase name.  Each
//    pair of words is assumed to be separated by
//    one hyphen, without explicitly storing those
//    hyphens.  Each of the linked words must be
//    the same text item as used in any other
//    hyphenated phrase name that includes that
//    same word.  This convention allows searching
//    for a phrase name just by looking at the
//    text item IDs of the words in the phrase
//    name.  Note that this convention does not
//    allow a leading or trailing hyphen, and
//    does not allow two or more adjacent
//    hyphens.
//
//  * "list_of_integers"
//    A list of integers.  These are generated
//    when an integer calculation is done, such as
//    adding two vectors of integers.  And this
//    list is generated prior to a request for
//    integer math, such as incrementing.
//    This convention regards the integers as
//    being separated by one space between each
//    pair of integers, without those spaces
//    being explicitly stored.  If a list of
//    numbers includes even one decimal number,
//    the "pointers_to_decimal_numbers" category
//    must be used.  This storage type increases
//    speed by eliminating unneeded conversions
//    of numbers between text type and the "int"
//    data type.
//
//  * "pointers_to_decimal_numbers"
//    A list of pointers to decimal numbers.  The
//    decimal numbers are stored separately in a
//    "float" array.  Each pair of pointers is
//    assumed to be separated by one space, without
//    explicitly storing those spaces.  This
//    convention increases speed by eliminating
//    unneeded conversions of numbers between text
//    type and the "float" data type.
//
//  A list can contain just one item.
//
//  These categories are stored in the array named
//  global_text_category_for_item.

int global_text_item_category ;
const int global_category_contains_unicode_anything = 1 ;
const int global_category_contains_unicode_no_delimiters = 2 ;
const int global_category_contains_list_of_text_item_ids = 3 ;
const int global_category_contains_hyphenated_phrase_name = 4 ;
const int global_category_contains_list_of_integers = 5 ;
const int global_category_contains_pointers_to_decimal_numbers = 6 ;
const int global_category_contains_pointer_pair = 7 ;


// -----------------------------------------------
//  Declare variables that store "text contains"
//  category values.

int global_text_contains_category ;
int global_to_text_contains_category ;
int global_from_text_contains_category ;


// -----------------------------------------------
//  Declare a list of the sub-items of category
//  "unicode_no_delimiters" that hold words used
//  hyphenated phrases.

int gloal_pointer_to_text_item_unicode_no_delimiters ;
const int gloal_maximum_number_of_text_items_unicode_no_delimiters = 2000 ;
int global_list_of_text_items_unicode_no_delimiters[ 2005 ] ;


// -----------------------------------------------
//  Declare character numbers, character pointers,
//  and character counts.

int global_single_character ;
int global_next_character_number ;
int global_line_character_position ;
int global_character_pointer ;
int global_character_pointer_for_text_item ;
int global_character_count ;
int global_character_count_for_expand_text ;
int global_length_of_matching_text ;
int global_character_pointer_if_category_pointer_pair ;
int global_character_offset ;
int global_character_length ;


// -----------------------------------------------
//  Declare character categories, and a list that
//  converts a character's ASCII code into one of
//  these character categories.

const int global_length_of_list_of_character_numbers = 256 ;

int global_character_category_number_for_character_number[ 260 ] ;
int global_character_category ;

const int global_character_category_empty = 0 ;
const int global_character_category_other = 1 ;
const int global_character_category_hyphen = 2 ;  // also used as minus sign
const int global_character_category_space = 3 ;
const int global_character_category_underscore = 4 ;
const int global_character_category_newline = 5 ;
const int global_character_category_tab = 6 ;
const int global_character_category_slash = 7 ;
const int global_character_category_backslash = 8 ;
const int global_character_category_open_angle_bracket = 9 ;
const int global_character_category_close_angle_bracket = 10 ;
const int global_character_category_quotation_mark = 11 ;  // double quotation mark
const int global_character_category_apostrophe = 12 ;  // also single quotation mark
const int global_character_category_period = 13 ;  // also used as decimal point
const int global_character_category_plus_sign = 14 ;
const int global_character_category_digit = 15 ;  // 0 through 9
const int global_character_category_symbol = 16 ;


// -----------------------------------------------
//  Define some ASCII codes.

const int global_ascii_code_for_tab = 9 ;
const int global_ascii_code_for_newline = 10 ;
const int global_ascii_code_for_formfeed = 12 ;
const int global_ascii_code_for_carriage_return = 13 ;
const int global_ascii_code_for_space = 32 ;
const int global_ascii_code_for_quotation_mark = 34 ;
const int global_ascii_code_for_apostrophe = 39 ;
const int global_ascii_code_for_plus = 43 ;
const int global_ascii_code_for_hyphen = 45 ;
const int global_ascii_code_for_period = 46 ;
const int global_ascii_code_for_slash = 47 ;
const int global_ascii_code_for_digit_0 = 48 ;
const int global_ascii_code_for_digit_1 = 49 ;
const int global_ascii_code_for_digit_2 = 50 ;
const int global_ascii_code_for_digit_3 = 51 ;
const int global_ascii_code_for_digit_4 = 52 ;
const int global_ascii_code_for_digit_5 = 53 ;
const int global_ascii_code_for_digit_6 = 54 ;
const int global_ascii_code_for_digit_7 = 55 ;
const int global_ascii_code_for_digit_8 = 56 ;
const int global_ascii_code_for_digit_9 = 57 ;
const int global_ascii_code_for_open_angle_bracket = 60 ;
const int global_ascii_code_for_close_angle_bracket = 62 ;
const int global_ascii_code_for_underscore = 95 ;
const int global_ascii_code_for_comma = 44 ;
const int global_ascii_code_for_backslash = 92 ;
const int global_ascii_code_for_left_square_bracket = 91 ;
const int global_ascii_code_for_right_square_bracket = 93 ;
const int global_ascii_code_for_left_parenthesis = 40 ;
const int global_ascii_code_for_right_parenthesis = 41 ;
const int global_ascii_code_for_ampersand = 38 ;
const int global_ascii_code_for_asterisk = 42 ;
const int global_ascii_code_for_pound_sign = 35 ;
const int global_ascii_code_for_exclamation_point = 33 ;
const int global_ascii_code_for_question_mark = 63 ;
const int global_ascii_code_for_at_sign = 64 ;
const int global_ascii_code_for_percent = 37 ;
const int global_ascii_code_for_caret = 94 ;
const int global_ascii_code_for_grave_accent = 96 ;
const int global_ascii_code_for_left_curly_bracket = 123 ;
const int global_ascii_code_for_right_curly_bracket = 125 ;
const int global_ascii_code_for_vertical_bar = 124 ;
const int global_ascii_code_for_tilde = 126 ;


// -----------------------------------------------
//  Define the ASCII codes for the letters that
//  appear in the words "attribute" and "specify".

const int global_ascii_code_for_letter_a = 65 ;
const int global_ascii_code_for_letter_b = 66 ;
const int global_ascii_code_for_letter_c = 67 ;
const int global_ascii_code_for_letter_e = 69 ;
const int global_ascii_code_for_letter_f = 70 ;
const int global_ascii_code_for_letter_i = 73 ;
const int global_ascii_code_for_letter_p = 80 ;
const int global_ascii_code_for_letter_r = 82 ;
const int global_ascii_code_for_letter_s = 83 ;
const int global_ascii_code_for_letter_t = 84 ;
const int global_ascii_code_for_letter_u = 85 ;
const int global_ascii_code_for_letter_y = 89 ;


// -----------------------------------------------
//  Declare the variables that implement the
//  "target pointer stack".  Each stack
//  collectively points to a single character.
//  Each stack level applies to one text item.
//  The variable
//  "global_target_stack_item_prior"
//  is zero for the bottom stack level.  The
//  variable
//  "global_target_stack_item_next"
//  is zero if there has not yet been any need to
//  create a higher-level stack item.

const int global_offset_for_target_stack_item_bottom = 0 ;
int global_target_stack_item_bottom ;
const int global_offset_for_target_stack_item_top = 1 ;
int global_target_stack_item_top ;
const int global_offset_for_target_stack_item_prior = 2 ;
int global_target_stack_item_prior ;
const int global_offset_for_target_stack_item_next = 3 ;
int global_target_stack_item_next ;
const int global_offset_for_current_target_text_item = 4 ;
int global_current_target_text_item ;
const int global_offset_for_current_target_character_position = 5 ;
int global_current_target_character_position ;
int global_pointer_to_within_target_stack_item_bottom ;
int global_pointer_to_within_target_stack_item_top ;
int global_pointer_to_within_target_stack_item_current ;
int global_pointer_to_within_target_stack_item_current_copy ;
int global_pointer_to_within_target_stack_item_current_original ;
int global_target_stack_item_top_original ;
int global_target_stack_item_current ;
int global_target_stack_item_current_original ;
int global_target_stack_item_current_copy ;
int global_target_stack_pointer_for_get_next_previous_character ;
int global_target_stack_pointer_for_copy_from ;
int global_target_stack_pointer_for_copy_to ;
int global_id_for_copy_of_target_pointer_stack ;
int global_id_for_original_of_target_pointer_stack ;


// -----------------------------------------------
//  Declare lists, flags, counters, and other
//  variables that are used when finding matching
//  text, matching patterns, expanding text, and
//  otherwise parsing text.

int global_recent_character_position_for_character_number[ 260 ] ;
int global_searched_usage_count_for_character[ 155 ] ;
int global_usage_count_for_character[ 155 ] ;
const int global_minimum_usage_character_to_consider = 32 ;
const int global_maximum_usage_character_to_consider = 125 ;
int global_yes_or_no_looking_for_word_attribute_or_specify ;
int global_yes_or_no_character_is_delimiter ;
int global_yes_or_no_delimiter_encountered ;
int global_yes_or_no_use_copy_when_appending ;
int global_yes_or_no_inserted_character ;
int global_yes_or_no_transition_from_character_to_delimiter ;
int global_yes_or_no_transition_from_delimiter_to_character ;
int global_yes_or_no_begin_not_end ;
int global_yes_or_no_matching_text ;
int global_direction_next_or_previous ;
const int global_direction_next = 1 ;
const int global_direction_previous = 2 ;
int global_direction_opposite ;
int global_length_of_text_to_find ;
int global_position_within_text_to_find ;
int global_optimum_character_for_find_pause ;
int global_possible_optimum_character_as_integer ;
int global_score_for_possible_optimum_character ;
int global_highest_score_for_optimum_character_for_find_pause ;
int global_position_of_found_character_for_find_pause ;
int global_position_of_optimum_character_for_pause ;
int global_recent_position_of_any_delimiter ;
int global_character_distance_from_optimum_character_for_pause ;
int global_position_of_underscore ;
int global_position_of_open_angle_bracket ;
int global_position_of_close_angle_bracket ;
int global_position_of_open_angle_bracket_within_text_item ;
int global_position_of_close_angle_bracket_within_text_item ;


// -----------------------------------------------
//  Declare a variable that tracks which kind of
//  delimiter -- if any -- is inserted between
//  sub text items.  Also declare its allowed
//  values.

int global_character_to_insert_between_subitems ;
const int global_insertion_character_none = 1 ;
const int global_insertion_character_space = 2 ;
const int global_insertion_character_hyphen = 3 ;


// -----------------------------------------------
//  Declare a storage area for decimal numbers.
//  These are used when the text items contain
//  the category:
//  global_category_contains_pointers_to_decimal_numbers
//  In that case, those pointers point to
//  positions in this list.

float global_decimal_number_at_position[ 2000 ] ;


// -----------------------------------------------
//  Declare pointers to words.  The first items
//  are compared to determine whether the text
//  begins with a delimiter or a word.

int global_character_pointer_to_word_number[ 20000 ] ;
int global_character_pointer_to_delimiter_number[ 20000 ] ;


// -----------------------------------------------
//  Declare text items related to operands.

int global_text_item_for_operand_one ;
int global_text_item_for_operand_two ;
int global_text_item_for_operand_three ;
int global_word_count_operand_one ;
int global_word_count_operand_two ;


// -----------------------------------------------
//  Declare pointers to within a text item.

int global_pointer_to_within_text_item ;
int global_text_item_pointer ;
int global_pointer_next_word_begin ;
int global_pointer_next_word_end ;
int global_next_character_position_count ;


// -----------------------------------------------
//  Declare other pointers and character counters.

int global_word_position ;
int global_space_available_in_text_item ;


// -----------------------------------------------
//  Declare some flags.

int global_yes_or_no ;
int global_yes_or_no_text_item_changeable ;
int global_yes_or_no_reached_begin_of_current_text_item ;
int global_yes_or_no_reached_end_of_current_text_item ;
int global_yes_or_no_same_text ;
int global_yes_or_no_same_phrase_name ;
int global_yes_or_no_same_phrase_word ;
int global_yes_or_no_requesting_space_appended ;
int global_yes_or_no_negative_number ;
int global_yes_or_no_decimal_number ;
int global_yes_or_no_number_is_valid ;
int global_yes_or_no_numeric_delimiter_encountered ;
int global_yes_or_no_filename_is_valid ;
int global_yes_or_no_in_filename_before_period ;
int global_yes_or_no_filename_delimiter_encountered ;
int global_yes_or_no_folder_name_is_valid ;
int global_yes_or_no_in_folder_name_before_period ;
int global_yes_or_no_folder_name_delimiter_encountered ;
int global_yes_or_no_use_slash_not_backslash ;
int global_yes_or_no_count_phrase_usage ;


// -----------------------------------------------
//  Declare some variables.

int global_check_for_match_text_item_id ;
int global_text_item_looking_at_next_word_in_hyphenated_phrase ;
int global_text_item_intended_next_word_in_hyphenated_phrase ;
int global_word_count_hyphenated_phrase_name ;
int global_character_pointer_begin_for_text_one ;
int global_character_pointer_end_for_text_one ;
int global_character_pointer_begin_for_text_two ;
int global_character_pointer_end_for_text_two ;
int global_count_of_words_handled ;
int global_distance_between_item_begin_and_end ;
int global_current_target_text_item_begin ;
int global_current_target_text_item_end ;
int global_test_loop_counter ;


// -----------------------------------------------
//  Define the connections to file input and file
//  output.

FILE * global_infile_connection ;
FILE * global_outfile_connection ;


// -----------------------------------------------
//  Specify an extra output file that contains a
//  log of actions for the purpose of monitoring
//  or debugging intermediate calculations.

std::ofstream log_out ;


// -----------------------------------------------
//  Declare some other global variables.

int global_response_ignored ;
int global_one_number_to_append ;
int global_text_pointer ;
int global_number_of_valid_characters_encountered ;
int global_number_of_digits_encountered ;
int global_single_integer ;
int global_single_character_as_integer ;
int global_saved_single_character_as_integer ;
int global_decimal_number_divisor ;


// -----------------------------------------------
//  Declare some variables that are used to
//  handle non-integers.

float global_single_decimal_number ;
std::string global_cplusplus_string ;
char global_c_format_string[ 50 ] ;
int global_unused_string_length ;
char global_c_format_single_character ;


// -----------------------------------------------
//  Declare variables used for debugging purposes.

int global_pointer_for_debugging ;
int global_text_item_id_for_sample_numbers ;
int global_text_item_id_for_sample_filename ;
int global_text_item_id_for_sample_folder_name ;
int global_text_item_id_for_sample_text_to_expand ;


// -----------------------------------------------
//  Declare global_do_nothing as an integer that
//  is incremented where the code otherwise would
//  be empty.  This is done for code readability.

int global_do_nothing ;


// -----------------------------------------------
//  End of top-level code.
//  Beginning of functions.


// -----------------------------------------------
// -----------------------------------------------
//  Function exit_not_yet_supported

void exit_not_yet_supported( )
{
    log_out << "BUG:  This text item category, " << global_text_item_category << ", (or some other capability) is not yet supported." << std::endl ;
    exit( EXIT_FAILURE ) ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function choose_slash_or_backslash
//
//  This function checks the operating system to
//  determine whether slashes or backslashes
//  should be used in folder names.
//
//  This code uses compiler macros because there
//  is no way to create a library function that
//  would work on all operating systems.

void choose_slash_or_backslash( )
{
    global_yes_or_no_use_slash_not_backslash = global_yes ;
    #ifdef _WIN32
    global_yes_or_no_use_slash_not_backslash = global_no ;
    #endif
    #ifdef _WIN64
    global_yes_or_no_use_slash_not_backslash = global_no ;
    #endif
}


// -----------------------------------------------
// -----------------------------------------------
//  Function check_yes_or_no_text_item_is_empty

int check_yes_or_no_text_item_is_empty( )
{
    if ( global_text_pointer_end_for_item[ global_text_item_id ] < global_text_pointer_begin_for_item[ global_text_item_id ] )
    {
        return global_yes ;
    } else
    {
        return global_no ;
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function measure_space_available_in_text_item

void measure_space_available_in_text_item( )
{
    global_space_available_in_text_item = global_text_pointer_allocation_end_for_item[ global_text_item_id ] - global_text_pointer_end_for_item[ global_text_item_id ] ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function assign_storage_for_new_text_item
//
//  Initialize the pointers that will keep track
//  of a new text item.

void assign_storage_for_new_text_item( )
{
    global_text_pointer_begin_for_item[ global_next_available_text_item_id ] = global_next_available_begin_pointer_for_next_available_text_item_id ;
    global_next_available_begin_pointer_for_next_available_text_item_id += global_length_requested_for_next_text_item_storage ;
    global_text_pointer_allocation_end_for_item[ global_next_available_text_item_id ] = global_next_available_begin_pointer_for_next_available_text_item_id - 1 ;
    global_text_pointer_end_for_item[ global_next_available_text_item_id ] =     global_text_pointer_begin_for_item[ global_next_available_text_item_id ] - 1 ;
    global_id_of_item_containing_definition_for_item[ global_next_available_text_item_id ] = 0 ;
    global_new_storage_text_item_id = global_next_available_text_item_id ;
    global_next_available_text_item_id ++ ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function recover_memory_from_top_text_item
//
//  If the top-most text item contains text that
//  does not extend to the end of the allocated
//  number of sub-items, reduce the allocation
//  size.  If the text item type is
//  list_of_text_item_ids, allocate an extra
//  position for future extension.  Also allow for
//  a case where the text extends beyond what was
//  originally allocated.

void recover_memory_from_top_text_item( )
{
    if ( global_new_storage_text_item_id != ( global_next_available_text_item_id - 1 ) )
    {
        return ;
    }
    global_next_available_begin_pointer_for_next_available_text_item_id = global_text_pointer_end_for_item[ global_new_storage_text_item_id ] + 1 ;
    if ( global_text_category_for_item[ global_new_storage_text_item_id ] == global_category_contains_list_of_text_item_ids )
    {
        global_next_available_begin_pointer_for_next_available_text_item_id ++ ;
    }
    global_text_pointer_allocation_end_for_item[ global_new_storage_text_item_id ] = global_next_available_begin_pointer_for_next_available_text_item_id - 1 ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function extend_length_of_top_text_item
//
//  Extend the length of the top-most text item.

void extend_length_of_top_text_item( )
{
    if ( global_new_storage_text_item_id != ( global_next_available_text_item_id - 1 ) )
    {
        return ;
    }
    global_text_pointer_allocation_end_for_item[ global_new_storage_text_item_id ] += global_default_length_for_text_item ;
    global_next_available_begin_pointer_for_next_available_text_item_id = global_text_pointer_allocation_end_for_item[ global_new_storage_text_item_id ] + 1 ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function write_single_character_to_file
//
//  Write the the character -- expressed as an
//  integer -- to the output file.  The character
//  integer is supplied in the variable
//  global_single_character_as_integer.  Ignore
//  any error responses.
//
//  Later, replace "fputc" function with C++ code
//  that handles Unicode characters, including
//  Chinese characters.

void write_single_character_as_integer_to_file( )
{
    global_response_ignored = fputc( char( global_single_character_as_integer ) , global_outfile_connection ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  convert_integer_to_text
//
//  This function converts the integer stored in
//  global_single_integer into text digits that
//  are stored in text item
//  global_text_item_id_for_number_as_text.

void convert_integer_to_text( )
{


// -----------------------------------------------
//  Point to where the first character (as an
//  integer) will be stored.

    global_character_pointer_for_text_item = global_text_pointer_begin_for_item[ global_text_item_id_for_number_as_text ] ;


// -----------------------------------------------
//  If the integer is zero, just use the single
//  digit zero (0).

    if ( global_single_integer == 0 )
    {
        global_c_format_string[ 0 ] = '0' ;
        global_character_count = 1 ;


// -----------------------------------------------
//  Otherwise, convert the integer into
//  digit characters.

    } else
    {
        try
        {
            global_character_count = sprintf( global_c_format_string , "%1d" , global_single_integer ) ;
        }


// -----------------------------------------------
//  If the conversion was not successful, insert
//  the text "not_an_integer".

        catch( ... )
        {
            global_c_format_string[ 0 ] = 'n' ;
            global_c_format_string[ 1 ] = 'o' ;
            global_c_format_string[ 2 ] = 't' ;
            global_c_format_string[ 3 ] = '_' ;
            global_c_format_string[ 4 ] = 'a' ;
            global_c_format_string[ 5 ] = 'n' ;
            global_c_format_string[ 6 ] = '_' ;
            global_c_format_string[ 7 ] = 'i' ;
            global_c_format_string[ 8 ] = 'n' ;
            global_c_format_string[ 9 ] = 't' ;
            global_c_format_string[ 10 ] = 'e' ;
            global_c_format_string[ 11 ] = 'g' ;
            global_c_format_string[ 12 ] = 'e' ;
            global_c_format_string[ 13 ] = 'r' ;
            global_character_count = 14 ;
        }
    }


// -----------------------------------------------
//  Store the text.

    for ( global_character_pointer = 0 ; global_character_pointer < global_character_count ; global_character_pointer ++ )
    {
        global_single_character_as_integer = (int) global_c_format_string[ global_character_pointer ] ;
        global_storage_all_text[ global_character_pointer_for_text_item ] = global_single_character_as_integer ;
        global_character_pointer_for_text_item ++ ;
        log_out << "digit " << global_single_character_as_integer << std::endl ;
    }
    global_text_pointer_end_for_item[ global_text_item_id_for_number_as_text ] = global_character_pointer_for_text_item - 1 ;
    global_text_category_for_item[ global_text_item_id_for_number_as_text ] = global_category_contains_unicode_no_delimiters ;


// -----------------------------------------------
//  End of function convert_integer_to_text.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  convert_decimal_to_text
//
//  This function converts the decimal stored in
//  global_single_decimal_number into text digits
//  that are stored in text item
//  global_text_item_id_for_number_as_text.

void convert_decimal_to_text( )
{


// -----------------------------------------------
//  Point to where the first character (as an
//  integer) will be stored.

    global_text_item_pointer = global_text_pointer_begin_for_item[ global_text_item_id_for_number_as_text ] ;


// -----------------------------------------------
//  If the decimal number is zero, use the text
//  "0.0".

    if ( global_single_decimal_number == 0 )
    {
        global_c_format_string[ 0 ] = '0' ;
        global_c_format_string[ 1 ] = '.' ;
        global_c_format_string[ 2 ] = '0' ;
        global_character_count = 3 ;


// -----------------------------------------------
//  Otherwise, convert the decimal number into
//  digit characters, plus a decimal point.

    } else
    {
        try
        {
            global_character_count = sprintf( global_c_format_string , "%1f" , global_single_decimal_number ) ;
        }


// -----------------------------------------------
//  If the conversion was not successful, insert
//  the text "not_a_number".

        catch( ... )
        {
            global_c_format_string[ 0 ] = 'n' ;
            global_c_format_string[ 1 ] = 'o' ;
            global_c_format_string[ 2 ] = 't' ;
            global_c_format_string[ 3 ] = '_' ;
            global_c_format_string[ 4 ] = 'a' ;
            global_c_format_string[ 5 ] = '_' ;
            global_c_format_string[ 6 ] = 'n' ;
            global_c_format_string[ 7 ] = 'u' ;
            global_c_format_string[ 8 ] = 'm' ;
            global_c_format_string[ 9 ] = 'b' ;
            global_c_format_string[ 10 ] = 'e' ;
            global_c_format_string[ 11 ] = 'r' ;
            global_character_count = 12 ;
        }
    }


// -----------------------------------------------
//  Store the text.

    for ( global_character_pointer = 0 ; global_character_pointer < global_character_count ; global_character_pointer ++ )
    {
        global_single_character_as_integer = (int) global_c_format_string[ global_character_pointer ] ;
        global_storage_all_text[ global_text_item_pointer ] = global_single_character_as_integer ;
        global_text_item_pointer ++ ;
//        log_out << "digit " << global_single_character_as_integer << std::endl ;
    }


// -----------------------------------------------
//  End of function convert_decimal_to_text.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function store_text_and_get_its_text_item_id
//
//  Gets the text word supplied as a function
//  argument in C string format, stores it in
//  global_storage_all_text, and returns the text
//  item ID number for this text.

int store_text_and_get_its_text_item_id( const char * local_this_word )
{


// -----------------------------------------------
//  Count the characters to be stored, and request
//  this amount of storage space.
//
//  Reminder:  The first character position is
//  zero because this code handles text that
//  is imported using the strcpy function.

    global_character_count = 0 ;
    for ( size_t character_pointer = 0 ; character_pointer < ( strlen( local_this_word ) ) ; character_pointer ++ )
    {
        global_single_character = (int) local_this_word[ character_pointer ] ;
        if ( global_single_character == 0 )
        {
            break ;
        }
        global_character_count ++ ;
    }
    global_length_requested_for_next_text_item_storage = global_character_count ;


// -----------------------------------------------
//  Create the storage for the text item.

    assign_storage_for_new_text_item( ) ;


// -----------------------------------------------
//  Store the characters in the new text item.
//
//  Reminder:  The first character position is
//  zero because this code handles text that
//  is imported using the strcpy function.

    global_next_character_position_in_storage_all_text = global_text_pointer_begin_for_item[ global_new_storage_text_item_id ] ;
    for ( size_t character_pointer = 0 ; character_pointer < ( strlen( local_this_word ) ) ; character_pointer ++ )
    {
        global_single_character = (int) local_this_word[ character_pointer ] ;
        global_storage_all_text[ global_next_character_position_in_storage_all_text ] = global_single_character ;
        global_next_character_position_in_storage_all_text ++ ;
    }


// -----------------------------------------------
//  Update the pointer to the end of the
//  just-stored text.

    global_text_pointer_end_for_item[ global_new_storage_text_item_id ] = global_text_pointer_begin_for_item[ global_new_storage_text_item_id ] + global_character_count - 1 ;


// -----------------------------------------------
//  Specify the category for this text item.

    global_text_category_for_item[ global_new_storage_text_item_id ] = global_category_contains_unicode_anything ;


// -----------------------------------------------
//  Return with the text item ID number

    return global_new_storage_text_item_id ;


// -----------------------------------------------
//  End of function store_text_and_get_its_text_item_id.

}


// -----------------------------------------------
// -----------------------------------------------
//  Function store_phrase_name_and_get_id
//
//  Creates a text item for a hyphenated phrase
//  name, and supplies the text item ID number for
//  the new text item.
//
//  Later, allow a variable number of phrase
//  words.

int store_phrase_name_and_get_id( int word_one , int word_two , int word_three , int word_four , int word_five , int word_six , int word_seven , int word_eight , int word_nine , int word_ten , int word_eleven , int word_twelve )
{
    global_length_requested_for_next_text_item_storage = 12 ;
    assign_storage_for_new_text_item( ) ;
    global_text_category_for_item[ global_new_storage_text_item_id ] = global_category_contains_hyphenated_phrase_name ;
    global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ] = word_one ;
    global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ] = word_two ;
    global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ] = word_three ;
    global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ] = word_four ;
    global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ] = word_five ;
    global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ] = word_six ;
    global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ] = word_seven ;
    global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ] = word_eight ;
    global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ] = word_nine ;
    global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ] = word_ten ;
    global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ] = word_eleven ;
    global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ] = word_twelve ;
    for ( global_character_pointer = global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ; global_character_pointer >= global_text_pointer_begin_for_item[ global_new_storage_text_item_id ] ; global_character_pointer -- )
    {
        if ( global_storage_all_text[ global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ] > 0 )
        {
            break ;
        }
        global_text_pointer_end_for_item[ global_new_storage_text_item_id ] -- ;
    }
    return global_new_storage_text_item_id ;
}


// -----------------------------------------------
// -----------------------------------------------
//    do_main_initialization
//
//  Does initialization at the very beginning.

void do_main_initialization( )
{

    int pointer ;
    int character_number ;
    int next_character ;
    int text_id_number ;
    int text_item_id_for_next_key_word ;
    int text_item_id_for_next_phrase_name ;


// -----------------------------------------------
//  Open the output file that logs details.

    log_out.open ( "output_log_c_language_runtime_test.txt" , std::ios::out ) ;


// -----------------------------------------------
//  Initialize the list that converts character
//  numbers into categories.

    for ( pointer = 0 ; pointer <= global_length_of_list_of_character_numbers ; pointer ++ )
    {
        global_character_category_number_for_character_number[ pointer ] = global_character_category_other ;
    }

    global_character_category_number_for_character_number[ global_ascii_code_for_tab ] = global_character_category_tab ;
    global_character_category_number_for_character_number[ global_ascii_code_for_newline ] = global_character_category_newline ;

//  carriage return and formfeed treated as newline
    global_character_category_number_for_character_number[ global_ascii_code_for_carriage_return ] = global_character_category_newline ;
    global_character_category_number_for_character_number[ global_ascii_code_for_formfeed ] = global_character_category_newline ;

    global_character_category_number_for_character_number[ global_ascii_code_for_quotation_mark ] = global_character_category_quotation_mark ;
    global_character_category_number_for_character_number[ global_ascii_code_for_apostrophe ] = global_character_category_apostrophe ;
    global_character_category_number_for_character_number[ global_ascii_code_for_hyphen ] = global_character_category_hyphen ;
    global_character_category_number_for_character_number[ global_ascii_code_for_space ] = global_character_category_space ;
    global_character_category_number_for_character_number[ global_ascii_code_for_hyphen ] = global_character_category_hyphen ;
    global_character_category_number_for_character_number[ global_ascii_code_for_underscore ] = global_character_category_underscore ;
    global_character_category_number_for_character_number[ global_ascii_code_for_slash ] = global_character_category_slash ;
    global_character_category_number_for_character_number[ global_ascii_code_for_open_angle_bracket ] = global_character_category_open_angle_bracket ;
    global_character_category_number_for_character_number[ global_ascii_code_for_close_angle_bracket ] = global_character_category_close_angle_bracket ;
    global_character_category_number_for_character_number[ global_ascii_code_for_period ] = global_character_category_period ;
    global_character_category_number_for_character_number[ global_ascii_code_for_plus ] = global_character_category_plus_sign ;
    global_character_category_number_for_character_number[ global_ascii_code_for_digit_0 ] = global_character_category_digit ;
    global_character_category_number_for_character_number[ global_ascii_code_for_digit_1 ] = global_character_category_digit ;
    global_character_category_number_for_character_number[ global_ascii_code_for_digit_2 ] = global_character_category_digit ;
    global_character_category_number_for_character_number[ global_ascii_code_for_digit_3 ] = global_character_category_digit ;
    global_character_category_number_for_character_number[ global_ascii_code_for_digit_4 ] = global_character_category_digit ;
    global_character_category_number_for_character_number[ global_ascii_code_for_digit_5 ] = global_character_category_digit ;
    global_character_category_number_for_character_number[ global_ascii_code_for_digit_6 ] = global_character_category_digit ;
    global_character_category_number_for_character_number[ global_ascii_code_for_digit_7 ] = global_character_category_digit ;
    global_character_category_number_for_character_number[ global_ascii_code_for_digit_8 ] = global_character_category_digit ;
    global_character_category_number_for_character_number[ global_ascii_code_for_digit_9 ] = global_character_category_digit ;
    global_character_category_number_for_character_number[ global_ascii_code_for_comma ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_backslash ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_left_square_bracket ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_right_square_bracket ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_left_parenthesis ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_right_parenthesis ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_ampersand ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_asterisk ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_pound_sign ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_exclamation_point ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_question_mark ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_at_sign ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_percent ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_caret ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_grave_accent ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_left_curly_bracket ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_right_curly_bracket ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_vertical_bar ] = global_character_category_symbol ;
    global_character_category_number_for_character_number[ global_ascii_code_for_tilde ] = global_character_category_symbol ;


// -----------------------------------------------
//  Initialize the counter that indicates the next
//  available text ID number.  (Zero is not used.)
//  It must be incremented after each text item ID
//  number is assigned.

    global_next_available_text_item_id = 1 ;


// -----------------------------------------------
//  Put zeros into the lists that are indexed by
//  text item ID number because those ID numbers
//  start at one, not zero.

    global_storage_all_text[ 0 ] = 0 ;
    global_text_category_for_item[ 0 ] = 0 ;
    global_text_pointer_allocation_end_for_item[ 0 ] = 0 ;
    global_text_pointer_begin_for_item[ 0 ] = 0 ;
    global_text_pointer_end_for_item[ 0 ] = 0 ;


// -----------------------------------------------
//  Initialize the pointer that keeps track of the
//  beginning of the next available character
//  positions in the list: global_storage_all_text

    global_next_available_begin_pointer_for_next_available_text_item_id = 1 ;


// -----------------------------------------------
//  Initialize the pointer that keeps track of the
//  end of the list:
//  global_id_of_item_containing_definition_for_item

    global_next_available_defined_phrase_number = 1 ;


// -----------------------------------------------
//  Create text items that each hold one symbol,
//  and define text item ID numbers for these
//  symbols.

    global_text_item_id_for_single_space = store_text_and_get_its_text_item_id( " " ) ;
    global_text_item_id_for_single_hyphen = store_text_and_get_its_text_item_id( "-" ) ;
    global_text_item_id_for_single_underscore  = store_text_and_get_its_text_item_id( "_" ) ;
    global_text_item_id_for_single_tab  = store_text_and_get_its_text_item_id( "\t" ) ;
    global_text_item_id_for_single_newline  = store_text_and_get_its_text_item_id( "\n" ) ;
    global_text_item_id_for_single_carriage_return  = store_text_and_get_its_text_item_id( "\r" ) ;
    global_text_item_id_for_single_formfeed  = store_text_and_get_its_text_item_id( "\f" ) ;
    global_text_item_id_for_single_slash  = store_text_and_get_its_text_item_id( "/" ) ;
    global_text_item_id_for_single_backslash  = store_text_and_get_its_text_item_id( "\\" ) ;
    global_text_item_id_for_single_quotation_mark  = store_text_and_get_its_text_item_id( "?" ) ;
    global_text_item_id_for_single_apostrophe  = store_text_and_get_its_text_item_id( "'" ) ;
    global_text_item_id_for_single_plus  = store_text_and_get_its_text_item_id( "+" ) ;
    global_text_item_id_for_single_period  = store_text_and_get_its_text_item_id( "." ) ;
    global_text_item_id_for_single_open_angle_bracket  = store_text_and_get_its_text_item_id( "<" ) ;
    global_text_item_id_for_single_close_angle_bracket  = store_text_and_get_its_text_item_id( ">" ) ;


// -----------------------------------------------
//  Create the text items for words within the
//  phrase names that have definitions -- rather
//  than only having meaning between the words
//  ambee and amenn.
//
//  Reminder: The strcpy function starts position
//  counting at one, not zero.

//  todo: generate this code from a template

    global_text_item_id_for_word_character = store_text_and_get_its_text_item_id( "character" ) ;
    global_text_item_id_for_sample_numbers = store_text_and_get_its_text_item_id( " 123 , 72.3 , -4399 , -88.6666 " ) ;
    global_text_item_id_for_sample_filename = store_text_and_get_its_text_item_id( "  , xyz !@#$%^&*(){}:;?<> yes_name.txt , " ) ;
    global_text_item_id_for_sample_folder_name = store_text_and_get_its_text_item_id( "  , xyz !@#$%/^&\\*(){}:;?<> /yes_name/txt/ , " ) ;
    global_text_item_id_for_sample_text_to_expand = store_text_and_get_its_text_item_id( "   _ hyphenated-phrase   <specify 123>  <attribute 123> " ) ;
    global_text_item_id_for_word_hyphen = store_text_and_get_its_text_item_id( "hyphen" ) ;
    global_text_item_id_for_word_space = store_text_and_get_its_text_item_id( "space" ) ;
    global_text_item_id_for_word_newline = store_text_and_get_its_text_item_id( "newline" ) ;
    global_text_item_id_for_word_underscore = store_text_and_get_its_text_item_id( "underscore" ) ;
    global_text_item_id_for_word_tab = store_text_and_get_its_text_item_id( "tab" ) ;
    global_text_item_id_for_word_four = store_text_and_get_its_text_item_id( "four" ) ;
    global_text_item_id_for_word_hyphens = store_text_and_get_its_text_item_id( "hyphens" ) ;
    global_text_item_id_for_word_non = store_text_and_get_its_text_item_id( "non" ) ;
    global_text_item_id_for_word_breaking = store_text_and_get_its_text_item_id( "breaking" ) ;
    global_text_item_id_for_word_empty = store_text_and_get_its_text_item_id( "empty" ) ;
    global_text_item_id_for_word_text = store_text_and_get_its_text_item_id( "text" ) ;


// -----------------------------------------------
//  Create the text items for the Dashrep-defined
//  phrase names.

    global_id_for_phrase_word_numeric = store_text_and_get_its_text_item_id( "numeric" ) ;

    global_id_for_phrase_name_hyphen_here = store_phrase_name_and_get_id( global_id_for_phrase_word_hyphen , global_id_for_phrase_word_here , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_character_hyphen = store_phrase_name_and_get_id( global_id_for_phrase_word_character , global_id_for_phrase_word_hyphen , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_four_hyphens = store_phrase_name_and_get_id( global_id_for_phrase_word_four , global_id_for_phrase_word_hyphens , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_no_space = store_phrase_name_and_get_id( global_id_for_phrase_word_no , global_id_for_phrase_word_space , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_empty_text = store_phrase_name_and_get_id( global_id_for_phrase_word_empty , global_id_for_phrase_word_text , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_one_space = store_phrase_name_and_get_id( global_id_for_phrase_word_one , global_id_for_phrase_word_space , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_character_space = store_phrase_name_and_get_id( global_id_for_phrase_word_character , global_id_for_phrase_word_space , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_non_breaking_space = store_phrase_name_and_get_id( global_id_for_phrase_word_non , global_id_for_phrase_word_breaking , global_id_for_phrase_word_space , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_new_line = store_phrase_name_and_get_id( global_id_for_phrase_word_new , global_id_for_phrase_word_line , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_empty_line = store_phrase_name_and_get_id( global_id_for_phrase_word_empty , global_id_for_phrase_word_line , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_line_break = store_phrase_name_and_get_id( global_id_for_phrase_word_line , global_id_for_phrase_word_break , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_character_newline = store_phrase_name_and_get_id( global_id_for_phrase_word_character , global_id_for_phrase_word_newline , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_character_tab = store_phrase_name_and_get_id( global_id_for_phrase_word_character , global_id_for_phrase_word_tab , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_character_underscore = store_phrase_name_and_get_id( global_id_for_phrase_word_character , global_id_for_phrase_word_underscore , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_expand_text = store_phrase_name_and_get_id( global_id_for_phrase_word_expand , global_id_for_phrase_word_text , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_standard_output = store_phrase_name_and_get_id( global_id_for_phrase_word_standard , global_id_for_phrase_word_output , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_text = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_text , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_append_text = store_phrase_name_and_get_id( global_id_for_phrase_word_append , global_id_for_phrase_word_text , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_append_text_no_space = store_phrase_name_and_get_id( global_id_for_phrase_word_append , global_id_for_phrase_word_text , global_id_for_phrase_word_no , global_id_for_phrase_word_space , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_append_new_line = store_phrase_name_and_get_id( global_id_for_phrase_word_append , global_id_for_phrase_word_new , global_id_for_phrase_word_line , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_append_repeatedly_using_count = store_phrase_name_and_get_id( global_id_for_phrase_word_append , global_id_for_phrase_word_repeatedly , global_id_for_phrase_word_using , global_id_for_phrase_word_count , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_prepend_text = store_phrase_name_and_get_id( global_id_for_phrase_word_prepend , global_id_for_phrase_word_text , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_prepend_text_no_space = store_phrase_name_and_get_id( global_id_for_phrase_word_prepend , global_id_for_phrase_word_text , global_id_for_phrase_word_no , global_id_for_phrase_word_space , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_put_into_phrase = store_phrase_name_and_get_id( global_id_for_phrase_word_put , global_id_for_phrase_word_into , global_id_for_phrase_word_phrase , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_get_phrase_name_from_phrase = store_phrase_name_and_get_id( global_id_for_phrase_word_get , global_id_for_phrase_word_phrase , global_id_for_phrase_word_name , global_id_for_phrase_word_from , global_id_for_phrase_word_phrase , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_get_cgi_information = store_phrase_name_and_get_id( global_id_for_phrase_word_get , global_id_for_phrase_word_cgi , global_id_for_phrase_word_information , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_get_definitions_from_phrase = store_phrase_name_and_get_id( global_id_for_phrase_word_get , global_id_for_phrase_word_definitions , global_id_for_phrase_word_from , global_id_for_phrase_word_phrase , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_put_listed_phrase_definitions_into_phrase = store_phrase_name_and_get_id( global_id_for_phrase_word_put , global_id_for_phrase_word_listed , global_id_for_phrase_word_phrase , global_id_for_phrase_word_definitions , global_id_for_phrase_word_into , global_id_for_phrase_word_phrase , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_listed_words_to_phrases_named_in_pattern = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_listed , global_id_for_phrase_word_words , global_id_for_phrase_word_to , global_id_for_phrase_word_phrases , global_id_for_phrase_word_named , global_id_for_phrase_word_in , global_id_for_phrase_word_pattern , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_append_multiple_from_phrases_named_in_pattern = store_phrase_name_and_get_id( global_id_for_phrase_word_append , global_id_for_phrase_word_multiple , global_id_for_phrase_word_from , global_id_for_phrase_word_phrases , global_id_for_phrase_word_named , global_id_for_phrase_word_in , global_id_for_phrase_word_pattern , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_clear_phrase = store_phrase_name_and_get_id( global_id_for_phrase_word_clear , global_id_for_phrase_word_phrase , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_clear_listed_phrases = store_phrase_name_and_get_id( global_id_for_phrase_word_clear , global_id_for_phrase_word_listed , global_id_for_phrase_word_phrases , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_delete_listed_phrases = store_phrase_name_and_get_id( global_id_for_phrase_word_delete , global_id_for_phrase_word_listed , global_id_for_phrase_word_phrases , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_if_yes_begin = store_phrase_name_and_get_id( global_id_for_phrase_word_if , global_id_for_phrase_word_yes , global_id_for_phrase_word_begin , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_if_no_begin = store_phrase_name_and_get_id( global_id_for_phrase_word_if , global_id_for_phrase_word_no , global_id_for_phrase_word_begin , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_if_else = store_phrase_name_and_get_id( global_id_for_phrase_word_if , global_id_for_phrase_word_else , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_if_end = store_phrase_name_and_get_id( global_id_for_phrase_word_if , global_id_for_phrase_word_end , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_yes_or_no_empty_phrase = store_phrase_name_and_get_id( global_id_for_phrase_word_yes , global_id_for_phrase_word_or , global_id_for_phrase_word_no , global_id_for_phrase_word_empty , global_id_for_phrase_word_phrase , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_yes_or_no_same_two_phrase_definitions = store_phrase_name_and_get_id( global_id_for_phrase_word_yes , global_id_for_phrase_word_or , global_id_for_phrase_word_no , global_id_for_phrase_word_same , global_id_for_phrase_word_two , global_id_for_phrase_word_phrase , global_id_for_phrase_word_definitions , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_yes_or_no_same_two_words = store_phrase_name_and_get_id( global_id_for_phrase_word_yes , global_id_for_phrase_word_or , global_id_for_phrase_word_no , global_id_for_phrase_word_same , global_id_for_phrase_word_two , global_id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_yes_or_no_opposite = store_phrase_name_and_get_id( global_id_for_phrase_word_yes , global_id_for_phrase_word_or , global_id_for_phrase_word_no , global_id_for_phrase_word_opposite , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_yes_if_all_yes = store_phrase_name_and_get_id( global_id_for_phrase_word_yes , global_id_for_phrase_word_if , global_id_for_phrase_word_all , global_id_for_phrase_word_yes , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_yes_if_any_yes = store_phrase_name_and_get_id( global_id_for_phrase_word_yes , global_id_for_phrase_word_if , global_id_for_phrase_word_any , global_id_for_phrase_word_yes , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_no_if_any_no = store_phrase_name_and_get_id( global_id_for_phrase_word_no , global_id_for_phrase_word_if , global_id_for_phrase_word_any , global_id_for_phrase_word_no , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_yes_if_not_no = store_phrase_name_and_get_id( global_id_for_phrase_word_yes , global_id_for_phrase_word_if , global_id_for_phrase_word_not , global_id_for_phrase_word_no , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_no_if_not_yes = store_phrase_name_and_get_id( global_id_for_phrase_word_no , global_id_for_phrase_word_if , global_id_for_phrase_word_not , global_id_for_phrase_word_yes , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_use_handler_with_each_word_in_phrase = store_phrase_name_and_get_id( global_id_for_phrase_word_use , global_id_for_phrase_word_handler , global_id_for_phrase_word_with , global_id_for_phrase_word_each , global_id_for_phrase_word_word , global_id_for_phrase_word_in , global_id_for_phrase_word_phrase , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_word_to_use_in_handler = store_phrase_name_and_get_id( global_id_for_phrase_word_word , global_id_for_phrase_word_to , global_id_for_phrase_word_use , global_id_for_phrase_word_in , global_id_for_phrase_word_handler , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_get_count_of_words = store_phrase_name_and_get_id( global_id_for_phrase_word_get , global_id_for_phrase_word_count , global_id_for_phrase_word_of , global_id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_get_word_at_position = store_phrase_name_and_get_id( global_id_for_phrase_word_get , global_id_for_phrase_word_word , global_id_for_phrase_word_at , global_id_for_phrase_word_position , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_get_position_of_word = store_phrase_name_and_get_id( global_id_for_phrase_word_get , global_id_for_phrase_word_position , global_id_for_phrase_word_of , global_id_for_phrase_word_word , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_word_at_position = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_word , global_id_for_phrase_word_at , global_id_for_phrase_word_position , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_words_from_position_to_position = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_words , global_id_for_phrase_word_from , global_id_for_phrase_word_position , global_id_for_phrase_word_to , global_id_for_phrase_word_position , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_words_offset_skip = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_words , global_id_for_phrase_word_offset , global_id_for_phrase_word_skip , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_words_found_in_both_lists = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_words , global_id_for_phrase_word_found , global_id_for_phrase_word_in , global_id_for_phrase_word_both , global_id_for_phrase_word_lists , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_words_found_in_either_list = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_words , global_id_for_phrase_word_found , global_id_for_phrase_word_in , global_id_for_phrase_word_either , global_id_for_phrase_word_list , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_words_found_only_in_first_list = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_words , global_id_for_phrase_word_found , global_id_for_phrase_word_only , global_id_for_phrase_word_in , global_id_for_phrase_word_first , global_id_for_phrase_word_list , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_words_that_begin_with_text = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_words , global_id_for_phrase_word_that , global_id_for_phrase_word_begin , global_id_for_phrase_word_with , global_id_for_phrase_word_text , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_words_that_begin_with_listed_words = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_words , global_id_for_phrase_word_that , global_id_for_phrase_word_begin , global_id_for_phrase_word_with , global_id_for_phrase_word_listed , global_id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_words_that_contain_listed_words = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_words , global_id_for_phrase_word_that , global_id_for_phrase_word_contain , global_id_for_phrase_word_listed , global_id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_words_unique_only = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_words , global_id_for_phrase_word_unique , global_id_for_phrase_word_only , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_list_of_unique_word_counts = store_phrase_name_and_get_id( global_id_for_phrase_word_list , global_id_for_phrase_word_of , global_id_for_phrase_word_unique , global_id_for_phrase_word_word , global_id_for_phrase_word_counts , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_list_of_pointers_to_unique_words = store_phrase_name_and_get_id( global_id_for_phrase_word_list , global_id_for_phrase_word_of , global_id_for_phrase_word_pointers , global_id_for_phrase_word_to , global_id_for_phrase_word_unique , global_id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_words_order_reversed = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_words , global_id_for_phrase_word_order , global_id_for_phrase_word_reversed , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_words_sort_numeric = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_words , global_id_for_phrase_word_sort , global_id_for_phrase_word_numeric , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_words_rearrange_using_order_sort_numeric = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_words , global_id_for_phrase_word_rearrange , global_id_for_phrase_word_using , global_id_for_phrase_word_order , global_id_for_phrase_word_sort , global_id_for_phrase_word_numeric , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_words_sort_alphabetic = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_words , global_id_for_phrase_word_sort , global_id_for_phrase_word_alphabetic , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_words_rearrange_using_order_sort_alphabetic = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_words , global_id_for_phrase_word_rearrange , global_id_for_phrase_word_using , global_id_for_phrase_word_order , global_id_for_phrase_word_sort , global_id_for_phrase_word_alphabetic , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_generate_counts_from_integer_to_integer = store_phrase_name_and_get_id( global_id_for_phrase_word_generate , global_id_for_phrase_word_counts , global_id_for_phrase_word_from , global_id_for_phrase_word_integer , global_id_for_phrase_word_to , global_id_for_phrase_word_integer , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_generate_every_pairwise_combination_of_words = store_phrase_name_and_get_id( global_id_for_phrase_word_generate , global_id_for_phrase_word_every , global_id_for_phrase_word_pairwise , global_id_for_phrase_word_combination , global_id_for_phrase_word_of , global_id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_generate_every_ordered_pairwise_combination_of_words = store_phrase_name_and_get_id( global_id_for_phrase_word_generate , global_id_for_phrase_word_every , global_id_for_phrase_word_ordered , global_id_for_phrase_word_pairwise , global_id_for_phrase_word_combination , global_id_for_phrase_word_of , global_id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_generate_list_of_all_dashrep_phrases = store_phrase_name_and_get_id( global_id_for_phrase_word_generate , global_id_for_phrase_word_list , global_id_for_phrase_word_of , global_id_for_phrase_word_all , global_id_for_phrase_word_dashrep , global_id_for_phrase_word_phrases , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_get_count_of_characters = store_phrase_name_and_get_id( global_id_for_phrase_word_get , global_id_for_phrase_word_count , global_id_for_phrase_word_of , global_id_for_phrase_word_characters , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_get_characters_from_position_to_position = store_phrase_name_and_get_id( global_id_for_phrase_word_get , global_id_for_phrase_word_characters , global_id_for_phrase_word_from , global_id_for_phrase_word_position , global_id_for_phrase_word_to , global_id_for_phrase_word_position , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_characters_from_position_to_position = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_characters , global_id_for_phrase_word_from , global_id_for_phrase_word_position , global_id_for_phrase_word_to , global_id_for_phrase_word_position , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_without_extra_spaces = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_without , global_id_for_phrase_word_extra , global_id_for_phrase_word_spaces , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_lowercase_only = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_lowercase , global_id_for_phrase_word_only , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_uppercase_only = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_uppercase , global_id_for_phrase_word_only , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_initial_caps = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_initial , global_id_for_phrase_word_caps , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_zero_pad_left_to_length = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_zero , global_id_for_phrase_word_pad , global_id_for_phrase_word_left , global_id_for_phrase_word_to , global_id_for_phrase_word_length , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_encode_as_cgi_parameter = store_phrase_name_and_get_id( global_id_for_phrase_word_encode , global_id_for_phrase_word_as , global_id_for_phrase_word_cgi , global_id_for_phrase_word_parameter , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_decode_from_cgi_parameter = store_phrase_name_and_get_id( global_id_for_phrase_word_decode , global_id_for_phrase_word_from , global_id_for_phrase_word_cgi , global_id_for_phrase_word_parameter , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_convert_unicode_to_html_entities = store_phrase_name_and_get_id( global_id_for_phrase_word_convert , global_id_for_phrase_word_unicode , global_id_for_phrase_word_to , global_id_for_phrase_word_html , global_id_for_phrase_word_entities , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_get_position_of_matching_text = store_phrase_name_and_get_id( global_id_for_phrase_word_get , global_id_for_phrase_word_position , global_id_for_phrase_word_of , global_id_for_phrase_word_matching , global_id_for_phrase_word_text , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_and_replace = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_and , global_id_for_phrase_word_replace , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_and_replace_using_paired_listed_words = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_and , global_id_for_phrase_word_replace , global_id_for_phrase_word_using , global_id_for_phrase_word_paired , global_id_for_phrase_word_listed , global_id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_generate_positions_of_listed_words = store_phrase_name_and_get_id( global_id_for_phrase_word_generate , global_id_for_phrase_word_positions , global_id_for_phrase_word_of , global_id_for_phrase_word_listed , global_id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_generate_positions_of_delimiter = store_phrase_name_and_get_id( global_id_for_phrase_word_generate , global_id_for_phrase_word_positions , global_id_for_phrase_word_of , global_id_for_phrase_word_delimiter , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_generate_positions_of_first_matching_delimiter_after_listed_positions = store_phrase_name_and_get_id( global_id_for_phrase_word_generate , global_id_for_phrase_word_positions , global_id_for_phrase_word_of , global_id_for_phrase_word_first , global_id_for_phrase_word_matching , global_id_for_phrase_word_delimiter , global_id_for_phrase_word_after , global_id_for_phrase_word_listed , global_id_for_phrase_word_positions , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_get_current_time_in_epoch_seconds = store_phrase_name_and_get_id( global_id_for_phrase_word_get , global_id_for_phrase_word_current , global_id_for_phrase_word_time , global_id_for_phrase_word_in , global_id_for_phrase_word_epoch , global_id_for_phrase_word_seconds , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_split_epoch_seconds_into_named_components = store_phrase_name_and_get_id( global_id_for_phrase_word_split , global_id_for_phrase_word_epoch , global_id_for_phrase_word_seconds , global_id_for_phrase_word_into , global_id_for_phrase_word_named , global_id_for_phrase_word_components , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_split_epoch_seconds_into_named_components_for_zero_meridian = store_phrase_name_and_get_id( global_id_for_phrase_word_split , global_id_for_phrase_word_epoch , global_id_for_phrase_word_seconds , global_id_for_phrase_word_into , global_id_for_phrase_word_named , global_id_for_phrase_word_components , global_id_for_phrase_word_for , global_id_for_phrase_word_zero , global_id_for_phrase_word_meridian , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_time_day_of_month = store_phrase_name_and_get_id( global_id_for_phrase_word_time , global_id_for_phrase_word_day , global_id_for_phrase_word_of , global_id_for_phrase_word_month , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_time_day_of_week = store_phrase_name_and_get_id( global_id_for_phrase_word_time , global_id_for_phrase_word_day , global_id_for_phrase_word_of , global_id_for_phrase_word_week , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_time_day_of_year = store_phrase_name_and_get_id( global_id_for_phrase_word_time , global_id_for_phrase_word_day , global_id_for_phrase_word_of , global_id_for_phrase_word_year , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_time_hour = store_phrase_name_and_get_id( global_id_for_phrase_word_time , global_id_for_phrase_word_hour , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_time_minute = store_phrase_name_and_get_id( global_id_for_phrase_word_time , global_id_for_phrase_word_minute , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_time_month_number = store_phrase_name_and_get_id( global_id_for_phrase_word_time , global_id_for_phrase_word_month , global_id_for_phrase_word_number , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_time_second = store_phrase_name_and_get_id( global_id_for_phrase_word_time , global_id_for_phrase_word_second , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_time_year = store_phrase_name_and_get_id( global_id_for_phrase_word_time , global_id_for_phrase_word_year , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_zero_or_nonzero = store_phrase_name_and_get_id( global_id_for_phrase_word_zero , global_id_for_phrase_word_or , global_id_for_phrase_word_nonzero , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_zero_one_multiple = store_phrase_name_and_get_id( global_id_for_phrase_word_zero , global_id_for_phrase_word_one , global_id_for_phrase_word_multiple , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_equal_greater_less_compare = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_equal , global_id_for_phrase_word_greater , global_id_for_phrase_word_less , global_id_for_phrase_word_compare , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_add = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_add , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_minus = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_minus , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_multiply = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_multiply , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_divide_by = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_divide , global_id_for_phrase_word_by , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_maximum = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_maximum , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_minimum = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_minimum , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_increment = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_increment , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_decrement = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_decrement , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_integer = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_integer , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_absolute = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_absolute , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_odd_or_even = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_odd , global_id_for_phrase_word_or , global_id_for_phrase_word_even , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_square_root = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_square , global_id_for_phrase_word_root , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_sine = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_sine , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_cosine = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_cosine , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_logarithm_base_e = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_logarithm , global_id_for_phrase_word_base , global_id_for_phrase_word_e , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_logarithm_base_10 = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_logarithm , global_id_for_phrase_word_base , global_id_for_phrase_word_10 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_pi = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_pi , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_vector_add_number = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_vector , global_id_for_phrase_word_add , global_id_for_phrase_word_number , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_vector_multiply_by_number = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_vector , global_id_for_phrase_word_multiply , global_id_for_phrase_word_by , global_id_for_phrase_word_number , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_vectors_add = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_vectors , global_id_for_phrase_word_add , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_vectors_multiply = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_vectors , global_id_for_phrase_word_multiply , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_vectors_divide_by = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_vectors , global_id_for_phrase_word_divide , global_id_for_phrase_word_by , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_vector_integers = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_vector , global_id_for_phrase_word_integers , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_vector_absolutes = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_vector , global_id_for_phrase_word_absolutes , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_vectors_from_delta_values_calculate_distances = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_vectors , global_id_for_phrase_word_from , global_id_for_phrase_word_delta , global_id_for_phrase_word_values , global_id_for_phrase_word_calculate , global_id_for_phrase_word_distances , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_two_dimensional_sort_into_columns_and_rows = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_two , global_id_for_phrase_word_dimensional , global_id_for_phrase_word_sort , global_id_for_phrase_word_into , global_id_for_phrase_word_columns , global_id_for_phrase_word_and , global_id_for_phrase_word_rows , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_y_map_tile_number_based_on_latitude = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_y , global_id_for_phrase_word_map , global_id_for_phrase_word_tile , global_id_for_phrase_word_number , global_id_for_phrase_word_based , global_id_for_phrase_word_on , global_id_for_phrase_word_latitude , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_numeric_map_tile_zoom = store_phrase_name_and_get_id( global_id_for_phrase_word_numeric , global_id_for_phrase_word_map , global_id_for_phrase_word_tile , global_id_for_phrase_word_zoom , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_and_move_attributes_into_xml_tags = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_and , global_id_for_phrase_word_move , global_id_for_phrase_word_attributes , global_id_for_phrase_word_into , global_id_for_phrase_word_xml , global_id_for_phrase_word_tags , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_and_remove_attributes_from_xml_tags = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_and , global_id_for_phrase_word_remove , global_id_for_phrase_word_attributes , global_id_for_phrase_word_from , global_id_for_phrase_word_xml , global_id_for_phrase_word_tags , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_yes_or_no_permission_to_append_to_files = store_phrase_name_and_get_id( global_id_for_phrase_word_yes , global_id_for_phrase_word_or , global_id_for_phrase_word_no , global_id_for_phrase_word_permission , global_id_for_phrase_word_to , global_id_for_phrase_word_append , global_id_for_phrase_word_to , global_id_for_phrase_word_files , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_yes_or_no_permission_to_delete_or_overwrite_files = store_phrase_name_and_get_id( global_id_for_phrase_word_yes , global_id_for_phrase_word_or , global_id_for_phrase_word_no , global_id_for_phrase_word_permission , global_id_for_phrase_word_to , global_id_for_phrase_word_delete , global_id_for_phrase_word_or , global_id_for_phrase_word_overwrite , global_id_for_phrase_word_files , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_dashrep_path_prefix_for_file_reading = store_phrase_name_and_get_id( global_id_for_phrase_word_dashrep , global_id_for_phrase_word_path , global_id_for_phrase_word_prefix , global_id_for_phrase_word_for , global_id_for_phrase_word_file , global_id_for_phrase_word_reading , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_dashrep_path_prefix_for_file_writing = store_phrase_name_and_get_id( global_id_for_phrase_word_dashrep , global_id_for_phrase_word_path , global_id_for_phrase_word_prefix , global_id_for_phrase_word_for , global_id_for_phrase_word_file , global_id_for_phrase_word_writing , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_operating_system_slash_or_backslash = store_phrase_name_and_get_id( global_id_for_phrase_word_operating , global_id_for_phrase_word_system , global_id_for_phrase_word_slash , global_id_for_phrase_word_or , global_id_for_phrase_word_backslash , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_dashrep_file_name_if_read_file_missing = store_phrase_name_and_get_id( global_id_for_phrase_word_dashrep , global_id_for_phrase_word_file , global_id_for_phrase_word_name , global_id_for_phrase_word_if , global_id_for_phrase_word_read , global_id_for_phrase_word_file , global_id_for_phrase_word_missing , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_generate_list_of_files_in_current_read_directory = store_phrase_name_and_get_id( global_id_for_phrase_word_generate , global_id_for_phrase_word_list , global_id_for_phrase_word_of , global_id_for_phrase_word_files , global_id_for_phrase_word_in , global_id_for_phrase_word_current , global_id_for_phrase_word_read , global_id_for_phrase_word_directory , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_generate_list_of_folders_in_current_read_directory = store_phrase_name_and_get_id( global_id_for_phrase_word_generate , global_id_for_phrase_word_list , global_id_for_phrase_word_of , global_id_for_phrase_word_folders , global_id_for_phrase_word_in , global_id_for_phrase_word_current , global_id_for_phrase_word_read , global_id_for_phrase_word_directory , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_yes_or_no_file_exists = store_phrase_name_and_get_id( global_id_for_phrase_word_yes , global_id_for_phrase_word_or , global_id_for_phrase_word_no , global_id_for_phrase_word_file , global_id_for_phrase_word_exists , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_yes_or_no_folder_exists = store_phrase_name_and_get_id( global_id_for_phrase_word_yes , global_id_for_phrase_word_or , global_id_for_phrase_word_no , global_id_for_phrase_word_folder , global_id_for_phrase_word_exists , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_size_of_file = store_phrase_name_and_get_id( global_id_for_phrase_word_size , global_id_for_phrase_word_of , global_id_for_phrase_word_file , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_modification_time_of_file = store_phrase_name_and_get_id( global_id_for_phrase_word_modification , global_id_for_phrase_word_time , global_id_for_phrase_word_of , global_id_for_phrase_word_file , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_set_file_permission_public_read = store_phrase_name_and_get_id( global_id_for_phrase_word_set , global_id_for_phrase_word_file , global_id_for_phrase_word_permission , global_id_for_phrase_word_public , global_id_for_phrase_word_read , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_set_file_permission_private = store_phrase_name_and_get_id( global_id_for_phrase_word_set , global_id_for_phrase_word_file , global_id_for_phrase_word_permission , global_id_for_phrase_word_private , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_set_file_permission_private_but_executable = store_phrase_name_and_get_id( global_id_for_phrase_word_set , global_id_for_phrase_word_file , global_id_for_phrase_word_permission , global_id_for_phrase_word_private , global_id_for_phrase_word_but , global_id_for_phrase_word_executable , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_rename_file = store_phrase_name_and_get_id( global_id_for_phrase_word_rename , global_id_for_phrase_word_file , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_delete_file = store_phrase_name_and_get_id( global_id_for_phrase_word_delete , global_id_for_phrase_word_file , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_create_empty_sub_folder = store_phrase_name_and_get_id( global_id_for_phrase_word_create , global_id_for_phrase_word_empty , global_id_for_phrase_word_sub , global_id_for_phrase_word_folder , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_from_file_to_phrase = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_from , global_id_for_phrase_word_file , global_id_for_phrase_word_to , global_id_for_phrase_word_phrase , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_end_of_line_indicator = store_phrase_name_and_get_id( global_id_for_phrase_word_end , global_id_for_phrase_word_of , global_id_for_phrase_word_line , global_id_for_phrase_word_indicator , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_text_end_of_line_here_space_delimited = store_phrase_name_and_get_id( global_id_for_phrase_word_text , global_id_for_phrase_word_end , global_id_for_phrase_word_of , global_id_for_phrase_word_line , global_id_for_phrase_word_here , global_id_for_phrase_word_space , global_id_for_phrase_word_delimited , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_yes_or_no_trim_spaces_when_copy_from_file = store_phrase_name_and_get_id( global_id_for_phrase_word_yes , global_id_for_phrase_word_or , global_id_for_phrase_word_no , global_id_for_phrase_word_trim , global_id_for_phrase_word_spaces , global_id_for_phrase_word_when , global_id_for_phrase_word_copy , global_id_for_phrase_word_from , global_id_for_phrase_word_file , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_yes_or_no_skip_empty_lines_when_copy_from_file = store_phrase_name_and_get_id( global_id_for_phrase_word_yes , global_id_for_phrase_word_or , global_id_for_phrase_word_no , global_id_for_phrase_word_skip , global_id_for_phrase_word_empty , global_id_for_phrase_word_lines , global_id_for_phrase_word_when , global_id_for_phrase_word_copy , global_id_for_phrase_word_from , global_id_for_phrase_word_file , 0 , 0 ) ;
    global_id_for_phrase_name_copy_from_phrase_append_to_file = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_from , global_id_for_phrase_word_phrase , global_id_for_phrase_word_append , global_id_for_phrase_word_to , global_id_for_phrase_word_file , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_append_file_to_file = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_append , global_id_for_phrase_word_file , global_id_for_phrase_word_to , global_id_for_phrase_word_file , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_linewise_read_from_file_and_use_handler = store_phrase_name_and_get_id( global_id_for_phrase_word_linewise , global_id_for_phrase_word_read , global_id_for_phrase_word_from , global_id_for_phrase_word_file , global_id_for_phrase_word_and , global_id_for_phrase_word_use , global_id_for_phrase_word_handler , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_linewise_input_line_from_file = store_phrase_name_and_get_id( global_id_for_phrase_word_linewise , global_id_for_phrase_word_input , global_id_for_phrase_word_line , global_id_for_phrase_word_from , global_id_for_phrase_word_file , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_linewise_input_line_count = store_phrase_name_and_get_id( global_id_for_phrase_word_linewise , global_id_for_phrase_word_input , global_id_for_phrase_word_line , global_id_for_phrase_word_count , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_linewise_read_from_standard_input = store_phrase_name_and_get_id( global_id_for_phrase_word_linewise , global_id_for_phrase_word_read , global_id_for_phrase_word_from , global_id_for_phrase_word_standard , global_id_for_phrase_word_input , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_get_url_resource = store_phrase_name_and_get_id( global_id_for_phrase_word_get , global_id_for_phrase_word_url , global_id_for_phrase_word_resource , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_trace_from_get_url_resource = store_phrase_name_and_get_id( global_id_for_phrase_word_trace , global_id_for_phrase_word_from , global_id_for_phrase_word_get , global_id_for_phrase_word_url , global_id_for_phrase_word_resource , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_find_line_in_file_that_begins_with_text = store_phrase_name_and_get_id( global_id_for_phrase_word_find , global_id_for_phrase_word_line , global_id_for_phrase_word_in , global_id_for_phrase_word_file , global_id_for_phrase_word_that , global_id_for_phrase_word_begins , global_id_for_phrase_word_with , global_id_for_phrase_word_text , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_find_lines_in_file_that_begin_with_any_listed_word = store_phrase_name_and_get_id( global_id_for_phrase_word_find , global_id_for_phrase_word_lines , global_id_for_phrase_word_in , global_id_for_phrase_word_file , global_id_for_phrase_word_that , global_id_for_phrase_word_begin , global_id_for_phrase_word_with , global_id_for_phrase_word_any , global_id_for_phrase_word_listed , global_id_for_phrase_word_word , 0 , 0 ) ;
    global_id_for_phrase_name_find_lines_in_file_that_begin_with_any_two_words_listed = store_phrase_name_and_get_id( global_id_for_phrase_word_find , global_id_for_phrase_word_lines , global_id_for_phrase_word_in , global_id_for_phrase_word_file , global_id_for_phrase_word_that , global_id_for_phrase_word_begin , global_id_for_phrase_word_with , global_id_for_phrase_word_any , global_id_for_phrase_word_two , global_id_for_phrase_word_words , global_id_for_phrase_word_listed , 0 ) ;
    global_id_for_phrase_name_copy_from_columns_in_file_to_named_phrases = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_from , global_id_for_phrase_word_columns , global_id_for_phrase_word_in , global_id_for_phrase_word_file , global_id_for_phrase_word_to , global_id_for_phrase_word_named , global_id_for_phrase_word_phrases , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_copy_from_columns_in_file_to_column_lists = store_phrase_name_and_get_id( global_id_for_phrase_word_copy , global_id_for_phrase_word_from , global_id_for_phrase_word_columns , global_id_for_phrase_word_in , global_id_for_phrase_word_file , global_id_for_phrase_word_to , global_id_for_phrase_word_column , global_id_for_phrase_word_lists , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_yes_or_no_use_two_spaces_as_column_delimiter = store_phrase_name_and_get_id( global_id_for_phrase_word_yes , global_id_for_phrase_word_or , global_id_for_phrase_word_no , global_id_for_phrase_word_use , global_id_for_phrase_word_two , global_id_for_phrase_word_spaces , global_id_for_phrase_word_as , global_id_for_phrase_word_column , global_id_for_phrase_word_delimiter , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_gather_tagged_info_from_file = store_phrase_name_and_get_id( global_id_for_phrase_word_gather , global_id_for_phrase_word_tagged , global_id_for_phrase_word_info , global_id_for_phrase_word_from , global_id_for_phrase_word_file , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_gather_from_tagged_file_one_entry = store_phrase_name_and_get_id( global_id_for_phrase_word_gather , global_id_for_phrase_word_from , global_id_for_phrase_word_tagged , global_id_for_phrase_word_file , global_id_for_phrase_word_one , global_id_for_phrase_word_entry , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_write_gathered_listed_items_to_end_of_file = store_phrase_name_and_get_id( global_id_for_phrase_word_write , global_id_for_phrase_word_gathered , global_id_for_phrase_word_listed , global_id_for_phrase_word_items , global_id_for_phrase_word_to , global_id_for_phrase_word_end , global_id_for_phrase_word_of , global_id_for_phrase_word_file , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_dashrep_gather_tag_begin = store_phrase_name_and_get_id( global_id_for_phrase_word_dashrep , global_id_for_phrase_word_gather , global_id_for_phrase_word_tag , global_id_for_phrase_word_begin , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_dashrep_gather_tag_end = store_phrase_name_and_get_id( global_id_for_phrase_word_dashrep , global_id_for_phrase_word_gather , global_id_for_phrase_word_tag , global_id_for_phrase_word_end , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_dashrep_gather_tag_unique = store_phrase_name_and_get_id( global_id_for_phrase_word_dashrep , global_id_for_phrase_word_gather , global_id_for_phrase_word_tag , global_id_for_phrase_word_unique , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_dashrep_gather_tag_delete = store_phrase_name_and_get_id( global_id_for_phrase_word_dashrep , global_id_for_phrase_word_gather , global_id_for_phrase_word_tag , global_id_for_phrase_word_delete , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_dashrep_gather_tag_matching_id = store_phrase_name_and_get_id( global_id_for_phrase_word_dashrep , global_id_for_phrase_word_gather , global_id_for_phrase_word_tag , global_id_for_phrase_word_matching , global_id_for_phrase_word_id , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_trace_show = store_phrase_name_and_get_id( global_id_for_phrase_word_trace , global_id_for_phrase_word_show , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_trace_show_where = store_phrase_name_and_get_id( global_id_for_phrase_word_trace , global_id_for_phrase_word_show , global_id_for_phrase_word_where , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_output_trace_file_name = store_phrase_name_and_get_id( global_id_for_phrase_word_output , global_id_for_phrase_word_trace , global_id_for_phrase_word_file , global_id_for_phrase_word_name , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_dashrep_comments_ignored = store_phrase_name_and_get_id( global_id_for_phrase_word_dashrep , global_id_for_phrase_word_comments , global_id_for_phrase_word_ignored , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_generate_phrase_usage_counts = store_phrase_name_and_get_id( global_id_for_phrase_word_generate , global_id_for_phrase_word_phrase , global_id_for_phrase_word_usage , global_id_for_phrase_word_counts , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_exit_from_dashrep = store_phrase_name_and_get_id( global_id_for_phrase_word_exit , global_id_for_phrase_word_from , global_id_for_phrase_word_dashrep , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_dashrep_language_yes = store_phrase_name_and_get_id( global_id_for_phrase_word_dashrep , global_id_for_phrase_word_language , global_id_for_phrase_word_yes , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_dashrep_version = store_phrase_name_and_get_id( global_id_for_phrase_word_dashrep , global_id_for_phrase_word_version , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_delayed_nospace = store_phrase_name_and_get_id( global_id_for_phrase_word_delayed , global_id_for_phrase_word_nospace , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_delayed_newline = store_phrase_name_and_get_id( global_id_for_phrase_word_delayed , global_id_for_phrase_word_newline , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_yes_or_no_permission_administrator = store_phrase_name_and_get_id( global_id_for_phrase_word_yes , global_id_for_phrase_word_or , global_id_for_phrase_word_no , global_id_for_phrase_word_permission , global_id_for_phrase_word_administrator , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_dashrep_endless_loop_counter_limit = store_phrase_name_and_get_id( global_id_for_phrase_word_dashrep , global_id_for_phrase_word_endless , global_id_for_phrase_word_loop , global_id_for_phrase_word_counter , global_id_for_phrase_word_limit , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    global_id_for_phrase_name_dashrep_time_limit = store_phrase_name_and_get_id( global_id_for_phrase_word_dashrep , global_id_for_phrase_word_time , global_id_for_phrase_word_limit , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;


// -----------------------------------------------
//  Create some special hyphenated phrase names.

    global_id_for_phrase_name_placeholder_for_hyphen_here = store_phrase_name_and_get_id( global_id_for_phrase_word_placeholder , global_id_for_phrase_word_for , global_id_for_phrase_word_hyphen , global_id_for_phrase_word_here , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;

    global_id_for_phrase_name_placeholder_for_new_line = store_phrase_name_and_get_id( global_id_for_phrase_word_placeholder , global_id_for_phrase_word_for , global_id_for_phrase_word_new , global_id_for_phrase_word_line , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;

    global_id_for_phrase_name_placeholder_for_empty_line = store_phrase_name_and_get_id( global_id_for_phrase_word_placeholder , global_id_for_phrase_word_for , global_id_for_phrase_word_empty , global_id_for_phrase_word_line , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;


// -----------------------------------------------
//  Connect the Dashrep-defined static phrase
//  names with their definitions.

    global_id_of_item_containing_definition_for_item[ global_id_for_phrase_name_character_hyphen ] = global_text_item_id_for_single_hyphen ;
    global_id_of_item_containing_definition_for_item[ global_id_for_phrase_name_character_space ] = global_text_item_id_for_single_space ;
    global_id_of_item_containing_definition_for_item[ global_id_for_phrase_name_character_newline ] = global_text_item_id_for_single_newline ;
    global_id_of_item_containing_definition_for_item[ global_id_for_phrase_name_character_tab ] = global_text_item_id_for_single_tab ;
    global_id_of_item_containing_definition_for_item[ global_id_for_phrase_name_character_underscore ] = global_text_item_id_for_single_underscore ;

    global_text_item_id_for_empty_text = store_text_and_get_its_text_item_id( "" ) ;
    global_id_of_item_containing_definition_for_item[ global_id_for_phrase_name_empty_text ] = global_text_item_id_for_empty_text ;

    global_text_item_id_for_four_hyphens = store_text_and_get_its_text_item_id( "----" ) ;
    global_id_of_item_containing_definition_for_item[ global_id_for_phrase_name_four_hyphens ] = global_text_item_id_for_four_hyphens ;

    global_text_item_id_for_non_breaking_space = store_text_and_get_its_text_item_id( "&nbsp;" ) ;
    global_id_of_item_containing_definition_for_item[ global_id_for_phrase_name_non_breaking_space ] = global_text_item_id_for_non_breaking_space ;


// -----------------------------------------------
//  Create the text items used for file input and
//  output.  Shorten the length slightly in case
//  of an overrun.

    global_length_requested_for_next_text_item_storage = global_allocated_length_for_file_input_or_output ;

    global_text_item_id_for_file_input = global_next_available_text_item_id ;
    assign_storage_for_new_text_item( ) ;
    global_text_category_for_item[ global_text_item_id_for_file_input ] = global_category_contains_unicode_anything ;
    global_text_pointer_allocation_end_for_item[ global_text_item_id_for_file_input ] -= 5 ;

    global_text_item_id_for_file_output = global_next_available_text_item_id ;
    assign_storage_for_new_text_item( ) ;
    global_text_category_for_item[ global_text_item_id_for_file_output ] = global_category_contains_unicode_anything ;
    global_text_pointer_allocation_end_for_item[ global_text_item_id_for_file_output ] -= 5 ;


// -----------------------------------------------
//  Create the text item used to store the result
//  of converting a number into text.

    global_length_requested_for_next_text_item_storage = 20 ;
    global_text_item_id_for_number_as_text = global_next_available_text_item_id ;
    assign_storage_for_new_text_item( ) ;
    global_text_category_for_item[ global_text_item_id_for_number_as_text ] = global_category_contains_unicode_anything ;


// -----------------------------------------------
//  Create text items that contain specific
//  unchanging messages.

    global_message_trace__expand_phrases__endless_loop = store_text_and_get_its_text_item_id( "trace_diagnostic__expand_phrases__error_endless_loop__highest_count " ) ;



// -----------------------------------------------
//  Create text items that hold one filename and
//  one folder name after they have been changed
//  to eliminate leading and trailing delimiters.

    global_length_requested_for_next_text_item_storage = 200 ;

    global_text_item_id_for_valid_filename = global_next_available_text_item_id ;
    assign_storage_for_new_text_item( ) ;
    global_text_category_for_item[ global_text_item_id_for_valid_filename ] = global_category_contains_unicode_anything ;
    global_text_pointer_allocation_end_for_item[ global_text_item_id_for_valid_filename ] -= 5 ;

    global_text_item_id_for_valid_folder_name = global_next_available_text_item_id ;
    assign_storage_for_new_text_item( ) ;
    global_text_category_for_item[ global_text_item_id_for_valid_folder_name ] = global_category_contains_unicode_anything ;
    global_text_pointer_allocation_end_for_item[ global_text_item_id_for_valid_folder_name ] -= 5 ;


// -----------------------------------------------
//  Initialize some counters that track other
//  kinds of storage usage.

    global_next_available_defined_phrase_number = 1 ;


// -----------------------------------------------
//  Initialize some variables.

    global_yes_or_no = global_yes ;
    global_yes_or_no_requesting_space_appended = global_yes ;
    global_number_of_hyphenated_phrase_names_in_text_items = 0 ;
    global_target_stack_pointer_for_get_next_previous_character = 0 ;
    global_target_stack_item_bottom = 0 ;


// -----------------------------------------------
//  Now that initialization is done, do not allow
//  text items to have their contents changed.

    global_yes_or_no_text_item_changeable = global_no ;
    global_text_item_id_last_predefined = global_next_available_text_item_id - 1 ;


// -----------------------------------------------
//  Define numeric-pi as a decimal number using
//  category list_of_decimal_numbers.
//  If value is needed, set flag and do
//  calculation later only if needed.


// -----------------------------------------------
//  For debugging, show the defined text items.

    for ( global_text_item_id = 1 ; global_text_item_id < global_next_available_text_item_id ; global_text_item_id ++ )
    {
//        log_out << "[" << global_text_item_id << " spans " << global_text_pointer_begin_for_item[ global_text_item_id ] << " to " << global_text_pointer_end_for_item[ global_text_item_id ] << "]" ;
        for ( global_character_pointer = global_text_pointer_begin_for_item[ global_text_item_id ] ; global_character_pointer <= global_text_pointer_end_for_item[ global_text_item_id ] ; global_character_pointer ++ )
        {
//            log_out << "[" << global_storage_all_text[ global_character_pointer ] << "]" ;
        }
//        log_out << std::endl ;
    }


// -----------------------------------------------
//  End of function do_main_initialization.

    return ;

}


// -----------------------------------------------
// -----------------------------------------------
//  Function check_yes_or_no_character_is_delimiter

void check_yes_or_no_character_is_delimiter( )
{
    switch ( global_single_character_as_integer )
    {
        case global_ascii_code_for_space :
            global_yes_or_no_character_is_delimiter = global_yes ;
            break ;
        case global_ascii_code_for_tab :
            global_yes_or_no_character_is_delimiter = global_yes ;
            break ;
        case global_ascii_code_for_newline :
            global_yes_or_no_character_is_delimiter = global_yes ;
            break ;
        case global_ascii_code_for_formfeed :
            global_yes_or_no_character_is_delimiter = global_yes ;
            break ;
        case global_ascii_code_for_carriage_return :
            global_yes_or_no_character_is_delimiter = global_yes ;
            break ;
        default :
            global_yes_or_no_character_is_delimiter = global_no ;
            break ;
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function read_text_line_from_file
//
//  Reads one line of text from a file and puts
//  the text into the text item ID numbered
//  global_text_item_id_for_file_input.
//
//  Later, replace "fgetc" function with C++ code
//  that reads unicode characters.  Test with
//  Chinese characters.

void read_text_line_from_file( )
{
    global_text_pointer_end_for_item[ global_text_item_id_for_file_input ] = global_text_pointer_begin_for_item[ global_text_item_id_for_file_input ] - 1 ;
    global_text_category_for_item[ global_text_item_id_for_file_input ] = global_category_contains_unicode_anything ;
    while ( 1 == 1 )
    {
        global_next_character_number = fgetc( global_infile_connection ) ;
        global_text_item_id_to_edit = global_text_item_id_for_file_input ;
        measure_space_available_in_text_item( ) ;
        if ( global_space_available_in_text_item > 1 )
        {
            global_text_pointer_end_for_item[ global_text_item_id_to_edit ] ++ ;
            global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_to_edit ] ] = global_next_character_number ;
        } else
        {
            log_out << "[Error:  Out of space for storing text line from file]" << std::endl ;
            global_next_character_number = 0 ;
            return ;
        }
        global_character_category = global_character_category_number_for_character_number[ global_next_character_number ] ;
        if ( ( global_next_character_number == EOF ) || ( global_character_category == global_character_category_newline ) )
        {
            global_next_character_number = 0 ;
            return ;
        }
        if ( global_text_pointer_end_for_item[ global_text_item_id_for_file_input ] < global_text_pointer_allocation_end_for_item[ global_text_item_id_for_file_input ] )
        {
            global_text_pointer_end_for_item[ global_text_item_id_for_file_input ] ++ ;
            global_text_pointer_end_for_item[ global_text_item_id_for_file_input ] = global_next_character_number ;
        } else
        {
            log_out << "[Error: file input line exceeds buffer size]" << std::endl ;
            exit( EXIT_FAILURE ) ;
        }
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------

void write_to_log( )
{
    log_out << "global_direction_next_or_previous " << global_direction_next_or_previous << std::endl << "global_target_stack_item_bottom " << global_target_stack_item_bottom << std::endl << "global_target_stack_item_top " << global_target_stack_item_top << std::endl << "global_target_stack_item_prior " << global_target_stack_item_prior << std::endl << "global_target_stack_item_next " << global_target_stack_item_next << std::endl << "global_target_stack_pointer_for_get_next_previous_character " << global_target_stack_pointer_for_get_next_previous_character << std::endl << "global_pointer_to_within_target_stack_item_top " << global_pointer_to_within_target_stack_item_top << std::endl << "global_current_target_text_item " << global_current_target_text_item << std::endl << "global_current_target_character_position " << global_current_target_character_position << std::endl << "global_text_pointer_begin_for_item[ " << global_current_target_text_item << " ] " << global_text_pointer_begin_for_item[ global_current_target_text_item ] << std::endl << "global_text_pointer_end_for_item[ " << global_current_target_text_item << " ] " << global_text_pointer_end_for_item[ global_current_target_text_item ] << std::endl << "global_current_target_text_item_begin " << global_current_target_text_item_begin << std::endl << "global_current_target_text_item_end " << global_current_target_text_item_end << std::endl << "global_distance_between_item_begin_and_end " << global_distance_between_item_begin_and_end << std::endl << "global_text_category_for_item " << global_text_category_for_item[ global_current_target_text_item ] << std::endl << "global_yes_or_no_reached_end_of_current_text_item " << global_yes_or_no_reached_end_of_current_text_item << std::endl << std::endl ;

    global_test_loop_counter ++ ;
    if ( global_test_loop_counter > 200 )
    {
        log_out << "reached endless loop counter limit" << std::endl ;
        exit( EXIT_FAILURE ) ;
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function specify_character_to_insert_between_subitems

void specify_character_to_insert_between_subitems( )
{
    global_text_item_with_next_character = global_storage_all_text[ global_text_pointer_begin_for_item[ global_target_stack_item_top ] ] ;
    switch ( global_text_category_for_item[ global_text_item_with_next_character ] )
    {
        global_category_contains_hyphenated_phrase_name :
            global_character_to_insert_between_subitems = global_insertion_character_hyphen ;
            break ;
        global_category_contains_list_of_integers :
            global_character_to_insert_between_subitems = global_insertion_character_space ;
            break ;
        global_category_contains_pointers_to_decimal_numbers :
            global_character_to_insert_between_subitems = global_insertion_character_space ;
            break ;
        default :
            global_character_to_insert_between_subitems = global_insertion_character_none ;
            break ;
    }
//    log_out << "char insert" << std::endl ;
//    write_to_log( ) ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function put_info_into_target_pointer_stack_item

void put_info_into_target_pointer_stack_item( )
{
        global_pointer_to_within_target_stack_item_top = global_text_pointer_begin_for_item[ global_target_stack_item_bottom ] ;

        global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_top ] = global_target_stack_item_top ;

        global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_prior ] = global_target_stack_item_prior ;

        global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_next ] = global_target_stack_item_next ;

        global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_text_item ] = global_current_target_text_item ;

        global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_character_position ] = global_current_target_character_position ;

//    log_out << "put" << std::endl ;
//    write_to_log( ) ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_info_from_target_pointer_stack_item

void get_info_from_target_pointer_stack_item( )
{
    global_pointer_to_within_target_stack_item_top = global_text_pointer_begin_for_item[ global_target_stack_item_bottom ] ;

    global_target_stack_item_top = global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_top ] ;

    global_target_stack_item_prior = global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_prior ] ;

    global_target_stack_item_next = global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_next ] ;

    global_current_target_text_item = global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_text_item ] ;

    global_current_target_character_position = global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_character_position ] ;

//    log_out << "get" << std::endl ;
//    write_to_log( ) ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function pop_target_pointer_stack
//
//  Move down one level in the target pointer
//  stack.

void pop_target_pointer_stack( )
{


// -----------------------------------------------
//  Identify the stack's top item.

    global_pointer_to_within_target_stack_item_bottom = global_text_pointer_begin_for_item[ global_target_stack_item_bottom ] ;

    global_target_stack_item_top = global_storage_all_text[ global_pointer_to_within_target_stack_item_bottom + global_offset_for_target_stack_item_top ] ;


// -----------------------------------------------
//  Identify the prior item, one stack level
//  lower.

    global_pointer_to_within_target_stack_item_top = global_text_pointer_begin_for_item[ global_target_stack_item_top ] ;

    global_target_stack_item_prior = global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_prior ] ;


// -----------------------------------------------
//  Use the prior item as the new top item.

    global_target_stack_item_top = global_target_stack_item_prior ;

    global_storage_all_text[ global_pointer_to_within_target_stack_item_bottom + global_offset_for_target_stack_item_top ] = global_target_stack_item_top ;


// -----------------------------------------------
//  Get the info from the new top item.

    get_info_from_target_pointer_stack_item( ) ;


// -----------------------------------------------
//  Determine the text item category of the new
//  top item.

    global_text_item_category = global_text_category_for_item[ global_id_pointer_stack_for_getting_next_character ] ;


// -----------------------------------------------
//  Specify the automatic insertion character for
//  the new top item.

    specify_character_to_insert_between_subitems( ) ;

    log_out << "pop" << std::endl ;
    write_to_log( ) ;


// -----------------------------------------------
//  End of function pop_target_pointer_stack.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function push_target_pointer_stack
//
//  Add one level to the target pointer stack.  If
//  this is the first use of this pointer stack --
//  is indicated by a value of zero -- create the
//  bottom level of the stack.  Each additional
//  pointer stack level is added as needed.  The
//  pointer stack is specified by the ID number in
//  "global_target_stack_item_bottom".

void push_target_pointer_stack( )
{


// -----------------------------------------------
//  If a new target pointer stack item needs to be
//  created, create it.

    if ( ( global_target_stack_item_bottom == 0 ) || ( global_target_stack_item_next == 0 ) )
    {
        global_length_requested_for_next_text_item_storage = 5 ;
        assign_storage_for_new_text_item( ) ;
        log_out << "global_new_storage_text_item_id " << global_new_storage_text_item_id << std::endl ;
    }


// -----------------------------------------------
//  If a new bottom stack item was created, fill
//  it with the needed info, then return.

    if ( global_target_stack_item_bottom == 0 )
    {
        global_target_stack_item_bottom = global_new_storage_text_item_id ;
        global_target_stack_item_top = global_target_stack_item_bottom ;
        global_target_stack_item_prior = 0 ;
        global_target_stack_item_next = 0 ;
        global_current_target_text_item = 0 ;
        global_current_target_character_position = 0 ;
        put_info_into_target_pointer_stack_item( ) ;
        log_out << "new bottom" << std::endl ;
        write_to_log( ) ;
        return ;
    }


// -----------------------------------------------
//  If a new non-bottom stack level was created,
//  point to it from what will become the prior
//  stack level, fill it with the needed info,
//  and point to it as the new top stack level
//  item.

    if ( global_target_stack_item_next == 0 )
    {
        global_target_stack_item_top = global_new_storage_text_item_id ;
        global_pointer_to_within_target_stack_item_bottom = global_text_pointer_begin_for_item[ global_target_stack_item_bottom ] ;
        global_storage_all_text[ global_pointer_to_within_target_stack_item_bottom + global_offset_for_target_stack_item_top ] = global_target_stack_item_top ;
        global_target_stack_item_next = 0 ;
        global_pointer_to_within_target_stack_item_top = global_text_pointer_begin_for_item[ global_target_stack_item_top ] ;
        global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_next ] = global_target_stack_item_next ;
        global_current_target_text_item = 0 ;
        global_current_target_character_position = 0 ;
        put_info_into_target_pointer_stack_item( ) ;
        log_out << "new non-bottom" << std::endl ;
        write_to_log( ) ;
        return ;
    }


// -----------------------------------------------
//  Otherwise use an existing pointer stack item
//  and fill it with the needed info.

    global_target_stack_item_top = global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_next ] ;
    global_pointer_to_within_target_stack_item_top = global_text_pointer_begin_for_item[ global_target_stack_item_top ] ;
    global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_text_item ] = 0 ;
    global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_character_position ] = 0 ;
    log_out << "new bottom" << std::endl ;
    write_to_log( ) ;


// -----------------------------------------------
//  End of function push_target_pointer_stack.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function initialize_get_next_character_from_text_item
//
//  Initialize the pointer stack that is used by
//  the function
//  "get_next_or_previous_character_from_text_item"
//  and specify the "next" (not "previous"
//  direction).  The starting text item ID is
//  specified in "global_text_item_id".

void initialize_get_next_character_from_text_item( )
{
    global_current_target_text_item = global_text_item_id ;
    global_target_stack_item_bottom = 0 ;
    push_target_pointer_stack( ) ;
    global_target_stack_pointer_for_get_next_previous_character = global_target_stack_item_bottom ;
    get_info_from_target_pointer_stack_item( ) ;
    global_current_target_text_item = global_text_item_id ;
    global_current_target_character_position = 1 ;
    global_target_stack_item_top = global_target_stack_item_bottom ;
    put_info_into_target_pointer_stack_item( ) ;
    global_text_item_category = global_text_category_for_item[ global_current_target_text_item ] ;
    specify_character_to_insert_between_subitems( ) ;
    global_yes_or_no_inserted_character = global_no ;
    global_direction_next_or_previous = global_direction_next ;
    log_out << "init get char" << std::endl ;
    write_to_log( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function initialize_get_previous_character_from_text_item
//
//  Initialize the pointer stack that is used by
//  the function
//  "get_next_or_previous_character_from_text_item"
//  and specify the "previous" (not "next"
//  direction).  The starting text item ID is
//  specified in "global_text_item_id".

void initialize_get_previous_character_from_text_item( )
{
    initialize_get_next_character_from_text_item( ) ;
    global_current_target_character_position = global_text_pointer_end_for_item[ global_current_target_text_item ] - global_text_pointer_begin_for_item[ global_current_target_text_item ] + 1 ;
    global_pointer_to_within_target_stack_item_top = global_text_pointer_begin_for_item[ global_target_stack_item_bottom ] ;
    global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_character_position ] = global_current_target_character_position ;
    global_direction_next_or_previous = global_direction_previous ;
    log_out << "init get previous char" << std::endl ;
    write_to_log( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function copy_pointer_stack
//
//  Copies the information needed to point to a
//  specific character position within a text
//  item, or within a sub text item.  This allows
//  a way to go backward to the most recent
//  character (or delimiter) of a specific type,
//  without losing the current character position
//  being parsed.  Also sometimes two of these
//  stacks are used to point to the beginning and
//  end of a word or found (matching) text, even
//  if it spans beyond a single sub text item.
//  The copy is pointed to by
//  "global_id_for_copy_of_target_pointer_stack".
//  The original is pointed to by
//  "global_id_for_original_of_target_pointer_stack".

void copy_pointer_stack( )
{


// -----------------------------------------------
//  Create a new, empty, target pointer stack
//  item, and get its location.

    global_target_stack_item_bottom = 0 ;
    push_target_pointer_stack( ) ;
    global_id_for_copy_of_target_pointer_stack = global_target_stack_item_bottom ;
    global_target_stack_item_current_copy = global_id_for_copy_of_target_pointer_stack ;


// -----------------------------------------------
//  Get the location of the target pointer stack
//  being copied, and get the location of the top
//  item in that stack.

    global_target_stack_item_current_original = global_id_for_original_of_target_pointer_stack ;
    global_pointer_to_within_target_stack_item_current_original = global_text_pointer_begin_for_item[ global_target_stack_item_current_original ] ;
    global_target_stack_item_top_original = global_storage_all_text[ global_pointer_to_within_target_stack_item_current_original + global_offset_for_target_stack_item_top ] ;


// -----------------------------------------------
//  Begin a loop that handles each stack level.

    while ( global_target_stack_item_current_original > 0 )
    {


// -----------------------------------------------
//  Copy the pointer information.

        global_pointer_to_within_target_stack_item_current_copy = global_text_pointer_begin_for_item[ global_target_stack_item_current_copy ] ;
        global_pointer_to_within_target_stack_item_current_original = global_text_pointer_begin_for_item[ global_target_stack_item_current_original ] ;
        global_storage_all_text[ global_pointer_to_within_target_stack_item_current_copy + global_offset_for_current_target_text_item ] = global_storage_all_text[ global_pointer_to_within_target_stack_item_current_original + global_offset_for_current_target_text_item ] ;
        global_storage_all_text[ global_pointer_to_within_target_stack_item_current_copy + global_offset_for_current_target_character_position ] = global_storage_all_text[ global_pointer_to_within_target_stack_item_current_original + global_offset_for_current_target_character_position ] ;
        global_storage_all_text[ global_pointer_to_within_target_stack_item_current_copy + global_offset_for_target_stack_item_top ] = 0 ;
        global_target_stack_item_current_original = global_storage_all_text[ global_pointer_to_within_target_stack_item_current_original + global_offset_for_target_stack_item_next ] ;


// -----------------------------------------------
//  If the top stack level has been reached, exit
//  the loop.

        if ( ( global_target_stack_item_current_original == 0 ) || ( global_target_stack_item_current_original == global_target_stack_item_top_original ) )
        {
            break ;
        }


// -----------------------------------------------
//  Create a new, empty, target pointer stack
//  item that will store the pointers at the next
//  higher stack level, and update the previous
//  stack level to point to this new stack level.

        global_target_stack_item_bottom = 0 ;
        push_target_pointer_stack( ) ;
        global_target_stack_item_current_copy = global_target_stack_item_bottom ;
        global_storage_all_text[ global_pointer_to_within_target_stack_item_current_copy + global_offset_for_target_stack_item_next ] = global_target_stack_item_current_copy ;


// -----------------------------------------------
//  Get from the original stack item the "next"
//  higher stack item ID.

        global_pointer_to_within_target_stack_item_current_original = global_text_pointer_begin_for_item[ global_target_stack_item_current_original ] ;
        global_target_stack_item_current_original = global_storage_all_text[ global_pointer_to_within_target_stack_item_current_original + global_offset_for_target_stack_item_next ] ;


// -----------------------------------------------
//  Repeat the loop to handle the next stack
//  level.

    }


// -----------------------------------------------

    global_storage_all_text[ global_text_pointer_begin_for_item[ global_id_for_copy_of_target_pointer_stack ] + global_offset_for_target_stack_item_top ] = global_target_stack_item_current_copy ;


// -----------------------------------------------
//  End of copy_pointer_stack.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_next_or_previous_character_from_text_item
//
//  Gets the next -- or previous -- character from
//  the text item specified by
//  "global_text_item_id" and  puts the character
//  -- as an integer -- into
//  "global_single_character_as_integer".  The
//  direction -- "next" or "previous" -- is
//  specified by "global_direction_next_or_previous".
//  Before using this function the initialization
//  function
//  "initialize_get_next_character_from_text_item"
//  or
//  "initialize_get_previous_character_from_text_item"
//  must be used.

void get_next_or_previous_character_from_text_item( )
{


// -----------------------------------------------
//  Begin a loop that points to the next
//  character.  When needed, move up or down the
//  stack, or sometimes both up and down.  This
//  function exits within the loop as soon as the
//  next character is known.

    while ( 1 == 1 )
    {


// -----------------------------------------------
//  Point to the beginning and end of the current
//  text item, and calculate the distance between
//  them.

        global_current_target_text_item_begin = global_text_pointer_begin_for_item[ global_current_target_text_item ] ;
        global_current_target_text_item_end = global_text_pointer_end_for_item[ global_current_target_text_item ] ;
        global_distance_between_item_begin_and_end = global_current_target_text_item_end - global_current_target_text_item_begin ;


// -----------------------------------------------
//  If the previous character was the last (or
//  previous) character in the current-level text
//  item, track this situation.  Allow for the
//  possibility that the text item is empty.  If
//  the text item category is
//  "category_pointer_pair", this calculation is
//  different from the other category types.

        if ( global_direction_next_or_previous == global_direction_next )
        {
            if ( global_current_target_character_position > global_distance_between_item_begin_and_end )
            {
                global_yes_or_no_reached_end_of_current_text_item = global_yes ;
            } else
            {
                global_yes_or_no_reached_end_of_current_text_item = global_no ;
            }
        } else
        {
            if ( global_current_target_character_position < 1 )
            {
                global_yes_or_no_reached_end_of_current_text_item = global_yes ;
            } else
            {
                global_yes_or_no_reached_end_of_current_text_item = global_no ;
            }
        }
        if ( global_text_category_for_item[ global_current_target_text_item ] == global_category_contains_pointer_pair )
        {
            global_character_pointer_if_category_pointer_pair = global_storage_all_text[ global_current_target_text_item_begin ] + global_current_target_character_position - 1 ;
            if ( global_direction_next_or_previous == global_direction_next )
            {
                if ( global_character_pointer_if_category_pointer_pair > global_storage_all_text[ global_current_target_text_item_end ] )
                {
                    global_yes_or_no_reached_end_of_current_text_item = global_yes ;
                } else
                {
                    global_yes_or_no_reached_end_of_current_text_item = global_no ;
                }
            } else
            {
                if ( global_character_pointer_if_category_pointer_pair < global_storage_all_text[ global_current_target_text_item_begin ] )
                {
                    global_yes_or_no_reached_end_of_current_text_item = global_yes ;
                } else
                {
                    global_yes_or_no_reached_end_of_current_text_item = global_no ;
                }
            }
        }


// -----------------------------------------------
//  Write debugging info.

        log_out << "get char" << std::endl ;
        write_to_log( ) ;


// -----------------------------------------------
//  If the last (or first) character has already
//  been supplied, supply the character number as
//  zero.

        if ( ( global_target_stack_item_prior == 0 ) && ( global_yes_or_no_reached_end_of_current_text_item == global_yes ) )
        {
            global_single_character_as_integer = 0 ;
            log_out << "end of text" << std::endl ;
            return ;
        }


// -----------------------------------------------
//  If the end (or beginning) of a sub text item
//  has been reached, move back to the text item
//  that pointed to that text item, then repeat
//  the loop.

        if ( global_yes_or_no_reached_end_of_current_text_item == global_yes )
        {
            pop_target_pointer_stack( ) ;
            get_info_from_target_pointer_stack_item( ) ;
            global_yes_or_no_inserted_character = global_no ;
            global_text_item_category = global_text_category_for_item[ global_current_target_text_item ] ;
            continue ;
        }


// -----------------------------------------------
//  If a space or hyphen needs to be inserted
//  here, insert it.  This applies to a list of
//  integers, a list of pointers to decimal
//  numbers, or a hyphenated phrase name.  It also
//  applies when there is a transition from one
//  hyphenated phrase name to a subordinate
//  hyphenated phrase name (which usually happens
//  when "fenambee" or "amennfen" or similar
//  directive is used.  If the text item is empty
//  or contains only one sub text item, don't
//  insert a character.

        if ( global_character_to_insert_between_subitems != global_insertion_character_none )
        {
            if ( global_yes_or_no_inserted_character == global_no )
            {
                if ( ( ( global_current_target_character_position > 1 ) && ( global_current_target_character_position < ( global_current_target_text_item_end - global_current_target_text_item_begin + 1 ) ) ) || ( ( global_text_item_category == global_category_contains_hyphenated_phrase_name ) && ( global_text_category_for_item[ global_target_stack_item_prior ] == global_category_contains_hyphenated_phrase_name ) ) )
                {
                    global_single_character_as_integer = global_character_to_insert_between_subitems ;
                    global_yes_or_no_inserted_character = global_yes ;
                    return ;
                }
            }
        }


// -----------------------------------------------
//  If the text item category is either
//  "unicode_anything" or "unicode_no_delimiters",
//  supply the next (or previous) character,
//  increment the pointer, and return.

        if ( ( global_text_item_category == global_category_contains_unicode_anything ) || ( global_text_item_category == global_category_contains_unicode_no_delimiters ) )
        {
            global_single_character_as_integer = global_storage_all_text[ global_text_pointer_begin_for_item[ global_current_target_text_item ] + global_current_target_character_position - 1 ] ;
            log_out << "character " << global_single_character_as_integer << std::endl ;
            if ( global_direction_next_or_previous == global_direction_next )
            {
                global_current_target_character_position ++ ;
            } else
            {
                global_current_target_character_position -- ;
            }
            return ;
        }


// -----------------------------------------------
//  If the text item category is either
//  "list_of_text_item_ids" or
//  "hyphenated_phrase_name", get the next (or
//  previous) subordinate text item ID from within
//  this text item, push the subordinate item's
//  info onto the target pointer stack, point to
//  the first (or last) item within that
//  subordinate text item, then repeat the loop.

        if ( ( global_text_item_category == global_category_contains_list_of_text_item_ids ) || ( global_text_item_category == global_category_contains_hyphenated_phrase_name ) )
        {
            put_info_into_target_pointer_stack_item( ) ;
            push_target_pointer_stack( ) ;
            get_info_from_target_pointer_stack_item( ) ;
            global_current_target_text_item = global_storage_all_text[ global_text_pointer_begin_for_item[ global_current_target_text_item ] + global_current_target_character_position - 1 ] ;
            global_pointer_to_within_target_stack_item_top = global_text_pointer_begin_for_item[ global_target_stack_item_top ] ;
            global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_text_item ] = global_current_target_text_item ;
            if ( global_direction_next_or_previous == global_direction_next )
            {
                global_current_target_character_position = 1 ;
            } else
            {
                global_current_target_character_position = global_text_pointer_end_for_item[ global_current_target_text_item ] - global_text_pointer_begin_for_item[ global_current_target_text_item ] + 1 ;
            }
            global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_character_position ] = global_current_target_character_position ;
            global_text_item_category = global_text_category_for_item[ global_current_target_text_item ] ;
            global_yes_or_no_inserted_character = global_no ;
            continue ;
        }


// -----------------------------------------------
//  If the text item category is either
//  "list_of_integers" or
//  "pointers_to_decimal_numbers", get the next
//  (or previous) number, convert it into text,
//  store the text version (of the integer or
//  decimal number) in a text item, point to the
//  first (or last) character of that text, get
//  the first (or last) character of that number,
//  increment (or decrement) the pointer, and then
//  return.

        if ( ( global_text_item_category == global_category_contains_list_of_integers ) || ( global_text_item_category == global_category_contains_pointers_to_decimal_numbers ) )
        {
            if ( global_text_item_category == global_category_contains_list_of_integers )
            {
                global_single_integer = global_storage_all_text[ global_text_pointer_begin_for_item[ global_current_target_text_item ] + global_current_target_character_position - 1 ] ;
                convert_integer_to_text( ) ;
            } else
            {
                global_single_decimal_number = global_decimal_number_at_position[ global_storage_all_text[ global_text_pointer_begin_for_item[ global_current_target_text_item ] + global_current_target_character_position - 1 ] ] ;
                convert_decimal_to_text( ) ;
            }
            push_target_pointer_stack( ) ;
            get_info_from_target_pointer_stack_item( ) ;
            global_current_target_text_item = global_text_item_id_for_number_as_text ;
            if ( global_direction_next_or_previous == global_direction_next )
            {
                global_current_target_character_position = 1 ;
            } else
            {
                global_current_target_character_position = global_text_pointer_end_for_item[ global_current_target_text_item ] - global_text_pointer_begin_for_item[ global_current_target_text_item ] + 1 ;
            }
            global_pointer_to_within_target_stack_item_top = global_text_pointer_begin_for_item[ global_target_stack_item_bottom ] ;
            global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_text_item ] = global_current_target_text_item ;
            global_storage_all_text[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_character_position ] = global_current_target_character_position ;
            continue ;
        }


// -----------------------------------------------
//  If the text item category is
//  "category_pointer_pair", point to the next (or
//  previous) character in the text being pointed
//  to, get that character, then return.  If the
//  pointer already is at the end (or beginning)
//  of the characters, repeat the loop.

        if ( global_text_item_category == global_category_contains_pointer_pair )
        {
            global_single_character_as_integer = global_storage_all_text[ global_character_pointer_if_category_pointer_pair ] ;
            log_out << "character " << global_single_character_as_integer << std::endl ;
            if ( global_direction_next_or_previous == global_direction_next )
            {
                global_current_target_character_position ++ ;
            } else
            {
                global_current_target_character_position -- ;
            }
            return ;
        }


// -----------------------------------------------
//  If the character number is zero, skip it and
//  repeat the loop.

        if ( global_single_character_as_integer == 0 )
        {
            continue ;
        }


// -----------------------------------------------
//  Repeat the loop that gets the next character.

    }


// -----------------------------------------------
//  All done in function get_next_or_previous_character_from_text_item.

    global_single_character_as_integer = 0 ;
    return ;

}


// -----------------------------------------------
// -----------------------------------------------
//  Function truncate_text_item_using_target_pointer_stack
//
//  This function changes the "begin" or "end"
//  pointers of a text item and any sub text items
//  to match the target pointer stack that is
//  pointed to by "global_text_item_id_to_edit".  This
//  function truncates the beginning if the flag
//  "global_yes_or_no_begin_not_end" is
//  "global_yes" or else truncates the ending.
//  This function should not be used if the text
//  item and sub text items must not change.  Some
//  text item types (categories) cannot be
//  truncated using this function.

void truncate_text_item_using_target_pointer_stack( )
{
    log_out << "truncate item " << global_text_item_id_to_edit << std::endl ;


// -----------------------------------------------
//  Initialization.

    global_text_item_id_to_truncate = global_text_item_id_to_edit ;
    global_pointer_to_within_target_stack_item_current = global_text_pointer_begin_for_item[ global_target_stack_item_bottom ] ;
    global_target_stack_item_current = global_storage_all_text[ global_pointer_to_within_target_stack_item_current + global_offset_for_target_stack_item_top ] ;
    write_to_log( ) ;


// -----------------------------------------------
//  For each stack level within the target pointer
//  stack, truncate the text item at that level.

    while ( global_target_stack_item_current > 0 )
    {
        global_text_item_category = global_text_category_for_item[ global_text_item_id_to_truncate ] ;
        write_to_log( ) ;
        if ( ( global_text_item_category == global_category_contains_unicode_anything ) || ( global_text_item_category == global_category_contains_unicode_no_delimiters ) || ( global_text_item_category == global_category_contains_list_of_text_item_ids ) )
        {
            global_pointer_to_within_target_stack_item_current = global_text_pointer_begin_for_item[ global_target_stack_item_current ] ;
            if ( global_yes_or_no_begin_not_end == global_yes )
            {
                global_text_pointer_begin_for_item[ global_text_item_id_to_truncate ] = global_storage_all_text[ global_pointer_to_within_target_stack_item_current + global_offset_for_current_target_character_position ] ;
                log_out << "truncated beginning of " << global_text_item_id_to_truncate << " to " << global_text_pointer_begin_for_item[ global_text_item_id_to_truncate ] << std::endl ;
            } else
            {
                global_text_pointer_end_for_item[ global_text_item_id_to_truncate ] = global_storage_all_text[ global_pointer_to_within_target_stack_item_current + global_offset_for_current_target_character_position ] ;
                log_out << "truncated end of " << global_text_item_id_to_truncate << " to " << global_text_pointer_end_for_item[ global_text_item_id_to_truncate ] << std::endl ;
            }
            global_target_stack_item_current = global_storage_all_text[ global_pointer_to_within_target_stack_item_current + global_offset_for_target_stack_item_prior ] ;
            if ( ( global_target_stack_item_current == 0 ) || ( global_target_stack_item_current == global_target_stack_item_bottom ) )
            {
                break ;
            }
            log_out << "truncate, stack shift needed" << std::endl ;
        } else
        {
            log_out << "cannot truncate global_text_item_category " << global_text_item_category << std::endl ;
            return ;
        }
    }


// -----------------------------------------------
//  End of function
//  truncate_text_item_using_target_pointer_stack.

    log_out << "truncation done" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function remove_leading_or_trailing_delimiters
//
//  This function changes the "begin" (or "end")
//  pointer of a text item to skip over leading
//  (or trailing) delimiters.  If the text item
//  points to sub text items, those "begin" (or
//  "end") pointers are also changed.  This
//  function should not be used if the text item
//  and sub text items must not change.

void remove_leading_or_trailing_delimiters( )
{


// -----------------------------------------------
//  Specify whether to remove leading or trailing
//  delimiters.

    global_text_item_id = global_text_item_id_to_edit ;
    if ( global_direction_next_or_previous == global_direction_next )
    {
        initialize_get_next_character_from_text_item( ) ;
        global_yes_or_no_begin_not_end = global_yes ;
        global_direction_opposite = global_direction_previous ;
    } else
    {
        initialize_get_previous_character_from_text_item( ) ;
        global_yes_or_no_begin_not_end = global_no ;
        global_direction_opposite = global_direction_next ;
    }


// -----------------------------------------------
//  Search for the first (or last) non-delimiter.

    global_yes_or_no_character_is_delimiter = global_yes ;
    while ( global_yes_or_no_character_is_delimiter == global_yes )
    {
        get_next_or_previous_character_from_text_item( ) ;
        check_yes_or_no_character_is_delimiter( ) ;
        if ( global_yes_or_no_character_is_delimiter == global_no )
        {
            break ;
        }
    }


// -----------------------------------------------
//  Point to that leading (or trailing)
//  non-delimiter and use it as the new beginning
//  (or end) of the text item being edited.

    global_direction_next_or_previous = global_direction_opposite ;
    get_next_or_previous_character_from_text_item( ) ;
    truncate_text_item_using_target_pointer_stack( ) ;


// -----------------------------------------------
//  End of function remove_leading_or_trailing_delimiters.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function remove_leading_delimiters

void remove_leading_delimiters( )
{
    global_direction_next_or_previous = global_direction_next ;
    remove_leading_or_trailing_delimiters( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function remove_trailing_delimiters

void remove_trailing_delimiters( )
{
    global_direction_next_or_previous = global_direction_previous ;
    remove_leading_or_trailing_delimiters( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function remove_leading_and_trailing_delimiters

void remove_leading_and_trailing_delimiters( )
{
    remove_leading_delimiters( ) ;
    remove_trailing_delimiters( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function initialize_point_to_next_word_in_text_item

void initialize_point_to_next_word_in_text_item( )
{
    initialize_get_next_character_from_text_item( ) ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function point_to_next_word_in_text_item
//
//  Identifies the next word from the text item
//  and points to the word using a pair of target
//  pointer stacks, which are pointed to by
//  "global_text_item_id_for_next_word_begin" and
//  "global_text_item_id_for_next_word_end".
//  Before using this function the initialization
//  function
//  "initialize_get_next_word_from_text_item"
//  must be used.  It uses
//  "global_text_item_id" and creates a
//  target pointer stack that is referred to by
//  "global_target_stack_item_bottom".
//  The text item
//  "global_text_item_id_for_next_word" is
//  created to point to the word.

void point_to_next_word_in_text_item( )
{
    global_yes_or_no_character_is_delimiter = global_yes ;
    while ( global_yes_or_no_character_is_delimiter == global_yes )
    {
        get_next_or_previous_character_from_text_item( ) ;
        check_yes_or_no_character_is_delimiter( ) ;
        if ( global_yes_or_no_character_is_delimiter == global_no )
        {
            global_direction_next_or_previous = global_direction_previous ;
            get_next_or_previous_character_from_text_item( ) ;
            copy_pointer_stack( ) ;
            global_text_item_id_for_next_word_begin = global_id_for_copy_of_target_pointer_stack ;
            break ;
        }
    }
    global_target_stack_item_top_original = global_target_stack_item_top ;
    get_next_or_previous_character_from_text_item( ) ;
    global_direction_next_or_previous = global_direction_next ;
    while ( global_yes_or_no_character_is_delimiter == global_no )
    {
        get_next_or_previous_character_from_text_item( ) ;
        check_yes_or_no_character_is_delimiter( ) ;
        if ( global_yes_or_no_character_is_delimiter == global_yes )
        {
            global_direction_next_or_previous = global_direction_previous ;
            get_next_or_previous_character_from_text_item( ) ;
            copy_pointer_stack( ) ;
            global_text_item_id_for_next_word_end = global_id_for_copy_of_target_pointer_stack ;
            break ;
        }
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_text_by_character_offset_and_length
//
//  Gets text for specified text item, using
//  character offset and length.  Equivalent to
//  standard "substr" function but uses Dashrep
//  runtime text storage conventions.  The result
//  is a global_text_item_id that indicates the
//  matching text.
//  The source text is pointed to by
//  "global_text_item_id_to_copy" and the offset is
//  specified by "global_character_offset" and
//  "global_character_length" specifies the
//  length, and "global_text_item_id_for_copy"
//  is the created copy of the specified
//  characters.

void get_text_by_character_offset_and_length( )
{
    global_length_requested_for_next_text_item_storage = 1000 ;
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_copy = global_new_storage_text_item_id ;
    initialize_get_next_character_from_text_item( ) ;
    global_next_character_position_count = 0 ;
    global_character_count = 0 ;
    while ( global_single_character_as_integer != 0 )
    {
        global_next_character_position_count ++ ;
        get_next_or_previous_character_from_text_item( ) ;
        if ( global_next_character_position_count >= global_character_offset )
        {
            global_character_count ++ ;
            global_text_pointer_end_for_item[ global_text_item_id_for_copy ] ++ ;
            global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_copy ] ] = global_single_character_as_integer ;
        }
        if ( ( global_character_count >= global_character_length ) || ( global_single_character_as_integer == 0 ) )
        {
            break ;
        }
    }
    if ( global_text_item_id_for_copy == global_new_storage_text_item_id )
    {
        log_out << "BUG: unexpectedly a new text item was created while getting text based on offset and length" << std::endl ;
        exit ( EXIT_FAILURE ) ;
    }
    recover_memory_from_top_text_item( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function text_replace


void text_replace( )
{

//  todo: write this code
//  if shorter, pad with zeros
//  if longer, insert branching ...

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function write_text_item_to_file
//
//  This function writes the contents of one text
//  item to the output file.  If that text item
//  points to any sub text items, those sub text
//  items also are written to the file.  The text
//  item ID must be in global_text_item_id.

void write_text_item_to_file( )
{
    log_out << "global_text_item_id " << global_text_item_id << std::endl ;
    initialize_get_next_character_from_text_item( ) ;
    while ( 1 == 1 )
    {
        get_next_or_previous_character_from_text_item( ) ;
        if ( global_single_character_as_integer == 0 )
        {
            return ;
        }
        write_single_character_as_integer_to_file( ) ;
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function text_item_clear
//
//  Changes a text item to contain nothing, but
//  does not change any linked lower-level text
//  items.  If the text item still can possibly be
//  referenced by another higher-level text item,
//  do not use this function, and instead point to
//  the empty text item or create a new text item.

void text_item_clear( )
{
    global_text_pointer_end_for_item[ global_text_item_id_to_edit ] = global_text_pointer_begin_for_item[ global_text_item_id_to_edit ] - 1 ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function append_space_if_not_empty
//
//  Appends a space to
//  "global_text_item_id_to_edit"
//  if it is not empty.
//  If the text item is categorized as a list of
//  numbers (integer or decimal), must convert
//  text item into characters.

void append_space_if_not_empty( )
{
    if ( global_text_pointer_end_for_item[ global_text_item_id_to_edit ] < global_text_pointer_begin_for_item[ global_text_item_id_to_edit ] )
    {
        if ( global_text_category_for_item[ global_text_item_id_to_edit ] == global_category_contains_list_of_text_item_ids )
        {
            measure_space_available_in_text_item( ) ;
            if ( global_space_available_in_text_item >= 2 )
            {
                global_text_pointer_end_for_item[ global_text_item_id_to_edit ] ++ ;
                global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_to_edit ] ] = global_text_item_id_for_single_space ;
            } else
            {
                global_text_item_id = 111 ;
                exit_not_yet_supported( ) ;
                return ;
            }
        } else
        {
            global_length_requested_for_next_text_item_storage = global_default_length_for_text_item ;
            assign_storage_for_new_text_item( ) ;
            global_text_category_for_item[ global_new_storage_text_item_id ] = global_category_contains_list_of_text_item_ids ;
//  insert the to and space IDs, but not the from ID
//        global_storage_all_text
            global_text_item_id_to_edit = global_new_storage_text_item_id ;
        }
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function append_linked_text
//
//  Appends text assuming that the text being
//  appended will not change, so just add a link
//  to the text being appended.  The text item
//  to be appended is specified by the text item
//  ID number in "global_text_item_id_from_origin",
//  and the text item being extended is specified
//  by the text item ID number in
//  "global_text_item_id_to_edit".  The value in
//  "global_yes_or_no_requesting_space_appended"
//  indicates whether to insert a space between
//  non-empty text being extended and non-empty
//  text being appended.
//
//  If the text item is almost full, create a new
//  sub text item and point to it with the last
//  available linked-list position, and append
//  the linked text item to the beginning of the
//  new sub text item.  The result leaves room
//  for more sub text items to be appended
//  without needing to add a new sub text item
//  for every appended text item.

void append_linked_text( )
{


// -----------------------------------------------
//  If the text being appended is empty, there is
//  nothing to do.

    if ( global_text_pointer_end_for_item[ global_text_item_id_from_origin ] < global_text_pointer_begin_for_item[ global_text_item_id_from_origin ] )
    {
        return ;
    }


// -----------------------------------------------
//  If the text being extended is empty, just put
//  a pointer into the text being extended, and
//  specify a category of "list_of_text_items"
//  regardless of what it was before.  The
//  pointer points to the text being appended.

    if ( global_text_pointer_end_for_item[ global_text_item_id_to_edit ] < global_text_pointer_begin_for_item[ global_text_item_id_to_edit ] )
    {
        global_to_text_contains_category = global_text_category_for_item[ global_text_item_id_to_edit ] ;
        if ( global_to_text_contains_category == global_category_contains_list_of_text_item_ids )
        {
            global_text_pointer_begin_for_item[ global_text_item_id_to_edit ] = global_text_item_id_from_origin ;
            global_text_pointer_end_for_item[ global_text_item_id_to_edit ] = global_text_pointer_begin_for_item[ global_text_item_id_to_edit ] ;
        } else
        {
            global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_to_edit ] ] = global_text_item_id_from_origin ;
            global_text_pointer_end_for_item[ global_text_item_id_to_edit ] = global_text_pointer_begin_for_item[ global_text_item_id_to_edit ] ;
            global_text_category_for_item[ global_text_item_id_to_edit ] = global_category_contains_list_of_text_item_ids ;
        }
        return ;
    }


// -----------------------------------------------
//  If the text being extended is not empty and
//  there is a request to insert a space between
//  the extended text and the appended text,
//  insert a space.

    if ( global_yes_or_no_requesting_space_appended == global_yes )
    {
        append_space_if_not_empty( ) ;
    }


// -----------------------------------------------
//  Get the categories of the "from" and "to" text
//  items.

    global_from_text_contains_category = global_text_category_for_item[ global_text_item_id_from_origin ] ;
    global_to_text_contains_category = global_text_category_for_item[ global_text_item_id_to_edit ] ;


// -----------------------------------------------
//  If the categories of the "from" and "to" text
//  items are both of category
//  "contains_list_of_text_item_ids", add the
//  pointer.

    if ( ( global_from_text_contains_category == global_category_contains_list_of_text_item_ids ) && ( global_to_text_contains_category == global_category_contains_list_of_text_item_ids ) )
    {
        global_text_pointer_end_for_item[ global_text_item_id_to_edit ] ++ ;
        global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_to_edit ] ] = global_text_item_id_from_origin ;
        return ;
    }


// -----------------------------------------------
//  Create a new text item of category
//  "list_of_text_item_ids" and into it put
//  pointers that point to the "to" and "from"
//  text items, and change the text item ID of the
//  "to" text item so that the new top-level item
//  points to both the "to" and "from".

    global_length_requested_for_next_text_item_storage = global_default_length_for_text_item ;
    assign_storage_for_new_text_item( ) ;
    global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ] = global_text_item_id_to_edit ;
    global_text_category_for_item[ global_new_storage_text_item_id ] = global_category_contains_list_of_text_item_ids ;
    global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ] = global_text_item_id_from_origin ;
    global_text_item_id_to_edit = global_new_storage_text_item_id ;
    return ;


// -----------------------------------------------
//  End of function append_linked_text.

}


// -----------------------------------------------
// -----------------------------------------------
//  Function append_copied_text

//  Appends text assuming that the text being
//  appended will change, so a copy of that text
//  must be stored.  The text item to be appended
//  is specified by the text item ID number in
//  global_text_item_id_from_origin, and the text
//  item being extended is specified by the text
//  item ID number in
//  global_text_item_id_to_edit.

void append_copied_text( )
{
    global_text_pointer_end_for_item[ global_text_item_id_to_edit ] = global_text_pointer_begin_for_item[ global_text_item_id_to_edit ] - 1 ;
    global_length_requested_for_next_text_item_storage = global_text_pointer_end_for_item[ global_text_item_id_from_origin ] - global_text_pointer_begin_for_item[ global_text_item_id_from_origin ] + 1 ;
    assign_storage_for_new_text_item( ) ;
    for ( global_text_pointer = global_text_pointer_begin_for_item[ global_text_item_id_from_origin ] ; global_text_pointer <= global_text_pointer_end_for_item[ global_text_item_id_from_origin ] ; global_text_pointer ++ )
    {
        global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ++ ;
        global_storage_all_text[ global_text_pointer_end_for_item[ global_new_storage_text_item_id ] ] = global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_from_origin ] ]
         ;
    }
    global_text_category_for_item[ global_new_storage_text_item_id ] = global_text_category_for_item[ global_text_item_id_from_origin ] ;
    global_text_item_id_from_origin = global_new_storage_text_item_id ;
    append_linked_text( ) ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function append_text
//
//  Appends text from the text item
//  "global_text_item_id_from_origin" to the text item
//  "global_text_item_id_to_edit".
//  Allow the two text item IDs to be the same.

void append_text( )
{
    if ( global_text_item_id_from_origin > global_text_item_id_last_predefined )
    {
        append_copied_text( ) ;
    } else
    {
        append_linked_text( ) ;
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function copy_linked_text

void copy_linked_text( )
{
    global_text_pointer_end_for_item[ global_text_item_id_to_edit ] = global_text_pointer_begin_for_item[ global_text_item_id_to_edit ] - 1 ;
    append_linked_text( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function copy_copied_text

void copy_copied_text( )
{
    global_text_pointer_end_for_item[ global_text_item_id_to_edit ] = global_text_pointer_begin_for_item[ global_text_item_id_to_edit ] - 1 ;
    append_copied_text( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function copy_text

void copy_text( )
{
    if ( global_text_item_id_from_origin > global_text_item_id_last_predefined )
    {
        copy_copied_text( ) ;
    } else
    {
        copy_linked_text( ) ;
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function initialize_parse_characters_of_number

void initialize_parse_characters_of_number( )
{
    global_single_integer = 0 ;
    global_single_decimal_number = 0.0 ;
    global_decimal_number_divisor = 1.0 ;
    global_yes_or_no_negative_number = global_no ;
    global_yes_or_no_decimal_number = global_no ;
    global_yes_or_no_numeric_delimiter_encountered = global_no ;
    global_yes_or_no_number_is_valid = global_yes ;
    global_number_of_digits_encountered = 0 ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function parse_one_character_of_number

void parse_one_character_of_number( )
{
    if ( global_yes_or_no_decimal_number == global_no )
    {
        switch ( global_single_character_as_integer )
        {
            case global_ascii_code_for_period :
                global_yes_or_no_decimal_number = global_yes ;
                global_single_decimal_number = float( global_single_integer ) ;
                global_single_integer = 0 ;
                break ;
            case global_ascii_code_for_digit_0 :
                global_single_integer = global_single_integer * 10 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_1 :
                global_single_integer = ( global_single_integer * 10 ) + 1 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_2 :
                global_single_integer = ( global_single_integer * 10 ) + 2 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_3 :
                global_single_integer = ( global_single_integer * 10 ) + 3 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_4 :
                global_single_integer = ( global_single_integer * 10 ) + 4 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_5 :
                global_single_integer = ( global_single_integer * 10 ) + 5 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_6 :
                global_single_integer = ( global_single_integer * 10 ) + 6 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_7 :
                global_single_integer = ( global_single_integer * 10 ) + 7 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_8 :
                global_single_integer = ( global_single_integer * 10 ) + 8 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_9 :
                global_single_integer = ( global_single_integer * 10 ) + 9 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_hyphen :
                if ( global_single_integer == 0 )
                {
                    global_yes_or_no_negative_number = global_yes ;
                } else
                {
                    log_out << "minus sign not at beginning" << std::endl ;
                }
                break ;
            case global_ascii_code_for_plus :
                if ( global_single_integer > 0 )
                {
                    log_out << "plus sign not at beginning" << std::endl ;
                }
                break ;
            default :
                global_yes_or_no_numeric_delimiter_encountered = global_yes ;
                break ;
        }
    } else
    {
        switch ( global_single_character_as_integer )
        {
            case global_ascii_code_for_period :
                global_yes_or_no_number_is_valid = global_no ;
                log_out << "extra period" << std::endl ;
                break ;
            case global_ascii_code_for_digit_0 :
                global_single_decimal_number = global_single_decimal_number * 10 ;
                global_decimal_number_divisor *= 10.0 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_1 :
                global_single_decimal_number = ( global_single_decimal_number * 10 ) + 1 ;
                global_decimal_number_divisor *= 10.0 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_2 :
                global_single_decimal_number = ( global_single_decimal_number * 10 ) + 2 ;
                global_decimal_number_divisor *= 10.0 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_3 :
                global_single_decimal_number = ( global_single_decimal_number * 10 ) + 3 ;
                global_decimal_number_divisor *= 10.0 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_4 :
                global_single_decimal_number = ( global_single_decimal_number * 10 ) + 4 ;
                global_decimal_number_divisor *= 10.0 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_5 :
                global_single_decimal_number = ( global_single_decimal_number * 10 ) + 5 ;
                global_decimal_number_divisor *= 10.0 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_6 :
                global_single_decimal_number = ( global_single_decimal_number * 10 ) + 6 ;
                global_decimal_number_divisor *= 10.0 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_7 :
                global_single_decimal_number = ( global_single_decimal_number * 10 ) + 7 ;
                global_decimal_number_divisor *= 10.0 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_8 :
                global_single_decimal_number = ( global_single_decimal_number * 10 ) + 8 ;
                global_decimal_number_divisor *= 10.0 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_digit_9 :
                global_single_decimal_number = ( global_single_decimal_number * 10 ) + 9 ;
                global_decimal_number_divisor *= 10.0 ;
                global_number_of_digits_encountered ++ ;
                break ;
            case global_ascii_code_for_hyphen :
                if ( global_single_decimal_number == 0 )
                {
                    global_yes_or_no_negative_number = global_yes ;
                } else
                {
                    log_out << "minus sign not at beginning" << std::endl ;
                }
                break ;
            case global_ascii_code_for_plus :
                if ( global_single_decimal_number != 0 )
                {
                    log_out << "minus sign not at beginning" << std::endl ;
                }
                break ;
            default :
                global_yes_or_no_numeric_delimiter_encountered = global_yes ;
                break ;
        }
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function finish_parse_characters_of_number

void finish_parse_characters_of_number( )
{
    if ( global_yes_or_no_number_is_valid == global_no )
    {
        global_single_integer = 0 ;
        global_single_decimal_number = 0.0 ;
        log_out << "number is not valid" << std::endl ;
        return ;
    }
    if ( global_yes_or_no_decimal_number == global_no )
    {
        if ( global_yes_or_no_negative_number == global_yes )
        {
            global_single_integer = - global_single_integer ;
        }
    } else
    {
        if ( global_decimal_number_divisor > 1.0 )
        {
            global_single_decimal_number = global_single_decimal_number / global_decimal_number_divisor ;
        }
        if ( global_yes_or_no_negative_number == global_yes )
        {
            global_single_decimal_number = - global_single_decimal_number ;
        }
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function test_parsing_numeric_characters

void test_parsing_numeric_characters( )
{
    global_text_item_id_from_origin = global_text_item_id_for_sample_numbers ;
    initialize_parse_characters_of_number( ) ;
    for ( global_text_pointer = global_text_pointer_begin_for_item[ global_text_item_id_from_origin ] ; global_text_pointer <= global_text_pointer_end_for_item[ global_text_item_id_from_origin ] ; global_text_pointer ++ )
    {
        global_single_character_as_integer = global_storage_all_text[ global_text_pointer ] ;
        parse_one_character_of_number( ) ;
        if ( ( global_yes_or_no_numeric_delimiter_encountered == global_yes ) || ( global_text_pointer == global_text_pointer_end_for_item[ global_text_item_id_from_origin ] ) )
        {
            if ( global_number_of_digits_encountered > 0 )
            {
                if ( global_yes_or_no_number_is_valid == global_yes )
                {
                    finish_parse_characters_of_number( ) ;
                    if ( global_yes_or_no_decimal_number == global_no )
                    {
                        log_out << "integer number = " << global_single_integer << std::endl ;
                    } else
                    {
                        convert_decimal_to_text( ) ;
                        log_out << "decimal number in text item " << std::endl ;
                    }
                } else
                {
                    log_out << "invalid number" << std::endl ;
                }
            }
            initialize_parse_characters_of_number( ) ;
        }
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function initialize_parse_characters_of_filename

void initialize_parse_characters_of_filename( )
{
    global_yes_or_no_filename_is_valid = global_yes ;
    global_yes_or_no_in_filename_before_period = global_yes ;
    global_number_of_valid_characters_encountered = 0 ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function parse_one_character_of_filename

void parse_one_character_of_filename( )
{
    global_character_category = global_character_category_number_for_character_number[ global_single_character_as_integer ] ;
    switch ( global_character_category )
    {
        case global_character_category_period :
            global_yes_or_no_in_filename_before_period = global_no ;
            if ( global_number_of_valid_characters_encountered < 1 )
            {
                global_yes_or_no_filename_is_valid = global_no ;
            }
            log_out << "period" << std::endl ;
            break ;
        case global_character_category_other :
            global_number_of_valid_characters_encountered ++ ;
            log_out << "valid character" << std::endl ;
            break ;
        case global_character_category_digit :
            global_number_of_valid_characters_encountered ++ ;
            log_out << "valid character" << std::endl ;
            break ;
        case global_character_category_hyphen :
            global_number_of_valid_characters_encountered ++ ;
            log_out << "valid character" << std::endl ;
            break ;
        case global_character_category_underscore :
            global_number_of_valid_characters_encountered ++ ;
            log_out << "valid character" << std::endl ;
            break ;
        default :
            global_yes_or_no_filename_delimiter_encountered = global_yes ;
            log_out << "delimiter" << std::endl ;
            break ;
    }
    if ( global_yes_or_no_filename_delimiter_encountered == global_yes )
    {
        if ( ( global_yes_or_no_in_filename_before_period == global_no ) && ( global_number_of_valid_characters_encountered < 1 ) )
        {
           global_yes_or_no_filename_is_valid = global_no ;
        }
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function initialize_parse_characters_of_folder_name

void initialize_parse_characters_of_folder_name( )
{
    global_yes_or_no_folder_name_is_valid = global_yes ;
    global_yes_or_no_in_folder_name_before_period = global_yes ;
    global_number_of_valid_characters_encountered = 0 ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function parse_one_character_of_folder_name

void parse_one_character_of_folder_name( )
{
    global_character_category = global_character_category_number_for_character_number[ global_single_character_as_integer ] ;
    switch ( global_character_category )
    {
        case global_character_category_other :
            global_number_of_valid_characters_encountered ++ ;
            log_out << "valid character" << std::endl ;
            break ;
        case global_character_category_digit :
            global_number_of_valid_characters_encountered ++ ;
            log_out << "valid character" << std::endl ;
            break ;
        case global_character_category_hyphen :
            global_number_of_valid_characters_encountered ++ ;
            log_out << "valid character" << std::endl ;
            break ;
        case global_character_category_underscore :
            global_number_of_valid_characters_encountered ++ ;
            log_out << "valid character" << std::endl ;
            break ;
        case global_character_category_slash :
            global_yes_or_no_folder_name_delimiter_encountered = global_yes ;
            log_out << "valid character" << std::endl ;
            break ;
        case global_character_category_backslash :
            global_yes_or_no_folder_name_delimiter_encountered = global_yes ;
            log_out << "valid character" << std::endl ;
            break ;
        default :
            global_yes_or_no_folder_name_delimiter_encountered = global_yes ;
            log_out << "delimiter" << std::endl ;
            break ;
    }
    if ( global_yes_or_no_folder_name_delimiter_encountered == global_yes )
    {
        if ( ( global_yes_or_no_in_folder_name_before_period == global_no ) && ( global_number_of_valid_characters_encountered < 1 ) )
        {
           global_yes_or_no_folder_name_is_valid = global_no ;
        }
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function yes_or_no_matching_text
//
//  Checks if two sequences of text characters are
//  the same.  It starts checking at both the
//  beginning and the end.  This approach is more
//  often going to be faster when the two text
//  sequences are numbers because the end digits
//  are more likely to be different.  The
//  characters are in "global_storage_all_text",
//  and the initial character pointers are:
//  "global_character_pointer_begin_for_text_one"
//  "global_character_pointer_end_for_text_one"
//  "global_character_pointer_begin_for_text_two"
//  "global_character_pointer_end_for_text_two".
//  These character pointers are modified by this
//  function.

void yes_or_no_matching_text( )
{


// -----------------------------------------------
//  If the lengths are different, there is no
//  match.

    if ( ( global_character_pointer_end_for_text_one - global_character_pointer_begin_for_text_one ) != ( global_character_pointer_end_for_text_two - global_character_pointer_begin_for_text_two ) )
    {
        global_yes_or_no_same_text = global_no ;
        return ;
    }


// -----------------------------------------------
//  Begin a loop that returns when a difference is
//  found, or when all the characters have been
//  checked.

    while ( 1 == 1 )
    {


// -----------------------------------------------
//  Check the next character at or near the
//  beginning of the two character sequences.

        if ( global_storage_all_text[ global_character_pointer_begin_for_text_one ] != global_storage_all_text[ global_character_pointer_begin_for_text_two ] )
        {
            global_yes_or_no_same_text = global_no ;
            return ;
        }
        global_character_pointer_begin_for_text_one ++ ;
        global_character_pointer_begin_for_text_two ++ ;
        if ( global_character_pointer_begin_for_text_one > global_character_pointer_end_for_text_one )
        {
            global_yes_or_no_same_text = global_yes ;
            return ;
        }


// -----------------------------------------------
//  Check the next character at or near the end of
//  the two character sequences.

        if ( global_storage_all_text[ global_character_pointer_end_for_text_one ] != global_storage_all_text[ global_character_pointer_end_for_text_two ] )
        {
            global_yes_or_no_same_text = global_no ;
            return ;
        }
        global_character_pointer_end_for_text_one -- ;
        global_character_pointer_end_for_text_two -- ;
        if ( global_character_pointer_begin_for_text_one > global_character_pointer_end_for_text_one )
        {
            global_yes_or_no_same_text = global_yes ;
            return ;
        }


// -----------------------------------------------
//  Repeat the loop.

    }


// -----------------------------------------------
//  End of yes_or_no_matching_text.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function check_same_text_in_two_text_items
//
//  Checks if the unicode text item
//  "global_text_item_one" contains the
//  same unicode text as in 
//  "global_text_item_two".
//  The result is indicated by the yes or no value
//  in "global_yes_or_no_same_text".

void check_same_text_in_two_text_items( )
{

//  todo: avoid the need for this function

    global_character_pointer_begin_for_text_one = global_text_pointer_begin_for_item[ global_text_item_one ] ;
    global_character_pointer_end_for_text_one = global_text_pointer_end_for_item[ global_text_item_one ] ;
    global_character_pointer_begin_for_text_two = global_text_pointer_begin_for_item[ global_text_item_two ] ;
    global_character_pointer_end_for_text_two = global_text_pointer_end_for_item[ global_text_item_two ] ;
    yes_or_no_matching_text( ) ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function check_yes_or_no_same_phrase_name
//
//  Checks if the text item
//  "global_looking_at_hyphenated_phrase_name_in_text_item_id"
//  contains the same hyphenated phrase name as
//  the hyphenated phrase name stored in the
//  "parsed_hyphenated_phrase_name" area.
//  The text item is assumed to contain the
//  category "contains_hyphenated_phrase_name",
//  but this assumption is not checked here.  The
//  comparison result is in
//  "global_yes_or_no_same_phrase_name".

void check_yes_or_no_same_phrase_name( )
{

//  todo: refine this code


// -----------------------------------------------
//  Initialization.

    global_yes_or_no_same_phrase_name = global_yes ;


// -----------------------------------------------
//  If the number of words in the two hyphenated
//  phrase names are different, there is no match.

    global_word_count_hyphenated_phrase_name = global_text_pointer_end_for_item[ global_looking_at_hyphenated_phrase_name_in_text_item_id ] - global_text_pointer_begin_for_item[ global_looking_at_hyphenated_phrase_name_in_text_item_id ] + 1 ;
    if ( global_word_count_hyphenated_phrase_name == global_word_count_parsed_hyphenated_phrase_name )
    {
        global_yes_or_no_same_phrase_name = global_no ;
    }


// -----------------------------------------------
//  Point to the text items that hold the first
//  word in each phrase name.

    global_text_item_intended_next_word_in_hyphenated_phrase = global_storage_all_text[ global_text_pointer_begin_for_item[ global_looking_at_hyphenated_phrase_name_in_text_item_id ] ] ;
    global_text_item_looking_at_next_word_in_hyphenated_phrase = global_storage_all_text[ global_text_pointer_begin_for_item[ global_looking_at_hyphenated_phrase_name_in_text_item_id ] ] ;


// -----------------------------------------------
//  Check each word for a match.  If they differ,
//  the hyphenated phrase names do not match.
//
//  Later, alternate between checking at beginning
//  and end.  This approach will increase speed
//  in situations where the last word is an
//  integer.
//
//  Later, when phrase words are not duplicated,
//  just check if the text item ID numbers differ.

    for ( global_word_position = 1 ; global_word_position <= global_word_count_hyphenated_phrase_name ; global_word_position ++ )
    {
        global_check_for_match_text_item_id = global_storage_all_text[ global_text_item_intended_next_word_in_hyphenated_phrase ] ;
        global_text_item_id_to_find = global_storage_all_text[ global_text_item_looking_at_next_word_in_hyphenated_phrase ] ;
        check_same_text_in_two_text_items( ) ;
        if ( global_yes_or_no_same_text == global_no )
        {
            global_yes_or_no_same_phrase_name = global_no ;
            return ;
        }
        global_text_item_intended_next_word_in_hyphenated_phrase ++ ;
        global_text_item_looking_at_next_word_in_hyphenated_phrase ++ ;
    }


// -----------------------------------------------
//  End of function check_yes_or_no_same_phrase_name.

}


// -----------------------------------------------
// -----------------------------------------------
//  Function lookup_hyphenated_phrase_name
//
//  Searches all the defined hyphenated phrase
//  names to find a match with the hyphenated
//  phrase name defined by the pointers in the 
//  "parsed_hyphenated_phrase_name" area.
//  Puts the text item ID of the matching
//  hyphenated phrase name into the variable
//  global_text_item_id_of_matching_hyphenated_phrase_name,
//  but that variable is zero if no match was
//  found.
//
//  To increase speed, when a word within the
//  phrase name matches a word in the same
//  position of another phrase name, progress to
//  looking for the next word in the phrase name.
//  This approach is faster when the phrase name
//  contains an integer -- because the integer
//  is looked for earlier in the process, and
//  there are likely to be fewer phrase names
//  that include an integer.

void lookup_hyphenated_phrase_name( )
{
    global_text_item_id_of_matching_hyphenated_phrase_name = 0 ;
    for ( global_position_in_list_of_hyphenated_phrase_text_items = 1 ; global_position_in_list_of_hyphenated_phrase_text_items <= global_number_of_hyphenated_phrase_names_in_text_items ; global_position_in_list_of_hyphenated_phrase_text_items ++ )
    {
        global_looking_at_hyphenated_phrase_name_in_text_item_id = global_list_of_hyphenated_phrase_text_items[ global_position_in_list_of_hyphenated_phrase_text_items ] ;
        check_yes_or_no_same_phrase_name( ) ;
        if ( global_yes_or_no_same_phrase_name == global_yes )
        {
            global_text_item_id_of_matching_hyphenated_phrase_name = global_looking_at_hyphenated_phrase_name_in_text_item_id ;
            return ;
        }
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function add_new_hyphenated_phrase_name
//
//  Adds the hyphenated phrase name in the
//  "parsed_hyphenated_phrase_name" area.  This
//  function assumes the hyphenated phrase name
//  does not match any existing hyphenated phrase
//  name.  Do not duplicate any words that are
//  already used in other hyphenated phrase names.
//

void add_new_hyphenated_phrase_name( )
{

//  todo: write this code

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function convert_into_category_list_of_integers
//
//  Convert a text item that contains only integers
//  -- in text format -- into a text item that is
//  a list of integers.

void convert_into_category_list_of_integers( )
{
    global_count_of_words_handled = 0 ;
    global_text_item_id_for_integers_as_text = global_text_item_id_from_origin ;
    global_length_requested_for_next_text_item_storage = 2 ;
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_list_of_integers = global_new_storage_text_item_id ;
    initialize_point_to_next_word_in_text_item( ) ;
    while ( 1 == 1 )
    {
        point_to_next_word_in_text_item( ) ;
        if ( global_pointer_next_word_begin == 0 )
        {
            log_out << "no more words" << std::endl ;
            break ;
        }
        global_text_pointer_begin_for_item[ global_text_item_id_for_pointer_begin_end ] = global_pointer_next_word_begin ;
        global_text_pointer_end_for_item[ global_text_item_id_for_pointer_begin_end ] = global_pointer_next_word_end ;
        measure_space_available_in_text_item( ) ;
        if ( global_space_available_in_text_item < 1 )
        {
            extend_length_of_top_text_item( ) ;
        }

        global_text_item_id_for_integers_as_text = global_text_item_id_for_pointer_begin_end ;

        while ( 1 == 1 )
        {
            initialize_parse_characters_of_number( ) ;
            global_single_character_as_integer = global_storage_all_text[ global_text_pointer ] ;
            parse_one_character_of_number( ) ;
            if ( ( global_yes_or_no_numeric_delimiter_encountered == global_yes ) || ( global_text_pointer == global_text_pointer_end_for_item[ global_text_item_id_from_origin ] ) )
            {
                if ( global_number_of_digits_encountered > 0 )
                {
                    if ( global_yes_or_no_number_is_valid == global_yes )
                    {
                        finish_parse_characters_of_number( ) ;
                        if ( global_yes_or_no_decimal_number == global_no )
                        {
                            global_text_pointer_end_for_item[ global_text_item_id_for_list_of_integers ] ++ ;
                            global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_list_of_integers ] ] = global_single_integer ;
                            log_out << "integer number = " << global_single_integer << std::endl ;
                            break ;
                        } else
                        {
                            global_text_item_id_for_list_of_integers = 0 ;
                            global_text_item_id_to_edit = 0 ;
                            recover_memory_from_top_text_item( ) ;
                            log_out << "number is not integer, is decimal" << std::endl ;
                            return ;
                        }
                    } else
                    {
                        global_text_item_id_for_list_of_integers = 0 ;
                        global_text_item_id_to_edit = 0 ;
                        recover_memory_from_top_text_item( ) ;
                        log_out << "invalid number" << std::endl ;
                        return ;
                    }
                }
                initialize_parse_characters_of_number( ) ;
            }
        }
    }
    recover_memory_from_top_text_item( ) ;
    global_text_item_id_to_edit = global_text_item_id_for_list_of_integers ;
    global_text_category_for_item[ global_text_item_id_for_list_of_integers ] = global_category_contains_list_of_integers ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function convert_into_category_pointers_to_decimal_numbers
//
//  Use function that parses decimal numbers.

void convert_into_category_pointers_to_decimal_numbers( )
{

//  todo: copy code from integer version -- after it has been debugged

    global_text_category_for_item[ global_text_item_id_from_origin ] = global_category_contains_pointers_to_decimal_numbers ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function scan_text_item_for_character_usage
//
//  This function scans the text item indicated by
//  "global_text_item_id" and counts how
//  many times each character appears within that
//  text.

void scan_text_item_for_character_usage( )
{


// -----------------------------------------------
//  Initialization.

    log_out << "global_text_item_id " << global_text_item_id << std::endl ;
    for ( global_single_character_as_integer = global_minimum_usage_character_to_consider ; global_single_character_as_integer <= global_maximum_usage_character_to_consider ; global_single_character_as_integer ++ )
    {
        global_usage_count_for_character[ global_single_character_as_integer ] = 0 ;
    }


// -----------------------------------------------
//  Begin a loop that looks at each character, and
//  exit the loop when there are no more
//  characters.

    initialize_get_next_character_from_text_item( ) ;
    global_next_character_position_count = 0 ;
    while ( global_single_character_as_integer != 0 )
    {
        get_next_or_previous_character_from_text_item( ) ;
        if ( global_single_character_as_integer == 0 )
        {
            break ;
        }


// -----------------------------------------------
//  Count how many times each character is
//  encountered.

        if ( ( global_single_character_as_integer >= global_minimum_usage_character_to_consider ) && ( global_single_character_as_integer <= global_maximum_usage_character_to_consider ) )
        {
            global_usage_count_for_character[ global_single_character_as_integer ] ++ ;
        }


// -----------------------------------------------
//  Repeat the loop for the next character.

    }


// -----------------------------------------------
//  End of function
//  scan_text_item_for_character_usage.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function scan_searched_text_before_doing_find_text
//
//  This function scans the text item indicated by
//  "global_text_item_id_to_search" and copies
//  into the
//  "global_searched_usage_count_for_character"
//  array the character usage counts.

void scan_searched_text_before_doing_find_text( )
{
    global_text_item_id = global_text_item_id_to_search ;
    scan_text_item_for_character_usage( ) ;
    for ( global_single_character_as_integer = global_minimum_usage_character_to_consider ; global_single_character_as_integer <= global_maximum_usage_character_to_consider ; global_single_character_as_integer ++ )
    {
        global_searched_usage_count_for_character[ global_single_character_as_integer ] = global_usage_count_for_character[ global_single_character_as_integer ] ;
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function initialize_track_recent_position_of_each_character

void initialize_track_recent_position_of_each_character( )
{
    log_out << "global_text_item_id " << global_text_item_id << std::endl ;
    global_next_character_position_count = 0 ;
    initialize_get_next_character_from_text_item( ) ;
    for ( global_single_character_as_integer = global_minimum_usage_character_to_consider ; global_single_character_as_integer <= global_maximum_usage_character_to_consider ; global_single_character_as_integer ++ )
    {
        global_recent_character_position_for_character_number[ global_single_character_as_integer ] = 0 ;
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function track_recent_position_of_each_character
//
//  This function keeps track of the position
//  where each character was last encountered.
//  The function
//  "initialize_track_recent_position_of_each_character"
//  must be used before using this function.  This
//  function is used repeatedly because it stops
//  when the character specified in
//  "global_optimum_character_for_find_pause" is
//  encountered.

void track_recent_position_of_each_character( )
{


// -----------------------------------------------
//  Begin a loop that looks at each character in
//  the text item.

    while ( global_single_character_as_integer != 0 )
    {
        get_next_or_previous_character_from_text_item( ) ;


// -----------------------------------------------
//  Exit the loop and this function when the
//  character specified in
//  "global_optimum_character_for_find_pause" is
//  encountered, or when the end of the text item
//  is reached.

        if ( ( global_single_character_as_integer == global_optimum_character_for_find_pause ) || ( global_single_character_as_integer == 0 ) )
        {
            return ;
        }


// -----------------------------------------------
//  Update a list of pointers that indicates when
//  the current character was last encountered.

        global_next_character_position_count ++ ;
        if ( ( global_single_character_as_integer >= global_minimum_usage_character_to_consider ) && ( global_single_character_as_integer <= global_maximum_usage_character_to_consider ) )
        {
            global_recent_character_position_for_character_number[ global_single_character_as_integer ] = global_next_character_position_count ;
        }


// -----------------------------------------------
//  Also track the last appearance of any
//  delimiter.

        switch ( global_single_character_as_integer )
        {
            case global_ascii_code_for_space :
                global_recent_position_of_any_delimiter = global_next_character_position_count ;
                break ;
            case global_ascii_code_for_tab :
                global_recent_position_of_any_delimiter = global_next_character_position_count ;
                break ;
            case global_ascii_code_for_newline :
                global_recent_position_of_any_delimiter = global_next_character_position_count ;
                break ;
            case global_ascii_code_for_formfeed :
                global_recent_position_of_any_delimiter = global_next_character_position_count ;
                break ;
            case global_ascii_code_for_carriage_return :
                global_recent_position_of_any_delimiter = global_next_character_position_count ;
                break ;
        }


// -----------------------------------------------
//  Point to the position of the found character.

    global_saved_single_character_as_integer = global_single_character_as_integer ;
    global_direction_next_or_previous = global_direction_previous ;
    get_next_or_previous_character_from_text_item( ) ;
    global_direction_next_or_previous = global_direction_next ;
    global_single_character_as_integer = global_saved_single_character_as_integer ;


// -----------------------------------------------
//  Repeat the loop for the next character.

    }


// -----------------------------------------------
//  End of function
//  track_recent_position_of_each_character.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function find_optimum_character_for_find_pause
//
//  This function finds which character should be
//  used as a trigger for pausing the find process
//  to fully check for a match.  The optimum
//  character is one that is at or near the end of
//  the text being found, and is a character that
//  appears less often in the text being searched,
//  and appears only once in the text being found.
//  This function assumes the text to find has no
//  subordinate text items, and contains only
//  unicode characters (of any kind).  If this
//  code is enhanced to handle Chinese characters,
//  a larger character code range is needed.  If
//  none of the letters in the match text appear
//  in the search text, then the character to find
//  is set to zero to indicate this case.

void find_optimum_character_for_find_pause( )
{
    global_optimum_character_for_find_pause = 0 ;
    global_length_of_text_to_find = global_text_pointer_end_for_item[ global_text_item_id_from_origin ] - global_text_pointer_begin_for_item[ global_text_item_id_from_origin ] + 1 ;
    global_text_pointer = global_text_pointer_begin_for_item[ global_text_item_id_from_origin ] ;
    global_highest_score_for_optimum_character_for_find_pause = 0 ;
    for ( global_position_within_text_to_find = 1 ; global_position_within_text_to_find <= global_length_of_text_to_find ; global_position_within_text_to_find ++ )
    {
        global_possible_optimum_character_as_integer = global_storage_all_text[ global_text_pointer ] ;
        if ( global_usage_count_for_character[ global_possible_optimum_character_as_integer ] == 0 )
        {
            continue ;
        }
        global_score_for_possible_optimum_character = ( global_length_of_matching_text - global_position_within_text_to_find ) + ( global_usage_count_for_character[ global_possible_optimum_character_as_integer ] * global_searched_usage_count_for_character[ global_possible_optimum_character_as_integer ] ) ;
        if ( global_score_for_possible_optimum_character > global_highest_score_for_optimum_character_for_find_pause )
        {
            global_optimum_character_for_find_pause = global_possible_optimum_character_as_integer ;
            global_highest_score_for_optimum_character_for_find_pause = global_score_for_possible_optimum_character ;
            global_position_of_optimum_character_for_pause = global_position_within_text_to_find ;

            log_out << "position " << global_position_within_text_to_find << ", character " << global_possible_optimum_character_as_integer << ", score " << global_score_for_possible_optimum_character << std::endl ;

        }
        global_text_pointer ++ ;
    }
    log_out << "optimum character to find is " << global_optimum_character_for_find_pause << std::endl ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function check_for_match_where_paused
//
//  This function determines whether the text
//  being searched matches the text to find.  This
//  check is done when the target pointer stack is
//  pointing to an occurance of the optimum
//  character that triggers this check.  The text
//  item "global_text_item_id_to_find" is the text
//  to find.  The text item being searched is
//  ...

//  todo: proofread this code

void check_for_match_where_paused( )
{
    global_yes_or_no_matching_text = global_yes ;

    global_position_of_found_character_for_find_pause = global_recent_character_position_for_character_number[ global_optimum_character_for_find_pause ] ;
    global_character_distance_from_optimum_character_for_pause = 0 ;
    for ( global_text_pointer = global_text_pointer_end_for_item[ global_text_item_id_to_find ] ; global_text_pointer >= global_text_pointer_begin_for_item[ global_text_item_id_to_find ] ; global_text_pointer -- )
    {
        global_single_character_as_integer = global_storage_all_text[ global_text_pointer ] ;
        if ( ( global_recent_character_position_for_character_number[ global_single_character_as_integer ] + global_character_distance_from_optimum_character_for_pause ) != global_position_of_found_character_for_find_pause )
        {
            global_yes_or_no_matching_text = global_no ;
            return ;
        }
        global_character_distance_from_optimum_character_for_pause ++ ;
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function find_matching_text
//
//  This function finds some "matched" text
//  within some text to be searched.  The text to
//  match must be in "global_text_item_id_to_find"
//  The text to be searched must be in
//  "global_text_item_id_to_search" and that text
//  must be the same text that was scanned using
//  the function
//  "scan_searched_text_before_doing_find_text".
//  The result is ...

//  The starting point for the text to be searched
//  must be specified by the pointer stack pointed
//  to by "global_...".
//
//  This function is similar to the standard
//  C-language "index" function, but allows the
//  text being searched to be in text items and
//  subordinate text items, and can include
//  integers and decimal numbers that are searched
//  as text.  Also, the characters are stored as
//  integers, not bytes, to allow unicode
//  searches.
//
//  Reminder:  This function is not used during
//  runtime to search for matching hyphenated
//  phrase names unless the directive fenambee
//  or amennfen are involved.  During compile time
//  matching phrase names are resolved
//  immediately.

void find_matching_text( )
{


// -----------------------------------------------
//  Initialize the flag the indicates whether the
//  matching text was found.

    global_yes_or_no_matching_text = global_no ;


// -----------------------------------------------
//  Get the character usage counts for the text to
//  be found.

    global_text_item_id_from_origin = global_text_item_id_to_find ;
    scan_text_item_for_character_usage( ) ;


// -----------------------------------------------
//  Determine which character to use for
//  triggering pauses when the full text is
//  checked for a match.  It is put into the
//  variable
//  "global_optimum_character_for_find_pause".

    find_optimum_character_for_find_pause( ) ;


// -----------------------------------------------
//  If none of the characters in the matching text
//  appear in the text being searched, indicate
//  the text does not contain the matching text.

    if ( global_optimum_character_for_find_pause == 0 )
    {
        global_position_of_found_character_for_find_pause = 0 ;
        return ;
    }


// -----------------------------------------------
//  Scan the text being searched, and pause when
//  the "optimum" character is encountered, and
//  check whether there is a full match at that
//  position.

    initialize_get_next_character_from_text_item( ) ;
    while ( 1 == 1 )
    {
        get_next_or_previous_character_from_text_item( ) ;
        if ( global_single_character_as_integer == 0 )
        {
            global_yes_or_no_matching_text = 0 ;
            return ;
        }
        if ( global_single_character_as_integer == global_optimum_character_for_find_pause )
        {
            check_for_match_where_paused( ) ;
            if ( global_yes_or_no_matching_text == global_yes )
            {
                break ;
            }
        }
    }


// -----------------------------------------------
//  If the text matches, return with pointers to
//  the beginning and end of the matching text.

    if ( global_yes_or_no_matching_text == global_yes )
    {

//  todo: write this code

    }


// -----------------------------------------------
//  End of function find_matching_text.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function replace_angle_bracketed_phrase_names
//
//  This function finds each occurance of a phrase
//  name in angle brackets, with underscores where
//  the hyphens would otherwise appear, such as
//  "<character_hyphen>".  It does not check
//  whether the phrase name is defined.  It only
//  checks that the characters between the angle
//  brackets include at least one underscore and
//  does not include a hyphen.

void replace_angle_bracketed_phrase_names( )
{


// -----------------------------------------------
//  Initialization.

// todo: still need to handle pointer to stack for recent copy of stack

    global_text_item_id = global_text_item_id_to_edit ;
    initialize_get_next_character_from_text_item( ) ;
    initialize_track_recent_position_of_each_character( ) ;


// -----------------------------------------------
//  Begin a loop that repeatedly looks for the
//  desired sequence of a delimiter, an open angle
//  bracket, an underscore, and then a close angle
//  bracket.

    while ( global_single_character_as_integer > 0 )
    {


// -----------------------------------------------
//  When the end of the text is encountered,
//  return.

        if ( global_single_character_as_integer == 0 )
        {
            log_out << "angle bracketed phrases replaced, or were not found" << std::endl ;
            return ;
        }


// -----------------------------------------------
//  Find the next open angle bracket, and save a
//  copy of the target pointer stack to keep track
//  of this location.

        global_optimum_character_for_find_pause = global_ascii_code_for_open_angle_bracket ;
        track_recent_position_of_each_character( ) ;
        copy_pointer_stack( ) ;


// -----------------------------------------------
//  If an open angle bracket is not found, return.

        if ( global_single_character_as_integer == 0 )
        {
            log_out << "open angle bracket not found" << std::endl ;
            return ;
        }


// -----------------------------------------------
//  Find the next close angle bracket.

        global_optimum_character_for_find_pause = global_ascii_code_for_open_angle_bracket ;
        track_recent_position_of_each_character( ) ;


// -----------------------------------------------
//  If a close angle bracket was not found, return
//  without a pointer to the found text.

        if ( global_single_character_as_integer == 0 )
        {
            log_out << "close angle bracket not found" << std::endl ;
            return ;
        }


// -----------------------------------------------
//  If the sequence of the latest underscore and
//  angle brackets does not match the sequence
//  being searched for -- namely delimiter, open
//  angle bracket, underscore, then close angle
//  bracket -- then repeat the search loop.

        log_out << "global_recent_position_of_any_delimiter " << global_recent_position_of_any_delimiter << std::endl << "global_position_of_open_angle_bracket " << global_position_of_open_angle_bracket << std::endl << "global_position_of_underscore " << global_position_of_underscore << std::endl << "global_position_of_close_angle_bracket " << global_position_of_close_angle_bracket << std::endl << "global_current_target_text_item " << global_current_target_text_item << std::endl ;

        global_position_of_open_angle_bracket = global_recent_character_position_for_character_number[ global_ascii_code_for_open_angle_bracket ] ;
        global_position_of_underscore = global_recent_character_position_for_character_number[ global_ascii_code_for_underscore ] ;
        global_position_of_close_angle_bracket = global_recent_character_position_for_character_number[ global_ascii_code_for_close_angle_bracket ] ;
        if ( ( global_recent_position_of_any_delimiter < global_position_of_open_angle_bracket ) && ( global_position_of_open_angle_bracket < global_position_of_underscore ) && ( global_position_of_underscore < global_position_of_close_angle_bracket ) )
        {
            continue ;
        }


// -----------------------------------------------
//  Point to the found text that matches the
//  pattern.

        global_position_of_close_angle_bracket_within_text_item = global_current_target_character_position - 1 ;
        global_position_of_open_angle_bracket_within_text_item = global_position_of_close_angle_bracket_within_text_item - ( global_position_of_close_angle_bracket - global_position_of_open_angle_bracket ) ;


// -----------------------------------------------
//  If the angle bracketed phrase name is not
//  entirely within one text item, exit with an
//  error.  Later, if this error ever occurs,
//  add code that copies the entire text item into
//  a single text item, and switch to using that
//  instead.

        if ( global_position_of_open_angle_bracket < 1 )
        {
            log_out << "angle bracketed phrase is not within a single text item and current code does not yet handle this situation" << std::endl ;
            exit( EXIT_FAILURE ) ;
        }


// -----------------------------------------------
//  Find the hyphenated phrase name.

//  todo: write this code


// -----------------------------------------------
//  Find the definition of the phrase name and
//  insert that text where the angle bracketed
//  phrase name appears.

//  todo: write this code



// -----------------------------------------------
//  Repeat the loop until the entire text has been
//  searched and modified.

    }


// -----------------------------------------------
//  End of replace_angle_bracketed_phrase_names.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function expand_text
//
//  Expands the text item indicated in
//  global_text_item_id_from_origin.

//  Local variables are used because this function
//  can be used recursively.

//  Currently being changed from Perl code to C.

void expand_text( )
{


// -----------------------------------------------
//  Declarations.

    int expand_endless_cycle_count_maximum ;
    int current_phrase_text_item_id ;
    int expand_result_text_item_id ;
    int output_buffer ;
    int space_directive ;
    int expand_endless_loop_counter ;
    int expand_endless_loop_counter_maximum ;
    int recursion_level ;
    int pointer_to_phrase_begin ;
    int pointer_to_next_space ;
    int pointer_to_phrase_end ;
    int prior_length ;
    int prefix ;
    int possible_phrase_name_with_underscores ;
    int length_of_tag ;
    int new_output_buffer ;
    int pointer_to_remainder_of_output_buffer ;
    int possible_phrase_name_with_hyphens ;
    int pointer_to_close_angle_bracket ;
    int length_of_output_buffer ;
    int maximum_cycle_count ;
    int phrase_name ;
    int cycle_count ;
    int phrase_name_with_highest_cycle_count ;
    int length_of_code_at_recursion_level_current ;

    int code_at_recursion_level[ 105 ] ;
    int length_of_code_at_recursion_level[ 105 ] ;
    int pointer_to_remainder_of_code_at_recursion_level[ 105 ] ;

    int expand_buffer_text_item_id ;

    const int space_directive_none = 1 ;
    const int space_directive_one = 2 ;
    const int space_directive_one_requested = 3 ;


// -----------------------------------------------
//  Specify the text item being expanded.

    global_id_for_phrase_name_expand_text = global_text_item_id_to_edit ;


// -----------------------------------------------
//  Specify that when appending is done, the
//  "copied" version is used.

    global_yes_or_no_use_copy_when_appending = global_yes ;


// -----------------------------------------------
//  Initialization.

    global_text_item_id = expand_buffer_text_item_id ;
    text_item_clear( ) ;

// output_buffer = '' ;
    space_directive = space_directive_none ;
// new_output_buffer = '' ;
// possible_phrase_name_with_underscores = '' ;

    pointer_to_remainder_of_output_buffer = 0 ;
    expand_endless_loop_counter = 0 ;
    expand_endless_loop_counter_maximum = 100000 ;
    expand_endless_cycle_count_maximum = 100000 ;

// @code_at_recursion_level = ( ) ;
// @length_of_code_at_recursion_level = ( ) ;
// @pointer_to_remainder_of_code_at_recursion_level = ( ) ;

// code_at_recursion_level[ 0 ] = 'unused' ;
// pointer_to_remainder_of_code_at_recursion_level[ 0 ] = 0 ;
// length_of_code_at_recursion_level[ 0 ] = 0 ;



// -----------------------------------------------
//  Begin a loop that handles each space delimited
//  string in the phrase definition.

// code_at_recursion_level[ 1 ] = global_text_item_id_from_origin ;
// pointer_to_remainder_of_code_at_recursion_level[ 1 ] = 0 ;
// length_of_code_at_recursion_level[ 1 ] = length( code_at_recursion_level[ 1 ] ) ;

    recursion_level = 1 ;

    while ( ( recursion_level > 0 ) && ( expand_endless_loop_counter <= expand_endless_loop_counter_maximum ) )
    {
        expand_endless_loop_counter ++ ;


// -----------------------------------------------
//  Get the next phrase name.  If there is no more
//  code at the current recursion level, shift
//  back to the previous recursion level.  When
//  the recursion_level reaches zero, the loop
//  will end.

// length_of_code_at_recursion_level_current = length_of_code_at_recursion_level[ recursion_level ] ;
        if ( length_of_code_at_recursion_level_current == 0 )
        {
            recursion_level -- ;
            continue ;
        }
// pointer_to_phrase_begin = pointer_to_remainder_of_code_at_recursion_level[ recursion_level ] ;
// while ( ( pointer_to_phrase_begin < length_of_code_at_recursion_level_current ) && ( substr( code_at_recursion_level[ recursion_level ] , pointer_to_phrase_begin , 1 ) eq ' ' ) ) {
        pointer_to_phrase_begin ++ ;
// }
// pointer_to_next_space = index( code_at_recursion_level[ recursion_level ] , ' ' , pointer_to_phrase_begin ) ;
        if ( pointer_to_next_space == -1 )
        {
// pointer_to_phrase_end = length_of_code_at_recursion_level_current - 1 ;
// pointer_to_remainder_of_code_at_recursion_level[ recursion_level ] = length_of_code_at_recursion_level_current ;
        } else
        {
// pointer_to_next_space = index( code_at_recursion_level[ recursion_level ] , ' ' , pointer_to_phrase_begin ) ;
            if ( pointer_to_next_space > pointer_to_phrase_begin )
            {
                pointer_to_phrase_end = pointer_to_next_space - 1 ;
// pointer_to_remainder_of_code_at_recursion_level[ recursion_level ] = pointer_to_next_space ;
            } else
            {
                pointer_to_phrase_end = -2 ;
            }
        }
        if ( pointer_to_phrase_begin > pointer_to_phrase_end )
        {
            recursion_level -- ;
            continue ;
        }
// current_phrase_text_item_id = substr( code_at_recursion_level[ recursion_level ] , pointer_to_phrase_begin , ( pointer_to_phrase_end - pointer_to_phrase_begin + 1 ) ) ;


// -----------------------------------------------
// Check for an endless loop caused by the same
// phrase name being encountered too many times.
// If this occurs, exit the endless loop.

        if ( global_yes_or_no_count_phrase_usage == global_yes )
        {
// global_number_of_times_encountered_phrase_named{ current_phrase_text_item_id } ++ ;
// if ( global_number_of_times_encountered_phrase_named{ current_phrase_text_item_id } >= expand_endless_cycle_count_maximum ) {
            maximum_cycle_count = 0 ;
// foreach phrase_name ( keys( %global_number_of_times_encountered_phrase_named ) ) {
// cycle_count = global_number_of_times_encountered_phrase_named{ phrase_name } ;
        if ( cycle_count > maximum_cycle_count )
        {
           maximum_cycle_count = cycle_count ;
// phrase_name = phrase_name_with_highest_cycle_count ;
        }
// }
// global_action_result = 'trace_diagnostic__expand_phrases__error_endless_loop__highest_count ' . phrase_name_with_highest_cycle_count . ' ' . maximum_cycle_count . "\n" ;
// print global_action_result . "\n" ;
// return '' ;
// }
        }


// -----------------------------------------------
//  todo:
//
//  Later, terminate the first loop and start a
//  separate loop that handles space directives,
//  and a third separate loop that handles angle-
//  bracketed and underscore-joined phrase names,
//  and a fourth loop that repositions "specify"
//  and "attribute" directives.


// global_id_for_phrase_name_expand_text


// -----------------------------------------------
//  If the phrase name is a hyphen directive, or a
//  space directive, or a line directive, handle
//  it.

        if ( current_phrase_text_item_id == global_id_for_phrase_name_hyphen_here )
        {
// output_buffer .= '-' ;
            space_directive = space_directive_none ;
            continue ;
        }
        if ( current_phrase_text_item_id == global_id_for_phrase_name_no_space )
        {
            if ( space_directive = space_directive_one_requested )
            {
                space_directive = space_directive_none ;
            }
            continue ;
        }
// if ( current_phrase_text_item_id eq ( '<' . 'no_space' . '>' ) ) {
            space_directive = space_directive_none ;
            continue ;
// }
        if ( current_phrase_text_item_id == global_id_for_phrase_name_one_space )
        {
            space_directive = space_directive_one_requested ;
            continue ;
        }
// if ( current_phrase_text_item_id eq ( '<' . 'one_space' . '>' ) ) {
            space_directive = space_directive_one_requested ;
            continue ;
// }
        if ( current_phrase_text_item_id == global_id_for_phrase_name_new_line )
        {
// output_buffer .= "\n" ;
            space_directive = space_directive_none ;
            continue ;
        }
// if ( current_phrase_text_item_id eq ( '<' . 'new_line' . '>' ) ) {
// output_buffer .= "\n" ;
            space_directive = space_directive_none ;
            continue ;
// }
        if ( current_phrase_text_item_id == global_id_for_phrase_name_empty_line )
        {
// output_buffer .= "\n\n" ;
            space_directive = space_directive_none ;
            continue ;
        }
// if ( current_phrase_text_item_id eq ( '<' . 'empty_line' . '>' ) ) {
// output_buffer .= "\n\n" ;
            space_directive = space_directive_none ;
            continue ;
// }


// -----------------------------------------------
//  If the phrase name has a definition (which can
//  be empty), and it is not a space directive or
//  line directive, insert phrase definition into
//  the text being expanded, and remove the phrase
//  name.

// if ( ( current_phrase_text_item_id =~ /[^ \-]\-[^ \-]/ ) && ( exists( global_dashrep_replacement{ current_phrase_text_item_id } ) ) ) {
            recursion_level ++ ;
// code_at_recursion_level[ recursion_level ] = global_dashrep_replacement{ current_phrase_text_item_id } ;
// length_of_code_at_recursion_level[ recursion_level ] = length( code_at_recursion_level[ recursion_level ] ) ;
// pointer_to_remainder_of_code_at_recursion_level[ recursion_level ] = 0 ;
            continue ;
// }


// -----------------------------------------------
//  If a space should be inserted here, insert it.
//  Specify a default of inserting one space after
//  the next phrase insertion.

        if ( ( space_directive == space_directive_one ) || ( space_directive == space_directive_one_requested ) )
        {
// output_buffer .= ' ' ;
        }
        space_directive = space_directive_one ;


// -----------------------------------------------
//  At this point the current text string is not
//  the name of a defined phrase, so just use the
//  text string.

// output_buffer .= current_phrase_text_item_id ;
// pointer_to_remainder_of_code_at_recursion_level[ recursion_level ] = pointer_to_phrase_end + 1 ;


// -----------------------------------------------
//  In the output buffer, if there is a
//  "<specify " string that needs to be combined
//  with the preceding tag, combine it into a
//  single XML or HTML tag.  Handle tags of type
//  "<xyz />" as well as "<xyz>".

// if ( index( output_buffer , '<specify ' ) > 0 ) {
        prior_length = 0 ;
// while ( length( output_buffer ) != prior_length ) {
// prior_length = length( output_buffer ) ;
// output_buffer =~ s/ *\/> *<specify +([^>]+)>/ $1 \/>/ ;
// }
// if ( index( output_buffer , '<specify ' ) > 0 ) {
        prior_length = 0 ;
// while ( length( output_buffer ) != prior_length ) {
// prior_length = length( output_buffer ) ;
// output_buffer =~ s/ *> *<specify +/ / ;
// }
// }
// }


// -----------------------------------------------
//  If the output buffer contains a recognized
//  phrase name using underscores instead of
//  hyphens, and it is enclosed in angle brackets
//  (with no spaces), then replace that text with
//  the definition of the specified phrase.

// output_buffer =~ s/ *<placeholder_for_hyphen_here> */-/sg ;
// output_buffer =~ s/ *<placeholder_for_new_line> */\n/sg ;
// output_buffer =~ s/ *<placeholder_for_empty_line> */\n/sg ;

// if ( output_buffer =~ /<((no_space)|(hyphen_here)|(new_line))> *$/ ) {
            space_directive = space_directive_none ;
// }
            length_of_output_buffer = -1 ;
            pointer_to_remainder_of_output_buffer = 0 ;
// new_output_buffer = '' ;
// while ( substr( output_buffer , pointer_to_remainder_of_output_buffer ) =~ /^(.*?)<([^ \->]+_[^ \->]+)>/s ) {
// prefix = $1 ;
// possible_phrase_name_with_underscores = $2 ;
// length_of_output_buffer = length( output_buffer ) ;
// new_output_buffer .= prefix ;
// length_of_tag = length( possible_phrase_name_with_underscores ) ;
// pointer_to_remainder_of_output_buffer += length( prefix ) + length_of_tag + 2 ;

// possible_phrase_name_with_hyphens = possible_phrase_name_with_underscores ;
// possible_phrase_name_with_hyphens =~ s/_/-/g ;
// if ( exists( global_dashrep_replacement{ possible_phrase_name_with_hyphens } ) ) {
// new_output_buffer .= global_dashrep_replacement{ possible_phrase_name_with_hyphens } ;
// } else {
// new_output_buffer .= '<' . possible_phrase_name_with_underscores . '>' ;
// }
// }
            if ( length_of_output_buffer != -1 )
            {
// output_buffer = new_output_buffer . substr( output_buffer , pointer_to_remainder_of_output_buffer ) ;
// new_output_buffer = '' ;
// possible_phrase_name_with_underscores = '' ;
            }


// -----------------------------------------------
//  If the output buffer does not contain any text
//  that might need to be revised, then append it
//  to the result text.

// pointer_to_close_angle_bracket = index( output_buffer , '>' ) ;
// if ( pointer_to_close_angle_bracket < 0 ) {
// expand_result_text_item_id .= output_buffer ;
// output_buffer = '' ;
// } elsif ( length( output_buffer ) > 1000 ) {
// expand_result_text_item_id .= substr( output_buffer , 0 , 500 ) ;
// output_buffer = substr( output_buffer , 500 ) ;
// }


// -----------------------------------------------
//  Repeat the loop that handles each space
//  delimited string.

    }


// -----------------------------------------------
//  Supply the results.

// expand_result_text_item_id .= output_buffer ;
// return: global_expand_result_text_item_id ;
    return ;


// -----------------------------------------------
//  End of function expand_text.

}


// -----------------------------------------------
// -----------------------------------------------
//  Function execute_loop_handler_based_on_handler_id

void execute_loop_handler_based_on_handler_id( int local_text_item_id_for_next_word , int local_loop_handler )
{

//  use switch statement

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function implement_loop
//
//  This function points to the next word using a
//  pair of target pointer stacks, then executes
//  the requested action.
//
//  Local variables are used because this function
//  can be used recursively.

void implement_loop( )
{
    int local_text_item_id_contains_word_list ;
    int local_text_item_id_for_next_word ;
    int local_loop_handler ;
    local_text_item_id_contains_word_list = global_text_item_id_from_origin ;
    initialize_point_to_next_word_in_text_item( ) ;
    while ( 1 == 1 )
    {
        point_to_next_word_in_text_item( ) ;
        if ( global_single_character_as_integer == 0 )
        {
            return ;
        }
        execute_loop_handler_based_on_handler_id( local_text_item_id_for_next_word , local_loop_handler ) ;
// ... handler-name-with-underscores ...
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Functions that call the above functions.
//  These are needed to match the use of functions
//  in the Perl version, but these will be
//  eliminated later.

int parameterized_use_handler_with_each_word_in_phrase( int local_text_item_id )
{
    global_text_item_id_from_origin = local_text_item_id ;
    implement_loop( ) ;
    int expand_result_text_item_id ;  // temporary, to avoid compiler error
    return expand_result_text_item_id ;
}

int parameterized_dashrep_expand_text( int local_text_item_id )
{
    global_text_item_id_from_origin = local_text_item_id ;
    expand_text( ) ;
    int expand_result_text_item_id ;  // temporary, to avoid compiler error
    return expand_result_text_item_id ;
}

void parameterized_append_text( int local_text_item_id )
{
    global_text_item_id_from_origin = local_text_item_id ;
    append_copied_text( ) ;
    return ;
}

void parameterized_get_phrase_definition( int local_to_text_item_id , int local_from_text_item_id )
{
    local_to_text_item_id = global_id_of_item_containing_definition_for_item[ local_from_text_item_id ] ;
    return ;
}

void parameterized_put_phrase_definition( int local_from_text_item_id , int local_to_text_item_id )
{
    global_id_of_item_containing_definition_for_item[ local_to_text_item_id ] = local_from_text_item_id ;
    return ;
}

void handle_endless_loop_encountered( )
{
    exit( EXIT_FAILURE ) ;
    return ;
}

void handle_time_limit_exceeded( )
{
    exit( EXIT_FAILURE ) ;
    return ;
}

int parameterized_remove_leading_trailing_spaces( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;
    remove_leading_delimiters( ) ;
    remove_trailing_delimiters( ) ;
    return global_text_item_id ;
}

int parameterized_yes_or_no_empty( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;
    local_yes_or_no = check_yes_or_no_text_item_is_empty( ) ;
    return local_yes_or_no ;
}

int parameterized_yes_or_no_phrase_name( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_phrase_definition_not_empty( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = global_id_of_item_containing_definition_for_item[ local_text_item_id ] ;
    local_yes_or_no = check_yes_or_no_text_item_is_empty( ) ;
    return local_yes_or_no ;
}

int parameterized_yes_or_no_positive_integer( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_integer( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_positive_real_number( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_real_number( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_phrase_contains_real_numbers( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;

    return local_yes_or_no ;
}

int parameterized_normalize_calculated_value( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;

    return local_text_item_id ;
}

int parameterized_convert_numeric_text_into_numeric_value( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;

    return local_text_item_id ;
}

int parameterized_convert_numeric_value_into_numeric_text( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;

    return local_text_item_id ;
}

int parameterized_get_list_of_words( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;

    return local_text_item_id ;
}

int parameterized_yes_or_no_valid_url( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_valid_path( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_valid_path_prefix( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_file_name( int local_text_item_id )
{
    global_text_item_id = local_text_item_id ;
    initialize_parse_characters_of_filename( ) ;
    for ( global_text_pointer = global_text_pointer_begin_for_item[ global_text_item_id_from_origin ] ; global_text_pointer <= global_text_pointer_end_for_item[ global_text_item_id_from_origin ] ; global_text_pointer ++ )
    {
        global_character_category = global_storage_all_text[ global_text_pointer ] ;
        parse_one_character_of_filename( ) ;
        if ( ( global_yes_or_no_numeric_delimiter_encountered == global_yes ) || ( global_text_pointer == global_text_pointer_end_for_item[ global_text_item_id_from_origin ] ) )
        {
            if ( global_yes_or_no_filename_is_valid == global_yes )
            {
                log_out << "filename = ?" << std::endl ;
            } else
            {
                log_out << "invalid filename" << std::endl ;
            }
        }
        initialize_parse_characters_of_filename( ) ;
    }
    return global_yes_or_no_filename_is_valid ;
}

int parameterized_yes_or_no_folder_name( int local_text_item_id )
{
//  The flag global_yes_or_no_use_slash_not_backslash
//  identifies whether slashes or backslashes are
//  allowed in folder names.
    global_text_item_id = local_text_item_id ;
    initialize_parse_characters_of_folder_name( ) ;
    for ( global_text_pointer = global_text_pointer_begin_for_item[ global_text_item_id ] ; global_text_pointer <= global_text_pointer_end_for_item[ global_text_item_id ] ; global_text_pointer ++ )
    {
        global_single_character_as_integer = global_storage_all_text[ global_text_pointer ] ;
        parse_one_character_of_folder_name( ) ;
        if ( ( global_yes_or_no_numeric_delimiter_encountered == global_yes ) || ( global_text_pointer == global_text_pointer_end_for_item[ global_text_item_id ] ) )
        {
            if ( global_yes_or_no_folder_name_is_valid == global_yes )
            {
                log_out << "folder name = ?" << std::endl ;
            } else
            {
                log_out << "invalid folder name" << std::endl ;
            }
            initialize_parse_characters_of_folder_name( ) ;
        }
    }
    return global_yes_or_no_folder_name_is_valid ;
}

int parameterized_yes_or_no_input_file_exists( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;

    return local_yes_or_no ;
}

int parameterized_open_file_for_reading( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;

    return local_yes_or_no ;
}

int parameterized_open_file_for_appending( int local_text_item_id )
{
    int local_yes_or_no ;
    global_text_item_id = local_text_item_id ;

    return local_yes_or_no ;
}

void point_to_words( )
{

    return ;
}

void point_to_words_in_operand_one( )
{
    global_text_item_id = global_text_item_for_operand_one ;
    point_to_words( ) ;
    return ;
}

void point_to_words_in_operand_two( )
{
    global_text_item_id = global_text_item_for_operand_two ;
    point_to_words( ) ;
    return ;
}

void point_to_words_in_operand_three( )
{
    global_text_item_id = global_text_item_for_operand_three ;
    point_to_words( ) ;
    return ;
}

void remove_extra_spaces( )
{
    remove_leading_delimiters( ) ;
    remove_trailing_delimiters( ) ;

    return ;
}

void get_count_of_words( )
{

    return ;
}

void get_word_at_position( )
{

    return ;
}

void open_trace_output_file_if_not_open( )
{

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function do_everything

void do_everything( )
{


// -----------------------------------------------
//  Initialization.

    do_main_initialization( ) ;


// -----------------------------------------------
//  Test basic text handling functionality.

    log_out << std::endl ;
    log_out << "doing testing" << std::endl ;

    global_infile_connection = fopen( "input_dashrep_example_menagerie_copy.txt" , "r" ) ;
    global_outfile_connection = fopen( "temp_output_from_c_language_runtime_test.txt" , "w" ) ;

//    global_single_integer = 170512 ;
//    convert_integer_to_text( ) ;

//    log_out << "next test" << std::endl ;

//    global_text_item_id_from_origin = global_text_item_id_for_number_as_text ;
//    write_text_item_to_file( ) ;

//    log_out << "next test" << std::endl ;

    global_text_item_id_to_edit = global_text_item_id_for_sample_numbers ;
    remove_leading_and_trailing_delimiters( ) ;
    global_text_item_id = global_text_item_id_for_sample_numbers ;
    write_text_item_to_file( ) ;

//    global_text_item_id_from_origin = global_text_item_id_for_sample_numbers ;
//    global_text_item_id_to_edit = global_text_item_id_for_sample_numbers ;
//    append_text( ) ;

    log_out << "done testing" << std::endl ;
    std::cout << "program done" << std::endl ;


// -----------------------------------------------
//  End of "do_everything" code.

}


// -----------------------------------------------
// -----------------------------------------------
//  Execution starts here.

int main( int argc, char *argv[] )
{

    int argv_pointer ;


// -----------------------------------------------
//  Get environment variable values that include
//  CGI info.

    for ( int argv_pointer = 0 ; argv_pointer < argc ; argv_pointer ++ )
    {
        printf( "argv[ %d ] = %s\n", argv_pointer, argv[ argv_pointer ] ) ;
    }


// -----------------------------------------------
//  Do everything using a single function.

    do_everything( ) ;


// -----------------------------------------------
//  End of "main" code.

}


// -----------------------------------------------
// -----------------------------------------------
//
//  End of all code.
//
// -----------------------------------------------


// -----------------------------------------------
//
//  AUTHOR
//
//  Richard Fobes, www.Dashrep.org
//
//
// -----------------------------------------------
//
//  End of dashrep_c_language_runtime_in_development.cpp
