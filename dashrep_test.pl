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

$numeric_return_value = &dashrep_translate::dashrep_define( "special-replacement-newline" , "[eol]" );

$dashrep_code = <<TEXT_TO_IMPORT;

*---- Do NOT change the following numbers or the tests will fail ----*
list-of-numbers: 3,12,7,13,4
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
[-special-replacement-adjacent-space = &nbsp;-]
[-special-replacement-hyphen = &ndash;-]
[-copy-from-phrase-to-phrase-and-replace-hyphens: text-with-special-characters text-with-hyphens-replaced-]
[-copy-from-phrase-to-phrase-and-replace-newlines: text-with-special-characters text-with-newlines-replaced-]
[-copy-from-phrase-to-phrase-and-replace-adjacent-spaces: text-with-special-characters text-with-adjacent-spaces-replaced-]
[-copy-from-phrase-to-phrase-as-tagged-dashrep-code: page-participants-list tagged-dashrep-code-]
[-should-be-zero = [-zero-one-multiple: 0-]-]
[-should-be-one = [-zero-one-multiple: 1-]-]
[-should-be-multiple = [-zero-one-multiple: 2-]-]
[-should-be-size-zero = [-count-of-list: -]-]
[-should-be-size-one = [-count-of-list: 4-]-]
[-should-be-size-three = [-count-of-list: 4,5,6-]-]
[-should-be-count-zero = [-zero-one-multiple-count-of-list: -]-]
[-should-be-count-one = [-zero-one-multiple-count-of-list: 12-]-]
[-should-be-count-multiple = [-zero-one-multiple-count-of-list: [-list-of-numbers-]-]-]
[-should-be-item-three = [-first-item-in-list: [-list-of-numbers-]-]-]
[-should-be-item-four = [-last-item-in-list: [-list-of-numbers-]-]-]
[-should-be-empty = [-empty-or-nonempty: -]-]
[-should-be-nonempty = [-empty-or-nonempty: something-]-]
[-item-one = waltz-]
[-item-two = dance-]
[-should-be-same = [-same-or-not-same: [-item-one-]-[-item-one-]-]-]
[-should-be-not-same = [-same-or-not-same: [-item-one-]-[-item-two-]-]-]
[-action-showothervoterranking-[-same-or-not-same: [-input-validated-participantid-]-[-users-participant-id-]-]-]
[-should-be-sorted = [-sort-numbers: [-list-of-numbers-]-]-]
[-test-counter = 17-]
[-test-value = 3-]
[-test-yes-numbers-equal = [-yes-or-no-first-number-equals-second-number: 16 16-]-]
[-test-no-numbers-not-equal = [-yes-or-no-first-number-equals-second-number: 18 19-]-]
[-test-yes-number-greater-than = [-yes-or-no-first-number-greater-than-second-number: 21 20-]-]
[-test-no-number-not-greater-than = [-yes-or-no-first-number-greater-than-second-number: 20 20-]-]
[-test-yes-number-less-than = [-yes-or-no-first-number-less-than-second-number: 21 22-]-]
[-test-no-number-not-less-than = [-yes-or-no-first-number-less-than-second-number: 22 22-]-]
[-copy-from-phrase-to-phrase: empty-text test-text-length-0-]
[-should-be-length-0 = [-length-of-phrase-definition: test-text-length-0-]-]
[-test-text-length-1 = a-]
[-should-be-length-1 = [-length-of-phrase-definition: test-text-length-1-]-]
[-test-text-length-7 = abcdefg-]
[-should-be-length-7 = [-length-of-phrase-definition: test-text-length-7-]-]
[-should-be-item-with-value-7 = [-from-list-in-phrase-get-item-number: list-of-numbers 3-]-]
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
[-unique-value: test-value-]
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

test-of-tabs:
abc tab-here def tab-here ghi
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
12345.67890
--------

test-of-replace-periods-with-spaces:
[-replace-periods-with-spaces: [-text-with-periods-]-]
--------

list-from-which-to-remove-last-item:
12, 56, 72
--------

test-of-remove-last-item-from-phrase-list:
[-remove-last-item-from-phrase-list: list-from-which-to-remove-last-item-]
--------

