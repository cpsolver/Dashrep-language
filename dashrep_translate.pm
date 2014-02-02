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

Version 3.00

=cut

#  uncomment-for-cpan-version-begin
# our $VERSION = '3.00';


#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
=head1 SYNOPSIS

The following sample code executes the Dashrep-language actions specified in the standard input file.

    use dashrep_translate;
    &dashrep_translate::dashrep_linewise_translate( );

The following sample code implements the Dashrep web framework, which allows an interactive portion of a website to be written in the Dashrep language.  (The "cgi_to_dashrep_replacements" module is available on GitHub in the CPSolver account.)

    use dashrep_translate;
    use cgi_to_dashrep_replacements;
    $web_page = &dashrep_translate::dashrep_web_framework ;
    print $web_page ;

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

Although Dashrep code is not directly executable, it can generate executable code.  Although it does not directly define loops, it generates lists in which any delimited (using commas and/or spaces) list of text strings (including integers) specifies the unique values for the list items.  Although the Dashrep language does not directly implement a branching structure, the translated code can be completely changed at any level (including within lists) based on parameterized hyphenated phrases such as B<[-template-for-move-proposal-link-for-action-[-output-requested-action-]-]>.

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

=head2 dashrep_web_framework

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
#     dashrep_web_framework
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
my $global_nesting_level_of_file_actions ;
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
my $file_write_protection_mode ;
my $global_dashrep_text_list_of_phrase_names ;
my %global_dashrep_replacement ;
my %global_replacement_count_for_item_name ;
my %global_exists_xml_hyphenated_phrase ;
my @global_list_of_lists_to_generate ;
my @global_xml_tag_at_level_number ;


#-----------------------------------------------
#  Define package constants, and initialize
#  special phrases.

BEGIN {
    $global_true = 1 ;
    $global_false = 0 ;
    $global_endless_loop_counter = 0 ;
    $global_endless_loop_counter_limit = 70000 ;
    $global_xml_accumulated_sequence_of_tag_names = "" ;
    $global_spaces = "                                                                              " ;
    $global_nesting_level_of_file_actions = 0 ;
    $global_ignore_level = 0 ;
    $global_capture_level = 0 ;
    $global_xml_level_number = 0 ;
    $global_trace_log = "" ;
    $global_unique_value = 0 ;
    $global_storage_number = 1 ;
    $file_write_protection_mode = 0600 ;  # octal number that specifies no "world" read access
    %global_replacement_count_for_item_name = ( ) ;
    @global_list_of_lists_to_generate = ( ) ;
    @global_xml_tag_at_level_number = ( ) ;

    %global_dashrep_replacement = ( ) ;

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
    $global_dashrep_replacement{ "dashrep-permission-to-delete-or-overwrite-files-yes-or-no" } = "yes" ;
    $global_dashrep_replacement{ "dashrep-permission-to-append-to-files-yes-or-no" } = "yes" ;
    $global_dashrep_replacement{ "dashrep-comments-ignored" } = "" ;
    $global_dashrep_replacement{ "dashrep-endless-loop-counter-limit" } = "" ;
    $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } = "yes" ;
    $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-ignore-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-ignore-level" } = "" ;
    $global_dashrep_replacement{ "dashrep-capture-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-capture-level" } = "" ;
    $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-xml-level-reset-if-zero" } = "" ;
    $global_dashrep_replacement{ "dashrep-first-xml-tag-name" } = "" ;
    $global_dashrep_replacement{ "dashrep-xml-yes-handle-open-close-tag-" } = "" ;
    $global_dashrep_replacement{ "dashrep-xml-yes-handle-open-close-tag-" } = "" ;
    $global_dashrep_replacement{ "dashrep-yes-or-no-export-delimited-definitions" } = "" ;
    $global_dashrep_replacement{ "dashrep-special-replacement-hyphen" } = "[hyphen]" ;
    $global_dashrep_replacement{ "dashrep-special-replacement-adjacent-space" } = "[adjacentspace]" ;
    $global_dashrep_replacement{ "dashrep-special-replacement-newline" } = "[newline]" ;
    $global_dashrep_replacement{ "dashrep-stop-translation" } = "" ;
    $global_dashrep_replacement{ "dashrep-translation-before-escape" } = "" ;
    $global_dashrep_replacement{ "dashrep-html-replacement-open-angle-bracket" } = "&lt;" ;
    $global_dashrep_replacement{ "dashrep-html-replacement-close-angle-bracket" } = "&gt;" ;
    $global_dashrep_replacement{ "dashrep-html-replacement-quotation-mark" } = '"' ;
    $global_dashrep_replacement{ "dashrep-html-replacement-apostrophe" } = "'" ;
    $global_dashrep_replacement{ "dashrep-html-replacement-ampersand" } = "&" ;
    $global_dashrep_replacement{ "non-breaking-space" } = "&nbsp;" ;
    $global_dashrep_replacement{ "list-of-phrases-newly-defined" } = "" ;
    $global_dashrep_replacement{ "dashrep-undefined" } = "dashrep_undefined" ;
    $global_dashrep_replacement{ "dashrep-gather-tag-begin" } = "entry_begin" ;
    $global_dashrep_replacement{ "dashrep-gather-tag-end" } = "entry_end" ;
    $global_dashrep_replacement{ "dashrep-gather-tag-unique" } = "url" ;
    $global_dashrep_replacement{ "dashrep-omit-web-page-from-trace-log-yes-or-no" } = "no" ;

    $global_dashrep_text_list_of_phrase_names = "category_hyphens_spaces_lines hyphen-here character-hyphen four-hyphens no-space empty-text one-space character-space non-breaking-space span-non-breaking-spaces-begin span-non-breaking-spaces-end new-line empty-line line-break character-newline character-open-square-bracket character-close-square-bracket character-tab category_definitions list-of-phrases-newly-defined dashrep-definitions-begin dashrep-definitions-end dashrep-definition-append-next define-end define-begin clear-phrase clear-phrases-listed-in-phrase clear-all-dashrep-phrases expand-phrase-to-phrase calculate-if-phrase-empty calculate-if-empty-then-use-here dashrep-yes-append-not-replace-for-imported-phrases dashrep-yes-or-no-export-delimited-definitions export-defs-all-begin export-defs-all-end export-defs-def-begin export-defs-def-end export-defs-phrase-begin export-defs-phrase-end copy-from-phrase-to-phrase append-from-phrase-to-phrase append-from-phrase-to-phrase-no-space prepend-from-phrase-to-phrase prepend-from-phrase-to-phrase-no-space append-new-line-to-phrase category_decision yes-or-no-empty-phrase yes-or-no-same-two-phrase-definitions yes-if-not-no no-if-any-no no-if-not-yes yes-if-any-yes yes-or-no-opposite if-word-is-yes-then-first-else-second if-word-is-no-then-first-else-second if-first-word-is-yes-then-keep-remainder-else-empty if-first-word-is-no-then-keep-remainder-else-empty category_numeric zero-one-multiple zero-or-nonzero numeric-add numeric-minus numeric-multiply numeric-divide-by numeric-maximum numeric-minimum numeric-integer numeric-absolute numeric-equal-greater-less-compare numeric-odd-or-even numeric-sine numeric-cosine numeric-logarithm-base-e numeric-logarithm-base-10 numeric-pi numeric-map-tile-zoom numeric-y-map-tile-number-based-on-latitude numeric-two-dimensional-sort-into-columns-and-rows numeric-increment numeric-decrement category_character count-of-characters-in-phrase-definition characters-in-phrase-get-from-position-to-position position-of-string-in-phrase-within-phrase copy-from-phrase-to-phrase-and-remove-extra-spaces copy-from-phrase-to-phrase-and-replace-string-in-phrase-with-phrase copy-from-phrase-to-phrase-and-split-into-list-of-characters copy-from-phrase-to-phrase-and-replace-html-reserved-characters copy-from-phrase-to-phrase-and-replace-digits-with-9s copy-from-phrase-to-phrase-lowercase-only copy-from-phrase-to-phrase-uppercase-only copy-from-phrase-to-phrase-initial-caps copy-from-phrase-to-phrase-and-encode-as-cgi-parameter copy-from-phrase-to-phrase-and-decode-from-cgi-parameter category_word yes-or-no-same-two-words first-word-in-phrase last-word-in-phrase from-phrase-get-word-number copy-from-phrase-to-phrase-words-from-position-to-position count-of-words-in-phrase position-of-word-in-phrase yes-or-no-word-is-in-phrase position-of-word-in-phrase-within-phrase append-word-to-phrase copy-from-two-phrases-words-found-in-both-to-phrase copy-from-first-phrase-words-not-found-in-second-phrase-to-phrase copy-from-phrase-unique-words-to-phrase copy-from-phrase-to-phrase-and-numeric-sort-by-word copy-from-phrase-to-phrase-and-alphabetic-sort-by-word copy-words-from-phrase-to-phrase-using-numeric-sort-order-specified-in-phrase copy-from-phrase-to-phrase-only-word-at-position copy-from-phrase-to-phrase-but-remove-first-word copy-from-phrase-to-phrase-but-remove-last-word copy-from-phrase-to-phrase-with-word-order-reversed use-template-with-each-word-in-phrase word-to-use-in-template category_generate_list use-template-and-parameters-to-create-simple-list-with-name use-template-and-parameters-to-create-full-list-with-name counts-from-integer-to-integer-put-into-phrase create-list-of-phrase-names-that-begin-with-text-in-phrase-and-put-into-phrase every-pairwise-combination-of-words-from-two-phrases-put-into-two-phrases every-ordered-pairwise-combination-of-words-from-two-phrases-put-into-two-phrases createlist-first-yes-or-no createlist-item-next createlist-item-number createlist-last-yes-or-no createlist-parameter createlist-total-number-of-items dashrep-warning-parameter-for-list-generation-contains-invalid-characters category_file_related dashrep-permission-to-append-to-files-yes-or-no dashrep-permission-to-delete-or-overwrite-files-yes-or-no dashrep-path-prefix-for-file-reading dashrep-path-prefix-for-file-writing get-definitions-from-file dashrep-phrase-prefix-for-imported-phrases dashrep-phrase-suffix-for-imported-phrases write-all-dashrep-definitions-to-file write-all-dashrep-phrase-names-to-file write-dashrep-definitions-listed-in-phrase-to-file copy-from-file-to-phrase copy-from-phrase-append-to-file expand-phrase-to-file copy-from-file-to-phrases-line-numbered find-line-in-file-that-begins-with-string-in-phrase-and-put-into-phrase find-lines-in-file-that-begin-with-any-word-in-phrase-and-append-storage-phrase-names-to-phrase find-lines-in-file-that-begin-with-any-two-words-in-phrase-and-append-storage-phrase-names-to-phrase copy-from-columns-in-file-to-named-phrases dashrep-use-two-spaces-as-column-delimiter gather-tagged-info-from-file-and-put-unique-values-into-phrase dashrep-gather-tag-begin dashrep-gather-tag-end dashrep-gather-tag-unique put-into-phrase-list-of-files-in-current-read-directory put-into-phrase-list-of-folders-in-current-read-directory yes-or-no-file-exists yes-or-no-folder-in-phrase-exists size-of-file modification-time-of-file create-empty-file delete-file create-empty-sub-folder linewise-translate-from-file-to-file linewise-translate-parameters-only-from-file-to-file linewise-translate-phrases-only-from-file-to-file linewise-translate-special-phrases-only-from-file-to-file linewise-read-from-file-and-use-template storage-input-line-from-file input-line-count category_xml xml-move-attributes-into-tag-elements-within-phrase linewise-translate-xml-tags-in-file-to-dashrep-phrases-in-file dashrep-first-xml-tag-name dashrep-list-of-xml-phrases dashrep-xml-level-reset-if-zero dashrep-xml-trace-on-yes-or-no dashrep-xml-yes-ignore-if-no-tag-replacement category_html dashrep-html-replacement-ampersand dashrep-html-replacement-apostrophe dashrep-html-replacement-close-angle-bracket dashrep-html-replacement-open-angle-bracket dashrep-html-replacement-quotation-mark insert-angle-bracketed-definitions-into-already-expanded-phrase category_web_framework web-framework-in-use generated-web-page do-before-generating-web-page do-after-generating-web-page web-framework-generated-web-page path-to-initial-dashrep-definitions filename-for-initial-dashrep-definitions category_ignore_capture ignore-begin-here ignore-end-here capture-begin-here capture-end-here captured-text dashrep-ignore-actions-on-yes-or-no dashrep-capture-actions-on-yes-or-no dashrep-capture-level dashrep-ignore-level category_time get-current-time-in-epoch-seconds split-epoch-seconds-into-named-components time-day-of-month time-day-of-week time-day-of-year time-hour time-minute time-month-number time-second time-year category_debug dashrep-comments-ignored dashrep-warning-trace-on-yes-or-no dashrep-capture-trace-on-yes-or-no dashrep-debug-trace-log dashrep-debug-trace-on-yes-or-no dashrep-action-trace-on-yes-or-no dashrep-ignore-trace-on-yes-or-no dashrep-linewise-trace-on-yes-or-no dashrep-web-framework-trace-on-yes-or-no dashrep-trace-show-definition category_advanced dashrep-stop-translation dashrep-endless-loop-counter-limit unique-value escape-if-yes escape-if-no dashrep-translation-before-escape escape-text dashrep-special-replacement-adjacent-space dashrep-special-replacement-hyphen dashrep-special-replacement-newline dashrep-yes-indicate-line-endings end-of-line-here clear-all-expanded-text-up-to-here dashrep-yes-do-not-expand-special-phrases dashrep-list-of-recognized-phrase-names dashrep-undefined insert-codeview-tags-into-phrase yes-or-no-allow-user-defined-actions user-defined-action-operand-one user-defined-action-operand-two user-defined-action-operand-three user-defined-action-operand-four category_spoken_words copy-from-phrase-to-phrase-from-spoken-dashrep-code copy-from-phrase-to-phrase-into-spoken-dashrep-code dashbee dashenn dashnex ambee amenn combee comenn fen conambee amenncon linbray category_do_not_use dashrep-list-info-temporary-storage dashrep-list-info-temporary-storage-separator" ;
    $global_dashrep_replacement{ "dashrep-list-of-recognized-phrase-names" } = $global_dashrep_text_list_of_phrase_names ;

}


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
    $global_dashrep_replacement{ "dashrep-permission-to-delete-or-overwrite-files-yes-or-no" } = "yes" ;
    $global_dashrep_replacement{ "dashrep-permission-to-append-to-files-yes-or-no" } = "yes" ;
    $global_dashrep_replacement{ "dashrep-comments-ignored" } = "" ;
    $global_dashrep_replacement{ "dashrep-endless-loop-counter-limit" } = "" ;
    $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } = "yes" ;
    $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-ignore-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-ignore-level" } = "" ;
    $global_dashrep_replacement{ "dashrep-capture-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-capture-level" } = "" ;
    $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } = "" ;
    $global_dashrep_replacement{ "dashrep-xml-level-reset-if-zero" } = "" ;
    $global_dashrep_replacement{ "dashrep-first-xml-tag-name" } = "" ;
    $global_dashrep_replacement{ "dashrep-xml-yes-handle-open-close-tag-" } = "" ;
    $global_dashrep_replacement{ "dashrep-xml-yes-handle-open-close-tag-" } = "" ;
    $global_dashrep_replacement{ "dashrep-yes-or-no-export-delimited-definitions" } = "" ;
    $global_dashrep_replacement{ "dashrep-special-replacement-hyphen" } = "[hyphen]" ;
    $global_dashrep_replacement{ "dashrep-special-replacement-adjacent-space" } = "[adjacentspace]" ;
    $global_dashrep_replacement{ "dashrep-special-replacement-newline" } = "[newline]" ;
    $global_dashrep_replacement{ "dashrep-stop-translation" } = "" ;
    $global_dashrep_replacement{ "dashrep-translation-before-escape" } = "" ;
    $global_dashrep_replacement{ "dashrep-html-replacement-open-angle-bracket" } = "&lt;" ;
    $global_dashrep_replacement{ "dashrep-html-replacement-close-angle-bracket" } = "&gt;" ;
    $global_dashrep_replacement{ "dashrep-html-replacement-quotation-mark" } = '"' ;
    $global_dashrep_replacement{ "dashrep-html-replacement-apostrophe" } = "'" ;
    $global_dashrep_replacement{ "dashrep-html-replacement-ampersand" } = "&" ;
    $global_dashrep_replacement{ "non-breaking-space" } = "&nbsp;" ;
    $global_dashrep_replacement{ "list-of-phrases-newly-defined" } = "" ;
    $global_dashrep_replacement{ "dashrep-undefined" } = "dashrep_undefined" ;
    $global_dashrep_replacement{ "dashrep-gather-tag-begin" } = "entry_begin" ;
    $global_dashrep_replacement{ "dashrep-gather-tag-end" } = "entry_end" ;
    $global_dashrep_replacement{ "dashrep-gather-tag-unique" } = "url" ;
    $global_dashrep_replacement{ "dashrep-list-of-recognized-phrase-names" } = $global_dashrep_text_list_of_phrase_names ;
    $global_dashrep_replacement{ "dashrep-omit-web-page-from-trace-log-yes-or-no" } = "no" ;
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
        if ( ( exists( $global_dashrep_replacement{ "web-framework-in-use" } ) ) && ( $global_dashrep_replacement{ "web-framework-in-use" } eq "yes" ) )
        {
            $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "Warning: Call to dashrep_define subroutine does not have exactly two parameters." ;
        } else
        {
#  remove-from-cpan-version-begin
            warn "Warning: Call to dashrep_define subroutine does not have exactly two parameters." ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#            carp "Warning: Call to dashrep_define subroutine does not have exactly two parameters." ;
#  uncomment-for-cpan-version-end
        }
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
    my @list_of_replacement_strings ;


