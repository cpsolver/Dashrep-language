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

const int global_length_of_lists_for_text = 20000 ;

int global_text_pointer_begin_for_item[ 20005 ] ;
int global_text_pointer_allocation_end_for_item[ 20005 ] ;
int global_text_pointer_end_for_item[ 20005 ] ;
int global_text_length_for_item[ 20005 ] ;
int global_text_category_for_item[ 20005 ] ;
int global_id_of_item_containing_definition_for_item[ 20005 ] ;


// -----------------------------------------------
//  Declare variables that keep track of the next
//  available text item ID number, and the
//  beginning location for storing each new text
//  item, and the length of the storage allocated.

int global_next_available_text_item_id_number ;
int global_next_available_begin_pointer_for_next_available_text_item_id_number ;
int global_length_requested_for_next_text_item_storage ;


// -----------------------------------------------
//  Declare global variables that hold text item
//  ID numbers.

int global_text_item_id_number ;
int global_from_text_item_id_number ;
int global_to_text_item_id_number ;
int global_search_text_item_id_number ;
int global_matching_text_item_id_number ;
int global_text_item_id_for_file_input ;
int global_text_item_id_for_file_output ;
int global_find_this_text_item_id_number ;
int global_find_within_text_item_id_number ;
int global_new_storage_text_item_id_number ;
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
int global_text_item_id_for_phrase_name_character_hyphen ;
int global_text_item_id_for_phrase_name_character_space ;
int global_text_item_id_for_phrase_name_character_underscore ;
int global_text_item_id_for_phrase_name_character_newline ;
int global_text_item_id_for_phrase_name_character_tab ;
int global_text_item_id_for_phrase_name_four_hyphens ;
int global_text_item_id_for_phrase_name_empty_text ;
int global_text_item_id_for_phrase_name_non_breaking_space ;


// -----------------------------------------------
//  Declare pointers that point to portions of the
//  text items.  These first-in-last-out stacks
//  are overwritten when a new action begins (if
//  the action needs these pointers).

int global_text_id_number_for_action_stack_position[ 2005 ] ;
int global_position_in_text_item_for_action_stack_position[ 2005 ] ;
int global_next_action_stack_position_for_action_stack_position[ 2005 ] ;


// -----------------------------------------------
//  Declare a "char" data type that is used to
//  access a double-quoted text word.

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
//  Hyphenated words must contain at least one
//  hyphen but cannot contain spaces, tabs,
//  newlines, or any other characters that are not
//  allowed in a Dashrep phrase name.  Leading and
//  trailing hyphens are not allowed.
//
//  A word cannot contain any spaces, hyphens,
//  tabs, newlines, formfeeds, or vertical tabs.
//
//  A list of words assumes the words are
//  separated by one space between each pair of
//  words, but those spaces are not explicitly
//  stored.
//
//  A list can contain just one item.
//
//  Storing integers as integers instead of as
//  text increases execution speed.  Similarly for
//  decimal numbers being stored as real numbers.

const int global_text_contains_nothing_empty = 1 ;
const int global_text_contains_list_of_text_item_ids = 2 ;
const int global_text_contains_unicode_anything = 3 ;
const int global_text_contains_hyphenated_word = 4 ;
const int global_text_contains_list_of_words = 5 ;
const int global_text_contains_list_of_integers = 6 ;
const int global_contains_list_of_pointers_to_decimal_numbers = 7 ;


// -----------------------------------------------
//  Declare variables that store "text contains"
//  category values.

int global_text_contains_category ;
int global_to_text_contains_category ;
int global_from_text_contains_category ;


// -----------------------------------------------
//  Declare character pointers and a character
//  storage variable.

int global_next_character_number ;
int global_line_character_position ;
int global_single_character ;
int global_character_pointer ;


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
const int global_character_category_open_angle_bracket = 8 ;
const int global_character_category_close_angle_bracket = 9 ;
const int global_character_category_quotation_mark = 10 ;  // double quotation mark
const int global_character_category_apostrophe = 11 ;  // also single quotation mark
const int global_character_category_period = 12 ;  // also used as decimal point
const int global_character_category_plus_sign = 13 ;
const int global_character_category_digit = 14 ;  // 0 through 9


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


