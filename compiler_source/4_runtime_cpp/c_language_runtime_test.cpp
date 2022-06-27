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
//  items or text characters.

char global_char_all_text[ 100000 ] ;


// -----------------------------------------------
//  Declare variables that keep track of the next
//  available text item ID number, and the
//  beginning location for storing each new text
//  item, and the length of the storage allocated.

int global_next_available_text_item_id_number ;
int global_next_available_begin_pointer_for_next_available_text_item_id_number ;
int global_length_of_next_text_item_storage ;


// -----------------------------------------------
//  Declare various global variables.
//  Function-specific variables are avoided for
//  functions that are used frequently, so that
//  execution is faster.

int global_text_item_id_number ;
int global_next_character_number ;
int global_line_character_position ;


// -----------------------------------------------
//  Declare the text pointer lists.

const int global_length_of_lists_for_text = 20000 ;

int global_text_category_for_item[ 20005 ] ;
int global_text_pointer_allocation_end_for_item[ 20005 ] ;
int global_text_pointer_begin_for_item[ 20005 ] ;
int global_text_pointer_end_for_item[ 20005 ] ;
int global_text_length_for_item[ 20005 ] ;


// -----------------------------------------------
//  Declare the item ID numbers used for file
//  input and output, and declare the size of
//  these two storage areas.

int global_text_item_id_for_file_input ;
int global_text_item_id_for_file_output ;
const int global_allocated_length_for_file_input_or_output = 2000 ;


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
//  Temporarily specify starting text items.
//  Later, generate this code using the list in
//  file: text-list-of-dashrep-key-words.txt

// char * global_starting_key_words = "10 absolute absolutes add administrator after all alphabetic ambee amenn amennfen amennfenambee and any append as at attributes backslash base based begin begins both break breaking but by calculate caps cgi character characters clear column columns combee combination comenn comments compare components contain convert copy cosine count counter counts create current dashrep day decode decrement definitions delayed delete delimited delimiter delta dimensional directory distances divide e each either else empty encode end endless entities entry epoch equal even every executable exists exit expand extra fen fenambee file files find first folder folders for found four from gather gathered generate get greater handler here hour html hyphen hyphens id if ignored in increment indicator info information initial input integer integers into items language latitude left length less limit line lines linewise list listed lists logarithm loop lowercase map matching maximum meridian minimum minus minute missing modification month move multiple multiply name named new newline no non nonzero nospace nospay not number numeric odd of offset on one only operating opposite or order ordered output overwrite pad paired pairwise parameter path pattern permission phrase phrases pi pointers position positions prefix prepend private public put read reading rearrange remove rename repeatedly replace resource reversed root rows same second seconds set show sine size skip slash sort space spaces split square standard sub system tab tag tagged tags text that tile time to trace trim two underscore unicode unique uppercase url usage use using values vector vectors version week when where with without word words write writing xml y year yes zero zoom" ;


// -----------------------------------------------
// -----------------------------------------------
//  Function assign_storage_for_new_text_item
//
//  Initialize the pointers that will keep track
//  of a new text item.

void assign_storage_for_new_text_item( )
{
    global_text_pointer_begin_for_item[ global_next_available_text_item_id_number ] = global_next_available_begin_pointer_for_next_available_text_item_id_number ;
    global_next_available_begin_pointer_for_next_available_text_item_id_number += global_length_of_next_text_item_storage ;
    global_text_pointer_end_for_item[ global_next_available_text_item_id_number ] = global_next_available_begin_pointer_for_next_available_text_item_id_number - 1 ;
    global_text_length_for_item[ global_next_available_text_item_id_number ] = 0 ;
    global_next_available_text_item_id_number ++ ;
    return ;
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
//  Put zero into the first global_char_all_text
//  list so that storage for characters and text
//  pointers start at one, not zero.

    global_char_all_text[ 0 ] = 0 ;


// -----------------------------------------------
//  Initialize the pointer that keeps track of the
//  beginning of the next available character
//  positions in the list: global_char_all_text

    global_next_available_begin_pointer_for_next_available_text_item_id_number = 1 ;


// -----------------------------------------------
//  Initialize the text items used for file input
//  and output.  Shorten the length slightly in
//  case of an overrun.

    global_length_of_next_text_item_storage = global_allocated_length_for_file_input_or_output ;

    global_text_item_id_for_file_input = global_next_available_text_item_id_number ;
    assign_storage_for_new_text_item( ) ;
    global_text_category_for_item[ global_text_item_id_for_file_input ] = global_character_category_other ;
    global_text_length_for_item[ global_text_item_id_for_file_input ] -= 5 ;

    global_text_item_id_for_file_output = global_next_available_text_item_id_number ;
    assign_storage_for_new_text_item( ) ;
    global_text_category_for_item[ global_text_item_id_for_file_output ] = global_character_category_other ;
    global_text_length_for_item[ global_text_item_id_for_file_input ] -= 5 ;


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
//  Function store_next_character
//
//  Stores the character number that's in
//  global_next_character_number into item id
//  number global_text_item_id_number.
//  Global variables are used for faster
//  execution.

void store_next_character( )
{
    global_character_category = global_character_category_number_for_character_number[ global_next_character_number ] ;
    if ( global_character_category == global_character_category_other )
    {
        log_out << "[Storing character " << global_next_character_number << " at " << global_text_pointer_end_for_item[ global_text_item_id_number ] << "]" ;
    } else if ( global_character_category == global_character_category_space )
    {
        log_out << "[Storing space]" ;
    } else if ( global_character_category == global_character_category_hyphen )
    {
        log_out << "[Storing hyphen]" ;
    } else if ( global_character_category == global_character_category_newline )
    {
        log_out << "[Storing newline]" ;
    } else if ( global_character_category == global_character_category_tab )
    {
        log_out << "[Storing tab]" ;
    } else if ( global_character_category == global_character_category_empty )
    {
        log_out << "[Error, request to storing nothing]" ;
    } else
    {
        log_out << "[Storing character " << global_next_character_number << "]" ;
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function read_text_line_from_file
//
//  Reads one line of text from a file.  Global
//  variables are used for faster execution.

void read_text_line_from_file( )
{
    global_text_item_id_number = global_text_item_id_for_file_input ;
    global_next_character_number = -1 ;
    global_text_pointer_end_for_item[ global_text_item_id_number ] = global_text_pointer_begin_for_item[ global_text_item_id_number ] - 1 ;

    while ( ( global_next_character_number != 0 ) && ( global_yes == global_no ) )

    {
        global_next_character_number = fgetc( global_infile_connection ) ;
        if ( global_next_character_number == EOF )
        {
            global_next_character_number = 0 ;
            return ;
        }
        store_next_character( ) ;
    }
    return ;
}


// -----------------------------------------------
// -----------------------------------------------
//  Function write_text_item_to_file
//

void write_text_item_to_file( int text_item_id_number )
{

    log_out << "Error: Attempt to clear text item that is not changeable" << std::endl ;

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
    if ( global_yes_or_no_text_item_changeable == global_yes )
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
    if ( global_yes_or_no_text_item_changeable == global_yes )
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


    global_infile_connection = fopen( "input_dashrep_example_menagerie_copy.txt" , "r" ) ;
    global_infile_connection = fopen( "temp_output_from_c_language_runtime_test.txt" , "w" ) ;

    read_text_line_from_file( ) ;

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
