#----------------------------------------------------
#                join.pl
#----------------------------------------------------
#  Joins multiple files into single file.
#  File contents preceded by a line of the form:
#     <START_OF_NEXT_FILE> filename
#
#----------------------------------------------------

#----------------------------------------------------

# Get the names of all the files to combine.

while ( $file_name = <STDIN> ) {
    chomp( $file_name ) ;
    if ( ( $file_name =~ /[a-z]/ ) && ( $file_name !~ /((^)|(\\))copy /i ) ) {
        push( @file_name_list, $file_name ) ;
    }
}

#----------------------------------------------------

# For first/next file ...

foreach $file_name ( @file_name_list ) {

# Write labeled filename.

    print "<START_OF_NEXT_FILE> " . $file_name . "\n" ;

# Copy all lines.

    open( INFILE, $file_name ) ;
    while ( $input_line = <INFILE> ) {
		chomp( $input_line ) ;
        print $input_line . "\n" ;
    }
    close( INFILE ) ;

# Repeat loop for next file.

}
