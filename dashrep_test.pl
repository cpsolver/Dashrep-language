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
#  Optionally test the new expansion code.

$numeric_return_value = &dashrep_translate::dashrep_define( "yes-or-no-use-slower-subset-expand" , "no" );
$numeric_return_value = &dashrep_translate::dashrep_define( "yes-or-no-use-faster-subset-expand" , "yes" );


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

$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-action-trace-on-yes-or-no" , "yes" );

$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-warning-trace-on-yes-or-no" , "yes" );

$numeric_return_value = &dashrep_translate::dashrep_define( "text-with-special-characters" , "some hyphenated-text \n  with linebreaks\n    and   adjacent    spaces" );

$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-special-replacement-newline" , "[eol]" );

$numeric_return_value = &dashrep_translate::dashrep_define( "symbol-space" , " " );

$numeric_return_value = &dashrep_translate::dashrep_define( "symbol-two-periods" , ".." );

$numeric_return_value = &dashrep_translate::dashrep_define( "text-with-extra-spaces" , "  12 34  56   78   90  " ) ;

$numeric_return_value = &dashrep_translate::dashrep_define( "template-for-createlist" , "abc-[-createlist-parameter-]-def" ) ;

$numeric_return_value = &dashrep_translate::dashrep_define( "template-for-full-createlist" , "abc-[-createlist-parameter-]-def-[-createlist-item-number-]of[-createlist-total-number-of-items-]-ghi" ) ;

$dashrep_code = <<TEXT_TO_IMPORT;

*---- Do NOT change the following numbers or the tests will fail ----*
list-of-numbers 3 12 7 13 4
--------

