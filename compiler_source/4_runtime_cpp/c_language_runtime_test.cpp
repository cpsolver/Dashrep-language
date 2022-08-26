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
//  In particular, local (function-specific)
//  variables are avoided to yield faster
//  execution.  (Pushing and popping local
//  variables on and off the function stack wastes
//  time.)


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
//  Declare data type categories.
//  These values are in the array
//  "global_category_for_item".

//  todo: refer to "data types" instead of container categories

//
//  An item can contain any of the following
//  data types.
//
//  * "list_of_item_ids"
//    Pointers to other items.  These can be
//    recursive, which means a pointer can point
//    to yet another list of item ids.
//
//  * "text_characters"
//    A sequence of text characters.  Each
//    character is stored as an integer, which is
//    usually a Unicode character, whic means that
//    Chinese characters are supported.
//
//  * "pointers_to_decimal_numbers"
//    A list of pointers to decimal numbers.  The
//    decimal numbers are stored separately in the
//    array "global_all_decimal_numbers".  Each
//    pair of pointers is assumed to be separated
//    by one space, without explicitly storing
//    those spaces.  This data type increases
//    speed by reducing the need to convert
//    between text type and "float" type every
//    time a decimal-number calculation is done.
//
//  * "list_of_integers"
//    A list of integers.  The decimal numbers
//    are stored separately in the same array --
//    "global_all_pointers_integers" -- as
//    pointers, but in different items (so that
//    pointers and integers are not intemixed).
//    Adjacent pairs of integers are assumed to be
//    separated by one space, without explicitly
//    storing those spaces.  This data type
//    increases speed by reducing the need to
//    convert between text type and integers every
//    time a numeric calculation is done.
//
//  * "phrase_word_pointers"
//    A list of item IDs that only point to
//    "phrase_word" text items.  The result is
//    a valid phrase name -- which is
//    not necessarily a defined phrase name.  Each
//    adjacent pair of words is assumed to be
//    separated by one hyphen, without explicitly
//    storing those hyphens.  Each of the linked
//    words must be the same text item as used in
//    any other hyphenated phrase name that
//    includes that same word.  This convention
//    allows searching for a phrase name just by
//    looking at the text item IDs of the words in
//    the phrase name.  Note that this convention
//    does not allow a leading or trailing hyphen,
//    and does not allow two or more adjacent
//    hyphens.
//
//  * "underscored"
//    A pointer to phrase word pointers that
//    change the delimiter from a hyphen to an
//    underscore.  This extra layer allows a
//    phrase name to also represent an underscored
//    version for places where angle brackets
//    enclose the underscored version.  For
//    example, "<character_hyphen>" can be
//    represented as a linked list that points to
//    the text items "<" and ">" with an
//    underscored item that points to the list of
//    phrase names "character" and "hyphen".
//
//  Any kind of list can contain just one item.

const int global_container_category_list_of_item_ids = 1 ;
const int global_container_category_text_characters = 2 ;
const int global_container_category_pointers_to_decimal_numbers = 3 ;
const int global_container_category_list_of_integers = 4 ;
const int global_container_category_phrase_word_pointers = 5 ;
// todo: implement:
const int global_container_category_underscored = 6 ;


// -----------------------------------------------
//  Access flags.  These values are in the array
//  "global_yes_or_no_can_edit_item".

const int global_access_flag_no_changes = 1 ;
const int global_access_loop_access = 2 ;
const int global_access_flag_can_change = 3 ;


// -----------------------------------------------
//  The characters are stored as short INTEGERS,
//  not as bytes!  If support for
//  Chinese characters is needed, the data type
//  can be changed.

unsigned int global_all_characters[ 100000 ] ;


// -----------------------------------------------
//  Specify the characters that are put into the
//  character storage area at the beginning of
//  program execution.  These code lines are
//  generated by the Dashrep compiler.

unsigned int global_initialize_character_at[ ] = {
	0,  // unused
	32,73,63,  //  indicate text
	16,5,37,60,  //  indicate text
} ;


// -----------------------------------------------
//  Declare the other lists for which the compiler
//  supplies initial values.  Also declare the
//  constants that should be used to ensure there
//  are no attempts to write (or read) beyond the
//  list lengths.
//
//  The allocated length must be longer than the
//  maximum length because position zero is not
//  used.  All these lists use contents starting
//  at array position 1.

const int global_length_of_lists_for_items = 20000 ;
int global_all_pointers_integers[ 20005 ] ;
int global_category_for_item[ 20005 ] ;
int global_pointer_begin_for_item[ 20005 ] ;
int global_pointer_end_for_item[ 20005 ] ;
int global_pointer_allocation_end_for_item[ 20005 ] ;
int global_id_for_defined_phrase_name_number[ 20005 ] ;
int global_id_of_item_containing_definition_for_item[ 20005 ] ;
int global_yes_or_no_can_edit_item[ 20005 ] ;

const int global_maximum_words_in_phrase_name = 30 ;
int global_id_for_list_of_phrase_names_of_length[ 32 ] ;
int global_id_for_list_of_phrase_words_of_length[ 32 ] ;

const int global_length_of_list_of_character_numbers = 256 ;
int global_character_category_number_for_character_number[ 260 ] ;

int global_id_from_linked_list_number[ 2005 ] ;


// -----------------------------------------------
//  Declare lists for which the compiler does not
//  supply initial values.
//
//  Reminder:  The ascii code for a space is 32,
//  and the last printable ascii character is 125.

const int global_minimum_usage_character_to_consider = 32 ;
const int global_maximum_usage_character_to_consider = 125 ;
int global_usage_count_for_character[ 155 ] ;
int global_searched_usage_count_for_character[ 155 ] ;

//  global_length_of_list_of_character_numbers indicates maximum
int global_recent_character_position_for_character_number[ 260 ] ;

//  global_maximum_words_in_phrase_name is maximum size
int global_character_pointer_begin_for_phrase_word_in_position[ 32 ] ;
int global_character_pointer_end_for_phrase_word_in_position[ 32 ] ;
int global_position_begin_for_phrase_word_number[ 32 ] ;

//  avoid conflict with variable name "global_id_for_phrase_word_number"
int global_id_for_phrase_word_at_position_number[ 32 ] ;


// -----------------------------------------------
//  Declare "char" variables, and a C++ "string"
//  variable.  These are used for input from, and
//  output to, files.  Also they may be used with
//  the C-language "sprintf" function.

char global_c_format_string[ 50 ] ;
char global_c_format_single_character ;
char global_this_word[ 205 ] ;
std::string global_cplusplus_string ;


// -----------------------------------------------
//  Declare the list and variables that hold
//  decimal numbers.

float global_all_decimal_numbers[ 2005 ] ;
float global_single_decimal_number ;
const float global_pi = 245850922 / 78256779 ;


// -----------------------------------------------
//  Declare constants.

const int gloal_maximum_number_of_text_items_unicode_no_delimiters = 2000 ;
const int global_allocated_length_for_file_input_or_output = 2000 ;
const int global_allocated_length_for_this_word = 200 ;
const int global_ascii_code_for_ampersand = 38 ;
const int global_ascii_code_for_apostrophe = 39 ;
const int global_ascii_code_for_asterisk = 42 ;
const int global_ascii_code_for_at_sign = 64 ;
const int global_ascii_code_for_backslash = 92 ;
const int global_ascii_code_for_caret = 94 ;
const int global_ascii_code_for_carriage_return = 13 ;
const int global_ascii_code_for_close_angle_bracket = 62 ;
const int global_ascii_code_for_comma = 44 ;
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
const int global_ascii_code_for_exclamation_point = 33 ;
const int global_ascii_code_for_formfeed = 12 ;
const int global_ascii_code_for_grave_accent = 96 ;
const int global_ascii_code_for_hyphen = 45 ;
const int global_ascii_code_for_left_curly_bracket = 123 ;
const int global_ascii_code_for_left_parenthesis = 40 ;
const int global_ascii_code_for_left_square_bracket = 91 ;
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
const int global_ascii_code_for_newline = 10 ;
const int global_ascii_code_for_open_angle_bracket = 60 ;
const int global_ascii_code_for_percent = 37 ;
const int global_ascii_code_for_period = 46 ;
const int global_ascii_code_for_plus = 43 ;
const int global_ascii_code_for_pound_sign = 35 ;
const int global_ascii_code_for_question_mark = 63 ;
const int global_ascii_code_for_quotation_mark = 34 ;
const int global_ascii_code_for_right_curly_bracket = 125 ;
const int global_ascii_code_for_right_parenthesis = 41 ;
const int global_ascii_code_for_right_square_bracket = 93 ;
const int global_ascii_code_for_slash = 47 ;
const int global_ascii_code_for_space = 32 ;
const int global_ascii_code_for_tab = 9 ;
const int global_ascii_code_for_tilde = 126 ;
const int global_ascii_code_for_underscore = 95 ;
const int global_ascii_code_for_vertical_bar = 124 ;
const int global_character_category_apostrophe = 39 ;  // also single quotation mark
const int global_character_category_backslash = 92 ;
const int global_character_category_close_angle_bracket = 62 ;
const int global_character_category_digit = 57 ;  // 0 through 9
const int global_character_category_empty = 0 ;
const int global_character_category_hyphen = 45 ;  // also used as minus sign
const int global_character_category_newline = 10 ;
const int global_character_category_open_angle_bracket = 60 ;
const int global_character_category_other = 1 ;
const int global_character_category_period = 46 ;  // also used as decimal point
const int global_character_category_plus_sign = 43 ;
const int global_character_category_quotation_mark = 34 ;  // double quotation mark
const int global_character_category_slash = 47 ;
const int global_character_category_space = 32 ;
const int global_character_category_symbol = 3 ;
const int global_character_category_tab = 9 ;
const int global_character_category_underscore = 95 ;
const int global_default_length_for_text_item = 25 ;
const int global_direction_next = 1 ;
const int global_direction_previous = 2 ;
const int global_insertion_character_hyphen = 3 ;
const int global_insertion_character_none = 1 ;
const int global_insertion_character_space = 2 ;
const int global_offset_for_current_target_character_position = 5 ;
const int global_offset_for_current_target_text_item = 4 ;
const int global_offset_for_target_stack_item_bottom = 0 ;
const int global_offset_for_target_stack_item_next = 3 ;
const int global_offset_for_target_stack_item_prior = 2 ;
const int global_offset_for_target_stack_item_top = 1 ;
const int global_space_directive_none = 1 ;
const int global_space_directive_one = 2 ;
const int global_space_directive_one_requested = 3 ;


// -----------------------------------------------
//  Declare variables in alphabetical order.

