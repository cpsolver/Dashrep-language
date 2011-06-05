package dashrep_translate;


=head1 NAME

Dashrep is a versatile descriptive programming language based on hyphenated phrases being successively expanded into replacement text.  It is a much more flexible alternative to using a template language.  See www.Dashrep.org for details.

=head1 VERSION

Version 2.12

=cut

=head1 SYNOPSIS

Implements the Dashrep (TM) language, which is a versatile descriptive programming language that recursively expands English-like hyphenated phrases, such as B<rectangle-outline-attention-begin>, into any kind of text or code, such as HTML, XML, JavaScript, C (subset), boilerplate-based text, etc.  The resulting expanded text can be an HTML web page, an XML file, a JavaScript program, a boilerplate-based document, etc.

See www.Dashrep.org for details.

Note about Version 2: This code has been modified from Version 1.10, which is the code in the Language::Dashrep module in the Perl CPAN archives.  Version 2.00 and later can be used without involving anything related to CPAN; it only needs the Perl interpreter (which means that on the Windows operating system only the Perl.exe and Perlxxx.dll files are needed to execute this code.)

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

=head2 dashrep_delete_all

=head2 dashrep_expand_parameters

=head2 dashrep_expand_phrases

=head2 dashrep_expand_phrases_except_special

=head2 dashrep_expand_special_phrases

=head2 dashrep_set_runaway_limit

=head2 dashrep_xml_tags_to_dashrep

=head2 dashrep_top_level_action

=head2 dashrep_linewise_translate

=cut


#-----------------------------------------------
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
#-----------------------------------------------


#-----------------------------------------------
#  Declare package variables.

my ( $global_true ) ;
my ( $global_false ) ;
my ( $global_endless_loop_counter ) ;
my ( $global_endless_loop_counter_limit ) ;
my ( $nesting_level_of_file_actions ) ;
my ( $xml_level_number ) ;
my ( $xml_accumulated_sequence_of_tag_names ) ;
my ( $spaces ) ;
my ( $global_ignore_level ) ;
my ( $global_capture_level ) ;
my ( $global_phrase_to_insert_after_next_top_level_line ) ;
my ( $global_top_line_count_for_insert_phrase ) ;
my ( @global_list_of_lists_to_generate ) ;
my ( %dashrep_replacement ) ;
my ( %replacement_count_for_item_name ) ;
my ( @xml_tag_at_level_number ) ;


#-----------------------------------------------
#  Define package constants.

BEGIN {
    $global_true = 1 ;
    $global_false = 0 ;
    $global_endless_loop_counter = 0 ;
    $global_endless_loop_counter_limit = 70000 ;
    $xml_accumulated_sequence_of_tag_names = "" ;
    $spaces = "                                                                              " ;
    $nesting_level_of_file_actions = 0 ;
    $global_ignore_level = 0 ;
    $global_capture_level = 0 ;
    $xml_level_number = 0 ;
    %dashrep_replacement = ( ) ;
    %replacement_count_for_item_name = ( ) ;
    @global_list_of_lists_to_generate = ( ) ;
    @xml_tag_at_level_number = ( ) ;
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
        warn "Warning: Call to dashrep_define subroutine does not have exactly two parameters." ;
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
        warn "Warning: Call to dashrep_define subroutine does not have exactly one parameter." ;
        return 0 ;
    }


#-----------------------------------------------
#  Reset the "ignore" and "capture" levels.

    $global_ignore_level = 0 ;
    $global_capture_level = 0 ;


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
#  Ignore the "dashrep-definitions-begin" and
#  "dashrep-definitions-end" directives.

        } elsif ( ( $input_string eq 'dashrep-definitions-begin' ) || ( $input_string eq 'dashrep-definitions-end' ) )
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
                 warn "Warning: Replacement for hyphenated phrase " . $definition_name . " includes itself, which would cause an endless replacement loop." ;
            } else
            {
                if ( $dashrep_replacement{ $definition_name } ne "" )
                {
                    $dashrep_replacement{ $definition_name } .= " " ;
                }
                $dashrep_replacement{ $definition_name } = $dashrep_replacement{ $definition_name } . $input_string ;
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
        warn "Warning: Call to dashrep_define subroutine does not have exactly zero parameters." ;
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
        warn "Warning: Call to dashrep_delete subroutine does not have exactly one parameter." ;
        return 0 ;
    }


#-----------------------------------------------
#  End of subroutine.

    return 1 ;

}


=head2 dashrep_delete_all

Deletes all the hyphenated phrases.

There are no parameters.

Return value is 1 if the deletion is
successful.  Return value is zero if there
is not exactly zero parameters.

=cut