test-of-special-operators:
[-test-assignment = 17-]
[-should-be-17 = [-test-assignment-]-]
[-first-word-phrase = copied-]
[-second-word-phrase = text-]
[-copy-text empty-text copied-text-]
[-append-text first-word-phrase copied-text-]
[-append-text second-word-phrase copied-text-]
[-copy-text copied-text should-be-copied-text-]
[-dashrep-special-replacement-adjacent-space = &nbsp;-]
[-dashrep-special-replacement-hyphen = &ndash;-]
[-copy-without-extra-spaces text-with-special-characters text-with-adjacent-spaces-replaced-]
[-convert-into-spoken-dashrep-code page-participants-list tagged-dashrep-code-]
[-convert-from-spoken-dashrep-code tagged-dashrep-code regenerated-page-participants-list-]
[-should-be-zero = [-zero-one-multiple 0-]-]
[-should-be-one = [-zero-one-multiple 1-]-]
[-should-be-multiple = [-zero-one-multiple 2-]-]
[-should-be-size-zero = [-get-count-of-words empty-text-]-]
[-should-be-size-one = [-get-count-of-words should-be-17-]-]
[-list-of-size-three = 4 5 6-]
[-should-be-size-three = [-get-count-of-words list-of-size-three-]-]
[-should-be-item-three = [-get-word-at-position list-of-numbers 1 -]-]
[-should-be-item-four = [-get-word-at-position list-of-numbers 999 -]-]
[-should-be-same-words-yes = [-yes-or-no-same-two-words waltz waltz-]-]
[-should-be-same-words-no = [-yes-or-no-same-two-words waltz dance-]-]
[-item-one = waltz-]
[-item-two = dance-]
[-should-be-same-yes = [-yes-or-no-same-two-phrase-definitions item-one item-one-]-]
[-should-be-same-no = [-yes-or-no-same-two-phrase-definitions item-one item-two-]-]
[-test-counter = 17-]
[-test-value = 3-]
[-compare-numbers-equal = [-numeric-equal-greater-less-compare 16 16-]-]
[-compare-numbers-less = [-numeric-equal-greater-less-compare 18 19-]-]
[-compare-numbers-greater = [-numeric-equal-greater-less-compare 21 20-]-]
[-copy-text empty-text test-text-length-0-]
[-should-be-length-0 = [-get-count-of-characters test-text-length-0-]-]
[-test-text-length-1 = a-]
[-should-be-length-1 = [-get-count-of-characters test-text-length-1-]-]
[-test-text-length-7 = abcdefg-]
[-should-be-length-7 = [-get-count-of-characters test-text-length-7-]-]
[-should-be-item-with-value-7 = [-get-word-at-position list-of-numbers 3-]-]
[-generate-counts-from-integer-to-integer 0 7 counts-from-0-to-7-]
[-generate-counts-from-integer-to-integer 5 -4 counts-from-5-to-minus-4-]
[-minimum-maximum-result = [-numeric-minimum 2 8 -] [-numeric-maximum 2 8 -] [-numeric-minimum 3 -] [-numeric-maximum 4 -]-]
[-generate-every-pairwise-combination-of-words counts-from-0-to-7 counts-from-5-to-minus-4 list-of-first-items-in-two-dimensions list-of-second-items-in-two-dimensions-]
[-should-be-counts-3-and-minus-2 = [-get-word-at-position list-of-first-items-in-two-dimensions 38-] [-get-word-at-position list-of-second-items-in-two-dimensions 38-]-]
[-calculation-result = [-numeric-integer [-numeric-multiply 3.14 7.39-]-]-]
[-compare-result = [-numeric-equal-greater-less-compare 23 17-] [-numeric-equal-greater-less-compare 17 17-] [-numeric-equal-greater-less-compare 17 23-]-]
[-string-to-test-character-actions = abc123 abc123 abc123-]
[-character-result = [-get-characters-from-position-to-position string-to-test-character-actions 1 1-][-get-characters-from-position-to-position string-to-test-character-actions 2 2-][-get-characters-from-position-to-position string-to-test-character-actions 4 4-][-get-characters-from-position-to-position string-to-test-character-actions 5 5-][-get-characters-from-position-to-position string-to-test-character-actions 20 20-][-get-characters-from-position-to-position string-to-test-character-actions 21 21-]-]
[-sample-word-list = alpha beta gamma delta-]
[-copy-words-from-position-to-position sample-word-list should-be-beta-gamma 2 3-]
[-word-alpha = alpha -]
[-word-gamma = gamma -]
[-word-other = other -]
[-word-list-result = [-get-position-of-word word-alpha sample-word-list-]-[-get-position-of-word word-gamma sample-word-list-]-[-get-position-of-word word-other sample-word-list-]-]
[-sample-word-list-one = alpha alpha-here and beta gamma beta delta-]
[-sample-word-list-two = something-here alpha alpha-here beta delta whatever-]
[-copy-text sample-word-list-one list-with-dups-]
[-append-text sample-word-list-two list-with-dups-]
[-find-in-lists-result = [-copy-words-found-in-both-lists sample-word-list-one sample-word-list-two word-list-in-both-] [-copy-words-found-in-either-list sample-word-list-one sample-word-list-two word-list-in-either-] [-copy-words-found-only-in-first-list sample-word-list-one sample-word-list-two word-list-in-first-only-] [-copy-words-unique-only list-with-dups unique-words-] [-word-list-in-both-] - [-word-list-in-either-] - [-word-list-in-first-only-] - [-unique-words-] - [-list-of-unique-word-counts-] -]
[-hyphen-translation-safe = <character_hyphen>-]
[-copy-and-replace template-for-createlist text-translation-safe character-hyphen hyphen-translation-safe-]
[-already-expanded-phrase = one<character_hyphen>two<character_hyphen>three <item_one>-]
[-insert-angle-bracketed-definitions already-expanded-phrase-]
[-yes-or-no-allow-user-defined-actions = yes-]
[-string-123 = 123 -]
[-copy-zero-pad-left-to-length string-123 string-123-padded 5 -]
[-vector-one = 17 23 -4 -]
[-vector-two = 21 -9 0 -]
[-numeric-vector-add-number vector-one -7 vector-result-add-number-]
[-numeric-vector-multiply-by-number vector-one 7 vector-result-multiply-by-number-]
[-numeric-vectors-add vector-one vector-two vector-result-addition-]
[-numeric-vectors-from-delta-values-calculate-distances vector-one vector-two vector-result-distances-]
[-text-to-repeat = number 9 -]
[-append-repeatedly-using-count text-to-repeat list-of-repeated-text 9 -]
[-text-with-named-html-entities = abc &amp; &apos; &lt; &gt; &ldquo; &rdquo; &quot; def -]
[-text-with-tag-and-attribute = <p style="xyz">... and a < span style="whatever" >wet< / span > dolphin ...<br />...</p> -]
[-copy-and-remove-attributes-from-xml-tags text-with-tag-and-attribute text-with-tag-]
[-list-of-words-to-search-based-on-prefix = here-is-something here-is-something-else hereis-something-else and-something-else-]
[-text-begins-with = here-is-]
[-copy-words-that-begin-with-text list-of-words-to-search-based-on-prefix list-of-words-that-begin-with-text text-begins-with-]
[-text-contains = is -]
[-copy-words-that-contain-listed-words list-of-words-to-search-based-on-prefix list-of-words-that-contain-listed-words text-contains-]
[-text-begins-with = and -]
[-copy-words-that-begin-with-listed-words list-of-words-to-search-based-on-prefix list-of-words-that-begin-with-listed-words text-begins-with-]
[-text-for-multiple-find = fish bird-]
[-text-for-multiple-search = birds songbird fish clownfish-]
[-generate-positions-of-listed-words text-for-multiple-find text-for-multiple-search pointers-to-multiple-matching-words-]
[-paired-words-for-replacements = bird flier fish swimmer-]
[-copy-and-replace-using-paired-listed-words text-for-multiple-search results-replacements-using-paired-words paired-words-for-replacements-]
[-string-category-underscore = category_ -]
[-copy-from-file-to-phrase specifications_phrase_categories_and_names.txt documented-phrase-names-]
[-copy-words-that-begin-with-text documented-phrase-names category-words string-category-underscore-]
[-copy-words-found-only-in-first-list documented-phrase-names category-words documented-phrase-names-]
[-spoken-words = dashbee dashenn dashnex ambee amenn combee comenn fen fenambee amennfen linbray-]
[-copy-words-found-only-in-first-list documented-phrase-names spoken-words documented-phrase-names-]
[-copy-words-found-only-in-first-list documented-phrase-names dashrep-list-of-recognized-phrase-names list-of-phrase-names-documented-minus-recognized-]
[-copy-words-found-only-in-first-list dashrep-list-of-recognized-phrase-names documented-phrase-names list-of-phrase-names-recognized-minus-documented-]
[-copy-text list-of-phrase-names-documented-minus-recognized list-of-phrase-names-difference-]
[-append-text character-period list-of-phrase-names-difference-]
[-append-text character-period list-of-phrase-names-difference-]
[-append-text list-of-phrase-names-recognized-minus-documented list-of-phrase-names-difference-]
[-copy-without-extra-spaces list-of-phrase-names-difference list-of-phrase-names-difference-]
nothing else
--------