int global_allocation_begin ;
int global_character_begin_pointer_one ;
int global_character_begin_pointer_two ;
int global_character_category ;
int global_character_count ;
int global_character_count_for_expand_text ;
int global_character_distance_from_optimum_character_for_pause ;
int global_character_end_pointer_one ;
int global_character_end_pointer_two ;
int global_character_insertion_count ;
int global_character_length ;
int global_character_length_minus_one ;
int global_character_length_of_phrase_word ;
int global_character_length_of_phrase_word_minus_one ;
int global_character_offset ;
int global_character_pointer ;
int global_character_pointer_begin_for_text_one ;
int global_character_pointer_begin_for_text_two ;
int global_character_pointer_for_phrase_word_current ;
int global_character_pointer_for_text_item ;
int global_character_pointer_if_category_pointer_pair ;
int global_character_pointer_one ;
int global_character_pointer_two ;
int global_character_pointer_within_text_item_for_first_hyphen ;
int global_character_position_in_phrase_name ;
int global_character_to_insert_between_subitems ;
int global_check_for_match_item_id ;
int global_check_from_begin ;
int global_check_from_begin_or_check_from_end ;
int global_check_from_end ;
int global_container_category ;
int global_count_of_words_handled ;
int global_count_of_words_in_phrase_name ;
int global_current_target_character_position ;
int global_current_target_text_item ;
int global_current_target_text_item_begin ;
int global_current_target_text_item_end ;
int global_decimal_number_divisor ;
int global_defined_phrase_number ;
int global_direction_next_or_previous ;
int global_direction_opposite ;
int global_distance_between_item_begin_and_end ;
int global_distance_from_first_hyphen_to_trailing_delimiter ;
int global_do_nothing ;
int global_found_matching_phrase_name ;
int global_from_text_contains_category ;
int global_highest_score_for_optimum_character_for_find_pause ;
int global_id_current ;
int global_id_for_copy_of_target_pointer_stack ;
int global_id_for_character_position ;
int global_id_for_original_of_target_pointer_stack ;
int global_id_for_phrase_name_append_multiple_from_phrases_named_in_pattern ;
int global_id_for_phrase_name_append_new_line ;
int global_id_for_phrase_name_append_repeatedly_using_count ;
int global_id_for_phrase_name_append_text ;
int global_id_for_phrase_name_append_text_no_space ;
int global_id_for_phrase_name_character_hyphen ;
int global_id_for_phrase_name_character_newline ;
int global_id_for_phrase_name_character_space ;
int global_id_for_phrase_name_character_tab ;
int global_id_for_phrase_name_character_underscore ;
int global_id_for_phrase_name_clear_listed_phrases ;
int global_id_for_phrase_name_clear_phrase ;
int global_id_for_phrase_name_convert_unicode_to_html_entities ;
int global_id_for_phrase_name_copy_and_move_attributes_into_xml_tags ;
int global_id_for_phrase_name_copy_and_remove_attributes_from_xml_tags ;
int global_id_for_phrase_name_copy_and_replace ;
int global_id_for_phrase_name_copy_and_replace_using_paired_listed_words ;
int global_id_for_phrase_name_copy_append_file_to_file ;
int global_id_for_phrase_name_copy_characters_from_position_to_position ;
int global_id_for_phrase_name_copy_from_columns_in_file_to_column_lists ;
int global_id_for_phrase_name_copy_from_columns_in_file_to_named_phrases ;
int global_id_for_phrase_name_copy_from_file_to_phrase ;
int global_id_for_phrase_name_copy_from_phrase_append_to_file ;
int global_id_for_phrase_name_copy_initial_caps ;
int global_id_for_phrase_name_copy_listed_words_to_phrases_named_in_pattern ;
int global_id_for_phrase_name_copy_lowercase_only ;
int global_id_for_phrase_name_copy_text ;
int global_id_for_phrase_name_copy_uppercase_only ;
int global_id_for_phrase_name_copy_without_extra_spaces ;
int global_id_for_phrase_name_copy_word_at_position ;
int global_id_for_phrase_name_copy_words_found_in_both_lists ;
int global_id_for_phrase_name_copy_words_found_in_either_list ;
int global_id_for_phrase_name_copy_words_found_only_in_first_list ;
int global_id_for_phrase_name_copy_words_from_position_to_position ;
int global_id_for_phrase_name_copy_words_offset_skip ;
int global_id_for_phrase_name_copy_words_order_reversed ;
int global_id_for_phrase_name_copy_words_rearrange_using_order_sort_alphabetic ;
int global_id_for_phrase_name_copy_words_rearrange_using_order_sort_numeric ;
int global_id_for_phrase_name_copy_words_sort_alphabetic ;
int global_id_for_phrase_name_copy_words_sort_numeric ;
int global_id_for_phrase_name_copy_words_that_begin_with_listed_words ;
int global_id_for_phrase_name_copy_words_that_begin_with_text ;
int global_id_for_phrase_name_copy_words_that_contain_listed_words ;
int global_id_for_phrase_name_copy_words_unique_only ;
int global_id_for_phrase_name_copy_zero_pad_left_to_length ;
int global_id_for_phrase_name_create_empty_sub_folder ;
int global_id_for_phrase_name_dashrep_comments_ignored ;
int global_id_for_phrase_name_dashrep_endless_loop_counter_limit ;
int global_id_for_phrase_name_dashrep_file_name_if_read_file_missing ;
int global_id_for_phrase_name_dashrep_gather_tag_begin ;
int global_id_for_phrase_name_dashrep_gather_tag_delete ;
int global_id_for_phrase_name_dashrep_gather_tag_end ;
int global_id_for_phrase_name_dashrep_gather_tag_matching_id ;
int global_id_for_phrase_name_dashrep_gather_tag_unique ;
int global_id_for_phrase_name_dashrep_language_yes ;
int global_id_for_phrase_name_dashrep_path_prefix_for_file_reading ;
int global_id_for_phrase_name_dashrep_path_prefix_for_file_writing ;
int global_id_for_phrase_name_dashrep_time_limit ;
int global_id_for_phrase_name_dashrep_version ;
int global_id_for_phrase_name_decode_from_cgi_parameter ;
int global_id_for_phrase_name_delayed_newline ;
int global_id_for_phrase_name_delayed_nospace ;
int global_id_for_phrase_name_delete_file ;
int global_id_for_phrase_name_delete_listed_phrases ;
int global_id_for_phrase_name_empty_line ;
int global_id_for_phrase_name_empty_text ;
int global_id_for_phrase_name_encode_as_cgi_parameter ;
int global_id_for_phrase_name_end_of_line_indicator ;
int global_id_for_phrase_name_exit_from_dashrep ;
int global_id_for_phrase_name_expand_text ;
int global_id_for_phrase_name_find_line_in_file_that_begins_with_text ;
int global_id_for_phrase_name_find_lines_in_file_that_begin_with_any_listed_word ;
int global_id_for_phrase_name_find_lines_in_file_that_begin_with_any_two_words_listed ;
int global_id_for_phrase_name_four_hyphens ;
int global_id_for_phrase_name_gather_from_tagged_file_one_entry ;
int global_id_for_phrase_name_gather_tagged_info_from_file ;
int global_id_for_phrase_name_generate_counts_from_integer_to_integer ;
int global_id_for_phrase_name_generate_every_ordered_pairwise_combination_of_words ;
int global_id_for_phrase_name_generate_every_pairwise_combination_of_words ;
int global_id_for_phrase_name_generate_list_of_all_dashrep_phrases ;
int global_id_for_phrase_name_generate_list_of_files_in_current_read_directory ;
int global_id_for_phrase_name_generate_list_of_folders_in_current_read_directory ;
int global_id_for_phrase_name_generate_phrase_usage_counts ;
int global_id_for_phrase_name_generate_positions_of_delimiter ;
int global_id_for_phrase_name_generate_positions_of_first_matching_delimiter_after_listed_positions ;
int global_id_for_phrase_name_generate_positions_of_listed_words ;
int global_id_for_phrase_name_get_cgi_information ;
int global_id_for_phrase_name_get_characters_from_position_to_position ;
int global_id_for_phrase_name_get_count_of_characters ;
int global_id_for_phrase_name_get_count_of_words ;
int global_id_for_phrase_name_get_current_time_in_epoch_seconds ;
int global_id_for_phrase_name_get_definitions_from_phrase ;
int global_id_for_phrase_name_get_phrase_name_from_phrase ;
int global_id_for_phrase_name_get_position_of_matching_text ;
int global_id_for_phrase_name_get_position_of_word ;
int global_id_for_phrase_name_get_url_resource ;
int global_id_for_phrase_name_get_word_at_position ;
int global_id_for_phrase_name_hyphen_here ;
int global_id_for_phrase_name_if_else ;
int global_id_for_phrase_name_if_end ;
int global_id_for_phrase_name_if_no_begin ;
int global_id_for_phrase_name_if_yes_begin ;
int global_id_for_phrase_name_line_break ;
int global_id_for_phrase_name_linewise_input_line_count ;
int global_id_for_phrase_name_linewise_input_line_from_file ;
int global_id_for_phrase_name_linewise_read_from_file_and_use_handler ;
int global_id_for_phrase_name_linewise_read_from_standard_input ;
int global_id_for_phrase_name_list_of_pointers_to_unique_words ;
int global_id_for_phrase_name_list_of_unique_word_counts ;
int global_id_for_phrase_name_modification_time_of_file ;
int global_id_for_phrase_name_new_line ;
int global_id_for_phrase_name_no_if_any_no ;
int global_id_for_phrase_name_no_if_not_yes ;
int global_id_for_phrase_name_no_space ;
int global_id_for_phrase_name_non_breaking_space ;
int global_id_for_phrase_name_numeric_absolute ;
int global_id_for_phrase_name_numeric_add ;
int global_id_for_phrase_name_numeric_cosine ;
int global_id_for_phrase_name_numeric_decrement ;
int global_id_for_phrase_name_numeric_divide_by ;
int global_id_for_phrase_name_numeric_equal_greater_less_compare ;
int global_id_for_phrase_name_numeric_increment ;
int global_id_for_phrase_name_numeric_integer ;
int global_id_for_phrase_name_numeric_logarithm_base_10 ;
int global_id_for_phrase_name_numeric_logarithm_base_e ;
int global_id_for_phrase_name_numeric_map_tile_zoom ;
int global_id_for_phrase_name_numeric_maximum ;
int global_id_for_phrase_name_numeric_minimum ;
int global_id_for_phrase_name_numeric_minus ;
int global_id_for_phrase_name_numeric_multiply ;
int global_id_for_phrase_name_numeric_odd_or_even ;
int global_id_for_phrase_name_numeric_pi ;
int global_id_for_phrase_name_numeric_sine ;
int global_id_for_phrase_name_numeric_square_root ;
int global_id_for_phrase_name_numeric_two_dimensional_sort_into_columns_and_rows ;
int global_id_for_phrase_name_numeric_vector_absolutes ;
int global_id_for_phrase_name_numeric_vector_add_number ;
int global_id_for_phrase_name_numeric_vector_integers ;
int global_id_for_phrase_name_numeric_vector_multiply_by_number ;
int global_id_for_phrase_name_numeric_vectors_add ;
int global_id_for_phrase_name_numeric_vectors_divide_by ;
int global_id_for_phrase_name_numeric_vectors_from_delta_values_calculate_distances ;
int global_id_for_phrase_name_numeric_vectors_multiply ;
int global_id_for_phrase_name_numeric_y_map_tile_number_based_on_latitude ;
int global_id_for_phrase_name_one_space ;
int global_id_for_phrase_name_operating_system_slash_or_backslash ;
int global_id_for_phrase_name_output_trace_file_name ;
int global_id_for_phrase_name_placeholder_for_empty_line ;
int global_id_for_phrase_name_placeholder_for_hyphen_here ;
int global_id_for_phrase_name_placeholder_for_new_line ;
int global_id_for_phrase_name_prepend_text ;
int global_id_for_phrase_name_prepend_text_no_space ;
int global_id_for_phrase_name_put_into_phrase ;
int global_id_for_phrase_name_put_listed_phrase_definitions_into_phrase ;
int global_id_for_phrase_name_rename_file ;
int global_id_for_phrase_name_set_file_permission_private ;
int global_id_for_phrase_name_set_file_permission_private_but_executable ;
int global_id_for_phrase_name_set_file_permission_public_read ;
int global_id_for_phrase_name_size_of_file ;
int global_id_for_phrase_name_split_epoch_seconds_into_named_components ;
int global_id_for_phrase_name_split_epoch_seconds_into_named_components_for_zero_meridian ;
int global_id_for_phrase_name_standard_output ;
int global_id_for_phrase_name_text_end_of_line_here_space_delimited ;
int global_id_for_phrase_name_time_day_of_month ;
int global_id_for_phrase_name_time_day_of_week ;
int global_id_for_phrase_name_time_day_of_year ;
int global_id_for_phrase_name_time_hour ;
int global_id_for_phrase_name_time_minute ;
int global_id_for_phrase_name_time_month_number ;
int global_id_for_phrase_name_time_second ;
int global_id_for_phrase_name_time_year ;
int global_id_for_phrase_name_trace_from_get_url_resource ;
int global_id_for_phrase_name_trace_show ;
int global_id_for_phrase_name_trace_show_where ;
int global_id_for_phrase_name_use_handler_with_each_word_in_phrase ;
int global_id_for_phrase_name_word_to_use_in_handler ;
int global_id_for_phrase_name_write_gathered_listed_items_to_end_of_file ;
int global_id_for_phrase_name_yes_if_all_yes ;
int global_id_for_phrase_name_yes_if_any_yes ;
int global_id_for_phrase_name_yes_if_not_no ;
int global_id_for_phrase_name_yes_or_no_empty_phrase ;
int global_id_for_phrase_name_yes_or_no_file_exists ;
int global_id_for_phrase_name_yes_or_no_folder_exists ;
int global_id_for_phrase_name_yes_or_no_opposite ;
int global_id_for_phrase_name_yes_or_no_permission_administrator ;
int global_id_for_phrase_name_yes_or_no_permission_to_append_to_files ;
int global_id_for_phrase_name_yes_or_no_permission_to_delete_or_overwrite_files ;
int global_id_for_phrase_name_yes_or_no_same_two_phrase_definitions ;
int global_id_for_phrase_name_yes_or_no_same_two_words ;
int global_id_for_phrase_name_yes_or_no_skip_empty_lines_when_copy_from_file ;
int global_id_for_phrase_name_yes_or_no_trim_spaces_when_copy_from_file ;
int global_id_for_phrase_name_yes_or_no_use_two_spaces_as_column_delimiter ;
int global_id_for_phrase_name_zero_one_multiple ;
int global_id_for_phrase_name_zero_or_nonzero ;
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
int global_id_for_phrase_word_placeholder ;
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
int global_id_for_pointers_to_decimal_numbers ;
int global_id_pointer_stack_for_getting_next_character ;
int global_item_id ;
int global_id_containing_first_hyphen ;
int global_id_for_copy ;
int global_id_for_empty_text ;
int global_id_for_file_input ;
int global_id_for_file_output ;
int global_id_for_float_as_text ;
int global_id_for_four_hyphens ;
int global_id_for_integers_as_text ;
int global_id_for_list_of_integers ;
int global_id_for_next_word ;
int global_id_for_next_word_begin ;
int global_id_for_next_word_end ;
int global_id_for_non_breaking_space ;
int global_id_for_number_as_text ;
int global_id_for_phrase_name ;
int global_id_for_phrase_word ;
int global_id_for_pointer_begin_end ;
int global_id_for_sample_filename ;
int global_id_for_sample_folder_name ;
int global_id_for_sample_numbers ;
int global_id_for_sample_text_to_expand ;
int global_id_for_single_apostrophe ;
int global_id_for_single_backslash ;
int global_id_for_single_carriage_return ;
int global_id_for_single_close_angle_bracket ;
int global_id_for_single_formfeed ;
int global_id_for_single_hyphen ;
int global_id_for_single_newline ;
int global_id_for_single_open_angle_bracket ;
int global_id_for_single_period ;
int global_id_for_single_plus ;
int global_id_for_single_quotation_mark ;
int global_id_for_single_slash ;
int global_id_for_single_space ;
int global_id_for_single_tab ;
int global_id_for_single_underscore ;
int global_id_for_valid_filename ;
int global_id_for_valid_folder_name ;
int global_id_for_word_breaking ;
int global_id_for_word_character ;
int global_id_for_word_empty ;
int global_id_for_word_four ;
int global_id_for_word_hyphen ;
int global_id_for_word_hyphens ;
int global_id_for_word_newline ;
int global_id_for_word_non ;
int global_id_for_word_space ;
int global_id_for_word_tab ;
int global_id_for_word_text ;
int global_id_for_word_underscore ;
int global_id_from_linked_list ;
int global_id_from_origin ;
int global_id_text_to_edit ;
int global_id_text_to_find ;
int global_id_text_to_search ;
int global_id_text_to_truncate ;
int global_item_id_to_consider ;
int global_length_of_text_item ;
int global_length_of_first_phrase_word_minus_one ;
int global_length_of_matching_text ;
int global_length_of_text_to_find ;
int global_length_requested_for_next_text_item_storage ;
int global_line_character_position ;
int global_linked_list_current_pointer ;
int global_linked_list_grouping_id ;
int global_looking_at_hyphenated_phrase_name_in_item_id ;
int global_message_trace__expand_phrases__endless_loop ;
int global_new_storage_item_id ;
int global_next_available_begin_pointer_for_next_available_item_id ;
int global_next_available_defined_phrase_number ;
int global_next_available_item_id ;
int global_next_character_number ;
int global_next_character_position_count ;
int global_next_character_position_in_storage_all_text ;
int global_number_of_digits_encountered ;
int global_number_of_hyphenated_phrase_names_in_text_items ;
int global_number_of_phrase_words_found ;
int global_number_of_valid_characters_encountered ;
int global_offset ;
int global_offset_within_list_of_pointers ;
int global_one_number_to_append ;
int global_optimum_character_for_find_pause ;
int global_phrase_word_number_to_check ;
int global_pointer_for_debugging ;
int global_pointer_next_word_begin ;
int global_pointer_next_word_end ;
int global_pointer_to_first_hyphen ;
int global_pointer_to_leading_delimiter ;
int global_pointer_to_text_item_unicode_no_delimiters ;
int global_pointer_to_within_target_stack_item_bottom ;
int global_pointer_to_within_target_stack_item_current ;
int global_pointer_to_within_target_stack_item_current_copy ;
int global_pointer_to_within_target_stack_item_current_original ;
int global_pointer_to_within_target_stack_item_top ;
int global_pointer_to_within_text_item ;
int global_character_position_current ;
int global_character_position_desired ;
int global_position_in_list_of_hyphenated_phrase_text_items ;
int global_position_of_close_angle_bracket ;
int global_position_of_close_angle_bracket_within_text_item ;
int global_position_of_found_character_for_find_pause ;
int global_position_of_open_angle_bracket ;
int global_position_of_open_angle_bracket_within_text_item ;
int global_position_of_optimum_character_for_pause ;
int global_position_of_underscore ;
int global_position_within_text_to_find ;
int global_possible_optimum_character_as_integer ;
int global_previous_character ;
int global_previous_linked_list_grouping_id ;
int global_recent_position_of_any_delimiter ;
int global_response_ignored ;
int global_saved_single_character_as_integer ;
int global_score_for_possible_optimum_character ;
int global_single_character ;
int global_single_character_as_integer ;
int global_single_integer ;
int global_space_available_in_item ;
int global_target_stack_item_bottom ;
int global_target_stack_item_current ;
int global_target_stack_item_current_copy ;
int global_target_stack_item_current_original ;
int global_target_stack_item_next ;
int global_target_stack_item_prior ;
int global_target_stack_item_top ;
int global_target_stack_item_top_original ;
int global_target_stack_pointer_for_copy_from ;
int global_target_stack_pointer_for_copy_to ;
int global_target_stack_pointer_for_get_next_previous_character ;
int global_target_stack_pointer_for_phrase_name_end ;
int global_target_stack_pointer_for_word_begin ;
int global_target_stack_pointer_for_word_end ;
int global_test_loop_counter ;
int global_text_contains_category ;
int global_text_item_for_operand_one ;
int global_text_item_for_operand_three ;
int global_text_item_for_operand_two ;
int global_text_item_intended_next_word_in_hyphenated_phrase ;
int global_text_item_looking_at_next_word_in_hyphenated_phrase ;
int global_text_item_one ;
int global_text_item_pointer ;
int global_text_item_two ;
int global_text_item_with_next_character ;
int global_text_item_with_previous_character ;
int global_text_pointer ;
int global_text_pointer_begin ;
int global_text_pointer_end ;
int global_to_text_contains_category ;
int global_unused_string_length ;
int global_word_count_hyphenated_phrase_name ;
int global_word_count_operand_one ;
int global_word_count_operand_two ;
int global_word_position ;
int global_yes_or_no ;
int global_yes_or_no_begin_not_end ;
int global_yes_or_no_character_is_delimiter ;
int global_yes_or_no_count_phrase_usage ;
int global_yes_or_no_decimal_number ;
int global_yes_or_no_delimiter_encountered ;
int global_yes_or_no_filename_delimiter_encountered ;
int global_yes_or_no_filename_is_valid ;
int global_yes_or_no_folder_name_delimiter_encountered ;
int global_yes_or_no_folder_name_is_valid ;
int global_yes_or_no_in_filename_before_period ;
int global_yes_or_no_in_folder_name_before_period ;
int global_yes_or_no_inserted_character ;
int global_yes_or_no_looking_for_word_attribute_or_specify ;
int global_yes_or_no_matching_text ;
int global_yes_or_no_negative_number ;
int global_yes_or_no_number_is_valid ;
int global_yes_or_no_numeric_delimiter_encountered ;
int global_yes_or_no_phrase_words_match ;
int global_yes_or_no_reached_begin_of_current_text_item ;
int global_yes_or_no_reached_end_of_current_text_item ;
int global_yes_or_no_requesting_space_appended ;
int global_yes_or_no_same_phrase_name ;
int global_yes_or_no_same_phrase_word ;
int global_yes_or_no_same_text ;
int global_yes_or_no_transition_from_character_to_delimiter ;
int global_yes_or_no_transition_from_delimiter_to_character ;
int global_yes_or_no_use_copy_when_appending ;
int global_yes_or_no_use_slash_not_backslash ;


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
//  End of top-level code.
//  Beginning of functions.


