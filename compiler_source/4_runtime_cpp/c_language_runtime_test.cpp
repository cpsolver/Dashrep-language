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
int global_text_length_for_item[ 20005 ] ;
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


// -----------------------------------------------
//  Declare global variables that hold text item
//  ID numbers.

int global_text_item_id ;
int global_new_storage_text_item_id ;
int global_from_text_item_id ;
int global_to_text_item_id ;
int global_convertable_text_item_id ;

int global_phrase_name_text_item_id ;
int global_definition_text_item_id ;

int global_matching_subtext_text_item_id ;
int global_finding_match_text_item_id ;

int global_text_item_id_for_file_input ;
int global_text_item_id_for_file_output ;
int global_text_item_id_for_single_space ;
int global_text_item_id_for_single_hyphen ;
int global_text_item_id_for_single_underscore ;
int global_text_item_id_for_single_newline ;
int global_text_item_id_for_single_carriage_return ;
int global_text_item_id_for_single_open_angle_bracket ;
int global_text_item_id_for_single_close_angle_bracket ;
int global_text_item_id_for_single_slash ;
int global_text_item_id_for_single_plus ;
int global_text_item_id_for_single_period ;
int global_text_item_id_for_single_apostrophe ;
int global_text_item_id_for_single_quotation_mark ;
int global_text_item_id_for_single_tab ;
int global_text_item_id_for_single_formfeed ;
int global_text_item_id_for_non_breaking_space ;
int global_text_item_id_for_phrase_name_character_hyphen ;
int global_text_item_id_for_phrase_name_character_space ;
int global_text_item_id_for_phrase_name_character_underscore ;
int global_text_item_id_for_phrase_name_character_newline ;
int global_text_item_id_for_phrase_name_character_tab ;
int global_text_item_id_for_phrase_name_four_hyphens ;
int global_text_item_id_for_phrase_name_empty_text ;
int global_text_item_id_for_phrase_name_non_breaking_space ;
int global_text_item_id_for_valid_filename ;
int global_text_item_id_for_valid_folder_name ;
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
int global_text_item_id_for_getting_next_character ;


// -----------------------------------------------
//  Declare pointers that point to portions of the
//  text items.  These first-in-last-out stacks
//  are overwritten when a new action begins (if
//  the action needs these pointers).

int global_text_id_number_for_action_stack_position[ 2005 ] ;
int global_position_in_text_item_for_action_stack_position[ 2005 ] ;
int global_next_action_stack_position_for_action_stack_position[ 2005 ] ;


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
//  Declare a two lists of pointers that point to
//  the words of a hyphenated phrase name.  This
//  is where such a name is stored while checking
//  for a match with an existing hyphenated phrase
//  name.  Allow 30 words for the longest phrase
//  name.  Array position counting starts at 1,
//  not zero.  Also declare related pointers.

const int global_maximum_words_in_hyphenated_phrase_name = 30 ;
int global_word_count_parsed_hyphenated_phrase_name ;
int global_parsed_hyphenated_phrase_name_pointer_begin_word[ 32 ] ;
int global_parsed_hyphenated_phrase_name_pointer_end_word[ 32 ] ;
int global_word_position_in_parsed_hyphenated_phrase_name ;


// -----------------------------------------------
//  Declare a "char" data type that is used to
//  access a double-quoted text word in this code.

const int global_allocated_length_for_this_word = 200 ;
char global_this_word[ 205 ] ;


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
//  * "list_of_text_item_ids"
//    Pointers to other text items that are
//    handled as "sub text items".
//
//  * "nothing_empty"
//    Zero characters.  This category eliminates
//    the need to check the text item's "begin"
//    and "end" pointers to see that the "end"
//    pointer is one character position less than
//    the "begin" pointer.
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
const int global_category_contains_nothing_empty = 1 ;
const int global_category_contains_unicode_anything = 2 ;
const int global_category_contains_unicode_no_delimiters = 3 ;
const int global_category_contains_list_of_text_item_ids = 4 ;
const int global_category_contains_hyphenated_phrase_name = 5 ;
const int global_category_contains_list_of_integers = 6 ;
const int global_category_contains_pointers_to_decimal_numbers = 7 ;


// -----------------------------------------------
//  Declare variables that store "text contains"
//  category values.

int global_text_contains_category ;
int global_to_text_contains_category ;
int global_from_text_contains_category ;


// -----------------------------------------------
//  Declare a list of the subitems of category
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
int global_character_count ;
int global_character_count_for_expand_text ;
int global_length_of_matching_text ;


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
//  Declare stack-type storage for text items and
//  character pointers.  These are used in
//  rotation, with the rotation sequence tracked.
//  This approach avoids the need to load and save
//  text item IDs and character pointers.

const int global_maximum_stack_number = 10 ;
int global_current_stack_number_available ;
const int global_maximum_stack_level = 20 ;
int global_text_item_id_for_stack_number_and_stack_level[ 12 ][ 22 ] ;
int global_character_pointer_for_stack_number_and_stack_level[ 12 ][ 22 ] ;


// -----------------------------------------------
//  Declare variables for using the stack-type
//  storage pointers.

int global_current_stack_number_for_getting_next_character ;
int global_current_stack_number_for_appending_next_character ;
int global_current_stack_number_for_word_list ;
int global_current_stack_number_for_word_list_for_loops ;

int global_current_stack_level ;
int global_current_stack_level_for_getting_next_character ;


// -----------------------------------------------
//  Declare a list of counters and special
//  counters that are used by the expand_text
//  function.

int global_recent_character_position_for_character_number[ 260 ] ;
int global_yes_or_no_looking_for_word_attribute_or_specify ;
int global_yes_or_no_prior_character_was_delimiter ;
int global_yes_or_no_delimiter_encountered ;
int global_recent_character_position_for_character_number_beyond_ascii ;


// -----------------------------------------------
//  Declare buffers that hold multiple character
//  pointers that point to hyphens, underscores,
//  and the letter "t" which appears three times
//  in the word "attribute".

int global_character_usage_buffer_rotation_number ;
const int global_maximum_character_usage_buffer_rotation_number = 30 ;
int global_character_usage_position_for_hyphen_for_buffer_rotation[ 31 ] ;
int global_character_usage_position_for_underscore_for_buffer_rotation[ 31 ] ;
int global_character_usage_position_for_letter_t_for_buffer_rotation[ 31 ] ;
int global_character_usage_buffer_rotation_number_for_hyphen ;
int global_character_usage_buffer_rotation_number_for_underscore ;
int global_character_usage_buffer_rotation_number_for_letter_t ;


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
//  Declare the matrix for the state machine that
//  is used to parse text.
//
//  States can include triggers for starting and
//  ending a match for a character sequence.
//
//  Data in this matrix is specified using
//  Dashrep code such as:
//  next-state-for-current-state fenambee
//  current-state amennfen and-current-category
//  fenambee current-category amenn


const int global_dimension_of_list_state_machine = 1000 ;

int global_next_state_for_current_state_and_character_category[ 1005 ][ 1005 ] ;


// -----------------------------------------------
//  Declare pointers to within a text item.

int global_pointer_to_within_text_item ;
int global_text_item_pointer ;


// -----------------------------------------------
//  Declare other pointers.

int global_word_position ;


// -----------------------------------------------
//  Declare some flags.

int global_yes_or_no_text_item_changeable ;
int global_yes_or_no_reached_end_of_current_text_item ;
int global_yes_or_no_same_unicode_characters ;
int global_yes_or_no_same_hyphenated_phrase_name ;


// -----------------------------------------------
//  Declare some variables.

int global_check_for_match_text_item_id ;
int global_text_item_looking_at_next_word_in_hyphenated_phrase ;
int global_text_item_intended_next_word_in_hyphenated_phrase ;
int global_word_count_hyphenated_phrase_name ;
int global_search_character_pointer_begin ;
int global_search_character_pointer_end ;
int global_match_character_pointer_begin ;
int global_match_character_pointer_end ;


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
int global_yes_or_no_requesting_space_appended ;
int global_one_number_to_append ;
int global_yes_or_no_can_extend_text_item ;
int global_text_pointer ;
int global_single_character_as_integer ;
int global_yes_or_no_negative_number ;
int global_yes_or_no_decimal_number ;
int global_yes_or_no_number_is_valid ;
int global_single_integer ;
int global_decimal_number_divisor ;
int global_number_of_digits_encountered ;
int global_yes_or_no_numeric_delimiter_encountered ;
int global_yes_or_no_filename_is_valid ;
int global_yes_or_no_in_filename_before_period ;
int global_number_of_valid_characters_encountered ;
int global_yes_or_no_filename_delimiter_encountered ;
int global_yes_or_no_folder_name_is_valid ;
int global_yes_or_no_in_folder_name_before_period ;
int global_yes_or_no_folder_name_delimiter_encountered ;
int global_yes_or_no_use_slash_not_backslash ;


