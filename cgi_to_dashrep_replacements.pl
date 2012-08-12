package cgi_to_dashrep_replacements;

#  The function in this package converts CGI
#  (web-page-based) input values into Dashrep
#  replacement phrases.


#  COPYRIGHT & LICENSE

#  Copyright 2011 Richard Fobes at www.Dashrep.org, all rights reserved.

#  You can redistribute and/or modify this library module
#  under the Perl Artistic license, a copy
#  of which is included in the LICENSE file.


#  TO DO:  Properly define this file as a package.



#-----------------------------------------------
#-----------------------------------------------
#           get_input_information
#-----------------------------------------------
#-----------------------------------------------
#  Subroutine that gets form data from previous
#  web page, or else gets the input information
#  from the standard input.  Put the information
#  into Dashrep phrases with the prefix
#  "input-" added to the element name.

sub get_input_information
{

    my ( @name_value_pairs ) ;

    my ( $input_encountered ) ;
    my ( $raw_input ) ;
    my ( $input_line ) ;
    my ( $name_value ) ;
    my ( $name ) ;
    my ( $value ) ;
    my ( $env_variable_name ) ;
    my ( $cgi_length_limit ) ;
    my ( $input_value_name ) ;
    my ( $choice_number ) ;


#-----------------------------------------------
#  Initialization.

    $input_encountered = $global_false ;


#-----------------------------------------------
#  Protect against an excessively long input string.

    $cgi_length_limit = 10000000 ;

    if ( $ENV{ "CONTENT_LENGTH" } > $cgi_length_limit )
    {
        $global_error_message = &dashrep_get_replacement( "error-message-input-way-too-long-part1" ) . $ENV{ "CONTENT_LENGTH" } . &dashrep_get_replacement( "error-message-input-way-too-long-part2" ) ;
        return ;
    }


#-----------------------------------------------
#  Read the input text.
#  If it is not available through the CGI-supplied "GET"
#  approach, read it from the input file,
#  which also might be CGI-supplied information
#  (using the "POST" approach).
#  If it is in multiple lines, replace the
#  newline code with a space.

#  Note:  The "GET" method is needed in order to
#  recognize environment variables after the
#  question mark in a URL.

    if ( $ENV{ "REQUEST_METHOD" } eq 'GET' )
    {
        $raw_input = $ENV{ "QUERY_STRING" } ;

    } else {
        while( $input_line = <STDIN> )
        {
            chomp( $input_line ) ;
            $raw_input .= $input_line . " " ;
        }

    }


#-----------------------------------------------
#  Get the user's IP address and port number.

    $global_ip_address = $ENV{ "REMOTE_ADDR" } ;
    $global_port = $ENV{ "REMOTE_PORT" } ;


#-----------------------------------------------
#  If the information is CGI form data, translate it,
#  separate the values, and put them into Dashrep
#  phrases.

    if ( $raw_input =~ /^(([^ <>]+)=([^ <>]*)(&([^ <>]+)=([^ <>]*))*) *$/ )
    {
        $raw_input = $1 ;

        $raw_input =~ tr/+/ / ;

        @name_value_pairs = split( /&/, $raw_input ) ;
        foreach $name_value ( @name_value_pairs )
        {
            ( $name, $value ) = split( /=/, $name_value, 2 ) ;
            if ( not( defined( $value ) ) )
            {
                $value = '' ;
            }
            $name  =~ s/%([0-9A-F][0-9A-F])/chr (hex ($1))/ieg ;
            $name  =~ s/[<>\/\\]+/_/g ;

            if ( $name eq "texttoimport" )
            {
#               Special preservation of tabs, line breaks, etc. for imported text:
                $value =~ s/%0D//ig ;
                $value =~ s/%([0-9A-F][0-9A-F])/chr (hex ($1))/ieg ;
            } else
            {
                $value =~ s/%([0-9A-F][0-9A-F])/chr (hex ($1))/ieg ;
                $value =~ s/[<>]+/_/gm ;
                $value =~ s/\n/<eol\/>/gm ;
            }

            if ( $name !~ /^ *$/ )
            {
                &dashrep_define( "input-" . $name , $value ) ;
                $input_encountered = $global_true ;
            }
        }
        $raw_input = "" ;
    }


#-----------------------------------------------
#  If the information contains data tagged as
#  <xmlraw>, put it into a single Dashrep phrase,
#  without interpreting any interior XML tags.

    if ( $raw_input =~ /<xmlraw>/i )
    {
        $raw_input =~ s/><eol\/>/>/g ;
        $raw_input =~ s/><eol\/>/>/g ;
        $raw_input =~ s/<eol\/></</g ;
        $raw_input =~ s/<eol\/></</g ;

        if ( $raw_input =~ /^(.*?)<xmlraw>(.*)<\/xmlraw>(.*)$/is )
        {
            $value = $2 ;
            $raw_input = $1 . $3 ;
            &dashrep_define( "input-xmlraw" , $value ) ;
            $input_encountered = $global_true ;
        }
    }


#-----------------------------------------------
#  If one of the CGI input parameters was "xml",
#  put that parameter value back into the input
#  text string so that it can be split up in the
#  next section.

    if ( &dashrep_get_replacement( "input-xml" ) =~ /<xml>/ )
    {
        $raw_input = "<xml>" . &dashrep_get_replacement( "input-xml" ) . "<\/xml>" ;
        &dashrep_define( "input-xml" , "" ) ;
    }


#-----------------------------------------------
#  If the information is in XML format,
#  remove spaces that are adjacent to XML tags,
#  and remove <eol/> tags that are adjacent to another
#  tag, then extract the information and put it
#  into Dashrep phrases.

    if ( $raw_input =~ /<xml>/i )
    {
        $raw_input =~ s/> +/>/g ;
        $raw_input =~ s/ +</</g ;
        if ( $name ne "texttoimport" )
        {
            $raw_input =~ s/><eol\/>/>/g ;
            $raw_input =~ s/><eol\/>/>/g ;
            $raw_input =~ s/<eol\/></</g ;
            $raw_input =~ s/<eol\/></</g ;
        }

        while ( $raw_input =~ /^(.*?)<([^<>\/]+)>([^<>]*)<\/[^<>\/]+>(.*)$/is )
        {
            $name = $2 ;
            $value = $3 ;
            $raw_input = $1 . $4 ;
            if ( $name !~ /^ *$/ )
            {
                &dashrep_define( "input-" . $name , $value ) ;
                $input_encountered = $global_true ;
            }
        }

        $raw_input = "" ;
    }


#-----------------------------------------------
#  If the input information is empty or unrecognized,
#  try getting a value for "accessid" from a different
#  environment variable -- due to access from an external
#  link.

    if ( $input_encountered == $global_false )
    {
        $env_variable_name = "" ;

        if ( $ENV{ "PATH_INFO" } =~ /accessid=([a-z0-9\-]+)/i )
        {
            &dashrep_define( "input-accessid" , $1 ) ;
            $env_variable_name = "PATH_INFO" ;

        } elsif ( $ENV{ "PATH_TRANSLATED" } =~ /accessid=([a-z0-9\-]+)/i )
        {
            &dashrep_define( "input-accessid" , $1 ) ;
            $env_variable_name = "PATH_TRANSLATED" ;

        } elsif ( $ENV{ "REQUEST_URI" } =~ /accessid=([a-z0-9\-]+)/i )
        {
            &dashrep_define( "input-accessid" , $1 ) ;
            $env_variable_name = "REQUEST_URI" ;

        } elsif ( $ENV{ "PATH_INFO" } =~ /\/([a-z0-9\-]+)[^\/]*$/i )
        {
            &dashrep_define( "input-accessid" , $1 ) ;
            $env_variable_name = "PATH_INFO" ;

        } elsif ( $ENV{ "PATH_TRANSLATED" } =~ /\/([a-z0-9\-]+)[^\/]*$/i )
        {
            &dashrep_define( "input-accessid" , $1 ) ;
            $env_variable_name = "PATH_TRANSLATED" ;

        } elsif ( $ENV{ "REQUEST_URI" } =~ /\/([a-z0-9\-]+)[^\/]*$/i )
        {
            &dashrep_define( "input-accessid" , $1 ) ;
            $env_variable_name = "REQUEST_URI" ;

        }

        if ( $env_variable_name ne "" )
        {
            $raw_input = $ENV{ $env_variable_name } ;
            $input_encountered = $global_true ;
            &dashrep_define( "input-action" , "fromlink" ) ;
        }

    }


#-----------------------------------------------
#  End of subroutine.

    return ;

}

1; # End of package