// -----------------------------------------------
// -----------------------------------------------
//  Function exit_not_yet_supported

void exit_not_yet_supported( )
{
    log_out << "BUG:  This container category, " << global_container_category << ", (or some other capability) is not yet supported." << std::endl ;
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
//  Function measure_space_available_in_item
//
//  Measure how much space is available in the
//  specified item.

void measure_space_available_in_item( )
{
    global_space_available_in_item = global_pointer_allocation_end_for_item[ global_item_id ] - global_pointer_end_for_item[ global_item_id ] ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_allocation_begin
//
//  Get the allocation begin value that indicates
//  the first available position for the specified
//  item.  This is needed when the "begin" pointer
//  has been changed.  The "contains" category
//  must be considered because the allocation end
//  of the previous item is relevant only if that
//  previous item is in the same list as the item
//  for which the allocation end is desired.  Each
//  container category is separate, so the prior
//  item must be in the same container category.

void get_allocation_begin( )
{
    global_container_category = global_category_for_item[ global_item_id ] ;
    global_item_id_to_consider = global_item_id - 1 ;
    while ( global_item_id_to_consider > 0 )
    {
    	if ( global_category_for_item[ global_item_id_to_consider ] == global_container_category )
    	{
    		global_allocation_begin = global_pointer_allocation_end_for_item[ global_item_id_to_consider ] + 1 ;
    		return ;
    	}
        global_item_id_to_consider -- ;
    }
    global_allocation_begin = global_pointer_begin_for_item[ global_item_id ] ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function check_yes_or_no_text_item_is_empty

int check_yes_or_no_text_item_is_empty( )
{
    if ( global_pointer_end_for_item[ global_item_id ] < global_pointer_begin_for_item[ global_item_id ] )
    {
        return global_yes ;
    } else
    {
        return global_no ;
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function assign_storage_for_new_item
//
//  Initialize the pointers that will keep track
//  of a new item, which is usually a text item,
//  yet also may be a linked list grouping item,
//  or a level in a target pointer stack.

void assign_storage_for_new_item( )
{
    global_pointer_begin_for_item[ global_next_available_item_id ] = global_next_available_begin_pointer_for_next_available_item_id ;
    global_next_available_begin_pointer_for_next_available_item_id += global_length_requested_for_next_text_item_storage ;
    global_pointer_allocation_end_for_item[ global_next_available_item_id ] = global_next_available_begin_pointer_for_next_available_item_id - 1 ;
    global_pointer_end_for_item[ global_next_available_item_id ] =     global_pointer_begin_for_item[ global_next_available_item_id ] - 1 ;
    global_id_of_item_containing_definition_for_item[ global_next_available_item_id ] = 0 ;
    global_yes_or_no_can_edit_item[ global_next_available_item_id ] = global_no ;
    global_new_storage_item_id = global_next_available_item_id ;
    global_next_available_item_id ++ ;
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
//  list_of_item_ids, allocate an extra
//  position for future extension.  Also allow for
//  a case where the text extends beyond what was
//  originally allocated.

void recover_memory_from_top_text_item( )
{
    if ( global_new_storage_item_id != ( global_next_available_item_id - 1 ) )
    {
        return ;
    }
    global_next_available_begin_pointer_for_next_available_item_id = global_pointer_end_for_item[ global_new_storage_item_id ] + 1 ;
    if ( global_category_for_item[ global_new_storage_item_id ] == global_container_category_list_of_item_ids )
    {
        global_next_available_begin_pointer_for_next_available_item_id ++ ;
    }
    global_pointer_allocation_end_for_item[ global_new_storage_item_id ] = global_next_available_begin_pointer_for_next_available_item_id - 1 ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function extend_length_of_top_text_item
//
//  Extend the length of the top-most text item.

void extend_length_of_top_text_item( )
{
    if ( global_new_storage_item_id != ( global_next_available_item_id - 1 ) )
    {
        return ;
    }
    global_pointer_allocation_end_for_item[ global_new_storage_item_id ] += global_default_length_for_text_item ;
    global_next_available_begin_pointer_for_next_available_item_id = global_pointer_allocation_end_for_item[ global_new_storage_item_id ] + 1 ;
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
//  "global_id_for_number_as_text".

void convert_integer_to_text( )
{


// -----------------------------------------------
//  Point to where the first character (as an
//  integer) will be stored.

    global_character_pointer_for_text_item = global_pointer_begin_for_item[ global_id_for_number_as_text ] ;


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
        global_all_pointers_integers[ global_character_pointer_for_text_item ] = global_single_character_as_integer ;
        global_character_pointer_for_text_item ++ ;
        log_out << "digit " << global_single_character_as_integer << std::endl ;
    }
    global_pointer_end_for_item[ global_id_for_number_as_text ] = global_character_pointer_for_text_item - 1 ;
    global_category_for_item[ global_id_for_number_as_text ] = global_container_category_text_characters ;


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
//  global_id_for_number_as_text.

void convert_decimal_to_text( )
{


// -----------------------------------------------
//  Point to where the first character (as an
//  integer) will be stored.

    global_text_item_pointer = global_pointer_begin_for_item[ global_id_for_number_as_text ] ;


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
        global_all_pointers_integers[ global_text_item_pointer ] = global_single_character_as_integer ;
        global_text_item_pointer ++ ;
//        log_out << "digit " << global_single_character_as_integer << std::endl ;
    }


// -----------------------------------------------
//  End of function convert_decimal_to_text.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function store_text_and_get_its_item_id
//
//  Gets the text word supplied as a function
//  argument in C string format, stores it in
//  global_all_pointers_integers, and returns the text
//  item ID number for this text.

int store_text_and_get_its_item_id( const char * local_this_word )
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

    assign_storage_for_new_item( ) ;


// -----------------------------------------------
//  Store the characters in the new text item.
//
//  Reminder:  The first character position is
//  zero because this code handles text that
//  is imported using the strcpy function.

    global_next_character_position_in_storage_all_text = global_pointer_begin_for_item[ global_new_storage_item_id ] ;
    for ( size_t character_pointer = 0 ; character_pointer < ( strlen( local_this_word ) ) ; character_pointer ++ )
    {
        global_single_character = (int) local_this_word[ character_pointer ] ;
        global_all_pointers_integers[ global_next_character_position_in_storage_all_text ] = global_single_character ;
        global_next_character_position_in_storage_all_text ++ ;
    }


// -----------------------------------------------
//  Update the pointer to the end of the
//  just-stored text.

    global_pointer_end_for_item[ global_new_storage_item_id ] = global_pointer_begin_for_item[ global_new_storage_item_id ] + global_character_count - 1 ;


// -----------------------------------------------
//  Specify the category for this text item.

    global_category_for_item[ global_new_storage_item_id ] = global_container_category_text_characters ;


// -----------------------------------------------
//  Return with the text item ID number

    return global_new_storage_item_id ;


// -----------------------------------------------
//  End of function store_text_and_get_its_item_id.

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
    assign_storage_for_new_item( ) ;
    global_category_for_item[ global_new_storage_item_id ] = global_container_category_phrase_word_pointers ;
    global_pointer_end_for_item[ global_new_storage_item_id ] ++ ;
    global_all_pointers_integers[ global_pointer_end_for_item[ global_new_storage_item_id ] ] = word_one ;
    global_pointer_end_for_item[ global_new_storage_item_id ] ++ ;
    global_all_pointers_integers[ global_pointer_end_for_item[ global_new_storage_item_id ] ] = word_two ;
    global_pointer_end_for_item[ global_new_storage_item_id ] ++ ;
    global_all_pointers_integers[ global_pointer_end_for_item[ global_new_storage_item_id ] ] = word_three ;
    global_pointer_end_for_item[ global_new_storage_item_id ] ++ ;
    global_all_pointers_integers[ global_pointer_end_for_item[ global_new_storage_item_id ] ] = word_four ;
    global_pointer_end_for_item[ global_new_storage_item_id ] ++ ;
    global_all_pointers_integers[ global_pointer_end_for_item[ global_new_storage_item_id ] ] = word_five ;
    global_pointer_end_for_item[ global_new_storage_item_id ] ++ ;
    global_all_pointers_integers[ global_pointer_end_for_item[ global_new_storage_item_id ] ] = word_six ;
    global_pointer_end_for_item[ global_new_storage_item_id ] ++ ;
    global_all_pointers_integers[ global_pointer_end_for_item[ global_new_storage_item_id ] ] = word_seven ;
    global_pointer_end_for_item[ global_new_storage_item_id ] ++ ;
    global_all_pointers_integers[ global_pointer_end_for_item[ global_new_storage_item_id ] ] = word_eight ;
    global_pointer_end_for_item[ global_new_storage_item_id ] ++ ;
    global_all_pointers_integers[ global_pointer_end_for_item[ global_new_storage_item_id ] ] = word_nine ;
    global_pointer_end_for_item[ global_new_storage_item_id ] ++ ;
    global_all_pointers_integers[ global_pointer_end_for_item[ global_new_storage_item_id ] ] = word_ten ;
    global_pointer_end_for_item[ global_new_storage_item_id ] ++ ;
    global_all_pointers_integers[ global_pointer_end_for_item[ global_new_storage_item_id ] ] = word_eleven ;
    global_pointer_end_for_item[ global_new_storage_item_id ] ++ ;
    global_all_pointers_integers[ global_pointer_end_for_item[ global_new_storage_item_id ] ] = word_twelve ;
    for ( global_character_pointer = global_pointer_end_for_item[ global_new_storage_item_id ] ; global_character_pointer >= global_pointer_begin_for_item[ global_new_storage_item_id ] ; global_character_pointer -- )
    {
        if ( global_all_pointers_integers[ global_pointer_end_for_item[ global_new_storage_item_id ] ] > 0 )
        {
            break ;
        }
        global_pointer_end_for_item[ global_new_storage_item_id ] -- ;
    }
    return global_new_storage_item_id ;
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

    global_next_available_item_id = 1 ;


// -----------------------------------------------
//  Put zeros into the lists that are indexed by
//  text item ID number because those ID numbers
//  start at one, not zero.

    global_all_pointers_integers[ 0 ] = 0 ;
    global_category_for_item[ 0 ] = 0 ;
    global_pointer_allocation_end_for_item[ 0 ] = 0 ;
    global_pointer_begin_for_item[ 0 ] = 0 ;
    global_pointer_end_for_item[ 0 ] = 0 ;


// -----------------------------------------------
//  Initialize the pointer that keeps track of the
//  beginning of the next available character
//  positions in the list: global_all_pointers_integers

    global_next_available_begin_pointer_for_next_available_item_id = 1 ;


// -----------------------------------------------
//  Initialize the pointer that keeps track of the
//  end of the list:
//  global_id_of_item_containing_definition_for_item

    global_next_available_defined_phrase_number = 1 ;


// -----------------------------------------------
//  Create text items that each hold one symbol,
//  and define text item ID numbers for these
//  symbols.

    global_id_for_single_space = store_text_and_get_its_item_id( " " ) ;
    global_id_for_single_hyphen = store_text_and_get_its_item_id( "-" ) ;
    global_id_for_single_underscore  = store_text_and_get_its_item_id( "_" ) ;
    global_id_for_single_tab  = store_text_and_get_its_item_id( "\t" ) ;
    global_id_for_single_newline  = store_text_and_get_its_item_id( "\n" ) ;
    global_id_for_single_carriage_return  = store_text_and_get_its_item_id( "\r" ) ;
    global_id_for_single_formfeed  = store_text_and_get_its_item_id( "\f" ) ;
    global_id_for_single_slash  = store_text_and_get_its_item_id( "/" ) ;
    global_id_for_single_backslash  = store_text_and_get_its_item_id( "\\" ) ;
    global_id_for_single_quotation_mark  = store_text_and_get_its_item_id( "?" ) ;
    global_id_for_single_apostrophe  = store_text_and_get_its_item_id( "'" ) ;
    global_id_for_single_plus  = store_text_and_get_its_item_id( "+" ) ;
    global_id_for_single_period  = store_text_and_get_its_item_id( "." ) ;
    global_id_for_single_open_angle_bracket  = store_text_and_get_its_item_id( "<" ) ;
    global_id_for_single_close_angle_bracket  = store_text_and_get_its_item_id( ">" ) ;


// -----------------------------------------------
//  Create the text items for words within the
//  phrase names that have definitions -- rather
//  than only having meaning between the words
//  ambee and amenn.
//
//  Reminder: The strcpy function starts position
//  counting at one, not zero.

//  todo: generate this code from a template

    global_id_for_word_character = store_text_and_get_its_item_id( "character" ) ;
    global_id_for_sample_numbers = store_text_and_get_its_item_id( " 123 , 72.3 , -4399 , -88.6666 " ) ;
    global_id_for_sample_filename = store_text_and_get_its_item_id( "  , xyz !@#$%^&*(){}:;?<> yes_name.txt , " ) ;
    global_id_for_sample_folder_name = store_text_and_get_its_item_id( "  , xyz !@#$%/^&\\*(){}:;?<> /yes_name/txt/ , " ) ;
    global_id_for_sample_text_to_expand = store_text_and_get_its_item_id( "   _ hyphenated-phrase   <specify 123>  <attribute 123> " ) ;
    global_id_for_word_hyphen = store_text_and_get_its_item_id( "hyphen" ) ;
    global_id_for_word_space = store_text_and_get_its_item_id( "space" ) ;
    global_id_for_word_newline = store_text_and_get_its_item_id( "newline" ) ;
    global_id_for_word_underscore = store_text_and_get_its_item_id( "underscore" ) ;
    global_id_for_word_tab = store_text_and_get_its_item_id( "tab" ) ;
    global_id_for_word_four = store_text_and_get_its_item_id( "four" ) ;
    global_id_for_word_hyphens = store_text_and_get_its_item_id( "hyphens" ) ;
    global_id_for_word_non = store_text_and_get_its_item_id( "non" ) ;
    global_id_for_word_breaking = store_text_and_get_its_item_id( "breaking" ) ;
    global_id_for_word_empty = store_text_and_get_its_item_id( "empty" ) ;
    global_id_for_word_text = store_text_and_get_its_item_id( "text" ) ;


// -----------------------------------------------
//  Create the text items for the Dashrep-defined
//  phrase names.

//  Reminder: put the following phrase words at
//  the beginning of their linked lists because
//  they are often encountered in directives:
//  "hyphen"
//  "here"
//  "hyphen-here"
//  "placeholder"
//  "for"

    global_id_for_phrase_word_numeric = store_text_and_get_its_item_id( "numeric" ) ;

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

    global_id_of_item_containing_definition_for_item[ global_id_for_phrase_name_character_hyphen ] = global_id_for_single_hyphen ;
    global_id_of_item_containing_definition_for_item[ global_id_for_phrase_name_character_space ] = global_id_for_single_space ;
    global_id_of_item_containing_definition_for_item[ global_id_for_phrase_name_character_newline ] = global_id_for_single_newline ;
    global_id_of_item_containing_definition_for_item[ global_id_for_phrase_name_character_tab ] = global_id_for_single_tab ;
    global_id_of_item_containing_definition_for_item[ global_id_for_phrase_name_character_underscore ] = global_id_for_single_underscore ;

    global_id_for_empty_text = store_text_and_get_its_item_id( "" ) ;
    global_id_of_item_containing_definition_for_item[ global_id_for_phrase_name_empty_text ] = global_id_for_empty_text ;

    global_id_for_four_hyphens = store_text_and_get_its_item_id( "----" ) ;
    global_id_of_item_containing_definition_for_item[ global_id_for_phrase_name_four_hyphens ] = global_id_for_four_hyphens ;

    global_id_for_non_breaking_space = store_text_and_get_its_item_id( "&nbsp;" ) ;
    global_id_of_item_containing_definition_for_item[ global_id_for_phrase_name_non_breaking_space ] = global_id_for_non_breaking_space ;


// -----------------------------------------------
//  Create the text items used for file input and
//  output.  Shorten the length slightly in case
//  of an overrun.

    global_length_requested_for_next_text_item_storage = global_allocated_length_for_file_input_or_output ;

    global_id_for_file_input = global_next_available_item_id ;
    assign_storage_for_new_item( ) ;
    global_category_for_item[ global_id_for_file_input ] = global_container_category_text_characters ;
    global_pointer_allocation_end_for_item[ global_id_for_file_input ] -= 5 ;

    global_id_for_file_output = global_next_available_item_id ;
    assign_storage_for_new_item( ) ;
    global_category_for_item[ global_id_for_file_output ] = global_container_category_text_characters ;
    global_pointer_allocation_end_for_item[ global_id_for_file_output ] -= 5 ;


// -----------------------------------------------
//  Create the text item used to store the result
//  of converting a number into text.

    global_length_requested_for_next_text_item_storage = 20 ;
    global_id_for_number_as_text = global_next_available_item_id ;
    assign_storage_for_new_item( ) ;
    global_category_for_item[ global_id_for_number_as_text ] = global_container_category_text_characters ;


// -----------------------------------------------
//  Create text items that contain specific
//  unchanging messages.

    global_message_trace__expand_phrases__endless_loop = store_text_and_get_its_item_id( "trace_diagnostic__expand_phrases__error_endless_loop__highest_count " ) ;



// -----------------------------------------------
//  Create text items that hold one filename and
//  one folder name after they have been changed
//  to eliminate leading and trailing delimiters.

    global_length_requested_for_next_text_item_storage = 200 ;

    global_id_for_valid_filename = global_next_available_item_id ;
    assign_storage_for_new_item( ) ;
    global_category_for_item[ global_id_for_valid_filename ] = global_container_category_text_characters ;
    global_pointer_allocation_end_for_item[ global_id_for_valid_filename ] -= 5 ;

    global_id_for_valid_folder_name = global_next_available_item_id ;
    assign_storage_for_new_item( ) ;
    global_category_for_item[ global_id_for_valid_folder_name ] = global_container_category_text_characters ;
    global_pointer_allocation_end_for_item[ global_id_for_valid_folder_name ] -= 5 ;


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
//  Define numeric-pi as a decimal number using
//  category list_of_decimal_numbers.
//  If value is needed, set flag and do
//  calculation later only if needed.


// -----------------------------------------------
//  For debugging, show the defined text items.

    for ( global_item_id = 1 ; global_item_id < global_next_available_item_id ; global_item_id ++ )
    {
//        log_out << "[" << global_item_id << " spans " << global_pointer_begin_for_item[ global_item_id ] << " to " << global_pointer_end_for_item[ global_item_id ] << "]" ;
        for ( global_character_pointer = global_pointer_begin_for_item[ global_item_id ] ; global_character_pointer <= global_pointer_end_for_item[ global_item_id ] ; global_character_pointer ++ )
        {
//            log_out << "[" << global_all_pointers_integers[ global_character_pointer ] << "]" ;
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
//  global_id_for_file_input.
//
//  Later, replace "fgetc" function with C++ code
//  that reads unicode characters.  Test with
//  Chinese characters.

void read_text_line_from_file( )
{
    global_pointer_end_for_item[ global_id_for_file_input ] = global_pointer_begin_for_item[ global_id_for_file_input ] - 1 ;
    global_category_for_item[ global_id_for_file_input ] = global_container_category_text_characters ;
    while ( 1 == 1 )
    {
        global_next_character_number = fgetc( global_infile_connection ) ;
        global_id_text_to_edit = global_id_for_file_input ;
        measure_space_available_in_item( ) ;
        if ( global_space_available_in_item > 1 )
        {
            global_pointer_end_for_item[ global_id_text_to_edit ] ++ ;
            global_all_pointers_integers[ global_pointer_end_for_item[ global_id_text_to_edit ] ] = global_next_character_number ;
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
        if ( global_pointer_end_for_item[ global_id_for_file_input ] < global_pointer_allocation_end_for_item[ global_id_for_file_input ] )
        {
            global_pointer_end_for_item[ global_id_for_file_input ] ++ ;
            global_pointer_end_for_item[ global_id_for_file_input ] = global_next_character_number ;
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
    global_pointer_end_for_item[ global_id_text_to_edit ] = global_pointer_begin_for_item[ global_id_text_to_edit ] - 1 ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function append_space_if_not_empty
//
//  Appends a space to
//  "global_id_text_to_edit"
//  if it is not empty.
//  If the text item is categorized as a list of
//  numbers (integer or decimal), must convert
//  text item into characters.

void append_space_if_not_empty( )
{
    if ( global_pointer_end_for_item[ global_id_text_to_edit ] < global_pointer_begin_for_item[ global_id_text_to_edit ] )
    {
        if ( global_category_for_item[ global_id_text_to_edit ] == global_container_category_list_of_item_ids )
        {
            measure_space_available_in_item( ) ;
            if ( global_space_available_in_item >= 2 )
            {
                global_pointer_end_for_item[ global_id_text_to_edit ] ++ ;
                global_all_pointers_integers[ global_pointer_end_for_item[ global_id_text_to_edit ] ] = global_id_for_single_space ;
            } else
            {
                global_item_id = 111 ;
                exit_not_yet_supported( ) ;
                return ;
            }
        } else
        {
            global_length_requested_for_next_text_item_storage = global_default_length_for_text_item ;
            assign_storage_for_new_item( ) ;
            global_category_for_item[ global_new_storage_item_id ] = global_container_category_list_of_item_ids ;
//  insert the to and space IDs, but not the from ID
//        global_all_pointers_integers
            global_id_text_to_edit = global_new_storage_item_id ;
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
//  ID number in "global_id_from_origin",
//  and the text item being extended is specified
//  by the text item ID number in
//  "global_id_text_to_edit".  The value in
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

    if ( global_pointer_end_for_item[ global_id_from_origin ] < global_pointer_begin_for_item[ global_id_from_origin ] )
    {
        return ;
    }


// -----------------------------------------------
//  If the text being extended is empty, just put
//  a pointer into the text being extended, and
//  specify a category of "list_of_text_items"
//  regardless of what it was before.  The
//  pointer points to the text being appended.

    if ( global_pointer_end_for_item[ global_id_text_to_edit ] < global_pointer_begin_for_item[ global_id_text_to_edit ] )
    {
        global_to_text_contains_category = global_category_for_item[ global_id_text_to_edit ] ;
        if ( global_to_text_contains_category == global_container_category_list_of_item_ids )
        {
            global_pointer_begin_for_item[ global_id_text_to_edit ] = global_id_from_origin ;
            global_pointer_end_for_item[ global_id_text_to_edit ] = global_pointer_begin_for_item[ global_id_text_to_edit ] ;
        } else
        {
            global_all_pointers_integers[ global_pointer_begin_for_item[ global_id_text_to_edit ] ] = global_id_from_origin ;
            global_pointer_end_for_item[ global_id_text_to_edit ] = global_pointer_begin_for_item[ global_id_text_to_edit ] ;
            global_category_for_item[ global_id_text_to_edit ] = global_container_category_list_of_item_ids ;
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

    global_from_text_contains_category = global_category_for_item[ global_id_from_origin ] ;
    global_to_text_contains_category = global_category_for_item[ global_id_text_to_edit ] ;


// -----------------------------------------------
//  If the categories of the "from" and "to" text
//  items are both of category
//  "contains_list_of_item_ids", add the
//  pointer.

    if ( ( global_from_text_contains_category == global_container_category_list_of_item_ids ) && ( global_to_text_contains_category == global_container_category_list_of_item_ids ) )
    {
        global_pointer_end_for_item[ global_id_text_to_edit ] ++ ;
        global_all_pointers_integers[ global_pointer_end_for_item[ global_id_text_to_edit ] ] = global_id_from_origin ;
        return ;
    }


// -----------------------------------------------
//  Create a new text item of category
//  "list_of_item_ids" and into it put
//  pointers that point to the "to" and "from"
//  text items, and change the text item ID of the
//  "to" text item so that the new top-level item
//  points to both the "to" and "from".

    global_length_requested_for_next_text_item_storage = global_default_length_for_text_item ;
    assign_storage_for_new_item( ) ;
    global_pointer_end_for_item[ global_new_storage_item_id ] ++ ;
    global_all_pointers_integers[ global_pointer_end_for_item[ global_new_storage_item_id ] ] = global_id_text_to_edit ;
    global_category_for_item[ global_new_storage_item_id ] = global_container_category_list_of_item_ids ;
    global_pointer_end_for_item[ global_new_storage_item_id ] ++ ;
    global_all_pointers_integers[ global_pointer_end_for_item[ global_new_storage_item_id ] ] = global_id_from_origin ;
    global_id_text_to_edit = global_new_storage_item_id ;
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
//  global_id_from_origin, and the text
//  item being extended is specified by the text
//  item ID number in
//  global_id_text_to_edit.

void append_copied_text( )
{
    global_pointer_end_for_item[ global_id_text_to_edit ] = global_pointer_begin_for_item[ global_id_text_to_edit ] - 1 ;
    global_length_requested_for_next_text_item_storage = global_pointer_end_for_item[ global_id_from_origin ] - global_pointer_begin_for_item[ global_id_from_origin ] + 1 ;
    assign_storage_for_new_item( ) ;
    for ( global_text_pointer = global_pointer_begin_for_item[ global_id_from_origin ] ; global_text_pointer <= global_pointer_end_for_item[ global_id_from_origin ] ; global_text_pointer ++ )
    {
        global_pointer_end_for_item[ global_new_storage_item_id ] ++ ;
        global_all_pointers_integers[ global_pointer_end_for_item[ global_new_storage_item_id ] ] = global_all_pointers_integers[ global_pointer_end_for_item[ global_id_from_origin ] ]
         ;
    }
    global_category_for_item[ global_new_storage_item_id ] = global_category_for_item[ global_id_from_origin ] ;
    global_id_from_origin = global_new_storage_item_id ;
    append_linked_text( ) ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function append_text
//
//  Appends text from the text item
//  "global_id_from_origin" to the text item
//  "global_id_text_to_edit".
//  Allow the two text item IDs to be the same.

void append_text( )
{
	if ( ( global_yes_or_no_can_edit_item[ global_id_from_origin ] == global_yes ) && ( global_yes_or_no_can_edit_item[ global_id_text_to_edit ] == global_yes ) )
	{
        append_linked_text( ) ;
    } else
    {
        append_copied_text( ) ;
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function copy_linked_text

void copy_linked_text( )
{
    global_pointer_end_for_item[ global_id_text_to_edit ] = global_pointer_begin_for_item[ global_id_text_to_edit ] - 1 ;
    append_linked_text( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function copy_copied_text

void copy_copied_text( )
{
    global_pointer_end_for_item[ global_id_text_to_edit ] = global_pointer_begin_for_item[ global_id_text_to_edit ] - 1 ;
    append_copied_text( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function copy_text
//
//  Copy the text item, either by modifying the
//  original text, or by making a copy.

void copy_text( )
{
	if ( ( global_yes_or_no_can_edit_item[ global_id_from_origin ] == global_yes ) && ( global_yes_or_no_can_edit_item[ global_id_text_to_edit ] == global_yes ) )
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
//  Function write_to_log
//
//  This function can be used when debugging target
//  pointer usage.

void write_to_log( )
{
    log_out << "global_direction_next_or_previous " << global_direction_next_or_previous << std::endl << "global_target_stack_item_bottom " << global_target_stack_item_bottom << std::endl << "global_target_stack_item_top " << global_target_stack_item_top << std::endl << "global_target_stack_item_prior " << global_target_stack_item_prior << std::endl << "global_target_stack_item_next " << global_target_stack_item_next << std::endl << "global_target_stack_pointer_for_get_next_previous_character " << global_target_stack_pointer_for_get_next_previous_character << std::endl << "global_pointer_to_within_target_stack_item_top " << global_pointer_to_within_target_stack_item_top << std::endl << "global_current_target_text_item " << global_current_target_text_item << std::endl << "global_current_target_character_position " << global_current_target_character_position << std::endl << "global_pointer_begin_for_item[ " << global_current_target_text_item << " ] " << global_pointer_begin_for_item[ global_current_target_text_item ] << std::endl << "global_pointer_end_for_item[ " << global_current_target_text_item << " ] " << global_pointer_end_for_item[ global_current_target_text_item ] << std::endl << "global_current_target_text_item_begin " << global_current_target_text_item_begin << std::endl << "global_current_target_text_item_end " << global_current_target_text_item_end << std::endl << "global_distance_between_item_begin_and_end " << global_distance_between_item_begin_and_end << std::endl << "global_category_for_item " << global_category_for_item[ global_current_target_text_item ] << std::endl << "global_yes_or_no_reached_end_of_current_text_item " << global_yes_or_no_reached_end_of_current_text_item << std::endl << std::endl ;

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
    global_text_item_with_next_character = global_all_pointers_integers[ global_pointer_begin_for_item[ global_target_stack_item_top ] ] ;
    switch ( global_category_for_item[ global_text_item_with_next_character ] )
    {
        global_container_category_phrase_word_pointers :
            global_character_to_insert_between_subitems = global_insertion_character_hyphen ;
            break ;
        global_container_category_list_of_integers :
            global_character_to_insert_between_subitems = global_insertion_character_space ;
            break ;
        global_container_category_pointers_to_decimal_numbers :
            global_character_to_insert_between_subitems = global_insertion_character_space ;
            break ;
        default :
            global_character_to_insert_between_subitems = global_insertion_character_none ;
            break ;
    }
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
//  Function convert_into_category_list_of_integers
//
//  Convert a text item that contains only integers
//  -- in text format -- into a text item that is
//  a list of integers.

void convert_into_category_list_of_integers( )
{
    global_count_of_words_handled = 0 ;
    global_id_for_integers_as_text = global_id_from_origin ;
    global_length_requested_for_next_text_item_storage = 2 ;
    assign_storage_for_new_item( ) ;
    global_id_for_list_of_integers = global_new_storage_item_id ;
    global_character_pointer_current = global_pointer_begin_for_item[ global_id_for_integers_as_text ] ;
    global_character_pointer_end = global_pointer_end_for_item[ global_id_for_integers_as_text ] ;
    global_yes_or_no_character_is_delimiter = global_yes ;
    while ( global_character_pointer_current <= global_character_pointer_end )
    {
        global_single_character_as_integer = global_all_characters[ global_character_pointer_current ] ;
        check_yes_or_no_character_is_delimiter( ) ;
        while ( global_yes_or_no_character_is_delimiter == global_yes )
        {
        	continue ;
        }
        global_character_pointer_begin_for_number = global_character_pointer_current ;
        while ( global_yes_or_no_character_is_delimiter == global_no )
        {
            initialize_parse_characters_of_number( ) ;
            global_single_character_as_integer = global_all_characters[ global_text_pointer ] ;
            parse_one_character_of_number( ) ;
            if ( ( global_yes_or_no_numeric_delimiter_encountered == global_yes ) || ( global_text_pointer == global_pointer_end_for_item[ global_id_from_origin ] ) )
            {
                if ( global_number_of_digits_encountered > 0 )
                {
                    if ( global_yes_or_no_number_is_valid == global_yes )
                    {
                        finish_parse_characters_of_number( ) ;
                        if ( global_yes_or_no_decimal_number == global_no )
                        {
                            global_pointer_end_for_item[ global_id_for_list_of_integers ] ++ ;
                            global_all_pointers_integers[ global_pointer_end_for_item[ global_id_for_list_of_integers ] ] = global_single_integer ;
                            log_out << "integer number = " << global_single_integer << std::endl ;
                            break ;
                        } else
                        {
                            global_id_for_list_of_integers = 0 ;
                            global_id_text_to_edit = 0 ;
                            recover_memory_from_top_text_item( ) ;
                            log_out << "number is not integer, is decimal" << std::endl ;
                            return ;
                        }
                    } else
                    {
                        global_id_for_list_of_integers = 0 ;
                        global_id_text_to_edit = 0 ;
                        recover_memory_from_top_text_item( ) ;
                        log_out << "invalid number" << std::endl ;
                        return ;
                    }
                }
                initialize_parse_characters_of_number( ) ;
            }
        }
        measure_space_available_in_item( ) ;
        if ( global_space_available_in_item < 1 )
        {
            extend_length_of_top_text_item( ) ;
        }
        global_character_pointer_current ++ ;
    }
    recover_memory_from_top_text_item( ) ;
    global_id_text_to_edit = global_id_for_list_of_integers ;
    global_category_for_item[ global_id_for_list_of_integers ] = global_container_category_list_of_integers ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function convert_into_category_pointers_to_decimal_numbers
//
//  Use function that parses decimal numbers.

void convert_into_category_pointers_to_decimal_numbers( )
{

//  later, after integer version debugged, copy code from integer version and modify for decimal numbers

//  global_container_category_pointers_to_decimal_numbers ;

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function convert_list_of_integers_into_text_item
//
//  Convert the text item at
//  "global_id_for_list_of_integers", which is
//  assumed to be a list of integers, into a text
//  item that contains only integers, with one
//  space between each adjacent pair of numbers.

void convert_list_of_integers_into_text_item( )
{


// -----------------------------------------------
//  Create a new text item to hold the generated
//  text.

    global_length_requested_for_next_text_item_storage = 200 ;
    assign_storage_for_new_item( ) ;
    global_id_for_integers_as_text = global_new_storage_item_id ;


// -----------------------------------------------
//  Begin a loop that handles each integer.


    while ( global_current_target_character_position < 0 )
    {


// todo: finish writing this code

//  global_id_for_list_of_integers

        global_single_integer = global_all_pointers_integers[ global_pointer_begin_for_item[ global_current_target_text_item ] + global_current_target_character_position - 1 ] ;
        convert_integer_to_text( ) ;


// -----------------------------------------------
//  Append the digits to the text item.

        append_copied_text( ) ;


// -----------------------------------------------
//  Repeat the loop for the next integer.


    }


// -----------------------------------------------
//  End of convert_list_of_integers_into_text_item.

}


// -----------------------------------------------
// -----------------------------------------------
//  Function convert_pointers_to_decimal_numbers_into_text_item
//
//  Convert a text item that is a list of decimal
//  numbers into a text item that contains only
//  decimal numbers as text, with one space
//  between each adjacent pair of numbers.

void convert_pointers_to_decimal_numbers_into_text_item( )
{

//  later, after integer version debugged, copy code from integer version and modify for decimal numbers

//  global_container_category_pointers_to_decimal_numbers ;
//  convert_decimal_to_text( ) ;

}


// -----------------------------------------------
// -----------------------------------------------
//  Function put_info_into_target_pointer_stack_level

void put_info_into_target_pointer_stack_level( )
{
        global_pointer_to_within_target_stack_item_top = global_pointer_begin_for_item[ global_target_stack_item_bottom ] ;

        global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_top ] = global_target_stack_item_top ;

        global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_prior ] = global_target_stack_item_prior ;

        global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_next ] = global_target_stack_item_next ;

        global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_text_item ] = global_current_target_text_item ;

        global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_character_position ] = global_current_target_character_position ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_info_from_target_pointer_stack_level

void get_info_from_target_pointer_stack_level( )
{
    global_pointer_to_within_target_stack_item_top = global_pointer_begin_for_item[ global_target_stack_item_bottom ] ;

    global_target_stack_item_top = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_top ] ;

    global_target_stack_item_prior = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_prior ] ;

    global_target_stack_item_next = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_next ] ;

    global_current_target_text_item = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_text_item ] ;

    global_current_target_character_position = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_character_position ] ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function create_new_target_pointer_stack_level
//
//  Create a new target pointer stack level.  The
//  pointer stack is specified by the ID number in
//  "global_target_stack_item_bottom".

void create_new_target_pointer_stack_level( )
{


// -----------------------------------------------
//  Create the new stack level.

    global_length_requested_for_next_text_item_storage = 5 ;
    assign_storage_for_new_item( ) ;
    log_out << "global_new_storage_item_id " << global_new_storage_item_id << std::endl ;


// -----------------------------------------------
//  If the new stack item is the bottom level,
//  initialize the pointers that will be put into
//  the new stack level.

    if ( global_target_stack_item_bottom == 0 )
    {
        global_target_stack_item_bottom = global_new_storage_item_id ;
        global_target_stack_item_top = global_target_stack_item_bottom ;
        global_target_stack_item_prior = 0 ;
        global_target_stack_item_next = 0 ;


// -----------------------------------------------
//  If the new stack level is not the bottom
//  level, point to it from what will become the
//  prior stack level, and initialize the default
//  pointers, which includes pointing to it as the
//  new top stack level.

    } else
    {
        global_target_stack_item_top = global_new_storage_item_id ;
        global_pointer_to_within_target_stack_item_bottom = global_pointer_begin_for_item[ global_target_stack_item_bottom ] ;
        global_all_pointers_integers[ global_pointer_to_within_target_stack_item_bottom + global_offset_for_target_stack_item_top ] = global_target_stack_item_top ;
        global_target_stack_item_next = 0 ;
        global_pointer_to_within_target_stack_item_top = global_pointer_begin_for_item[ global_target_stack_item_top ] ;
        global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_next ] = global_target_stack_item_next ;
    }


// -----------------------------------------------
//  Put zeros into the pointers that soon will
//  point to the text item and character position
//  that is stored in this new stack level.

    global_current_target_text_item = 0 ;
    global_current_target_character_position = 0 ;


// -----------------------------------------------
//  Put the pointers into the new stack level.

    put_info_into_target_pointer_stack_level( ) ;
    log_out << "new stack level" << std::endl ;
    write_to_log( ) ;
    return ;


// -----------------------------------------------
//  End of create_new_target_pointer_stack_level.

}


// -----------------------------------------------
// -----------------------------------------------
//  Function push_target_pointer_stack_level
//
//  Move up to the next higher target pointer
//  stack level.  If this is the first use of this
//  pointer stack -- as indicated by a value of
//  zero -- create the bottom level of the stack.
//  The pointer stack is specified by the ID
//  number in "global_target_stack_item_bottom".

void push_target_pointer_stack_level( )
{


// -----------------------------------------------
//  If a new target pointer stack item needs to be
//  created, create it.

    if ( ( global_target_stack_item_bottom == 0 ) || ( global_target_stack_item_next == 0 ) )
    {
    	create_new_target_pointer_stack_level( ) ;
    }


// -----------------------------------------------
//  Update the stack level with the needed info.


//  todo: finish editing this code
    global_pointer_to_within_target_stack_item_bottom = global_pointer_begin_for_item[ global_target_stack_item_bottom ] ;
    global_pointer_to_within_target_stack_item_top = global_pointer_begin_for_item[ global_target_stack_item_top ] ;

    global_all_pointers_integers[ global_pointer_to_within_target_stack_item_bottom + global_offset_for_target_stack_item_top ] = global_target_stack_item_top ;

    global_target_stack_item_next = 0 ;



    global_target_stack_item_top = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_next ] ;
    global_pointer_to_within_target_stack_item_top = global_pointer_begin_for_item[ global_target_stack_item_top ] ;
    global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_text_item ] = 0 ;
    global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_character_position ] = 0 ;
    log_out << "new bottom" << std::endl ;
    write_to_log( ) ;


// -----------------------------------------------
//  End of function push_target_pointer_stack_level.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function pop_target_pointer_stack_level
//
//  Move down one level in the target pointer
//  stack.

void pop_target_pointer_stack_level( )
{


// -----------------------------------------------
//  Identify the stack's top item.

    global_pointer_to_within_target_stack_item_bottom = global_pointer_begin_for_item[ global_target_stack_item_bottom ] ;

    global_target_stack_item_top = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_bottom + global_offset_for_target_stack_item_top ] ;


// -----------------------------------------------
//  Identify the prior item, one stack level
//  lower.

    global_pointer_to_within_target_stack_item_top = global_pointer_begin_for_item[ global_target_stack_item_top ] ;

    global_target_stack_item_prior = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_target_stack_item_prior ] ;


// -----------------------------------------------
//  Use the prior item as the new top item.

    global_target_stack_item_top = global_target_stack_item_prior ;

    global_all_pointers_integers[ global_pointer_to_within_target_stack_item_bottom + global_offset_for_target_stack_item_top ] = global_target_stack_item_top ;


// -----------------------------------------------
//  Get the info from the new top item.

    get_info_from_target_pointer_stack_level( ) ;


// -----------------------------------------------
//  Determine the container category of the new
//  top item.

    global_container_category = global_category_for_item[ global_id_pointer_stack_for_getting_next_character ] ;


// -----------------------------------------------
//  Get the information from this lower stack
//  level.

    get_info_from_target_pointer_stack_level( ) ;


// -----------------------------------------------
//  Specify the automatic insertion character for
//  the new top item, and initialize the flag that
//  tracks when that character has been inserted.

    specify_character_to_insert_between_subitems( ) ;
    global_yes_or_no_inserted_character = global_no ;

    log_out << "pop" << std::endl ;
    write_to_log( ) ;


// -----------------------------------------------
//  End of function pop_target_pointer_stack_level.

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
//  specified in "global_item_id".

void initialize_get_next_character_from_text_item( )
{
//	global_id_pointer_stack_for_getting_next_character ;
    global_current_target_text_item = global_item_id ;
    global_target_stack_item_bottom = 0 ;
    push_target_pointer_stack_level( ) ;
    global_target_stack_pointer_for_get_next_previous_character = global_target_stack_item_bottom ;
    get_info_from_target_pointer_stack_level( ) ;
    global_current_target_text_item = global_item_id ;
    global_current_target_character_position = 1 ;
    global_target_stack_item_top = global_target_stack_item_bottom ;
    put_info_into_target_pointer_stack_level( ) ;
    global_container_category = global_category_for_item[ global_current_target_text_item ] ;
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
//  specified in "global_item_id".

void initialize_get_previous_character_from_text_item( )
{
    initialize_get_next_character_from_text_item( ) ;
    global_current_target_character_position = global_pointer_end_for_item[ global_current_target_text_item ] - global_pointer_begin_for_item[ global_current_target_text_item ] + 1 ;
    global_pointer_to_within_target_stack_item_top = global_pointer_begin_for_item[ global_target_stack_item_bottom ] ;
    global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_character_position ] = global_current_target_character_position ;
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
//  If ID for the copy already exists, it is used
//  instead of creating a new stack.
//  The copy is pointed to by
//  "global_id_for_copy_of_target_pointer_stack".
//  The original is pointed to by
//  "global_id_for_original_of_target_pointer_stack".

void copy_pointer_stack( )
{


// -----------------------------------------------
//  If the stack does not already exist, create a
//  new, empty, target pointer stack, and get its
//  location.  Otherwise use the existing stack.

    if ( global_id_for_copy_of_target_pointer_stack == 0 )
    {
        global_target_stack_item_bottom = 0 ;
        push_target_pointer_stack_level( ) ;
        global_id_for_copy_of_target_pointer_stack = global_target_stack_item_bottom ;
    } else
    {
        global_target_stack_item_bottom = global_id_for_copy_of_target_pointer_stack ;
    }
    global_target_stack_item_current_copy = global_id_for_copy_of_target_pointer_stack ;


// -----------------------------------------------
//  Get the location of the target pointer stack
//  being copied, and get the location of the top
//  item in that stack.

    global_target_stack_item_current_original = global_id_for_original_of_target_pointer_stack ;
    global_pointer_to_within_target_stack_item_current_original = global_pointer_begin_for_item[ global_target_stack_item_current_original ] ;
    global_target_stack_item_top_original = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_current_original + global_offset_for_target_stack_item_top ] ;


// -----------------------------------------------
//  Begin a loop that handles each stack level.

    while ( global_target_stack_item_current_original > 0 )
    {


// -----------------------------------------------
//  Copy the pointer information.

        global_pointer_to_within_target_stack_item_current_copy = global_pointer_begin_for_item[ global_target_stack_item_current_copy ] ;
        global_pointer_to_within_target_stack_item_current_original = global_pointer_begin_for_item[ global_target_stack_item_current_original ] ;
        global_all_pointers_integers[ global_pointer_to_within_target_stack_item_current_copy + global_offset_for_current_target_text_item ] = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_current_original + global_offset_for_current_target_text_item ] ;
        global_all_pointers_integers[ global_pointer_to_within_target_stack_item_current_copy + global_offset_for_current_target_character_position ] = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_current_original + global_offset_for_current_target_character_position ] ;
        global_all_pointers_integers[ global_pointer_to_within_target_stack_item_current_copy + global_offset_for_target_stack_item_top ] = 0 ;
        global_target_stack_item_current_original = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_current_original + global_offset_for_target_stack_item_next ] ;


// -----------------------------------------------
//  If the top stack level has been reached, exit
//  the loop.

        if ( ( global_target_stack_item_current_original == 0 ) || ( global_target_stack_item_current_original == global_target_stack_item_top_original ) )
        {
            break ;
        }


// -----------------------------------------------
//  Get from the copy stack the next-higher stack
//  level ID.

        global_pointer_to_within_target_stack_item_current_copy = global_pointer_begin_for_item[ global_target_stack_item_current_copy ] ;
        global_target_stack_item_current_copy = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_current_copy + global_offset_for_target_stack_item_next ] ;


// -----------------------------------------------
//  If the stack for the copy has run out of stack
//  levels, create a new, empty, target pointer
//  stack level.

//  todo: needs more proofreading ...

        if ( global_target_stack_item_current_copy == 0 )
        {
	        global_target_stack_item_bottom = 0 ;
	        push_target_pointer_stack_level( ) ;
            global_target_stack_item_current_copy = global_target_stack_item_bottom ;
        }


// -----------------------------------------------
//  In the previous copy stack level, point to
//  this next-higher stack level.

        global_all_pointers_integers[ global_pointer_to_within_target_stack_item_current_copy + global_offset_for_target_stack_item_next ] = global_target_stack_item_current_copy ;


// -----------------------------------------------
//  Get from the original stack item the "next"
//  higher stack item ID.

        global_pointer_to_within_target_stack_item_current_original = global_pointer_begin_for_item[ global_target_stack_item_current_original ] ;
        global_target_stack_item_current_original = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_current_original + global_offset_for_target_stack_item_next ] ;


// -----------------------------------------------
//  Repeat the loop to handle the next stack
//  level.

    }


// -----------------------------------------------

    global_all_pointers_integers[ global_pointer_begin_for_item[ global_id_for_copy_of_target_pointer_stack ] + global_offset_for_target_stack_item_top ] = global_target_stack_item_current_copy ;


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
//  "global_item_id" and  puts the character
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

        global_current_target_text_item_begin = global_pointer_begin_for_item[ global_current_target_text_item ] ;
        global_current_target_text_item_end = global_pointer_end_for_item[ global_current_target_text_item ] ;
        global_distance_between_item_begin_and_end = global_current_target_text_item_end - global_current_target_text_item_begin ;


// -----------------------------------------------
//  If the previous character was the last (or
//  previous) character in the current-level text
//  item, track this situation.  Allow for the
//  possibility that the text item is empty.

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
            pop_target_pointer_stack_level( ) ;
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
                if ( ( ( global_current_target_character_position > 1 ) && ( global_current_target_character_position < ( global_current_target_text_item_end - global_current_target_text_item_begin + 1 ) ) ) || ( ( global_container_category == global_container_category_phrase_word_pointers ) && ( global_category_for_item[ global_target_stack_item_prior ] == global_container_category_phrase_word_pointers ) ) )
                {
                    global_single_character_as_integer = global_character_to_insert_between_subitems ;
                    global_yes_or_no_inserted_character = global_yes ;
                    return ;
                }
            }
        }


// -----------------------------------------------
//  If the container category is
//  "text_characters", supply the next (or
//  previous) character, increment the pointer,
//  and return.

        if ( global_container_category == global_container_category_text_characters )
        {
            global_single_character_as_integer = global_all_characters[ global_pointer_begin_for_item[ global_current_target_text_item ] + global_current_target_character_position - 1 ] ;
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
//  If the container category is either
//  "list_of_integers" or
//  "pointers_to_decimal_numbers", convert the
//  numbers into a text item, with a space between
//  each adjacent pair of numbers, and insert this
//  new text item as a replacement for the list of
//  integers or list of pointers to decimal
//  numbers, and point to the beginning (or end)
//  of the new text item.

        if ( ( global_container_category == global_container_category_list_of_item_ids ) || ( global_container_category == global_container_category_phrase_word_pointers ) )
        {
	        if ( global_container_category == global_container_category_list_of_integers )
	        {
	        	global_id_for_list_of_integers = global_current_target_text_item ;
	            convert_list_of_integers_into_text_item( ) ;
	        } else
	        {
	        	global_id_for_pointers_to_decimal_numbers = global_current_target_text_item ;
	            convert_pointers_to_decimal_numbers_into_text_item( ) ;
	        }

//  todo: move to function that inserts replacement text item id number

            put_info_into_target_pointer_stack_level( ) ;
            push_target_pointer_stack_level( ) ;
            get_info_from_target_pointer_stack_level( ) ;
            global_current_target_text_item = global_all_pointers_integers[ global_pointer_begin_for_item[ global_current_target_text_item ] + global_current_target_character_position - 1 ] ;
            global_pointer_to_within_target_stack_item_top = global_pointer_begin_for_item[ global_target_stack_item_top ] ;
            global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_text_item ] = global_current_target_text_item ;
            global_container_category = global_category_for_item[ global_current_target_text_item ] ;


            if ( global_direction_next_or_previous == global_direction_next )
            {
                global_current_target_character_position = 1 ;
            } else
            {
                global_current_target_character_position = global_pointer_end_for_item[ global_current_target_text_item ] - global_pointer_begin_for_item[ global_current_target_text_item ] + 1 ;
            }
            global_all_pointers_integers[ global_pointer_to_within_target_stack_item_top + global_offset_for_current_target_character_position ] = global_current_target_character_position ;
            global_yes_or_no_inserted_character = global_no ;
            continue ;
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
//  pointed to by "global_id_text_to_edit".  This
//  function truncates the beginning if the flag
//  "global_yes_or_no_begin_not_end" is
//  "global_yes" or else truncates the ending.
//  This function should not be used if the text
//  item and sub text items must not change.  Some
//  text item types (categories) cannot be
//  truncated using this function.

void truncate_text_item_using_target_pointer_stack( )
{
    log_out << "truncate item " << global_id_text_to_edit << std::endl ;


// -----------------------------------------------
//  Initialization.

    global_id_text_to_truncate = global_id_text_to_edit ;
    global_pointer_to_within_target_stack_item_current = global_pointer_begin_for_item[ global_target_stack_item_bottom ] ;
    global_target_stack_item_current = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_current + global_offset_for_target_stack_item_top ] ;
    write_to_log( ) ;


// -----------------------------------------------
//  For each stack level within the target pointer
//  stack, truncate the text item at that level.

    while ( global_target_stack_item_current > 0 )
    {
        global_container_category = global_category_for_item[ global_id_text_to_truncate ] ;
        write_to_log( ) ;
        if ( ( global_container_category == global_container_category_text_characters ) || ( global_container_category == global_container_category_list_of_item_ids ) )
        {
            global_pointer_to_within_target_stack_item_current = global_pointer_begin_for_item[ global_target_stack_item_current ] ;
            if ( global_yes_or_no_begin_not_end == global_yes )
            {
                global_pointer_begin_for_item[ global_id_text_to_truncate ] = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_current + global_offset_for_current_target_character_position ] ;
                log_out << "truncated beginning of " << global_id_text_to_truncate << " to " << global_pointer_begin_for_item[ global_id_text_to_truncate ] << std::endl ;
            } else
            {
                global_pointer_end_for_item[ global_id_text_to_truncate ] = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_current + global_offset_for_current_target_character_position ] ;
                log_out << "truncated end of " << global_id_text_to_truncate << " to " << global_pointer_end_for_item[ global_id_text_to_truncate ] << std::endl ;
            }
            global_target_stack_item_current = global_all_pointers_integers[ global_pointer_to_within_target_stack_item_current + global_offset_for_target_stack_item_prior ] ;
            if ( ( global_target_stack_item_current == 0 ) || ( global_target_stack_item_current == global_target_stack_item_bottom ) )
            {
                break ;
            }
            log_out << "truncate, stack shift needed" << std::endl ;
        } else
        {
            log_out << "cannot truncate global_container_category " << global_container_category << std::endl ;
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

    global_item_id = global_id_text_to_edit ;
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
//  Function initalize_skip_to_character_position
//
//  This function does initialization for the
//  function "skip_to_character_position".

void initalize_skip_to_character_position( ) ;
{
    global_item_id_current = global_id_for_character_position ;
	return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function jump_to_character_position
//
//  todo: change to use pointer, as output
//
//  Within the text item
//  "global_id_for_character_position"
//  jump to the character indicated by
//  "global_character_position_desired".  If that
//  position is specified as zero, count the
//  number of characters in the text item.  The
//  text item can contain pointers to other text
//  items.  This function calls itself recursively
//  so that the position within each subordinate
//  item is tracked with a local variable that
//  automatically implements a stack.
//
//  Before calling this function, use the function
//  "initalize_skip_to_character_position".

void skip_to_character_position( int local_item_id )
{
	int local_character_position_for_current_item = 1 ;
    int local_item_id = global_id_for_character_position ;
    while ( global_character_position_current < global_character_position_desired )
    {
        global_container_category = global_category_for_item[ global_id_current ] ;
        switch ( global_container_category )
        {
            case global_container_category_text_characters :
                global_length_of_text_item = global_pointer_end_for_item[ global_id_current ] - global_pointer_begin_for_item[ global_id_current ] ;

//  todo: write this code

                break ;
            case global_container_category_list_of_item_ids :

                skip_to_character_position( int local_item_id ) ;

                global_offset_within_list_of_pointers ++ ;
                global_id_current = global_all_pointers_integers[ global_pointer_begin_for_item[ global_id_current ] + global_offset_within_list_of_pointers ] ;
                if ( global_category_for_item[ global_id_current ] == global_container_category_phrase_word_pointers )
                {
                	global_character_insertion_count = 0 ;
                }
                break ;
            case global_container_category_phrase_word_pointers :

               	global_character_position_current ++ ;

                break ;
            default :
                log_out << "error, encountered list of integers or list of pointers to decimal numbers that have not been converted to text" << std::endl ;
                global_character_position_current = global_character_position_desired + 1 ;
                break ;
        }
    }
    if ( global_character_position_current > global_character_position_desired )
    {
        log_out << "error, encountered list of integers or list of pointers to decimal numbers that have not been converted to text" << std::endl ;
    }
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
//  "global_id_for_next_word_begin" and
//  "global_id_for_next_word_end".
//  Before using this function the initialization
//  function
//  "initialize_get_next_word_from_text_item"
//  must be used.
//  The beginning and end of the found word is
//  pointed to by
//  "global_target_stack_pointer_for_word_begin"
//  and
//  "global_target_stack_pointer_for_word_end".

void point_to_next_word_in_text_item( )
{


// -----------------------------------------------
//  Find the end of the current delimiter.

    global_yes_or_no_character_is_delimiter = global_yes ;
    while ( global_yes_or_no_character_is_delimiter == global_yes )
    {
        get_next_or_previous_character_from_text_item( ) ;
        if ( global_single_character_as_integer == 0 )
        {
            break ;
        }
        check_yes_or_no_character_is_delimiter( ) ;
        if ( global_yes_or_no_character_is_delimiter == global_no )
        {
            break ;
        }
    }


// -----------------------------------------------
//  Point to the beginning of the word that
//  follows the delimiter, then save this
//  character position in a target pointer stack.

    global_direction_next_or_previous = global_direction_previous ;
    get_next_or_previous_character_from_text_item( ) ;
    global_id_for_copy_of_target_pointer_stack = global_target_stack_pointer_for_word_begin ;
    copy_pointer_stack( ) ;
    global_id_for_next_word_begin = global_id_for_copy_of_target_pointer_stack ;
    global_target_stack_item_top_original = global_target_stack_item_top ;
    get_next_or_previous_character_from_text_item( ) ;


// -----------------------------------------------
//  Find the end of the non-delimiter text.

    global_direction_next_or_previous = global_direction_next ;
    while ( global_yes_or_no_character_is_delimiter == global_no )
    {
        get_next_or_previous_character_from_text_item( ) ;
        if ( global_single_character_as_integer == 0 )
        {
            break ;
        }
        check_yes_or_no_character_is_delimiter( ) ;
        if ( global_yes_or_no_character_is_delimiter == global_yes )
        {
            break ;
        }
    }


// -----------------------------------------------
//  Point to the end of the word that precedes the
//  next delimiter, then save this character
//  position in a second target pointer stack.

    global_direction_next_or_previous = global_direction_previous ;
    get_next_or_previous_character_from_text_item( ) ;
    global_id_for_copy_of_target_pointer_stack = global_target_stack_pointer_for_word_end ;
    copy_pointer_stack( ) ;
    global_id_for_next_word_end = global_id_for_copy_of_target_pointer_stack ;


// -----------------------------------------------
//  End of point_to_next_word_in_text_item.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_text_by_character_offset_and_length
//
//  Gets text from the specified text item, using
//  character offset and length.  Equivalent to
//  standard "substr" function but uses Dashrep
//  runtime text storage conventions.
//  The source text is pointed to by
//  "global_id_text_to_copy" and the offset is
//  specified by "global_character_offset" and
//  "global_character_length" specifies the
//  length, and "global_id_for_copy"
//  is the created copy of the specified
//  characters.

void get_text_by_character_offset_and_length( )
{
    global_length_requested_for_next_text_item_storage = 1000 ;
    assign_storage_for_new_item( ) ;
    global_id_for_copy = global_new_storage_item_id ;
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
            global_pointer_end_for_item[ global_id_for_copy ] ++ ;
            global_all_pointers_integers[ global_pointer_end_for_item[ global_id_for_copy ] ] = global_single_character_as_integer ;
        }
        if ( ( global_character_count >= global_character_length ) || ( global_single_character_as_integer == 0 ) )
        {
            break ;
        }
    }
    if ( global_id_for_copy == global_new_storage_item_id )
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
//
//  Replaces text.  The pointers
//  "global_target_begin_gap" and
//  "global_target_end_gap" point to the gap
//  into which the text in item
//  "global_id_for_insertion_into_gap" is
//  inserted.

void text_replace( )
{

//  todo: write this code


// -----------------------------------------------
//  Calculate the gap size.

//  global_target_begin_gap
//  global_target_end_gap


// -----------------------------------------------
//  Calculate the replacement size.

//  global_id_for_insertion_into_gap


// -----------------------------------------------
//  Check if the gap is entirely within the same
//  item.


// -----------------------------------------------
//  Check if the item being edited can be changed.


// -----------------------------------------------
//  If the gap size is larger than the replacement
//  size, and the gap is entirely within the same
//  item, and the item being edited can be
//  changed, do this simple kind of replacement,
//  and pad any extra space with zeros (which do
//  not add any size when the text is written to
//  a file or parsed one character at a time),
//  then return.


// -----------------------------------------------
//  Handle a complex situation which requires
//  inserting an item that uses pointers to
//  indicate the sequence.

    log_out << "BUG: ability to handle complex replacements not yet coded" << std::endl ;
    exit ( EXIT_FAILURE ) ;


// -----------------------------------------------
//  End of function text_replace.

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
//  item ID must be in global_item_id.

void write_text_item_to_file( )
{
    log_out << "global_item_id " << global_item_id << std::endl ;
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
//  Function check_yes_or_no_matching_text
//
//  Checks if two sequences of text characters are
//  the same.  It starts checking at both the
//  beginning and the end.  This approach is more
//  often going to be faster when the two text
//  sequences are numbers because the end digits
//  are more likely to be different.  The
//  characters are in "global_all_pointers_integers",
//  and the initial character pointers are:
//  "global_character_pointer_begin_for_text_one"
//  and
//  "global_character_pointer_begin_for_text_two"
//  and "global_character_length_minus_one" is the
//  character length minus one.

void check_yes_or_no_matching_text( )
{


// -----------------------------------------------
//  Initialization.

    global_character_begin_pointer_one = global_character_pointer_begin_for_text_one ;
    global_character_begin_pointer_two = global_character_pointer_begin_for_text_two ;
    global_character_end_pointer_one = global_character_pointer_begin_for_text_one + global_character_length_minus_one ;
    global_character_end_pointer_two = global_character_pointer_begin_for_text_two + global_character_length_minus_one ;


// -----------------------------------------------
//  Begin a loop that returns when a difference is
//  found, or when all the characters have been
//  checked.

    while ( 1 == 1 )
    {


// -----------------------------------------------
//  Check the next character at or near the
//  beginning of the two character sequences.

        log_out << "character one: " << global_all_pointers_integers[ global_character_begin_pointer_one ] << "  character two: " << global_all_pointers_integers[ global_character_begin_pointer_two ] << std::endl ;

        if ( global_all_pointers_integers[ global_character_begin_pointer_one ] != global_all_pointers_integers[ global_character_begin_pointer_two ] )
        {
            global_yes_or_no_same_text = global_no ;
            return ;
        }
        global_character_begin_pointer_one ++ ;
        global_character_begin_pointer_two ++ ;
        if ( global_character_begin_pointer_one > global_character_end_pointer_one )
        {
            global_yes_or_no_same_text = global_yes ;
            return ;
        }


// -----------------------------------------------
//  Check the next character at or near the end of
//  the two character sequences.

        log_out << "character one: " << global_all_pointers_integers[ global_character_begin_pointer_one ] << "  character two: " << global_all_pointers_integers[ global_character_begin_pointer_two ] << std::endl ;
        if ( global_all_pointers_integers[ global_character_end_pointer_one ] != global_all_pointers_integers[ global_character_end_pointer_two ] )
        {
            global_yes_or_no_same_text = global_no ;
            return ;
        }
        global_character_end_pointer_one -- ;
        global_character_end_pointer_two -- ;
        if ( global_character_end_pointer_one < global_character_begin_pointer_one )
        {
            global_yes_or_no_same_text = global_yes ;
            return ;
        }


// -----------------------------------------------
//  Repeat the loop.

    }


// -----------------------------------------------
//  End of check_yes_or_no_matching_text.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function create_linked_list
//
//  This function creates a linked list.  The ID
//  that identifies the linked list is in
//  "global_linked_list_grouping_id".

void create_linked_list( )
{
    global_length_requested_for_next_text_item_storage = 30 ;
    assign_storage_for_new_item( ) ;
    global_linked_list_grouping_id = global_new_storage_item_id ;
    global_pointer_end_for_item[ global_linked_list_grouping_id ] ++ ;
    global_all_pointers_integers[ global_pointer_end_for_item[ global_linked_list_grouping_id ] ] = 0 ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function add_to_linked_list
//
//  This function adds a pointer to the end of a
//  linked list.  The ID that identifies the
//  linked list is in
//  "global_linked_list_grouping_id".

void add_to_linked_list( )
{
    if ( global_pointer_end_for_item[ global_linked_list_grouping_id ] >= global_pointer_allocation_end_for_item[ global_linked_list_grouping_id ] )
    {
        global_pointer_end_for_item[ global_linked_list_grouping_id ] = global_pointer_allocation_end_for_item[ global_linked_list_grouping_id ] ;
        global_previous_linked_list_grouping_id = global_linked_list_grouping_id ;
        create_linked_list( ) ;
        global_all_pointers_integers[ global_pointer_end_for_item[ global_previous_linked_list_grouping_id ] ] = global_linked_list_grouping_id ;
    }
    global_pointer_end_for_item[ global_linked_list_grouping_id ] ++ ;
    global_all_pointers_integers[ global_pointer_end_for_item[ global_linked_list_grouping_id ] ] = 0 ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_next_pointer_from_linked_list
//
//  This function gets the next item ID from
//  the linked list that is pointed to by
//  "global_linked_list_grouping_id".  The pointer
//  "global_linked_list_current_pointer"
//  points to the current position in
//  "global_all_pointers_integers" that contains
//  the next item ID, which is supplied as
//  "global_id_from_linked_list".
//  The last integer in each text-item-like
//  grouping points to the next grouping.

void get_next_pointer_from_linked_list( )
{

//  todo: proofread this code

    if ( global_linked_list_current_pointer == global_pointer_end_for_item[ global_linked_list_grouping_id ] )
    {
        global_linked_list_grouping_id = global_all_pointers_integers[ global_pointer_end_for_item[ global_linked_list_grouping_id ] ] ;
        global_linked_list_current_pointer = global_pointer_begin_for_item[ global_linked_list_grouping_id ] ;
    }
    global_id_from_linked_list = global_all_pointers_integers[ global_linked_list_current_pointer ] ;
    global_linked_list_current_pointer ++ ;
	return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function add_new_phrase_name
//
//  Adds the hyphenated phrase name in the
//  "parsed_hyphenated_phrase_name" area.  This
//  function assumes the hyphenated phrase name
//  does not match any existing hyphenated phrase
//  name.  Do not duplicate any words that are
//  already used in other hyphenated phrase names.
//

void add_new_phrase_name( )
{

//  todo: write this code

// -----------------------------------------------
//  If any of the phrase words are not already
//  listed, add them to the end of the linked list
//  that lists other phrase words of the same
//  length.


// -----------------------------------------------
//  Add the phrase name to the end of the linked
//  list that lists other phrase names that have
//  the same number of phrase words.



// -----------------------------------------------
//  End of add_new_phrase_name.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function find_matching_phrase_word
//
//  Find the already-defined phrase word that
//  matches the phrase word specified by ....
//  The text item ID of the matching phrase word
//  is supplied in
//  "global_id_for_phrase_word".  A
//  zero value indicates the phrase word was not
//  found.
//
//  The search is done using the linked list of
//  phrase words that have the same character
//  length (as the phrase word to match).

void find_matching_phrase_word( )
{


// -----------------------------------------------
//  Point to the phrase word to be found, and
//  calculate its length minus one.

    global_character_pointer_begin_for_text_two = global_character_pointer_begin_for_phrase_word_in_position[ global_phrase_word_number_to_check ] ;
    global_character_length_of_phrase_word_minus_one = global_character_pointer_end_for_phrase_word_in_position[ global_phrase_word_number_to_check ] - global_character_pointer_begin_for_phrase_word_in_position[ global_phrase_word_number_to_check ] ;


// -----------------------------------------------
//  If there are no phrase words that have this
//  length, put zero into
//  "global_id_for_phrase_word", then
//  return.

//  todo: initialize global_id_for_list_of_phrase_words_of_length[ ] to zeros before adding phrase words

    if ( global_id_for_list_of_phrase_words_of_length[ global_character_length_of_phrase_word_minus_one + 1 ] == 0 )
    {
    	global_id_for_phrase_word = 0 ;
        return ;
    }


// -----------------------------------------------
//  Point to the first character of the phrase
//  word being searched for.

    global_character_pointer_begin_for_text_two = global_position_begin_for_phrase_word_number[ global_phrase_word_number_to_check ] ;


// -----------------------------------------------
//  Begin a loop that checks each phrase word for
//  a match.

//  todo: finish writing, and proofreading, this code

    global_id_for_phrase_word = 0 ;
    global_linked_list_grouping_id = global_id_for_list_of_phrase_words_of_length[ global_character_length_of_phrase_word ] ;
    global_linked_list_current_pointer = global_pointer_begin_for_item[ global_linked_list_grouping_id ] - 1 ;
    while ( 1 == 1 )
    {


// -----------------------------------------------
//  Point to the next phrase word to check.  If
//  there are no more to check, return with an
//  indication that there was no match.

        get_next_pointer_from_linked_list( ) ;
        global_character_pointer_begin_for_text_one = 1 ;global_pointer_begin_for_item[ global_id_from_linked_list ] ;
        if ( global_character_pointer_begin_for_text_one == 0 )
        {
        	global_yes_or_no_matching_text = global_no ;
        	break ;
        }


// -----------------------------------------------
//  Compare the already-defined phrase word with
//  the phrase word being searched for.
//  If the phrase words match, return with the
//  text item ID of the matching phrase word.

        global_item_id = global_id_from_linked_list ;
        check_yes_or_no_matching_text( ) ;
        if ( global_yes_or_no_matching_text == global_yes )
        {
        	global_id_for_phrase_word = global_id_from_linked_list ;
	        return ;
        }


// -----------------------------------------------
//  Repeat the loop for the next already-defined
//  phrase word.

    }
    global_id_for_phrase_word = 0 ;


// -----------------------------------------------
//  End of find_matching_phrase_word.

    return ;

}


// -----------------------------------------------
// -----------------------------------------------
//  Function find_matching_phrase_name
//
//  Searches all the already-defined phrase
//  names to find a match with the phrase name
//  defined by the pointers in the 
//  "parsed_hyphenated_phrase_name" area.
//  Puts the text item ID of the matching
//  phrase name into the variable
//  "global_found_matching_phrase_name"
//  but that variable is zero if no match was
//  found.
//
//  ? The text item
//  "global_item_id_with_phrase_name_to_find"
//  contains the phrase name to be found.

void find_matching_phrase_name( )
{


// -----------------------------------------------
//  Initialization.

    global_number_of_phrase_words_found = 0 ;


// -----------------------------------------------
//  Point to the last character of the last word
//  in the phrase name, then save this position.

    global_direction_next_or_previous = global_direction_previous ;
    get_next_or_previous_character_from_text_item( ) ;
    global_id_for_copy_of_target_pointer_stack = global_target_stack_pointer_for_phrase_name_end ;
    copy_pointer_stack( ) ;


// -----------------------------------------------
//  Access the characters in the phrase name in
//  reverse sequence.

    global_direction_next_or_previous = global_direction_previous ;
    global_count_of_words_in_phrase_name = 1 ;
    global_previous_character = 0 ;
    global_yes_or_no_character_is_delimiter = global_no ;
    while ( global_yes_or_no_character_is_delimiter == global_yes )
    {


// -----------------------------------------------
//  If a delimiter or the beginning of the text
//  item is encountered, exit the loop because all
//  the phrase words have been encountered.

        get_next_or_previous_character_from_text_item( ) ;
        if ( global_single_character_as_integer == 0 )
        {
            break ;
        }
        check_yes_or_no_character_is_delimiter( ) ;
        if ( global_yes_or_no_character_is_delimiter == global_no )
        {
            break ;
        }


// -----------------------------------------------
//  If the character is a hyphen, and the previous
//  character was not also a hyphen, increment the
//  count of phrase words, store the pointer that
//  points to the beginning of this phrase word,
//  and repeat the loop.
//  Reminder:  The hyphens are not stored, so the
//  end of the previous word is one less than the
//  beginning of the next word.

        if ( global_single_character_as_integer == global_ascii_code_for_hyphen )
        {
        	if ( global_single_character_as_integer == global_previous_character )
        	{
                continue ;
            }
        	global_count_of_words_in_phrase_name ++ ;

// todo:  finish writing this code

        	global_position_begin_for_phrase_word_number[ global_maximum_words_in_phrase_name - global_count_of_words_in_phrase_name ] = global_pointer_begin_for_item[ global_id_for_phrase_name ] ;



            continue ;
        }


// -----------------------------------------------
//  Put the current character into the text item,
//  compensating for getting the characters in
//  reverse sequence.  Check for the phrase name
//  exceeding the length allowed.
//  Reminder:  The text item ID minus one refers
//  to the preceeding text item.

        global_pointer_begin_for_item[ global_id_for_phrase_name ] ++ ;
        if ( global_pointer_begin_for_item[ global_id_for_phrase_name ] <= global_pointer_allocation_end_for_item[ global_id_for_phrase_name - 1 ] )
        {
        	log_out << "BUG: Phrase name exceeds allowed length." << std::endl ;
        	exit ( EXIT_FAILURE ) ;
        }
        global_all_pointers_integers[ global_pointer_begin_for_item[ global_id_for_phrase_name ] ] = global_single_character_as_integer ;

        
// -----------------------------------------------
//  Save a copy of the current character, then
//  repeat the loop to handle the "next"
//  (backwards-direction) character in the phrase
//  name.

        global_previous_character = global_single_character_as_integer ;
    }


// -----------------------------------------------
//  Point to the first character in the phrase
//  name, and leave the target pointer stack
//  pointing to this character.

    global_direction_next_or_previous = global_direction_next ;
    get_next_or_previous_character_from_text_item( ) ;


// -----------------------------------------------
//  Find each phrase word in the list of
//  already-defined phrase words, and get its
//  text item ID number.  Also count how
//  many were found.
//
//  Reminder:  When using the array
//  "global_position_begin_for_phrase_word_number",
//  the index numbers are offset such that the
//  last phrase word is indexed as one minus
//  "global_maximum_words_in_phrase_name".

    global_number_of_phrase_words_found = 0 ;
    for ( global_phrase_word_number_to_check = 1 ; global_phrase_word_number_to_check <= global_count_of_words_in_phrase_name ; global_phrase_word_number_to_check ++ )
    {

//  todo: proofread this code

        global_character_position_in_phrase_name = 
        global_character_pointer_begin_for_phrase_word_in_position[ global_phrase_word_number_to_check ] = global_position_begin_for_phrase_word_number[ global_maximum_words_in_phrase_name - global_phrase_word_number_to_check ] ;
        global_character_pointer_end_for_phrase_word_in_position[ global_phrase_word_number_to_check ] = global_position_begin_for_phrase_word_number[ global_maximum_words_in_phrase_name - ( global_phrase_word_number_to_check + 1 ) ] ;

//  array only used once:
        global_id_from_linked_list_number[ global_phrase_word_number_to_check ] = global_id_from_linked_list ;

        find_matching_phrase_word( ) ;
        global_id_for_phrase_word_at_position_number[ global_phrase_word_number_to_check ] = global_id_for_phrase_word ;
        if ( global_id_for_phrase_word > 0 )
        {
        	global_number_of_phrase_words_found ++ ;
        }
    }


// -----------------------------------------------
//  If not all the phrase words within the phrase
//  name were found, indicate the phrase name
//  cannot match any already-defined phrase name,
//  then return.

    if ( global_number_of_phrase_words_found < global_count_of_words_in_phrase_name )
    {
        global_found_matching_phrase_name = 0 ;
        return ;
    }


// -----------------------------------------------
//  Limit the search to the phrase names that have
//  the same number of phrase words.

    global_linked_list_grouping_id = global_id_for_list_of_phrase_names_of_length[ global_count_of_words_in_phrase_name ] ;

//  reminder: put zeros into global_id_for_list_of_phrase_names_of_length before adding any phrase names


// -----------------------------------------------
//  Begin a loop that searches each
//  already-defined phrase name.

    while ( 1 == 1 )
    {


// -----------------------------------------------
//  Point to the next already-defined phrase name.

        get_next_pointer_from_linked_list( ) ;
        log_out << "global_id_for_phrase_name " << global_id_for_phrase_name << std::endl ;


// -----------------------------------------------
//  If there are no more phrase names in the list,
//  return without a match.

//  todo: finish

        return ;


// -----------------------------------------------
//  Compare the text item ID numbers in the phrase
//  name to match and the ID numbers in the phrase
//  name being considered.  If any of the ID
//  numbers do not match, continue the search.

	    global_number_of_phrase_words_found = 0 ;
	    for ( global_phrase_word_number_to_check = 1 ; global_phrase_word_number_to_check <= global_count_of_words_in_phrase_name ; global_phrase_word_number_to_check ++ )
	    {
	        global_id_for_phrase_word = global_all_pointers_integers[ global_pointer_begin_for_item[ global_id_for_phrase_name ] + global_phrase_word_number_to_check - 1 ] ;
	        if ( global_id_for_phrase_word_at_position_number[ global_phrase_word_number_to_check ] != global_id_for_phrase_word )
	        {
	        	break ;
	        }
	        global_number_of_phrase_words_found ++ ;
	    }
	    if ( global_number_of_phrase_words_found < global_count_of_words_in_phrase_name )
	    {
	    	continue ;
	    }


// -----------------------------------------------
//  All the phrase words match, so use the text
//  item ID of the matching phrase word as the
//  pointer to the current phrase word.

// todo: finish ...

        global_yes_or_no_phrase_words_match = global_yes ;


// -----------------------------------------------
//  Repeat the loop to check the next phrase name.

    }


// -----------------------------------------------
//  End of function find_matching_phrase_name.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function scan_text_item_for_character_usage
//
//  This function scans the text item indicated by
//  "global_item_id" and counts how
//  many times each character appears within that
//  text.

void scan_text_item_for_character_usage( )
{


// -----------------------------------------------
//  Initialization.

    log_out << "global_item_id " << global_item_id << std::endl ;
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
//  "global_id_text_to_search" and copies
//  into the
//  "global_searched_usage_count_for_character"
//  array the character usage counts.

void scan_searched_text_before_doing_find_text( )
{
    global_item_id = global_id_text_to_search ;
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
    log_out << "global_item_id " << global_item_id << std::endl ;
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
    global_length_of_text_to_find = global_pointer_end_for_item[ global_id_from_origin ] - global_pointer_begin_for_item[ global_id_from_origin ] + 1 ;
    global_text_pointer = global_pointer_begin_for_item[ global_id_from_origin ] ;
    global_highest_score_for_optimum_character_for_find_pause = 0 ;
    for ( global_position_within_text_to_find = 1 ; global_position_within_text_to_find <= global_length_of_text_to_find ; global_position_within_text_to_find ++ )
    {
        global_possible_optimum_character_as_integer = global_all_pointers_integers[ global_text_pointer ] ;
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
//  item "global_id_text_to_find" is the text
//  to find.  The text item being searched is
//  ...

//  todo: proofread this code

void check_for_match_where_paused( )
{
    global_yes_or_no_matching_text = global_yes ;

    global_position_of_found_character_for_find_pause = global_recent_character_position_for_character_number[ global_optimum_character_for_find_pause ] ;
    global_character_distance_from_optimum_character_for_pause = 0 ;
    for ( global_text_pointer = global_pointer_end_for_item[ global_id_text_to_find ] ; global_text_pointer >= global_pointer_begin_for_item[ global_id_text_to_find ] ; global_text_pointer -- )
    {
        global_single_character_as_integer = global_all_characters[ global_text_pointer ] ;
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
//  match must be in "global_id_text_to_find"
//  The text to be searched must be in
//  "global_id_text_to_search" and that text
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

    global_id_from_origin = global_id_text_to_find ;
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
//  Function save_position_of_first_hyphen
//
//  This function saves the position at which the
//  first hyphen in a phrase name is encountered.

void save_position_of_first_hyphen( )
{
    global_pointer_to_first_hyphen = global_recent_character_position_for_character_number[ global_ascii_code_for_hyphen ] ;
    global_id_containing_first_hyphen = global_current_target_text_item ;
    global_character_pointer_within_text_item_for_first_hyphen = global_current_target_character_position ;
    global_pointer_to_leading_delimiter = global_recent_position_of_any_delimiter ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_phrase_name_when_at_trailing_delimiter
//
//  This function points to the phrase words in a
//  phrase name, based on the current position
//  being at the first delimiter that follows a
//  hyphen.  If the entire phrase name is not
//  within a single text item or is not specified
//  as a text item that contains a phrase name,
//  the phrase name is placed into a text item
//  that contains a phrase name.

void get_phrase_name_when_at_trailing_delimiter( )
{


// -----------------------------------------------
//  Calculate some distances using information
//  that is already available.

    global_length_of_first_phrase_word_minus_one = global_pointer_to_first_hyphen - global_pointer_to_leading_delimiter ;
    global_distance_from_first_hyphen_to_trailing_delimiter = global_recent_position_of_any_delimiter - global_pointer_to_first_hyphen ;


// -----------------------------------------------
//  If the entire phrase name is
//  not within the same text item as the delimiter
//  that follows the phrase name, indicate an
//  error for now, and later modify the code to
//  handle such other cases.

    if ( ( global_id_containing_first_hyphen == global_current_target_text_item ) && ( global_character_pointer_within_text_item_for_first_hyphen > global_length_of_first_phrase_word_minus_one ) && ( ( global_length_of_first_phrase_word_minus_one + global_distance_from_first_hyphen_to_trailing_delimiter ) <= ( global_pointer_end_for_item[ global_current_target_text_item ] - global_pointer_begin_for_item[ global_current_target_text_item ] ) ) )
    {
    	log_out << "phrase name not within single text item, so modify code to handle this kind of situation " << std::endl ;
    	exit( EXIT_FAILURE ) ;
    }


// -----------------------------------------------
//  If the phrase name is in a text item of the
//  type that contains a hyphenated phrase name,
//  indicate an error and the need to modify this
//  code.

    if ( global_category_for_item[ global_current_target_text_item ] == global_container_category_phrase_word_pointers )
    {
    	log_out << "phrase name is in a special hyphenated text item, so modify code to handle this kind of situation " << std::endl ;
    	exit( EXIT_FAILURE ) ;

    }




// -----------------------------------------------
//  End of get_phrase_name_when_at_trailing_delimiter.

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

    global_item_id = global_id_text_to_edit ;
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

        find_matching_phrase_name( ) ;


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
//  Function handle_directives
//
//  Handle the "hyphen-here" and "one-space" and
//  "no-space" directives.

void handle_directives( )
{

}


// -----------------------------------------------
// -----------------------------------------------
//  Function expand_text
//
//  Expands the text item indicated in
//  global_id_from_origin.

//  Local variables are used because this function
//  can be used recursively.

//  Currently being changed from Perl code to C.

void expand_text( )
{


// -----------------------------------------------
//  Declarations.

    int expand_endless_cycle_count_maximum ;
    int current_phrase_item_id ;
    int expand_result_item_id ;
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

    int expand_buffer_item_id ;



// -----------------------------------------------
//  Specify the text item being expanded.

    global_id_for_phrase_name_expand_text = global_id_text_to_edit ;


// -----------------------------------------------
//  Specify that when appending is done, the
//  "copied" version is used.

    global_yes_or_no_use_copy_when_appending = global_yes ;


// -----------------------------------------------
//  Initialization.

    global_item_id = expand_buffer_item_id ;
    text_item_clear( ) ;

// output_buffer = '' ;
    space_directive = global_space_directive_none ;
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

// code_at_recursion_level[ 1 ] = global_id_from_origin ;
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
// current_phrase_item_id = substr( code_at_recursion_level[ recursion_level ] , pointer_to_phrase_begin , ( pointer_to_phrase_end - pointer_to_phrase_begin + 1 ) ) ;


// -----------------------------------------------
// Check for an endless loop caused by the same
// phrase name being encountered too many times.
// If this occurs, exit the endless loop.

        if ( global_yes_or_no_count_phrase_usage == global_yes )
        {
// global_number_of_times_encountered_phrase_named{ current_phrase_item_id } ++ ;
// if ( global_number_of_times_encountered_phrase_named{ current_phrase_item_id } >= expand_endless_cycle_count_maximum ) {
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

        if ( current_phrase_item_id == global_id_for_phrase_name_hyphen_here )
        {
// output_buffer .= '-' ;
            space_directive = global_space_directive_none ;
            continue ;
        }
        if ( current_phrase_item_id == global_id_for_phrase_name_no_space )
        {
            if ( space_directive = global_space_directive_one_requested )
            {
                space_directive = global_space_directive_none ;
            }
            continue ;
        }
// if ( current_phrase_item_id eq ( '<' . 'no_space' . '>' ) ) {
            space_directive = global_space_directive_none ;
            continue ;
// }
        if ( current_phrase_item_id == global_id_for_phrase_name_one_space )
        {
            space_directive = global_space_directive_one_requested ;
            continue ;
        }
// if ( current_phrase_item_id eq ( '<' . 'one_space' . '>' ) ) {
            space_directive = global_space_directive_one_requested ;
            continue ;
// }
        if ( current_phrase_item_id == global_id_for_phrase_name_new_line )
        {
// output_buffer .= "\n" ;
            space_directive = global_space_directive_none ;
            continue ;
        }
// if ( current_phrase_item_id eq ( '<' . 'new_line' . '>' ) ) {
// output_buffer .= "\n" ;
            space_directive = global_space_directive_none ;
            continue ;
// }
        if ( current_phrase_item_id == global_id_for_phrase_name_empty_line )
        {
// output_buffer .= "\n\n" ;
            space_directive = global_space_directive_none ;
            continue ;
        }
// if ( current_phrase_item_id eq ( '<' . 'empty_line' . '>' ) ) {
// output_buffer .= "\n\n" ;
            space_directive = global_space_directive_none ;
            continue ;
// }


// -----------------------------------------------
//  If the phrase name has a definition (which can
//  be empty), and it is not a space directive or
//  line directive, insert phrase definition into
//  the text being expanded, and remove the phrase
//  name.

// if ( ( current_phrase_item_id =~ /[^ \-]\-[^ \-]/ ) && ( exists( global_dashrep_replacement{ current_phrase_item_id } ) ) ) {
            recursion_level ++ ;
// code_at_recursion_level[ recursion_level ] = global_dashrep_replacement{ current_phrase_item_id } ;
// length_of_code_at_recursion_level[ recursion_level ] = length( code_at_recursion_level[ recursion_level ] ) ;
// pointer_to_remainder_of_code_at_recursion_level[ recursion_level ] = 0 ;
            continue ;
// }


// -----------------------------------------------
//  If a space should be inserted here, insert it.
//  Specify a default of inserting one space after
//  the next phrase insertion.

        if ( ( space_directive == global_space_directive_one ) || ( space_directive == global_space_directive_one_requested ) )
        {
// output_buffer .= ' ' ;
        }
        space_directive = global_space_directive_one ;


// -----------------------------------------------
//  At this point the current text string is not
//  the name of a defined phrase, so just use the
//  text string.

// output_buffer .= current_phrase_item_id ;
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
            space_directive = global_space_directive_none ;
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
// expand_result_item_id .= output_buffer ;
// output_buffer = '' ;
// } elsif ( length( output_buffer ) > 1000 ) {
// expand_result_item_id .= substr( output_buffer , 0 , 500 ) ;
// output_buffer = substr( output_buffer , 500 ) ;
// }


// -----------------------------------------------
//  Repeat the loop that handles each space
//  delimited string.

    }


// -----------------------------------------------
//  Supply the results.

// expand_result_item_id .= output_buffer ;
// return: global_expand_result_item_id ;
    return ;


// -----------------------------------------------
//  End of function expand_text.

}


// -----------------------------------------------
// -----------------------------------------------
//  Function execute_loop_handler_based_on_handler_id

void execute_loop_handler_based_on_handler_id( int local_item_id_for_next_word , int local_loop_handler )
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
    int local_item_id_contains_word_list ;
    int local_item_id_for_next_word ;
    int local_loop_handler ;
    local_item_id_contains_word_list = global_id_from_origin ;
    initialize_point_to_next_word_in_text_item( ) ;
    while ( 1 == 1 )
    {
        point_to_next_word_in_text_item( ) ;
        if ( global_single_character_as_integer == 0 )
        {
            return ;
        }
        execute_loop_handler_based_on_handler_id( local_item_id_for_next_word , local_loop_handler ) ;
// ... handler-name-with-underscores ...
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Functions that call the above functions.
//  These are needed to match the use of functions
//  in the Perl version, but these will be
//  eliminated later.

int parameterized_use_handler_with_each_word_in_phrase( int local_item_id )
{
    global_id_from_origin = local_item_id ;
    implement_loop( ) ;
    int expand_result_item_id ;  // temporary, to avoid compiler error
    return expand_result_item_id ;
}

int parameterized_dashrep_expand_text( int local_item_id )
{
    global_id_from_origin = local_item_id ;
    expand_text( ) ;
    int expand_result_item_id ;  // temporary, to avoid compiler error
    return expand_result_item_id ;
}

void parameterized_append_text( int local_item_id )
{
    global_id_from_origin = local_item_id ;
    append_copied_text( ) ;
    return ;
}

void parameterized_get_phrase_definition( int local_to_item_id , int local_from_item_id )
{
    local_to_item_id = global_id_of_item_containing_definition_for_item[ local_from_item_id ] ;
    return ;
}

void parameterized_put_phrase_definition( int local_from_item_id , int local_to_item_id )
{
    global_id_of_item_containing_definition_for_item[ local_to_item_id ] = local_from_item_id ;
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

int parameterized_remove_leading_trailing_spaces( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;
    remove_leading_delimiters( ) ;
    remove_trailing_delimiters( ) ;
    return global_item_id ;
}

int parameterized_yes_or_no_empty( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;
    local_yes_or_no = check_yes_or_no_text_item_is_empty( ) ;
    return local_yes_or_no ;
}

int parameterized_yes_or_no_phrase_name( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_phrase_definition_not_empty( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = global_id_of_item_containing_definition_for_item[ local_item_id ] ;
    local_yes_or_no = check_yes_or_no_text_item_is_empty( ) ;
    return local_yes_or_no ;
}

int parameterized_yes_or_no_positive_integer( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_integer( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_positive_real_number( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_real_number( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_phrase_contains_real_numbers( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_normalize_calculated_value( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;

    return local_item_id ;
}

int parameterized_convert_numeric_text_into_numeric_value( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;

    return local_item_id ;
}

int parameterized_convert_numeric_value_into_numeric_text( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;

    return local_item_id ;
}

int parameterized_get_list_of_words( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;

    return local_item_id ;
}

int parameterized_yes_or_no_valid_url( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_valid_path( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_valid_path_prefix( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_file_name( int local_item_id )
{
    global_item_id = local_item_id ;
    initialize_parse_characters_of_filename( ) ;
    for ( global_text_pointer = global_pointer_begin_for_item[ global_id_from_origin ] ; global_text_pointer <= global_pointer_end_for_item[ global_id_from_origin ] ; global_text_pointer ++ )
    {
        global_character_category = global_all_pointers_integers[ global_text_pointer ] ;
        parse_one_character_of_filename( ) ;
        if ( ( global_yes_or_no_numeric_delimiter_encountered == global_yes ) || ( global_text_pointer == global_pointer_end_for_item[ global_id_from_origin ] ) )
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

int parameterized_yes_or_no_folder_name( int local_item_id )
{
//  The flag global_yes_or_no_use_slash_not_backslash
//  identifies whether slashes or backslashes are
//  allowed in folder names.
    global_item_id = local_item_id ;
    initialize_parse_characters_of_folder_name( ) ;
    for ( global_text_pointer = global_pointer_begin_for_item[ global_item_id ] ; global_text_pointer <= global_pointer_end_for_item[ global_item_id ] ; global_text_pointer ++ )
    {
        global_single_character_as_integer = global_all_characters[ global_text_pointer ] ;
        parse_one_character_of_folder_name( ) ;
        if ( ( global_yes_or_no_numeric_delimiter_encountered == global_yes ) || ( global_text_pointer == global_pointer_end_for_item[ global_item_id ] ) )
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

int parameterized_yes_or_no_input_file_exists( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_open_file_for_reading( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_open_file_for_appending( int local_item_id )
{
    int local_yes_or_no ;
    global_item_id = local_item_id ;

    return local_yes_or_no ;
}

void point_to_words( )
{

    return ;
}

void point_to_words_in_operand_one( )
{
    global_item_id = global_text_item_for_operand_one ;
    point_to_words( ) ;
    return ;
}

void point_to_words_in_operand_two( )
{
    global_item_id = global_text_item_for_operand_two ;
    point_to_words( ) ;
    return ;
}

void point_to_words_in_operand_three( )
{
    global_item_id = global_text_item_for_operand_three ;
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

//    global_id_from_origin = global_id_for_number_as_text ;
//    write_text_item_to_file( ) ;

//    log_out << "next test" << std::endl ;

    global_id_text_to_edit = global_id_for_sample_numbers ;
    remove_leading_and_trailing_delimiters( ) ;
    global_item_id = global_id_for_sample_numbers ;
    write_text_item_to_file( ) ;

//    global_id_from_origin = global_id_for_sample_numbers ;
//    global_id_text_to_edit = global_id_for_sample_numbers ;
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