test-of-comment-delimiters:
beginning text
*---- comment text ----*
middle text
/---- comment text ----/
ending text
--------

test-of-numeric-increment:
[-numeric-increment test-counter-]
--------

test-of-unique-value:
[-first-unique-value = [-unique-value-]-]
[-second-unique-value = [-unique-value-]-]
[-yes-or-no-same-two-phrase-definitions first-unique-value second-unique-value-]
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

test-of-space-and-line-directives:
Content-type: text/html
<new_line>
<new_line>
<!DOCTYPE html>
<new_line>
<head>
<new_line>
<title> no-space web-page-title no-space </title>
<new_line>
--------

web-page-title:
No hyphen-here title no-space
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
[-copy-and-replace text-with-periods text-with-spaces character-period character-space-]
--------

test-of-several-copy-actions:
[-text-being-copied = abc DEF 123-]
[-copy-text text-being-copied text-copied-]
[-copy-lowercase-only text-being-copied text-copied-lowercase-]
[-copy-uppercase-only text-being-copied text-copied-uppercase-]
[-copy-words-from-position-to-position text-being-copied text-copied-without-first-word 2 999 -]
[-copy-words-from-position-to-position text-being-copied text-copied-without-last-word 1 2 -]
[-text-copied-] [-text-copied-lowercase-] [-text-copied-uppercase-]
[-text-copied-without-first-word-] [-text-copied-without-last-word-]
--------

test-of-more-copy-actions:
[-copy-without-extra-spaces text-with-extra-spaces text-copied-extra-spaces-removed-]
[-text-being-copied = 17 9 183 65-]
[-copy-words-sort-numeric text-being-copied text-copied-numeric-sorted-]
[-text-copied-numeric-sorted-] [-text-copied-extra-spaces-removed-]
--------

list-from-which-to-remove-last-item:
12, 56, 72
--------

phrase-that-contains-hyphenated-phrases:
hyphenated-content-here hyphenated-content-here
--------

value-of-pi:
3.14159
--------

