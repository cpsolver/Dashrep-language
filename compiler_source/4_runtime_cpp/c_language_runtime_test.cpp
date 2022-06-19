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

int global_text_pointer_allocation_end_for_item[ 20005 ] ;
int global_text_status_available_or_read_only_for_item[ 20005 ] ;
int global_text_pointer_begin_for_item[ 20005 ] ;
int global_text_pointer_end_for_item[ 20005 ] ;
int global_text_length_for_item[ 20005 ] ;
int global_text_category_for_item[ 20005 ] ;


// -----------------------------------------------
//  Declare the values stored in:
//  global_text_category_for_item
//
//  Also declare the list that converts the
//  character's ASCII code into one of these
//  categories.

const int global_length_of_list_of_character_numbers = 256 ;

int global_category_number_for_character_number[ 260 ] ;

const int global_category_other = 1 ;
const int global_category_hyphen = 2 ;  // also used as minus sign
const int global_category_space = 3 ;
const int global_category_underscore = 4 ;
const int global_category_newline = 5 ;
const int global_category_tab = 6 ;
const int global_category_slash = 7 ;
const int global_category_open_angle_bracket = 8 ;
const int global_category_close_angle_bracket = 9 ;
const int global_category_quotation_mark = 10 ;  // double quotation mark
const int global_category_apostrophe = 11 ;  // also single quotation mark
const int global_category_period = 12 ;  // also used as decimal point
const int global_category_plus_sign = 13 ;
const int global_category_digit = 14 ;  // 0 through 9
const int global_category_formfeed = 15 ;
const int global_category_carriage_return = 16 ;


// -----------------------------------------------
//  Declare the matrix for the state machine that
//  is used to parse text.
//
//  States can include triggers for starting and
//  ending a match for a character sequence.

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


// -----------------------------------------------
//  Open the output file that logs details.

    log_out.open ( "output_log_c_language_runtime_test.txt" , std::ios::out ) ;


// -----------------------------------------------
//  Initialize the list that converts character
//  numbers into categories.

    for ( pointer = 0 ; pointer <= global_length_of_list_of_character_numbers ; pointer ++ )
    {
        global_category_number_for_character_number[ pointer ] = 0 ;
    }
    global_category_number_for_character_number[ 123 ] = global_category_other ;
    global_category_number_for_character_number[ 123 ] = global_category_hyphen ;
    global_category_number_for_character_number[ 123 ] = global_category_space ;
    global_category_number_for_character_number[ 123 ] = global_category_underscore ;
    global_category_number_for_character_number[ 123 ] = global_category_newline ;
    global_category_number_for_character_number[ 123 ] = global_category_tab ;
    global_category_number_for_character_number[ 123 ] = global_category_slash ;
    global_category_number_for_character_number[ 123 ] = global_category_open_angle_bracket ;
    global_category_number_for_character_number[ 123 ] = global_category_close_angle_bracket ;
    global_category_number_for_character_number[ 123 ] = global_category_quotation_mark ;
    global_category_number_for_character_number[ 123 ] = global_category_apostrophe ;
    global_category_number_for_character_number[ 123 ] = global_category_period ;
    global_category_number_for_character_number[ 123 ] = global_category_plus_sign ;
    global_category_number_for_character_number[ 123 ] = global_category_digit ;
    global_category_number_for_character_number[ 123 ] = global_category_formfeed ;
    global_category_number_for_character_number[ 123 ] = global_category_carriage_return ;


// -----------------------------------------------
//  End of function do_main_initialization.

    return ;

}


// -----------------------------------------------
// -----------------------------------------------
//  Function text_append

void text_append( int from_text_item_id_number , int to_text_item_id_number )
{
    log_out << "function text_append (overwrites char storage if fits, else abandons that storage and marks that storage area as available, and creates new storage area that holds text, but do not do trash collection; if runs out of space, programmer should split large task into smaller tasks)" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function text_item_clear

void text_item_clear( int text_item_id_number )
{
    log_out << "function text_item_clear (changes text item to point to nothing, but keeps bottom-level text items)" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function text_copy

void text_copy( int from_text_item_id_number , int to_text_item_id_number )
{
    log_out << "function text_copy (use text_append after clearing prior contents)" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function store_text_item

void store_text_item( int from_text_item_id_number , int to_text_item_id_number )
{
    log_out << "function store_text_item" << std::endl ;
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
//  Function get_next_text_item

void get_next_text_item_within_text_item( int text_item_id_number , int pointer_to_within_text_item )
{
    log_out << "function get_next_text_item_within_text_item (and keep track of nested pointers)" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function get_text_by_character_offset_and_length

void get_text_by_character_offset_and_length( int text_item_id_number , int character_offset , int characters_length )
{
    log_out << "function get_text_by_character_offset_and_length (equivalent to standard substr function)" << std::endl ;
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function find_matching_text

void find_matching_text( int text_item_id_number , int pointer_to_within_text_item , int text_to_find_item_id_number )
{
    log_out << "function find_matching_text (equivalent to standard index function)" << std::endl ;
    return ;
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

    
    find_matching_text( ) ;


    log_out << std::endl << "[doing testing]" << std::endl ;


// -----------------------------------------------
//  End of function do_testing.

    return ;

}


// -----------------------------------------------
// -----------------------------------------------
//  Execution starts here.

int main() {


// -----------------------------------------------
//  Initialization.

    do_main_initialization( ) ;


// -----------------------------------------------
//  Test the functions in this file.

    get_next_text_item( ) ;
    do_testing( ) ;
    get_text_by_offset_and_length( ) ;
    find_matching_text( ) ;
    yes_or_no_matching_text( ) ;
    text_append( ) ;
    text_copy( ) ;
    text_replace( ) ;
    point_to_pattern_matching_text( ) ;
    point_to_pattern_matching_text_backwards( ) ;

    std::cout << "done testing" << std::endl ;


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
