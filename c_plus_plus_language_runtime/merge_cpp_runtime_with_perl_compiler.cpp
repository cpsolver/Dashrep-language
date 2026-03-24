// merge_cpp_runtime_with_perl_compiler.cpp
//
// Reads:
//   input_to_dashrep_compiler.txt        — Dashrep phrase definitions
//   dashrep_compiler_executable__version_for_merge_testing.pl  — machine-generated Perl file
//
// The Perl file contains triplets of consecutive lines in this exact format:
//
//   Line 1: my $storage_item__NNNN = 'phrase-name' ;
//   Line 2: my $storage_item__MMMM = <any rhs expression> ;   (MMMM = NNNN + 1)
//   Line 3: $global_dashrep_replacement{ $storage_item__NNNN } = $storage_item__MMMM ;
//
// For each triplet where the phrase name on line 1 matches a definition in
// the Dashrep file, line 2's right-hand side is replaced with the Dashrep
// definition encoded as a plain single-quoted Perl string (newlines → space).
// Lines 1 and 3 are written unchanged.  All other lines pass through unchanged.
//
// Output goes to stdout.  Progress messages go to stderr.

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <map>
#include <regex>
#include <algorithm>

static std::string trim(const std::string& s) {
    size_t a = s.find_first_not_of(" \t\r\n");
    if (a == std::string::npos) return "";
    size_t b = s.find_last_not_of(" \t\r\n");
    return s.substr(a, b - a + 1);
}

// Encode a Dashrep definition as the rhs of a Perl assignment.
// Produces:  'definition text with newlines replaced by spaces' ;
// Only ' and \ need escaping inside a Perl single-quoted string.
static std::string encode_as_perl_rhs(const std::string& def) {
    std::string encoded;
    for (char c : def) {
        if (c == '\'') {
            encoded += "\\'";
        } else if (c == '\\') {
            encoded += "\\\\";
        } else if (c == '\n') {
            if (!encoded.empty() && encoded.back() != ' ')
                encoded += ' ';
        } else {
            encoded += c;
        }
    }
    while (!encoded.empty() && encoded.back() == ' ')
        encoded.pop_back();
    return "'" + encoded + "' ;";
}

// Read the Dashrep definitions file.
// Format:  phrase-name:\n definition lines \n ----\n ...
static std::map<std::string, std::string>
read_dashrep_definitions(const std::string& path) {
    std::map<std::string, std::string> defs;
    std::ifstream f(path);
    if (!f) { std::cerr << "ERROR: cannot open: " << path << "\n"; return defs; }

    std::string line, current_name;
    std::vector<std::string> def_lines;
    bool reading_def = false;

    auto flush = [&]() {
        if (!current_name.empty()) {
            size_t start = 0, end = def_lines.size();
            while (start < end && trim(def_lines[start]).empty()) start++;
            while (end > start && trim(def_lines[end-1]).empty()) end--;
            std::string def;
            for (size_t i = start; i < end; i++) {
                if (!def.empty()) def += "\n";
                def += def_lines[i];
            }
            defs[current_name] = def;
        }
        current_name.clear();
        def_lines.clear();
        reading_def = false;
    };

    while (std::getline(f, line)) {
        if (trim(line) == "----") { flush(); continue; }
        if (!reading_def) {
            if (!line.empty() && line.back() == ':') {
                current_name = trim(line.substr(0, line.size() - 1));
                reading_def = true;
            }
            continue;
        }
        def_lines.push_back(line);
    }
    flush();
    return defs;
}