// -----------------------------------------------
//  Declare some variables that store decimal
//  numbers.

float global_single_decimal_number ;


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
//  be empty.  This is done for readability.

int global_do_nothing ;


// -----------------------------------------------
//  Specify the Dashrep-recognized phrase names.
//
//  Later, generate this code.

char global_dashrep_phrase_names[ ] = "hyphen-here character-hyphen four-hyphens no-space empty-text one-space character-space non-breaking-space new-line empty-line line-break character-newline character-tab character-underscore  expand-text standard-output copy-text append-text append-text-no-space append-new-line append-repeatedly-using-count prepend-text prepend-text-no-space put-into-phrase get-phrase-name-from-phrase get-cgi-information get-definitions-from-phrase put-listed-phrase-definitions-into-phrase copy-listed-words-to-phrases-named-in-pattern append-multiple-from-phrases-named-in-pattern clear-phrase clear-listed-phrases delete-listed-phrases if-yes-begin if-no-begin if-else if-end yes-or-no-empty-phrase yes-or-no-same-two-phrase-definitions yes-or-no-same-two-words yes-or-no-opposite yes-if-all-yes yes-if-any-yes no-if-any-no yes-if-not-no no-if-not-yes use-handler-with-each-word-in-phrase word-to-use-in-handler get-count-of-words get-word-at-position get-position-of-word copy-word-at-position copy-words-from-position-to-position copy-words-offset-skip copy-words-found-in-both-lists copy-words-found-in-either-list copy-words-found-only-in-first-list copy-words-that-begin-with-text copy-words-that-begin-with-listed-words copy-words-that-contain-listed-words copy-words-unique-only list-of-unique-word-counts list-of-pointers-to-unique-words copy-words-order-reversed copy-words-sort-numeric copy-words-rearrange-using-order-sort-numeric copy-words-sort-alphabetic copy-words-rearrange-using-order-sort-alphabetic generate-counts-from-integer-to-integer generate-every-pairwise-combination-of-words generate-every-ordered-pairwise-combination-of-words generate-list-of-all-dashrep-phrases get-count-of-characters get-characters-from-position-to-position copy-characters-from-position-to-position copy-without-extra-spaces copy-lowercase-only copy-uppercase-only copy-initial-caps copy-zero-pad-left-to-length encode-as-cgi-parameter decode-from-cgi-parameter convert-unicode-to-html-entities get-position-of-matching-text copy-and-replace copy-and-replace-using-paired-listed-words generate-positions-of-listed-words generate-positions-of-delimiter generate-positions-of-first-matching-delimiter-after-listed-positions get-current-time-in-epoch-seconds split-epoch-seconds-into-named-components split-epoch-seconds-into-named-components-for-zero-meridian time-day-of-month time-day-of-week time-day-of-year time-hour time-minute time-month-number time-second time-year zero-or-nonzero zero-one-multiple numeric-equal-greater-less-compare numeric-add numeric-minus numeric-multiply numeric-divide-by numeric-maximum numeric-minimum numeric-increment numeric-decrement numeric-integer numeric-absolute numeric-odd-or-even numeric-square-root numeric-sine numeric-cosine numeric-logarithm-base-e numeric-logarithm-base-10 numeric-pi numeric-vector-add-number numeric-vector-multiply-by-number numeric-vectors-add numeric-vectors-multiply numeric-vectors-divide-by numeric-vector-integers numeric-vector-absolutes numeric-vectors-from-delta-values-calculate-distances numeric-two-dimensional-sort-into-columns-and-rows numeric-y-map-tile-number-based-on-latitude numeric-map-tile-zoom copy-and-move-attributes-into-xml-tags copy-and-remove-attributes-from-xml-tags yes-or-no-permission-to-append-to-files yes-or-no-permission-to-delete-or-overwrite-files dashrep-path-prefix-for-file-reading dashrep-path-prefix-for-file-writing operating-system-slash-or-backslash dashrep-file-name-if-read-file-missing generate-list-of-files-in-current-read-directory generate-list-of-folders-in-current-read-directory yes-or-no-file-exists yes-or-no-folder-exists size-of-file modification-time-of-file set-file-permission-public-read set-file-permission-private set-file-permission-private-but-executable rename-file delete-file create-empty-sub-folder copy-from-file-to-phrase end-of-line-indicator text-end-of-line-here-space-delimited yes-or-no-trim-spaces-when-copy-from-file yes-or-no-skip-empty-lines-when-copy-from-file copy-from-phrase-append-to-file copy-append-file-to-file linewise-read-from-file-and-use-handler linewise-input-line-from-file linewise-input-line-count linewise-read-from-standard-input get-url-resource trace-from-get-url-resource find-line-in-file-that-begins-with-text find-lines-in-file-that-begin-with-any-listed-word find-lines-in-file-that-begin-with-any-two-words-listed copy-from-columns-in-file-to-named-phrases copy-from-columns-in-file-to-column-lists yes-or-no-use-two-spaces-as-column-delimiter gather-tagged-info-from-file gather-from-tagged-file-one-entry write-gathered-listed-items-to-end-of-file dashrep-gather-tag-begin dashrep-gather-tag-end dashrep-gather-tag-unique dashrep-gather-tag-delete dashrep-gather-tag-matching-id trace-show trace-show-where output-trace-file-name dashrep-comments-ignored generate-phrase-usage-counts exit-from-dashrep dashrep-language-yes dashrep-version delayed-nospace delayed-newline yes-or-no-permission-administrator dashrep-endless-loop-counter-limit dashrep-time-limit " ;


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
//  Function check_yes_or_no_can_extend_text_item
//

