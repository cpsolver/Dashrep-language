#  Test the dashrep_translate.pm module

#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# #!perl -T

# use strict;
# use warnings;
# use Test::More tests => 2;

# BEGIN {

# use_ok('Language::Dashrep');


#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin

use dashrep_translate;



BEGIN {


#  remove-from-cpan-version-end
#-------------------------------------------
#  Declare variables.

my $results_text;
my $phrase_name;
my $numeric_return_value;
my $string_return_value;
my $list_count;
my $one_if_ok;
my $dashrep_code;
my $content_with_expanded_parameters;
my $html_code;
my $captured_text;
my $being_tested;
my $test_OK_counter;
my $test_number_count;
my $prior_list_count;
my $pointer;
my $accumulated_string;
my $test_failed_counter;
my $filename;
my @string_array_return_value;

$test_number_count = 0;
$test_OK_counter = 0;
$results_text = "";


#-------------------------------------------
#  Test defining a hyphenated phrase
#  to be associated with its replacement text.

$being_tested = "defined hyphenated phrase -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$numeric_return_value = &dashrep_translate::dashrep_define( "page-name" , "name of page" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $numeric_return_value = &dashrep_define( "page-name" , "name of page" );
#  uncomment-for-cpan-version-end
if ( $numeric_return_value eq 1 ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test getting defined hyphenated phrase.

$being_tested = "retrieved replacement text -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "page-name" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "page-name" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "name of page" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "attempt to retrieve undefined phrase -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "phrase-not-defined" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "phrase-not-defined" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test defining second phrase and then
#  getting list of all defined phrases.

#  remove-from-cpan-version-begin
@string_array_return_value = &dashrep_translate::dashrep_get_list_of_phrases;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# @string_array_return_value = &dashrep_get_list_of_phrases;
#  uncomment-for-cpan-version-end
$prior_list_count = $#string_array_return_value + 1;

$being_tested = "defined hyphenated phrase -- ";
$test_number_count ++;
if ( $numeric_return_value eq 1 ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
#  remove-from-cpan-version-begin
$numeric_return_value = &dashrep_translate::dashrep_define( "page-name-second" , "name of second page" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $numeric_return_value = &dashrep_define( "page-name-second" , "name of second page" );
#  uncomment-for-cpan-version-end
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };;

$being_tested = "counted defined phrases -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
@string_array_return_value = &dashrep_translate::dashrep_get_list_of_phrases;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# @string_array_return_value = &dashrep_get_list_of_phrases;
#  uncomment-for-cpan-version-end
$list_count = $#string_array_return_value + 1;
if ( $list_count == $prior_list_count + 1 ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "verified name in list of phrase names -- ";
$test_number_count ++;
$one_if_ok = 0;
for ( $pointer = 0 ; $pointer <= ( $list_count - 1 ) ; $pointer ++ )
{
    if ( $string_array_return_value[ $pointer ] =~ /page/ ) { $one_if_ok = 1; last; };
}
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test deleting hyphenated phrase.

#  remove-from-cpan-version-begin
$numeric_return_value = &dashrep_translate::dashrep_define( "temporary-phrase" , "anything here" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $numeric_return_value = &dashrep_define( "temporary-phrase" , "anything here" );
#  uncomment-for-cpan-version-end

$being_tested = "deleted hyphenated phrase -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_delete( "temporary-phrase" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_delete( "temporary-phrase" );
#  uncomment-for-cpan-version-end
if ( $numeric_return_value eq 1 ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "attempt to retrieve deleted phrase -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "temporary-phrase" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "temporary-phrase" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

#-------------------------------------------
#  Specify Dashrep code that will be used in
#  tests below.

$numeric_return_value = &dashrep_translate::dashrep_define( "text-with-special-characters" , "some hyphenated-text \n  with linebreaks\n    and   adjacent    spaces" );

$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-special-replacement-newline" , "[eol]" );

$numeric_return_value = &dashrep_translate::dashrep_define( "symbol-space" , " " );

$numeric_return_value = &dashrep_translate::dashrep_define( "symbol-two-periods" , ".." );

$numeric_return_value = &dashrep_translate::dashrep_define( "text-with-extra-spaces" , "  12 34  56   78   90  " ) ;

$numeric_return_value = &dashrep_translate::dashrep_define( "template-for-createlist" , "abc-[-createlist-parameter-]-def" ) ;

$numeric_return_value = &dashrep_translate::dashrep_define( "template-for-full-createlist" , "abc-[-createlist-parameter-]-def-[-createlist-item-number-]of[-createlist-total-number-of-items-]-ghi" ) ;

$dashrep_code = <<TEXT_TO_IMPORT;

*---- Do NOT change the following numbers or the tests will fail ----*
list-of-numbers: 3 12 7 13 4
--------

test-of-special-operators:
[-test-assignment = 17-]
[-should-be-17 = [-test-assignment-]-]
[-first-word-phrase = copied-]
[-second-word-phrase = text-]
[-copy-from-phrase-to-phrase: empty-text copied-text-]
[-append-from-phrase-to-phrase: first-word-phrase copied-text-]
[-append-from-phrase-to-phrase: second-word-phrase copied-text-]
[-copy-from-phrase-to-phrase: copied-text should-be-copied-text-]
[-dashrep-special-replacement-adjacent-space = &nbsp;-]
[-dashrep-special-replacement-hyphen = &ndash;-]
[-copy-from-phrase-to-phrase-and-replace-hyphens: text-with-special-characters text-with-hyphens-replaced-]
[-copy-from-phrase-to-phrase-and-replace-newlines: text-with-special-characters text-with-newlines-replaced-]
[-copy-from-phrase-to-phrase-and-replace-adjacent-spaces: text-with-special-characters text-with-adjacent-spaces-replaced-]
[-copy-from-phrase-to-phrase-into-spoken-dashrep-code: page-participants-list tagged-dashrep-code-]
[-copy-from-phrase-to-phrase-from-spoken-dashrep-code: tagged-dashrep-code regenerated-page-participants-list-]
[-should-be-zero = [-zero-one-multiple: 0-]-]
[-should-be-one = [-zero-one-multiple: 1-]-]
[-should-be-multiple = [-zero-one-multiple: 2-]-]
[-should-be-size-zero = [-count-of-words-in-phrase: empty-text-]-]
[-should-be-size-one = [-count-of-words-in-phrase: should-be-17-]-]
[-list-of-size-three = 4 5 6-]
[-should-be-size-three = [-count-of-words-in-phrase: list-of-size-three-]-]
[-should-be-item-three = [-first-word-in-phrase: list-of-numbers-]-]
[-should-be-item-four = [-last-word-in-phrase: list-of-numbers-]-]
[-should-be-empty-yes = [-yes-or-no-empty-word: -]-]
[-should-be-empty-no = [-yes-or-no-empty-word: something-]-]
[-item-one = waltz-]
[-item-two = dance-]
[-should-be-same-yes = [-yes-or-no-same-two-words: [-item-one-] [-item-one-]-]-]
[-should-be-same-no = [-yes-or-no-same-two-words: [-item-one-] [-item-two-]-]-]
[-test-counter = 17-]
[-test-value = 3-]
[-compare-numbers-equal = [-numeric-equal-greater-less-compare: 16 16-]-]
[-compare-numbers-less = [-numeric-equal-greater-less-compare: 18 19-]-]
[-compare-numbers-greater = [-numeric-equal-greater-less-compare: 21 20-]-]
[-copy-from-phrase-to-phrase: empty-text test-text-length-0-]
[-should-be-length-0 = [-count-of-characters-in-phrase-defintion: test-text-length-0-]-]
[-test-text-length-1 = a-]
[-should-be-length-1 = [-count-of-characters-in-phrase-defintion: test-text-length-1-]-]
[-test-text-length-7 = abcdefg-]
[-should-be-length-7 = [-count-of-characters-in-phrase-defintion: test-text-length-7-]-]
[-should-be-item-with-value-7 = [-from-phrase-get-word-number: list-of-numbers 3-]-]
[-counts-from-integer-to-integer-put-into-phrase: 0 7 counts-from-0-to-7-]
[-counts-from-integer-to-integer-put-into-phrase: 5 -4 counts-from-5-to-minus-4-]
[-every-pairwise-combination-of-words-from-two-phrases-put-into-two-phrases: counts-from-0-to-7 counts-from-5-to-minus-4 list-of-first-items-in-two-dimensions list-of-second-items-in-two-dimensions-]
[-should-be-counts-3-and-minus-2 = [-from-phrase-get-word-number list-of-first-items-in-two-dimensions 38-] [-from-phrase-get-word-number list-of-second-items-in-two-dimensions 38-]-]
[-calculation-result = [-numeric-integer [-numeric-multiply 3.14 7.39-]-]-]
[-compare-result = [-numeric-equal-greater-less-compare: 23 17-] [-numeric-equal-greater-less-compare: 17 17-] [-numeric-equal-greater-less-compare: 17 23-]-]
[-string-to-test-character-actions = abc123 abc123 abc123-]
[-character-result = [-characters-in-phrase-get-from-position-to-position: string-to-test-character-actions 1 1-][-characters-in-phrase-get-from-position-to-position: string-to-test-character-actions 2 2-][-characters-in-phrase-get-from-position-to-position: string-to-test-character-actions 4 4-][-characters-in-phrase-get-from-position-to-position: string-to-test-character-actions 5 5-][-characters-in-phrase-get-from-position-to-position: string-to-test-character-actions 20 20-][-characters-in-phrase-get-from-position-to-position: string-to-test-character-actions 21 21-]-]
[-sample-word-list = alpha beta gamma delta-]
[-word-list-result = [-position-of-word-in-phrase: alpha sample-word-list-]-[-position-of-word-in-phrase: gamma sample-word-list-]-[-position-of-word-in-phrase: other sample-word-list-]-]
[-sample-word-list-one = alpha alpha-here and beta gamma delta-]
[-sample-word-list-two = something-here alpha alpha-here beta delta whatever-]
[-copy-from-phrase-to-phrase sample-word-list-one list-with-dups-]
[-append-from-phrase-to-phrase sample-word-list-two list-with-dups-]
[-find-in-lists-result = [-copy-from-two-phrases-words-found-in-both-to-phrase: sample-word-list-one sample-word-list-two word-list-in-both-] [-copy-from-first-phrase-words-not-found-in-second-phrase-to-phrase: sample-word-list-one sample-word-list-two word-list-in-first-only-] [-copy-from-phrase-unique-words-to-phrase: list-with-dups unique-words-] [-word-list-in-both-] - [-word-list-in-first-only-] - [-unique-words-] -]
[-use-template-and-parameters-to-create-simple-list-with-name: template-for-createlist sample-word-list-one generated-simple-list-]
[-prefix-for-list-named-generated-full-list = prefix-here-]
[-suffix-for-list-named-generated-full-list = suffix-here-]
[-separator-for-list-named-generated-full-list = separator-here-]
[-use-template-and-parameters-to-create-full-list-with-name: template-for-full-createlist sample-word-list-one generated-full-list-]
[-generated-simple-and-full-lists = [-generated-simple-list-] - [-generated-full-list-]-]
[-hyphen-translation-safe = <character_hyphen>-]
[-copy-from-phrase-to-phrase-and-replace-string-in-phrase-with-phrase template-for-createlist text-translation-safe character-hyphen hyphen-translation-safe-]
[-copy-from-phrase-to-phrase-split-into-words-at-string-in-phrase template-for-full-createlist test-inserted-spaces character-hyphen-]
[-already-expanded-phrase = one<character_hyphen>two<character_hyphen>three <item_one>-]
[-insert-angle-bracketed-definitions-into-already-expanded-phrase already-expanded-phrase-]
nothing else
--------

test-of-comment-delimiters:
beginning text
*---- comment text ----*
middle text
/---- comment text ----/
ending text
--------

test-of-auto-increment:
[-auto-increment: test-counter-]
--------

test-of-unique-value:
[-first-unique-value = [-unique-value-]-]
[-second-unique-value = [-unique-value-]-]
[-yes-or-no-same-phrase: first-unique-value second-unique-value-]
--------

non-breaking-space:
&nbsp;
--------

test-of-special-spacing:
abc no-space def one-space ghi jkl  span-non-breaking-spaces-begin mno pqr stu span-non-breaking-spaces-end vwx non-breaking-space yz
--------

test-of-special-line-phrases:
abc
empty-line
def
new-line
ghi
--------

test-of-parameter-substitution:
[-prefix-text-]-def-[-middle-text-]-jkl-[-suffix-text-]
--------

prefix-text:
abc
--------

middle-text:
ghi
--------

suffix-text:
mno
--------

intended-result-of-parameter-substitution:
abc-def-ghi-jkl-mno
--------

single-phrase-to-replace:
replaced-phrase
--------

text-with-periods:
12345.67890.54321
--------

character-period:
.
--------

test-of-replace-periods-with-spaces:
[-copy-from-phrase-to-phrase-and-replace-string-in-phrase-with-phrase: text-with-periods text-with-spaces character-period character-space-]
--------

test-of-replace-spaces-with-phrase:
[-copy-from-phrase-to-phrase-and-replace-spaces-with-phrase text-with-extra-spaces text-with-spaces-replaced symbol-two-periods-]
--------

test-of-several-copy-actions:
[-text-being-copied = abc DEF 123-]
[-copy-from-phrase-to-phrase text-being-copied text-copied-]
[-copy-from-phrase-to-phrase-lowercase-only text-being-copied text-copied-lowercase-]
[-copy-from-phrase-to-phrase-uppercase-only text-being-copied text-copied-uppercase-]
[-copy-from-phrase-to-phrase-and-replace-digits-with-9s text-being-copied text-copied-with-9s-]
[-copy-from-phrase-to-phrase-and-split-into-list-of-characters text-being-copied text-copied-separate-characters-]
[-copy-from-phrase-to-phrase-but-remove-first-word text-being-copied text-copied-without-first-word-]
[-copy-from-phrase-to-phrase-but-remove-last-word text-being-copied text-copied-without-last-word-]
[-text-copied-] [-text-copied-lowercase-] [-text-copied-uppercase-]
[-text-copied-with-9s-] [-text-copied-separate-characters-]
[-text-copied-without-first-word-] [-text-copied-without-last-word-]
--------

test-of-more-copy-actions:
[-copy-from-phrase-to-phrase-and-remove-extra-spaces text-with-extra-spaces text-copied-extra-spaces-removed-]
[-text-being-copied = 17 9 183 65-]
[-copy-from-phrase-to-phrase-and-numeric-sort-by-word text-being-copied text-copied-numeric-sorted-]
[-text-being-copied = <xyz>&amp;</xyz>-]
[-copy-from-phrase-to-phrase-and-replace-html-reserved-characters text-being-copied text-copied-html-characters-replaced-]
[-text-copied-numeric-sorted-] [-text-copied-extra-spaces-removed-] [-text-copied-html-characters-replaced-]
--------

list-from-which-to-remove-last-item:
12, 56, 72
--------

phrase-that-contains-hyphenated-phrases:
hyphenated-content-here hyphenated-content-here
--------

test-of-action-that-replaces-each-hyphen-with-hyphen-here:
[-copy-from-phrase-to-phrase-and-replace-each-hyphen-with-hypen-here phrase-that-contains-hyphenated-phrases resulting-text-with-no-hyphenated-phrases-]
--------

test-of-calculate-if-empty:
[-calculate-if-phrase-empty: value-of-pi-]
[-value-of-pi-]
--------

value-of-pi:
--------

how-to-calculate-value-of-pi:
[-value-of-pi = 3.14159-]
--------

test-of-stop-translation:
[-value-of-pi-]
[-dashrep-stop-translation = yes-]
[-value-of-pi-]
--------

sample-escape-text:
command to be executed
--------

test-of-escape-action:
[-escape-text = step1-]
[-escape-if-yes: no-]
[-copy-from-phrase-to-phrase sample-escape-text escape-text-]
[-escape-if-yes: yes-]
[-escape-text = step3-]
[-escape-if-yes: yes-]
--------

page-participants-list:
[-list-of-parameter-values-for-list-named-participant-names-full = [-case-info-idlistparticipants-]-]
[-use-template-and-parameters-to-create-full-list-with-name template-for-list-named-participant-names-full list-of-parameter-values-for-list-named-participant-names-full generated-list-named-participant-names-full-]
[-auto-increment: test-counter-]
format-begin-heading-level-1
words-web-page-title
format-end-heading-level-1
tag-begin ul tag-end
generated-list-named-participant-names-full
tag-begin /ul tag-end
--------
entire-standard-web-page:
web-page-begin-1-of-2
web-page-begin-2-of-2
[-page-participants-list-]
web-page-end
--------
words-web-page-title:
List of participants
--------
tag-begin: < no-space
--------
tag-end: no-space >
--------
web-page-begin-1-of-2:
tag-begin !DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" tag-end
tag-begin html tag-end
tag-begin head tag-end
tag-begin title tag-end no-space
words-web-page-title
no-space tag-begin /title tag-end
--------
web-page-begin-2-of-2:
tag-begin /head tag-end
new-line
tag-begin body tag-end
--------
web-page-end:
tag-begin /body tag-end
tag-begin /html tag-end
--------
format-begin-heading-level-1:
tag-begin h1 tag-end no-space
--------
format-end-heading-level-1:
no-space  tag-begin /h1 tag-end
--------
case-info-idlistparticipants:
[-list-of-numbers-]
--------
template-for-list-named-participant-names-full: tag-begin li tag-end no-space participant-fullname-for-participantid-[-createlist-parameter-] no-space tag-begin /li tag-end
--------
participant-fullname-for-participantid-3
James (Conservative)
---------------
participant-fullname-for-participantid-12
Nicole (Bloc Qu&eacute;b&eacute;cois)
---------------
participant-fullname-for-participantid-7
Eduard (Liberal)
---------------
participant-fullname-for-participantid-13
Robert (New Democratic)
---------------
participant-fullname-for-participantid-4
Diane (Conservative)
---------------
TEXT_TO_IMPORT


#-------------------------------------------
#  Test import hyphenated phrases with
#  replacement text.

$being_tested = "imported replacements using Dashrep code -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$numeric_return_value = &dashrep_translate::dashrep_import_replacements( $dashrep_code );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $numeric_return_value = &dashrep_import_replacements( $dashrep_code );
#  uncomment-for-cpan-version-end
if ( $numeric_return_value > 10 ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test expanding parameters.

$being_tested = "expanded parameters in one string -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$content_with_expanded_parameters = &dashrep_translate::dashrep_expand_parameters( "test-of-parameter-substitution" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $content_with_expanded_parameters = &dashrep_expand_parameters( "test-of-parameter-substitution" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "intended-result-of-parameter-substitution" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "intended-result-of-parameter-substitution" );
#  uncomment-for-cpan-version-end
if ( $content_with_expanded_parameters eq $string_return_value ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "expanded parameters in one variable-named string -- ";
$test_number_count ++;
$phrase_name = "test-of-parameter-substitution" ;
#  remove-from-cpan-version-begin
$content_with_expanded_parameters = &dashrep_translate::dashrep_expand_parameters( $phrase_name );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $content_with_expanded_parameters = &dashrep_expand_parameters( $phrase_name );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "intended-result-of-parameter-substitution" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "intended-result-of-parameter-substitution" );
#  uncomment-for-cpan-version-end
if ( $content_with_expanded_parameters eq $string_return_value ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "expanded parameters -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$content_with_expanded_parameters = &dashrep_translate::dashrep_expand_parameters( "page-participants-list" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $content_with_expanded_parameters = &dashrep_expand_parameters( "page-participants-list" );
#  uncomment-for-cpan-version-end
if ( $content_with_expanded_parameters =~ /format-begin-heading-level-1 words-web-page-title format-end-heading-level-1 tag-begin ul tag-end generated-list-named-participant-names-full tag-begin .* tag-end/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test special operators.

#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-of-special-operators" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "test-of-special-operators" );
#  uncomment-for-cpan-version-end

$being_tested = "test equal sign assignment -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-17" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-17" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "17" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test copy and append from phrase to phrase -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-copied-text" );
# $results_text .= "[[" . $string_return_value . "]]" ;
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-copied-text" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq " copied text" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test copy with special replacement of hyphens -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "text-with-hyphens-replaced" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "text-with-hyphens-replaced" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /\&ndash;/s ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test copy with special replacement of newlines -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "text-with-newlines-replaced" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "text-with-newlines-replaced" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /\[eol\]/s ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test copy with special replacement of adjacent spaces -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "text-with-adjacent-spaces-replaced" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "text-with-adjacent-spaces-replaced" );
#  uncomment-for-cpan-version-end
if ( ( $string_return_value =~ /\&nbsp;/s ) && ( $string_return_value !~ /  / ) ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test copy as tagged dashrep code -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "tagged-dashrep-code" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "tagged-dashrep-code" );
#  uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( ( $string_return_value =~ / ambee /s ) && ( $string_return_value !~ /  / ) ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test zero operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-zero" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-zero" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "zero" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test one operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-one" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-one" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "one" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test multiple operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-multiple" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-multiple" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "multiple" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test list-size operator for zero -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-size-zero" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-size-zero" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "0" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test list-size operator for one -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-size-one" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-size-one" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "1" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test list-size operator for three -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-size-three" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-size-three" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "3" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test first item in list operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-item-three" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-item-three" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "3" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test last item in list operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-item-four" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-item-four" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "4" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test empty operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-empty-yes" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-empty-yes" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "yes" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test nonempty operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-empty-no" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-empty-no" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "no" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test same operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-same-yes" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-same-yes" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "yes" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test not same operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-same-no" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-same-no" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "no" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test numbers equal operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "compare-numbers-equal" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "compare-numbers-equal" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "equal" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test numbers equal operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "compare-numbers-less" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "compare-numbers-less" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "less" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test greater than operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "compare-numbers-greater" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "compare-numbers-greater" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "greater" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test auto-increment operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-of-auto-increment" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "test-of-auto-increment" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "test-counter" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "test-counter" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "18" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test unique-value operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-of-unique-value" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "test-of-unique-value" );
#  uncomment-for-cpan-version-end
if ( $string_return_value ne "no" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test text length operator, length 0 -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "should-be-length-0" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "should-be-length-0" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "0" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test text length operator, length 1 -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "should-be-length-1" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "should-be-length-1" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "1" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test text length operator, length 7 -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "should-be-length-7" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "should-be-length-7" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "7" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


$being_tested = "test from-list-in-phrase-get-item-number action -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "should-be-item-with-value-7" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "should-be-item-with-value-7" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "7" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


$being_tested = "test counting actions -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "should-be-counts-3-and-minus-2" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "should-be-counts-3-and-5" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "3 -2" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


$being_tested = "test calculation actions -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "calculation-result" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "calculation-result" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "23" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


$being_tested = "test comparison actions -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "compare-result" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "compare-result" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "greater equal less" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


$being_tested = "test character actions -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "character-result" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "character-result" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "ab1233" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


$being_tested = "test word-list actions -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "word-list-result" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "word-list-result" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "1-3-0" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


$being_tested = "test find in lists actions -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "find-in-lists-result" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "find-in-lists-result" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "alpha alpha-here beta delta - and gamma - alpha alpha-here and beta gamma delta something-here whatever" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


$being_tested = "test generate-list actions -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-generated-simple-and-full-lists-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-generated-simple-and-full-lists-]" );
#  uncomment-for-cpan-version-end
$string_return_value =~ s/  +/ /g ;
$string_return_value =~ s/^ +// ;
$string_return_value =~ s/ +$// ;
# $results_text .= "[[" . $string_return_value . "]]\n" ;
if ( $string_return_value eq "abc-alpha-def abc-alpha-here-def abc-and-def abc-beta-def abc-gamma-def abc-delta-def - prefix-here abc-alpha-def-1of6-ghi separator-here abc-alpha-here-def-2of6-ghi separator-here abc-and-def-3of6-ghi separator-here abc-beta-def-4of6-ghi separator-here abc-gamma-def-5of6-ghi separator-here abc-delta-def-6of6-ghi suffix-here" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test comment delimiters.

$being_tested = "test comment delimiters -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "test-of-comment-delimiters" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "test-of-comment-delimiters" );
#  uncomment-for-cpan-version-end
if ( $string_return_value !~ /comment/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test expansion without special phrases.

$being_tested = "test expansion without special phrases -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_phrases_except_special( "test-of-special-spacing" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_phrases_except_special( "test-of-special-spacing" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /abc no\-space def one\-space ghi jkl/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test expansion of specific special phrases.

$being_tested = "test no-space directive -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_phrases( "abc  no-space  def" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_phrases( "abc  no-space  def" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /abcdef/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test one-space directive -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_phrases( "abc  one-space  def" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_phrases( "abc  one-space  def" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /abc def/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test four-space indentation -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_phrases( "abc new-line  no-space  one-space  one-space  one-space  one-space  no-space  def" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_phrases( "abc new-line  no-space  one-space  one-space  one-space  one-space  no-space  def" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /abc\n    def/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test single phrase replacement -- ";
$test_number_count ++;
$phrase_name = "single-phrase-to-replace";
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_phrases( $phrase_name );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_phrases( $phrase_name );
#  uncomment-for-cpan-version-end
if ( $string_return_value ne "replaced-phrase" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test non-breaking-space directives -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "abc non-breaking-space def" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_special_phrases( "abc non-breaking-space def" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /abc&nbsp;def/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test non-breaking-spaces-begin/end directive -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "jkl  span-non-breaking-spaces-begin mno pqr stu span-non-breaking-spaces-end vwx" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_special_phrases( "jkl  span-non-breaking-spaces-begin mno pqr stu span-non-breaking-spaces-end vwx" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /jkl mno&nbsp;pqr&nbsp;stu vwx/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test empty-line and new-line directives -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "abc empty-line def new-line ghi" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_special_phrases( "abc empty-line def new-line ghi" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /abc\n\ndef\nghi/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test special line-related phrases.

$being_tested = "test line break phrase -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_phrases( "test-of-special-line-phrases" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_phrases( "test-of-special-line-phrases" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /\n/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test special-phrase line break -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "test-of-special-line-phrases" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_special_phrases( "test-of-special-line-phrases" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /\n/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the "ignore-begin-here" and
#  "ignore-end-here" directives.

$being_tested = "test ignore directives on same line -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "test-abc ignore-begin-here def ghi ignore-end-here test-jkl" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_special_phrases( "test-abc ignore-begin-here def ghi ignore-end-here test-jkl" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /test-abc[^a-z]*test-jkl/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test ignore directives on different lines -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "test-abc" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_special_phrases( "test-abc" );
#  uncomment-for-cpan-version-end
$accumulated_string = $string_return_value;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "ignore-begin-here" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_special_phrases( "ignore-begin-here" );
#  uncomment-for-cpan-version-end
$accumulated_string .= $string_return_value;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "def ghi" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_special_phrases( "def ghi" );
#  uncomment-for-cpan-version-end
$accumulated_string .= $string_return_value;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "ignore-end-here" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_special_phrases( "ignore-end-here" );
#  uncomment-for-cpan-version-end
$accumulated_string .= $string_return_value;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "test-jkl" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_special_phrases( "test-jkl" );
#  uncomment-for-cpan-version-end
$accumulated_string .= $string_return_value;
if ( $accumulated_string =~ /test-abc[^a-z]*test-jkl/i ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the "capture-begin-here" and
#  "capture-end-here" directives.

$being_tested = "test capture directives on same line -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-tracking-on-or-off" , "on" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $numeric_return_value = &dashrep_define( "dashrep-tracking-on-or-off" , "on" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "test-abc capture-begin-here def ghi capture-end-here test-jkl" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_special_phrases( "test-abc capture-begin-here def ghi capture-end-here test-jkl" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$captured_text = &dashrep_translate::dashrep_get_replacement( "captured-text" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $captured_text = &dashrep_get_replacement( "captured-text" );
#  uncomment-for-cpan-version-end
if ( ( $string_return_value =~ /test-abc[^a-z]*test-jkl/ ) && ( $captured_text =~ /^[^a-z]*def +ghi[^a-z]*$/ ) ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test capture directives on different lines -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "test-abc" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_special_phrases( "test-abc" );
#  uncomment-for-cpan-version-end
$accumulated_string = $string_return_value;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "capture-begin-here" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_special_phrases( "capture-begin-here" );
#  uncomment-for-cpan-version-end
$accumulated_string .= $string_return_value;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "def ghi" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_special_phrases( "def ghi" );
#  uncomment-for-cpan-version-end
$accumulated_string .= $string_return_value;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "capture-end-here" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_special_phrases( "capture-end-here" );
#  uncomment-for-cpan-version-end
$accumulated_string .= $string_return_value;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "test-jkl" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_special_phrases( "test-jkl" );
#  uncomment-for-cpan-version-end
$accumulated_string .= $string_return_value;
#  remove-from-cpan-version-begin
$captured_text = &dashrep_translate::dashrep_get_replacement( "captured-text" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $captured_text = &dashrep_get_replacement( "captured-text" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-tracking-on-or-off" , "off" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $numeric_return_value = &dashrep_define( "dashrep-tracking-on-or-off" , "off" );
#  uncomment-for-cpan-version-end
if ( ( $accumulated_string =~ /test-abc *test-jkl/ ) && ( $captured_text =~ /def +ghi/ ) ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the copy-from-phrase-to-phrase-and-replace-string-in-phrase-with-phrase action.

$being_tested = "test action: copy-from-phrase-to-phrase-and-replace-string-in-phrase-with-phrase -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-of-replace-periods-with-spaces" );
$string_return_value = &dashrep_translate::dashrep_get_replacement( "text-with-spaces" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "test-of-replace-periods-with-spaces" );
# $string_return_value = &dashrep_get_replacement( "text-with-spaces" );
# uncomment-for-cpan-version-end
if ( $string_return_value eq "12345 67890 54321" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the copy-from-phrase-to-phrase-and-replace-spaces-with-phrase action.

$being_tested = "test action: copy-from-phrase-to-phrase-and-replace-spaces-with-phrase -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-of-replace-spaces-with-phrase" );
$string_return_value = &dashrep_translate::dashrep_get_replacement( "text-with-spaces-replaced" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "test-of-replace-spaces-with-phrase" );
# $string_return_value = &dashrep_get_replacement( "text-with-spaces-replaced" );
# uncomment-for-cpan-version-end
if ( $string_return_value eq "12..34..56..78..90" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test several copy actions.

$being_tested = "test some copy actions -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-of-several-copy-actions" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "test-of-several-copy-actions" );
# uncomment-for-cpan-version-end
$string_return_value =~ s/^ +// ;
$string_return_value =~ s/ +$// ;
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( $string_return_value eq "abc DEF 123 abc def 123 ABC DEF 123 abc DEF 999 a b c onespace D E F onespace 1 2 3 DEF 123 abc DEF" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test several more copy actions.

$being_tested = "test some more copy actions -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-of-more-copy-actions" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "test-of-more-copy-actions" );
# uncomment-for-cpan-version-end
$string_return_value =~ s/^ +// ;
$string_return_value =~ s/ +$// ;
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( $string_return_value eq "9 17 65 183 12 34 56 78 90 &lt;xyz&gt;&amp;&lt;/xyz&gt;" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test action: test-of-action-that-replaces-each-hyphen-with-hyphen-here

$being_tested = "test action: test-of-action-that-replaces-each-hyphen-with-hyphen-here -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-test-of-action-that-replaces-each-hyphen-with-hyphen-here-]" );
$string_return_value = &dashrep_translate::dashrep_get_replacement( "resulting-text-with-no-hyphenated-phrases" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-test-of-action-that-replaces-each-hyphen-with-hyphen-here-]" );
# $string_return_value = &dashrep_get_replacement( "resulting-text-with-no-hyphenated-phrases" );
# uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( $string_return_value eq "hyphenated hyphen-here content hyphen-here here hyphenated hyphen-here content hyphen-here here" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test action: copy-from-phrase-to-phrase-split-into-words-at-string-in-phrase

$being_tested = "test action: copy-from-phrase-to-phrase-split-into-words-at-string-in-phrase -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "test-inserted-spaces" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "test-inserted-spaces" );
# uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( $string_return_value eq "abc [ createlist parameter ] def [ createlist item number ]of[ createlist total number of items ] ghi" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };



#-------------------------------------------
#  Test append-from-phrase-to-phrase action.

$being_tested = "test action: append-from-phrase-to-phrase -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-test-source-phrase" , "some content here" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $numeric_return_value = &dashrep_define( "dashrep-test-source-phrase" , "some content here" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-test-target-phrase" , "" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $numeric_return_value = &dashrep_define( "dashrep-test-target-phrase" , "" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-append-from-phrase-to-phrase dashrep-test-source-phrase dashrep-test-target-phrase-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-append-from-phrase-to-phrase dashrep-test-source-phrase dashrep-test-target-phrase-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "dashrep-test-target-phrase" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "dashrep-test-target-phrase" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /some content here/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the "copy-from-phrase-to-phrase-and-replace-string-in-phrase-with-phrase" action.

$being_tested = "test action: copy-from-phrase-to-phrase-and-replace-string-in-phrase-with-phrase -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "text-translation-safe" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_phrases( "text-translation-safe" );
# uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( $string_return_value eq "abc<character_hyphen>[<character_hyphen>createlist<character_hyphen>parameter<character_hyphen>]<character_hyphen>def" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the action "insert-angle-bracketed-definitions-into-already-expanded-phrase"

$being_tested = "test action: insert-angle-bracketed-definitions-into-already-expanded-phrase -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "already-expanded-phrase" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_phrases( "already-expanded-phrase" );
# uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( $string_return_value eq "one-two-three waltz" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the calculate-if-empty action.

$being_tested = "test action: calculate-if-empty -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-of-calculate-if-empty" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_phrases( "test-of-calculate-if-empty" );
# uncomment-for-cpan-version-end
if ( $string_return_value =~ /^ *3\.14159 *$/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the dashrep-stop-translation action, then test resume translation.

$being_tested = "test action: dashrep-stop-translation -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-of-stop-translation" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_phrases( "test-of-stop-translation" );
# uncomment-for-cpan-version-end
if ( $string_return_value =~ /^ *3\.14159 *\[-value-of-pi-\]$/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

# remove-from-cpan-version-begin
$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-stop-translation" , "" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $numeric_return_value = &dashrep_define( "dashrep-stop-translation" , "" );
# uncomment-for-cpan-version-end

$being_tested = "resume translation -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-one" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-one" );
# uncomment-for-cpan-version-end
if ( $string_return_value eq "one" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the escape action.

# $being_tested = "escape action -- ";
# $test_number_count ++;
# $string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-of-escape-action" );
# $results_text .= "[[" . $string_return_value . "]]" ;
# if ( $string_return_value eq "step2" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
# if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
# if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test expanding a single hyphenated
#  phrase into an entire web page, including
#  a table that lists participants.

$being_tested = "expanded hyphenated phrase using all replacements -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$content_with_expanded_parameters = &dashrep_translate::dashrep_expand_parameters( "entire-standard-web-page" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $content_with_expanded_parameters = &dashrep_expand_parameters( "entire-standard-web-page" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$html_code = &dashrep_translate::dashrep_expand_phrases( $content_with_expanded_parameters );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $html_code = &dashrep_expand_phrases( $content_with_expanded_parameters );
#  uncomment-for-cpan-version-end
if ( length( $html_code ) gt 100 ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };
$being_tested = "found specific expanded text, including list items -- ";
$test_number_count ++;
if ( ( $html_code =~ /List of participants/ ) && ( $html_code =~ /Nicole/ ) ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Print the web page to a file with the .html
#  extension.
#  As a further test, you can open the file
#  with a web browser.

$filename = "output_test_web_page.html";
open ( OUTFILE , ">" . $filename );
print OUTFILE $html_code;
close OUTFILE;


#-------------------------------------------
#  Test file actions.

$being_tested = "test actions that create file, append to file, and copy from file to phrase -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-delete-file output_test_target_file.txt-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-delete-file output_test_target_file.txt-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-create-empty-file output_test_target_file.txt-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-create-empty-file output_test_target_file.txt-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-copy-from-phrase-append-to-file dashrep-test-source-phrase output_test_target_file.txt-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-copy-from-phrase-append-to-file dashrep-test-source-phrase output_test_target_file.txt-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-copy-from-file-to-phrase output_test_target_file.txt dashrep-test-target-phrase-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-copy-from-file-to-phrase output_test_target_file.txt dashrep-test-target-phrase-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "dashrep-test-target-phrase" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "dashrep-test-target-phrase" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /some content here/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test action: clear-all-dashrep-phrases -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-write-all-dashrep-definitions-to-file output_test_definitions_file.txt-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-write-all-dashrep-definitions-to-file output_test_definitions_file.txt-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-clear-all-dashrep-phrases-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-clear-all-dashrep-phrases-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "page-name" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "page-name" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test actions that save and get definitions in file -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-get-definitions-from-file  output_test_definitions_file.txt-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-get-definitions-from-file  output_test_definitions_file.txt-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "page-name" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "page-name" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "name of page" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test action: linewise-translate-from-file-to-file -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-delete-file output_test_source_file.txt-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-delete-file output_test_source_file.txt-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-create-empty-file output_test_source_file.txt-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-create-empty-file output_test_source_file.txt-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-test-target-phrase" , "non-replaced-content" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $numeric_return_value = &dashrep_define( "dashrep-test-target-phrase" , "non-replaced-content" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$numeric_return_value = &dashrep_translate::dashrep_define( "non-replaced-content" , "replaced content" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $numeric_return_value = &dashrep_define( "non-replaced-content" , "replaced content" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-copy-from-phrase-append-to-file dashrep-test-target-phrase output_test_source_file.txt-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-copy-from-phrase-append-to-file dashrep-test-target-phrase output_test_source_file.txt-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-linewise-translate-from-file-to-file output_test_source_file.txt output_test_target_file.txt-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-linewise-translate-from-file-to-file output_test_source_file.txt output_test_target_file.txt-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-copy-from-file-to-phrase output_test_target_file.txt dashrep-test-target-phrase-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-copy-from-file-to-phrase output_test_target_file.txt dashrep-test-target-phrase-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "dashrep-test-target-phrase" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "dashrep-test-target-phrase" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /replaced content/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

# Subroutine dashrep_linewise_translate is NOT tested because it uses STDIN and STDOUT.


#-------------------------------------------
#  Test xml-to-dashrep translation.

$being_tested = "test subroutine named dashrep_xml_tags_to_dashrep -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-first-xml-tag-name" , "xml" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $numeric_return_value = &dashrep_define( "dashrep-first-xml-tag-name" , "xml" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_xml_tags_to_dashrep( "<xml><head>xyz</head></xml>" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_xml_tags_to_dashrep( "<xml><head>xyz</head></xml>" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /begin-xml-head.*xyz.*end-xml-head/s ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test action: linewise-translate-xml-tags-in-file-to-dashrep-phrases-in-file -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-first-xml-tag-name" , "html" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $numeric_return_value = &dashrep_define( "dashrep-first-xml-tag-name" , "html" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-test-xml-phrase" , "" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $numeric_return_value = &dashrep_define( "dashrep-test-xml-phrase" , "" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-delete-file output_test_xml_phrases_file.txt-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-delete-file output_test_xml_phrases_file.txt-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-create-empty-file output_test_xml_phrases_file.txt-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-create-empty-file output_test_xml_phrases_file.txt-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-linewise-translate-xml-tags-in-file-to-dashrep-phrases-in-file output_test_web_page.html output_test_xml_phrases_file.txt-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-linewise-translate-xml-tags-in-file-to-dashrep-phrases-in-file output_test_web_page.html output_test_xml_phrases_file.txt-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-copy-from-file-to-phrase output_test_xml_phrases_file.txt dashrep-test-xml-phrase-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-copy-from-file-to-phrase output_test_xml_phrases_file.txt dashrep-test-xml-phrase-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "dashrep-test-xml-phrase" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "dashrep-test-xml-phrase" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /begin-html-head.*participants.*end-html-head/s ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Remove temporary files.
#  (Comment out if need to view files for debugging.)

#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-delete-file output_test_source_file.txt-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-delete-file output_test_source_file.txt-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-delete-file output_test_target_file.txt-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-delete-file output_test_target_file.txt-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-delete-file output_test_definitions_file.txt-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-delete-file output_test_definitions_file.txt-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-delete-file output_test_xml_phrases_file.txt-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-delete-file output_test_xml_phrases_file.txt-]" );
#  uncomment-for-cpan-version-end


#-------------------------------------------
#  Optionally write use of deprecated
#  action names.

#  $results_text .= "\n\n" . "Useage of deprecated actions:\n" . &dashrep_translate::dashrep_get_replacement( "dashrep-list-of-deprecated-action-useage" ) . "\n\n";


#-------------------------------------------
#  Write results, including the count of
#  successful tests.

if ( $test_OK_counter == $test_number_count )
{
    $results_text .= "All " . $test_OK_counter . " tests were successful!\n";
} else
{
    $test_failed_counter = $test_number_count - $test_OK_counter ;
    $results_text .= "Failed " . $test_failed_counter . " tests!\nSee test output file for details.\n";
}
$filename = "output_test_results.txt";
open ( OUTFILE , ">" . $filename );
print OUTFILE $results_text ;
close OUTFILE;


#  uncomment-for-cpan-version-begin
# #-------------------------------------------
# #  If all test results OK, indicate pass for
# #  CPAN module test.

# if ( $test_OK_counter == $test_number_count ) {
#     pass("Passed all $test_OK_counter tests out of $test_number_count");
# } else {
#     fail("Failed $test_failed_counter tests out of $test_number_count, see file $filename for details");
# }


#  uncomment-for-cpan-version-end
#-------------------------------------------
#  All done testing.

}