#-----------------------------------------------
#  Get the text that contains replacement
#  definitions.

    if ( scalar( @_ ) == 1 )
    {
        $replacements_text_to_import = $_[ 0 ] ;
    } else
    {
        if ( ( exists( $global_dashrep_replacement{ "web-framework-in-use" } ) ) && ( $global_dashrep_replacement{ "web-framework-in-use" } eq "yes" ) )
        {
            $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "Warning: Call to dashrep_import_replacements subroutine does not have exactly one parameter." ;
        } else
        {
#  remove-from-cpan-version-begin
            warn "Warning: Call to dashrep_import_replacements subroutine does not have exactly one parameter." ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#            carp "Warning: Call to dashrep_import_replacements subroutine does not have exactly one parameter." ;
#  uncomment-for-cpan-version-end
        }
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
#  Reset the "ignore" and "capture" levels.

    $global_ignore_level = 0 ;
    $global_capture_level = 0 ;


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
    if ( ( exists( $global_dashrep_replacement{ "dashrep-yes-append-not-replace-for-imported-phrases" } ) ) && ( $global_dashrep_replacement{ "dashrep-yes-append-not-replace-for-imported-phrases" } eq "yes" ) )
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
#  "dashrep-yes-append-not-replace-for-imported-phrases"
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
                $global_dashrep_replacement{ $definition_name } = "ERROR: Replacement for the hyphenated phrase:\n    " . $definition_name . "\n" . "includes itself, which would cause an endless replacement loop." . "\n" ;
                if ( ( exists( $global_dashrep_replacement{ "web-framework-in-use" } ) ) && ( $global_dashrep_replacement{ "web-framework-in-use" } eq "yes" ) )
                {
                    $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "Warning: Replacement for the hyphenated phrase:\n    " . $definition_name . "\n" . "includes itself, which would cause an endless replacement loop.". "\n" . "Error occurred " ;
                } else
                {
#  remove-from-cpan-version-begin
                    warn "Warning: Replacement for the hyphenated phrase:\n    " . $definition_name . "\n" . "includes itself, which would cause an endless replacement loop.". "\n" . "Error occurred " ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#                    carp "Warning: Replacement for the hyphenated phrase:\n    " . $definition_name . "\n" . "includes itself, which would cause an endless replacement loop.". "\n" . "Error occurred " ;
#  uncomment-for-cpan-version-end
                }
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
        if ( ( exists( $global_dashrep_replacement{ "web-framework-in-use" } ) ) && ( $global_dashrep_replacement{ "web-framework-in-use" } eq "yes" ) )
        {
            $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "Warning: Call to dashrep_get_list_of_phrases subroutine does not have exactly zero parameters." ;
        } else
        {
#  remove-from-cpan-version-begin
            warn "Warning: Call to dashrep_get_list_of_phrases subroutine does not have exactly zero parameters." ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#            carp "Warning: Call to dashrep_get_list_of_phrases subroutine does not have exactly zero parameters." ;
#  uncomment-for-cpan-version-end
        }
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
        if ( ( exists( $global_dashrep_replacement{ "web-framework-in-use" } ) ) && ( $global_dashrep_replacement{ "web-framework-in-use" } eq "yes" ) )
        {
            $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "Warning: Call to dashrep_delete subroutine does not have exactly one parameter." ;
        } else
        {
#  remove-from-cpan-version-begin
            warn "Warning: Call to dashrep_delete subroutine does not have exactly one parameter." ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#            carp "Warning: Call to dashrep_delete subroutine does not have exactly one parameter." ;
#  uncomment-for-cpan-version-end
        }
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
        if ( ( exists( $global_dashrep_replacement{ "web-framework-in-use" } ) ) && ( $global_dashrep_replacement{ "web-framework-in-use" } eq "yes" ) )
        {
            $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "Warning: Call to dashrep_delete_all subroutine does not have exactly one parameter." ;
        } else
        {
#  remove-from-cpan-version-begin
            warn "Warning: Call to dashrep_delete_all subroutine does not have exactly zero parameters." ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#            carp "Warning: Call to dashrep_delete_all subroutine does not have exactly zero parameters." ;
#  uncomment-for-cpan-version-end
        }
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

    my $supplied_text ;
    my $replacement_text ;
    my $loop_status_done ;
    my $text_begin ;
    my $text_parameter_name ;
    my $text_parameter_value ;
    my $text_end ;
    my $action_name ;
    my $object_of_action ;
    my $count ;
    my $zero_one_multiple ;
    my $yes_or_no ;
    my $text_parameter ;
    my $text_for_value ;
    my $possible_new_limit ;
    my $text_parameter_content ;
    my $operand_one ;
    my $operand_two ;
    my $source_phrase_name ;
    my $target_phrase_name ;
    my $epoch_seconds ;
    my $first_object_of_action ;
    my $second_object_of_action ;
    my $temp_text ;
    my $phrase_length ;
    my $open_angle_bracket_replacement ;
    my $close_angle_bracket_replacement ;
    my $quotation_mark_replacement ;
    my $apostrophe_replacement ;
    my $ampersand_replacement ;
    my $counter ;
    my $value ;
    my $text_returned ;
    my $second_time ;
    my $minute ;
    my $hour ;
    my $day_of_month ;
    my $month_number ;
    my $year ;
    my $weekday ;
    my $day_of_year ;
    my $extra_info ;
    my $operand_three ;
    my $operand_four ;
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
    my $not_listed_word ;
    my $result_word_list ;
    my $string_in_phrase ;
    my $copied_characters ;
    my $template_phrase_name ;
    my $parameter_word_list ;
    my $generated_list_name ;
    my $text_that_expands_to_generate_list ;
    my $list_of_parameters ;
    my $list_position ;
    my $parameter ;
    my $item_number ;
    my $item_name ;
    my $phrase_words ;
    my $list_of_phrases ;
    my $sequence_of_phrases ;
    my $number_of_operands ;
    my $list_of_operands ;
    my $text_string ;
    my $source_text ;
    my $word_position ;
    my $list_of_words ;
    my $text_inserted ;
    my $list_of_phrase_names ;
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
    my $unique_value_as_text ;
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
    my $down_direction_minimum_value ;
    my $down_direction_maximum_value ;
    my $right_direction_minimum_value ;
    my $right_direction_maximum_value ;
    my $range_of_down_direction_values ;
    my $range_of_right_direction_values ;
    my $top_row_number ;
    my $bottom_row_number ;
    my $fill_direction_top_left ;
    my $fill_direction_bottom_right ;
    my $fill_direction_bottom_left ;
    my $fill_direction_top_right ;
    my $need_maximum ;
    my $need_minimum ;
    my $value_direction_right_and_down ;
    my $value_direction_left_and_down ;
    my $value_direction_down ;
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
    my $multiplier_for_down_direction_values ;
    my $multiplier_for_right_direction_values ;
    my $text_for_down_direction_values ;
    my $text_for_right_direction_values ;
    my $character_to_capitalize ;
    my @words_at_numeric_value ;
    my @list ;
    my @list_of_sorted_numbers ;
    my @list_of_replacements_to_auto_increment ;
    my @list_of_action_names ;
    my @zero_if_not_remaining_item_number ;
    my @right_and_down_direction_value_for_item_number ;
    my @left_and_down_direction_value_for_item_number ;
    my @column_position_for_item_number ;
    my @row_position_for_item_number ;
    my @list_of_remaining_item_numbers ;
    my @down_direction_value_for_item_number ;
    my @right_direction_value_for_item_number ;
    my %item_number_at_row_column ;


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
    $replacement_text =~ s/[\r\n\t]/ /sg ;
    $replacement_text =~ s/^ +//sg;
    $replacement_text =~ s/ +$//sg;


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
#  Initialize the list of replacement names
#  encountered that need to be auto-incremented.

    @list_of_replacements_to_auto_increment = ( ) ;


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
            if ( ( exists( $global_dashrep_replacement{ "web-framework-in-use" } ) ) && ( $global_dashrep_replacement{ "web-framework-in-use" } eq "yes" ) )
            {
                $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "Warning: The dashrep_expand_parameters subroutine has encountered an endless loop." . "\n" . "Stopped" ;
            } else
            {
#  remove-from-cpan-version-begin
                warn "Warning: The dashrep_expand_parameters subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#                carp "Warning: The dashrep_expand_parameters subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  uncomment-for-cpan-version-end
            }
            return 0 ;
        }


#-----------------------------------------------
#  Get the next inner-most parameter syntax --
#  with "[-" at the beginning and "-]" at the end.
#  (It must not contain a nested parameter syntax.)
#  If it contains any line breaks, replace those
#  with spaces.  If there are no more parameters,
#  exit the loop.

        if ( $replacement_text =~ /^(.*?)\[\-([^\[\]]*)\-\](.*)$/ )
        {
            $text_begin = $1 ;
            $text_parameter_content = $2 ;
            $text_end = $3 ;
            $text_parameter_content =~ s/^ +// ;
            $text_parameter_content =~ s/ +$// ;
            $text_parameter_content =~ s/[\r\n\t]/ /sg ;
            $loop_status_done = $global_false ;
            if ( ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" ) && ( $text_parameter_content =~ /[^ ]/ ) )
            {
                $global_trace_log .= "{{trace; innermost parameter: " . $text_parameter_content . "}}\n";
            }
        } else
        {
            last ;
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

        if ( ( $text_parameter_content !~ / / ) && ( exists( $global_dashrep_replacement{ $text_parameter_content } ) ) )
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
#  Get the action name and the operands.  If there
#  are no non-space characters, remove the
#  parameter brackets and restart the main loop.

        $action_name = "" ;
        $object_of_action = "" ;
        $operand_one = "" ;
        $operand_two = "" ;
        $operand_three = "" ;
        $operand_four = "" ;
        $number_of_operands = 0 ;
        if ( $text_parameter_content =~ /^([^ ]+)(.*)$/ )
        {
            $action_name = $1 ;
            $object_of_action = $2 ;
            $action_name =~ s/^ +// ;
            $action_name =~ s/ +$// ;
            $action_name =~ s/^\-+// ;
            $action_name =~ s/\-+$// ;
            $object_of_action =~ s/^ +// ;
            $object_of_action =~ s/ +$// ;
            $object_of_action =~ s/\-+$// ;
            @list_of_operands = split( / +/ , $object_of_action ) ;
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
        } else
        {
            $replacement_text = $text_begin . " " . $text_parameter_content . " " . $text_end ;
            next ;
        }
        if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
        {
            $global_trace_log .= "{{trace; action " . $action_name . " has " . $number_of_operands . " operands: " . $object_of_action . "}}\n";
        }
        $global_replacement_count_for_item_name{ "action " . $action_name } ++ ;
        $global_replacement_count_for_item_name{ "text parameter content " . $text_parameter_content } ++ ;
        $global_replacement_count_for_item_name{ "expand parameters subroutine" } -- ;


#-----------------------------------------------
#  Handle the action:
#  clear-phrase

        if ( $action_name eq "clear-phrase" )
        {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            $phrase_name = $operand_one ;
            $global_dashrep_replacement{ $phrase_name } = "" ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; cleared phrase " . $phrase_name . "}}\n" ;
            }
            $replacement_text = $text_begin . " " . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  clear-phrases-listed-in-phrase

        if ( $action_name eq "clear-phrases-listed-in-phrase" )
        {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            $phrase_name = $operand_one ;
            @list_of_phrase_names = split( / + / , $global_dashrep_replacement{ $phrase_name } ) ;
            foreach $phrase_name_to_clear ( @list_of_phrase_names )
            {
                if ( exists( $global_dashrep_replacement{ $phrase_name_to_clear } ) )
                {
                    $global_dashrep_replacement{ $phrase_name_to_clear } = "" ;
                }
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; cleared phrases listed in phrase " . $phrase_name . "}}\n" ;
            }
            $replacement_text = $text_begin . " " . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  clear-all-dashrep-phrases

        if ( $action_name eq "clear-all-dashrep-phrases" )
        {
            if ( $number_of_operands != 0 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            $tracking_on_yes_or_no = $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } ;
            &dashrep_delete_all( );
            if ( $tracking_on_yes_or_no eq "yes" )
            {
                $global_trace_log .= "{{trace; cleared all definitions, including tracking/trace settings}}\n" ;
            }
            $global_endless_loop_counter = 0 ;
            $replacement_text = "" ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  append-from-phrase-to-phrase
#  append-from-phrase-to-phrase-no-space
#  prepend-from-phrase-to-phrase
#  prepend-from-phrase-to-phrase-no-space
#  append-word-to-phrase

        if ( ( $action_name eq "append-from-phrase-to-phrase" ) || ( $action_name eq "append-from-phrase-to-phrase-no-space" ) || ( $action_name eq "prepend-from-phrase-to-phrase" ) || ( $action_name eq "prepend-from-phrase-to-phrase-no-space" ) || ( $action_name eq "append-word-to-phrase" ) )
        {
            if ( $number_of_operands != 2 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_two =~ /^[\-_]/ ) || ( $operand_two =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            $source_phrase_name = $operand_one ;
            $target_phrase_name = $operand_two ;
            $text_for_value = "" ;
            if ( ( $action_name ne "append-word-to-phrase" ) && ( ( not( exists( $global_dashrep_replacement{ $source_phrase_name } ) ) ) || ( not( defined( $global_dashrep_replacement{ $source_phrase_name } ) ) ) ) )
            {
                $global_dashrep_replacement{ $target_phrase_name } .= "" ;
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; appended nothing because phrase " . $source_phrase_name . " is not defined}}\n" ;
                }
            } else
            {
                if ( $action_name eq "append-from-phrase-to-phrase-no-space" )
                {
                    $text_string = $global_dashrep_replacement{ $source_phrase_name } ;
                    $text_string =~ s/^ +//s ;
                    $text_string =~ s/ +$//s ;
                    $global_dashrep_replacement{ $target_phrase_name } .= $text_string ;
                } elsif ( $action_name eq "append-from-phrase-to-phrase" )
                {
                    $global_dashrep_replacement{ $target_phrase_name } .= " " . $global_dashrep_replacement{ $source_phrase_name } ;
                } elsif ( $action_name eq "prepend-from-phrase-to-phrase-no-space" )
                {
                    $text_string = $global_dashrep_replacement{ $source_phrase_name } ;
                    $text_string =~ s/^ +//s ;
                    $text_string =~ s/ +$//s ;
                    $global_dashrep_replacement{ $target_phrase_name } = $text_string . $global_dashrep_replacement{ $target_phrase_name } ;
                } elsif ( $action_name eq "prepend-from-phrase-to-phrase" )
                {
                    $global_dashrep_replacement{ $target_phrase_name } = $global_dashrep_replacement{ $source_phrase_name } . " " . $global_dashrep_replacement{ $target_phrase_name } ;
                } elsif ( $action_name eq "append-word-to-phrase" )
                {
                    $global_dashrep_replacement{ $target_phrase_name } .= " " . $operand_one ;
                }
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; did action " . $action_name . " from phrase " . $source_phrase_name . " to phrase " . $target_phrase_name . "}}\n" ;
                }
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  append-new-line-to-phrase

        if ( $action_name eq "append-new-line-to-phrase" )
        {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            $global_dashrep_replacement{ $operand_one } .= "\n" ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; appended newline to phrase " . $operand_one . "}}\n" ;
            }
            $text_for_value = "" ;
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  copy-from-phrase-to-phrase
#  copy-from-phrase-to-phrase-and-replace-html-reserved-characters
#  copy-from-phrase-to-phrase-and-replace-digits-with-9s (useful for identifying string patterns that involve digits)
#  copy-from-phrase-to-phrase-lowercase-only
#  copy-from-phrase-to-phrase-uppercase-only
#  copy-from-phrase-to-phrase-initial-caps
#  copy-from-phrase-to-phrase-and-remove-extra-spaces
#  copy-from-phrase-to-phrase-and-numeric-sort-by-word
#  copy-from-phrase-to-phrase-and-alphabetic-sort-by-word
#  copy-from-phrase-to-phrase-and-split-into-list-of-characters
#  copy-from-phrase-to-phrase-but-remove-first-word
#  copy-from-phrase-to-phrase-but-remove-last-word
#  copy-from-phrase-to-phrase-and-encode-as-cgi-parameter
#  copy-from-phrase-to-phrase-and-decode-from-cgi-parameter

        if ( ( $action_name eq "copy-from-phrase-to-phrase" ) || ( $action_name eq "copy-from-phrase-to-phrase-and-remove-extra-spaces" ) || ( $action_name eq "copy-from-phrase-to-phrase-and-replace-html-reserved-characters" ) || ( $action_name eq "copy-from-phrase-to-phrase-and-replace-digits-with-9s" ) || ( $action_name eq "copy-from-phrase-to-phrase-lowercase-only" ) || ( $action_name eq "copy-from-phrase-to-phrase-uppercase-only" ) || ( $action_name eq "copy-from-phrase-to-phrase-initial-caps" ) || ( $action_name eq "copy-from-phrase-to-phrase-and-numeric-sort-by-word" ) || ( $action_name eq "copy-from-phrase-to-phrase-and-alphabetic-sort-by-word" ) || ( $action_name eq "copy-from-phrase-to-phrase-and-split-into-list-of-characters" ) || ( $action_name eq "copy-from-phrase-to-phrase-but-remove-first-word" ) || ( $action_name eq "copy-from-phrase-to-phrase-but-remove-last-word" ) || ( $action_name eq "copy-from-phrase-to-phrase-and-encode-as-cgi-parameter" ) || ( $action_name eq "copy-from-phrase-to-phrase-and-decode-from-cgi-parameter" ) )
        {
            if ( $number_of_operands != 2 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_two =~ /^[\-_]/ ) || ( $operand_two =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            $source_phrase_name = $operand_one ;
            $target_phrase_name = $operand_two ;
            if ( not( exists( $global_dashrep_replacement{ $source_phrase_name } ) ) )
            {
                $global_dashrep_replacement{ $source_phrase_name } = "" ;
            }
            $temp_text = $global_dashrep_replacement{ $source_phrase_name } ;
            if ( $action_name eq "copy-from-phrase-to-phrase-and-remove-extra-spaces" )
            {
                $temp_text =~ s/  +/ /sg ;
                $temp_text =~ s/^ +//s ;
                $temp_text =~ s/ +$//s ;
            } elsif ( $action_name eq "copy-from-phrase-to-phrase-and-replace-digits-with-9s" )
            {
                $temp_text =~ s/[0-8]/9/sg ;
            } elsif ( $action_name eq "copy-from-phrase-to-phrase-lowercase-only" )
            {
                $temp_text = lc( $temp_text ) ;
            } elsif ( $action_name eq "copy-from-phrase-to-phrase-uppercase-only" )
            {
                $temp_text = uc( $temp_text ) ;
            } elsif ( $action_name eq "copy-from-phrase-to-phrase-initial-caps" )
            {
                $temp_text =~ s/^ +// ;
                $temp_text =~ s/ +$// ;
                $remaining_text = $temp_text ;
                $accumulated_text = "" ;
                if ( $remaining_text =~ /^([a-z])(.*)$/s )
                {
                    $character_to_capitalize = $1 ;
                    $remaining_text = $2 ;
                    $accumulated_text .= uc( $character_to_capitalize ) ;
                }
                while ( $remaining_text =~ /^(.*?) ([a-z])(.*)$/s )
                {
                    $accumulated_text .= $1 ;
                    $character_to_capitalize = $2 ;
                    $remaining_text = $3 ;
                    $accumulated_text .= " " . uc( $character_to_capitalize ) ;
                }
                $accumulated_text .= $remaining_text ;
                $temp_text = $accumulated_text ;
            } elsif ( $action_name eq "copy-from-phrase-to-phrase-and-encode-as-cgi-parameter" )
            {
                $temp_text =~ s/ /\+/sg ;
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
            } elsif ( $action_name eq "copy-from-phrase-to-phrase-and-decode-from-cgi-parameter" )
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
            } elsif ( $action_name eq "copy-from-phrase-to-phrase-and-replace-html-reserved-characters" )
            {
                $open_angle_bracket_replacement = $global_dashrep_replacement{ "dashrep-html-replacement-open-angle-bracket" } ;
                $close_angle_bracket_replacement = $global_dashrep_replacement{ "dashrep-html-replacement-close-angle-bracket" } ;
                $quotation_mark_replacement = $global_dashrep_replacement{ "dashrep-html-replacement-quotation-mark" } ;
                $apostrophe_replacement = $global_dashrep_replacement{ "dashrep-html-replacement-apostrophe" } ;
                $ampersand_replacement = $global_dashrep_replacement{ "dashrep-html-replacement-ampersand" } ;
                $temp_text =~ s/</${open_angle_bracket_replacement}/sg ;
                $temp_text =~ s/>/${close_angle_bracket_replacement}/sg ;
                $temp_text =~ s/\"/${quotation_replacement}/sg ;
                $temp_text =~ s/\'/${apostrophe_replacement}/sg ;
                $temp_text =~ s/\&/${ampersand_replacement}/sg ;
            } elsif ( $action_name eq "copy-from-phrase-to-phrase-and-numeric-sort-by-word" )
            {
                $temp_text =~ s/[\n\r\t]+/ /sg ;
                $temp_text =~ s/^ +// ;
                $temp_text =~ s/ +$// ;
                @list = split( / +/ , $temp_text ) ;
                @list_of_sorted_numbers = sort { $a <=> $b } @list ;
                $temp_text = join( " " , @list_of_sorted_numbers ) ;
            } elsif ( $action_name eq "copy-from-phrase-to-phrase-and-alphabetic-sort-by-word" )
            {
                $temp_text =~ s/[\n\r\t]+/ /sg ;
                $temp_text =~ s/^ +// ;
                $temp_text =~ s/ +$// ;
                @list = split( / +/ , $temp_text ) ;
                @list_of_sorted_numbers = sort( @list ) ;
                $temp_text = join( " " , @list_of_sorted_numbers ) ;
            } elsif ( $action_name eq "copy-from-phrase-to-phrase-and-split-into-list-of-characters" )
            {
                $temp_text = join( " " , unpack( "(a1)*" , $temp_text ) ) ;
                $temp_text =~ s/   / onespace /g ;
            } elsif ( $action_name eq "copy-from-phrase-to-phrase-but-remove-first-word" )
            {
                $temp_text =~ s/[\n\r\t]+/ /sg ;
                $temp_text =~ s/^ *[^ ]+ +// ;
            } elsif ( $action_name eq "copy-from-phrase-to-phrase-but-remove-last-word" )
            {
                $temp_text =~ s/[\n\r\t]+/ /sg ;
                $temp_text =~ s/ +[^ ]+ *$// ;
            }
            $global_dashrep_replacement{ $target_phrase_name } = $temp_text ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; copied from phrase " . $source_phrase_name . " to phrase " . $target_phrase_name . " with any specified changes}}\n" ;
            }
            $replacement_text = $text_begin . " " . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  copy-from-phrase-to-phrase-into-spoken-dashrep-code