void check_yes_or_no_can_extend_text_item( )
{
    if ( global_text_pointer_end_for_item[ global_text_item_id ] < global_text_pointer_allocation_end_for_item[ global_text_item_id ]  )
    {
        global_yes_or_no_can_extend_text_item = global_yes ;
    } else
    {
        global_yes_or_no_can_extend_text_item = global_no ;
    }
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
    global_text_length_for_item[ global_next_available_text_item_id ] = 0 ;
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
//  position for future extension.

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
//  Function write_single_character_to_file
//
//  Write the global_single_character to the
//  output file.  Ignore any error responses.

void write_single_character_to_file( )
{
    global_response_ignored = fputc( global_single_character , global_outfile_connection ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function store_one_text_character
//
//  Stores the integer in the variable
//  global_one_number_to_append, putting it into
//  the text item with ID number
//  global_text_item_id.
//  Bounds checking should be done before using
//  this function.  The bounds checking done here
//  should not be relied on.

void store_one_text_character( )
{
    int yes_or_no ;

    check_yes_or_no_can_extend_text_item( ) ;
    if ( global_yes_or_no_can_extend_text_item == global_no )
    {
        log_out << "[BUG:  Cannot expand size of text item ID number " << global_to_text_item_id << "]" ;
        exit( EXIT_FAILURE ) ;
    }
    global_text_pointer_end_for_item[ global_to_text_item_id ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_to_text_item_id ] ] = global_one_number_to_append ;
    global_text_length_for_item[ global_to_text_item_id ] ++ ;
    log_out << "[stored " << global_one_number_to_append << " at " << global_text_pointer_end_for_item[ global_to_text_item_id ] << "]" ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function store_this_word_in_text_item
//
//  Copies the text word in the char array named
//  global_this_word into a new text item.

void store_this_word_in_text_item( )
{
    int next_character_position_in_storage_all_text ;


// -----------------------------------------------
//  Count the characters to be stored, and request
//  this amount of storage space.
//
//  Reminder:  The first character position is
//  zero because this code handles text that
//  is imported using the strcpy function.

    global_character_count = 0 ;
    for ( global_character_pointer = 0 ; global_character_pointer <= ( sizeof( global_this_word ) - 1 ) ; global_character_pointer ++ )
    {
        global_single_character = (int) global_this_word[ global_character_pointer ] ;
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

    next_character_position_in_storage_all_text = global_text_pointer_begin_for_item[ global_new_storage_text_item_id ] ;
    for ( global_character_pointer = 0 ; global_character_pointer < global_character_count ; global_character_pointer ++ )
    {
        global_single_character = (int) global_this_word[ global_character_pointer ] ;
        global_storage_all_text[ next_character_position_in_storage_all_text ] = global_single_character ;
        next_character_position_in_storage_all_text ++ ;
    }


// -----------------------------------------------
//  Update the pointer to the end of the
//  just-stored text.

    global_text_pointer_end_for_item[ global_new_storage_text_item_id ] = global_text_pointer_begin_for_item[ global_new_storage_text_item_id ] + global_character_count - 1 ;
    global_text_length_for_item[ global_new_storage_text_item_id ] = global_character_count ;


// -----------------------------------------------
//  End of function store_this_word_in_text_item.

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
    global_text_length_for_item[ 0 ] = 0 ;


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
//  and define text item ID numbers for those
//  symbols.

    global_length_requested_for_next_text_item_storage = 1 ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_space = global_new_storage_text_item_id ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_space ] ] = global_ascii_code_for_space ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_hyphen = global_new_storage_text_item_id ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_hyphen ] ] = global_ascii_code_for_hyphen ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_newline = global_new_storage_text_item_id ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_newline ] ] = global_ascii_code_for_newline ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_carriage_return = global_new_storage_text_item_id ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_carriage_return ] ] = global_ascii_code_for_carriage_return ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_quotation_mark = global_new_storage_text_item_id ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_quotation_mark ] ] = global_ascii_code_for_quotation_mark ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_apostrophe = global_new_storage_text_item_id ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_apostrophe ] ] = global_ascii_code_for_apostrophe ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_plus = global_new_storage_text_item_id ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_plus ] ] = global_ascii_code_for_plus ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_underscore = global_new_storage_text_item_id ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_underscore ] ] = global_ascii_code_for_underscore ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_period = global_new_storage_text_item_id ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_period ] ] = global_ascii_code_for_period ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_open_angle_bracket = global_new_storage_text_item_id ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_open_angle_bracket ] ] = global_ascii_code_for_open_angle_bracket ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_close_angle_bracket = global_new_storage_text_item_id ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_close_angle_bracket ] ] = global_ascii_code_for_close_angle_bracket ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_slash = global_new_storage_text_item_id ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_slash ] ] = global_ascii_code_for_slash ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_tab = global_new_storage_text_item_id ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_tab ] ] = global_ascii_code_for_tab ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_formfeed = global_new_storage_text_item_id ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_formfeed ] ] = global_ascii_code_for_formfeed ;

    for ( text_id_number = global_text_item_id_for_single_space ; text_id_number <= global_text_item_id_for_single_formfeed ; text_id_number ++ )
    {
        global_text_pointer_end_for_item[ text_id_number ] = global_text_pointer_begin_for_item[ text_id_number ] ;
        global_text_length_for_item[ text_id_number ] = 1 ;
        global_text_category_for_item[ text_id_number ] = global_category_contains_unicode_anything ;
    }


// -----------------------------------------------
//  Create the text items for words within the
//  phrase names that have definitions (rather
//  than only having meaning between the words
//  ambee and amenn.
//
//  Reminder: The strcpy function starts position
//  counting at one, not zero.

    strcpy( global_this_word , "character" ) ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_character = global_new_storage_text_item_id ;



    strcpy( global_this_word , " 123 , 72.3 , -4399 , -88.6666 " ) ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_sample_numbers = global_new_storage_text_item_id ;


    strcpy( global_this_word , "  , xyz !@#$%^&*(){}:;?<> yes_name.txt , " ) ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_sample_filename = global_new_storage_text_item_id ;

    strcpy( global_this_word , "  , xyz !@#$%/^&\\*(){}:;?<> /yes_name/txt/ , " ) ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_sample_folder_name = global_new_storage_text_item_id ;

    strcpy( global_this_word , "   _ hyphenated-phrase   <specify 123>  <attribute 123> " ) ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_sample_text_to_expand = global_new_storage_text_item_id ;


    strcpy( global_this_word , "hyphen" ) ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_hyphen = global_new_storage_text_item_id ;

    strcpy( global_this_word , "space" ) ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_space = global_new_storage_text_item_id ;

    strcpy( global_this_word , "newline" ) ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_newline = global_new_storage_text_item_id ;

    strcpy( global_this_word , "underscore" ) ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_underscore = global_new_storage_text_item_id ;

    strcpy( global_this_word , "tab" ) ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_tab = global_new_storage_text_item_id ;

    strcpy( global_this_word , "four" ) ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_four = global_new_storage_text_item_id ;

    strcpy( global_this_word , "hyphens" ) ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_hyphens = global_new_storage_text_item_id ;

    strcpy( global_this_word , "non" ) ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_non = global_new_storage_text_item_id ;

    strcpy( global_this_word , "breaking" ) ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_breaking = global_new_storage_text_item_id ;

    strcpy( global_this_word , "empty" ) ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_empty = global_new_storage_text_item_id ;

    strcpy( global_this_word , "text" ) ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_text = global_new_storage_text_item_id ;


// -----------------------------------------------
//  Create the text items for Dashrep-defined
//  static phrase names.  And supply their
//  definitions.

    global_length_requested_for_next_text_item_storage = 2 ;

// character-hyphen
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_phrase_name_character_hyphen = global_new_storage_text_item_id ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_hyphen ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_hyphen ] ] = global_text_item_id_for_word_character ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_hyphen ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_hyphen ] ] = global_text_item_id_for_word_hyphen ;
    global_text_length_for_item[ global_text_item_id_for_phrase_name_character_hyphen ] = 2 ;
    global_id_of_item_containing_definition_for_item[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_hyphen ] ] = global_text_item_id_for_single_hyphen ;


// character-space
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_phrase_name_character_space = global_new_storage_text_item_id ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_space ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_space ] ] = global_text_item_id_for_word_character ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_space ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_space ] ] = global_text_item_id_for_word_space ;
    global_text_length_for_item[ global_text_item_id_for_phrase_name_character_space ] = 2 ;
    global_id_of_item_containing_definition_for_item[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_space ] ] = global_text_item_id_for_single_space ;

// character-newline
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_phrase_name_character_newline = global_new_storage_text_item_id ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_newline ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_newline ] ] = global_text_item_id_for_word_character ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_newline ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_newline ] ] = global_text_item_id_for_word_newline ;
    global_text_length_for_item[ global_text_item_id_for_phrase_name_character_newline ] = 2 ;
    global_id_of_item_containing_definition_for_item[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_newline ] ] = global_text_item_id_for_single_newline ;

// character-tab
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_phrase_name_character_tab = global_new_storage_text_item_id ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_tab ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_tab ] ] = global_text_item_id_for_word_character ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_tab ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_tab ] ] = global_text_item_id_for_word_tab ;
    global_text_length_for_item[ global_text_item_id_for_phrase_name_character_tab ] = 2 ;
    global_id_of_item_containing_definition_for_item[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_tab ] ] = global_text_item_id_for_single_tab ;

// character-underscore
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_phrase_name_character_underscore = global_new_storage_text_item_id ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_underscore ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_underscore ] ] = global_text_item_id_for_word_character ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_underscore ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_underscore ] ] = global_text_item_id_for_word_underscore ;
    global_text_length_for_item[ global_text_item_id_for_phrase_name_character_underscore ] = 2 ;
    global_id_of_item_containing_definition_for_item[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_underscore ] ] = global_text_item_id_for_single_underscore ;

// four-hyphens
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_phrase_name_four_hyphens = global_new_storage_text_item_id ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_four_hyphens ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_four_hyphens ] ] = global_text_item_id_for_word_four ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_four_hyphens ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_four_hyphens ] ] = global_text_item_id_for_word_hyphens ;
    global_text_length_for_item[ global_text_item_id_for_phrase_name_four_hyphens ] = 2 ;
    global_id_of_item_containing_definition_for_item[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_four_hyphens ] ] = global_text_item_id_for_phrase_name_four_hyphens ;

// empty-text
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_phrase_name_empty_text = global_new_storage_text_item_id ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_empty_text ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_empty_text ] ] = global_text_item_id_for_word_character ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_empty_text ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_empty_text ] ] = global_text_item_id_for_word_hyphen ;
    global_text_length_for_item[ global_text_item_id_for_phrase_name_empty_text ] = 2 ;
    global_id_of_item_containing_definition_for_item[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_empty_text ] ] = global_text_item_id_for_phrase_name_empty_text ;

    global_length_requested_for_next_text_item_storage = 3 ;