#-----------------------------------------------
#-----------------------------------------------
#                 dashrep_delete_all
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_delete_all
{


#-----------------------------------------------
#  Reset the "ignore" and "capture" levels.

    $global_ignore_level = 0 ;
    $global_capture_level = 0 ;


#-----------------------------------------------
#  Reset the xml-parsing state.

    $xml_level_number = 0 ;
    @xml_tag_at_level_number = ( ) ;


#-----------------------------------------------
#  Delete all the phrases.

    if ( scalar( @_ ) == 0 )
    {
        %dashrep_replacement = ( );
    } else
    {
        warn "Warning: Call to dashrep_delete_all subroutine does not have exactly zero parameters." ;
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

First, and only, parameter is the text -- or
hyphenated phrase -- that is to be expanded.

Return value is the text after expanding
any parameters.  Return value is an empty
string if there is not exactly one parameter.

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
#  Use the supplied text as the default result,
#  without leading or trailing spaces.

    $replacement_text = $supplied_text ;
    $replacement_text =~ s/^ +//sg;
    $replacement_text =~ s/ +$//sg;


#-----------------------------------------------
#  If just a hyphenated phrase was supplied,
#  expand it into its replacement text.

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

        if ( ( $dashrep_replacement{ "dashrep_internal-debug-trace-on-or-off" } eq "on" ) && ( $replacement_text =~ /[^ ]/ ) )
        {
            print "{{trace; replacement string: " . $replacement_text . "}}\n";
        }


#-----------------------------------------------
#  Get the next inner-most parameter syntax --
#  with "[-" at the beginning and "-]" at the end.
#  (It must not contain a nested parameter syntax.)

        if ( $replacement_text =~ /^(.*?)\[\-([^\[\]]*)\-\](.*)$/ )
        {
            $text_begin = $1 ;
            $text_parameter_content = $2 ;
            $text_end = $3 ;
            $text_parameter_content =~ s/^ +// ;
            $text_parameter_content =~ s/ +$// ;
            $loop_status_done = $global_false ;

            if ( ( $dashrep_replacement{ "dashrep_internal-debug-trace-on-or-off" } eq "on" ) && ( $text_parameter_content =~ /[^ ]/ ) )
            {
                print "{{trace; innermost parameter: " . $text_parameter_content . "}}\n";
            }


#-----------------------------------------------
#  If there is a parameter value assigned -- as
#  indicated by an equal sign -- then assign
#  the value.
#
#  Problems will arise if the parameter value
#  contains a space, bracket, colon, or equal
#  sign, but in those cases just specify a
#  replacement name instead of the value of
#  that replacement.

            if ( $text_parameter_content =~ /^([^ \n\:=]+) *= *([^ \n\:=]+)$/ )
            {
                $text_parameter_name = $1 ;
                $text_parameter_value = $2 ;
                $text_parameter_value =~ s/[\- ]+$// ;
                if ( length( $text_parameter_name ) > 0 )
                {
                    $dashrep_replacement{ $text_parameter_name } = $text_parameter_value ;
                    $replacement_count_for_item_name{ $text_parameter_name } ++ ;
                }
                $replacement_text = $text_begin . " " . $text_end ;
                $replacement_count_for_item_name{ $text_parameter_value } ++ ;
                if ( ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" ) && ( $text_parameter_name =~ /[^ ]/ ) )
                {
                    print "{{trace; assignment: " . $text_parameter_name . " = " . $text_parameter_value . "}}\n";
                }


#-----------------------------------------------
#  Handle the two-operand action:
#  append-from-phrase-to-phrase

            } elsif ( $text_parameter_content =~ /^append-from-phrase-to-phrase *: *([^\n\:=]*) +([^\n\:=]*)$/ )
            {
                $source_phrase = $1 ;
                $target_phrase = $2 ;
                $dashrep_replacement{ $target_phrase } .= " " . $dashrep_replacement{ $source_phrase } ;
                if ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" )
                {
                    print "{{trace; appended from phrase " . $source_phrase . " to phrase " . $target_phrase . "}}\n" ;
                }
                $replacement_text = $text_begin . " " . $text_end ;


#-----------------------------------------------
#  If there is an action requested (which
#  includes a colon between the action and its
#  operand(s), handle it.

            } elsif ( $text_parameter_content =~ /^([^ \n\:=]+-[^ \n\:=]+) *[: ] *([^\n\:=]*)$/ )
            {
                $action_name = $1 ;
                $object_of_action = $2 ;
                $object_of_action =~ s/\-+$// ;
                $object_of_action =~ s/^ +// ;
                $object_of_action =~ s/ +$// ;
                if ( $object_of_action =~ /^([^ ]+) +(.+)$/ )
                {
                    $first_object_of_action = $1 ;
                    $second_object_of_action = $2 ;
                }

                if ( ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" ) && ( $action_name =~ /[^ ]/ ) )
                {
                    print "{{trace; action and object: " . $action_name . " : " . $object_of_action . "}}\n";
                }


#-----------------------------------------------
#  Handle the action:
#  first-item-in-list

                if ( $action_name eq "first-item-in-list" )
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
#  Handle the action:
#  last-item-in-list

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
#  Handle the action:
#  count-of-list

                } elsif ( $action_name eq "count-of-list" )
                {
                    if ( $object_of_action =~ /[^ ]/ )
                    {
                        @list = &dashrep_internal_split_delimited_items( $object_of_action ) ;
                        $count = $#list + 1 ;
                        if ( $count > 0 )
                        {
                            $text_for_value = $count ;
                        } else
                        {
                            $text_for_value = "0" ;
                        }
                    } else
                    {
                        $text_for_value = "0" ;
                    }
                    $replacement_text = $text_begin . $text_for_value . $text_end ;


#-----------------------------------------------
#  Handle the action:
#  zero-one-multiple-count-of-list

                } elsif ( $action_name eq "zero-one-multiple-count-of-list" )
                {
                    if ( $object_of_action =~ /[^ ]/ )
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
                    } else
                    {
                        $name_for_count = "zero" ;
                    }
                    $replacement_text = $text_begin . $name_for_count . $text_end ;


#-----------------------------------------------
#  Handle the action:
#  zero-one-multiple

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
#  Handle the action:
#  empty-or-nonempty

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
#  Handle the action:
#  same-or-not-same

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
#  Handle the action:
#  sort-numbers

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
#  Handle the action:
#  unique-value
#
#  Currently this action is equivalent to the
#  auto-increment action.
#  It can be changed to accomodate a
#  parallel-processing environment where the
#  code here would assign values from separate
#  blocks of numbers assigned to each
#  processor/process.

                } elsif ( $action_name eq "unique-value" )
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
#  Handle the action:
#  auto-increment

                } elsif ( $action_name eq "auto-increment" )
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
#  Handle the action:
#  create-list-named

                } elsif ( $action_name eq "create-list-named" )
                {
                    push ( @global_list_of_lists_to_generate , $object_of_action ) ;
                    $replacement_text = $text_begin . " " . $text_end ;


#-----------------------------------------------
#  Handle the action:
#  insert-phrase-with-brackets-after-next-top-line
#  For now, just get the phrase name.

                } elsif ( $action_name eq "insert-phrase-with-brackets-after-next-top-line" )
                {
                    $global_phrase_to_insert_after_next_top_level_line = $object_of_action ;
                    $global_top_line_count_for_insert_phrase = 1 ;
                    $replacement_text = $text_begin . " " . $text_end ;
                    if ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" )
                    {
                        print "{{trace; got phrase to insert after next line: " . $global_phrase_to_insert_after_next_top_level_line . "}}\n" ;
                    }


#-----------------------------------------------
#  Terminate the branching that handles a
#  parameter of the type that uses a colon to
#  separate the action name from its required
#  argument.

                } else
                {
                    if ( ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" ) && ( $action_name =~ /[^ ]/ ) )
                    {
                        print "{{trace; action not recognized: " . $action_name . "}}\n";
                    }
                    $replacement_text = $text_begin . " " . $text_parameter_content . " " . $text_end ;
                }


#-----------------------------------------------
#  If the parameter is a defined phrase, do the
#  replacement.

            } elsif ( exists( $dashrep_replacement{ $text_parameter_content } ) )
            {
                $text_parameter = $dashrep_replacement{ $text_parameter_content } ;
                $replacement_text = $text_begin . $text_parameter . $text_end ;
                $loop_status_done = $global_false ;
                if ( $text_parameter_placeholder =~ /^auto-increment-/ )
                {
                    push( @list_of_replacements_to_auto_increment , $text_parameter_placeholder ) ;
                }
                $replacement_count_for_item_name{ $text_parameter_placeholder } ++ ;


#-----------------------------------------------
#  If the parameter content has been not been
#  recognized, simply remove the "[-" and "-]"
#  strings.

            } else
            {
                $replacement_text = $text_begin . $text_parameter_content . $text_end ;
            }


#-----------------------------------------------
#  Avoid an endless loop (caused by a replacement
#  containing, at some level, itself).

            $global_endless_loop_counter ++ ;
            if ( $global_endless_loop_counter > $global_endless_loop_counter_limit )
            {
                &dashrep_internal_endless_loop_info( %replacement_count_for_item_name ) ;
                die "Error: The dashrep_expand_parameters subroutine encountered an endless loop.  Stopped" ;
            }


#-----------------------------------------------
#  Repeat the loop that gets the next inner-most
#  parameter syntax.

        }


#-----------------------------------------------
#  Repeat the loop that repeats until no
#  replacement was done.

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
                die "Error: The dashrep_generate_lists subroutine encountered an endless loop.  Stopped" ;
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
language -- except the special
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
#  Initialization.

    $expanded_output_string = "" ;


#-----------------------------------------------
#  Internally define the "hyphen-here" phrase.

    $dashrep_replacement{ "hyphen-here" } = "no-space - no-space" ;


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
            die "Error: The dashrep_expand_phrases_except_special subroutine encountered an endless loop.  Stopped" ;
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
#  line break, and push those strings onto the
#  stack, and then repeat the loop.

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
#  Get the ignore level.  It can be accessed
#  from outside this subroutine in case multiple
#  streams of Dashrep code are being processed
#  in turn.

    if ( $dashrep_replacement{ "dashrep_internal-ignore-level" } =~ /^[0-9]+$/ )
    {
        $global_ignore_level = $dashrep_replacement{ "dashrep_internal-ignore-level" } + 0 ;
    }


#-----------------------------------------------
#  Get the capture level.  It can be accessed
#  from outside this subroutine in case multiple
#  streams of Dashrep code are being processed
#  in turn.

    if ( $dashrep_replacement{ "dashrep_internal-capture-level" } =~ /^[0-9]+$/ )
    {
        $global_capture_level = $dashrep_replacement{ "dashrep_internal-capture-level" } + 0 ;
    }


#-----------------------------------------------
#  If the ignore level and capture level are both
#  non-zero, indicate an error (because they
#  overlap).

    if ( ( $global_ignore_level > 0 ) && ( $global_capture_level > 0 ) )
    {
        $expanded_string .= " [warning: ignore and capture directives overlap, both directives reset] " ;
        $global_ignore_level = 0 ;
        $global_capture_level = 0 ;
    }


#-----------------------------------------------
#  Handle the directives:
#  "ignore-begin-here" and
#  "ignore-end-here"

    $remaining_string = $expanded_string ;
    $expanded_string = "" ;

    if ( ( $global_ignore_level > 0 ) && ( $remaining_string !~ /((ignore-begin-here)|(ignore-end-here))/si ) )
    {
        if ( $dashrep_replacement{ "dashrep_internal-ignore-trace-on-or-off" } eq "on" )
        {
            print "{{trace; ignore level: " . $global_ignore_level . "}}\n" ;
            if ( $remaining_string =~ /[^ ]/ )
            {
                print "{{trace; ignored: " . $remaining_string . "}}\n" ;
            }
        }
        $remaining_string = "" ;
    }

    while ( $remaining_string =~ /^(.*? +)?((ignore-begin-here)|(ignore-end-here))( +.*)?$/si )
    {
        $code_begin = $1 ;
        $ignore_directive = $2 ;
        $remaining_string = $5 ;

        if ( $global_ignore_level > 0 )
        {
            if ( $dashrep_replacement{ "dashrep_internal-ignore-trace-on-or-off" } eq "on" )
            {
                print "{{trace; ignore level: " . $global_ignore_level . "}}\n" ;
                if ( $remaining_string =~ /[^ ]/ )
                {
                    print "{{trace; ignored: " . $code_begin . "}}\n" ;
                }
            }
        } else
        {
            $expanded_string .= $code_begin . " " ;
        }

        if ( $ignore_directive eq "ignore-begin-here" )
        {
            if ( $dashrep_replacement{ "dashrep_internal-ignore-trace-on-or-off" } eq "on" )
            {
                print "{{trace; ignore directive: " . $ignore_directive . "}}\n" ;
            }
            $global_ignore_level ++ ;
            $dashrep_replacement{ "dashrep_internal-ignore-level" } = sprintf( "%d" , $global_ignore_level ) ;
        } elsif ( $ignore_directive eq "ignore-end-here" )
        {
            if ( $dashrep_replacement{ "dashrep_internal-ignore-trace-on-or-off" } eq "on" )
            {
                print "{{trace; ignore directive: " . $ignore_directive . "}}\n" ;
            }
            $global_ignore_level -- ;
            $dashrep_replacement{ "dashrep_internal-ignore-level" } = sprintf( "%d" , $global_ignore_level ) ;
        }
    }
    $expanded_string .= $remaining_string ;


#-----------------------------------------------
#  Handle the directives:
#  "capture-begin-here" and
#  "capture-end-here"

    $remaining_string = $expanded_string ;
    $expanded_string = "" ;

    if ( ( $global_capture_level > 0 ) && ( $remaining_string !~ /((capture-begin-here)|(capture-end-here))/si ) )
    {
        $dashrep_replacement{ "captured-text" } .= " " . $remaining_string ;
        if ( $dashrep_replacement{ "dashrep_internal-capture-trace-on-or-off" } eq "on" )
        {
            print "{{trace; capture level: " . $global_capture_level . "}}\n" ;
            if ( $remaining_string =~ /[^ ]/ )
            {
                print "{{trace; captured: " . $remaining_string . "}}\n" ;
            }
        }
        $remaining_string = "" ;
    }

    while ( $remaining_string =~ /^(.*? +)?((capture-begin-here)|(capture-end-here))( +.*)?$/si )
    {
        $code_begin = $1 ;
        $capture_directive = $2 ;
        $remaining_string = $5 ;

        if ( $global_capture_level > 0 )
        {
            $dashrep_replacement{ "captured-text" } .= " " . $code_begin ;
            if ( $dashrep_replacement{ "dashrep_internal-capture-trace-on-or-off" } eq "on" )
            {
                print "{{trace; capture level: " . $global_capture_level . "}}\n" ;
                if ( $remaining_string =~ /[^ ]/ )
                {
                    print "{{trace; captured: " . $code_begin . "}}\n" ;
                }
            }
        } else
        {
            $expanded_string .= $code_begin . " " ;
        }

        if ( $capture_directive eq "capture-begin-here" )
        {
            $dashrep_replacement{ "captured-text" } = "" ;
            if ( $dashrep_replacement{ "dashrep_internal-capture-trace-on-or-off" } eq "on" )
            {
                print "{{trace; capture directive: " . $capture_directive . "}}\n" ;
            }
            $global_capture_level ++ ;
            $dashrep_replacement{ "dashrep_internal-capture-level" } = sprintf( "%d" , $global_capture_level ) ;
        } elsif ( $capture_directive eq "capture-end-here" )
        {
            if ( $dashrep_replacement{ "dashrep_internal-capture-trace-on-or-off" } eq "on" )
            {
                print "{{trace; capture directive: " . $capture_directive . "}}\n" ;
            }
            $global_capture_level -- ;
            $dashrep_replacement{ "dashrep_internal-capture-level" } = sprintf( "%d" , $global_capture_level ) ;
        }
    }
    $expanded_string .= $remaining_string ;


#-----------------------------------------------
#  Handle the directive:
#  "non-breaking-space"

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
#  Handle the directives:
#  "span-non-breaking-spaces-begin" and
#  "span-non-breaking-spaces-end"

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
#  Handle the directive:
#  "tab-here"

    $expanded_string =~ s/ *\btab-here\b */\t/sg ;


#-----------------------------------------------
#  Handle the directives:
#  "empty-line" and "new-line"

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

First, and only, parameter is the text string
that may contain hyphenated phrases to be
expanded.

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

    my ( $text_string_to_expand ) ;
    my ( $partly_expanded_string ) ;
    my ( $expanded_string ) ;


#-----------------------------------------------
#  Get the starting hyphenated-phrase.

    if ( scalar( @_ ) == 1 )
    {
        $text_string_to_expand = $_[ 0 ] ;
    } else
    {
        $expanded_string = "" ;
        return $expanded_string ;
    }


#-----------------------------------------------
#  Expand the phrase except for special phrases.

    $partly_expanded_string = &dashrep_expand_phrases_except_special( $text_string_to_expand ) ;


#-----------------------------------------------
#  Handle special directives:
#  "empty-line" and "new-line" and
#  "no-space" and "one-space" and others

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
#  Reset the "ignore" and "capture" levels.

    $global_ignore_level = 0 ;
    $global_capture_level = 0 ;


#-----------------------------------------------
#  Reset the xml-parsing state.

    $xml_level_number = 0 ;
    @xml_tag_at_level_number = ( ) ;


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
            warn "Warning: Limit number supplied to dashrep_set_runaway_limit subroutine is too small (less than 5), so limit not changed." ;
            return 0 ;
        }
    } else
    {
        warn "Warning: Call to dashrep_set_runaway_limit subroutine does not have exactly one parameter." ;
        return 0 ;
    }


