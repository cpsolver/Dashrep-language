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
//  Declare the text storage list.

char global_char_all_text[ 100000 ] ;


// -----------------------------------------------
//  Declare the text pointer lists.

const int global_length_of_lists_for_text = 20000 ;

int global_text_category_for_item[ 20005 ] ;
int global_text_pointer_allocation_end_for_item[ 20005 ] ;
int global_text_status_available_or_read_only_for_item[ 20005 ] ;
int global_text_pointer_begin_for_item[ 20005 ] ;
int global_text_pointer_end_for_item[ 20005 ] ;
int global_text_length_for_item[ 20005 ] ;


// -----------------------------------------------
//  Declare the values stored in:
//  global_text_status_available_or_read_only_for_item
//
//  In the future, possibly define a new Dashrep
//  phrase "internal-reuse-memory" that allows
//  text storage to be changeable.  In the
//  meantime only use "read only" status.

const int global_text_status_read_only = 1 ;
const int global_text_status_available = 2 ;
const int global_text_status_changeable = 3 ;


// -----------------------------------------------
//  Declare character categories, and a list that
//  converts a character's ASCII code into one of
//  these character categories.

const int global_length_of_list_of_character_numbers = 256 ;

int global_character_category_number_for_character_number[ 260 ] ;

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
const int global_character_category_formfeed = 15 ;
const int global_character_category_carriage_return = 16 ;


// -----------------------------------------------
//  Declare text "contains" categories.  Each
//  category is more restrictive.  For example,
//  if the text "contains no spaces or tabs" then
//  it does not contain newlines.  A possible
//  phrase name can contain hyphens but not any
//  other symbols.

const int global_text_contains_no_symbols = 1 ;
const int global_text_contains_possible_phrase_name = 2 ;
const int global_text_contains_no_spaces_or_tabs = 3 ;
const int global_text_contains_no_newlines = 4 ;
const int global_text_contains_possible_tabs = 5 ;
const int global_text_contains_anything = 6 ;


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
//  Specify an extra output file that contains a
//  log of actions for the purpose of monitoring
//  or debugging intermediate calculations.

std::ofstream log_out ;




// -----------------------------------------------
// -----------------------------------------------
//  convert_integer_to_text
//
//  This function is used instead of "std::to_string"
//  for compatibility with older C++ "string" libraries
//  that have a bug.  The bug is that the "to_string"
//  function is not recognized as being within the
//  "std" library, even though it is defined there.

std::string convert_integer_to_text( int supplied_integer )
{
    int unused_string_length ;
    char c_format_string[ 50 ] ;
    try
    {
        unused_string_length = sprintf( c_format_string , "%1d" , supplied_integer ) ;
        return ( std::string ) c_format_string ;
    }
    catch( ... )
    {
        return "NAN" ;
    }
}


// -----------------------------------------------
// -----------------------------------------------
//  convert_float_to_text
//
//  To read why this function is here, see the comment
//  above for function: convert_integer_to_text

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
//  convert_text_to_integer
//
//  To read why this function is here, see the comment
//  above for function: convert_integer_to_text

int convert_text_to_integer( char * supplied_text )
{
    int equivalent_integer ;
    try
    {
        equivalent_integer = atoi( supplied_text ) ;
    }
    catch( ... )
    {
        equivalent_integer = -999 ;
    }
    return equivalent_integer ;
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
    global_character_category_number_for_character_number[ 9 ] = global_character_category_tab ;
    global_character_category_number_for_character_number[ 10 ] = global_character_category_newline ;
    global_character_category_number_for_character_number[ 12 ] = global_character_category_formfeed ;
    global_character_category_number_for_character_number[ 13 ] = global_character_category_carriage_return ;
    global_character_category_number_for_character_number[ 34 ] = global_character_category_quotation_mark ;
    global_character_category_number_for_character_number[ 39 ] = global_character_category_apostrophe ;

    character_number = ' ' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_space ;
    character_number = '-' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_hyphen ;
    character_number = '_' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_underscore ;
    character_number = '/' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_slash ;
    character_number = '<' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_open_angle_bracket ;
    character_number = '>' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_close_angle_bracket ;
    character_number = '.' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_period ;
    character_number = '+' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_plus_sign ;
    character_number = '0' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_digit ;
    character_number = '1' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_digit ;
    character_number = '2' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_digit ;
    character_number = '3' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_digit ;
    character_number = '4' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_digit ;
    character_number = '5' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_digit ;
    character_number = '6' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_digit ;
    character_number = '7' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_digit ;
    character_number = '8' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_digit ;
    character_number = '9' ;
    global_character_category_number_for_character_number[ character_number ] = global_character_category_digit ;


// -----------------------------------------------
//  End of function do_main_initialization.

    return ;

}