// -----------------------------------------------
//  Declare a storage area for decimal numbers.
//  These are used when the text items contain
//  the category:
//  global_contains_list_of_pointers_to_decimal_numbers
//  In that case, those pointers point to
//  positions in this list.

float global_decimal_number_at_position[ 2000 ] ;


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


// -----------------------------------------------
//  Define a flag that tracks whether a text item
//  can have its contents changed.

int global_yes_or_no_text_item_changeable ;


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

int global_response_integer ;
int global_yes_or_no_requesting_space_appended ;
int global_one_number_to_append ;
int global_yes_or_no_can_extend_text_item ;


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
//  Function check_yes_or_no_can_extend_text_item
//

void check_yes_or_no_can_extend_text_item( )
{
    if ( global_text_pointer_end_for_item[ global_text_item_id_number ] < global_text_pointer_allocation_end_for_item[ global_text_item_id_number ]  )
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
    global_text_pointer_begin_for_item[ global_next_available_text_item_id_number ] = global_next_available_begin_pointer_for_next_available_text_item_id_number ;
    global_next_available_begin_pointer_for_next_available_text_item_id_number += global_length_requested_for_next_text_item_storage ;
    global_text_pointer_allocation_end_for_item[ global_next_available_text_item_id_number ] = global_next_available_begin_pointer_for_next_available_text_item_id_number - 1 ;
    global_text_pointer_end_for_item[ global_next_available_text_item_id_number ] =     global_text_pointer_begin_for_item[ global_next_available_text_item_id_number ] - 1 ;
    global_text_length_for_item[ global_next_available_text_item_id_number ] = 0 ;
    global_id_of_item_containing_definition_for_item[ global_next_available_text_item_id_number ] = 0 ;

//    log_out << "[ID " << global_next_available_text_item_id_number << " , begin " << global_text_pointer_begin_for_item[ global_next_available_text_item_id_number ] << " , end " << global_text_pointer_end_for_item[ global_next_available_text_item_id_number ] << " , requested " << global_length_requested_for_next_text_item_storage << " , allocation end " << global_text_pointer_allocation_end_for_item[ global_next_available_text_item_id_number ] << " , length " << global_text_length_for_item[ global_next_available_text_item_id_number ] << "]" ;

    global_new_storage_text_item_id_number = global_next_available_text_item_id_number ;
    global_next_available_text_item_id_number ++ ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function write_single_character_to_file
//
//  Write the text item pointed to by 
//  global_text_item_id_number to the output file.
//  Ignore any error responses.

void write_single_character_to_file( )
{
    global_response_integer = fputc( global_single_character , global_outfile_connection ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function store_one_text_number
//
//  Stores the integer in the variable
//  global_one_number_to_append, putting it into
//  the text item with ID number
//  global_text_item_id_number.
//  Bounds checking should be done before using
//  this function.  The bounds checking done here
//  should not be relied on.

void store_one_text_number( )
{
    int yes_or_no ;

    check_yes_or_no_can_extend_text_item( ) ;
    if ( global_yes_or_no_can_extend_text_item == global_no )
    {
        log_out << "[BUG:  Cannot expand size of text item ID number " << global_to_text_item_id_number << "]" ;
        exit( EXIT_FAILURE ) ;
    }
    global_text_pointer_end_for_item[ global_to_text_item_id_number ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_to_text_item_id_number ] ] = global_one_number_to_append ;
    global_text_length_for_item[ global_to_text_item_id_number ] ++ ;
    log_out << "[stored " << global_one_number_to_append << " at " << global_text_pointer_end_for_item[ global_to_text_item_id_number ] << "]" ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function store_this_word_in_text_item
//
//  Copies the text word in the char array named
//  global_this_word into a new text item.

void store_this_word_in_text_item( )
{

//  todo: write this code

    assign_storage_for_new_text_item( ) ;

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


// -----------------------------------------------
//  Initialize the counter that indicates the next
//  available text ID number.  (Zero is not used.)
//  It must be incremented after each text item ID
//  number is assigned.

    global_next_available_text_item_id_number = 1 ;


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

    global_next_available_begin_pointer_for_next_available_text_item_id_number = 1 ;


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
    global_text_item_id_for_single_space = global_new_storage_text_item_id_number ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_space ] ] = global_ascii_code_for_space ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_hyphen = global_new_storage_text_item_id_number ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_hyphen ] ] = global_ascii_code_for_hyphen ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_newline = global_new_storage_text_item_id_number ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_newline ] ] = global_ascii_code_for_newline ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_carriage_return = global_new_storage_text_item_id_number ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_carriage_return ] ] = global_ascii_code_for_carriage_return ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_quotation_mark = global_new_storage_text_item_id_number ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_quotation_mark ] ] = global_ascii_code_for_quotation_mark ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_apostrophe = global_new_storage_text_item_id_number ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_apostrophe ] ] = global_ascii_code_for_apostrophe ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_plus = global_new_storage_text_item_id_number ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_plus ] ] = global_ascii_code_for_plus ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_underscore = global_new_storage_text_item_id_number ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_underscore ] ] = global_ascii_code_for_underscore ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_period = global_new_storage_text_item_id_number ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_period ] ] = global_ascii_code_for_period ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_open_angle_bracket = global_new_storage_text_item_id_number ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_open_angle_bracket ] ] = global_ascii_code_for_open_angle_bracket ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_close_angle_bracket = global_new_storage_text_item_id_number ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_carriage_return ] ] = global_ascii_code_for_close_angle_bracket ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_slash = global_new_storage_text_item_id_number ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_slash ] ] = global_ascii_code_for_slash ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_tab = global_new_storage_text_item_id_number ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_tab ] ] = global_ascii_code_for_tab ;

    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_single_formfeed = global_new_storage_text_item_id_number ;
    global_storage_all_text[ global_text_pointer_begin_for_item[ global_text_item_id_for_single_formfeed ] ] = global_ascii_code_for_formfeed ;

    for ( text_id_number = global_text_item_id_for_single_space ; text_id_number <= global_text_item_id_for_single_formfeed ; text_id_number ++ )
    {
        global_text_pointer_end_for_item[ text_id_number ] = global_text_pointer_begin_for_item[ text_id_number ] ;
        global_text_length_for_item[ text_id_number ] = 1 ;
        global_text_category_for_item[ text_id_number ] = global_text_contains_unicode_anything ;
    }


