package dashrep_translate;

#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# package Language::Dashrep;

# use 5.010;
# use warnings;
# use strict;
# use Carp;
# require Exporter;

#  uncomment-for-cpan-version-end


=head1 NAME

Language::Dashrep - Dashrep language translator/interpreter

=cut


=head1 VERSION

Version 4.00

=cut

#  uncomment-for-cpan-version-begin
# our $VERSION = '4.00';


#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
=head1 SYNOPSIS

The following sample code executes the Dashrep-language actions specified in the standard input file.

    use dashrep_translate;
    &dashrep_translate::dashrep_linewise_translate( );

The following sample code implements a Dashrep web framework, which allows the interactive portion of a website to be written in the Dashrep language.  (The "cgi_to_dashrep_replacements" module is available on GitHub in the CPSolver account.)  The web page is not returned by the first function call because the beginning portion of a web page has very rigorous requirements.

    use dashrep_translate;
    use cgi_to_dashrep_replacements;
    $should_be_empty = &dashrep_translate::dashrep_expand_parameters( '[-dashrep-path-prefix-for-file-reading = /home/username/dashrepcode/ -][-get-definitions-from-file dashrepcode.txt-][-start-here-]' ) ;
    $web_page = &dashrep_translate::dashrep_get_replacement( 'generated-web-page' ) ;
    print $web_page ;
    $should_be_empty = &dashrep_translate::dashrep_expand_parameters( '[-do-after-sending-web-page-]' ) ;

The module also supports direct access to functions that define Dashrep phrases, expand text that contains Dashrep phrases, and more.

=cut


#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# =head1 SYNOPSIS
#
# The following sample code executes the Dashrep-language actions specified in the standard input file.
#
#    use Language::Dashrep;
#    &Dashrep::dashrep_linewise_translate( );
#
# The module also supports direct access to functions that define Dashrep phrases, expand text that contains Dashrep phrases, and more.
#
# =cut
#
#
#  uncomment-for-cpan-version-end
=head1 ABOUT

Dashrep (TM) is a versatile descriptive programming language that recognizes hyphenated phrases, such as B<rectangle-outline-attention-begin>, and recursively expands the phrases to generate an HTML web page, an XML file, a JavaScript program, a boilerplate-based document, a template-based email message, or any other text-based content.

See www.Dashrep.org for details about the Dashrep language.

The Dashrep language implements branching by using parameterized hyphenated phrases such as B<[-template-for-move-proposal-link-for-action-[-output-requested-action-]-]>. The language also provides a simple "if-then-else" functionality that handles simple cases in which branching involves only two branches.

The Dashrep language has actions that make it easy to generate and manipulate lists, where the list contains space-delimited words. These lists can be used as values that can be accessed within loops, which are always invoked using the same simple action.

The Dashrep language has been used to convert text files into MML- and XML-format files (for two books, I<The Creative Problem Solver's Toolbox> and I<Ending The Hidden Unfairness In U.S. Elections>), specify dynamically generated HTML pages (at www.VoteFair.org and www.NegotiationTool.com), generate JavaScript code (that Adobe Illustrator executed to generate vector graphics for use in the book I<Ending The Hidden Unfairness In U.S. Elections>), generate invoices and packing slips, expand boilerplate-like text, and more.

The design goals for the Dashrep language were:

=over

=item * Provide a convenient way to move descriptive code out of executable code.

=item * Keep it simple, and keep it flexible.

=item * Make the language speakable.  (This characteristic is useful for various purposes, including circumventing keyboard-induced repetitive-stress injury, and using microphone-equipped mobile devices.)

Note about Version 2 and later: These versions, if they are from GitHub instead of CPAN, can be used without the CPAN envioronment.  The GitHub version only needs the Perl interpreter, which means that on the Windows operating system only the I<perl.exe> and I<perl512.dll> and I<libgcc_s_sjlj-1.dll> files (or their more-recent equivalents) are needed.

=back

=cut


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

=head2 dashrep_xml_tags_to_dashrep

=head2 dashrep_linewise_translate

=head2 dashrep_compiler_access

=cut


#  uncomment-for-cpan-version-begin
# our @ISA = qw(Exporter);
# our @EXPORT = qw(
#     dashrep_define
#     dashrep_import_replacements
#     dashrep_get_replacement
#     dashrep_get_list_of_phrases
#     dashrep_delete
#     dashrep_delete_all
#     dashrep_expand_parameters
#     dashrep_expand_phrases
#     dashrep_expand_phrases_except_special
#     dashrep_expand_special_phrases
#     dashrep_xml_tags_to_dashrep
#     dashrep_linewise_translate
#     dashrep_compiler_access
# );


#  uncomment-for-cpan-version-end
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

my $global_true ;
my $global_false ;
my $global_endless_loop_counter ;
my $global_endless_loop_counter_limit ;
my $global_time_limit ;
my $global_starting_time ;
my $global_interval_count_for_time_limit_check ;
my $global_nesting_level_of_file_actions ;
my $global_recursion_level_of_expand_parameters ;
my $global_xml_level_number ;
my $global_xml_accumulated_sequence_of_tag_names ;
my $global_spaces ;
my $global_ignore_level ;
my $global_capture_level ;
my $global_xml_level ;
my $global_phrase_to_insert_after_next_top_level_line ;
my $global_top_line_count_for_insert_phrase ;
my $global_trace_log ;
my $global_dashrep_text_list_of_actions_and_special_phrases ;
my $global_dashrep_text_list_of_phrase_categories ;
my $global_dashrep_text_list_of_phrases_fundamental ;
my $global_dashrep_text_list_of_phrases_decision ;
my $global_dashrep_text_list_of_phrases_numeric ;
my $global_dashrep_text_list_of_phrases_time ;
my $global_dashrep_text_list_of_phrases_character ;
my $global_dashrep_text_list_of_phrases_word ;
my $global_dashrep_text_list_of_phrases_generate_list ;
my $global_dashrep_text_list_of_phrases_copy_append ;
my $global_dashrep_text_list_of_phrases_file_related ;
my $global_dashrep_text_list_of_phrases_advanced ;
my $global_dashrep_text_list_of_spoken_words ;
my $global_dashrep_text_list_of_phrases_uncategorized ;
my $global_unique_value ;
my $global_storage_number ;
my $global_file_write_protection_mode ;
my $global_file_public_read_protection_mode ;
my $global_dashrep_text_list_of_phrase_names ;
my $global_action_name ;
my $global_operand_one ;
my $global_operand_two ;
my $global_operand_three ;
my $global_operand_four ;
my $global_operand_five ;
my $global_operands_all ;
my $global_action_result ;
my $global_single_action_name ;
my $global_single_action_operand_one ;
my $global_single_action_operand_two ;
my $global_single_action_operand_three ;
my $global_single_action_operand_four ;
my $global_single_action_operand_five ;
my $global_single_action_operands_all ;
my $global_list_of_action_names_as_text ;
my $global_list_of_predefined_phrases_as_text ;
my $global_list_of_special_names_as_text ;
my $global_list_of_deprecated_phrases_as_text ;
my %global_dashrep_replacement ;
my %global_replacement_count_for_item_name ;
my %global_exists_xml_hyphenated_phrase ;
my %global_check_operand_one_phrase_is_not_empty_for_action ;
my %global_check_operand_two_phrase_is_not_empty_for_action ;
my %global_check_operand_three_phrase_is_not_empty_for_action ;
my %global_check_operand_two_is_positive_integer_for_action ;
my %global_check_operand_three_is_positive_integer_for_action ;
my %global_check_operand_four_is_positive_integer_for_action ;
my %global_check_operand_one_is_positive_integer_for_action ;
my %global_check_operand_one_is_real_number_for_action ;
my %global_check_operand_two_is_real_number_for_action ;
my %global_check_operand_one_is_phrase_name_for_action ;
my %global_check_operand_two_is_phrase_name_for_action ;
my %global_check_operand_three_is_phrase_name_for_action ;
my %global_check_operand_four_is_phrase_name_for_action ;
my %global_check_operand_five_is_phrase_name_for_action ;
my %global_check_operand_one_is_file_name_for_action ;
my %global_check_operand_two_is_file_name_for_action ;
my @global_list_of_lists_to_generate ;
my @global_xml_tag_at_level_number ;
my @global_required_number_of_operands_for_action ;
my @global_minimum_number_of_operands_for_action ;


#-----------------------------------------------
#  Define package constants, and initialize
#  special phrases.

BEGIN {
    my $phrase_name ;

    $global_true = 1 ;
    $global_false = 0 ;
    $global_endless_loop_counter = 0 ;
    $global_endless_loop_counter_limit = 70000 ;
    $global_time_limit = 1200 ;  # 1200 seconds = 20 minutes
    $global_starting_time = time ;
    $global_interval_count_for_time_limit_check = 0 ;
    $global_xml_accumulated_sequence_of_tag_names = "" ;
    $global_spaces = "                                                                              " ;
    $global_nesting_level_of_file_actions = 0 ;
    $global_recursion_level_of_expand_parameters = 0 ;
    $global_ignore_level = 0 ;
    $global_capture_level = 0 ;
    $global_xml_level_number = 0 ;
    $global_trace_log = "" ;
    $global_unique_value = 0 ;
    $global_storage_number = 1 ;
    $global_single_action_name = "" ;
    $global_single_action_operand_one = "" ;
    $global_single_action_operand_two = "" ;
    $global_single_action_operand_three = "" ;
    $global_single_action_operand_four = "" ;
    $global_single_action_operand_five = "" ;
    $global_single_action_operands_all = "" ;
    $global_file_write_protection_mode = 0600 ;  # octal number that specifies no "world" read access
    $global_file_public_read_protection_mode = 0644 ;  # octal number that specifies public "world" read access
    %global_replacement_count_for_item_name = ( ) ;
    @global_list_of_lists_to_generate = ( ) ;
    @global_xml_tag_at_level_number = ( ) ;

    %global_dashrep_replacement = ( ) ;

    $global_dashrep_replacement{ "dashrep-version" } = "4.00" ;
    $global_dashrep_replacement{ "empty-text" } = "" ;
    $global_dashrep_replacement{ "character-space" } = " " ;
    $global_dashrep_replacement{ "character-hyphen" } = "-" ;
    $global_dashrep_replacement{ "character-newline" } = "\n" ;
    $global_dashrep_replacement{ "character-open-square-bracket" } = "[" ;
    $global_dashrep_replacement{ "character-close-square-bracket" } = "]" ;
    $global_dashrep_replacement{ "character-tab" } = "\t" ;
    $global_dashrep_replacement{ "four-hyphens" } = "----" ;
    $global_dashrep_replacement{ "dashrep-path-prefix-for-file-reading" } = "" ;
    $global_dashrep_replacement{ "dashrep-path-prefix-for-file-writing" } = "" ;
    $global_dashrep_replacement{ "yes-or-no-permission-to-delete-or-overwrite-files" } = "yes" ;
    $global_dashrep_replacement{ "yes-or-no-permission-to-append-to-files" } = "yes" ;
    $global_dashrep_replacement{ "dashrep-comments-ignored" } = "" ;
    $global_dashrep_replacement{ "dashrep-endless-loop-counter-limit" } = "" ;
    $global_dashrep_replacement{ "dashrep-time-limit" } = "1200" ;
    $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } = "yes" ;
    $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-xml-level-reset-if-zero" } = "" ;
    $global_dashrep_replacement{ "dashrep-first-xml-tag-name" } = "" ;
    $global_dashrep_replacement{ "yes-or-no-export-delimited-definitions" } = "" ;
    $global_dashrep_replacement{ "dashrep-stop-translation" } = "" ;
    $global_dashrep_replacement{ "non-breaking-space" } = "&nbsp;" ;
    $global_dashrep_replacement{ "list-of-phrases-newly-defined" } = "" ;
    $global_dashrep_replacement{ "dashrep-undefined" } = "dashrep_undefined" ;
    $global_dashrep_replacement{ "dashrep-gather-tag-begin" } = "entry_begin" ;
    $global_dashrep_replacement{ "dashrep-gather-tag-end" } = "entry_end" ;
    $global_dashrep_replacement{ "dashrep-gather-tag-unique" } = "url" ;
    $global_dashrep_replacement{ "dashrep-gather-tag-matching-id" } = "1" ;
    $global_dashrep_replacement{ "dashrep-gather-tag-delete" } = "delete_id" ;
    $global_dashrep_replacement{ "dashrep-recent-phrase-name-replaced" } = "" ;
    $global_dashrep_replacement{ "yes-or-no-use-slower-subset-expand" } = "no" ;
    $global_dashrep_replacement{ "yes-or-no-expand-special-phrases" } = "yes" ;
    $global_dashrep_replacement{ "dashrep-language-yes" } = "yes" ;
    $global_dashrep_replacement{ "list-of-unique-word-counts" } = "" ;
    $global_dashrep_replacement{ "list-of-pointers-to-unique-words" } = "" ;
    $global_dashrep_replacement{ "dashrep-list-of-compiled-executable-phrases" } = "" ;

    $global_list_of_predefined_phrases_as_text = "" ;
    foreach $phrase_name ( keys( %global_dashrep_replacement ) )
    {
        if ( $global_list_of_predefined_phrases_as_text ne "" )
        {
            $global_list_of_predefined_phrases_as_text .= " " ;
        }
        $global_list_of_predefined_phrases_as_text .= " " . $phrase_name ;
    }

    $global_required_number_of_operands_for_action{ "clear-phrase" } = 1 ;
    $global_required_number_of_operands_for_action{ "clear-listed-phrases" } = 1 ;
    $global_required_number_of_operands_for_action{ "delete-listed-phrases" } = 1 ;
    $global_required_number_of_operands_for_action{ "delete-all-dashrep-phrases" } = 0 ;
    $global_required_number_of_operands_for_action{ "append-text" } = 2 ;
    $global_required_number_of_operands_for_action{ "append-text-no-space" } = 2 ;
    $global_required_number_of_operands_for_action{ "append-repeatedly-using-count" } = 3 ;
    $global_required_number_of_operands_for_action{ "prepend-text" } = 2 ;
    $global_required_number_of_operands_for_action{ "prepend-text-no-space" } = 2 ;
    $global_required_number_of_operands_for_action{ "append-new-line" } = 1 ;
    $global_required_number_of_operands_for_action{ "copy-listed-words-to-phrases-named-in-pattern" } = 2 ;
    $global_required_number_of_operands_for_action{ "append-multiple-from-phrases-named-in-pattern" } = 2 ;
    $global_required_number_of_operands_for_action{ "copy-text" } = 2 ;
    $global_required_number_of_operands_for_action{ "copy-without-extra-spaces" } = 2 ;
    $global_required_number_of_operands_for_action{ "copy-lowercase-only" } = 2 ;
    $global_required_number_of_operands_for_action{ "copy-uppercase-only" } = 2 ;
    $global_required_number_of_operands_for_action{ "copy-initial-caps" } = 2 ;
    $global_required_number_of_operands_for_action{ "copy-words-sort-numeric" } = 2 ;
    $global_required_number_of_operands_for_action{ "copy-words-sort-alphabetic" } = 2 ;
    $global_required_number_of_operands_for_action{ "encode-as-cgi-parameter" } = 2 ;
    $global_required_number_of_operands_for_action{ "decode-from-cgi-parameter" } = 2 ;
    $global_required_number_of_operands_for_action{ "convert-into-spoken-dashrep-code" } = 2 ;
    $global_required_number_of_operands_for_action{ "convert-from-spoken-dashrep-code" } = 2 ;
    $global_required_number_of_operands_for_action{ "convert-unicode-to-html-entities" } = 2 ;
    $global_required_number_of_operands_for_action{ "xml-move-attributes-into-tag-elements" } = 1 ;
    $global_required_number_of_operands_for_action{ "copy-and-remove-attributes-from-xml-tags" } = 2 ;
    $global_required_number_of_operands_for_action{ "insert-angle-bracketed-definitions" } = 1 ;
    $global_required_number_of_operands_for_action{ "copy-word-at-position" } = 3 ;
    $global_required_number_of_operands_for_action{ "copy-zero-pad-left-to-length" } = 3 ;
    $global_required_number_of_operands_for_action{ "copy-words-rearrange-using-order-sort-alphabetic" } = 3 ;
    $global_required_number_of_operands_for_action{ "copy-words-rearrange-using-order-sort-numeric" } = 3 ;
    $global_required_number_of_operands_for_action{ "copy-and-replace" } = 4 ;
    $global_required_number_of_operands_for_action{ "copy-characters-from-position-to-position" } = 4 ;
    $global_required_number_of_operands_for_action{ "copy-and-replace-using-paired-listed-words" } = 3 ;
    $global_required_number_of_operands_for_action{ "expand-text" } = 2 ;
    $global_required_number_of_operands_for_action{ "get-phrase-definition-without-expanding" } = 1 ;
    $global_required_number_of_operands_for_action{ "expand-parameters-only" } = 2 ;
    $global_required_number_of_operands_for_action{ "numeric-equal-greater-less-compare" } = 2 ;
    $global_required_number_of_operands_for_action{ "if-yes-begin" } = 1 ;
    $global_required_number_of_operands_for_action{ "if-no-begin" } = 1 ;
    $global_required_number_of_operands_for_action{ "if-else" } = 0 ;
    $global_required_number_of_operands_for_action{ "if-end" } = 0 ;
    $global_required_number_of_operands_for_action{ "get-word-at-position" } = 2 ;
    $global_required_number_of_operands_for_action{ "copy-words-from-position-to-position" } = 4 ;
    $global_required_number_of_operands_for_action{ "copy-words-order-reversed" } = 2 ;
    $global_required_number_of_operands_for_action{ "get-count-of-words" } = 1 ;
    $global_required_number_of_operands_for_action{ "yes-or-no-word-is-in-phrase" } = 2 ;
    $global_required_number_of_operands_for_action{ "get-position-of-word" } = 2 ;
    $global_required_number_of_operands_for_action{ "get-position-of-matching-text" } = 2 ;
    $global_required_number_of_operands_for_action{ "generate-positions-of-delimiter" } = 3 ;
    $global_required_number_of_operands_for_action{ "generate-positions-of-first-matching-delimiter-after-listed-positions" } = 4 ;
    $global_required_number_of_operands_for_action{ "generate-positions-of-listed-words" } = 3 ;
    $global_required_number_of_operands_for_action{ "generate-counts-from-integer-to-integer" } = 3 ;
    $global_required_number_of_operands_for_action{ "copy-words-that-begin-with-text" } = 3 ;
    $global_required_number_of_operands_for_action{ "copy-words-that-contain-listed-words" } = 3 ;
    $global_required_number_of_operands_for_action{ "copy-words-that-begin-with-listed-words" } = 3 ;
    $global_required_number_of_operands_for_action{ "generate-every-pairwise-combination-of-words" } = 4 ;
    $global_required_number_of_operands_for_action{ "generate-every-ordered-pairwise-combination-of-words" } = 4 ;
    $global_required_number_of_operands_for_action{ "zero-one-multiple" } = 1 ;
    $global_required_number_of_operands_for_action{ "zero-or-nonzero" } = 1 ;
    $global_required_number_of_operands_for_action{ "get-count-of-characters" } = 1 ;
    $global_required_number_of_operands_for_action{ "numeric-increment" } = 1 ;
    $global_required_number_of_operands_for_action{ "numeric-decrement" } = 1 ;
    $global_required_number_of_operands_for_action{ "yes-or-no-same-two-phrase-definitions" } = 2 ;
    $global_required_number_of_operands_for_action{ "get-characters-from-position-to-position" } = 3 ;
    $global_required_number_of_operands_for_action{ "numeric-minus" } = 2 ;
    $global_required_number_of_operands_for_action{ "numeric-divide-by" } = 2 ;
    $global_required_number_of_operands_for_action{ "numeric-absolute" } = 1 ;
    $global_required_number_of_operands_for_action{ "numeric-integer" } = 1 ;
    $global_required_number_of_operands_for_action{ "numeric-sine" } = 1 ;
    $global_required_number_of_operands_for_action{ "numeric-cosine" } = 1 ;
    $global_required_number_of_operands_for_action{ "numeric-logarithm-base-e" } = 1 ;
    $global_required_number_of_operands_for_action{ "numeric-logarithm-base-10" } = 1 ;
    $global_required_number_of_operands_for_action{ "numeric-vector-add-number" } = 3 ;
    $global_required_number_of_operands_for_action{ "numeric-vector-multiply-by-number" } = 3 ;
    $global_required_number_of_operands_for_action{ "numeric-vectors-add" } = 3 ;
    $global_required_number_of_operands_for_action{ "numeric-vectors-multiply" } = 3 ;
    $global_required_number_of_operands_for_action{ "numeric-vectors-divide-by" } = 3 ;
    $global_required_number_of_operands_for_action{ "numeric-vector-integers" } = 2 ;
    $global_required_number_of_operands_for_action{ "numeric-vector-absolutes" } = 2 ;
    $global_required_number_of_operands_for_action{ "numeric-vectors-from-delta-values-calculate-distances" } = 3 ;
    $global_required_number_of_operands_for_action{ "numeric-pi" } = 0 ;
    $global_required_number_of_operands_for_action{ "numeric-y-map-tile-number-based-on-latitude" } = 1 ;
    $global_required_number_of_operands_for_action{ "numeric-two-dimensional-sort-into-columns-and-rows" } = 4 ;
    $global_required_number_of_operands_for_action{ "get-current-time-in-epoch-seconds" } = 0 ;
    $global_required_number_of_operands_for_action{ "split-epoch-seconds-into-named-components" } = 1 ;
    $global_required_number_of_operands_for_action{ "split-epoch-seconds-into-named-components-for-zero-meridian" } = 1 ;
    $global_required_number_of_operands_for_action{ "use-handler-with-each-word-in-phrase" } = 2 ;
    $global_required_number_of_operands_for_action{ "use-handler-with-each-word-in-phrase-currently-at-character-position" } = 3 ;
    $global_required_number_of_operands_for_action{ "insert-codeview-tags" } = 1 ;
    $global_required_number_of_operands_for_action{ "escape-from-dashrep" } = 0 ;
    $global_required_number_of_operands_for_action{ "resume-after-escape-from-dashrep" } = 0 ;
    $global_required_number_of_operands_for_action{ "trace-show" } = 1 ;
    $global_required_number_of_operands_for_action{ "generate-phrase-usage-counts" } = 1 ;
    $global_required_number_of_operands_for_action{ "copy-words-found-in-both-lists" } = 3 ;
    $global_required_number_of_operands_for_action{ "copy-words-found-only-in-first-list" } = 3 ;
    $global_required_number_of_operands_for_action{ "copy-words-found-in-either-list" } = 3 ;
    $global_required_number_of_operands_for_action{ "copy-from-file-to-phrase" } = 2 ;
    $global_required_number_of_operands_for_action{ "copy-append-file-to-file" } = 2 ;
    $global_required_number_of_operands_for_action{ "find-line-in-file-that-begins-with-text" } = 3 ;
    $global_required_number_of_operands_for_action{ "find-lines-in-file-that-begin-with-any-listed-word" } = 3 ;
    $global_required_number_of_operands_for_action{ "find-lines-in-file-that-begin-with-any-two-words-listed" } = 3 ;
    $global_required_number_of_operands_for_action{ "get-definitions-from-file" } = 1 ;
    $global_required_number_of_operands_for_action{ "generate-list-of-files-in-current-read-directory" } = 1 ;
    $global_required_number_of_operands_for_action{ "generate-list-of-folders-in-current-read-directory" } = 1 ;
    $global_required_number_of_operands_for_action{ "yes-or-no-file-exists" } = 1 ;
    $global_required_number_of_operands_for_action{ "yes-or-no-folder-exists" } = 1 ;
    $global_required_number_of_operands_for_action{ "modification-time-of-file" } = 1 ;
    $global_required_number_of_operands_for_action{ "set-file-permission-public-read" } = 1 ;
    $global_required_number_of_operands_for_action{ "size-of-file" } = 1 ;
    $global_required_number_of_operands_for_action{ "copy-from-phrase-append-to-file" } = 2 ;
    $global_required_number_of_operands_for_action{ "rename-file" } = 2 ;
    $global_required_number_of_operands_for_action{ "delete-file" } = 1 ;
    $global_required_number_of_operands_for_action{ "create-empty-file" } = 1 ;
    $global_required_number_of_operands_for_action{ "create-empty-sub-folder" } = 1 ;
    $global_required_number_of_operands_for_action{ "copy-from-columns-in-file-to-named-phrases" } = 3 ;
    $global_required_number_of_operands_for_action{ "copy-from-columns-in-file-to-column-lists" } = 2 ;
    $global_required_number_of_operands_for_action{ "gather-tagged-info-from-file" } = 2 ;
    $global_required_number_of_operands_for_action{ "write-gathered-listed-items-to-end-of-file" } = 2 ;
    $global_required_number_of_operands_for_action{ "gather-from-tagged-file-one-entry" } = 2 ;
    $global_required_number_of_operands_for_action{ "linewise-read-from-file-and-use-handler" } = 2 ;
    $global_required_number_of_operands_for_action{ "write-all-dashrep-definitions-to-file" } = 1 ;
    $global_required_number_of_operands_for_action{ "generate-list-of-all-dashrep-phrases" } = 1 ;
    $global_required_number_of_operands_for_action{ "write-dashrep-definitions-listed-in-phrase-to-file" } = 2 ;
    $global_required_number_of_operands_for_action{ "unique-value" } = 0 ;
    $global_required_number_of_operands_for_action{ "numeric-odd-or-even" } = 1 ;
    $global_required_number_of_operands_for_action{ "copy-words-unique-only" } = 2 ;
    $global_required_number_of_operands_for_action{ "dashrep-compiler-write-phrase-definition" } = 1 ;

    $global_minimum_number_of_operands_for_action{ "numeric-add" } = 1 ;
    $global_minimum_number_of_operands_for_action{ "numeric-multiply" } = 1 ;
    $global_minimum_number_of_operands_for_action{ "numeric-maximum" } = 1 ;
    $global_minimum_number_of_operands_for_action{ "numeric-minimum" } = 1 ;
    $global_minimum_number_of_operands_for_action{ "copy-to-phrase-from-following-text" } = 2 ;
    $global_minimum_number_of_operands_for_action{ "put-into-phrase" } = 2 ;

    $global_minimum_number_of_operands_for_action{ "yes-or-no-empty-phrase" } = 1 ;
    $global_minimum_number_of_operands_for_action{ "yes-or-no-opposite" } = 0 ;
    $global_minimum_number_of_operands_for_action{ "yes-or-no-same-two-words" } = 0 ;
    $global_minimum_number_of_operands_for_action{ "yes-if-all-yes" } = 0 ;
    $global_minimum_number_of_operands_for_action{ "yes-if-not-no" } = 0 ;
    $global_minimum_number_of_operands_for_action{ "no-if-not-yes" } = 0 ;
    $global_minimum_number_of_operands_for_action{ "yes-if-any-yes" } = 0 ;
    $global_minimum_number_of_operands_for_action{ "no-if-any-no" } = 0 ;

    $global_check_operand_one_phrase_is_not_empty_for_action{ "use-handler-with-each-word-in-phrase" } = "yes" ;
    $global_check_operand_two_phrase_is_not_empty_for_action{ "use-handler-with-each-word-in-phrase" } = "yes" ;
    $global_check_operand_one_phrase_is_not_empty_for_action{ "numeric-vector-add-number" } = "yes" ;
    $global_check_operand_one_phrase_is_not_empty_for_action{ "numeric-vector-multiply-by-number" } = "yes" ;
    $global_check_operand_one_phrase_is_not_empty_for_action{ "copy-listed-words-to-phrases-named-in-pattern" } = "yes" ;
    $global_check_operand_one_phrase_is_not_empty_for_action{ "append-multiple-in-phrase-to-phrases-named-in-pattern" } = "yes" ;
    $global_check_operand_one_phrase_is_not_empty_for_action{ "generate-every-pairwise-combination-of-words" } = "yes" ;
    $global_check_operand_two_phrase_is_not_empty_for_action{ "generate-every-pairwise-combination-of-words" } = "yes" ;
    $global_check_operand_one_phrase_is_not_empty_for_action{ "generate-every-ordered-pairwise-combination-of-words" } = "yes" ;
    $global_check_operand_two_phrase_is_not_empty_for_action{ "generate-every-ordered-pairwise-combination-of-words" } = "yes" ;
    $global_check_operand_two_phrase_is_not_empty_for_action{ "numeric-two-dimensional-sort-into-columns-and-rows" } = "yes" ;
    $global_check_operand_three_phrase_is_not_empty_for_action{ "numeric-two-dimensional-sort-into-columns-and-rows" } = "yes" ;
    $global_check_operand_two_phrase_is_not_empty_for_action{ "find-line-in-file-that-begins-with-text" } = "yes" ;
    $global_check_operand_two_phrase_is_not_empty_for_action{ "find-lines-in-file-that-begin-with-any-listed-word" } = "yes" ;
    $global_check_operand_two_phrase_is_not_empty_for_action{ "find-lines-in-file-that-begin-with-any-two-words-listed" } = "yes" ;
    $global_check_operand_one_phrase_is_not_empty_for_action{ "copy-from-phrase-append-to-file" } = "yes" ;
    $global_check_operand_two_phrase_is_not_empty_for_action{ "linewise-read-from-file-and-use-handler" } = "yes" ;
    $global_check_operand_one_phrase_is_not_empty_for_action{ "write-dashrep-definitions-listed-in-phrase-to-file" } = "yes" ;
    $global_check_operand_one_phrase_is_not_empty_for_action{ "get-word-at-position" } = "yes" ;
    $global_check_operand_three_phrase_is_not_empty_for_action{ "copy-and-replace" } = "yes" ;
    $global_check_operand_three_phrase_is_not_empty_for_action{ "copy-and-replace-using-paired-listed-words" } = "yes" ;
    $global_check_operand_two_phrase_is_not_empty_for_action{ "get-position-of-word" } = "yes" ;
    $global_check_operand_one_phrase_is_not_empty_for_action{ "generate-positions-of-delimiter" } = "yes" ;
    $global_check_operand_one_phrase_is_not_empty_for_action{ "generate-positions-of-first-matching-delimiter-after-listed-positions" } = "yes" ;
    $global_check_operand_one_phrase_is_not_empty_for_action{ "generate-positions-of-listed-words" } = "yes" ;
    $global_check_operand_two_phrase_is_not_empty_for_action{ "generate-positions-of-delimiter" } = "yes" ;
    $global_check_operand_two_phrase_is_not_empty_for_action{ "generate-positions-of-first-matching-delimiter-after-listed-positions" } = "yes" ;
    $global_check_operand_three_phrase_is_not_empty_for_action{ "copy-words-that-begin-with-text" } = "yes" ;
    $global_check_operand_three_phrase_is_not_empty_for_action{ "copy-words-that-contain-listed-words" } = "yes" ;
    $global_check_operand_three_phrase_is_not_empty_for_action{ "copy-words-that-begin-with-listed-words" } = "yes" ;

    $global_check_operand_two_is_positive_integer_for_action{ "get-word-at-position" } = "yes" ;
    $global_check_operand_three_is_positive_integer_for_action{ "copy-word-at-position" } = "yes" ;
    $global_check_operand_three_is_positive_integer_for_action{ "copy-zero-pad-left-to-length" } = "yes" ;
    $global_check_operand_three_is_positive_integer_for_action{ "copy-characters-from-position-to-position" } = "yes" ;
    $global_check_operand_four_is_positive_integer_for_action{ "copy-characters-from-position-to-position" } = "yes" ;
    $global_check_operand_three_is_positive_integer_for_action{ "copy-words-from-position-to-position" } = "yes" ;
    $global_check_operand_four_is_positive_integer_for_action{ "copy-words-from-position-to-position" } = "yes" ;
    $global_check_operand_one_is_positive_integer_for_action{ "zero-one-multiple" } = "yes" ;
    $global_check_operand_one_is_positive_integer_for_action{ "zero-or-nonzero" } = "yes" ;
    $global_check_operand_two_is_positive_integer_for_action{ "get-characters-from-position-to-position" } = "yes" ;
    $global_check_operand_three_is_positive_integer_for_action{ "get-characters-from-position-to-position" } = "yes" ;
    $global_check_operand_one_is_positive_integer_for_action{ "numeric-two-dimensional-sort-into-columns-and-rows" } = "yes" ;
    $global_check_operand_three_is_positive_integer_for_action{ "append-repeatedly-using-count" } = "yes" ;
    $global_check_operand_three_is_positive_integer_for_action{ "use-handler-with-each-word-in-phrase-currently-at-character-position" } = "yes" ;

    $global_check_operand_one_is_real_number_for_action{ "numeric-equal-greater-less-compare" } = "yes" ;
    $global_check_operand_two_is_real_number_for_action{ "numeric-equal-greater-less-compare" } = "yes" ;
    $global_check_operand_one_is_real_number_for_action{ "numeric-minus" } = "yes" ;
    $global_check_operand_two_is_real_number_for_action{ "numeric-minus" } = "yes" ;
    $global_check_operand_one_is_real_number_for_action{ "numeric-divide-by" } = "yes" ;
    $global_check_operand_two_is_real_number_for_action{ "numeric-divide-by" } = "yes" ;
    $global_check_operand_one_is_real_number_for_action{ "numeric-absolute" } = "yes" ;
    $global_check_operand_one_is_real_number_for_action{ "numeric-integer" } = "yes" ;
    $global_check_operand_one_is_real_number_for_action{ "numeric-odd-or-even" } = "yes" ;
    $global_check_operand_one_is_real_number_for_action{ "numeric-sine" } = "yes" ;
    $global_check_operand_one_is_real_number_for_action{ "numeric-cosine" } = "yes" ;
    $global_check_operand_one_is_real_number_for_action{ "numeric-logarithm-base-e" } = "yes" ;
    $global_check_operand_one_is_real_number_for_action{ "numeric-logarithm-base-10" } = "yes" ;
    $global_check_operand_one_is_real_number_for_action{ "numeric-y-map-tile-number-based-on-latitude" } = "yes" ;
    $global_check_operand_two_is_real_number_for_action{ "numeric-vector-add-number" } = "yes" ;
    $global_check_operand_two_is_real_number_for_action{ "numeric-vector-multiply-by-number" } = "yes" ;
    $global_check_operand_one_is_real_number_for_action{ "split-epoch-seconds-into-named-components" } = "yes" ;

    $global_check_operand_one_is_phrase_name_for_action{ "clear-phrase" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "clear-listed-phrases" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "delete-listed-phrases" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "append-text" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "append-text" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "append-text-no-space" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "append-text-no-space" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "append-repeatedly-using-count" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "append-repeatedly-using-count" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "prepend-text" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "prepend-text" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "prepend-text-no-space" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "prepend-text-no-space" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "append-new-line" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-listed-words-to-phrases-named-in-pattern" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "append-multiple-in-phrase-to-phrases-named-in-pattern" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-text" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-text" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-lowercase-only" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-lowercase-only" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-uppercase-only" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-uppercase-only" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-initial-caps" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-initial-caps" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-without-extra-spaces" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-without-extra-spaces" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-words-sort-numeric" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-words-sort-numeric" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-words-sort-alphabetic" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-words-sort-alphabetic" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "encode-as-cgi-parameter" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "encode-as-cgi-parameter" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "decode-from-cgi-parameter" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "decode-from-cgi-parameter" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "convert-into-spoken-dashrep-code" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "convert-into-spoken-dashrep-code" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "convert-from-spoken-dashrep-code" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "convert-from-spoken-dashrep-code" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "convert-unicode-to-html-entities" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "convert-unicode-to-html-entities" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "xml-move-attributes-into-tag-elements" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-and-remove-attributes-from-xml-tags" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-and-remove-attributes-from-xml-tags" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "insert-angle-bracketed-definitions" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-word-at-position" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-word-at-position" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-words-rearrange-using-order-sort-alphabetic" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-words-rearrange-using-order-sort-alphabetic" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-words-rearrange-using-order-sort-numeric" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-words-rearrange-using-order-sort-numeric" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "copy-words-rearrange-using-order-sort-alphabetic" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "copy-words-rearrange-using-order-sort-numeric" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-zero-pad-left-to-length" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-zero-pad-left-to-length" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-and-replace" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-and-replace" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "copy-and-replace" } = "yes" ;
    $global_check_operand_four_is_phrase_name_for_action{ "copy-and-replace" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-characters-from-position-to-position" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-characters-from-position-to-position" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-and-replace-using-paired-listed-words" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-and-replace-using-paired-listed-words" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "expand-text" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "expand-text" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "expand-parameters-only" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "expand-parameters-only" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "get-phrase-definition-without-expanding" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-words-from-position-to-position" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-words-from-position-to-position" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-words-order-reversed" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-words-order-reversed" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "get-count-of-words" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "get-position-of-matching-text" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "get-position-of-matching-text" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "generate-positions-of-delimiter" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "generate-positions-of-first-matching-delimiter-after-listed-positions" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "generate-positions-of-listed-words" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "generate-positions-of-listed-words" } = "yes" ;
    $global_check_operand_four_is_phrase_name_for_action{ "generate-positions-of-first-matching-delimiter-after-listed-positions" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "generate-counts-from-integer-to-integer" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-words-that-begin-with-text" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-words-that-begin-with-text" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-words-that-contain-listed-words" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-words-that-contain-listed-words" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-words-that-begin-with-listed-words" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-words-that-begin-with-listed-words" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "generate-every-pairwise-combination-of-words" } = "yes" ;
    $global_check_operand_four_is_phrase_name_for_action{ "generate-every-pairwise-combination-of-words" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "generate-every-ordered-pairwise-combination-of-words" } = "yes" ;
    $global_check_operand_four_is_phrase_name_for_action{ "generate-every-ordered-pairwise-combination-of-words" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "get-count-of-characters" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "numeric-increment" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "yes-or-no-same-two-phrase-definitions" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "yes-or-no-same-two-phrase-definitions" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "get-characters-from-position-to-position" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "numeric-vector-add-number" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "numeric-vector-multiply-by-number" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "numeric-vectors-add" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "numeric-vectors-add" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "numeric-vectors-add" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "numeric-vectors-multiply" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "numeric-vectors-multiply" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "numeric-vectors-multiply" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "numeric-vectors-divide-by" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "numeric-vectors-divide-by" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "numeric-vectors-divide-by" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "numeric-vector-integers" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "numeric-vector-absolutes" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "numeric-vector-add-number" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "numeric-vector-multiply-by-number" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "trace-show" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "trace-show" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "generate-phrase-usage-counts" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "insert-codeview-tags" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-from-file-to-phrase" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "find-line-in-file-that-begins-with-text" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "find-lines-in-file-that-begin-with-any-listed-word" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "find-lines-in-file-that-begin-with-any-two-words-listed" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "generate-list-of-files-in-current-read-directory" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "generate-list-of-folders-in-current-read-directory" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "gather-tagged-info-from-file" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "write-gathered-listed-items-to-end-of-file" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "gather-from-tagged-file-one-entry" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-two-phrases-words-found-in-both-to-phrase" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-two-phrases-words-found-in-both-to-phrase" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "copy-two-phrases-words-found-in-both-to-phrase" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-words-found-only-in-first-list" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-words-found-only-in-first-list" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "copy-two-phrases-words-found-in-either-to-phrase" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "copy-two-phrases-words-found-in-either-to-phrase" } = "yes" ;
    $global_check_operand_three_is_phrase_name_for_action{ "copy-two-phrases-words-found-in-either-to-phrase" } = "yes" ;
    $global_check_operand_one_is_phrase_name_for_action{ "generate-list-of-all-dashrep-phrases" } = "yes" ;
    $global_check_operand_two_is_phrase_name_for_action{ "yes-or-no-word-is-in-phrase" } = "yes" ;

    $global_check_operand_one_is_file_name_for_action{ "get-definitions-from-file" } = "yes" ;
    $global_check_operand_one_is_file_name_for_action{ "yes-or-no-file-exists" } = "yes" ;
    $global_check_operand_one_is_file_name_for_action{ "modification-time-of-file" } = "yes" ;
    $global_check_operand_one_is_file_name_for_action{ "set-file-permission-public-read" } = "yes" ;
    $global_check_operand_one_is_file_name_for_action{ "size-of-file" } = "yes" ;
    $global_check_operand_one_is_file_name_for_action{ "delete-file" } = "yes" ;
    $global_check_operand_one_is_file_name_for_action{ "rename-file" } = "yes" ;
    $global_check_operand_one_is_file_name_for_action{ "create-empty-file" } = "yes" ;
    $global_check_operand_one_is_file_name_for_action{ "copy-from-columns-in-file-to-named-phrases" } = "yes" ;
    $global_check_operand_one_is_file_name_for_action{ "copy-from-columns-in-file-to-column-lists" } = "yes" ;
    $global_check_operand_one_is_file_name_for_action{ "gather-tagged-info-from-file" } = "yes" ;
    $global_check_operand_one_is_file_name_for_action{ "gather-from-tagged-file-one-entry" } = "yes" ;
    $global_check_operand_one_is_file_name_for_action{ "linewise-read-from-file-and-use-handler" } = "yes" ;
    $global_check_operand_one_is_file_name_for_action{ "write-all-dashrep-definitions-to-file" } = "yes" ;
    $global_check_operand_one_is_file_name_for_action{ "copy-append-file-to-file" } = "yes" ;
    $global_check_operand_two_is_file_name_for_action{ "copy-append-file-to-file" } = "yes" ;
    $global_check_operand_two_is_file_name_for_action{ "copy-from-phrase-append-to-file" } = "yes" ;
    $global_check_operand_two_is_file_name_for_action{ "rename-file" } = "yes" ;
    $global_check_operand_two_is_file_name_for_action{ "write-dashrep-definitions-listed-in-phrase-to-file" } = "yes" ;
    $global_check_operand_two_is_file_name_for_action{ "write-gathered-listed-items-to-end-of-file" } = "yes" ;

    $global_list_of_action_names_as_text = "" ;
    foreach $phrase_name ( keys( %global_required_number_of_operands_for_action ) )
    {
        if ( $global_list_of_action_names_as_text ne "" )
        {
            $global_list_of_action_names_as_text .= " " ;
        }
        $global_list_of_action_names_as_text .= $phrase_name ;
    }
    foreach $phrase_name ( keys( %global_minimum_number_of_operands_for_action ) )
    {
        if ( $global_list_of_action_names_as_text ne "" )
        {
            $global_list_of_action_names_as_text .= " " ;
        }
        $global_list_of_action_names_as_text .= $phrase_name ;
    }
    $global_list_of_special_names_as_text = "hyphen-here no-space one-space new-line empty-line line-break delayed-nospace delayed-newline dashrep-definitions-begin dashrep-definitions-end dashrep-definition-append-next define-end define-begin yes-or-no-append-not-replace-for-imported-phrases export-defs-all-begin export-defs-all-end export-defs-def-begin export-defs-def-end export-defs-phrase-begin export-defs-phrase-end word-to-use-in-handler time-day-of-month time-day-of-week time-day-of-year time-hour time-minute time-month-number time-second time-year numeric-map-tile-zoom linewise-input-line-from-file linewise-input-line-count dashrep-phrase-prefix-for-imported-phrases dashrep-phrase-suffix-for-imported-phrases yes-or-no-use-two-spaces-as-column-delimiter dashrep-debug-trace-log dashrep-endless-loop-count dashrep-time-limit end-of-line-here yes-or-no-indicate-line-endings dashrep-replacement-results-at-time-of-escape dashrep-list-of-action-names dashrep-list-of-predefined-phrases dashrep-list-of-special-phrases undeleted-phrase" ;
    $global_list_of_deprecated_phrases_as_text = "dashrep-first-xml-tag-name dashrep-xml-level-reset-if-zero dashrep-xml-trace-on-yes-or-no dashrep-xml-yes-ignore-if-no-tag-replacement" ;
    $global_dashrep_replacement{ "dashrep-list-of-predefined-phrases" } = $global_list_of_predefined_phrases_as_text ;
    $global_dashrep_replacement{ "dashrep-list-of-action-names" } = $global_list_of_action_names_as_text ;
    $global_dashrep_replacement{ "dashrep-list-of-special-phrases" } = $global_list_of_special_names_as_text ;
    $global_dashrep_replacement{ "dashrep-list-of-deprecated-phrases" } = $global_list_of_deprecated_phrases_as_text ;
    $global_dashrep_text_list_of_phrase_names = $global_dashrep_replacement{ "dashrep-list-of-predefined-phrases" } . " " . $global_dashrep_replacement{ "dashrep-list-of-action-names" } . " " . $global_dashrep_replacement{ "dashrep-list-of-special-phrases" } . " " . $global_dashrep_replacement{ "dashrep-list-of-deprecated-phrases" } ;
    $global_dashrep_replacement{ "dashrep-list-of-recognized-phrase-names" } = $global_dashrep_text_list_of_phrase_names ;
}


#-----------------------------------------------



=head1 FUNCTIONS


=head2 initialize_special_phrases

Initialize special phrases, especially the ones
with special "dashrep-..." names.

=cut

#-----------------------------------------------
#-----------------------------------------------
#                 initialize_special_phrases
#-----------------------------------------------
#-----------------------------------------------

sub initialize_special_phrases
{
    $global_dashrep_replacement{ "dashrep-version" } = "4.00" ;
    $global_dashrep_replacement{ "empty-text" } = "" ;
    $global_dashrep_replacement{ "character-space" } = " " ;
    $global_dashrep_replacement{ "character-hyphen" } = "-" ;
    $global_dashrep_replacement{ "character-newline" } = "\n" ;
    $global_dashrep_replacement{ "character-open-square-bracket" } = "[" ;
    $global_dashrep_replacement{ "character-close-square-bracket" } = "]" ;
    $global_dashrep_replacement{ "character-tab" } = "\t" ;
    $global_dashrep_replacement{ "four-hyphens" } = "----" ;
    $global_dashrep_replacement{ "dashrep-path-prefix-for-file-reading" } = "" ;
    $global_dashrep_replacement{ "dashrep-path-prefix-for-file-writing" } = "" ;
    $global_dashrep_replacement{ "yes-or-no-permission-to-delete-or-overwrite-files" } = "yes" ;
    $global_dashrep_replacement{ "yes-or-no-permission-to-append-to-files" } = "yes" ;
    $global_dashrep_replacement{ "dashrep-comments-ignored" } = "" ;
    $global_dashrep_replacement{ "dashrep-endless-loop-counter-limit" } = "" ;
    $global_dashrep_replacement{ "dashrep-time-limit" } = "1200" ;
    $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } = "yes" ;
    $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-xml-level-reset-if-zero" } = "" ;
    $global_dashrep_replacement{ "dashrep-first-xml-tag-name" } = "" ;
    $global_dashrep_replacement{ "yes-or-no-export-delimited-definitions" } = "" ;
    $global_dashrep_replacement{ "dashrep-stop-translation" } = "" ;
    $global_dashrep_replacement{ "non-breaking-space" } = "&nbsp;" ;
    $global_dashrep_replacement{ "list-of-phrases-newly-defined" } = "" ;
    $global_dashrep_replacement{ "dashrep-undefined" } = "dashrep_undefined" ;
    $global_dashrep_replacement{ "dashrep-gather-tag-begin" } = "entry_begin" ;
    $global_dashrep_replacement{ "dashrep-gather-tag-end" } = "entry_end" ;
    $global_dashrep_replacement{ "dashrep-gather-tag-unique" } = "url" ;
    $global_dashrep_replacement{ "dashrep-gather-tag-matching-id" } = "1" ;
    $global_dashrep_replacement{ "dashrep-gather-tag-delete" } = "delete_id" ;
    $global_dashrep_replacement{ "dashrep-recent-phrase-name-replaced" } = "" ;
    $global_dashrep_replacement{ "yes-or-no-use-slower-subset-expand" } = "no" ;
    $global_dashrep_replacement{ "yes-or-no-expand-special-phrases" } = "yes" ;
    $global_dashrep_replacement{ "dashrep-language-yes" } = "yes" ;
    $global_dashrep_replacement{ "list-of-unique-word-counts" } = "" ;
    $global_dashrep_replacement{ "list-of-pointers-to-unique-words" } = "" ;

    $global_dashrep_replacement{ "dashrep-list-of-recognized-phrase-names" } = $global_dashrep_text_list_of_phrase_names ;
}


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

    my $phrase_name ;
    my $expanded_text ;


#-----------------------------------------------
#  Do the assignment.

    if ( scalar( @_ ) == 2 )
    {
        $phrase_name = $_[ 0 ] ;
        $expanded_text = $_[ 1 ] ;
        $phrase_name =~ s/^ +// ;
        $phrase_name =~ s/ +$// ;
        $global_dashrep_replacement{ $phrase_name } = $expanded_text ;
    } else
    {
#  remove-from-cpan-version-begin
        warn "Warning: Call to dashrep_define subroutine does not have exactly two parameters." ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#        carp "Warning: Call to dashrep_define subroutine does not have exactly two parameters." ;
#  uncomment-for-cpan-version-end
        return 0 ;
    }


#-----------------------------------------------
#  End of subroutine.

    return 1 ;

}


=head2 dashrep_import_replacements

Parses text that associates Dashrep phrases
with the definitions for those phrases.

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

    my $definition_name ;
    my $definition_value ;
    my $input_string ;
    my $replacements_text_to_import ;
    my $text_before ;
    my $text_including_comment_end ;
    my $text_after ;
    my $do_nothing ;
    my $number_of_replacement_names ;
    my $phrase_prefix ;
    my $phrase_suffix ;
    my $yes_append_not_replace ;
    my $append_next_definition ;
    my $modified_input_string ;
    my @list_of_replacement_strings ;


#-----------------------------------------------
#  Get the text that contains replacement
#  definitions.

    if ( scalar( @_ ) == 1 )
    {
        $replacements_text_to_import = $_[ 0 ] ;
    } else
    {
#  remove-from-cpan-version-begin
        warn "Warning: Call to dashrep_import_replacements subroutine does not have exactly one parameter." ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#        carp "Warning: Call to dashrep_import_replacements subroutine does not have exactly one parameter." ;
#  uncomment-for-cpan-version-end
        return 0 ;
    }
    if ( not( defined( $replacements_text_to_import ) ) )
    {
        $replacements_text_to_import = "" ;
        if ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" )
        {
            $global_trace_log .= "{{trace; imported zero definitions from empty text}}\n" ;
        }
    }


#-----------------------------------------------
#  If the supplied text is empty, indicate this
#  case and return.

    if ( $replacements_text_to_import !~ /[^ ]/ )
    {
        if ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" )
        {
            $global_trace_log .= "{{trace; imported zero definitions from empty text}}\n" ;
        }
        return 0 ;
    }


#-----------------------------------------------
#  Remove any spaces at the end of the
#  "list-of-phrases-newly-defined" phrase.

    if ( exists( $global_dashrep_replacement{ "list-of-phrases-newly-defined" } ) )
    {
        $global_dashrep_replacement{ "list-of-phrases-newly-defined" } =~ s/ +$// ;
    } else
    {
        $global_dashrep_replacement{ "list-of-phrases-newly-defined" } = "" ;
    }


#-----------------------------------------------
#  If supplied, get requested prefix or suffix
#  strings, and a flag indicating that definitions
#  should be appended rather than overwritten.

    if ( exists( $global_dashrep_replacement{ "dashrep-phrase-prefix-for-imported-phrases" } ) )
    {
        $phrase_prefix = $global_dashrep_replacement{ "dashrep-phrase-prefix-for-imported-phrases" } ;
    } else
    {
        $phrase_prefix = "" ;
    }
    if ( exists( $global_dashrep_replacement{ "dashrep-phrase-suffix-for-imported-phrases" } ) )
    {
        $phrase_suffix = $global_dashrep_replacement{ "dashrep-phrase-suffix-for-imported-phrases" } ;
    } else
    {
        $phrase_suffix = "" ;
    }
    if ( ( exists( $global_dashrep_replacement{ "yes-or-no-append-not-replace-for-imported-phrases" } ) ) && ( $global_dashrep_replacement{ "yes-or-no-append-not-replace-for-imported-phrases" } eq "yes" ) )
    {
        $yes_append_not_replace = "yes" ;
    } else
    {
        $yes_append_not_replace = "" ;
    }


#-----------------------------------------------
#  Initialization.

    $number_of_replacement_names = 0 ;
    $append_next_definition = $global_false ;


#-----------------------------------------------
#  Replace line breaks, and tabs, with spaces.

    $replacements_text_to_import =~ s/[\n\r\t]+/ /sg ;
    $replacements_text_to_import =~ s/[\n\r\t]+/ /sg ;
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
        $global_dashrep_replacement{ "dashrep-comments-ignored" } .= "  " . $2 ;
        $text_including_comment_end = $3 ;
        $text_after = "" ;
        if ( $text_including_comment_end =~ /^(.*?\-\-+[\*\/])(.*)$/ )
        {
            $global_dashrep_replacement{ "dashrep-comments-ignored" } .= $1 . "  " ;
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

        } elsif ( ( $input_string eq 'dashrep-definitions-begin' ) || ( $input_string eq 'dashrep-definitions-end' ) || ( $input_string eq 'dashrep-definition-append-next' ) )
        {
            $do_nothing ++ ;


#-----------------------------------------------
#  When the "dashrep-definition-append-next"
#  directive is encountered, set the flag that
#  will cause the next definition to be appended
#  instead of overwriting the previous definition.

        } elsif ( $input_string eq 'dashrep-definition-append-next' )
        {
            $append_next_definition = $global_true ;


#-----------------------------------------------
#  When the "define-end" directive, or a series
#  of at least 3 dashes ("--------"), is encountered,
#  clear the definition name.
#  Also remove trailing spaces from the previous
#  replacement.

        } elsif ( ( $input_string eq 'define-end' ) || ( $input_string =~ /^---+$/ ) )
        {
            $definition_value = $global_dashrep_replacement{ $definition_name } ;
            $definition_value =~ s/ +$// ;
            if ( $definition_value =~ /[^ \n\r]/ )
            {
                $global_dashrep_replacement{ $definition_name } = $definition_value ;
            } else
            {
                $global_dashrep_replacement{ $definition_name } = "" ;
            }
            $definition_name = "" ;


#-----------------------------------------------
#  Get a definition name.
#  Allow a colon after the hyphenated name.
#  If this definition name has already been defined,
#  ignore the earlier definition -- unless the phrase
#  "yes-or-no-append-not-replace-for-imported-phrases"
#  is "yes" or the "dashrep-definition-append-next"
#  directive preceded this definition.
#  If the name does not contain a hyphen,
#  replace any non-english characters with an
#  underscore and prefix the name with
#  "invalid-phrase-name-".

        } elsif ( $definition_name eq "" )
        {
            $definition_name = $input_string ;
            $definition_name =~ s/\:$//  ;
            if ( $definition_name !~ /\-/ )
            {
                $definition_name =~ s/[^a-z0-9_]+/_/sgi  ;
                $definition_name = "unhyphenated-phrase-" . $definition_name ;
            }
            if ( $yes_append_not_replace ne "yes" )
            {
                if ( $append_next_definition == $global_true )
                {
                    $append_next_definition = $global_false ;
                } else
                {
                    $global_dashrep_replacement{ $definition_name } = "" ;
                }
            }
            $number_of_replacement_names ++ ;
            $global_dashrep_replacement{ "list-of-phrases-newly-defined" } .= " " . $definition_name ;


#-----------------------------------------------
#  Collect any text that is part of a definition.
#  But do not allow the definition to include
#  the name of the phrase being defined (because
#  that would cause an endless loop when the
#  phrase is replaced).

        } elsif ( $input_string ne "" )
        {
            if ( $input_string eq $definition_name )
            {
                $modified_input_string = $input_string ;
                $modified_input_string =~ s/-/ _ /g ;
                $modified_input_string =~ s/ _ / - /g ;
                $global_dashrep_replacement{ $definition_name } .= " " . $modified_input_string . " " ;
#  remove-from-cpan-version-begin
                warn "Warning: Replacement for the hyphenated phrase:\n    " . $definition_name . "\n" . "includes itself, which would cause an endless replacement loop.". "\n" . "Error occurred " ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#                carp "Warning: Replacement for the hyphenated phrase:\n    " . $definition_name . "\n" . "includes itself, which would cause an endless replacement loop.". "\n" . "Error occurred " ;
#  uncomment-for-cpan-version-end
            } else
            {
                if ( $global_dashrep_replacement{ $definition_name } ne "" )
                {
                    $global_dashrep_replacement{ $definition_name } .= " " ;
                }
                $global_dashrep_replacement{ $definition_name } = $global_dashrep_replacement{ $definition_name } . $input_string ;
            }
        }


#-----------------------------------------------
#  Make the logged debugging (trace) information
#  available.

    $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= $global_trace_log ;
    $global_trace_log = "" ;


#-----------------------------------------------
#  Repeat the loop for the next string.

    }


#-----------------------------------------------
#  End of subroutine.

    return $number_of_replacement_names ;

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

    my $phrase_name ;
    my $expanded_text ;


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

    if ( ( exists( $global_dashrep_replacement{ $phrase_name } ) ) && ( $global_dashrep_replacement{ $phrase_name } =~ /[^ ]/ ) )
    {
        $expanded_text = $global_dashrep_replacement{ $phrase_name } ;
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

    my @list_of_phrases ;

    if ( scalar( @_ ) != 0 )
    {
#  remove-from-cpan-version-begin
        warn "Warning: Call to dashrep_get_list_of_phrases subroutine does not have exactly zero parameters." ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#        carp "Warning: Call to dashrep_get_list_of_phrases subroutine does not have exactly zero parameters." ;
#  uncomment-for-cpan-version-end
        @list_of_phrases = ( ) ;
        return @list_of_phrases ;
    }

    @list_of_phrases = keys( %global_dashrep_replacement ) ;
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

    my $phrase_name ;


#-----------------------------------------------
#  Delete the indicated phrase.

    if ( scalar( @_ ) == 1 )
    {
        $phrase_name = $_[ 0 ] ;
        $phrase_name =~ s/^ +// ;
        $phrase_name =~ s/ +$// ;
        delete( $global_dashrep_replacement{ $phrase_name } );
    } else
    {
#  remove-from-cpan-version-begin
        warn "Warning: Call to dashrep_delete subroutine does not have exactly one parameter." ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#        carp "Warning: Call to dashrep_delete subroutine does not have exactly one parameter." ;
#  uncomment-for-cpan-version-end
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
#  Reset the xml-parsing state.

    $global_xml_level_number = 0 ;
    $global_dashrep_replacement{ "dashrep-xml-level-reset-if-zero" } = "" ;
    @global_xml_tag_at_level_number = ( ) ;


#-----------------------------------------------
#  Delete all the phrases.

    if ( scalar( @_ ) == 0 )
    {
        %global_dashrep_replacement = ( );
        &initialize_special_phrases( ) ;
    } else
    {
#  remove-from-cpan-version-begin
        warn "Warning: Call to dashrep_delete_all subroutine does not have exactly zero parameters." ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#        carp "Warning: Call to dashrep_delete_all subroutine does not have exactly zero parameters." ;
#  uncomment-for-cpan-version-end
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

    my $undeleted_phrase_content ;
    my $do_nothing ;
    my $supplied_text ;
    my $replacement_text ;
    my $loop_status_done ;
    my $text_begin ;
    my $text_end ;
    my $text_parameter_content ;
    my $text_parameter_name ;
    my $text_parameter_value ;
    my $action_name ;
    my $operand_one ;
    my $operand_two ;
    my $operand_three ;
    my $operand_four ;
    my $operand_five ;
    my $operands_all ;
    my $action_result ;
    my $count ;
    my $yes_or_no ;
    my $text_parameter ;
    my $possible_new_limit ;
    my $source_phrase_name ;
    my $target_phrase_name ;
    my $epoch_seconds ;
    my $first_object_of_action ;
    my $second_object_of_action ;
    my $temp_text ;
    my $phrase_length ;
    my $counter ;
    my $value ;
    my $second_time ;
    my $minute ;
    my $hour ;
    my $day_of_month ;
    my $month_number ;
    my $year ;
    my $weekday ;
    my $day_of_year ;
    my $extra_info ;
    my $phrase_name ;
    my $starting_count ;
    my $ending_count ;
    my $plus_or_minus_one ;
    my $count_range ;
    my $next_number ;
    my $text_to_append ;
    my $output_list_one_phrase_name ;
    my $output_list_two_phrase_name ;
    my $input_list_one_phrase_name ;
    my $input_list_two_phrase_name ;
    my $input_list_one ;
    my $input_list_two ;
    my $count_list_one ;
    my $count_list_two ;
    my $counter_one ;
    my $value_one ;
    my $counter_two ;
    my $value_two ;
    my $separator_one ;
    my $separator_two ;
    my $numeric_value ;
    my $result_value ;
    my $character_to_replace ;
    my $character_position ;
    my $prefix ;
    my $suffix ;
    my $text_to_expand ;
    my $partial_translation ;
    my $translation ;
    my $word_to_find ;
    my $list_length ;
    my $last_pointer ;
    my $pointer ;
    my $text_list_loop ;
    my $text_list_key ;
    my $destination_phrase ;
    my $list_of_key_values ;
    my $listed_word ;
    my $word ;
    my $list_of_loop_words ;
    my $length_of_loop_list ;
    my $result_word_list ;
    my $string_in_phrase ;
    my $handler_phrase_name ;
    my $item_number ;
    my $phrase_words ;
    my $list_of_phrases ;
    my $sequence_of_phrases ;
    my $number_of_operands ;
    my $list_of_operands ;
    my $text_string ;
    my $source_text ;
    my $word_position ;
    my $list_of_words ;
    my $phrase_name_to_clear ;
    my $text_to_insert ;
    my $string_to_be_replaced ;
    my $word_number ;
    my $string_to_find ;
    my $string_to_search ;
    my $position ;
    my $result_text ;
    my $starting_character_position ;
    my $ending_character_position ;
    my $phrase_being_edited ;
    my $text_being_edited ;
    my $remaining_text ;
    my $accumulated_text ;
    my $possible_phrase_name ;
    my $length_of_string_to_be_replaced ;
    my $word_number_begin ;
    my $word_number_end ;
    my $word_count ;
    my $separator ;
    my $ending_first_count ;
    my $starting_second_count ;
    my $number_of_characters_to_get ;
    my $tracking_on_yes_or_no ;
    my $character_code_to_decode ;
    my $list_indicating_sort_order ;
    my $sort_order ;
    my $extra_words_without_sort_value ;
    my $length_of_string ;
    my $generated_list ;
    my $map_tile_zoom ;
    my $map_tile_n ;
    my $pi ;
    my $angle_in_radians ;
    my $sine_of_angle ;
    my $cosine_of_angle ;
    my $value_of_operand_one ;
    my $number_of_columns ;
    my $number_of_items ;
    my $number_of_items_in_bottom_row ;
    my $number_of_full_rows ;
    my $number_of_rows ;
    my $up_direction_minimum_value ;
    my $up_direction_maximum_value ;
    my $right_direction_minimum_value ;
    my $right_direction_maximum_value ;
    my $range_of_up_direction_values ;
    my $range_of_right_direction_values ;
    my $top_row_number ;
    my $bottom_row_number ;
    my $fill_direction_top_left ;
    my $fill_direction_bottom_right ;
    my $fill_direction_bottom_left ;
    my $fill_direction_top_right ;
    my $need_maximum ;
    my $need_minimum ;
    my $value_direction_right_and_up ;
    my $value_direction_left_and_up ;
    my $value_direction_up ;
    my $value_direction_right ;
    my $top_left_open_column ;
    my $top_right_open_column ;
    my $bottom_left_open_column ;
    my $bottom_right_open_column ;
    my $fill_direction ;
    my $target_row_number ;
    my $target_column_number ;
    my $need_maximum_or_minimum ;
    my $final_result ;
    my $row_number ;
    my $column_number ;
    my $next_value_to_compare ;
    my $use_value_direction ;
    my $max_or_min_value ;
    my $action_name_exists ;
    my $parameter_level ;
    my $parameter_begin_or_end_string ;
    my $phrase_type ;
    my $prefix_text ;
    my $list_of_words_as_text ;
    my $odd_or_even_based_on_zero_or_one ;
    my $item_number_at_min_or_max ;
    my $multiplier_for_up_direction_values ;
    my $multiplier_for_right_direction_values ;
    my $text_for_up_direction_values ;
    my $text_for_right_direction_values ;
    my $character_to_capitalize ;
    my $list_indicating_sort_order_text_string ;
    my $pointer_one ;
    my $pointer_two ;
    my $pointer_to_matching_text ;
    my $name_of_parameter_for_handler ;
    my $list_of_x_values_as_text ;
    my $list_of_y_values_as_text ;
    my $pair_pointer ;
    my $phrase_name_containing_source_words ;
    my $phrase_name_containing_pattern ;
    my $phrase_name_containing_parameter_list ;
    my $first_or_second ;
    my $segment_that_might_include_else ;
    my $remainder ;
    my $segment_if_first ;
    my $segment_if_second ;
    my $length_desired ;
    my $number_of_zeros_needed ;
    my $zero_padding ;
    my $single_value ;
    my $required_number_of_operands ;
    my $target_operand ;
    my $replacement_count ;
    my $endless_loop_replacements_with_count ;
    my $replacement_count_text ;
    my $search_starting_position ;
    my $list_of_positions ;
    my $local_endless_loop_counter ;
    my $local_endless_loop_counter_maximum ;
    my $repeat_count ;
    my $current_character_position_number ;
    my $character_pointer_to_next_word_zero_based ;
    my $growing_text_to_append ;
    my $words_to_find ;
    my $text_list_of_start_matching_positions ;
    my $list_of_text_items_to_find ;
    my $text_to_find_at_position ;
    my $number_of_items_to_find ;
    my $text_to_find ;
    my $position_of_text_found ;
    my $position_as_string ;
    my $paired_words_as_text ;
    my $pair_status ;
    my $pair_pointer_offset_zero ;
    my $string_to_insert ;
    my $position_end ;
    my $word_to_check ;
    my $string_to_match ;
    my $number_of_unique_words ;
    my $text_list_of_unique_word_counts ;
    my $number_of_items_remaining ;
    my $yes_or_no_within_ampersand_encoded_character ;
    my $octet_number ;
    my $unicode_number ;
    my $elapsed_time ;
    my $text_list_of_unique_word_pointers ;
    my @octet_number_at_position ;
    my @list_of_words_to_check ;
    my @list_of_strings_to_match ;
    my @list_of_paired_words ;
    my @item_number_found_at_position ;
    my @list_of_start_matching_positions ;
    my @list_of_phrase_names ;
    my @list_of_x_values ;
    my @list_of_y_values ;
    my @list ;
    my @list_of_sorted_numbers ;
    my @list_of_action_names ;
    my @zero_if_not_remaining_item_number ;
    my @right_and_up_direction_value_for_item_number ;
    my @left_and_up_direction_value_for_item_number ;
    my @column_position_for_item_number ;
    my @row_position_for_item_number ;
    my @list_of_remaining_item_numbers ;
    my @up_direction_value_for_item_number ;
    my @right_direction_value_for_item_number ;
    my @list_of_parameter_words ;
    my @list_of_source_words ;
    my @unique_word_at_position ;
    my %occurrence_count_for_word ;
    my %listed_word ;
    my %words_at_numeric_value ;
    my %item_number_at_row_column ;


#-----------------------------------------------
#  Get the hyphenated phrase or supplied string.

    if ( scalar( @_ ) == 1 )
    {
        $supplied_text = $_[ 0 ] ;
    } else
    {
        $supplied_text = "" ;
    }


#-----------------------------------------------
#  Use the supplied text as the default result,
#  without leading or trailing spaces.

    $replacement_text = $supplied_text ;
    $replacement_text =~ s/[\r\n\t]/ /sg ;
    $replacement_text =~ s/^ +// ;
    $replacement_text =~ s/ +$// ;


#-----------------------------------------------
#  If there is no supplied text and no
#  runtime-code action name, return with nothing.

    if ( ( $supplied_text eq "" ) && ( $global_single_action_name eq "" ) )
    {
        return $replacement_text ;
    }


#-----------------------------------------------
#  If just a hyphenated phrase was supplied,
#  expand it into its replacement text.

    if ( $supplied_text =~ /^ *([^\- ]+-[^ ]*[^\- ]) *$/ )
    {
        $supplied_text = $1 ;
        if ( ( exists( $global_dashrep_replacement{ $supplied_text } ) ) && ( $global_dashrep_replacement{ $supplied_text } =~ /[^ ]/ ) )
        {
            $replacement_text = $global_dashrep_replacement{ $supplied_text } ;
        }
    }


#-----------------------------------------------
#  Update the endless loop count limit in case
#  it has changed.

    if ( $global_dashrep_replacement{ "dashrep-endless-loop-counter-limit" } =~ /^[0-9]+$/ )
    {
        $possible_new_limit = $global_dashrep_replacement{ "dashrep-endless-loop-counter-limit" } + 0 ;
        if ( ( $possible_new_limit != $global_endless_loop_counter_limit ) && ( $possible_new_limit > 1000 ) )
        {
            $global_endless_loop_counter_limit = $possible_new_limit ;
            if ( ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" ) && ( $replacement_text =~ /[^ ]/ ) )
            {
                $global_trace_log .= "{{trace; updated endless loop counter limit: " . $possible_new_limit . "}}\n";
            }
        }
    }


#-----------------------------------------------
#  Update the time limit in case it has changed.

    if ( $global_dashrep_replacement{ "dashrep-time-limit" } =~ /^[0-9]+$/ )
    {
        $possible_new_limit = $global_dashrep_replacement{ "dashrep-time-limit" } + 0 ;
        if ( ( $possible_new_limit != $global_time_limit ) && ( $possible_new_limit > 0 ) )
        {
            $global_time_limit = $possible_new_limit ;
            if ( ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" ) && ( $replacement_text =~ /[^ ]/ ) )
            {
                $global_trace_log .= "{{trace; updated time limit: " . $possible_new_limit . "}}\n";
            }
        }
    }


#-----------------------------------------------
#  Begin a loop that repeats until there have
#  been no more replacements.

    $loop_status_done = $global_false ;
    while ( $loop_status_done == $global_false )
    {
        $loop_status_done = $global_true ;

        if ( ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" ) && ( $replacement_text =~ /[^ ]/ ) )
        {
            $global_trace_log .= "{{trace; replacement string: " . $replacement_text . "}}\n";
        }


#-----------------------------------------------
#  Stop translating if requested.

        if ( $global_dashrep_replacement{ "dashrep-stop-translation" } eq "yes" )
        {
            if ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; stopping translation as requested}}\n";
            }
            last ;
        }


#-----------------------------------------------
#  Check for an endless loop.

        $global_endless_loop_counter ++ ;
        $global_replacement_count_for_item_name{ "expand parameters subroutine" } ++ ;
        if ( $global_endless_loop_counter > $global_endless_loop_counter_limit )
        {
            &dashrep_internal_endless_loop_info( ) ;
            $global_dashrep_replacement{ "dashrep-stop-translation" } = "yes" ;
            $global_trace_log .= "{{trace; Error: The dashrep_expand_parameters subroutine has encountered an endless loop, so attempting to stop translation gently}}\n";
            last ;
        }
        if ( $global_endless_loop_counter > ( $global_endless_loop_counter_limit + 100 ) )
        {
#  remove-from-cpan-version-begin
            warn "Warning: The dashrep_expand_parameters subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#            carp "Warning: The dashrep_expand_parameters subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  uncomment-for-cpan-version-end
            return 0 ;
        }


#-----------------------------------------------
#  Check if time limit exceeded.

        $global_interval_count_for_time_limit_check ++ ;
        if ( $global_interval_count_for_time_limit_check > 1000 )
        {
            $global_interval_count_for_time_limit_check = 0 ;
            $elapsed_time = time - $global_starting_time ;
            if ( $elapsed_time > $global_time_limit )
            {
                $global_dashrep_replacement{ "dashrep-stop-translation" } = "yes" ;
                $global_trace_log .= "{{trace; Error: The dashrep_expand_parameters subroutine has exceeded the time limit, so attempting to stop translation gently}}\n";
                last ;
            }
            if ( $elapsed_time > ( $global_time_limit + 1 ) )
            {
#  remove-from-cpan-version-begin
                warn "Warning: The dashrep_expand_parameters subroutine has exceeded the time limit." . "\n" . "Stopped" ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#                carp "Warning: The dashrep_expand_parameters subroutine has exceeded the time limit." . "\n" . "Stopped" ;
#  uncomment-for-cpan-version-end
                return 0 ;
            }
        }


#-----------------------------------------------
#  Get the next inner-most parameter syntax --
#  with "[-" at the beginning and "-]" at the end.
#  (It must not contain a nested parameter syntax.)
#  If it contains any line breaks, replace those
#  with spaces.  If there are no more parameters,
#  exit the loop.
#
#  ToDo:  Finish editing and testing code to
#  also handle words:
#  ambee amenn fenambee amennfen

        if ( $replacement_text =~ /((ambee)|(amenn)|(fenambee)|(amennfen))/ )
        {
            $replacement_text =~ s/((^)|( +))fenambee(( +)|($))/-\[-/sgi ;
            $replacement_text =~ s/((^)|( +))amennfen(( +)|($))/-\]-/sgi ;
            $replacement_text =~ s/((^)|( +))ambee(( +)|($))/\[-/sgi ;
            $replacement_text =~ s/((^)|( +))amenn(( +)|($))/-\]/sgi ;
        }
        $text_begin = "" ;
        $text_parameter_content = "" ;
        $text_end = "" ;
        if ( $replacement_text =~ /^(.*?)\[\-([^\[\]]*)\-\](.*)$/ )
        {
            $text_begin = $1 ;
            $text_parameter_content = $2 ;
            $text_end = $3 ;
        }
        if ( ( $text_parameter_content eq "" ) && ( $global_single_action_name eq "" ) )
        {
            last ;
        }
        $text_parameter_content =~ s/[\r\n\t]/ /sg ;
        $text_parameter_content =~ s/^ +// ;
        $text_parameter_content =~ s/ +$// ;
        $loop_status_done = $global_false ;
        if ( ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" ) && ( $text_parameter_content =~ /[^ ]/ ) )
        {
            $global_trace_log .= "{{trace; innermost parameter: " . $text_parameter_content . "}}\n";
        }


#-----------------------------------------------
#  If there is a parameter value assigned -- as
#  indicated by an equal sign -- then assign
#  the value, and restart the main loop.
#  The parameter value cannot contain a line break.

        if ( $text_parameter_content =~ /^ *([^ \:=\-]+\-[^ \:=]+) *= *([^ ](.*[^ ])?) *$/ )
        {
            $text_parameter_name = $1 ;
            $text_parameter_value = $2 ;
            $text_parameter_value =~ s/[\- ]+$// ;
            if ( ( length( $text_parameter_name ) > 0 ) && ( $text_parameter_name =~ /^[^\-]+-/ ) )
            {
                $global_dashrep_replacement{ $text_parameter_name } = $text_parameter_value ;
            }
            $replacement_text = $text_begin . " " . $text_end ;
            $global_replacement_count_for_item_name{ $text_parameter_value } ++ ;
            $global_replacement_count_for_item_name{ "expand parameters subroutine" } -- ;
            if ( $global_replacement_count_for_item_name{ $text_parameter_value } == 1 )
            {
                $global_dashrep_replacement{ "list-of-phrases-newly-defined" } .= " " . $text_parameter_name ;
            }
            if ( ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" ) && ( $text_parameter_name =~ /[^ ]/ ) )
            {
                $global_trace_log .= "{{trace; assignment: " . $text_parameter_name . " = " . $text_parameter_value . "}}\n";
            }
            next ;
        }


#-----------------------------------------------
#  If the parameter is a defined phrase, do the
#  replacement, then restart the main loop.
#  Use the "dashrep-recent-phrase-name-replaced"
#  phrase as a way to access this replacement
#  name for debugging purposes.

        if ( ( $text_parameter_content ne "" ) && ( $text_parameter_content !~ / / ) && ( exists( $global_dashrep_replacement{ $text_parameter_content } ) ) )
        {
            if ( defined( $global_dashrep_replacement{ $text_parameter_content } ) )
            {
                $text_parameter = $global_dashrep_replacement{ $text_parameter_content } ;
                if ( $text_parameter =~ /[^ ]/ )
                {
                    $replacement_text = $text_begin . $text_parameter . $text_end ;
                    $global_replacement_count_for_item_name{ $text_parameter_content } ++ ;
                    $global_replacement_count_for_item_name{ "expand parameters subroutine" } -- ;
                    $loop_status_done = $global_false ;
                    $global_dashrep_replacement{ "dashrep-recent-phrase-name-replaced" } = $text_parameter_content ;
                    if ( ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" ) && ( $text_parameter_content =~ /[^ ]/ ) )
                    {
                        $global_trace_log .= "{{trace; replaced " . $text_parameter_content . " with its definition" . "}}\n";
                    }
                } else
                {
                    $replacement_text = $text_begin . " " . $text_end ;
                    $loop_status_done = $global_false ;
                    $global_replacement_count_for_item_name{ "undefined or empty parameter named " . $text_parameter_content } ++ ;
                    $global_replacement_count_for_item_name{ "expand parameters subroutine" } -- ;
                    if ( ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" ) && ( $text_parameter_content =~ /[^ ]/ ) )
                    {
                        $global_trace_log .= "{{trace; phrase " . $text_parameter . " is empty, so replaced with single space" . "}}\n";
                    }
                }
            } else
            {
                $replacement_text = $text_begin . " " . $text_end ;
                $loop_status_done = $global_false ;
                if ( ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" ) && ( $text_parameter_content =~ /[^ ]/ ) )
                {
                    $global_trace_log .= "{{trace; phrase " . $text_parameter . " exists but is not defined, so it may be empty, so replaced with single space" . "}}\n";
                }
            }
            next ;
        }


#-----------------------------------------------
#  If a colon follows the action name (or any
#  phrase name at the beginning), replace it with
#  a space.

        $text_parameter_content =~ s/^([^ \:]+-[^ \:]+) *:/$1 /sg ;


#-----------------------------------------------
#  Replace any tabs with spaces, and replace
#  multiple adjacent spaces with a single space,
#  and remove leading and trailing spaces.

        $text_parameter_content =~ s/\t+/ /g ;
        $text_parameter_content =~ s/  +/ /g ;
        $text_parameter_content =~ s/^ // ;
        $text_parameter_content =~ s/ $// ;


#-----------------------------------------------
#  If this subroutine is being used as runtime
#  code for compiled code, get the single action
#  name and its operands.

        if ( $global_single_action_name ne "" )
        {
            $action_name = $global_single_action_name ;
            $operands_all = $global_single_action_operands_all ;
            if ( exists( $global_required_number_of_operands_for_action{ $action_name } ) )
            {
                $number_of_operands = $global_required_number_of_operands_for_action{ $action_name } ;
            } elsif ( exists( $global_minimum_number_of_operands_for_action{ $action_name } ) )
            {
                $number_of_operands = $global_minimum_number_of_operands_for_action{ $action_name } ;
            } else
            {
                $number_of_operands = 0 ;
            }
            if ( $number_of_operands > 0 )
            {
                $operand_one = $global_single_action_operand_one ;
                if ( $number_of_operands > 1 )
                {
                    $operand_two = $global_single_action_operand_two ;
                    if ( $number_of_operands > 2 )
                    {
                        $operand_three = $global_single_action_operand_three ;
                        if ( $number_of_operands > 3 )
                        {
                            $operand_four = $global_single_action_operand_four ;
                            if ( $number_of_operands > 4 )
                            {
                                $operand_five = $global_single_action_operand_five ;
                            }
                        }
                    }
                }
            }


#-----------------------------------------------
#  From the current "text parameter content"
#  get the action name and the operands.  If there
#  are no non-space characters, remove the
#  parameter brackets and restart the main loop.

        } else
        {
            $operands_all = "" ;
            $operand_one = "" ;
            $operand_two = "" ;
            $operand_three = "" ;
            $operand_four = "" ;
            $operand_five = "" ;
            $number_of_operands = 0 ;
            if ( $text_parameter_content =~ /^([^ ]+)(.*)$/ )
            {
                $action_name = $1 ;
                $operands_all = $2 ;
                $action_name =~ s/^\-+// ;
                $action_name =~ s/\-+$// ;
                $operands_all =~ s/\n/ /sg ;
                $operands_all =~ s/^ +// ;
                $operands_all =~ s/ +$// ;
                $operands_all =~ s/\-+$// ;
                @list_of_operands = split( / +/ , $operands_all ) ;
                $number_of_operands = scalar( @list_of_operands ) ;
                if ( $number_of_operands >= 1 )
                {
                    $operand_one = $list_of_operands[ 0 ] ;
                }
                if ( $number_of_operands >= 2 )
                {
                    $operand_two = $list_of_operands[ 1 ] ;
                }
                if ( $number_of_operands >= 3 )
                {
                    $operand_three = $list_of_operands[ 2 ] ;
                }
                if ( $number_of_operands >= 4 )
                {
                    $operand_four = $list_of_operands[ 3 ] ;
                }
                if ( $number_of_operands >= 5 )
                {
                    $operand_five = $list_of_operands[ 4 ] ;
                }
            } else
            {
                $replacement_text = $text_begin . " " . $text_parameter_content . " " . $text_end ;
                next ;
            }
        }


#-----------------------------------------------
#  If the action name is not recognized, leave
#  the text as-is, but omit the brackets,
#  and indicate this situation, which is not
#  necessarily an error.

        if ( ( not( exists( $global_required_number_of_operands_for_action{ $action_name } ) ) ) && ( not( ( exists( $global_minimum_number_of_operands_for_action{ $action_name } ) ) ) ) )
        {
            $replacement_text = $text_begin . $text_parameter_content . $text_end ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning, first word in parameter brackets is not a recognized action name: " . $action_name . "}}\n" ;
            }
            next ;
        }


#-----------------------------------------------
#  Keep track of some info.

        if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
        {
            $global_trace_log .= "{{trace; action " . $action_name . " has " . $number_of_operands . " operands: " . $operands_all . "}}\n";
        }
        $global_replacement_count_for_item_name{ "action " . $action_name } ++ ;
        $global_replacement_count_for_item_name{ "text parameter content " . $text_parameter_content } ++ ;
        $global_replacement_count_for_item_name{ "expand parameters subroutine" } -- ;


#-----------------------------------------------
#  Check the number of operands.  If not correct,
#  do not execute the action.

        if ( ( exists( $global_required_number_of_operands_for_action{ $action_name } ) ) && ( $global_required_number_of_operands_for_action{ $action_name } != $number_of_operands ) )
        {
            $action_result = $global_dashrep_replacement{ "dashrep-undefined" } ;
            $replacement_text = $text_begin . $action_result . $text_end ;
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning, wrong number of operands (" . $number_of_operands . ") for action " . $action_name . "}}\n" ;
            }
            next ;
        }
        if ( ( exists( $global_minimum_number_of_operands_for_action{ $action_name } ) ) && ( $number_of_operands < $global_minimum_number_of_operands_for_action{ $action_name } ) )
        {
            $action_result = $global_dashrep_replacement{ "dashrep-undefined" } ;
            $replacement_text = $text_begin . $action_result . $text_end ;
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning, not enough operands for action " . $action_name . "}}\n" ;
            }
            next ;
        }


#-----------------------------------------------
#  Check some operands.  If not valid,
#  do not execute the action.

        if ( ( ( exists( $global_check_operand_one_phrase_is_not_empty_for_action{ $action_name } ) ) ) && ( ( not( exists( $global_dashrep_replacement{ $operand_one } ) ) ) || ( $global_dashrep_replacement{ $operand_one } eq "" ) ) )
        {
            $action_result = $global_dashrep_replacement{ "dashrep-undefined" } ;
            $replacement_text = $text_begin . $action_result . $text_end ;
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning, for action " . $action_name . ", operand one (" . $operand_one . ") does not exist, or is empty" . "}}\n" ;
            }
            next ;
        }
        if ( ( ( exists( $global_check_operand_two_phrase_is_not_empty_for_action{ $action_name } ) ) ) && ( ( not( exists( $global_dashrep_replacement{ $operand_two } ) ) ) || ( $global_dashrep_replacement{ $operand_two } eq "" ) ) )
        {
            $action_result = $global_dashrep_replacement{ "dashrep-undefined" } ;
            $replacement_text = $text_begin . $action_result . $text_end ;
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning, for action " . $action_name . ", operand two (" . $operand_two . ") does not exist, or is empty" . "}}\n" ;
            }
            next ;
        }
        if ( ( ( exists( $global_check_operand_one_is_positive_integer_for_action{ $action_name } ) ) ) && ( $operand_one !~ /^[0-9]+$/ ) )
        {
            $action_result = $global_dashrep_replacement{ "dashrep-undefined" } ;
            $replacement_text = $text_begin . $action_result . $text_end ;
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning, for action " . $action_name . ", operand one (" . $operand_one . ") is not a positive integer" . "}}\n" ;
            }
            next ;
        }
        if ( ( ( exists( $global_check_operand_two_is_positive_integer_for_action{ $action_name } ) ) ) && ( $operand_two !~ /^[0-9]+$/ ) )
        {
            $action_result = $global_dashrep_replacement{ "dashrep-undefined" } ;
            $replacement_text = $text_begin . $action_result . $text_end ;
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning, for action " . $action_name . ", operand two (" . $operand_two . ") is not a positive integer" . "}}\n" ;
            }
            next ;
        }
        if ( ( ( exists( $global_check_operand_three_is_positive_integer_for_action{ $action_name } ) ) ) && ( $operand_three !~ /^[0-9]+$/ ) )
        {
            $action_result = $global_dashrep_replacement{ "dashrep-undefined" } ;
            $replacement_text = $text_begin . $action_result . $text_end ;
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning, for action " . $action_name . ", operand three (" . $operand_three . ") is not a positive integer" . "}}\n" ;
            }
            next ;
        }
        if ( ( ( exists( $global_check_operand_one_is_real_number_for_action{ $action_name } ) ) ) && ( $operand_one !~ /^[\-\+0-9\.]+$/ ) )
        {
            $action_result = $global_dashrep_replacement{ "dashrep-undefined" } ;
            $replacement_text = $text_begin . $action_result . $text_end ;
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning, for action " . $action_name . ", operand one (" . $operand_one . ") is not a real number" . "}}\n" ;
            }
            next ;
        }
        if ( ( ( exists( $global_check_operand_two_is_real_number_for_action{ $action_name } ) ) ) && ( $operand_two !~ /^[\-\+0-9\.]+$/ ) )
        {
            $action_result = $global_dashrep_replacement{ "dashrep-undefined" } ;
            $replacement_text = $text_begin . $action_result . $text_end ;
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning, for action " . $action_name . ", operand two (" . $operand_two . ") is not a real number" . "}}\n" ;
            }
            next ;
        }
        if ( ( exists( $global_check_operand_one_is_phrase_name_for_action{ $action_name } ) ) && ( ( $operand_one =~ /^[\-]/ ) || ( $operand_one =~ /[\-]$/ ) ) )
        {
            $action_result = $global_dashrep_replacement{ "dashrep-undefined" } ;
            $replacement_text = $text_begin . $action_result . $text_end ;
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning, for action " . $action_name . ", operand one (" . $operand_one . ") is not a valid phrase name" . "}}\n" ;
            }
            next ;
        }
        if ( ( exists( $global_check_operand_two_is_phrase_name_for_action{ $action_name } ) ) && ( ( $operand_two =~ /^[\-]/ ) || ( $operand_two =~ /[\-]$/ ) ) )
        {
            $action_result = $global_dashrep_replacement{ "dashrep-undefined" } ;
            $replacement_text = $text_begin . $action_result . $text_end ;
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning, for action " . $action_name . ", operand two (" . $operand_two . ") is not a valid phrase name" . "}}\n" ;
            }
            next ;
        }
        if ( ( exists( $global_check_operand_three_is_phrase_name_for_action{ $action_name } ) ) && ( ( $operand_three =~ /^[\-]/ ) || ( $operand_three =~ /[\-]$/ ) ) )
        {
            $action_result = $global_dashrep_replacement{ "dashrep-undefined" } ;
            $replacement_text = $text_begin . $action_result . $text_end ;
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning, for action " . $action_name . ", operand three (" . $operand_three . ") is not a valid phrase name" . "}}\n" ;
            }
            next ;
        }
        if ( ( exists( $global_check_operand_four_is_phrase_name_for_action{ $action_name } ) ) && ( ( $operand_four =~ /^[\-]/ ) || ( $operand_four =~ /[\-]$/ ) ) )
        {
            $action_result = $global_dashrep_replacement{ "dashrep-undefined" } ;
            $replacement_text = $text_begin . $action_result . $text_end ;
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning, for action " . $action_name . ", operand four (" . $operand_four . ") is not a valid phrase name" . "}}\n" ;
            }
            next ;
        }
        if ( ( exists( $global_check_operand_one_is_file_name_for_action{ $action_name } ) ) && ( $operand_one !~ /^[^ ]+\.[^ ]+/ ) )
        {
            $action_result = $global_dashrep_replacement{ "dashrep-undefined" } ;
            $replacement_text = $text_begin . $action_result . $text_end ;
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning, for action " . $action_name . ", operand one (" . $operand_one . ") is not a valid file name" . "}}\n" ;
            }
            next ;
        }
        if ( ( exists( $global_check_operand_two_is_file_name_for_action{ $action_name } ) ) && ( $operand_two !~ /^[^ ]+\.[^ ]+/ ) )
        {
            $action_result = $global_dashrep_replacement{ "dashrep-undefined" } ;
            $replacement_text = $text_begin . $action_result . $text_end ;
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning, for action " . $action_name . ", operand two (" . $operand_two . ") is not a valid file name" . "}}\n" ;
            }
            next ;
        }


#-----------------------------------------------
#  Clear the result text.
#  Include a space so that if this result is
#  inserted between phrases, the phrases will not
#  be joined.

        $action_result = " " ;


#-----------------------------------------------
#  If requested, log the action details.

        if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
        {
            $global_trace_log .= "{{trace; starting action " . $action_name . " with operands: " . $operand_one . " and " . $operand_two . " and " . $operand_three . " and " . $operand_four . " and " . $operand_five . "}}\n" ;
        }


#-----------------------------------------------
#  Beginning of code for actions.


#-----------------------------------------------
#  Handle the action:
#  clear-phrase

        if ( $action_name eq "clear-phrase" )
        {
            $phrase_name = $operand_one ;
            $global_dashrep_replacement{ $phrase_name } = "" ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; cleared phrase " . $phrase_name . "}}\n" ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  clear-listed-phrases
#  delete-listed-phrases

        if ( ( $action_name eq "clear-listed-phrases" ) || ( $action_name eq "delete-listed-phrases" ) )
        {
            $phrase_name = $operand_one ;
            @list_of_phrase_names = split( / + / , $global_dashrep_replacement{ $phrase_name } ) ;
            foreach $phrase_name_to_clear ( @list_of_phrase_names )
            {
                if ( exists( $global_dashrep_replacement{ $phrase_name_to_clear } ) )
                {
                    if ( $action_name eq "delete-listed-phrases" )
                    {
                        delete( $global_dashrep_replacement{ $phrase_name_to_clear } ) ;
                    } elsif ( $action_name eq "clear-listed-phrases" )
                    {
                        $global_dashrep_replacement{ $phrase_name_to_clear } = "" ;

                        $global_trace_log .= "{{trace; cleared phrase " . $phrase_name_to_clear . "}}\n" ;

                    }
                }
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                if ( $action_name eq "delete-listed-phrases" )
                {
                    $global_trace_log .= "{{trace; deleted phrases listed in phrase " . $phrase_name . "}}\n" ;
                } else
                {
                    $global_trace_log .= "{{trace; cleared phrases listed in phrase " . $phrase_name . "}}\n" ;
                }
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  delete-all-dashrep-phrases

        if ( $action_name eq "delete-all-dashrep-phrases" )
        {
            $tracking_on_yes_or_no = $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } ;
            $undeleted_phrase_content = "" ;
            if ( ( exists( $global_dashrep_replacement{ "undeleted-phrase" } ) ) && ( $global_dashrep_replacement{ "undeleted-phrase" } =~ /[^ ]/ ) )
            {
                $undeleted_phrase_content = $global_dashrep_replacement{ "undeleted-phrase" } ;
            }
            &dashrep_delete_all( );
            if ( $undeleted_phrase_content ne "" )
            {
                $global_dashrep_replacement{ "undeleted-phrase" } = $undeleted_phrase_content ;
            }
            if ( $tracking_on_yes_or_no eq "yes" )
            {
                $global_trace_log .= "{{trace; cleared all definitions, including tracking/trace settings}}\n" ;
            }
            $global_endless_loop_counter = 0 ;
            $replacement_text = " " ;
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  append-text
#  append-text-no-space
#  prepend-text
#  prepend-text-no-space
#  append-repeatedly-using-count

        if ( ( $action_name eq "append-text" ) || ( $action_name eq "append-text-no-space" ) || ( $action_name eq "prepend-text" ) || ( $action_name eq "prepend-text-no-space" ) || ( $action_name eq "append-repeatedly-using-count" ) )
        {
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                $text_to_append = $global_dashrep_replacement{ $operand_one } ;
            } else
            {
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; action " . $action_name . " has nothing to append, because operand one -- " . $operand_one . " -- is empty" . "}}\n" ;
                }
                $replacement_text = $text_begin . $action_result . $text_end ;
                next ;
            }
            if ( not( exists( $global_dashrep_replacement{ $operand_two } ) ) )
            {
                $global_dashrep_replacement{ $operand_two } = "" ;
            }
            if ( $action_name eq "append-text-no-space" )
            {
                $global_dashrep_replacement{ $operand_two } .= $text_to_append ;
            } elsif ( $action_name eq "prepend-text-no-space" )
            {
                $global_dashrep_replacement{ $operand_two } = $text_to_append . $global_dashrep_replacement{ $operand_two } ;
            } elsif ( $action_name eq "append-text" )
            {
                $text_to_append =~ s/^ +//s ;
                $text_to_append =~ s/ +$//s ;
                if ( $global_dashrep_replacement{ $operand_two } eq "" )
                {
                    $global_dashrep_replacement{ $operand_two } = $text_to_append ;
                } else
                {
                    $global_dashrep_replacement{ $operand_two } .= " " . $text_to_append ;
                }
            } elsif ( $action_name eq "prepend-text" )
            {
                $text_to_append =~ s/^ +//s ;
                $text_to_append =~ s/ +$//s ;
                if ( $global_dashrep_replacement{ $operand_two } eq "" )
                {
                    $global_dashrep_replacement{ $operand_two } = $text_to_append ;
                } else
                {
                    $global_dashrep_replacement{ $operand_two } = $text_to_append . " " . $global_dashrep_replacement{ $operand_two } ;
                }
            } elsif ( $action_name eq "append-repeatedly-using-count" )
            {
                $text_to_append =~ s/^ +//s ;
                $text_to_append =~ s/ +$//s ;
                if ( $operand_three eq "0" )
                {
                    $repeat_count = 0 ;
                } else
                {
                    $repeat_count = $operand_three + 0 ;
                }
                if ( ( $repeat_count < 1 ) || ( $repeat_count > 99999 ) )
                {
                    if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; action " . $action_name . " has repeat count (" . $repeat_count . ") that is less than one or is too large" . "}}\n" ;
                    }
                    $replacement_text = $text_begin . $action_result . $text_end ;
                    next ;
                } else
                {
                    $growing_text_to_append = "" ;
                    if ( $global_dashrep_replacement{ $operand_two } eq "" )
                    {
                        $growing_text_to_append = $text_to_append ;
                    } else
                    {
                        $growing_text_to_append = " " . $text_to_append ;
                    }
                    for ( $count = 2 ; $count <= $repeat_count ; $count ++ )
                    {
                        $growing_text_to_append .= " " . $text_to_append ;
                    }
                    $global_dashrep_replacement{ $operand_two } .= $growing_text_to_append ;
                }
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; did action " . $action_name . " from phrase " . $operand_one . " to phrase " . $operand_two . "}}\n" ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  append-new-line

        if ( $action_name eq "append-new-line" )
        {
            $global_dashrep_replacement{ $operand_one } .= "\n" ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; appended newline to phrase " . $operand_one . "}}\n" ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  copy-listed-words-to-phrases-named-in-pattern
#  append-multiple-from-phrases-named-in-pattern

        if ( ( $action_name eq "copy-listed-words-to-phrases-named-in-pattern" ) || ( $action_name eq "append-multiple-from-phrases-named-in-pattern" ) )
        {
            if ( $action_name eq "copy-listed-words-to-phrases-named-in-pattern" )
            {
                $phrase_name_containing_source_words = $operand_one ;
                $phrase_name_containing_pattern = $operand_two ;
                $target_phrase_name = "" ;
            } else
            {
                $phrase_name_containing_pattern = $operand_one ;
                $target_phrase_name = $operand_two ;
                $phrase_name_containing_source_words = "" ;
            }
            if ( ( defined( $global_dashrep_replacement{ $phrase_name_containing_pattern } ) ) && ( $global_dashrep_replacement{ $phrase_name_containing_pattern } =~ /^([^ ]*)ambee-([^ ]*)-amenn([^ ]*)$/ ) )
            {
                $prefix = $1 ;
                $phrase_name_containing_parameter_list = $2 ;
                $suffix = $3 ;
            } else
            {
                $replacement_text = $text_begin . $action_result . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $phrase_name_containing_pattern . "}}\n" ;
                }
                next ;
            }
            $prefix =~ s/[ \n]+//g ;
            $prefix =~ s/^-+// ;
            $suffix =~ s/[ \n]+//g ;
            $suffix =~ s/-+$// ;
            $phrase_name_containing_parameter_list =~ s/[ \n]+//g ;
            $phrase_name_containing_parameter_list =~ s/^-+// ;
            $phrase_name_containing_parameter_list =~ s/-+$// ;
            if ( not( defined( $global_dashrep_replacement{ $phrase_name_containing_parameter_list } ) ) )
            {
                $replacement_text = $text_begin . $action_result . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , the operand " . $phrase_name_containing_parameter_list . " is not defined, so nothing was done" . "}}\n" ;
                }
                next ;
            }
            $list_of_words_as_text = $global_dashrep_replacement{ $phrase_name_containing_parameter_list } ;
            $list_of_words_as_text =~ s/\n/ /sg ;
            $list_of_words_as_text =~ s/^ +// ;
            $list_of_words_as_text =~ s/ +$// ;
            if ( $list_of_words_as_text !~ /[^ ]/ )
            {
                $replacement_text = $text_begin . $action_result . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , the operand " . $phrase_name_containing_parameter_list . " does not contain any words, so nothing was done" . "}}\n" ;
                }
                next ;
            }
            @list_of_parameter_words = split( / +/ , $list_of_words_as_text ) ;
            if ( $action_name eq "copy-listed-words-to-phrases-named-in-pattern" )
            {
                $phrase_name_containing_source_words =~ s/[ \n]+//sg ;
                $phrase_name_containing_source_words =~ s/^-+// ;
                $phrase_name_containing_source_words =~ s/-+$// ;
                if ( not( defined( $global_dashrep_replacement{ $phrase_name_containing_source_words } ) ) )
                {
                    $replacement_text = $text_begin . $action_result . $text_end ;
                    if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; warning, for action " . $action_name . " , the operand " . $phrase_name_containing_source_words . " is not defined, so no copying was done" . "}}\n" ;
                    }
                    next ;
                }
                $list_of_words_as_text = $global_dashrep_replacement{ $phrase_name_containing_source_words } ;
                $list_of_words_as_text =~ s/\n/ /sg ;
                $list_of_words_as_text =~ s/^ +// ;
                $list_of_words_as_text =~ s/ +$// ;
                if ( $list_of_words_as_text !~ /[^ ]/ )
                {
                    $replacement_text = $text_begin . $action_result . $text_end ;
                    if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; warning, for action " . $action_name . " , the operand " . $phrase_name_containing_source_words . " does not contain any words, so no copying was done" . "}}\n" ;
                    }
                    next ;
                }
                @list_of_source_words = split( / +/ , $list_of_words_as_text ) ;
            }
            if ( $action_name eq "copy-listed-words-to-phrases-named-in-pattern" )
            {
                for ( $pointer = 0 ; $pointer <= $#list_of_parameter_words ; $pointer ++ )
                {
                    if ( $pointer <= $#list_of_source_words )
                    {
                        $target_phrase_name = $prefix . $list_of_parameter_words[ $pointer ] . $suffix ;
                        if ( $target_phrase_name =~ /^[^ \-][^ ]*-[^ ]*[^ \-]$/ )
                        {
                            $text_string = $list_of_source_words[ $pointer ] ;
                            $global_dashrep_replacement{ $target_phrase_name } = $text_string ;
                        }
                    } else
                    {
                        if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                        {
                            $global_trace_log .= "{{trace; warning, for action " . $action_name . " , the number of words in the source list " . $phrase_name_containing_source_words . " is less than the number of phrase names based on the parameter values in the list " . $phrase_name_containing_parameter_list . " so not all the copies were created" . "}}\n" ;
                        }
                        last ;
                    }
                }
            } else
            {
                for ( $pointer = 0 ; $pointer <= $#list_of_parameter_words ; $pointer ++ )
                {
                    $source_phrase_name = $prefix . $list_of_parameter_words[ $pointer ] . $suffix ;
                    if ( ( $source_phrase_name =~ /^[^ ]+$/ ) && ( defined( $global_dashrep_replacement{ $source_phrase_name } ) ) )
                    {
                        $text_string = $global_dashrep_replacement{ $source_phrase_name } ;
                        $text_string =~ s/\n/ /sg ;
                        $text_string =~ s/^ +// ;
                        $text_string =~ s/ +$// ;
                        $global_dashrep_replacement{ $target_phrase_name } .= " " . $text_string ;
                    }
                }
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; did action " . $action_name . " for phrases named " . $operand_one . " and " . $operand_two . "}}\n" ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  copy-text
#  copy-to-phrase-from-following-text
#  put-into-phrase
#  copy-lowercase-only
#  copy-uppercase-only
#  copy-initial-caps
#  copy-without-extra-spaces
#  copy-words-sort-numeric
#  copy-words-sort-alphabetic
#  encode-as-cgi-parameter
#  decode-from-cgi-parameter

        if ( ( $action_name eq "copy-text" ) || ( $action_name eq "put-into-phrase" ) || ( $action_name eq "copy-to-phrase-from-following-text" ) || ( $action_name eq "copy-without-extra-spaces" ) || ( $action_name eq "copy-lowercase-only" ) || ( $action_name eq "copy-uppercase-only" ) || ( $action_name eq "copy-initial-caps" ) || ( $action_name eq "copy-words-sort-numeric" ) || ( $action_name eq "copy-words-sort-alphabetic" ) || ( $action_name eq "encode-as-cgi-parameter" ) || ( $action_name eq "decode-from-cgi-parameter" ) )
        {
            $source_phrase_name = $operand_one ;
            $target_phrase_name = $operand_two ;
            if ( not( exists( $global_dashrep_replacement{ $source_phrase_name } ) ) )
            {
                $global_dashrep_replacement{ $source_phrase_name } = "" ;
            }
            $temp_text = $global_dashrep_replacement{ $source_phrase_name } ;
            if ( $action_name eq "copy-without-extra-spaces" )
            {
                $temp_text =~ s/\n/ /sg ;
                $temp_text =~ s/  +/ /g ;
                $temp_text =~ s/^ +// ;
                $temp_text =~ s/ +$// ;
            } elsif ( $action_name eq "copy-lowercase-only" )
            {
                $temp_text = lc( $temp_text ) ;
            } elsif ( $action_name eq "copy-uppercase-only" )
            {
                $temp_text = uc( $temp_text ) ;
            } elsif ( ( $action_name eq "copy-to-phrase-from-following-text" ) || ( $action_name eq "put-into-phrase" ) )
            {
                $temp_text = $operands_all ;
                $temp_text =~ s/^ *[^ ]+ +// ;
                $target_phrase_name = $operand_one ;
            } elsif ( $action_name eq "copy-initial-caps" )
            {
                $temp_text =~ s/\n/ /sg ;
                $temp_text =~ s/^ +// ;
                $temp_text =~ s/ +$// ;
                $remaining_text = $temp_text ;
                $accumulated_text = "" ;
                if ( $remaining_text =~ /^([a-z])(.*)$/ )
                {
                    $character_to_capitalize = $1 ;
                    $remaining_text = $2 ;
                    $accumulated_text .= uc( $character_to_capitalize ) ;
                }
                while ( $remaining_text =~ /^(.*?) ([a-z])(.*)$/ )
                {
                    $accumulated_text .= $1 ;
                    $character_to_capitalize = $2 ;
                    $remaining_text = $3 ;
                    $accumulated_text .= " " . uc( $character_to_capitalize ) ;
                }
                $accumulated_text .= $remaining_text ;
                $temp_text = $accumulated_text ;
            } elsif ( $action_name eq "encode-as-cgi-parameter" )
            {
                $temp_text =~ s/\n/ /sg ;
                $temp_text =~ s/ /\+/g ;
                $remaining_text = $temp_text ;
                $accumulated_text = "" ;
                while ( $remaining_text =~ /^(.*?)([^a-zA-Z0-9])(.*)$/s )
                {
                    $accumulated_text .= $1 ;
                    $character_to_replace = $2 ;
                    $remaining_text = $3 ;
                    $accumulated_text .= '%' . sprintf( "%02x" , ord( $character_to_replace ) ) ;
                }
                $accumulated_text .= $remaining_text ;
                $temp_text = $accumulated_text ;
            } elsif ( $action_name eq "decode-from-cgi-parameter" )
            {
                $temp_text =~ s/\+/ /sg ;
                $remaining_text = $temp_text ;
                $accumulated_text = "" ;
                while ( $remaining_text =~ /^(.*?)(\%[0-9][0-9])(.*)$/s )
                {
                    $accumulated_text .= $1 ;
                    $character_code_to_decode = $2 ;
                    $remaining_text = $3 ;
                    $accumulated_text .= chr( hex( $character_code_to_decode ) ) ;
                }
                $accumulated_text .= $remaining_text ;
                $temp_text = $accumulated_text ;
            } elsif ( $action_name eq "copy-words-sort-numeric" )
            {
                $temp_text =~ s/\n/ /sg ;
                $temp_text =~ s/^ +// ;
                $temp_text =~ s/ +$// ;
                @list = split( / +/ , $temp_text ) ;
                @list_of_sorted_numbers = sort { $a <=> $b } @list ;
                $temp_text = join( " " , @list_of_sorted_numbers ) ;
            } elsif ( $action_name eq "copy-words-sort-alphabetic" )
            {
                $temp_text =~ s/\n/ /sg ;
                $temp_text =~ s/^ +// ;
                $temp_text =~ s/ +$// ;
                @list = split( / +/ , $temp_text ) ;
                @list_of_sorted_numbers = sort( @list ) ;
                $temp_text = join( " " , @list_of_sorted_numbers ) ;
            }
            $global_dashrep_replacement{ $target_phrase_name } = $temp_text ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; copied from phrase " . $source_phrase_name . " to phrase " . $target_phrase_name . " with any specified changes}}\n" ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  convert-unicode-to-html-entities
#
#  Converts non-ASCII characters, and convert a few
#  ASCII characters such as:
#  11 which is "LF" (line feed)
#  13 which is "CR" (carriage return)
#  127 which is "del"

        if ( $action_name eq "convert-unicode-to-html-entities" )
        {
            $source_phrase_name = $operand_one ;
            $target_phrase_name = $operand_two ;
            if ( not( exists( $global_dashrep_replacement{ $source_phrase_name } ) ) )
            {
                $global_dashrep_replacement{ $source_phrase_name } = "" ;
            }
            $accumulated_text = "" ;
            @octet_number_at_position = unpack( "C*" , $global_dashrep_replacement{ $source_phrase_name } ) ;
            $yes_or_no_within_ampersand_encoded_character = "no" ;
            $pointer = -1 ;
            while ( $pointer < $#octet_number_at_position )
            {
                $pointer ++ ;
                $octet_number = $octet_number_at_position[ $pointer ] ;
                if ( $octet_number < 32 )
                {
                    $unicode_number = $octet_number ;
                    $accumulated_text .= '&#' . $unicode_number . ';' ;
                } elsif ( $octet_number < 127 )
                {
                    $accumulated_text .= chr( $octet_number ) ;
                } elsif ( $octet_number >= 0xfc )
                {
                    $unicode_number = ( ( ( ( ( ( ( ( ( ( $octet_number - 0xfc ) * 64 ) + $octet_number_at_position[ $pointer + 1 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 2 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 3 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 4 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 5 ] - 128 ;
                    $accumulated_text .= '&#' . $unicode_number . ';' ;
                    $pointer += 5 ;
                } elsif ( $octet_number >= 0xf8 )
                {
                    $unicode_number = ( ( ( ( ( ( ( ( $octet_number - 0xf8 ) * 64 ) + $octet_number_at_position[ $pointer + 1 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 2 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 3 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 4 ] - 128 ;
                    $accumulated_text .= '&#' . $unicode_number . ';' ;
                    $pointer += 4 ;
                } elsif ( $octet_number >= 0xf0 )
                {
                    $unicode_number = ( ( ( ( ( ( $octet_number - 0xf0 ) * 64 ) + $octet_number_at_position[ $pointer + 1 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 2 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 3 ] - 128 ;
                    $accumulated_text .= '&#' . $unicode_number . ';' ;
                    $pointer += 3 ;
                } elsif ( $octet_number >= 0xe0 )
                {
                    $unicode_number = ( ( ( ( $octet_number - 0xe0 ) * 64 ) + $octet_number_at_position[ $pointer + 1 ] - 128 ) * 64 ) + $octet_number_at_position[ $pointer + 2 ] - 128 ;
                    $accumulated_text .= '&#' . $unicode_number . ';' ;
                    $pointer += 2 ;
                } elsif ( $octet_number >= 0xc0 )
                {
                    $unicode_number = ( ( $octet_number - 0xc0 ) * 64 ) + $octet_number_at_position[ $pointer + 1 ] - 128 ;
                    $accumulated_text .= '&#' . $unicode_number . ';' ;
                    $pointer += 1 ;
                } elsif ( $octet_number > 0 )
                {
                    $unicode_number = $octet_number ;
                    $accumulated_text .= '&#' . $unicode_number . ';' ;
                }
            }
            $global_dashrep_replacement{ $target_phrase_name } = $accumulated_text ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; copied from phrase " . $source_phrase_name . " to phrase " . $target_phrase_name . " with unicode translation}}\n" ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  convert-into-spoken-dashrep-code
#  convert-from-spoken-dashrep-code

        if ( ( $action_name eq "convert-into-spoken-dashrep-code" ) || ( $action_name eq "convert-from-spoken-dashrep-code" ) )
        {
            $source_phrase_name = $operand_one ;
            $target_phrase_name = $operand_two ;
            if ( not( exists( $global_dashrep_replacement{ $source_phrase_name } ) ) )
            {
                $global_dashrep_replacement{ $source_phrase_name } = "" ;
            }
            $temp_text = $global_dashrep_replacement{ $source_phrase_name } ;
            if ( $action_name eq "convert-into-spoken-dashrep-code" )
            {
                $temp_text =~ s/^ +//sg ;
                $temp_text =~ s/ +$//sg ;
                $temp_text = " " . $temp_text . " " ;
                $temp_text =~ s/\t+/ /sg ;
                $temp_text =~ s/  +/ /sg ;
                $temp_text =~ s/[\n\r]/ linbray /sg ;
                $temp_text =~ s/-\[-/ fenambee /sg ;
                $temp_text =~ s/-\]-/ amennfen /sg ;
                $temp_text =~ s/\[-/ ambee /sg ;
                $temp_text =~ s/-\]/ amenn /sg ;
                $temp_text =~ s/ ([^ ]+(-[^ ]+)+) / dashbee $1 dashenn /sg ;
                $temp_text =~ s/-/ fen /sg ;
                $temp_text =~ s/^ +//sg ;
                $temp_text =~ s/ +$//sg ;
                $temp_text =~ s/  +/ /sg ;
            } else
            {
                $temp_text =~ s/\t+/ /sg ;
                $temp_text = " " . $temp_text . " " ;
                $temp_text =~ s/  +/ /sg ;
                $temp_text =~ s/ dashnex / dashenn dashbee /sg ;
                $temp_text =~ s/ wunspay / one-space /sg ;
                $temp_text =~ s/ feneer / hyphen-here /sg ;
                $temp_text =~ s/ senek / sentence-next /sg ;
                while ( $temp_text =~ /^(.* )ofo ([^ \]]+?) ofo( .*)$/s )
                {
                    $prefix = $1 ;
                    $phrase_words = $2 ;
                    $suffix = $3 ;
                    $temp_text = $prefix . " dashbee " . $phrase_words . " dashenn " . $suffix ;
                }
                while ( $temp_text =~ /^(.* )ofo ([^ \]]+?)-\]( .*)$/s )
                {
                    $prefix = $1 ;
                    $phrase_words = $2 ;
                    $suffix = $3 ;
                    $temp_text = $prefix . " dashbee " . $phrase_words . " dashenn " . $suffix ;
                }
                while ( $temp_text =~ /^(.* )dashbee (.+?) dashenn( .*)$/s )
                {
                    $prefix = $1 ;
                    $phrase_words = $2 ;
                    $suffix = $3 ;
                    $phrase_words =~ s/ +/-/sg ;
                    $temp_text = $prefix . $phrase_words . $suffix ;
                }
                while ( $temp_text =~ / ((ambee)|(amenn)|(fen)|(combee)|(comenn)|(newline)(fenambee)|(amennfen)) /s )
                {
                    $temp_text =~ s/ ambee / \[-/sg ;
                    $temp_text =~ s/ amenn /-\] /sg ;
                    $temp_text =~ s/ fen / - /sg ;
                    $temp_text =~ s/([^a-z0-9])fen-/$1-/sg ;
                    $temp_text =~ s/-fen([^a-z0-9])/-$1/sg ;
                    $temp_text =~ s/ combee / *---- /sg ;
                    $temp_text =~ s/ comenn / ----* /sg ;
                    $temp_text =~ s/ fenambee /-\[-/sg ;
                    $temp_text =~ s/ amennfen /-\]-/sg ;
                    $temp_text =~ s/ newline / linbray /sg ;
                }
                $temp_text =~ s/\[- /\[-/sg ;
                $temp_text =~ s/ -\]/-\]/sg ;
                $temp_text =~ s/ -/-/sg ;
                $temp_text =~ s/- /-/sg ;
                while ( $temp_text =~ / linbray /s )
                {
                    $temp_text =~ s/ linbray / \n /sg ;
                }
                $temp_text =~ s/ \n/\n/sg ;
                $temp_text =~ s/\n /\n/sg ;
                $temp_text =~ s/^ +//sg ;
                $temp_text =~ s/ +$//sg ;
                $temp_text =~ s/  +/ /sg ;
            }
            $global_dashrep_replacement{ $target_phrase_name } = $temp_text ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; copied from phrase " . $source_phrase_name . " to phrase " . $target_phrase_name . " with translation}}\n" ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  xml-move-attributes-into-tag-elements

        if ( $action_name eq "xml-move-attributes-into-tag-elements" )
        {
            $phrase_being_edited = $operand_one ;
            $text_being_edited = $global_dashrep_replacement{ $phrase_being_edited } ;
            while( $text_being_edited =~ / *\/> *<((attribute)|(specify)) ([^>]+)>/sg )
            {
                $text_being_edited =~ s/ *\/> *<((attribute)|(specify)) (([^"<>]*"[^"]*"[^"<>]*)+?)>/ $4 \/>/sg ;
                $global_replacement_count_for_item_name{ "loop within action " . $action_name } ++ ;
                if ( $global_endless_loop_counter > $global_endless_loop_counter_limit - 100 )
                {
                    $global_trace_log .= "{{trace; Error: During the action " . $action_name . " the endless loop counter got within 100 counts of exceeding its limit, so no more replacements will be done by this action.}}\n";
                    last ;
                }
                $global_endless_loop_counter ++ ;
            }
            while( $text_being_edited =~ / *> *<((attribute)|(specify)) ([^>]+)>/sg )
            {
                $text_being_edited =~ s/ *> *<((attribute)|(specify)) (([^"<>]*"[^"]*"[^"<>]*)+?)>/ $4>/sg ;
                $global_replacement_count_for_item_name{ "loop within action " . $action_name } ++ ;
                if ( $global_endless_loop_counter > $global_endless_loop_counter_limit - 100 )
                {
                    $global_trace_log .= "{{trace; Error: During the action " . $action_name . " the endless loop counter got within 100 counts of exceeding its limit, so no more replacements will be done by this action.}}\n";
                    last ;
                }
                $global_endless_loop_counter ++ ;
            }
            $global_dashrep_replacement{ $phrase_being_edited } = $text_being_edited ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; within phrase " . $phrase_being_edited . " moved attributes into tag elements}}\n" ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  copy-and-remove-attributes-from-xml-tags

        if ( $action_name eq "copy-and-remove-attributes-from-xml-tags" )
        {
            $text_being_edited = $global_dashrep_replacement{ $operand_one } ;
            $text_being_edited =~ s/< *(\/?) *([a-zA-Z]+)[^>\/]*(\/?)[^>]*>/<$1$2$3>/gi ;
            $text_being_edited =~ s/><!\[CDATA\[/>/gi ;
            $text_being_edited =~ s/\]\]></</gi ;
            $global_dashrep_replacement{ $operand_two } = $text_being_edited ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; within phrase " . $phrase_being_edited . " removed attributes from tags}}\n" ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  insert-angle-bracketed-definitions

        if ( $action_name eq "insert-angle-bracketed-definitions" )
        {
            $phrase_being_edited = $operand_one ;
            if ( not( exists( $global_dashrep_replacement{ $phrase_being_edited } ) ) )
            {
                $global_dashrep_replacement{ $phrase_being_edited } = "" ;
            }
            $remaining_text = $global_dashrep_replacement{ $phrase_being_edited } ;
            $accumulated_text = "" ;
            $remaining_text =~ s/<character_hyphen>/-/sg ;
            while ( $remaining_text =~ /^(.*?)<([^ _<>;:=,\-]+_[^ <>;:=,\-]+)>(.*)$/s )
            {
                $accumulated_text .= $1 ;
                $possible_phrase_name = $2 ;
                $remaining_text = $3 ;
                $phrase_name = $possible_phrase_name ;
                $phrase_name =~ s/_/-/g ;
                if ( exists( $global_dashrep_replacement{ $phrase_name } ) )
                {
                    $accumulated_text .= $global_dashrep_replacement{ $phrase_name } ;
                } else
                {
                    $accumulated_text .= "<" . $possible_phrase_name . ">" ;
                }
                $global_endless_loop_counter ++ ;
                $global_replacement_count_for_item_name{ "loop within action " . $action_name } ++ ;
                if ( $global_endless_loop_counter > $global_endless_loop_counter_limit - 100 )
                {
                    $global_trace_log .= "{{trace; Error: During the action " . $action_name . " the endless loop counter got within 100 counts of exceeding its limit, so no more replacements will be done by this action.}}\n";
                    $accumulated_text .= $remaining_text ;
                    $remaining_text = "" ;
                    last ;
                }
            }
            $accumulated_text .= $remaining_text ;
            $accumulated_text =~ s/ *<no_space> *//sg ;
            $accumulated_text =~ s/ *<new_line> */\n/sg ;
            $global_dashrep_replacement{ $phrase_being_edited } = $accumulated_text ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; within phrase " . $phrase_being_edited . " replaced translation-safe phrases with their definitions}}\n" ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  copy-word-at-position
#  copy-words-rearrange-using-order-sort-alphabetic
#  copy-words-rearrange-using-order-sort-numeric

        if ( ( $action_name eq "copy-word-at-position" ) || ( $action_name eq "copy-words-rearrange-using-order-sort-alphabetic" ) || ( $action_name eq "copy-words-rearrange-using-order-sort-numeric" ) )
        {
            if ( ( $action_name eq "copy-words-rearrange-using-order-sort-numeric" ) && ( $global_dashrep_replacement{ $operand_three } =~ /[^0-9\.\- ]/ ) )
            {
                $replacement_text = $text_begin . $action_result . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , operand " . $operand_three . " contains non-numeric content: " . $global_dashrep_replacement{ $operand_three } . "}}\n" ;
                }
                next ;
            }
            $source_phrase_name = $operand_one ;
            $target_phrase_name = $operand_two ;
# previously, next line removed instead of replaced:
            $source_phrase_name =~ s/\n/ /g ;
            if ( ( $source_phrase_name !~ /^[^ ]+$/ ) || ( not( exists( $global_dashrep_replacement{ $source_phrase_name } ) ) ) || ( not( defined( $global_dashrep_replacement{ $source_phrase_name } ) ) ) )
            {
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; copied nothing because phrase " . $operand_one . " is not defined}}\n" ;
                }
            } else
            {
                $source_text = $global_dashrep_replacement{ $source_phrase_name } ;
                $source_text =~ s/\n/ /sg ;
                $source_text =~ s/^ +// ;
                $source_text =~ s/ +$// ;
                if ( $action_name eq "copy-word-at-position" )
                {
                    if ( $operand_three =~ /^[0-9]+$/ )
                    {
                        $word_position = $operand_three + 0 ;
                    } else
                    {
                        $word_position = 1 ;
                    }
                    if ( $source_text =~ / / )
                    {
                        @list_of_words = split( / +/ , $source_text ) ;
                    } else
                    {
                        @list_of_words = ( ) ;
                        $list_of_words[ 0 ] = $source_text ;
                    }
                    if ( $word_position > scalar( @list_of_words + 1 ) )
                    {
                        $word_position = scalar( @list_of_words + 1 ) ;
                    }
                    $global_dashrep_replacement{ $target_phrase_name } = $list_of_words[ $word_position - 1 ] ;
                    if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; copied word number " . $word_position . " from phrase " . $source_phrase_name . " to phrase " . $target_phrase_name . "}}\n" ;
                    }
                } elsif ( ( $action_name eq "copy-words-rearrange-using-order-sort-alphabetic" ) || ( $action_name eq "copy-words-rearrange-using-order-sort-numeric" ) )
                {
                    if ( $source_text =~ / / )
                    {
                        @list_of_words = split( / +/ , $source_text ) ;
                    } else
                    {
                        @list_of_words = ( ) ;
                        $list_of_words[ 0 ] = $source_text ;
                    }
                    $list_indicating_sort_order_text_string = $global_dashrep_replacement{ $operand_three } ;
                    $list_indicating_sort_order_text_string =~ s/\n/ /s ;
                    $list_indicating_sort_order_text_string =~ s/^ +// ;
                    $list_indicating_sort_order_text_string =~ s/ +$// ;
                    @list_indicating_sort_order = split( / +/ , $list_indicating_sort_order_text_string ) ;

                    if ( $action_name eq "copy-words-rearrange-using-order-sort-numeric" )
                    {
                        @sort_order = sort { $a <=> $b } @list_indicating_sort_order ;
                    } else
                    {
                        @sort_order = sort( @list_indicating_sort_order ) ;
                    }
                    $extra_words_without_sort_value = "" ;
                    if ( $#list_indicating_sort_order < $#list_of_words )
                    {
                        for ( $word_position = ( $#list_indicating_sort_order + 2 ) ; $word_position <= ( $#list_of_words + 1 ) ; $word_position ++ )
                        {
                            $extra_words_without_sort_value .= $list_of_words[ $word_position - 1 ] . " " ;
                        }
                    }
                    %words_at_numeric_value = ( ) ;
                    for ( $word_position = 1 ; $word_position <= ( $#list_indicating_sort_order + 1 ) ; $word_position ++ )
                    {
                        $numeric_value = $list_indicating_sort_order[ $word_position - 1 ] ;
                        $words_at_numeric_value{ $numeric_value } .= $list_of_words[ $word_position - 1 ] . " " ;
                    }
                    $text_string = "" ;
                    foreach $numeric_value ( @sort_order )
                    {
                        if ( $words_at_numeric_value{ $numeric_value } =~ /[^ ]/ )
                        {
                            $text_string .= $words_at_numeric_value{ $numeric_value } . " " ;
                            $words_at_numeric_value{ $numeric_value } = "" ;
                        }
                    }
                    $text_string .= " " . $extra_words_without_sort_value ;
                    $text_string =~ s/ +/ /g ;
                    $text_string =~ s/ $// ;
                    $global_dashrep_replacement{ $target_phrase_name } = $text_string ;
                    if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; copied words from phrase " . $source_phrase_name . " to phrase " . $target_phrase_name . " in order specified numeric content in phrase " . $operand_three . "}}\n" ;
                    }
                }
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  copy-zero-pad-left-to-length

        if ( $action_name eq "copy-zero-pad-left-to-length" )
        {
            $source_phrase_name = $operand_one ;
            $target_phrase_name = $operand_two ;
            if ( ( $source_phrase_name !~ /^[^ ]+$/ ) || ( not( exists( $global_dashrep_replacement{ $source_phrase_name } ) ) ) || ( not( defined( $global_dashrep_replacement{ $source_phrase_name } ) ) ) )
            {
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; copied nothing because phrase " . $operand_one . " is not defined}}\n" ;
                }
            } else
            {
                $source_text = $global_dashrep_replacement{ $source_phrase_name } ;
                $source_text =~ s/^ +// ;
                $source_text =~ s/ +$// ;
                $length_desired = $operand_three + 0 ;
                $number_of_zeros_needed = $length_desired - length( $source_text ) ;
                $zero_padding = "" ;
                while ( ( $number_of_zeros_needed > 0 ) && ( $number_of_zeros_needed < 99 ) )
                {
                    $zero_padding .= "0" ;
                    $number_of_zeros_needed -- ;
                }
                $global_dashrep_replacement{ $target_phrase_name } = $zero_padding . $source_text ;
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; copied word from phrase " . $source_phrase_name . " to phrase " . $target_phrase_name . " and padded it with zeros" . "}}\n" ;
                }
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  copy-characters-from-position-to-position

        if ( $action_name eq "copy-characters-from-position-to-position" )
        {
            $source_phrase_name = $operand_one ;
            $target_phrase_name = $operand_two ;
            if ( not( exists( $global_dashrep_replacement{ $source_phrase_name } ) ) )
            {
                $global_dashrep_replacement{ $source_phrase_name } = "" ;
            }
            $pointer_one = -1 ;
            $pointer_two = -1 ;
            if ( $operand_three =~ /^([0-9]+)$/ )
            {
                $pointer_one = $1 ;
            }
            if ( $operand_four =~ /^([0-9]+)$/ )
            {
                $pointer_two = $1 ;
            }
            if ( ( $pointer_one == -1 ) || ( $pointer_two == -1 ) || ( $pointer_one > $pointer_two ) )
            {
                $replacement_text = $text_begin . $action_result . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , operand " . $operand_three . " or operand " . $operand_four . " is not a positive integer number, or the first number is larger than the second number (context: operand one is " . $operand_one . " and operand two is " . $operand_two . ")" . "}}\n" ;
                }
                next ;
            }
            $source_text = $global_dashrep_replacement{ $source_phrase_name } ;
            $global_dashrep_replacement{ $target_phrase_name } = substr( $source_text , ( $pointer_one - 1 ) , ( $pointer_two - $pointer_one + 1 ) ) ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; copied some characters from phrase " . $source_phrase_name . " to phrase " . $target_phrase_name . "}}\n" ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  copy-and-replace

        if ( $action_name eq "copy-and-replace" )
        {
            $source_phrase_name = $operand_one ;
            $target_phrase_name = $operand_two ;
            if ( not( exists( $global_dashrep_replacement{ $source_phrase_name } ) ) )
            {
                $global_dashrep_replacement{ $source_phrase_name } = "" ;
            }
            $string_to_be_replaced = $global_dashrep_replacement{ $operand_three } ;
            if ( exists( $global_dashrep_replacement{ $operand_four } ) )
            {
                $text_to_insert = $global_dashrep_replacement{ $operand_four } ;
            } else
            {
                $text_to_insert = "" ;
            }
            $source_text = $global_dashrep_replacement{ $source_phrase_name } ;
            if ( ( length( $text_to_insert ) >= length( $string_to_be_replaced ) ) && ( index( $text_to_insert , $string_to_be_replaced ) >= 0 ) )
            {
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning: replacement string (" . $text_to_insert . ") contains string to replace (" . $string_to_be_replaced . "), so no replacements done}}\n" ;
                }
            } elsif ( ( length( $string_to_be_replaced ) >= length( $text_to_insert ) ) && ( length( $text_to_insert ) > 0 ) && ( index( $string_to_be_replaced , $text_to_insert ) >= 0 ) )
            {
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning: string to replace (" . $string_to_be_replaced . ") contains replacement string (" . $text_to_insert . "), so no replacements done}}\n" ;
                }
            } else
            {
                $length_of_string_to_be_replaced = length( $string_to_be_replaced ) ;
                $character_position = index( $source_text , $string_to_be_replaced ) ;
                while ( $character_position >= 0 )
                {
                    $source_text = substr( $source_text , 0 , $character_position ) . $text_to_insert . substr( $source_text , $character_position + $length_of_string_to_be_replaced ) ;
                    $character_position = index( $source_text , $string_to_be_replaced ) ;
                    $global_endless_loop_counter ++ ;
                    $global_replacement_count_for_item_name{ "loop within action " . $action_name } ++ ;
                    if ( $global_endless_loop_counter > $global_endless_loop_counter_limit - 100 )
                    {
                        $global_trace_log .= "{{trace; Error: During the action " . $action_name . " the endless loop counter got within 100 counts of exceeding its limit, so no more replacements will be done by this action.}}\n";
                        last ;
                    }
                }
                $global_dashrep_replacement{ $target_phrase_name } = $source_text ;
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; copied from phrase " . $source_phrase_name . " to phrase " . $target_phrase_name . " with replacements}}\n" ;
                }
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  copy-and-replace-using-paired-listed-words

        if ( $action_name eq "copy-and-replace-using-paired-listed-words" )
        {
            if ( not( exists( $global_dashrep_replacement{ $operand_one } ) ) )
            {
                $global_dashrep_replacement{ $operand_one } = "" ;
            }
            $result_text = $global_dashrep_replacement{ $operand_one } ;
            if ( not( exists( $global_dashrep_replacement{ $operand_three } ) ) )
            {
                $global_dashrep_replacement{ $operand_three } = "" ;
            }
            $paired_words_as_text = $global_dashrep_replacement{ $operand_three } ;
            $paired_words_as_text =~ s/\n/ /sg ;
            $paired_words_as_text =~ s/^ +// ;
            $paired_words_as_text =~ s/ +$// ;
            @list_of_paired_words = split( / +/ , $paired_words_as_text ) ;
            $pair_status = "search" ;
            for ( $pair_pointer_offset_zero = 0 ; $pair_pointer_offset_zero <= $#list_of_paired_words ; $pair_pointer_offset_zero ++ )
            {
                if ( $pair_status eq "search" )
                {
                    $string_to_be_replaced = $list_of_paired_words[ $pair_pointer_offset_zero ] ;
                    $pair_status = "replace" ;
                } else
                {
                    $string_to_insert = $list_of_paired_words[ $pair_pointer_offset_zero ] ;
                    $remaining_text = $result_text ;
                    $result_text = "" ;
                    $pointer_to_matching_text = index( $remaining_text , $string_to_be_replaced ) ;
                    while ( $pointer_to_matching_text >= 0 )
                    {
                        if ( $pointer_to_matching_text > 0 )
                        {
                            $result_text .= substr( $remaining_text , 0 , $pointer_to_matching_text ) ;
                        }
                        $result_text .= $string_to_insert ;
                        $remaining_text = substr( $remaining_text , ( $pointer_to_matching_text + length( $string_to_be_replaced ) ) ) ;
                        $pointer_to_matching_text = index( $remaining_text , $string_to_be_replaced ) ;
                    }
                    $result_text .= $remaining_text ;
                    $pair_status = "search" ;
                }
            }
            $global_dashrep_replacement{ $operand_two } = $result_text ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; copied from phrase " . $operand_one . " to phrase " . $operand_two . " with replacements specified in phrase " . $operand_three . "}}\n" ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  expand-text
#  expand-parameters-only

        if ( ( $action_name eq "expand-text" ) || ( $action_name eq "expand-parameters-only" ) )
        {
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                $text_to_expand = $global_dashrep_replacement{ $operand_one } ;
                $global_recursion_level_of_expand_parameters ++ ;
                $partial_translation = &dashrep_expand_parameters( $text_to_expand ) ;
                $global_recursion_level_of_expand_parameters -- ;
                if ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; after parameters expanded: " . $partial_translation . "}}\n" ;
                }
                if ( $action_name ne "expand-parameters-only" )
                {
                    $translation = &dashrep_expand_phrases( $partial_translation );
                } else
                {
                    $translation = $partial_translation ;
                }

#  causes bug in some Dashrep code, so this update not yet implemented:
#                $translation =~ s/^ +// ;
#                $translation =~ s/ +$// ;

                $global_dashrep_replacement{ $operand_two } = $translation ;
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; expanded phrase " . $operand_one . " into phrase " . $operand_two . "}}\n" ;
                }
            } else
            {
                $global_dashrep_replacement{ $operand_two } = "" ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, cannot expand undefined phrase " . $operand_one . "}}\n" ;
                }
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  get-phrase-definition-without-expanding

        if ( $action_name eq "get-phrase-definition-without-expanding" )
        {
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                $action_result = $global_dashrep_replacement{ $operand_one } ;
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; inserted definition of phrase " . $operand_one . "}}\n" ;
                }
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  numeric-equal-greater-less-compare

        if ( $action_name eq "numeric-equal-greater-less-compare" )
        {
            $first_object_of_action = $operand_one + 0 ;
            $second_object_of_action = $operand_two + 0 ;
            if ( $first_object_of_action == $second_object_of_action )
            {
                $action_result = "equal" ;
            } elsif ( $first_object_of_action > $second_object_of_action )
            {
                $action_result = "greater" ;
            } else
            {
                $action_result = "less" ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  yes-if-not-no
#  no-if-any-no

        if ( ( $action_name eq "yes-if-not-no" ) || ( $action_name eq "no-if-any-no" ) )
        {
            if ( $operands_all =~ /no/i )
            {
                $yes_or_no = "no" ;
            } else
            {
                $yes_or_no = "yes" ;
            }
            $replacement_text = $text_begin . $yes_or_no . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  no-if-not-yes
#  yes-if-any-yes

        if ( ( $action_name eq "no-if-not-yes" ) || ( $action_name eq "yes-if-any-yes" ) )
        {
            if ( $operands_all =~ /yes/i )
            {
                $yes_or_no = "yes" ;
            } else
            {
                $yes_or_no = "no" ;
            }
            $replacement_text = $text_begin . $yes_or_no . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  yes-if-all-yes

        if ( $action_name eq "yes-if-all-yes" )
        {
            if ( $operands_all =~ / *(yes *)+/i )
            {
                $yes_or_no = "yes" ;
            } else
            {
                $yes_or_no = "no" ;
            }
            $replacement_text = $text_begin . $yes_or_no . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  yes-or-no-opposite

        if ( $action_name eq "yes-or-no-opposite" )
        {
            if ( $operands_all =~ /yes/i )
            {
                $yes_or_no = "no" ;
            } else
            {
                $yes_or_no = "yes" ;
            }
            $replacement_text = $text_begin . $yes_or_no . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  get-word-at-position

        if ( $action_name eq "get-word-at-position" )
        {
            $word_number = $operand_two + 0 ;
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                $temp_text = $global_dashrep_replacement{ $operand_one } ;
                $temp_text =~ s/\n/ /sg ;
                $temp_text =~ s/^ +// ;
                $temp_text =~ s/ +$// ;
                @list = split( / +/ , $temp_text ) ;
            } else
            {
                @list = ( ) ;
            }
            $count = $#list + 1 ;
            if ( $count >= 1 )
            {
                if ( $word_number > $count )
                {
                    $word_number = $count ;
                }
                $action_result = $list[ $word_number - 1 ] ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  copy-words-from-position-to-position

        if ( $action_name eq "copy-words-from-position-to-position" )
        {
            $word_number_begin = $operand_three + 0 ;
            $word_number_end = $operand_four + 0 ;
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                $temp_text = $global_dashrep_replacement{ $operand_one } ;
                $temp_text =~ s/\n/ /sg ;
                $temp_text =~ s/^ +// ;
                $temp_text =~ s/ +$// ;
                @list = split( / +/ , $temp_text ) ;
            } else
            {
                @list = ( ) ;
            }
            $word_count = $#list + 1 ;
            if ( $word_number_end > $word_count )
            {
                $word_number_end = $word_count ;
            }
            if ( ( $word_count < 1 ) || ( $word_number_begin < 1 ) || ( $word_number_end < 1 ) || ( $word_number_begin > $word_count ) || ( $word_number_end < $word_number_begin ) )
            {
                $global_dashrep_replacement{ $operand_two } = "" ;
            } else
            {
                $result_text = "" ;
                $separator = "" ;
                $global_dashrep_replacement{ $operand_two } = "" ;
                for ( $word_number = $word_number_begin ; $word_number <= $word_number_end ; $word_number ++ )
                {
                    $result_text .= $separator . $list[ $word_number - 1 ] ;
                    $separator = " " ;
                }
                $result_text =~ s/ +$// ;
                $global_dashrep_replacement{ $operand_two } = $result_text ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  copy-words-order-reversed
#  (useful for inserting commas or decimal points into integers)

        if ( $action_name eq "copy-words-order-reversed" )
        {
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                $temp_text = $global_dashrep_replacement{ $operand_one } ;
                $temp_text =~ s/\n/ /sg ;
                $temp_text =~ s/^ +// ;
                $temp_text =~ s/ +$// ;
                @list = split( / +/ , $temp_text ) ;
            } else
            {
                @list = ( ) ;
            }
            $count = $#list + 1 ;
            $temp_text = "" ;
            if ( $count > 0 )
            {
                for ( $word_number = $count ; $word_number >= 1 ; $word_number -- )
                {
                    $temp_text .= $list[ $word_number - 1 ] . " " ;
                }
                $temp_text =~ s/ +$// ;
            }
            $global_dashrep_replacement{ $operand_two } = $temp_text ;
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  get-count-of-words

        if ( $action_name eq "get-count-of-words" )
        {
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                $temp_text = $global_dashrep_replacement{ $operand_one } ;
                $temp_text =~ s/\n/ /sg ;
                $temp_text =~ s/^ +// ;
                $temp_text =~ s/ +$// ;
                @list = split( / +/ , $temp_text ) ;
            } else
            {
                @list = ( ) ;
            }
            $count = $#list + 1 ;
            if ( $count > 0 )
            {
                $action_result = $count ;
            } else
            {
                $action_result = "0" ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  yes-or-no-word-is-in-phrase
#  get-position-of-word

        if ( ( $action_name eq "yes-or-no-word-is-in-phrase" ) || ( $action_name eq "get-position-of-word" ) )
        {
            if ( $action_name eq "get-position-of-word" )
            {
                $word_to_find = $global_dashrep_replacement{ $operand_one } ;
            } else
            {
                $word_to_find = $operand_one ;
            }
            $phrase_name = $operand_two ;
            $temp_text = $global_dashrep_replacement{ $phrase_name } ;
            $temp_text =~ s/\n/ /sg ;
            $temp_text =~ s/^ +// ;
            $temp_text =~ s/ +$// ;
            @list = split( / +/ , $temp_text ) ;
            $list_length = $#list + 1 ;
            if ( $action_name eq "get-position-of-word" )
            {
                $action_result = "0" ;
            } else
            {
                $action_result = "no" ;
            }
            if ( $list_length >= 1 )
            {
                $last_pointer = 0 ;
                for ( $pointer = 1 ; $pointer <= $list_length ; $pointer ++ )
                {
                    if ( $list[ $pointer - 1 ] eq $word_to_find )
                    {
                        if ( $action_name eq "get-position-of-word" )
                        {
                            $action_result = sprintf( "%d" , $pointer ) ;
                        } else
                        {
                            $action_result = "yes" ;
                        }
                        last ;
                    }
                }
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  get-position-of-matching-text

        if ( $action_name eq "get-position-of-matching-text" )
        {
            $string_to_find = $global_dashrep_replacement{ $operand_one } ;
            $string_to_search = $global_dashrep_replacement{ $operand_two } ;
            $search_starting_position = 0 ;
            $action_result = "0" ;
            $phrase_length = length( $string_to_search ) + 1 ;
            if ( $phrase_length > 0 )
            {
                $position = index( $string_to_search , $string_to_find , $search_starting_position ) + 1 ;
                if ( $position > 0 )
                {
                    $action_result = sprintf( "%d" , $position ) ;
                }
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; action " . $action_name . " searched for " . $string_to_find . " within " . $string_to_search . " and found at character position " . $action_result . "}}\n";
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  generate-positions-of-delimiter

        if ( $action_name eq "generate-positions-of-delimiter" )
        {
            $string_to_find = $global_dashrep_replacement{ $operand_one } ;
            $string_to_search = $global_dashrep_replacement{ $operand_two } ;
            $search_starting_position = 0 ;
            $list_of_positions = "" ;
            $phrase_length = length( $string_to_search ) + 1 ;
            if ( $phrase_length > 0 )
            {
                $local_endless_loop_counter = 0 ;
                $local_endless_loop_counter_maximum = 10000 ;
                $position = index( $string_to_search , $string_to_find , $search_starting_position ) ;
                while ( ( $position > -1 ) && ( $local_endless_loop_counter <= $local_endless_loop_counter_maximum ) )
                {
                    if ( $list_of_positions ne "" )
                    {
                        $list_of_positions .= " " ;
                    }
                    $list_of_positions .= sprintf( "%d" , ( $position + 1 ) ) ;
                    $search_starting_position = $position + 1 ;
                    $position = index( $string_to_search , $string_to_find , $search_starting_position ) ;
                    $local_endless_loop_counter ++ ;
                }
                $global_dashrep_replacement{ $operand_three } = $list_of_positions ;
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; action " . $action_name . " searched for " . $string_to_find . " within " . $string_to_search . " and found matches at character positions " . $action_result . "}}\n";
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  generate-positions-of-first-matching-delimiter-after-listed-positions

        if ( $action_name eq "generate-positions-of-first-matching-delimiter-after-listed-positions" )
        {
            $string_to_find = $global_dashrep_replacement{ $operand_one } ;
            $string_to_search = $global_dashrep_replacement{ $operand_two } ;
            $list_of_positions = "" ;
            $phrase_length = length( $string_to_search ) + 1 ;
            if ( ( $phrase_length > 0 ) && ( exists( $global_dashrep_replacement{ $operand_three } ) ) )
            {
                $text_list_of_start_matching_positions = $global_dashrep_replacement{ $operand_three } ;
                $text_list_of_start_matching_positions =~ s/\n/ /sg ;
                $text_list_of_start_matching_positions =~ s/^ +// ;
                $text_list_of_start_matching_positions =~ s/ +$// ;
                if ( $text_list_of_start_matching_positions =~ /[0-9 ]+/ )
                {
                    @list_of_start_matching_positions = split( / +/ , $text_list_of_start_matching_positions ) ;
                } else
                {
                    @list_of_start_matching_positions = ( ) ;
                }
                foreach $search_starting_position ( @list_of_start_matching_positions )
                {
                    $position = index( $string_to_search , $string_to_find , $search_starting_position ) ;
                    if ( $position < 0 )
                    {
                        $position = -1 ;
                    }
                    if ( $list_of_positions ne "" )
                    {
                        $list_of_positions .= " " ;
                    }
                    $list_of_positions .= sprintf( "%d" , ( $position + 1 ) ) ;
                }
            }
            $global_dashrep_replacement{ $operand_four } = $list_of_positions ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; action " . $action_name . " searched for " . $string_to_find . " within " . $string_to_search . " following postions " . $text_list_of_start_matching_positions . " and found matches at character positions " . $list_of_positions . "}}\n";
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  generate-positions-of-listed-words

        if ( $action_name eq "generate-positions-of-listed-words" )
        {
            $words_to_find = $global_dashrep_replacement{ $operand_one } ;
            $string_to_search = $global_dashrep_replacement{ $operand_two } ;
            $list_of_positions = "" ;
            $words_to_find =~ s/\n/ /sg ;
            $words_to_find =~ s/^ +// ;
            $words_to_find =~ s/ +$// ;
            if ( $words_to_find =~ / / )
            {
                @list_of_text_items_to_find = split( / +/ , $words_to_find ) ;
                $number_of_items_to_find = $#list_of_text_items_to_find + 1 ;
            } elsif ( $words_to_find =~ /^[^ ]+$/ )
            {
                @list_of_text_items_to_find = ( ) ;
                $list_of_text_items_to_find[ 0 ] = $words_to_find ;
                $number_of_items_to_find = 1 ;
            } else
            {
                @list_of_text_items_to_find = ( ) ;
                $number_of_items_to_find = 0 ;
            }
            %text_to_find_at_position = ( ) ;
            if ( $number_of_items_to_find > 0 )
            {
                for ( $item_number = 1 ; $item_number <= $number_of_items_to_find ; $item_number ++ )
                {
                    $text_to_find = $list_of_text_items_to_find[ $item_number - 1 ] ;
                    $search_starting_position = 0 ;
                    $local_endless_loop_counter = 0 ;
                    $local_endless_loop_counter_maximum = 10000 ;
                    $position_of_text_found = index( $string_to_search , $text_to_find , $search_starting_position ) ;
                    while ( ( $position_of_text_found > -1 ) && ( $local_endless_loop_counter <= $local_endless_loop_counter_maximum ) )
                    {
                        $position_as_string = sprintf( "%05d" , $position_of_text_found ) ;
                        if ( exists( $text_to_find_at_position{ $position_as_string } ) )
                        {
                            if ( length( $text_to_find ) > length( $text_to_find_at_position{ $position_as_string } ) )
                            {
                                $text_to_find_at_position{ $position_as_string } = $text_to_find ;
                                $item_number_found_at_position{ $position_as_string } = $item_number ;
                            }
                        } else
                        {
                            $text_to_find_at_position{ $position_as_string } = $text_to_find ;
                            $item_number_found_at_position{ $position_as_string } = $item_number ;
                        }
                        $search_starting_position = $position_of_text_found + 1 ;
                        $position_of_text_found = index( $string_to_search , $text_to_find , $search_starting_position ) ;
                        $local_endless_loop_counter ++ ;
                    }
                }
            }
            $position_end = -1 ;
            foreach $position_of_text_found ( sort( keys( %text_to_find_at_position ) ) )
            {
                if ( ( $position_of_text_found + 1 ) >= $position_end )
                {
                    if ( $list_of_positions ne "" )
                    {
                        $list_of_positions .= " " ;
                    }
                    $list_of_positions .= $position_of_text_found + 1 ;
                    $position_end = ( $position_of_text_found + length( $list_of_text_items_to_find[ $item_number_found_at_position{ $position_of_text_found } - 1 ] ) ) ;
                    $list_of_positions .= " " . $position_end  ;
                }
            }
            $global_dashrep_replacement{ $operand_three } = $list_of_positions ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; action " . $action_name . " searched for words in " . $operand_one . " within " . $operand_two . " and found matches at character positions in phrase " . $operand_three . "}}\n";
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  copy-words-found-in-both-lists
#      (sequence of first occurence of item in first list determines sequence in result list)
#  copy-words-found-only-in-first-list
#      (order of items in first list are preserved)
#  copy-words-unique-only

        if ( ( $action_name eq "copy-words-found-in-both-lists" ) || ( $action_name eq "copy-words-found-only-in-first-list" ) || ( $action_name eq "copy-words-unique-only" ) )
        {
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                $text_list_loop = $global_dashrep_replacement{ $operand_one } ;
            } else
            {
                $text_list_loop = "" ;
            }
            if ( $action_name eq "copy-words-unique-only" )
            {
                $text_list_key = "" ;
                $destination_phrase = $operand_two ;
            } else
            {
                if ( exists( $global_dashrep_replacement{ $operand_two } ) )
                {
                    $text_list_key = $global_dashrep_replacement{ $operand_two } ;
                } else
                {
                    $text_list_key = "" ;
                }
                $destination_phrase = $operand_three ;
            }
            $text_list_key =~ s/\n/ /sg ;
            $text_list_key =~ s/^ +// ;
            $text_list_key =~ s/ +$// ;
            if ( $text_list_key eq "" )
            {
                @list_of_key_values = ( ) ;
            } else
            {
                @list_of_key_values = split( / +/ , $text_list_key ) ;
            }
            %listed_word = ( ) ;
            foreach $word ( @list_of_key_values )
            {
                $listed_word{ $word } = 1 ;
            }
            $text_list_loop =~ s/\n/ /sg ;
            $text_list_loop =~ s/^ +// ;
            $text_list_loop =~ s/ +$// ;
            if ( $text_list_loop eq "" )
            {
                @list_of_loop_words = ( ) ;
            } else
            {
                @list_of_loop_words = split( / +/ , $text_list_loop ) ;
            }
            $length_of_loop_list = $#list_of_loop_words + 1 ;
            %occurrence_count_for_word = ( ) ;
            $number_of_unique_words = 0 ;
            @unique_word_at_position = ( ) ;
            $unique_word_at_position[ 0 ] = "" ;
            $text_list_of_unique_word_pointers = "" ;
            $result_word_list = "" ;
            if ( $length_of_loop_list > 0 )
            {
                for ( $pointer = 1 ; $pointer <= $length_of_loop_list ; $pointer ++ )
                {
                    $word = $list_of_loop_words[ $pointer - 1 ] ;
                    $occurrence_count_for_word{ $word } ++ ;
                    if ( exists( $listed_word{ $word } ) )
                    {
                        if ( ( $action_name eq "copy-words-found-in-both-lists" ) && ( $occurrence_count_for_word{ $word } == 1 ) )
                        {
                            $result_word_list .= $word . " " ;
                        }
                    } else
                    {
                        if ( $action_name eq "copy-words-found-only-in-first-list" )
                        {
                            $result_word_list .= $word . " " ;
                        } elsif ( ( $action_name eq "copy-words-unique-only" ) && ( $occurrence_count_for_word{ $word } == 1 ) )
                        {
                            $result_word_list .= $word . " " ;
                            $number_of_unique_words ++ ;
                            $unique_word_at_position[ $number_of_unique_words ] = $word ;
                            $text_list_of_unique_word_pointers .= $pointer . " " ;
                        }
                    }
                }
            }
            $text_list_of_unique_word_pointers =~ s/ +$// ;
            $result_word_list =~ s/ +$// ;
            $global_dashrep_replacement{ $destination_phrase } = $result_word_list ;
            if ( $action_name eq "copy-words-unique-only" )
            {
                $text_list_of_unique_word_counts = "" ;
                for ( $pointer = 1 ; $pointer <= $number_of_unique_words ; $pointer ++ )
                {
                    if ( $pointer > 1 )
                    {
                        $text_list_of_unique_word_counts .= " " ;
                    }
                    $text_list_of_unique_word_counts .= sprintf( "%d" , $occurrence_count_for_word{ $unique_word_at_position[ $pointer ] } ) ;
                }
                $global_dashrep_replacement{ "list-of-unique-word-counts" } = $text_list_of_unique_word_counts ;
                $global_dashrep_replacement{ "list-of-pointers-to-unique-words" } = $text_list_of_unique_word_pointers ;
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; action " . $action_name . " done" . "}}\n";
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  copy-words-found-in-either-list

        if ( $action_name eq "copy-words-found-in-either-list" )
        {
            $text_list_key = $global_dashrep_replacement{ $operand_one } . " " . $global_dashrep_replacement{ $operand_two } ;
            $text_list_key =~ s/\n/ /sg ;
            $text_list_key =~ s/^ +// ;
            $text_list_key =~ s/ +$// ;
            $result_word_list = "" ;
            if ( $text_list_key ne "" )
            {
                @list_of_key_values = split( / +/ , $text_list_key ) ;
                %listed_word = ( ) ;
                foreach $word ( @list_of_key_values )
                {
                    $listed_word{ $word } = "exists" ;
                }
                foreach $word ( keys( %listed_word ) )
                {
                    $result_word_list .= $word . " " ;
                }
            }
            $result_word_list =~ s/ +$// ;
            $global_dashrep_replacement{ $operand_three } = $result_word_list ;
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  generate-counts-from-integer-to-integer

        if ( $action_name eq "generate-counts-from-integer-to-integer" )
        {
            if ( $operand_one !~ /^[\-0-9]+$/ )
            {
                $replacement_text = $text_begin . $action_result . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( $operand_two !~ /^[\-0-9]+$/ )
            {
                $replacement_text = $text_begin . $action_result . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one !~ /^[\-0-9]+$/ ) || ( $operand_two !~ /^[\-0-9]+$/ ) || ( $operand_three eq "" ) )
            {
                $do_nothing ++ ;
            } else
            {
                $starting_count = $operand_one + 0 ;
                $ending_count = $operand_two + 0 ;
                $phrase_name = $operand_three ;
                if ( $starting_count > $ending_count )
                {
                    $plus_or_minus_one = -1 ;
                    $count_range = $starting_count - $ending_count + 1 ;
                } else
                {
                    $plus_or_minus_one = 1 ;
                    $count_range = $ending_count - $starting_count + 1 ;
                }
                if ( $count_range > 9999999 )
                {
                    $action_result = " " . $action_name . " " . $operands_all . " " ;
                } else
                {
                    $global_dashrep_replacement{ $phrase_name } = "" ;
                    for ( $counter = 1 ; $counter <= $count_range ; $counter ++ )
                    {
                        $next_number = $starting_count + ( $plus_or_minus_one * ( $counter - 1 ) );
                        if ( $next_number == 0 )
                        {
                            $text_to_append = "0" ;
                        } else
                        {
                            $text_to_append = sprintf( "%d" , $next_number ) ;
                        }
                        if ( $counter < $count_range )
                        {
                            $text_to_append .= " " ;
                        }
                        $global_dashrep_replacement{ $phrase_name } .= $text_to_append ;
                    }
                }
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  generate-list-of-all-dashrep-phrases

        if ( $action_name eq "generate-list-of-all-dashrep-phrases" )
        {
            @list_of_phrases = keys( %global_dashrep_replacement ) ;
            @sequence_of_phrases = sort( @list_of_phrases ) ;
            $counter = 0 ;
            if ( $global_dashrep_replacement{ "yes-or-no-export-delimited-definitions" } eq "yes" )
            {
                foreach $phrase_name ( @sequence_of_phrases )
                {
                    if ( ( defined( $phrase_name ) ) && ( $phrase_name =~ /[^ ]/ ) && ( exists( $global_dashrep_replacement{ $phrase_name } ) ) && ( $phrase_name ne "four-hyphens" ) )
                    {
                        if ( $global_dashrep_replacement{ $operand_one } ne "" )
                        {
                            $global_dashrep_replacement{ $operand_one } .= " " ;
                        }
                        $global_dashrep_replacement{ $operand_one } .= $phrase_name ;
                        $counter ++ ;
                    }
                }
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; wrote " . $counter . " phrase names to phrase " . $operand_one . "}}\n" ;
                }
            } else
            {
                $global_dashrep_replacement{ $operand_one } = "" ;
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; value of yes-or-no-export-delimited-definitions is not yes, so wrote no phrase names to phrase " . $operand_one . "}}\n" ;
                }
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  copy-words-that-begin-with-text

        if ( $action_name eq "copy-words-that-begin-with-text" )
        {
            $list_of_words_as_text = $global_dashrep_replacement{ $operand_one } ;
            $list_of_words_as_text =~ s/\n/ /sg ;
            $list_of_words_as_text =~ s/^ +// ;
            $list_of_words_as_text =~ s/ +$// ;
            if ( $list_of_words_as_text =~ / / )
            {
                @list_of_words = split( / +/ , $list_of_words_as_text ) ;
            } else
            {
                @list_of_words = ( ) ;
                $list_of_words[ 0 ] = $list_of_words_as_text ;
            }
            $string_to_search = $global_dashrep_replacement{ $operand_three } ;
            $length_of_string = length( $string_to_search ) ;
            $generated_list = "" ;
            foreach $word ( @list_of_words )
            {
                if ( substr( $word , 0 , $length_of_string ) eq $string_to_search )
                {
                    $generated_list .= $word . " " ;
                }
            }
            $generated_list =~ s/ +$// ;
            $global_dashrep_replacement{ $operand_two } = $generated_list ;
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  copy-words-that-contain-listed-words
#  copy-words-that-begin-with-listed-words

        if ( ( $action_name eq "copy-words-that-contain-listed-words" ) || ( $action_name eq "copy-words-that-begin-with-listed-words" ) )
        {
            $list_of_words_as_text = $global_dashrep_replacement{ $operand_one } ;
            $list_of_words_as_text =~ s/\n/ /sg ;
            $list_of_words_as_text =~ s/^ +// ;
            $list_of_words_as_text =~ s/ +$// ;
            @list_of_words_to_check = split( / +/ , $list_of_words_as_text ) ;
            $list_of_words_as_text = $global_dashrep_replacement{ $operand_three } ;
            $list_of_words_as_text =~ s/\n/ /sg ;
            $list_of_words_as_text =~ s/^ +// ;
            $list_of_words_as_text =~ s/ +$// ;
            @list_of_strings_to_match = split( / +/ , $list_of_words_as_text ) ;
            $generated_list = "" ;
            foreach $word_to_check ( @list_of_words_to_check )
            {
                foreach $string_to_match ( @list_of_strings_to_match )
                {
                    $pointer_to_matching_text = index( $word_to_check , $string_to_match ) ;
                    if ( $pointer_to_matching_text >= 0 )
                    {
                        if ( $action_name eq "copy-words-that-contain-listed-words" )
                        {
                            $generated_list .= $word_to_check . " " ;
                            last ;
                        } elsif ( ( $pointer_to_matching_text == 0 ) && ( $action_name eq "copy-words-that-begin-with-listed-words" ) )
                        {
                            $generated_list .= $word_to_check . " " ;
                            last ;
                        }
                    }
                }
            }
            $generated_list =~ s/ +$// ;
            $global_dashrep_replacement{ $operand_two } = $generated_list ;
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  generate-every-pairwise-combination-of-words
#  generate-every-ordered-pairwise-combination-of-words

        if ( ( $action_name eq "generate-every-pairwise-combination-of-words" ) || ( $action_name eq "generate-every-ordered-pairwise-combination-of-words" ) )
        {
            $input_list_one_phrase_name = $operand_one ;
            $input_list_two_phrase_name = $operand_two ;
            $output_list_one_phrase_name = $operand_three ;
            $output_list_two_phrase_name = $operand_four ;
            $temp_text = $global_dashrep_replacement{ $input_list_one_phrase_name } ;
            $temp_text =~ s/\n/ /sg ;
            $temp_text =~ s/^ +// ;
            $temp_text =~ s/ +$// ;
            @input_list_one = split( / +/ , $temp_text ) ;
            $temp_text = $global_dashrep_replacement{ $input_list_two_phrase_name } ;
            $temp_text =~ s/\n/ /sg ;
            $temp_text =~ s/^ +// ;
            $temp_text =~ s/ +$// ;
            @input_list_two = split( / +/ , $temp_text ) ;
            $count_list_one = $#input_list_one + 1 ;
            $count_list_two = $#input_list_two + 1 ;
            if ( $count_list_one < 1 )
            {
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . ", operand " . $operand_one . " does not contain any words" . "}}\n" ;
                }
            } elsif ( $count_list_two < 1 )
            {
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . ", operand " . $operand_two . " does not contain any words" . "}}\n" ;
                }
            } else
            {
                $global_dashrep_replacement{ $output_list_one_phrase_name } = "" ;
                $global_dashrep_replacement{ $output_list_two_phrase_name } = "" ;
                $separator_one = " " ;
                $separator_two = " " ;
                $ending_first_count = $count_list_one ;
                $starting_second_count = 1 ;
                if ( $action_name eq "generate-every-ordered-pairwise-combination-of-words" )
                {
                    $ending_first_count -- ;
                }
                for ( $counter_one = 1 ; $counter_one <= $ending_first_count ; $counter_one ++ )
                {
                    $value_one = $input_list_one[ $counter_one - 1 ] ;
                    if ( $ending_first_count != $count_list_one )
                    {
                        $starting_second_count = $counter_one + 1 ;
                    }
                    for ( $counter_two = $starting_second_count ; $counter_two <= $count_list_two ; $counter_two ++ )
                    {
                        $value_two = $input_list_two[ $counter_two - 1 ] ;
                        if ( ( $counter_one == $ending_first_count ) && ( $counter_two == $count_list_two ) )
                        {
                            $separator_one = "" ;
                            $separator_two = "" ;
                        }
                        $global_dashrep_replacement{ $output_list_one_phrase_name } .= $value_one . $separator_one ;
                        $global_dashrep_replacement{ $output_list_two_phrase_name } .= $value_two . $separator_two ;
                    }
                }
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  zero-one-multiple
#  zero-or-nonzero

        if ( ( $action_name eq "zero-one-multiple" ) || ( $action_name eq "zero-or-nonzero" ) )
        {
            if ( ( $operand_one =~ /^[0-9]+$/ ) && ( $operand_one + 0 <= 0 ) )
            {
                $action_result = "zero" ;
            } elsif ( $action_name eq "zero-or-nonzero" )
            {
                $action_result = "nonzero" ;
            } elsif ( $operand_one + 0 == 1 )
            {
                $action_result = "one" ;
            } else
            {
                $action_result = "multiple" ;
            }
            $replacement_text = $text_begin . $action_result . $text_end ;
#  end of action code
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  yes-or-no-empty-phrase

        if ( $action_name eq "yes-or-no-empty-phrase" )
        {
            $action_result = "yes" ;
            if ( $number_of_operands == 1 )
            {
                if ( exists( $global_dashrep_replacement{ $operand_one } ) )
                {
                    if ( $global_dashrep_replacement{ $operand_one } =~ /[^ \n]/ )
                    {
                        $action_result = "no" ;
                    }
                }
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  get-count-of-characters

       if ( $action_name eq "get-count-of-characters" )
       {
            $action_result = "0" ;
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                $action_result = length( $global_dashrep_replacement{ $operand_one } ) ;
                if ( $action_result < 1 )
                {
                    $action_result = "0" ;
                }
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  numeric-increment
#  numeric-decrement

       if ( ( $action_name eq "numeric-increment" ) || ( $action_name eq "numeric-decrement" ) )
       {
            $result_value = 0 ;
            if ( exists( $global_dashrep_replacement{ $operand_one } ) && ( $global_dashrep_replacement{ $operand_one } =~ /^ *-?[0-9]+ *$/ ) )
            {
                $result_value = int( $global_dashrep_replacement{ $operand_one } ) ;
            }
            if ( $action_name eq "numeric-increment" )
            {
                $result_value ++ ;
            } else
            {
                $result_value -- ;
            }
            if ( $result_value == 0 )
            {
                $result_text = "0" ;
            } else
            {
                $result_text = sprintf( "%d" , $result_value ) ;
            }
            if ( $result_text =~ /^(-?[0-9]+)\.0*$/ )
            {
                $result_text = $1 ;
            }
            $global_dashrep_replacement{ $operand_one } = $result_text ;
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  yes-or-no-same-two-phrase-definitions

        if ( $action_name eq "yes-or-no-same-two-phrase-definitions" )
        {
            $action_result = "no" ;
            if ( ( not( exists( $global_dashrep_replacement{ $operand_one } ) ) ) && ( not( exists( $global_dashrep_replacement{ $operand_two } ) ) ) )
            {
                $action_result = "yes" ;
            } elsif ( not( exists( $global_dashrep_replacement{ $operand_one } ) ) )
            {
                if ( $global_dashrep_replacement{ $operand_two } eq "" )
                {
                    $action_result = "yes" ;
                } else
                {
                    $action_result = "no" ;
                }
            } elsif ( not( exists( $global_dashrep_replacement{ $operand_two } ) ) )
            {
                if ( $global_dashrep_replacement{ $operand_one } eq "" )
                {
                    $action_result = "yes" ;
                } else
                {
                    $action_result = "no" ;
                }
            } elsif ( ( $global_dashrep_replacement{ $operand_one } eq $global_dashrep_replacement{ $operand_two } ) )
            {
                $action_result = "yes" ;
            } else
            {
                $action_result = "no" ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  yes-or-no-same-two-words

        if ( $action_name eq "yes-or-no-same-two-words" )
        {
            $action_result = "no" ;
            if ( $number_of_operands == 2 )
            {
                if ( $operand_one eq $operand_two )
                {
                    $action_result = "yes" ;
                }
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  get-characters-from-position-to-position

        if ( $action_name eq "get-characters-from-position-to-position" )
        {
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                $string_in_phrase = $global_dashrep_replacement{ $operand_one } ;
                $phrase_length = length( $string_in_phrase ) ;
                $starting_character_position = $operand_two + 0 ;
                if ( $starting_character_position > $phrase_length )
                {
                    $starting_character_position = $phrase_length ;
                } elsif ( $starting_character_position < 0 )
                {
                    $starting_character_position = $phrase_length - $starting_character_position + 1 ;
                }
                $ending_character_position = $operand_three + 0 ;
                if ( ( $ending_character_position > $phrase_length ) || ( $ending_character_position == 0 ) )
                {
                    $ending_character_position = $phrase_length ;
                } elsif ( $ending_character_position < 0 )
                {
                    $ending_character_position = $phrase_length - $ending_character_position + 1 ;
                }
                $number_of_characters_to_get = $ending_character_position - $starting_character_position + 1 ;
                if ( $number_of_characters_to_get < 1 )
                {
                    $number_of_characters_to_get = 1 ;
                }
                $action_result = substr( $string_in_phrase , ( $starting_character_position - 1 ) , $number_of_characters_to_get ) ;
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; action " . $action_name . " got characters " . $action_result . "}}\n";
                }
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  numeric-minus

        if ( $action_name eq "numeric-minus" )
        {
            $numeric_value = ( $operand_one + 0 ) - ( $operand_two + 0 ) ;
            if ( $numeric_value == 0 )
            {
                $action_result = "0" ;
            } else
            {
                $action_result = sprintf( "%f" , $numeric_value ) ;
            }
            if ( $action_result =~ /^(-?[0-9]+)\.0*$/ )
            {
                $action_result = $1 ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  numeric-divide-by

        if ( $action_name eq "numeric-divide-by" )
        {
            if ( ( $operand_two + 0 ) == 0 )
            {
                $action_result = "infinity" ;
            } elsif ( ( $operand_one + 0 ) == 0 )
            {
                $action_result = "0" ;
            } else
            {
                $numeric_value = ( $operand_one + 0 ) / ( $operand_two + 0 ) ;
                $action_result = sprintf( "%f" , $numeric_value ) ;
            }
            if ( $action_result =~ /^(-?[0-9]+)\.0*$/ )
            {
                $action_result = $1 ;
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; operands for action " . $action_name . " are " . $operand_one . " and " . $operand_two . " , and result is " . $numeric_value . "}}\n" ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  numeric-add
#  numeric-multiply
#  numeric-maximum
#  numeric-minimum

        if ( ( $action_name eq "numeric-add" ) || ( $action_name eq "numeric-multiply" ) || ( $action_name eq "numeric-maximum" ) || ( $action_name eq "numeric-minimum" ) )
        {
            $action_result = "0" ;
            if ( $action_name eq "numeric-add" )
            {
                $numeric_value = 0 ;
            } elsif ( $action_name eq "numeric-multiply" )
            {
                $numeric_value = 1 ;
            } elsif ( $action_name eq "numeric-maximum" )
            {
                $numeric_value = -999999 ;
            } elsif ( $action_name eq "numeric-minimum" )
            {
                $numeric_value = 999999 ;
            } else
            {
                $numeric_value = 0 ;
            }
            $temp_text = $operands_all ;
            @list = split( /[ \n]+/ , $temp_text ) ;
            for ( $counter = 0 ; $counter <= $#list ; $counter ++ )
            {
                $value = $list[ $counter ] ;
                if ( $value =~ /^-?[0-9]+(\.[0-9]*)?$/ )
                {
                    if ( $action_name eq "numeric-add" )
                    {
                        $numeric_value = $numeric_value + $value ;
                    } elsif ( $action_name eq "numeric-multiply" )
                    {
                        $numeric_value = $numeric_value * $value ;
                    } elsif ( $action_name eq "numeric-maximum" )
                    {
                        if ( $value > $numeric_value )
                        {
                            $numeric_value = $value ;
                        }
                    } elsif ( $action_name eq "numeric-minimum" )
                    {
                        if ( $value < $numeric_value )
                        {
                            $numeric_value = $value ;
                        }
                    }
                }
            }
            if ( $numeric_value == 0 )
            {
                $action_result = "0" ;
            } else
            {
                $action_result = sprintf( "%f" , $numeric_value ) ;
            }
            if ( $action_result =~ /^(-?[0-9]+)\.0*$/ )
            {
                $action_result = $1 ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  numeric-absolute

        if ( $action_name eq "numeric-absolute" )
        {
            $result_value = abs( $operand_one + 0 ) ;
            if ( $result_value == 0 )
            {
                $action_result = "0" ;
            } else
            {
                $action_result = sprintf( "%d" , $result_value ) ;
            }
            if ( $action_result =~ /^(-?[0-9]+)\.0*$/ )
            {
                $action_result = $1 ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  numeric-integer
#  numeric-odd-or-even
#  numeric-sine
#  numeric-cosine
#  numeric-logarithm-base-e
#  numeric-logarithm-base-10
#  numeric-y-map-tile-number-based-on-latitude

        if ( ( $action_name eq "numeric-integer" ) || ( $action_name eq "numeric-sine" ) || ( $action_name eq "numeric-cosine" ) || ( $action_name eq "numeric-logarithm-base-e" ) || ( $action_name eq "numeric-logarithm-base-10" ) || ( $action_name eq "numeric-y-map-tile-number-based-on-latitude" )|| ( $action_name eq "numeric-odd-or-even" ) )
        {
            if ( $action_name eq "numeric-integer" )
            {
                $result_value = int( $operand_one + 0 ) ;
                if ( $result_value == 0 )
                {
                    $action_result = "0" ;
                } else
                {
                    $action_result = sprintf( "%d" , $result_value ) ;
                }
                if ( $action_result =~ /^(-?[0-9]+)\.0*$/ )
                {
                    $action_result = $1 ;
                }
            } elsif ( $action_name eq "numeric-odd-or-even" )
            {
                $result_value = int( $operand_one + 0 ) ;
                $result_value = $result_value - int( ( $result_value * 2 ) / 2 ) ;
                if ( $result_value == 0 )
                {
                    $action_result = "even" ;
                } else
                {
                    $action_result = "odd" ;
                }
            } elsif ( $action_name eq "numeric-sine" )
            {
                $result_value = sin( $operand_one + 0.0 ) ;
                if ( $result_value == 0 )
                {
                    $action_result = "0" ;
                } else
                {
                    $action_result = sprintf( "%f" , $result_value ) ;
                }
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; for action " . $action_name . " and input value " . $operand_one . " , result is " . $result_value . "}}\n" ;
                }
            } elsif ( $action_name eq "numeric-cosine" )
            {
                $result_value = cos( $operand_one + 0.0 ) ;
                if ( $result_value == 0 )
                {
                    $action_result = "0" ;
                } else
                {
                    $action_result = sprintf( "%f" , $result_value ) ;
                }
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; for action " . $action_name . " and input value " . $operand_one . " , result is " . $result_value . "}}\n" ;
                }
            } elsif ( $action_name eq "numeric-logarithm-base-e" )
            {
                if ( $operand_one + 0.0 < 0.000001 )
                {
                    $result_value = -999999 ;
                } else
                {
                    $result_value = log( $operand_one + 0.0 ) ;
                }
                if ( $result_value == 0 )
                {
                    $action_result = "0" ;
                } else
                {
                    $action_result = sprintf( "%f" , $result_value ) ;
                }
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; for action " . $action_name . " and input value " . $operand_one . " , result is " . $result_value . "}}\n" ;
                }
            } elsif ( $action_name eq "numeric-logarithm-base-10" )
            {
                if ( $operand_one + 0.0 < 0.000001 )
                {
                    $result_value = -999999 ;
                } else
                {
                    $result_value = ( log( $operand_one + 0.0 ) ) / ( log( 10.0 ) ) ;
                }
                if ( $result_value == 0 )
                {
                    $action_result = "0" ;
                } else
                {
                    $action_result = sprintf( "%f" , $result_value ) ;
                }
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; for action " . $action_name . " and input value " . $operand_one . " , result is " . $result_value . "}}\n" ;
                }
            } elsif ( $action_name eq "numeric-y-map-tile-number-based-on-latitude" )
            {
                if ( ( $operand_one > 85.0 ) || ( $operand_one < -85.0 ) )
                {
                    $action_result = $global_dashrep_replacement{ "dashrep-undefined" } ;
                    $replacement_text = $text_begin . $action_result . $text_end ;
                    if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; warning, for action " . $action_name . " , angle is outside of valid range: " . $operand_one . "}}\n" ;
                    }
                    next ;
                }
                if ( ( exists( $global_dashrep_replacement{ "numeric-map-tile-zoom" } ) ) && ( $global_dashrep_replacement{ "numeric-map-tile-zoom" } =~ /^[0-9]+$/ ) )
                {
                    $map_tile_zoom = $global_dashrep_replacement{ "numeric-map-tile-zoom" } + 0 ;
                } else
                {
                    $map_tile_zoom = 16 ;
                }
                $map_tile_n = 2 ** $map_tile_zoom ;
                $pi = 4.0 * atan2( 1.0 , 1.0 ) ;
                $global_dashrep_replacement{ "numeric-pi" } = sprintf( "%f" , $pi ) ;
                $angle_in_radians = ( $operand_one + 0.0 ) * $pi / 180.0 ;
                $sine_of_angle = sin( $angle_in_radians ) ;
                $cosine_of_angle = cos( $angle_in_radians ) ;
                $result_value = $map_tile_n * ( 1.0 - ( log( ( $sine_of_angle / $cosine_of_angle ) + ( 1 / $cosine_of_angle ) ) / $pi ) ) / 2.0 ;
                if ( $result_value == 0 )
                {
                    $action_result = "0" ;
                } else
                {
                    $action_result = sprintf( "%f" , $result_value ) ;
                }
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; for action " . $action_name . " and input value " . $operand_one . " , result is " . $result_value . "}}\n" ;
                    $global_trace_log .= "{{trace; calculation details, zoom = " . $map_tile_zoom . " , n = " . $map_tile_n . " , angle in radians = " . $angle_in_radians . " , sine = " . $sine_of_angle . " , cosine = " . $cosine_of_angle . " , pi = " . $pi . "}}\n" ;
                }
            }
            if ( $action_result =~ /^(-?[0-9]+)\.0*$/ )
            {
                $action_result = $1 ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  numeric-vector-add-number
#  numeric-vector-multiply-by-number
#  numeric-vectors-add
#  numeric-vectors-multiply
#  numeric-vectors-divide-by
#  numeric-vectors-from-delta-values-calculate-distances
#  numeric-vector-integers
#  numeric-vector-absolutes
#
#  Reminder: target phrase name might be the same as the source phrase name

        if ( ( $action_name eq "numeric-vector-add-number" ) || ( $action_name eq "numeric-vector-multiply-by-number" ) || ( $action_name eq "numeric-vectors-add" ) ||  ( $action_name eq "numeric-vectors-multiply" ) ||  ( $action_name eq "numeric-vectors-divide-by" ) || ( $action_name eq "numeric-vectors-from-delta-values-calculate-distances" ) || ( $action_name eq "numeric-vector-integers" ) || ( $action_name eq "numeric-vector-absolutes" ) )
        {
            $single_value = 0 ;
            $required_number_of_operands = $global_required_number_of_operands_for_action{ $action_name } ;
            if ( $required_number_of_operands == 3 )
            {
                $target_operand = $operand_three ;
            } else
            {
                $target_operand = $operand_two ;
            }
            if ( ( $action_name eq "numeric-vector-add-number" ) || ( $action_name eq "numeric-vector-multiply-by-number" ) )
            {
                $single_value = $operand_two + 0 ;
            }
            if ( $global_dashrep_replacement{ $operand_one } !~ /^[ \-0-9\.]+$/ )
            {
                $action_result = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $action_result . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            $list_of_x_values_as_text = $global_dashrep_replacement{ $operand_one } ;
            $list_of_x_values_as_text =~ s/\n/ /s ;
            $list_of_x_values_as_text =~ s/^ +// ;
            $list_of_x_values_as_text =~ s/ +$// ;
            @list_of_x_values = split( / +/ , $list_of_x_values_as_text ) ;
            $global_dashrep_replacement{ $target_operand } = "" ;
            if ( ( $action_name eq "numeric-vectors-add" ) || ( $action_name eq "numeric-vectors-multiply" ) || ( $action_name eq "numeric-vectors-divide-by" ) || ( $action_name eq "numeric-vectors-from-delta-values-calculate-distances" ) )
            {
                $list_of_y_values_as_text = $global_dashrep_replacement{ $operand_two } ;
                $list_of_y_values_as_text =~ s/\n/ /s ;
                $list_of_y_values_as_text =~ s/^ +// ;
                $list_of_y_values_as_text =~ s/ +$// ;
                @list_of_y_values = split( / +/ , $list_of_y_values_as_text ) ;
            }
            for( $pair_pointer = 0 ; $pair_pointer <= $#list_of_x_values ; $pair_pointer ++ )
            {
                if ( $action_name eq "numeric-vectors-add" )
                {
                    $numeric_value = $list_of_x_values[ $pair_pointer ] + $list_of_y_values[ $pair_pointer ] + 0 ;
                } elsif ( $action_name eq "numeric-vectors-multiply" )
                {
                    $numeric_value = $list_of_x_values[ $pair_pointer ] * $list_of_y_values[ $pair_pointer ] + 0 ;
                } elsif ( $action_name eq "numeric-vectors-divide-by" )
                {
                    if ( abs( $list_of_y_values[ $pair_pointer ] ) < 0.000001 )
                    {
                        $numeric_value = 1000000 ;
                    } else
                    {
                        $numeric_value = $list_of_x_values[ $pair_pointer ] / $list_of_y_values[ $pair_pointer ] + 0 ;
                    }
                } elsif ( $action_name eq "numeric-vectors-from-delta-values-calculate-distances" )
                {
                    $numeric_value =  int( sqrt( ( $list_of_x_values[ $pair_pointer ] ** 2 ) + ( $list_of_y_values[ $pair_pointer ] ** 2 ) ) + 0.5 ) ;
                } elsif ( $action_name eq "numeric-vector-add-number" )
                {
                    $numeric_value = $list_of_x_values[ $pair_pointer ] + $single_value + 0 ;
                } elsif ( $action_name eq "numeric-vector-multiply-by-number" )
                {
                    $numeric_value = $list_of_x_values[ $pair_pointer ] * $single_value ;
                } elsif ( $action_name eq "numeric-vector-integers" )
                {
                    $numeric_value = int( $list_of_x_values[ $pair_pointer ] + 0 ) ;
                } elsif ( $action_name eq "numeric-vector-absolutes" )
                {
                    $numeric_value = abs( $list_of_x_values[ $pair_pointer ] + 0 ) ;
                }
                if ( $numeric_value == 0 )
                {
                    $global_dashrep_replacement{ $target_operand } .= "0 " ;
                } else
                {
                    $global_dashrep_replacement{ $target_operand } .= sprintf( "%d" , $numeric_value ) . " " ;
                }
            }
            $global_dashrep_replacement{ $operand_three } =~ s/ +$// ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; action " . $action_name . " did vector calculations" . "}}\n";
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  numeric-two-dimensional-sort-into-columns-and-rows
#
#  operand order:
#    number of columns
#    word-based (space-delimited) list of column-direction values for sorting (increasing to right)
#    word-based (space-delimited) list of row-direction values for sorting (increasing to top)
#    name of phrase into which to put the results, which are space-delimited strings such as "row-3-column-2" and "row-1-column-1"
#
#  number of rows is calculated based on number of values

        if ( $action_name eq "numeric-two-dimensional-sort-into-columns-and-rows" )
        {
            if ( ( $operand_one + 0 ) < 1 )
            {
                $replacement_text = $text_begin . $action_result . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , number of columns (" . $operand_one . ") is less than 1" . "}}\n" ;
                }
                next ;
            }
            if ( $global_dashrep_replacement{ $operand_two } !~ /^[\-0-9\. ]+$/ )
            {
                $replacement_text = $text_begin . $action_result . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , second operand contains invalid values: " . $global_dashrep_replacement{ $operand_two } . "}}\n" ;
                }
                next ;
            }
            if ( $global_dashrep_replacement{ $operand_three } !~ /^[\-0-9\. ]+$/ )
            {
                $replacement_text = $text_begin . $action_result . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , third operand contains invalid values: " . $global_dashrep_replacement{ $operand_three } . "}}\n" ;
                }
                next ;
            }
            $number_of_columns = $operand_one ;
            $text_for_right_direction_values = $global_dashrep_replacement{ $operand_two } ;
            $text_for_up_direction_values = $global_dashrep_replacement{ $operand_three } ;
            $text_for_up_direction_values =~ s/\n/ /s ;
            $text_for_up_direction_values =~ s/^ +// ;
            $text_for_up_direction_values =~ s/ +$// ;
            $text_for_right_direction_values =~ s/\n/ /s ;
            $text_for_right_direction_values =~ s/^ +// ;
            $text_for_right_direction_values =~ s/ +$// ;
            @up_direction_value_for_item_number = split( / +/ , $text_for_up_direction_values ) ;
            unshift( @up_direction_value_for_item_number , 0 ) ;
            @right_direction_value_for_item_number = split( / +/ , $text_for_right_direction_values ) ;
            unshift( @right_direction_value_for_item_number , 0 ) ;
            $number_of_items = $#up_direction_value_for_item_number ;
            if ( ( $#up_direction_value_for_item_number != $#right_direction_value_for_item_number ) && ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" ) )
            {
                $replacement_text = $text_begin . $action_result . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , second operand (" . $operand_two . ") and third operand (". $operand_three . ") do not have the same number of values" . "}}\n" ;
                }
                next ;
            }
            if ( ( $number_of_items == 0 ) && ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" ) )
            {
                $replacement_text = $text_begin . $action_result . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , the second operand (" . $operand_two . ") and third operand (". $operand_three . ") are empty" . "}}\n" ;
                }
                next ;
            }
            $number_of_items_in_bottom_row = $number_of_columns ;
            $number_of_full_rows = int( $number_of_items / $number_of_columns ) ;
            $number_of_rows = $number_of_full_rows ;
            if ( ( $number_of_full_rows * $number_of_columns ) < $number_of_items )
            {
                $number_of_rows ++ ;
                $number_of_items_in_bottom_row = $number_of_items - ( $number_of_full_rows * $number_of_columns ) ;
            }
            @list_of_remaining_item_numbers = ( ) ;
            $up_direction_minimum_value = 999999 ;
            $up_direction_maximum_value = -999999 ;
            $right_direction_minimum_value = 999999 ;
            $right_direction_maximum_value = -999999 ;
            for ( $item_number = 1 ; $item_number <= $number_of_items ; $item_number ++ )
            {
                $zero_if_not_remaining_item_number[ $item_number ] = $item_number ;
                if ( $up_direction_value_for_item_number[ $item_number ] < $up_direction_minimum_value )
                {
                    $up_direction_minimum_value = $up_direction_value_for_item_number[ $item_number ] ;
                }
                if ( $up_direction_value_for_item_number[ $item_number ] > $up_direction_maximum_value )
                {
                    $up_direction_maximum_value = $up_direction_value_for_item_number[ $item_number ] ;
                }
                if ( $right_direction_value_for_item_number[ $item_number ] < $right_direction_minimum_value )
                {
                    $right_direction_minimum_value = $right_direction_value_for_item_number[ $item_number ] ;
                }
                if ( $right_direction_value_for_item_number[ $item_number ] > $right_direction_maximum_value )
                {
                    $right_direction_maximum_value = $right_direction_value_for_item_number[ $item_number ] ;
                }
                push( @list_of_remaining_item_numbers , $item_number ) ;
            }
            $range_of_up_direction_values = $up_direction_maximum_value - $up_direction_minimum_value ;
            $range_of_right_direction_values = $right_direction_maximum_value - $right_direction_minimum_value ;
            if ( $range_of_up_direction_values > 0.0001 )
            {
                $multiplier_for_up_direction_values = $number_of_rows * 100.00 / $range_of_up_direction_values ;
            } else
            {
                $multiplier_for_up_direction_values = $number_of_rows * 1.0 ;
                $up_direction_minimum_value = $up_direction_minimum_value - 1.0 ;
            }
            if ( $range_of_right_direction_values > 0.0001 )
            {
                $multiplier_for_right_direction_values = $number_of_columns * 100.00 / $range_of_right_direction_values ;
            } else
            {
                $multiplier_for_right_direction_values = $number_of_columns * 1.0 ;
                $right_direction_minimum_value = $right_direction_minimum_value - 1.0 ;
            }
            for ( $item_number = 1 ; $item_number <= $number_of_items ; $item_number ++ )
            {
                $up_direction_value_for_item_number[ $item_number ] = ( $up_direction_value_for_item_number[ $item_number ] - $up_direction_minimum_value ) * $multiplier_for_up_direction_values ;
                $right_direction_value_for_item_number[ $item_number ] = ( $right_direction_value_for_item_number[ $item_number ] - $right_direction_minimum_value ) * $multiplier_for_right_direction_values ;
            }
            for ( $item_number = 1 ; $item_number <= $number_of_items ; $item_number ++ )
            {
                $right_and_up_direction_value_for_item_number[ $item_number ] = $right_direction_value_for_item_number[ $item_number ] + $up_direction_value_for_item_number[ $item_number ] ;
                $left_and_up_direction_value_for_item_number[ $item_number ] = - $right_direction_value_for_item_number[ $item_number ] + $up_direction_value_for_item_number[ $item_number ] ;
            }
            $top_row_number = 1 ;
            $bottom_row_number = $number_of_rows ;
            $fill_direction_top_left = 1 ;
            $fill_direction_bottom_right = 2 ;
            $fill_direction_bottom_left = 3 ;
            $fill_direction_top_right = 4 ;
            $need_maximum = 1 ;
            $need_minimum = 2 ;
            $value_direction_right_and_up = 1 ;
            $value_direction_left_and_up = 2 ;
            $value_direction_up = 3 ;
            $value_direction_right = 4 ;
            $top_left_open_column = 1 ;
            $top_right_open_column = $number_of_columns ;
            $bottom_left_open_column = 1 ;
            $bottom_right_open_column = $number_of_items_in_bottom_row ;
            $number_of_items_remaining = $number_of_items ;
            while ( $number_of_items_remaining > 0 )
            {
                for ( $fill_direction = $fill_direction_top_left ; $fill_direction <= $fill_direction_top_right ; $fill_direction ++ )
                {
                    if ( $fill_direction == $fill_direction_top_left )
                    {
                        $target_row_number = $top_row_number ;
                        $target_column_number = $top_left_open_column ;
                        if ( $top_row_number == $bottom_row_number )
                        {
                            $need_maximum_or_minimum = $need_minimum ;
                            $use_value_direction = $value_direction_right ;
                        } elsif ( $top_left_open_column < $top_right_open_column )
                        {
                            $need_maximum_or_minimum = $need_maximum ;
                            $use_value_direction = $value_direction_left_and_up ;
                        } elsif ( $top_left_open_column == $top_right_open_column )
                        {
                            $need_maximum_or_minimum = $need_maximum ;
                            $use_value_direction = $value_direction_up ;
                        } else
                        {
                            next ;
                        }
                    } elsif ( $fill_direction == $fill_direction_bottom_right )
                    {
                        $target_row_number = $bottom_row_number ;
                        $target_column_number = $bottom_right_open_column ;
                        if ( $top_row_number == $bottom_row_number )
                        {
                            $need_maximum_or_minimum = $need_maximum ;
                            $use_value_direction = $value_direction_right ;
                        } elsif ( ( $bottom_row_number == $number_of_rows ) && ( $bottom_right_open_column > $number_of_items_in_bottom_row ) )
                        {
                            $bottom_right_open_column -- ;
                            next ;
                        } elsif ( $bottom_left_open_column < $bottom_right_open_column )
                        {
                            $need_maximum_or_minimum = $need_minimum ;
                            $use_value_direction = $value_direction_left_and_up ;
                        } elsif ( $bottom_left_open_column == $bottom_right_open_column )
                        {
                            $need_maximum_or_minimum = $need_minimum ;
                            $use_value_direction = $value_direction_up ;
                        } else
                        {
                            next ;
                        }
                    } elsif ( $fill_direction == $fill_direction_bottom_left )
                    {
                        $target_row_number = $bottom_row_number ;
                        $target_column_number = $bottom_left_open_column ;
                        if ( $top_row_number == $bottom_row_number )
                        {
                            next ;
                        } elsif ( ( $bottom_row_number == $number_of_rows ) && ( $bottom_left_open_column > $number_of_items_in_bottom_row ) )
                        {
                            $bottom_row_number -- ;
                            $bottom_left_open_column = 1 ;
                            $bottom_right_open_column = $number_of_columns ;
                            $need_maximum_or_minimum = $need_minimum ;
                            $use_value_direction = $value_direction_right_and_up ;
                        } elsif ( $bottom_left_open_column < $bottom_right_open_column )
                        {
                            $need_maximum_or_minimum = $need_minimum ;
                            $use_value_direction = $value_direction_right_and_up ;
                        } elsif ( $bottom_left_open_column == $bottom_right_open_column )
                        {
                            $need_maximum_or_minimum = $need_minimum ;
                            $use_value_direction = $value_direction_up ;
                        } else
                        {
                            next ;
                        }
                    } elsif ( $fill_direction == $fill_direction_top_right )
                    {
                        $target_row_number = $top_row_number ;
                        $target_column_number = $top_right_open_column ;
                        if ( $top_row_number == $bottom_row_number )
                        {
                            next ;
                        } elsif ( $top_left_open_column < $top_right_open_column )
                        {
                            $need_maximum_or_minimum = $need_maximum ;
                            $use_value_direction = $value_direction_left_and_up ;
                        } elsif ( $top_left_open_column == $top_right_open_column )
                        {
                            $need_maximum_or_minimum = $need_maximum ;
                            $use_value_direction = $value_direction_up ;
                        } else
                        {
                            next ;
                        }
                    }
                    if ( $need_maximum_or_minimum == $need_maximum )
                    {
                        $max_or_min_value = -999999 ;
                    } else
                    {
                        $max_or_min_value = 999999 ;
                    }
                    $item_number_at_min_or_max = 0 ;
                    foreach ( $item_number = 1 ; $item_number <= $number_of_items ; $item_number ++ )
                    {
                        if ( $zero_if_not_remaining_item_number[ $item_number ] >= 1 )
                        {
                            if ( $use_value_direction == $value_direction_right_and_up )
                            {
                                $next_value_to_compare = $right_and_up_direction_value_for_item_number[ $item_number ] ;
                            } elsif ( $use_value_direction == $value_direction_left_and_up )
                            {
                                $next_value_to_compare = $left_and_up_direction_value_for_item_number[ $item_number ] ;
                            } elsif ( $use_value_direction == $value_direction_up )
                            {
                                $next_value_to_compare = $up_direction_value_for_item_number[ $item_number ] ;
                            } elsif ( $use_value_direction == $value_direction_right )
                            {
                                $next_value_to_compare = $right_direction_value_for_item_number[ $item_number ] ;
                            } else
                            {
                                next ;
                            }
                            if ( $need_maximum_or_minimum == $need_maximum )
                            {
                                if ( $next_value_to_compare > $max_or_min_value )
                                {
                                    $max_or_min_value = $next_value_to_compare ;
                                    $item_number_at_min_or_max = $item_number ;
                                }
                            } else
                            {
                                if ( $next_value_to_compare < $max_or_min_value )
                                {
                                    $max_or_min_value = $next_value_to_compare ;
                                    $item_number_at_min_or_max = $item_number ;
                                }
                            }
                        }
                    }
                    $column_position_for_item_number[ $item_number_at_min_or_max ] = $target_column_number ;
                    $row_position_for_item_number[ $item_number_at_min_or_max ] = $target_row_number ;
                    if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; 2-d info: " . $item_number_at_min_or_max . " " . $target_row_number . " " . $target_column_number . " " . $top_row_number . " " . $bottom_row_number . " " . $top_left_open_column . " " . $top_right_open_column . " " . $bottom_left_open_column . " " . $bottom_right_open_column . " " . $fill_direction . " " . $need_maximum_or_minimum . "}}\n" ;
                    }
#                   Do NOT change (or remove) next line, else endless loop is likely:
                    $number_of_items_remaining -- ;
                    if ( $number_of_items_remaining < 1 )
                    {
                        last ;
                    }
                    if ( $fill_direction == $fill_direction_top_left )
                    {
                        $top_left_open_column ++ ;
                    } elsif ( $fill_direction == $fill_direction_bottom_right )
                    {
                        $bottom_right_open_column -- ;
                    } elsif ( $fill_direction == $fill_direction_bottom_left )
                    {
                        $bottom_left_open_column ++ ;
                    } elsif ( $fill_direction == $fill_direction_top_right )
                    {
                        $top_right_open_column -- ;
                    }
                    $zero_if_not_remaining_item_number[ $item_number_at_min_or_max ] = 0 ;
                }
                if ( $number_of_items_remaining < 1 )
                {
                    last ;
                }
                if ( $top_left_open_column > $top_right_open_column )
                {
                    $top_row_number ++ ;
                    $top_left_open_column = 1 ;
                    $top_right_open_column = $number_of_columns ;
                }
                if ( $bottom_left_open_column > $bottom_right_open_column )
                {
                    $bottom_row_number -- ;
                    $bottom_left_open_column = 1 ;
                    $bottom_right_open_column = $number_of_columns ;
                }
                if ( $top_row_number == $bottom_row_number )
                {
                    if ( $top_left_open_column > $bottom_left_open_column )
                    {
                        $bottom_left_open_column = $top_left_open_column ;
                    }
                    if ( $top_left_open_column < $bottom_left_open_column )
                    {
                        $top_left_open_column = $bottom_left_open_column ;
                    }
                    if ( $top_right_open_column > $bottom_right_open_column )
                    {
                        $top_right_open_column = $bottom_right_open_column ;
                    }
                    if ( $top_right_open_column < $bottom_right_open_column )
                    {
                        $bottom_right_open_column = $top_right_open_column ;
                    }
                }
            }
            $final_result = "" ;
            for ( $item_number = 1 ; $item_number <= $number_of_items ; $item_number ++ )
            {
                $row_number = $row_position_for_item_number[ $item_number ] ;
                $column_number = $column_position_for_item_number[ $item_number ] ;
                $final_result .= "row-" . $row_number . "-column-" . $column_number . " " ;
                $item_number_at_row_column{ $row_number . "" . $column_number } = $item_number ;
            }
            $final_result =~ s/ +$// ;
            $global_dashrep_replacement{ $operand_four } = $final_result ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; " . $number_of_items . " items , " . $number_of_columns . " columns , " . $number_of_rows . " rows , " . $number_of_items_in_bottom_row . " items in bottom row}}\n" ;
                $global_trace_log .= "{{trace; two-dimensionally sorted items}}\n" ;
                for ( $row_number = 1 ; $row_number <= $number_of_rows ; $row_number ++ )
                {
                    $global_trace_log .= "{{row " . $row_number . ":  " ;
                    for ( $column_number = 1 ; $column_number <= $number_of_columns ; $column_number ++ )
                    {
                        if ( ( $row_number < $number_of_rows ) || ( ( $row_number == $number_of_rows ) && ( $column_number <= $number_of_items_in_bottom_row ) ) )
                        {
                            $item_number = $item_number_at_row_column{ $row_number . "" . $column_number } ;
                            $global_trace_log .= "item " . $item_number . " (" . $up_direction_value_for_item_number[ $item_number ] . " " . $right_direction_value_for_item_number[ $item_number ] . ") " ;
                        }
                    }
                    $global_trace_log .= "}}\n" ;
                }
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  get-current-time-in-epoch-seconds

        if ( $action_name eq "get-current-time-in-epoch-seconds" )
        {
            $epoch_seconds = time ;
            $action_result = sprintf( "%d" , $epoch_seconds ) ;
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  split-epoch-seconds-into-named-components
#  split-epoch-seconds-into-named-components-for-zero-meridian

        if ( ( $action_name eq "split-epoch-seconds-into-named-components" ) || ( $action_name eq "split-epoch-seconds-into-named-components-for-zero-meridian" ) )
        {
            if ( $operand_one !~ /^[\-0-9\.]+$/ )
            {
                $replacement_text = $text_begin . $action_result . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( $action_name eq "split-epoch-seconds-into-named-components" )
            {
                ( $second_time , $minute , $hour , $day_of_month , $month_number , $year , $weekday , $day_of_year , $extra_info ) = localtime( $operand_one ) ;
            } else
            {
                ( $second_time , $minute , $hour , $day_of_month , $month_number , $year , $weekday , $day_of_year , $extra_info ) = gmtime( $operand_one ) ;
            }
            $month_number ++ ;
            $year += 1900 ;
            $global_dashrep_replacement{ "time-second" } = sprintf( "%d" , $second_time ) ;
            $global_dashrep_replacement{ "time-minute" } = sprintf( "%d" , $minute ) ;
            $global_dashrep_replacement{ "time-hour" } = sprintf( "%d" , $hour ) ;
            $global_dashrep_replacement{ "time-day-of-month" } = sprintf( "%d" , $day_of_month ) ;
            $global_dashrep_replacement{ "time-month-number" } = sprintf( "%d" , $month_number ) ;
            $global_dashrep_replacement{ "time-year" } = sprintf( "%d" , $year ) ;
            $global_dashrep_replacement{ "time-day-of-week" } = sprintf( "%d" , $weekday ) ;
            $global_dashrep_replacement{ "time-day-of-year" } = sprintf( "%d" , $day_of_year ) ;
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  use-handler-with-each-word-in-phrase
#  use-handler-with-each-word-in-phrase-currently-at-character-position
#
#  Note about the action:
#    use-handler-with-each-word-in-phrase-currently-at-character-position
#  This action is intended for internal use only, so some of
#  its operands are not checked for validity.

        if ( ( $action_name eq "use-handler-with-each-word-in-phrase" ) || ( $action_name eq "use-handler-with-each-word-in-phrase-currently-at-character-position" ) )
        {
            $name_of_parameter_for_handler = "word-to-use-in-handler" ;
            $handler_phrase_name = $operand_one ;
            if ( not( exists( $global_dashrep_replacement{ $operand_two } ) ) )
            {
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            if ( ( $action_name eq "use-handler-with-each-word-in-phrase" ) && ( ( $global_dashrep_replacement{ $operand_two } =~ /^ / ) || ( $global_dashrep_replacement{ $operand_two } =~ / $/ ) || ( $global_dashrep_replacement{ $operand_two } =~ /  / ) ) )
            {
                $list_of_words_as_text = $global_dashrep_replacement{ $operand_two } ;
                $list_of_words_as_text =~ s/[ \n][ \n\r]+/ /sg ;
                $list_of_words_as_text =~ s/^ //s ;
                $list_of_words_as_text =~ s/ $//s ;
                $global_dashrep_replacement{ $operand_two } = $list_of_words_as_text ;
            }
            $text_to_expand = " [-" . $handler_phrase_name . "-] " ;
            $current_character_position_number = 1 ;
            if ( $action_name eq "use-handler-with-each-word-in-phrase-currently-at-character-position" )
            {
                $current_character_position_number = $operand_three + 0 ;
            }
            $character_pointer_to_next_word_zero_based = 1 + index( $global_dashrep_replacement{ $operand_two } , " " , ( $current_character_position_number - 1 ) ) ;
            if ( $character_pointer_to_next_word_zero_based > 0 )
            {
                $global_dashrep_replacement{ $name_of_parameter_for_handler } = substr( $global_dashrep_replacement{ $operand_two } , ( $current_character_position_number - 1 ) , ( $character_pointer_to_next_word_zero_based - $current_character_position_number ) ) ;
                $current_character_position_number = $character_pointer_to_next_word_zero_based + 1 ;
                $text_to_expand .= "[-use-handler-with-each-word-in-phrase-currently-at-character-position " . $operand_one . " " . $operand_two . " " . sprintf( "%d" , $current_character_position_number ) . "-] " ;
            } else
            {
                $global_dashrep_replacement{ $name_of_parameter_for_handler } = substr( $global_dashrep_replacement{ $operand_two } , ( $current_character_position_number - 1 ) ) ;
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                if ( $action_name eq "use-handler-with-each-word-in-phrase" )
                {
                    $global_trace_log .= "{{trace; action " . $action_name . " creating code that will use handler " . $operand_one . " with each word in phrase " . $operand_two . "}}\n";
                }
            }
#  end of action code
            $replacement_text = $text_begin . $text_to_expand . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  trace-show

        if ( $action_name eq "trace-show" )
        {
            if ( ( $operand_one !~ /^[\-_]/ ) && ( $operand_one !~ /[\-_]$/ ) )
            {
                if ( exists( $global_dashrep_replacement{ $operand_one } ) )
                {
                    $value_of_operand_one = $global_dashrep_replacement{ $operand_one } ;
                    if ( $value_of_operand_one =~ /[^ ]/s )
                    {
                        $global_trace_log .= "{{trace; ******* " . $operand_one . " = " . $value_of_operand_one . " *******" . "}}\n";
                    } else
                    {
                        $global_trace_log .= "{{trace; ******* " . $operand_one . " is empty *******" . "}}\n";
                    }
                } else
                {
                    $global_trace_log .= "{{trace; ******* " . $operand_one . " is not defined *******" . "}}\n";
                }
            } else
            {
                $global_trace_log .= "{{trace; ******* " . $operand_one . " does not look like a valid phrase name *******" . "}}\n";
            }
            $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= $global_trace_log ;
            $global_trace_log = "" ;
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  generate-phrase-usage-counts

       if ( $action_name eq "generate-phrase-usage-counts" )
       {
            $result_text = "" ;
            foreach $phrase_name ( keys( %global_replacement_count_for_item_name ) )
            {
                $replacement_count = $global_replacement_count_for_item_name{ $phrase_name } ;
                if ( $endless_loop_replacements_with_count{ sprintf( "%08d" , $replacement_count ) } ne "" )
                {
                    $endless_loop_replacements_with_count{ sprintf( "%08d" , $replacement_count ) } .= "\n" ;
                }
                $endless_loop_replacements_with_count{ sprintf( "%08d" , $replacement_count ) } .= $phrase_name ;
            }
            foreach $replacement_count_text ( reverse( sort( keys( %endless_loop_replacements_with_count ) ) ) )
            {
                @list_of_phrase_names = sort( split( /\n/ , $endless_loop_replacements_with_count{ $replacement_count_text } ) ) ;
                foreach $phrase_name ( @list_of_phrase_names )
                {
                    $result_text .= $replacement_count_text . " " . $phrase_name  . "\n" ;
                }
            }
            $global_dashrep_replacement{ $operand_one } = $result_text ;
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  if-yes-begin
#  if-no-begin
#
#  This action recognizes the strings:
#  [-if-else-]
#  [-if-end-]

        if ( ( $action_name eq "if-yes-begin" ) || ( $action_name eq "if-no-begin" ) )
        {
            if ( $action_name eq "if-yes-begin" )
            {
                if ( $operand_one =~ /yes/i )
                {
                    $first_or_second = "first" ;
                } else
                {
                    $first_or_second = "second" ;
                }
            } else
            {
                if ( $operand_one =~ /no/i )
                {
                    $first_or_second = "first" ;
                } else
                {
                    $first_or_second = "second" ;
                }
            }
            if ( $text_end =~ /^(.*?)\[- *if-end *-\](.*)$/ )
            {
                $segment_that_might_include_else = $1 ;
                $remainder = $2 ;
                if ( $segment_that_might_include_else =~ /^(.*?)\[- *if-else *-\](.*)$/ )
                {
                    $segment_if_first = $1 ;
                    $segment_if_second = $2 ;
                    if ( $first_or_second eq "first" )
                    {
                        $text_end = $segment_if_first . " " . $remainder ;
                    } else
                    {
                        $text_end = $segment_if_second . " " . $remainder ;
                    }
                } else
                {
                    if ( $first_or_second eq "first" )
                    {
                        $text_end = $segment_that_might_include_else . " " . $remainder ;
                    } else
                    {
                        $text_end = " " . $remainder ;
                    }
                }
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; handling action " . $action_name . " for case " . $first_or_second . "}}\n" ;
            }
#  end of action code
            $replacement_text = $text_begin . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the INVALID actions:
#  [-if-else-]
#  [-if-end-]
#
#  These pseudo-actions should have been removed
#  by the actions "if-yes-begin" and "if-no-begin",
#  so those valid actions are missing.

        if ( ( $action_name eq "if-else" ) || ( $action_name eq "if-end" ) )
        {
            $action_result = " " . $action_name . " " ;
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; Warning: pseudo-action " . $action_name . " was encountered, which means that a matching if-yes-begin or if-no-begin action is missing" . "}}\n" ;
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  unique-value
#
#  This action can be changed to accomodate a
#  parallel-processing environment where the
#  code here would assign values from separate
#  blocks of numbers assigned to each
#  processor/process.

        if ( $action_name eq "unique-value" )
        {
            $global_unique_value ++ ;
            $action_result = sprintf( "%d" , $global_unique_value ) ;
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  insert-codeview-tags

        if ( $action_name eq "insert-codeview-tags" )
        {
            if ( not( exists( $action_name_exists{ "no-space" } ) ) || ( $action_name_exists{ "no-space" } ne "yes" ) )
            {
                @list_of_action_names = split( / / , $global_dashrep_text_list_of_phrase_names ) ;
                foreach $action_name ( @list_of_action_names )
                {
                    $action_name_exists{ $action_name } = "yes" ;
                }
            }
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                $string_in_phrase = $global_dashrep_replacement{ $operand_one } ;
                $string_in_phrase =~ s/\n/<dashrep_codeview_newline>/sg ;
                $string_in_phrase =~ s/=/<dashrep_codeview_equal_sign>/sg ;
                $parameter_level = 1 ;
                $odd_or_even_based_on_zero_or_one[ 0 ] = "even" ;
                $odd_or_even_based_on_zero_or_one[ 1 ] = "odd" ;
                $accumulated_text = "" ;
                $remaining_text = $string_in_phrase ;
                while ( $remaining_text =~ /^(.*?)((\[-)|(-\]))(.*)$/ )
                {
                    $prefix_text = $1 ;
                    $parameter_begin_or_end_string = $2 ;
                    $remaining_text = $5 ;
                    $accumulated_text = $accumulated_text . $prefix_text ;
                    if ( $parameter_begin_or_end_string eq "[-" )
                    {
                        if ( $parameter_level >= 1 )
                        {
                            $accumulated_text = $accumulated_text . "<dashrep_codeview_tag_param_" . $odd_or_even_based_on_zero_or_one[ $parameter_level % 2 ] . "_begin>" ;
                        } else
                        {
                            $accumulated_text = $accumulated_text . "<dashrep_codeview_tag_param_unmatched_begin>" ;
                        }
                        $parameter_level ++ ;
                    } elsif ( $parameter_begin_or_end_string eq "-]" )
                    {
                        $parameter_level -- ;
                        if ( $parameter_level >= 1 )
                        {
                            $accumulated_text = $accumulated_text . "<dashrep_codeview_tag_param_" . $odd_or_even_based_on_zero_or_one[ $parameter_level % 2 ] . "_end>" ;
                        } else
                        {
                            $accumulated_text = $accumulated_text . "<dashrep_codeview_tag_param_unmatched_end>" ;
                        }
                    }
                }
                $string_in_phrase = $accumulated_text . $remaining_text ;
                $accumulated_text = "" ;
                $remaining_text = $string_in_phrase ;
                while ( $remaining_text =~ /^(.*?)([^ <>]+-[^ <>]+)(([ <]).*)$/ )
                {
                    $prefix_text = $1 ;
                    $phrase_name = $2 ;
                    $remaining_text = $3 ;
                    if ( exists( $action_name_exists{ $phrase_name } ) && ( $action_name_exists{ $phrase_name } eq "yes" ) )
                    {
                        $phrase_type = "action" ;
                    } elsif ( exists( $global_dashrep_replacement{ $phrase_name } ) && ( $global_dashrep_replacement{ $phrase_name } ne "" ) )
                    {
                        $phrase_type = "phrase_defined" ;
                    } else
                    {
                        $phrase_type = "phrase" ;
                    }
                    $accumulated_text = $accumulated_text . $prefix_text . "<dashrep_codeview_tag_" . $phrase_type . "_begin>" . $phrase_name . "<dashrep_codeview_tag_" . $phrase_type . "_middle_1>" . $phrase_name . "<dashrep_codeview_tag_" . $phrase_type . "_middle_2>" . $phrase_name . "<dashrep_codeview_tag_" . $phrase_type . "_end>" ;
                }
                $string_in_phrase = $accumulated_text . $remaining_text ;
                $global_dashrep_replacement{ $operand_one } = $string_in_phrase ;
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; action " . $action_name . " inserted codeview tags into " . $operand_one . "}}\n";
                }
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  escape-from-dashrep

        if ( $action_name eq "escape-from-dashrep" )
        {
            $global_dashrep_replacement{ "dashrep-replacement-results-at-time-of-escape" } = $text_begin . $action_result . $text_end ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; action " . $action_name . " saved remaining text in phrase dashrep-replacement-results-at-time-of-escape, and exited from Dashrep engine" . "}}\n";
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            last ;
        }


#-----------------------------------------------
#  Handle the action:
#  resume-after-escape-from-dashrep

        if ( $action_name eq "resume-after-escape-from-dashrep" )
        {
            $text_begin = "" ;
            if ( not( defined( $global_dashrep_replacement{ "dashrep-replacement-results-at-time-of-escape" } ) ) )
            {
                $global_dashrep_replacement{ "dashrep-replacement-results-at-time-of-escape" } = "" ;
            }
            $text_end = $global_dashrep_replacement{ "dashrep-replacement-results-at-time-of-escape" } ;
            $global_dashrep_replacement{ "dashrep-replacement-results-at-time-of-escape" } = "" ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; action " . $action_name . " started expanding text in phrase dashrep-replacement-results-at-time-of-escape" . "}}\n";
            }
#  end of action code
            $replacement_text = $text_begin . $action_result . $text_end ;
            next ;
        }


#-----------------------------------------------
#  If the word "file" or "files" or "folder" or
#  "folders" appears in the action name,
#  and if the action is recognized as a file-related
#  action, execute the action.

        if ( $action_name =~ /((file)|(folder))/ )
        {
            if ( ( $action_name eq "copy-from-phrase-append-to-file" ) || ( $action_name eq "copy-from-file-to-phrase" ) || ( $action_name eq "copy-append-file-to-file" ) || ( $action_name eq "generate-list-of-files-in-current-read-directory" ) || ( $action_name eq "generate-list-of-folders-in-current-read-directory" ) || ( $action_name eq "yes-or-no-file-exists" ) || ( $action_name eq "yes-or-no-folder-exists" ) || ( $action_name eq "size-of-file" ) || ( $action_name eq "modification-time-of-file" ) || ( $action_name eq "set-file-permission-public-read" ) || ( $action_name eq "create-empty-file" ) || ( $action_name eq "create-empty-sub-folder" ) || ( $action_name eq "rename-file" ) || ( $action_name eq "delete-file" ) || ( $action_name eq "find-line-in-file-that-begins-with-text" ) || ( $action_name eq "find-lines-in-file-that-begin-with-any-listed-word" ) || ( $action_name eq "find-lines-in-file-that-begin-with-any-two-words-listed" ) || ( $action_name eq "write-all-dashrep-definitions-to-file" ) || ( $action_name eq "write-dashrep-definitions-listed-in-phrase-to-file" ) || ( $action_name eq "get-definitions-from-file" ) || ( $action_name eq "linewise-translate-from-file-to-file" ) || ( $action_name eq "linewise-translate-parameters-only-from-file-to-file" ) || ( $action_name eq "linewise-translate-phrases-only-from-file-to-file" ) || ( $action_name eq "linewise-translate-special-phrases-only-from-file-to-file" ) || ( $action_name eq "copy-from-columns-in-file-to-named-phrases" ) || ( $action_name eq "copy-from-columns-in-file-to-column-lists" ) || ( $action_name eq "gather-tagged-info-from-file" ) || ( $action_name eq "write-gathered-listed-items-to-end-of-file" ) || ( $action_name eq "gather-from-tagged-file-one-entry" ) || ( $action_name eq "linewise-read-from-file-and-use-handler" ) )
            {
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; file-related action encountered: " . $action_name . " " . $operands_all . "}}\n" ;
                }
                $global_action_name = $action_name ;
                $global_operand_one = $operand_one ;
                $global_operand_two = $operand_two ;
                $global_operand_three = $operand_three ;
                $global_operand_four = $operand_four ;
                $global_operand_five = $operand_five ;
                $global_operands_all = $operands_all ;
                &dashrep_file_actions( ) ;
                $action_result = $global_action_result ;
                $replacement_text = $text_begin . $action_result . $text_end ;
                next ;
            }
        }


#-----------------------------------------------
#  Make the endless loop counter value available
#  -- on a read-only basis -- for debugging.

        if ( $action_name eq "dashrep-endless-loop-count" )
        {
            $replacement_text = $text_begin . $global_endless_loop_counter . $text_end ;
            next ;
        }


#-----------------------------------------------
#  If the parameter content has not been
#  recognized, simply remove the "[-" and "-]"
#  strings.

        $replacement_text = $text_begin . " " . $text_parameter_content . " " . $text_end ;
        if ( ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" ) && ( $action_name =~ /[^ ]/ ) )
        {
            $global_trace_log .= "{{trace; warning, action not recognized: " . $action_name . "}}\n";
        }


#-----------------------------------------------
#  Avoid an endless loop (caused by a replacement
#  containing, at some level, itself).

        $global_endless_loop_counter ++ ;
        $global_replacement_count_for_item_name{ "unknown action" } ++ ;
        if ( $global_endless_loop_counter > $global_endless_loop_counter_limit )
        {
            &dashrep_internal_endless_loop_info( ) ;
#  remove-from-cpan-version-begin
            warn "Warning: The dashrep_expand_parameters subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#            carp "Warning: The dashrep_expand_parameters subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  uncomment-for-cpan-version-end
            return 0 ;
        }


#-----------------------------------------------
#  Check if time limit exceeded.

        $global_interval_count_for_time_limit_check ++ ;
        if ( $global_interval_count_for_time_limit_check > 1000 )
        {
            $global_interval_count_for_time_limit_check = 0 ;
            $elapsed_time = time - $global_starting_time ;
            if ( $elapsed_time > $global_time_limit )
            {
#  remove-from-cpan-version-begin
                warn "Warning: The dashrep_expand_parameters subroutine has exceeded the time limit." . "\n" . "Stopped" ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#                carp "Warning: The dashrep_expand_parameters subroutine has exceeded the time limit." . "\n" . "Stopped" ;
#  uncomment-for-cpan-version-end
                return 0 ;
            }
        }


#-----------------------------------------------
#  Repeat the loop that repeats until no more
#  parameters remain.

    }


#-----------------------------------------------
#  Make the logged debugging (trace) information
#  available.

    $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= $global_trace_log ;
    $global_trace_log = "" ;


#-----------------------------------------------
#  Return the revised text.

    return $replacement_text ;


#-----------------------------------------------
#  End of subroutine.

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

    my $current_item ;
    my $hyphenated_phrase_to_expand ;
    my $expanded_output_string ;
    my $first_item ;
    my $remainder ;
    my $replacement_item ;
    my $elapsed_time ;
    my @item_stack ;
    my @items_to_add ;


#-----------------------------------------------
#  Initialization.

    $expanded_output_string = "" ;


#-----------------------------------------------
#  Internally define the "hyphen-here" phrase.

    $global_dashrep_replacement{ "hyphen-here" } = "no-space - no-space" ;


#-----------------------------------------------
#  Get the starting replacement name.

    if ( scalar( @_ ) == 1 )
    {
        $hyphenated_phrase_to_expand = $_[ 0 ] ;
    } else
    {
        $expanded_output_string = "" ;
        if ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" )
        {
            $global_trace_log .= "{{trace; nothing to expand}}\n";
        }
        return $expanded_output_string ;
    }


#-----------------------------------------------
#  Start with a single phrase on a stack.

    @item_stack = ( ) ;
    push( @item_stack , $hyphenated_phrase_to_expand ) ;


#-----------------------------------------------
#  Begin a loop that does all the replacements.

    while ( $#item_stack >= 0 )
    {


#-----------------------------------------------
#  Stop translating if requested.

        if ( $global_dashrep_replacement{ "dashrep-stop-translation" } eq "yes" )
        {
            if ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; stopping translation as requested}}\n";
            }
            last ;
        }


#-----------------------------------------------
#  Check for an endless loop.

        $global_endless_loop_counter ++ ;
        $global_replacement_count_for_item_name{ "expand phrases except special" } ++ ;
        if ( $global_endless_loop_counter > $global_endless_loop_counter_limit )
        {
            &dashrep_internal_endless_loop_info( ) ;
            $global_dashrep_replacement{ "dashrep-stop-translation" } = "yes" ;
            $global_trace_log .= "{{trace; Error: The dashrep_expand_phrases_except_special subroutine has encountered an endless loop, so attempting to stop translation gently}}\n";
            last ;
        }
        if ( $global_endless_loop_counter > ( $global_endless_loop_counter_limit + 100 ) )
        {
#  remove-from-cpan-version-begin
            warn "Warning: The dashrep_expand_phrases_except_special subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#            carp "Warning: The dashrep_expand_phrases_except_special subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  uncomment-for-cpan-version-end
            return 0 ;
        }


#-----------------------------------------------
#  Check if time limit has been exceeded.

        $global_interval_count_for_time_limit_check ++ ;
        if ( $global_interval_count_for_time_limit_check > 1000 )
        {
            $global_interval_count_for_time_limit_check = 0 ;
            $elapsed_time = time - $global_starting_time ;
            if ( $elapsed_time > $global_time_limit )
            {
                $global_dashrep_replacement{ "dashrep-stop-translation" } = "yes" ;
                $global_trace_log .= "{{trace; Error: The dashrep_expand_phrases_except_special subroutine has exceeded the time limit, so attempting to stop translation gently}}\n";
                last ;
            }
            if ( $elapsed_time > ( $global_time_limit + 1 ) )
            {
#  remove-from-cpan-version-begin
                warn "Warning: The dashrep_expand_phrases_except_special subroutine has exceeded the time limit." . "\n" . "Stopped" ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#                carp "Warning: The dashrep_expand_phrases_except_special subroutine has exceeded the time limit." . "\n" . "Stopped" ;
#  uncomment-for-cpan-version-end
                return 0 ;
            }
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

        if ( ( exists( $global_dashrep_replacement{ $current_item } ) ) && ( defined( $global_dashrep_replacement{ $current_item } ) ) )
        {
            $replacement_item = $global_dashrep_replacement{ $current_item } ;
            if ( $replacement_item =~ /[^ ]/ )
            {
                @items_to_add = split( /[ \n\r]+/ , $replacement_item ) ;
                push( @item_stack , reverse( @items_to_add ) ) ;
                $global_replacement_count_for_item_name{ $current_item } ++ ;
                if ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; replaced phrase: " . $current_item . "}}\n";
                }
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
#  Make the logged debugging (trace) information
#  available.

    $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= $global_trace_log ;
    $global_trace_log = "" ;


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

    my $expanded_string ;
    my $phrase_name ;
    my $code_for_non_breaking_space ;
    my $code_with_spaces ;
    my $code_begin ;
    my $code_end ;


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
    if ( ( not( defined( $expanded_string ) ) ) || ( $expanded_string !~ /[^ ]/ ) )
    {
        return "";
    }


#-----------------------------------------------
#  If requested, do not expand special phrases.

    if ( ( exists( $global_dashrep_replacement{ "yes-or-no-expand-special-phrases" } ) ) && ( $global_dashrep_replacement{ "yes-or-no-expand-special-phrases" } eq "no" ) )
    {
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
        if ( ( exists( $global_dashrep_replacement{ $phrase_name } ) ) && ( defined( $global_dashrep_replacement{ $phrase_name } ) ) )
        {
            $expanded_string = $global_dashrep_replacement{ $phrase_name } ;
        }
    }


#-----------------------------------------------
#  Handle the directive:
#  "non-breaking-space"

    $code_for_non_breaking_space = $global_dashrep_replacement{ "non-breaking-space" } ;
    while ( $expanded_string =~ /^(.* +)?non-breaking-space( +.*)?$/sgi )
    {
        $code_begin = $1 ;
        $code_end = $2 ;
        $code_begin =~ s/ +$//s ;
        $code_end =~ s/^ +//s ;
        $expanded_string = $code_begin . $code_for_non_breaking_space . $code_end ;
    }


#-----------------------------------------------
#  Handle the directives:
#  "span-non-breaking-spaces-begin" and
#  "span-non-breaking-spaces-end"

    $code_for_non_breaking_space = $global_dashrep_replacement{ "non-breaking-space" } ;
    while ( $expanded_string =~ /((^)|((.* +)?))span-non-breaking-spaces-begin( +.*? +)span-non-breaking-spaces-end(( +.*)|($))/sgi )
    {
        $code_begin = $1 ;
        $code_with_spaces = $5 ;
        $code_end = $6 ;
        $code_with_spaces =~ s/^ +//s ;
        $code_with_spaces =~ s/ +$//s ;
        $code_with_spaces =~ s/ +/ ${code_for_non_breaking_space} /sg ;
        $code_with_spaces =~ s/ +//sg ;
        $expanded_string = $code_begin . $code_with_spaces . $code_end ;
    }


#-----------------------------------------------
#  Replace multiple spaces and tabs with single spaces.

    $expanded_string =~ s/[ \n][ \t]+/ /sg ;


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
#  Make the logged debugging (trace) information
#  available.

    $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= $global_trace_log ;
    $global_trace_log = "" ;


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

    my $text_string_to_expand ;
    my $partly_expanded_string ;
    my $expanded_string ;


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
#  Unless otherwise requested, use the faster,
#  newer code for doing the expansion.  It handles
#  line and space directives as part of the
#  expansion.

    if ( ( not( exists( $global_dashrep_replacement{ "yes-or-no-use-slower-subset-expand" } ) ) ) || ( $global_dashrep_replacement{ "yes-or-no-use-slower-subset-expand" } ne "yes" ) )
    {
        $expanded_string = &dashrep_internal_expand_phrases_faster_subset( $text_string_to_expand ) ;
        return $expanded_string ;
    }


#-----------------------------------------------
#  Expand the phrase except for special phrases.

    $partly_expanded_string = &dashrep_expand_phrases_except_special( $text_string_to_expand ) ;
    if ( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } eq "yes" )
    {
        $global_trace_log .= "{{trace; after non-special phrases expanded: " . $partly_expanded_string . "}}\n" ;
    }


#-----------------------------------------------
#  Handle special directives:
#  "empty-line" and "new-line" and
#  "no-space" and "one-space" and others

    $expanded_string = &dashrep_expand_special_phrases( $partly_expanded_string ) ;


#-----------------------------------------------
#  Make the logged debugging (trace) information
#  available.

    $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= $global_trace_log ;
    $global_trace_log = "" ;


#-----------------------------------------------
#  End of subroutine.

    return $expanded_string ;

}


=head2 dashrep_file_actions

Internal subroutine, not exported.
It is only needed within the Dashrep module.

=cut


#-----------------------------------------------
#-----------------------------------------------
#         Non-exported subroutine:
#
#         dashrep_file_actions
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_file_actions
{
    my $source_definitions ;
    my $action_name ;
    my $operand_one ;
    my $operand_two ;
    my $operand_three ;
    my $operand_four ;
    my $operand_five ;
    my $operands_all ;
    my $action_result ;
    my $translation ;
    my $partial_translation ;
    my $source_filename ;
    my $target_filename ;
    my $source_phrase_name ;
    my $target_phrase_name ;
    my $line_count ;
    my $possible_error_message ;
    my $all_defs_begin ;
    my $all_defs_end ;
    my $phrase_begin ;
    my $phrase_end ;
    my $def_begin ;
    my $def_end ;
    my $all_lines ;
    my $input_line ;
    my $phrase_name ;
    my $numeric_return_value ;
    my $counter ;
    my $definitions_or_phrase_names ;
    my $string_to_find ;
    my $length_of_string ;
    my $sequence_of_phrases ;
    my $directory ;
    my $file_name ;
    my $list_of_file_names ;
    my $read_time ;
    my $write_time ;
    my $file_size ;
    my $number_of_column_names ;
    my $use_two_spaces_as_delimiter ;
    my $text_item_in_column ;
    my $number_of_columns ;
    my $column_pointer ;
    my $unique_value ;
    my $phrase_naming_convention_for_this_column ;
    my $line_ending ;
    my $line_number ;
    my $full_path ;
    my $temp_text ;
    my $list_name_prefix ;
    my $list_of_words ;
    my $word ;
    my $matching_text ;
    my $possible_match ;
    my $storage_name ;
    my $words_to_match ;
    my $length_of_first_word ;
    my $second_word ;
    my $name_of_phrase_that_contains_list_of_index_values ;
    my $first_word ;
    my $entry_begin ;
    my $entry_end ;
    my $entry_unique ;
    my $list_of_unique_values ;
    my $found_unique_value ;
    my $line_status ;
    my $tag_name ;
    my $multiline_value_name ;
    my $remainder_of_line ;
    my $prefix_text ;
    my $target_sub_folder ;
    my $slash_or_backslash_for_path ;
    my $accumulated_matching_entry_info ;
    my $entry_delete ;
    my $entry_matching_id ;
    my $possible_matching_entry_info ;
    my $pointer ;
    my $list_of_storage_names ;
    my $list_of_words_as_text ;
    my $accumulated_text ;
    my $minimum_number_of_columns ;
    my @list_of_values_in_column ;
    my @value_in_column ;
    my @list_of_tag_values_in_sequence_encountered ;
    my @list_of_tag_names ;
    my @list_of_phrases ;
    my @phrase_naming_convention_for_column ;
    my %exists_tag_name ;
    my %content_for_tag ;


#-----------------------------------------------
#  Initialization.

    $possible_error_message = "" ;
    $action_result = " " ;


#-----------------------------------------------
#  Verify that there are no function operands.

    if ( scalar( @_ ) != 0 )
    {
#  remove-from-cpan-version-begin
        warn "Warning: Call to File-related action subroutine does not have zero parameters." ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#        carp "Warning: Call to File-related action subroutine does not have exactly zero parameters." ;
#  uncomment-for-cpan-version-end
        return 0 ;
    }


#-----------------------------------------------
#  Get the inputs.
#  Use local copies of the operands so that
#  this subroutine can be called recursively.

    $action_name = $global_action_name ;
    $operand_one = $global_operand_one ;
    $operand_two = $global_operand_two ;
    $operand_three = $global_operand_three ;
    $operand_four = $global_operand_four ;
    $operand_five = $global_operand_five ;
    $operands_all = $global_operands_all ;


#-----------------------------------------------
#  Specify the default output (the action result).

    $action_result = " " ;


#-----------------------------------------------
#  Define filename variables and phrase name
#  variables based on the contents of the
#  operands.

    $source_phrase_name = $operand_one ;
    $source_filename = $operand_one ;
    $target_phrase_name = $operand_two ;
    $target_filename = $operand_two ;
    if ( $operand_two eq "" )
    {
        $target_phrase_name = $operand_one ;
        $target_filename = $operand_one ;
    }


#-----------------------------------------------
#  Strip off any path, and keep only the names
#  of the source and target files.

    $source_filename =~ s/^.*[\\\/]// ;
    $source_filename =~ s/^\.+// ;
    $target_filename =~ s/^.*[\\\/]// ;
    $target_filename =~ s/^\.+// ;


#-----------------------------------------------
#  Insert the path into the filename variables.

    if ( $source_filename ne "" )
    {
        $source_filename = $global_dashrep_replacement{ "dashrep-path-prefix-for-file-reading" } . $source_filename ;
    }
    if ( $target_filename ne "" )
    {
        $target_filename = $global_dashrep_replacement{ "dashrep-path-prefix-for-file-writing" } . $target_filename ;
    }


#-----------------------------------------------
#  If requested, log the action details.

    if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
    {
        $global_trace_log .= "{{trace; action " . $action_name . " has operand one " . $operand_one . " has operand two " . $operand_two . " has operand three " . $operand_three . " has operand four " . $operand_four . " has operand five " . $operand_five . " has default result " . $action_result . " has source_filename " . $source_filename . " has target_filename " . $target_filename . " has source_phrase_name " . $source_phrase_name . " has target_phrase_name " . $target_phrase_name . "}}\n" ;
    }


#-----------------------------------------------
#  Handle the action:
#  copy-from-file-to-phrase

    if ( $action_name eq "copy-from-file-to-phrase" )
    {
        if ( ( $source_filename eq "" ) || ( $target_phrase_name eq "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $target_phrase_name . "]" ;
        } elsif ( open ( INFILE , '<' . $source_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [warning, file named " . $source_filename . " not found, or could not be opened]" ;
        }
        if ( $possible_error_message eq "" )
        {
            $all_lines = "" ;
            $line_ending = "" ;
            $line_number = 0 ;
            if ( not( exists( $global_dashrep_replacement{ "yes-or-no-indicate-line-endings" } ) ) )
            {
                $global_dashrep_replacement{ "yes-or-no-indicate-line-endings" } = "no" ;
            }
            if ( ( exists( $global_dashrep_replacement{ "yes-or-no-indicate-line-endings" } ) ) && ( $global_dashrep_replacement{ "yes-or-no-indicate-line-endings" } eq "yes" ) )
            {
                $line_ending = " end-of-line-here " ;
            } else
            {
                $line_ending = " " ;
            }
            while ( $input_line = <INFILE> )
            {
                chomp( $input_line ) ;
                $input_line =~ s/[\t\f\n\r]+/ /g ;
                $input_line =~ s/^ +/ / ;
                $input_line =~ s/ +$/ / ;
                if ( $action_name eq "copy-from-file-to-phrase" )
                {
                    if ( ( $input_line ne "" ) || ( $line_ending ne " " ) )
                    {
                        $all_lines .= $input_line . $line_ending ;
                    }
                }
            }
            $global_dashrep_replacement{ $target_phrase_name } = $all_lines ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; copied from file " . $source_filename . " to phrase " . $target_phrase_name . "}}\n" ;
            }
        } else
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
            }
        }
        close( INFILE ) ;
#  end of action code


#-----------------------------------------------
#  Handle the actions:
#  find-line-in-file-that-begins-with-text
#  find-lines-in-file-that-begin-with-any-listed-word
#  find-lines-in-file-that-begin-with-any-two-words-listed

    } elsif ( ( $action_name eq "find-line-in-file-that-begins-with-text" ) || ( $action_name eq "find-lines-in-file-that-begin-with-any-listed-word" ) || ( $action_name eq "find-lines-in-file-that-begin-with-any-two-words-listed" ) )
    {
        $list_of_storage_names = "" ;
        if ( ( $source_filename eq "" ) || ( $operand_two eq "" ) || ( $operand_three eq "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $operand_two . " and " . $operand_three . "]" ;
        } elsif ( ( $action_name eq "find-line-in-file-that-begins-with-text" ) && ( ( not( exists( $global_dashrep_replacement{ $operand_two } ) ) ) || ( $global_dashrep_replacement{ $operand_two } !~ /[^ ]/ ) ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has empty search word in phrase " . $operand_two . "]" ;
        } elsif ( ( ( $action_name eq "find-lines-in-file-that-begin-with-any-listed-word" ) || ( $action_name eq "find-lines-in-file-that-begin-with-any-two-words-listed" ) ) && ( ( not( exists( $global_dashrep_replacement{ $operand_two } ) ) ) || ( $global_dashrep_replacement{ $operand_two } !~ /[^ ]/ ) ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has no search words in phrase " . $operand_two . "]" ;
        } elsif ( open ( INFILE , '<' . $source_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [warning, file named " . $source_filename . " not found, or could not be opened]" ;
        }
        if ( $possible_error_message eq "" )
        {
            if ( $action_name eq "find-line-in-file-that-begins-with-text" )
            {
                $string_to_find = $global_dashrep_replacement{ $operand_two } ;
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; searching in file " . $source_filename . " for string " . $string_to_find . "}}\n" ;
                }
                $length_of_string = length( $string_to_find ) ;
                while ( $input_line = <INFILE> )
                {
                    chomp( $input_line ) ;
                    $possible_match = substr( $input_line , 0 , $length_of_string ) ;
                    if ( $possible_match eq $string_to_find )
                    {
                        $global_dashrep_replacement{ $operand_three } = $input_line ;
                        if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                        {
                            $global_trace_log .= "{{trace; in file " . $source_filename . " found starting string " . $string_to_find . "}}\n" ;
                        }
                        last ;
                    }
                }
            } else
            {
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; searching in file " . $source_filename . " for words in phrase " . $operand_two . "}}\n" ;
                }
                $list_of_words_as_text = $global_dashrep_replacement{ $operand_two } ;
                $list_of_words_as_text =~ s/^ +// ;
                $list_of_words_as_text =~ s/ +$//s ;
                if ( $list_of_words_as_text =~ / / )
                {
                    @list_of_words = split( /[ \n\r]+/ , $list_of_words_as_text ) ;
                } else
                {
                    @list_of_words = ( ) ;
                    $list_of_words[ 0 ] = $list_of_words_as_text ;
                }
                foreach $word ( @list_of_words )
                {
                    $matching_text{ $word } = "match" ;
                }
                if ( $action_name eq "find-lines-in-file-that-begin-with-any-listed-word" )
                {
                    $words_to_match = 1 ;
                } else
                {
                    $words_to_match = 2 ;
                }
                while ( $input_line = <INFILE> )
                {
                    chomp( $input_line ) ;
                    $length_of_first_word = index( $input_line , " " ) ;
                    $possible_match = substr( $input_line , 0 , $length_of_first_word ) ;
                    if ( ( exists( $matching_text{ $possible_match } ) ) && ( $matching_text{ $possible_match } eq "match" ) )
                    {
                        if ( $words_to_match == 1 )
                        {
                            $storage_name = "dashrep-storage-" . sprintf( "%d" , $global_storage_number ) ;
                            $global_storage_number ++ ;
                            $global_dashrep_replacement{ $storage_name } = $input_line ;
                            $list_of_storage_names .= $storage_name . " " ;
                        } else
                        {
                            if ( $input_line =~ /^[^ ]+ +([^ ]+)(( )|($))/ )
                            {
                                $second_word = $1 ;
                                if ( ( exists( $matching_text{ $second_word } ) ) && ( $matching_text{ $second_word } eq "match" ) )
                                {
                                    $storage_name = "dashrep-storage-" . sprintf( "%d" , $global_storage_number ) ;
                                    $global_storage_number ++ ;
                                    if ( $list_of_storage_names eq "" )
                                    {
                                        $list_of_storage_names = $storage_name . " " ;
                                    } else
                                    {
                                        $list_of_storage_names .= $storage_name . " " ;
                                    }
                                    $global_dashrep_replacement{ $storage_name } = $input_line ;
                                }
                            }
                        }
                    }
                }
                $list_of_storage_names =~ s/ +$// ;
                $global_dashrep_replacement{ $operand_three } = $list_of_storage_names ;
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; finished searching, previous message indicates any matches " . "}}\n" ;
            }
        } else
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
            }
        }
        close( INFILE ) ;
#  end of action code


#-----------------------------------------------
#  Handle the action:
#  get-definitions-from-file
#
#  The filename is edited to remove any path
#  specifications, and then the prefix in the
#  appropriate dashrep phrase is used.

    } elsif ( $action_name eq "get-definitions-from-file" )
    {
        if ( ( $source_filename eq "" ) || ( $operand_two ne "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $operand_two . "]" ;
        } elsif ( open ( INFILE , '<' . $source_filename ) )
        {
            $possible_error_message = "" ;
        } else
        {
            if ( -e $source_filename )
            {
                $possible_error_message .= " [warning, file named " . $source_filename . " found, but could not be opened]" ;
            } else
            {
                $possible_error_message .= " [warning, file named " . $source_filename . " not found]" ;
            }
        }
        if ( $possible_error_message eq "" )
        {
            $source_definitions = "" ;
            while ( $input_line = <INFILE> )
            {
                chomp( $input_line ) ;
                $input_line =~ s/[\n\r\f\t]+/ /g ;
                if ( ( defined( $input_line ) ) && ( $input_line =~ /[^ ]/ ) )
                {
                    $source_definitions .= $input_line . " " ;
                }
            }
            $numeric_return_value = &dashrep_import_replacements( $source_definitions ) ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; imported " . $numeric_return_value . " definitions from file: " . $source_filename . "}}\n" ;
            }
        } else
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
            }
        }
        close( INFILE ) ;
#  end of action code


#-----------------------------------------------
#  Handle the actions:
#  generate-list-of-files-in-current-read-directory
#  generate-list-of-folders-in-current-read-directory
#
#  The current read directory is already specified
#  in a Dashrep phrase.

    } elsif ( ( $action_name eq "generate-list-of-files-in-current-read-directory" ) || ( $action_name eq "generate-list-of-folders-in-current-read-directory" ) )
    {
        if ( ( $operand_one eq "" ) || ( $operand_two ne "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $operand_two . "]" ;
        } elsif ( exists( $global_dashrep_replacement{ "dashrep-path-prefix-for-file-reading" } ) )
        {
            $directory = $global_dashrep_replacement{ "dashrep-path-prefix-for-file-reading" } ;
            if ( ( $directory eq "" ) || ( $directory !~ /[\\\/]$/ ) )
            {
                $directory = './' ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, directory " . $directory . " is invalid so using local directory}}\n" ;
                }
            }
            if ( opendir( READDIR , $directory ) )
            {
                while ( defined( $file_name = readdir( READDIR ) ) )
                {
                    if ( $file_name !~ /^\./ )
                    {
                        $full_path = $directory . $file_name ;
                        if ( $action_name eq "generate-list-of-folders-in-current-read-directory" )
                        {
                            if ( -d $full_path )
                            {
                                $list_of_file_names .= $file_name . " " ;
                            }
                        } elsif ( $action_name eq "generate-list-of-files-in-current-read-directory" )
                        {
                            if ( -f $full_path )
                            {
                                $list_of_file_names .= $file_name . " " ;
                            }
                        }
                    }
                }
                $list_of_file_names =~ s / +$// ;
                $global_dashrep_replacement{ $operands_all } = $list_of_file_names ;
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; listed files or folders in directory " . $directory . "}}\n" ;
                }
                closedir( READDIR ) ;
            } else
            {
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, cannot list files in directory " . $directory . "}}\n" ;
                }
            }
        }
#  end of action code


#-----------------------------------------------
#  Handle the action:
#  yes-or-no-file-exists
#
#  The filename is edited to remove any path
#  specifications, and then the prefix in the
#  appropriate dashrep phrase is used.

    } elsif ( $action_name eq "yes-or-no-file-exists" )
    {
        if ( ( $source_filename eq "" ) || ( $operand_two ne "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $operand_two . "]" ;
        } elsif ( open ( INFILE , '<' . $source_filename ) )
        {
            $action_result = " yes " ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; file exists: " . $source_filename . "}}\n" ;
            }
        } else
        {
            $action_result = " no " ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; file does not exist: " . $source_filename . "}}\n" ;
            }
        }
        close( INFILE ) ;
#  end of action code


#-----------------------------------------------
#  Handle the action:
#  yes-or-no-folder-exists

    } elsif ( $action_name eq "yes-or-no-folder-exists" )
    {
        if ( $operand_one eq "" )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has empty operand " . $operand_one . "]" ;
        } elsif ( -d $operand_one )
        {
            $action_result = " yes " ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; folder exists: " . $operand_one . "}}\n" ;
            }
        } else
        {
            $action_result = " no " ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; folder does not exist: " . $operand_one . "}}\n" ;
            }
        }
#  end of action code


#-----------------------------------------------
#  Handle the action:
#  modification-time-of-file
#
#  The filename is edited to remove any path
#  specifications, and then the prefix in the
#  appropriate dashrep phrase is used.

    } elsif ( $action_name eq "modification-time-of-file" )
    {
        if ( ( $source_filename eq "" ) || ( $operand_two ne "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $operand_two . "]" ;
        } else
        {
            ( $read_time , $write_time ) = ( stat( $source_filename ) )[8,9] ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; modification time of file " . $source_filename . " is " . $write_time . "}}\n" ;
            }
        }
        $action_result = " " . $write_time . " " ;
#  end of action code


#-----------------------------------------------
#  Handle the action:
#  set-file-permission-public-read
#
#  The filename is edited to remove any path
#  specifications, and then the prefix in the
#  appropriate dashrep phrase is used.

    } elsif ( $action_name eq "set-file-permission-public-read" )
    {
        if ( ( $target_filename eq "" ) || ( $operand_two ne "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $target_filename . " and " . $operand_two . "]" ;
        } elsif ( not( chmod( $global_file_public_read_protection_mode , $target_filename ) ) )
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: protection removal for output file " . $target_filename . "  not successful}}\n" ;
            }
        }
#  end of action code


#-----------------------------------------------
#  Handle the action:
#  size-of-file
#
#  The filename is edited to remove any path
#  specifications, and then the prefix in the
#  appropriate dashrep phrase is used.

    } elsif ( $action_name eq "size-of-file" )
    {
        if ( ( $source_filename eq "" ) || ( $operand_two ne "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $operand_two . "]" ;
        } else
        {
            $file_size = sprintf( "%d" , ( stat( $source_filename ) )[7] ) ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; size of file " . $source_filename . " is " . $file_size . "}}\n" ;
            }
        }
        $action_result = " " . $file_size . " " ;
#  end of action code


#-----------------------------------------------
#  Handle the action:
#  copy-from-phrase-append-to-file
#
#  The filename is edited to remove any path
#  specifications, and then the prefix in the
#  appropriate dashrep phrase is used.

    } elsif ( $action_name eq "copy-from-phrase-append-to-file" )
    {
        if ( $target_filename eq "" )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_phrase_name . " and " . $target_filename . "]" ;
        } elsif ( $global_dashrep_replacement{ "yes-or-no-permission-to-append-to-files" } ne "yes" )
        {
            $global_trace_log .= "{{trace; attempt to copy from phrase " . $source_phrase_name . " to end of file " . $target_filename . "}}\n" ;
            $possible_error_message .= " [warning, do not have permission to append to files]" ;
        } elsif ( open ( OUTFILE , '>>' . $target_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [warning, file named " . $target_filename . " could not be opened for writing]" ;
        }
        if ( $possible_error_message eq "" )
        {
            if ( exists( $global_dashrep_replacement{ $source_phrase_name } ) )
            {
                print OUTFILE $global_dashrep_replacement{ $source_phrase_name } . "\n" ;
            } else
            {
                print OUTFILE $source_phrase_name . "\n" ;
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; copied from phrase " . $source_phrase_name . " to end of file " . $target_filename . "}}\n" ;
            }
        } else
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
            }
        }
        close( OUTFILE ) ;
        if ( not( chmod( $global_file_write_protection_mode , $target_filename ) ) )
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: protection of output file " . $target_filename . "  not successful}}\n" ;
            }
        }
#  end of action code


#-----------------------------------------------
#  Handle the action:
#  copy-append-file-to-file
#
#  The filenames are edited to remove any path
#  specifications, and then the prefix in the
#  appropriate dashrep phrase is used.

    } elsif ( $action_name eq "copy-append-file-to-file" )
    {
        if ( ( $source_filename eq "" ) || ( $target_filename eq "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $target_filename . "]" ;
        } elsif ( $global_dashrep_replacement{ "yes-or-no-permission-to-append-to-files" } ne "yes" )
        {
            $global_trace_log .= "{{trace; attempt to copy from phrase " . $source_phrase_name . " to end of file " . $target_filename . "}}\n" ;
            $possible_error_message .= " [warning, do not have permission to append to files]" ;
        }
        if ( open ( INFILE , '<' . $source_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [warning, file named " . $source_filename . " not found, or could not be opened]" ;
        }
        if ( open ( OUTFILE , '>>' . $target_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [warning, file named " . $target_filename . " could not be opened for writing]" ;
        }
        if ( $possible_error_message eq "" )
        {
            while ( $input_line = <INFILE> )
            {
                chomp( $input_line ) ;
                print OUTFILE $input_line . "\n" ;
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; copied from file " . $source_filename . " to file " . $target_filename . "}}\n" ;
            }
        } else
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
            }
        }
        close( INFILE ) ;
        close( OUTFILE ) ;
        if ( not( chmod( $global_file_write_protection_mode , $target_filename ) ) )
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: protection of output file " . $target_filename . "  not successful}}\n" ;
            }
        }
#  end of action code


#-----------------------------------------------
#  Handle the action:
#  delete-file
#
#  The filename is edited to remove any path
#  specifications, and then the prefix in the
#  appropriate dashrep phrase is used.

    } elsif ( $action_name eq "delete-file" )
    {
        if ( ( $target_filename eq "" ) || ( $operand_two ne "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $target_filename . " and " . $operand_two . "]" ;
        } elsif ( $global_dashrep_replacement{ "yes-or-no-permission-to-delete-or-overwrite-files" } ne "yes" )
        {
            $global_trace_log .= "{{trace; attempt to delete file: " . $target_filename . "}}\n" ;
            $possible_error_message .= " [warning, do not have permission to delete or overwrite files]" ;
        } else
        {
            unlink $target_filename ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; deleted file: " . $target_filename . "}}\n" ;
            }
        }
#  end of action code


#-----------------------------------------------
#  Handle the action:
#  rename-file
#
#  The filename is edited to remove any path
#  specifications, and then the prefix in the
#  appropriate dashrep phrase is used.

    } elsif ( $action_name eq "rename-file" )
    {
        if ( $global_dashrep_replacement{ "yes-or-no-permission-to-delete-or-overwrite-files" } ne "yes" )
        {
            $global_trace_log .= "{{trace; attempt to rename file: " . $source_filename . "}}\n" ;
            $possible_error_message .= " [warning, do not have permission to delete or overwrite or rename files]" ;
        } else
        {
            rename( $source_filename , $target_filename ) ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; renamed file " . $source_filename . " to " . $target_filename . "}}\n" ;
            }
        }
#  end of action code


#-----------------------------------------------
#  Handle the action:
#  create-empty-file
#
#  The filename is edited to remove any path
#  specifications, and then the prefix in the
#  appropriate dashrep phrase is used.

    } elsif ( $action_name eq "create-empty-file" )
    {
        if ( ( $target_filename eq "" ) || ( $operand_two ne "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $target_filename . " and " . $operand_two . "]" ;
        } elsif ( $global_dashrep_replacement{ "yes-or-no-permission-to-delete-or-overwrite-files" } ne "yes" )
        {
            $global_trace_log .= "{{trace; attempt to create empty file: " . $target_filename . "}}\n" ;
            $possible_error_message .= " [warning, do not have permission to delete or overwrite files]" ;
        } else
        {
            if ( open ( OUTFILE , '>' . $target_filename ) )
            {
                $possible_error_message .= "" ;
            } else
            {
                $possible_error_message .= " [warning, file named " . $target_filename . " could not be created]" ;
            }
            if ( $possible_error_message eq "" )
            {
                print OUTFILE "" ;
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; created empty file: " . $target_filename . "}}\n" ;
                }
            } else
            {
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
                }
            }
            close( OUTFILE ) ;
            if ( not( chmod( $global_file_write_protection_mode , $target_filename ) ) )
            {
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning: protection of output file " . $target_filename . "  not successful}}\n" ;
                }
            }
        }
#  end of action code


#-----------------------------------------------
#  Handle the action:
#  create-empty-sub-folder
#
#  The created folder must be directly beneath
#  the currently specified write directory.

    } elsif ( $action_name eq "create-empty-sub-folder" )
    {
        if ( ( $operand_one eq "" ) || ( $operand_one !~ /^[a-z0-9_\-]+$/i ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operand " . $operand_one . "]" ;
        } elsif ( $global_dashrep_replacement{ "yes-or-no-permission-to-delete-or-overwrite-files" } ne "yes" )
        {
            $global_trace_log .= "{{trace; attempt to create empty folder: " . $global_dashrep_replacement{ "dashrep-path-prefix-for-file-writing" } . "}}\n" ;
            $possible_error_message .= " [warning, do not have permission to create files or folders]" ;
        } else
        {
            $target_sub_folder = $global_dashrep_replacement{ "dashrep-path-prefix-for-file-writing" } . $operand_one ;
            if ( $target_sub_folder =~ /([\/\\])/ )
            {
                $slash_or_backslash_for_path = $1 ;
            } else
            {
                $slash_or_backslash_for_path = '/' ;
            }
            if ( $global_dashrep_replacement{ "dashrep-path-prefix-for-file-writing" } !~ /[\/\\]$/ )
            {
                $target_sub_folder = $global_dashrep_replacement{ "dashrep-path-prefix-for-file-writing" } . $slash_or_backslash_for_path . $operand_one ;
            }
            if ( -d $target_sub_folder )
            {
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; sub-folder " . $target_sub_folder . " already exists, so not created". "}}\n" ;
                }
                $possible_error_message .= "" ;
            } else
            {
                umask( 0077 ) ;
                if ( mkdir( $target_sub_folder ) )
                {
                    if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; sub-folder " . $target_sub_folder . " created". "}}\n" ;
                    }
                } else
                {
                    if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; sub-folder " . $target_sub_folder . " could not be created". "}}\n" ;
                    }
                    $possible_error_message .= " [warning, sub-folder named " . $target_sub_folder . " could not be created]" ;
                }
            }
            if ( $possible_error_message ne "" )
            {
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
                }
            }
        }
#  end of action code


#-----------------------------------------------
#  Handle the action:
#  copy-from-columns-in-file-to-named-phrases

    } elsif ( $action_name eq "copy-from-columns-in-file-to-named-phrases" )
    {
        if ( ( $source_filename eq "" ) || ( $operand_two eq "" ) || ( $operand_three eq "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $operand_two . " and " . $operand_three . "]" ;
        } elsif ( open ( INFILE , '<' . $source_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [warning, file named " . $source_filename . " not found, or could not be opened]" ;
        }
        if ( $possible_error_message eq "" )
        {
            $temp_text = $global_dashrep_replacement{ $operand_two } ;
            $temp_text =~ s/^ +// ;
            $temp_text =~ s/ +$//s ;
            if ( $temp_text =~ / / )
            {
                @phrase_naming_convention_for_column = split( /[ \n\r]+/ , $temp_text ) ;
                $number_of_column_names = scalar( @phrase_naming_convention_for_column ) ;
                $prefix_text = $phrase_naming_convention_for_column[ 0 ] ;
            } else
            {
                $phrase_naming_convention_for_column[ 1 ] = "" ;
                $number_of_column_names = 2 ;
                $prefix_text = $temp_text ;
            }
            if ( $prefix_text !~ /^[^ ]+$/ )
            {
                $possible_error_message .= " [warning, action " . $action_name . " has prefix of " . $prefix_text . " that is not valid]" ;
            }
        }
        if ( $possible_error_message eq "" )
        {
            $name_of_phrase_that_contains_list_of_index_values = $operand_three ;
            if ( $name_of_phrase_that_contains_list_of_index_values !~ /^[a-z0-9_\-]+$/i )
            {
                $possible_error_message .= " [warning, action " . $action_name . " has invalid third operand " . $name_of_phrase_that_contains_list_of_index_values . "]" ;
            }
        }
        if ( $possible_error_message eq "" )
        {
            $list_of_unique_values = "" ;
            $global_dashrep_replacement{ $name_of_phrase_that_contains_list_of_index_values } = $list_of_unique_values ;
            if ( ( exists( $global_dashrep_replacement{ "yes-or-no-use-two-spaces-as-column-delimiter" } ) ) && ( $global_dashrep_replacement{ "yes-or-no-use-two-spaces-as-column-delimiter" } eq "yes" ) )
            {
                $use_two_spaces_as_delimiter = "yes" ;
            } else
            {
                $use_two_spaces_as_delimiter = "no" ;
            }
            while ( $input_line = <INFILE> )
            {
                chomp( $input_line ) ;
                $input_line =~ s/[ \n\t]+$// ;
                if ( $use_two_spaces_as_delimiter eq "yes" )
                {
                    @text_item_in_column = split( /  +/ , $input_line ) ;
                } else
                {
                    @text_item_in_column = split( /[\t ]/ , $input_line ) ;
                }
                $unique_value = $text_item_in_column[ 0 ] ;
                if ( $unique_value =~ / / )
                {
                    $unique_value =~ s/ +/_/g ;
                }
                $number_of_columns = scalar( @text_item_in_column ) ;
                if ( $number_of_columns > $number_of_column_names )
                {
                    $number_of_columns = $number_of_column_names ;
                }
                if ( $number_of_columns > 0 )
                {
                    $list_of_unique_values .= " " . $unique_value ;
                    for ( $column_pointer = 2 ; $column_pointer <= $number_of_column_names ; $column_pointer ++ )
                    {
                        if ( $phrase_naming_convention_for_column[ $column_pointer - 1 ] ne "" )
                        {
                            $phrase_naming_convention_for_this_column = $prefix_text . "-" . $unique_value . "-" . $phrase_naming_convention_for_column[ $column_pointer - 1 ] ;
                        } else
                        {
                            $phrase_naming_convention_for_this_column = $prefix_text . "-" . $unique_value ;
                        }
                        if ( $column_pointer <= $number_of_columns )
                        {
                            $global_dashrep_replacement{ $phrase_naming_convention_for_this_column } = $text_item_in_column[ $column_pointer - 1 ] ;
                        } else
                        {
                            $global_dashrep_replacement{ $phrase_naming_convention_for_this_column } = "" ;
                        }
                    }
                }
            }
            $list_of_unique_values =~ s/^ +// ;
            $global_dashrep_replacement{ $name_of_phrase_that_contains_list_of_index_values } = $list_of_unique_values ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; copied from columns in file " . $source_filename . " to phrase names specified in phrase " . $target_phrase_name . "}}\n" ;
            }
        }
        if ( $possible_error_message ne "" )
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
            }
        }
        close( INFILE ) ;
#  end of action code


#-----------------------------------------------
#  Handle the action:
#  copy-from-columns-in-file-to-column-lists

    } elsif ( $action_name eq "copy-from-columns-in-file-to-column-lists" )
    {
        if ( ( $source_filename eq "" ) || ( $operand_two eq "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $operand_two . "]" ;
        } elsif ( open ( INFILE , '<' . $source_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [warning, file named " . $source_filename . " not found, or could not be opened]" ;
        }
        if ( $possible_error_message eq "" )
        {
            $list_name_prefix = $operand_two ;
            @list_of_values_in_column = ( ) ;
            $minimum_number_of_columns = 999 ;
            while ( $input_line = <INFILE> )
            {
                chomp( $input_line ) ;
                $input_line =~ s/[\n\t]+/ /g ;
                $input_line =~ s/^ +// ;
                $input_line =~ s/ +$// ;
                @value_in_column = split( / +/ , $input_line ) ;
                $number_of_columns = scalar( @value_in_column ) ;
                if ( $number_of_columns < 1 )
                {
                    next ;
                } elsif ( $number_of_columns < $minimum_number_of_columns )
                {
                    $minimum_number_of_columns = $number_of_columns ;
                }
                if ( $number_of_columns > 0 )
                {
                    for ( $column_pointer = 1 ; $column_pointer <= $minimum_number_of_columns ; $column_pointer ++ )
                    {
                        $list_of_values_in_column[ $column_pointer ] .= $value_in_column[ $column_pointer - 1 ] . " " ;
                    }
                }
            }
            for ( $column_pointer = 1 ; $column_pointer <= $minimum_number_of_columns ; $column_pointer ++ )
            {
                $list_of_values_in_column[ $column_pointer ] =~ s/ +$// ;
                $global_dashrep_replacement{ $list_name_prefix . "-" . $column_pointer } = $list_of_values_in_column[ $column_pointer ] ;
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; copied from columns in file " . $source_filename . " to phrase names with prefix " . $operand_two . "}}\n" ;
            }
        }
        if ( $possible_error_message ne "" )
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
            }
        }
        close( INFILE ) ;
#  end of action code


#-----------------------------------------------
#  Handle the actions:
#  gather-tagged-info-from-file
#  gather-from-tagged-file-one-entry

    } elsif ( ( $action_name eq "gather-tagged-info-from-file" ) || ( $action_name eq "gather-from-tagged-file-one-entry" ) )
    {
        $accumulated_matching_entry_info = "" ;
        if ( open ( INFILE , '<' . $source_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [warning: file named " . $source_filename . " not found, or could not be opened" . "]\n" ;
        }
        if ( $possible_error_message eq "" )
        {
            $entry_begin = $global_dashrep_replacement{ "dashrep-gather-tag-begin" } ;
            if ( $entry_begin !~ /^[^ ]+$/ )
            {
                $entry_begin = "entry_begin" ;
            }
            $entry_end = $global_dashrep_replacement{ "dashrep-gather-tag-end" } ;
            if ( $entry_end !~ /^[^ ]+$/ )
            {
                $entry_end = "entry_end" ;
            }
            $entry_unique = $global_dashrep_replacement{ "dashrep-gather-tag-unique" } ;
            if ( $entry_unique !~ /^[^ ]+$/ )
            {
                $entry_unique = "url" ;
            }
            $entry_delete = $global_dashrep_replacement{ "dashrep-gather-tag-delete" } ;
            if ( $entry_delete !~ /^[^ ]+$/ )
            {
                $entry_delete = "delete_id" ;
            }
            if ( $action_name eq "gather-from-tagged-file-one-entry" )
            {
                $entry_matching_id = $global_dashrep_replacement{ "dashrep-gather-tag-matching-id" } ;
                if ( $entry_matching_id !~ /^[^ ]+$/ )
                {
                    $entry_matching_id = "1" ;
                }
            } elsif ( $action_name eq "gather-tagged-info-from-file" )
            {
                $entry_matching_id = "" ;
            }
            $accumulated_matching_entry_info = "" ;
            $possible_matching_entry_info = "" ;
            $unique_value = "" ;
            $list_of_tag_values_in_sequence_encountered = "" ;
            %content_for_tag = ( ) ;
            %found_unique_value = ( ) ;
            %exists_tag_name = ( ) ;
            $line_status = "between" ;
            while ( $input_line = <INFILE> )
            {
                chomp( $input_line ) ;
                $pointer = index( $input_line , "\r" ) ;
                if ( $pointer >= 0 )
                {
                    $input_line =~ s/[\r\n]+//gs ;
                }
                if ( $entry_matching_id ne "" )
                {
#                   This section of code applies to action: gather-from-tagged-file-one-entry
                    if ( $input_line =~ /^ *([^ ]+) *$/ )
                    {
                        $first_word = $1 ;
                        if ( $first_word eq $entry_begin )
                        {
                            $line_status = "within" ;
                            $possible_matching_entry_info = "" ;
                        } elsif ( $first_word eq $entry_end )
                        {
                            if ( $line_status eq "within-matching" )
                            {
                                $accumulated_matching_entry_info .= $possible_matching_entry_info ;
                            }
                            $possible_matching_entry_info = "" ;
                            $line_status = "between" ;
                        } elsif ( ( $line_status eq "within" ) || ( $line_status eq "within-matching" ) )
                        {
                            $possible_matching_entry_info .= $input_line . "\n" ;
                        }

                    } elsif ( $input_line =~ /^ *([^ ]+) +([^ \t\n\r]+) *$/ )
                    {
                        $first_word = $1 ;
                        $second_word = $2 ;
                        if ( $first_word eq $entry_unique )
                        {
                            if ( $second_word eq $entry_matching_id )
                            {
                                $line_status = "within-matching" ;
                                $possible_matching_entry_info .= $input_line . "\n" ;
                            } else
                            {
                                $line_status = "within-not-matching" ;
                                $possible_matching_entry_info = "" ;
                            }
                        } elsif ( $first_word eq $entry_delete )
                        {
                            if ( $second_word eq $entry_matching_id )
                            {
                                $accumulated_matching_entry_info = "" ;
                            } else
                            {
                                $possible_matching_entry_info = "" ;
                                $line_status = "between" ;
                            }
                        } elsif ( ( $line_status eq "within" ) || ( $line_status eq "within-matching" ) )
                        {
                            $possible_matching_entry_info .= $input_line . "\n" ;
                        }
                    } elsif ( ( $line_status eq "within" ) || ( $line_status eq "within-matching" ) )
                    {
                        $possible_matching_entry_info .= $input_line . "\n" ;
                    }
                } else
                {
#                   This section of code applies to action: gather-tagged-info-from-file
                    if ( $input_line =~ /^ *([^ ]+) *$/ )
                    {
                        $first_word = $1 ;
                        if ( $first_word eq "multi_line_end" )
                        {
                            $line_status = "within" ;
                        } elsif ( ( $first_word eq $entry_end ) || ( $first_word eq $entry_begin ) )
                        {
                            if ( $unique_value =~ /^[^ ]+$/ )
                            {
                                foreach $tag_name ( keys( %content_for_tag ) )
                                {
                                    $global_dashrep_replacement{ $tag_name . "-value-for-unique-id-" . $unique_value } = $content_for_tag{ $tag_name } ;
                                }
                            } elsif ( ( $entry_matching_id eq "" ) && ( $first_word eq $entry_end ) )
                            {
                                $global_trace_log .= "{{trace; warning: action " . $action_name . " encountered a set of items that do not contain a unique value, so no definitions were created for this set of items" . "}}\n" ;
                            }
                            $unique_value = "" ;
                            %content_for_tag = ( ) ;
                            if ( $first_word eq $entry_begin )
                            {
                                $line_status = "within" ;
                            } else
                            {
                                $line_status = "between" ;
                            }
                        } elsif ( $line_status eq "within_multiline" )
                        {
                            $content_for_tag{ $multiline_value_name } .= $input_line . " " ;
                        } else
                        {
                            $content_for_tag{ $first_word } = "" ;
                        }
                    } elsif ( $line_status eq "within_multiline" )
                    {
                        $content_for_tag{ $multiline_value_name } .= $input_line . " " ;
                    } elsif ( $input_line =~ /^ *([^ ]+) +([^ ].*)$/ )
                    {
                        $first_word = $1 ;
                        $remainder_of_line = $2 ;
                        if ( $first_word eq $entry_unique )
                        {
                            $unique_value = $remainder_of_line ;
                            $unique_value =~ s/[ \n\r]+/_/g ;
                            if ( not( exists( $found_unique_value{ $unique_value } ) ) )
                            {
                                $found_unique_value{ $unique_value } = "found" ;
                            }
                        } elsif ( $first_word eq $entry_delete )
                        {
                            $unique_value = $remainder_of_line ;
                            $unique_value =~ s/[ \n\r]+/_/g ;
                            $found_unique_value{ $unique_value } = "delete" ;
                        } elsif ( $remainder_of_line =~ /^ *multi_line_begin/ )
                        {
                            $line_status = "within_multiline" ;
                            $multiline_value_name = $first_word ;
                            $content_for_tag{ $multiline_value_name } = "" ;
                        } else
                        {
                            $content_for_tag{ $first_word } = $remainder_of_line ;
                            if ( not( exists( $exists_tag_name{ $first_word } ) ) )
                            {
                                $exists_tag_name{ $first_word } = "yes" ;
                                if ( $list_of_tag_values_in_sequence_encountered eq "" )
                                {
                                    $list_of_tag_values_in_sequence_encountered = $entry_unique . " " ;
                                } else
                                {
                                    $list_of_tag_values_in_sequence_encountered .= " " ;
                                }
                                $list_of_tag_values_in_sequence_encountered .= $first_word ;
                            }
                        }
                    }
                }
            }
            if ( $action_name eq "gather-from-tagged-file-one-entry" )
            {
                $global_dashrep_replacement{ $target_phrase_name } = $accumulated_matching_entry_info ;
            } elsif ( $action_name eq "gather-tagged-info-from-file" )
            {
                if ( $unique_value =~ /^[^ ]+$/ )
                {
                    foreach $tag_name ( keys( %content_for_tag ) )
                    {
                        $global_dashrep_replacement{ $tag_name . "-value-for-unique-id-" . $unique_value } = $content_for_tag{ $tag_name } ;
                    }
                }
                $list_of_unique_values = "" ;
                foreach $unique_value ( keys( %found_unique_value ) )
                {
                    if ( $found_unique_value{ $unique_value } ne "delete" )
                    {
                        if ( $list_of_unique_values ne "" )
                        {
                            $list_of_unique_values .= " " ;
                        }
                        $list_of_unique_values .= $unique_value ;
                    }
                }
                $global_dashrep_replacement{ $target_phrase_name } = $list_of_unique_values ;
                $list_of_tag_names = "" ;
                foreach $tag_name ( keys( %exists_tag_name ) )
                {
                    if ( $list_of_tag_names ne "" )
                    {
                        $list_of_tag_names .= " " ;
                    }
                    $list_of_tag_names .= $tag_name ;
                }
                $global_dashrep_replacement{ "dashrep-gathered-tag-names" } = $list_of_tag_names ;
                $global_dashrep_replacement{ "dashrep-gathered-tag-names-in-sequence" } = $list_of_tag_values_in_sequence_encountered ;
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; did action " . $action_name ." with file " . $source_filename . " and target phrase " . $target_phrase_name . "}}\n" ;
            }
        } else
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
            }
        }
        close( INFILE ) ;
#  end of action code


#-----------------------------------------------
#  Handle the action:
#  write-gathered-listed-items-to-end-of-file

    } elsif ( $action_name eq "write-gathered-listed-items-to-end-of-file" )
    {
        $accumulated_text = "" ;
        if ( $target_filename eq "" )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_phrase_name . " and " . $target_filename . "]" ;
        } elsif ( $global_dashrep_replacement{ "yes-or-no-permission-to-append-to-files" } ne "yes" )
        {
            $global_trace_log .= "{{trace; attempt to copy from phrase " . $source_phrase_name . " to end of file " . $target_filename . "}}\n" ;
            $possible_error_message .= " [warning, do not have permission to append to files]" ;
        } elsif ( open ( OUTFILE , '>>' . $target_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [warning, file named " . $target_filename . " could not be opened for writing]" ;
        }
        if ( $possible_error_message eq "" )
        {
            $entry_begin = $global_dashrep_replacement{ "dashrep-gather-tag-begin" } ;
            $entry_end = $global_dashrep_replacement{ "dashrep-gather-tag-end" } ;
            $entry_unique = $global_dashrep_replacement{ "dashrep-gather-tag-unique" } ;
            @list_of_tag_names = ( ) ;
            if ( ( exists( $global_dashrep_replacement{ "dashrep-gathered-tag-names-in-sequence" } ) ) && ( $global_dashrep_replacement{ "dashrep-gathered-tag-names-in-sequence" } =~ /[^ ]/ ) )
            {
                @list_of_tag_names = split( /[ \n\r]+/ , $global_dashrep_replacement{ "dashrep-gathered-tag-names-in-sequence" } ) ;
            }
            @list_of_unique_values = ( ) ;
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                @list_of_unique_values = split( /[ \n\r]+/ , $global_dashrep_replacement{ $operand_one } ) ;
            }
            foreach $unique_value ( @list_of_unique_values )
            {
                $accumulated_text .= $entry_begin . "\n" ;
                $accumulated_text .= $entry_unique . " " . $unique_value . "\n" ;
                foreach $tag_name ( @list_of_tag_names )
                {
                    $phrase_name = $tag_name . "-value-for-unique-id-" . $unique_value ;
                    if ( exists( $global_dashrep_replacement{ $phrase_name } ) )
                    {
                        $accumulated_text .= $tag_name . " " . $global_dashrep_replacement{ $phrase_name } . "\n" ;
                    }
                }
                $accumulated_text .= $entry_end . "\n\n" ;
            }
            print OUTFILE $accumulated_text . "\n" ;

            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; wrote gathered selected items listed in phrase " . $source_phrase_name . " to end of file " . $target_filename . "}}\n" ;
            }
        } else
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
            }
        }
        close( OUTFILE ) ;
        if ( not( chmod( $global_file_write_protection_mode , $target_filename ) ) )
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: protection of output file " . $target_filename . "  not successful}}\n" ;
                $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
            }
        }
#  end of action code


#-----------------------------------------------
#  Handle the action:
#  linewise-read-from-file-and-use-handler

    } elsif ( $action_name eq "linewise-read-from-file-and-use-handler" )
    {
        if ( ( $source_filename eq "" ) || ( $target_phrase_name eq "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $target_phrase_name . "]" ;
        } elsif ( open ( INFILE , '<' . $source_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [warning, file named " . $source_filename . " not found, or could not be opened]" ;
        }
        if ( $possible_error_message eq "" )
        {
            $global_nesting_level_of_file_actions ++ ;
            if ( $global_nesting_level_of_file_actions > 1 )
            {
                $possible_error_message .= " [warning, file-related action called recursivley, which is not allowed]" ;
            } else
            {
                $line_count = 1 ;
                while ( $input_line = <INFILE> )
                {
                    chomp( $input_line ) ;
                    $global_dashrep_replacement{ "linewise-input-line-from-file" } = $input_line ;
                    $global_dashrep_replacement{ "linewise-input-line-count" } = $line_count ;
                    $partial_translation = &dashrep_expand_parameters( $target_phrase_name );
                    $translation = &dashrep_expand_phrases( $partial_translation );
                    if ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; after parameters expanded: " . $partial_translation . "}}\n" ;
                        $global_trace_log .= "{{trace; after phrases expanded: " . $partial_translation . "}}\n" ;
                    }
                    $global_nesting_level_of_file_actions -- ;
                    $line_count ++ ;
                }
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; processed each line in file " . $source_filename . " using handler " . $target_phrase_name . "}}\n" ;
            }
        } else
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
            }
        }
        close( INFILE ) ;
#  end of action code


#-----------------------------------------------
#  End of branching.

    }


#-----------------------------------------------
#  Handle the actions:
#  write-all-dashrep-definitions-to-file
#  write-dashrep-definitions-listed-in-phrase-to-file
#
#  The filename is edited to remove any path
#  specifications, and then the prefix in the
#  appropriate dashrep phrase is used.

    $definitions_or_phrase_names = "" ;
    if ( $action_name eq "write-dashrep-definitions-listed-in-phrase-to-file" )
    {
        if ( ( $source_phrase_name eq "" ) || ( $target_filename eq "" ) || ( $operand_two eq "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_phrase_name . " and " . $target_filename . " and " . $operand_two . "]" ;
        } else
        {
            $definitions_or_phrase_names = "definitions" ;
            @list_of_phrases = split( /[ \n\r]+/ , $global_dashrep_replacement{ $source_phrase_name } ) ;
            @sequence_of_phrases = @list_of_phrases ;
        }
    } elsif ( $action_name eq "write-all-dashrep-definitions-to-file" )
    {
        if ( ( $target_filename eq "" ) || ( $operand_two ne "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $target_filename . " and " . $operand_two . "]" ;
        } else
        {
            $definitions_or_phrase_names = "definitions" ;
            @list_of_phrases = &dashrep_get_list_of_phrases( ) ;
            @sequence_of_phrases = sort( @list_of_phrases ) ;
            unshift( @sequence_of_phrases , "dashrep-language-yes" ) ;
        }
    }
    if ( $definitions_or_phrase_names ne "" )
    {
        if ( $#list_of_phrases < 0 )
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: no phrases to write (to file)}}\n" ;
            }
        } else
        {
            $global_nesting_level_of_file_actions ++ ;
            if ( $global_nesting_level_of_file_actions > 1 )
            {
                $possible_error_message .= " [warning, file-related action called recursivley, which is not allowed]" ;
            } elsif ( $global_dashrep_replacement{ "yes-or-no-permission-to-delete-or-overwrite-files" } ne "yes" )
            {
                $possible_error_message .= " [warning, do not have permission to delete or overwrite files]" ;
            }
            if ( $global_dashrep_replacement{ "yes-or-no-export-delimited-definitions" } eq "yes" )
            {
                if ( exists( $global_dashrep_replacement{ "export-defs-all-begin" } ) )
                {
                    $all_defs_begin = "[-export-defs-all-begin-]\n\n" ;
                } else
                {
                    $all_defs_begin = "" ;
                }
                if ( exists( $global_dashrep_replacement{ "export-defs-all-end" } ) )
                {
                    $all_defs_end = "[-export-defs-all-end-]\n\n" ;
                } else
                {
                    $all_defs_end = "" ;
                }
                if ( exists( $global_dashrep_replacement{ "export-defs-phrase-begin" } ) )
                {
                    $phrase_begin = "[-export-defs-phrase-begin-] " ;
                } else
                {
                    $phrase_begin = "" ;
                }
                if ( exists( $global_dashrep_replacement{ "export-defs-phrase-end" } ) )
                {
                    $phrase_end = " [-export-defs-phrase-end-]\n\n" ;
                } else
                {
                    $phrase_end = "" ;
                }
                if ( exists( $global_dashrep_replacement{ "export-defs-def-begin" } ) )
                {
                    $def_begin = "[-export-defs-def-begin-] " ;
                } else
                {
                    $def_begin = "" ;
                }
                if ( exists( $global_dashrep_replacement{ "export-defs-def-end" } ) )
                {
                    $def_end = " [-export-defs-def-end-]\n\n" ;
                } else
                {
                    $def_end = "" ;
                }
            } else
            {
                $all_defs_begin = "dashrep-definitions-begin\n\n" ;
                $all_defs_end = "dashrep-definitions-end\n\n" ;
                $phrase_begin = "" ;
                $phrase_end = ":\n" ;
                $def_begin = "" ;
                $def_end = "\n-----\n\n" ;
            }
            if ( $possible_error_message eq "" )
            {
                if ( open ( OUTFILE , '>' . $target_filename ) )
                {
                    $possible_error_message .= "" ;
                } else
                {
                    $possible_error_message .= " [warning, file named " . $target_filename . " could not be opened for writing]" ;
                }
                if ( $possible_error_message eq "" )
                {
                    $counter = 0 ;
                    if ( $definitions_or_phrase_names eq "definitions" )
                    {
                        print OUTFILE $all_defs_begin ;
                        foreach $phrase_name ( @sequence_of_phrases )
                        {
                            if ( ( defined( $phrase_name ) ) && ( $phrase_name =~ /^[^ ]+$/ ) && ( exists( $global_dashrep_replacement{ $phrase_name } ) ) && ( defined( $global_dashrep_replacement{ $phrase_name } ) ) && ( $phrase_name ne "four-hyphens" ) )
                            {
                                print OUTFILE $phrase_begin . $phrase_name . $phrase_end . $def_begin . $global_dashrep_replacement{ $phrase_name } . $def_end ;
                                $counter ++ ;
                            }
                        }
                        print OUTFILE $all_defs_end ;
                    } else
                    {
                        foreach $phrase_name ( @sequence_of_phrases )
                        {
                            if ( ( defined( $phrase_name ) ) && ( $phrase_name =~ /[^ ]/ ) && ( exists( $global_dashrep_replacement{ $phrase_name } ) ) && ( $phrase_name ne "four-hyphens" ) )
                            {
                                print OUTFILE $phrase_name . "\n" ;
                                $counter ++ ;
                            }
                        }
                    }
                    if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; wrote " . $counter . " " . $definitions_or_phrase_names . " to file: " . $target_filename . "}}\n" ;
                    }
                } else
                {
                    if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
                    }
                }
                close( OUTFILE ) ;
                if ( not( chmod( $global_file_write_protection_mode , $target_filename ) ) )
                {
                    if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; warning: protection of output file " . $target_filename . "  not successful}}\n" ;
                    }
                }
            }
            $global_nesting_level_of_file_actions -- ;
        }
    }
#  end of action code


#-----------------------------------------------
#  If there was an error message, put it
#  into the text that is returned as the
#  result.
#  Also, if requested, put the error message
#  into the trace log.

    $possible_error_message =~ s/^ +// ;
    $possible_error_message =~ s/ +$// ;
    if ( $possible_error_message =~ /[^ ]/ )
    {
        $action_result = " " . $possible_error_message . " " ;
        if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
        {
            $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
        }
    }
    $possible_error_message = "" ;


#-----------------------------------------------
#  Put the action result -- which is usually a
#  single space -- into the global output variable.

    $global_action_result = $action_result ;


#-----------------------------------------------
#  Make the logged debugging (trace) information
#  available.

    $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= $global_trace_log ;
    $global_trace_log = "" ;


#-----------------------------------------------
#  Return.
#  The calling subroutine will return the value
#  of the "global_action_result" variable.

    return ;


#-----------------------------------------------
#  End of subroutine.

}


=head2 dashrep_xml_tags_to_dashrep

Deprecated.

Converts a single line of XML code into Dashrep
code in which XML tags are replaced by Dashrep
phrases.
Tags are replaced by hyphenated phrases that
are named according to the accumulated XML
tag names, with "begin-" and "end-" to indicate
the beginning and ending tags.  The prefix
"begin-and-end-" indicates a self-terminating
XML tag (e.g. "<br />").
If the resulting phrase has a Dashrep definition,
that definition (which is assumed to be a single
phrase) is used instead.
If the non-tag content contains any hyphens,
they are replaced with the phrase "hyphen-here".
If a tag's opening bracket (<) and closing
bracket (>) are not both on the same line, the
tag will not be recognized.

=cut


#-----------------------------------------------
#-----------------------------------------------
#             dashrep_xml_tags_to_dashrep
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_xml_tags_to_dashrep
{

    my $input_text ;
    my $first_tag_name ;
    my $output_text ;
    my $open_brackets ;
    my $close_brackets ;
    my $remaining_string ;
    my $prefix_text ;
    my $tag_full ;
    my $suffix_text ;
    my $tag_name ;
    my $previous_input_text ;
    my $text_before_tag ;
    my $tag_and_possible_parameters ;
    my $parameter_name ;
    my $parameter_value ;
    my $text_after_tag ;
    my $revised_tags ;
    my $possible_slash ;
    my $may_include_closing_slash ;
    my $previous_tag_name ;
    my $sequence_without_hyphen_prefix ;
    my $starting_position_of_last_tag_name ;
    my $full_phrase ;
    my $text_before_cdata ;
    my $text_cdata ;
    my $text_after_cdata ;
    my $revised_cdata ;


#-----------------------------------------------
#  Get the input text.

    if ( scalar( @_ ) == 1 )
    {
        $input_text = $_[ 0 ] ;
    } else
    {
#  remove-from-cpan-version-begin
        warn "Warning: Call to xml_tags_to_dashrep subroutine does not have exactly one parameter." ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#        carp "Warning: Call to xml_tags_to_dashrep subroutine does not have exactly one parameter." ;
#  uncomment-for-cpan-version-end
        return 0 ;
    }


#-----------------------------------------------
#  Trim spaces from the input line, and clear
#  the output text.

    $input_text =~ s/^ +// ;
    $input_text =~ s/ +$// ;
    $output_text = "" ;


#-----------------------------------------------
#  Check for the possibility of the tag level
#  being reset to zero, which allows multiple
#  XML files to be processed in turn.

    if ( $global_dashrep_replacement{ "dashrep-xml-level-reset-if-zero" } =~ /^0+$/ )
    {
        $global_xml_level = 0 ;
    }
    $global_dashrep_replacement{ "dashrep-xml-level-reset-if-zero" } = "" ;


#-----------------------------------------------
#  Get the tag name that is regarded as at
#  the highest level of interest.  Tags at
#  higher levels are ignored.

    $first_tag_name = $global_dashrep_replacement{ "dashrep-first-xml-tag-name" } ;


#-----------------------------------------------
#  If a line does not contain the same number
#  of open angle brackets (<) as close angle
#  brackets (>), and tracing is on, issue a
#  warning.

    $open_brackets = $input_text ;
    $open_brackets =~ s/[^<]//g ;
    $close_brackets = $input_text ;
    $close_brackets =~ s/[^>]//g ;
    if ( length( $open_brackets ) != length( $close_brackets ) )
    {
        if ( $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } eq "yes" )
        {
            $global_trace_log .= "{{trace; non-matching angle brackets: " . $input_text . "}}\n" ;
        }
    }


#-----------------------------------------------
#  If a tag is identified -- through use of
#  special hyphenated phrases -- as of the
#  open-and-close type that may not include a
#  closing slash (such as "<br>"), then insert
#  a closing tag.
#  Note that the match is case-sensitive.

    $remaining_string = $input_text ;
    $input_text = "" ;
    while ( $remaining_string =~ /^(.*?)(<[^ <>\/][^>]*[^>\/]>)(.*)$/ )
    {
        $prefix_text = $1 ;
        $tag_full = $2 ;
        $suffix_text = $3 ;
        $tag_name = $tag_full ;
        $tag_name =~ s/^<([^ >\/]+).*>$/$1/ ;
        if ( $tag_name ne "" )
        {
            if ( exists( $global_dashrep_replacement{ "dashrep-xml-yes-handle-open-close-tag-" . $tag_name } ) )
            {
                $tag_full .= '</' . $tag_name . ">" ;
                if ( $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; open-and-close type xml tag: " . $tag_name . " , modified to include closing tag: " . $tag_full . "}}\n" ;
                }
            }
        }
        $input_text .= $prefix_text . $tag_full ;
        $remaining_string = $suffix_text ;
    }
    $input_text .= $remaining_string ;


#-----------------------------------------------
#  If a tag of the open-and-close type does
#  not have a space before the closing slash
#  (such as "<br/>"), then insert the missing
#  space.

    $input_text =~ s/(<[^>]*[^> ])(\/>)/$1 $2/sgi ;


#-----------------------------------------------
#  If an open-and-close tag contains parameters
#  within the tag, convert the tag into an open
#  tag immediately followed by its close tag, so
#  that the parameters within the tag will be
#  put into separate XML tags.

    $input_text =~ s/(<([^ >\!\?\/]+)[^>]* [^ >\=]+=[\"\'][^>]+) +\/>/$1><\/$2>/sgi ;


#-----------------------------------------------
#  If one of the parameters within a tag is a
#  "style" tag that has multiple CSS
#  parameters with their own parameter values
#  (with a colon (:) separating each
#  sub-parameter name from its sub-parameter
#  value, and with semicolons (;) separating
#  those name & value pairs within the XML
#  parameter), split up those sub-parameters
#  into separate parameters (with combined
#  names).

    $previous_input_text = "" ;
    while ( $input_text ne $previous_input_text )
    {
        $previous_input_text = $input_text ;
        $input_text =~ s/(<[^>]+ style) *= *\"([^\"\:\;>]+) *: *([^\"\:\;>]*) *; *([^\">]+)\"([^>]*>)/$1_$2=\"$3\" style=\"$4\"$5/sgi ;
        $input_text =~ s/(<[^>]+ style) *= *\"([^\"\:\;>]+) *: *([^\"\:\;>]*)\"([^>]*>)/$1_$2=\"$3\"$4/sgi ;
        if ( $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } eq "yes" )
        {
            if ( $previous_input_text ne $input_text )
            {
                $global_trace_log .= "{{trace; after xml sub-parameters extracted: " . $input_text . "}}\n" ;
            }
        }
    }


#-----------------------------------------------
#  Expand parameters within a tag into separate
#  XML tags.
#  Possibly do later: Insert "begin-xml-tag-parameters" and
#  "end-xml-tag-parameters" around parameters.

    while ( $input_text =~ /^(.*)(<[^ >\!\?\/][^>]*) ([^ >\=]+)=((\"([^>\"]*)\")|([^ >\"\']+)) *>(.*)$/ )
    {
        $text_before_tag = $1 ;
        $tag_and_possible_parameters = $2 ;
        $parameter_name = $3 ;
        $parameter_value = $4 ;
        $text_after_tag = $8 ;
        $parameter_value =~ s/^\"(.*)\"$/$1/ ;
        $parameter_name =~ s/\-/_/g ;
        $revised_tags = $tag_and_possible_parameters . "><" . $parameter_name . ">" . $parameter_value . '</' . $parameter_name . ">" ;
        $input_text = $text_before_tag . $revised_tags . $text_after_tag ;
        if ( $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } eq "yes" )
        {
            $global_trace_log .= "{{trace; after xml parameter extracted: " . $revised_tags . "}}\n" ;
        }
    }


#-----------------------------------------------
#  If the <!CDATA[[ ... ]]> syntax is used,
#  within the enclosed text, replace angle
#  brackets with HTML symbol strings.

    while ( $input_text =~ /^(.*?)<!\[CDATA\[(.*?)\]\]>(.*)$/i )
    {
        $text_before_cdata = $1 ;
        $text_cdata = $2 ;
        $text_after_cdata = $3 ;
        $revised_cdata = $text_cdata ;
        $revised_cdata =~ s/</&lt;/sg ;
        $revised_cdata =~ s/>/&gt;/sg ;
        $input_text = $text_before_cdata . "<cdata>" . $revised_cdata . "<\/cdata>" . $text_after_cdata ;
        if ( $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } eq "yes" )
        {
            $global_trace_log .= "{{trace; CDATA text converted to non-XML: " . $revised_cdata . "}}\n" ;
        }
    }


#-----------------------------------------------
#  Begin a loop that repeats for each XML tag.
#
#  Get the name within a (single) tag, and
#  ignore any other content within the tag.
#  Ignore the opening XML-standard-required
#  declaration.

    while ( $input_text =~ /^ *([^<>]*)<(\/?)([^ >\?\/]+[^ >\/]*)([^>]*)>(.*)$/ )
    {
        $text_before_tag = $1 ;
        $possible_slash = $2 ;
        $tag_name = $3 ;
        $may_include_closing_slash = $4 ;
        $suffix_text = $5 ;
        if ( $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } eq "yes" )
        {
            $global_trace_log .= "{{trace; input line: " . $input_text . "}}\n" ;
        }
        $input_text = $suffix_text ;
        if ( $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } eq "yes" )
        {
            $global_trace_log .= "{{trace; tag: <" . $possible_slash . $tag_name . ">}}\n" ;
        }


#-----------------------------------------------
#  Stop translating if requested.

        if ( $global_dashrep_replacement{ "dashrep-stop-translation" } eq "yes" )
        {
            if ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; stopping translation as requested}}\n";
            }
            last ;
        }


#-----------------------------------------------
#  Check for an endless loop.

        $global_endless_loop_counter ++ ;
        $global_replacement_count_for_item_name{ "XML parsing subroutine" } ++ ;
        if ( $global_endless_loop_counter > $global_endless_loop_counter_limit )
        {
            &dashrep_internal_endless_loop_info( ) ;
            $global_dashrep_replacement{ "dashrep-stop-translation" } = "yes" ;
            $global_trace_log .= "{{trace; Error: The dashrep_xml_tags_to_dashrep subroutine has encountered an endless loop, so attempting to stop translation gently}}\n";
            last ;
        }
        if ( $global_endless_loop_counter > ( $global_endless_loop_counter_limit + 100 ) )
        {
#  remove-from-cpan-version-begin
            warn "Warning: The dashrep_xml_tags_to_dashrep subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#            carp "Warning: The dashrep_xml_tags_to_dashrep subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  uncomment-for-cpan-version-end
            return 0 ;
        }


#-----------------------------------------------
#  If the non-tag content text contains any
#  hyphens, replace them with the phrase
#  "hypen-here".

        $text_before_tag =~ s/\-/dashrep_internal_hyphen_here/sg ;
        $text_before_tag =~ s/dashrep_internal_hyphen_here/ hyphen-here /sg ;


#-----------------------------------------------
#  If any text precedes the tag, write it on a
#  separate line.  However, do not write it if
#  the first tag has not yet been encountered.

        if ( ( $text_before_tag =~ /[^ ]/ ) && ( $global_xml_level_number > 0 ) )
        {
            if ( $global_ignore_level <= 0 )
            {
                $output_text .= $text_before_tag . "\n" ;
            }
        }


#-----------------------------------------------
#  If a specially named Dashrep phrase indicates
#  that the tag should be ignored, ignore it.

        if ( exists( $global_dashrep_replacement{ "dashrep-xml-yes-ignore-tag-named-" . $tag_name } ) )
        {
            if ( $global_dashrep_replacement{ "dashrep-xml-yes-ignore-tag-named-" . $tag_name } eq "yes" )
            {
                if ( $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; ignoring tag: " . $tag_name . "}}\n" ;
                }
                next ;
            }
        }


#-----------------------------------------------
#  If a specially named Dashrep phrase indicates
#  that the XML tag should be renamed, rename it as
#  requested.

        if ( exists( $global_dashrep_replacement{ "dashrep-xml-replacement-name-for-tag-named-" . $tag_name } ) )
        {
            $previous_tag_name = $tag_name ;
            $tag_name = $global_dashrep_replacement{ "dashrep-xml-replacement-name-for-tag-named-" . $previous_tag_name } ;
            if ( $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; changing tag name " . $previous_tag_name . " into tag name " . $tag_name . "}}\n" ;
            }
        }


#-----------------------------------------------
#  If the tag is of the "close" type, write the
#  appropriate dashrep phrase (and indent it to
#  indicate the nesting level).  Then remove the
#  lowest-level tag name from the phrase that
#  contains all the tag names.

        if ( $possible_slash eq '/' )
        {
            if ( length( $global_xml_accumulated_sequence_of_tag_names ) > 0 )
            {
                if ( $global_xml_tag_at_level_number[ $global_xml_level_number ] eq $tag_name )
                {
                    $full_phrase = "end" . $global_xml_accumulated_sequence_of_tag_names ;
                    if ( exists( $global_dashrep_replacement{ $full_phrase } ) )
                    {
                        $global_ignore_level = 0 ;
                    }
                    if ( $global_ignore_level <= 0 )
                    {
                        if ( ( not( exists( $global_dashrep_replacement{ "dashrep-xml-yes-ignore-if-no-tag-replacement" } ) ) ) || ( $global_dashrep_replacement{ "dashrep-xml-yes-ignore-if-no-tag-replacement" } ne "yes" ) || ( exists( $global_dashrep_replacement{ $full_phrase } ) ) )
                        {
                            $output_text .= substr( $global_spaces , 0 , ( 2 * $global_xml_level_number ) ) ;
                            $output_text .= "[-" ;
                            if ( exists( $global_dashrep_replacement{ $full_phrase } ) )
                            {
                                $output_text .= $global_dashrep_replacement{ $full_phrase } ;
                            } else
                            {
                                $output_text .= $full_phrase ;
                            }
                            $output_text .= "-]" ;
                            $output_text .= "\n" ;
                        }
                    } else
                    {
                        $global_ignore_level -- ;
                    }
                    $sequence_without_hyphen_prefix = $global_xml_accumulated_sequence_of_tag_names ;
                    $sequence_without_hyphen_prefix =~ s/^\-// ;
                    $global_exists_xml_hyphenated_phrase{ $sequence_without_hyphen_prefix } = "exists" ;
                    $starting_position_of_last_tag_name = length( $global_xml_accumulated_sequence_of_tag_names ) - length( $global_xml_tag_at_level_number[ $global_xml_level_number ] ) - 1 ;
                    if ( $starting_position_of_last_tag_name > 0 )
                    {
                        $global_xml_accumulated_sequence_of_tag_names = substr( $global_xml_accumulated_sequence_of_tag_names , 0 , $starting_position_of_last_tag_name ) ;
                    } else
                    {
                        $global_xml_accumulated_sequence_of_tag_names = "" ;
                    }
                    $global_xml_level_number -- ;
                } else
                {
                    if ( $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; close tag " . $tag_name . " ignored because it does not match expected close tag name " . $global_xml_tag_at_level_number[ $global_xml_level_number ] . "}}\n" ;
                    }
                }
            }


#-----------------------------------------------
#  If the tag is of the singular (open and close)
#  type, write the appropriate dashrep phrase.

        } elsif ( $may_include_closing_slash =~ /\// )
        {
            if ( length( $global_xml_accumulated_sequence_of_tag_names ) > 0 )
            {
                $full_phrase = "begin-and-end" . $global_xml_accumulated_sequence_of_tag_names . "-" . $tag_name ;
                if ( ( exists( $global_dashrep_replacement{ "dashrep-xml-yes-ignore-if-no-tag-replacement" } ) ) && ( $global_dashrep_replacement{ "dashrep-xml-yes-ignore-if-no-tag-replacement" } eq "yes" ) && ( not( exists( $global_dashrep_replacement{ $full_phrase } ) ) ) )
                {
                    $global_ignore_level ++ ;
                }
                if ( exists( $global_dashrep_replacement{ $full_phrase } ) )
                {
                    $global_ignore_level = 0 ;
                }
                if ( $global_ignore_level <= 0 )
                {
                    $output_text .= substr( $global_spaces , 0 , ( 2 * ( $global_xml_level_number + 1 ) ) ) ;
                    $output_text .= "[-" ;
                    if ( exists( $global_dashrep_replacement{ $full_phrase } ) )
                    {
                        $output_text .= $global_dashrep_replacement{ $full_phrase } ;
                    } else
                    {
                        $output_text .= $full_phrase ;
                    }
                    $output_text .= "-]" ;
                    $output_text .= "\n" ;
                } else
                {
                    $global_ignore_level -- ;
                }
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
            if ( length( $global_xml_accumulated_sequence_of_tag_names ) <= 0 )
            {
                if ( $tag_name eq $first_tag_name )
                {
                    $global_xml_level_number ++ ;
                    $global_xml_tag_at_level_number[ $global_xml_level_number ] = $tag_name ;
                    $global_xml_accumulated_sequence_of_tag_names = "-" . $tag_name ;
                    if ( $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; specified top-level tag name: " . $first_tag_name . "}}\n" ;
                    }
                } elsif ( $first_tag_name =~ /^ *$/ )
                {
                    $global_xml_level_number ++ ;
                    $global_xml_tag_at_level_number[ $global_xml_level_number ] = $tag_name ;
                    $first_tag_name = $tag_name ;
                    $global_dashrep_replacement{ "dashrep-first-xml-tag-name" } = $first_tag_name ;
                    $global_xml_accumulated_sequence_of_tag_names = "-" . $tag_name ;
                    if ( $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; default top-level tag name: " . $tag_name . "}}\n" ;
                    }
                } else
                {
                    if ( $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; ignored tag: " . $tag_name . "}}\n" ;
                    }
                }
            } else
            {
                $global_xml_level_number ++ ;
                $global_xml_tag_at_level_number[ $global_xml_level_number ] = $tag_name ;
                $global_xml_accumulated_sequence_of_tag_names .= "-" . $tag_name ;
            }
            if ( length( $global_xml_accumulated_sequence_of_tag_names ) > 0 )
            {
                $full_phrase = "begin" . $global_xml_accumulated_sequence_of_tag_names ;
                if ( ( exists( $global_dashrep_replacement{ "dashrep-xml-yes-ignore-if-no-tag-replacement" } ) ) && ( $global_dashrep_replacement{ "dashrep-xml-yes-ignore-if-no-tag-replacement" } eq "yes" ) && ( not( exists( $global_dashrep_replacement{ $full_phrase } ) ) ) )
                {
                    $global_ignore_level ++ ;
                }
                if ( exists( $global_dashrep_replacement{ $full_phrase } ) )
                {
                    $global_ignore_level = 0 ;
                }
                if ( $global_ignore_level <= 0 )
                {
                    $output_text .= substr( $global_spaces , 0 , ( 2 * ( $global_xml_level_number - 1 ) ) ) ;
                    $output_text .= "[-" ;
                    if ( exists( $global_dashrep_replacement{ $full_phrase } ) )
                    {
                        $output_text .= $global_dashrep_replacement{ $full_phrase } ;
                    } else
                    {
                        $output_text .= $full_phrase ;
                    }
                    $output_text .= "-]" ;
                    $output_text .= "\n" ;
                }
                $sequence_without_hyphen_prefix = $global_xml_accumulated_sequence_of_tag_names ;
                $sequence_without_hyphen_prefix =~ s/^\-// ;
                $global_exists_xml_hyphenated_phrase{ $sequence_without_hyphen_prefix } = "exists" ;
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

    if ( ( $input_text =~ /^ *([^ ].*)$/ ) && ( $global_xml_level_number > 0 ) )
    {
        $input_text = $1 ;
        $output_text .= "\n" . $input_text ;
        $input_text = "" ;
    }


#-----------------------------------------------
#  End of subroutine.

    return $output_text ;

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

    my $input_line ;
    my $all_lines ;
    my $line_count ;
    my $numeric_return_value ;
    my $revised_text ;
    my $after_possible_action ;
    my $error_message ;
    my $line_number ;


#-----------------------------------------------
#  Ensure there is no input text.

    if ( scalar( @_ ) != 0 )
    {
#  remove-from-cpan-version-begin
        warn "Warning: Call to dashrep_linewise_translate subroutine does not have exactly zero parameters." ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#        carp "Warning: Call to dashrep_linewise_translate subroutine does not have exactly zero parameters." ;
#  uncomment-for-cpan-version-end
        return 0 ;
    }


#-----------------------------------------------
#  Initialization.

    $after_possible_action = "" ;


#-----------------------------------------------
#  Read each line from the input file.

    $line_number = 0 ;
    while ( $input_line = <STDIN> )
    {
        chomp( $input_line );
        $line_number ++ ;
        $input_line =~ s/[\n\r\f\t]+/ /g ;
        if ( ( exists( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } ) ) && ( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } eq "yes" ) && ( $input_line =~ /[^ ]/ ) )
        {
            print "{{stdin line number " . $line_number . "}}\n" ;
            print "{{trace; linewise input line: " . $input_line . "}}\n" ;
        }


#-----------------------------------------------
#  Stop translating if requested.

        if ( $global_dashrep_replacement{ "dashrep-stop-translation" } eq "yes" )
        {
            if ( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; stopping translation as requested}}\n";
            }
            last ;
        }


#-----------------------------------------------
#  Check for an endless loop.

        $global_endless_loop_counter ++ ;
        $global_replacement_count_for_item_name{ "loop within linewise translation subroutine" } ++ ;
        if ( $global_endless_loop_counter > $global_endless_loop_counter_limit )
        {
            &dashrep_internal_endless_loop_info( ) ;
            $global_dashrep_replacement{ "dashrep-stop-translation" } = "yes" ;
            $global_trace_log .= "{{trace; Error: The dashrep_linewise_translate subroutine has encountered an endless loop, so attempting to stop translation gently}}\n";
            last ;
        }
        if ( $global_endless_loop_counter > ( $global_endless_loop_counter_limit + 100 ) )
        {
#  remove-from-cpan-version-begin
            warn "Warning: The dashrep_linewise_translate subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#            carp "Warning: The dashrep_linewise_translate subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  uncomment-for-cpan-version-end
            return 0 ;
        }


#-----------------------------------------------
#  Remove any comments that begin and end on
#  this line.

        $input_line =~ s/\*---+.*?---+\*/ /sg ;


#-----------------------------------------------
#  If there are Dashrep definitions, get them.

        if ( $input_line =~ /^ *dashrep-definitions-begin *$/ )
        {
            $all_lines = "" ;
            $line_count = 0 ;
            while ( $input_line = <STDIN> )
            {
                chomp( $input_line );
                $input_line =~ s/[\n\r\f\t]+/ /g ;
                if ( $input_line =~ /^ *dashrep-definitions-end *$/ )
                {
                    last;
                }
                if ( ( $input_line =~ /[^ ]/ ) && ( defined( $input_line ) ) )
                {
                    $all_lines .= $input_line . " " ;
                }
                $line_count ++ ;
            }
            if ( $all_lines =~ /[^ ]/ )
            {
                $numeric_return_value = &dashrep_import_replacements( $all_lines );
                if ( ( exists( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } ) ) && ( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } eq "yes" ) && ( $input_line =~ /[^ ]/ ) )
                {
                    print "{{trace; definition line: " . $input_line . " ; imported " . $numeric_return_value . " definitions from " . $line_count . " lines}}\n" ;
                }
            }


#-----------------------------------------------
#  If this line begins a multi-line comment,
#  ignore all the comment lines.

        } elsif ( $input_line =~ /^ *\*---+ *$/ )
        {
            if ( ( exists( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } ) ) && ( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } eq "yes" ) && ( $input_line =~ /[^ ]/ ) )
            {
                print "{{trace; linewise comment begins: " . $input_line . "}}\n" ;
            }
            while ( $input_line = <STDIN> )
            {
                chomp( $input_line );
                $input_line =~ s/[\n\r\f\t]+/ /g ;
                if ( $input_line =~ /^ *---+\* *$/ )
                {
                    if ( ( exists( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } ) ) && ( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } eq "yes" ) && ( $input_line =~ /[^ ]/ ) )
                    {
                        print "{{trace; linewise comment ends: " . $input_line . "}}\n" ;
                    }
                    last;
                }
                if ( ( exists( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } ) ) && ( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } eq "yes" ) && ( $input_line =~ /[^ ]/ ) )
                {
                    print "{{trace; linewise comment ignored: " . $input_line . "}}\n" ;
                }
            }


#-----------------------------------------------
#  Otherwise, translate this line by itself.

        } else
        {
            $global_endless_loop_counter = 0 ;
            %global_replacement_count_for_item_name = ( ) ;
            $input_line = "[-" . $input_line . "-]" ;
            $revised_text = &dashrep_expand_parameters( $input_line );
            $revised_text = &dashrep_expand_phrases( $revised_text );
            if ( ( exists( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } ) ) && ( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } eq "yes" ) && ( $after_possible_action =~ /^ *$/ ) && ( $revised_text =~ /[^ ]/ ) )
            {
                print "{{trace; line after action executed: " . $after_possible_action . "}}\n" ;
            }
            if ( ( exists( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } ) ) && ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" ) || ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" ) )
            {
                print $global_trace_log . "\n" ;
                $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= $global_trace_log ;
                $global_trace_log = "" ;
            }
            print $revised_text . "\n" ;

        }


#-----------------------------------------------
#  Repeat the loop for the next line.

    }


#-----------------------------------------------
#  End of subroutine.

    return $error_message ;

}


=head2 dashrep_compiler_access

Provides an access point for the Dashrep compiler.
Specifically this short subroutine gets an action
name, number of operands for the action, and operand
values and copies those text strings to global
variables, and then calls the dashrep_expand_parameters
subroutine.

This subroutine does not support actions for which
global_minimum_number_of_operands_for_action
is defined (even though the dashrep_expand_parameters
subroutine does support those actions).
And there are actions that should be avoided by the
compiler because they take control away from the
compiled code.

The parameters are: the action name, the number of
operands, and the first four operands.  If there
should be an action that requires a fifth operand,
it is not supported by this subroutine.

Return value is the text that is returned by the
dashrep_expand_parameters subroutine.

If any error occurs, this subroutine simply returns,
without indicating the error (because the compiler
should not generate those error conditions).

=cut


#-----------------------------------------------
#-----------------------------------------------
#         dashrep_compiler_access
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_compiler_access
{
    my $number_of_operands ;
    my $number_of_parameters ;
    my $return_text ;
    my @parameter_values ;


#-----------------------------------------------
#  Copy the operands to global variables.
#
#  Reminder:  Operands apply to the action,
#  and parameters apply to what is passed to
#  this subroutine.

    @parameter_values = @_ ;
    $number_of_parameters = scalar( @parameter_values ) ;
    if ( scalar( @parameter_values ) > 1 )
    {
        $global_single_action_name = $parameter_values[ 0 ] ;
        $number_of_operands = $parameter_values[ 1 ] + 0 ;
    } else
    {
        return "" ;
    }
    if ( ( not( exists( $global_required_number_of_operands_for_action{ $global_single_action_name } ) ) ) || ( $number_of_operands != $global_required_number_of_operands_for_action{ $global_single_action_name } ) )
    {
        return "" ;
    }
    $global_single_action_operand_one = "" ;
    $global_single_action_operand_two = "" ;
    $global_single_action_operand_three = "" ;
    $global_single_action_operand_four = "" ;
    $global_single_action_operand_five = "" ;
    if ( $number_of_operands > 2 )
    {
        $global_single_action_operand_one = $parameter_values[ 2 ] ;
        if ( $number_of_operands > 3 )
        {
            $global_single_action_operand_two = $parameter_values[ 3 ] ;
            if ( $number_of_operands > 4 )
            {
                $global_single_action_operand_three = $parameter_values[ 4 ] ;
                if ( $number_of_operands > 5 )
                {
                    $global_single_action_operand_four = $parameter_values[ 5 ] ;
                }
            }
        }
    }


#-----------------------------------------------
#  Call the dashrep_expand_parameters subroutine.

    $return_text = &dashrep_expand_parameters( ) ;


#-----------------------------------------------
#  End of subroutine.

    return $return_text ;

}



=head2 dashrep_internal_expand_phrases_faster_subset

Internal subroutine, not exported.
It is only needed within the Dashrep module.

=cut

#-----------------------------------------------
#-----------------------------------------------
#         Non-exported subroutine:
#
#      dashrep_internal_expand_phrases_faster_subset
#-----------------------------------------------
#-----------------------------------------------
#  This subroutine expands Dashrep code using
#  faster code that implements a subset of what
#  the full version handles.

#  This subroutine is not exported because it
#  is only needed within this Dashrep module.

sub dashrep_internal_expand_phrases_faster_subset
{

    my $expand_endless_cycle_count_maximum ;
    my $supplied_text ;
    my $current_phrase ;
    my $result_text ;
    my $output_buffer ;
    my $space_directive ;
    my $expand_endless_loop_counter ;
    my $expand_endless_loop_counter_maximum ;
    my $recursion_level ;
    my $pointer_to_phrase_begin ;
    my $pointer_to_next_space ;
    my $pointer_to_phrase_end ;
    my $prior_length ;
    my $prefix ;
    my $possible_phrase_name_with_underscores ;
    my $length_of_tag ;
    my $new_output_buffer ;
    my $pointer_to_remainder_of_output_buffer ;
    my $possible_phrase_name_with_hyphens ;
    my $pointer_to_close_angle_bracket ;
    my $string_of_spaces ;
    my $length_of_output_buffer ;
    my $maximum_cycle_count ;
    my $phrase_name ;
    my $cycle_count ;
    my $phrase_name_with_highest_cycle_count ;
    my $length_of_code_at_recursion_level_current ;
    my @code_at_recursion_level ;
    my @length_of_code_at_recursion_level ;
    my @pointer_to_remainder_of_code_at_recursion_level ;
    my %number_of_times_encountered_phrase_named ;


#-----------------------------------------------
#  Get the hyphenated phrase or supplied string.

    if ( scalar( @_ ) == 1 )
    {
        $supplied_text = $_[ 0 ] ;
    } else
    {
        $result_text = "" ;
        return $result_text ;
    }


#-----------------------------------------------
#  Initialization.

    $space_directive = "none" ;
    $result_text = "" ;
    $output_buffer = "" ;
    $pointer_to_remainder_of_output_buffer = 0 ;
    $new_output_buffer = "" ;
    $possible_phrase_name_with_underscores = "" ;
    $string_of_spaces = "                                                                                              " ;
    $expand_endless_loop_counter = 0 ;
    $expand_endless_loop_counter_maximum = 100000 ;
    %number_of_times_encountered_phrase_named = ( ) ;
    $expand_endless_cycle_count_maximum = 100000 ;
    @code_at_recursion_level = ( ) ;
    @length_of_code_at_recursion_level = ( ) ;
    @pointer_to_remainder_of_code_at_recursion_level = ( ) ;
    $code_at_recursion_level[ 0 ] = "unused" ;
    $pointer_to_remainder_of_code_at_recursion_level[ 0 ] = 0 ;
    $length_of_code_at_recursion_level[ 0 ] = 0 ;


#----------------------------------------------------
#  Begin a loop that handles each space-delimited string
#  in the phrase definition.

    $code_at_recursion_level[ 1 ] = $supplied_text ;
    $pointer_to_remainder_of_code_at_recursion_level[ 1 ] = 0 ;
    $length_of_code_at_recursion_level[ 1 ] = length( $code_at_recursion_level[ 1 ] ) ;
    $recursion_level = 1 ;
    while ( ( $recursion_level > 0 ) && ( $expand_endless_loop_counter <= $expand_endless_loop_counter_maximum ) )
    {
        $expand_endless_loop_counter ++ ;


#----------------------------------------------------
#  Get the next phrase name.
#  If there is no more code at the current recursion
#  level, shift back to the previous recursion level.
#  When the recursion_level reaches zero, the loop
#  will end.

#        print substr( $string_of_spaces , 0 , ( $recursion_level * 4 ) ) ;
#        print ".........." . "\n" ;
#        print substr( $string_of_spaces , 0 , ( $recursion_level * 4 ) ) ;
#        print "remainder: " . substr( $code_at_recursion_level[ $recursion_level ] , $pointer_to_remainder_of_code_at_recursion_level[ $recursion_level ] , 100 ) . " ...\n" ;
        $length_of_code_at_recursion_level_current = $length_of_code_at_recursion_level[ $recursion_level ] ;
        if ( $length_of_code_at_recursion_level_current == 0 )
        {
#            print substr( $string_of_spaces , 0 , ( $recursion_level * 4 ) ) ;
#            print "empty definition, nothing to append" . "\n" ;
            $recursion_level -- ;
            next ;
        }
        $pointer_to_phrase_begin = $pointer_to_remainder_of_code_at_recursion_level[ $recursion_level ] ;
        while ( ( $pointer_to_phrase_begin < $length_of_code_at_recursion_level_current ) && ( substr( $code_at_recursion_level[ $recursion_level ] , $pointer_to_phrase_begin , 1 ) eq " " ) )
        {
            $pointer_to_phrase_begin ++ ;
        }
        $pointer_to_next_space = index( $code_at_recursion_level[ $recursion_level ] , " " , $pointer_to_phrase_begin ) ;
        if ( $pointer_to_next_space == -1 )
        {
#            print substr( $string_of_spaces , 0 , ( $recursion_level * 4 ) ) ;
#            print "no more spaces in definition" . "\n" ;
            $pointer_to_phrase_end = $length_of_code_at_recursion_level_current - 1 ;
            $pointer_to_remainder_of_code_at_recursion_level[ $recursion_level ] = $length_of_code_at_recursion_level_current ;
        } else
        {
#            print substr( $string_of_spaces , 0 , ( $recursion_level * 4 ) ) ;
#            print "definition contains another space in middle of three characters: " . substr( $code_at_recursion_level[ $recursion_level ] , $pointer_to_next_space - 1 , 3 ) . "\n" ;
            $pointer_to_next_space = index( $code_at_recursion_level[ $recursion_level ] , " " , $pointer_to_phrase_begin ) ;
            if ( $pointer_to_next_space > $pointer_to_phrase_begin )
            {
                $pointer_to_phrase_end = $pointer_to_next_space - 1 ;
                $pointer_to_remainder_of_code_at_recursion_level[ $recursion_level ] = $pointer_to_next_space ;
            } else
            {
                $pointer_to_phrase_end = -2 ;
            }
        }
#        print substr( $string_of_spaces , 0 , ( $recursion_level * 4 ) ) ;
#        print "pointers to phrase begin and end: " . $pointer_to_phrase_begin . " " . $pointer_to_phrase_end . "\n" ;
        if ( $pointer_to_phrase_begin > $pointer_to_phrase_end )
        {
            $recursion_level -- ;
            next ;
        }
        $current_phrase = substr( $code_at_recursion_level[ $recursion_level ] , $pointer_to_phrase_begin , ( $pointer_to_phrase_end - $pointer_to_phrase_begin + 1 ) ) ;
#        print substr( $string_of_spaces , 0 , ( $recursion_level * 4 ) ) ;
#        print "current_phrase: " . $current_phrase . "\n" ;


#----------------------------------------------------
#  Check for an endless loop caused by the same
#  phrase name being encountered too many times.
#  If this occurs, exit the endless loop.

        $number_of_times_encountered_phrase_named{ $current_phrase } ++ ;
        if ( $number_of_times_encountered_phrase_named{ $current_phrase } >= $expand_endless_cycle_count_maximum )
        {
            if ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" )
            {
                $maximum_cycle_count = 0 ;
                foreach $phrase_name ( keys( %number_of_times_encountered_phrase_named ) )
                {
                    $cycle_count = $number_of_times_encountered_phrase_named{ $phrase_name } ;
                    if ( $cycle_count > $maximum_cycle_count )
                    {
                        $maximum_cycle_count = $cycle_count ;
                        $phrase_name = $phrase_name_with_highest_cycle_count ;
                    }
                }
                $global_trace_log .= "{{trace; in subroutine dashrep_internal_expand_phrases_faster_subset encountered phrase " . $phrase_name_with_highest_cycle_count . " " . $maximum_cycle_count . " number of times}}\n" ;
            }
#  remove-from-cpan-version-begin
            warn "Warning: The dashrep_internal_expand_phrases_faster_subset subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#           carp "Warning: The dashrep_internal_expand_phrases_faster_subset subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  uncomment-for-cpan-version-end
            return "" ;
        }


#----------------------------------------------------
#  If the phrase name is a hyphen directive, or a
#  space directive, or a line directive, handle it.

        if ( $current_phrase eq "hyphen-here" )
        {
            $output_buffer .= "-" ;
            $space_directive = "none" ;
            next ;
        }
        if ( $current_phrase eq "no-space" )
        {
            if ( $space_directive ne "one_requested" )
            {
               $space_directive = "none" ;
            }
            next ;
        }
        if ( $current_phrase eq "<no_space>" )
        {
            $space_directive = "none" ;
            next ;
        }
        if ( $current_phrase eq "one-space" )
        {
            $space_directive = "one_requested" ;
            next ;
        }
        if ( $current_phrase eq "<one_space>" )
        {
            $space_directive = "one_requested" ;
            next ;
        }
        if ( $current_phrase eq "new-line" )
        {
            $output_buffer .= "\n" ;
            $space_directive = "none" ;
            next ;
        }
        if ( $current_phrase eq "<new_line>" )
        {
            $output_buffer .= "\n" ;
            $space_directive = "none" ;
            next ;
        }
        if ( $current_phrase eq "empty-line" )
        {
            $output_buffer .= "\n\n" ;
            $space_directive = "none" ;
            next ;
        }
        if ( $current_phrase eq "<empty_line>" )
        {
            $output_buffer .= "\n\n" ;
            $space_directive = "none" ;
            next ;
        }


#----------------------------------------------------
#  If the phrase name has a definition (which can be
#  empty), and it is not a space directive or line
#  directive, insert phrase definition into the text
#  being expanded, and remove the phrase name.

        if ( ( $current_phrase =~ /[^ \-]\-[^ \-]/ ) && ( exists( $global_dashrep_replacement{ $current_phrase } ) ) )
        {
            $recursion_level ++ ;
#            print substr( $string_of_spaces , 0 , ( $recursion_level * 4 ) ) ;
#            print "inserting definition of phrase: " . $current_phrase . "\n" ;
            $code_at_recursion_level[ $recursion_level ] = $global_dashrep_replacement{ $current_phrase } ;
            $length_of_code_at_recursion_level[ $recursion_level ] = length( $code_at_recursion_level[ $recursion_level ] ) ;
            $pointer_to_remainder_of_code_at_recursion_level[ $recursion_level ] = 0 ;
            next ;
        }


#----------------------------------------------------
#  If a space should be inserted here, insert it.
#  Specify a default of inserting one space after
#  the next phrase insertion.

#        print "space_directive: " . $space_directive . "\n" ;
        if ( ( $space_directive eq "one" ) || ( $space_directive eq "one_requested" ) )
        {
            $output_buffer .= " " ;
        }
        $space_directive = "one" ;


#----------------------------------------------------
#  At this point the current text string is not the
#  name of a defined phrase, so just use the text string.

        $output_buffer .= $current_phrase ;
        $pointer_to_remainder_of_code_at_recursion_level[ $recursion_level ] = $pointer_to_phrase_end + 1 ;


#----------------------------------------------------
#  In the output buffer, if there is a
#  "<specify " string that needs to be
#  combined with the preceding tag, combine it into
#  a single XML or HTML tag.
#  Handle tags of type "<xyz />" as well as "<xyz>".

        if ( index( $output_buffer , "<specify " ) > 0 )
        {
            $prior_length = 0 ;
            while ( length( $output_buffer ) != $prior_length )
            {
                $prior_length = length( $output_buffer ) ;
                $output_buffer =~ s/ *\/> *<specify +([^>]+)>/ $1 \/>/ ;
            }
            if ( index( $output_buffer , "<specify " ) > 0 )
            {
                $prior_length = 0 ;
                while ( length( $output_buffer ) != $prior_length )
                {
                    $prior_length = length( $output_buffer ) ;
                    $output_buffer =~ s/ *> *<specify +/ / ;
                }
            }
        }


#----------------------------------------------------
#  If the output buffer contains a recognized phrase
#  name using underscores instead of hyphens, and it
#  is enclosed in angle brackets (with no spaces),
#  then replace that text with the definition of the
#  specified phrase.

#        print "--------------" . "\n" ;
#        print "output_buffer: " . $output_buffer . "\n" ;
#        $output_buffer =~ s/ *<no_space> *//sg ;
        $output_buffer =~ s/ *<hyphen_here> */-/sg ;
        $output_buffer =~ s/ *<new_line> */\n/sg ;
        $output_buffer =~ s/ *<empty_line> */\n/sg ;
        if ( $output_buffer =~ /<((no_space)|(hyphen_here)|(new_line))> *$/ )
        {
            $space_directive = "none" ;
        }
#        print "output_buffer: " . $output_buffer . "\n" ;
        $length_of_output_buffer = -1 ;
        $pointer_to_remainder_of_output_buffer = 0 ;
        $new_output_buffer = "" ;
        while ( substr( $output_buffer , $pointer_to_remainder_of_output_buffer ) =~ /^(.*?)<([^ \->]+_[^ \->]+)>/s )
        {
            $prefix = $1 ;
            $possible_phrase_name_with_underscores = $2 ;
            $length_of_output_buffer = length( $output_buffer ) ;
            $new_output_buffer .= $prefix ;
            $length_of_tag = length( $possible_phrase_name_with_underscores ) ;
            $pointer_to_remainder_of_output_buffer += length( $prefix ) + $length_of_tag + 2 ;

#            print "............. " . "\n" ;
#            print "current_phrase: " . $current_phrase . "\n" ;
#            print "output_buffer: " . $output_buffer . "\n" ;
#            print "remainder of output_buffer: " . substr( $output_buffer , $pointer_to_remainder_of_output_buffer ) . "\n" ;
#            print "possible_phrase_name_with_underscores: " . $possible_phrase_name_with_underscores . "\n" ;
#            print "remainder of output buffer: " . substr( $output_buffer , $pointer_to_remainder_of_output_buffer ) . "\n" ;

            $possible_phrase_name_with_hyphens = $possible_phrase_name_with_underscores ;
            $possible_phrase_name_with_hyphens =~ s/_/-/g ;
            if ( exists( $global_dashrep_replacement{ $possible_phrase_name_with_hyphens } ) )
            {
                $new_output_buffer .= $global_dashrep_replacement{ $possible_phrase_name_with_hyphens } ;
            } else
            {
                $new_output_buffer .= "<" . $possible_phrase_name_with_underscores . ">" ;
            }

#            print "new_output_buffer: " . $new_output_buffer . "\n" ;

        }
        if ( $length_of_output_buffer != -1 )
        {
            $output_buffer = $new_output_buffer . substr( $output_buffer , $pointer_to_remainder_of_output_buffer ) ;

#            print "output_buffer: " . $output_buffer . "\n" ;

            $new_output_buffer = "" ;
            $possible_phrase_name_with_underscores = "" ;
        }


#----------------------------------------------------
#  If the output buffer does not contain any text
#  that might need to be revised, then append it to
#  the result text.

        $pointer_to_close_angle_bracket = index( $output_buffer , ">" ) ;
        if ( $pointer_to_close_angle_bracket < 0 )
        {
            $result_text .= $output_buffer ;
            $output_buffer = "" ;
        } elsif ( length( $output_buffer ) > 1000 )
        {
            $result_text .= substr( $output_buffer , 0 , 500 ) ;
            $output_buffer = substr( $output_buffer , 500 ) ;
        }
#        print "==============" . "\n" ;


#----------------------------------------------------
#  Repeat the loop that handles each space-delimited
#  string.

    }


#----------------------------------------------------
#  Supply the results.

    $result_text .= $output_buffer ;
    return $result_text ;


#-----------------------------------------------
#  End of subroutine.

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

    my $item_name ;
    my $highest_usage_counter ;
    my $highest_usage_item_name ;
    my $replacement_count ;
    my $endless_loop_replacements_with_count ;
    my $list_of_phrases ;
    my $endless_loop_debug_info_filename ;
    my $phrase_name ;
    my $counter ;

    $highest_usage_counter = - 1 ;
    foreach $item_name ( keys( %global_replacement_count_for_item_name ) )
    {
        $replacement_count = $global_replacement_count_for_item_name{ $item_name } ;
        if ( $replacement_count > $highest_usage_counter )
        {
            $highest_usage_counter = $replacement_count ;
            $highest_usage_item_name = $item_name ;
        }
        if ( $replacement_count > 100 )
        {
            $endless_loop_replacements_with_count{ sprintf( "%08d" , $replacement_count ) } .= $item_name . "\n" ;
        }
    }

    if ( $highest_usage_item_name =~ / / )
    {
        @list_of_phrases = &dashrep_get_list_of_phrases( ) ;
        $endless_loop_debug_info_filename = "output_endless_loop_debug_info.txt" ;
        if ( open ( OUTFILE , '>' . $endless_loop_debug_info_filename ) )
        {
            print OUTFILE "Too many cycles of replacement (" . $global_endless_loop_counter . ").\n" . "Hyphenated phrase with highest replacement count (" . $highest_usage_counter . ") is:\n" . "    " . $highest_usage_item_name . "\n\n" ;
            foreach $replacement_count ( reverse( sort( keys( %endless_loop_replacements_with_count ) ) ) )
            {
                print OUTFILE "Had " . $replacement_count . " replacements:" . "\n" . $endless_loop_replacements_with_count{ $replacement_count } . "\n\n" ;
            }
            print OUTFILE "All definitions:\n\n" ;
            foreach $phrase_name ( @list_of_phrases )
            {
                if ( ( defined( $phrase_name ) ) && ( $phrase_name =~ /^[^ ]+$/ ) && ( exists( $global_dashrep_replacement{ $phrase_name } ) ) && ( defined( $global_dashrep_replacement{ $phrase_name } ) ) )
                {
                    print OUTFILE $phrase_name . ":\n" . $global_dashrep_replacement{ $phrase_name } . "\n----\n\n" ;
                    $counter ++ ;
                }
            }
            close( OUTFILE ) ;
            print "Endless loop debug info written to file " . $endless_loop_debug_info_filename . "\n" ;
            chmod( $global_file_write_protection_mode , $endless_loop_debug_info_filename ) ;
        }
    }

#  remove-from-cpan-version-begin
    warn "Too many cycles of replacement (" . $global_endless_loop_counter . ").\n" . "Hyphenated phrase with highest replacement count (" . $highest_usage_counter . ") is:\n" . "    " . $highest_usage_item_name . "\n" ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#    carp "Too many cycles of replacement (" . $global_endless_loop_counter . ").\n" . "Hyphenated phrase with highest replacement count (" . $highest_usage_counter . ") is:\n" . "    " . $highest_usage_item_name . "\n" ;
#  uncomment-for-cpan-version-end


#-----------------------------------------------
#  End of subroutine.

    return 1 ;

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

Copyright 2009 through 2015 Richard Fobes at www.Dashrep.org, all rights reserved.

You can redistribute and/or modify this library module
under the Perl Artistic License 2.0, a copy
of which is included in the LICENSE file.

Conversions of this code into other languages are also
covered by the above license terms.

The Dashrep (TM) name is trademarked by Richard Fobes at
www.Dashrep.org to prevent the name from being co-opted.

The Dashrep (TM) language is in the public domain.

=cut

1; # End of package