// Process the Perl file, replacing matched triplets.
static void process_perl_file(
    const std::string& path,
    const std::map<std::string, std::string>& dashrep_defs)
{
    std::ifstream f(path);
    if (!f) { std::cerr << "ERROR: cannot open: " << path << "\n"; return; }

    // Line 1: my $storage_item__NNNN = 'phrase-name' ;
    static const std::regex line1_re(
        R"(^\s*my\s+\$storage_item__(\d+)\s*=\s*'([^']*)'\s*;\s*$)");
    // Line 2: my $storage_item__MMMM = <anything> ;
    static const std::regex line2_re(
        R"(^\s*my\s+\$storage_item__(\d+)\s*=\s*.+;\s*$)");
    // Line 2 prefix (up to and including '= ') for preserving indentation
    static const std::regex line2_prefix_re(
        R"(^(\s*my\s+\$storage_item__\d+\s*=\s*))");
    // Line 3: $global_dashrep_replacement{ $storage_item__NNNN } = $storage_item__MMMM ;
    static const std::regex line3_re(
        R"(^\s*\$global_dashrep_replacement\s*\{\s*\$storage_item__(\d+)\s*\}\s*=\s*\$storage_item__(\d+)\s*;\s*$)");

    std::vector<std::string> lines;
    std::string line;
    while (std::getline(f, line)) lines.push_back(line);

    int replaced = 0;
    size_t i = 0;
    while (i < lines.size()) {
        std::smatch m1;
        if (i + 2 < lines.size() &&
            std::regex_match(lines[i], m1, line1_re))
        {
            long        num1   = std::stol(m1[1].str());
            std::string phrase = m1[2].str();

            std::smatch m2, m3;
            bool ok2 = std::regex_match(lines[i+1], m2, line2_re);
            bool ok3 = std::regex_match(lines[i+2], m3, line3_re);

            long num2 = ok2 ? std::stol(m2[1].str()) : -1;
            long n3a  = ok3 ? std::stol(m3[1].str()) : -1;
            long n3b  = ok3 ? std::stol(m3[2].str()) : -1;

            bool valid_triplet = ok2 && ok3
                              && num2 == num1 + 1
                              && n3a  == num1
                              && n3b  == num2;

            if (valid_triplet) {
                auto it = dashrep_defs.find(phrase);
                if (it != dashrep_defs.end()) {
                    // Compute the new line 2 rhs
                    std::smatch mp;
                    std::string prefix;
                    if (std::regex_search(lines[i+1], mp, line2_prefix_re))
                        prefix = mp[1].str();
                    else
                        prefix = "my $storage_item__" + std::to_string(num2) + " = ";
                    std::string new_line2 = prefix + encode_as_perl_rhs(it->second);

                    // Check if there is an actual change
                    bool changed = (new_line2 != lines[i+1]);

                    // Diagnostic comment: phrase name and first 60 chars of definition
                    std::string def_preview = it->second;
                    for (char& c : def_preview) if (c == '\n') c = ' ';
                    if (def_preview.size() > 60) def_preview = def_preview.substr(0, 60) + "...";
                    std::string diag = "# MERGE: phrase=\"" + phrase + "\" def=\"" + def_preview + "\"";
                    if (!changed) diag += " (no change)";

                    // Emit diagnostic comment, then the triplet
                    std::cout << diag << "\n";
                    std::cout << lines[i] << "\n";
                    if (changed) {
                        std::cout << new_line2 << "\n";
                        std::cerr << "  Replaced: \"" << phrase << "\"\n";
                        replaced++;
                    } else {
                        std::cout << lines[i+1] << "\n";
                        std::cerr << "  No change: \"" << phrase << "\"\n";
                    }
                    std::cout << lines[i+2] << "\n";
                    i += 3;
                    continue;
                }
            }
        }
        std::cout << lines[i] << "\n";
        i++;
    }
    std::cerr << "Total replacements: " << replaced << "\n";
}

int main() {
    const std::string dashrep_file = "input_to_dashrep_compiler.txt";
    const std::string perl_file    = "dashrep_compiler_executable__version_for_merge_testing.pl";

    auto dashrep_defs = read_dashrep_definitions(dashrep_file);
    std::cerr << "Read " << dashrep_defs.size() << " Dashrep phrase definitions.\n";

    process_perl_file(perl_file, dashrep_defs);
    return 0;
}