test-of-insert-codeview-tags:
[-text-being-codified = <xyz>&amp;</xyz>-]
[-copy-text text-being-codified dashrep-code-with-inserted-codeview-tags-]
[-insert-codeview-tags dashrep-code-with-inserted-codeview-tags-]
--------

input-right-values:
12 -3 6 23 15 9 22 17 2 -5 10
--------

input-up-values:
8 -9 4 2 18 3 11 9 12 6 7
--------

two-dimensional-sort:
[-numeric-two-dimensional-sort-into-columns-and-rows 3 input-right-values input-up-values results-of-two-dimensional-sort-]
--------

test-if-begin-actions:
[-result-of-testing-if-begin-actions = [-if-yes-begin yes-] one [-if-else-] two [-if-end-] [-if-yes-begin no-] three [-if-else-] four [-if-end-] [-if-no-begin yes-] five [-if-else-] six [-if-end-] [-if-no-begin no-] seven [-if-else-] eight [-if-end-] [-if-yes-begin yes-] nine [-if-end-] [-if-yes-begin no-] ten [-if-end-] [-if-no-begin no-] eleven [-if-end-] [-if-no-begin yes-] twelve [-if-end-] -]
--------

character-string-source:
some words here
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
[-escape-if-yes no-]
[-copy-text sample-escape-text escape-text-]
[-escape-if-yes yes-]
[-escape-text = step3-]
[-escape-if-yes yes-]
--------
handle-one-named-participant:
[-expand-text template-for-list-named-participant-names-full expanded-content-for-named-participant-]
[-append-text expanded-content-for-named-participant generated-list-named-participant-names-full-]
--------
page-participants-list:
[-list-of-parameter-values-for-list-named-participant-names-full = [-case-info-idlistparticipants-]-]
[-use-handler-with-each-word-in-phrase handle-one-named-participant list-of-parameter-values-for-list-named-participant-names-full-]
[-numeric-increment test-counter-]
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
template-for-list-named-participant-names-full: tag-begin li tag-end no-space participant-fullname-for-participantid-[-word-to-use-in-handler-] no-space tag-begin /li tag-end
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
# Test action: expand-text


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
if ( $string_return_value eq "copied text" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
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
if ( $string_return_value !~ /  / ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
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

$being_tested = "test same word operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-same-words-yes" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-same-words-yes" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "yes" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test not same word operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-same-words-no" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-same-words-no" );
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

$being_tested = "test numeric-increment operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-of-numeric-increment" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "test-of-numeric-increment" );
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
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-counts-3-and-minus-2" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-counts-3-and-5" );
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