#  copy-from-phrase-to-phrase-from-spoken-dashrep-code

        if ( ( $action_name eq "copy-from-phrase-to-phrase-into-spoken-dashrep-code" ) || ( $action_name eq "copy-from-phrase-to-phrase-from-spoken-dashrep-code" ) )
        {
            if ( $number_of_operands != 2 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_two =~ /^[\-_]/ ) || ( $operand_two =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            $source_phrase_name = $operand_one ;
            $target_phrase_name = $operand_two ;
            if ( not( exists( $global_dashrep_replacement{ $source_phrase_name } ) ) )
            {
                $global_dashrep_replacement{ $source_phrase_name } = "" ;
            }
            $temp_text = $global_dashrep_replacement{ $source_phrase_name } ;
            if ( $action_name eq "copy-from-phrase-to-phrase-into-spoken-dashrep-code" )
            {
                $temp_text =~ s/^ +//sg ;
                $temp_text =~ s/ +$//sg ;
                $temp_text = " " . $temp_text . " " ;
                $temp_text =~ s/\t+/ /sg ;
                $temp_text =~ s/  +/ /sg ;
                $temp_text =~ s/[\n\r]/ linbray /sg ;
                $temp_text =~ s/-\[-/ hyambee /sg ;
                $temp_text =~ s/-\]-/ amennhy /sg ;
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
                while ( $temp_text =~ / ((ambee)|(amenn)|(fen)|(combee)|(comenn)|(newline)(hyambee)|(amennhy)) /s )
                {
                    $temp_text =~ s/ ambee / \[-/sg ;
                    $temp_text =~ s/ amenn /-\] /sg ;
                    $temp_text =~ s/ fen / - /sg ;
                    $temp_text =~ s/([^a-z0-9])fen-/$1-/sg ;
                    $temp_text =~ s/-fen([^a-z0-9])/-$1/sg ;
                    $temp_text =~ s/ combee / *---- /sg ;
                    $temp_text =~ s/ comenn / ----* /sg ;
                    $temp_text =~ s/ hyambee /-\[-/sg ;
                    $temp_text =~ s/ amennhy /-\]-/sg ;
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
            $replacement_text = $text_begin . " " . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  xml-move-attributes-into-tag-elements-within-phrase

        if ( $action_name eq "xml-move-attributes-into-tag-elements-within-phrase" )
        {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( not( exists( $global_dashrep_replacement{ $operand_one } ) ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , empty operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
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
            $replacement_text = $text_begin . " " . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  insert-angle-bracketed-definitions-into-already-expanded-phrase

        if ( $action_name eq "insert-angle-bracketed-definitions-into-already-expanded-phrase" )
        {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            $phrase_being_edited = $operand_one ;
            if ( not( exists( $global_dashrep_replacement{ $phrase_being_edited } ) ) )
            {
                $global_dashrep_replacement{ $phrase_being_edited } = "" ;
            }
            $remaining_text = $global_dashrep_replacement{ $phrase_being_edited } ;
            $accumulated_text = "" ;
            $remaining_text =~ s/<character_hyphen>/-/sg ;
            while ( $remaining_text =~ /^(.*?)<([^ _<>]+_[^ <>]+)>(.*)$/s )
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
            $replacement_text = $text_begin . " " . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  copy-from-phrase-to-phrase-only-word-at-position
#  copy-words-from-phrase-to-phrase-using-numeric-sort-order-specified-in-phrase
#
        if ( ( $action_name eq "copy-from-phrase-to-phrase-only-word-at-position" ) || ( $action_name eq "copy-words-from-phrase-to-phrase-using-numeric-sort-order-specified-in-phrase" ) )
        {
            if ( $number_of_operands != 3 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_two =~ /^[\-_]/ ) || ( $operand_two =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            if ( $action_name eq "copy-words-from-phrase-to-phrase-using-numeric-sort-order-specified-in-phrase" )
            {
                if ( ( $operand_three =~ /^[\-_]/ ) || ( $operand_three =~ /[\-_]$/ ) || ( not( exists( $global_dashrep_replacement{ $operand_three } ) ) ) )
                {
                    $text_for_value = " " ;
                    $replacement_text = $text_begin . $text_for_value . $text_end ;
                    if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_three . "}}\n" ;
                    }
                    next ;
                }
            }
            if ( ( $action_name eq "copy-words-from-phrase-to-phrase-using-numeric-sort-order-specified-in-phrase" ) && ( $operand_three =~ /[^0-9\.\- ]/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , operand contains non-numeric content: " . $operand_three . "}}\n" ;
                }
                next ;
            }
            $source_phrase_name = $operand_one ;
            $target_phrase_name = $operand_two ;
            $source_phrase_name =~ s/[\n\t\t]//g ;
            if ( ( $source_phrase_name !~ /^[^ ]+$/ ) || ( not( exists( $global_dashrep_replacement{ $source_phrase_name } ) ) ) || ( not( defined( $global_dashrep_replacement{ $source_phrase_name } ) ) ) )
            {
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; copied nothing because phrase " . $operand_one . " is not defined}}\n" ;
                }
                $text_for_value = " " ;
            } else
            {
                $source_text = $global_dashrep_replacement{ $source_phrase_name } ;
                $source_text =~ s/^ +// ;
                $source_text =~ s/ +$// ;
                $text_for_value = "" ;
                if ( $action_name eq "copy-from-phrase-to-phrase-only-word-at-position" )
                {
                    if ( $operand_three =~ /^[0-9]+$/ )
                    {
                        $word_position = $operand_three + 0 ;
                    } else
                    {
                        $word_position = 1 ;
                    }
                    @list_of_words = split( / +/ , $source_text ) ;
                    if ( $word_position > scalar( @list_of_words + 1 ) )
                    {
                        $word_position = scalar( @list_of_words + 1 ) ;
                    }
                    $global_dashrep_replacement{ $target_phrase_name } = $list_of_words[ $word_position - 1 ] ;
                    if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; copied word number " . $word_position . " from phrase " . $source_phrase_name . " to phrase " . $target_phrase_name . "}}\n" ;
                    }
                } elsif ( $action_name eq "copy-words-from-phrase-to-phrase-using-numeric-sort-order-specified-in-phrase" )
                {
                    @list_of_words = split( / +/ , $source_text ) ;
                    @list_indicating_sort_order = split( / +/ , $global_dashrep_replacement{ $operand_three } ) ;
                    @sort_order = sort( @list_indicating_sort_order ) ;
                    $extra_words_without_sort_value = "" ;
                    if ( $#list_indicating_sort_order < $#list_of_words )
                    {
                        for ( $word_position = ( $list_indicating_sort_order + 2 ) ; $word_position <= ( $#list_of_words + 1 ) ; $word_position ++ )
                        {
                            $extra_words_without_sort_value .= $list_of_words[ $word_position - 1 ] . " " ;
                        }
                    }
                    for ( $word_position = 1 ; $word_position <= ( $#list_indicating_sort_order + 1 ) ; $word_position ++ )
                    {
                        $words_at_numeric_value{ $numeric_value } .= $list_of_words[ $word_position - 1 ] . " " ;
                    }
                    $text_string = "" ;
                    foreach $numeric_value ( @sort_order )
                    {
                        $text_string .= $words_at_numeric_value{ $numeric_value } . " " ;
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
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  copy-from-phrase-to-phrase-and-replace-string-in-phrase-with-phrase

        if ( $action_name eq "copy-from-phrase-to-phrase-and-replace-string-in-phrase-with-phrase" )
        {
            if ( $number_of_operands != 4 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_two =~ /^[\-_]/ ) || ( $operand_two =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            if ( $action_name eq "copy-from-phrase-to-phrase-and-replace-string-in-phrase-with-phrase" )
            {
                if ( ( $operand_three =~ /^[\-_]/ ) || ( $operand_three =~ /[\-_]$/ ) || ( not( exists( $global_dashrep_replacement{ $operand_three } ) ) ) )
                {
                    $text_for_value = " " ;
                    $replacement_text = $text_begin . $text_for_value . $text_end ;
                    if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; warning, for action " . $action_name . " , phrase " . $operand_three . " is not a valid phrase name or phrase does not exist" . "}}\n" ;
                    }
                    next ;
                }
                $string_to_be_replaced = $global_dashrep_replacement{ $operand_three } ;
                if ( length( $string_to_be_replaced ) < 1 )
                {
                    $text_for_value = " " ;
                    $replacement_text = $text_begin . $text_for_value . $text_end ;
                    if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; warning, for action " . $action_name . " , search string in phrase " . $operand_three . " is not at least one character long" . "}}\n" ;
                    }
                    next ;
                }
            }
            if ( ( $operand_four =~ /^[\-_]/ ) || ( $operand_four =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_four . "}}\n" ;
                }
                next ;
            }
            $source_phrase_name = $operand_one ;
            $target_phrase_name = $operand_two ;
            if ( not( exists( $global_dashrep_replacement{ $source_phrase_name } ) ) )
            {
                $global_dashrep_replacement{ $source_phrase_name } = "" ;
            }
            if ( exists( $global_dashrep_replacement{ $operand_four } ) )
            {
                $text_to_insert = $global_dashrep_replacement{ $operand_four } ;
            } else
            {
                $text_to_insert = "" ;
            }
            if ( $action_name eq "copy-from-phrase-to-phrase-and-replace-string-in-phrase-with-phrase" )
            {
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
                }
                $global_dashrep_replacement{ $target_phrase_name } = $source_text ;
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; copied from phrase " . $source_phrase_name . " to phrase " . $target_phrase_name . " with replacements}}\n" ;
                }
            }
            $replacement_text = $text_begin . " " . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  expand-phrase-to-phrase

        if ( $action_name eq "expand-phrase-to-phrase" )
        {
            if ( $number_of_operands != 2 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_two =~ /^[\-_]/ ) || ( $operand_two =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            $text_for_value = " " ;
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                $text_to_expand = $global_dashrep_replacement{ $operand_one } ;
                $partial_translation = &dashrep_expand_parameters( $text_to_expand ) ;
                if ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; after parameters expanded: " . $partial_translation . "}}\n" ;
                }
                $translation = &dashrep_expand_phrases( $partial_translation );
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
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  numeric-equal-greater-less-compare

        if ( $action_name eq "numeric-equal-greater-less-compare" )
        {
            if ( $number_of_operands != 2 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( $operand_one !~ /^[\-0-9\.]+$/ )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( $operand_two !~ /^[\-0-9\.]+$/ )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            $first_object_of_action = $operand_one + 0 ;
            $second_object_of_action = $operand_two + 0 ;
            if ( $first_object_of_action == $second_object_of_action )
            {
                $text_for_value = "equal" ;
            } elsif ( $first_object_of_action > $second_object_of_action )
            {
                $text_for_value = "greater" ;
            } else
            {
                $text_for_value = "less" ;
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  yes-if-not-no
#  no-if-any-no

        if ( ( $action_name eq "yes-if-not-no" ) || ( $action_name eq "no-if-any-no" ) )
        {
            if ( $object_of_action =~ /no/i )
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
            if ( $object_of_action =~ /yes/i )
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
            if ( $object_of_action =~ /yes/i )
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
#  if-word-is-yes-then-first-else-second
#  if-word-is-no-then-first-else-second

        if ( ( $action_name eq "if-word-is-yes-then-first-else-second" ) || ( $action_name eq "if-word-is-no-then-first-else-second" ) )
        {
            if ( $number_of_operands != 3 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /yes/i ) && ( $action_name eq "if-word-is-yes-then-first-else-second" ) )
            {
                $text_for_value = $operand_two ;
            } elsif ( ( $operand_one =~ /no/i ) && ( $action_name eq "if-word-is-no-then-first-else-second" ) )
            {
                $text_for_value = $operand_two ;
            } else
            {
                $text_for_value = $operand_three ;
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  if-first-word-is-yes-then-keep-remainder-else-empty
#  if-first-word-is-no-then-keep-remainder-else-empty

        if ( ( $action_name eq "if-first-word-is-yes-then-keep-remainder-else-empty" ) || ( $action_name eq "if-first-word-is-no-then-keep-remainder-else-empty" ) )
        {
            if ( ( ( $object_of_action =~ /^ *yes /i ) && ( $action_name eq "if-first-word-is-yes-then-keep-remainder-else-empty" ) ) || ( ( $object_of_action =~ /^ *no /i ) && ( $action_name eq "if-first-word-is-no-then-keep-remainder-else-empty" ) ) )
            {
                $text_for_value = $object_of_action ;
                $text_for_value =~ s/^ *[a-z]+ //i ;
            } else
            {
                $text_for_value = "" ;
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  first-word-in-phrase

        if ( $action_name eq "first-word-in-phrase" )
        {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( exists( $global_dashrep_replacement{ $object_of_action } ) ) )
            {
                $temp_text = $global_dashrep_replacement{ $object_of_action } ;
                $temp_text =~ s/^ +// ;
                $temp_text =~ s/ +$// ;
                @list = split( / +/ , $temp_text ) ;
            } else
            {
                @list = ( ) ;
            }
            $count = $#list + 1 ;
            $text_for_value = " " ;
            if ( $count > 0 )
            {
                $text_for_value = $list[ 0 ] ;
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  last-word-in-phrase

        if ( $action_name eq "last-word-in-phrase" )
        {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                $temp_text = $global_dashrep_replacement{ $operand_one } ;
                $temp_text =~ s/^ +// ;
                $temp_text =~ s/ +$// ;
                @list = split( / +/ , $temp_text ) ;
            } else
            {
                @list = ( ) ;
            }
            $count = $#list + 1 ;
            $text_for_value = " " ;
            if ( $count > 0 )
            {
                $text_for_value = $list[ $#list ] ;
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  from-phrase-get-word-number
#
#  Todo: have this action create the equivalent action that uses the new "copy-from-phrase-to-phrase-words-from-position-to-position" action

        if ( $action_name eq "from-phrase-get-word-number" )
        {
            if ( $number_of_operands != 2 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( $operand_two !~ /^[\-0-9]+$/ )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            if ( not( exists( $global_dashrep_replacement{ $operand_one } ) ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_two !~ /^[0-9]+$/ ) || ( ( $operand_two + 0 ) < 1 ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            $word_number = $operand_two + 0 ;
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                $temp_text = $global_dashrep_replacement{ $operand_one } ;
                $temp_text =~ s/^ +// ;
                $temp_text =~ s/ +$// ;
                @list = split( / +/ , $temp_text ) ;
            } else
            {
                @list = ( ) ;
            }
            $count = $#list + 1 ;
            if ( $count < 1 )
            {
                $text_for_value = " " ;
            } else
            {
                if ( $word_number > $count )
                {
                    $text_for_value = " " ;
                    if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; warning, for action " . $action_name . " , operand " . $operand_one . " exceeds number of words in phrase, so no word supplied" . "}}\n" ;
                    }
                } else
                {
                    $text_for_value = $list[ $word_number - 1 ] ;
                }
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  copy-from-phrase-to-phrase-words-from-position-to-position

        if ( $action_name eq "copy-from-phrase-to-phrase-words-from-position-to-position" )
        {
            if ( $number_of_operands != 4 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_two =~ /^[\-_]/ ) || ( $operand_two =~ /[\-_]$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            if ( $operand_three !~ /^[\-0-9]+$/ )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_three . "}}\n" ;
                }
                next ;
            }
            if ( $operand_four !~ /^[\-0-9]+$/ )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_four . "}}\n" ;
                }
                next ;
            }
            if ( not( exists( $global_dashrep_replacement{ $operand_one } ) ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_three !~ /^[\-0-9]+$/ ) || ( ( $operand_three + 0 ) < 1 ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_three . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_four !~ /^[\-0-9]+$/ ) || ( ( $operand_four + 0 ) < 1 ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_four . "}}\n" ;
                }
                next ;
            }
            $text_for_value = "" ;
            $word_number_begin = $operand_three + 0 ;
            $word_number_end = $operand_four + 0 ;
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                $temp_text = $global_dashrep_replacement{ $operand_one } ;
                $temp_text =~ s/^ +// ;
                $temp_text =~ s/ +$// ;
                @list = split( / +/ , $temp_text ) ;
            } else
            {
                @list = ( ) ;
            }
            $word_count = $#list + 1 ;
            if ( $word_count < 1 )
            {
                $global_dashrep_replacement{ $operand_two } = "" ;
            } else
            {
                if ( ( $word_number_begin > $word_count ) || ( $word_number_end < $word_number_begin ) || ( $word_number_end < 1 ) )
                {
                    $global_dashrep_replacement{ $operand_two } = "" ;
                    if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; warning, for action " . $action_name . " , operands " . $operand_three . " and " . $operand_four . " are not valid word pointers, so no copy done" . "}}\n" ;
                    }
                } else
                {
                    $separator = "" ;
                    $global_dashrep_replacement{ $operand_two } = "" ;
                    for ( $word_number = $word_number_begin ; $word_number <= $word_number_end ; $word_number ++ )
                    {
                        $global_dashrep_replacement{ $operand_two } .= $separator . $list[ $word_number - 1 ] ;
                        $separator = " " ;
                    }
                }
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  copy-from-phrase-to-phrase-with-word-order-reversed
#  (useful for inserting commas or decimal points into integers)

        if ( $action_name eq "copy-from-phrase-to-phrase-with-word-order-reversed" )
        {
            if ( $number_of_operands != 2 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_two =~ /^[\-_]/ ) || ( $operand_two =~ /[\-_]$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            $text_for_value = " " ;
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                $temp_text = $global_dashrep_replacement{ $operand_one } ;
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
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  from-phrase-get-word-number

        if ( $action_name eq "from-phrase-get-word-number" )
        {
            if ( $number_of_operands != 2 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( $operand_two !~ /^[\-0-9]+$/ )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            if ( ( not( exists( $global_dashrep_replacement{ $operand_one } ) ) ) || ( $operand_two !~ /^[0-9+]$/ )  || ( ( $operand_two + 0 ) < 1 ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operands}}\n" ;
                }
            } else
            {
                $word_number = $operand_two + 0 ;
                if ( ( exists( $global_dashrep_replacement{ $operand_one } ) ) )
                {
                    $temp_text = $global_dashrep_replacement{ $operand_one } ;
                    $temp_text =~ s/^ +// ;
                    $temp_text =~ s/ +$// ;
                    @list = split( / +/ , $temp_text ) ;
                } else
                {
                    @list = ( ) ;
                }
                $count = $#list + 1 ;
                if ( $count < 1 )
                {
                    $text_for_value = $global_dashrep_replacement{ $operand_one } ;
                } else
                {
                    if ( $word_number > $count )
                    {
                        $text_for_value = " " . $action_name . " " . $object_of_action . " " ;
                    } else
                    {
                        $text_for_value = $list[ $word_number - 1 ] ;
                    }
                }
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  count-of-words-in-phrase

        if ( $action_name eq "count-of-words-in-phrase" )
        {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                $temp_text = $global_dashrep_replacement{ $operand_one } ;
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
                $text_for_value = $count ;
            } else
            {
                $text_for_value = "0" ;
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  position-of-word-in-phrase
#  yes-or-no-word-is-in-phrase
#  position-of-word-in-phrase-within-phrase

        if ( ( $action_name eq "position-of-word-in-phrase" ) || ( $action_name eq "yes-or-no-word-is-in-phrase" ) || ( $action_name eq "position-of-word-in-phrase-within-phrase" ) )
        {
            if ( $number_of_operands != 2 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( ( $operand_two =~ /^[\-_]/ ) || ( $operand_two =~ /[\-_]$/ ) ) || ( not( exists( $global_dashrep_replacement{ $operand_two } ) ) ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            if ( ( $action_name eq "position-of-word-in-phrase-within-phrase" ) && ( ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) ) || ( not( exists( $global_dashrep_replacement{ $operand_one } ) ) ) ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( $action_name eq "position-of-word-in-phrase-within-phrase" )
            {
                $word_to_find = $global_dashrep_replacement{ $operand_one } ;
            } else
            {
                $word_to_find = $operand_one ;
            }
            $phrase_name = $operand_two ;
            $temp_text = $global_dashrep_replacement{ $phrase_name } ;
            $temp_text =~ s/^ +// ;
            $temp_text =~ s/ +$// ;
            @list = split( / +/ , $temp_text ) ;
            $list_length = $#list + 1 ;
            if ( ( $action_name eq "position-of-word-in-phrase" ) || ( $action_name eq "position-of-word-in-phrase-within-phrase" ) )
            {
                $text_for_value = "0" ;
            } else
            {
                $text_for_value = "no" ;
            }
            if ( $list_length >= 1 )
            {
                $last_pointer = 0 ;
                for ( $pointer = 1 ; $pointer <= $list_length ; $pointer ++ )
                {
                    if ( $list[ $pointer - 1 ] eq $word_to_find )
                    {
                        if ( ( $action_name eq "position-of-word-in-phrase" ) || ( $action_name eq "position-of-word-in-phrase-within-phrase" ) )
                        {
                            $text_for_value = sprintf( "%d" , $pointer ) ;
                        } else
                        {
                            $text_for_value = "yes" ;
                        }
                        last ;
                    }
                }
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  position-of-string-in-phrase-within-phrase

        if ( $action_name eq "position-of-string-in-phrase-within-phrase" )
        {
            if ( $number_of_operands != 2 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) ) || ( not( exists( $global_dashrep_replacement{ $operand_one } ) ) ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( ( $operand_two =~ /^[\-_]/ ) || ( $operand_two =~ /[\-_]$/ ) ) || ( not( exists( $global_dashrep_replacement{ $operand_two } ) ) ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            $string_to_find = $global_dashrep_replacement{ $operand_one } ;
            $string_to_search = $global_dashrep_replacement{ $operand_two } ;
            $text_for_value = "0" ;
            $phrase_length = length( $string_to_search ) + 1 ;
            if ( $phrase_length > 0 )
            {
                $position = index( $string_to_search , $string_to_find ) + 1 ;
                if ( $position > 0 )
                {
                    $text_for_value = sprintf( "%d" , $position ) ;
                }
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; action " . $action_name . " searched for " . $string_to_find . " within " . $string_to_search . " and found at character position " . $text_for_value . "}}\n";
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  copy-from-two-phrases-words-found-in-both-to-phrase
#  copy-from-first-phrase-words-not-found-in-second-phrase-to-phrase
#      (order of items in first list are preserved)
#  copy-from-phrase-unique-words-to-phrase

        if ( ( $action_name eq "copy-from-two-phrases-words-found-in-both-to-phrase" ) || ( $action_name eq "copy-from-first-phrase-words-not-found-in-second-phrase-to-phrase" ) || ( $action_name eq "copy-from-phrase-unique-words-to-phrase" ) )
        {
            $text_for_value = "" ;
            $text_list_loop = $global_dashrep_replacement{ $operand_one } ;
            if ( $action_name eq "copy-from-phrase-unique-words-to-phrase" )
            {
                $text_list_key = "" ;
                $destination_phrase = $operand_two ;
            } else
            {
                $text_list_key = $global_dashrep_replacement{ $operand_two } ;
                $destination_phrase = $operand_three ;
            }
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
                $listed_word{ $word } = 0 ;
            }
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
            %not_listed_word = ( ) ;
            $result_word_list = "" ;
            if ( $length_of_loop_list > 0 )
            {
                for ( $pointer = 1 ; $pointer <= $length_of_loop_list ; $pointer ++ )
                {
                    $word = $list_of_loop_words[ $pointer - 1 ] ;
                    if ( ( exists( $listed_word{ $word } ) ) && ( $action_name eq "copy-from-two-phrases-words-found-in-both-to-phrase" ) )
                    {
                        $result_word_list .= $word . " " ;
                    } elsif ( not( exists( $listed_word{ $word } ) ) )
                    {
                        if ( $action_name eq "copy-from-first-phrase-words-not-found-in-second-phrase-to-phrase" )
                        {
                            $result_word_list .= $word . " " ;
                        } elsif ( $action_name eq "copy-from-phrase-unique-words-to-phrase" )
                        {
                            $not_listed_word{ $word } ++ ;
                            if ( $not_listed_word{ $word } < 2 )
                            {
                                $result_word_list .= $word . " " ;
                            }
                        }
                    }
                }
            }
            $result_word_list =~ s/ +$// ;
            $global_dashrep_replacement{ $destination_phrase } = $result_word_list ;
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  counts-from-integer-to-integer-put-into-phrase

        if ( $action_name eq "counts-from-integer-to-integer-put-into-phrase" )
        {
            if ( $number_of_operands != 3 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( $operand_one !~ /^[\-0-9]+$/ )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( $operand_two !~ /^[\-0-9]+$/ )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_three =~ /^[\-_]/ ) || ( $operand_three =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_three . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one !~ /^[\-0-9]+$/ ) || ( $operand_two !~ /^[\-0-9]+$/ ) || ( $operand_three eq "" ) )
            {
                $text_for_value = " " ;
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
                if ( $count_range > 99999 )
                {
                    $text_for_value = " " . $action_name . " " . $object_of_action . " " ;
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
                    $text_for_value = "" ;
                }
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  create-list-of-phrase-names-that-begin-with-text-in-phrase-and-put-into-phrase

        if ( $action_name eq "create-list-of-phrase-names-that-begin-with-text-in-phrase-and-put-into-phrase" )
        {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( $global_dashrep_replacement{ "dashrep-yes-or-no-export-delimited-definitions" } eq "yes" )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, permission denied to use action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( $operand_one =~ /^[\-_]/ )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( $operand_one !~ /^[^ ]+-[^ ]+-[^ ]/ )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , operand " . $operand_one . " does not contain at least two hyphens" . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_two =~ /^[\-_]/ ) || ( $operand_two =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            $length_of_string = length( $operand_one ) ;
            @list_of_phrases = &dashrep_get_list_of_phrases( ) ;
            @sequence_of_phrases = sort( @list_of_phrases ) ;
            $counter = 0 ;
            $generated_list = "" ;
            foreach $phrase_name ( @sequence_of_phrases )
            {
                if ( ( defined( $phrase_name ) ) && ( $phrase_name =~ /[^ ]/ ) && ( exists( $global_dashrep_replacement{ $phrase_name } ) ) )
                {
                    if ( substr( $phrase_name , 0 , $length_of_string ) eq $operand_one )
                    {
                        $generated_list .= $phrase_name . " " ;
                        $counter ++ ;
                    }
                }
            }
            $generated_list =~ s/ +$// ;
            $global_dashrep_replacement{ $operand_two } = $generated_list ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; wrote " . $counter . " phrase names to phrase " . $operand_one . "}}\n" ;
            }
            $text_for_value = "" ;
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  every-pairwise-combination-of-words-from-two-phrases-put-into-two-phrases
#  every-ordered-pairwise-combination-of-words-from-two-phrases-put-into-two-phrases

        if ( ( $action_name eq "every-pairwise-combination-of-words-from-two-phrases-put-into-two-phrases" ) || ( $action_name eq "every-ordered-pairwise-combination-of-words-from-two-phrases-put-into-two-phrases" ) )
        {
            if ( $number_of_operands != 4 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_two =~ /^[\-_]/ ) || ( $operand_two =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_three =~ /^[\-_]/ ) || ( $operand_three =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_three . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_four =~ /^[\-_]/ ) || ( $operand_four =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_four . "}}\n" ;
                }
                next ;
            }
            if ( not( defined( $global_dashrep_replacement{ $operand_one } ) ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , operand " . $operand_one . " not defined" . "}}\n" ;
                }
                next ;
            } elsif ( not( defined( $global_dashrep_replacement{ $operand_two } ) ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , operand " . $operand_two . " not defined" . "}}\n" ;
                }
                next ;
            } else
            {
                $input_list_one_phrase_name = $operand_one ;
                $input_list_two_phrase_name = $operand_two ;
                $output_list_one_phrase_name = $operand_three ;
                $output_list_two_phrase_name = $operand_four ;
                $temp_text = $global_dashrep_replacement{ $input_list_one_phrase_name } ;
                $temp_text =~ s/^ +// ;
                $temp_text =~ s/ +$// ;
                @input_list_one = split( / +/ , $temp_text ) ;
                $temp_text = $global_dashrep_replacement{ $input_list_two_phrase_name } ;
                $temp_text =~ s/^ +// ;
                $temp_text =~ s/ +$// ;
                @input_list_two = split( / +/ , $temp_text ) ;
                $count_list_one = $#input_list_one + 1 ;
                $count_list_two = $#input_list_two + 1 ;
                if ( $count_list_one < 1 )
                {
                    $text_for_value = " " ;
                    if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; warning, for action " . $action_name . ", operand " . $operand_one . " does not contain any words" . "}}\n" ;
                    }
                } elsif ( $count_list_two < 1 )
                {
                    $text_for_value = " " ;
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
                    if ( $action_name eq "every-ordered-pairwise-combination-of-words-from-two-phrases-put-into-two-phrases" )
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
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  zero-one-multiple
#  zero-or-nonzero

        if ( ( $action_name eq "zero-one-multiple" ) || ( $action_name eq "zero-or-nonzero" ) )
        {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( $operand_one !~ /^[\-0-9\.]+$/ )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[0-9]+$/ ) && ( $operand_one + 0 <= 0 ) )
            {
                $zero_one_multiple = "zero" ;
            } elsif ( $action_name eq "zero-or-nonzero" )
            {
                $zero_one_multiple = "nonzero" ;
            } elsif ( $operand_one + 0 == 1 )
            {
                $zero_one_multiple = "one" ;
            } else
            {
                $zero_one_multiple = "multiple" ;
            }
            $replacement_text = $text_begin . $zero_one_multiple . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  yes-or-no-empty-phrase

        if ( $action_name eq "yes-or-no-empty-phrase" )
        {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            $result_text = "yes" ;
            if ( exists( $global_dashrep_replacement{ $operand_one } ) )
            {
                if ( $global_dashrep_replacement{ $operand_one } =~ /[^ \n\t]/ )
                {
                    $result_text = "no" ;
                }
            }
            $replacement_text = $text_begin . $result_text . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  count-of-characters-in-phrase-definition
#  numeric-increment
#  numeric-decrement

       if ( ( $action_name eq "count-of-characters-in-phrase-definition" ) || ( $action_name eq "numeric-increment" ) || ( $action_name eq "numeric-decrement" ) )
       {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( $action_name eq "count-of-characters-in-phrase-definition" )
            {
                $result_text = "0" ;
                if ( exists( $global_dashrep_replacement{ $operand_one } ) )
                {
                    $result_text = length( $global_dashrep_replacement{ $operand_one } ) ;
                    if ( $result_text < 1 )
                    {
                        $result_text = "0" ;
                    }
                }
            } elsif ( ( $action_name eq "numeric-increment" ) || ( $action_name eq "numeric-decrement" ) )
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
                $result_text = "" ;
            }
            $replacement_text = $text_begin . $result_text . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  yes-or-no-same-two-phrase-definitions

        if ( $action_name eq "yes-or-no-same-two-phrase-definitions" )
        {
            if ( $number_of_operands != 2 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_two =~ /^[\-_]/ ) || ( $operand_two =~ /[\-_]$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            if ( ( not( exists( $global_dashrep_replacement{ $operand_one } ) ) ) && ( not( exists( $global_dashrep_replacement{ $operand_two } ) ) ) )
            {
                $result_text = "yes" ;
            } elsif ( not( exists( $global_dashrep_replacement{ $operand_one } ) ) )
            {
                if ( $global_dashrep_replacement{ $operand_two } eq "" )
                {
                    $result_text = "yes" ;
                } else
                {
                    $result_text = "no" ;
                }
            } elsif ( not( exists( $global_dashrep_replacement{ $operand_two } ) ) )
            {
                if ( $global_dashrep_replacement{ $operand_one } eq "" )
                {
                    $result_text = "yes" ;
                } else
                {
                    $result_text = "no" ;
                }
            } elsif ( ( $global_dashrep_replacement{ $operand_one } eq $global_dashrep_replacement{ $operand_two } ) )
            {
                $result_text = "yes" ;
            } else
            {
                $result_text = "no" ;
            }
            $replacement_text = $text_begin . $result_text . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  yes-or-no-same-two-words

        if ( $action_name eq "yes-or-no-same-two-words" )
        {
            if ( $number_of_operands != 2 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( $operand_one eq $operand_two )
            {
                $result_text = "yes" ;
            } else
            {
                $result_text = "no" ;
            }
            $replacement_text = $text_begin . $result_text . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  characters-in-phrase-get-from-position-to-position

        if ( $action_name eq "characters-in-phrase-get-from-position-to-position" )
        {
            if ( $number_of_operands != 3 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( $operand_two !~ /^[\-0-9]+$/ )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            if ( $operand_three !~ /^[\-0-9]+$/ )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_three . "}}\n" ;
                }
                next ;
            }
            $text_for_value = " " ;
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
                $copied_characters = substr( $string_in_phrase , ( $starting_character_position - 1 ) , $number_of_characters_to_get ) ;
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; action " . $action_name . " got characters " . $copied_characters . "}}\n";
                }
                $text_for_value = $copied_characters
            }
            $replacement_text = $text_begin . $copied_characters . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  numeric-minus

        if ( $action_name eq "numeric-minus" )
        {
            if ( $number_of_operands != 2 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( $operand_one !~ /^[\-0-9\.]+$/ )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( $operand_two !~ /^[\-0-9\.]+$/ )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            $numeric_value = ( $operand_one + 0 ) - ( $operand_two + 0 ) ;
            if ( $numeric_value == 0 )
            {
                $text_for_value = "0" ;
            } else
            {
                $text_for_value = sprintf( "%f" , $numeric_value ) ;
            }
            if ( $text_for_value =~ /^(-?[0-9]+)\.0*$/ )
            {
                $text_for_value = $1 ;
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  numeric-divide-by

        if ( $action_name eq "numeric-divide-by" )
        {
            if ( $number_of_operands != 2 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( $operand_one !~ /^[\-0-9\.]+$/ )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( $operand_two !~ /^[\-0-9\.]+$/ )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_two + 0 ) == 0 )
            {
                $text_for_value = "infinity" ;
            } elsif ( ( $operand_one + 0 ) == 0 )
            {
                $text_for_value = "0" ;
            } else
            {
                $numeric_value = ( $operand_one + 0 ) / ( $operand_two + 0 ) ;
                $text_for_value = sprintf( "%f" , $numeric_value ) ;
            }
            if ( $text_for_value =~ /^(-?[0-9]+)\.0*$/ )
            {
                $text_for_value = $1 ;
            }
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; operands for action " . $action_name . " are " . $operand_one . " and " . $operand_two . " , and result is " . $numeric_value . "}}\n" ;
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  numeric-add
#  numeric-multiply
#  numeric-maximum
#  numeric-minimum

        if ( ( ( $action_name eq "numeric-add" ) || ( $action_name eq "numeric-multiply" ) || ( $action_name eq "numeric-maximum" ) || ( $action_name eq "numeric-minimum" ) ) && ( $number_of_operands >= 1 ) )
        {
            if ( $number_of_operands < 1 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            $text_for_value = "0" ;
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
            $temp_text = $object_of_action ;
            $temp_text =~ s/^ +// ;
            $temp_text =~ s/ +$// ;
            @list = split( / +/ , $temp_text ) ;
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
                $text_for_value = "0" ;
            } else
            {
                $text_for_value = sprintf( "%f" , $numeric_value ) ;
            }
            if ( $text_for_value =~ /^(-?[0-9]+)\.0*$/ )
            {
                $text_for_value = $1 ;
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  numeric-absolute

        if ( $action_name eq "numeric-absolute" )
        {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( $operand_one !~ /^[\-0-9\.]+$/ )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            $result_value = abs( $operand_one + 0 ) ;
            if ( $result_value == 0 )
            {
                $text_for_value = "0" ;
            } else
            {
                $text_for_value = sprintf( "%d" , $result_value ) ;
            }
            if ( $text_for_value =~ /^(-?[0-9]+)\.0*$/ )
            {
                $text_for_value = $1 ;
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  numeric-integer
#  numeric-odd-or-even
#  numeric-sine
#  numeric-cosine
#  numeric-logarithm-base-e
#  numeric-logarithm-base-10
#  numeric-y-map-tile-number-based-on-latitude

        if ( ( $action_name eq "numeric-integer" ) || ( $action_name eq "numeric-sine" ) || ( $action_name eq "numeric-cosine" ) || ( $action_name eq "numeric-logarithm-base-e" ) || ( $action_name eq "numeric-logarithm-base-10" ) || ( $action_name eq "numeric-y-map-tile-number-based-on-latitude" )|| ( $action_name eq "numeric-odd-or-even" ) )
        {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( $operand_one !~ /^[\-0-9\.]+$/ )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( $action_name eq "numeric-integer" )
            {
                $result_value = int( $operand_one + 0 ) ;
                if ( $result_value == 0 )
                {
                    $text_for_value = "0" ;
                } else
                {
                    $text_for_value = sprintf( "%d" , $result_value ) ;
                }
                if ( $text_for_value =~ /^(-?[0-9]+)\.0*$/ )
                {
                    $text_for_value = $1 ;
                }
            } elsif ( $action_name eq "numeric-odd-or-even" )
            {
                $result_value = int( $operand_one + 0 ) ;
                $result_value = $result_value - int( ( $result_value * 2 ) / 2 ) ;
                if ( $result_value == 0 )
                {
                    $text_for_value = "even" ;
                } else
                {
                    $text_for_value = "odd" ;
                }
            } elsif ( $action_name eq "numeric-sine" )
            {
                $result_value = sin( $operand_one + 0.0 ) ;
                if ( $result_value == 0 )
                {
                    $text_for_value = "0" ;
                } else
                {
                    $text_for_value = sprintf( "%f" , $result_value ) ;
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
                    $text_for_value = "0" ;
                } else
                {
                    $text_for_value = sprintf( "%f" , $result_value ) ;
                }
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; for action " . $action_name . " and input value " . $operand_one . " , result is " . $result_value . "}}\n" ;
                }
            } elsif ( $action_name eq "numeric-logarithm-base-e" )
            {
                $result_value = log( $operand_one + 0.0 ) ;
                if ( $result_value == 0 )
                {
                    $text_for_value = "0" ;
                } else
                {
                    $text_for_value = sprintf( "%f" , $result_value ) ;
                }
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; for action " . $action_name . " and input value " . $operand_one . " , result is " . $result_value . "}}\n" ;
                }
            } elsif ( $action_name eq "numeric-logarithm-base-10" )
            {
                $result_value = ( log( $operand_one + 0.0 ) ) / ( log( 10.0 ) ) ;
                if ( $result_value == 0 )
                {
                    $text_for_value = "0" ;
                } else
                {
                    $text_for_value = sprintf( "%f" , $result_value ) ;
                }
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; for action " . $action_name . " and input value " . $operand_one . " , result is " . $result_value . "}}\n" ;
                }
            } elsif ( $action_name eq "numeric-y-map-tile-number-based-on-latitude" )
            {
                if ( ( $operand_one > 85.0 ) || ( $operand_one < -85.0 ) )
                {
                    $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                    $replacement_text = $text_begin . $text_for_value . $text_end ;
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
                    $text_for_value = "0" ;
                } else
                {
                    $text_for_value = sprintf( "%f" , $result_value ) ;
                }
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; for action " . $action_name . " and input value " . $operand_one . " , result is " . $result_value . "}}\n" ;
                    $global_trace_log .= "{{trace; calculation details, zoom = " . $map_tile_zoom . " , n = " . $map_tile_n . " , angle in radians = " . $angle_in_radians . " , sine = " . $sine_of_angle . " , cosine = " . $cosine_of_angle . " , pi = " . $pi . "}}\n" ;
                }
            }
            if ( $text_for_value =~ /^(-?[0-9]+)\.0*$/ )
            {
                $text_for_value = $1 ;
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  numeric-two-dimensional-sort-into-columns-and-rows
#
#  operand order:
#    number of columns
#    word-based (space-delimited) list of column-direction values for sorting (increasing to right)
#    word-based (space-delimited) list of row-direction values for sorting (increasing to bottom)
#    name of phrase into which to put the results, which are space-delimited strings such as "row-3-column-2" and "row-1-column-1"
#
#  number of rows is calculated based on number of values

        if ( $action_name eq "numeric-two-dimensional-sort-into-columns-and-rows" )
        {
            if ( $number_of_operands != 4 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands (" . $number_of_operands . " instead of 4) for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( $operand_one !~ /^[0-9]+$/ )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid number of columns: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one + 0 ) < 1 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , number of columns (" . $operand_one . ") is less than 1" . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_two =~ /^[\-_]/ ) || ( $operand_two =~ /[\-_]$/ ) || ( not( exists( $global_dashrep_replacement{ $operand_two } ) ) ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid second operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_three =~ /^[\-_]/ ) || ( $operand_three =~ /[\-_]$/ ) || ( not( exists( $global_dashrep_replacement{ $operand_three } ) ) ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid third operand: " . $operand_three . "}}\n" ;
                }
                next ;
            }
            if ( $global_dashrep_replacement{ $operand_two } !~ /^[\-0-9\. ]+$/ )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , second operand contains invalid values: " . $global_dashrep_replacement{ $operand_two } . "}}\n" ;
                }
                next ;
            }
            if ( $global_dashrep_replacement{ $operand_three } !~ /^[\-0-9\. ]+$/ )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , third operand contains invalid values: " . $global_dashrep_replacement{ $operand_three } . "}}\n" ;
                }
                next ;
            }
            $number_of_columns = $operand_one ;
            $text_for_down_direction_values = $global_dashrep_replacement{ $operand_two } ;
            $text_for_right_direction_values = $global_dashrep_replacement{ $operand_three } ;
            $text_for_down_direction_values =~ s/^ +//s ;
            $text_for_down_direction_values =~ s/ +$//s ;
            $text_for_right_direction_values =~ s/^ +//s ;
            $text_for_right_direction_values =~ s/ +$//s ;
            @down_direction_value_for_item_number = split( / +/s , $text_for_down_direction_values ) ;
            unshift( @down_direction_value_for_item_number , 0 ) ;
            @right_direction_value_for_item_number = split( / +/s , $text_for_right_direction_values ) ;
            unshift( @right_direction_value_for_item_number , 0 ) ;
            $number_of_items = $#down_direction_value_for_item_number ;
            if ( ( $#down_direction_value_for_item_number != $#right_direction_value_for_item_number ) && ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , second operand (" . $operand_two . ") and third operand (". $operand_three . ") do not have the same number of values" . "}}\n" ;
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
            $down_direction_minimum_value = 999999 ;
            $down_direction_maximum_value = -999999 ;
            $right_direction_minimum_value = 999999 ;
            $right_direction_maximum_value = -999999 ;
            for ( $item_number = 1 ; $item_number <= $number_of_items ; $item_number ++ )
            {
                $zero_if_not_remaining_item_number[ $item_number ] = $item_number ;
                if ( $down_direction_value_for_item_number[ $item_number ] < $down_direction_minimum_value )
                {
                    $down_direction_minimum_value = $down_direction_value_for_item_number[ $item_number ] ;
                }
                if ( $down_direction_value_for_item_number[ $item_number ] > $down_direction_maximum_value )
                {
                    $down_direction_maximum_value = $down_direction_value_for_item_number[ $item_number ] ;
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
            $range_of_down_direction_values = $down_direction_maximum_value - $down_direction_minimum_value ;
            $range_of_right_direction_values = $right_direction_maximum_value - $right_direction_minimum_value ;
            if ( $range_of_down_direction_values > 0.0001 )
            {
                $multiplier_for_down_direction_values = 100.00 / $range_of_down_direction_values ;
            } else
            {
                $multiplier_for_down_direction_values = 1.0 ;
                $down_direction_minimum_value = $down_direction_minimum_value - 1.0 ;
            }
            if ( $range_of_right_direction_values > 0.0001 )
            {
                $multiplier_for_right_direction_values = 100.00 / $range_of_right_direction_values ;
            } else
            {
                $multiplier_for_right_direction_values = 1.0 ;
                $right_direction_minimum_value = $right_direction_minimum_value - 1.0 ;
            }
            for ( $item_number = 1 ; $item_number <= $number_of_items ; $item_number ++ )
            {
                $down_direction_value_for_item_number[ $item_number ] = ( $down_direction_value_for_item_number[ $item_number ] - $down_direction_minimum_value ) * $multiplier_for_down_direction_values ;
                $right_direction_value_for_item_number[ $item_number ] = ( $right_direction_value_for_item_number[ $item_number ] - $right_direction_minimum_value ) * $multiplier_for_right_direction_values ;
            }
            for ( $item_number = 1 ; $item_number <= $number_of_items ; $item_number ++ )
            {
                $right_and_down_direction_value_for_item_number[ $item_number ] = $right_direction_value_for_item_number[ $item_number ] + $down_direction_value_for_item_number[ $item_number ] ;
                $left_and_down_direction_value_for_item_number[ $item_number ] = - $right_direction_value_for_item_number[ $item_number ] + $down_direction_value_for_item_number[ $item_number ] ;
            }
            $top_row_number = 1 ;
            $bottom_row_number = $number_of_rows ;
            $fill_direction_top_left = 1 ;
            $fill_direction_bottom_right = 2 ;
            $fill_direction_bottom_left = 3 ;
            $fill_direction_top_right = 4 ;
            $need_maximum = 1 ;
            $need_minimum = 2 ;
            $value_direction_right_and_down = 1 ;
            $value_direction_left_and_down = 2 ;
            $value_direction_down = 3 ;
            $value_direction_right = 4 ;
            $top_left_open_column = 1 ;
            $top_right_open_column = $number_of_columns ;
            $bottom_left_open_column = 1 ;
            $bottom_right_open_column = $number_of_columns ;
            while ( $top_row_number <= $bottom_row_number )
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
                            $need_maximum_or_minimum = $need_minimum ;
                            $use_value_direction = $value_direction_right_and_down ;
                        } elsif ( $top_left_open_column == $top_right_open_column )
                        {
                            $need_maximum_or_minimum = $need_minimum ;
                            $use_value_direction = $value_direction_down ;
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
                            $need_maximum_or_minimum = $need_maximum ;
                            $use_value_direction = $value_direction_right_and_down ;
                        } elsif ( $bottom_left_open_column == $bottom_right_open_column )
                        {
                            $need_maximum_or_minimum = $need_maximum ;
                            $use_value_direction = $value_direction_down ;
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
                            $bottom_left_open_column ++ ;
                            next ;
                        } elsif ( $bottom_left_open_column < $bottom_right_open_column )
                        {
                            $need_maximum_or_minimum = $need_maximum ;
                            $use_value_direction = $value_direction_left_and_down ;
                        } elsif ( $bottom_left_open_column == $bottom_right_open_column )
                        {
                            $need_maximum_or_minimum = $need_maximum ;
                            $use_value_direction = $value_direction_down ;
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
                            $need_maximum_or_minimum = $need_minimum ;
                            $use_value_direction = $value_direction_left_and_down ;
                        } elsif ( $top_left_open_column == $top_right_open_column )
                        {
                            $need_maximum_or_minimum = $need_minimum ;
                            $use_value_direction = $value_direction_down ;
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
                            if ( $use_value_direction == $value_direction_right_and_down )
                            {
                                $next_value_to_compare = $right_and_down_direction_value_for_item_number[ $item_number ] ;
                            } elsif ( $use_value_direction == $value_direction_left_and_down )
                            {
                                $next_value_to_compare = $left_and_down_direction_value_for_item_number[ $item_number ] ;
                            } elsif ( $use_value_direction == $value_direction_down )
                            {
                                $next_value_to_compare = $down_direction_value_for_item_number[ $item_number ] ;
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
                if ( ( $top_left_open_column > $top_right_open_column ) && ( $bottom_left_open_column > $bottom_right_open_column ) )
                {
                    $top_row_number ++ ;
                    $bottom_row_number -- ;
                    $top_left_open_column = 1 ;
                    $top_right_open_column = $number_of_columns ;
                    $bottom_left_open_column = 1 ;
                    $bottom_right_open_column = $number_of_columns ;
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
                            $global_trace_log .= "item " . $item_number . " (" . $down_direction_value_for_item_number[ $item_number ] . " " . $right_direction_value_for_item_number[ $item_number ] . ") " ;
                        }
                    }
                    $global_trace_log .= "}}\n" ;
                }
            }
            $replacement_text = $text_begin . " " . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  get-current-time-in-epoch-seconds

        if ( $action_name eq "get-current-time-in-epoch-seconds" )
        {
            if ( $number_of_operands != 0 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            $epoch_seconds = time ;
            $text_for_value = sprintf( "%d" , $epoch_seconds ) ;
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  split-epoch-seconds-into-named-components

        if ( $action_name eq "split-epoch-seconds-into-named-components" )
        {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( $operand_one !~ /^[\-0-9\.]+$/ )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            ( $second_time , $minute , $hour , $day_of_month , $month_number , $year , $weekday , $day_of_year , $extra_info ) = localtime( $operand_one ) ;
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
            $text_for_value = "" ;
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  use-template-with-each-word-in-phrase

        if ( $action_name eq "use-template-with-each-word-in-phrase" )
        {
            if ( $number_of_operands != 2 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_two =~ /^[\-_]/ ) || ( $operand_two =~ /[\-_]$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            if ( ( not( exists( $global_dashrep_replacement{ $operand_one } ) ) ) || ( $global_dashrep_replacement{ $operand_one } =~ /^ *$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , phrase named " . $operand_one . " does not exist or is empty" . "}}\n" ;
                }
                next ;
            }
            if ( ( not( exists( $global_dashrep_replacement{ $operand_two } ) ) ) || ( $global_dashrep_replacement{ $operand_two } =~ /^ *$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , phrase named " . $operand_two . " does not exist or is empty" . "}}\n" ;
                }
                next ;
            }
            $template_phrase_name = $operand_one ;
            $text_to_expand = " " ;
            $list_of_words_as_text = $global_dashrep_replacement{ $operand_two } ;
            $list_of_words_as_text =~ s/^ +//s ;
            $list_of_words_as_text =~ s/ +$//s ;
            @list_of_words = split( / +/ , $list_of_words_as_text ) ;
            for ( $word_number = 1 ; $word_number <= $#list_of_words + 1 ; $word_number ++ )
            {
                $text_to_expand .= "[-copy-from-phrase-to-phrase-only-word-at-position " . $operand_two . " word-to-use-in-template " . $word_number . "-][-" . $template_phrase_name . "-]" ;
            }
            $text_to_expand .= " " ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; action " . $action_name . " created code that will use template " . $operand_one . " with each word in phrase " . $operand_two . "}}\n";
                $global_trace_log .= "{{trace; list of words: " . $global_dashrep_replacement{ $operand_two } . "}}\n";
                $global_trace_log .= "{{trace; text that will be expanded: " . $text_to_expand . "}}\n";
            }
            $replacement_text = $text_begin . $text_to_expand . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  use-template-and-parameters-to-create-full-list-with-name
#  use-template-and-parameters-to-create-simple-list-with-name

        if ( ( $action_name eq "use-template-and-parameters-to-create-full-list-with-name" ) || ( $action_name eq "use-template-and-parameters-to-create-simple-list-with-name" ) )
        {
            if ( $number_of_operands != 3 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_two =~ /^[\-_]/ ) || ( $operand_two =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_two . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_three =~ /^[\-_]/ ) || ( $operand_three =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_three . "}}\n" ;
                }
                next ;
            }
            if ( not( exists( $global_dashrep_replacement{ $operand_one } ) ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , operand " . $operand_one . " is empty or does not exist" . "}}\n" ;
                }
                next ;
            } elsif ( not( exists( $global_dashrep_replacement{ $operand_two } ) ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , operand " . $operand_two . " is empty or does not exist" . "}}\n" ;
                }
                next ;
            } elsif ( $operand_one eq $operand_two )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , operands " . $operand_one . " and " . $operand_two . " are the same, which is meaningless" . "}}\n" ;
                }
                next ;
            } else
            {
                $text_for_value = "" ;
                $template_phrase_name = $operand_one ;
                $parameter_word_list = $global_dashrep_replacement{ $operand_two } ;
                $generated_list_name = $operand_three ;
                $global_replacement_count_for_item_name{ "generating list named " . $generated_list_name } ++ ;
                $text_that_expands_to_generate_list = "[-copy-from-phrase-to-phrase empty-text " . $generated_list_name . "-]" ;
                $parameter_word_list =~ s/^ +// ;
                $parameter_word_list =~ s/ +$// ;
                @list_of_parameters = split( / +/ , $parameter_word_list ) ;
                $list_length = $#list_of_parameters + 1 ;
                if ( $list_length < 1 )
                {
                    if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; warning, list named " . $generated_list_name . "  is empty}}\n";
                    }
                } else
                {
                    $text_that_expands_to_generate_list .= "[-createlist-total-number-of-items = " . sprintf( "%d" , $list_length ) . "-]" ;
                    if ( exists( $global_dashrep_replacement{ "separator-for-list-named-" . $generated_list_name } ) )
                    {
                        $text_that_expands_to_generate_list .= "[-expand-phrase-to-phrase separator-for-list-named-" . $generated_list_name . " dashrep-list-info-temporary-storage-separator-]" ;
                    } else
                    {
                        $global_dashrep_replacement{ "dashrep-list-info-temporary-storage-separator" } = "" ;
                    }
                    for ( $list_position = 1 ; $list_position <= $list_length ; $list_position ++ )
                    {
                        $parameter = $list_of_parameters[ $list_position - 1 ] ;
                        $item_number = sprintf( "%d" , $list_position ) ;
                        $global_replacement_count_for_item_name{ "next item in list named " . $generated_list_name } ++ ;
                        if ( ( $parameter !~ /\[-/ ) && ( $parameter !~ /-\[/ ) )
                        {
                            if ( $action_name eq "use-template-and-parameters-to-create-full-list-with-name" )
                            {
                                $item_name = "item-for-list-named-" . $generated_list_name . "-and-parameter-" . $parameter ;
                                if ( ( $list_position == 1 ) && ( exists( $global_dashrep_replacement{ "prefix-for-list-named-" . $generated_list_name } ) ) )
                                {
                                    $text_that_expands_to_generate_list .= "[-expand-phrase-to-phrase prefix-for-list-named-" . $generated_list_name . " dashrep-list-info-temporary-storage-][-append-from-phrase-to-phrase dashrep-list-info-temporary-storage " . $generated_list_name . "-]" ;
                                }
                                $text_that_expands_to_generate_list .= "[-createlist-item-number = " . $item_number . "-]" ;
                                if ( $list_position == 1 )
                                {
                                    $text_that_expands_to_generate_list .= "[-createlist-first-yes-or-no = yes-]" ;
                                } else
                                {
                                    $text_that_expands_to_generate_list .= "[-createlist-first-yes-or-no = no-]" ;
                                }
                                if ( $list_position == $list_length )
                                {
                                    $text_that_expands_to_generate_list .= "[-createlist-last-yes-or-no = yes-]" ;
                                } else
                                {
                                    $text_that_expands_to_generate_list .= "[-createlist-last-yes-or-no = no-]" ;
                                }
                                $global_dashrep_replacement{ "dashrep-createlist-parameter-number-" . $item_number } = $parameter ;
                                $text_that_expands_to_generate_list .= "[-copy-from-phrase-to-phrase dashrep-createlist-parameter-number-" . $item_number . " createlist-parameter-]" ;
                                $text_that_expands_to_generate_list .= "[-expand-phrase-to-phrase " . $template_phrase_name . " " . $item_name . "-][-append-from-phrase-to-phrase " . $item_name . " " . $generated_list_name . "-]" ;
                                if ( ( $list_length > 1 ) && ( $list_position < $list_length ) )
                                {
                                    $text_that_expands_to_generate_list .= "[-append-from-phrase-to-phrase dashrep-list-info-temporary-storage-separator " . $generated_list_name . "-]" ;
                                }
                                if ( ( $list_position == $list_length ) && ( exists( $global_dashrep_replacement{ "suffix-for-list-named-" . $generated_list_name } ) ) )
                                {
                                    $text_that_expands_to_generate_list .= "[-expand-phrase-to-phrase suffix-for-list-named-" . $generated_list_name . " dashrep-list-info-temporary-storage-][-append-from-phrase-to-phrase dashrep-list-info-temporary-storage " . $generated_list_name . "-]" ;
                                }
                                $text_that_expands_to_generate_list .= "[-clear-phrase dashrep-createlist-parameter-number-" . $item_number . "-]" ;
                            } else
                            {
                                $text_that_expands_to_generate_list .= "[-createlist-parameter = " . $parameter . "-][-expand-phrase-to-phrase " . $template_phrase_name . " createlist-item-next-][-append-from-phrase-to-phrase createlist-item-next " . $generated_list_name . "-]" ;
                                if ( ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" ) && ( $parameter =~ /-/ ) )
                                {
                                    $global_trace_log .= "{{warning; parameter (" . $parameter . ") contains hyphens, so the full version, not this simple version, should be used to generate this list" . "}}\n";
                                }
                            }
                        } else
                        {
                            $text_that_expands_to_generate_list .= " dashrep-warning-parameter-for-list-generation-contains-invalid-characters " ;
                        }
                    }
                    if ( $action_name eq "use-template-and-parameters-to-create-full-list-with-name" )
                    {
                        $text_that_expands_to_generate_list .= "[-clear-phrase dashrep-list-info-temporary-storage-separator-]" ;
                    }
                    $text_for_value = "" . $text_that_expands_to_generate_list . "" ;
                    if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; parameters used to create list: " . join( "," , @list_of_parameters ) . "}}\n";
                        $global_trace_log .= "{{trace; list named " . $generated_list_name . "  will be created}}\n";
                        $global_trace_log .= "{{trace; text that will expand to generate list: " . $text_that_expands_to_generate_list . "}}\n";
                    }
                }
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  dashrep-trace-show-definition

        if ( $action_name eq "dashrep-trace-show-definition" )
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
                } elsif ( $operand_one eq "endless-loop-counter" )
                {
                    $global_trace_log .= "{{trace; ******* " . "endless-loop-counter" . " = " . $global_endless_loop_counter . " *******" . "}}\n";
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
            $replacement_text = $text_begin . $text_end ;
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
            $unique_value_as_text = sprintf( "%d" , $global_unique_value ) ;
            $replacement_text = $text_begin . $unique_value_as_text . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  calculate-if-phrase-empty
#  calculate-if-empty-then-use-here

        if ( ( $action_name eq "calculate-if-phrase-empty" ) || ( $action_name eq "calculate-if-empty-then-use-here" ) )
        {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
            $text_for_value = " " ;
            if ( ( exists( $global_dashrep_replacement{ $operand_one } ) ) && ( $global_dashrep_replacement{ $operand_one } =~ /[^ ]/ ) )
            {
                if ( $action_name eq "calculate-if-empty-then-use-here" )
                {
                    $text_for_value = "[-" . $operand_one . "-]" ;
                }
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; phrase " . $operand_one . " is not empty, so no need to calculate}}\n" ;
                }
            } else
            {
                $text_for_value = "[-calculate-" . $operand_one . "-]" ;
                if ( $action_name eq "calculate-if-empty-then-use-here" )
                {
                    $text_for_value .= "[-" . $operand_one . "-]" ;
                }
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; phrase " . $operand_one . " is empty, so inserting phrase " . $text_for_value . "}}\n" ;
                }
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  clear-all-expanded-text-up-to-here

        if ( $action_name eq "clear-all-expanded-text-up-to-here" )
        {
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; clearing all expanded text up to here}}\n" ;
                $global_trace_log .= "{{trace; the following text was removed:}}\n" ;
                $global_trace_log .= $text_begin . "\n" ;
                $global_trace_log .= "{{trace; end of text removed by request}}\n" ;
            }
            $replacement_text = $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the action:
