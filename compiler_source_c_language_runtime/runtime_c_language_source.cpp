// -----------------------------------------------
// -----------------------------------------------
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
//  IMPORTANT:
//  The names of local variables and arrays begin
//  with the text "local_".  All other variables
//  and arrays are GLOBAL variables and arrays!
//  An exception is that the standard names
//  "argv" and "argc" refer to local variables.


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
//  execution.  This speed increase occurs
//  because pushing and popping local
//  variables on and off the function stack wastes
//  time.
//
//  Also, this code does not check for "user" errors
//  because the Dashrep compiler does not "use"
//  this code in unexpected ways.  Any other uses
//  of this code are not supported.


// -----------------------------------------------
//  Declare constants "yes_yes" and "no_no".
//  They are used instead of "true" and "false"
//  values because true and false involve making
//  a claim that might be false, whereas asking a
//  question involves a "yes" or "no" answer.
//  Also, this convention matches earlier versions
//  of the Dashrep compiler in other programming
//  languages.

const int no_no = 0 ;
const int yes_yes = 1 ;


// -----------------------------------------------
//  Here is an overview of the data structure
//  that is explained in the sections below.

//  big storage arrays:
//    all_pointers
//    all_characters  (which holds all text)
//    all_integers
//    all_decimal_numbers

//  array that associates array category with data type:
//    storage_array_for_data_type

//  data_types (not arrays):
//    linked_list
//    text_characters
//    list_of_integers
//    list_of_decimal_numbers
//    phrase_word_pointers
//    switch_delimiter_to_underscore

//  item-specific arrays:
//    data_type_for_item
//    pointer_allocation_end_for_item
//    pointer_begin_for_item
//    pointer_end_for_item
//    pointer_to_definition_of_item

//  word-specific array:
//    position_begin_for_phrase_word_number

//  character-specific arrays:
//    character_pointer_begin_for_phrase_word_in_position
//    character_category_number_for_character_number
//    recent_character_position_for_character_number
//    usage_count_for_character
//    searched_usage_count_for_character

//  item-id-specific arrays:
//    id_for_list_of_phrase_words_of_length
//    id_for_list_of_phrase_names_of_length

//  constants (not arrays) for offsets within stack items:
//    offset_for_current_pointer_stack_level_text_item
//    offset_for_current_pointer_stack_level_character_position
//    offset_for_pointer_stack_level_top


// -----------------------------------------------
//  Declare the data types that can represent
//  text.  The data type of each item is stored in
//  the array "data_type_for_item".
//  A list (of any kind) can contain just one
//  item.
//
//  * "linked_list"
//    A linked list is a sequence of "segments"
//    where each "segment" is an item that has
//    an item ID.  A linked list can be
//    extended when more storage space is needed.
//    The first position in the item, if it is not
//    zero, points to the prior item in the same
//    linked list of pointers.  The last position
//    in the item, if it is not zero, points to
//    the next item in the same linked list of
//    pointers.  A zero value indicates there is
//    not a prior or next item in the linked list.
//    Linked lists are stored in the array
//    "all_pointers".
//
//    Text characters are NOT stored in linked
//    lists.  Instead, text consists of a linked
//    list that points to "text_characters" items,
//    which are explained below.
//
//    Or a linked list can point to other linked
//    lists, which means this pointing can be
//    recursive, which means a list of pointers
//    can point to yet other linked lists of
//    pointers, and the final pointers point to
//    items of the "text_characters" type.
//
//    "Indexed list" is a special use of the
//    "linked_list" data type.  In this case the
//    linked list acts as an array that can be
//    indexed by position.  The resulting array
//    can be extended as needed, without knowing
//    in advance how long the array will be.
//
//    "Pointer stack level" is a special use of
//    the "linked_list" data type.  In this
//    case each "linked_list" segment is one
//    level in the stack, and each segment has
//    three pointers (besides the "prior" and
//    "next" pointers):  a pointer to the item at
//    that stack level, a character pointer to
//    the position within that item at that ID,
//    and a pointer to the top item in the stack.
//    The pointer to the top item is only
//    significant at the lowest stack level,
//    where the "prior" pointer is zero.  The
//    offsets for these three pointers are named
//    to begin with the text "offset_for_".
//
//  * "text_characters"
//    A sequence of text characters.  Each
//    character is stored as an integer, which is
//    usually a Unicode character, which means
//    that Chinese characters are supported.
//    These characters are stored in the array
//    "all_characters".
//
//  * "list_of_decimal_numbers"
//    A list of decimal numbers -- which includes the
//    possibility of being a single decimal number.
//    The decimal numbers are stored in the array
//    "all_decimal_numbers".  Each
//    adjacent pair of numbers is assumed to be
//    separated by one space, without explicitly
//    storing those spaces.  This data type
//    increases speed by reducing the need to
//    convert between text type and "float" type
//    every time decimal-number calculations are
//    done.
//
//  * "list_of_integers"
//    A list of integers -- which includes the
//    possibility of being a single integer.  The
//    integers are stored in the array named
//    "all_integers".  Adjacent pairs of
//    integers are assumed to be separated by one
//    space, without explicitly storing the
//    spaces.  This data type increases speed by
//    reducing conversions between text type and
//    integers.
//
//  * "phrase_word_pointers"
//    A list of item IDs that only point to
//    "phrase_word" text items.  A phrase word
//    text item is a "text_characters" data type that
//    has added significance because it is a
//    single word -- with no delimiter -- and the
//    word is used in at least one phrase name.
//    The list of phrase word pointers results in
//    a valid phrase name -- which is not
//    necessarily a defined phrase name.  Each
//    adjacent pair of words is assumed to be
//    separated by one hyphen, without explicitly
//    storing those hyphens.  Each of the linked
//    words must be the same text item as used in
//    any other hyphenated phrase name that
//    includes that same word.  This convention
//    allows searching for a phrase name just by
//    looking at the item IDs of the words in
//    the phrase name.  Note that this convention
//    does not allow a leading or trailing hyphen,
//    and does not allow two or more adjacent
//    hyphens.  These pointers are stored in the
//    array "all_pointers".
//
//  * "switch_delimiter_to_underscore"
//    A single pointer to one item of data type
//    "phrase_word_pointers" for the purpose of
//    changing the delimiter from a hyphen to an
//    underscore.  This extra layer allows a
//    phrase name to also represent an underscored
//    version for places where angle brackets
//    enclose the underscored version.  For
//    example, "<character_hyphen>" can be
//    represented as a list of pointers that point
//    to three items:  (1) a text character item
//    that contains only "<", (2) a
//    "switch delimiter to underscore" item that,
//    in turn, points to the list of phrase words
//    "character" and "hyphen", and (3) a text
//    character item that contains only ">".
//    These pointers are stored in the array
//    "all_pointers".

const int data_type_linked_list = 1 ;
const int data_type_text_characters = 2 ;
const int data_type_list_of_integers = 3 ;
const int data_type_list_of_decimal_numbers = 4 ;
const int data_type_phrase_word_pointers = 5 ;

// todo: implement:
const int data_type_switch_delimiter_to_underscore = 6 ;


// -----------------------------------------------
//  Declare constants that identify the four
//  storage arrays.

const int storage_array_all_pointers = 1 ;
const int storage_array_all_characters = 2 ;
const int storage_array_all_integers = 3 ;
const int storage_array_all_decimal_numbers = 4 ;


// -----------------------------------------------
//  Declare an array that specifies which storage
//  array is used to store each data type.

const int maximum_data_type = 10 ;
int storage_array_for_data_type[ 15 ] ;


// -----------------------------------------------
//  Declare access flags.  These values are in the
//  array "access_flag_for_item".

const int access_flag_no_changes = 1 ;
const int access_flag_can_change = 2 ;


// -----------------------------------------------
//  The characters are stored as INTEGERS, not as
//  bytes!  This supports Chinese characters.

unsigned int all_characters[ 100000 ] ;


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

const int length_of_lists_for_items = 20000 ;
int all_pointers[ 20005 ] ;
int data_type_for_item[ 20005 ] ;
int pointer_begin_for_item[ 20005 ] ;
int pointer_end_for_item[ 20005 ] ;
int pointer_allocation_end_for_item[ 20005 ] ;
int pointer_to_definition_of_item[ 20005 ] ;
int access_flag_for_item[ 20005 ] ;

const int maximum_words_in_phrase_name = 30 ;
int id_for_list_of_phrase_names_of_length[ 32 ] ;

const int maximum_length_of_phrase_word = 40 ;
int id_for_list_of_phrase_words_of_length[ 42 ] ;

const int length_of_list_of_character_numbers = 256 ;
int character_category_number_for_character_number[ 260 ] ;


// -----------------------------------------------
//  Declare lists for which the compiler does not
//  supply initial values.
//
//  Reminder:  The unicode number for a space is 32,
//  and the last printable ascii character is 125.

int all_integers[ 20005 ] ;

const int minimum_usage_character_to_consider = 32 ;
const int maximum_usage_character_to_consider = 125 ;
int usage_count_for_character[ 155 ] ;
int searched_usage_count_for_character[ 155 ] ;

//  length_of_list_of_character_numbers indicates maximum
int recent_character_position_for_character_number[ 260 ] ;

//  maximum_words_in_phrase_name is maximum size
int character_pointer_begin_for_phrase_word_in_position[ 32 ] ;
int character_pointer_end_for_phrase_word_in_position[ 32 ] ;
int position_begin_for_phrase_word_number[ 32 ] ;

//  avoid conflict with variable name "id_for_phrase_word_number"
int id_for_phrase_word_at_position_number[ 32 ] ;


// -----------------------------------------------
//  Declare "char" variables, and a C++ "string"
//  variable.  These are used for input from, and
//  output to, files.  Also they may be used with
//  the C-language "sprintf" function.

char c_format_string[ 50 ] ;
char c_format_single_character ;
char this_word[ 205 ] ;
std::string cplusplus_string ;


// -----------------------------------------------
//  Declare the list and variables that hold
//  decimal numbers.

float all_decimal_numbers[ 2005 ] ;
float single_decimal_number ;
const float pi = 245850922 / 78256779 ;


// -----------------------------------------------
//  Declare constants.

const int allocated_length_for_file_input_or_output = 2000 ;
const int allocated_length_for_this_word = 200 ;
const int unicode_for_ampersand = 38 ;
const int unicode_for_apostrophe = 39 ;
const int unicode_for_asterisk = 42 ;
const int unicode_for_at_sign = 64 ;
const int unicode_for_backslash = 92 ;
const int unicode_for_caret = 94 ;
const int unicode_for_carriage_return = 13 ;
const int unicode_for_close_angle_bracket = 62 ;
const int unicode_for_comma = 44 ;
const int unicode_for_digit_0 = 48 ;
const int unicode_for_digit_1 = 49 ;
const int unicode_for_digit_2 = 50 ;
const int unicode_for_digit_3 = 51 ;
const int unicode_for_digit_4 = 52 ;
const int unicode_for_digit_5 = 53 ;
const int unicode_for_digit_6 = 54 ;
const int unicode_for_digit_7 = 55 ;
const int unicode_for_digit_8 = 56 ;
const int unicode_for_digit_9 = 57 ;
const int unicode_for_exclamation_point = 33 ;
const int unicode_for_formfeed = 12 ;
const int unicode_for_grave_accent = 96 ;
const int unicode_for_hyphen = 45 ;
const int unicode_for_left_curly_bracket = 123 ;
const int unicode_for_left_parenthesis = 40 ;
const int unicode_for_left_square_bracket = 91 ;
const int unicode_for_newline = 10 ;
const int unicode_for_open_angle_bracket = 60 ;
const int unicode_for_percent = 37 ;
const int unicode_for_period = 46 ;
const int unicode_for_plus = 43 ;
const int unicode_for_pound_sign = 35 ;
const int unicode_for_question_mark = 63 ;
const int unicode_for_quotation_mark = 34 ;
const int unicode_for_right_curly_bracket = 125 ;
const int unicode_for_right_parenthesis = 41 ;
const int unicode_for_right_square_bracket = 93 ;
const int unicode_for_slash = 47 ;
const int unicode_for_space = 32 ;
const int unicode_for_tab = 9 ;
const int unicode_for_tilde = 126 ;
const int unicode_for_underscore = 95 ;
const int unicode_for_vertical_bar = 124 ;
const int character_category_apostrophe = 39 ;  // also single quotation mark
const int character_category_backslash = 92 ;
const int character_category_close_angle_bracket = 62 ;
const int character_category_digit = 57 ;  // 0 through 9
const int character_category_empty = 0 ;
const int character_category_hyphen = 45 ;  // also used as minus sign
const int character_category_newline = 10 ;
const int character_category_open_angle_bracket = 60 ;
const int character_category_other = 1 ;
const int character_category_period = 46 ;  // also used as decimal point
const int character_category_plus_sign = 43 ;
const int character_category_quotation_mark = 34 ;  // double quotation mark
const int character_category_slash = 47 ;
const int character_category_space = 32 ;
const int character_category_symbol = 3 ;
const int character_category_tab = 9 ;
const int character_category_underscore = 95 ;
const int default_length_for_text_item = 25 ;
const int direction_next = 1 ;
const int direction_previous = 2 ;
const int offset_for_current_pointer_stack_level_character_position = 2 ;
const int offset_for_current_pointer_stack_level_text_item = 1 ;
const int offset_for_pointer_stack_level_top = 3 ;
const int space_directive_none = 1 ;
const int space_directive_one = 2 ;
const int space_directive_one_requested = 3 ;


// -----------------------------------------------
//  Declare variables in alphabetical order.

//  sort these new ones later:
int pointer ;
int id_for_pointer_stack_being_followed ;
int new_current_pointer_stack_text_item ;
int count_of_numbers_supplied_to_array_all_characters ;
int count_of_numbers_supplied_to_array_all_pointers ;
int count_of_numbers_supplied_to_array_all_integers ;
int count_of_numbers_supplied_to_array_all_decimal_numbers ;
int number_to_put_into_indexed_list ;
int indexed_list_position_desired ;
int position_within_indexed_list ;
int indexed_list_index_current ;
int indexed_list_segment_begin ;
int indexed_list_segment_end ;
int length_of_segment_within_indexed_list ;
int offset_for_pointer_stack_level_prior ;
int offset_for_pointer_stack_level_next ;
int next_segment_id_for_linked_list ;
int not_enough_space ;
int item_id_origin ;
int current_pointer_to_append ;
int id_pointer ;
int number_to_append ;


int access_flag ;
int allocation_begin ;
int character_begin_pointer_one ;
int character_begin_pointer_two ;
int character_category ;
int character_count ;
int character_count_for_expand_text ;
int character_distance_from_optimum_character_for_pause ;
int character_end_pointer_one ;
int character_end_pointer_two ;
int character_insertion_count ;
int character_length ;
int character_length_minus_one ;
int character_length_of_phrase_word ;
int character_length_of_phrase_word_minus_one ;
int character_offset ;
int character_pointer ;
int character_pointer_current ;
int character_pointer_end ;
int character_pointer_begin_for_number ;
int character_pointer_begin_for_text_one ;
int character_pointer_begin_for_text_two ;
int character_pointer_for_phrase_word_current ;
int character_pointer_for_text_item ;
int character_pointer_one ;
int character_pointer_two ;
int character_pointer_within_text_item_for_first_hyphen ;
int character_position_in_phrase_name ;
int character_to_insert_between_subitems ;
int check_for_match_item_id ;
int check_from_begin ;
int check_from_begin_or_check_from_end ;
int check_from_end ;
int data_type ;
int count_of_characters_remaining_in_item ;
int count_of_words_handled ;
int count_of_words_in_phrase_name ;
int counter ;
int current_pointer_stack_character_position ;
int current_pointer_stack_text_item ;
int current_pointer_stack_text_item_begin ;
int current_pointer_stack_text_item_end ;
int decimal_number_divisor ;
int decimal_number_position_begin ;
int decimal_number_position_current ;
int decimal_number_position_end ;
int defined_phrase_number ;
int direction_next_or_previous ;
int direction_opposite ;
int length_from_item_begin_to_end_minus_one ;
int distance_from_first_hyphen_to_trailing_delimiter ;
int do_nothing ;
int found_matching_phrase_name ;
int from_text_data_type ;
int highest_score_for_optimum_character_for_find_pause ;
int id_containing_first_hyphen ;
int id_for_copy ;
int id_text_pointer_for_copy ;
int id_for_character_position ;
int id_for_decimal_numbers_as_text ;
int id_for_empty_text ;
int id_for_file_input ;
int id_for_file_output ;
int id_for_float_as_text ;
int id_for_four_hyphens ;
int id_for_integers_as_text ;
int id_for_list_of_integers ;
int id_for_next_word ;
int id_for_next_word_begin ;
int id_for_next_word_end ;
int id_for_non_breaking_space ;
int id_for_number_as_text ;
int id_text_pointer_for_original ;
int id_for_phrase_name_append_multiple_from_phrases_named_in_pattern ;
int id_for_phrase_name_append_new_line ;
int id_for_phrase_name_append_repeatedly_using_count ;
int id_for_phrase_name_append_text ;
int id_for_phrase_name_append_text_no_space ;
int id_for_phrase_name_character_hyphen ;
int id_for_phrase_name_character_newline ;
int id_for_phrase_name_character_space ;
int id_for_phrase_name_character_tab ;
int id_for_phrase_name_character_underscore ;
int id_for_phrase_name_clear_listed_phrases ;
int id_for_phrase_name_clear_phrase ;
int id_for_phrase_name_convert_unicode_to_html_entities ;
int id_for_phrase_name_copy_and_move_attributes_into_xml_tags ;
int id_for_phrase_name_copy_and_remove_attributes_from_xml_tags ;
int id_for_phrase_name_copy_and_replace ;
int id_for_phrase_name_copy_and_replace_using_paired_listed_words ;
int id_for_phrase_name_copy_append_file_to_file ;
int id_for_phrase_name_copy_characters_from_position_to_position ;
int id_for_phrase_name_copy_from_columns_in_file_to_column_lists ;
int id_for_phrase_name_copy_from_columns_in_file_to_named_phrases ;
int id_for_phrase_name_copy_from_file_to_phrase ;
int id_for_phrase_name_copy_from_phrase_append_to_file ;
int id_for_phrase_name_copy_initial_caps ;
int id_for_phrase_name_copy_listed_words_to_phrases_named_in_pattern ;
int id_for_phrase_name_copy_lowercase_only ;
int id_for_phrase_name_copy_text ;
int id_for_phrase_name_copy_uppercase_only ;
int id_for_phrase_name_copy_without_extra_spaces ;
int id_for_phrase_name_copy_word_at_position ;
int id_for_phrase_name_copy_words_found_in_both_lists ;
int id_for_phrase_name_copy_words_found_in_either_list ;
int id_for_phrase_name_copy_words_found_only_in_first_list ;
int id_for_phrase_name_copy_words_from_position_to_position ;
int id_for_phrase_name_copy_words_offset_skip ;
int id_for_phrase_name_copy_words_order_reversed ;
int id_for_phrase_name_copy_words_rearrange_using_order_sort_alphabetic ;
int id_for_phrase_name_copy_words_rearrange_using_order_sort_numeric ;
int id_for_phrase_name_copy_words_sort_alphabetic ;
int id_for_phrase_name_copy_words_sort_numeric ;
int id_for_phrase_name_copy_words_that_begin_with_listed_words ;
int id_for_phrase_name_copy_words_that_begin_with_text ;
int id_for_phrase_name_copy_words_that_contain_listed_words ;
int id_for_phrase_name_copy_words_unique_only ;
int id_for_phrase_name_copy_zero_pad_left_to_length ;
int id_for_phrase_name_create_empty_sub_folder ;
int id_for_phrase_name_dashrep_comments_ignored ;
int id_for_phrase_name_dashrep_endless_loop_counter_limit ;
int id_for_phrase_name_dashrep_file_name_if_read_file_missing ;
int id_for_phrase_name_dashrep_gather_tag_begin ;
int id_for_phrase_name_dashrep_gather_tag_delete ;
int id_for_phrase_name_dashrep_gather_tag_end ;
int id_for_phrase_name_dashrep_gather_tag_matching_id ;
int id_for_phrase_name_dashrep_gather_tag_unique ;
int id_for_phrase_name_dashrep_language_yes ;
int id_for_phrase_name_dashrep_path_prefix_for_file_reading ;
int id_for_phrase_name_dashrep_path_prefix_for_file_writing ;
int id_for_phrase_name_dashrep_time_limit ;
int id_for_phrase_name_dashrep_version ;
int id_for_phrase_name_decode_from_cgi_parameter ;
int id_for_phrase_name_delayed_newline ;
int id_for_phrase_name_delayed_nospace ;
int id_for_phrase_name_delete_file ;
int id_for_phrase_name_delete_listed_phrases ;
int id_for_phrase_name_empty_line ;
int id_for_phrase_name_empty_text ;
int id_for_phrase_name_encode_as_cgi_parameter ;
int id_for_phrase_name_end_of_line_indicator ;
int id_for_phrase_name_exit_from_dashrep ;
int id_for_phrase_name_expand_text ;
int id_for_phrase_name_find_line_in_file_that_begins_with_text ;
int id_for_phrase_name_find_lines_in_file_that_begin_with_any_listed_word ;
int id_for_phrase_name_find_lines_in_file_that_begin_with_any_two_words_listed ;
int id_for_phrase_name_four_hyphens ;
int id_for_phrase_name_gather_from_tagged_file_one_entry ;
int id_for_phrase_name_gather_tagged_info_from_file ;
int id_for_phrase_name_generate_counts_from_integer_to_integer ;
int id_for_phrase_name_generate_every_ordered_pairwise_combination_of_words ;
int id_for_phrase_name_generate_every_pairwise_combination_of_words ;
int id_for_phrase_name_generate_list_of_all_dashrep_phrases ;
int id_for_phrase_name_generate_list_of_files_in_current_read_directory ;
int id_for_phrase_name_generate_list_of_folders_in_current_read_directory ;
int id_for_phrase_name_generate_phrase_usage_counts ;
int id_for_phrase_name_generate_positions_of_delimiter ;
int id_for_phrase_name_generate_positions_of_first_matching_delimiter_after_listed_positions ;
int id_for_phrase_name_generate_positions_of_listed_words ;
int id_for_phrase_name_get_cgi_information ;
int id_for_phrase_name_get_characters_from_position_to_position ;
int id_for_phrase_name_get_count_of_characters ;
int id_for_phrase_name_get_count_of_words ;
int id_for_phrase_name_get_current_time_in_epoch_seconds ;
int id_for_phrase_name_get_definitions_from_phrase ;
int id_for_phrase_name_get_phrase_name_from_phrase ;
int id_for_phrase_name_get_position_of_matching_text ;
int id_for_phrase_name_get_position_of_word ;
int id_for_phrase_name_get_url_resource ;
int id_for_phrase_name_get_word_at_position ;
int id_for_phrase_name_hyphen_here ;
int id_for_phrase_name_if_else ;
int id_for_phrase_name_if_end ;
int id_for_phrase_name_if_no_begin ;
int id_for_phrase_name_if_yes_begin ;
int id_for_phrase_name_line_break ;
int id_for_phrase_name_linewise_input_line_count ;
int id_for_phrase_name_linewise_input_line_from_file ;
int id_for_phrase_name_linewise_read_from_file_and_use_handler ;
int id_for_phrase_name_linewise_read_from_standard_input ;
int id_for_phrase_name_list_of_pointers_to_unique_words ;
int id_for_phrase_name_list_of_unique_word_counts ;
int id_for_phrase_name_modification_time_of_file ;
int id_for_phrase_name_new_line ;
int id_for_phrase_name_no_if_any_no ;
int id_for_phrase_name_no_if_not_yes ;
int id_for_phrase_name_no_space ;
int id_for_phrase_name_non_breaking_space ;
int id_for_phrase_name_numeric_absolute ;
int id_for_phrase_name_numeric_add ;
int id_for_phrase_name_numeric_cosine ;
int id_for_phrase_name_numeric_decrement ;
int id_for_phrase_name_numeric_divide_by ;
int id_for_phrase_name_numeric_equal_greater_less_compare ;
int id_for_phrase_name_numeric_increment ;
int id_for_phrase_name_numeric_integer ;
int id_for_phrase_name_numeric_logarithm_base_10 ;
int id_for_phrase_name_numeric_logarithm_base_e ;
int id_for_phrase_name_numeric_map_tile_zoom ;
int id_for_phrase_name_numeric_maximum ;
int id_for_phrase_name_numeric_minimum ;
int id_for_phrase_name_numeric_minus ;
int id_for_phrase_name_numeric_multiply ;
int id_for_phrase_name_numeric_odd_or_even ;
int id_for_phrase_name_numeric_pi ;
int id_for_phrase_name_numeric_sine ;
int id_for_phrase_name_numeric_square_root ;
int id_for_phrase_name_numeric_two_dimensional_sort_into_columns_and_rows ;
int id_for_phrase_name_numeric_vector_absolutes ;
int id_for_phrase_name_numeric_vector_add_number ;
int id_for_phrase_name_numeric_vector_integers ;
int id_for_phrase_name_numeric_vector_multiply_by_number ;
int id_for_phrase_name_numeric_vectors_add ;
int id_for_phrase_name_numeric_vectors_divide_by ;
int id_for_phrase_name_numeric_vectors_from_delta_values_calculate_distances ;
int id_for_phrase_name_numeric_vectors_multiply ;
int id_for_phrase_name_numeric_y_map_tile_number_based_on_latitude ;
int id_for_phrase_name_one_space ;
int id_for_phrase_name_operating_system_slash_or_backslash ;
int id_for_phrase_name_output_trace_file_name ;
int id_for_phrase_name_placeholder_for_empty_line ;
int id_for_phrase_name_placeholder_for_hyphen_here ;
int id_for_phrase_name_placeholder_for_new_line ;
int id_for_phrase_name_prepend_text ;
int id_for_phrase_name_prepend_text_no_space ;
int id_for_phrase_name_put_into_phrase ;
int id_for_phrase_name_put_listed_phrase_definitions_into_phrase ;
int id_for_phrase_name_rename_file ;
int id_for_phrase_name_set_file_permission_private ;
int id_for_phrase_name_set_file_permission_private_but_executable ;
int id_for_phrase_name_set_file_permission_public_read ;
int id_for_phrase_name_size_of_file ;
int id_for_phrase_name_split_epoch_seconds_into_named_components ;
int id_for_phrase_name_split_epoch_seconds_into_named_components_for_zero_meridian ;
int id_for_phrase_name_standard_output ;
int id_for_phrase_name_text_end_of_line_here_space_delimited ;
int id_for_phrase_name_time_day_of_month ;
int id_for_phrase_name_time_day_of_week ;
int id_for_phrase_name_time_day_of_year ;
int id_for_phrase_name_time_hour ;
int id_for_phrase_name_time_minute ;
int id_for_phrase_name_time_month_number ;
int id_for_phrase_name_time_second ;
int id_for_phrase_name_time_year ;
int id_for_phrase_name_trace_from_get_url_resource ;
int id_for_phrase_name_trace_show ;
int id_for_phrase_name_trace_show_where ;
int id_for_phrase_name_use_handler_with_each_word_in_phrase ;
int id_for_phrase_name_word_to_use_in_handler ;
int id_for_phrase_name_write_gathered_listed_items_to_end_of_file ;
int id_for_phrase_name_yes_if_all_yes ;
int id_for_phrase_name_yes_if_any_yes ;
int id_for_phrase_name_yes_if_not_no ;
int id_for_phrase_name_yes_or_no_empty_phrase ;
int id_for_phrase_name_yes_or_no_file_exists ;
int id_for_phrase_name_yes_or_no_folder_exists ;
int id_for_phrase_name_yes_or_no_opposite ;
int id_for_phrase_name_yes_or_no_permission_administrator ;
int id_for_phrase_name_yes_or_no_permission_to_append_to_files ;
int id_for_phrase_name_yes_or_no_permission_to_delete_or_overwrite_files ;
int id_for_phrase_name_yes_or_no_same_two_phrase_definitions ;
int id_for_phrase_name_yes_or_no_same_two_words ;
int id_for_phrase_name_yes_or_no_skip_empty_lines_when_copy_from_file ;
int id_for_phrase_name_yes_or_no_trim_spaces_when_copy_from_file ;
int id_for_phrase_name_yes_or_no_use_two_spaces_as_column_delimiter ;
int id_for_phrase_name_zero_one_multiple ;
int id_for_phrase_name_zero_or_nonzero ;
int id_for_phrase_word_10 ;
int id_for_phrase_word_absolute ;
int id_for_phrase_word_absolutes ;
int id_for_phrase_word_add ;
int id_for_phrase_word_administrator ;
int id_for_phrase_word_after ;
int id_for_phrase_word_all ;
int id_for_phrase_word_alphabetic ;
int id_for_phrase_word_and ;
int id_for_phrase_word_any ;
int id_for_phrase_word_append ;
int id_for_phrase_word_as ;
int id_for_phrase_word_at ;
int id_for_phrase_word_attributes ;
int id_for_phrase_word_backslash ;
int id_for_phrase_word_base ;
int id_for_phrase_word_based ;
int id_for_phrase_word_begin ;
int id_for_phrase_word_begins ;
int id_for_phrase_word_both ;
int id_for_phrase_word_break ;
int id_for_phrase_word_breaking ;
int id_for_phrase_word_but ;
int id_for_phrase_word_by ;
int id_for_phrase_word_calculate ;
int id_for_phrase_word_caps ;
int id_for_phrase_word_cgi ;
int id_for_phrase_word_character ;
int id_for_phrase_word_characters ;
int id_for_phrase_word_clear ;
int id_for_phrase_word_column ;
int id_for_phrase_word_columns ;
int id_for_phrase_word_combination ;
int id_for_phrase_word_comments ;
int id_for_phrase_word_compare ;
int id_for_phrase_word_components ;
int id_for_phrase_word_contain ;
int id_for_phrase_word_convert ;
int id_for_phrase_word_copy ;
int id_for_phrase_word_cosine ;
int id_for_phrase_word_count ;
int id_for_phrase_word_counter ;
int id_for_phrase_word_counts ;
int id_for_phrase_word_create ;
int id_for_phrase_word_current ;
int id_for_phrase_word_dashrep ;
int id_for_phrase_word_day ;
int id_for_phrase_word_decode ;
int id_for_phrase_word_decrement ;
int id_for_phrase_word_definitions ;
int id_for_phrase_word_delayed ;
int id_for_phrase_word_delete ;
int id_for_phrase_word_delimited ;
int id_for_phrase_word_delimiter ;
int id_for_phrase_word_delta ;
int id_for_phrase_word_dimensional ;
int id_for_phrase_word_directory ;
int id_for_phrase_word_distances ;
int id_for_phrase_word_divide ;
int id_for_phrase_word_e ;
int id_for_phrase_word_each ;
int id_for_phrase_word_either ;
int id_for_phrase_word_else ;
int id_for_phrase_word_empty ;
int id_for_phrase_word_encode ;
int id_for_phrase_word_end ;
int id_for_phrase_word_endless ;
int id_for_phrase_word_entities ;
int id_for_phrase_word_entry ;
int id_for_phrase_word_epoch ;
int id_for_phrase_word_equal ;
int id_for_phrase_word_even ;
int id_for_phrase_word_every ;
int id_for_phrase_word_executable ;
int id_for_phrase_word_exists ;
int id_for_phrase_word_exit ;
int id_for_phrase_word_expand ;
int id_for_phrase_word_extra ;
int id_for_phrase_word_file ;
int id_for_phrase_word_files ;
int id_for_phrase_word_find ;
int id_for_phrase_word_first ;
int id_for_phrase_word_folder ;
int id_for_phrase_word_folders ;
int id_for_phrase_word_for ;
int id_for_phrase_word_found ;
int id_for_phrase_word_four ;
int id_for_phrase_word_from ;
int id_for_phrase_word_gather ;
int id_for_phrase_word_gathered ;
int id_for_phrase_word_generate ;
int id_for_phrase_word_get ;
int id_for_phrase_word_greater ;
int id_for_phrase_word_handler ;
int id_for_phrase_word_here ;
int id_for_phrase_word_hour ;
int id_for_phrase_word_html ;
int id_for_phrase_word_hyphen ;
int id_for_phrase_word_hyphens ;
int id_for_phrase_word_id ;
int id_for_phrase_word_if ;
int id_for_phrase_word_ignored ;
int id_for_phrase_word_in ;
int id_for_phrase_word_increment ;
int id_for_phrase_word_indicator ;
int id_for_phrase_word_info ;
int id_for_phrase_word_information ;
int id_for_phrase_word_initial ;
int id_for_phrase_word_input ;
int id_for_phrase_word_integer ;
int id_for_phrase_word_integers ;
int id_for_phrase_word_into ;
int id_for_phrase_word_items ;
int id_for_phrase_word_language ;
int id_for_phrase_word_latitude ;
int id_for_phrase_word_left ;
int id_for_phrase_word_length ;
int id_for_phrase_word_less ;
int id_for_phrase_word_limit ;
int id_for_phrase_word_line ;
int id_for_phrase_word_lines ;
int id_for_phrase_word_linewise ;
int id_for_phrase_word_list ;
int id_for_phrase_word_listed ;
int id_for_phrase_word_lists ;
int id_for_phrase_word_logarithm ;
int id_for_phrase_word_loop ;
int id_for_phrase_word_lowercase ;
int id_for_phrase_word_map ;
int id_for_phrase_word_matching ;
int id_for_phrase_word_maximum ;
int id_for_phrase_word_meridian ;
int id_for_phrase_word_minimum ;
int id_for_phrase_word_minus ;
int id_for_phrase_word_minute ;
int id_for_phrase_word_missing ;
int id_for_phrase_word_modification ;
int id_for_phrase_word_month ;
int id_for_phrase_word_move ;
int id_for_phrase_word_multiple ;
int id_for_phrase_word_multiply ;
int id_for_phrase_word_name ;
int id_for_phrase_word_named ;
int id_for_phrase_word_new ;
int id_for_phrase_word_newline ;
int id_for_phrase_word_no ;
int id_for_phrase_word_non ;
int id_for_phrase_word_nonzero ;
int id_for_phrase_word_nospace ;
int id_for_phrase_word_not ;
int id_for_phrase_word_number ;
int id_for_phrase_word_numeric ;
int id_for_phrase_word_odd ;
int id_for_phrase_word_of ;
int id_for_phrase_word_offset ;
int id_for_phrase_word_on ;
int id_for_phrase_word_one ;
int id_for_phrase_word_only ;
int id_for_phrase_word_operating ;
int id_for_phrase_word_opposite ;
int id_for_phrase_word_or ;
int id_for_phrase_word_order ;
int id_for_phrase_word_ordered ;
int id_for_phrase_word_output ;
int id_for_phrase_word_overwrite ;
int id_for_phrase_word_pad ;
int id_for_phrase_word_paired ;
int id_for_phrase_word_pairwise ;
int id_for_phrase_word_parameter ;
int id_for_phrase_word_path ;
int id_for_phrase_word_pattern ;
int id_for_phrase_word_permission ;
int id_for_phrase_word_phrase ;
int id_for_phrase_word_phrases ;
int id_for_phrase_word_pi ;
int id_for_phrase_word_placeholder ;
int id_for_phrase_word_pointers ;
int id_for_phrase_word_position ;
int id_for_phrase_word_positions ;
int id_for_phrase_word_prefix ;
int id_for_phrase_word_prepend ;
int id_for_phrase_word_private ;
int id_for_phrase_word_public ;
int id_for_phrase_word_put ;
int id_for_phrase_word_read ;
int id_for_phrase_word_reading ;
int id_for_phrase_word_rearrange ;
int id_for_phrase_word_remove ;
int id_for_phrase_word_rename ;
int id_for_phrase_word_repeatedly ;
int id_for_phrase_word_replace ;
int id_for_phrase_word_resource ;
int id_for_phrase_word_reversed ;
int id_for_phrase_word_root ;
int id_for_phrase_word_rows ;
int id_for_phrase_word_same ;
int id_for_phrase_word_second ;
int id_for_phrase_word_seconds ;
int id_for_phrase_word_set ;
int id_for_phrase_word_show ;
int id_for_phrase_word_sine ;
int id_for_phrase_word_size ;
int id_for_phrase_word_skip ;
int id_for_phrase_word_slash ;
int id_for_phrase_word_sort ;
int id_for_phrase_word_space ;
int id_for_phrase_word_spaces ;
int id_for_phrase_word_split ;
int id_for_phrase_word_square ;
int id_for_phrase_word_standard ;
int id_for_phrase_word_sub ;
int id_for_phrase_word_system ;
int id_for_phrase_word_tab ;
int id_for_phrase_word_tag ;
int id_for_phrase_word_tagged ;
int id_for_phrase_word_tags ;
int id_for_phrase_word_text ;
int id_for_phrase_word_that ;
int id_for_phrase_word_tile ;
int id_for_phrase_word_time ;
int id_for_phrase_word_to ;
int id_for_phrase_word_trace ;
int id_for_phrase_word_trim ;
int id_for_phrase_word_two ;
int id_for_phrase_word_underscore ;
int id_for_phrase_word_unicode ;
int id_for_phrase_word_unique ;
int id_for_phrase_word_uppercase ;
int id_for_phrase_word_url ;
int id_for_phrase_word_usage ;
int id_for_phrase_word_use ;
int id_for_phrase_word_using ;
int id_for_phrase_word_values ;
int id_for_phrase_word_vector ;
int id_for_phrase_word_vectors ;
int id_for_phrase_word_version ;
int id_for_phrase_word_week ;
int id_for_phrase_word_when ;
int id_for_phrase_word_where ;
int id_for_phrase_word_with ;
int id_for_phrase_word_without ;
int id_for_phrase_word_word ;
int id_for_phrase_word_words ;
int id_for_phrase_word_write ;
int id_for_phrase_word_writing ;
int id_for_phrase_word_xml ;
int id_for_phrase_word_y ;
int id_for_phrase_word_year ;
int id_for_phrase_word_yes ;
int id_for_phrase_word_zero ;
int id_for_phrase_word_zoom ;
int id_linked_list ;
int id_for_list_of_decimal_numbers ;
int id_for_phrase_name ;
int id_for_phrase_word ;
int id_for_pointer_begin_end ;
int id_for_reminder ;
int id_for_sample_filename ;
int id_for_sample_folder_name ;
int id_for_sample_numbers ;
int id_for_sample_text_to_expand ;
int id_for_single_apostrophe ;
int id_for_single_backslash ;
int id_for_single_carriage_return ;
int id_for_single_close_angle_bracket ;
int id_for_single_formfeed ;
int id_for_single_hyphen ;
int id_for_single_newline ;
int id_for_single_open_angle_bracket ;
int id_for_single_period ;
int id_for_single_plus ;
int id_for_single_quotation_mark ;
int id_for_single_slash ;
int id_for_single_space ;
int id_for_single_tab ;
int id_for_single_underscore ;
int id_for_testing ;
int id_for_valid_filename ;
int id_for_valid_folder_name ;
int id_for_word_breaking ;
int id_for_word_character ;
int id_for_word_empty ;
int id_for_word_four ;
int id_for_word_hyphen ;
int id_for_word_hyphens ;
int id_for_word_newline ;
int id_for_word_non ;
int id_for_word_space ;
int id_for_word_tab ;
int id_for_word_text ;
int id_for_word_underscore ;
int id_from_indexed_list ;
int id_from_origin ;
int id_text_position_for_getting_next_character ;
int id_text_to_edit ;
int id_text_to_find ;
int id_text_to_search ;
int id_text_to_truncate ;
int integer_position_begin ;
int integer_position_current ;
int integer_position_end ;
int item_id ;
int item_id_current ;
int item_id_to_consider ;
int length_for_just_copy ;
int length_of_item ;
int length_of_first_phrase_word_minus_one ;
int length_of_matching_text ;
int length_of_text_to_find ;
int length_requested_for_next_item_storage ;
int line_character_position ;
int indexed_list_current_position ;
int id_indexed_list ;
int id_linked_list_segment_last_occupied ;
int id_linked_list_segment_last_saved ;
int id_linked_list_segment_last_saved_saved ;
int id_linked_list_segment_last_with_content ;
int indexed_list_current_segment_id ;
int indexed_list_next_segment_id ;
int looking_at_hyphenated_phrase_name_in_item_id ;
int message_trace__expand_phrases__endless_loop ;
int new_item_id ;
int next_available_begin_pointer_for_data_type_linked_list ;
int next_available_begin_pointer_for_data_type_text_characters ;
int next_available_begin_pointer_for_data_type_list_of_integers ;
int next_available_begin_pointer_for_data_type_list_of_decimal_numbers ;
int next_available_defined_phrase_number ;
int next_available_item_id ;
int next_character_number ;
int next_character_position_count ;
int next_character_position_in_storage_all_text ;
int next_number_from_indexed_list ;
int number_of_digits_encountered ;
int number_of_hyphenated_phrase_names_in_text_items ;
int number_of_phrase_words_found ;
int number_of_valid_characters_encountered ;
int offset ;
int offset_pointer_stack_level_list_of_pointers ;
int one_number_to_append ;
int optimum_character_for_find_pause ;
int phrase_word_number_to_check ;
int pointer_for_just_copy_source ;
int pointer_for_just_copy_destination ;
int pointer_for_debugging ;
int pointer_from ;
int pointer_from_indexed_list ;
int pointer_next_word_begin ;
int pointer_next_word_end ;
int pointer_to ;
int number_to_append ;
int pointer_to_character_to_insert_between_subitems ;
int pointer_to_first_hyphen ;
int pointer_to_leading_delimiter ;
int pointer_to_next_or_previous_character ;
int pointer_to_within_text_item ;

