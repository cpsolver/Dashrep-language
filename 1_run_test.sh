#!/bin/bash

# ---------- verify needed files exist ----------
ls -l dashrep_compiler_executable.pl
ls -l dashrep_test_code_joined_dashdefs.txt

# ---------- compile and run the test code ----------

find ./test_dashrep_code/ -name "*-*.txt" > test_code_list_of_dashdef_files.txt
perl combine_listed_dashdefs.pl < test_code_list_of_dashdef_files.txt > dashrep_test_code_joined_dashdefs.txt
perl -w dashrep_compiler_executable.pl < dashrep_test_code_joined_dashdefs.txt > output_log_from_dashrep_compiler.txt
rm -f executable_test_dashrep_compiler.pl
mv output_from_dashrep_compiler.pl executable_test_dashrep_compiler.pl
cp output_trace.txt output_trace_from_dashrep_compiler_generate_test.txt
rm -f output_display_values_not_correct.txt
perl -w executable_test_dashrep_compiler.pl > output_piped_executable_test_dashrep_compiler.html
cp output_trace.txt output_trace_from_dashrep_compiler_execute_test.txt

# ---------- compile and run the "dolphin talkative" example ----------
perl -w dashrep_compiler_executable.pl < input_dashrep_dolphin_talkative.txt > output_log_from_dashrep_compiler.txt
rm -f executable_dolphin_talkative.pl
mv output_from_dashrep_compiler.pl executable_dolphin_talkative.pl
cp output_trace.txt output_trace_from_dashrep_dolphin_talkative.txt
perl executable_dolphin_talkative.pl > output_piped_results_from_dashrep_dolphin_talkative.txt

# ---------- all done ----------
read -p "Press Enter to continue..."