#  insert-codeview-tags-into-phrase

        if ( $action_name eq "insert-codeview-tags-into-phrase" )
        {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( ( $operand_one =~ /^[\-_]/ ) || ( $operand_one =~ /[\-_]$/ ) )
            {
                $text_for_value = $global_dashrep_replacement{ "dashrep-undefined" } ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, for action " . $action_name . " , invalid operand: " . $operand_one . "}}\n" ;
                }
                next ;
            }
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
            $replacement_text = $text_begin . " " . $text_end ;
            next ;
        }


#-----------------------------------------------
#  Handle the actions:
#  escape-if-yes
#  escape-if-no
#
#  If the escape condition is met, return immediately,
#  with the content of the "escape-text" phrase as the return value.
#  But first save the current text being replaced.

#  Not yet implemented, not yet debugged.

        if ( ( $action_name eq "escape-if-yes" ) || ( $action_name eq "escape-if-no" ) )
        {
            if ( $number_of_operands != 1 )
            {
                $text_for_value = " " ;
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, wrong number of operands for action " . $action_name . "}}\n" ;
                }
                next ;
            }
            $text_inserted = " action " . $action_name . " not yet implemented " ;
            if ( ( exists( $global_dashrep_replacement{ "escape-text" } ) ) && ( $global_dashrep_replacement{ "escape-text" } ne "" ) )
            {
                if ( ( $object_of_action eq "yes" ) && ( $action_name eq "escape-if-yes" ) )
                {
#                    $global_dashrep_replacement{ "dashrep-translation-before-escape" } = $replacement_text ;
#                    $replacement_text = $global_dashrep_replacement{ "escape-text" } ;
#                    return $replacement_text ;
                } elsif ( ( $object_of_action eq "no" ) && ( $action_name eq "escape-if-no" ) )
                {
                    $replacement_text = $text_begin . $text_for_value . $text_end ;
#                    $global_dashrep_replacement{ "dashrep-translation-before-escape" } = $replacement_text ;
#                    $replacement_text = $global_dashrep_replacement{ "escape-text" } ;
#                    return $replacement_text ;
                }
            }