$being_tested = "test minimum and maximum actions with single value -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "minimum-maximum-result" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "minimum-maximum-result" );
#  uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]\n" ;
if ( $string_return_value eq "2 8 3 4" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
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


$being_tested = "test word copy action -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-beta-gamma" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-beta-gamma" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "beta gamma" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
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
# $results_text .= $string_return_value . "   " ;
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
# $results_text .= "[[" . $string_return_value . "]]\n" ;
if ( $string_return_value eq "alpha alpha-here beta delta - beta whatever something-here gamma alpha-here alpha delta and - and gamma - alpha alpha-here and beta gamma delta something-here whatever - 2 2 1 3 1 2 1 1" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


$being_tested = "test action copy-zero-pad-left-to-length -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "string-123-padded" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_translate::dashrep_get_replacement( "string-123-padded" );
#  uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]\n" ;
if ( $string_return_value eq "00123" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


$being_tested = "test action numeric-vector-add-number -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "vector-result-add-number" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_translate::dashrep_get_replacement( "vector-result-add-number" );
#  uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]\n" ;
if ( $string_return_value eq "10 16 -11" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


$being_tested = "test action numeric-vector-multiply-by-number -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "vector-result-multiply-by-number" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_translate::dashrep_get_replacement( "vector-result-multiply-by-number" );
#  uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]\n" ;
if ( $string_return_value eq "119 161 -28" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


$being_tested = "test action numeric-vectors-add -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "vector-result-addition" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_translate::dashrep_get_replacement( "vector-result-addition" );
#  uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]\n" ;
if ( $string_return_value eq "38 14 -4" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


$being_tested = "test action numeric-vectors-from-delta-values-calculate-distances -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "vector-result-distances" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_translate::dashrep_get_replacement( "vector-result-distances" );
#  uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]\n" ;
if ( $string_return_value eq "27 25 4" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
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


$string_return_value = &dashrep_translate::dashrep_get_replacement( "yes-or-no-use-faster-subset-expand" );
if ( $string_return_value ne "yes" )
{
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
}

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

$being_tested = "test-of-space-and-line-directives -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_phrases( "test-of-space-and-line-directives" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_phrases( "test-of-space-and-line-directives" );
#  uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( $string_return_value =~ /^Content-type: text\/html\n\n<!DOCTYPE html>\n<head>\n<title>No-title<\/title>/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
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
#  Test the copy-and-replace action.

$being_tested = "test action: copy-and-replace -- ";
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
if ( $string_return_value eq "abc DEF 123 abc def 123 ABC DEF 123 DEF 123 abc DEF" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
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
if ( $string_return_value eq "9 17 65 183 12 34 56 78 90" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test append-text action.

$being_tested = "test action: append-text -- ";
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
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-append-text dashrep-test-source-phrase dashrep-test-target-phrase-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-append-text dashrep-test-source-phrase dashrep-test-target-phrase-]" );
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
#  Test the "copy-and-replace" action.

$being_tested = "test action: copy-and-replace (again) -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "text-translation-safe" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "text-translation-safe" );
# uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( $string_return_value eq "abc<character_hyphen>[<character_hyphen>createlist<character_hyphen>parameter<character_hyphen>]<character_hyphen>def" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the action "insert-angle-bracketed-definitions"

$being_tested = "test action: insert-angle-bracketed-definitions -- ";
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
#  Test the action "insert-codeview-tags"

# $being_tested = "test action: insert-codeview-tags -- ";
# $test_number_count ++;
# # remove-from-cpan-version-begin
# $string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-of-insert-codeview-tags" ) ;
# $string_return_value = &dashrep_translate::dashrep_get_replacement( "dashrep-code-with-inserted-codeview-tags" );
# # remove-from-cpan-version-end
# # uncomment-for-cpan-version-begin
# # $string_return_value = &dashrep_expand_parameters( "test-of-insert-codeview-tags" ) ;
# # $string_return_value = &dashrep_get_replacement( "dashrep-code-with-inserted-codeview-tags" );
# # uncomment-for-cpan-version-end
 # $results_text .= "[[" . $string_return_value . "]]" ;
# if ( $string_return_value =~ /<dashrep_codeview_tag_action_begin>copy-without-extra-spaces</ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
# if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
# if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the action "numeric-two-dimensional-sort-into-columns-and-rows"

$being_tested = "test action: numeric-two-dimensional-sort-into-columns-and-rows -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "two-dimensional-sort" ) ;
$string_return_value = &dashrep_translate::dashrep_get_replacement( "results-of-two-dimensional-sort" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = dashrep_expand_parameters( "two-dimensional-sort" ) ;
# $string_return_value = dashrep_get_replacement( "results-of-two-dimensional-sort" );
# uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( $string_return_value =~ /row-2-column-3 row-4-column-1 row-3-column-1 row-4-column-2 row-1-column-2 row-3-column-2 row-3-column-3 row-2-column-2 row-1-column-1 row-1-column-3 row-2-column-1/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the actions "if-yes-begin" and "if-no-begin"

$being_tested = "test actions: if-yes-begin and if-no-begin -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-if-begin-actions" ) ;
$string_return_value = &dashrep_translate::dashrep_get_replacement( "result-of-testing-if-begin-actions" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = dashrep_expand_parameters( "test-if-begin-actions" ) ;
# $string_return_value = dashrep_get_replacement( "result-of-testing-if-begin-actions" );
# uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( $string_return_value =~ /^ *one +four +six +seven *nine *eleven *$/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the action "use-handler-with-each-word-in-phrase"

$being_tested = "test action use-handler-with-each-word-in-phrase -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_define( "parameter-phrase-to-repeat" , "[-prepend-text word-to-use-in-handler string-generated-by-use-handler-action-]" );
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-use-handler-with-each-word-in-phrase parameter-phrase-to-repeat sample-word-list-]" ) ;
$string_return_value = &dashrep_translate::dashrep_get_replacement( "string-generated-by-use-handler-action" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = dashrep_define( "parameter-phrase-to-repeat" , "[-prepend-text word-to-use-in-handler string-generated-by-use-handler-action-]" );
# $string_return_value = dashrep_expand_parameters( "[-use-handler-with-each-word-in-phrase parameter-phrase-to-repeat sample-word-list-]" ) ;
# $string_return_value = dashrep_get_replacement( "string-generated-by-use-handler-action" );
# uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
# $special_trace_value = &dashrep_translate::dashrep_get_replacement( "special-trace-value" );
# $results_text .= "[[" . $special_trace_value . "]]" ;
if ( $string_return_value =~ /^ *delta gamma beta alpha *$/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the action "append-repeatedly-using-count"

$being_tested = "test action append-repeatedly-using-count -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "list-of-repeated-text" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = dashrep_get_replacement( "list-of-repeated-text" );
# uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( $string_return_value eq "number 9 number 9 number 9 number 9 number 9 number 9 number 9 number 9 number 9" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the action "copy-and-remove-attributes-from-xml-tags"

$being_tested = "test action copy-and-remove-attributes-from-xml-tags -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "text-with-tag" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = dashrep_get_replacement( "text-with-tag" );
# uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( $string_return_value eq "<p>... and a <span>wet</span> dolphin ...<br/>...</p>" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the action "copy-words-that-begin-with-text"

$being_tested = "test action copy-words-that-begin-with-text -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "list-of-words-that-begin-with-text" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = dashrep_get_replacement( "list-of-words-that-begin-with-text" );
# uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( $string_return_value eq "here-is-something here-is-something-else" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the action "copy-words-that-contain-listed-words"

$being_tested = "test action copy-words-that-contain-listed-words -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "list-of-words-that-contain-listed-words" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = dashrep_get_replacement( "list-of-words-that-contain-listed-words" );
# uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( $string_return_value eq "here-is-something here-is-something-else hereis-something-else" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the action "copy-words-that-begin-with-listed-words"

$being_tested = "test action copy-words-that-begin-with-listed-words -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "list-of-words-that-begin-with-listed-words" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = dashrep_get_replacement( "list-of-words-that-begin-with-listed-words" );
# uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( $string_return_value eq "and-something-else" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the action "positions-multiple-of-words-in-phrase-within-phrase-put-into-phrase"

$being_tested = "test action positions-multiple-of-words-in-phrase-within-phrase-put-into-phrase -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "pointers-to-multiple-matching-words" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = dashrep_get_replacement( "pointers-to-multiple-matching-words" );
# uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( $string_return_value eq "1 4 11 14 16 19 26 29" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the action "copy-and-replace-using-paired-listed-words"

$being_tested = "test action copy-and-replace-using-paired-listed-words -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "results-replacements-using-paired-words" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = dashrep_get_replacement( "results-replacements-using-paired-words" );
# uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
if ( $string_return_value eq "fliers songflier swimmer clownswimmer" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the action "write-gathered-listed-items-to-end-of-file"

# $numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-gathered-tag-names-in-sequence" , "url whatever2" );
# $numeric_return_value = &dashrep_translate::dashrep_define( "list-of-unique-values" , "aaa bbb ccc" );
# $string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-write-gathered-listed-items-to-end-of-file list-of-unique-values filename_unused.txt-]" ) ;


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
# $results_text .= "[[" . $html_code . "]]" ;
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

$being_tested = "test action: delete-all-dashrep-phrases -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-write-all-dashrep-definitions-to-file output_test_definitions_file.txt-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-write-all-dashrep-definitions-to-file output_test_definitions_file.txt-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "[-delete-all-dashrep-phrases-]" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_parameters( "[-delete-all-dashrep-phrases-]" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "page-name" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "page-name" );
#  uncomment-for-cpan-version-end
# $results_text .= "[[" . $string_return_value . "]]" ;
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


#-------------------------------------------
#  Compare lists of action names and predefined phrases and all Dashrep-recognized phrases.

$being_tested = "compare lists of action names and predefined phrases and all Dashrep-recognized phrases -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "list-of-phrase-names-difference" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "list-of-phrase-names-difference" );
#  uncomment-for-cpan-version-end
 $results_text .= "[[" . $string_return_value . "]]" . "\n" ;
if ( $string_return_value eq ". ." ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };



#-------------------------------------------
#  Note:
#  Subroutine dashrep_linewise_translate is NOT tested because it uses STDIN and STDOUT.


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
#  Write the trace log to a file.

$trace_log = &dashrep_translate::dashrep_get_replacement( "dashrep-debug-trace-log" );
print $trace_log . "\n\n";


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