// -----------------------------------------------
//  Initialize the text items used for file input
//  and output.  Shorten the length slightly in
//  case of an overrun.

    global_length_requested_for_next_text_item_storage = global_allocated_length_for_file_input_or_output ;

    global_text_item_id_for_file_input = global_next_available_text_item_id_number ;
    assign_storage_for_new_text_item( ) ;
    global_text_category_for_item[ global_text_item_id_for_file_input ] = global_character_category_other ;
    global_text_pointer_allocation_end_for_item[ global_text_item_id_for_file_input ] -= 5 ;

    global_text_item_id_for_file_output = global_next_available_text_item_id_number ;
    assign_storage_for_new_text_item( ) ;
    global_text_category_for_item[ global_text_item_id_for_file_output ] = global_character_category_other ;
    global_text_pointer_allocation_end_for_item[ global_text_item_id_for_file_output ] -= 5 ;


// -----------------------------------------------
//  Create the text items for words within the
//  phrase names that have definitions (rather
//  than only having meaning between the words
//  ambee and amenn.

    global_this_word[ ] = "character" ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_character = global_new_storage_text_item_id_number ;

    global_this_word[ ] = "hyphen" ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_hyphen = global_new_storage_text_item_id_number ;

    global_this_word[ ] = "space" ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_space = global_new_storage_text_item_id_number ;

    global_this_word[ ] = "newline" ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_newline = global_new_storage_text_item_id_number ;

    global_this_word[ ] = "underscore" ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_underscore = global_new_storage_text_item_id_number ;

    global_this_word[ ] = "tab" ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_tab = global_new_storage_text_item_id_number ;

    global_this_word[ ] = "four" ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_four = global_new_storage_text_item_id_number ;

    global_this_word[ ] = "hyphens" ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_hyphens = global_new_storage_text_item_id_number ;

    global_this_word[ ] = "non" ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_non = global_new_storage_text_item_id_number ;

    global_this_word[ ] = "breaking" ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_breaking = global_new_storage_text_item_id_number ;

    global_this_word[ ] = "empty" ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_empty = global_new_storage_text_item_id_number ;

    global_this_word[ ] = "text" ;
    store_this_word_in_text_item( ) ;
    global_text_item_id_for_word_text = global_new_storage_text_item_id_number ;