#            Following commands will not be executed if return command above is executed:
            $replacement_text = $text_begin . $text_inserted . $text_end ;
            next ;
        }


#-----------------------------------------------
#  If the word "file" or "files" or "folder" or
#  "folders" appears in the action name,
#  and if the action is recognized as a file-related
#  action, execute the action.

        if ( $action_name =~ /((file)|(folder))/ )
        {
            if ( ( $action_name eq "copy-from-phrase-append-to-file" ) || ( $action_name eq "expand-phrase-to-file" ) || ( $action_name eq "copy-from-file-to-phrase" ) || ( $action_name eq "put-into-phrase-list-of-files-in-current-read-directory" ) || ( $action_name eq "put-into-phrase-list-of-folders-in-current-read-directory" ) || ( $action_name eq "yes-or-no-file-exists" ) || ( $action_name eq "yes-or-no-folder-in-phrase-exists" ) || ( $action_name eq "size-of-file" ) || ( $action_name eq "modification-time-of-file" ) || ( $action_name eq "create-empty-file" ) || ( $action_name eq "create-empty-sub-folder" ) || ( $action_name eq "delete-file" ) || ( $action_name eq "find-line-in-file-that-begins-with-string-in-phrase-and-put-into-phrase" ) || ( $action_name eq "find-lines-in-file-that-begin-with-any-word-in-phrase-and-append-storage-phrase-names-to-phrase" ) || ( $action_name eq "find-lines-in-file-that-begin-with-any-two-words-in-phrase-and-append-storage-phrase-names-to-phrase" ) || ( $action_name eq "write-all-dashrep-definitions-to-file" ) || ( $action_name eq "write-all-dashrep-phrase-names-to-file" ) || ( $action_name eq "write-dashrep-definitions-listed-in-phrase-to-file" ) || ( $action_name eq "get-definitions-from-file" ) || ( $action_name eq "linewise-translate-from-file-to-file" ) || ( $action_name eq "linewise-translate-parameters-only-from-file-to-file" ) || ( $action_name eq "linewise-translate-phrases-only-from-file-to-file" ) || ( $action_name eq "linewise-translate-special-phrases-only-from-file-to-file" ) || ( $action_name eq "linewise-translate-xml-tags-in-file-to-dashrep-phrases-in-file" ) || ( $action_name eq "copy-from-columns-in-file-to-named-phrases" ) || ( $action_name eq "gather-tagged-info-from-file-and-put-unique-values-into-phrase" ) || ( $action_name eq "linewise-read-from-file-and-use-template" ) || ( $action_name eq "copy-from-file-to-phrases-line-numbered" ) )
            {
                $text_returned = &dashrep_file_actions( $text_parameter_content ) ;
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; file-related action encountered: " . $text_parameter_content . "}}\n" ;
                }
                $replacement_text = $text_begin . $text_returned . $text_end ;
                next ;
            }
        }