#-----------------------------------------------
#  End of subroutine.

    return 1 ;

}


=head2 dashrep_xml_tags_to_dashrep

Converts a single line of XML code into Dashrep
code in which XML tags are replaced by Dashrep
phrases.
Tags are replaced by hyphenated phrases that
are named according to the accumulated XML
tag names, with "begin-" and "end-" to indicate
the beginning and ending tags.  The prefix
"begin-and-end-" indicates a self-terminating
XML tag (e.g. "<br />").
If the non-tag content contains any hyphens,
they are replaced with the phrase "hyphen-here".

=cut


#-----------------------------------------------
#-----------------------------------------------
#             dashrep_xml_tags_to_dashrep
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_xml_tags_to_dashrep
{


#-----------------------------------------------
#  Get the input text.

    my( $input_text ) ;
    my( $first_tag_name ) ;
    if ( scalar( @_ ) == 1 )
    {
        $input_text = @_[ 0 ] ;
    } else
    {
        warn "Warning: Call to xml_tags_to_dashrep subroutine does not have exactly one parameter." ;
        return 0 ;
    }


#-----------------------------------------------
#  Trim spaces from the input line, and clear
#  the output text.

    $input_text =~ s/^ +// ;
    $input_text =~ s/ +$// ;
    $output_text = "" ;


#-----------------------------------------------
#  Get the tag name that is regarded as at
#  the highest level of interest.  Tags at
#  higher levels are ignored.

    $first_tag_name = $dashrep_replacement{ "dashrep_internal-first-xml-tag-name" } ;


#-----------------------------------------------
#  Begin a loop that repeats for each XML tag.
#
#  Get the name within a (single) tag, and
#  ignore any other content within the tag.
#  Ignore the opening XML-standard-required
#  declaration.

    while ( $input_text =~ /^ *([^<>]*)<(\/?)([^ >\?]+[^ >]*)([^>]*)>(.*)$/ )
    {
        $text_before_tag = $1 ;
        $possible_slash = $2 ;
        $tag_name = $3 ;
        $may_include_closing_slash = $4 ;
        $input_text = $5 ;
        if ( $dashrep_replacement{ "dashrep_internal-xml-trace-on-or-off" } eq "on" )
        {
            print "{{trace; tag: <" . $possible_slash . $tag_name . ">}}\n" ;
        }


#-----------------------------------------------
#  If the non-tag content text contains any
#  hyphens, replace them with the phrase
#  "hypen-here".

        $text_before_tag =~ s/\-/dashrep_internal_hyphen_here/sg ;
        $text_before_tag =~ s/dashrep_internal_hyphen_here/ hyphen-here /sg ;


#-----------------------------------------------
#  If any text precedes the tag, write it on a
#  separate line.

        if ( $text_before_tag =~ /[^ ]/ )
        {
            $output_text .= $text_before_tag . "\n" ;
        }


#-----------------------------------------------
#  If the tag is of the "close" type, write the
#  appropriate dashrep phrase.  Then remove the
#  lowest-level tag name from the phrase that
#  contains all the tag names.

        if ( $possible_slash eq '/' )
        {
            if ( length( $xml_accumulated_sequence_of_tag_names ) > 0 )
            {
                $output_text .= substr( $spaces , 0 , ( 2 * $xml_level_number ) ) . "[-" ;
                $output_text .= "end" . $xml_accumulated_sequence_of_tag_names . "-]\n" ;
                $starting_position_of_last_tag_name = length( $xml_accumulated_sequence_of_tag_names ) - length( $xml_tag_at_level_number[ $xml_level_number ] ) - 1 ;
                if ( $starting_position_of_last_tag_name > 0 )
                {
                    $xml_accumulated_sequence_of_tag_names = substr( $xml_accumulated_sequence_of_tag_names , 0 , $starting_position_of_last_tag_name ) ;
                } else
                {
                    $xml_accumulated_sequence_of_tag_names = "" ;
                }
            }
            $xml_level_number -- ;


#-----------------------------------------------
#  If the tag is of the singular (open and close)
#  type, write the appropriate dashrep phrase.

        } elsif ( $may_include_closing_slash =~ /\// )
        {
            if ( length( $xml_accumulated_sequence_of_tag_names ) > 0 )
            {
                $output_text .= substr( $spaces , 0 , ( 2 * ( $xml_level_number + 1 ) ) ) . "[-" ;
                $output_text .= "begin-and-end" . $xml_accumulated_sequence_of_tag_names . "-" . $tag_name . "-]\n" ;
            }


#-----------------------------------------------
#  If the tag is of the "open" type, append the
#  new tag name to the accumulated hyphenated
#  phrase, and then write the appropriate Dashrep
#  phrase.  However, do not use tag names that
#  occur before the specified first tag name
#  (of interest) -- unless the first tag name
#  is empty.

        } else
        {
            if ( length( $xml_accumulated_sequence_of_tag_names ) <= 0 )
            {
                if ( $tag_name eq $first_tag_name )
                {
                    $xml_level_number ++ ;
                    $xml_tag_at_level_number[ $xml_level_number ] = $tag_name ;
                    $xml_accumulated_sequence_of_tag_names = "-" . $tag_name ;
                    if ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" )
                    {
                        print "{{trace; specified top-level tag name: " . $first_tag_name . "}}\n" ;
                    }
                } elsif ( $first_tag_name =~ /^ *$/ )
                {
                    $xml_level_number ++ ;
                    $xml_tag_at_level_number[ $xml_level_number ] = $tag_name ;
                    $first_tag_name = $tag_name ;
                    $dashrep_replacement{ "dashrep_internal-first-xml-tag-name" } = $first_tag_name ;
                    $xml_accumulated_sequence_of_tag_names = "-" . $tag_name ;
                    if ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" )
                    {
                        print "{{trace; default top-level tag name: " . $tag_name . "}}\n" ;
                    }
                } else
                {
                    if ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" )
                    {
                        print "{{trace; ignored tag: " . $tag_name . "}}\n" ;
                    }
                }
            } else
            {
                $xml_level_number ++ ;
                $xml_tag_at_level_number[ $xml_level_number ] = $tag_name ;
                $xml_accumulated_sequence_of_tag_names .= "-" . $tag_name ;
            }
            if ( length( $xml_accumulated_sequence_of_tag_names ) > 0 )
            {
                $output_text .= substr( $spaces , 0 , ( 2 * ( $xml_level_number - 1 ) ) ) . "[-" ;
                $output_text .= "begin" . $xml_accumulated_sequence_of_tag_names . "-]\n" ;
            }
        }


#-----------------------------------------------
#  Repeat the loop for the next tag in the
#  input line.

    }


#-----------------------------------------------
#  If the non-tag content text contains any
#  hyphens, replace them with the phrase
#  "hypen-here".

        $input_text =~ s/\-/dashrep_internal_hyphen_here/sg ;
        $input_text =~ s/dashrep_internal_hyphen_here/ hyphen-here /sg ;


#-----------------------------------------------
#  If any text follows the last tag, write it on a
#  separate line.

    if ( $input_text =~ /^ *([^ ].*)$/ )
    {
        $input_text = $1 ;
        $output_text .= "\n" . $input_text ;
        $input_text = "" ;
    }


#-----------------------------------------------
#  End of subroutine.

    return $output_text ;

}


=head2 dashrep_top_level_action

Handles a top-level action such as a transfer
to and from files.

First, and only, parameter is the
text string that contains any text, which
may include one top-level action (which is
a hyphenated phrase).

Return value is the text string after removing
the executed action, or the original text
string if there was no action phrase.
Return value is an empty string if there
is not exactly one parameter.

=cut


#-----------------------------------------------
#-----------------------------------------------
#         dashrep_top_level_action
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_top_level_action
{

    my ( $source_definitions ) ;
    my ( $input_text ) ;
    my ( $translation ) ;
    my ( $partial_translation ) ;
    my ( $source_filename ) ;
    my ( $target_filename ) ;
    my ( $source_phrase ) ;
    my ( $target_phrase ) ;
    my ( $lines_to_translate ) ;
    my ( @list_of_phrases ) ;


#-----------------------------------------------
#  Reset the xml-parsing state.

    $xml_level_number = 0 ;
    @xml_tag_at_level_number = ( ) ;


#-----------------------------------------------
#  Get the input text.

    if ( scalar( @_ ) == 1 )
    {
        $input_text = @_[ 0 ] ;
    } else
    {
        warn "Warning: Call to dashrep_top_level_action subroutine does not exactly one parameter." ;
        return 0 ;
    }


#-----------------------------------------------
#  Clear the error message.

    $possible_error_message = "" ;


#-----------------------------------------------
#  Ensure this function is not called recursively.

    $nesting_level_of_file_actions ++ ;
    if ( $nesting_level_of_file_actions > 1 )
    {
        warn "Warning: Call to dashrep_top_level_action subroutine called recursivley, which is not allowed." ;
        return 0 ;
    }


#-----------------------------------------------
#  Handle the action:
#  append-from-phrase-to-phrase

    if ( $input_text =~ /^ *append-from-phrase-to-phrase +([^ \[\]]+) +([^ \[\]]+) *$/ )
    {
        $source_phrase = $1 ;
        $target_phrase = $2 ;
        $dashrep_replacement{ $target_phrase } .= " " . $dashrep_replacement{ $source_phrase } ;
        if ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" )
        {
            print "{{trace; appended from phrase " . $source_phrase . " to phrase " . $target_phrase . "}}\n" ;
        }
        $input_text = "" ;


#-----------------------------------------------
#  Handle the action:
#  copy-from-phrase-append-to-file
#
#  The filename is edited to remove any path
#  specifications, so that only local files
#  are affected.

    } elsif ( $input_text =~ /^ *copy-from-phrase-append-to-file +([^ \[\]]+) +([^ \[\]]+) *$/ )
    {
        $source_phrase = $1 ;
        $target_filename = $2 ;
        $target_filename =~ s/^.*[\\\/]// ;
        $target_filename =~ s/^\.+// ;
        if ( open ( OUTFILE , ">>" . $target_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [file named " . $target_filename . " could not be opened for writing]" ;
        }
        if ( $possible_error_message eq "" )
        {
            print OUTFILE "\n" . $dashrep_replacement{ $source_phrase } . "\n" ;
        }
        close( OUTFILE ) ;
        if ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" )
        {
            print "{{trace; copied from phrase " . $source_phrase . " to end of file " . $target_filename . "}}\n" ;
        }
        $input_text = "" ;


#-----------------------------------------------
#  Handle the action:
#  copy-from-file-to-phrase

    } elsif ( $input_text =~ /^ *copy-from-file-to-phrase +([^ \[\]]+) +([^ \[\]]+) *$/ )
    {
        $source_filename = $1 ;
        $target_phrase = $2 ;
        if ( open ( INFILE , "<" . $source_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [file named " . $source_filename . " not found, or could not be opened]" ;
        }
        if ( $possible_error_message eq "" )
        {
            $possible_error_message .= " [file named " . $source_filename . " found, and opened]" ;
            $all_lines = "" ;
            while( $input_line = <INFILE> )
            {
                chomp( $input_line ) ;
                $all_lines .= $input_line . "\n" ;
            }
            $dashrep_replacement{ $target_phrase } = $all_lines ;
        }
        close( INFILE ) ;
        if ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" )
        {
            print "{{trace; copied from file " . $source_filename . " to phrase " . $target_phrase . "}}\n" ;
        }
        $input_text = "" ;


#-----------------------------------------------
#  Handle the action:
#  create-empty-file
#
#  The filename is edited to remove any path
#  specifications, so that only local files
#  are affected.

    } elsif ( $input_text =~ /^ *create-empty-file +([^ \[\]]+) *$/ )
    {
        $target_filename = $1 ;
        $target_filename =~ s/^.*[\\\/]// ;
        $target_filename =~ s/^\.+// ;
        if ( open ( OUTFILE , ">" . $target_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [file named " . $target_filename . " could not be created]" ;
        }
        if ( $possible_error_message eq "" )
        {
            print OUTFILE "" ;
        }
        close( OUTFILE ) ;
        if ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" )
        {
            print "{{trace; created empty file: " . $target_filename . "}}\n" ;
        }
        $input_text = "" ;


#-----------------------------------------------
#  Handle the action:
#  delete-file
#
#  The filename is edited to remove any path
#  specifications, so that only local files
#  are affected.

    } elsif ( $input_text =~ /^ *delete-file +([^ \[\]]+) *$/ )
    {
        $target_filename = $1 ;
        $target_filename =~ s/^.*[\\\/]// ;
        $target_filename =~ s/^\.+// ;
        unlink $target_filename ;
        if ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" )
        {
            print "{{trace; deleted file: " . $target_filename . "}}\n" ;
        }
        $input_text = "" ;


#-----------------------------------------------
#  Handle the action:
#  write-all-dashrep-definitions-to-file
#
#  The filename is edited to remove any path
#  specifications, so that only local files
#  are affected.

    } elsif ( $input_text =~ /^ *write-all-dashrep-definitions-to-file +([^ \[\]]+) *$/ )
    {
        $target_filename = $1 ;
        $target_filename =~ s/^.*[\\\/]// ;
        $target_filename =~ s/^\.+// ;
        @list_of_phrases = &dashrep_get_list_of_phrases( ) ;
        if ( open ( OUTFILE , ">" . $target_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [file named " . $target_filename . " could not be opened for writing]" ;
        }
        if ( $possible_error_message eq "" )
        {
            if ( $dashrep_replacement{ "dashrep_internal-export-delimited-definitions" } eq "yes" )
            {
                $all_defs_begin = "export-defs-all-begin\n\n" ;
                $all_defs_end = "export-defs-all-end\n\n" ;
                $phrase_begin = "export-defs-phrase-begin " ;
                $phrase_end = " export-defs-phrase-end\n\n" ;
                $def_begin = "export-defs-def-begin " ;
                $def_end = " export-defs-def-end\n\n" ;
            } else
            {
                $all_defs_begin = "dashrep-definitions-begin\n\n" ;
                $all_defs_end = "dashrep-definitions-end\n\n" ;
                $phrase_begin = "" ;
                $phrase_end = ":\n" ;
                $def_begin = "" ;
                $def_end = "\n-----\n\n" ;
            }
            print OUTFILE $all_defs_begin ;
            foreach $phrase_name ( sort( @list_of_phrases ) )
            {
                if ( $phrase_name =~ /[^ ]/ )
                {
                    print OUTFILE $phrase_begin . $phrase_name . $phrase_end . $def_begin . $dashrep_replacement{ $phrase_name } . $def_end ;
                }
            }
            print OUTFILE $all_defs_end ;
        }
        close( OUTFILE ) ;
        if ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" )
        {
            print "{{trace; wrote all definitions to file: " . $target_filename . "}}\n" ;
        }
        $input_text = "" ;


#-----------------------------------------------
#  Handle the action:
#  get-definitions-from-file

    } elsif ( $input_text =~ /^ *get-definitions-from-file +([^ \[\]]+) *$/ )
    {
        $source_filename = $1 ;
        if ( open ( INFILE , "<" . $source_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [file named " . $source_filename . " not found, or could not be opened]" ;
        }
        if ( $possible_error_message eq "" )
        {
            $possible_error_message .= " [file named " . $source_filename . " found, and opened]" ;
            $source_definitions = "" ;
            while( $input_line = <INFILE> )
            {
                chomp( $input_line ) ;
                $source_definitions .= $input_line . " " ;
            }
        }
        close( INFILE ) ;
        &dashrep_import_replacements( $source_definitions ) ;
        if ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" )
        {
            print "{{trace; got definitions from file: " . $source_filename . "}}\n" ;
        }
        $input_text = "" ;


#-----------------------------------------------
#  Handle the action:
#  clear-all-dashrep-phrases

    } elsif ( $input_text =~ /^ *clear-all-dashrep-phrases *$/ )
    {
        $tracking_on_or_off = $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } ;
        &dashrep_delete_all( );
        if ( $tracking_on_or_off eq "on" )
        {
            print "{{trace; cleared all definitions}}\n" ;
        }
        $input_text = "" ;


#-----------------------------------------------
#  Handle the actions:
#  linewise-translate-from-file-to-file and
#  linewise-translate-parameters-only-from-file-to-file
#  linewise-translate-phrases-only-from-file-to-file
#
#  The output filename is edited to remove any path
#  specifications, so that only local files
#  are affected.

    } elsif ( $input_text =~ /^ *linewise-translate(()|(-parameters-only)|(-phrases-only))-from-file-to-file +([^ \[\]]+) +([^ \[\]]+) *$/ )
    {
        $qualifier = $1 ;
        $source_filename = $5 ;
        $target_filename = $6 ;
        $target_filename =~ s/^.*[\\\/]// ;
        $target_filename =~ s/^\.+// ;
        if ( open ( INFILE , "<" . $source_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [file named " . $source_filename . " not found, or could not be opened]" ;
        }
        if ( open ( OUTFILE , ">" . $target_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [file named " . $target_filename . " could not be opened for writing]" ;
        }
        if ( $possible_error_message eq "" )
        {
            $global_ignore_level = 0 ;
            $global_capture_level = 0 ;
            $global_top_line_count_for_insert_phrase = 0 ;
            while( $input_line = <INFILE> )
            {
                chomp( $input_line ) ;
                $lines_to_translate = 1 ;
                while ( $lines_to_translate > 0 )
                {
                    $lines_to_translate = 0 ;
                    if ( $qualifier eq "-parameters-only" )
                    {
                        $translation = &dashrep_expand_parameters( $input_line );
                    } elsif ( $qualifier eq "-phrases-only" )
                    {
                        $translation = &dashrep_expand_phrases( $input_line );
                    } else
                    {
                        $partial_translation = &dashrep_expand_parameters( $input_line );
                        $translation = &dashrep_expand_phrases( $partial_translation );
                    }
                    if ( ( $translation =~ /[^ ]/ ) && ( ( $global_ignore_level < 1 ) || ( $global_capture_level < 1 ) ) )
                    {
                        print OUTFILE $translation . "\n" ;
                    }
                    if ( $global_top_line_count_for_insert_phrase == 1 )
                    {
                        $global_top_line_count_for_insert_phrase = 2 ;
                    } elsif ( $global_top_line_count_for_insert_phrase == 2 )
                    {
                        $global_top_line_count_for_insert_phrase = 0 ;
                        if ( $global_phrase_to_insert_after_next_top_level_line ne "" )
                        {
                            $input_line = "[-" . $global_phrase_to_insert_after_next_top_level_line . "-]" ;
                            $lines_to_translate = 1 ;
                        }
                    }
                }
            }
            if ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" )
            {
                print "{{trace; linewise translated from file " . $source_filename . " to file " . $target_filename . "}}\n" ;
            }
        } else
        {
            if ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" )
            {
                print "{{trace; failed to linewise translate from file " . $source_filename . " to file " . $target_filename . "}}\n" ;
            }
        }
        close( INFILE ) ;
        close( OUTFILE ) ;
        $possible_error_message =~ s/^ +// ;
        $input_text = $possible_error_message ;


#-----------------------------------------------
#  Handle the action:
#  linewise-translate-xml-tags-in-file-to-dashrep-phrases-in-file
#
#  The output filename is edited to remove any path
#  specifications, so that only local files
#  are affected.

    } elsif ( $input_text =~ /^ *linewise-translate-xml-tags-in-file-to-dashrep-phrases-in-file +([^ \[\]]+) +([^ \[\]]+) *$/ )
    {
        $source_filename = $1 ;
        $target_filename = $2 ;
        $target_filename =~ s/^.*[\\\/]// ;
        $target_filename =~ s/^\.+// ;
        if ( open ( INFILE , "<" . $source_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [file named " . $source_filename . " not found, or could not be opened]" ;
        }
        if ( open ( OUTFILE , ">" . $target_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [file named " . $target_filename . " could not be opened for writing]" ;
        }
        if ( $possible_error_message eq "" )
        {
            while( $input_line = <INFILE> )
            {
                chomp( $input_line ) ;
                $translation = &dashrep_xml_tags_to_dashrep( $input_line );
                print OUTFILE $translation . "\n" ;
            }
            if ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" )
            {
                print "{{trace; source xml file named " . $source_filename . " expanded into dashrep phrases in file named " . $target_filename . "}}\n" ;
            }
        } else
        {
            if ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" )
            {
                print "{{trace; failed to expand source xml file named " . $source_filename . " into dashrep phrases in file named " . $target_filename . "}}\n" ;
            }
        }
        close( INFILE ) ;
        close( OUTFILE ) ;
        $possible_error_message =~ s/^ +// ;
        $input_text = $possible_error_message ;


#-----------------------------------------------
#  Finish handling a top-level action.

        if ( ( $dashrep_replacement{ "dashrep_internal-tracking-on-or-off" } eq "on" ) && ( $input_text =~ /[^ ]/ ) )
        {
            print "{{trace; not recognized as top-level action: " . $input_text . "}}\n" ;
        }
    }


#-----------------------------------------------
#  End of subroutine.

    $nesting_level_of_file_actions -- ;
    return $input_text ;

}


=head2 dashrep_linewise_translate

Reads from the standard input file,
does the specified Dashrep translations,
and writes any requested translations
into the standard output file.

There are no parameters.

Return value is a text string that is either
empty -- if there is no error -- or else
contains an error message (although currently
no errors are defined).

=cut


#-----------------------------------------------
#-----------------------------------------------
#         dashrep_linewise_translate
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_linewise_translate
{

    my ( $input_line ) ;


#-----------------------------------------------
#  Read each line from the input file.

    while( $input_line = <STDIN> )
    {
        chomp( $input_line );
        if ( ( $dashrep_replacement{ "dashrep_internal-linewise-trace-on-or-off" } eq "on" ) && ( $input_line =~ /[^ ]/ ) )
        {
            print "{{trace; linewise input line: " . $input_line . "}}\n" ;
        }


#-----------------------------------------------
#  If there are Dashrep definitions, get them.

        if ( $input_line =~ /^ *dashrep-definitions-begin *$/ )
        {
            while( $input_line = <STDIN> )
            {
                chomp( $input_line );
                if ( $input_line =~ /^ *dashrep-definitions-end *$/ )
                {
                    last;
                }
                $all_lines .= $input_line . " " ;
            }
            $numeric_return_value = &dashrep_import_replacements( $all_lines );
            if ( ( $dashrep_replacement{ "dashrep_internal-linewise-trace-on-or-off" } eq "on" ) && ( $input_line =~ /[^ ]/ ) )
            {
                print "{{trace; definition line: " . $input_line . "}}\n" ;
            }


#-----------------------------------------------
#  Otherwise, translate this line by itself.

        } else
        {
            $revised_text = &dashrep_expand_parameters( $input_line );
            if ( ( $dashrep_replacement{ "dashrep_internal-linewise-trace-on-or-off" } eq "on" ) && ( $revised_text =~ /[^ ]/ ) )
            {
                print "{{trace; line after parameters expanded: " . $revised_text . "}}\n" ;
            }
            $revised_text = &dashrep_expand_phrases( $revised_text );
            if ( ( $dashrep_replacement{ "dashrep_internal-linewise-trace-on-or-off" } eq "on" ) && ( $revised_text =~ /[^ ]/ ) )
            {
                print "{{trace; line after phrases expanded: " . $revised_text . "}}\n" ;
            }
            $output_text = &dashrep_top_level_action( $revised_text );
            print $output_text . "\n" ;
        }


#-----------------------------------------------
#  Repeat the loop for the next line.

    }


#-----------------------------------------------
#  End of subroutine.

    return $error_message ;

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
    warn "Too many cycles of replacement.\n" . "Hyphenated phrase with highest replacement count (" . $highest_usage_counter . ") is:\n" . "    " . $highest_usage_item_name . "" ;


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

Richard Fobes, "CPSolver" at GitHub.com


=head1 DOCUMENTATION

See www.Dashrep.org for details about the Dashrep language.


=head1 BUGS

Please report any bugs or feature requests to "CPSolver" at GitHub.com.


=head1 TO DO

See www.Dashrep.org for descriptions of possible future developments.


=head1 ACKNOWLEDGEMENTS

Richard Fobes designed the Dashrep (TM) language and
developed the original version of this code over a
period of many years.  Richard Fobes is the author
of the book titled The Creative Problem Solver's Toolbox.


=head1 COPYRIGHT & LICENSE

Copyright 2009, 2011 Richard Fobes at www.Dashrep.org, all rights reserved.

You can redistribute and/or modify this library module
under the Perl Artistic license, a copy
of which is included in the LICENSE file.

Conversions of this code into other languages are also
covered by the above license terms.

The Dashrep (TM) name is trademarked by Richard Fobes at
www.Dashrep.org to prevent the name from being co-opted.

The Dashrep (TM) language is in the public domain.

=cut

1; # End of package