// -----------------------------------------------
//  Create the text items for Dashrep-defined
//  static phrase names.  And supply their
//  definitions.

    global_length_requested_for_next_text_item_storage = 2 ;

// character-hyphen
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_phrase_name_character_hyphen = global_new_storage_text_item_id_number ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_hyphen ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_hyphen ] ] = global_text_item_id_for_word_character ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_hyphen ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_hyphen ] ] = global_text_item_id_for_word_hyphen ;
    global_text_length_for_item[ global_text_item_id_for_phrase_name_character_hyphen ] = 2 ;
    global_id_of_item_containing_definition_for_item[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_hyphen ] ] = global_text_item_id_for_single_hyphen ;


// character-space
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_phrase_name_character_space = global_new_storage_text_item_id_number ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_space ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_space ] ] = global_text_item_id_for_word_character ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_space ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_space ] ] = global_text_item_id_for_word_space ;
    global_text_length_for_item[ global_text_item_id_for_phrase_name_character_space ] = 2 ;
    global_id_of_item_containing_definition_for_item[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_space ] ] = global_text_item_id_for_single_space ;

// character-newline
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_phrase_name_character_newline = global_new_storage_text_item_id_number ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_newline ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_newline ] ] = global_text_item_id_for_word_character ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_newline ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_newline ] ] = global_text_item_id_for_word_newline ;
    global_text_length_for_item[ global_text_item_id_for_phrase_name_character_newline ] = 2 ;
    global_id_of_item_containing_definition_for_item[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_newline ] ] = global_text_item_id_for_single_newline ;

// character-tab
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_phrase_name_character_tab = global_new_storage_text_item_id_number ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_tab ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_tab ] ] = global_text_item_id_for_word_character ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_tab ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_tab ] ] = global_text_item_id_for_word_tab ;
    global_text_length_for_item[ global_text_item_id_for_phrase_name_character_tab ] = 2 ;
    global_id_of_item_containing_definition_for_item[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_tab ] ] = global_text_item_id_for_single_tab ;

// character-underscore
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_phrase_name_character_underscore = global_new_storage_text_item_id_number ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_underscore ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_underscore ] ] = global_text_item_id_for_word_character ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_underscore ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_underscore ] ] = global_text_item_id_for_word_underscore ;
    global_text_length_for_item[ global_text_item_id_for_phrase_name_character_underscore ] = 2 ;
    global_id_of_item_containing_definition_for_item[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_character_underscore ] ] = global_text_item_id_for_single_underscore ;

// four-hyphens
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_phrase_name_four_hyphens = global_new_storage_text_item_id_number ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_four_hyphens ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_four_hyphens ] ] = global_text_item_id_for_word_four ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_four_hyphens ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_four_hyphens ] ] = global_text_item_id_for_word_hyphens ;
    global_text_length_for_item[ global_text_item_id_for_phrase_name_four_hyphens ] = 2 ;
    global_id_of_item_containing_definition_for_item[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_four_hyphens ] ] = global_text_item_id_for_four_hyphens ;

// empty-text
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_phrase_name_empty_text = global_new_storage_text_item_id_number ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_empty_text ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_empty_text ] ] = global_text_item_id_for_word_character ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_empty_text ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_empty_text ] ] = global_text_item_id_for_word_hyphen ;
    global_text_length_for_item[ global_text_item_id_for_phrase_name_empty_text ] = 2 ;
    global_id_of_item_containing_definition_for_item[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_empty_text ] ] = global_text_item_id_for_four_hyphens ;

    global_length_requested_for_next_text_item_storage = 3 ;