#-----------------------------------------------
#  Handle a user-defined action -- if the
#  "yes-or-no-allow-user-defined-actions" phrase
#  equals "yes".  Specifically,
#  make the operands available, and then insert
#  the action name, by itself, in parameter brackets.

        if ( ( exists( $global_dashrep_replacement{ $action_name } ) ) && ( $global_dashrep_replacement{ $action_name } =~ /-/ ) )
        {
            $text_for_value = "" ;
            if ( ( not( exists( $global_dashrep_replacement{ "yes-or-no-allow-user-defined-actions" } ) ) ) || ( $global_dashrep_replacement{ "yes-or-no-allow-user-defined-actions" } ne "yes" ) )
            {
                $replacement_text = $text_begin . $text_for_value . $text_end ;
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, no permission to handle user-defined action: " . $action_name . "}}\n" ;
                }
                next ;
            }
            if ( $number_of_operands >= 1 )
            {
                $text_for_value .= "[-user-defined-action-operand-one = " . $operand_one . "-]" ;
            }
            if ( $number_of_operands >= 2 )
            {
                $text_for_value .= "[-user-defined-action-operand-two = " . $operand_two . "-]" ;
            }
            if ( $number_of_operands >= 3 )
            {
                $text_for_value .= "[-user-defined-action-operand-three = " . $operand_three . "-]" ;
            }
            if ( $number_of_operands >= 4 )
            {
                $text_for_value .= "[-user-defined-action-operand-four = " . $operand_four . "-]" ;
            }
            $text_for_value .= "[-" . $action_name . "-]" ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; recognized user-defined action " . $action_name . "}}\n" ;
            }
            $replacement_text = $text_begin . $text_for_value . $text_end ;
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
            if ( ( exists( $global_dashrep_replacement{ "web-framework-in-use" } ) ) && ( $global_dashrep_replacement{ "web-framework-in-use" } eq "yes" ) )
            {
                $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "Warning: The dashrep_expand_parameters subroutine has encountered an endless loop." . "\n" . "Stopped" ;
            } else
            {
#  remove-from-cpan-version-begin
                warn "Warning: The dashrep_expand_parameters subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#                carp "Warning: The dashrep_expand_parameters subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  uncomment-for-cpan-version-end
            }
            return 0 ;
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
            if ( ( exists( $global_dashrep_replacement{ "web-framework-in-use" } ) ) && ( $global_dashrep_replacement{ "web-framework-in-use" } eq "yes" ) )
            {
                $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "Warning: The dashrep_expand_phrases_except_special subroutine has encountered an endless loop." . "\n" . "Stopped" ;
            } else
            {
#  remove-from-cpan-version-begin
                warn "Warning: The dashrep_expand_phrases_except_special subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#                carp "Warning: The dashrep_expand_phrases_except_special subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  uncomment-for-cpan-version-end
            }
            return 0 ;
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
    my $remaining_string ;
    my $ignore_directive ;
    my $capture_directive ;


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

    if ( ( exists( $global_dashrep_replacement{ "dashrep-yes-do-not-expand-special-phrases" } ) ) && ( $global_dashrep_replacement{ "dashrep-yes-do-not-expand-special-phrases" } eq "yes" ) )
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
#  Get the ignore level.  It can be accessed
#  from outside this subroutine in case multiple
#  streams of Dashrep code are being processed
#  in turn.

    if ( $global_dashrep_replacement{ "dashrep-ignore-level" } =~ /^[0-9]+$/ )
    {
        $global_ignore_level = $global_dashrep_replacement{ "dashrep-ignore-level" } + 0 ;
    }


#-----------------------------------------------
#  Get the capture level.  It can be accessed
#  from outside this subroutine in case multiple
#  streams of Dashrep code are being processed
#  in turn.

    if ( $global_dashrep_replacement{ "dashrep-capture-level" } =~ /^[0-9]+$/ )
    {
        $global_capture_level = $global_dashrep_replacement{ "dashrep-capture-level" } + 0 ;
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

    if ( ( not( exists( $global_dashrep_replacement{ "dashrep-ignore-actions-on-yes-or-no" } ) ) ) || ( $global_dashrep_replacement{ "dashrep-ignore-actions-on-yes-or-no" } ne "no" ) )
    {
        $remaining_string = $expanded_string ;
        $expanded_string = "" ;
        if ( ( $global_ignore_level > 0 ) && ( $remaining_string !~ /((ignore-begin-here)|(ignore-end-here))/si ) )
        {
            if ( $global_dashrep_replacement{ "dashrep-ignore-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; ignore level: " . $global_ignore_level . "}}\n" ;
                if ( $remaining_string =~ /[^ ]/ )
                {
                    $global_trace_log .= "{{trace; ignored: " . $remaining_string . "}}\n" ;
                }
            }
            $remaining_string = "" ;
        }
        while ( $remaining_string =~ /^((.*? +)?)((ignore-begin-here)|(ignore-end-here))(( +.*)?)$/si )
        {
            $code_begin = $1 ;
            $ignore_directive = $3 ;
            $remaining_string = $6 ;
            if ( $global_ignore_level > 0 )
            {
                if ( $global_dashrep_replacement{ "dashrep-ignore-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; ignore level: " . $global_ignore_level . "}}\n" ;
                    if ( $remaining_string =~ /[^ ]/ )
                    {
                        $global_trace_log .= "{{trace; ignored: " . $code_begin . "}}\n" ;
                    }
                }
            } else
            {
                $expanded_string .= $code_begin . " " ;
            }
            if ( $ignore_directive eq "ignore-begin-here" )
            {
                if ( $global_dashrep_replacement{ "dashrep-ignore-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; ignore directive: " . $ignore_directive . "}}\n" ;
                }
                $global_ignore_level ++ ;
                $global_dashrep_replacement{ "dashrep-ignore-level" } = sprintf( "%d" , $global_ignore_level ) ;
            } elsif ( $ignore_directive eq "ignore-end-here" )
            {
                if ( $global_dashrep_replacement{ "dashrep-ignore-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; ignore directive: " . $ignore_directive . "}}\n" ;
                }
                $global_ignore_level -- ;
                $global_dashrep_replacement{ "dashrep-ignore-level" } = sprintf( "%d" , $global_ignore_level ) ;
            }
        }
        $expanded_string .= $remaining_string ;
    }


#-----------------------------------------------
#  Handle the directives:
#  "capture-begin-here" and
#  "capture-end-here"

    if ( ( not( exists( $global_dashrep_replacement{ "dashrep-capture-actions-on-yes-or-no" } ) ) ) || ( $global_dashrep_replacement{ "dashrep-capture-actions-on-yes-or-no" } ne "no" ) )
    {
        $remaining_string = $expanded_string ;
        $expanded_string = "" ;
        if ( ( $global_capture_level > 0 ) && ( $remaining_string !~ /((capture-begin-here)|(capture-end-here))/si ) )
        {
            $global_dashrep_replacement{ "captured-text" } .= " " . $remaining_string ;
            if ( $global_dashrep_replacement{ "dashrep-capture-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; capture level: " . $global_capture_level . "}}\n" ;
                if ( $remaining_string =~ /[^ ]/ )
                {
                    $global_trace_log .= "{{trace; captured: " . $remaining_string . "}}\n" ;
                }
            }
            $remaining_string = "" ;
        }
        while ( $remaining_string =~ /^((.*? +)?)((capture-begin-here)|(capture-end-here))(( +.*)?)$/si )
        {
            $code_begin = $1 ;
            $capture_directive = $3 ;
            $remaining_string = $6 ;
            if ( $global_capture_level > 0 )
            {
                $global_dashrep_replacement{ "captured-text" } .= " " . $code_begin ;
                if ( $global_dashrep_replacement{ "dashrep-capture-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; capture level: " . $global_capture_level . "}}\n" ;
                    if ( $remaining_string =~ /[^ ]/ )
                    {
                        $global_trace_log .= "{{trace; captured: " . $code_begin . "}}\n" ;
                    }
                }
            } else
            {
                $expanded_string .= $code_begin . " " ;
            }
            if ( $capture_directive eq "capture-begin-here" )
            {
                $global_dashrep_replacement{ "captured-text" } = "" ;
                if ( $global_dashrep_replacement{ "dashrep-capture-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; capture directive: " . $capture_directive . "}}\n" ;
                }
                $global_capture_level ++ ;
                $global_dashrep_replacement{ "dashrep-capture-level" } = sprintf( "%d" , $global_capture_level ) ;
            } elsif ( $capture_directive eq "capture-end-here" )
            {
                if ( $global_dashrep_replacement{ "dashrep-capture-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; capture directive: " . $capture_directive . "}}\n" ;
                }
                $global_capture_level -- ;
                $global_dashrep_replacement{ "dashrep-capture-level" } = sprintf( "%d" , $global_capture_level ) ;
            }
        }
        $expanded_string .= $remaining_string ;
    }


#-----------------------------------------------
#  Handle the directive:
#  "non-breaking-space"

    $code_for_non_breaking_space = $global_dashrep_replacement{ "non-breaking-space" } ;
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
    my $input_text ;
    my $translation ;
    my $partial_translation ;
    my $source_filename ;
    my $target_filename ;
    my $source_phrase_name ;
    my $target_phrase_name ;
    my $lines_to_translate ;
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
    my $qualifier ;
    my $numeric_return_value ;
    my $full_line ;
    my $multi_line_limit ;
    my $open_brackets ;
    my $close_brackets ;
    my $multi_line_count ;
    my $xml_hyphenated_phrase ;
    my $counter ;
    my $definitions_or_phrase_names ;
    my $action_name ;
    my $object_of_action ;
    my $operand_one ;
    my $operand_two ;
    my $text_begin ;
    my $text_end ;
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
    my $operand_three ;
    my $line_ending ;
    my $line_number ;
    my $line_number_in_text ;
    my $full_path ;
    my $temp_text ;
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
    my @list_of_phrases ;
    my @phrase_naming_convention_for_column ;
    my %content_for_tag ;


#-----------------------------------------------
#  Initialization.

    $possible_error_message = "" ;


#-----------------------------------------------
#  Get the input text.

    if ( scalar( @_ ) == 1 )
    {
        $input_text = $_[ 0 ] ;
    } else
    {
        if ( ( exists( $global_dashrep_replacement{ "web-framework-in-use" } ) ) && ( $global_dashrep_replacement{ "web-framework-in-use" } eq "yes" ) )
        {
            $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "Warning: Call to File-related action subroutine does not have exactly one parameter." ;
        } else
        {
#  remove-from-cpan-version-begin
            warn "Warning: Call to File-related action subroutine does not have exactly one parameter." ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#            carp "Warning: Call to File-related action subroutine does not have exactly one parameter." ;
#  uncomment-for-cpan-version-end
        }
        return 0 ;
    }


#-----------------------------------------------
#  Get the action name and the operands.

    $action_name = "" ;
    $object_of_action = "" ;
    $operand_one = "" ;
    $operand_two = "" ;
    $operand_three = "" ;
    if ( $input_text =~ /^([^ ]+)(.*)$/ )
    {
        $action_name = $1 ;
        $object_of_action = $2 ;
        $action_name =~ s/^ +// ;
        $action_name =~ s/ +$// ;
        $action_name =~ s/^\-+// ;
        $action_name =~ s/\-+$// ;
        $object_of_action =~ s/^ +// ;
        $object_of_action =~ s/ +$// ;
        $object_of_action =~ s/^\-+// ;
        $object_of_action =~ s/\-+$// ;
        if ( $object_of_action =~ /^([^ ]+) +([^ ]+) +([^ ]+)/ )
        {
            $operand_one = $1 ;
            $operand_two = $2 ;
            $operand_three = $3 ;
        } elsif ( $object_of_action =~ /^([^ ]+) +([^ ]+)/ )
        {
            $operand_one = $1 ;
            $operand_two = $2 ;
        } elsif ( $object_of_action !~ / / )
        {
            $operand_one = $object_of_action ;
            $operand_two = "" ;
        }
    } else
    {
        $input_text = $text_begin . " " . $input_text . " " . $text_end ;
        return $input_text ;
    }
    if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
    {
        $global_trace_log .= "{{trace; action and object: " . $action_name . "  " . $object_of_action . "}}\n";
    }
    $operand_one =~ s/\t+//g ;
    $operand_two =~ s/\t+//g ;
    $operand_three =~ s/\t+//g ;
    $source_phrase_name = $operand_one ;
    $source_filename = $operand_one ;
    $target_phrase_name = $operand_two ;
    $target_filename = $operand_two ;
    if ( $operand_two eq "" )
    {
        $target_phrase_name = $operand_one ;
        $target_filename = $operand_one ;
    }
    $source_filename =~ s/^.*[\\\/]// ;
    $source_filename =~ s/^\.+// ;
    $target_filename =~ s/^.*[\\\/]// ;
    $target_filename =~ s/^\.+// ;
    if ( $source_filename ne "" )
    {
        $source_filename = $global_dashrep_replacement{ "dashrep-path-prefix-for-file-reading" } . $source_filename ;
    }
    if ( $target_filename ne "" )
    {
        $target_filename = $global_dashrep_replacement{ "dashrep-path-prefix-for-file-writing" } . $target_filename ;
    }


#-----------------------------------------------
#  Handle the actions:
#  copy-from-file-to-phrase
#  copy-from-file-to-phrases-line-numbered

    if ( ( $action_name eq "copy-from-file-to-phrase" ) || ( $action_name eq "copy-from-file-to-phrases-line-numbered" ) )
    {
        if ( ( $source_filename eq "" ) || ( $target_phrase_name eq "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $target_phrase_name . "]" ;
        } elsif ( open ( INFILE , "<" . $source_filename ) )
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
            if ( not( exists( $global_dashrep_replacement{ "dashrep-yes-indicate-line-endings" } ) ) )
            {
                $global_dashrep_replacement{ "dashrep-yes-indicate-line-endings" } = "no" ;
            }
            if ( ( exists( $global_dashrep_replacement{ "dashrep-yes-indicate-line-endings" } ) ) && ( $global_dashrep_replacement{ "dashrep-yes-indicate-line-endings" } eq "yes" ) )
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
                } elsif ( $action_name eq "copy-from-file-to-phrases-line-numbered" )
                {
                    $line_number ++ ;
                    $line_number_in_text = sprintf( "%d" , $line_number ) ;
                    $global_dashrep_replacement{ $target_phrase_name . "-" . $line_number_in_text } = $input_line ;
                    $global_dashrep_replacement{ "list-of-line-numbers-for-list-named-" . $target_phrase_name } .= " " . $line_number_in_text ;
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
        $input_text = "" ;


#-----------------------------------------------
#  Handle the actions:
#  find-line-in-file-that-begins-with-string-in-phrase-and-put-into-phrase
#  find-lines-in-file-that-begin-with-any-word-in-phrase-and-append-storage-phrase-names-to-phrase
#  find-lines-in-file-that-begin-with-any-two-words-in-phrase-and-append-storage-phrase-names-to-phrase

    } elsif ( ( $action_name eq "find-line-in-file-that-begins-with-string-in-phrase-and-put-into-phrase" ) || ( $action_name eq "find-lines-in-file-that-begin-with-any-word-in-phrase-and-append-storage-phrase-names-to-phrase" ) || ( $action_name eq "find-lines-in-file-that-begin-with-any-two-words-in-phrase-and-append-storage-phrase-names-to-phrase" ) )
    {
        $input_text = "" ;
        if ( ( $source_filename eq "" ) || ( $operand_two eq "" ) || ( $operand_three eq "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $operand_two . " and " . $operand_three . "]" ;
        } elsif ( ( $action_name eq "find-line-in-file-that-begins-with-string-in-phrase-and-put-into-phrase" ) && ( ( not( exists( $global_dashrep_replacement{ $operand_two } ) ) ) || ( $global_dashrep_replacement{ $operand_two } !~ /[^ ]/ ) ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has empty search word in phrase " . $operand_two . "]" ;
        } elsif ( ( ( $action_name eq "find-lines-in-file-that-begin-with-any-word-in-phrase-and-append-storage-phrase-names-to-phrase" ) || ( $action_name eq "find-lines-in-file-that-begin-with-any-two-words-in-phrase-and-append-storage-phrase-names-to-phrase" ) ) && ( ( not( exists( $global_dashrep_replacement{ $operand_two } ) ) ) || ( $global_dashrep_replacement{ $operand_two } !~ /[^ ]/ ) ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has no search words in phrase " . $operand_two . "]" ;
        } elsif ( open ( INFILE , "<" . $source_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [warning, file named " . $source_filename . " not found, or could not be opened]" ;
        }
        if ( $possible_error_message eq "" )
        {
            if ( $action_name eq "find-line-in-file-that-begins-with-string-in-phrase-and-put-into-phrase" )
            {
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; searching in file " . $source_filename . " for string " . $string_to_find . "}}\n" ;
                }
                $string_to_find = $global_dashrep_replacement{ $operand_two } ;
                $length_of_string = length( $string_to_find ) ;
                $input_text = "" ;
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
                @list_of_words = split( / +/ , $global_dashrep_replacement{ $operand_two } ) ;
                foreach $word ( @list_of_words )
                {
                    $matching_text{ $word } = "match" ;
                }
                $input_text = "" ;
                if ( $action_name eq "find-lines-in-file-that-begin-with-any-word-in-phrase-and-append-storage-phrase-names-to-phrase" )
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
                            $global_dashrep_replacement{ $operand_three } .= $storage_name . " " ;
                            $global_dashrep_replacement{ $storage_name } = $input_line ;
                        } else
                        {
                            if ( $input_line =~ /^[^ ]+ +([^ ]+)(( )|($))/ )
                            {
                                $second_word = $1 ;
                                if ( ( exists( $matching_text{ $second_word } ) ) && ( $matching_text{ $second_word } eq "match" ) )
                                {
                                    $storage_name = "dashrep-storage-" . sprintf( "%d" , $global_storage_number ) ;
                                    $global_storage_number ++ ;
                                    $global_dashrep_replacement{ $operand_three } .= $storage_name . " " ;
                                    $global_dashrep_replacement{ $storage_name } = $input_line ;
                                }
                            }
                        }
                    }
                }
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
        $input_text = "" ;


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
        } elsif ( open ( INFILE , "<" . $source_filename ) )
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
        $input_text = "" ;


#-----------------------------------------------
#  Handle the action:
#  put-into-phrase-list-of-files-in-current-read-directory
#  put-into-phrase-list-of-folders-in-current-read-directory
#
#  The current read directory is already specified
#  in a Dashrep phrase.

    } elsif ( ( $action_name eq "put-into-phrase-list-of-files-in-current-read-directory" ) || ( $action_name eq "put-into-phrase-list-of-folders-in-current-read-directory" ) )
    {
        $input_text = " " . $action_name . " " . $object_of_action . " " ;
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
                $input_text = "" ;
                while ( defined( $file_name = readdir( READDIR ) ) )
                {
                    if ( $file_name !~ /^\./ )
                    {
                        $full_path = $directory . $file_name ;
                        if ( $action_name eq "put-into-phrase-list-of-folders-in-current-read-directory" )
                        {
                            if ( -d $full_path )
                            {
                                $list_of_file_names .= $file_name . " " ;
                            }
                        } elsif ( $action_name eq "put-into-phrase-list-of-files-in-current-read-directory" )
                        {
                            if ( -f $full_path )
                            {
                                $list_of_file_names .= $file_name . " " ;
                            }
                        }
                    }
                }
                $list_of_file_names =~ s / +$// ;
                $global_dashrep_replacement{ $object_of_action } = $list_of_file_names ;
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
        $input_text = "" ;


#-----------------------------------------------
#  Handle the action:
#  yes-or-no-file-exists
#
#  The filename is edited to remove any path
#  specifications, and then the prefix in the
#  appropriate dashrep phrase is used.

    } elsif ( $action_name eq "yes-or-no-file-exists" )
    {
        $input_text = "" ;
        if ( ( $source_filename eq "" ) || ( $operand_two ne "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $operand_two . "]" ;
        } elsif ( open ( INFILE , "<" . $source_filename ) )
        {
            $input_text = " yes " ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; file exists: " . $source_filename . "}}\n" ;
            }
        } else
        {
            $input_text = " no " ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; file does not exist: " . $source_filename . "}}\n" ;
            }
        }
        close( INFILE ) ;