int pointer_to_pointer_stack_level_bottom ;
int pointer_to_pointer_stack_level_top ;

int pointer_copy_current ;
int pointer_copy_end ;
int pointer_origin_current ;
int pointer_origin_end ;
int character_position_current ;
int character_position_desired ;
int position_in_list_of_hyphenated_phrase_text_items ;
int position_of_close_angle_bracket ;
int position_of_close_angle_bracket_within_text_item ;
int position_of_found_character_for_find_pause ;
int position_of_open_angle_bracket ;
int position_of_open_angle_bracket_within_text_item ;
int position_of_optimum_character_for_pause ;
int position_of_underscore ;
int position_within_text_to_find ;
int possible_optimum_character_as_integer ;
int previous_character ;
int previous_indexed_list_segment_id ;
int recent_position_of_any_delimiter ;
int response_ignored ;
int saved_single_character_as_integer ;
int score_for_possible_optimum_character ;
int single_character ;
int single_character_as_integer ;
int single_integer ;
int space_available_in_item ;
int space_directive ;
int storage_array ;
int pointer_stack_level_bottom ;
int pointer_stack_level_current ;
int pointer_stack_level_current_copy ;
int pointer_stack_level_current_original ;
int pointer_stack_level_next ;
int pointer_stack_level_prior ;
int pointer_stack_level_top ;
int pointer_stack_level_top_original ;
int pointer_stack_pointer_for_copy_from ;
int pointer_stack_pointer_for_copy_to ;
int pointer_stack_pointer_for_get_next_previous_character ;
int pointer_stack_pointer_for_phrase_name_end ;
int pointer_stack_pointer_for_word_begin ;
int pointer_stack_pointer_for_word_end ;
int test_loop_counter ;
int text_item_for_operand_one ;
int text_item_for_operand_three ;
int text_item_for_operand_two ;
int text_item_intended_next_word_in_hyphenated_phrase ;
int text_item_looking_at_next_word_in_hyphenated_phrase ;
int text_item_one ;
int text_item_two ;
int text_item_with_next_character ;
int text_item_with_previous_character ;
int text_pointer ;
int text_pointer_begin ;
int text_pointer_end ;
int to_text_data_type ;
int unused_string_length ;
int word_count_hyphenated_phrase_name ;
int word_count_operand_one ;
int word_count_operand_two ;
int word_position ;
int yes_or_no ;
int yes_or_no_begin_not_end ;
int yes_or_no_character_is_delimiter ;
int yes_or_no_count_phrase_usage ;
int yes_or_no_decimal_number ;
int yes_or_no_delimiter_encountered ;
int yes_or_no_encountered_eof_flag ;
int yes_or_no_filename_delimiter_encountered ;
int yes_or_no_filename_is_valid ;
int yes_or_no_folder_name_delimiter_encountered ;
int yes_or_no_folder_name_is_valid ;
int yes_or_no_in_filename_before_period ;
int yes_or_no_in_folder_name_before_period ;
int yes_or_no_inserted_character ;
int yes_or_no_last_character_is_space ;
int yes_or_no_looking_for_word_attribute_or_specify ;
int yes_or_no_matching_text ;
int yes_or_no_more_text_in_file ;
int yes_or_no_negative_number ;
int yes_or_no_number_is_valid ;
int yes_or_no_numeric_delimiter_encountered ;
int yes_or_no_phrase_words_match ;
int yes_or_no_reached_begin_of_current_text_item ;
int yes_or_no_reached_end_of_current_text_item ;
int yes_or_no_requesting_space_appended ;
int yes_or_no_same_phrase_name ;
int yes_or_no_same_phrase_word ;
int yes_or_no_same_text ;
int yes_or_no_text_item_is_empty ;
int yes_or_no_transition_from_character_to_delimiter ;
int yes_or_no_transition_from_delimiter_to_character ;
int yes_or_no_use_copy_when_appending ;
int yes_or_no_use_slash_not_backslash ;
int zero_offset_in_stack_level_bottom ;
int zero_offset_in_stack_level_current ;
int zero_offset_in_stack_level_current_copy ;
int zero_offset_in_stack_level_current_original ;
int zero_offset_in_stack_level_top ;


// -----------------------------------------------
//  Here is where the Dashrep compiler
//  inserts the numbers that will be inserted
//  into some of the "all" arrays.
//  The unicode numbers for some characters and
//  some special text strings are supplied here
//  using their unicode numbers.  This avoids the
//  complication of putting them into Dashrep
//  code.
//  Important:  Dashrep code should be used to
//  determine the positions of these characters
//  so that any changes here automatically change
//  the numbers that indicate their positions.

unsigned int initial_contents_for_all_characters[ ] = {
0,  // unused

// <here_insert_code_into_array_all_charaters>

0  // last item, without comma
} ;

int initial_contents_for_all_pointers[ ] = {
    0,  // unused
// <here_insert_code_into_array_all_pointers>
    0  // last item, without comma
} ;

int initial_contents_for_all_integers[ ] = {
    0,  // unused
// <here_insert_code_into_array_all_integers>
    0  // last item, without comma
} ;

int initial_contents_for_all_decimal_numbers[ ] = {
    0.0,  // unused
// <here_insert_code_into_array_all_numbers>
    0.0  // last item, without comma
} ;


// -----------------------------------------------
//  Define the connections to file input and file
//  output.

FILE * infile_connection ;
FILE * outfile_connection ;


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
//  Allow the "do_main_initialization" function to
//  find the functions it uses.

void create_new_item_id_and_assign_storage( ) ;
int store_text_and_get_its_item_id( const char * local_this_word ) ;
int during_initialization_store_phrase_name( int local_word_one , int local_word_two , int local_word_three , int local_word_four , int local_word_five , int local_word_six , int local_word_seven , int local_word_eight , int local_word_nine , int local_word_ten , int local_word_eleven , int local_word_twelve ) ;


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
//  Initialize the list that associates each data
//  type with the storage type it uses.

    for ( data_type = 0 ; data_type <= maximum_data_type ; data_type ++ )
    {
        storage_array_for_data_type[ data_type ] = storage_array_all_pointers ;
    }
    storage_array_for_data_type[ data_type_text_characters ] = storage_array_all_characters ;
    storage_array_for_data_type[ data_type_list_of_integers ] = storage_array_all_integers ;
    storage_array_for_data_type[ data_type_list_of_decimal_numbers ] = storage_array_all_decimal_numbers ;


// -----------------------------------------------
//  Initialize the list that converts character
//  numbers into categories.

    for ( pointer = 0 ; pointer <= length_of_list_of_character_numbers ; pointer ++ )
    {
        character_category_number_for_character_number[ pointer ] = character_category_other ;
    }

    character_category_number_for_character_number[ unicode_for_tab ] = character_category_tab ;
    character_category_number_for_character_number[ unicode_for_newline ] = character_category_newline ;

//  carriage return and formfeed treated as newline
    character_category_number_for_character_number[ unicode_for_carriage_return ] = character_category_newline ;
    character_category_number_for_character_number[ unicode_for_formfeed ] = character_category_newline ;

    character_category_number_for_character_number[ unicode_for_quotation_mark ] = character_category_quotation_mark ;
    character_category_number_for_character_number[ unicode_for_apostrophe ] = character_category_apostrophe ;
    character_category_number_for_character_number[ unicode_for_hyphen ] = character_category_hyphen ;
    character_category_number_for_character_number[ unicode_for_space ] = character_category_space ;
    character_category_number_for_character_number[ unicode_for_hyphen ] = character_category_hyphen ;
    character_category_number_for_character_number[ unicode_for_underscore ] = character_category_underscore ;
    character_category_number_for_character_number[ unicode_for_slash ] = character_category_slash ;
    character_category_number_for_character_number[ unicode_for_open_angle_bracket ] = character_category_open_angle_bracket ;
    character_category_number_for_character_number[ unicode_for_close_angle_bracket ] = character_category_close_angle_bracket ;
    character_category_number_for_character_number[ unicode_for_period ] = character_category_period ;
    character_category_number_for_character_number[ unicode_for_plus ] = character_category_plus_sign ;
    character_category_number_for_character_number[ unicode_for_digit_0 ] = character_category_digit ;
    character_category_number_for_character_number[ unicode_for_digit_1 ] = character_category_digit ;
    character_category_number_for_character_number[ unicode_for_digit_2 ] = character_category_digit ;
    character_category_number_for_character_number[ unicode_for_digit_3 ] = character_category_digit ;
    character_category_number_for_character_number[ unicode_for_digit_4 ] = character_category_digit ;
    character_category_number_for_character_number[ unicode_for_digit_5 ] = character_category_digit ;
    character_category_number_for_character_number[ unicode_for_digit_6 ] = character_category_digit ;
    character_category_number_for_character_number[ unicode_for_digit_7 ] = character_category_digit ;
    character_category_number_for_character_number[ unicode_for_digit_8 ] = character_category_digit ;
    character_category_number_for_character_number[ unicode_for_digit_9 ] = character_category_digit ;
    character_category_number_for_character_number[ unicode_for_comma ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_backslash ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_left_square_bracket ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_right_square_bracket ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_left_parenthesis ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_right_parenthesis ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_ampersand ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_asterisk ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_pound_sign ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_exclamation_point ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_question_mark ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_at_sign ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_percent ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_caret ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_grave_accent ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_left_curly_bracket ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_right_curly_bracket ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_vertical_bar ] = character_category_symbol ;
    character_category_number_for_character_number[ unicode_for_tilde ] = character_category_symbol ;


// -----------------------------------------------
//  Here is where the numbers supplied by the
//  Dashrep compiler are copied into the "all"
//  arrays.

for ( pointer = 0 ; pointer <= count_of_numbers_supplied_to_array_all_characters ; pointer ++ )
{
    all_characters[ pointer ] = initial_contents_for_all_characters[ pointer ] ;
}

for ( pointer = 0 ; pointer <= count_of_numbers_supplied_to_array_all_pointers ; pointer ++ )
{
    all_pointers[ pointer ] = initial_contents_for_all_pointers[ pointer ] ;
}

for ( pointer = 0 ; pointer <= count_of_numbers_supplied_to_array_all_integers ; pointer ++ )
{
    all_integers[ pointer ] = initial_contents_for_all_integers[ pointer ] ;
}

for ( pointer = 0 ; pointer <= count_of_numbers_supplied_to_array_all_decimal_numbers ; pointer ++ )
{
    all_decimal_numbers[ pointer ] = initial_contents_for_all_decimal_numbers[ pointer ] ;
}


// -----------------------------------------------
//  Initialize the counter that indicates the next
//  available item ID number.  (Zero is not used.)
//  It must be incremented after each item ID
//  number is assigned.

    next_available_item_id = 1 ;


// -----------------------------------------------
//  Put zeros into the lists that are indexed by
//  item ID number because those ID numbers
//  start at one, not zero.

    all_characters[ 0 ] = 0 ;
    all_pointers[ 0 ] = 0 ;
    all_integers[ 0 ] = 0 ;
    all_decimal_numbers[ 0 ] = 0.0 ;
    data_type_for_item[ 0 ] = 0 ;
    pointer_allocation_end_for_item[ 0 ] = 0 ;
    pointer_begin_for_item[ 0 ] = 0 ;
    pointer_end_for_item[ 0 ] = 0 ;


// -----------------------------------------------
//  Initialize the pointers that keep track of the
//  beginning of each item ID.  Each of these data
//  types is stored in a different array.  The
//  "linked_list" data type is used for
//  multiple kinds of information.

    next_available_begin_pointer_for_data_type_linked_list = 1 ;
    next_available_begin_pointer_for_data_type_text_characters = 1 ;
    next_available_begin_pointer_for_data_type_list_of_integers = 1 ;
    next_available_begin_pointer_for_data_type_list_of_decimal_numbers = 1 ;


// -----------------------------------------------
//  Initialize the pointer that keeps track of the
//  end of the list:
//  pointer_to_definition_of_item

    next_available_defined_phrase_number = 1 ;


// -----------------------------------------------
//  Create text items that each hold one symbol,
//  and define item ID numbers for these
//  symbols.

    id_for_single_space = store_text_and_get_its_item_id( " " ) ;
    id_for_single_hyphen = store_text_and_get_its_item_id( "-" ) ;
    id_for_single_underscore  = store_text_and_get_its_item_id( "_" ) ;
    id_for_reminder = store_text_and_get_its_item_id( "next are tab newline carriage_return formfeed" ) ;
    id_for_single_tab  = store_text_and_get_its_item_id( "\t" ) ;
    id_for_single_newline  = store_text_and_get_its_item_id( "\n" ) ;
    id_for_single_carriage_return  = store_text_and_get_its_item_id( "\r" ) ;
    id_for_single_formfeed  = store_text_and_get_its_item_id( "\f" ) ;
    id_for_single_slash  = store_text_and_get_its_item_id( "/" ) ;
    id_for_single_backslash  = store_text_and_get_its_item_id( "\\" ) ;
    id_for_single_quotation_mark  = store_text_and_get_its_item_id( "?" ) ;
    id_for_single_apostrophe  = store_text_and_get_its_item_id( "'" ) ;
    id_for_single_plus  = store_text_and_get_its_item_id( "+" ) ;
    id_for_single_period  = store_text_and_get_its_item_id( "." ) ;
    id_for_single_open_angle_bracket  = store_text_and_get_its_item_id( "<" ) ;
    id_for_single_close_angle_bracket  = store_text_and_get_its_item_id( ">" ) ;


// -----------------------------------------------
//  Initialize the list that associates an item ID
//  with each possible word length.

    for ( length_of_item = 0 ; length_of_item <= maximum_length_of_phrase_word ; length_of_item ++ )
    {
        id_for_list_of_phrase_words_of_length[ length_of_item ] = 0 ;
    }


// -----------------------------------------------
//  Initialize some test text items for use during
//  debugging.

    id_for_sample_numbers = store_text_and_get_its_item_id( " 123 , 72.3 , -4399 , -88.6666 " ) ;
    id_for_sample_filename = store_text_and_get_its_item_id( "  , xyz !@#$%^&*(){}:;?<> yes_name.txt , " ) ;
    id_for_sample_folder_name = store_text_and_get_its_item_id( "  , xyz !@#$%/^&\\*(){}:;?<> /yes_name/txt/ , " ) ;
    id_for_sample_text_to_expand = store_text_and_get_its_item_id( "   _ hyphenated-phrase   <specify 123>  <attribute 123> " ) ;


// -----------------------------------------------
//  Create the text items for words within the
//  phrase names that have definitions -- rather
//  than only having meaning between the words
//  ambee and amenn.
//
//  Reminder: The strcpy function starts position
//  counting at one, not zero.

//  reminder: generate this code from a template

    id_for_word_hyphen = store_text_and_get_its_item_id( "hyphen" ) ;
    id_for_word_space = store_text_and_get_its_item_id( "space" ) ;
    id_for_word_newline = store_text_and_get_its_item_id( "newline" ) ;
    id_for_word_underscore = store_text_and_get_its_item_id( "underscore" ) ;
    id_for_word_tab = store_text_and_get_its_item_id( "tab" ) ;
    id_for_word_four = store_text_and_get_its_item_id( "four" ) ;
    id_for_word_hyphens = store_text_and_get_its_item_id( "hyphens" ) ;
    id_for_word_non = store_text_and_get_its_item_id( "non" ) ;
    id_for_word_breaking = store_text_and_get_its_item_id( "breaking" ) ;
    id_for_word_empty = store_text_and_get_its_item_id( "empty" ) ;
    id_for_word_text = store_text_and_get_its_item_id( "text" ) ;


// -----------------------------------------------
//  Create the text items for the Dashrep-defined
//  phrase names.