test-of-calculate-if-empty:
[-calculate-if-empty: value-of-pi-]
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
[-create-list-named: participant-names-full-]
[-auto-increment: test-counter-]
[-unique-value: test-value-]
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

case-info-idlistparticipants: [-list-of-numbers-]
--------
template-for-list-named-participant-names-full: tag-begin li tag-end no-space participant-fullname-for-participantid-[-parameter-participant-id-] no-space tag-begin /li tag-end
--------
parameter-name-for-list-named-participant-names-full:
parameter-participant-id
--------
list-of-parameter-values-for-list-named-participant-names-full:
[-case-info-idlistparticipants-]
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
if ( ( $string_return_value =~ /dashrep-code-hyphen-here/s ) && ( $string_return_value !~ /  / ) ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
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

$being_tested = "test zero count operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-count-zero" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-count-zero" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "zero" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test one count operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-count-one" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-count-one" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "one" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test multiple count operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-count-multiple" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-count-multiple" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "multiple" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
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
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-empty" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-empty" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "empty" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test nonempty operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-nonempty" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-nonempty" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "nonempty" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test same operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-same" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-same" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "same" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test not same operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-not-same" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-not-same" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "not-same" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test numbers equal operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "test-yes-numbers-equal" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "test-yes-numbers-equal" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "yes" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test numbers equal operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "test-no-numbers-not-equal" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "test-no-numbers-not-equal" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "no" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test greater than operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "test-yes-number-greater-than" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "test-yes-number-greater-than" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "yes" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test greater than operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "test-no-number-not-greater-than" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "test-no-number-not-greater-than" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "no" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test less than operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "test-yes-number-less-than" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "test-yes-number-less-than" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "yes" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test less than operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "test-no-number-not-less-than" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "test-no-number-not-less-than" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "no" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };

