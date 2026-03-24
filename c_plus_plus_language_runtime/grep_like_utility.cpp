//  grep_like_utility.cpp

//  Usage:
//  g++ -std=c++17 -o grep_like_utility grep_like_utility.cpp
//  ./grep_like_utility < input.txt > output.txt


#include <iostream>
#include <string>
#include <regex>
#include <algorithm>
#include <cctype>

int main(int argc, char* argv[]) {
    std::string line_in;
    std::string line_out;
    std::string pattern_to_find;
    std::string newline_pattern;
    std::smatch pattern_matches;
    pattern_to_find = " =~ " ;
    newline_pattern = "\\n" ;
    while (std::getline(std::cin, line_in)) {
        if (!line_in.empty() && line_in.back() == '\r') {
            line_in.pop_back();
        }
        line_out = line_in;

        // Leave comments otherwise unchanged.
        if (std::regex_search(line_out, pattern_matches, std::regex(R"(^// )"))) {
            std::cout << line_out << '\n';
            continue;
        }



// read-line-begin
// std::getline(

// read-line-end

//        line_out = std::regex_replace(line_out, std::regex(R"(^( *)whatever (.+)$)"), "$1read-line $2");




// foreach

//        line_out = std::regex_replace(line_out, std::regex(R"(foreach )"), "for-each ");


// perl:
// void function_parameterized__get_list_of_words( ) {  <new_line>
// std::string local_text ;  <new_line>
// std::string globallist_of_operands ;  <new_line>
// local_text = $_[ 0 ] ;  <new_line>
// cpp:
// void processInput(const std::vector<std::string>& args) {
//     std::string local_text;
//     if (!args.empty()) {
//         local_text = args[0];
//     } else {
//         local_text = "";
//     }


        if (line_out != line_in) {
            std::cout << "// before: " << line_in << '\n';
//            std::cout << line_out << '\n';
//            std::cout << '\n';
        }

        std::cout << line_out << '\n';

    }
    return 0;


//        line_out = std::regex_replace(line_out, std::regex(R"( sprintf\( *"%d" *, *([^\(\)]+) *\))"), " convert-integer-to-string-begin $1 convert-to-string-end ");

//        line_out = std::regex_replace(line_out, std::regex(R"( \.= )"), " += ");
//        line_out = std::regex_replace(line_out, std::regex(R"(global_dashrep_replacement\[ (\w+) \} )"), "global_dashrep_replacement[ $1 ] ");
//        line_out = std::regex_replace(line_out, std::regex(R"( elsif )"), " else if ");

//         // Limit which lines might get modified.
//         if (false) {
// //        if (line_out.find(" =~ ") != std::string::npos) {

//             if (line_out.find(" =~ s") != std::string::npos) {
//                 line_out = std::regex_replace(line_out, std::regex(R"(([\w{}\[\] ]+?) =~ s/((?:[^/\\]|\\.)*)/([^/]*)/[gimsxy]* ;)"), "replace-begin $1 replace-equals $1 replace-this <regex_begin>$2<regex_end> with-this <regex_begin>$3<regex_end> replace-end");
//                 line_out = std::regex_replace(line_out, std::regex(R"(replace-begin  +)"), "replace-begin ");
//                 line_out = std::regex_replace(line_out, std::regex(R"( replace-equals  +)"), " replace-equals ");
//             }

//             line_out = std::regex_replace(line_out, std::regex(R"(<regex_begin>)"), "R\"(");
//             line_out = std::regex_replace(line_out, std::regex(R"(<regex_end>)"), ")\"");

//             std::cout << "// before: " << line_in << '\n';
//             std::cout << line_out << '\n';
//             std::cout << '\n';
//             continue;

//         }


// if need to only replace first match (not globally):
// global_prefix = std::regex_replace(global_prefix, std::regex(R"([ \n]+)"), "", 
//       std::regex_constants::format_first_only);


// in following code, second "s" does nothing meaningful:
//  global_list_of_words_as_text =~ s/\n/ /sg ;
// just in case,
//  std::regex(R"(foo.bar)", std::regex_constants::ECMAScript) // dot does NOT match \n by default
// To make dot match \n, there's no direct flag in std::regex, but you can use:
//  std::regex(R"(foo[\s\S]bar)")  // workaround: [\s\S] matches any character including \n


// Already used:
        // if (line_out.find(" =~ ") != std::string::npos) {


        //     if (line_out.find(" =~ /") != std::string::npos) {
        //         line_out = std::regex_replace(line_out, std::regex(R"( =~ )"), R"( looks-like-begin )");
        //     }

        //     if (line_out.find(" looks-like-begin ") != std::string::npos) {
        //         line_out = std::regex_replace(line_out, std::regex(R"(( looks-like-begin )/([^/]*)/)"), "$1 <regex_begin>$2<regex_end> looks-like-end");
        //     }

        //     if (line_out.find(" =~ s /") != std::string::npos) {
        //         line_out = std::regex_replace(line_out, std::regex(R"( =~ s /)"), R"( =~ s/)");
        //     }

        //     if (line_out.find(" =~ s") != std::string::npos) {
        //         line_out = std::regex_replace(line_out, std::regex(R"(([\w{}\[\] ]+?) =~ s/((?:[^/\\]|\\.)*)/([^/]*)/[gimsxy]* ;)"), "replace-begin $1 replace-equals $1 replace-this <regex_begin>$2<regex_end> with-this <regex_begin>$3<regex_end> replace-end");
        //         line_out = std::regex_replace(line_out, std::regex(R"(replace-begin  +)"), "replace-begin ");
        //         line_out = std::regex_replace(line_out, std::regex(R"( replace-equals  +)"), " replace-equals ");
        //     }

        //     line_out = std::regex_replace(line_out, std::regex(R"(<regex_begin>)"), "R\"(");
        //     line_out = std::regex_replace(line_out, std::regex(R"(<regex_end>)"), ")\"");


        // line_out = std::regex_replace(line_out, std::regex(R"(^( *)std::vector<std::string> (.+)$)"), "$1declare-decimal $2");
        // line_out = std::regex_replace(line_out, std::regex(R"(^( *)std::unordered_map<std::string, std::string> (.+)$)"), "$1declare-key-value-pair-map $2");
        // line_out = std::regex_replace(line_out, std::regex(R"(^( *)double (.+)$)"), "$1declare-decimal $2");
        // line_out = std::regex_replace(line_out, std::regex(R"(^( *)int (.+)$)"), "$1declare-integer $2");
        // line_out = std::regex_replace(line_out, std::regex(R"(^( *)std::string (.+)$)"), "$1declare-string $2");


        // line_out = std::regex_replace(line_out, std::regex(R"(std::cout << OUTFILE (.+) \+ "\\n" ;)"), "write-to-file-begin $1 write-to-file-end-of-line ;");
        // line_out = std::regex_replace(line_out, std::regex(R"(std::cout << TRACE_OUT (.+) \+ "\\n" ;)"), "write-to-trace-file-begin $1 write-to-file-end-of-line ;");
        // if (std::regex_search(line_out, pattern_matches, std::regex(R"(write-to-[^ ]+-begin)"))) {
        //     line_out = std::regex_replace(line_out, std::regex(R"( \+ )"), " write-more ");
        // }



}