#-----------------------------------------------
#  Handle the action:
#  yes-or-no-folder-in-phrase-exists

    } elsif ( $action_name eq "yes-or-no-folder-in-phrase-exists" )
    {
        $input_text = "" ;
        if ( $operand_one ne "" )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has empty operand " . $operand_one . "]" ;
        } elsif ( -d $operand_one )
        {
            $input_text = " yes " ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; folder exists: " . $operand_one . "}}\n" ;
            }
        } else
        {
            $input_text = " no " ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; folder does not exist: " . $operand_one . "}}\n" ;
            }
        }


#-----------------------------------------------
#  Handle the action:
#  modification-time-of-file
#
#  The filename is edited to remove any path
#  specifications, and then the prefix in the
#  appropriate dashrep phrase is used.

    } elsif ( $action_name eq "modification-time-of-file" )
    {
        $input_text = "" ;
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
        $input_text = " " . $write_time . " " ;


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
        $input_text = " " . $file_size . " " ;


#-----------------------------------------------
#  Handle the action:
#  copy-from-phrase-append-to-file
#
#  The filename is edited to remove any path
#  specifications, and then the prefix in the
#  appropriate dashrep phrase is used.

    } elsif ( $action_name eq "copy-from-phrase-append-to-file" )
    {
        if ( ( $source_phrase_name eq "" ) || ( $target_filename eq "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_phrase_name . " and " . $target_filename . "]" ;
        } elsif ( $global_dashrep_replacement{ "dashrep-permission-to-append-to-files-yes-or-no" } ne "yes" )
        {
            $global_trace_log .= "{{trace; attempt to copy from phrase " . $source_phrase_name . " to end of file " . $target_filename . "}}\n" ;
            $possible_error_message .= " [warning, do not have permission to append to files]" ;
        } elsif ( open ( OUTFILE , ">>" . $target_filename ) )
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
        if ( not( chmod( $file_write_protection_mode , $target_filename ) ) )
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: protection of output file " . $target_filename . "  not successful}}\n" ;
            }
        }
        $input_text = "" ;


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
        } elsif ( $global_dashrep_replacement{ "dashrep-permission-to-delete-or-overwrite-files-yes-or-no" } ne "yes" )
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
        $input_text = "" ;


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
        } elsif ( $global_dashrep_replacement{ "dashrep-permission-to-delete-or-overwrite-files-yes-or-no" } ne "yes" )
        {
            $global_trace_log .= "{{trace; attempt to create empty file: " . $target_filename . "}}\n" ;
            $possible_error_message .= " [warning, do not have permission to delete or overwrite files]" ;
        } else
        {
            if ( open ( OUTFILE , ">" . $target_filename ) )
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
            if ( not( chmod( $file_write_protection_mode , $target_filename ) ) )
            {
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning: protection of output file " . $target_filename . "  not successful}}\n" ;
                }
            }
        }
        $input_text = "" ;


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
        } elsif ( $global_dashrep_replacement{ "dashrep-permission-to-delete-or-overwrite-files-yes-or-no" } ne "yes" )
        {
            $global_trace_log .= "{{trace; attempt to create empty folder: " . $global_dashrep_replacement{ "dashrep-path-prefix-for-file-writing" } . "}}\n" ;
            $possible_error_message .= " [warning, do not have permission to create files or folders]" ;
        } else
        {
            $target_sub_folder = $global_dashrep_replacement{ "dashrep-path-prefix-for-file-writing" } . $target_sub_folder ;
            if ( $target_sub_folder =~ /([\/\\])/ )
            {
                $slash_or_backslash_for_path = $1 ;
            } else
            {
                $slash_or_backslash_for_path = '/' ;
            }
            $target_sub_folder .= $slash_or_backslash_for_path ;
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
        $input_text = "" ;


#-----------------------------------------------
#  Handle the action:
#  expand-phrase-to-file
#
#  The filename is edited to remove any path
#  specifications, and then the prefix in the
#  appropriate dashrep phrase is used.
#
#  Do not allow any other file-related action to
#  be used during this action.

    } elsif ( $action_name eq "expand-phrase-to-file" )
    {
        if ( ( $source_phrase_name eq "" ) || ( $target_filename eq "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_phrase_name . " and " . $target_filename . "]" ;
        } elsif ( $global_dashrep_replacement{ "dashrep-permission-to-delete-or-overwrite-files-yes-or-no" } ne "yes" )
        {
            $possible_error_message .= " [warning, do not have permission to delete or overwrite files]" ;
        } else
        {
            if ( open ( OUTFILE , ">" . $target_filename ) )
            {
                $possible_error_message .= "" ;
            } else
            {
                $possible_error_message .= " [warning, file named " . $target_filename . " could not be opened for writing]" ;
            }
            if ( $possible_error_message eq "" )
            {
                $global_nesting_level_of_file_actions ++ ;
                if ( $global_nesting_level_of_file_actions > 1 )
                {
                    $possible_error_message .= " [warning, file-related action called recursivley, which is not allowed]" ;
                }
                $partial_translation = &dashrep_expand_parameters( $source_phrase_name );
                if ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; after parameters expanded: " . $partial_translation . "}}\n" ;
                }
                $translation = &dashrep_expand_phrases( $partial_translation );
                $global_nesting_level_of_file_actions -- ;
                print OUTFILE $translation . "\n" ;
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; expanded phrase " . $source_phrase_name . " to file " . $target_filename . "}}\n" ;
                }
            } else
            {
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
                }
            }
            close( OUTFILE ) ;
            if ( not( chmod( $file_write_protection_mode , $target_filename ) ) )
            {
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning: protection of output file " . $target_filename . "  not successful}}\n" ;
                }
            }
        }
        $input_text = "" ;


#-----------------------------------------------
#  Handle the action:
#  linewise-translate-xml-tags-in-file-to-dashrep-phrases-in-file
#
#  The filename is edited to remove any path
#  specifications, and then the prefix in the
#  appropriate dashrep phrase is used.
#
#  If a tag does not end on the same line as it
#  starts, more lines are read in an attempt
#  to reach the end of the tag, but this
#  capability is not robust.  This is done to
#  accomodate XHTML generated by the "Tidy"
#  utility.

    } elsif ( $action_name eq "linewise-translate-xml-tags-in-file-to-dashrep-phrases-in-file" )
    {
        $global_nesting_level_of_file_actions ++ ;
        if ( ( $source_filename eq "" ) || ( $target_filename eq "" ) || ( $source_filename eq $target_filename ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $target_filename . "]" ;
        } elsif ( $global_nesting_level_of_file_actions > 1 )
        {
            $possible_error_message .= " [warning, file-related action called recursivley, which is not allowed]" ;
        } elsif ( $global_dashrep_replacement{ "dashrep-permission-to-delete-or-overwrite-files-yes-or-no" } ne "yes" )
        {
            $possible_error_message .= " [warning, do not have permission to delete or overwrite files]" ;
        }
        if ( $possible_error_message eq "" )
        {
            if ( open ( INFILE , "<" . $source_filename ) )
            {
                $possible_error_message .= "" ;
            } else
            {
                $possible_error_message .= " [warning, file named " . $source_filename . " not found, or could not be opened]" ;
            }
            if ( $possible_error_message eq "" )
            {
                if ( open ( OUTFILE , ">" . $target_filename ) )
                {
                    $possible_error_message .= "" ;
                } else
                {
                    $possible_error_message .= " [warning, file named " . $target_filename . " could not be opened for writing]" ;
                }
            }
            if ( $possible_error_message eq "" )
            {
                $full_line = "" ;
                $multi_line_limit = 100 ;
                $multi_line_count = 0 ;
                while ( $input_line = <INFILE> )
                {
                    chomp( $input_line ) ;
                    $input_line =~ s/[\n\r\f\t]+/ /g ;
                    if ( $full_line ne "" )
                    {
                        $full_line = $full_line . " " . $input_line ;
                    } else
                    {
                        $full_line = $input_line ;
                    }
                    if ( ( $full_line =~ /<!\[CDATA\[/ ) && ( $full_line !~ /<!\[CDATA\[.*\]\]>/ ) )
                    {
                        next ;
                    } else
                    {
                        $open_brackets = $full_line ;
                        $close_brackets = $full_line ;
                        $open_brackets =~ s/[^<]//sg ;
                        $close_brackets =~ s/[^>]//sg ;
                        if ( ( length( $open_brackets ) != length( $close_brackets ) ) && ( $multi_line_count < $multi_line_limit ) )
                        {
                            next ;
                        }
                    }
                    if ( $global_dashrep_replacement{ "dashrep-xml-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; accumulated text to convert: " . $full_line . "}}\n" ;
                    }
                    $global_endless_loop_counter = 0 ;
                    %global_replacement_count_for_item_name = ( ) ;
                    $translation = &dashrep_xml_tags_to_dashrep( $full_line );
                    print OUTFILE $translation . "\n" ;
                    $full_line = "" ;
                }
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; source xml file named " . $source_filename . " expanded into dashrep phrases in file named " . $target_filename . "}}\n" ;
                }
                $global_dashrep_replacement{ "dashrep-list-of-xml-phrases" } = "" ;
                foreach $xml_hyphenated_phrase ( sort( keys ( %global_exists_xml_hyphenated_phrase ) ) )
                {
                    $global_dashrep_replacement{ "dashrep-list-of-xml-phrases" } .= $xml_hyphenated_phrase . " " ;
                }
            } else
            {
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning, failed to expand source xml file named " . $source_filename . " into dashrep phrases in file named " . $target_filename . "}}\n" ;
                }
            }
            close( INFILE ) ;
            close( OUTFILE ) ;
            if ( not( chmod( $file_write_protection_mode , $target_filename ) ) )
            {
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning: protection of output file " . $target_filename . "  not successful}}\n" ;
                }
            }
        }
        $global_nesting_level_of_file_actions -- ;
        $input_text = "" ;


#-----------------------------------------------
#  Handle the action:
#  copy-from-columns-in-file-to-named-phrases

    } elsif ( $action_name eq "copy-from-columns-in-file-to-named-phrases" )
    {
        if ( ( $source_filename eq "" ) || ( $operand_two eq "" ) || ( $operand_three eq "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $operand_two . " and " . $operand_three . "]" ;
        } elsif ( open ( INFILE , "<" . $source_filename ) )
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
            $temp_text =~ s/ +$// ;
            @phrase_naming_convention_for_column = split( / +/ , $temp_text ) ;
            $number_of_column_names = scalar( @phrase_naming_convention_for_column ) ;
            $prefix_text = $phrase_naming_convention_for_column[ 0 ] ;
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
            if ( ( exists( $global_dashrep_replacement{ "dashrep-use-two-spaces-as-column-delimiter" } ) ) && ( $global_dashrep_replacement{ "dashrep-use-two-spaces-as-column-delimiter" } eq "yes" ) )
            {
                $use_two_spaces_as_delimiter = "yes" ;
            } else
            {
                $use_two_spaces_as_delimiter = "no" ;
            }
            while ( $input_line = <INFILE> )
            {
                chomp( $input_line ) ;
                $input_line =~ s/ +$// ;
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
                        if ( $column_pointer <= $number_of_columns )
                        {
                            $phrase_naming_convention_for_this_column = $prefix_text . "-" . $unique_value . "-" . $phrase_naming_convention_for_column[ $column_pointer - 1 ] ;
                            $global_dashrep_replacement{ $phrase_naming_convention_for_this_column } = $text_item_in_column[ $column_pointer - 1 ] ;
                        } else
                        {
                            $phrase_naming_convention_for_this_column = $prefix_text . "-" . $unique_value . "-" . $phrase_naming_convention_for_column[ $column_pointer - 1 ] ;
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
        $input_text = "" ;


#-----------------------------------------------
#  Handle the action:
#  gather-tagged-info-from-file-and-put-unique-values-into-phrase

    } elsif ( $action_name eq "gather-tagged-info-from-file-and-put-unique-values-into-phrase" )
    {
        if ( ( $source_filename eq "" ) || ( $target_phrase_name eq "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $target_phrase_name . "]" ;
        } elsif ( open ( INFILE , "<" . $source_filename ) )
        {
            $possible_error_message .= "" ;
        } else
        {
            $possible_error_message .= " [warning, file named " . $source_filename . " not found, or could not be opened]" ;
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
            $unique_value = "" ;
            %content_for_tag = ( ) ;
            %found_unique_value = ( ) ;
            $line_status = "between" ;
            while ( $input_line = <INFILE> )
            {
                chomp( $input_line ) ;
                if ( $input_line =~ /^ *([^ ]+) *$/ )
                {
                    $first_word = $1 ;
                    if ( $first_word eq $entry_end )
                    {
                        if ( $line_status eq "within" )
                        {
                            if ( $unique_value =~ /^[^ ]+$/ )
                            {
                                foreach $tag_name ( keys( %content_for_tag ) )
                                {
                                    $global_dashrep_replacement{ $tag_name . "-value-for-unique-id-" . $unique_value } = $content_for_tag{ $tag_name } ;
                                }
                            } else
                            {
                                $global_trace_log .= " [warning, action " . $action_name . " encountered a set of items that do not contain a unique value, so no definitions were created for this set of items]" ;
                            }
                        } elsif ( $line_status eq "within_multiline" )
                        {
                            $global_trace_log .= " [warning, action " . $action_name . " encountered the end of a set of items without first encountering the end of a multi-line item; the items in this set have not been added]" ;
                        } else
                        {
                            $global_trace_log .= " [warning, action " . $action_name . " encountered the end of a set of items without first encountering the tag at the beginning; the items in this set have not been added]" ;
                        }
                        $unique_value = "" ;
                        %content_for_tag = ( ) ;
                        $line_status = "between" ;
                    } elsif ( $first_word eq $entry_begin )
                    {
                        if ( $line_status eq "between" )
                        {
                            $unique_value = "" ;
                            %content_for_tag = ( ) ;
                            $line_status = "within" ;
                        } else
                        {
                            $global_trace_log .= " [warning, action " . $action_name . " encountered the beginning of a set of items without first encountering the tag at the end of the previous set of items]" ;
                        }
                    } elsif ( $first_word eq "multi_line_end" )
                    {
                        $line_status = "within" ;
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
                        $unique_value =~ s/ +/_/g ;
                        if ( not( exists( $found_unique_value{ $unique_value } ) ) )
                        {
                            $found_unique_value{ $unique_value } = "found" ;
                        }
                    } elsif ( $remainder_of_line =~ /^ *multi_line_begin/ )
                    {
                        $line_status = "within_multiline" ;
                        $multiline_value_name = $first_word ;
                        $content_for_tag{ $multiline_value_name } = "" ;
                    } else
                    {
                        $content_for_tag{ $first_word } = $remainder_of_line ;
                    }
                }
            }
            $list_of_unique_values = "" ;
            foreach $unique_value ( keys( %found_unique_value ) )
            {
                $list_of_unique_values .= " " . $unique_value ;
            }
            $list_of_unique_values =~ s/^ +// ;
            $global_dashrep_replacement{ $target_phrase_name } = $list_of_unique_values ;
            if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; gathered tagged info from file " . $source_filename . " to various phrase names, and unique values put into phrase " . $target_phrase_name . "}}\n" ;
            }
        } else
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
            }
        }
        close( INFILE ) ;
        $input_text = "" ;


#-----------------------------------------------
#  Handle the action:
#  linewise-read-from-file-and-use-template

    } elsif ( $action_name eq "linewise-read-from-file-and-use-template" )
    {
        if ( ( $source_filename eq "" ) || ( $target_phrase_name eq "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $target_phrase_name . "]" ;
        } elsif ( open ( INFILE , "<" . $source_filename ) )
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
                    $global_dashrep_replacement{ "storage-input-line-from-file" } = $input_line ;
                    $global_dashrep_replacement{ "input-line-count" } = $line_count ;
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
                $global_trace_log .= "{{trace; processed each line in file " . $source_filename . " using template " . $target_phrase_name . "}}\n" ;
            }
        } else
        {
            if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
            {
                $global_trace_log .= "{{trace; warning: " . $possible_error_message . "}}\n" ;
            }
        }
        close( INFILE ) ;
        $input_text = "" ;


#-----------------------------------------------
#  End of branching.

    }


