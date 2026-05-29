//  dashrep_compile_run.cpp
//  -----------------------
//
//  Runs shell commands that compile and run a Dashrep program.
//
//  Usage:
//  g++ -std=c++17 -o dashrep_compile_run dashrep_compile_run.cpp
//  ./dashrep_compile_run <parameter> [<compiler_dir>]
//
//  <parameter> must contain only letters, digits, and underscores
//  <compiler_dir> optional path to directory containing dashrep_compiler_executable.pl
//  default path is local
//
//  Assume Dashrep code is in file named 
//  input_file          = "dashrep_" + param + ".txt";
//
//  Output files:
//  output_trace        = "output_trace_" + param + ".txt";
//  output_trace_copy   = "output_trace_from_dashrep_compiler_" + param + ".txt";
//  compiler_log        = "output_log_from_dashrep_compiler_" + param + ".txt";
//  compiled_script     = "output_from_dashrep_compiler.pl";
//  run_output          = "output_from_running_" + param + ".txt";
//
//---------------------------------------------------

#include <iostream>
#include <string>
#include <cstdlib>
#include <cctype>

// Validates that the parameter contains only letters, digits, and underscores.
bool isValidParam(const std::string& param) {
    if (param.empty()) {
        return false;
    }
    for (char c : param) {
        if (!std::isalpha(static_cast<unsigned char>(c)) &&
            !std::isdigit(static_cast<unsigned char>(c)) &&
            c != '_') {
            return false;
        }
    }
    return true;
}

// Runs a shell command and returns its exit code.
int run(const std::string& cmd) {
    std::cout << "Running: " << cmd << std::endl;
    int ret = std::system(cmd.c_str());
    if (ret != 0) {
        std::cerr << "Warning: command exited with code " << ret
                  << ": " << cmd << std::endl;
    }
    return ret;
}

int main(int argc, char* argv[]) {


    if (argc < 2 || argc > 3) {
        std::cerr << "Usage: " << argv[0] << " <parameter> [<compiler_dir>]" << std::endl;
        std::cerr << "  <parameter>    must contain only letters, digits, and underscores." << std::endl;
        std::cerr << "  <compiler_dir> optional path to directory containing dashrep_compiler_executable.pl" << std::endl;
        std::cerr << "                 (default: ./dashrep_compiler_executable.pl)" << std::endl;
        return 1;
    }

    std::string param(argv[1]);

    if (!isValidParam(param)) {
        std::cerr << "Error: parameter \"" << param
                  << "\" contains invalid characters. "
                  << "Only letters, digits, and underscores are allowed." << std::endl;
        return 1;
    }

    std::string compiler_dir = (argc == 3) ? std::string(argv[2]) : ".";
    // Ensure no trailing slash before appending filename
    if (!compiler_dir.empty() && compiler_dir.back() == '/') {
        compiler_dir.pop_back();
    }
    std::string compiler_path = compiler_dir + "/dashrep_compiler_executable.pl";

    // Build filenames from the parameter.
    std::string output_trace        = "output_trace_" + param + ".txt";
    std::string output_trace_copy   = "output_trace_from_dashrep_compiler_" + param + ".txt";
    std::string input_file          = "dashrep_" + param + ".txt";
    std::string compiler_log        = "output_log_from_dashrep_compiler_" + param + ".txt";
    std::string compiled_script     = "output_from_dashrep_compiler.pl";
    std::string run_output          = "output_from_running_" + param + ".txt";

    // Step 1: Remove old trace files (ignore errors if they don't exist).
    run("rm -f " + output_trace);
    run("rm -f " + output_trace_copy);

    // Step 2: Run the Dashrep compiler.
    std::string compile_cmd =
        "perl -w " + compiler_path + " < " + input_file +
        " > " + compiler_log;
    int compile_ret = run(compile_cmd);
    if (compile_ret != 0) {
        std::cerr << "Error: Dashrep compiler step failed." << std::endl;
        return compile_ret;
    }

    // Step 3: Copy the compiler's trace output.
    run("cp output_trace.txt " + output_trace_copy);

    // Step 4: Run the compiled Perl script.
    std::string run_cmd =
        "perl -w " + compiled_script + " > " + run_output;
    int run_ret = run(run_cmd);
    if (run_ret != 0) {
        std::cerr << "Error: Running compiled script failed." << std::endl;
        return run_ret;
    }

    std::cout << "Done. Output written to " << run_output << std::endl;
    return 0;
}
