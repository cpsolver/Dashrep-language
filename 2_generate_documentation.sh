#!/bin/bash

#  the -f flag suppresses errors if the file doesn't exist, matching the silent behavior of del
rm -f output_trace.txt
perl -w dashrep_compiler_executable.pl < specifications_phrase_descriptions.txt > output_log_compile_dashrep_documentation_generator.txt
cp output_from_dashrep_compiler.pl output_dashrep_documentation_generator.pl
cp output_trace.txt output_trace_from_compiling_documentation_generator.txt
perl output_dashrep_documentation_generator.pl > output_log_documentation.txt
ls -l output_specifications_documentation.html
read -p "Press Enter to continue..."
