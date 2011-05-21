package Language::Dashrep;

use 5.010;
use warnings;
use strict;

require Exporter;
use Carp;


=head1 NAME

Language::Dashrep - Dashrep is a versatile descriptive programming language based on hyphenated phrases being successively expanded into replacement text.  It is a much more flexible alternative to using a template language.  See www.Dashrep.org for details.

=head1 VERSION

Version 1.10

=cut

our $VERSION = '1.10';

=head1 SYNOPSIS

Implements the Dashrep (TM) language, which is a versatile descriptive programming language that recursively expands English-like hyphenated phrases, such as B<rectangle-outline-attention-begin>, into any kind of text or code, such as HTML, XML, JavaScript, C (subset), boilerplate-based text, etc.  The resulting expanded text can be an HTML web page, an XML file, a JavaScript program, a boilerplate-based document, etc.  See www.Dashrep.org for details.

The following sample code generates an entire web page, including a list-based table.  The referenced Dashrep files are available at www.Dashrep.org.

    use Language::Dashrep;

    #-------------------------------------------
    #  Read and import the file-based replacements.

    foreach $file_name ( "dashrep-replacements-sample.txt" , "dashrep-replacements-html.txt" , "dashrep-replacements-language-en.txt" , "dashrep-replacements-case-info.txt" )
    {
        if ( open ( INFILE , "<" . $file_name ) )
        {
            while( $input_line = <INFILE> )
            {
                chomp( $input_line ) ;
                $content_read_from_file .= $input_line . "\n" ;
            }
            close ( INFILE ) ;
            &dashrep_import_replacements( $content_read_from_file ) ;
        } else
        {
            die "Could not open file named $file_name for reading." ;
        }
    }

    #-------------------------------------------
    #  Define situation-specific replacements.

    &dashrep_define( "case-info-idlistparticipants" , "3,12,7,13,4" ) ;

    #-------------------------------------------
    #  Specify which page contents to generate,
    #  and expand the parameters for that page.

    &dashrep_define( "web-page-content" , &dashrep_expand_parameters( "page-participants-list" ) ) ;

    #-------------------------------------------
    #  Expand a single hyphenated phrase into an
    #  entire web page, including a table that
    #  lists the participants indicated above.

    $html_code = &dashrep_expand_phrases( "entire-standard-web-page" ) ;
    print $html_code ;

Although Dashrep code is not directly executable, it can generate executable code.  Although it does not directly define loops, it generates lists in which any delimited (using commas and/or spaces) list of text strings (including integers) specifies the unique values for the list items.  Although the Dashrep language does not directly implement a branching structure, the translated code can be completely changed at any level (including within lists) based on parameterized hyphenated phrases such as B<[-template-for-move-proposal-link-for-action-[-output-requested-action-]-]>.