//  Reminder: put the following phrase words at
//  the beginning of their linked lists because
//  they are often encountered in directives:
//  "hyphen"
//  "here"
//  "placeholder"
//  "for"

    id_for_phrase_word_hyphen = store_text_and_get_its_item_id( "hyphen" ) ;
    id_for_phrase_word_here = store_text_and_get_its_item_id( "here" ) ;
    id_for_phrase_word_placeholder = store_text_and_get_its_item_id( "placeholder" ) ;
    id_for_phrase_word_for = store_text_and_get_its_item_id( "for" ) ;

    id_for_phrase_name_hyphen_here = during_initialization_store_phrase_name( id_for_phrase_word_hyphen , id_for_phrase_word_here , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_character_hyphen = during_initialization_store_phrase_name( id_for_phrase_word_character , id_for_phrase_word_hyphen , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_four_hyphens = during_initialization_store_phrase_name( id_for_phrase_word_four , id_for_phrase_word_hyphens , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_no_space = during_initialization_store_phrase_name( id_for_phrase_word_no , id_for_phrase_word_space , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_empty_text = during_initialization_store_phrase_name( id_for_phrase_word_empty , id_for_phrase_word_text , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_one_space = during_initialization_store_phrase_name( id_for_phrase_word_one , id_for_phrase_word_space , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_character_space = during_initialization_store_phrase_name( id_for_phrase_word_character , id_for_phrase_word_space , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_non_breaking_space = during_initialization_store_phrase_name( id_for_phrase_word_non , id_for_phrase_word_breaking , id_for_phrase_word_space , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_new_line = during_initialization_store_phrase_name( id_for_phrase_word_new , id_for_phrase_word_line , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_empty_line = during_initialization_store_phrase_name( id_for_phrase_word_empty , id_for_phrase_word_line , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_line_break = during_initialization_store_phrase_name( id_for_phrase_word_line , id_for_phrase_word_break , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_character_newline = during_initialization_store_phrase_name( id_for_phrase_word_character , id_for_phrase_word_newline , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_character_tab = during_initialization_store_phrase_name( id_for_phrase_word_character , id_for_phrase_word_tab , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_character_underscore = during_initialization_store_phrase_name( id_for_phrase_word_character , id_for_phrase_word_underscore , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_expand_text = during_initialization_store_phrase_name( id_for_phrase_word_expand , id_for_phrase_word_text , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_standard_output = during_initialization_store_phrase_name( id_for_phrase_word_standard , id_for_phrase_word_output , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_text = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_text , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_append_text = during_initialization_store_phrase_name( id_for_phrase_word_append , id_for_phrase_word_text , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_append_text_no_space = during_initialization_store_phrase_name( id_for_phrase_word_append , id_for_phrase_word_text , id_for_phrase_word_no , id_for_phrase_word_space , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_append_new_line = during_initialization_store_phrase_name( id_for_phrase_word_append , id_for_phrase_word_new , id_for_phrase_word_line , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_append_repeatedly_using_count = during_initialization_store_phrase_name( id_for_phrase_word_append , id_for_phrase_word_repeatedly , id_for_phrase_word_using , id_for_phrase_word_count , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_prepend_text = during_initialization_store_phrase_name( id_for_phrase_word_prepend , id_for_phrase_word_text , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_prepend_text_no_space = during_initialization_store_phrase_name( id_for_phrase_word_prepend , id_for_phrase_word_text , id_for_phrase_word_no , id_for_phrase_word_space , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_put_into_phrase = during_initialization_store_phrase_name( id_for_phrase_word_put , id_for_phrase_word_into , id_for_phrase_word_phrase , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_get_phrase_name_from_phrase = during_initialization_store_phrase_name( id_for_phrase_word_get , id_for_phrase_word_phrase , id_for_phrase_word_name , id_for_phrase_word_from , id_for_phrase_word_phrase , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_get_cgi_information = during_initialization_store_phrase_name( id_for_phrase_word_get , id_for_phrase_word_cgi , id_for_phrase_word_information , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_get_definitions_from_phrase = during_initialization_store_phrase_name( id_for_phrase_word_get , id_for_phrase_word_definitions , id_for_phrase_word_from , id_for_phrase_word_phrase , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_put_listed_phrase_definitions_into_phrase = during_initialization_store_phrase_name( id_for_phrase_word_put , id_for_phrase_word_listed , id_for_phrase_word_phrase , id_for_phrase_word_definitions , id_for_phrase_word_into , id_for_phrase_word_phrase , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_listed_words_to_phrases_named_in_pattern = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_listed , id_for_phrase_word_words , id_for_phrase_word_to , id_for_phrase_word_phrases , id_for_phrase_word_named , id_for_phrase_word_in , id_for_phrase_word_pattern , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_append_multiple_from_phrases_named_in_pattern = during_initialization_store_phrase_name( id_for_phrase_word_append , id_for_phrase_word_multiple , id_for_phrase_word_from , id_for_phrase_word_phrases , id_for_phrase_word_named , id_for_phrase_word_in , id_for_phrase_word_pattern , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_clear_phrase = during_initialization_store_phrase_name( id_for_phrase_word_clear , id_for_phrase_word_phrase , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_clear_listed_phrases = during_initialization_store_phrase_name( id_for_phrase_word_clear , id_for_phrase_word_listed , id_for_phrase_word_phrases , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_delete_listed_phrases = during_initialization_store_phrase_name( id_for_phrase_word_delete , id_for_phrase_word_listed , id_for_phrase_word_phrases , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_if_yes_begin = during_initialization_store_phrase_name( id_for_phrase_word_if , id_for_phrase_word_yes , id_for_phrase_word_begin , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_if_no_begin = during_initialization_store_phrase_name( id_for_phrase_word_if , id_for_phrase_word_no , id_for_phrase_word_begin , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_if_else = during_initialization_store_phrase_name( id_for_phrase_word_if , id_for_phrase_word_else , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_if_end = during_initialization_store_phrase_name( id_for_phrase_word_if , id_for_phrase_word_end , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_yes_or_no_empty_phrase = during_initialization_store_phrase_name( id_for_phrase_word_yes , id_for_phrase_word_or , id_for_phrase_word_no , id_for_phrase_word_empty , id_for_phrase_word_phrase , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_yes_or_no_same_two_phrase_definitions = during_initialization_store_phrase_name( id_for_phrase_word_yes , id_for_phrase_word_or , id_for_phrase_word_no , id_for_phrase_word_same , id_for_phrase_word_two , id_for_phrase_word_phrase , id_for_phrase_word_definitions , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_yes_or_no_same_two_words = during_initialization_store_phrase_name( id_for_phrase_word_yes , id_for_phrase_word_or , id_for_phrase_word_no , id_for_phrase_word_same , id_for_phrase_word_two , id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_yes_or_no_opposite = during_initialization_store_phrase_name( id_for_phrase_word_yes , id_for_phrase_word_or , id_for_phrase_word_no , id_for_phrase_word_opposite , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_yes_if_all_yes = during_initialization_store_phrase_name( id_for_phrase_word_yes , id_for_phrase_word_if , id_for_phrase_word_all , id_for_phrase_word_yes , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_yes_if_any_yes = during_initialization_store_phrase_name( id_for_phrase_word_yes , id_for_phrase_word_if , id_for_phrase_word_any , id_for_phrase_word_yes , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_no_if_any_no = during_initialization_store_phrase_name( id_for_phrase_word_no , id_for_phrase_word_if , id_for_phrase_word_any , id_for_phrase_word_no , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_yes_if_not_no = during_initialization_store_phrase_name( id_for_phrase_word_yes , id_for_phrase_word_if , id_for_phrase_word_not , id_for_phrase_word_no , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_no_if_not_yes = during_initialization_store_phrase_name( id_for_phrase_word_no , id_for_phrase_word_if , id_for_phrase_word_not , id_for_phrase_word_yes , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_use_handler_with_each_word_in_phrase = during_initialization_store_phrase_name( id_for_phrase_word_use , id_for_phrase_word_handler , id_for_phrase_word_with , id_for_phrase_word_each , id_for_phrase_word_word , id_for_phrase_word_in , id_for_phrase_word_phrase , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_word_to_use_in_handler = during_initialization_store_phrase_name( id_for_phrase_word_word , id_for_phrase_word_to , id_for_phrase_word_use , id_for_phrase_word_in , id_for_phrase_word_handler , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_get_count_of_words = during_initialization_store_phrase_name( id_for_phrase_word_get , id_for_phrase_word_count , id_for_phrase_word_of , id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_get_word_at_position = during_initialization_store_phrase_name( id_for_phrase_word_get , id_for_phrase_word_word , id_for_phrase_word_at , id_for_phrase_word_position , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_get_position_of_word = during_initialization_store_phrase_name( id_for_phrase_word_get , id_for_phrase_word_position , id_for_phrase_word_of , id_for_phrase_word_word , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_word_at_position = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_word , id_for_phrase_word_at , id_for_phrase_word_position , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_words_from_position_to_position = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_words , id_for_phrase_word_from , id_for_phrase_word_position , id_for_phrase_word_to , id_for_phrase_word_position , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_words_offset_skip = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_words , id_for_phrase_word_offset , id_for_phrase_word_skip , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_words_found_in_both_lists = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_words , id_for_phrase_word_found , id_for_phrase_word_in , id_for_phrase_word_both , id_for_phrase_word_lists , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_words_found_in_either_list = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_words , id_for_phrase_word_found , id_for_phrase_word_in , id_for_phrase_word_either , id_for_phrase_word_list , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_words_found_only_in_first_list = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_words , id_for_phrase_word_found , id_for_phrase_word_only , id_for_phrase_word_in , id_for_phrase_word_first , id_for_phrase_word_list , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_words_that_begin_with_text = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_words , id_for_phrase_word_that , id_for_phrase_word_begin , id_for_phrase_word_with , id_for_phrase_word_text , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_words_that_begin_with_listed_words = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_words , id_for_phrase_word_that , id_for_phrase_word_begin , id_for_phrase_word_with , id_for_phrase_word_listed , id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_words_that_contain_listed_words = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_words , id_for_phrase_word_that , id_for_phrase_word_contain , id_for_phrase_word_listed , id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_words_unique_only = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_words , id_for_phrase_word_unique , id_for_phrase_word_only , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_list_of_unique_word_counts = during_initialization_store_phrase_name( id_for_phrase_word_list , id_for_phrase_word_of , id_for_phrase_word_unique , id_for_phrase_word_word , id_for_phrase_word_counts , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_list_of_pointers_to_unique_words = during_initialization_store_phrase_name( id_for_phrase_word_list , id_for_phrase_word_of , id_for_phrase_word_pointers , id_for_phrase_word_to , id_for_phrase_word_unique , id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_words_order_reversed = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_words , id_for_phrase_word_order , id_for_phrase_word_reversed , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_words_sort_numeric = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_words , id_for_phrase_word_sort , id_for_phrase_word_numeric , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_words_rearrange_using_order_sort_numeric = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_words , id_for_phrase_word_rearrange , id_for_phrase_word_using , id_for_phrase_word_order , id_for_phrase_word_sort , id_for_phrase_word_numeric , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_words_sort_alphabetic = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_words , id_for_phrase_word_sort , id_for_phrase_word_alphabetic , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_words_rearrange_using_order_sort_alphabetic = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_words , id_for_phrase_word_rearrange , id_for_phrase_word_using , id_for_phrase_word_order , id_for_phrase_word_sort , id_for_phrase_word_alphabetic , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_generate_counts_from_integer_to_integer = during_initialization_store_phrase_name( id_for_phrase_word_generate , id_for_phrase_word_counts , id_for_phrase_word_from , id_for_phrase_word_integer , id_for_phrase_word_to , id_for_phrase_word_integer , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_generate_every_pairwise_combination_of_words = during_initialization_store_phrase_name( id_for_phrase_word_generate , id_for_phrase_word_every , id_for_phrase_word_pairwise , id_for_phrase_word_combination , id_for_phrase_word_of , id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_generate_every_ordered_pairwise_combination_of_words = during_initialization_store_phrase_name( id_for_phrase_word_generate , id_for_phrase_word_every , id_for_phrase_word_ordered , id_for_phrase_word_pairwise , id_for_phrase_word_combination , id_for_phrase_word_of , id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_generate_list_of_all_dashrep_phrases = during_initialization_store_phrase_name( id_for_phrase_word_generate , id_for_phrase_word_list , id_for_phrase_word_of , id_for_phrase_word_all , id_for_phrase_word_dashrep , id_for_phrase_word_phrases , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_get_count_of_characters = during_initialization_store_phrase_name( id_for_phrase_word_get , id_for_phrase_word_count , id_for_phrase_word_of , id_for_phrase_word_characters , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_get_characters_from_position_to_position = during_initialization_store_phrase_name( id_for_phrase_word_get , id_for_phrase_word_characters , id_for_phrase_word_from , id_for_phrase_word_position , id_for_phrase_word_to , id_for_phrase_word_position , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_characters_from_position_to_position = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_characters , id_for_phrase_word_from , id_for_phrase_word_position , id_for_phrase_word_to , id_for_phrase_word_position , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_without_extra_spaces = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_without , id_for_phrase_word_extra , id_for_phrase_word_spaces , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_lowercase_only = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_lowercase , id_for_phrase_word_only , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_uppercase_only = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_uppercase , id_for_phrase_word_only , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_initial_caps = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_initial , id_for_phrase_word_caps , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_zero_pad_left_to_length = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_zero , id_for_phrase_word_pad , id_for_phrase_word_left , id_for_phrase_word_to , id_for_phrase_word_length , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_encode_as_cgi_parameter = during_initialization_store_phrase_name( id_for_phrase_word_encode , id_for_phrase_word_as , id_for_phrase_word_cgi , id_for_phrase_word_parameter , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_decode_from_cgi_parameter = during_initialization_store_phrase_name( id_for_phrase_word_decode , id_for_phrase_word_from , id_for_phrase_word_cgi , id_for_phrase_word_parameter , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_convert_unicode_to_html_entities = during_initialization_store_phrase_name( id_for_phrase_word_convert , id_for_phrase_word_unicode , id_for_phrase_word_to , id_for_phrase_word_html , id_for_phrase_word_entities , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_get_position_of_matching_text = during_initialization_store_phrase_name( id_for_phrase_word_get , id_for_phrase_word_position , id_for_phrase_word_of , id_for_phrase_word_matching , id_for_phrase_word_text , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_and_replace = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_and , id_for_phrase_word_replace , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_and_replace_using_paired_listed_words = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_and , id_for_phrase_word_replace , id_for_phrase_word_using , id_for_phrase_word_paired , id_for_phrase_word_listed , id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_generate_positions_of_listed_words = during_initialization_store_phrase_name( id_for_phrase_word_generate , id_for_phrase_word_positions , id_for_phrase_word_of , id_for_phrase_word_listed , id_for_phrase_word_words , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_generate_positions_of_delimiter = during_initialization_store_phrase_name( id_for_phrase_word_generate , id_for_phrase_word_positions , id_for_phrase_word_of , id_for_phrase_word_delimiter , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_generate_positions_of_first_matching_delimiter_after_listed_positions = during_initialization_store_phrase_name( id_for_phrase_word_generate , id_for_phrase_word_positions , id_for_phrase_word_of , id_for_phrase_word_first , id_for_phrase_word_matching , id_for_phrase_word_delimiter , id_for_phrase_word_after , id_for_phrase_word_listed , id_for_phrase_word_positions , 0 , 0 , 0 ) ;
    id_for_phrase_name_get_current_time_in_epoch_seconds = during_initialization_store_phrase_name( id_for_phrase_word_get , id_for_phrase_word_current , id_for_phrase_word_time , id_for_phrase_word_in , id_for_phrase_word_epoch , id_for_phrase_word_seconds , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_split_epoch_seconds_into_named_components = during_initialization_store_phrase_name( id_for_phrase_word_split , id_for_phrase_word_epoch , id_for_phrase_word_seconds , id_for_phrase_word_into , id_for_phrase_word_named , id_for_phrase_word_components , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_split_epoch_seconds_into_named_components_for_zero_meridian = during_initialization_store_phrase_name( id_for_phrase_word_split , id_for_phrase_word_epoch , id_for_phrase_word_seconds , id_for_phrase_word_into , id_for_phrase_word_named , id_for_phrase_word_components , id_for_phrase_word_for , id_for_phrase_word_zero , id_for_phrase_word_meridian , 0 , 0 , 0 ) ;
    id_for_phrase_name_time_day_of_month = during_initialization_store_phrase_name( id_for_phrase_word_time , id_for_phrase_word_day , id_for_phrase_word_of , id_for_phrase_word_month , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_time_day_of_week = during_initialization_store_phrase_name( id_for_phrase_word_time , id_for_phrase_word_day , id_for_phrase_word_of , id_for_phrase_word_week , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_time_day_of_year = during_initialization_store_phrase_name( id_for_phrase_word_time , id_for_phrase_word_day , id_for_phrase_word_of , id_for_phrase_word_year , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_time_hour = during_initialization_store_phrase_name( id_for_phrase_word_time , id_for_phrase_word_hour , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_time_minute = during_initialization_store_phrase_name( id_for_phrase_word_time , id_for_phrase_word_minute , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_time_month_number = during_initialization_store_phrase_name( id_for_phrase_word_time , id_for_phrase_word_month , id_for_phrase_word_number , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_time_second = during_initialization_store_phrase_name( id_for_phrase_word_time , id_for_phrase_word_second , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_time_year = during_initialization_store_phrase_name( id_for_phrase_word_time , id_for_phrase_word_year , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_zero_or_nonzero = during_initialization_store_phrase_name( id_for_phrase_word_zero , id_for_phrase_word_or , id_for_phrase_word_nonzero , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_zero_one_multiple = during_initialization_store_phrase_name( id_for_phrase_word_zero , id_for_phrase_word_one , id_for_phrase_word_multiple , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_equal_greater_less_compare = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_equal , id_for_phrase_word_greater , id_for_phrase_word_less , id_for_phrase_word_compare , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_add = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_add , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_minus = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_minus , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_multiply = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_multiply , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_divide_by = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_divide , id_for_phrase_word_by , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_maximum = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_maximum , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_minimum = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_minimum , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_increment = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_increment , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_decrement = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_decrement , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_integer = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_integer , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_absolute = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_absolute , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_odd_or_even = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_odd , id_for_phrase_word_or , id_for_phrase_word_even , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_square_root = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_square , id_for_phrase_word_root , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_sine = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_sine , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_cosine = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_cosine , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_logarithm_base_e = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_logarithm , id_for_phrase_word_base , id_for_phrase_word_e , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_logarithm_base_10 = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_logarithm , id_for_phrase_word_base , id_for_phrase_word_10 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_pi = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_pi , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_vector_add_number = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_vector , id_for_phrase_word_add , id_for_phrase_word_number , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_vector_multiply_by_number = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_vector , id_for_phrase_word_multiply , id_for_phrase_word_by , id_for_phrase_word_number , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_vectors_add = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_vectors , id_for_phrase_word_add , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_vectors_multiply = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_vectors , id_for_phrase_word_multiply , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_vectors_divide_by = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_vectors , id_for_phrase_word_divide , id_for_phrase_word_by , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_vector_integers = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_vector , id_for_phrase_word_integers , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_vector_absolutes = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_vector , id_for_phrase_word_absolutes , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_vectors_from_delta_values_calculate_distances = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_vectors , id_for_phrase_word_from , id_for_phrase_word_delta , id_for_phrase_word_values , id_for_phrase_word_calculate , id_for_phrase_word_distances , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_two_dimensional_sort_into_columns_and_rows = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_two , id_for_phrase_word_dimensional , id_for_phrase_word_sort , id_for_phrase_word_into , id_for_phrase_word_columns , id_for_phrase_word_and , id_for_phrase_word_rows , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_y_map_tile_number_based_on_latitude = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_y , id_for_phrase_word_map , id_for_phrase_word_tile , id_for_phrase_word_number , id_for_phrase_word_based , id_for_phrase_word_on , id_for_phrase_word_latitude , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_numeric_map_tile_zoom = during_initialization_store_phrase_name( id_for_phrase_word_numeric , id_for_phrase_word_map , id_for_phrase_word_tile , id_for_phrase_word_zoom , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_and_move_attributes_into_xml_tags = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_and , id_for_phrase_word_move , id_for_phrase_word_attributes , id_for_phrase_word_into , id_for_phrase_word_xml , id_for_phrase_word_tags , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_and_remove_attributes_from_xml_tags = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_and , id_for_phrase_word_remove , id_for_phrase_word_attributes , id_for_phrase_word_from , id_for_phrase_word_xml , id_for_phrase_word_tags , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_yes_or_no_permission_to_append_to_files = during_initialization_store_phrase_name( id_for_phrase_word_yes , id_for_phrase_word_or , id_for_phrase_word_no , id_for_phrase_word_permission , id_for_phrase_word_to , id_for_phrase_word_append , id_for_phrase_word_to , id_for_phrase_word_files , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_yes_or_no_permission_to_delete_or_overwrite_files = during_initialization_store_phrase_name( id_for_phrase_word_yes , id_for_phrase_word_or , id_for_phrase_word_no , id_for_phrase_word_permission , id_for_phrase_word_to , id_for_phrase_word_delete , id_for_phrase_word_or , id_for_phrase_word_overwrite , id_for_phrase_word_files , 0 , 0 , 0 ) ;
    id_for_phrase_name_dashrep_path_prefix_for_file_reading = during_initialization_store_phrase_name( id_for_phrase_word_dashrep , id_for_phrase_word_path , id_for_phrase_word_prefix , id_for_phrase_word_for , id_for_phrase_word_file , id_for_phrase_word_reading , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_dashrep_path_prefix_for_file_writing = during_initialization_store_phrase_name( id_for_phrase_word_dashrep , id_for_phrase_word_path , id_for_phrase_word_prefix , id_for_phrase_word_for , id_for_phrase_word_file , id_for_phrase_word_writing , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_operating_system_slash_or_backslash = during_initialization_store_phrase_name( id_for_phrase_word_operating , id_for_phrase_word_system , id_for_phrase_word_slash , id_for_phrase_word_or , id_for_phrase_word_backslash , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_dashrep_file_name_if_read_file_missing = during_initialization_store_phrase_name( id_for_phrase_word_dashrep , id_for_phrase_word_file , id_for_phrase_word_name , id_for_phrase_word_if , id_for_phrase_word_read , id_for_phrase_word_file , id_for_phrase_word_missing , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_generate_list_of_files_in_current_read_directory = during_initialization_store_phrase_name( id_for_phrase_word_generate , id_for_phrase_word_list , id_for_phrase_word_of , id_for_phrase_word_files , id_for_phrase_word_in , id_for_phrase_word_current , id_for_phrase_word_read , id_for_phrase_word_directory , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_generate_list_of_folders_in_current_read_directory = during_initialization_store_phrase_name( id_for_phrase_word_generate , id_for_phrase_word_list , id_for_phrase_word_of , id_for_phrase_word_folders , id_for_phrase_word_in , id_for_phrase_word_current , id_for_phrase_word_read , id_for_phrase_word_directory , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_yes_or_no_file_exists = during_initialization_store_phrase_name( id_for_phrase_word_yes , id_for_phrase_word_or , id_for_phrase_word_no , id_for_phrase_word_file , id_for_phrase_word_exists , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_yes_or_no_folder_exists = during_initialization_store_phrase_name( id_for_phrase_word_yes , id_for_phrase_word_or , id_for_phrase_word_no , id_for_phrase_word_folder , id_for_phrase_word_exists , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_size_of_file = during_initialization_store_phrase_name( id_for_phrase_word_size , id_for_phrase_word_of , id_for_phrase_word_file , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_modification_time_of_file = during_initialization_store_phrase_name( id_for_phrase_word_modification , id_for_phrase_word_time , id_for_phrase_word_of , id_for_phrase_word_file , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_set_file_permission_public_read = during_initialization_store_phrase_name( id_for_phrase_word_set , id_for_phrase_word_file , id_for_phrase_word_permission , id_for_phrase_word_public , id_for_phrase_word_read , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_set_file_permission_private = during_initialization_store_phrase_name( id_for_phrase_word_set , id_for_phrase_word_file , id_for_phrase_word_permission , id_for_phrase_word_private , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_set_file_permission_private_but_executable = during_initialization_store_phrase_name( id_for_phrase_word_set , id_for_phrase_word_file , id_for_phrase_word_permission , id_for_phrase_word_private , id_for_phrase_word_but , id_for_phrase_word_executable , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_rename_file = during_initialization_store_phrase_name( id_for_phrase_word_rename , id_for_phrase_word_file , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_delete_file = during_initialization_store_phrase_name( id_for_phrase_word_delete , id_for_phrase_word_file , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_create_empty_sub_folder = during_initialization_store_phrase_name( id_for_phrase_word_create , id_for_phrase_word_empty , id_for_phrase_word_sub , id_for_phrase_word_folder , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_from_file_to_phrase = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_from , id_for_phrase_word_file , id_for_phrase_word_to , id_for_phrase_word_phrase , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_end_of_line_indicator = during_initialization_store_phrase_name( id_for_phrase_word_end , id_for_phrase_word_of , id_for_phrase_word_line , id_for_phrase_word_indicator , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_text_end_of_line_here_space_delimited = during_initialization_store_phrase_name( id_for_phrase_word_text , id_for_phrase_word_end , id_for_phrase_word_of , id_for_phrase_word_line , id_for_phrase_word_here , id_for_phrase_word_space , id_for_phrase_word_delimited , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_yes_or_no_trim_spaces_when_copy_from_file = during_initialization_store_phrase_name( id_for_phrase_word_yes , id_for_phrase_word_or , id_for_phrase_word_no , id_for_phrase_word_trim , id_for_phrase_word_spaces , id_for_phrase_word_when , id_for_phrase_word_copy , id_for_phrase_word_from , id_for_phrase_word_file , 0 , 0 , 0 ) ;
    id_for_phrase_name_yes_or_no_skip_empty_lines_when_copy_from_file = during_initialization_store_phrase_name( id_for_phrase_word_yes , id_for_phrase_word_or , id_for_phrase_word_no , id_for_phrase_word_skip , id_for_phrase_word_empty , id_for_phrase_word_lines , id_for_phrase_word_when , id_for_phrase_word_copy , id_for_phrase_word_from , id_for_phrase_word_file , 0 , 0 ) ;
    id_for_phrase_name_copy_from_phrase_append_to_file = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_from , id_for_phrase_word_phrase , id_for_phrase_word_append , id_for_phrase_word_to , id_for_phrase_word_file , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_append_file_to_file = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_append , id_for_phrase_word_file , id_for_phrase_word_to , id_for_phrase_word_file , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_linewise_read_from_file_and_use_handler = during_initialization_store_phrase_name( id_for_phrase_word_linewise , id_for_phrase_word_read , id_for_phrase_word_from , id_for_phrase_word_file , id_for_phrase_word_and , id_for_phrase_word_use , id_for_phrase_word_handler , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_linewise_input_line_from_file = during_initialization_store_phrase_name( id_for_phrase_word_linewise , id_for_phrase_word_input , id_for_phrase_word_line , id_for_phrase_word_from , id_for_phrase_word_file , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_linewise_input_line_count = during_initialization_store_phrase_name( id_for_phrase_word_linewise , id_for_phrase_word_input , id_for_phrase_word_line , id_for_phrase_word_count , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_linewise_read_from_standard_input = during_initialization_store_phrase_name( id_for_phrase_word_linewise , id_for_phrase_word_read , id_for_phrase_word_from , id_for_phrase_word_standard , id_for_phrase_word_input , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_get_url_resource = during_initialization_store_phrase_name( id_for_phrase_word_get , id_for_phrase_word_url , id_for_phrase_word_resource , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_trace_from_get_url_resource = during_initialization_store_phrase_name( id_for_phrase_word_trace , id_for_phrase_word_from , id_for_phrase_word_get , id_for_phrase_word_url , id_for_phrase_word_resource , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_find_line_in_file_that_begins_with_text = during_initialization_store_phrase_name( id_for_phrase_word_find , id_for_phrase_word_line , id_for_phrase_word_in , id_for_phrase_word_file , id_for_phrase_word_that , id_for_phrase_word_begins , id_for_phrase_word_with , id_for_phrase_word_text , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_find_lines_in_file_that_begin_with_any_listed_word = during_initialization_store_phrase_name( id_for_phrase_word_find , id_for_phrase_word_lines , id_for_phrase_word_in , id_for_phrase_word_file , id_for_phrase_word_that , id_for_phrase_word_begin , id_for_phrase_word_with , id_for_phrase_word_any , id_for_phrase_word_listed , id_for_phrase_word_word , 0 , 0 ) ;
    id_for_phrase_name_find_lines_in_file_that_begin_with_any_two_words_listed = during_initialization_store_phrase_name( id_for_phrase_word_find , id_for_phrase_word_lines , id_for_phrase_word_in , id_for_phrase_word_file , id_for_phrase_word_that , id_for_phrase_word_begin , id_for_phrase_word_with , id_for_phrase_word_any , id_for_phrase_word_two , id_for_phrase_word_words , id_for_phrase_word_listed , 0 ) ;
    id_for_phrase_name_copy_from_columns_in_file_to_named_phrases = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_from , id_for_phrase_word_columns , id_for_phrase_word_in , id_for_phrase_word_file , id_for_phrase_word_to , id_for_phrase_word_named , id_for_phrase_word_phrases , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_copy_from_columns_in_file_to_column_lists = during_initialization_store_phrase_name( id_for_phrase_word_copy , id_for_phrase_word_from , id_for_phrase_word_columns , id_for_phrase_word_in , id_for_phrase_word_file , id_for_phrase_word_to , id_for_phrase_word_column , id_for_phrase_word_lists , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_yes_or_no_use_two_spaces_as_column_delimiter = during_initialization_store_phrase_name( id_for_phrase_word_yes , id_for_phrase_word_or , id_for_phrase_word_no , id_for_phrase_word_use , id_for_phrase_word_two , id_for_phrase_word_spaces , id_for_phrase_word_as , id_for_phrase_word_column , id_for_phrase_word_delimiter , 0 , 0 , 0 ) ;
    id_for_phrase_name_gather_tagged_info_from_file = during_initialization_store_phrase_name( id_for_phrase_word_gather , id_for_phrase_word_tagged , id_for_phrase_word_info , id_for_phrase_word_from , id_for_phrase_word_file , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_gather_from_tagged_file_one_entry = during_initialization_store_phrase_name( id_for_phrase_word_gather , id_for_phrase_word_from , id_for_phrase_word_tagged , id_for_phrase_word_file , id_for_phrase_word_one , id_for_phrase_word_entry , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_write_gathered_listed_items_to_end_of_file = during_initialization_store_phrase_name( id_for_phrase_word_write , id_for_phrase_word_gathered , id_for_phrase_word_listed , id_for_phrase_word_items , id_for_phrase_word_to , id_for_phrase_word_end , id_for_phrase_word_of , id_for_phrase_word_file , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_dashrep_gather_tag_begin = during_initialization_store_phrase_name( id_for_phrase_word_dashrep , id_for_phrase_word_gather , id_for_phrase_word_tag , id_for_phrase_word_begin , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_dashrep_gather_tag_end = during_initialization_store_phrase_name( id_for_phrase_word_dashrep , id_for_phrase_word_gather , id_for_phrase_word_tag , id_for_phrase_word_end , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_dashrep_gather_tag_unique = during_initialization_store_phrase_name( id_for_phrase_word_dashrep , id_for_phrase_word_gather , id_for_phrase_word_tag , id_for_phrase_word_unique , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_dashrep_gather_tag_delete = during_initialization_store_phrase_name( id_for_phrase_word_dashrep , id_for_phrase_word_gather , id_for_phrase_word_tag , id_for_phrase_word_delete , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_dashrep_gather_tag_matching_id = during_initialization_store_phrase_name( id_for_phrase_word_dashrep , id_for_phrase_word_gather , id_for_phrase_word_tag , id_for_phrase_word_matching , id_for_phrase_word_id , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_trace_show = during_initialization_store_phrase_name( id_for_phrase_word_trace , id_for_phrase_word_show , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_trace_show_where = during_initialization_store_phrase_name( id_for_phrase_word_trace , id_for_phrase_word_show , id_for_phrase_word_where , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_output_trace_file_name = during_initialization_store_phrase_name( id_for_phrase_word_output , id_for_phrase_word_trace , id_for_phrase_word_file , id_for_phrase_word_name , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_dashrep_comments_ignored = during_initialization_store_phrase_name( id_for_phrase_word_dashrep , id_for_phrase_word_comments , id_for_phrase_word_ignored , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_generate_phrase_usage_counts = during_initialization_store_phrase_name( id_for_phrase_word_generate , id_for_phrase_word_phrase , id_for_phrase_word_usage , id_for_phrase_word_counts , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_exit_from_dashrep = during_initialization_store_phrase_name( id_for_phrase_word_exit , id_for_phrase_word_from , id_for_phrase_word_dashrep , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_dashrep_language_yes = during_initialization_store_phrase_name( id_for_phrase_word_dashrep , id_for_phrase_word_language , id_for_phrase_word_yes , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_dashrep_version = during_initialization_store_phrase_name( id_for_phrase_word_dashrep , id_for_phrase_word_version , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_delayed_nospace = during_initialization_store_phrase_name( id_for_phrase_word_delayed , id_for_phrase_word_nospace , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_delayed_newline = during_initialization_store_phrase_name( id_for_phrase_word_delayed , id_for_phrase_word_newline , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_yes_or_no_permission_administrator = during_initialization_store_phrase_name( id_for_phrase_word_yes , id_for_phrase_word_or , id_for_phrase_word_no , id_for_phrase_word_permission , id_for_phrase_word_administrator , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_dashrep_endless_loop_counter_limit = during_initialization_store_phrase_name( id_for_phrase_word_dashrep , id_for_phrase_word_endless , id_for_phrase_word_loop , id_for_phrase_word_counter , id_for_phrase_word_limit , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;
    id_for_phrase_name_dashrep_time_limit = during_initialization_store_phrase_name( id_for_phrase_word_dashrep , id_for_phrase_word_time , id_for_phrase_word_limit , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;


// -----------------------------------------------
//  Create some special hyphenated phrase names.

    id_for_phrase_name_placeholder_for_hyphen_here = during_initialization_store_phrase_name( id_for_phrase_word_placeholder , id_for_phrase_word_for , id_for_phrase_word_hyphen , id_for_phrase_word_here , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;

    id_for_phrase_name_placeholder_for_new_line = during_initialization_store_phrase_name( id_for_phrase_word_placeholder , id_for_phrase_word_for , id_for_phrase_word_new , id_for_phrase_word_line , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;

    id_for_phrase_name_placeholder_for_empty_line = during_initialization_store_phrase_name( id_for_phrase_word_placeholder , id_for_phrase_word_for , id_for_phrase_word_empty , id_for_phrase_word_line , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ) ;


// -----------------------------------------------
//  Connect the Dashrep-defined static phrase
//  names with their definitions.

    pointer_to_definition_of_item[ id_for_phrase_name_character_hyphen ] = id_for_single_hyphen ;
    pointer_to_definition_of_item[ id_for_phrase_name_character_space ] = id_for_single_space ;
    pointer_to_definition_of_item[ id_for_phrase_name_character_newline ] = id_for_single_newline ;
    pointer_to_definition_of_item[ id_for_phrase_name_character_tab ] = id_for_single_tab ;
    pointer_to_definition_of_item[ id_for_phrase_name_character_underscore ] = id_for_single_underscore ;

    id_for_empty_text = store_text_and_get_its_item_id( "" ) ;
    pointer_to_definition_of_item[ id_for_phrase_name_empty_text ] = id_for_empty_text ;

    id_for_four_hyphens = store_text_and_get_its_item_id( "----" ) ;
    pointer_to_definition_of_item[ id_for_phrase_name_four_hyphens ] = id_for_four_hyphens ;

    id_for_non_breaking_space = store_text_and_get_its_item_id( "&nbsp;" ) ;
    pointer_to_definition_of_item[ id_for_phrase_name_non_breaking_space ] = id_for_non_breaking_space ;


// -----------------------------------------------
//  Create the text items used for file input and
//  output.  Shorten the length slightly in case
//  of an overrun.

    length_requested_for_next_item_storage = allocated_length_for_file_input_or_output ;

    id_for_file_input = next_available_item_id ;
    create_new_item_id_and_assign_storage( ) ;
    data_type_for_item[ id_for_file_input ] = data_type_text_characters ;
    pointer_allocation_end_for_item[ id_for_file_input ] -= 5 ;

    id_for_file_output = next_available_item_id ;
    create_new_item_id_and_assign_storage( ) ;
    data_type_for_item[ id_for_file_output ] = data_type_text_characters ;
    pointer_allocation_end_for_item[ id_for_file_output ] -= 5 ;


// -----------------------------------------------
//  Create the text item used to store the result
//  of converting a number into text.

    length_requested_for_next_item_storage = 20 ;
    id_for_number_as_text = next_available_item_id ;
    create_new_item_id_and_assign_storage( ) ;
    data_type_for_item[ id_for_number_as_text ] = data_type_text_characters ;


// -----------------------------------------------
//  Create text items that contain specific
//  unchanging messages.

    message_trace__expand_phrases__endless_loop = store_text_and_get_its_item_id( "trace_diagnostic__expand_phrases__error_endless_loop__highest_count " ) ;


// -----------------------------------------------
//  Create text items that hold one filename and
//  one folder name after they have been changed
//  to eliminate leading and trailing delimiters.

    length_requested_for_next_item_storage = 200 ;

    create_new_item_id_and_assign_storage( ) ;
    id_for_valid_filename = new_item_id ;
    data_type_for_item[ id_for_valid_filename ] = data_type_text_characters ;
    pointer_allocation_end_for_item[ id_for_valid_filename ] -= 5 ;

    create_new_item_id_and_assign_storage( ) ;
    id_for_valid_folder_name = new_item_id ;
    data_type_for_item[ id_for_valid_folder_name ] = data_type_text_characters ;
    pointer_allocation_end_for_item[ id_for_valid_folder_name ] -= 5 ;


// -----------------------------------------------
//  Initialize some counters that track other
//  kinds of storage usage.

    next_available_defined_phrase_number = 1 ;


// -----------------------------------------------
//  Initialize some variables.

    yes_or_no = yes_yes ;
    yes_or_no_requesting_space_appended = yes_yes ;
    number_of_hyphenated_phrase_names_in_text_items = 0 ;
    pointer_stack_pointer_for_get_next_previous_character = 0 ;
    pointer_stack_level_bottom = 0 ;


// -----------------------------------------------
//  End of function do_main_initialization.

    return ;

}


// -----------------------------------------------
// -----------------------------------------------
//  Function show_one_defined_text_item
//
//  This function is intended for debugging.

void show_one_defined_text_item( )
{
    log_out << "[item " << item_id << " spans " << pointer_begin_for_item[ item_id ] << " to " << pointer_end_for_item[ item_id ] << "]" ;
    for ( character_pointer = pointer_begin_for_item[ item_id ] ; character_pointer <= pointer_end_for_item[ item_id ] ; character_pointer ++ )
    {
//        log_out << "[" << all_characters[ character_pointer ] << "]" ;
        log_out << char( all_characters[ character_pointer ] ) ;
    }
    log_out << std::endl ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function show_defined_text_items
//
//  This function is intended for debugging.

void show_defined_text_items( )
{
    for ( item_id = 1 ; item_id < next_available_item_id ; item_id ++ )
    {
        show_one_defined_text_item( ) ;
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function exit_not_yet_supported
//
//  Provide an exit for functionality that has not
//  yet been written.

void exit_not_yet_supported( )
{
    log_out << "BUG:  This data type, " << data_type << ", (or some other capability) is not yet supported." << std::endl ;
    exit( EXIT_FAILURE ) ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function choose_slash_or_backslash
//
//  Checks the operating system to
//  determine whether slashes or backslashes
//  should be used in folder names.
//
//  This code uses compiler macros because there
//  is no way to create a library function that
//  would work on all operating systems.

void choose_slash_or_backslash( )
{
    yes_or_no_use_slash_not_backslash = yes_yes ;
    #ifdef _WIN32
    yes_or_no_use_slash_not_backslash = no_no ;
    #endif
    #ifdef _WIN64
    yes_or_no_use_slash_not_backslash = no_no ;
    #endif
}


// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
//  Function create_new_item_id_and_assign_storage
//
//  Initialize the pointers that will keep track
//  of a new item.  The new item ID is supplied in
//  the variable "new_item_id".
//  The variable
//  "length_requested_for_next_item_storage"
//  specifies how much storage is allocated.
//  The data type must be specified in the
//  variable "data_type" and it determines
//  which storage area holds the item's contents.
//  If the data type is "linked_list" then an
//  extra two pointer positions are added for
//  pointing to the "next" and "prior" items in
//  the same list.

void create_new_item_id_and_assign_storage( )
{
    new_item_id = next_available_item_id ;
    next_available_item_id ++ ;
    data_type_for_item[ new_item_id ] = data_type ;
    switch ( data_type )
    {
        case data_type_text_characters :
            pointer_begin_for_item[ new_item_id ] = next_available_begin_pointer_for_data_type_text_characters ;
            next_available_begin_pointer_for_data_type_text_characters += length_requested_for_next_item_storage ;
            pointer_allocation_end_for_item[ new_item_id ] = next_available_begin_pointer_for_data_type_text_characters - 1 ;
            pointer_end_for_item[ new_item_id ] = pointer_begin_for_item[ new_item_id ] - 1 ;
            break ;
        case data_type_list_of_integers :
            pointer_begin_for_item[ new_item_id ] = next_available_begin_pointer_for_data_type_list_of_integers ;
            next_available_begin_pointer_for_data_type_list_of_integers += length_requested_for_next_item_storage ;
            pointer_allocation_end_for_item[ new_item_id ] = next_available_begin_pointer_for_data_type_list_of_integers - 1 ;
            pointer_end_for_item[ new_item_id ] = pointer_begin_for_item[ new_item_id ] - 1 ;
            break ;
        case data_type_list_of_decimal_numbers :
            pointer_begin_for_item[ new_item_id ] = next_available_begin_pointer_for_data_type_list_of_decimal_numbers ;
            next_available_begin_pointer_for_data_type_list_of_decimal_numbers += length_requested_for_next_item_storage ;
            pointer_allocation_end_for_item[ new_item_id ] = next_available_begin_pointer_for_data_type_list_of_decimal_numbers - 1 ;
            pointer_end_for_item[ new_item_id ] = pointer_begin_for_item[ new_item_id ] - 1 ;
            break ;
        case data_type_linked_list :
            pointer_begin_for_item[ new_item_id ] = next_available_begin_pointer_for_data_type_linked_list + 1 ;
            next_available_begin_pointer_for_data_type_linked_list += length_requested_for_next_item_storage + 2 ;
            pointer_allocation_end_for_item[ new_item_id ] = next_available_begin_pointer_for_data_type_linked_list - 2 ;
            pointer_end_for_item[ new_item_id ] = pointer_begin_for_item[ new_item_id ] + length_requested_for_next_item_storage - 1 ;
            all_pointers[ pointer_begin_for_item[ new_item_id ] - 1 ] = 0 ;
            all_pointers[ pointer_end_for_item[ new_item_id ] + 1 ] = 0 ;
            break ;
        default :
            pointer_begin_for_item[ new_item_id ] = next_available_begin_pointer_for_data_type_linked_list ;
            next_available_begin_pointer_for_data_type_linked_list += length_requested_for_next_item_storage ;
            pointer_allocation_end_for_item[ new_item_id ] = next_available_begin_pointer_for_data_type_linked_list - 1 ;
            pointer_end_for_item[ new_item_id ] = pointer_begin_for_item[ new_item_id ] - 1 ;
            break ;
    }
    pointer_to_definition_of_item[ new_item_id ] = 0 ;
    access_flag_for_item[ new_item_id ] = access_flag_can_change ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function measure_space_occupied_by_item
//
//  Measure how much space is occupied by the
//  specified item.

void measure_space_occupied_by_item( )
{
    space_occupied_by_item = pointer_end_for_item[ item_id ] - pointer_begin_for_item[ item_id ] + 1 ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function measure_space_available_in_item
//
//  Measure how much additional space is available
//  in the specified item.

void measure_space_available_in_item( )
{
    space_available_in_item = pointer_allocation_end_for_item[ item_id ] - pointer_end_for_item[ item_id ] ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function adjust_storage_space_to_fit_newest_item
//
//  If the newest item does not fully occupy the
//  allocated space, or it exceeds the storage
//  space that was originally allocated, change
//  the allocation size.  If the data type is
//  "linked_list", allow space for the "next"
//  and "prior" pointers.

void adjust_storage_space_to_fit_newest_item( )
{
    if ( new_item_id != ( next_available_item_id - 1 ) )
    {
        return ;
    }
    data_type = data_type_for_item[ new_item_id ] ;
    pointer_allocation_end_for_item[ new_item_id ] = pointer_end_for_item[ new_item_id ] ;
    switch ( data_type )
    {
        case data_type_linked_list :
            pointer_allocation_end_for_item[ new_item_id ] += 2 ;
            next_available_begin_pointer_for_data_type_linked_list = pointer_allocation_end_for_item[ new_item_id ] + 1 ;
            break ;
        case data_type_text_characters :
            next_available_begin_pointer_for_data_type_text_characters = pointer_allocation_end_for_item[ new_item_id ] + 1 ;
            break ;
        case data_type_list_of_integers :
            next_available_begin_pointer_for_data_type_list_of_integers = pointer_allocation_end_for_item[ new_item_id ] + 1 ;
            break ;
        case data_type_list_of_decimal_numbers :
            next_available_begin_pointer_for_data_type_list_of_decimal_numbers = pointer_allocation_end_for_item[ new_item_id ] + 1 ;
            break ;
        default :
            next_available_begin_pointer_for_data_type_linked_list = pointer_allocation_end_for_item[ new_item_id ] + 1 ;
            break ;
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function clear_item
//
//  Changes the specified single item to contain
//  nothing.  If the text item still can possibly
//  be referenced by another higher-level item,
//  do not use this function, and instead point to
//  the empty text item or create a new item.

void clear_item( )
{
    pointer_end_for_item[ id_text_to_edit ] = pointer_begin_for_item[ id_text_to_edit ] - 1 ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function check_yes_or_no_solo_item_is_empty

void check_yes_or_no_solo_item_is_empty( )
{
    if ( pointer_end_for_item[ item_id ] < pointer_begin_for_item[ item_id ] )
    {
        yes_or_no_text_item_is_empty = yes_yes ;
        return ;
    }
    data_type = data_type_for_item[ item_id ] ;
    storage_array = storage_array_for_data_type[ data_type ] ;
    switch ( storage_array )
    {
        case storage_array_all_pointers :
            for ( pointer = pointer_begin_for_item[ item_id ] ; pointer <= pointer_end_for_item[ item_id ] ; pointer ++ )
            {
                if ( all_pointers[ pointer ] > 0 )
                {
                    yes_or_no_text_item_is_empty = no_no ;
                    return ;
                }
            }
            break ;
        case storage_array_all_characters :
            for ( pointer = pointer_begin_for_item[ item_id ] ; pointer <= pointer_end_for_item[ item_id ] ; pointer ++ )
            {
                if ( all_characters[ pointer ] > 0 )
                {
                    yes_or_no_text_item_is_empty = no_no ;
                    return ;
                }
            }
            break ;
        case storage_array_all_integers :
            for ( pointer = pointer_begin_for_item[ item_id ] ; pointer <= pointer_end_for_item[ item_id ] ; pointer ++ )
            {
                if ( all_integers[ pointer ] > 0 )
                {
                    yes_or_no_text_item_is_empty = no_no ;
                    return ;
                }
            }
            break ;
        case storage_array_all_decimal_numbers :
            for ( pointer = pointer_begin_for_item[ item_id ] ; pointer <= pointer_end_for_item[ item_id ] ; pointer ++ )
            {
                if ( all_decimal_numbers[ pointer ] > 0.0 )
                {
                    yes_or_no_text_item_is_empty = no_no ;
                    return ;
                }
            }
            break ;
        default :
            for ( pointer = pointer_begin_for_item[ item_id ] ; pointer <= pointer_end_for_item[ item_id ] ; pointer ++ )
            {
                if ( all_pointers[ pointer ] > 0 )
                {
                    yes_or_no_text_item_is_empty = no_no ;
                    return ;
                }
            }
            break ;
    }
    yes_or_no_text_item_is_empty = yes_yes ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function check_yes_or_no_matching_text
//
//  Checks if two sequences of text characters are
//  the same.  It starts checking at both the
//  beginning and the end.  This approach is often
//  faster than going from beginning to end
//  because there are many cases when the
//  beginning is the same for many items.  The
//  characters are assumed to be in
//  "all_characters", the initial character
//  pointers are
//  "character_pointer_begin_for_text_one"
//  and
//  "character_pointer_begin_for_text_two",
//  and the character length minus one is in
//  "character_length_minus_one".

void check_yes_or_no_matching_text( )
{


// -----------------------------------------------
//  Initialization.

    character_begin_pointer_one = character_pointer_begin_for_text_one ;
    character_begin_pointer_two = character_pointer_begin_for_text_two ;
    character_end_pointer_one = character_pointer_begin_for_text_one + character_length_minus_one ;
    character_end_pointer_two = character_pointer_begin_for_text_two + character_length_minus_one ;

    character_count = character_length_minus_one + 1 ;


// -----------------------------------------------
//  Begin a loop that returns when a difference is
//  found, or when all the characters have been
//  checked.

    while ( character_count > 0 )
    {


// -----------------------------------------------
//  Check the next character at or near the
//  beginning of the two character sequences.

        log_out << "character one: " << all_characters[ character_begin_pointer_one ] << "  character two: " << all_characters[ character_begin_pointer_two ] << std::endl ;

        if ( all_characters[ character_begin_pointer_one ] != all_characters[ character_begin_pointer_two ] )
        {
            yes_or_no_same_text = no_no ;
            return ;
        }
        character_begin_pointer_one ++ ;
        character_begin_pointer_two ++ ;
        character_count -- ;


// -----------------------------------------------
//  If all the characters have been checked, exit
//  the loop.

        if ( character_count <= 0 )
        {
            break ;
        }


// -----------------------------------------------
//  Check the next character at or near the end of
//  the two character sequences.

        log_out << "character one: " << all_characters[ character_end_pointer_one ] << "  character two: " << all_characters[ character_end_pointer_two ] << std::endl ;

        if ( all_characters[ character_end_pointer_one ] != all_characters[ character_end_pointer_two ] )
        {
            yes_or_no_same_text = no_no ;
            return ;
        }
        character_end_pointer_one -- ;
        character_end_pointer_two -- ;
        character_count -- ;


// -----------------------------------------------
//  Repeat the loop.

    }


// -----------------------------------------------
//  Indicate a match.

    yes_or_no_same_text = yes_yes ;


// -----------------------------------------------
//  End of check_yes_or_no_matching_text.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function just_copy_simple
//
//  Copies contents for the storage
//  type specified by "storage_array" (not
//  "data_type"), starting at
//  "pointer_for_just_copy_source"
//  for length "length_for_just_copy", with
//  "pointer_for_just_copy_destination"
//  specifying the first position of the copied
//  contents.  This function does not do anything
//  special for data type "pointers_list" because
//  that is not a "storage type".

void just_copy_simple( )
{
    pointer_from = pointer_for_just_copy_source ;
    pointer_to = pointer_for_just_copy_destination ;
    counter = length_for_just_copy ;
    if ( counter < 1 )
    {
        return ;
    }
    switch ( storage_array )
    {
        case storage_array_all_pointers :
//          Yes this case would be handled by the "default" case,
//          but this executes faster because this case
//          occurs more often.
            while ( counter > 0 )
            {
                all_pointers[ pointer_to ] = all_pointers[ pointer_from ] ;
                pointer_from ++ ;
                pointer_to ++ ;
                counter -- ;
            }
            break ;
        case storage_array_all_characters :
            while ( counter > 0 )
            {
                all_characters[ pointer_to ] = all_characters[ pointer_from ] ;
                pointer_from ++ ;
                pointer_to ++ ;
                counter -- ;
            }
            break ;
        case storage_array_all_integers :
            while ( counter > 0 )
            {
                all_integers[ pointer_to ] = all_integers[ pointer_from ] ;
                pointer_from ++ ;
                pointer_to ++ ;
                counter -- ;
            }
            break ;
        case storage_array_all_decimal_numbers :
            while ( counter > 0 )
            {
                all_decimal_numbers[ pointer_to ] = all_decimal_numbers[ pointer_from ] ;
                pointer_from ++ ;
                pointer_to ++ ;
                counter -- ;
            }
            break ;
        default :
            while ( counter > 0 )
            {
                all_pointers[ pointer_to ] = all_pointers[ pointer_from ] ;
                pointer_from ++ ;
                pointer_to ++ ;
                counter -- ;
            }
            break ;
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function copy_solo_item_to_new
//
//  Copy one item into a new storage area.  The
//  copy has the same data type and length as the
//  original.  The original is specified by
//  "item_id".  The copy is
//  specified by "id_for_copy".  If the
//  data type is "linked_list" the "next" and
//  "prior" pointers are set to zeros.

void copy_solo_item_to_new( )
{
    length_of_item = pointer_allocation_end_for_item[ item_id ] - pointer_begin_for_item[ item_id ] + 1 ;
    length_requested_for_next_item_storage = length_of_item ;
    data_type = data_type_for_item[ item_id ] ;
    create_new_item_id_and_assign_storage( ) ;
    id_for_copy = new_item_id ;
    pointer_for_just_copy_source = pointer_begin_for_item[ item_id ] ;
    pointer_for_just_copy_destination = pointer_begin_for_item[ id_for_copy ] ;
    length_for_just_copy = length_requested_for_next_item_storage ;
    storage_array = storage_array_for_data_type[ data_type ] ;
    just_copy_simple( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function check_yes_or_no_character_is_delimiter

void check_yes_or_no_character_is_delimiter( )
{
    switch ( single_character_as_integer )
    {
        case unicode_for_space :
            yes_or_no_character_is_delimiter = yes_yes ;
            break ;
        case unicode_for_tab :
            yes_or_no_character_is_delimiter = yes_yes ;
            break ;
        case unicode_for_newline :
            yes_or_no_character_is_delimiter = yes_yes ;
            break ;
        case unicode_for_formfeed :
            yes_or_no_character_is_delimiter = yes_yes ;
            break ;
        case unicode_for_carriage_return :
            yes_or_no_character_is_delimiter = yes_yes ;
            break ;
        default :
            yes_or_no_character_is_delimiter = no_no ;
            break ;
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  convert_integer_to_text
//
//  Converts the integer stored in
//  single_integer into text digits that
//  are stored in text item
//  "id_for_number_as_text".

void convert_integer_to_text( )
{


// -----------------------------------------------
//  Point to where the first character (as an
//  integer) will be stored.

    character_pointer_for_text_item = pointer_begin_for_item[ id_for_number_as_text ] ;


// -----------------------------------------------
//  If the integer is zero, just use the single
//  digit zero (0).

    if ( single_integer == 0 )
    {
        c_format_string[ 0 ] = '0' ;
        character_count = 1 ;


// -----------------------------------------------
//  Otherwise, convert the integer into
//  digit characters.

    } else
    {
        try
        {
            character_count = sprintf( c_format_string , "%1d" , single_integer ) ;
        }


// -----------------------------------------------
//  If the conversion was not successful, insert
//  the text "not_an_integer".

        catch( ... )
        {
            c_format_string[ 0 ] = 'n' ;
            c_format_string[ 1 ] = 'o' ;
            c_format_string[ 2 ] = 't' ;
            c_format_string[ 3 ] = '_' ;
            c_format_string[ 4 ] = 'a' ;
            c_format_string[ 5 ] = 'n' ;
            c_format_string[ 6 ] = '_' ;
            c_format_string[ 7 ] = 'i' ;
            c_format_string[ 8 ] = 'n' ;
            c_format_string[ 9 ] = 't' ;
            c_format_string[ 10 ] = 'e' ;
            c_format_string[ 11 ] = 'g' ;
            c_format_string[ 12 ] = 'e' ;
            c_format_string[ 13 ] = 'r' ;
            character_count = 14 ;
        }
    }


// -----------------------------------------------
//  Store the text.

    for ( character_pointer = 0 ; character_pointer < character_count ; character_pointer ++ )
    {
        single_character_as_integer = (int) c_format_string[ character_pointer ] ;
        all_characters[ character_pointer_for_text_item ] = single_character_as_integer ;
        character_pointer_for_text_item ++ ;
        log_out << "digit " << single_character_as_integer << std::endl ;
    }
    pointer_end_for_item[ id_for_number_as_text ] = character_pointer_for_text_item - 1 ;
    data_type_for_item[ id_for_number_as_text ] = data_type_text_characters ;


// -----------------------------------------------
//  End of function convert_integer_to_text.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  convert_decimal_to_text
//
//  Converts the decimal stored in
//  single_decimal_number into text digits
//  that are stored in text item
//  id_for_number_as_text.

void convert_decimal_to_text( )
{


// -----------------------------------------------
//  If the decimal number is zero, use the text
//  "0.0".

    if ( single_decimal_number == 0 )
    {
        c_format_string[ 0 ] = '0' ;
        c_format_string[ 1 ] = '.' ;
        c_format_string[ 2 ] = '0' ;
        character_count = 3 ;


// -----------------------------------------------
//  Otherwise, convert the decimal number into
//  digit characters, plus a decimal point.

    } else
    {
        try
        {
            character_count = sprintf( c_format_string , "%1f" , single_decimal_number ) ;
        }


// -----------------------------------------------
//  If the conversion was not successful, insert
//  the text "not_a_number".

        catch( ... )
        {
            c_format_string[ 0 ] = 'n' ;
            c_format_string[ 1 ] = 'o' ;
            c_format_string[ 2 ] = 't' ;
            c_format_string[ 3 ] = '_' ;
            c_format_string[ 4 ] = 'a' ;
            c_format_string[ 5 ] = '_' ;
            c_format_string[ 6 ] = 'n' ;
            c_format_string[ 7 ] = 'u' ;
            c_format_string[ 8 ] = 'm' ;
            c_format_string[ 9 ] = 'b' ;
            c_format_string[ 10 ] = 'e' ;
            c_format_string[ 11 ] = 'r' ;
            character_count = 12 ;
        }
    }


// -----------------------------------------------
//  Store the text.

    character_pointer_for_text_item = pointer_begin_for_item[ id_for_number_as_text ] ;
    for ( character_pointer = 0 ; character_pointer < character_count ; character_pointer ++ )
    {
        single_character_as_integer = (int) c_format_string[ character_pointer ] ;
        all_characters[ character_pointer_for_text_item ] = single_character_as_integer ;
        character_pointer_for_text_item ++ ;
    }
    pointer_begin_for_item[ id_for_number_as_text ] = character_pointer_for_text_item - 1 ;


// -----------------------------------------------
//  End of function convert_decimal_to_text.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function convert_list_of_integers_into_text_item
//
//  Convert the text item at
//  "id_for_list_of_integers", which is
//  assumed to be a list of integers, into a text
//  item that contains only integers, with one
//  space between each adjacent pair of numbers.
//  The result is put into the item specified by
//  "id_for_integers_as_text".

void convert_list_of_integers_into_text_item( )
{


// -----------------------------------------------
//  Create a new text item to hold the generated
//  text.

    data_type = data_type_text_characters ;
    length_requested_for_next_item_storage = 200 ;
    create_new_item_id_and_assign_storage( ) ;
    id_for_integers_as_text = new_item_id ;


// -----------------------------------------------
//  Begin a loop that handles each integer.

    integer_position_begin = pointer_begin_for_item[ id_for_list_of_integers ] ;
    integer_position_current =  integer_position_begin ;
    integer_position_end = pointer_end_for_item[ id_for_list_of_integers ] ;
    while ( integer_position_current <= integer_position_end )
    {


// -----------------------------------------------
//  Convert the integer into text.

        single_integer = all_integers[ integer_position_current ] ;
        convert_integer_to_text( ) ;


// -----------------------------------------------
//  Insert a space between adjacent numbers.

        if ( integer_position_current != integer_position_begin )
        {
            pointer_end_for_item[ id_for_integers_as_text ] ++ ;
            all_characters[ pointer_end_for_item[ id_for_integers_as_text ] ] = unicode_for_space ;
        }


// -----------------------------------------------
//  Append the digits to the text item.

        pointer_for_just_copy_source = pointer_begin_for_item[ id_for_number_as_text ] ;
        length_for_just_copy = pointer_end_for_item[ id_for_number_as_text ] - pointer_for_just_copy_source + 1 ;
        pointer_for_just_copy_destination = pointer_end_for_item[ id_for_integers_as_text ] + 1 ;
        storage_array = storage_array_all_characters ;
        just_copy_simple( ) ;
        pointer_end_for_item[ id_for_integers_as_text ] += length_for_just_copy - 1 ;


// -----------------------------------------------
//  Repeat the loop for the next integer.

        integer_position_current ++ ;
    }


// -----------------------------------------------
//  Adjust the storage size to fit the result.

    adjust_storage_space_to_fit_newest_item( ) ;


// -----------------------------------------------
//  End of convert_list_of_integers_into_text_item.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function convert_list_of_decimal_numbers_into_text_item
//
//  Convert a text item that is a list of decimal
//  numbers into a text item that contains only
//  decimal numbers as text, with one space
//  between each adjacent pair of numbers.
//
//  For comments, look at the function
//  "convert_list_of_integers_into_text_item".

void convert_list_of_decimal_numbers_into_text_item( )
{
    data_type = data_type_text_characters ;
    length_requested_for_next_item_storage = 200 ;
    create_new_item_id_and_assign_storage( ) ;
    id_for_decimal_numbers_as_text = new_item_id ;
    decimal_number_position_begin = pointer_begin_for_item[ id_for_list_of_decimal_numbers ] ;
    decimal_number_position_current =  decimal_number_position_begin ;
    decimal_number_position_end = pointer_end_for_item[ id_for_list_of_decimal_numbers ] ;
    while ( decimal_number_position_current <= decimal_number_position_end )
    {
        single_decimal_number = all_decimal_numbers[ decimal_number_position_current ] ;
        convert_decimal_to_text( ) ;
        if ( decimal_number_position_current != decimal_number_position_begin )
        {
            pointer_end_for_item[ id_for_decimal_numbers_as_text ] ++ ;
            all_characters[ pointer_end_for_item[ id_for_decimal_numbers_as_text ] ] = unicode_for_space ;
        }
        pointer_for_just_copy_source = pointer_begin_for_item[ id_for_number_as_text ] ;
        length_for_just_copy = pointer_end_for_item[ id_for_number_as_text ] - pointer_for_just_copy_source + 1 ;
        pointer_for_just_copy_destination = pointer_end_for_item[ id_for_decimal_numbers_as_text ] + 1 ;
        storage_array = storage_array_all_characters ;
        just_copy_simple( ) ;
        pointer_end_for_item[ id_for_decimal_numbers_as_text ] += length_for_just_copy - 1 ;
        decimal_number_position_current ++ ;
    }
    adjust_storage_space_to_fit_newest_item( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function initialize_parse_characters_of_number
//
//  Prepare to use the function named
//  parse_one_character_of_number.

void initialize_parse_characters_of_number( )
{
    single_integer = 0 ;
    single_decimal_number = 0.0 ;
    decimal_number_divisor = 1.0 ;
    yes_or_no_negative_number = no_no ;
    yes_or_no_decimal_number = no_no ;
    yes_or_no_numeric_delimiter_encountered = no_no ;
    yes_or_no_number_is_valid = yes_yes ;
    number_of_digits_encountered = 0 ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function parse_one_character_of_number
//
//  Handle one character of text that is either an
//  integer or a decimal number.  Gather the
//  information needed to convert the text
//  version of the number into an integer or
//  decimal number.

void parse_one_character_of_number( )
{
    if ( yes_or_no_decimal_number == no_no )
    {
        switch ( single_character_as_integer )
        {
            case unicode_for_period :
                yes_or_no_decimal_number = yes_yes ;
                single_decimal_number = float( single_integer ) ;
                single_integer = 0 ;
                break ;
            case unicode_for_digit_0 :
                single_integer = single_integer * 10 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_1 :
                single_integer = ( single_integer * 10 ) + 1 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_2 :
                single_integer = ( single_integer * 10 ) + 2 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_3 :
                single_integer = ( single_integer * 10 ) + 3 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_4 :
                single_integer = ( single_integer * 10 ) + 4 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_5 :
                single_integer = ( single_integer * 10 ) + 5 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_6 :
                single_integer = ( single_integer * 10 ) + 6 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_7 :
                single_integer = ( single_integer * 10 ) + 7 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_8 :
                single_integer = ( single_integer * 10 ) + 8 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_9 :
                single_integer = ( single_integer * 10 ) + 9 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_hyphen :
                if ( single_integer == 0 )
                {
                    yes_or_no_negative_number = yes_yes ;
                } else
                {
                    log_out << "minus sign not at beginning" << std::endl ;
                }
                break ;
            case unicode_for_plus :
                if ( single_integer > 0 )
                {
                    log_out << "plus sign not at beginning" << std::endl ;
                }
                break ;
            default :
                yes_or_no_numeric_delimiter_encountered = yes_yes ;
                break ;
        }
    } else
    {
        switch ( single_character_as_integer )
        {
            case unicode_for_period :
                yes_or_no_number_is_valid = no_no ;
                log_out << "extra period" << std::endl ;
                break ;
            case unicode_for_digit_0 :
                single_decimal_number = single_decimal_number * 10 ;
                decimal_number_divisor *= 10.0 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_1 :
                single_decimal_number = ( single_decimal_number * 10 ) + 1 ;
                decimal_number_divisor *= 10.0 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_2 :
                single_decimal_number = ( single_decimal_number * 10 ) + 2 ;
                decimal_number_divisor *= 10.0 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_3 :
                single_decimal_number = ( single_decimal_number * 10 ) + 3 ;
                decimal_number_divisor *= 10.0 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_4 :
                single_decimal_number = ( single_decimal_number * 10 ) + 4 ;
                decimal_number_divisor *= 10.0 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_5 :
                single_decimal_number = ( single_decimal_number * 10 ) + 5 ;
                decimal_number_divisor *= 10.0 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_6 :
                single_decimal_number = ( single_decimal_number * 10 ) + 6 ;
                decimal_number_divisor *= 10.0 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_7 :
                single_decimal_number = ( single_decimal_number * 10 ) + 7 ;
                decimal_number_divisor *= 10.0 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_8 :
                single_decimal_number = ( single_decimal_number * 10 ) + 8 ;
                decimal_number_divisor *= 10.0 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_digit_9 :
                single_decimal_number = ( single_decimal_number * 10 ) + 9 ;
                decimal_number_divisor *= 10.0 ;
                number_of_digits_encountered ++ ;
                break ;
            case unicode_for_hyphen :
                if ( single_decimal_number == 0 )
                {
                    yes_or_no_negative_number = yes_yes ;
                } else
                {
                    log_out << "minus sign not at beginning" << std::endl ;
                }
                break ;
            case unicode_for_plus :
                if ( single_decimal_number != 0 )
                {
                    log_out << "minus sign not at beginning" << std::endl ;
                }
                break ;
            default :
                yes_or_no_numeric_delimiter_encountered = yes_yes ;
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
    if ( yes_or_no_number_is_valid == no_no )
    {
        single_integer = 0 ;
        single_decimal_number = 0.0 ;
        log_out << "number is not valid" << std::endl ;
        return ;
    }
    if ( yes_or_no_decimal_number == no_no )
    {
        if ( yes_or_no_negative_number == yes_yes )
        {
            single_integer = - single_integer ;
        }
    } else
    {
        if ( decimal_number_divisor > 1.0 )
        {
            single_decimal_number = single_decimal_number / decimal_number_divisor ;
        }
        if ( yes_or_no_negative_number == yes_yes )
        {
            single_decimal_number = - single_decimal_number ;
        }
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function convert_into_data_type_list_of_integers
//
//  Convert a text item that contains only integers
//  -- in text format -- into a text item that is
//  a list of integers.

void convert_into_data_type_list_of_integers( )
{
    count_of_words_handled = 0 ;
    id_for_integers_as_text = id_from_origin ;
    length_requested_for_next_item_storage = 2 ;
    create_new_item_id_and_assign_storage( ) ;
    id_for_list_of_integers = new_item_id ;
    character_pointer_current = pointer_begin_for_item[ id_for_integers_as_text ] ;
    character_pointer_end = pointer_end_for_item[ id_for_integers_as_text ] ;
    yes_or_no_character_is_delimiter = yes_yes ;
    initialize_parse_characters_of_number( ) ;
    while ( character_pointer_current <= character_pointer_end )
    {
        single_character_as_integer = all_characters[ character_pointer_current ] ;
        check_yes_or_no_character_is_delimiter( ) ;
        if ( yes_or_no_character_is_delimiter == yes_yes )
        {
            continue ;
        }
        character_pointer_begin_for_number = character_pointer_current ;
        if ( yes_or_no_character_is_delimiter == no_no )
        {
            single_character_as_integer = all_characters[ character_pointer_current ] ;
            parse_one_character_of_number( ) ;
            if ( ( yes_or_no_numeric_delimiter_encountered == yes_yes ) || ( character_pointer_current == pointer_end_for_item[ id_from_origin ] ) )
            {
                if ( number_of_digits_encountered > 0 )
                {
                    if ( yes_or_no_number_is_valid == yes_yes )
                    {
                        finish_parse_characters_of_number( ) ;
                        if ( yes_or_no_decimal_number == no_no )
                        {
                            pointer_end_for_item[ id_for_list_of_integers ] ++ ;
                            all_integers[ pointer_end_for_item[ id_for_list_of_integers ] ] = single_integer ;
                            log_out << "integer number = " << single_integer << std::endl ;
                            break ;
                        } else
                        {
                            id_for_list_of_integers = 0 ;
                            id_text_to_edit = 0 ;
                            adjust_storage_space_to_fit_newest_item( ) ;
                            log_out << "number is not integer, is decimal" << std::endl ;
                            return ;
                        }
                    } else
                    {
                        id_for_list_of_integers = 0 ;
                        id_text_to_edit = 0 ;
                        adjust_storage_space_to_fit_newest_item( ) ;
                        log_out << "invalid number" << std::endl ;
                        return ;
                    }
                }
                initialize_parse_characters_of_number( ) ;
            }
        }
        character_pointer_current ++ ;
        measure_space_available_in_item( ) ;
        if ( space_available_in_item < 1 )
        {
            adjust_storage_space_to_fit_newest_item( ) ;
        }
    }
    adjust_storage_space_to_fit_newest_item( ) ;
    id_text_to_edit = id_for_list_of_integers ;
    data_type_for_item[ id_for_list_of_integers ] = data_type_list_of_integers ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function convert_into_data_type_list_of_decimal_numbers
//
//  Convert a text item that contains only decimal
//  numbers -- in text format -- into a text item
//  that is a list of decimal numbers.

void convert_into_data_type_list_of_decimal_numbers( )
{
    count_of_words_handled = 0 ;
    id_for_decimal_numbers_as_text = id_from_origin ;
    length_requested_for_next_item_storage = 2 ;
    create_new_item_id_and_assign_storage( ) ;
    id_for_list_of_decimal_numbers = new_item_id ;
    character_pointer_current = pointer_begin_for_item[ id_for_decimal_numbers_as_text ] ;
    character_pointer_end = pointer_end_for_item[ id_for_decimal_numbers_as_text ] ;
    yes_or_no_character_is_delimiter = yes_yes ;
    initialize_parse_characters_of_number( ) ;
    while ( character_pointer_current <= character_pointer_end )
    {
        single_character_as_integer = all_characters[ character_pointer_current ] ;
        check_yes_or_no_character_is_delimiter( ) ;
        if ( yes_or_no_character_is_delimiter == yes_yes )
        {
            continue ;
        }
        character_pointer_begin_for_number = character_pointer_current ;
        if ( yes_or_no_character_is_delimiter == no_no )
        {
            single_character_as_integer = all_characters[ character_pointer_current ] ;
            parse_one_character_of_number( ) ;
            if ( ( yes_or_no_numeric_delimiter_encountered == yes_yes ) || ( character_pointer_current == pointer_end_for_item[ id_from_origin ] ) )
            {
                if ( number_of_digits_encountered > 0 )
                {
                    if ( yes_or_no_number_is_valid == yes_yes )
                    {
                        finish_parse_characters_of_number( ) ;
                        if ( yes_or_no_decimal_number == no_no )
                        {
                            pointer_end_for_item[ id_for_list_of_decimal_numbers ] ++ ;
                            all_decimal_numbers[ pointer_end_for_item[ id_for_list_of_decimal_numbers ] ] = single_decimal_number ;
                            log_out << "decimal_number number = " << single_decimal_number << std::endl ;
                            break ;
                        } else
                        {
                            id_for_list_of_decimal_numbers = 0 ;
                            id_text_to_edit = 0 ;
                            adjust_storage_space_to_fit_newest_item( ) ;
                            log_out << "number is not decimal_number, is integer" << std::endl ;
                            return ;
                        }
                    } else
                    {
                        id_for_list_of_decimal_numbers = 0 ;
                        id_text_to_edit = 0 ;
                        adjust_storage_space_to_fit_newest_item( ) ;
                        log_out << "invalid number" << std::endl ;
                        return ;
                    }
                }
                initialize_parse_characters_of_number( ) ;
            }
        }
        character_pointer_current ++ ;
        measure_space_available_in_item( ) ;
        if ( space_available_in_item < 1 )
        {
            adjust_storage_space_to_fit_newest_item( ) ;
        }
    }
    adjust_storage_space_to_fit_newest_item( ) ;
    id_text_to_edit = id_for_list_of_decimal_numbers ;
    data_type_for_item[ id_for_list_of_decimal_numbers ] = data_type_list_of_decimal_numbers ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function initialize_parse_characters_of_filename

void initialize_parse_characters_of_filename( )
{
    yes_or_no_filename_is_valid = yes_yes ;
    yes_or_no_in_filename_before_period = yes_yes ;
    number_of_valid_characters_encountered = 0 ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function parse_one_character_of_filename

void parse_one_character_of_filename( )
{
    character_category = character_category_number_for_character_number[ single_character_as_integer ] ;
    switch ( character_category )
    {
        case character_category_period :
            yes_or_no_in_filename_before_period = no_no ;
            if ( number_of_valid_characters_encountered < 1 )
            {
                yes_or_no_filename_is_valid = no_no ;
            }
            log_out << "period" << std::endl ;
            break ;
        case character_category_other :
            number_of_valid_characters_encountered ++ ;
            log_out << "valid character" << std::endl ;
            break ;
        case character_category_digit :
            number_of_valid_characters_encountered ++ ;
            log_out << "valid character" << std::endl ;
            break ;
        case character_category_hyphen :
            number_of_valid_characters_encountered ++ ;
            log_out << "valid character" << std::endl ;
            break ;
        case character_category_underscore :
            number_of_valid_characters_encountered ++ ;
            log_out << "valid character" << std::endl ;
            break ;
        default :
            yes_or_no_filename_delimiter_encountered = yes_yes ;
            log_out << "delimiter" << std::endl ;
            break ;
    }
    if ( yes_or_no_filename_delimiter_encountered == yes_yes )
    {
        if ( ( yes_or_no_in_filename_before_period == no_no ) && ( number_of_valid_characters_encountered < 1 ) )
        {
           yes_or_no_filename_is_valid = no_no ;
        }
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function initialize_parse_characters_of_folder_name

void initialize_parse_characters_of_folder_name( )
{
    yes_or_no_folder_name_is_valid = yes_yes ;
    yes_or_no_in_folder_name_before_period = yes_yes ;
    number_of_valid_characters_encountered = 0 ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function parse_one_character_of_folder_name

void parse_one_character_of_folder_name( )
{
    character_category = character_category_number_for_character_number[ single_character_as_integer ] ;
    switch ( character_category )
    {
        case character_category_other :
            number_of_valid_characters_encountered ++ ;
            log_out << "valid character" << std::endl ;
            break ;
        case character_category_digit :
            number_of_valid_characters_encountered ++ ;
            log_out << "valid character" << std::endl ;
            break ;
        case character_category_hyphen :
            number_of_valid_characters_encountered ++ ;
            log_out << "valid character" << std::endl ;
            break ;
        case character_category_underscore :
            number_of_valid_characters_encountered ++ ;
            log_out << "valid character" << std::endl ;
            break ;
        case character_category_slash :
            yes_or_no_folder_name_delimiter_encountered = yes_yes ;
            log_out << "valid character" << std::endl ;
            break ;
        case character_category_backslash :
            yes_or_no_folder_name_delimiter_encountered = yes_yes ;
            log_out << "valid character" << std::endl ;
            break ;
        default :
            yes_or_no_folder_name_delimiter_encountered = yes_yes ;
            log_out << "delimiter" << std::endl ;
            break ;
    }
    if ( yes_or_no_folder_name_delimiter_encountered == yes_yes )
    {
        if ( ( yes_or_no_in_folder_name_before_period == no_no ) && ( number_of_valid_characters_encountered < 1 ) )
        {
           yes_or_no_folder_name_is_valid = no_no ;
        }
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function write_single_character_to_file
//
//  Write the the character -- expressed as an
//  integer -- to the output file.  The character
//  integer is supplied in the variable
//  single_character_as_integer.  Ignore
//  any error responses.
//
//  Later, replace "fputc" function with C++ code
//  that handles Unicode characters, including
//  Chinese characters.

void write_single_character_as_integer_to_file( )
{
    response_ignored = fputc( char( single_character_as_integer ) , outfile_connection ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function store_text_and_get_its_item_id
//
//  Gets the text word supplied as a function
//  argument in C string format, stores it in
//  all_characters, and returns the text
//  item ID number for this text.  This is needed
//  during initialization.

int store_text_and_get_its_item_id( const char * local_this_word )
{


// -----------------------------------------------
//  Count the characters to be stored, and request
//  this amount of storage space.
//
//  Reminder:  The first character position is
//  zero because this code handles text that
//  is imported using the strcpy function.

    character_count = 0 ;
    for ( size_t character_pointer = 0 ; character_pointer < ( strlen( local_this_word ) ) ; character_pointer ++ )
    {
        single_character = (int) local_this_word[ character_pointer ] ;
        if ( single_character == 0 )
        {
            break ;
        }
        character_count ++ ;
    }
    length_requested_for_next_item_storage = character_count ;


// -----------------------------------------------
//  Create the storage for the text item.

    create_new_item_id_and_assign_storage( ) ;


// -----------------------------------------------
//  Store the characters in the new text item.
//
//  Reminder:  The first character position is
//  zero because this code handles text that
//  is imported using the strcpy function.

    next_character_position_in_storage_all_text = pointer_begin_for_item[ new_item_id ] ;
    for ( size_t character_pointer = 0 ; character_pointer < ( strlen( local_this_word ) ) ; character_pointer ++ )
    {
        single_character = (int) local_this_word[ character_pointer ] ;
        all_characters[ next_character_position_in_storage_all_text ] = single_character ;
        next_character_position_in_storage_all_text ++ ;
    }


// -----------------------------------------------
//  Update the pointer to the end of the
//  just-stored text.

    pointer_end_for_item[ new_item_id ] = pointer_begin_for_item[ new_item_id ] + character_count - 1 ;


// -----------------------------------------------
//  Specify the data type for this text item.

    data_type_for_item[ new_item_id ] = data_type_text_characters ;


// -----------------------------------------------
//  Return with the item ID number

    return new_item_id ;


// -----------------------------------------------
//  End of function store_text_and_get_its_item_id.

}


// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
//  Function create_linked_list
//
//  Creates a linked list.  The variable
//  "id_linked_list" points to the new item.
//  If the "requested_length" is zero then the
//  default size of 35 is used.  The list is
//  empty.

void create_linked_list( )
{
    if ( requested_length > 0 )
    {
        length_requested_for_next_item_storage = requested_length ;
    } else
    {
        length_requested_for_next_item_storage = 35 ;
    }
    data_type = data_type_linked_list ;
    create_new_item_id_and_assign_storage( ) ;
    id_linked_list = new_item_id ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function clear_linked_list
//
//  Clears the content from every segment of a
//  linked list.  The segments of the linked
//  list remain linked.

void clear_linked_list( )
{
    id_linked_list_segment_next = id_linked_list ;
    while ( id_linked_list_segment_next > 0 )
    {
        pointer_end_for_item[ id_linked_list_segment_next ] = pointer_begin_for_item[ id_linked_list_segment_next ] - 1 ;
        id_linked_list_segment_next = all_pointers[ pointer_allocation_end_for_item[ id_linked_list_segment_next ] + 1 ] ;
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_first_number_from_linked_list
//
//  Gets, and puts into
//  "first_number_from_linked_list", the first
//  number from the linked list that includes
//  "id_linked_list_current_segment_source" as the
//  current segment within the linked list.  The
//  variable
//  "pointer_for_get_next_number_from_linked_list"
//  is updated to allow the function
//  "get_first_number_from_linked_list" to get
//  the next number.

//  todo: proofread

void get_first_number_from_linked_list( )
{
    id_linked_list_current_segment_source = id_linked_list ;
    if ( pointer_begin_for_item[ id_linked_list_current_segment_source ] <= pointer_end_for_item[ id_linked_list_current_segment_source ] )
    {
        pointer_for_get_next_number_from_linked_list = pointer_begin_for_item[ id_linked_list_current_segment_source ] ;
        next_number_from_linked_list = all_pointers[ pointer_for_get_next_number_from_linked_list ] ;
        return ;
    }
    first_number_from_linked_list = 0 ;
    id_linked_list_current_segment_source = 0 ;
    pointer_for_get_next_number_from_linked_list = 0 ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_next_number_from_linked_list
//
//  Gets, and puts into
//  "next_number_from_linked_list", the next
//  number from the linked list that includes
//  "id_linked_list_current_segment_source" as the
//  current segment within the linked list.  The
//  variable
//  "pointer_for_get_next_number_from_linked_list"
//  points to the previous position from which
//  this function got the previous number.
//  This pointer must be initialized by the function
//  "get_first_number_from_linked_list" before the
//  first use of this function.

//  todo: proofread

void get_next_number_from_linked_list( )
{
    pointer_for_get_next_number_from_linked_list ++ ;
    while ( ( id_linked_list_current_segment_source > 0 ) && ( pointer_for_get_next_number_from_linked_list > 0 ) )
    {
        if ( pointer_for_get_next_number_from_linked_list <=pointer_end_for_item[ id_linked_list_current_segment_source ] )
        {
            next_number_from_linked_list = all_pointers[ pointer_for_get_next_number_from_linked_list ] ;
            return ;
        }
        id_linked_list_current_segment_source = all_pointers[ pointer_allocation_end_for_item[ id_linked_list_current_segment_source ] + 1 ] ;
    }
    id_linked_list_current_segment_source = 0 ;
    pointer_for_get_next_number_from_linked_list = 0 ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_last_segment_in_linked_list

//  Gets the last segment in the linked list
//  pointed to by "id_linked_list" and
//  puts that item ID number into
//  "id_linked_list_segment_last".  This function
//  ignores any content in any segment.

void get_last_segment_in_linked_list( )
{
    id_linked_list_segment_next = id_linked_list ;
    while ( id_linked_list_segment_next > 0 )
    {
        id_linked_list_segment_next = all_pointers[ pointer_allocation_end_for_item[ id_linked_list_segment_next ] + 1 ] ;
    }
    id_linked_list_segment_last = id_linked_list_segment_next ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function extend_linked_list
//
//  Create a new item that is a segment that
//  extends the length of the existing linked list
//  pointed to by "id_linked_list".
//  If the value of "requested_length" is less
//  than one, create a new segment that
//  is three times longer than the size of the
//  prior segment.  The content of the added
//  segment is empty.

void extend_linked_list( )
{
    get_last_segment_in_linked_list( ) ;
    id_linked_list_segment_last_former = id_linked_list_segment_last_occupied ;
    if ( requested_length < 1 )
    {
        length_of_item = pointer_allocation_end_for_item[ id_linked_list_segment_last_occupied ] - pointer_begin_for_item[ id_linked_list_segment_last_occupied ] + 1 ;
        requested_length = 3 * length_of_item ;
    }
    data_type = data_type_linked_list ;
    create_new_item_id_and_assign_storage( ) ;
    id_linked_list_segment_last_occupied = new_item_id ;
    all_pointers[ pointer_allocation_end_for_item[ id_linked_list_segment_last_former ] + 1 ] = id_linked_list_segment_last_occupied ;
    all_pointers[ pointer_begin_for_item[ id_linked_list_segment_last_occupied ] - 1 ] = id_linked_list_segment_last_former ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_length_of_linked_list
//
//  Measure the length of the full linked list,
//  but counting only content, not segment lengths
//  because segements at the end can be empty.
//  Also get the item ID of the last segment that
//  has content, and measure the length of this
//  content in the last occupied segment.

void get_length_of_linked_list( )
{
    id_linked_list_segment_first = id_linked_list ;
    id_linked_list_segment_next = id_linked_list ;
    length_of_linked_list = 0 ;
    length_of_content_in_segment = pointer_end_for_item[ id_linked_list_segment_next ] - pointer_begin_for_item[ id_linked_list_segment_next ] + 1 ;
    while ( ( length_of_content_in_segment > 0 ) && ( id_linked_list_segment_next > 0 ) )
    {
        length_of_linked_list += length_of_content_in_segment ;
        id_linked_list_segment_next = all_pointers[ pointer_allocation_end_for_item[ id_linked_list_segment_next ] + 1 ] ;
        if ( id_linked_list_segment_next < 1 )
        {
            break ;
        }
        length_of_content_in_segment = pointer_end_for_item[ id_linked_list_segment_next ] - pointer_begin_for_item[ id_linked_list_segment_next ] + 1 ;
    }
    id_linked_list_segment_last_occupied = id_linked_list_segment_next ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function append_number_to_linked_list
//
//  Append the number in
//  "single_number_to_append" to the end of the
//  linked list specified by "id_linked_list".

void append_number_to_linked_list( )
{
    get_length_of_linked_list( ) ;
    if ( pointer_allocation_end_for_item[ id_linked_list_segment_last_occupied ] <= pointer_end_for_item[ id_linked_list_segment_last_occupied ] )
    {

//  todo: proofread here

        id_linked_list_segment_last_with_content = id_linked_list_segment_last_occupied ;
        id_linked_list_segment_next = all_pointers[ pointer_allocation_end_for_item[ id_linked_list_segment_last_occupied ] + 1 ] ;
        if ( id_linked_list_segment_next > 0 )
        {
            id_linked_list_segment_last_occupied = id_linked_list_segment_next ;
        } else
        {
            requested_length = 0 ;
            extend_linked_list( ) ;
        }
    }
    pointer = pointer_end_for_item[ id_linked_list_segment_last_occupied ] + 1 ;
    pointer_end_for_item[ id_linked_list_segment_last_occupied ] = pointer ;
    all_pointers[ pointer ] = single_number_to_append ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function append_another_number_to_linked_list
//
//  Append another number after recently using
//  the function "append_number_to_linked_list".
//  This function assumes the value in
//  "id_linked_list_segment_last_occupied" is
//  still valid.

void append_another_number_to_linked_list( )
{
    if ( pointer_end_for_item[ id_linked_list_segment_last_occupied ] < pointer_allocation_end_for_item[ id_linked_list_segment_last_occupied ] )
    {
        pointer = pointer_end_for_item[ id_linked_list_segment_last_occupied ] + 1 ;
        pointer_end_for_item[ id_linked_list_segment_last_occupied ] = pointer ;
        all_pointers[ pointer ] = single_number_to_append ;
    } else
    {
        append_number_to_linked_list( ) ;
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_last_number_in_linked_list
//
//  Get the last number in the linked list
//  specified by "id_linked_list".  The number is
//  put into "single_number_to_get".  If the
//  linked list is empty, return with a value of
//  zero.

void get_last_number_in_linked_list( )
{
    get_length_of_linked_list( ) ;
    while ( pointer_end_for_item[ id_linked_list_segment_last_occupied ] <= pointer_begin_for_item[ id_linked_list_segment_last_occupied ] )
    {
        id_linked_list_segment_last_occupied = all_pointers[ pointer_begin_for_item[ id_linked_list_segment_last_occupied ] - 1 ] ;
        if ( id_linked_list_segment_last_occupied < 1 )
        {
            single_number_to_get = 0 ;
            return ;
        }
    }
    single_number_to_get = all_pointers[ pointer_end_for_item[ id_linked_list_segment_last_occupied ] ] ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function remove_last_number_from_linked_list
//
//  Remove the last number in the linked list
//  specified by "id_linked_list".  If the linked
//  list is empty, return without any change.
//  Allow for the possibility that multiple
//  segments contain just one number in each
//  segment.

void remove_last_number_from_linked_list( )
{
    get_length_of_linked_list( ) ;
    while ( pointer_allocation_end_for_item[ id_linked_list_segment_last_occupied ] <= pointer_end_for_item[ id_linked_list_segment_last_occupied ] )
    {
        id_linked_list_segment_last_occupied = all_pointers[ pointer_begin_for_item[ id_linked_list_segment_last_occupied ] - 1 ] ;
        if ( id_linked_list_segment_last_occupied < 1 )
        {
            return ;
        }
    }
    pointer_end_for_item[ id_linked_list_segment_last_occupied ] -- ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function copy_linked_list
//
//  Copies the linked list pointed to by
//  "id_linked_list_original" to the linked list
//  pointed to by "id_linked_list_copy".

void copy_linked_list( )
{


// -----------------------------------------------
//  Save the value of "id_linked_list".

    id_linked_list_saved = id_linked_list ;


// -----------------------------------------------
//  If the destination linked list does not
//  already exist, create a new linked list that
//  is the length of the linked list being copied
//  plus room for 35 more numbers.

    if ( id_linked_list_copy == 0 )
    {
        id_linked_list = id_linked_list_original ;
        get_length_of_linked_list( ) ;
        requested_length = length_of_linked_list + 35 ;
        create_linked_list( ) ;
        id_linked_list_copy = id_linked_list ;


// -----------------------------------------------
//  If the destination linked list is not long
//  enough to hold all the content in the original
//  linked list, append a new segment that can
//  hold the full content plus room for 35 more
//  numbers.

    } else
    {
        id_linked_list = id_linked_list_original ;
        get_length_of_linked_list( ) ;
        length_of_linked_list_original = length_of_linked_list ;
        id_linked_list = id_linked_list_original ;
        get_length_of_linked_list( ) ;
        length_of_linked_list_copy = length_of_linked_list ;
        if ( length_of_linked_list_copy < length_of_linked_list_original )
        {
            id_linked_list = id_linked_list_original ;
            requested_length = length_of_linked_list_original - length_of_linked_list_copy + 35 ;
            extend_linked_list( ) ;
        }
    }


// -----------------------------------------------
//  Copy the contents.

    id_linked_list = id_linked_list_copy ;
    get_first_number_from_linked_list( ) ;
    if ( ( id_linked_list_current_segment_source > 0 ) && ( pointer_for_get_next_number_from_linked_list > 0 ) )
    {
        single_number_to_append = first_number_from_linked_list ;
        append_number_to_linked_list( ) ;
    }
    while ( ( id_linked_list_segment_next > 0 ) && ( id_linked_list_current_segment_source > 0 ) && ( pointer_for_get_next_number_from_linked_list > 0 ) )
    {
        get_next_number_from_linked_list( ) ;
        single_number_to_append = next_number_from_linked_list ;
        append_another_number_to_linked_list( )
    }


// -----------------------------------------------
//  Clear the contents of any segments that follow
//  the last segment used for the copy.

    id_linked_list_segment_next = all_pointers[ pointer_allocation_end_for_item[ id_linked_list_segment_next ] + 1 ] ;
    id_linked_list = id_linked_list_segment_next ;
    if ( id_linked_list_segment_next > 0 )
    {
        clear_linked_list( ) ;
    }


// -----------------------------------------------
//  Restore the value of "id_linked_list".

    id_linked_list = id_linked_list_saved ;


// -----------------------------------------------
//  End of copy_linked_list.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
//  Function create_stacked_list
//
//  Creates a stacked list.
//  The stacked list is simply a linked list
//  that is only intended to be used for push and
//  pop operations, or to read the top number.

void create_stacked_list( )
{
    create_linked_list( ) ;
    id_stacked_list = id_linked_list ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function push_number_onto_stacked_list
//
//  Pushes the integer specified in
//  "number_to_push" onto the top of the stacked
//  list specified in "id_stacked_list".

void push_number_onto_stacked_list( )
{
    id_linked_list = id_stacked_list ;
    number_to_append = number_to_push ;
    append_number_to_linked_list( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function read_top_number_in_stacked_list
//
//  Gets (just reads) the integer at the top of
//  the stacked list specified in
//  "id_stacked_list" and puts the number into
//  "number_from_top".

void read_top_number_in_stacked_list( )
{
    id_linked_list = id_stacked_list ;
    get_last_number_in_linked_list( ) ;
    number_from_top = single_number_to_get ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function pop_number_from_stacked_list
//
//  Pops the integer off the top of the stacked
//  list specified as "id_stacked_list" and puts
//  the number into "number_from_top".

void pop_number_from_stacked_list( )
{
    read_top_number_in_stacked_list( ) ;
    remove_last_number_from_linked_list( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
//  Function create_indexed_list
//
//  Creates an indexed list in which a list of
//  pointers are indexed by their position in
//  the list.  The list is identified by the ID
//  in "id_indexed_list".

void create_indexed_list( )
{
    length_requested_for_next_item_storage = 35 ;
    data_type = data_type_linked_list ;
    create_new_item_id_and_assign_storage( ) ;
    id_indexed_list = new_item_id ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function append_number_to_indexed_list
//
//  Appends a number to the end of an indexed
//  pointer list.  The ID that identifies
//  the indexed pointer list is in
//  "id_indexed_list".
//  The number to append is "number_to_append".

void append_number_to_indexed_list( )
{
    id_linked_list = id_indexed_list ;
    single_number_to_append = number_to_append ;
    append_number_to_linked_list( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_number_from_indexed_position
//
//  Within the indexed list specified by
//  "id_indexed_list", find the
//  index position specified by
//  "indexed_list_position_desired" and get the
//  number at that position and put it into
//  "number_from_indexed_list".
//  The item ID of the segment that contains the
//  desired indexed position is saved in
//  "id_indexed_list_segment_containing_desired".
//  If the indexed position is beyond the length
//  of the indexed list, supply the number zero.
//  This function does not check whether the value
//  in "id_indexed_list" is actually a linked
//  list, so the Dashrep compiler must never
//  specify the wrong ID.

void get_number_from_indexed_position( )
{


// -----------------------------------------------
//  Find the item ID of the segment that contains
//  the desired index position.  It is put into
//  "id_indexed_list_segment_containing_desired".

    id_indexed_list_segment_containing_desired = id_indexed_list ;
    index_position_at_end_of_current_segment = 0 ;
    while ( ( index_position_at_end_of_current_segment <= indexed_list_position_desired ) && ( id_indexed_list_segment_containing_desired > 0 ) )
    {
        index_position_at_end_of_current_segment += pointer_end_for_item[ id_indexed_list_segment_containing_desired ] - pointer_begin_for_item[ id_indexed_list_segment_containing_desired ] + 1 ;
        id_indexed_list_segment_containing_desired = all_pointers[ pointer_allocation_end_for_item[ id_indexed_list_segment_containing_desired ] + 1 ] ;
    }

//  todo: verify edge cases when position is at end or beginning of segment


// -----------------------------------------------
//  If the current length of the indexed list is
//  not long enough to include the desired index
//  location, supply a number value of zero and
//  return.

    if ( id_indexed_list_segment_containing_desired < 1 )
    {
        number_from_indexed_list = 0 ;
        segment_position_offset = 0 ;
        return ;
    }


// -----------------------------------------------
//  Calculate the position of the desired number
//  within that segment.

    segment_position_offset = index_position_at_end_of_current_segment - indexed_list_position_desired ;


// -----------------------------------------------
//  Get the number at the specified index
//  position.

//  todo: test this code, including at edge cases

    number_from_indexed_list = all_pointers[ pointer_end_for_item[ id_indexed_list_segment_containing_desired ] - segment_position_offset ] ;
    

// -----------------------------------------------
//  End of get_number_from_indexed_position.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_next_number_from_indexed_list
//
//  Gets the next number from an
//  indexed list after the function
//  "get_number_from_indexed_position"
//  has very recently been used.

void get_next_number_from_indexed_list( )
{


// -----------------------------------------------
//  If the next number is within the same segment
//  as the previous number, update the offset
//  position within the segment, get the number,
//  then return.

    segment_position_offset -- ;
    if ( segment_position_offset > 0 )
    {
        next_number_from_indexed_list = all_pointers[ pointer_end_for_item[ id_indexed_list_segment_containing_desired ] - segment_position_offset ] ;
        return ;
    }


// -----------------------------------------------
//  The new indexed position is not in the same
//  segment as the previous number, so get the ID
//  of the next segment.

    id_indexed_list_segment_containing_desired = all_pointers[ pointer_allocation_end_for_item[ id_indexed_list_segment_containing_desired ] + 1 ] ;


// -----------------------------------------------
//  If the end of the indexed list has been
//  reached, supply a number value of zero and
//  return.

    if ( id_indexed_list_segment_containing_desired < 1 )
    {
        number_from_indexed_list = 0 ;
        segment_position_offset = 0 ;
        return ;
    }


// -----------------------------------------------
//  Update the offset position to point to the
//  first number in that segment, and get the
//  first number in that segment.

//  todo: test this code

    segment_position_offset = pointer_end_for_item[ id_indexed_list_segment_containing_desired ] - pointer_begin_for_item[ id_indexed_list_segment_containing_desired ] - 1 ;
    next_number_from_indexed_list = all_pointers[ pointer_end_for_item[ id_indexed_list_segment_containing_desired ] - segment_position_offset ] ;


// -----------------------------------------------
//  End of function get_next_number_from_indexed_list.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function put_number_into_position_within_indexed_list
//
//  Within the indexed list specified by
//  "id_indexed_list", put into the
//  index position specified by
//  "indexed_list_position_desired"
//  the number in "number_to_put_into_indexed_list".
//  If the last segment is not long enough to
//  reach the desired position, create a new
//  segment that is long enough to reach the
//  desired position.

void put_number_into_position_within_indexed_list( )
{


// -----------------------------------------------
//  Get the item ID of the segment that contains
//  the indexed location, and get the offset
//  position within that segment.

    get_number_from_indexed_position( ) ;


// -----------------------------------------------
//  If the indexed location can be inserted into
//  an existing segment, insert it, then return.

    if ( id_indexed_list_segment_containing_desired > 0 )
    {
        pointer = pointer_end_for_item[ id_indexed_list_segment_containing_desired ] - segment_position_offset  ;
        all_pointers[ pointer ] = number_to_put_into_indexed_list ;
        return ;
    }


// -----------------------------------------------
//  The linked list is not long enough so append
//  one segment that is long enough to reach the
//  desired index position plus three times the
//  length of the prior segment.

    length_of_item = pointer_allocation_end_for_item[ id_indexed_list_segment_containing_desired ] - pointer_begin_for_item[ id_indexed_list_segment_containing_desired ] + 1 ;
    requested_length = indexed_list_position_desired - index_position_at_end_of_current_segment + ( 3 * length_of_item ) ;
    extend_linked_list( ) ;


// -----------------------------------------------
//  Pad the just-added segment with zeros.

    for ( pointer = pointer_begin_for_item[ id_indexed_list_segment_containing_desired ] ; pointer <= pointer_allocation_end_for_item[ id_indexed_list_segment_containing_desired ] ; pointer ++ )
    {
        all_pointers[ pointer ] = 0 ;
    }


// -----------------------------------------------
//  Update the pointer that indicates how much of
//  this segment contains the indexed list.

//  todo: test for correct position

    pointer_end_for_item[ id_indexed_list_segment_containing_desired ] = pointer_allocation_end_for_item[  id_indexed_list_segment_containing_desired ] + indexed_list_position_desired - index_position_at_end_of_current_segment + 1 ;


// -----------------------------------------------
//  Put the supplied number into the appropriate
//  position within the indexed list.

    all_pointers[ pointer_end_for_item[ id_linked_list_segment_last_occupied ] ] = number_to_put_into_indexed_list ;


// -----------------------------------------------
//  End of put_number_into_position_within_indexed_list.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
//  Function read_text_line_from_file
//
//  Reads one line of text from a file and puts
//  the text into the item ID numbered
//  id_for_file_input.  If the end of the file was
//  encountered the previous time this function
//  was executed, or if the end of the file is
//  encountered this time and nothing has been
//  written, then this situation is indicated by
//  the flag "yes_or_no_more_text_in_file" being
//  given a no value ("no_no").
//
//  Later, replace "fgetc" function with C++ code
//  that reads unicode characters.  Test with
//  Chinese characters.

void read_text_line_from_file( )
{
    if ( yes_or_no_encountered_eof_flag == yes_yes )
    {
        yes_or_no_more_text_in_file = no_no ;
        return ;
    }
    pointer_end_for_item[ id_for_file_input ] = pointer_begin_for_item[ id_for_file_input ] - 1 ;
    data_type_for_item[ id_for_file_input ] = data_type_text_characters ;
    item_id = id_for_file_input ;
    measure_space_available_in_item( ) ;
    next_character_number = 1 ;
    while ( next_character_number != EOF )
    {
        next_character_number = fgetc( infile_connection ) ;
        if ( next_character_number == EOF )
        {
            yes_or_no_encountered_eof_flag == yes_yes ;
            if ( pointer_end_for_item[ id_for_file_input ] < pointer_begin_for_item[ id_for_file_input ] )
            {
                yes_or_no_more_text_in_file = no_no ;
                return ;
            }
            break ;
        }
        character_category = character_category_number_for_character_number[ next_character_number ] ;
        if ( character_category == character_category_newline )
        {
            break ;
        }
        if ( space_available_in_item >= 1 )
        {
            pointer_end_for_item[ id_for_file_input ] ++ ;
            all_characters[ pointer_end_for_item[ id_for_file_input ] ] = next_character_number ;
            space_available_in_item -- ;
        } else
        {
            log_out << "[Error: file input line exceeds buffer size so modify code to allow length to be extended]" << std::endl ;
            return ;
        }
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function write_simple_text_item_to_file
//
//  Write the simple text item indicated by
//  "item_id" to the output file.  The simple text
//  item must not involve any pointer or any
//  linked list.

void write_simple_text_item_to_file( )
{
    for ( character_pointer = pointer_begin_for_item[ item_id ] ; character_pointer <= pointer_end_for_item[ item_id ] ; character_pointer ++ )
    {
        single_character_as_integer = all_characters[ character_pointer ] ;
        write_single_character_as_integer_to_file( ) ;
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function specify_character_to_insert_between_subitems

void specify_character_to_insert_between_subitems( )
{
    switch ( data_type )
    {
        data_type_phrase_word_pointers :
            character_to_insert_between_subitems = unicode_for_hyphen ;
            break ;
        data_type_switch_delimiter_to_underscore :
            character_to_insert_between_subitems = unicode_for_underscore ;
            break ;
        default :
            character_to_insert_between_subitems = 0 ;
            break ;
    }
}


// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
//  Function write_to_log
//
//  Can be used to debug the use of text pointers.

void write_to_log( )
{
    log_out << "direction_next_or_previous " << direction_next_or_previous << std::endl << "current_pointer_stack_text_item " << current_pointer_stack_text_item << std::endl << "current_pointer_stack_character_position " << current_pointer_stack_character_position << std::endl << "pointer_begin_for_item[ " << current_pointer_stack_text_item << " ] " << pointer_begin_for_item[ current_pointer_stack_text_item ] << std::endl << "pointer_end_for_item[ " << current_pointer_stack_text_item << " ] " << pointer_end_for_item[ current_pointer_stack_text_item ] << std::endl << "current_pointer_stack_text_item_begin " << current_pointer_stack_text_item_begin << std::endl << "current_pointer_stack_text_item_end " << current_pointer_stack_text_item_end << std::endl << "length_from_item_begin_to_end_minus_one " << length_from_item_begin_to_end_minus_one << std::endl << "data_type_for_item " << data_type_for_item[ current_pointer_stack_text_item ] << std::endl << "yes_or_no_reached_end_of_current_text_item " << yes_or_no_reached_end_of_current_text_item << std::endl << std::endl ;

    test_loop_counter ++ ;
    if ( test_loop_counter > 200 )
    {
        log_out << "reached endless loop counter limit" << std::endl ;
        exit( EXIT_FAILURE ) ;
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function copy_text_pointer
//
//  Copies the information needed to point to a
//  specific character position within a text
//  item, or within a sub text item.  This allows
//  a way to go backward to the most recent
//  character (or delimiter) of a specific type,
//  without losing the current character position
//  being parsed.  Also sometimes two of these
//  text pointers are used to point to the
//  beginning and end of a word (or found
//  matching text), even if it spans beyond a
//  single sub text item.  The copy is pointed to
//  by "id_text_pointer_for_copy" and this
//  linked list must already exist.  The prior
//  contents, if any, are overwritten.
//  The original is pointed to by
//  "id_text_pointer_for_original".

void copy_text_pointer( )
{
	id_linked_list_original = id_text_pointer_for_original ;
	id_linked_list_copy = id_text_pointer_for_copy ;
    copy_linked_list( ) ;
	id_linked_list_original = id_text_pointer_for_original + 1 ;
	id_linked_list_copy = id_text_pointer_for_copy + 1 ;
    copy_linked_list( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function initialize_text_position_direction_next
//
//  Initialize a text position pointer that is used in
//  "get_next_or_previous_character_from_text_item".
//  Specify the "next" (not "previous") direction.
//  The starting item ID is specified in "item_id".
//  If item_id is zero, create a new text position
//  pointer.  A text position pointer uses two
//  stacked lists.  The first stacked list tracks
//  the current item ID.  The second stacked list
//  tracks the character position within that item.
//  The item ID of the second stacked list must be
//  exactly one greater than the item ID of the
//  first stacked list.

void initialize_text_position_direction_next( )
{
    id_text_position_for_getting_next_character = item_id ;
    if ( id_text_position_for_getting_next_character < 1 )
    {
        create_stacked_list( ) ;
        id_text_position_for_getting_next_character = new_item_id ;
        create_stacked_list( ) ;
    }
    id_stacked_list = id_text_position_for_getting_next_character ;
    id_linked_list = id_stacked_list ;
    clear_linked_list( ) ;

// todo: continue writing this code

    number_to_push = id_whatever ;

    push_number_onto_stacked_list( ) ;
    id_stacked_list = id_text_position_for_getting_next_character + 1 ;
    id_linked_list = id_stacked_list ;
    clear_linked_list( ) ;
    number_to_push = 0 ;
    push_number_onto_stacked_list( ) ;
    count_of_characters_remaining_in_item = 0 ;

    id_stacked_list = id_text_position_for_getting_next_character ;

//  todo:
    number_to_push = id_whatever ;
    push_number_onto_stacked_list( ) ;
    data_type = data_type_for_item[ id_whatever ] ;
    current_pointer_stack_text_item = id_whatever ;

    specify_character_to_insert_between_subitems( ) ;
    yes_or_no_inserted_character = no_no ;
    direction_next_or_previous = direction_next ;
    log_out << "init get char" << std::endl ;
    write_to_log( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function initialize_text_position_direction_previous
//
//  Initialize the pointer stack that is used by
//  the function
//  "get_next_or_previous_character_from_text_item"
//  and specify the "previous" (not "next"
//  direction).  The starting item ID is
//  specified in "item_id".

void initialize_text_position_direction_previous( )
{
    initialize_text_position_direction_next( ) ;

// todo:
//  id_text_position_for_getting_next_character

    number_to_push = pointer_end_for_item[ current_pointer_stack_text_item ] - pointer_begin_for_item[ current_pointer_stack_text_item ] + 1 ;

    direction_next_or_previous = direction_previous ;
    log_out << "init get previous char" << std::endl ;
    write_to_log( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------


//  todo: revise all pointer_stack_level code to use
//  two "stacked_list" items, one for the item ID
//  and the other for the offset position within
//  the item.




// -----------------------------------------------
// -----------------------------------------------
//  Function get_next_or_previous_non_pointer_text_item
//
//  Changes the pointer stack named
//  "id_for_pointer_stack_being_followed"
//  to point to the next (or previous)
//  non-pointer text item.  Before using this
//  function, use the function
//  "initialize_text_position_direction_next" or
//  "initialize_get_previous_character_from_text_item".

void get_next_or_previous_non_pointer_text_item( )
{


// -----------------------------------------------
//  Begin a loop that points to the next (or
//  previous) text item -- of any type other than
//  "linked_list".  When needed, move up or
//  down the pointer stack levels, or
//  sometimes both up and down.  The loop exits
//  when the next non-pointer text item has been
//  found.

    while ( id_for_pointer_stack_being_followed > 0 )
    {


// -----------------------------------------------
//  Put the ID of the top pointer stack level into
//  "pointer_stack_level_top".

        pointer_stack_level_current = id_for_pointer_stack_being_followed ;
        get_info_from_pointer_stack_level( ) ;


// -----------------------------------------------
//  Get the following info from the top pointer
//  stack level:  "pointer_stack_level_prior" and
//  "pointer_stack_level_next" and
//  "current_pointer_stack_text_item" and
//  "current_pointer_stack_character_position".
//  If there is only one pointer stack level,
//  this information is already available.

        if ( pointer_stack_level_top != id_for_pointer_stack_being_followed )
        {
            pointer_stack_level_current = pointer_stack_level_top ;
            get_info_from_pointer_stack_level( ) ;
        }


// -----------------------------------------------
//  Write debugging info.

        log_out << "get next item" << std::endl ;
        write_to_log( ) ;


// -----------------------------------------------
//  Point to the beginning and end of the item
//  that is pointed to by the pointer stack, and
//  calculate the length of the item, minus one.

        current_pointer_stack_text_item_begin = pointer_begin_for_item[ current_pointer_stack_text_item ] ;
        current_pointer_stack_text_item_end = pointer_end_for_item[ current_pointer_stack_text_item ] ;
        length_from_item_begin_to_end_minus_one = current_pointer_stack_text_item_end - current_pointer_stack_text_item_begin ;


// -----------------------------------------------
//  If the "character" pointer in
//  "current_pointer_stack_character_position" --
//  which also can point to pointers -- is pointing
//  beyond the range of the top item, indicate that
//  the end (or beginning) of the item has been
//  reached.  Allow for the
//  possibility that the item is empty.

        if ( direction_next_or_previous == direction_next )
        {
            if ( current_pointer_stack_character_position > length_from_item_begin_to_end_minus_one )
            {
                yes_or_no_reached_end_of_current_text_item = yes_yes ;
            } else
            {
                yes_or_no_reached_end_of_current_text_item = no_no ;
            }
        } else
        {
            if ( current_pointer_stack_character_position < 1 )
            {
                yes_or_no_reached_end_of_current_text_item = yes_yes ;
            } else
            {
                yes_or_no_reached_end_of_current_text_item = no_no ;
            }
        }


// -----------------------------------------------
//  If the end (or beginning) of an item within a
//  linked list has been reached, follow the
//  linked list to the next item.

        if ( yes_or_no_reached_end_of_current_text_item == yes_yes )
        {

// todo: write this code

            continue ;
        }


// -----------------------------------------------
//  If the end (or beginning) of the linked list
//  has been reached, pop the pointer stack to get
//  get back to the item that pointed to that
//  linked list, point to the next position, then
//  repeat the loop.

        if ( yes_or_no_reached_end_of_current_text_item == yes_yes )
        {

//  todo:
            pop_pointer_stack_level( ) ;

            zero_offset_in_stack_level_current = pointer_begin_for_item[ pointer_stack_level_top ] ;
            if ( direction_next_or_previous == direction_next )
            {
                all_pointers[ zero_offset_in_stack_level_current + offset_for_current_pointer_stack_level_character_position ] ++ ;
            } else
            {
                all_pointers[ zero_offset_in_stack_level_current + offset_for_current_pointer_stack_level_character_position ] -- ;
            }
            continue ;
        }


// -----------------------------------------------
//  If the top item pointed to by the pointer
//  stack is of data type "linked_list" then
//  push a new level onto the pointer stack, point
//  to the first (or last) position within that
//  new-top item, and then return.

        data_type = data_type_for_item[ current_pointer_stack_text_item ] ;
        if ( data_type == data_type_linked_list )
        {
            zero_offset_in_stack_level_current = pointer_begin_for_item[ current_pointer_stack_text_item ] ;
            new_current_pointer_stack_text_item = all_pointers[ zero_offset_in_stack_level_current + offset_for_current_pointer_stack_level_text_item ] ;


//  todo: finish writing this code

            push_pointer_stack_level( ) ;

            zero_offset_in_stack_level_current = pointer_begin_for_item[ item_id ] ;

            all_pointers[ zero_offset_in_stack_level_current ] = new_current_pointer_stack_text_item ;

            if ( direction_next_or_previous == direction_next )
            {
                zero_offset_in_stack_level_top = pointer_begin_for_item[ pointer_stack_level_top ] ;
                all_pointers[ zero_offset_in_stack_level_top + offset_for_current_pointer_stack_level_character_position ] = pointer_begin_for_item[ current_pointer_stack_text_item ] ;
            } else
            {
                zero_offset_in_stack_level_top = pointer_begin_for_item[ pointer_stack_level_top ] ;
                all_pointers[ zero_offset_in_stack_level_top + offset_for_current_pointer_stack_level_character_position ] = pointer_end_for_item[ current_pointer_stack_text_item ] ;
            }
            return ;
        }


// -----------------------------------------------
//  Repeat the loop for the next pointer.

    }


// -----------------------------------------------
//  End of get_next_or_previous_non_pointer_text_item.

    return ;

}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_next_or_previous_character_from_text_item
//
//  Gets the next -- or previous -- character from
//  the text item specified by
//  "item_id" and  puts the character
//  -- as an integer -- into
//  "single_character_as_integer".  The
//  direction -- "next" or "previous" -- is
//  specified by "direction_next_or_previous".
//  Before using this function the initialization
//  function
//  "initialize_text_position_direction_next"
//  or
//  "initialize_get_previous_character_from_text_item"
//  must be used.

void get_next_or_previous_character_from_text_item( )
{


// -----------------------------------------------
//  Begin a loop that points to the next (or
//  previous) character.  When needed, move up or
//  down the pointer stack levels, or
//  sometimes both up and down.  The loop exits
//  when the next character is known.

    while ( 1 == 1 )
    {


// -----------------------------------------------
//  If the previous character was the last (or
//  previous) character in the current-level text
//  item, track this situation.  Allow for the
//  possibility that the text item is empty.

        if ( direction_next_or_previous == direction_next )
        {
            if ( current_pointer_stack_character_position > length_from_item_begin_to_end_minus_one )
            {
                yes_or_no_reached_end_of_current_text_item = yes_yes ;
            } else
            {
                yes_or_no_reached_end_of_current_text_item = no_no ;
            }
        } else
        {
            if ( current_pointer_stack_character_position < 1 )
            {
                yes_or_no_reached_end_of_current_text_item = yes_yes ;
            } else
            {
                yes_or_no_reached_end_of_current_text_item = no_no ;
            }
        }


// -----------------------------------------------
//  Write debugging info.

        log_out << "get next item" << std::endl ;
        write_to_log( ) ;


// -----------------------------------------------
//  If the last (or first) character has already
//  been supplied, supply the character number as
//  zero.

        if ( ( pointer_stack_level_prior == 0 ) && ( yes_or_no_reached_end_of_current_text_item == yes_yes ) )
        {
            pointer_to_next_or_previous_character = 0 ;
            count_of_characters_remaining_in_item = 0 ;
            log_out << "end of text" << std::endl ;
            return ;
        }


// -----------------------------------------------
//  If the end (or beginning) of a text item
//  has been reached, get the next (or previous)
//  text item, then repeat the loop.

        if ( yes_or_no_reached_end_of_current_text_item == yes_yes )
        {
            get_next_or_previous_non_pointer_text_item( ) ;
            continue ;
        }


// -----------------------------------------------
//  If a hyphen or underscore needs to be
//  inserted here, insert it.  This applies to the
//  data type
//  "data_type_phrase_word_pointers".  It
//  also applies when there is a transition from
//  one phrase name to a subordinate phrase name
//  (which usually happens when "fenambee" or
//  "amennfen" or similar directive is used).  If
//  the text item is empty or contains only one
//  sub text item, don't insert a character.

        if ( character_to_insert_between_subitems != 0 )
        {
            if ( yes_or_no_inserted_character == no_no )
            {
                if ( ( ( current_pointer_stack_character_position > 1 ) && ( current_pointer_stack_character_position < ( current_pointer_stack_text_item_end - current_pointer_stack_text_item_begin + 1 ) ) ) || ( ( data_type == data_type_phrase_word_pointers ) && ( data_type_for_item[ pointer_stack_level_prior ] == data_type_phrase_word_pointers ) ) )
                {
                    yes_or_no_inserted_character = yes_yes ;
                    pointer_to_next_or_previous_character = pointer_to_character_to_insert_between_subitems ;
                    all_characters[ pointer_to_next_or_previous_character ] = character_to_insert_between_subitems ;
                    count_of_characters_remaining_in_item = 1 ;
                    return ;
                }
            }
        }


// -----------------------------------------------
//  If the character number is zero, skip it and
//  repeat the loop.

        if ( single_character_as_integer == 0 )
        {
            continue ;
        }


// -----------------------------------------------
//  Get the character, then return.

//  todo: write this code
        single_character_as_integer = all_characters[ 123 ] ;
        return ;


// -----------------------------------------------
//  Repeat the loop that gets the next character.

    }


// -----------------------------------------------
//  End of get_next_or_previous_character_from_text_item.

    pointer_to_next_or_previous_character = 0 ;
    count_of_characters_remaining_in_item = 0 ;
    return ;

}


// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
//  Function check_yes_or_no_text_item_is_empty

void check_yes_or_no_text_item_is_empty( )
{
    initialize_text_position_direction_next( ) ;
    get_next_or_previous_character_from_text_item( ) ;
    if ( single_character_as_integer == 0 )
    {
        yes_or_no_text_item_is_empty = yes_yes ;
    } else
    {
        yes_or_no_text_item_is_empty = no_no ;
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function append_single_character

void append_single_character( )
{

// todo: write


// following code might be relevant, otherwise delete code below

    if ( pointer_end_for_item[ id_text_to_edit ] < pointer_begin_for_item[ id_text_to_edit ] )
    {
        switch ( data_type_for_item[ id_text_to_edit ] )
        {
            case data_type_linked_list :
                measure_space_available_in_item( ) ;
                if ( space_available_in_item >= 2 )
                {
                    pointer_end_for_item[ id_text_to_edit ] ++ ;
                    all_pointers[ pointer_end_for_item[ id_text_to_edit ] ] = id_for_single_space ;
                } else
                {
                    length_requested_for_next_item_storage = default_length_for_text_item ;
                    create_new_item_id_and_assign_storage( ) ;
                    data_type_for_item[ new_item_id ] = data_type_linked_list ;
                    return ;
                }
                break ;

//  todo: still some work to do here

            case data_type_list_of_integers :
                convert_list_of_integers_into_text_item( ) ;
                id_text_to_edit = new_item_id ;
                break ;
            case data_type_list_of_decimal_numbers :
                convert_list_of_decimal_numbers_into_text_item( ) ;
                id_text_to_edit = new_item_id ;
                break ;
        }
    }

}


// -----------------------------------------------
// -----------------------------------------------
//  Function append_space_if_not_empty
//
//  Appends a space to "id_text_to_edit" if
//  it is not empty.  If the text item's data type
//  is a list of integers or a list of decimal
//  numbers, there is not a space at the end, so
//  insert one.

void append_space_if_not_empty( )
{
    item_id = id_text_to_edit ;
    check_yes_or_no_text_item_is_empty( ) ;
    if ( yes_or_no_text_item_is_empty == yes_yes )
    {
        return ;
    }
    single_character_as_integer = unicode_for_space ;
    append_single_character( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function append_text_item_pointers

//  Appends the pointers (but not characters
//  or numbers) of a "origin" linked text item to a
//  "destination" linked text item.  The origin and
//  destination text items can each span multiple
//  linked items.  Each of the two item
//  IDs must refer to the beginning of a data type
//  "linked_list" but this is not checked.
//  If the destination does
//  not have enough space, additional linked items of
//  type "linked_list" are created and linked.

void append_text_item_pointers( )
{


// -----------------------------------------------
//  If the origin item is empty, there is
//  nothing to do.

    item_id = item_id_origin ;
    check_yes_or_no_solo_item_is_empty( ) ;
    if ( yes_or_no_text_item_is_empty == yes_yes )
    {
        return ;
    }


// -----------------------------------------------
//  Get the first pointer, which points to the
//  first non-pointer origin item.

    initialize_text_position_direction_next( ) ;
    get_next_or_previous_non_pointer_text_item( ) ;
    current_pointer_to_append = new_current_pointer_stack_text_item ;


// -----------------------------------------------
//  Begin a loop that handles each contiguous
//  (adjacent) group of pointers.

    while ( 1 == 1 )
    {


// -----------------------------------------------
//  Append the pointer.

//  todo:
        id_stacked_list = id_whatever ;


        number_to_push = current_pointer_to_append ;
        push_number_onto_stacked_list( ) ;


// -----------------------------------------------
//  Get the next pointer (to append).  If there
//  are none, exit the loop.

        get_next_or_previous_non_pointer_text_item( ) ;
        if ( new_current_pointer_stack_text_item = 0 )
        {
            current_pointer_to_append = new_current_pointer_stack_text_item ;
        }


// -----------------------------------------------
//  Repeat the loop for the next contiguous group
//  of pointers.

    }


// -----------------------------------------------
//  End of append_text_item_pointers.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function append_text
//
//  Appends text from the text item
//  "id_from_origin" to the text item
//  "id_text_to_edit".
//  This function assumes that the text being
//  appended will change, so a copy of that text
//  must be stored.
//  The two item IDs must be different.  If they
//  can be the same, use a different ID as a
//  buffer area and then copy just the pointers
//  to the destination (which previously was
//  the origin).

void append_text( )
{


// -----------------------------------------------
//  If the text item being edited is read only,
//  indicate an error because the compiler made a
//  mistake.


        log_out << "appending " << std::endl ;


    if ( access_flag_for_item[ id_text_to_edit ] == access_flag_no_changes )
    {
        log_out << "item to edit cannot change" << std::endl ;
        exit( EXIT_FAILURE ) ;
    }


// -----------------------------------------------
//  Append the pointers that point to items that
//  contain characters and numbers.  This copying
//  creates a single level of a linked list.

    append_text_item_pointers( ) ;


// -----------------------------------------------
//  Create copies of the items pointed to by the
//  pointers just appended.

    next_segment_id_for_linked_list = id_text_to_edit ;
    while ( next_segment_id_for_linked_list > 0 )
    {
        for ( id_pointer = pointer_begin_for_item[ next_segment_id_for_linked_list ] ;  id_pointer = pointer_end_for_item[ next_segment_id_for_linked_list ] ; id_pointer ++ )
        {

//  todo: write

            log_out << "in for loop " << std::endl ;

//  todo: endless loop

  return ;

            id_from_origin = all_pointers[ pointer_begin_for_item[ next_segment_id_for_linked_list ] ] ;

//  handle numbers too

        }
        id_linked_list_segment_next = all_pointers[ pointer_allocation_end_for_item[ id_linked_list_segment_next ] + 1 ] ;
    }


// -----------------------------------------------
//  If possible adjust ...

    adjust_storage_space_to_fit_newest_item( ) ;


// -----------------------------------------------
    return ;

}


// -----------------------------------------------
// -----------------------------------------------
//  Function delete_text

//  Delete the text in the item "id_text_to_edit".
//  This function assumes the item uses a
//  "linked_list" data type at the top level,
//  but this assumption is not checked.
//  This function does not check for protection
//  against changes.

void delete_text( )
{
    id_linked_list = id_text_to_edit ;
    clear_linked_list( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function copy_text
//
//  Copy the text item.  This function assumes
//  the origin and destination IDs are different,
//  but this assumption is not checked.

void copy_text( )
{


// -----------------------------------------------
//  If the text item is read only, indicate an
//  error because the compiler made a mistake.

    if ( access_flag_for_item[ id_text_to_edit ] == access_flag_no_changes )
    {
        log_out << "item to edit cannot change" << std::endl ;
        exit( EXIT_FAILURE ) ;
    }


// -----------------------------------------------
//  Delete any existing text, then append a copy
//  of the origin text.

    delete_text( ) ;
    append_text( ) ;


// -----------------------------------------------
//  End of copy_text.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
//  Function add_phrase_word_to_indexed_list
//
//  Add the "id_for_phrase_word" pointer to the list
//  of phrase words that have the same word
//  length.


// todo: continue editing that allows for new "prior" pointer in each "pointer_list" item



void add_phrase_word_to_indexed_list( )
{
    number_to_append = id_for_phrase_word ;
    if ( id_indexed_list < 1 )
    {
        create_indexed_list( ) ;
    }
    append_number_to_indexed_list( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function find_matching_phrase_word
//
//  Find the already-defined phrase word that
//  matches the phrase word specified by
//  "id_for_phrase_word".
//  The item ID of the matching phrase word
//  is supplied in
//  "id_for_phrase_word".  A
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

    character_pointer_begin_for_text_two = character_pointer_begin_for_phrase_word_in_position[ phrase_word_number_to_check ] ;
    character_length_of_phrase_word_minus_one = character_pointer_end_for_phrase_word_in_position[ phrase_word_number_to_check ] - character_pointer_begin_for_phrase_word_in_position[ phrase_word_number_to_check ] ;


// -----------------------------------------------
//  If there are no phrase words that have this
//  length, put zero into
//  "id_for_phrase_word", then
//  return.

    if ( id_for_list_of_phrase_words_of_length[ character_length_of_phrase_word_minus_one + 1 ] == 0 )
    {
        id_for_phrase_word = 0 ;
        return ;
    }


// -----------------------------------------------
//  Point to the first character of the phrase
//  word being searched for.

    character_pointer_begin_for_text_two = position_begin_for_phrase_word_number[ phrase_word_number_to_check ] ;


// -----------------------------------------------
//  Begin a loop that checks each phrase word for
//  a match.

//  todo: finish writing, and proofreading, this code

    id_for_phrase_word = 0 ;
    id_indexed_list = id_for_list_of_phrase_words_of_length[ character_length_of_phrase_word ] ;
    indexed_list_current_position = pointer_begin_for_item[ id_indexed_list ] - 1 ;
    while ( 1 == 1 )
    {


// -----------------------------------------------
//  Point to the next phrase word to check.  If
//  there are no more to check, return with an
//  indication that there was no match.

        get_next_number_from_indexed_list( ) ;
        character_pointer_begin_for_text_one = 1 ;pointer_begin_for_item[ id_from_indexed_list ] ;
        if ( character_pointer_begin_for_text_one == 0 )
        {
            yes_or_no_matching_text = no_no ;
            break ;
        }


// -----------------------------------------------
//  Compare the already-defined phrase word with
//  the phrase word being searched for.
//  If the phrase words match, return with the
//  item ID of the matching phrase word.

        item_id = id_from_indexed_list ;
        check_yes_or_no_matching_text( ) ;
        if ( yes_or_no_matching_text == yes_yes )
        {
            id_for_phrase_word = id_from_indexed_list ;
            return ;
        }


// -----------------------------------------------
//  Repeat the loop for the next already-defined
//  phrase word.

    }
    id_for_phrase_word = 0 ;


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
//  in the item ID "id_for_phrase_name".
//  Puts the item ID of the matching
//  phrase name into the variable
//  "found_matching_phrase_name"
//  but that variable is zero if no match was
//  found.

void find_matching_phrase_name( )
{


// -----------------------------------------------
//  Initialization.


// -----------------------------------------------
//  Find each phrase word in the list of
//  already-defined phrase words, and get its
//  item ID number.  Also count how
//  many were found.
//

//  todo: needed?
//  Reminder:  When using the array
//  "position_begin_for_phrase_word_number",
//  the index numbers are offset such that the
//  last phrase word is indexed as one minus
//  "maximum_words_in_phrase_name".

    number_of_phrase_words_found = 0 ;
    for ( phrase_word_number_to_check = 1 ; phrase_word_number_to_check <= count_of_words_in_phrase_name ; phrase_word_number_to_check ++ )
    {

        find_matching_phrase_word( ) ;

//  todo: proofread this code

        character_position_in_phrase_name = 
        character_pointer_begin_for_phrase_word_in_position[ phrase_word_number_to_check ] = position_begin_for_phrase_word_number[ maximum_words_in_phrase_name - phrase_word_number_to_check ] ;
        character_pointer_end_for_phrase_word_in_position[ phrase_word_number_to_check ] = position_begin_for_phrase_word_number[ maximum_words_in_phrase_name - ( phrase_word_number_to_check + 1 ) ] ;

//        ???[ phrase_word_number_to_check ] = id_from_indexed_list ;

        id_for_phrase_word_at_position_number[ phrase_word_number_to_check ] = id_for_phrase_word ;
        if ( id_for_phrase_word > 0 )
        {
            number_of_phrase_words_found ++ ;
        }
    }


// -----------------------------------------------
//  Limit the search to the phrase names that have
//  the same number of phrase words.

    id_indexed_list = id_for_list_of_phrase_names_of_length[ count_of_words_in_phrase_name ] ;

//  reminder: put zeros into id_for_list_of_phrase_names_of_length before adding any phrase names


// -----------------------------------------------
//  Begin a loop that searches each
//  already-defined phrase name.

    while ( 1 == 1 )
    {


// -----------------------------------------------
//  Point to the next already-defined phrase name.

        get_next_number_from_indexed_list( ) ;
        log_out << "id_for_phrase_name " << id_for_phrase_name << std::endl ;


// -----------------------------------------------
//  If there are no more phrase names in the list,
//  return without a match.

//  todo: finish

        return ;


// -----------------------------------------------
//  Compare the item ID numbers in the phrase
//  name to match and the ID numbers in the phrase
//  name being considered.  If any of the ID
//  numbers do not match, continue the search.

        number_of_phrase_words_found = 0 ;
        for ( phrase_word_number_to_check = 1 ; phrase_word_number_to_check <= count_of_words_in_phrase_name ; phrase_word_number_to_check ++ )
        {
            id_for_phrase_word = all_pointers[ pointer_begin_for_item[ id_for_phrase_name ] + phrase_word_number_to_check - 1 ] ;
            if ( id_for_phrase_word_at_position_number[ phrase_word_number_to_check ] != id_for_phrase_word )
            {
                break ;
            }
            number_of_phrase_words_found ++ ;
        }
        if ( number_of_phrase_words_found < count_of_words_in_phrase_name )
        {
            continue ;
        }


// -----------------------------------------------
//  All the phrase words match, so use the text
//  item ID of the matching phrase word as the
//  pointer to the current phrase word.

// todo: finish ...

        yes_or_no_phrase_words_match = yes_yes ;


// -----------------------------------------------
//  Repeat the loop to check the next phrase name.

    }


// -----------------------------------------------
//  If not all the phrase words within the phrase
//  name were found, indicate the phrase name
//  cannot match any already-defined phrase name,
//  then return.

    if ( number_of_phrase_words_found < count_of_words_in_phrase_name )
    {
        found_matching_phrase_name = 0 ;
        return ;
    }


// -----------------------------------------------
//  End of find_matching_phrase_name.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function add_new_phrase_name
//
//  Adds a new phrase name to the list of phrase
//  names.  The ID for the phrase name is in
//  "id_for_phrase_name".  This function
//  assumes the hyphenated phrase name
//  does not match any existing hyphenated phrase
//  name.  Do not duplicate any words that are
//  already used in other hyphenated phrase names.
//  Add the "id_for_phrase_name" pointer to the list
//  of phrase names that have the same word
//  count.  The phrase word count must be in
//  "number_of_phrase_words_found".

void add_new_phrase_name( )
{


// -----------------------------------------------
//  If any of the phrase words are not already
//  listed, add them to the end of the linked list
//  that lists other phrase words of the same
//  length.

//  todo: write this code
    for ( phrase_word_number_to_check = 1 ; phrase_word_number_to_check <= count_of_words_in_phrase_name ; phrase_word_number_to_check ++ )
    {
        if ( all_pointers[ pointer_begin_for_item[ id_for_phrase_name ] + phrase_word_number_to_check - 1 ] < 1 )
        {

            // todo: copy pointer to phrase w
            id_for_phrase_word = id_for_phrase_word ;
            add_phrase_word_to_indexed_list( ) ;
        }
    }


// -----------------------------------------------
//  Add the phrase name to the end of the linked
//  list that lists other phrase names that have
//  the same number of phrase words.

    number_to_append = item_id ;
    id_indexed_list = id_for_list_of_phrase_names_of_length[ number_of_phrase_words_found ] ;
    if ( id_indexed_list < 1 )
    {
        create_indexed_list( ) ;
    }
    append_number_to_indexed_list( ) ;


// -----------------------------------------------
//  End of add_new_phrase_name.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function during_initialization_store_phrase_name
//
//  Creates a text item for a hyphenated phrase
//  name, and supplies the item ID number for
//  the new text item.  This function is only used
//  during initialization, and will be eliminated
//  when the initialization is done using Dashrep
//  code.

int during_initialization_store_phrase_name( int local_word_one , int local_word_two , int local_word_three , int local_word_four , int local_word_five , int local_word_six , int local_word_seven , int local_word_eight , int local_word_nine , int local_word_ten , int local_word_eleven , int local_word_twelve )
{
    length_requested_for_next_item_storage = 12 ;
    create_new_item_id_and_assign_storage( ) ;
    data_type_for_item[ new_item_id ] = data_type_phrase_word_pointers ;
    pointer_end_for_item[ new_item_id ] ++ ;
    all_pointers[ pointer_end_for_item[ new_item_id ] ] = local_word_one ;
    pointer_end_for_item[ new_item_id ] ++ ;
    all_pointers[ pointer_end_for_item[ new_item_id ] ] = local_word_two ;
    pointer_end_for_item[ new_item_id ] ++ ;
    all_pointers[ pointer_end_for_item[ new_item_id ] ] = local_word_three ;
    pointer_end_for_item[ new_item_id ] ++ ;
    all_pointers[ pointer_end_for_item[ new_item_id ] ] = local_word_four ;
    pointer_end_for_item[ new_item_id ] ++ ;
    all_pointers[ pointer_end_for_item[ new_item_id ] ] = local_word_five ;
    pointer_end_for_item[ new_item_id ] ++ ;
    all_pointers[ pointer_end_for_item[ new_item_id ] ] = local_word_six ;
    pointer_end_for_item[ new_item_id ] ++ ;
    all_pointers[ pointer_end_for_item[ new_item_id ] ] = local_word_seven ;
    pointer_end_for_item[ new_item_id ] ++ ;
    all_pointers[ pointer_end_for_item[ new_item_id ] ] = local_word_eight ;
    pointer_end_for_item[ new_item_id ] ++ ;
    all_pointers[ pointer_end_for_item[ new_item_id ] ] = local_word_nine ;
    pointer_end_for_item[ new_item_id ] ++ ;
    all_pointers[ pointer_end_for_item[ new_item_id ] ] = local_word_ten ;
    pointer_end_for_item[ new_item_id ] ++ ;
    all_pointers[ pointer_end_for_item[ new_item_id ] ] = local_word_eleven ;
    pointer_end_for_item[ new_item_id ] ++ ;
    all_pointers[ pointer_end_for_item[ new_item_id ] ] = local_word_twelve ;
    for ( character_pointer = pointer_end_for_item[ new_item_id ] ; character_pointer >= pointer_begin_for_item[ new_item_id ] ; character_pointer -- )
    {
        if ( all_pointers[ pointer_end_for_item[ new_item_id ] ] > 0 )
        {
            break ;
        }
        pointer_end_for_item[ new_item_id ] -- ;
    }
    return new_item_id ;
}


// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
//  Function truncate_text_item_using_pointer_stack
//
//  Changes the "begin" or "end"
//  pointers of a text item and any subordinate
//  text items to match the pointer that is
//  pointed to by "id_text_to_edit".  This
//  function truncates the beginning if the flag
//  "yes_or_no_begin_not_end" is
//  "yes" or else truncates the ending.
//  This function should not be used if the text
//  item and sub text items must not change.  Some
//  text item types (categories) cannot be
//  truncated using this function.

void truncate_text_item_using_pointer_stack( )
{
    log_out << "truncate item " << id_text_to_edit << std::endl ;


// -----------------------------------------------
//  Initialization.

    id_text_to_truncate = id_text_to_edit ;
    zero_offset_in_stack_level_current = pointer_begin_for_item[ pointer_stack_level_bottom ] ;
    pointer_stack_level_current = all_pointers[ zero_offset_in_stack_level_current + offset_for_pointer_stack_level_top ] ;
    write_to_log( ) ;


// -----------------------------------------------
//  For each stack level within the
//  pointer stack, truncate the text item at that
//  level.

    while ( pointer_stack_level_current > 0 )
    {
        data_type = data_type_for_item[ id_text_to_truncate ] ;
        write_to_log( ) ;
        if ( ( data_type == data_type_text_characters ) || ( data_type == data_type_linked_list ) )
        {
            zero_offset_in_stack_level_current = pointer_begin_for_item[ pointer_stack_level_current ] ;
            if ( yes_or_no_begin_not_end == yes_yes )
            {
                pointer_begin_for_item[ id_text_to_truncate ] = all_pointers[ zero_offset_in_stack_level_current + offset_for_current_pointer_stack_level_character_position ] ;
                log_out << "truncated beginning of " << id_text_to_truncate << " to " << pointer_begin_for_item[ id_text_to_truncate ] << std::endl ;
            } else
            {
                pointer_end_for_item[ id_text_to_truncate ] = all_pointers[ zero_offset_in_stack_level_current + offset_for_current_pointer_stack_level_character_position ] ;
                log_out << "truncated end of " << id_text_to_truncate << " to " << pointer_end_for_item[ id_text_to_truncate ] << std::endl ;
            }
            pointer_stack_level_current = all_pointers[ zero_offset_in_stack_level_current + offset_for_pointer_stack_level_prior ] ;
            if ( ( pointer_stack_level_current == 0 ) || ( pointer_stack_level_current == pointer_stack_level_bottom ) )
            {
                break ;
            }
            log_out << "truncate, stack shift needed" << std::endl ;
        } else
        {
            log_out << "cannot truncate data_type " << data_type << std::endl ;
            return ;
        }
    }


// -----------------------------------------------
//  End of function
//  truncate_text_item_using_pointer_stack.

    log_out << "truncation done" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function remove_leading_or_trailing_delimiters
//
//  Changes the "begin" (or "end")
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

    item_id = id_text_to_edit ;
    if ( direction_next_or_previous == direction_next )
    {
        initialize_text_position_direction_next( ) ;
        yes_or_no_begin_not_end = yes_yes ;
        direction_opposite = direction_previous ;
    } else
    {
        initialize_get_previous_character_from_text_item( ) ;
        yes_or_no_begin_not_end = no_no ;
        direction_opposite = direction_next ;
    }


// -----------------------------------------------
//  Search for the first (or last) non-delimiter.

    yes_or_no_character_is_delimiter = yes_yes ;
    while ( yes_or_no_character_is_delimiter == yes_yes )
    {
        get_next_or_previous_character_from_text_item( ) ;
        check_yes_or_no_character_is_delimiter( ) ;
        if ( yes_or_no_character_is_delimiter == no_no )
        {
            break ;
        }
    }


// -----------------------------------------------
//  Point to that leading (or trailing)
//  non-delimiter and use it as the new beginning
//  (or end) of the text item being edited.

    direction_next_or_previous = direction_opposite ;
    get_next_or_previous_character_from_text_item( ) ;
    truncate_text_item_using_pointer_stack( ) ;


// -----------------------------------------------
//  End of function remove_leading_or_trailing_delimiters.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function remove_leading_delimiters

void remove_leading_delimiters( )
{
    direction_next_or_previous = direction_next ;
    remove_leading_or_trailing_delimiters( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function remove_trailing_delimiters

void remove_trailing_delimiters( )
{
    direction_next_or_previous = direction_previous ;
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
// -----------------------------------------------
// -----------------------------------------------
//  Function replace_text_item_with_pointer_list
//
//  Creates a copy of the text item
//  at "id_text_to_edit" and changes the
//  data type of the original to become
//  "linked_list" and replaces the previous
//  contents (which are now copied) with a single
//  pointer to the copy.  This function should not
//  be used if the top-level text item already is
//  of the "linked_list" type because that
//  would be pointless.  The size of the item to
//  edit is not checked, but it is assumed to be
//  at least one unit in length.

//  todo: proofread, make corrections

void replace_text_item_with_pointer_list( )
{
    item_id = id_text_to_edit ;
    copy_solo_item_to_new( ) ;
    all_pointers[ pointer_begin_for_item[ id_text_to_edit ] ] = id_for_copy ;
    pointer_end_for_item[ id_text_to_edit ] = pointer_begin_for_item[ id_text_to_edit ] ;
    data_type_for_item[ id_text_to_edit ] = data_type_linked_list ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
//  Function parse_phrase_name
//

void parse_phrase_name( )
{


// -----------------------------------------------
//  Initialization.

    number_of_phrase_words_found = 0 ;


// -----------------------------------------------
//  Point to the last character of the last word
//  in the phrase name, then save this position.

    direction_next_or_previous = direction_previous ;
    get_next_or_previous_character_from_text_item( ) ;
    id_text_pointer_for_copy = pointer_stack_pointer_for_phrase_name_end ;
    copy_text_pointer( ) ;


// -----------------------------------------------
//  Access the characters in the phrase name in
//  reverse sequence.

    direction_next_or_previous = direction_previous ;
    count_of_words_in_phrase_name = 1 ;
    previous_character = 0 ;
    yes_or_no_character_is_delimiter = no_no ;
    while ( yes_or_no_character_is_delimiter == yes_yes )
    {


// -----------------------------------------------
//  If a delimiter or the beginning of the text
//  item is encountered, exit the loop because all
//  the phrase words have been encountered.

        get_next_or_previous_character_from_text_item( ) ;
        if ( single_character_as_integer == 0 )
        {
            break ;
        }
        check_yes_or_no_character_is_delimiter( ) ;
        if ( yes_or_no_character_is_delimiter == no_no )
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

        if ( single_character_as_integer == unicode_for_hyphen )
        {
            if ( single_character_as_integer == previous_character )
            {
                continue ;
            }
            count_of_words_in_phrase_name ++ ;

// todo:  finish writing this code

            position_begin_for_phrase_word_number[ maximum_words_in_phrase_name - count_of_words_in_phrase_name ] = pointer_begin_for_item[ id_for_phrase_name ] ;



            continue ;
        }


// -----------------------------------------------
//  Put the current character into the text item,
//  compensating for getting the characters in
//  reverse sequence.  Check for the phrase name
//  exceeding the length allowed.
//  Reminder:  The item ID minus one refers
//  to the preceeding text item.

        pointer_begin_for_item[ id_for_phrase_name ] ++ ;
        if ( pointer_begin_for_item[ id_for_phrase_name ] <= pointer_allocation_end_for_item[ id_for_phrase_name - 1 ] )
        {
            log_out << "BUG: Phrase name exceeds allowed length." << std::endl ;
            exit ( EXIT_FAILURE ) ;
        }
        all_characters[ pointer_begin_for_item[ id_for_phrase_name ] ] = single_character_as_integer ;

        
// -----------------------------------------------
//  Save a copy of the current character, then
//  repeat the loop to handle the "next"
//  (backwards-direction) character in the phrase
//  name.

        previous_character = single_character_as_integer ;
    }


// -----------------------------------------------
//  Point to the first character in the phrase
//  name, and leave the pointer stack
//  pointing to this character.

    direction_next_or_previous = direction_next ;
    get_next_or_previous_character_from_text_item( ) ;


// -----------------------------------------------
//  End of function parse_phrase_name.

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
//  Function initalize_skip_to_character_position
//
//  This function does initialization for the
//  function "skip_to_character_position".

void initalize_skip_to_character_position( )
{
    item_id_current = id_for_character_position ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function skip_to_character_position
//
//  todo: change to use pointer, as output
//
//  Within the text item
//  "id_for_character_position"
//  jump to the character indicated by
//  "character_position_desired".  If that
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

void skip_to_character_position( )
{
    while ( character_position_current < character_position_desired )
    {
        data_type = data_type_for_item[ item_id_current ] ;
        switch ( data_type )
        {
            case data_type_text_characters :
                length_of_item = pointer_end_for_item[ item_id_current ] - pointer_begin_for_item[ item_id_current ] ;

//  todo: write this code

                break ;
            case data_type_linked_list :


                offset_pointer_stack_level_list_of_pointers ++ ;
                item_id_current = all_pointers[ pointer_begin_for_item[ item_id_current ] + offset_pointer_stack_level_list_of_pointers ] ;
                if ( data_type_for_item[ item_id_current ] == data_type_phrase_word_pointers )
                {
                    character_insertion_count = 0 ;
                }
                break ;
            case data_type_phrase_word_pointers :

                   character_position_current ++ ;

                break ;
            default :
                log_out << "error, encountered list of integers or list of pointers to decimal numbers that have not been converted to text" << std::endl ;
                character_position_current = character_position_desired + 1 ;
                break ;
        }
    }
    if ( character_position_current > character_position_desired )
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
    initialize_text_position_direction_next( ) ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function point_to_next_word_in_text_item
//
//  Identifies the next word from the text item
//  and points to the word using a pair of within_items
//  pointer stacks, which are pointed to by
//  "id_for_next_word_begin" and
//  "id_for_next_word_end".
//  Before using this function the initialization
//  function
//  "initialize_get_next_word_from_text_item"
//  must be used.
//  The beginning and end of the found word is
//  pointed to by
//  "pointer_stack_pointer_for_word_begin"
//  and
//  "pointer_stack_pointer_for_word_end".

void point_to_next_word_in_text_item( )
{


// -----------------------------------------------
//  Find the end of the current delimiter.

    yes_or_no_character_is_delimiter = yes_yes ;
    while ( yes_or_no_character_is_delimiter == yes_yes )
    {
        get_next_or_previous_character_from_text_item( ) ;
        if ( single_character_as_integer == 0 )
        {
            break ;
        }
        check_yes_or_no_character_is_delimiter( ) ;
        if ( yes_or_no_character_is_delimiter == no_no )
        {
            break ;
        }
    }


// -----------------------------------------------
//  Point to the beginning of the word that
//  follows the delimiter, then save this
//  character position in a pointer
//  stack.

    direction_next_or_previous = direction_previous ;
    get_next_or_previous_character_from_text_item( ) ;
    id_text_pointer_for_copy = pointer_stack_pointer_for_word_begin ;
    copy_text_pointer( ) ;
    id_for_next_word_begin = id_text_pointer_for_copy ;
    pointer_stack_level_top_original = pointer_stack_level_top ;
    get_next_or_previous_character_from_text_item( ) ;


// -----------------------------------------------
//  Find the end of the non-delimiter text.

    direction_next_or_previous = direction_next ;
    while ( yes_or_no_character_is_delimiter == no_no )
    {
        get_next_or_previous_character_from_text_item( ) ;
        if ( single_character_as_integer == 0 )
        {
            break ;
        }
        check_yes_or_no_character_is_delimiter( ) ;
        if ( yes_or_no_character_is_delimiter == yes_yes )
        {
            break ;
        }
    }


// -----------------------------------------------
//  Point to the end of the word that precedes the
//  next delimiter, then save this character
//  position in a second pointer
//  stack.

    direction_next_or_previous = direction_previous ;
    get_next_or_previous_character_from_text_item( ) ;
    id_text_pointer_for_copy = pointer_stack_pointer_for_word_end ;
    copy_text_pointer( ) ;
    id_for_next_word_end = id_text_pointer_for_copy ;


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
//  "id_text_to_copy" and the offset is
//  specified by "character_offset" and
//  "character_length" specifies the
//  length, and "id_for_copy"
//  is the created copy of the specified
//  characters.

//  todo: use "jump" function!!

void get_text_by_character_offset_and_length( )
{
    length_requested_for_next_item_storage = 1000 ;
    create_new_item_id_and_assign_storage( ) ;
    id_for_copy = new_item_id ;
    initialize_text_position_direction_next( ) ;
    next_character_position_count = 0 ;
    character_count = 0 ;
    while ( single_character_as_integer != 0 )
    {
        next_character_position_count ++ ;
        get_next_or_previous_character_from_text_item( ) ;
        if ( next_character_position_count >= character_offset )
        {
            character_count ++ ;
            pointer_end_for_item[ id_for_copy ] ++ ;
            all_characters[ pointer_end_for_item[ id_for_copy ] ] = single_character_as_integer ;
        }
        if ( ( character_count >= character_length ) || ( single_character_as_integer == 0 ) )
        {
            break ;
        }
    }
    if ( id_for_copy == new_item_id )
    {
        log_out << "BUG: unexpectedly a new text item was created while getting text based on offset and length" << std::endl ;
        exit ( EXIT_FAILURE ) ;
    }
    adjust_storage_space_to_fit_newest_item( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function text_replace
//
//  Replaces text.  The pointers
//  "within_items_begin_gap" and
//  "within_items_end_gap" point to the gap
//  into which the text in item
//  "id_for_insertion_into_gap" is
//  inserted.

void text_replace( )
{

//  todo: write this code


// -----------------------------------------------
//  Calculate the gap size.

//  within_items_begin_gap
//  within_items_end_gap


// -----------------------------------------------
//  Calculate the replacement size.

//  id_for_insertion_into_gap


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
// -----------------------------------------------
// -----------------------------------------------
//  Function write_text_item_to_file
//
//  Writes the contents of one text
//  item to the output file.  If that text item
//  points to any sub text items, those sub text
//  items also are written to the file.  The text
//  item ID must be in item_id.

void write_text_item_to_file( )
{
    log_out << "item_id " << item_id << std::endl ;
    initialize_text_position_direction_next( ) ;
    while ( 1 == 1 )
    {
        get_next_or_previous_character_from_text_item( ) ;
        if ( single_character_as_integer == 0 )
        {
            return ;
        }
        write_single_character_as_integer_to_file( ) ;
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
//  Function scan_text_item_for_character_usage
//
//  Scans the text item indicated by
//  "item_id" and counts how
//  many times each character appears within that
//  text.

void scan_text_item_for_character_usage( )
{


// -----------------------------------------------
//  Initialization.

    log_out << "item_id " << item_id << std::endl ;
    for ( single_character_as_integer = minimum_usage_character_to_consider ; single_character_as_integer <= maximum_usage_character_to_consider ; single_character_as_integer ++ )
    {
        usage_count_for_character[ single_character_as_integer ] = 0 ;
    }


// -----------------------------------------------
//  Begin a loop that looks at each character, and
//  exit the loop when there are no more
//  characters.

    initialize_text_position_direction_next( ) ;
    next_character_position_count = 0 ;
    while ( single_character_as_integer != 0 )
    {
        get_next_or_previous_character_from_text_item( ) ;
        if ( single_character_as_integer == 0 )
        {
            break ;
        }


// -----------------------------------------------
//  Count how many times each character is
//  encountered.

        if ( ( single_character_as_integer >= minimum_usage_character_to_consider ) && ( single_character_as_integer <= maximum_usage_character_to_consider ) )
        {
            usage_count_for_character[ single_character_as_integer ] ++ ;
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
//  Scans the text item indicated by
//  "id_text_to_search" and copies
//  into the
//  "searched_usage_count_for_character"
//  array the character usage counts.

void scan_searched_text_before_doing_find_text( )
{
    item_id = id_text_to_search ;
    scan_text_item_for_character_usage( ) ;
    for ( single_character_as_integer = minimum_usage_character_to_consider ; single_character_as_integer <= maximum_usage_character_to_consider ; single_character_as_integer ++ )
    {
        searched_usage_count_for_character[ single_character_as_integer ] = usage_count_for_character[ single_character_as_integer ] ;
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function initialize_track_recent_position_of_each_character

void initialize_track_recent_position_of_each_character( )
{
    log_out << "item_id " << item_id << std::endl ;
    next_character_position_count = 0 ;
    initialize_text_position_direction_next( ) ;
    for ( single_character_as_integer = minimum_usage_character_to_consider ; single_character_as_integer <= maximum_usage_character_to_consider ; single_character_as_integer ++ )
    {
        recent_character_position_for_character_number[ single_character_as_integer ] = 0 ;
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function track_recent_position_of_each_character
//
//  Keeps track of the position
//  where each character was last encountered.
//  The function
//  "initialize_track_recent_position_of_each_character"
//  must be used before using this function.  This
//  function is used repeatedly because it stops
//  when the character specified in
//  "optimum_character_for_find_pause" is
//  encountered.

void track_recent_position_of_each_character( )
{


// -----------------------------------------------
//  Begin a loop that looks at each character in
//  the text item.

    while ( single_character_as_integer != 0 )
    {
        get_next_or_previous_character_from_text_item( ) ;


// -----------------------------------------------
//  Exit the loop and this function when the
//  character specified in
//  "optimum_character_for_find_pause" is
//  encountered, or when the end of the text item
//  is reached.

        if ( ( single_character_as_integer == optimum_character_for_find_pause ) || ( single_character_as_integer == 0 ) )
        {
            return ;
        }


// -----------------------------------------------
//  Update a list of pointers that indicates when
//  the current character was last encountered.

        next_character_position_count ++ ;
        if ( ( single_character_as_integer >= minimum_usage_character_to_consider ) && ( single_character_as_integer <= maximum_usage_character_to_consider ) )
        {
            recent_character_position_for_character_number[ single_character_as_integer ] = next_character_position_count ;
        }


// -----------------------------------------------
//  Also track the last appearance of any
//  delimiter.

        switch ( single_character_as_integer )
        {
            case unicode_for_space :
                recent_position_of_any_delimiter = next_character_position_count ;
                break ;
            case unicode_for_tab :
                recent_position_of_any_delimiter = next_character_position_count ;
                break ;
            case unicode_for_newline :
                recent_position_of_any_delimiter = next_character_position_count ;
                break ;
            case unicode_for_formfeed :
                recent_position_of_any_delimiter = next_character_position_count ;
                break ;
            case unicode_for_carriage_return :
                recent_position_of_any_delimiter = next_character_position_count ;
                break ;
        }


// -----------------------------------------------
//  Point to the position of the found character.

    saved_single_character_as_integer = single_character_as_integer ;
    direction_next_or_previous = direction_previous ;
    get_next_or_previous_character_from_text_item( ) ;
    direction_next_or_previous = direction_next ;
    single_character_as_integer = saved_single_character_as_integer ;


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
//  Finds which character should be
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
    optimum_character_for_find_pause = 0 ;
    length_of_text_to_find = pointer_end_for_item[ id_from_origin ] - pointer_begin_for_item[ id_from_origin ] + 1 ;
    text_pointer = pointer_begin_for_item[ id_from_origin ] ;
    highest_score_for_optimum_character_for_find_pause = 0 ;
    for ( position_within_text_to_find = 1 ; position_within_text_to_find <= length_of_text_to_find ; position_within_text_to_find ++ )
    {
        possible_optimum_character_as_integer = all_characters[ text_pointer ] ;
        if ( usage_count_for_character[ possible_optimum_character_as_integer ] == 0 )
        {
            continue ;
        }
        score_for_possible_optimum_character = ( length_of_matching_text - position_within_text_to_find ) + ( usage_count_for_character[ possible_optimum_character_as_integer ] * searched_usage_count_for_character[ possible_optimum_character_as_integer ] ) ;
        if ( score_for_possible_optimum_character > highest_score_for_optimum_character_for_find_pause )
        {
            optimum_character_for_find_pause = possible_optimum_character_as_integer ;
            highest_score_for_optimum_character_for_find_pause = score_for_possible_optimum_character ;
            position_of_optimum_character_for_pause = position_within_text_to_find ;

            log_out << "position " << position_within_text_to_find << ", character " << possible_optimum_character_as_integer << ", score " << score_for_possible_optimum_character << std::endl ;

        }
        text_pointer ++ ;
    }
    log_out << "optimum character to find is " << optimum_character_for_find_pause << std::endl ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function check_for_match_where_paused
//
//  Determines whether the text
//  being searched matches the text to find.  This
//  check is done when the pointer
//  stack is pointing to an occurance of the
//  optimum character that triggers this check.
//  The text item "id_text_to_find" is the
//  text to find.  The text item being searched is
//  ...

//  todo: proofread this code

void check_for_match_where_paused( )
{
    yes_or_no_matching_text = yes_yes ;

    position_of_found_character_for_find_pause = recent_character_position_for_character_number[ optimum_character_for_find_pause ] ;
    character_distance_from_optimum_character_for_pause = 0 ;
    for ( text_pointer = pointer_end_for_item[ id_text_to_find ] ; text_pointer >= pointer_begin_for_item[ id_text_to_find ] ; text_pointer -- )
    {
        single_character_as_integer = all_characters[ text_pointer ] ;
        if ( ( recent_character_position_for_character_number[ single_character_as_integer ] + character_distance_from_optimum_character_for_pause ) != position_of_found_character_for_find_pause )
        {
            yes_or_no_matching_text = no_no ;
            return ;
        }
        character_distance_from_optimum_character_for_pause ++ ;
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function find_matching_text
//
//  Finds some "matched" text
//  within some text to be searched.  The text to
//  match must be in "id_text_to_find"
//  The text to be searched must be in
//  "id_text_to_search" and that text
//  must be the same text that was scanned using
//  the function
//  "scan_searched_text_before_doing_find_text".
//  The result is ...

//  The starting point for the text to be searched
//  must be specified by the pointer stack pointed
//  to by "...".
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

    yes_or_no_matching_text = no_no ;


// -----------------------------------------------
//  Get the character usage counts for the text to
//  be found.

    id_from_origin = id_text_to_find ;
    scan_text_item_for_character_usage( ) ;


// -----------------------------------------------
//  Determine which character to use for
//  triggering pauses when the full text is
//  checked for a match.  It is put into the
//  variable
//  "optimum_character_for_find_pause".

    find_optimum_character_for_find_pause( ) ;


// -----------------------------------------------
//  If none of the characters in the matching text
//  appear in the text being searched, indicate
//  the text does not contain the matching text.

    if ( optimum_character_for_find_pause == 0 )
    {
        position_of_found_character_for_find_pause = 0 ;
        return ;
    }


// -----------------------------------------------
//  Scan the text being searched, and pause when
//  the "optimum" character is encountered, and
//  check whether there is a full match at that
//  position.

    initialize_text_position_direction_next( ) ;
    while ( 1 == 1 )
    {
        get_next_or_previous_character_from_text_item( ) ;
        if ( single_character_as_integer == 0 )
        {
            yes_or_no_matching_text = 0 ;
            return ;
        }
        if ( single_character_as_integer == optimum_character_for_find_pause )
        {
            check_for_match_where_paused( ) ;
            if ( yes_or_no_matching_text == yes_yes )
            {
                break ;
            }
        }
    }


// -----------------------------------------------
//  If the text matches, return with pointers to
//  the beginning and end of the matching text.

    if ( yes_or_no_matching_text == yes_yes )
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
//  Saves the position at which the
//  first hyphen in a phrase name is encountered.

void save_position_of_first_hyphen( )
{
    pointer_to_first_hyphen = recent_character_position_for_character_number[ unicode_for_hyphen ] ;
    id_containing_first_hyphen = current_pointer_stack_text_item ;
    character_pointer_within_text_item_for_first_hyphen = current_pointer_stack_character_position ;
    pointer_to_leading_delimiter = recent_position_of_any_delimiter ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_phrase_name_when_at_trailing_delimiter
//
//  Points to the phrase words in a
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

    length_of_first_phrase_word_minus_one = pointer_to_first_hyphen - pointer_to_leading_delimiter ;
    distance_from_first_hyphen_to_trailing_delimiter = recent_position_of_any_delimiter - pointer_to_first_hyphen ;


// -----------------------------------------------
//  If the entire phrase name is
//  not within the same text item as the delimiter
//  that follows the phrase name, indicate an
//  error for now, and later modify the code to
//  handle such other cases.

    if ( ( id_containing_first_hyphen == current_pointer_stack_text_item ) && ( character_pointer_within_text_item_for_first_hyphen > length_of_first_phrase_word_minus_one ) && ( ( length_of_first_phrase_word_minus_one + distance_from_first_hyphen_to_trailing_delimiter ) <= ( pointer_end_for_item[ current_pointer_stack_text_item ] - pointer_begin_for_item[ current_pointer_stack_text_item ] ) ) )
    {
        log_out << "phrase name not within single text item, so modify code to handle this kind of situation " << std::endl ;
        exit( EXIT_FAILURE ) ;
    }


// -----------------------------------------------
//  If the phrase name is in a text item of the
//  type that contains a hyphenated phrase name,
//  indicate an error and the need to modify this
//  code.

    if ( data_type_for_item[ current_pointer_stack_text_item ] == data_type_phrase_word_pointers )
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
// -----------------------------------------------
// -----------------------------------------------
//  Function replace_angle_bracketed_phrase_names
//
//  Finds each occurance of a phrase
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

    item_id = id_text_to_edit ;
    initialize_text_position_direction_next( ) ;
    initialize_track_recent_position_of_each_character( ) ;


// -----------------------------------------------
//  Begin a loop that repeatedly looks for the
//  desired sequence of a delimiter, an open angle
//  bracket, an underscore, and then a close angle
//  bracket.

    while ( single_character_as_integer > 0 )
    {


// -----------------------------------------------
//  When the end of the text is encountered,
//  return.

        if ( single_character_as_integer == 0 )
        {
            log_out << "angle bracketed phrases replaced, or were not found" << std::endl ;
            return ;
        }


// -----------------------------------------------
//  Find the next open angle bracket, and save a
//  copy of the pointer stack to keep
//  track of this location.

        optimum_character_for_find_pause = unicode_for_open_angle_bracket ;
        track_recent_position_of_each_character( ) ;
        copy_text_pointer( ) ;


// -----------------------------------------------
//  If an open angle bracket is not found, return.

        if ( single_character_as_integer == 0 )
        {
            log_out << "open angle bracket not found" << std::endl ;
            return ;
        }


// -----------------------------------------------
//  Find the next close angle bracket.

        optimum_character_for_find_pause = unicode_for_open_angle_bracket ;
        track_recent_position_of_each_character( ) ;


// -----------------------------------------------
//  If a close angle bracket was not found, return
//  without a pointer to the found text.

        if ( single_character_as_integer == 0 )
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

        log_out << "recent_position_of_any_delimiter " << recent_position_of_any_delimiter << std::endl << "position_of_open_angle_bracket " << position_of_open_angle_bracket << std::endl << "position_of_underscore " << position_of_underscore << std::endl << "position_of_close_angle_bracket " << position_of_close_angle_bracket << std::endl << "current_pointer_stack_text_item " << current_pointer_stack_text_item << std::endl ;

        position_of_open_angle_bracket = recent_character_position_for_character_number[ unicode_for_open_angle_bracket ] ;
        position_of_underscore = recent_character_position_for_character_number[ unicode_for_underscore ] ;
        position_of_close_angle_bracket = recent_character_position_for_character_number[ unicode_for_close_angle_bracket ] ;
        if ( ( recent_position_of_any_delimiter < position_of_open_angle_bracket ) && ( position_of_open_angle_bracket < position_of_underscore ) && ( position_of_underscore < position_of_close_angle_bracket ) )
        {
            continue ;
        }


// -----------------------------------------------
//  Point to the found text that matches the
//  pattern.

        position_of_close_angle_bracket_within_text_item = current_pointer_stack_character_position - 1 ;
        position_of_open_angle_bracket_within_text_item = position_of_close_angle_bracket_within_text_item - ( position_of_close_angle_bracket - position_of_open_angle_bracket ) ;


// -----------------------------------------------
//  If the angle bracketed phrase name is not
//  entirely within one text item, exit with an
//  error.  Later, if this error ever occurs,
//  add code that copies the entire text item into
//  a single text item, and switch to using that
//  instead.

        if ( position_of_open_angle_bracket < 1 )
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
//  Function check_yes_or_no_last_character_is_space
//
//  Check the last character in the text item
//  indicated by "item_id".  If it is a space, or
//  the item is empty, set
//  "yes_or_no_last_character_is_space" to
//  "yes_yes".  Otherwise set it to "no_no".

//  todo: omit, not needed!!!  saved in case code is useful elsewhere

void check_yes_or_no_last_character_is_space( )
{
    yes_or_no_last_character_is_space = no_no ;
    item_id_current = item_id ;
    while ( item_id_current > 0 )
    {

        log_out << "item id = " << item_id_current << std::endl ;

        if ( pointer_end_for_item[ item_id_current ] < pointer_begin_for_item[ item_id_current ] )
        {
            item_id_current = all_pointers[ pointer_end_for_item[ item_id_current ] ] ;
            return ;
            break ;
        }
        data_type = data_type_for_item[ item_id_current ] ;
        switch ( data_type )
        {
            case data_type_text_characters :
                single_character_as_integer = all_characters[ pointer_end_for_item[ item_id_current ] ] ;
                if ( single_character_as_integer == unicode_for_space )
                {
                    yes_or_no_last_character_is_space = yes_yes ;
                }
                return ;
                break ;
            case data_type_linked_list :
                item_id_current = all_pointers[ pointer_end_for_item[ item_id_current ] ] ;
                break ;
            default :
                return ;
                break ;
        }
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function expand_text
//
//  Expands the text item indicated in
//  id_from_origin.

//  Local variables are used because this function
//  can be used recursively.

//  Currently being changed from Perl code to C.

void expand_text( )
{


// -----------------------------------------------
//  Declarations.

    int local_expand_endless_cycle_count_maximum ;
    int local_current_phrase_item_id ;
    int local_expand_result_item_id ;
    int local_output_buffer ;
    int local_space_directive ;
    int local_expand_endless_loop_counter ;
    int local_expand_endless_loop_counter_maximum ;
    int local_recursion_level ;
    int local_pointer_to_phrase_begin ;
    int local_pointer_to_next_space ;
    int local_pointer_to_phrase_end ;
    int local_prior_length ;
    int local_prefix ;
    int local_possible_phrase_name_with_underscores ;
    int local_length_of_tag ;
    int local_new_output_buffer ;
    int local_pointer_to_remainder_of_output_buffer ;
    int local_possible_phrase_name_with_hyphens ;
    int local_pointer_to_close_angle_bracket ;
    int local_length_of_output_buffer ;
    int local_maximum_cycle_count ;
    int local_phrase_name ;
    int local_cycle_count ;
    int local_phrase_name_with_highest_cycle_count ;
    int local_length_of_code_at_recursion_level_current ;
    int local_expand_buffer_item_id ;

    int local_code_at_recursion_level[ 105 ] ;
    int local_length_of_code_at_recursion_level[ 105 ] ;
    int local_pointer_to_remainder_of_code_at_recursion_level[ 105 ] ;


// -----------------------------------------------
//  Specify the text item being expanded.

    id_for_phrase_name_expand_text = id_text_to_edit ;


// -----------------------------------------------
//  Specify that when appending is done, the
//  "copied" version is used.

    yes_or_no_use_copy_when_appending = yes_yes ;


// -----------------------------------------------
//  Initialization.

    item_id = local_expand_buffer_item_id ;
    clear_item( ) ;

// local_output_buffer = '' ;
    local_space_directive = space_directive_none ;
// local_new_output_buffer = '' ;
// local_possible_phrase_name_with_underscores = '' ;

    local_pointer_to_remainder_of_output_buffer = 0 ;
    local_expand_endless_loop_counter = 0 ;
    local_expand_endless_loop_counter_maximum = 100000 ;
    local_expand_endless_cycle_count_maximum = 100000 ;

// @code_at_recursion_level = ( ) ;
// @length_of_code_at_recursion_level = ( ) ;
// @pointer_to_remainder_of_code_at_recursion_level = ( ) ;

// local_code_at_recursion_level[ 0 ] = 'unused' ;
// local_pointer_to_remainder_of_code_at_recursion_level[ 0 ] = 0 ;
// local_length_of_code_at_recursion_level[ 0 ] = 0 ;



// -----------------------------------------------
//  Begin a loop that handles each space delimited
//  string in the phrase definition.

// local_code_at_recursion_level[ 1 ] = id_from_origin ;
// local_pointer_to_remainder_of_code_at_recursion_level[ 1 ] = 0 ;
// local_length_of_code_at_recursion_level[ 1 ] = length( local_code_at_recursion_level[ 1 ] ) ;

    local_recursion_level = 1 ;

    while ( ( local_recursion_level > 0 ) && ( local_expand_endless_loop_counter <= local_expand_endless_loop_counter_maximum ) )
    {
        local_expand_endless_loop_counter ++ ;


// -----------------------------------------------
//  Get the next phrase name.  If there is no more
//  code at the current recursion level, shift
//  back to the previous recursion level.  When
//  the local_recursion_level reaches zero, the loop
//  will end.

// local_length_of_code_at_recursion_level_current = local_length_of_code_at_recursion_level[ local_recursion_level ] ;
        if ( local_length_of_code_at_recursion_level_current == 0 )
        {
            local_recursion_level -- ;
            continue ;
        }
// local_pointer_to_phrase_begin = local_pointer_to_remainder_of_code_at_recursion_level[ local_recursion_level ] ;
// while ( ( local_pointer_to_phrase_begin < local_length_of_code_at_recursion_level_current ) && ( substr( local_code_at_recursion_level[ local_recursion_level ] , local_pointer_to_phrase_begin , 1 ) eq ' ' ) ) {
        local_pointer_to_phrase_begin ++ ;
// }
// local_pointer_to_next_space = index( local_code_at_recursion_level[ local_recursion_level ] , ' ' , local_pointer_to_phrase_begin ) ;
        if ( local_pointer_to_next_space == -1 )
        {
// local_pointer_to_phrase_end = local_length_of_code_at_recursion_level_current - 1 ;
// local_pointer_to_remainder_of_code_at_recursion_level[ local_recursion_level ] = local_length_of_code_at_recursion_level_current ;
        } else
        {
// local_pointer_to_next_space = index( local_code_at_recursion_level[ local_recursion_level ] , ' ' , local_pointer_to_phrase_begin ) ;
            if ( local_pointer_to_next_space > local_pointer_to_phrase_begin )
            {
                local_pointer_to_phrase_end = local_pointer_to_next_space - 1 ;
// local_pointer_to_remainder_of_code_at_recursion_level[ local_recursion_level ] = local_pointer_to_next_space ;
            } else
            {
                local_pointer_to_phrase_end = -2 ;
            }
        }
        if ( local_pointer_to_phrase_begin > local_pointer_to_phrase_end )
        {
            local_recursion_level -- ;
            continue ;
        }
// local_current_phrase_item_id = substr( local_code_at_recursion_level[ local_recursion_level ] , local_pointer_to_phrase_begin , ( local_pointer_to_phrase_end - local_pointer_to_phrase_begin + 1 ) ) ;


// -----------------------------------------------
// Check for an endless loop caused by the same
// phrase name being encountered too many times.
// If this occurs, exit the endless loop.

        if ( yes_or_no_count_phrase_usage == yes_yes )
        {
// number_of_times_encountered_phrase_named{ local_current_phrase_item_id } ++ ;
// if ( number_of_times_encountered_phrase_named{ local_current_phrase_item_id } >= local_expand_endless_cycle_count_maximum ) {
            local_maximum_cycle_count = 0 ;
// foreach local_phrase_name ( keys( %number_of_times_encountered_phrase_named ) ) {
// local_cycle_count = number_of_times_encountered_phrase_named{ local_phrase_name } ;
        if ( local_cycle_count > local_maximum_cycle_count )
        {
           local_maximum_cycle_count = local_cycle_count ;
// local_phrase_name = local_phrase_name_with_highest_cycle_count ;
        }
// }
// action_result = 'trace_diagnostic__expand_phrases__error_endless_loop__highest_count ' . local_phrase_name_with_highest_cycle_count . ' ' . local_maximum_cycle_count . "\n" ;
// print action_result . "\n" ;
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


// id_for_phrase_name_expand_text


// -----------------------------------------------
//  If the phrase name is a hyphen directive, or a
//  space directive, or a line directive, handle
//  it.

        if ( local_current_phrase_item_id == id_for_phrase_name_hyphen_here )
        {
// local_output_buffer .= '-' ;
            local_space_directive = space_directive_none ;
            continue ;
        }
        if ( local_current_phrase_item_id == id_for_phrase_name_no_space )
        {
            if ( local_space_directive = space_directive_one_requested )
            {
                local_space_directive = space_directive_none ;
            }
            continue ;
        }
// if ( local_current_phrase_item_id eq ( '<' . 'no_space' . '>' ) ) {
            local_space_directive = space_directive_none ;
            continue ;
// }
        if ( local_current_phrase_item_id == id_for_phrase_name_one_space )
        {
            local_space_directive = space_directive_one_requested ;
            continue ;
        }
// if ( local_current_phrase_item_id eq ( '<' . 'one_space' . '>' ) ) {
            local_space_directive = space_directive_one_requested ;
            continue ;
// }
        if ( local_current_phrase_item_id == id_for_phrase_name_new_line )
        {
// local_output_buffer .= "\n" ;
            local_space_directive = space_directive_none ;
            continue ;
        }
// if ( local_current_phrase_item_id eq ( '<' . 'new_line' . '>' ) ) {
// local_output_buffer .= "\n" ;
            local_space_directive = space_directive_none ;
            continue ;
// }
        if ( local_current_phrase_item_id == id_for_phrase_name_empty_line )
        {
// local_output_buffer .= "\n\n" ;
            local_space_directive = space_directive_none ;
            continue ;
        }
// if ( local_current_phrase_item_id eq ( '<' . 'empty_line' . '>' ) ) {
// local_output_buffer .= "\n\n" ;
            local_space_directive = space_directive_none ;
            continue ;
// }


// -----------------------------------------------
//  If the phrase name has a definition (which can
//  be empty), and it is not a space directive or
//  line directive, insert phrase definition into
//  the text being expanded, and remove the phrase
//  name.

// if ( ( local_current_phrase_item_id =~ /[^ \-]\-[^ \-]/ ) && ( exists( dashrep_replacement{ local_current_phrase_item_id } ) ) ) {
            local_recursion_level ++ ;
// local_code_at_recursion_level[ local_recursion_level ] = dashrep_replacement{ local_current_phrase_item_id } ;
// local_length_of_code_at_recursion_level[ local_recursion_level ] = length( local_code_at_recursion_level[ local_recursion_level ] ) ;
// local_pointer_to_remainder_of_code_at_recursion_level[ local_recursion_level ] = 0 ;
            continue ;
// }


// -----------------------------------------------
//  If a space should be inserted here, insert it.
//  Specify a default of inserting one space after
//  the next phrase insertion.

        if ( ( local_space_directive == space_directive_one ) || ( local_space_directive == space_directive_one_requested ) )
        {
// local_output_buffer .= ' ' ;
        }
        local_space_directive = space_directive_one ;


// -----------------------------------------------
//  At this point the current text string is not
//  the name of a defined phrase, so just use the
//  text string.

// local_output_buffer .= local_current_phrase_item_id ;
// local_pointer_to_remainder_of_code_at_recursion_level[ local_recursion_level ] = local_pointer_to_phrase_end + 1 ;


// -----------------------------------------------
//  In the output buffer, if there is a
//  "<specify " string that needs to be combined
//  with the preceding tag, combine it into a
//  single XML or HTML tag.  Handle tags of type
//  "<xyz />" as well as "<xyz>".

// if ( index( local_output_buffer , '<specify ' ) > 0 ) {
        local_prior_length = 0 ;
// while ( length( local_output_buffer ) != local_prior_length ) {
// local_prior_length = length( local_output_buffer ) ;
// local_output_buffer =~ s/ *\/> *<specify +([^>]+)>/ $1 \/>/ ;
// }
// if ( index( local_output_buffer , '<specify ' ) > 0 ) {
        local_prior_length = 0 ;
// while ( length( local_output_buffer ) != local_prior_length ) {
// local_prior_length = length( local_output_buffer ) ;
// local_output_buffer =~ s/ *> *<specify +/ / ;
// }
// }
// }


// -----------------------------------------------
//  If the output buffer contains a recognized
//  phrase name using underscores instead of
//  hyphens, and it is enclosed in angle brackets
//  (with no spaces), then replace that text with
//  the definition of the specified phrase.

// local_output_buffer =~ s/ *<placeholder_for_hyphen_here> */-/sg ;
// local_output_buffer =~ s/ *<placeholder_for_new_line> */\n/sg ;
// local_output_buffer =~ s/ *<placeholder_for_empty_line> */\n/sg ;

// if ( local_output_buffer =~ /<((no_space)|(hyphen_here)|(new_line))> *$/ ) {
            local_space_directive = space_directive_none ;
// }
            local_length_of_output_buffer = -1 ;
            local_pointer_to_remainder_of_output_buffer = 0 ;
// local_new_output_buffer = '' ;
// while ( substr( local_output_buffer , local_pointer_to_remainder_of_output_buffer ) =~ /^(.*?)<([^ \->]+_[^ \->]+)>/s ) {
// local_prefix = $1 ;
// local_possible_phrase_name_with_underscores = $2 ;
// local_length_of_output_buffer = length( local_output_buffer ) ;
// local_new_output_buffer .= local_prefix ;
// local_length_of_tag = length( local_possible_phrase_name_with_underscores ) ;
// local_pointer_to_remainder_of_output_buffer += length( local_prefix ) + local_length_of_tag + 2 ;

// local_possible_phrase_name_with_hyphens = local_possible_phrase_name_with_underscores ;
// local_possible_phrase_name_with_hyphens =~ s/_/-/g ;
// if ( exists( dashrep_replacement{ local_possible_phrase_name_with_hyphens } ) ) {
// local_new_output_buffer .= dashrep_replacement{ local_possible_phrase_name_with_hyphens } ;
// } else {
// local_new_output_buffer .= '<' . local_possible_phrase_name_with_underscores . '>' ;
// }
// }
            if ( local_length_of_output_buffer != -1 )
            {
// local_output_buffer = local_new_output_buffer . substr( local_output_buffer , local_pointer_to_remainder_of_output_buffer ) ;
// local_new_output_buffer = '' ;
// local_possible_phrase_name_with_underscores = '' ;
            }


// -----------------------------------------------
//  If the output buffer does not contain any text
//  that might need to be revised, then append it
//  to the result text.

// local_pointer_to_close_angle_bracket = index( local_output_buffer , '>' ) ;
// if ( local_pointer_to_close_angle_bracket < 0 ) {
// local_expand_result_item_id .= local_output_buffer ;
// local_output_buffer = '' ;
// } elsif ( length( local_output_buffer ) > 1000 ) {
// local_expand_result_item_id .= substr( local_output_buffer , 0 , 500 ) ;
// local_output_buffer = substr( local_output_buffer , 500 ) ;
// }


// -----------------------------------------------
//  Repeat the loop that handles each space
//  delimited string.

    }


// -----------------------------------------------
//  Supply the results.

// local_expand_result_item_id .= local_output_buffer ;
// return: expand_result_item_id ;
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
//  Points to the next word using a
//  pair of pointer stacks, then
//  executes the requested action.
//
//  Local variables are used because this function
//  can be used recursively.

void implement_loop( )
{
    int local_item_id_contains_word_list ;
    int local_item_id_for_next_word ;
    int local_loop_handler ;
    local_item_id_contains_word_list = id_from_origin ;
    initialize_point_to_next_word_in_text_item( ) ;
    while ( 1 == 1 )
    {
        point_to_next_word_in_text_item( ) ;
        if ( single_character_as_integer == 0 )
        {
            return ;
        }
        execute_loop_handler_based_on_handler_id( local_item_id_for_next_word , local_loop_handler ) ;
// ... handler-name-with-underscores ...
    }
}


// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
// -----------------------------------------------
//  Functions that call the above functions.
//  These are needed to match the use of functions
//  in the Perl version, but these will be
//  eliminated later.

int parameterized_use_handler_with_each_word_in_phrase( int local_item_id )
{
    id_from_origin = local_item_id ;
    implement_loop( ) ;
    int local_expand_result_item_id ;  // temporary, to avoid compiler error
    return local_expand_result_item_id ;
}

int parameterized_dashrep_expand_text( int local_item_id )
{
    id_from_origin = local_item_id ;
    expand_text( ) ;
    int local_expand_result_item_id ;  // temporary, to avoid compiler error
    return local_expand_result_item_id ;
}

void parameterized_append_text( int local_item_id )
{
    id_from_origin = local_item_id ;
//    append_copied_text( ) ;
    return ;
}

void parameterized_get_phrase_definition( int local_to_item_id , int local_from_item_id )
{
    local_to_item_id = pointer_to_definition_of_item[ local_from_item_id ] ;
    return ;
}

void parameterized_put_phrase_definition( int local_from_item_id , int local_to_item_id )
{
    pointer_to_definition_of_item[ local_to_item_id ] = local_from_item_id ;
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
    item_id = local_item_id ;
    remove_leading_delimiters( ) ;
    remove_trailing_delimiters( ) ;
    return item_id ;
}

int parameterized_yes_or_no_empty( int local_item_id )
{
    item_id = local_item_id ;
    check_yes_or_no_solo_item_is_empty( ) ;
    return yes_or_no_text_item_is_empty ;
}

int parameterized_yes_or_no_phrase_name( int local_item_id )
{
    int local_yes_or_no ;
    item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_phrase_definition_not_empty( int local_item_id )
{
    item_id = pointer_to_definition_of_item[ local_item_id ] ;
    check_yes_or_no_solo_item_is_empty( ) ;
    return yes_or_no_text_item_is_empty ;
}

int parameterized_yes_or_no_positive_integer( int local_item_id )
{
    int local_yes_or_no ;
    item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_integer( int local_item_id )
{
    int local_yes_or_no ;
    item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_positive_real_number( int local_item_id )
{
    int local_yes_or_no ;
    item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_real_number( int local_item_id )
{
    int local_yes_or_no ;
    item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_phrase_contains_real_numbers( int local_item_id )
{
    int local_yes_or_no ;
    item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_normalize_calculated_value( int local_item_id )
{
    int local_yes_or_no ;
    item_id = local_item_id ;

    return local_item_id ;
}

int parameterized_convert_numeric_text_into_numeric_value( int local_item_id )
{
    int local_yes_or_no ;
    item_id = local_item_id ;

    return local_item_id ;
}

int parameterized_convert_numeric_value_into_numeric_text( int local_item_id )
{
    int local_yes_or_no ;
    item_id = local_item_id ;

    return local_item_id ;
}

int parameterized_get_list_of_words( int local_item_id )
{
    int local_yes_or_no ;
    item_id = local_item_id ;

    return local_item_id ;
}

int parameterized_yes_or_no_valid_url( int local_item_id )
{
    int local_yes_or_no ;
    item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_valid_path( int local_item_id )
{
    int local_yes_or_no ;
    item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_valid_path_prefix( int local_item_id )
{
    int local_yes_or_no ;
    item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_yes_or_no_file_name( int local_item_id )
{
    item_id = local_item_id ;
    initialize_parse_characters_of_filename( ) ;
    for ( text_pointer = pointer_begin_for_item[ id_from_origin ] ; text_pointer <= pointer_end_for_item[ id_from_origin ] ; text_pointer ++ )
    {
//  todo: proofread
        character_category = all_characters[ text_pointer ] ;
        parse_one_character_of_filename( ) ;
        if ( ( yes_or_no_numeric_delimiter_encountered == yes_yes ) || ( text_pointer == pointer_end_for_item[ id_from_origin ] ) )
        {
            if ( yes_or_no_filename_is_valid == yes_yes )
            {
                log_out << "filename = ?" << std::endl ;
            } else
            {
                log_out << "invalid filename" << std::endl ;
            }
        }
        initialize_parse_characters_of_filename( ) ;
    }
    return yes_or_no_filename_is_valid ;
}

int parameterized_yes_or_no_folder_name( int local_item_id )
{
//  The flag yes_or_no_use_slash_not_backslash
//  identifies whether slashes or backslashes are
//  allowed in folder names.
    item_id = local_item_id ;
    initialize_parse_characters_of_folder_name( ) ;
    for ( text_pointer = pointer_begin_for_item[ item_id ] ; text_pointer <= pointer_end_for_item[ item_id ] ; text_pointer ++ )
    {
        single_character_as_integer = all_characters[ text_pointer ] ;
        parse_one_character_of_folder_name( ) ;
        if ( ( yes_or_no_numeric_delimiter_encountered == yes_yes ) || ( text_pointer == pointer_end_for_item[ item_id ] ) )
        {
            if ( yes_or_no_folder_name_is_valid == yes_yes )
            {
                log_out << "folder name = ?" << std::endl ;
            } else
            {
                log_out << "invalid folder name" << std::endl ;
            }
            initialize_parse_characters_of_folder_name( ) ;
        }
    }
    return yes_or_no_folder_name_is_valid ;
}

int parameterized_yes_or_no_input_file_exists( int local_item_id )
{
    int local_yes_or_no ;
    item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_open_file_for_reading( int local_item_id )
{
    int local_yes_or_no ;
    item_id = local_item_id ;

    return local_yes_or_no ;
}

int parameterized_open_file_for_appending( int local_item_id )
{
    int local_yes_or_no ;
    item_id = local_item_id ;

    return local_yes_or_no ;
}

void point_to_words( )
{

    return ;
}

void point_to_words_in_operand_one( )
{
    item_id = text_item_for_operand_one ;
    point_to_words( ) ;
    return ;
}

void point_to_words_in_operand_two( )
{
    item_id = text_item_for_operand_two ;
    point_to_words( ) ;
    return ;
}

void point_to_words_in_operand_three( )
{
    item_id = text_item_for_operand_three ;
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
//  Here is where the Dashrep compiler insert the
//  program-specific functions

// <here_supply_program_specific_functions>


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

    yes_or_no_more_text_in_file = yes_yes ;
    yes_or_no_encountered_eof_flag = no_no ;
    infile_connection = fopen( "input_dashrep_example_menagerie_copy.txt" , "r" ) ;
    outfile_connection = fopen( "temp_output_from_c_language_runtime_test.txt" , "w" ) ;

    log_out << "id_for_file_input " << id_for_file_input << std::endl ;

    data_type = data_type_linked_list ;
    length_requested_for_next_item_storage = 20 ;
    create_new_item_id_and_assign_storage( ) ;
    id_for_testing = new_item_id ;

    while ( yes_or_no_more_text_in_file != no_no )
    {
        read_text_line_from_file( ) ;
        item_id = id_for_file_input ;
        write_simple_text_item_to_file( ) ;
        single_character_as_integer = unicode_for_newline ;
        write_single_character_as_integer_to_file( ) ;

        id_text_to_edit = id_for_testing ;
        append_space_if_not_empty( ) ;
        id_from_origin = id_for_file_input ;
        id_text_to_edit = id_for_testing ;
        append_text( ) ;
    }

    show_defined_text_items( ) ;

//    single_integer = 170512 ;
//    convert_integer_to_text( ) ;

//    log_out << "next test" << std::endl ;

//    id_from_origin = id_for_number_as_text ;
//    write_text_item_to_file( ) ;

//    log_out << "next test" << std::endl ;

    id_text_to_edit = id_for_sample_numbers ;
//    remove_leading_and_trailing_delimiters( ) ;
    item_id = id_for_sample_numbers ;
//    write_text_item_to_file( ) ;

//    id_from_origin = id_for_sample_numbers ;
//    id_text_to_edit = id_for_sample_numbers ;
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

    int local_argv_pointer ;


// -----------------------------------------------
//  Get environment variable values that include
//  CGI info.

    for ( int local_argv_pointer = 0 ; local_argv_pointer < argc ; local_argv_pointer ++ )
    {
//        printf( "argv[ %d ] = %s\n", local_argv_pointer, argv[ local_argv_pointer ] ) ;
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
