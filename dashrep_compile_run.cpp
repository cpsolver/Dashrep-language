//  dashrep_compile_run.cpp
//  -----------------------
//
//  Runs shell commands that compile and run a Dashrep program.
//
//  Usage:
//  g++ -std=c++17 -o dashrep_compile_run dashrep_compile_run.cpp
//  ./dashrep_compile_run <parameter> [<compiler_dir>]
//
//  <parameter> must contain only letters, digits, and underscores.
//
//  <compiler_dir> is an optional path to the directory
//  that contains the file: dashrep_compiler_executable.pl
//  If omitted, the default path is local.
//
//  Assume Dashrep code is in file named 
//  input_file          = "dashrep_" + param + ".txt";
//
//  For output files, see code.
//
//---------------------------------------------------

#include <iostream>
#include <string>
#include <cstdlib>
#include <cctype>
#include <filesystem>
#include <fstream>

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
    int ret = std::system(cmd.c_str());
    if (ret != 0) {
        std::cout << "Attempted to run: " << cmd << std::endl;
        std::cerr << "Warning: command exited with code " << ret
                  << ": " << cmd << std::endl;
    }
    return ret;
}


// Deletes a file.
void delete_file(const std::string& path) {
    std::error_code ec;
    std::filesystem::remove(path, ec);
    // Ignore error
}


// Copies a file.
void copy_file(const std::string& src, const std::string& dst) {
    std::error_code ec;
    std::filesystem::copy_file(
        src, dst,
        std::filesystem::copy_options::overwrite_existing,
        ec);
    if (ec) {
        std::cerr << "Error copying " << src << " to " << dst
                  << ": " << ec.message() << std::endl;
    }
}


// Main code.
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
    std::string name_of_temporary_file;

    // Build filenames.
    std::string input_file = "dashrep_" + param + ".txt";
    std::string output_trace_from_compiler = "output_trace_from_dashrep_compiler_" + param + ".txt";
    std::string compiled_runtime_program = "output_compiled_dashrep_program_" + param + ".pl";
    std::string output_trace = "output_trace_" + param + ".txt";
    std::string compiler_log = "output_log_from_dashrep_compiler_" + param + ".txt";
    std::string output_from_dashrep_compiler = "output_from_dashrep_compiler" + param + ".txt";
    std::string run_output = "output_from_running_" + param + ".txt";
    std::string output_trace_from_running = "output_trace_from_running_" + param + ".txt";

    // Build path to compiler.
    std::string compiler_path = compiler_dir + "/dashrep_compiler_executable.pl";

    // Remove files from previous run.
    delete_file(output_trace_from_compiler);
    delete_file(compiled_runtime_program);
    delete_file(output_trace);
    delete_file(compiler_log);
    delete_file(output_from_dashrep_compiler);
    delete_file(run_output);
    delete_file(output_trace_from_running);

    // Run the Dashrep compiler.
    std::string compile_cmd =
        "perl -w " + compiler_path + " < " + input_file +
        " > " + compiler_log;
    int compile_ret = run(compile_cmd);
    if (compile_ret != 0) {
        std::cerr << "Error: Dashrep compiler error." << std::endl;
        return compile_ret;
    }

    // Copy the compiler's trace output.
    copy_file("output_trace.txt", output_trace_from_compiler);
    name_of_temporary_file = "output_trace.txt";
    delete_file(name_of_temporary_file);

    // Copy the compiled runtime code.
    copy_file("output_from_dashrep_compiler.pl", compiled_runtime_program);

    // Delete duplicate files and files only needed for debugging compiler.
    name_of_temporary_file = "output_from_dashrep_compiler.pl";
    delete_file(name_of_temporary_file);
    name_of_temporary_file = "output_compiler_functions_replacement_only.txt";
    delete_file(name_of_temporary_file);
    name_of_temporary_file = "output_compiler_all_function_branches.txt";
    delete_file(name_of_temporary_file);
    name_of_temporary_file = "output_compiler_all_definition_items.txt";
    delete_file(name_of_temporary_file);
    name_of_temporary_file = "output_compiler_all_compiled_functions.txt";
    delete_file(name_of_temporary_file);

    // Run the compiled Perl script.
    std::string run_cmd =
        "perl -w " + compiled_runtime_program + " > " + run_output;
    int run_ret = run(run_cmd);
    if (run_ret != 0) {
        std::cerr << "Error: Running compiled script failed." << std::endl;
        return run_ret;
    }

    std::cout << "Compiled, run, output written to " << run_output << std::endl;
    return 0;
}
