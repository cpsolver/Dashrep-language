#  Test the dashrep_translate.pm module


use dashrep_translate;


BEGIN {

#-------------------------------------------
#  Declare variables.

my ( $numeric_return_value );
my ( $string_return_value );
my ( $list_count );
my ( $one_if_ok );
my ( $dashrep_code );
my ( $content_with_expanded_parameters );
my ( $html_code );
my ( @string_array_return_value );
my ( $captured_text );


#-------------------------------------------
#  Test defining a hyphenated phrase
#  to be associated with its replacement text.

$numeric_return_value = &dashrep_translate::dashrep_define( "page-name" , "name of page" );
print 'defined hyphenated phrase -- ';
if ( $numeric_return_value eq 1 ) { print 'OK' . "\n" } else { print "ERROR\n\n" };


#-------------------------------------------
#  Test getting defined hyphenated phrase.

$string_return_value = &dashrep_translate::dashrep_get_replacement( "page-name" );
print "retrieved replacement text -- ";
if ( $string_return_value eq "name of page" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "phrase-not-defined" );
print "attempt to retrieve undefined phrase -- ";
if ( $string_return_value eq "" ) { print "OK\n" } else { print "ERROR\n\n" }


#-------------------------------------------
#  Test defining second phrase and then
#  getting list of all defined phrases.

$numeric_return_value = &dashrep_translate::dashrep_define( "page-name-second" , "name of second page" );
print "defined hyphenated phrase -- ";
if ( $numeric_return_value eq 1 ) { print "OK\n" } else { print "ERROR\n\n" };

@string_array_return_value = &dashrep_translate::dashrep_get_list_of_phrases;
$list_count = $#string_array_return_value + 1;
print "counted defined phrases -- ";
if ( $list_count eq 2 ) { print "OK\n" } else { print "ERROR\n\n" }

if ( $string_array_return_value[ 1 ] =~ /page/ )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "verified name in list of phrase names -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }


#-------------------------------------------
#  Test deleting hyphenated phrase.

$numeric_return_value = &dashrep_translate::dashrep_define( "temporary-phrase" , "anything here" );

$string_return_value = &dashrep_translate::dashrep_delete( "temporary-phrase" );
print "deleted hyphenated phrase -- ";
if ( $numeric_return_value eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "temporary-phrase" );
print "attempt to retrieve deleted phrase -- ";
if ( $string_return_value eq "" ) { print "OK\n" } else { print "ERROR\n\n" }

#-------------------------------------------
#  Specify Dashrep code that will be used in
#  tests below.

$dashrep_code = <<TEXT_TO_IMPORT;

*---- Do NOT change the following numbers or the tests will fail ----*
list-of-numbers: 3,12,7,13,4
--------

test-of-special-operators:
[-test-assignment = 17-]
[-should-be-17 = [-test-assignment-]-]
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

$numeric_return_value = &dashrep_translate::dashrep_import_replacements( $dashrep_code );
if ( $numeric_return_value > 10 )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "imported replacements using Dashrep code -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }


#-------------------------------------------
#  Test expanding parameters.

$content_with_expanded_parameters = &dashrep_translate::dashrep_expand_parameters( "test-of-parameter-substitution" );
$string_return_value = &dashrep_translate::dashrep_get_replacement( "intended-result-of-parameter-substitution" );
if ( $content_with_expanded_parameters eq $string_return_value )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "expanded parameters in one string -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }

$content_with_expanded_parameters = &dashrep_translate::dashrep_expand_parameters( "page-participants-list" );
if ( $content_with_expanded_parameters =~ /format-begin-heading-level-1 words-web-page-title format-end-heading-level-1 tag-begin ul tag-end generated-list-named-participant-names-full tag-begin .* tag-end/ )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "expanded parameters -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }


#-------------------------------------------
#  Test special operators.

$string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-of-special-operators" );

$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-17" );
print "test equal sign assignment -- ";
if ( $string_return_value eq "17" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-zero" );
print "test special operator -- ";
if ( $string_return_value eq "zero" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-one" );
print "test one operator -- ";
if ( $string_return_value eq "one" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-multiple" );
print "test multiple operator -- ";
if ( $string_return_value eq "multiple" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-size-zero" );
print "test list-size operator for zero -- ";
if ( $string_return_value eq "0" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-size-one" );
print "test list-size operator for one -- ";
if ( $string_return_value eq "1" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-size-three" );
print "test list-size operator for three -- ";
if ( $string_return_value eq "3" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-count-zero" );
print "test zero count operator -- ";
if ( $string_return_value eq "zero" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-count-one" );
print "test one count operator -- ";
if ( $string_return_value eq "one" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-count-multiple" );
print "test multiple count operator -- ";
if ( $string_return_value eq "multiple" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-item-three" );
print "test first item in list operator -- ";
if ( $string_return_value eq "3" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-item-four" );
print "test last item in list operator -- ";
if ( $string_return_value eq "4" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-empty" );
print "test empty operator -- ";
if ( $string_return_value eq "empty" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-nonempty" );
print "test nonempty operator -- ";
if ( $string_return_value eq "nonempty" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-same" );
print "test same operator -- ";
if ( $string_return_value eq "same" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-not-same" );
print "test not same operator -- ";
if ( $string_return_value eq "not-same" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_get_replacement( "should-be-sorted" );
print "test sort operator -- ";
if ( $string_return_value eq "3,4,7,12,13" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-of-auto-increment" );
$string_return_value = &dashrep_translate::dashrep_get_replacement( "test-counter" );
print "test auto-increment operator -- ";
if ( $string_return_value eq "18" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_expand_parameters( "test-of-unique-value" );
$string_return_value = &dashrep_translate::dashrep_get_replacement( "test-value" );
print "test unique-value operator -- ";
if ( $string_return_value ne "3" ) { print "OK\n" } else { print "ERROR\n\n" }


#-------------------------------------------
#  Test comment delimiters.

$string_return_value = &dashrep_translate::dashrep_get_replacement( "test-of-comment-delimiters" );
if ( $string_return_value !~ /comment/ )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test comment delimiters -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }


#-------------------------------------------
#  Test expansion without special phrases.

$string_return_value = &dashrep_translate::dashrep_expand_phrases_except_special( "test-of-special-spacing" );
if ( $string_return_value =~ /abc no\-space def one\-space ghi jkl/ )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test expansion without special phrases -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }


#-------------------------------------------
#  Test expansion of specific special phrases.

$string_return_value = &dashrep_translate::dashrep_expand_phrases( "abc  no-space  def" );
if ( $string_return_value =~ /abcdef/ )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test no-space directive -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_expand_phrases( "abc  one-space  def" );
if ( $string_return_value =~ /abc def/ )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test one-space directive -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_expand_phrases( "abc new-line  no-space  one-space  one-space  one-space  one-space  no-space  def" );
if ( $string_return_value =~ /abc\n    def/ )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test four-space indentation -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "abc non-breaking-space def" );
if ( $string_return_value =~ /abc&nbsp;def/ )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test non-breaking-space directives -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "jkl  span-non-breaking-spaces-begin mno pqr stu span-non-breaking-spaces-end vwx" );
if ( $string_return_value =~ /jkl mno&nbsp;pqr&nbsp;stu vwx/ )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test non-breaking-spaces-begin/end directive -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "abc tab-here def" );
if ( $string_return_value =~ /abc\tdef/ )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test tab-here directive -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "abc empty-line def new-line ghi" );
if ( $string_return_value =~ /abc\n\ndef\nghi/ )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test empty-line and new-line directives -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }


#-------------------------------------------
#  Test special line-related phrases.

$string_return_value = &dashrep_translate::dashrep_expand_phrases( "test-of-special-line-phrases" );
if ( $string_return_value =~ /\n/ )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test line break phrase -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "test-of-special-line-phrases" );
if ( $string_return_value =~ /\n/ )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test special-phrase line break -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }


#-------------------------------------------
#  Test tab-here phrase.

$string_return_value = &dashrep_translate::dashrep_expand_phrases( "test-of-tabs" );
if ( $string_return_value ne "abc\tdef\tghi" )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test tab-here phrase -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }


#-------------------------------------------
#  Test the "ignore-begin-here" and
#  "ignore-end-here" directives.

$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "test-abc ignore-begin-here def ghi ignore-end-here test-jkl" );
if ( $string_return_value =~ /test-abc[^a-z]*test-jkl/ )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test ignore directives on same line -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "test-abc" );
$accumulated_string = $string_return_value;
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "ignore-begin-here" );
$accumulated_string .= $string_return_value;
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "def ghi" );
$accumulated_string .= $string_return_value;
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "ignore-end-here" );
$accumulated_string .= $string_return_value;
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "test-jkl" );
$accumulated_string .= $string_return_value;
if ( $accumulated_string =~ /test-abc[^a-z]*test-jkl/i )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test ignore directives on different lines -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }


#-------------------------------------------
#  Test the "capture-begin-here" and
#  "capture-end-here" directives.

$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-tracking-on-or-off" , "on" );
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "test-abc capture-begin-here def ghi capture-end-here test-jkl" );
$captured_text = &dashrep_translate::dashrep_get_replacement( "captured-text" );
if ( ( $string_return_value =~ /test-abc[^a-z]*test-jkl/ ) && ( $captured_text =~ /^[^a-z]*def +ghi[^a-z]*$/ ) )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test capture directives on same line -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "test-abc" );
$accumulated_string = $string_return_value;
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "capture-begin-here" );
$accumulated_string .= $string_return_value;
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "def ghi" );
$accumulated_string .= $string_return_value;
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "capture-end-here" );
$accumulated_string .= $string_return_value;
$string_return_value = &dashrep_translate::dashrep_expand_special_phrases( "test-jkl" );
$accumulated_string .= $string_return_value;
$captured_text = &dashrep_translate::dashrep_get_replacement( "captured-text" );
if ( ( $accumulated_string =~ /test-abc *test-jkl/ ) && ( $captured_text =~ /def +ghi/ ) )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test capture directives on different lines -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }
$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-tracking-on-or-off" , "off" );