The Dashrep language has been used to convert text files into MML- and XML-format files (for two books, I<The Creative Problem Solver's Toolbox> and I<Ending The Hidden Unfairness In U.S. Elections>), specify dynamically generated HTML pages (at www.VoteFair.org and www.NegotiationTool.com), generate JavaScript code (that Adobe Illustrator executed to generate vector graphics for use in the book I<Ending The Hidden Unfairness In U.S. Elections>), generate invoices and packing slips, expand boilerplate-like text, and more.

The design goals for the Dashrep language were:

=over

=item * Provide a convenient way to move descriptive code out of executable code.

=item * Keep it simple, and keep it flexible.

=item * Make the language speakable.  (This characteristic is useful for various purposes, including circumventing keyboard-induced repetitive-stress injury, and using microphone-equipped mobile devices.)

=back


=head1 EXPORT

The following subroutines are exported.

=head2 dashrep_define

=head2 dashrep_import_replacements

=head2 dashrep_get_replacement

=head2 dashrep_get_list_of_phrases

=head2 dashrep_delete

=head2 dashrep_expand_parameters

=head2 dashrep_expand_phrases

=head2 dashrep_expand_phrases_except_special

=head2 dashrep_expand_special_phrases

=head2 dashrep_set_runaway_limit

=cut


our @ISA = qw(Exporter);

our @EXPORT = qw(
    dashrep_define
    dashrep_import_replacements
    dashrep_get_replacement
    dashrep_get_list_of_phrases
    dashrep_delete
    dashrep_expand_parameters
    dashrep_expand_phrases
    dashrep_expand_phrases_except_special
    dashrep_expand_special_phrases
    dashrep_set_runaway_limit
);


#-------------------------------------------
#  This Perl code is intentionally written
#  in a subset of Perl and uses a C-like
#  syntax so that it can be ported more
#  easily to other languages, especially
#  the C language for faster execution.
#
#  If you offer improvements to this code,
#  please follow this convention so that
#  the code continues to be easily converted
#  into other languages.
#-------------------------------------------


#-----------------------------------------------
#  Declare package variables.

my ( $global_true ) ;
my ( $global_false ) ;
my ( $global_endless_loop_counter ) ;
my ( $global_endless_loop_counter_limit ) ;
my ( @global_list_of_lists_to_generate ) ;
my ( %dashrep_replacement ) ;
my ( %replacement_count_for_item_name ) ;


#-----------------------------------------------
#  Define package constants.

BEGIN {
    $global_true = 1 ;
    $global_false = 0 ;
    $global_endless_loop_counter = 0 ;
    $global_endless_loop_counter_limit = 70000 ;
    @global_list_of_lists_to_generate = ( ) ;
    %dashrep_replacement = ( ) ;
    %replacement_count_for_item_name = ( ) ;
}


=head1 FUNCTIONS


=head2 dashrep_define

Associates a replacement text string with
the specified hyphenated phrase.

First parameter is the hyphenated phrase.
Second parameter is its replacement text
string.

Return value is 1 if the definition is
successful.  Return value is zero if there
are not exactly two parameters.

=cut

#-----------------------------------------------
#-----------------------------------------------
#                 dashrep_define
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_define
{

    my ( $phrase_name ) ;
    my ( $expanded_text ) ;


#-----------------------------------------------
#  Do the assignment.

    if ( scalar( @_ ) == 2 )
    {
        $phrase_name = $_[ 0 ] ;
        $expanded_text = $_[ 1 ] ;
        $phrase_name =~ s/^ +// ;
        $phrase_name =~ s/ +$// ;
        $dashrep_replacement{ $phrase_name } = $expanded_text ;
    } else
    {
        carp "Warning: Call to dashrep_define subroutine does not have exactly two parameters." ;
        return 0 ;
    }


#-----------------------------------------------
#  End of subroutine.

    return 1 ;

}


=head2 dashrep_import_replacements

Parses a text string that is written in the
Dashrep language.  Often the text string is
the content of a text file.  The text
specifies the replacement text strings for
specified hyphenated phrases.

First, and only, parameter is the text
string that uses the Dashrep language.

Return value is the count for how many
hyphenated phrases were defined (or
redefined).  Return value is zero if
there is not exactly one parameter.

=cut

#-----------------------------------------------
#-----------------------------------------------
#                dashrep_import_replacements
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_import_replacements
{

    my ( $definition_name ) ;
    my ( $definition_value ) ;
    my ( $input_string ) ;
    my ( $replacements_text_to_import ) ;
    my ( $text_before ) ;
    my ( $text_including_comment_end ) ;
    my ( $text_after ) ;
    my ( $do_nothing ) ;
    my ( $temporary_string ) ;
    my ( @list_of_replacement_names ) ;
    my ( @list_of_replacement_strings ) ;


#-----------------------------------------------
#  Get the text that contains replacement
#  definitions.

    if ( scalar( @_ ) == 1 )
    {
        $replacements_text_to_import = $_[ 0 ] ;
    } else
    {
        carp "Warning: Call to dashrep_define subroutine does not have exactly one parameter." ;
        return 0 ;
    }


#-----------------------------------------------
#  Initialization.

    @list_of_replacement_names = ( ) ;


#-----------------------------------------------
#  Replace line breaks with spaces.

    $replacements_text_to_import =~ s/[\n\r]/ /sg ;
    $replacements_text_to_import =~ s/[\n\r]/ /sg ;
    $replacements_text_to_import =~ s/  +/ /sg ;


#-----------------------------------------------
#  Ignore comments that consist of, or are embedded
#  in, strings of the following types:
#    *------  -------*
#    /------  -------/

    $replacements_text_to_import =~ s/\*\-\-\-+\*/ /g ;
    $replacements_text_to_import =~ s/\/\-\-\-+\// /g ;
    while ( $replacements_text_to_import =~ /^(.*?)([\*\/]\-\-+)(.*)$/ )
    {
        $text_before = $1 ;
        $dashrep_replacement{ "comments_ignored" } .= "  " . $2 ;
        $text_including_comment_end = $3 ;
        $text_after = "" ;
        if ( $text_including_comment_end =~ /^(.*?\-\-+[\*\/])(.*)$/ )
        {
            $dashrep_replacement{ "comments_ignored" } .= $1 . "  " ;
            $text_after = $2 ;
        }
        $replacements_text_to_import = $text_before . " " . $text_after ;
    }


#-----------------------------------------------
#  Split the replacement text at spaces,
#  and put the strings into an array.

    $replacements_text_to_import =~ s/  +/ /g ;
    @list_of_replacement_strings = split( / / , $replacements_text_to_import ) ;


#-----------------------------------------------
#  Read and handle each item in the array.

    $definition_name = "" ;
    foreach $input_string ( @list_of_replacement_strings )
    {
        if ( $input_string =~ /^ *$/ )
        {
            $do_nothing ++ ;


#-----------------------------------------------
#  Ignore the "define-begin" directive.

        } elsif ( $input_string eq 'define-begin' )
        {
            $do_nothing ++ ;


#-----------------------------------------------
#  When the "define-end" directive, or a series
#  of at least 3 dashes ("--------"), is encountered,
#  clear the definition name.
#  Also remove trailing spaces from the previous
#  replacement.

        } elsif ( ( $input_string eq 'define-end' ) || ( $input_string =~ /^---+$/ ) )
        {
            $definition_value = $dashrep_replacement{ $definition_name } ;
            $definition_value =~ s/ +$// ;
            if ( $definition_value =~ /[^ \n\r]/ )
            {
                $dashrep_replacement{ $definition_name } = $definition_value ;
            } else
            {
                $dashrep_replacement{ $definition_name } = "" ;
            }
            $definition_name = "" ;


#-----------------------------------------------
#  Get a definition name.
#  Allow a colon after the hyphenated name.
#  If this definition name has already been defined,
#  ignore the earlier definition.

        } elsif ( $definition_name eq "" )
        {
            $definition_name = $input_string ;
            $definition_name =~ s/\:$//  ;
            $dashrep_replacement{ $definition_name } = "" ;
            push( @list_of_replacement_names , $definition_name ) ;


#-----------------------------------------------
#  Collect any text that is part of a definition.

        } elsif ( $input_string ne "" )
        {
            if ( $input_string eq $definition_name )
            {
                 $dashrep_replacement{ $definition_name } = "ERROR: Replacement for hyphenated phrase [" . $definition_name . "] includes itself, which would cause an endless replacement loop." . "\n" ;
                 carp "Warning: Replacement for hyphenated phrase " . $definition_name . " includes itself, which would cause an endless replacement loop." . "\n" ;
            } else
            {
                $dashrep_replacement{ $definition_name } = $dashrep_replacement{ $definition_name } . $input_string . "  " ;
            }
        }


#-----------------------------------------------
#  Repeat the loop for the next string.

    }


#-----------------------------------------------
#  End of subroutine.

    return $#list_of_replacement_names + 1 ;

}


=head2 dashrep_get_replacement

Gets/returns the replacement text string that
is associated with the specified hyphenated
phrase.

First, and only, parameter is the hyphenated
phrase.

Return value is the replacement string that
is associated with the specified hyphenated
phrase.  Return value is an empty string if
there is not exactly one parameter.

=cut

#-----------------------------------------------
#-----------------------------------------------
#                 dashrep_get_replacement
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_get_replacement
{

    my ( $phrase_name ) ;
    my ( $expanded_text ) ;


#-----------------------------------------------
#  Get the name of the hyphenated phrase.

    if ( scalar( @_ ) == 1 )
    {
        $phrase_name = $_[ 0 ] ;
    } else
    {
        $expanded_text = "" ;
        return $expanded_text ;
    }


#-----------------------------------------------
#  Get the replacement text that is associated
#  with the hyphenated phrase.

    if ( ( exists( $dashrep_replacement{ $phrase_name } ) ) && ( $dashrep_replacement{ $phrase_name } =~ /[^ ]/ ) )
    {
        $expanded_text = $dashrep_replacement{ $phrase_name } ;
    } else
    {
        $expanded_text = "" ;
    }


#-----------------------------------------------
#  End of subroutine.

    return $expanded_text ;

}


=head2 dashrep_get_list_of_phrases

Returns an array that lists all the
hyphenated phrases that have been defined
so far.

There are no parameters.

Return value is an array that lists all the
hyphenated phrases that have been defined.
Return value is an empty array if there is
not exactly zero parameters.

=cut

#-----------------------------------------------
#-----------------------------------------------
#           dashrep_get_list_of_phrases
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_get_list_of_phrases
{

    my ( @list_of_phrases ) ;

    if ( scalar( @_ ) != 0 )
    {
        carp "Warning: Call to dashrep_define subroutine does not have exactly zero parameters." ;
        @list_of_phrases = ( ) ;
        return @list_of_phrases ;
    }

    @list_of_phrases = keys( %dashrep_replacement ) ;
    return @list_of_phrases ;

}


=head2 dashrep_delete

Deletes the specified hyphenated phrase.

First parameter is the hyphenated phrase.

Return value is 1 if the deletion is
successful.  Return value is zero if there
is not exactly one parameter.

=cut

#-----------------------------------------------
#-----------------------------------------------
#                 dashrep_delete
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_delete
{

    my ( $phrase_name ) ;
    my ( $expanded_text ) ;


#-----------------------------------------------
#  Delete the indicated phrase.

    if ( scalar( @_ ) == 1 )
    {
        $phrase_name = $_[ 0 ] ;
        $phrase_name =~ s/^ +// ;
        $phrase_name =~ s/ +$// ;
        delete( $dashrep_replacement{ $phrase_name } );
    } else
    {
        carp "Warning: Call to dashrep_delete subroutine does not have exactly one parameter." ;
        return 0 ;
    }


#-----------------------------------------------
#  End of subroutine.

    return 1 ;

}


=head2 dashrep_expand_parameters

Parses a text string that is written in the
Dashrep language and handles parameter
replacements and special operations.  The
special operations must be within
"[- ... -]" text strings.
If the supplied text string is just a
hyphenated phrase, it is expanded to its
replacement string.  Otherwise, any
hyphenated phrase that does not appear
within the square-bracket pattern is
not replaced.  (Those hyphenated phrases
must be replaced using either the
dashrep_expand_phrases,
dashrep_expand_phrases_except_special,
or dashrep_expand_special_phrases subroutines.)

First, and only, parameter is the hyphenated
phrase that is to be expanded.

Return value is the text string associated
with the specified hyphenated phrase, after
that text string has had its parameters
expanded.  Return value is an empty string
if there is not exactly one parameter.

=cut

#-----------------------------------------------
#-----------------------------------------------
#       dashrep_expand_parameters
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_expand_parameters
{

    my ( $supplied_text ) ;
    my ( $replacement_text_name ) ;
    my ( $replacement_text ) ;
    my ( $loop_status_done ) ;
    my ( $text_begin ) ;
    my ( $text_parameter_name ) ;
    my ( $text_parameter_value ) ;
    my ( $text_end ) ;
    my ( $action_name ) ;
    my ( $object_of_action ) ;
    my ( $count ) ;
    my ( $zero_one_multiple ) ;
    my ( $empty_or_nonempty ) ;
    my ( $full_length ) ;
    my ( $length_half ) ;
    my ( $string_beginning ) ;
    my ( $string_end ) ;
    my ( $same_or_not_same ) ;
    my ( $sorted_numbers ) ;
    my ( $text_parameter_placeholder ) ;
    my ( $text_parameter ) ;
    my ( $item_name ) ;
    my ( $name_for_count ) ;
    my ( $text_for_value ) ;
    my ( @list ) ;
    my ( @list_of_sorted_numbers ) ;
    my ( @list_of_replacements_to_auto_increment ) ;


#-----------------------------------------------
#  Get the hyphenated phrase or supplied string.

    if ( scalar( @_ ) == 1 )
    {
        $supplied_text = $_[ 0 ] ;
    } else
    {
        $replacement_text = "" ;
        return $replacement_text ;
    }


#-----------------------------------------------
#  If just a hyphenated phrase was supplied,
#  expand it into its replacement text.

    $replacement_text = $supplied_text ;
    if ( $supplied_text =~ /^ *([^\- ]+-[^ ]*[^\- ]) *$/ )
    {
        $supplied_text = $1 ;
        if ( ( exists( $dashrep_replacement{ $supplied_text } ) ) && ( $dashrep_replacement{ $supplied_text } =~ /[^ ]/ ) )
        {
            $replacement_text = $dashrep_replacement{ $supplied_text } ;
        }
    }


#-----------------------------------------------
#  Initialize the list of replacement names
#  encountered that need to be auto-incremented.

    @list_of_replacements_to_auto_increment = ( ) ;


#-----------------------------------------------
#  Begin a loop that repeats until there have
#  been no more replacements.

    $loop_status_done = $global_false ;
    while ( $loop_status_done == $global_false )
    {
        $loop_status_done = $global_true ;


#-----------------------------------------------
#  If there are any parameter values specified
#  within the replacement, assign those
#  replacements.
#
#  Problems will arise if the parameter value
#  contains a space, bracket, colon, or equal
#  sign, but in those cases just specify a
#  replacement name instead of the value of
#  that replacement.

        while ( $replacement_text =~ /^(.*?)\[\-([^ \n\[\]\:=]+) *= *([^ \n\[\]\:=]+) *-?\](.*)$/ )
        {
            $text_begin = $1 ;
            $text_parameter_name = $2 ;
            $text_parameter_value = $3 ;
            $text_end = $4 ;
            $text_parameter_value =~ s/\-+$// ;
            if ( length( $text_parameter_name ) > 0 )
            {
                $dashrep_replacement{ $text_parameter_name } = $text_parameter_value ;
            } else
            {
            }
            $replacement_text = $text_begin . " " . $text_end ;
            $loop_status_done = $global_false ;
            if ( length( $text_parameter_name ) > 0 )
            {
                $replacement_count_for_item_name{ $text_parameter_name } ++ ;
            }
            $replacement_count_for_item_name{ $text_parameter_value } ++ ;
            $global_endless_loop_counter ++ ;
            if ( $global_endless_loop_counter > $global_endless_loop_counter_limit + 100 )
            {
                &dashrep_internal_endless_loop_info( %replacement_count_for_item_name ) ;
                croak "Error: The dashrep_expand_parameters subroutine encountered an endless loop." ;
            }
        }


#-----------------------------------------------
#  If there are any actions requested (which
#  include a colon between the action and its
#  operand(s), handle them.

        while ( $replacement_text =~ /^(.*?)\[\-([^ \n\[\]\:=]+) *: *([^\[\]]*) *-?\](.*)$/ )
        {
            $text_begin = $1 ;
            $action_name = $2 ;
            $object_of_action = $3 ;
            $text_end = $4 ;
            $object_of_action =~ s/\-+$// ;


#-----------------------------------------------
#  Handle the count-of-list action.

            if ( $action_name eq "count-of-list" )
            {
                @list = &dashrep_internal_split_delimited_items( $object_of_action ) ;
                $count = $#list + 1 ;
                if ( $count == 0 )
                {
                    $text_for_value = "0" ;
                } else
                {
                    $text_for_value = $count ;
                }
                $replacement_text = $text_begin . $text_for_value . $text_end ;


#-----------------------------------------------
#  Handle the first-item-in-list action.

            } elsif ( $action_name eq "first-item-in-list" )
            {
                @list = &dashrep_internal_split_delimited_items( $object_of_action ) ;
                $count = $#list + 1 ;
                $text_for_value = " " ;
                if ( $count > 0 )
                {
                    $text_for_value = $list[ 0 ] ;
                }
                $replacement_text = $text_begin . $text_for_value . $text_end ;


#-----------------------------------------------
#  Handle the last-item-in-list action.

            } elsif ( $action_name eq "last-item-in-list" )
            {
                @list = &dashrep_internal_split_delimited_items( $object_of_action ) ;
                $count = $#list + 1 ;
                $text_for_value = " " ;
                if ( $count > 0 )
                {
                    $text_for_value = $list[ $#list ] ;
                }
                $replacement_text = $text_begin . $text_for_value . $text_end ;


#-----------------------------------------------
#  Handle the zero-one-multiple-count-of-list
#  action.

            } elsif ( $action_name eq "zero-one-multiple-count-of-list" )
            {
                @list = &dashrep_internal_split_delimited_items( $object_of_action ) ;
                $count = $#list + 1 ;
                if ( $count == 0 )
                {
                    $name_for_count = "zero" ;
                } elsif ( $count == 1 )
                {
                    $name_for_count = "one" ;
                } elsif ( $count > 1 )
                {
                    $name_for_count = "multiple" ;
                }
                $replacement_text = $text_begin . $name_for_count . $text_end ;


#-----------------------------------------------
#  Handle the zero-one-multiple action.

            } elsif ( $action_name eq "zero-one-multiple" )
            {
                if ( $object_of_action + 0 <= 0 )
                {
                    $zero_one_multiple = "zero" ;
                } elsif ( $object_of_action + 0 == 1 )
                {
                    $zero_one_multiple = "one" ;
                } else
                {
                    $zero_one_multiple = "multiple" ;
                }
                $replacement_text = $text_begin . $zero_one_multiple . $text_end ;


#-----------------------------------------------
#  Handle the empty-or-nonempty action.

            } elsif ( $action_name eq "empty-or-nonempty" )
            {
                if ( $object_of_action =~ /[^ ]/ )
                {
                    $empty_or_nonempty = "nonempty" ;
                } else
                {
                    $empty_or_nonempty = "empty" ;
                }
                $replacement_text = $text_begin . $empty_or_nonempty . $text_end ;


#-----------------------------------------------
#  Handle the same-or-not-same action.

            } elsif ( $action_name eq "same-or-not-same" )
            {
                $full_length = length( $object_of_action ) ;
                $length_half = int( $full_length / 2 ) ;
                $string_beginning = substr( $object_of_action , 0 , $length_half ) ;
                $string_end = substr( $object_of_action , $full_length - $length_half , $length_half ) ;
                if ( $string_beginning eq $string_end )
                {
                    $same_or_not_same = "same" ;
                } else
                {
                    $same_or_not_same = "not-same" ;
                }
                $replacement_text = $text_begin . $same_or_not_same . $text_end ;


#-----------------------------------------------
#  Handle the sort-numbers action.

            } elsif ( $action_name eq "sort-numbers" )
            {
                if ( $object_of_action =~ /[1-9]/ )
                {
                    $object_of_action =~ s/ +/,/gs ;
                    $object_of_action =~ s/^,// ;
                    $object_of_action =~ s/,$// ;
                    @list = split( /,+/ , $object_of_action ) ;
                    @list_of_sorted_numbers = sort { $a <=> $b } @list ;
                    $sorted_numbers = join( "," , @list_of_sorted_numbers ) ;
                } else
                {
                    $sorted_numbers = " " ;
                }
                $replacement_text = $text_begin . $sorted_numbers . $text_end ;


#-----------------------------------------------
#  Handle the unique-value action.
#
#  Currently this action is equivalent to the
#  auto-increment action.
#  It can be changed to accomodate a
#  parallel-processing environment where the
#  code here would assign values from separate
#  blocks of numbers assigned to each
#  processor/process.

            } elsif ( $action_name =~ /^unique-value/ )
            {
                if ( exists( $dashrep_replacement{ $object_of_action } ) )
                {
                    $dashrep_replacement{ $object_of_action } = $dashrep_replacement{ $object_of_action } + 1 ;
                } else
                {
                    $dashrep_replacement{ $object_of_action } = 1 ;
                }
                $replacement_text = $text_begin . " " . $text_end ;


#-----------------------------------------------
#  Handle the auto-increment action.

            } elsif ( $action_name =~ /^auto-increment/ )
            {
                if ( exists( $dashrep_replacement{ $object_of_action } ) )
                {
                    $dashrep_replacement{ $object_of_action } = $dashrep_replacement{ $object_of_action } + 1 ;
                } else
                {
                    $dashrep_replacement{ $object_of_action } = 1 ;
                }
                $replacement_text = $text_begin . " " . $text_end ;


#-----------------------------------------------
#  Handle the create-list-named action.

            } elsif ( $action_name eq "create-list-named" )
            {
                push ( @global_list_of_lists_to_generate , $object_of_action ) ;
                $replacement_text = $text_begin . " " . $text_end ;


#-----------------------------------------------
#  Handle an action name that is not recognized.

            } else
            {
                $replacement_text = $text_begin . " " . $text_end ;
            }


#-----------------------------------------------
#  Finish handling a special action.

            $loop_status_done = $global_false ;
            $replacement_count_for_item_name{ $action_name } ++ ;
            $global_endless_loop_counter ++ ;
            if ( $global_endless_loop_counter > $global_endless_loop_counter_limit + 100 )
            {
                &dashrep_internal_endless_loop_info( %replacement_count_for_item_name ) ;
                croak "Error: The Dashrep dashrep_expand_parameters subroutine encountered an endless loop." ;
            }
        }


#-----------------------------------------------
#  Do each parameter replacement.

        if ( $replacement_text =~ /^(.*?)\[\-([^ \n\[\]]+)\-\](.*)$/ )
        {
            $text_begin = $1 ;
            $text_parameter_placeholder = $2 ;
            $text_end = $3 ;
            if ( exists( $dashrep_replacement{ $text_parameter_placeholder } ) )
            {
                $text_parameter = $dashrep_replacement{ $text_parameter_placeholder } ;
            } else
            {
                $text_parameter = "" ;
            }
            $replacement_text = $text_begin . $text_parameter . $text_end ;
            $loop_status_done = $global_false ;
            if ( $text_parameter_placeholder =~ /^auto-increment-/ )
            {
                push( @list_of_replacements_to_auto_increment , $text_parameter_placeholder ) ;
            }
            $replacement_count_for_item_name{ $text_parameter_placeholder } ++ ;
            $global_endless_loop_counter ++ ;
            if ( $global_endless_loop_counter > $global_endless_loop_counter_limit + 100 )
            {
                &dashrep_internal_endless_loop_info( %replacement_count_for_item_name ) ;
                croak "Error: The dashrep_expand_parameters subroutine encountered an endless loop." ;
            }
        }


#-----------------------------------------------
#  Avoid an endless loop (caused by a replacement
#  containing, at some level, itself).

        $global_endless_loop_counter ++ ;
        if ( $global_endless_loop_counter > $global_endless_loop_counter_limit )
        {
            &dashrep_internal_endless_loop_info( %replacement_count_for_item_name ) ;
            croak "Error: The dashrep_expand_parameters subroutine encountered an endless loop." ;
        }


#-----------------------------------------------
#  Repeat the inner loop if any replacements
#  were done.

    }


#-----------------------------------------------
#  For each encountered replacement that begins
#  with "auto-increment-", increment its value.

    foreach $text_parameter_placeholder ( @list_of_replacements_to_auto_increment )
    {
        $dashrep_replacement{ $text_parameter_placeholder } ++ ;
    }
    @list_of_replacements_to_auto_increment = ( ) ;


#-----------------------------------------------
#  Return the revised text.

    return $replacement_text ;


#-----------------------------------------------
#  End of subroutine.

}


=head2 dashrep_generate_lists

Internal subroutine, not exported.
It is only needed within the Dashrep module.

=cut


#-----------------------------------------------
#-----------------------------------------------
#         Non-exported subroutine:
#
#         dashrep_generate_lists
#-----------------------------------------------
#-----------------------------------------------
#  Generates one or more lists, and the elements
#  in them, and puts each list and each element
#  into a named replacement.
#  Allows new list names to be specified
#  while generating the initial lists.

#  This subroutine is not exported because it
#  is only needed within this Dashrep module.

sub dashrep_generate_lists
{

    my ( $list_name ) ;
    my ( $generated_list_name ) ;
    my ( $parameter_name ) ;
    my ( $do_nothing ) ;
    my ( $list_prefix ) ;
    my ( $list_separator ) ;
    my ( $list_suffix ) ;
    my ( $replacement_name ) ;
    my ( $delimited_list_of_parameters ) ;
    my ( $pointer ) ;
    my ( $parameter ) ;
    my ( $item_name ) ;
    my ( @list_of_parameters ) ;
    my ( %already_generated_list_named ) ;


#-----------------------------------------------
#  Begin a loop that handles each list to
#  be generated.

    foreach $list_name ( @global_list_of_lists_to_generate )
    {


#-----------------------------------------------
#  Don't generate the same list more than once.

        if ( exists( $already_generated_list_named{ $list_name } ) )
        {
            if ( $already_generated_list_named{ $list_name } == $global_true )
            {
                next ;
            }
        }
        $already_generated_list_named{ $list_name } = $global_true ;


#-----------------------------------------------
#  Get information about the list being generated.

        $generated_list_name = "generated-list-named-" . $list_name ;
        $parameter_name = $dashrep_replacement{ "parameter-name-for-list-named-" . $list_name } ;


#-----------------------------------------------
#  If the list prefix, separator, or suffix is
#  not defined, set it to empty (the default
#  value).

        if ( exists( $dashrep_replacement{ "prefix-for-list-named-" . $list_name } ) )
        {
            $do_nothing ++ ;
        } else
        {
            $dashrep_replacement{ "prefix-for-list-named-" . $list_name } = "" ;
        }
        $list_prefix = &dashrep_expand_parameters( "prefix-for-list-named-" . $list_name ) . "\n" ;

        if ( exists( $dashrep_replacement{ "separator-for-list-named-" . $list_name } ) )
        {
            $do_nothing ++ ;
        } else
        {
            $dashrep_replacement{ "separator-for-list-named-" . $list_name } = "" ;
        }
        $list_separator = &dashrep_expand_parameters( "separator-for-list-named-" . $list_name ) . "\n" ;

        if ( exists( $dashrep_replacement{ "suffix-for-list-named-" . $list_name } ) )
        {
            $do_nothing ++ ;
        } else
        {
            $dashrep_replacement{ "suffix-for-list-named-" . $list_name } = "" ;
        }
        $list_suffix = &dashrep_expand_parameters( "suffix-for-list-named-" . $list_name ) . "\n" ;


#-----------------------------------------------
#  Get the list of parameters that define the list.

        $replacement_name = "list-of-parameter-values-for-list-named-" . $list_name ;
        $delimited_list_of_parameters = &dashrep_expand_parameters( "list-of-parameter-values-for-list-named-" . $list_name ) ;
        @list_of_parameters = &dashrep_internal_split_delimited_items( $delimited_list_of_parameters ) ;
        $dashrep_replacement{ "logged-list-of-parameter-values-for-list-named-" . $list_name } = join( "," , @list_of_parameters ) ;


#-----------------------------------------------
#  Insert a prefix at the beginning of the list.

        $dashrep_replacement{ $generated_list_name } = $list_prefix . "\n" ;


#-----------------------------------------------
#  Begin a loop that handles each list item.
#  Do not change the order of the parameters.

        for ( $pointer = 0 ; $pointer <= $#list_of_parameters ; $pointer ++ )
        {
            $parameter = $list_of_parameters[ $pointer ] ;
            $dashrep_replacement{ $parameter_name } = $parameter ;


#-----------------------------------------------
#  Add the next item to the list.

            $item_name = "item-for-list-" . $list_name . "-and-parameter-" . $parameter ;
            $dashrep_replacement{ $generated_list_name } .= $item_name . "\n" ;


#-----------------------------------------------
#  Using a template, generate each item in the list.

            $dashrep_replacement{ $item_name } = &dashrep_expand_parameters( "template-for-list-named-" . $list_name ) ;


#-----------------------------------------------
#  Insert separators between items.

            if ( $pointer < $#list_of_parameters )
            {
                $dashrep_replacement{ $generated_list_name } .= $list_separator . "\n" ;
            }


#-----------------------------------------------
#  Protect against an endless loop.

            $global_endless_loop_counter ++ ;
            if ( $global_endless_loop_counter > $global_endless_loop_counter_limit )
            {
                croak "Error: The dashrep_generate_lists subroutine encountered an endless loop." ;
            }


#-----------------------------------------------
#  Repeat the loop for the next list item.

        }


#-----------------------------------------------
#  Terminate the generated list.

        $dashrep_replacement{ $generated_list_name } .= $list_suffix . "\n" ;


#-----------------------------------------------
#  Repeat the loop for the next list to be
#  generated.

    }

#-----------------------------------------------
#  End of subroutine.

    return 1 ;

}


=head2 dashrep_expand_phrases_except_special

Expands the hyphenated phrases in a text
string that is written in the Dashrep
language--except the special
(built-in) hyphenated phrases that handle
spaces, hyphens, tabs, and line breaks,
and except the parameterized phrases.

First, and only, parameter is the text
string that uses the Dashrep language.

Return value is the expanded text string.
Return value is an empty string if there
is not exactly one parameter.

=cut

#-----------------------------------------------
#-----------------------------------------------
#       dashrep_expand_phrases_except_special
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_expand_phrases_except_special
{

    my ( $current_item ) ;
    my ( $hyphenated_phrase_to_expand ) ;
    my ( $expanded_output_string ) ;
    my ( $item_name ) ;
    my ( $first_item ) ;
    my ( $remainder ) ;
    my ( $replacement_item ) ;
    my ( @item_stack ) ;
    my ( @items_to_add ) ;


#-----------------------------------------------
#  Get the starting replacement name.

    if ( scalar( @_ ) == 1 )
    {
        $hyphenated_phrase_to_expand = $_[ 0 ] ;
    } else
    {
        $expanded_output_string = "" ;
        return $expanded_output_string ;
    }


#-----------------------------------------------
#  Generate any needed lists.

    &dashrep_generate_lists ;


#-----------------------------------------------
#  Start with a single phrase on a stack.

    @item_stack = ( ) ;
    push( @item_stack , $hyphenated_phrase_to_expand ) ;
    $expanded_output_string = "" ;


#-----------------------------------------------
#  Begin a loop that does all the replacements.

    while( $#item_stack >= 0 )
    {


#-----------------------------------------------
#  If an endless loop occurs, handle that situation.

        $global_endless_loop_counter ++ ;
        if ( $global_endless_loop_counter > $global_endless_loop_counter_limit )
        {
            &dashrep_internal_endless_loop_info( %replacement_count_for_item_name ) ;
            croak "Error: The dashrep_expand_phrases_except_special subroutine encountered an endless loop." ;
        }


#-----------------------------------------------
#  Get the first/next item from the stack.
#  If it is empty (after removing spaces),
#  repeat the loop.

        $current_item = pop( @item_stack ) ;
        $current_item =~ s/^ +// ;
        $current_item =~ s/ +$// ;
        if ( $current_item eq "" )
        {
            next ;
        }


#-----------------------------------------------
#  If the item contains a space or line break,
#  split the string at the first space or
#  line break, and then repeat the loop.

        if ( $current_item =~ /^ *([^ ]+)[ \n\r]+(.*)$/ )
        {
            $first_item = $1 ;
            $remainder = $2 ;
            if ( $remainder =~ /[^ ]/ )
            {
                push( @item_stack , $remainder ) ;
            }
            push( @item_stack , $first_item ) ;
            next ;
        }


#-----------------------------------------------
#  If the item is a hyphenated phrase that has
#  been defined, expand the phrase into its
#  associated text (its definition), split the
#  text at any spaces or line breaks, put those
#  delimited items on the stack, and repeat
#  the loop.

        if ( exists( $dashrep_replacement{ $current_item } ) )
        {
            $replacement_item = $dashrep_replacement{ $current_item } ;
            if ( $replacement_item =~ /[^ ]/ )
            {
                @items_to_add = split( /[ \n\r]+/ , $replacement_item ) ;
                push( @item_stack , reverse( @items_to_add ) ) ;
                $replacement_count_for_item_name{ $current_item } ++ ;
                next ;
            }
            next ;
        }


#-----------------------------------------------
#  If the item cannot be expanded, append it to
#  the output string.

        $expanded_output_string .= $current_item . " " ;


#-----------------------------------------------
#  Repeat the loop for the next replacement.

    }


#-----------------------------------------------
#  End of subroutine.

    return $expanded_output_string ;

}


=head2 dashrep_expand_special_phrases

Expands only the the special (built-in)
hyphenated phrases that handle hyphens,
tabs, spaces and line breaks,

First, and only, parameter is the
text string that contains the special
hyphenated phrases.

Return value is the expanded text string.
Return value is an empty string if there
is not exactly one parameter.

=cut

#-----------------------------------------------
#-----------------------------------------------
#         dashrep_expand_special_phrases
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_expand_special_phrases
{

    my ( $expanded_string ) ;
    my ( $phrase_name ) ;
    my ( $code_for_non_breaking_space ) ;
    my ( $code_begin ) ;
    my ( $code_with_spaces ) ;
    my ( $code_end ) ;


#-----------------------------------------------
#  Get the starting hyphenated-phrase.

    if ( scalar( @_ ) == 1 )
    {
        $expanded_string = $_[ 0 ] ;
    } else
    {
        $expanded_string = "" ;
        return $expanded_string ;
    }


#-----------------------------------------------
#  If a single hyphenated phrase is supplied and
#  is defined, expand it.  Otherwise, assume
#  it's a text string that contains the special
#  phrases.

    if ( $expanded_string =~ /^ *([^ \[\]]+-[^ \[\]]+) *$/ )
    {
        $phrase_name = $1 ;
        if ( exists( $dashrep_replacement{ $phrase_name } ) )
        {
            $expanded_string = $dashrep_replacement{ $phrase_name } ;
        }
    }


#-----------------------------------------------
#  Handle the "non-breaking-space" directive.

    $code_for_non_breaking_space = $dashrep_replacement{ "non-breaking-space" } ;
    while ( $expanded_string =~ /^(.* +)?non-breaking-space( +.*)?$/sgi )
    {
        $code_begin = $1 ;
        $code_end = $2 ;
        $code_begin =~ s/ +$//si ;
        $code_end =~ s/^ +//si ;
        $expanded_string = $code_begin . $code_for_non_breaking_space . $code_end ;
    }


#-----------------------------------------------
#  Handle the "span-non-breaking-spaces-begin/end"
#  directives.

    $code_for_non_breaking_space = $dashrep_replacement{ "non-breaking-space" } ;
    while ( $expanded_string =~ /^(.*)\bspan-non-breaking-spaces-begin\b *(.*?) *\bspan-non-breaking-spaces-end\b(.*)$/sgi )
    {
        $code_begin = $1 ;
        $code_with_spaces = $2 ;
        $code_end = $3 ;
        $code_with_spaces =~ s/ +/ ${code_for_non_breaking_space} /sgi ;
        $code_with_spaces =~ s/ +//sgi ;
        $expanded_string = $code_begin . $code_with_spaces . $code_end ;
    }


#-----------------------------------------------
#  Replace multiple spaces and tabs with single spaces.

    $expanded_string =~ s/[ \n][ \t]+/ /sg ;


#-----------------------------------------------
#  Handle the "tab-here" directive.

    $expanded_string =~ s/ *\btab-here\b */\t/sg ;


#-----------------------------------------------
#  Handle the "empty-line" and "new-line" directives.

    $expanded_string =~ s/ *\bempty-line\b */\n\n/sg ;
    $expanded_string =~ s/ *\bnew-line\b */\n/sg ;


#-----------------------------------------------
#  Concatenate lines and spaces as indicated by
#  the "no-space" and "one-space" directives.

    $expanded_string =~ s/\bone-space\b/<onespace>/sgi ;

    $expanded_string =~ s/\bno-space\b/<nospace>/sgi ;

    $expanded_string =~ s/[ \t]+<nospace>[ \t]*/<nospace>/sgi ;
    $expanded_string =~ s/[ \t]*<nospace>[ \t]+/<nospace>/sgi ;
    $expanded_string =~ s/<nospace>//sgi ;
    $expanded_string =~ s/<nospace>//sgi ;

    $expanded_string =~ s/[ \t]+<onespace>[ \t]*/<onespace>/sgi ;
    $expanded_string =~ s/[ \t]*<onespace>[ \t]+/<onespace>/sgi ;
    $expanded_string =~ s/<onespace>/ /sgi ;
    $expanded_string =~ s/<onespace>/ /sgi ;


#-----------------------------------------------
#  End of subroutine.

    return $expanded_string ;

}


=head2 dashrep_expand_phrases

Expands all the hyphenated phrases
in a text string that is written in the
Dashrep language.  This includes expanding
the special (built-in) hyphenated phrases
that handle spaces, hyphens, and line breaks.

First, and only, parameter is the hyphenated
phrase to be expanded.

Return value is the expanded text string.
Return value is an empty string if there is not
exactly one parameter.

=cut

#-----------------------------------------------
#-----------------------------------------------
#              dashrep_expand_phrases
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_expand_phrases
{

    my ( $hyphenated_phrase_to_expand ) ;
    my ( $partly_expanded_string ) ;
    my ( $expanded_string ) ;


#-----------------------------------------------
#  Get the starting hyphenated-phrase.

    if ( scalar( @_ ) == 1 )
    {
        $hyphenated_phrase_to_expand = $_[ 0 ] ;
    } else
    {
        $expanded_string = "" ;
        return $expanded_string ;
    }


#-----------------------------------------------
#  Expand the phrase except for special phrases.

    $partly_expanded_string = &dashrep_expand_phrases_except_special( $hyphenated_phrase_to_expand ) ;


#-----------------------------------------------
#  Handle the "empty-line" and "new-line" and
#  "no-space" and "one-space" and other
#  special directives.

    $expanded_string = &dashrep_expand_special_phrases( $partly_expanded_string ) ;


#-----------------------------------------------
#  End of subroutine.

    return $expanded_string ;

}


=head2 dashrep_set_runaway_limit

Specifies the counter limit that attempts to
identify an endless loop caused by a
hyphenated phrase that has a replacement
string that (directly or indirectly) contains
the same replacement string.

First, and only, parameter is the new value
to be used as a replacement limit.

Return value is one (1) if the assignment was
successful.  Return value is zero if there
is not exactly one parameter, or if the new
limit does not exceed 5.

=cut

#-----------------------------------------------
#-----------------------------------------------
#            dashrep_set_runaway_limit
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_set_runaway_limit
{

    my ( $new_limit ) ;


#-----------------------------------------------
#  Do the assignment.

    if ( scalar( @_ ) == 1 )
    {
        $new_limit = $_[ 0 ] ;
        if ( $new_limit >= 5 )
        {
            $global_endless_loop_counter_limit = $new_limit ;
        } else
        {
            carp "Warning: Limit number supplied to dashrep_set_runaway_limit subroutine is too small (less than 5), so limit not changed." ;
            return 0 ;
        }
    } else
    {
        carp "Warning: Call to dashrep_set_runaway_limit subroutine does not have exactly one parameter." ;
        return 0 ;
    }


#-----------------------------------------------
#  End of subroutine.

    return 1 ;

}


=head2 dashrep_internal_endless_loop_info

Internal subroutine, not exported.
It is only needed within the Dashrep module.

=cut


#-----------------------------------------------
#-----------------------------------------------
#         Non-exported subroutine:
#
#         dashrep_internal_endless_loop_info
#-----------------------------------------------
#-----------------------------------------------
#  This subroutine displays the name of the
#  most-replaced hyphenated phrase, which is
#  usually the one that caused the endless loop.

#  This subroutine is not exported because it
#  is only needed within this Dashrep module.

#  The collected information is displayed in a
#  warning message.

sub dashrep_internal_endless_loop_info
{

    my ( $item_name ) ;
    my ( $highest_usage_counter ) ;
    my ( $highest_usage_item_name ) ;

    $highest_usage_counter = - 1 ;
    foreach $item_name ( keys( %replacement_count_for_item_name ) )
    {
        if ( $replacement_count_for_item_name{ $item_name } > $highest_usage_counter )
        {
            $highest_usage_counter = $replacement_count_for_item_name{ $item_name } ;
            $highest_usage_item_name = $item_name ;
        }
    }
    warn "Too many cycles of replacement.\n" . "Hyphenated phrase with highest replacement count (" . $highest_usage_counter . ") is:\n" . "    " . $highest_usage_item_name . "\n" ;


#-----------------------------------------------
#  End of subroutine.

    return 1 ;

}


=head2 dashrep_internal_split_delimited_items

Internal subroutine, not exported.
It is only needed within the Dashrep module.

=cut


#-----------------------------------------------
#-----------------------------------------------
#         Non-exported subroutine:
#
#         dashrep_internal_split_delimited_items
#-----------------------------------------------
#-----------------------------------------------
#  This subroutine converts a text-format list
#  of text items separated by commas, spaces, or
#  line breaks into an array of separate
#  text strings.  It does not expand any
#  hyphenated phrases.

#  This subroutine is not exported because it
#  is only needed within this Dashrep module.

sub dashrep_internal_split_delimited_items
{
    my ( $text_string ) ;
    my ( @array ) ;

    $text_string = $_[ 0 ] ;


#-----------------------------------------------
#  Convert all delimiters to single commas.

    if ( $text_string =~ /[\n\r]/ )
    {
        $text_string =~ s/[\n\r][\n\r]+/,/gs ;
        $text_string =~ s/[\n\r][\n\r]+/,/gs ;
    }

    $text_string =~ s/ +/,/gs ;
    $text_string =~ s/,,+/,/gs ;


#-----------------------------------------------
#  Remove leading and trailing commas.

    $text_string =~ s/^,// ;
    $text_string =~ s/,$// ;


#-----------------------------------------------
#  If there are only commas and spaces,
#  return an empty list.

    if ( $text_string =~ /^[ ,]*$/ )
    {
        @array = ( ) ;


#-----------------------------------------------
#  Split the strings into an array.

    } else
    {
        @array = split( /,+/ , $text_string ) ;
    }


#-----------------------------------------------
#  Return the resulting array.

    return @array ;

}




=head1 AUTHOR

Richard Fobes, C<< <fobes at CPAN.org> >>


=head1 BUGS

Please report any bugs or feature requests to C<bug-language-dashrep at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Language::Dashrep>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command:

    perldoc Language::Dashrep

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Language::Dashrep>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Language::Dashrep>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Language::Dashrep>

=item * Search CPAN

L<http://search.cpan.org/dist/Language::Dashrep>

=back

You can find documentation for the Dashrep language at: www.Dashrep.org


=head1 TO DO

See www.Dashrep.org for descriptions of possible future developments.


=head1 ACKNOWLEDGEMENTS

Richard Fobes designed the Dashrep (TM) language and
developed the original version of this code over a
period of many years.  Richard Fobes is the author
of the book titled The Creative Problem Solver's Toolbox.


=head1 COPYRIGHT & LICENSE

Copyright 2009 Richard Fobes at www.Dashrep.org, all rights reserved.

You can redistribute and/or modify this library module
under the Perl Artistic license, a copy
of which is included in the LICENSE file.

Conversions of this code into other languages are also
covered by the above license terms.

The Dashrep (TM) name is trademarked by Richard Fobes at
www.Dashrep.org to prevent the name from being co-opted.

The Dashrep (TM) language is in the public domain.

=cut

1; # End of Language::Dashrep
