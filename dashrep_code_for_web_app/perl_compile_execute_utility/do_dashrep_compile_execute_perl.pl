#--------------------------------------------------
#       do_dashrep_compile_execute_perl.pl
#--------------------------------------------------

#  (c) Copyright 2018 by Richard Fobes, but permission to copy and use anywhere
#  is hereby granted if this copyright notice is included.

# edit as needed:
$path_to_perl_interpreter = "D:\\perl_interpreter\\" ;
$path_to_dashrep_compiler = "D:\\dashrep_compiler\\" ;

$list_of_input_items_as_text = '' ;
while( $input_line = <STDIN> ) {
    chomp( $input_line ) ;
    $list_of_input_items_as_text .= ' ' . $input_line ;
}
$list_of_input_items_as_text =~ s/\n/ /sg ;
$list_of_input_items_as_text =~ s/^ +// ;
$list_of_input_items_as_text =~ s/ +$// ;
$list_of_input_items_as_text =~ s/  +/ /g ;
$list_of_input_items_as_text =~ s/[^ a-z0-9_\-]/_/ig ;
if ( $list_of_input_items_as_text ne '' ) {
    @list_of_input_items = split( / +/ , $list_of_input_items_as_text ) ;
} else {
    @list_of_input_items = ( ) ;
}

$compile_execute_mode = 'compile' ;
foreach $input_item ( @list_of_input_items ) {
    if ( $input_item eq 'compile' ) {
        $compile_execute_mode = 'compile' ;
    } elsif ( $input_item eq 'execute' ) {
        $compile_execute_mode = 'execute' ;
    } elsif ( $input_item eq 'skip' ) {
        $compile_execute_mode = 'skip' ;
    } else {
        if ( $compile_execute_mode eq 'skip' ) {
            next ;
        } elsif ( $compile_execute_mode eq 'compile' ) {
            print 'Source file:  code_for_compile_' . $input_item . '.txt' . "\n" ;

            open( OUTFILE2, '>' . 'output_trace.txt' ) ;
            print OUTFILE2 '' . "\n" ;
            close( OUTFILE2 ) ;

            open( OUTFILE2, '>' . 'output_from_dashrep_compiler.pl' ) ;
            print OUTFILE2 '' . "\n" ;
            close( OUTFILE2 ) ;

            open( OUTFILE, '>' . 'output_log_from_dashrep_compiler_for_' . $input_item . '.txt' ) ;
            $command_string_without_pipe = $path_to_perl_interpreter . 'perl -w ' . $path_to_dashrep_compiler . 'dashrep_compiler_executable.pl < ' . 'code_for_compile_' . $input_item . '.txt' ;
            if ( not( $process_id = open( RUNSCRIPT , $command_string_without_pipe . '|' ) ) ) {
                print 'Error, cannot run command: ' . $command_string_without_pipe . "\n" ;
                exit ;
            }
            print 'Running command: ' . $command_string_without_pipe . "\n" ;
            print 'Running process ID: ' . $process_id . "\n" ;
            while( $input_line = <RUNSCRIPT> ) {
                chomp( $input_line ) ;
                print OUTFILE $input_line . "\n" ;
            }
            close( OUTFILE ) ;
            close( RUNSCRIPT ) ;

            open( INFILE, '<' . 'output_from_dashrep_compiler.pl' ) ;
            open( OUTFILE2, '>' . 'executable_' . $input_item . '.pl' ) ;
            while( $input_line = <INFILE> ) {
                chomp( $input_line ) ;
                print OUTFILE2 $input_line . "\n" ;
            }
            close( INFILE ) ;
            close( OUTFILE2 ) ;
        } elsif ( $compile_execute_mode eq 'execute' ) {
            print 'Executable file:  executable_' . $input_item . '.txt' . "\n" ;

            open( OUTFILE, '>' . 'output_log_from_executable_for_' . $input_item . '.txt' ) ;
            $command_string_without_pipe = $path_to_perl_interpreter . 'perl -w ' . 'executable_' . $input_item . '.pl' ;
            if ( not( $process_id = open( RUNSCRIPT , $command_string_without_pipe . '|' ) ) )
            {
                print 'Error, cannot run command: ' . $command_string_without_pipe . "\n" ;
                exit ;
            }
            print 'Running command: ' . $command_string_without_pipe . "\n" ;
            print 'Running process ID: ' . $process_id . "\n" ;
            while( $input_line = <RUNSCRIPT> ) {
                chomp( $input_line ) ;
                print OUTFILE $input_line . "\n" ;
            }
            close( OUTFILE ) ;

            open( INFILE, '<' . 'output_trace.txt' ) ;
            open( OUTFILE2, '>' . 'output_trace_execute_from_' . $input_item . '.txt' ) ;
            while( $input_line = <INFILE> ) {
                chomp( $input_line ) ;
                print OUTFILE2 $input_line . "\n" ;
            }

        }
    }
}

print 'Finished' . "\n" ;