$being_tested = "test sort operator -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-sorted" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "should-be-sorted" );
#  uncomment-for-cpan-version-end
if ( $string_return_value eq "3,4,7,12,13" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
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
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_get_replacement( "test-value" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "test-value" );
#  uncomment-for-cpan-version-end
if ( $string_return_value ne "3" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
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

$being_tested = "test tab-here directive -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "abc tab-here def" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_special_phrases( "abc tab-here def" );
#  uncomment-for-cpan-version-end
if ( $string_return_value =~ /abc\tdef/ ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
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
#  Test tab-here phrase.

$being_tested = "test tab-here phrase -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_phrases( "test-of-tabs" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_expand_phrases( "test-of-tabs" );
#  uncomment-for-cpan-version-end
if ( $string_return_value ne "abc\tdef\tghi" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
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
#  Test the remove-last-item-from-phrase-list action.

$being_tested = "remove-last-item-from-phrase-list action -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-of-remove-last-item-from-phrase-list" );
$string_return_value = &dashrep_translate::dashrep_get_replacement( "list-from-which-to-remove-last-item" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "list-from-which-to-remove-last-item" );
# uncomment-for-cpan-version-end
if ( $string_return_value eq "12, 56" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the replace-periods-with-spaces action.

$being_tested = "replace-periods-with-spaces action -- ";
$test_number_count ++;
# remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-of-replace-periods-with-spaces" );
# remove-from-cpan-version-end
# uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_get_replacement( "list-from-which-to-remove-last-item" );
# uncomment-for-cpan-version-end
if ( $string_return_value eq "12345 67890" ) { $one_if_ok = 1; } else { $one_if_ok = 0; };
if ( $one_if_ok == 1 ) { $test_OK_counter ++ };
if ( $one_if_ok == 1 ) { $results_text .= $being_tested . "OK\n" } else { $results_text .= $being_tested . "ERROR\n\n" };


#-------------------------------------------
#  Test the calculate-if-empty action.

$being_tested = "calculate-if-empty action -- ";
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

$being_tested = "dashrep-stop-translation action -- ";
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
#  Test top-level actions.

$being_tested = "test top-level action: append-from-phrase-to-phrase -- ";
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
$string_return_value = &dashrep_translate::dashrep_top_level_action( "append-from-phrase-to-phrase dashrep-test-source-phrase dashrep-test-target-phrase" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "append-from-phrase-to-phrase dashrep-test-source-phrase dashrep-test-target-phrase" );
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

$being_tested = "test top-level actions that create file, append to file, and copy from file to phrase -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_top_level_action( "delete-file output_test_target_file.txt" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "delete-file output_test_target_file.txt" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_top_level_action( "create-empty-file output_test_target_file.txt" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "create-empty-file output_test_target_file.txt" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_top_level_action( "copy-from-phrase-append-to-file dashrep-test-source-phrase output_test_target_file.txt" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "copy-from-phrase-append-to-file dashrep-test-source-phrase output_test_target_file.txt" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_top_level_action( "copy-from-file-to-phrase output_test_target_file.txt dashrep-test-target-phrase" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "copy-from-file-to-phrase output_test_target_file.txt dashrep-test-target-phrase" );
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

$being_tested = "test top-level action: clear-all-dashrep-phrases -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_top_level_action( "write-all-dashrep-definitions-to-file output_test_definitions_file.txt" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "write-all-dashrep-definitions-to-file output_test_definitions_file.txt" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_top_level_action( "clear-all-dashrep-phrases" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "clear-all-dashrep-phrases" );
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

$being_tested = "test top-level actions that save and get definitions in file -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_top_level_action( "get-definitions-from-file  output_test_definitions_file.txt" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "get-definitions-from-file  output_test_definitions_file.txt" );
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

$being_tested = "test top-level action: linewise-translate-from-file-to-file -- ";
$test_number_count ++;
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_top_level_action( "delete-file output_test_source_file.txt" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "delete-file output_test_source_file.txt" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_top_level_action( "create-empty-file output_test_source_file.txt" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "create-empty-file output_test_source_file.txt" );
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
$string_return_value = &dashrep_translate::dashrep_top_level_action( "copy-from-phrase-append-to-file dashrep-test-target-phrase output_test_source_file.txt" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "copy-from-phrase-append-to-file dashrep-test-target-phrase output_test_source_file.txt" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_top_level_action( "linewise-translate-from-file-to-file output_test_source_file.txt output_test_target_file.txt" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "linewise-translate-from-file-to-file output_test_source_file.txt output_test_target_file.txt" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_top_level_action( "copy-from-file-to-phrase output_test_target_file.txt dashrep-test-target-phrase" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "copy-from-file-to-phrase output_test_target_file.txt dashrep-test-target-phrase" );
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

$being_tested = "test top-level action: linewise-translate-xml-tags-in-file-to-dashrep-phrases-in-file -- ";
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
$string_return_value = &dashrep_translate::dashrep_top_level_action( "delete-file output_test_xml_phrases_file.txt" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "delete-file output_test_xml_phrases_file.txt" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_top_level_action( "create-empty-file output_test_xml_phrases_file.txt" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "create-empty-file output_test_xml_phrases_file.txt" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_top_level_action( "linewise-translate-xml-tags-in-file-to-dashrep-phrases-in-file output_test_web_page.html output_test_xml_phrases_file.txt" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "linewise-translate-xml-tags-in-file-to-dashrep-phrases-in-file output_test_web_page.html output_test_xml_phrases_file.txt" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_top_level_action( "copy-from-file-to-phrase output_test_xml_phrases_file.txt dashrep-test-xml-phrase" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "copy-from-file-to-phrase output_test_xml_phrases_file.txt dashrep-test-xml-phrase" );
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
$string_return_value = &dashrep_translate::dashrep_top_level_action( "delete-file output_test_source_file.txt" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "delete-file output_test_source_file.txt" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_top_level_action( "delete-file output_test_target_file.txt" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "delete-file output_test_target_file.txt" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_top_level_action( "delete-file output_test_definitions_file.txt" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "delete-file output_test_definitions_file.txt" );
#  uncomment-for-cpan-version-end
#  remove-from-cpan-version-begin
$string_return_value = &dashrep_translate::dashrep_top_level_action( "delete-file output_test_xml_phrases_file.txt" );
#  remove-from-cpan-version-end
#  uncomment-for-cpan-version-begin
# $string_return_value = &dashrep_top_level_action( "delete-file output_test_xml_phrases_file.txt" );
#  uncomment-for-cpan-version-end


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