// -----------------------------------------------
// -----------------------------------------------
//  Function text_item_clear
//
//  Changes text item to point to nothing, but
//  keeps bottom-level text items.

void text_item_clear( int text_item_id_number )
{
    if ( global_text_status_available_or_read_only_for_item[ text_item_id_number ] == global_text_status_changeable )
    {
        global_text_category_for_item[ text_item_id_number ] = global_character_category_empty ;
        global_text_pointer_end_for_item[ text_item_id_number ] = global_text_pointer_begin_for_item[ text_item_id_number ] ;
        global_text_length_for_item[ text_item_id_number ] = 0 ;
    } else
    {
        log_out << "Error: Attempt to clear text item that is not changeable" << std::endl ;
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
//  is a text_item_id_number that indicates the
//  matching text.

int get_text_by_character_offset_and_length( int text_item_id_number , int character_offset , int characters_length )
{
    int subtext_text_id_number = 0 ;
    log_out << "get_text_by_character_offset_and_length not yet written" << std::endl ;
    return subtext_text_id_number ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_next_text_item
//
//  Gets next text item within specified text
//  item.  Keeps track of nested pointers.

void get_next_text_item_within_text_item( int text_item_id_number , int pointer_to_within_text_item )
{
    if ( ( global_text_category_for_item[ text_item_id_number ] == global_character_category_empty ) || ( global_text_length_for_item[ text_item_id_number ] == 0 ) )
    {
        pointer_to_within_text_item ++ ;
        if ( pointer_to_within_text_item >= global_text_pointer_allocation_end_for_item[ text_item_id_number ] )
        {
            log_out << "get_next_text_item code not yet written" << std::endl ;
            return ;
        }
    }

    global_text_pointer_begin_for_item[ text_item_id_number ] = 0 ;

    global_text_pointer_end_for_item[ text_item_id_number ] = 0 ;

    global_text_category_for_item[ text_item_id_number ] = 0 ;

    global_text_length_for_item[ text_item_id_number ] = 0 ;

    log_out << "get_next_text_item code not yet written" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function text_append_no_space
//
//  Overwrite char storage if fits, else abandons
//  that storage and marks that storage area as
//  available, and creates new storage area that
//  holds text.
//
//  Do not do trash collection; if runs out of
//  space, programmer should split large task
//  into smaller tasks.

void text_append_no_space( int from_text_item_id_number , int to_text_item_id_number )
{
    if ( global_text_status_available_or_read_only_for_item[ to_text_item_id_number ] == global_text_status_changeable )
    {
        if ( ( global_text_category_for_item[ from_text_item_id_number ] == global_character_category_empty ) || ( global_text_length_for_item[ from_text_item_id_number ] == 0 ) )
        {
            return ;
        }

        global_text_pointer_allocation_end_for_item[ to_text_item_id_number ] = 0 ;

        global_text_pointer_begin_for_item[ to_text_item_id_number ] = 0 ;

        global_text_pointer_end_for_item[ to_text_item_id_number ] = 0 ;

        global_text_category_for_item[ to_text_item_id_number ] = 0 ;

        global_text_length_for_item[ to_text_item_id_number ] = 0 ;

    } else
    {
        log_out << "Error: Attempt to append to text item that is not changeable" << std::endl ;
    }

    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function text_copy

void text_copy( int from_text_item_id_number , int to_text_item_id_number )
{
    text_item_clear( to_text_item_id_number ) ;
    text_append_no_space( from_text_item_id_number , to_text_item_id_number ) ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function phrase_name_lookup

void phrase_name_lookup( int text_item_id_number )
{
    log_out << "function phrase_name_lookup (and creates text item if phrase is new)" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function find_matching_text
//
//  The result is a text_item_id_number that
//  indicates the matching text.

int find_matching_text( int text_item_id_number , int pointer_to_within_text_item , int text_to_find_item_id_number )
{
    int subtext_text_id_number = 0 ;
    log_out << "function find_matching_text (equivalent to standard index function)" << std::endl ;
    return subtext_text_id_number ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function yes_or_no_matching_text

void yes_or_no_matching_text( int from_text_item_id_number , int to_text_item_id_number )
{
    log_out << "function yes_or_no_matching_text" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function text_replace

void text_replace( int text_item_id_number , int pointer_to_within_text_item )
{
    log_out << "function text_replace (using pointers)" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function point_to_pattern_matching_text

void point_to_pattern_matching_text( int text_item_id_number , int pointer_to_within_text_item ,  int text_pattern_id_number )
{
    log_out << "function point_to_pattern_matching_text (uses state machine, and symbol categorization) (if non-symbol alphanumeric text is part of the intended pattern, first find that text using find_matching_text)" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function point_to_pattern_matching_text_backwards

void point_to_pattern_matching_text_backwards( int text_item_id_number , int pointer_to_within_text_item ,  int text_pattern_id_number )
{
    log_out << "function point_to_pattern_matching_text_backwards (operates like point_to_pattern_matching_text but does checking in reverse direction, use for what can precede a word of characters)" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//    do_testing
//
//  Do testing.

void do_testing( )
{

    std::string input_line ;
    std::string input_text_word ;


// -----------------------------------------------
//  Begin loop to handle one line from the input
//  file, which is "standard input" (which means
//  it's the input file specified on the command
//  line).

    for ( std::string input_line ; std::getline( std::cin , input_line ) ; )
    {
        std::size_t pointer_found = input_line.find_last_not_of( " \t\n\r" ) ;
        if ( pointer_found != std::string::npos )
        {
            input_line.erase( pointer_found + 1 ) ;
        } else
        {
            input_line.clear( ) ;
        }
        log_out << std::endl << "[input line: " << input_line << "]" ;
        char input_line_c_version[ 2000 ] = "" ;
        std::size_t line_length = std::min( 2000 , (int) input_line.length() ) ;
        std::size_t line_length_copied = input_line.copy( input_line_c_version , line_length , 0 ) ;
        input_line_c_version[ line_length_copied ] = '\0' ;


// -----------------------------------------------
//  Begin loop to get first/next space-delimited
//  word (of text) from the input line.  It must
//  be an integer.

        char * pointer_to_word ;
        // reminder: strtok modifies the string
        pointer_to_word = strtok( input_line_c_version , " ,." ) ;
        while ( pointer_to_word != NULL )
        {
            input_text_word = pointer_to_word ;


// -----------------------------------------------
//  Handle the word.

            log_out << "[next word]" << input_text_word << std::endl ;


// -----------------------------------------------
//  Repeat the loop for the next word (within the line).

            pointer_to_word = strtok( NULL, " ,." ) ;
        }


// -----------------------------------------------
//  Repeat the loop for the next line of data from
//  the input file.

    }


// -----------------------------------------------
//  End of function do_testing.

    return ;

}


// -----------------------------------------------
// -----------------------------------------------
//  Execution starts here.

int main() {

    int from_text_item_id_number ;
    int to_text_item_id_number ;


// -----------------------------------------------
//  Initialization.

    do_main_initialization( ) ;


// -----------------------------------------------
//  Test basic text handling functionality.

    log_out << std::endl ;
    log_out << "doing testing" << std::endl ;
    from_text_item_id_number = 1 ;
    to_text_item_id_number = 2 ;
    text_copy( from_text_item_id_number , to_text_item_id_number ) ;
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