#-------------------------------------------
#  Test expanding a single hyphenated
#  phrase into an entire web page, including
#  a table that lists participants.

$content_with_expanded_parameters = &dashrep_translate::dashrep_expand_parameters( "entire-standard-web-page" );
$html_code = &dashrep_translate::dashrep_expand_phrases( $content_with_expanded_parameters );
if ( length( $html_code ) gt 100 )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "expanded hyphenated phrase using all replacements -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }

if ( ( $html_code =~ /List of participants/ ) && ( $html_code =~ /Nicole/ ) )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "found specific expanded text -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }


#-------------------------------------------
#  Test setting the runaway limit (to stop
#  endless loops).

$string_return_value = &dashrep_translate::dashrep_set_runaway_limit( 7000 );
print 'set new runaway limit -- ';
if ( $numeric_return_value eq 1 ) { print 'OK' . "\n"  } else { print "ERROR\n\n" }


#-------------------------------------------
#  Print $html_code to a file with the .html
#  extension.
#  As a further test, you can open the file
#  with a web browser.

open ( OUTFILE , ">" . "output_test_web_page.html" );
print OUTFILE $html_code;
close OUTFILE;


#-------------------------------------------
#  Test top-level actions.

$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-test-source-phrase" , "some content here" );
$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-test-target-phrase" , "" );
$string_return_value = &dashrep_translate::dashrep_top_level_action( "append-from-phrase-to-phrase dashrep-test-source-phrase dashrep-test-target-phrase" );
$string_return_value = &dashrep_translate::dashrep_get_replacement( "dashrep-test-target-phrase" );
if ( $string_return_value =~ /some content here/ )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test top-level action: append-from-phrase-to-phrase -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_top_level_action( "delete-file output_test_target_file.txt" );
$string_return_value = &dashrep_translate::dashrep_top_level_action( "create-empty-file output_test_target_file.txt" );
$string_return_value = &dashrep_translate::dashrep_top_level_action( "copy-from-phrase-append-to-file dashrep-test-source-phrase output_test_target_file.txt" );
$string_return_value = &dashrep_translate::dashrep_top_level_action( "copy-from-file-to-phrase output_test_target_file.txt dashrep-test-target-phrase" );
$string_return_value = &dashrep_translate::dashrep_get_replacement( "dashrep-test-target-phrase" );
if ( $string_return_value =~ /some content here/ )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test top-level actions that create file, append to file, and copy from file to phrase -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_top_level_action( "write-all-dashrep-definitions-to-file output_test_definitions_file.txt" );
$string_return_value = &dashrep_translate::dashrep_top_level_action( "clear-all-dashrep-phrases" );
$string_return_value = &dashrep_translate::dashrep_get_replacement( "page-name" );
print "test top-level action: clear-all-dashrep-phrases -- ";
if ( $string_return_value eq "" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_top_level_action( "get-definitions-from-file  output_test_definitions_file.txt" );
$string_return_value = &dashrep_translate::dashrep_get_replacement( "page-name" );
print "test top-level actions that save and get definitions in file -- ";
if ( $string_return_value eq "name of page" ) { print "OK\n" } else { print "ERROR\n\n" }

$string_return_value = &dashrep_translate::dashrep_top_level_action( "delete-file output_test_source_file.txt" );
$string_return_value = &dashrep_translate::dashrep_top_level_action( "create-empty-file output_test_source_file.txt" );
$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-test-target-phrase" , "non-replaced-content" );
$numeric_return_value = &dashrep_translate::dashrep_define( "non-replaced-content" , "replaced content" );
$string_return_value = &dashrep_translate::dashrep_top_level_action( "copy-from-phrase-append-to-file dashrep-test-target-phrase output_test_source_file.txt" );
$string_return_value = &dashrep_translate::dashrep_top_level_action( "linewise-translate-from-file-to-file output_test_source_file.txt output_test_target_file.txt" );
$string_return_value = &dashrep_translate::dashrep_top_level_action( "copy-from-file-to-phrase output_test_target_file.txt dashrep-test-target-phrase" );
$string_return_value = &dashrep_translate::dashrep_get_replacement( "dashrep-test-target-phrase" );
if ( $string_return_value =~ /replaced content/ )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test top-level action: linewise-translate-from-file-to-file -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }


#-------------------------------------------
#  Test xml-to-dashrep translation.

$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-internal-first-xml-tag-name" , "xml" );
$string_return_value = &dashrep_translate::dashrep_xml_tags_to_dashrep( "<xml><head>xyz</head></xml>" );
if ( $string_return_value =~ /begin-xml-head.*xyz.*end-xml-head/s )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test subroutine named dashrep_xml_tags_to_dashrep -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }

$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep_internal-first-xml-tag-name" , "html" );
$numeric_return_value = &dashrep_translate::dashrep_define( "dashrep-test-xml-phrase" , "" );
$string_return_value = &dashrep_translate::dashrep_top_level_action( "delete-file output_test_xml_phrases_file.txt" );
$string_return_value = &dashrep_translate::dashrep_top_level_action( "create-empty-file output_test_xml_phrases_file.txt" );
$string_return_value = &dashrep_translate::dashrep_top_level_action( "linewise-translate-xml-tags-in-file-to-dashrep-phrases-in-file output_test_web_page.html output_test_xml_phrases_file.txt" );
$string_return_value = &dashrep_translate::dashrep_top_level_action( "copy-from-file-to-phrase output_test_xml_phrases_file.txt dashrep-test-xml-phrase" );
$string_return_value = &dashrep_translate::dashrep_get_replacement( "dashrep-test-xml-phrase" );
if ( $string_return_value =~ /begin-html-head.*participants.*end-html-head/s )
{
    $one_if_ok = 1;
} else
{
    $one_if_ok = 0;
}
print "test top-level action: linewise-translate-xml-tags-in-file-to-dashrep-phrases-in-file -- ";
if ( $one_if_ok eq 1 ) { print "OK\n" } else { print "ERROR\n\n" }


#-------------------------------------------
#  Remove temporary files.
#  (Un-comment if need to view files for debugging.)

$string_return_value = &dashrep_translate::dashrep_top_level_action( "delete-file output_test_source_file.txt" );
$string_return_value = &dashrep_translate::dashrep_top_level_action( "delete-file output_test_target_file.txt" );
$string_return_value = &dashrep_translate::dashrep_top_level_action( "delete-file output_test_definitions_file.txt" ); 
$string_return_value = &dashrep_translate::dashrep_top_level_action( "delete-file output_test_xml_phrases_file.txt" );


#-------------------------------------------
#  All done testing.

}