// non-breaking-space
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_phrase_name_non_breaking_space = global_new_storage_text_item_id ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_non_breaking_space ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_non_breaking_space ] ] = global_text_item_id_for_word_non ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_non_breaking_space ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_non_breaking_space ] ] = global_text_item_id_for_word_breaking ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_non_breaking_space ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_non_breaking_space ] ] = global_text_item_id_for_word_space ;
    global_text_length_for_item[ global_text_item_id_for_phrase_name_non_breaking_space ] = 3 ;
    global_id_of_item_containing_definition_for_item[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_non_breaking_space ] ] = global_text_item_id_for_phrase_name_non_breaking_space ;


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

    global_yes_or_no_requesting_space_appended = global_yes ;
    global_number_of_hyphenated_phrase_names_in_text_items = 0 ;


// -----------------------------------------------
//  Now that initialization is done, do not allow
//  text items to have their contents changed.

    global_yes_or_no_text_item_changeable = global_no ;


// -----------------------------------------------
//  Define numeric-pi as decimal number using
//  category list_of_decimal_numbers.
//  If calculation is involved, set flag and do
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
//  Function read_text_line_from_file
//
//  Reads one line of text from a file and puts
//  the text into the text item ID numbered
//  global_text_item_id_for_file_input.

void read_text_line_from_file( )
{
    global_text_pointer_end_for_item[ global_text_item_id_for_file_input ] = global_text_pointer_begin_for_item[ global_text_item_id_for_file_input ] - 1 ;
    global_text_length_for_item[ global_text_item_id_for_file_input ] = 0 ;
    global_text_category_for_item[ global_text_item_id_for_file_input ] = global_category_contains_unicode_anything ;
    while ( 1 == 1 )
    {
        global_next_character_number = fgetc( global_infile_connection ) ;
        global_one_number_to_append = global_next_character_number ;
        global_to_text_item_id = global_text_item_id_for_file_input ;
        check_yes_or_no_can_extend_text_item( ) ;
        if ( global_yes_or_no_can_extend_text_item == global_yes )
        {
            store_one_text_character( ) ;
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
        }
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function text_item_clear
//
//  Changes a text item to point to nothing, but
//  does not change any linked lower-level text
//  items.  If the text item still can possibly be
//  referenced by another higher-level text item,
//  do not use this function, and instead point to
//  the empty text item or create a new text item.

void text_item_clear( )
{
    global_text_category_for_item[ global_to_text_item_id ] = global_category_contains_nothing_empty ;
    global_text_pointer_end_for_item[ global_to_text_item_id ] = global_text_pointer_begin_for_item[ global_to_text_item_id ] - 1 ;
    global_text_length_for_item[ global_to_text_item_id ] = 0 ;
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
//  ID number in global_from_text_item_id,
//  and the text item being extended is specified
//  by the text item ID number in
//  global_to_text_item_id.  The value in
//  global_yes_or_no_requesting_space_appended
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

    if ( ( global_text_category_for_item[ global_from_text_item_id ] == global_category_contains_nothing_empty ) || ( global_text_length_for_item[ global_from_text_item_id ] == 0 ) )
    {
        log_out << "text to append is empty so nothing to append" << std::endl ;
        return ;
    }


// -----------------------------------------------
//  If the text being extended is empty, just put
//  a pointer into the text being extended.  The
//  pointer points to the text being appended.

    global_to_text_contains_category = global_text_category_for_item[ global_to_text_item_id ] ;
    if ( ( global_to_text_contains_category == global_category_contains_nothing_empty ) || ( global_text_length_for_item[ global_to_text_item_id ] == 0 ) )
    {
        switch ( global_to_text_contains_category )
        {
            case global_category_contains_list_of_text_item_ids :
                return ;
                break ;
            case global_category_contains_unicode_anything :
                return ;
                break ;
            case global_category_contains_unicode_no_delimiters :
                global_text_item_id = global_to_text_contains_category ;
                exit_not_yet_supported( ) ;
                return ;
                break ;
            case global_category_contains_hyphenated_phrase_name :
                global_text_item_id = global_to_text_contains_category ;
                exit_not_yet_supported( ) ;
                return ;
                break ;
            case global_category_contains_list_of_integers :
                global_text_item_id = global_to_text_contains_category ;
                exit_not_yet_supported( ) ;
                return ;
                break ;
            case global_category_contains_pointers_to_decimal_numbers :
                global_text_item_id = global_to_text_contains_category ;
                exit_not_yet_supported( ) ;
                return ;
                break ;
            default :
                return ;
                break ;

        }

        log_out << "text being extended is empty so just point to the text being appended" << std::endl ;
        return ;
    }


// -----------------------------------------------
//  If the text being extended is not empty and
//  there is a request to insert a space between
//  the extended text and the appended text,
//  insert a space.

    if ( ( ( global_text_category_for_item[ global_to_text_item_id ] != global_category_contains_nothing_empty ) || ( global_text_length_for_item[ global_to_text_item_id ] != 0 ) ) && ( global_yes_or_no_requesting_space_appended == global_yes ) )
    {
        if ( global_text_category_for_item[ global_to_text_item_id ] == global_category_contains_list_of_text_item_ids )
        {
            check_yes_or_no_can_extend_text_item( ) ;
            if ( global_yes_or_no_can_extend_text_item == global_yes )
            {
                global_one_number_to_append = global_text_item_id_for_single_space ;
                store_one_text_character( ) ;
            } else
            {
                log_out << "create new text item to make room for space character" << std::endl ;
            }
        } else
        {
            global_length_requested_for_next_text_item_storage = global_default_length_for_text_item ;
            assign_storage_for_new_text_item( ) ;
            global_text_category_for_item[ global_new_storage_text_item_id ] = global_category_contains_list_of_text_item_ids ;
//  insert the to and space IDs, but not the from ID
//        global_storage_all_text
            global_to_text_item_id = global_new_storage_text_item_id ;
        }
    }


// -----------------------------------------------
//  Get the categories of the "from" and "to" text
//  items.

    global_from_text_contains_category = global_text_category_for_item[ global_from_text_item_id ] ;
    global_to_text_contains_category = global_text_category_for_item[ global_to_text_item_id ] ;


// -----------------------------------------------
//  If the "to" and "from" categories are
//  different, create a new text item of category
//  "..." and into it put pointers that point to
//  the "to" and "from" text items, and change the
//  text item ID of the "to" text item, then
//  return.

    if ( global_from_text_contains_category != global_to_text_contains_category )
    {
        global_length_requested_for_next_text_item_storage = global_default_length_for_text_item ;
        assign_storage_for_new_text_item( ) ;
        global_one_number_to_append = global_to_text_item_id ;
        global_to_text_item_id = global_new_storage_text_item_id ;
        store_one_text_character( ) ;
        global_one_number_to_append = global_text_item_id_for_single_space ;
        store_one_text_character( ) ;
        global_one_number_to_append = global_from_text_contains_category ;
        store_one_text_character( ) ;
        global_text_category_for_item[ global_to_text_item_id ] = global_category_contains_list_of_text_item_ids ;
        return ;
    }


// -----------------------------------------------
//  Begin a branch that handles cases where the
//  "from" and "to" categories are the same.  Each
//  branch handles a different category type.
//
//  Possibly move this code to a function that
//  can call itself, to allow for nested levels
//  of text items.

    switch ( global_to_text_contains_category )
    {


// -----------------------------------------------
//  If the categories of the "from" and "to" text
//  items are both of category "nothing_empty",
//  there is nothing to do, so return.

        case global_category_contains_nothing_empty :
            return ;
            break ;


// -----------------------------------------------
//  If the categories of the "from" and "to" text
//  items are both of category
//  contains_unicode_anything, then add the
//  characters if they fit, and otherwise add to
//  the higher-level item a pointer to the text.

        case global_category_contains_unicode_anything :
            global_text_item_id = global_to_text_contains_category ;
            exit_not_yet_supported( ) ;

//            global_storage_all_text[ global_text_pointer_begin_for_item[ global_to_text_item_id ] ] = global_from_text_item_id ;
//            global_text_pointer_end_for_item[ global_to_text_item_id ] = global_text_pointer_begin_for_item[ global_to_text_item_id ] ;
//            global_text_length_for_item[ global_to_text_item_id ] = 1 ;
//            global_id_of_item_containing_definition_for_item[ global_to_text_item_id ] = 0 ;


            global_text_item_id = global_to_text_contains_category ;
            exit_not_yet_supported( ) ;
            global_text_pointer_begin_for_item[ global_from_text_item_id ] = 0 ;
            global_text_pointer_end_for_item[ global_to_text_item_id ] = 0 ;
            global_text_length_for_item[ global_to_text_item_id ] = 0 ;
            global_id_of_item_containing_definition_for_item[ global_to_text_item_id ] = 0 ;
            break ;


// -----------------------------------------------
//  If the categories of the "from" and "to" text
//  items are both of category
//  contains_list_of_integers, add the integer to
//  the list.

        case global_category_contains_list_of_integers :
            global_text_item_id = global_to_text_contains_category ;
            exit_not_yet_supported( ) ;
            break ;


// -----------------------------------------------
//  If the categories of the "from" and "to" text
//  items are both of category
//  contains_pointers_to_decimal_numbers, add the
//  pointers to the list.

        case global_category_contains_pointers_to_decimal_numbers :
            global_text_item_id = global_to_text_contains_category ;
            exit_not_yet_supported( ) ;
            break ;


// -----------------------------------------------
//  Otherwise there is an error.

        default :
            log_out << "BUG: one or more text item categories are not recognized" << std::endl ;
            break ;


// -----------------------------------------------
//  End of "switch" statement.

    }


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
//  global_from_text_item_id, and the text
//  item being extended is specified by the text
//  item ID number in
//  global_to_text_item_id.

void append_copied_text( )
{
    text_item_clear( ) ;

    log_out << "todo: here, need code that copies text to be appended" << std::endl ;

    append_linked_text( ) ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function append_space_if_not_empty
//
//  Appends a space to
//  global_to_text_item_id
//  if it is not empty.
//  If the text item is categorized as a list of
//  numbers (integer or decimal), must convert
//  text item into characters.

void append_space_if_not_empty( )
{
    if ( ( global_text_category_for_item[ global_to_text_item_id ] != global_character_category_empty ) && ( global_text_length_for_item[ global_to_text_item_id ] > 0 ) )
    {
        log_out << "todo: append space" << std::endl ;
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function copy_linked_text

void copy_linked_text( )
{
    text_item_clear( ) ;
    append_linked_text( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function copy_copied_text

void copy_copied_text( )
{
    text_item_clear( ) ;
    append_copied_text( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function point_to_next_stack_storage_area

void point_to_next_stack_storage_area( )
{
    global_current_stack_number_available ++ ;
    if ( global_current_stack_number_available > global_maximum_stack_number )
    {
        global_current_stack_number_available = 1 ;
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function initialize_get_next_character_from_text_item

void initialize_get_next_character_from_text_item( )
{
    global_current_stack_number_for_getting_next_character = global_current_stack_number_available ;
    point_to_next_stack_storage_area( ) ;
    global_text_item_id_for_getting_next_character = global_text_item_id ;
    global_current_stack_level_for_getting_next_character = 1 ;
    global_text_item_id_for_stack_number_and_stack_level[ global_current_stack_number_for_getting_next_character ][ global_current_stack_level_for_getting_next_character ] = global_text_item_id_for_getting_next_character ;
    global_character_pointer_for_stack_number_and_stack_level[ global_current_stack_number_for_getting_next_character ][ global_current_stack_level_for_getting_next_character ] = global_text_pointer_begin_for_item[ global_text_item_id_for_getting_next_character ] ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_next_character_from_text_item

void get_next_character_from_text_item( )
{


// -----------------------------------------------
//  Begin a loop that points to the next
//  character.  When needed, move up or down the
//  stack, or sometimes both up and down.  This
//  function exits within the loop as soon as the
//  next character is known.

global_single_character_as_integer = 0 ;
while ( 1 == 1 )
{


// -----------------------------------------------
//  Write debugging info.

    log_out << "stack number " << global_current_stack_number_for_getting_next_character << ", stack level " << global_current_stack_level_for_getting_next_character << ", yes/no end of text item " << global_yes_or_no_reached_end_of_current_text_item << ", text item " << global_text_item_id_for_getting_next_character << ", character pointer " << global_character_pointer_for_stack_number_and_stack_level[ global_current_stack_number_for_getting_next_character ][ global_current_stack_level_for_getting_next_character ] << ", text item category " << global_text_item_category << std::endl ;


// -----------------------------------------------
//  If the previous character was the last
//  character in the current-level text item,
//  track this situation.  Allow for the
//  possibility that the text item is empty.

    global_yes_or_no_reached_end_of_current_text_item = global_no ;
    if ( global_character_pointer_for_stack_number_and_stack_level[ global_current_stack_number_for_getting_next_character ][ global_current_stack_level_for_getting_next_character ] >= global_text_pointer_end_for_item[ global_text_item_id_for_getting_next_character ] )
    {
        global_yes_or_no_reached_end_of_current_text_item = global_yes ;
    }


// -----------------------------------------------
//  If the last character has already been
//  supplied, supply the character number as zero.

    if ( ( global_current_stack_level_for_getting_next_character == 1 ) && ( global_yes_or_no_reached_end_of_current_text_item == global_yes ) )
    {
        global_single_character_as_integer = 0 ;
        log_out << "end of text" << std::endl ;
        return ;
    }


// -----------------------------------------------
//  If the end of a sub text item has been
//  reached, move to a lower level on the stack,
//  and repeat the loop.  Get the information for
//  this text item from the stack.

    if ( global_yes_or_no_reached_end_of_current_text_item == global_yes )
    {
        global_current_stack_level_for_getting_next_character -- ;
        global_text_item_id_for_getting_next_character = global_text_item_id_for_stack_number_and_stack_level[ global_current_stack_number_for_getting_next_character ][ global_current_stack_level_for_getting_next_character ] ;
        global_character_pointer_for_stack_number_and_stack_level[ global_current_stack_number_for_getting_next_character ][ global_current_stack_level_for_getting_next_character ] = global_text_pointer_begin_for_item[ global_text_item_id_for_getting_next_character ] ;
        global_text_item_category = global_text_category_for_item[ global_text_item_id_for_getting_next_character ] ;
        continue ;
    }


// -----------------------------------------------
//  Jump to the appropriate section based on the
//  category of the text item or sub text item.

    switch ( global_text_item_category )
    {


// -----------------------------------------------
//  Handle the category "unicode_anything".
//  Supply the next character.  If there are no
//  more characters, pop the stack and point to
//  the text item at the next lower level, and
//  repeat the loop.

        case global_category_contains_unicode_anything :
            global_character_pointer = global_character_pointer_for_stack_number_and_stack_level[ global_current_stack_number_for_getting_next_character ][ global_current_stack_level_for_getting_next_character ] ;
            if ( global_character_pointer <= global_text_pointer_end_for_item[ global_text_item_id_for_getting_next_character ] )
            {
                global_single_character_as_integer = global_storage_all_text[ global_character_pointer ] ;
                log_out << "character " << global_single_character_as_integer << std::endl ;
                global_character_pointer_for_stack_number_and_stack_level[ global_current_stack_number_for_getting_next_character ][ global_current_stack_level_for_getting_next_character ] ++ ;
                return ;
            } else
            {

                log_out << "incomplete code: pop stack" << std::endl ;

                continue ;
            }
            break ;


// -----------------------------------------------
//  Handle the category "list_of_text_item_ids".

        case global_category_contains_list_of_text_item_ids :

            log_out << "incomplete code: handle list of text items" << std::endl ;

            global_text_item_pointer = global_character_pointer_for_stack_number_and_stack_level[ global_current_stack_number_for_getting_next_character ][ global_current_stack_level_for_getting_next_character ] ;

            global_text_item_id_for_getting_next_character = global_storage_all_text[ global_text_item_pointer ] ;

            global_current_stack_level_for_getting_next_character ++ ;

            global_text_item_id_for_stack_number_and_stack_level[ global_current_stack_number_for_getting_next_character ][ global_current_stack_level_for_getting_next_character ] = global_text_item_id_for_getting_next_character ;

            global_character_pointer_for_stack_number_and_stack_level[ global_current_stack_number_for_getting_next_character ][ global_current_stack_level_for_getting_next_character ] = global_text_pointer_begin_for_item[ global_text_item_id_for_getting_next_character ] ;

            global_text_item_category = global_text_category_for_item[ global_text_item_id_for_getting_next_character ] ;

            continue ;
            break ;


// -----------------------------------------------
//  Handle the category "unicode_no_delimiters".

        case global_category_contains_unicode_no_delimiters :
            global_text_item_id = global_to_text_contains_category ;
            exit_not_yet_supported( ) ;
            break ;


// -----------------------------------------------
//  Handle the category "hyphenated_phrase_name".

        case global_category_contains_hyphenated_phrase_name :
            global_text_item_id = global_to_text_contains_category ;
            exit_not_yet_supported( ) ;
            break ;


// -----------------------------------------------
//  Handle the category "list_of_integers".

        case global_category_contains_list_of_integers :
            global_text_item_id = global_to_text_contains_category ;
            exit_not_yet_supported( ) ;
            break ;


// -----------------------------------------------
//  Handle the category "pointers_to_decimal_numbers".

        case global_category_contains_pointers_to_decimal_numbers :
            global_text_item_id = global_to_text_contains_category ;
            exit_not_yet_supported( ) ;
            break ;


// -----------------------------------------------
//  If the text item category was not recognized,
//  there is a bug.

        default :
            log_out << "BUG, invalid text item category" << std::endl ;
            break ;


// -----------------------------------------------
//  End of cases for the category of the current
//  text item.

        }


// -----------------------------------------------
//  Repeat the loop to handle pointing to the next
//  character.

        log_out << "[Error, likely infinite loop]" << std::endl ;
        return ;
    }


// -----------------------------------------------
//  All done in function get_next_character_from_text_item.

    return ;

}



// -----------------------------------------------
// -----------------------------------------------
//  Function remove_leading_delimiters

void remove_leading_delimiters( )
{
    global_text_item_id = 81 ;
    exit_not_yet_supported( ) ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function remove_trailing_delimiters
//
//  traverse backwards from end, see
//  remove_leading_delimiters

void remove_trailing_delimiters( )
{
    global_text_item_id = 82 ;
    exit_not_yet_supported( ) ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function reorganize_as_linked_list_of_words
//
//  To increase speed when the text item is a list
//  of space delimited words, reorganize the text
//  item so that each word is in a separate
//  sub-text item that contains no delimiters.

void reorganize_as_linked_list_of_words( )
{
    global_text_item_id = 80 ;
    exit_not_yet_supported( ) ;
}


// -----------------------------------------------
// -----------------------------------------------
//  convert_float_to_text
//
//  This function is used instead of "std::to_string"
//  for compatibility with older C++ "string" libraries
//  that have a bug.  The bug is that the "to_string"
//  function is not recognized as being within the
//  "std" library, even though it is defined there.

std::string convert_float_to_text( float supplied_float )
{
    std::string returned_string ;
    char c_format_string[ 50 ] ;
    int unused_string_length ;
    try
    {
        unused_string_length = sprintf( c_format_string , "%1f" , supplied_float ) ;
        returned_string = ( std::string ) c_format_string ;
        //  next line assumes the sprintf result always includes a decimal point
        returned_string.erase( returned_string.find_last_not_of( "0" ) + 1 , std::string::npos ) ;
        returned_string.erase( returned_string.find_last_not_of( "." ) + 1 , std::string::npos ) ;
        return returned_string ;
    }
    catch( ... )
    {
        return "NAN" ;
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
//  Function test_parsing_numeric_characters

void test_parsing_numeric_characters( )
{
    global_from_text_item_id = global_text_item_id_for_sample_numbers ;
    initialize_parse_characters_of_number( ) ;
    for ( global_text_pointer = global_text_pointer_begin_for_item[ global_from_text_item_id ] ; global_text_pointer <= global_text_pointer_end_for_item[ global_from_text_item_id ] ; global_text_pointer ++ )
    {
        global_single_character_as_integer = global_storage_all_text[ global_text_pointer ] ;
        parse_one_character_of_number( ) ;
        if ( ( global_yes_or_no_numeric_delimiter_encountered == global_yes ) || ( global_text_pointer == global_text_pointer_end_for_item[ global_from_text_item_id ] ) )
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
                        log_out << "decimal number = " << convert_float_to_text( global_single_decimal_number ) << std::endl ;
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
//  Function test_parsing_filename_characters

void test_parsing_filename_characters( )
{
    global_from_text_item_id = global_text_item_id_for_sample_filename ;
    initialize_parse_characters_of_filename( ) ;
    for ( global_text_pointer = global_text_pointer_begin_for_item[ global_from_text_item_id ] ; global_text_pointer <= global_text_pointer_end_for_item[ global_from_text_item_id ] ; global_text_pointer ++ )
    {
        global_character_category = global_storage_all_text[ global_text_pointer ] ;
        parse_one_character_of_filename( ) ;
        if ( ( global_yes_or_no_numeric_delimiter_encountered == global_yes ) || ( global_text_pointer == global_text_pointer_end_for_item[ global_from_text_item_id ] ) )
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
//  Function test_parsing_folder_name_characters
//
//  The flag global_yes_or_no_use_slash_not_backslash
//  identifies whether slashes or backslashes are
//  allowed in folder names.

void test_parsing_folder_name_characters( )
{
    global_from_text_item_id = global_text_item_id_for_sample_folder_name ;
    initialize_parse_characters_of_folder_name( ) ;
    for ( global_text_pointer = global_text_pointer_begin_for_item[ global_from_text_item_id ] ; global_text_pointer <= global_text_pointer_end_for_item[ global_from_text_item_id ] ; global_text_pointer ++ )
    {
        global_single_character_as_integer = global_storage_all_text[ global_text_pointer ] ;
        parse_one_character_of_folder_name( ) ;
        if ( ( global_yes_or_no_numeric_delimiter_encountered == global_yes ) || ( global_text_pointer == global_text_pointer_end_for_item[ global_from_text_item_id ] ) )
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
}


// -----------------------------------------------
// -----------------------------------------------
//  Function initialize_character_usage_buffers

void initialize_character_usage_buffers( )
{
    global_character_usage_buffer_rotation_number_for_hyphen = 1 ;
    global_character_usage_buffer_rotation_number_for_underscore = 1 ;
    global_character_usage_buffer_rotation_number_for_letter_t =1 ;
    for ( global_character_usage_buffer_rotation_number = 1 ; global_character_usage_buffer_rotation_number <= global_maximum_character_usage_buffer_rotation_number ; global_character_usage_buffer_rotation_number ++ )
    {
        global_character_usage_position_for_hyphen_for_buffer_rotation[ global_character_usage_buffer_rotation_number ] ;
        global_character_usage_position_for_underscore_for_buffer_rotation[ global_character_usage_buffer_rotation_number ] ;
        global_character_usage_position_for_letter_t_for_buffer_rotation[ global_character_usage_buffer_rotation_number ] ;
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  Function check_for_word_specify_or_attribute

void check_for_word_specify_or_attribute( )
{
    global_length_of_matching_text = 0 ;
    if ( ( ( global_recent_character_position_for_character_number[ global_ascii_code_for_letter_s ] + 1 ) == global_recent_character_position_for_character_number[ global_ascii_code_for_letter_p ] ) && ( ( global_recent_character_position_for_character_number[ global_ascii_code_for_letter_s ] + 2 ) == global_recent_character_position_for_character_number[ global_ascii_code_for_letter_e ] ) && ( ( global_recent_character_position_for_character_number[ global_ascii_code_for_letter_s ] + 3 ) == global_recent_character_position_for_character_number[ global_ascii_code_for_letter_c ] ) && ( ( global_recent_character_position_for_character_number[ global_ascii_code_for_letter_s ] + 4 ) == global_recent_character_position_for_character_number[ global_ascii_code_for_letter_i ] ) && ( ( global_recent_character_position_for_character_number[ global_ascii_code_for_letter_s ] + 5 ) == global_recent_character_position_for_character_number[ global_ascii_code_for_letter_f ] ) && ( ( global_recent_character_position_for_character_number[ global_ascii_code_for_letter_s ] + 6 ) == global_recent_character_position_for_character_number[ global_ascii_code_for_letter_y ] ) )
    {
        global_length_of_matching_text = 7 ;
    } else if ( ( ( global_recent_character_position_for_character_number[ global_ascii_code_for_letter_a ] + 1 ) == global_recent_character_position_for_character_number[ global_ascii_code_for_letter_r ] ) && ( ( global_recent_character_position_for_character_number[ global_ascii_code_for_letter_a ] + 1 ) == global_recent_character_position_for_character_number[ global_ascii_code_for_letter_i ] ) && ( ( global_recent_character_position_for_character_number[ global_ascii_code_for_letter_a ] + 1 ) == global_recent_character_position_for_character_number[ global_ascii_code_for_letter_b ] ) && ( ( global_recent_character_position_for_character_number[ global_ascii_code_for_letter_a ] + 1 ) == global_recent_character_position_for_character_number[ global_ascii_code_for_letter_u ] ) && ( ( global_recent_character_position_for_character_number[ global_ascii_code_for_letter_a ] + 1 ) == global_recent_character_position_for_character_number[ global_ascii_code_for_letter_e ] ) )
    {
        if ( global_character_usage_position_for_letter_t_for_buffer_rotation[ global_character_usage_buffer_rotation_number_for_letter_t ] == global_recent_character_position_for_character_number[ global_ascii_code_for_letter_a ] + 1 )
        {
            global_character_usage_buffer_rotation_number_for_letter_t -- ;
            if ( global_character_usage_buffer_rotation_number_for_letter_t < 1 )
            {
                global_character_usage_buffer_rotation_number_for_letter_t = global_maximum_character_usage_buffer_rotation_number ;
            }
            if ( global_character_usage_position_for_letter_t_for_buffer_rotation[ global_character_usage_buffer_rotation_number_for_letter_t ] == global_recent_character_position_for_character_number[ global_ascii_code_for_letter_a ] + 2 )
            {
                global_character_usage_buffer_rotation_number_for_letter_t -- ;
                if ( global_character_usage_buffer_rotation_number_for_letter_t < 1 )
                {
                    global_character_usage_buffer_rotation_number_for_letter_t = global_maximum_character_usage_buffer_rotation_number ;
                }
                if ( global_character_usage_position_for_letter_t_for_buffer_rotation[ global_character_usage_buffer_rotation_number_for_letter_t ] == global_recent_character_position_for_character_number[ global_ascii_code_for_letter_a ] + 1 )
                {
                    global_length_of_matching_text = 9 ;
                }
            }
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
//  beginning and the end.  This approach is
//  faster when the two text sequences are
//  numbers because the end digits are more likely
//  to be different.

void yes_or_no_matching_text( )
{
    global_yes_or_no_same_unicode_characters = global_yes ;
    while ( 1 == 1 )
    {
        if ( global_storage_all_text[ global_search_character_pointer_begin ] != global_storage_all_text[ global_match_character_pointer_begin ] )
        {
            global_yes_or_no_same_unicode_characters = global_no ;
            return ;
        }
        global_search_character_pointer_begin ++ ;
        global_match_character_pointer_begin ++ ;
        if ( global_search_character_pointer_begin > global_search_character_pointer_end )
        {
            return ;
        }
        if ( global_storage_all_text[ global_search_character_pointer_end ] != global_storage_all_text[ global_match_character_pointer_end ] )
        {
            global_yes_or_no_same_unicode_characters = global_no ;
            return ;
        }
        global_search_character_pointer_end -- ;
        global_match_character_pointer_end -- ;
        if ( global_search_character_pointer_begin > global_search_character_pointer_end )
        {
            return ;
        }
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function check_word_match_in_parsed_hyphenated_phrase_name
//
//  Checks if the text item
//  global_finding_match_text_item_id is the same
//  word as a word in the
//  "global_parsed_hyphenated_phrase_name" area.
//  The result is indicated by the yes or no value
//  in global_yes_or_no_same_unicode_characters.

void check_word_match_in_parsed_hyphenated_phrase_name( )
{
    global_search_character_pointer_begin = global_text_pointer_begin_for_item[ global_finding_match_text_item_id ] ;
    global_search_character_pointer_end = global_text_pointer_end_for_item[ global_finding_match_text_item_id ] ;
    global_match_character_pointer_begin = global_parsed_hyphenated_phrase_name_pointer_begin_word[ global_word_count_parsed_hyphenated_phrase_name ] ;
    global_match_character_pointer_end = global_parsed_hyphenated_phrase_name_pointer_end_word[ global_word_count_parsed_hyphenated_phrase_name ] ;
    yes_or_no_matching_text( ) ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function check_yes_or_no_same_hyphenated_phrase
//
//  Checks if the text item
//  global_looking_at_hyphenated_phrase_name_in_text_item_id
//  contains the same hyphenated phrase name as
//  the hyphenated phrase name stored in the
//  "parsed_hyphenated_phrase_name" area.
//  The text item is assumed to contain the
//  category "contains_hyphenated_phrase_name",
//  but this assumption is not checked here.  The
//  comparison result is in
//  global_yes_or_no_same_hyphenated_phrase_name.

void check_yes_or_no_same_hyphenated_phrase( )
{


// -----------------------------------------------
//  Initialization.

    global_yes_or_no_same_hyphenated_phrase_name = global_yes ;


// -----------------------------------------------
//  If the number of words in the two hyphenated
//  phrase names are different, there is no match.

    global_word_count_hyphenated_phrase_name = global_text_pointer_end_for_item[ global_looking_at_hyphenated_phrase_name_in_text_item_id ] - global_text_pointer_begin_for_item[ global_looking_at_hyphenated_phrase_name_in_text_item_id ] + 1 ;
    if ( global_word_count_hyphenated_phrase_name == global_word_count_parsed_hyphenated_phrase_name )
    {
        global_yes_or_no_same_hyphenated_phrase_name = global_no ;
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
//  and end.  This approach would increase speed
//  in situations where the last word is an
//  integer.
//
//  Later, when phrase words are not duplicated,
//  just check if the text item ID numbers differ.

    for ( global_word_position = 1 ; global_word_position <= global_word_count_hyphenated_phrase_name ; global_word_position ++ )
    {
    	global_check_for_match_text_item_id = global_storage_all_text[ global_text_item_intended_next_word_in_hyphenated_phrase ] ;
        global_finding_match_text_item_id = global_storage_all_text[ global_text_item_looking_at_next_word_in_hyphenated_phrase ] ;
        check_word_match_in_parsed_hyphenated_phrase_name( ) ;
        if ( global_yes_or_no_same_unicode_characters == global_no )
        {
            global_yes_or_no_same_hyphenated_phrase_name = global_no ;
            return ;
        }
        global_text_item_intended_next_word_in_hyphenated_phrase ++ ;
        global_text_item_looking_at_next_word_in_hyphenated_phrase ++ ;
    }


// -----------------------------------------------
//  End of function check_yes_or_no_same_hyphenated_phrase.

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

void lookup_hyphenated_phrase_name( )
{
	global_text_item_id_of_matching_hyphenated_phrase_name = 0 ;
    for ( global_position_in_list_of_hyphenated_phrase_text_items = 1 ; global_position_in_list_of_hyphenated_phrase_text_items <= global_number_of_hyphenated_phrase_names_in_text_items ; global_position_in_list_of_hyphenated_phrase_text_items ++ )
    {
        global_looking_at_hyphenated_phrase_name_in_text_item_id = global_list_of_hyphenated_phrase_text_items[ global_position_in_list_of_hyphenated_phrase_text_items ] ;
        check_yes_or_no_same_hyphenated_phrase( ) ;
        if ( global_yes_or_no_same_hyphenated_phrase_name == global_yes )
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
//  name.
//
//  Later, avoid duplicating any words that are
//  already used in other hyphenated phrase names.

void add_new_hyphenated_phrase_name( )
{

// todo:

}


// -----------------------------------------------
// -----------------------------------------------
//  Function initialize_parse_characters_for_expand_text

void initialize_parse_characters_for_expand_text( )
{
    global_recent_character_position_for_character_number_beyond_ascii = 0 ;
    global_yes_or_no_prior_character_was_delimiter = global_yes ;
    global_yes_or_no_delimiter_encountered = global_yes ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function parse_one_character_for_expand_text

void parse_one_character_for_expand_text( )
{

    log_out << global_single_character_as_integer << std::endl ;

    if ( global_single_character_as_integer <= global_length_of_list_of_character_numbers )
    {
        switch ( global_single_character_as_integer )
        {
            case global_ascii_code_for_hyphen :
                global_character_usage_buffer_rotation_number_for_hyphen ++ ;
                if ( global_character_usage_buffer_rotation_number_for_hyphen > global_maximum_character_usage_buffer_rotation_number )
                {
                    global_character_usage_buffer_rotation_number_for_hyphen = 1 ;
                }
                global_character_usage_position_for_hyphen_for_buffer_rotation[ global_character_usage_buffer_rotation_number_for_hyphen ] = global_character_count_for_expand_text ;
                break ;
            case global_ascii_code_for_underscore :
                global_character_usage_buffer_rotation_number_for_underscore ++ ;
                if ( global_character_usage_buffer_rotation_number_for_underscore > global_maximum_character_usage_buffer_rotation_number )
                {
                    global_character_usage_buffer_rotation_number_for_underscore = 1 ;
                }
                global_character_usage_position_for_underscore_for_buffer_rotation[ global_character_usage_buffer_rotation_number_for_underscore ] = global_character_count_for_expand_text ;
                break ;
            case global_ascii_code_for_letter_t :
                global_character_usage_buffer_rotation_number_for_letter_t ++ ;
                if ( global_character_usage_buffer_rotation_number_for_letter_t > global_maximum_character_usage_buffer_rotation_number )
                {
                    global_character_usage_buffer_rotation_number_for_letter_t = 1 ;
                }
                global_character_usage_position_for_letter_t_for_buffer_rotation[ global_character_usage_buffer_rotation_number_for_letter_t ] = global_character_count_for_expand_text ;
                break ;
            default :
                global_recent_character_position_for_character_number[ global_single_character_as_integer ] = global_character_count_for_expand_text ;
                break ;
        }
    } else
    {
        global_recent_character_position_for_character_number_beyond_ascii = global_character_count_for_expand_text ;
    }
    global_yes_or_no_delimiter_encountered = global_no ;
    switch ( global_single_character_as_integer )
    {
        case global_ascii_code_for_space :
            global_yes_or_no_delimiter_encountered = global_yes ;
            break ;
        case global_ascii_code_for_tab :
            global_yes_or_no_delimiter_encountered = global_yes ;
            break ;
        case global_ascii_code_for_newline :
            global_yes_or_no_delimiter_encountered = global_yes ;
            break ;
        case global_ascii_code_for_formfeed :
            global_yes_or_no_delimiter_encountered = global_yes ;
            break ;
        case global_ascii_code_for_carriage_return :
            global_yes_or_no_delimiter_encountered = global_yes ;
            break ;
    }
    if ( global_yes_or_no_delimiter_encountered == global_yes )
    {
        if (global_yes_or_no_prior_character_was_delimiter == global_no )
        {
            log_out << "transition from characters to delimiter" << std::endl ;
        }
        global_yes_or_no_prior_character_was_delimiter = global_yes ;
    } else
    {
        if (global_yes_or_no_prior_character_was_delimiter == global_yes )
        {
            log_out << "transition from delimiter to characters" << std::endl ;
        }
        global_yes_or_no_prior_character_was_delimiter = global_no ;
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function test_parsing_characters_for_expand_text

void test_parsing_characters_for_expand_text( )
{
    global_yes_or_no_looking_for_word_attribute_or_specify = global_yes ;
    global_from_text_item_id = global_text_item_id_for_sample_text_to_expand ;
    initialize_parse_characters_for_expand_text( ) ;
    for ( global_text_pointer = global_text_pointer_begin_for_item[ global_from_text_item_id ] ; global_text_pointer <= global_text_pointer_end_for_item[ global_from_text_item_id ] ; global_text_pointer ++ )
    {
        global_single_character_as_integer = global_storage_all_text[ global_text_pointer ] ;
        parse_one_character_for_expand_text( ) ;

//  todo: ...

    }

    log_out << "test parsing done" << std::endl ;

}


// -----------------------------------------------
// -----------------------------------------------
//  Function convert_into_category_list_of_integers
//
//  use function that parses integers

void convert_into_category_list_of_integers( )
{

    global_text_item_id = 83 ;
    exit_not_yet_supported( ) ;
    global_text_category_for_item[ global_convertable_text_item_id ] = global_category_contains_list_of_integers ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function convert_into_category_pointers_to_decimal_numbers
//
//  use function that parses decimal numbers

void convert_into_category_pointers_to_decimal_numbers( )
{
    global_text_item_id = 80 ;
    exit_not_yet_supported( ) ;
    global_text_category_for_item[ global_convertable_text_item_id ] = global_category_contains_pointers_to_decimal_numbers ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function find_matching_text
//
//  The result is a global_text_item_id that
//  indicates the matching text.
//    global_text_item_id
//    global_pointer_to_within_text_item
//    global_finding_match_text_item_id
//
//  equivalent to standard "index" function

int find_matching_text( )
{
    int subtext_text_id_number = 0 ;
    global_text_item_id = 90 ;
    exit_not_yet_supported( ) ;
    return subtext_text_id_number ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function point_to_pattern_matching_text
//
//  input:
//  global_text_item_id
//  global_pointer_to_within_text_item
//  global_finding_match_text_item_id
//
//  uses symbol categorization with switch
//  statement, if non-symbol alphanumeric text is
//  part of the intended pattern, first find that
//  text using find_matching_text

void point_to_pattern_matching_text( )
{

// todo:

    global_text_item_id = 92 ;
    exit_not_yet_supported( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function point_to_pattern_matching_text_backwards
//
//  operates like point_to_pattern_matching_text
//  but does checking in reverse direction, use for
//  what can precede a word of characters
//
//  inputs:
//  global_text_item_id
//  global_pointer_to_within_text_item
//  global_finding_match_text_item_id

void point_to_pattern_matching_text_backwards( )
{
    global_text_item_id = 93 ;
    exit_not_yet_supported( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function find_subtext
//
//  input: global_text_item_id

//  todo:

void find_subtext( )
{
    global_text_item_id = 86 ;
    exit_not_yet_supported( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function insert_into_subtext

//  todo:

void insert_into_subtext( )
{
    global_text_item_id = 87 ;
    exit_not_yet_supported( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function text_replace

void text_replace( )
{
//    global_to_text_item_id ;
//    global_pointer_to_within_text_item
    global_text_item_id = 89 ;
    exit_not_yet_supported( ) ;
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

void get_text_by_character_offset_and_length( )
{
// character_offset
// characters_length
    global_matching_subtext_text_item_id = 0 ;
    global_text_item_id = 94 ;
    exit_not_yet_supported( ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function expand_text
//
//  Expands the text item indicated in
//  global_from_text_item_id.
//
//  use current runtime version for details

void expand_text( )
{
    global_text_item_id = 92 ;
    exit_not_yet_supported( ) ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Functions that will call the above functions:

//  dashrep-expand-phrases
//  handle-endless-loop-encountered
//  handle-time-limit-exceeded

//  parameterized-yes-or-no-empty
//  parameterized-remove-leading-trailing-spaces
//  parameterized-yes-or-no-phrase-name
//  parameterized-yes-or-no-phrase-definition-not-empty
//  parameterized-yes-or-no-positive-integer
//  parameterized-yes-or-no-integer
//  parameterized-yes-or-no-positive-real-number
//  parameterized-yes-or-no-real-number
//  parameterized-yes-or-no-phrase-contains-real-numbers
//  parameterized-normalize-calculated-value
//  parameterized-convert-numeric-text-into-numeric-value
//  parameterized-convert-numeric-value-into-numeric-text
//  parameterized-get-list-of-words
//  parameterized-yes-or-no-valid-url
//  parameterized-yes-or-no-valid-path
//  parameterized-yes-or-no-valid-path-prefix
//  parameterized-yes-or-no-file-name
//  parameterized-yes-or-no-folder-name
//  parameterized-yes-or-no-input-file-exists
//  parameterized-open-file-for-reading
//  parameterized-open-file-for-appending

//  point-to-words
//  point-to-words-in-operand-one
//  point-to-words-in-operand-two
//  point-to-words-in-operand-three
//  remove-extra-spaces
//  get-count-of-words
//  get-word-at-position
//  open-trace-output-file-if-not-open


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

    test_parsing_characters_for_expand_text( ) ;

//    read_text_line_from_file( ) ;

    global_single_character = 101 ;
    write_single_character_to_file( ) ;

    global_from_text_item_id = 1 ;
    global_to_text_item_id = 2 ;
//    append_linked_text( ) ;

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