#-----------------------------------------------
#  Handle the actions:
#  linewise-translate-from-file-to-file and
#  linewise-translate-parameters-only-from-file-to-file
#  linewise-translate-phrases-only-from-file-to-file
#  linewise-translate-special-phrases-only-from-file-to-file
#
#  The filename is edited to remove any path
#  specifications, and then the prefix in the
#  appropriate dashrep phrase is used.
#
#  If there are Dashrep definitions, get them.
#
#  Do not allow any other file-related action to
#  be used during this action.

    $qualifier = "" ;
    if ( $action_name eq "linewise-translate-from-file-to-file" )
    {
        $qualifier = "normal" ;
    } elsif ( $action_name eq "linewise-translate-parameters-only-from-file-to-file" )
    {
        $qualifier = "parameters-only" ;
    } elsif ( $action_name eq "linewise-translate-phrases-only-from-file-to-file" )
    {
        $qualifier = "phrases-only" ;
    } elsif ( $action_name eq "linewise-translate-special-phrases-only-from-file-to-file" )
    {
        $qualifier = "special-phrases-only" ;
    }
    if ( $qualifier ne "" )
    {
        $global_nesting_level_of_file_actions ++ ;
        if ( ( $source_filename eq "" ) || ( $target_filename eq "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $source_filename . " and " . $target_filename . "]" ;
        } elsif ( $global_nesting_level_of_file_actions > 1 )
        {
            $possible_error_message .= " [warning, file-related action called recursivley, which is not allowed]" ;
        } elsif ( $global_dashrep_replacement{ "dashrep-permission-to-delete-or-overwrite-files-yes-or-no" } ne "yes" )
        {
            $possible_error_message .= " [warning, do not have permission to delete or overwrite files]" ;
        }
        if ( $possible_error_message eq "" )
        {
            if ( open ( INFILE , "<" . $source_filename ) )
            {
                $possible_error_message .= "" ;
            } else
            {
                if ( -e $source_filename )
                {
                    $possible_error_message .= " [warning, file named " . $source_filename . " exists, but could not be opened]" ;
                } else
                {
                    $possible_error_message .= " [warning, file named " . $source_filename . " not found]" ;
                }
            }
            if ( open ( OUTFILE , ">" . $target_filename ) )
            {
                $possible_error_message .= "" ;
            } else
            {
                $possible_error_message .= " [warning, file named " . $target_filename . " could not be opened for writing]" ;
            }
            if ( $possible_error_message eq "" )
            {
                $global_ignore_level = 0 ;
                $global_capture_level = 0 ;
                $global_top_line_count_for_insert_phrase = 0 ;
                while ( $input_line = <INFILE> )
                {
                    chomp( $input_line ) ;
                    $input_line =~ s/[\n\r\f\t]+/ /g ;
                    $global_endless_loop_counter = 0 ;
                    %global_replacement_count_for_item_name = ( ) ;
                    $lines_to_translate = 1 ;
                    while ( $lines_to_translate > 0 )
                    {
                        if ( $input_line =~ /^ *dashrep-definitions-begin *$/ )
                        {
                            $all_lines = "" ;
                            $line_count = 0 ;
                            while ( $input_line = <INFILE> )
                            {
                                chomp( $input_line ) ;
                                $input_line =~ s/[\n\r\f\t]+/ /g ;
                                if ( $input_line =~ /^ *dashrep-definitions-end *$/ )
                                {
                                    last ;
                                }
                                if ( ( $input_line =~ /[^ ]/ ) && ( defined( $input_line ) ) )
                                {
                                    $all_lines .= $input_line . " " ;
                                }
                                $line_count ++ ;
                            }
                            if ( $all_lines =~ /[^ ]/ )
                            {
                                $numeric_return_value = &dashrep_import_replacements( $all_lines ) ;
                                if ( ( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } eq "yes" ) && ( $input_line =~ /[^ ]/ ) )
                                {
                                    $global_trace_log .= "{{trace; definitions found, imported " . $numeric_return_value . " definitions from " . $line_count . " lines}}\n" ;
                                }
                            }
                            $lines_to_translate = 0 ;
                        } else
                        {
                            $lines_to_translate = 0 ;
                            if ( $qualifier eq "-parameters-only" )
                            {
                                $translation = &dashrep_expand_parameters( $input_line );
                            } elsif ( $qualifier eq "-phrases-only" )
                            {
                                $translation = &dashrep_expand_phrases( $input_line );
                            } elsif ( $qualifier eq "-special-phrases-only" )
                            {
                                $translation = &dashrep_expand_special_phrases( $input_line );
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
                }
                if ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; linewise translated from file " . $source_filename . " to file " . $target_filename . "}}\n" ;
                }
            } else
            {
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; failed to linewise translate from file " . $source_filename . " to file " . $target_filename . "}}\n" ;
                }
            }
            close( INFILE ) ;
            close( OUTFILE ) ;
            if ( not( chmod( $file_write_protection_mode , $target_filename ) ) )
            {
                if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                {
                    $global_trace_log .= "{{trace; warning: protection of output file " . $target_filename . "  not successful}}\n" ;
                }
            }
        }
        $global_nesting_level_of_file_actions -- ;
        $input_text = "" ;
    }


#-----------------------------------------------
#  Handle the actions:
#  write-all-dashrep-definitions-to-file
#  write-all-dashrep-phrase-names-to-file
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
            @list_of_phrases = split( / +/ , $global_dashrep_replacement{ $source_phrase_name } ) ;
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
        }
    } elsif ( $action_name eq "write-all-dashrep-phrase-names-to-file" )
    {
        if ( ( $target_filename eq "" ) || ( $operand_two ne "" ) )
        {
            $possible_error_message .= " [warning, action " . $action_name . " has invalid operands " . $target_filename . " and " . $operand_two . "]" ;
        } else
        {
            $definitions_or_phrase_names = "phrase-names" ;
            @list_of_phrases = &dashrep_get_list_of_phrases( ) ;
            @sequence_of_phrases = sort( @list_of_phrases ) ;
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
            } elsif ( $global_dashrep_replacement{ "dashrep-permission-to-delete-or-overwrite-files-yes-or-no" } ne "yes" )
            {
                $possible_error_message .= " [warning, do not have permission to delete or overwrite files]" ;
            }
            if ( $global_dashrep_replacement{ "dashrep-yes-or-no-export-delimited-definitions" } eq "yes" )
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
                if ( open ( OUTFILE , ">" . $target_filename ) )
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
                if ( not( chmod( $file_write_protection_mode , $target_filename ) ) )
                {
                    if ( $global_dashrep_replacement{ "dashrep-warning-trace-on-yes-or-no" } eq "yes" )
                    {
                        $global_trace_log .= "{{trace; warning: protection of output file " . $target_filename . "  not successful}}\n" ;
                    }
                }
            }
            $global_nesting_level_of_file_actions -- ;
        }
        $input_text = "" ;
    }


#-----------------------------------------------
#  If there was an error message, put it
#  into the text that is returned (and remove
#  the action that caused the error).

    $possible_error_message =~ s/^ +// ;
    $possible_error_message =~ s/ +$// ;
    if ( $possible_error_message =~ /[^ ]/ )
    {
        $input_text = $possible_error_message ;
    }


#-----------------------------------------------
#  Make the logged debugging (trace) information
#  available.

    $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= $global_trace_log ;
    $global_trace_log = "" ;


#-----------------------------------------------
#  Return, possibly with an error message.

    return $input_text ;


#-----------------------------------------------
#  End of subroutine.

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
        if ( ( exists( $global_dashrep_replacement{ "web-framework-in-use" } ) ) && ( $global_dashrep_replacement{ "web-framework-in-use" } eq "yes" ) )
        {
            $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "Warning: Call to xml_tags_to_dashrep subroutine does not have exactly one parameter." ;
        } else
        {
#  remove-from-cpan-version-begin
            warn "Warning: Call to xml_tags_to_dashrep subroutine does not have exactly one parameter." ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#            carp "Warning: Call to xml_tags_to_dashrep subroutine does not have exactly one parameter." ;
#  uncomment-for-cpan-version-end
        }
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
#  TODO: Insert "begin-xml-tag-parameters" and
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
            if ( ( exists( $global_dashrep_replacement{ "web-framework-in-use" } ) ) && ( $global_dashrep_replacement{ "web-framework-in-use" } eq "yes" ) )
            {
                $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "Warning: The dashrep_xml_tags_to_dashrep subroutine has encountered an endless loop." . "\n" . "Stopped" ;
            } else
            {
#  remove-from-cpan-version-begin
                warn "Warning: The dashrep_xml_tags_to_dashrep subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#                carp "Warning: The dashrep_xml_tags_to_dashrep subroutine has encountered an endless loop." . "\n" . "Stopped" ;
#  uncomment-for-cpan-version-end
            }
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
        if ( ( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } eq "yes" ) && ( $input_line =~ /[^ ]/ ) )
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
                if ( ( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } eq "yes" ) && ( $input_line =~ /[^ ]/ ) )
                {
                    print "{{trace; definition line: " . $input_line . " ; imported " . $numeric_return_value . " definitions from " . $line_count . " lines}}\n" ;
                }
            }


#-----------------------------------------------
#  If this line begins a multi-line comment,
#  ignore all the comment lines.

        } elsif ( $input_line =~ /^ *\*---+ *$/ )
        {
            if ( ( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } eq "yes" ) && ( $input_line =~ /[^ ]/ ) )
            {
                print "{{trace; linewise comment begins: " . $input_line . "}}\n" ;
            }
            while ( $input_line = <STDIN> )
            {
                chomp( $input_line );
                $input_line =~ s/[\n\r\f\t]+/ /g ;
                if ( $input_line =~ /^ *---+\* *$/ )
                {
                    if ( ( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } eq "yes" ) && ( $input_line =~ /[^ ]/ ) )
                    {
                        print "{{trace; linewise comment ends: " . $input_line . "}}\n" ;
                    }
                    last;
                }
                if ( ( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } eq "yes" ) && ( $input_line =~ /[^ ]/ ) )
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
            if ( ( $global_dashrep_replacement{ "dashrep-linewise-trace-on-yes-or-no" } eq "yes" ) && ( $after_possible_action =~ /^ *$/ ) && ( $revised_text =~ /[^ ]/ ) )
            {
                print "{{trace; line after action executed: " . $after_possible_action . "}}\n" ;
            }
            if ( ( $global_dashrep_replacement{ "dashrep-debug-trace-on-yes-or-no" } eq "yes" ) || ( $global_dashrep_replacement{ "dashrep-action-trace-on-yes-or-no" } eq "yes" ) )
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



=head2 dashrep_web_framework

Reads Dashrep code and does the specified Dashrep
actions and expansions, and then the resulting
web page is returned.
If the Dashrep code is not directly supplied
prior to calling this subroutine, that codes
comes from a local file, the default name for
which is "dashdef_bootstrap.txt".
If the resulting page does not look like a web page,
an error web page is returned, and the error page
includes an error number that indicates which
error file contains the error details.  That
error file is put into the subdirectory specified
as the only parameter passed to this subroutine
(and typically would be "errors"), or else is
put into the local directory.

=cut

#-----------------------------------------------
#-----------------------------------------------
#         dashrep_web_framework
#-----------------------------------------------
#-----------------------------------------------

sub dashrep_web_framework
{

    my $generated_web_page ;
    my $error_file_name ;
    my $emergency_page ;
    my $phrase_name ;
    my $definition ;
    my $error_file_prefix ;
    my $time_in_epoch_seconds ;
    my $last_digits_of_epoch_seconds ;
    my $intermediate_results ;
    my $results_before_generating_web_page ;
    my $results_after_generating_web_page ;
    my $path_to_file_containing_definitions ;
    my $file_containing_definitions ;
    my $phrase_to_expand ;
    my $bootstrap_results ;


#-----------------------------------------------
#  Specify that the web framework is being used,
#  so that error messages are not written to
#  the standard output, or to the error output.

    $global_dashrep_replacement{ "web-framework-in-use" } = "yes" ;


#-----------------------------------------------
#  As the default, supply trace messages for
#  the web framework.  After debugging a new
#  website, and before expecting high-volume
#  demand, turn off these trace messages from
#  within the Dashrep code.  If needed to debug
#  some portions of Dashrep code, turn on these
#  messages just before the problematic code.

    $global_dashrep_replacement{ "dashrep-web-framework-trace-on-yes-or-no" } = "yes" ;


#-----------------------------------------------
#  If specified -- as the only parameter passed
#  to this subroutine -- get a path for a possible
#  error file.  Otherwise use a default of a
#  sub-directory named "errors".

    $error_file_prefix = "errors\\" ;
    if ( scalar( @_ ) == 1 )
    {
        if ( $_[ 0 ] =~ /^[^ ]+[\\\/]$/ )
        {
            $error_file_prefix = $_[ 0 ] ;
        }
    }


#-----------------------------------------------
#  If the phrases "do-before-generating-web-page"
#  and "generated-web-page" are both empty (or
#  undefined), determine which file to read for
#  the Dashrep definitions, and then load the
#  Dashrep definitions from the specified file.

    if ( ( ( exists( $global_dashrep_replacement{ "do-before-generating-web-page" } ) ) && ( $global_dashrep_replacement{ "do-before-generating-web-page" } =~ /[^ ]/ ) ) || ( ( exists( $global_dashrep_replacement{ "generated-web-page" } ) ) && ( $global_dashrep_replacement{ "generated-web-page" } =~ /[^ ]/ ) ) )
    {
        if ( $global_dashrep_replacement{ "dashrep-web-framework-trace-on-yes-or-no" } eq "yes" )
        {
            $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "\n======\n" . "Either do-before-generating-web-page or generated-web-page phrase is defined and non-empty, so not getting definitions from file(s)" . "\n======\n\n" ;
        }
    } else
    {
        $path_to_file_containing_definitions = "" ;
        $file_containing_definitions = "dashdef_bootstrap.txt" ;
        if ( ( exists( $global_dashrep_replacement{ "filename-for-initial-dashrep-definitions" } ) ) && ( $global_dashrep_replacement{ "filename-for-initial-dashrep-definitions" } =~ /^[^ ]+$/ ) )
        {
            $file_containing_definitions = $global_dashrep_replacement{ "filename-for-initial-dashrep-definitions" } ;
        }
        if ( ( exists( $global_dashrep_replacement{ "path-to-initial-dashrep-definitions" } ) ) && ( $global_dashrep_replacement{ "path-to-initial-dashrep-definitions" } =~ /^[^ ]+$/ ) )
        {
            $path_to_file_containing_definitions = $global_dashrep_replacement{ "path-to-initial-dashrep-definitions" } ;
        }
        if ( $file_containing_definitions =~ /^[^ ]+$/ )
        {
            $phrase_to_expand = "[-dashrep-path-prefix-for-file-reading = " . $path_to_file_containing_definitions . "-][-get-definitions-from-file " . $file_containing_definitions . "-]" ;
            $bootstrap_results = &dashrep_expand_parameters( $phrase_to_expand );
            if ( $global_dashrep_replacement{ "dashrep-web-framework-trace-on-yes-or-no" } eq "yes" )
            {
                $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "\n======\n" . "Got definitions from bootstrap file:\n\n" . $path_to_file_containing_definitions . "\n======\n\n" . "Results from bootstrap:\n\n" . $bootstrap_results . "\n======\n\n" ;
            }
        }
    }


#-----------------------------------------------
#  Do the processing needed before generating a
#  web page.  Typically this processing interprets
#  what the user has requested.  It might involve
#  loading additional Dashrep definitions.

    $phrase_to_expand = "[-do-before-generating-web-page-]" ;
    $intermediate_results = &dashrep_expand_parameters( $phrase_to_expand );
    $results_before_generating_web_page = &dashrep_expand_phrases( $intermediate_results );
    if ( $global_dashrep_replacement{ "dashrep-web-framework-trace-on-yes-or-no" } eq "yes" )
    {
        $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "Results from processing done before generating web page:\n\n" . $results_before_generating_web_page . "\n======\n\n" ;
    }


#-----------------------------------------------
#  Generate the web page by expanding the
#  definition of the phrase "generated-web-page".
#
#  If the endless loop counter has exceeded its
#  limit, allow an additional 10000 loops for this
#  step, so that a web page can still be delivered.

    if ( $global_endless_loop_counter >= $global_endless_loop_counter_limit )
    {
        $global_endless_loop_counter = $global_endless_loop_counter_limit - 10000 ;
    }
    $phrase_to_expand = "[-generated-web-page-]" ;
    $intermediate_results = &dashrep_expand_parameters( $phrase_to_expand );
    $global_dashrep_replacement{ "web-framework-generated-web-page" } = &dashrep_expand_phrases( $intermediate_results );
    if ( ( $global_dashrep_replacement{ "dashrep-web-framework-trace-on-yes-or-no" } eq "yes" ) && ( $global_dashrep_replacement{ "dashrep-omit-web-page-from-trace-log-yes-or-no" } ne "yes" ) )
    {
        $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "Generated web page:\n\n" . $global_dashrep_replacement{ "web-framework-generated-web-page" } . "\n======\n\n" ;
    }


#-----------------------------------------------
#  Do any additional processing needed, such as
#  writing the trace messages, and expanding
#  translation-safe phrases into their HTML-safe
#  definitions.
#
#  If the endless loop counter has exceeded its
#  limit, allow an additional 1000 loops for this
#  step, so that a web page can still be delivered.

    if ( $global_endless_loop_counter >= $global_endless_loop_counter_limit )
    {
        $global_endless_loop_counter = $global_endless_loop_counter_limit - 1000 ;
    }
    $phrase_to_expand = "[-do-after-generating-web-page-]" ;
    $intermediate_results = &dashrep_expand_parameters( $phrase_to_expand );
    $results_after_generating_web_page = &dashrep_expand_phrases( $intermediate_results );
    if ( $global_dashrep_replacement{ "dashrep-web-framework-trace-on-yes-or-no" } eq "yes" )
    {
        $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "Results from processing done after generating web page:\n\n" . $results_after_generating_web_page . "\n======\n\n" ;
    }


#-----------------------------------------------
#  If the generated web page looks reasonable,
#  return with it.  The page is sent to the
#  browser with a simple "print" command.

    $generated_web_page = $global_dashrep_replacement{ "web-framework-generated-web-page" } ;
    if ( ( ( $generated_web_page =~ /^Content.type. +text.html/si ) && ( $generated_web_page =~ /<html>.*<body.*>/si ) ) || ( $generated_web_page =~ /^HTTP/si ) )
    {
        return $generated_web_page ;


#-----------------------------------------------
#  If the result does not look like a valid
#  web page, generate an error web page and
#  write debugging information to a text file
#  in the specified "errors" directory, and
#  return with that web page instead of the
#  generated one.

    } else
    {
        $time_in_epoch_seconds = time ;
        $last_digits_of_epoch_seconds = substr( sprintf( "%d" , $time_in_epoch_seconds ) , -3 ) ;
        $error_file_name = $error_file_prefix . "error_" . $last_digits_of_epoch_seconds . ".txt" ;
        $emergency_page ="Content-type: text\/html\n\n<html>\n<head>\n<title>Major error<\/title>\n<\/head>\n<body>\n<h1>Major error<\/h1>\n<p>A major error has been encountered.&nbsp; Please use the BACK button on your browser and try again.&nbsp; If this error happens again, please contact technical support and give them this error number: " . $last_digits_of_epoch_seconds . "<\/p>\n<\/body>\n<\/html>\n";
        open ( ERRFILE , ">" . $error_file_name ) ;
        print ERRFILE "generated web page:\n" ;
        print ERRFILE "----------  begin  ----------\n" ;
        print ERRFILE $generated_web_page ;
        print ERRFILE "\n" ;
        print ERRFILE "----------  end    ----------\n" ;
        print ERRFILE "\n\n" ;
        print ERRFILE "--------------------\n" ;
        print ERRFILE "Definition of dashrep-debug-trace-log phrase is shown below. To get more information, turn on trace settings.\n" ;
        print ERRFILE "--------------------\n" ;
        print ERRFILE "\n\n" ;
        $phrase_name = "dashrep-debug-trace-log" ;
        $definition = &dashrep_get_replacement( $phrase_name ) ;
        print ERRFILE $definition ;
        print ERRFILE "\n" ;
        close ERRFILE ;
        chmod( $file_write_protection_mode , $error_file_name ) ;
        return $emergency_page;
    }


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
        if ( $replacement_count > 10 )
        {
            $endless_loop_replacements_with_count{ sprintf( "%d" , $replacement_count ) } .= $item_name . "\n" ;
        }
    }

    if ( $highest_usage_item_name =~ / / )
    {
        @list_of_phrases = &dashrep_get_list_of_phrases( ) ;
        $endless_loop_debug_info_filename = "output_endless_loop_debug_info.txt" ;
        if ( open ( OUTFILE , ">" . $endless_loop_debug_info_filename ) )
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
            chmod( $file_write_protection_mode , $endless_loop_debug_info_filename ) ;
        }
    }

    if ( ( exists( $global_dashrep_replacement{ "web-framework-in-use" } ) ) && ( $global_dashrep_replacement{ "web-framework-in-use" } eq "yes" ) )
    {
        $global_dashrep_replacement{ "dashrep-debug-trace-log" } .= "Too many cycles of replacement (" . $global_endless_loop_counter . ").\n" . "Hyphenated phrase with highest replacement count (" . $highest_usage_counter . ") is:\n" . "    " . $highest_usage_item_name . "\n" ;
    } else
    {
#  remove-from-cpan-version-begin
        warn "Too many cycles of replacement (" . $global_endless_loop_counter . ").\n" . "Hyphenated phrase with highest replacement count (" . $highest_usage_counter . ") is:\n" . "    " . $highest_usage_item_name . "\n" ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
#        carp "Too many cycles of replacement (" . $global_endless_loop_counter . ").\n" . "Hyphenated phrase with highest replacement count (" . $highest_usage_counter . ") is:\n" . "    " . $highest_usage_item_name . "\n" ;
#  uncomment-for-cpan-version-end
    }


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

Copyright 2009 through 2013 Richard Fobes at www.Dashrep.org, all rights reserved.

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
