#!/usr/bin/perl

#---------------------------------------------------
#
#    combine_listed_dashdefs.pl
#    --------------------------
#
#---------------------------------------------------


#---------------------------------------------------
#  Specify the slash or backslash convention for the
#  current operating system.

$slash_or_backslash = '\\' ;


#---------------------------------------------------
#  Write a copyright notice.

print 'dashdef-copyright-notice:' . "\n" . 'All the code and text in this collection of Dashrep phrase definitions are (c) Copyright 2017 by the entity who owns the source code from which this object code was generated, and who is specified in a separate copyright statement within one of the following files within this collection. ALL RIGHTS RESERVED.' . "\n" . '----' . "\n" ;


#---------------------------------------------------
#  Generate the list of files.

while ( <STDIN> )
{
    $input_line = $_ ;
    chomp( $input_line ) ;
    $input_line =~ s/ +$// ;
    if ( $input_line =~ /([^ ]+\.txt)/ )
    {
        $full_path = $1 ;
        $list_of_all_full_paths .= $full_path . " " ;
    }
}


#---------------------------------------------------
#  Read each file, which contains the definition
#  of one Dashrep phrase, and write the combined
#  Dashrep definitions to an output file.

@sorted_list_of_full_paths = split( / +/ , $list_of_all_full_paths ) ;
foreach $full_path ( @sorted_list_of_full_paths )
{
    $file_name = $full_path ;
    $file_name =~ s/^.*[\/\\]// ;
    $phrase_name = $file_name ;
    $phrase_name =~ s/\.txt.*// ;
    $current_definition = "" ;

    print $phrase_name . ":" . "\n" ;

    if ( $file_name ne "" )
    {
        open ( INFILE , "<" . $full_path ) ;
        while ( $input_line = <INFILE> )
        {
            chomp( $input_line ) ;
            $current_definition .= $input_line . "\n" ;
        }
        close ( INFILE ) ;
        $definition_for_phrase{ $phrase_name } = $current_definition ;
    }

    print $current_definition . "----" . "\n" ;

}


#---------------------------------------------------
#  All done.

exit;