// non-breaking-space
    assign_storage_for_new_text_item( ) ;
    global_text_item_id_for_phrase_name_non_breaking_space = global_new_storage_text_item_id_number ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_non_breaking_space ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_non_breaking_space ] ] = global_text_item_id_for_word_non ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_non_breaking_space ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_non_breaking_space ] ] = global_text_item_id_for_word_breaking ;
    global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_non_breaking_space ] ++ ;
    global_storage_all_text[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_non_breaking_space ] ] = global_text_item_id_for_word_space ;
    global_text_length_for_item[ global_text_item_id_for_phrase_name_non_breaking_space ] = 3 ;
    global_id_of_item_containing_definition_for_item[ global_text_pointer_end_for_item[ global_text_item_id_for_phrase_name_non_breaking_space ] ] = global_text_item_id_for_non_breaking_space ;


// -----------------------------------------------
//  Initialize some counters that track other
//  kinds of storage usage.

    global_next_available_defined_phrase_number = 1 ;


// -----------------------------------------------
//  Initialize some variables.

    global_yes_or_no_requesting_space_appended = global_yes ;


// -----------------------------------------------
//  Now that initialization is done, do not allow
//  text items to have their contents changed.

    global_yes_or_no_text_item_changeable = global_no ;


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
    global_text_category_for_item[ global_text_item_id_for_file_input ] = global_text_contains_unicode_anything ;
    while ( 1 == 1 )
    {
        global_next_character_number = fgetc( global_infile_connection ) ;
        global_one_number_to_append = global_next_character_number ;
        global_to_text_item_id_number = global_text_item_id_for_file_input ;
        check_yes_or_no_can_extend_text_item( ) ;
        if ( global_yes_or_no_can_extend_text_item == global_yes )
        {
            store_one_text_number( ) ;
        } else
        {
            log_out << "[Error:  Out of space for storing text line from file]" ;
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
//  items.

void text_item_clear( )
{
    global_text_category_for_item[ global_to_text_item_id_number ] = global_text_contains_nothing_empty ;
    global_text_pointer_end_for_item[ global_to_text_item_id_number ] = global_text_pointer_begin_for_item[ global_to_text_item_id_number ] - 1 ;
    global_text_length_for_item[ global_to_text_item_id_number ] = 0 ;
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
//  ID number in global_from_text_item_id_number,
//  and the text item being extended is specified
//  by the text item ID number in
//  global_to_text_item_id_number.  The value in
//  global_yes_or_no_requesting_space_appended
//  indicates whether to insert a space between
//  non-empty text being extended and non-empty
//  text being appended.

void append_linked_text( )
{


// -----------------------------------------------
//  If the text being appended is empty, there is
//  nothing to do.

    if ( ( global_text_category_for_item[ global_from_text_item_id_number ] == global_text_contains_nothing_empty ) || ( global_text_length_for_item[ global_from_text_item_id_number ] == 0 ) )
    {
        log_out << "text to append is empty so nothing to append" << std::endl ;
        return ;
    }


// -----------------------------------------------
//  If the text being extended is not empty and
//  there is a request to insert a space between
//  the extended text and the appended text,
//  insert a space.

    if ( ( ( global_text_category_for_item[ global_to_text_item_id_number ] != global_text_contains_nothing_empty ) || ( global_text_length_for_item[ global_to_text_item_id_number ] != 0 ) ) && ( global_yes_or_no_requesting_space_appended == global_yes ) )
    {
        if ( global_text_category_for_item[ global_to_text_item_id_number ] == global_text_contains_list_of_text_item_ids )
        {
            check_yes_or_no_can_extend_text_item( ) ;
            if ( global_yes_or_no_can_extend_text_item == global_yes )
            {
                global_one_number_to_append = global_text_item_id_for_single_space ;
                store_one_text_number( ) ;
            } else
            {
                log_out << "create new text item to make room for space character" << std::endl ;
            }
        } else
        {
            global_length_requested_for_next_text_item_storage = global_default_length_for_text_item ;
            assign_storage_for_new_text_item( ) ;
            global_text_category_for_item[ global_new_storage_text_item_id_number ] = global_text_contains_list_of_text_item_ids ;
//  insert the to and space IDs, but not the from ID
//        global_storage_all_text
            global_to_text_item_id_number = global_new_storage_text_item_id_number ;
        }
    }


// -----------------------------------------------
//  Get the categories of the "from" and "to" text
//  items.

    global_from_text_contains_category = global_text_category_for_item[ global_from_text_item_id_number ] ;
    global_to_text_contains_category = global_text_category_for_item[ global_to_text_item_id_number ] ;


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
        global_one_number_to_append = global_to_text_item_id_number ;
        global_to_text_item_id_number = global_new_storage_text_item_id_number ;
        store_one_text_number( ) ;
        global_one_number_to_append = global_text_item_id_for_single_space ;
        store_one_text_number( ) ;
        global_one_number_to_append = global_from_text_contains_category ;
        store_one_text_number( ) ;
        global_text_category_for_item[ global_to_text_item_id_number ] = global_text_contains_list_of_text_item_ids ;
        return ;
    }


// -----------------------------------------------
//  Begin a branch that handles cases where the
//  "from" and "to" categories are the same.  Each
//  branch handles a different category type.

    switch ( global_to_text_contains_category )
    {


// -----------------------------------------------
//  If the categories of the "from" and "to" text
//  items are both of category "nothing_empty",
//  there is nothing to do, so return.

        case global_text_contains_nothing_empty :
            return ;
            break ;


// -----------------------------------------------
//  If the categories of the "from" and "to" text
//  items are both of category "contains
//  hyphenated word", ...

        case global_text_contains_hyphenated_word :

//            global_storage_all_text[ global_text_pointer_begin_for_item[ global_to_text_item_id_number ] ] = global_from_text_item_id_number ;
//            global_text_pointer_end_for_item[ global_to_text_item_id_number ] = global_text_pointer_begin_for_item[ global_to_text_item_id_number ] ;
//            global_text_length_for_item[ global_to_text_item_id_number ] = 1 ;
//            global_id_of_item_containing_definition_for_item[ global_to_text_item_id_number ] = 0 ;


            switch ( global_from_text_contains_category )
            {

                case global_text_contains_hyphenated_word :
                    global_text_pointer_begin_for_item[ global_from_text_item_id_number ] = 0 ;
                    global_text_pointer_end_for_item[ global_to_text_item_id_number ] = 0 ;
                    global_text_length_for_item[ global_to_text_item_id_number ] = 0 ;
                    global_id_of_item_containing_definition_for_item[ global_to_text_item_id_number ] = 0 ;
                    break ;

                default :
                    //
                    break ;

            }

        break ;


// -----------------------------------------------
//  If the categories of the "from" and "to" text
//  items are both of category "contains
//  ...

        case global_text_contains_list_of_words :
            //
            break ;


// -----------------------------------------------
//  If the categories of the "from" and "to" text
//  items are both of category "contains
//  ...

        case global_text_contains_unicode_anything :
            //
            break ;


// -----------------------------------------------
//  If the categories of the "from" and "to" text
//  items are both of category "contains
//  ...

        case global_text_contains_list_of_integers :
            //
            break ;


// -----------------------------------------------
//  If the categories of the "from" and "to" text
//  items are both of category "contains
//  ...

        case global_contains_list_of_pointers_to_decimal_numbers :
            //
            break ;


// -----------------------------------------------
//  If the categories of the "from" and "to" text
//  items are both of category "contains
//  ...

        default :
            //
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
//  global_from_text_item_id_number, and the text
//  item being extended is specified by the text
//  item ID number in
//  global_to_text_item_id_number.

void append_copied_text( )
{
    text_item_clear( ) ;
//  copy text, then use function append_linked_text to append it

}


// -----------------------------------------------
// -----------------------------------------------
//  Function append_space_if_not_empty
//
//  Appends a space to
//  global_to_text_item_id_number
//  if it is not empty.

void append_space_if_not_empty( )
{
    if ( ( global_text_category_for_item[ global_to_text_item_id_number ] != global_character_category_empty ) && ( global_text_length_for_item[ global_to_text_item_id_number ] > 0 ) )
    {
        log_out << "append space" << std::endl ;
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
//  Function trim_delimiters
//
//  For the text item specified in
//  global_text_item_id_number, removes leading
//  and trailing word delimiters, and from within
//  the text replaces multiple word delimiters
//  with a single space.  Word delimiters include
//  spaces, tabs, newlines, formfeeds, carriage
//  returns, and vertical tabs.
//  The trimmed version gets a new text item ID
//  number and that number is put into the
//  variable global_text_item_id_number.

void trim_delimiters( )
{
    log_out << "function trim_delimiters" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function widen_subtext_by_leading_trailing_spaces

void widen_subtext_by_leading_trailing_spaces( )
{
//    global_text_item_id_number
    log_out << "function widen_subtext_by_leading_trailing_spaces" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function find_subtext

void find_subtext( )
{
//    global_text_item_id_number
    log_out << "function find_subtext" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function insert_into_subtext

void insert_into_subtext( )
{
//    global_text_item_id_number
    log_out << "function find_subtext" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function text_replace

void text_replace( )
{
//    global_to_text_item_id_number ;
//    global_pointer_to_within_text_item
    log_out << "function text_replace (using pointers)" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function phrase_name_lookup
//
//  Finds the text item ID number of the phrase
//  name that is contained in the text item ID
//  number at global_from_text_item_id_number.
//  If a match is not found, this function puts a
//  zero into the variable
//  global_to_text_item_id_number.

void phrase_name_lookup( )
{
    log_out << "function phrase_name_lookup" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function find_matching_text
//
//  The result is a global_text_item_id_number that
//  indicates the matching text.
//    global_text_item_id_number
//    global_pointer_to_within_text_item
//    global_search_text_item_id_number

int find_matching_text( )
{
    int subtext_text_id_number = 0 ;
    log_out << "function find_matching_text (equivalent to standard index function)" << std::endl ;
    return subtext_text_id_number ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function yes_or_no_matching_text

void yes_or_no_matching_text( )
{
    log_out << "function yes_or_no_matching_text" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function point_to_pattern_matching_text

void point_to_pattern_matching_text( )
{
// global_text_item_id_number
// global_pointer_to_within_text_item
// global_search_text_item_id_number
    log_out << "function point_to_pattern_matching_text (uses state machine, and symbol categorization) (if non-symbol alphanumeric text is part of the intended pattern, first find that text using find_matching_text)" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function point_to_pattern_matching_text_backwards

void point_to_pattern_matching_text_backwards( )
{
// global_text_item_id_number
// global_pointer_to_within_text_item
// global_search_text_item_id_number
    log_out << "function point_to_pattern_matching_text_backwards (operates like point_to_pattern_matching_text but does checking in reverse direction, use for what can precede a word of characters)" << std::endl ;
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
//  is a global_text_item_id_number that indicates the
//  matching text.

int get_text_by_character_offset_and_length( )
{
// global_text_item_id_number
// character_offset
// characters_length
    int subtext_text_id_number = 0 ;
    log_out << "get_text_by_character_offset_and_length not yet written" << std::endl ;
    return subtext_text_id_number ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Execution starts here.

int main() {

    int character_number ;


// -----------------------------------------------
//  Initialization.

    do_main_initialization( ) ;


// -----------------------------------------------
//  Test basic text handling functionality.

    log_out << std::endl ;
    log_out << "doing testing" << std::endl ;


    global_infile_connection = fopen( "input_dashrep_example_menagerie_copy.txt" , "r" ) ;
    global_outfile_connection = fopen( "temp_output_from_c_language_runtime_test.txt" , "w" ) ;

    read_text_line_from_file( ) ;

    global_single_character = 101 ;
    write_single_character_to_file( ) ;

    global_from_text_item_id_number = 1 ;
    global_to_text_item_id_number = 2 ;

    for ( character_number = 1 ; character_number <= global_next_available_begin_pointer_for_next_available_text_item_id_number ; character_number ++ )
    {
        log_out << "[" << global_storage_all_text[ character_number ] << "]" ;
    }
    log_out << std::endl ;


    log_out << "done testing" << std::endl ;
    std::cout << "program done" << std::endl ;


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
