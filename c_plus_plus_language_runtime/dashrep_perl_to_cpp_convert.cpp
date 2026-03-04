// perl_to_cpp_converter.cpp
// Converts Perl subroutines to C++ using common Dashrep-style conversion patterns.
// Usage: ./perl_to_cpp_converter input.pl [output.cpp]

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <regex>
#include <functional>
#include <map>
#include <set>

// ---------------------------------------------------------------------------
// Utility helpers
// ---------------------------------------------------------------------------

static std::string read_file(const std::string& path) {
    std::ifstream f(path);
    if (!f) {
        std::cerr << "Error: cannot open '" << path << "'\n";
        std::exit(1);
    }
    std::ostringstream ss;
    ss << f.rdbuf();
    return ss.str();
}

static void write_file(const std::string& path, const std::string& content) {
    std::ofstream f(path);
    if (!f) {
        std::cerr << "Error: cannot write '" << path << "'\n";
        std::exit(1);
    }
    f << content;
}

// Replace all occurrences of `from` with `to` in `s`
static std::string replace_all(std::string s, const std::string& from, const std::string& to) {
    if (from.empty()) return s;
    size_t pos = 0;
    while ((pos = s.find(from, pos)) != std::string::npos) {
        s.replace(pos, from.size(), to);
        pos += to.size();
    }
    return s;
}

// Trim leading/trailing whitespace
static std::string trim(const std::string& s) {
    size_t a = s.find_first_not_of(" \t\r\n");
    if (a == std::string::npos) return "";
    size_t b = s.find_last_not_of(" \t\r\n");
    return s.substr(a, b - a + 1);
}

// Return leading whitespace of a line
static std::string leading_ws(const std::string& line) {
    size_t i = 0;
    while (i < line.size() && (line[i] == ' ' || line[i] == '\t')) ++i;
    return line.substr(0, i);
}

// Split string by newlines
static std::vector<std::string> split_lines(const std::string& s) {
    std::vector<std::string> lines;
    std::istringstream ss(s);
    std::string line;
    while (std::getline(ss, line)) lines.push_back(line);
    return lines;
}

// Join lines with newlines
static std::string join_lines(const std::vector<std::string>& lines) {
    std::string out;
    for (const auto& l : lines) out += l + "\n";
    return out;
}

// ---------------------------------------------------------------------------
// Type inference: determine the C++ type for a Perl variable
// ---------------------------------------------------------------------------

// A registry of all declared variables so we can emit the right C++ type
struct VarInfo {
    std::string name;       // without sigil
    std::string cpp_type;   // resolved C++ type
    bool is_local = false;  // declared with `my`
};

// Explicit type table — all known hash and array globals are listed here.
// Everything else is std::string unless it appears as a for-loop counter (int).
// Hashes: std::unordered_map<std::string, std::string>
// Arrays: std::vector<std::string>  (all arrays hold text values)
static const std::unordered_map<std::string, std::string> known_type_table = {
    // --- Hashes ---
    { "global_content_for_tag",                             "std::unordered_map<std::string, std::string>" },
    { "global_dashrep_replacement",                         "std::unordered_map<std::string, std::string>" },
    { "global_endless_loop_replacements_with_count",        "std::unordered_map<std::string, std::string>" },
    { "global_exists_tag_name",                             "std::unordered_map<std::string, std::string>" },
    { "global_found_unique_value",                          "std::unordered_map<std::string, std::string>" },
    { "global_item_number_at_row_column",                   "std::unordered_map<std::string, std::string>" },
    { "global_listed_word",                                 "std::unordered_map<std::string, std::string>" },
    { "global_number_of_times_encountered_phrase_named",    "std::unordered_map<std::string, std::string>" },
    { "global_occurrence_count_for_word",                   "std::unordered_map<std::string, std::string>" },
    { "global_text_to_find_at_position",                    "std::unordered_map<std::string, std::string>" },
    { "global_words_at_numeric_value",                      "std::unordered_map<std::string, std::string>" },
    { "global_yes_found_word",                              "std::unordered_map<std::string, std::string>" },
    // --- Arrays (all hold std::string values) ---
    { "global_accumulator",                                       "std::vector<std::string>" },
    { "global_begin_position_for_word",                           "std::vector<std::string>" },
    { "global_column_position_for_item_number",                   "std::vector<std::string>" },
    { "global_count_of_items_appended_to_accumulator",            "std::vector<std::string>" },
    { "global_input_list",                                        "std::vector<std::string>" },
    { "global_input_list_one",                                    "std::vector<std::string>" },
    { "global_input_list_two",                                    "std::vector<std::string>" },
    { "global_item_number_found_at_position",                     "std::vector<std::string>" },
    { "global_left_and_up_direction_value_for_item_number",       "std::vector<std::string>" },
    { "global_length_of_word",                                    "std::vector<std::string>" },
    { "global_list",                                              "std::vector<std::string>" },
    { "global_list_indicating_sort_order",                        "std::vector<std::string>" },
    { "global_list_of_action_names",                              "std::vector<std::string>" },
    { "global_list_of_file_names",                                "std::vector<std::string>" },
    { "global_list_of_items_one",                                 "std::vector<std::string>" },
    { "global_list_of_items_two",                                 "std::vector<std::string>" },
    { "global_list_of_key_values",                                "std::vector<std::string>" },
    { "global_list_of_loop_words",                                "std::vector<std::string>" },
    { "global_list_of_paired_words",                              "std::vector<std::string>" },
    { "global_list_of_parameter_words",                           "std::vector<std::string>" },
    { "global_list_of_phrase_names",                              "std::vector<std::string>" },
    { "global_list_of_phrases",                                   "std::vector<std::string>" },
    { "global_list_of_positions",                                 "std::vector<std::string>" },
    { "global_list_of_remaining_item_numbers",                    "std::vector<std::string>" },
    { "global_list_of_sorted_numbers",                            "std::vector<std::string>" },
    { "global_list_of_source_words",                              "std::vector<std::string>" },
    { "global_list_of_start_matching_positions",                  "std::vector<std::string>" },
    { "global_list_of_storage_names",                             "std::vector<std::string>" },
    { "global_list_of_strings_to_match",                          "std::vector<std::string>" },
    { "global_list_of_tag_names",                                 "std::vector<std::string>" },
    { "global_list_of_tag_values_in_sequence_encountered",        "std::vector<std::string>" },
    { "global_list_of_text_items_to_find",                        "std::vector<std::string>" },
    { "global_list_of_unique_values",                             "std::vector<std::string>" },
    { "global_list_of_values_in_column",                          "std::vector<std::string>" },
    { "global_list_of_words",                                     "std::vector<std::string>" },
    { "global_list_of_words_to_check",                            "std::vector<std::string>" },
    { "global_list_of_x_values",                                  "std::vector<std::string>" },
    { "global_list_of_y_values",                                  "std::vector<std::string>" },
    { "global_name_value_pairs",                                  "std::vector<std::string>" },
    { "global_octet_number_at_position",                          "std::vector<std::string>" },
    { "global_phrase_naming_convention_for_column",               "std::vector<std::string>" },
    { "global_phrase_usage_count_for_phrase_number",              "std::vector<std::string>" },
    { "global_pointer_to_whitespace_type",                        "std::vector<std::string>" },
    { "global_right_and_up_direction_value_for_item_number",      "std::vector<std::string>" },
    { "global_right_direction_text_for_item_number",              "std::vector<std::string>" },
    { "global_right_direction_value_for_item_number",             "std::vector<std::string>" },
    { "global_row_position_for_item_number",                      "std::vector<std::string>" },
    { "global_saved_accumulator_pointer_at_recursion_location",   "std::vector<std::string>" },
    { "global_sequence_of_phrases",                               "std::vector<std::string>" },
    { "global_sort_order",                                        "std::vector<std::string>" },
    { "global_text_item_in_column",                               "std::vector<std::string>" },
    { "global_unique_word_at_position",                           "std::vector<std::string>" },
    { "global_up_direction_text_for_item_number",                 "std::vector<std::string>" },
    { "global_up_direction_value_for_item_number",                "std::vector<std::string>" },
    { "global_value_in_column",                                   "std::vector<std::string>" },
    { "global_word_begin_operand_one_at_word",                    "std::vector<std::string>" },
    { "global_word_begin_operand_three_at_word",                  "std::vector<std::string>" },
    { "global_word_begin_operand_two_at_word",                    "std::vector<std::string>" },
    { "global_word_length_operand_one_at_word",                   "std::vector<std::string>" },
    { "global_word_length_operand_three_at_word",                 "std::vector<std::string>" },
    { "global_word_length_operand_two_at_word",                   "std::vector<std::string>" },
    { "global_yes_find_next_whitespace_of_type",                  "std::vector<std::string>" },
    { "global_zero_if_not_remaining_item_number",                 "std::vector<std::string>" },
    // --- Integer scalars (identified from ++ usage and for-loop counters) ---
    { "current_phrase",                                              "int" },
    { "expand_endless_loop_counter",                                 "int" },
    { "global_accumulator_pointer",                                  "int" },
    { "global_character_pointer",                                    "int" },
    { "global_endless_loop_counter",                                 "int" },
    { "global_interval_count_for_time_limit_check",                  "int" },
    { "global_length_of_text",                                       "int" },
    { "global_number_of_words",                                      "int" },
    { "global_whitespace_type",                                      "int" },
    { "global_word_count_operand_one",                               "int" },
    { "global_word_count_operand_two",                               "int" },
    { "global_word_count_operand_three",                             "int" },
    { "global_word_pointer_numeric",                                 "int" },
    { "pointer_to_phrase_begin",                                     "int" },
    { "global_fill_direction",                                       "int" },
    { "global_fill_direction_bottom_left",                           "int" },
    { "global_fill_direction_bottom_right",                          "int" },
    { "global_fill_direction_top_left",                              "int" },
    { "global_fill_direction_top_right",                             "int" },
    { "recursion_level",                                             "int" },
    { "cycle_count",                                                 "int" },
    { "expand_endless_cycle_count_maximum",                          "int" },
    { "expand_endless_loop_counter_maximum",                         "int" },
    { "global_bottom_left_open_column",                              "int" },
    { "global_bottom_right_open_column",                             "int" },
    { "global_bottom_row_number",                                    "int" },
    { "global_character_code_to_decode",                             "int" },
    { "global_pair_status",                                          "int" },
    { "length_of_code_at_recursion_level_current",                   "int" },
    { "length_of_output_buffer",                                     "int" },
    { "length_of_tag",                                               "int" },
    { "local_numeric",                                               "int" },
    { "maximum_cycle_count",                                         "int" },
    { "pointer_to_close_angle_bracket",                              "int" },
    { "pointer_to_next_space",                                       "int" },
    { "pointer_to_phrase_end",                                       "int" },
    { "pointer_to_remainder_of_output_buffer",                       "int" },
    { "prior_length",                                                "int" },
    // --- Float scalars ---
    { "global_angle_in_radians",                                    "double" },
    { "global_pi",                                                   "double" },
    // --- String scalars (explicitly confirmed) ---
    { "global_accumulated_matching_entry_info",                      "std::string" },
    { "global_accumulated_text",                                     "std::string" },
    { "global_action_debug_line",                                    "std::string" },
    { "global_action_name",                                          "std::string" },
    { "global_action_name_exists",                                   "std::string" },
    { "global_action_result",                                        "std::string" },
    { "global_all_defs_begin",                                       "std::string" },
    { "global_all_defs_end",                                         "std::string" },
    { "global_all_lines",                                            "std::string" },
    { "global_character_to_capitalize",                              "std::string" },
    { "global_character_to_replace",                                 "std::string" },
    { "global_concatenated_all_operands",                            "std::string" },
    { "global_concatenated_all_operands_modified",                   "std::string" },
    { "global_current_word",                                         "std::string" },
    { "global_currently_executing_phrase_name_with_underscores",     "std::string" },
    { "global_dashrep_text_list_of_phrase_names",                    "std::string" },
    { "global_def_begin",                                            "std::string" },
    { "global_def_end",                                              "std::string" },
    { "global_default_text",                                         "std::string" },
    { "global_definitions_or_phrase_names",                          "std::string" },
    { "global_destination_phrase",                                   "std::string" },
    { "global_directory",                                            "std::string" },
    { "global_entry_begin",                                          "std::string" },
    { "global_entry_delete",                                         "std::string" },
    { "global_entry_end",                                            "std::string" },
    { "global_entry_matching_id",                                    "std::string" },
    { "global_entry_unique",                                         "std::string" },
    { "global_extra_info",                                           "std::string" },
    { "global_extra_words_without_sort_value",                       "std::string" },
    { "global_file_name",                                            "std::string" },
    { "global_final_result",                                         "std::string" },
    { "global_first_object_of_action",                               "std::string" },
    { "global_first_or_second",                                      "std::string" },
    { "global_first_word",                                           "std::string" },
    { "global_full_path",                                            "std::string" },
    { "global_generated_list",                                       "std::string" },
    { "global_growing_text_to_append",                               "std::string" },
    { "global_handler_phrase_name",                                  "std::string" },
    { "global_input_line",                                           "std::string" },
    { "global_input_list_one_phrase_name",                           "std::string" },
    { "global_input_list_two_phrase_name",                           "std::string" },
    { "global_line_ending",                                          "std::string" },
    { "global_line_status",                                          "std::string" },
    { "global_list_indicating_sort_order_text_string",               "std::string" },
    { "global_list_name_prefix",                                     "std::string" },
    { "global_list_of_words_as_text",                                "std::string" },
    { "global_list_of_x_values_as_text",                             "std::string" },
    { "global_list_of_y_values_as_text",                             "std::string" },
    { "global_loop_status_done",                                     "std::string" },
    { "global_matching_text",                                        "std::string" },
    { "global_multiline_value_name",                                 "std::string" },
    { "global_multiple_spaces",                                      "std::string" },
    { "global_name",                                                 "std::string" },
    { "global_name_of_parameter_for_handler",                        "std::string" },
    { "global_name_of_phrase_that_contains_list_of_index_values",    "std::string" },
    { "global_name_value",                                           "std::string" },
    { "global_need_maximum",                                         "std::string" },
    { "global_need_maximum_or_minimum",                              "std::string" },
    { "global_need_minimum",                                         "std::string" },
    { "global_odd_or_even_based_on_zero_or_one",                     "std::string" },
    { "global_operand_five",                                         "std::string" },
    { "global_operand_four",                                         "std::string" },
    { "global_operand_one",                                          "std::string" },
    { "global_operand_one_words",                                    "std::string" },
    { "global_operand_three",                                        "std::string" },
    { "global_operand_three_words",                                  "std::string" },
    { "global_operand_two",                                          "std::string" },
    { "global_operand_two_words",                                    "std::string" },
    { "global_operands_all",                                         "std::string" },
    { "global_output_list_one_phrase_name",                          "std::string" },
    { "global_output_list_two_phrase_name",                          "std::string" },
    { "global_paired_words_as_text",                                 "std::string" },
    { "global_parameter_begin_or_end_string",                        "std::string" },
    { "global_partial_translation",                                  "std::string" },
    { "global_phrase_begin",                                         "std::string" },
    { "global_phrase_being_edited",                                  "std::string" },
    { "global_phrase_contents",                                      "std::string" },
    { "global_phrase_end",                                           "std::string" },
    { "global_phrase_name",                                          "std::string" },
    { "global_phrase_name_containing_parameter_list",                "std::string" },
    { "global_phrase_name_containing_pattern",                       "std::string" },
    { "global_phrase_name_containing_source_words",                  "std::string" },
    { "global_phrase_name_currently_executing",                      "std::string" },
    { "global_phrase_name_to_clear",                                 "std::string" },
    { "global_phrase_name_to_match",                                 "std::string" },
    { "global_phrase_naming_convention_for_this_column",             "std::string" },
    { "global_phrase_type",                                          "std::string" },
    { "global_phrase_words",                                         "std::string" },
    { "global_possible_error_message",                               "std::string" },
    { "global_possible_match",                                       "std::string" },
    { "global_possible_matching_entry_info",                         "std::string" },
    { "global_possible_new_limit",                                   "std::string" },
    { "global_possible_phrase",                                      "std::string" },
    { "global_possible_phrase_name",                                 "std::string" },
    { "global_prefix",                                               "std::string" },
    { "global_prefix_text",                                          "std::string" },
    { "global_range_of_right_direction_values",                      "std::string" },
    { "global_range_of_up_direction_values",                         "std::string" },
    { "global_raw_input",                                            "std::string" },
    { "global_remainder_of_line",                                    "std::string" },
    { "global_remaining_text",                                       "std::string" },
    { "global_replacement_count_text",                               "std::string" },
    { "global_result_text",                                          "std::string" },
    { "global_result_word_list",                                     "std::string" },
    { "global_runtime_error_type",                                   "std::string" },
    { "global_second_object_of_action",                              "std::string" },
    { "global_second_word",                                          "std::string" },
    { "global_segment_if_first",                                     "std::string" },
    { "global_segment_if_second",                                    "std::string" },
    { "global_segment_that_might_include_else",                      "std::string" },
    { "global_separator",                                            "std::string" },
    { "global_separator_one",                                        "std::string" },
    { "global_separator_two",                                        "std::string" },
    { "global_slash_or_backslash_for_path",                          "std::string" },
    { "global_source_definitions",                                   "std::string" },
    { "global_source_file_full_path",                                "std::string" },
    { "global_source_file_full_path_saved",                          "std::string" },
    { "global_source_file_name",                                     "std::string" },
    { "global_source_file_name_saved",                               "std::string" },
    { "global_source_path_prefix",                                   "std::string" },
    { "global_source_path_prefix_saved",                             "std::string" },
    { "global_source_phrase_name",                                   "std::string" },
    { "global_source_text",                                          "std::string" },
    { "global_storage_name",                                         "std::string" },
    { "global_string_in_phrase",                                     "std::string" },
    { "global_string_to_be_replaced",                                "std::string" },
    { "global_string_to_find",                                       "std::string" },
    { "global_string_to_insert",                                     "std::string" },
    { "global_string_to_match",                                      "std::string" },
    { "global_string_to_search",                                     "std::string" },
    { "global_string_word_to_use_in_handler",                        "std::string" },
    { "global_suffix",                                               "std::string" },
    { "global_supplied_text",                                        "std::string" },
    { "global_tag_name",                                             "std::string" },
    { "global_target_file_full_path",                                "std::string" },
    { "global_target_file_full_path_saved",                          "std::string" },
    { "global_target_file_name",                                     "std::string" },
    { "global_target_file_name_saved",                               "std::string" },
    { "global_target_operand",                                       "std::string" },
    { "global_target_path_prefix",                                   "std::string" },
    { "global_target_path_prefix_saved",                             "std::string" },
    { "global_target_phrase_name",                                   "std::string" },
    { "global_target_sub_folder",                                    "std::string" },
    { "global_target_text",                                          "std::string" },
    { "global_temp_text",                                            "std::string" },
    { "global_temporary_text",                                       "std::string" },
    { "global_text_begin",                                           "std::string" },
    { "global_text_being_edited",                                    "std::string" },
    { "global_text_end",                                             "std::string" },
    { "global_text_expanded_parameters_only",                        "std::string" },
    { "global_text_for_right_direction_values",                      "std::string" },
    { "global_text_for_up_direction_values",                         "std::string" },
    { "global_text_list_key",                                        "std::string" },
    { "global_text_list_loop",                                       "std::string" },
    { "global_text_list_of_start_matching_positions",                "std::string" },
    { "global_text_list_of_unique_word_counts",                      "std::string" },
    { "global_text_list_of_unique_word_pointers",                    "std::string" },
    { "global_text_parameter",                                       "std::string" },
    { "global_text_parameter_content",                               "std::string" },
    { "global_text_parameter_name",                                  "std::string" },
    { "global_text_parameter_value",                                 "std::string" },
    { "global_text_string",                                          "std::string" },
    { "global_text_to_append",                                       "std::string" },
    { "global_text_to_expand",                                       "std::string" },
    { "global_text_to_find",                                         "std::string" },
    { "global_text_to_insert",                                       "std::string" },
    { "global_trace_file_name",                                      "std::string" },
    { "global_translation",                                          "std::string" },
    { "global_undeleted_phrase_content",                             "std::string" },
    { "global_unique_value",                                         "std::string" },
    { "global_url",                                                  "std::string" },
    { "global_use_two_spaces_as_delimiter",                          "std::string" },
    { "global_use_value_direction",                                  "std::string" },
    { "global_weekday",                                              "std::string" },
    { "global_word",                                                 "std::string" },
    { "global_word_pointer_text",                                    "std::string" },
    { "global_word_to_check",                                        "std::string" },
    { "global_word_to_find",                                         "std::string" },
    { "global_word_to_use_in_handler",                               "std::string" },
    { "global_words_to_find",                                        "std::string" },
    { "global_words_to_match",                                       "std::string" },
    { "global_write_time",                                           "std::string" },
    { "global_zero_padding",                                         "std::string" },
    { "local_file_name",                                             "std::string" },
    { "local_folder_name",                                           "std::string" },
    { "local_text",                                                  "std::string" },
    { "new_output_buffer",                                           "std::string" },
    { "output_buffer",                                               "std::string" },
    { "output_results",                                              "std::string" },
    { "phrase_name",                                                 "std::string" },
    { "phrase_name_with_highest_cycle_count",                        "std::string" },
    { "possible_phrase_name_with_hyphens",                           "std::string" },
    { "possible_phrase_name_with_underscores",                       "std::string" },
    { "prefix",                                                      "std::string" },
    { "result_text",                                                 "std::string" },
    { "space_directive",                                             "std::string" },
    { "supplied_text",                                               "std::string" },
    { "operating_system_name",                                    "std::string" },
    { "local_target_phrase_name",                                    "std::string" },
    { "command_string_without_pipe",                                 "std::string" },
    { "process_id",                                                  "std::string" },
    { "local_endless_loop_counter",                                  "int" },
    { "local_endless_loop_counter_limit",                            "int" },
    { "length_of_text_in_word_list",                                 "int" },
    { "local_line_count",                                            "int" },
    { "local_pointer_to_future_space",                               "int" },
    { "local_pointer_to_next_space",                                 "int" },
    { "local_pointer_to_next_word",                                  "int" },
};

static std::string infer_cpp_type(const std::string& name, char sigil = '$') {
    // Check explicit table first (covers all known hashes and arrays)
    auto it = known_type_table.find(name);
    if (it != known_type_table.end()) return it->second;

    // Scalar: yes_or_no variables are always int; everything else is std::string
    std::string lower = name;
    for (char& c : lower) c = (char)std::tolower((unsigned char)c);
    if (lower.find("yes_or_no") != std::string::npos ||
        lower == "global_yes" || lower == "global_no")
        return "int";

    // Sigil fallback for unknowns not in the table (last resort)
    if (sigil == '@') return "std::vector<std::string>";
    if (sigil == '%') return "std::unordered_map<std::string, std::string>";

    return "std::string";
}

// ---------------------------------------------------------------------------
// Main converter state
// ---------------------------------------------------------------------------

struct Converter {
    std::string input;
    std::string output;

    // Track all `my`-declared variable names → VarInfo
    std::map<std::string, VarInfo> local_vars;

    // Lines of the current function being processed
    std::vector<std::string> in_lines;
    std::vector<std::string> out_lines;
    std::vector<std::pair<std::string,std::string>> todo_pairs; // {original_perl, converted}

    // -----------------------------------------------------------------------
    // Grep-like searches: each entry is { label, search_string }.
    // Matching source lines are listed at the bottom of the output file.
    // Add new searches here.
    // -----------------------------------------------------------------------
    const std::vector<std::pair<std::string,std::string>> grep_searches = {
        { "Lines containing \"sprintf\"", "sprintf" },
    };

    // Function name being converted
    std::string func_name;

    void convert(const std::string& src) {
        input = src;
        // Split into functions and convert each
        output = convert_whole_file(src);
    }

    // -----------------------------------------------------------------------
    // Top-level: split by `sub name { ... }` blocks
    // -----------------------------------------------------------------------
    // -----------------------------------------------------------------------
    // Registry of known global variable sigils supplied by the user.
    // Populated from the declarations block before any `sub`.
    // key = variable name (no sigil), value = cpp type string
    // -----------------------------------------------------------------------
    std::map<std::string, std::string> global_var_types;
    std::vector<std::string> global_init_stmts; // element assignments from preamble
    std::set<std::string> untyped_vars_seen;   // vars defaulting to std::string (no explicit type)

    // -----------------------------------------------------------------------
    // Infer C++ type for a global variable given its sigil and name.
    // Sigil '%' → unordered_map, '@' → vector, '$' → scalar heuristic.
    // -----------------------------------------------------------------------
    std::string infer_global_cpp_type(char sigil, const std::string& name) {
        return infer_cpp_type(name, sigil);
    }

    // -----------------------------------------------------------------------
    // Convert a default initializer value for a global variable.
    // -----------------------------------------------------------------------
    std::string default_for_cpp_type(const std::string& cpp_type) {
        if (cpp_type == "int")    return " = 0";
        if (cpp_type == "bool")   return " = false";
        if (cpp_type.rfind("std::vector", 0) == 0)          return "";
        if (cpp_type.rfind("std::unordered_map", 0) == 0)   return "";
        return " = \"\"";   // std::string default
    }

    // -----------------------------------------------------------------------
    // Parse and emit all top-level `my` declarations that appear before
    // the first `sub` in the file.  Returns a string of C++ global decls.
    // Also populates global_var_types for later use inside functions.
    // -----------------------------------------------------------------------
    std::string convert_global_declarations(const std::string& file_src) {
        // Find position of first `sub `
        size_t sub_pos = file_src.find("\nsub ");
        if (sub_pos == std::string::npos) sub_pos = file_src.size();

        std::string preamble = file_src.substr(0, sub_pos);
        std::vector<std::string> lines = split_lines(preamble);

        std::string out;
        out += "// ---- Global variables (converted from Perl top-level declarations) ----\n";

        static const std::regex decl_re(
            R"(^\s*my\s+([\$\@\%])(\w+)\s*(?:=\s*(.*))?;\s*(?:#.*)?$)");
        static const std::regex comment_re(R"(^\s*#)");
        static const std::regex blank_re(R"(^\s*$)");

        for (const auto& raw : lines) {
            std::string line = trim(raw);
            if (line.empty()) continue;

            // Full-line comment
            if (!line.empty() && line[0] == '#') {
                out += "// " + line.substr(1) + "\n";
                continue;
            }

            std::smatch m;
            if (std::regex_match(line, m, decl_re)) {
                char sigil      = m[1].str()[0];
                std::string name = m[2].str();
                std::string init = m[3].matched ? trim(m[3].str()) : "";

                std::string cpp_type = infer_global_cpp_type(sigil, name);
                // Refine scalar type from initializer value
                if (sigil == '$' && cpp_type == "std::string") {
                    std::string iv = trim(init);
                    // Remove trailing semicolons/spaces
                    while (!iv.empty() && (iv.back()==';'||iv.back()==' ')) iv.pop_back();
                    // Pure integer literal (including octal like 0600)
                    if (std::regex_match(iv, std::regex(R"([\-]?[0-9]+)"))) {
                        cpp_type = "int";
                    }
                    // Float literal
                    else if (std::regex_match(iv, std::regex(R"([\-]?[0-9]*\.[0-9]+([eE][\-+]?[0-9]+)?)"))) {
                        cpp_type = "double";
                    }
                    // Assigned from another variable that we already know is int
                    else if (!iv.empty() && iv[0] == '$') {
                        std::string ref_name = iv.substr(1);
                        if (global_var_types.count(ref_name) &&
                            (global_var_types[ref_name] == "int" ||
                             global_var_types[ref_name] == "double")) {
                            cpp_type = global_var_types[ref_name];
                        }
                    }
                    // `time` call → int (time_t)
                    else if (iv == "time") {
                        cpp_type = "int";
                    }
                }
                global_var_types[name] = cpp_type;
                // Track globals that received the default std::string type
                if (cpp_type == "std::string" &&
                    known_type_table.find(name) == known_type_table.end() &&
                    !name.empty() && !std::isdigit((unsigned char)name.back()))
                    untyped_vars_seen.insert(name);

                // Build initializer
                std::string init_part;
                if (!init.empty() && init != "( )" && init != "()") {
                    // Convert the RHS
                    std::string rhs = convert_global_init(init, cpp_type);
                    // If the type is numeric but the Perl init was "" or '',
                    // use the numeric default instead of an empty string literal.
                    if ((cpp_type == "int" || cpp_type == "double") &&
                        (rhs == """" || rhs == "''" || rhs.empty())) {
                        init_part = default_for_cpp_type(cpp_type);
                    } else if (!rhs.empty()) {
                        init_part = " = " + rhs;
                    }
                } else {
                    init_part = default_for_cpp_type(cpp_type);
                }

                out += cpp_type + " " + name + init_part + ";\n";
                continue;
            }

            // Lines like `$var[ 0 ] = 'x' ;` or `%hash = ( ) ;` after a declaration
            // These are executable statements — collect for emission inside main()
            if (!line.empty() && (line[0] == '$' || line[0] == '@' || line[0] == '%')) {
                // `%hash = ( ) ;` or `@arr = ( ) ;` → skip (arrays/maps default-construct fine)
                {
                    std::smatch cm;
                    if (std::regex_match(line, cm, std::regex(R"(([\$\@\%])(\w+)\s*=\s*\(\s*\)\s*;)"))) {
                        continue; // default construction handled by declaration
                    }
                }
                std::string converted = convert_line(line, 0);
                converted = flag_if_problematic(converted, line);
                if (!converted.empty()) global_init_stmts.push_back(converted);
                continue;
            }
        }
        out += "\n";
        return out;
    }

    // Convert a Perl global initializer RHS to C++
    std::string convert_global_init(const std::string& rhs, const std::string& cpp_type) {
        std::string r = trim(rhs);
        // Empty list `( )` → leave default constructor
        if (r == "( )" || r == "()") return "";
        // Remove trailing semicolon
        while (!r.empty() && (r.back() == ';' || r.back() == ' ')) r.pop_back();
        // If type is numeric but Perl init was an empty string, use numeric default
        if ((cpp_type == "int" || cpp_type == "double") &&
            (r == "\"\"" || r == "''" || r.empty()))
            return (cpp_type == "double") ? "0.0" : "0";
        // Single-quoted string
        if (!r.empty() && r[0] == '\'') {
            r = convert_single_quotes(r);
            return r;
        }
        // Numeric literal
        if (std::regex_match(r, std::regex(R"([\-]?[0-9]+)"))) return r;
        // Octal literal (Perl file modes like 0644)
        if (std::regex_match(r, std::regex(R"(0[0-7]+)"))) return r;
        // Variable reference
        if (!r.empty() && r[0] == '$') return r.substr(1);
        return convert_expr(r);
    }

    // -----------------------------------------------------------------------
    // List variables that defaulted to std::string with no explicit type entry.
    // Excludes variables whose names end in digits (e.g. output_buffer_1234).
    // -----------------------------------------------------------------------
    std::string append_untyped_vars() {
        if (untyped_vars_seen.empty()) return "";
        std::string out;
        out += "\n";
        out += "// -----------------------------------------------------------------------\n";
        out += "// UNTYPED VARIABLES — defaulted to std::string; add to known_type_table if wrong\n";
        out += "// -----------------------------------------------------------------------\n";
        for (const auto& v : untyped_vars_seen)
            out += "// " + v + "\n";
        return out;
    }

    // -----------------------------------------------------------------------
    // Scan the original Perl source for each grep_searches pattern and
    // append matching lines as comments at the bottom of the output file.
    // -----------------------------------------------------------------------
    std::string append_grep_results(const std::string& perl_src) {
        std::string out;
        std::vector<std::string> lines = split_lines(perl_src);
        for (const auto& search : grep_searches) {
            const std::string& label   = search.first;
            const std::string& pattern = search.second;
            std::vector<std::string> hits;
            for (size_t i = 0; i < lines.size(); i++) {
                if (lines[i].find(pattern) != std::string::npos) {
                    hits.push_back("// [line " + std::to_string(i + 1) + "] " + trim(lines[i]));
                }
            }
            if (!hits.empty()) {
                out += "\n";
                out += "// -----------------------------------------------------------------------\n";
                out += "// GREP: " + label + "\n";
                out += "// -----------------------------------------------------------------------\n";
                for (const auto& h : hits) out += h + "\n";
            }
        }
        return out;
    }

    std::string convert_whole_file(const std::string& src) {
        std::string result;
        result += "// Auto-converted from Perl by perl_to_cpp_converter\n";
        result += "#include <string>\n";
        result += "#include <vector>\n";
        result += "#include <unordered_map>\n";
        result += "#include <regex>\n";
        result += "#include <iostream>\n";
        result += "#include <algorithm>\n";
        result += "#include <sys/stat.h>\n";
        result += "#include <set>\n\n";

        // Emit global declarations that appear before any `sub`
        result += convert_global_declarations(src);

        // Find all `sub name( ) { ... }` blocks using brace counting
        size_t pos = 0;
        bool found_any = false;
        while (pos < src.size()) {
            // Look for `sub <name>`
            size_t sub_pos = src.find("sub ", pos);
            if (sub_pos == std::string::npos) break;

            // Extract sub name
            size_t name_start = sub_pos + 4;
            while (name_start < src.size() && src[name_start] == ' ') name_start++;
            size_t name_end = name_start;
            while (name_end < src.size() &&
                   (std::isalnum((unsigned char)src[name_end]) || src[name_end] == '_'))
                name_end++;
            std::string sub_name = src.substr(name_start, name_end - name_start);

            // Find opening brace
            size_t brace_open = src.find('{', name_end);
            if (brace_open == std::string::npos) break;

            // Match braces
            int depth = 1;
            size_t i = brace_open + 1;
            while (i < src.size() && depth > 0) {
                if (src[i] == '{') depth++;
                else if (src[i] == '}') depth--;
                i++;
            }
            size_t brace_close = i - 1;

            std::string body = src.substr(brace_open + 1, brace_close - brace_open - 1);
            result += convert_sub(sub_name, body);
            result += "\n";
            found_any = true;
            pos = brace_close + 1;
        }

        if (!found_any) {
            // No subs found – treat entire file as a body to convert
            result += "// (No 'sub' declarations found; converting as bare code)\n";
            result += convert_body(src);
        }

        // Emit main() with global element initializations from the preamble
        if (!global_init_stmts.empty()) {
            result += "int main() {\n";
            for (const auto& stmt : global_init_stmts) {
                result += "    " + trim(stmt) + "\n";
            }
            result += "    return 0;\n";
            result += "}\n\n";
        }

        // Append summary of all PERL2CPP_TODO items at the bottom of the file
        if (!todo_pairs.empty()) {
            result += "\n";
            result += "// -----------------------------------------------------------------------\n";
            result += "// PERL2CPP_TODO SUMMARY — lines needing manual attention\n";
            result += "// -----------------------------------------------------------------------\n";
            for (size_t ti = 0; ti < todo_pairs.size(); ti++) {
                result += "// [" + std::to_string(ti + 1) + "] Perl:      " + todo_pairs[ti].first  + "\n";
                result += "//     Converted: " + todo_pairs[ti].second + "\n";
            }
            result += "// -----------------------------------------------------------------------\n";
        }

        // Append list of variables that defaulted to std::string
        result += append_untyped_vars();

        // Append grep search results
        result += append_grep_results(src);

        return result;
    }

    // -----------------------------------------------------------------------
    // Convert a single `sub` into a C++ function
    // -----------------------------------------------------------------------
    std::string convert_sub(const std::string& name, const std::string& body) {
        func_name = name;
        local_vars.clear();

        // First pass: collect all `my` declarations to know types
        collect_declarations(body);

        // Determine return type
        std::string return_type = "std::string";
        // Functions with "yes_or_no" in their name always return int (0 or 1)
        {
            std::string lower_name = name;
            for (char& c : lower_name) c = (char)std::tolower((unsigned char)c);
            if (lower_name.find("yes_or_no") != std::string::npos)
                return_type = "int";
        }

        // Build parameter list
        // Perl `$_[0]` → first arg; heuristic: one optional std::string arg
        std::string params = "";
        // If the sub references $_[0], give it one string parameter
        if (body.find("$_[") != std::string::npos || body.find("@_") != std::string::npos) {
            params = "const std::string& supplied_arg";
        }

        std::string body_converted = convert_body(body);

        // Ensure non-void functions always end with a return statement
        if (return_type != "void") {
            // Find last non-empty, non-comment line
            auto blines = split_lines(body_converted);
            std::string last_code;
            for (int bi = (int)blines.size() - 1; bi >= 0; bi--) {
                std::string bt = trim(blines[bi]);
                if (!bt.empty() && bt.rfind("//", 0) != 0) { last_code = bt; break; }
            }
            if (last_code.rfind("return ", 0) != 0 && last_code != "return;") {
                // Append a safe default return
                std::string default_val = (return_type == "int") ? "0" : "\"\""  ;
                body_converted += "    return " + default_val + ";  // auto-added\n";
            }
        }

        std::string result;
        result += return_type + " " + name + "(" + params + ") {\n";
        result += body_converted;
        result += "}\n";
        return result;
    }

    // -----------------------------------------------------------------------
    // First pass: collect `my` variable declarations for type mapping
    // -----------------------------------------------------------------------
    void collect_declarations(const std::string& body) {
        // Match: my $varname ; or my @varname ; or my %varname ;
        static const std::regex decl_re(R"(my\s+([\$\@\%])(\w+)\s*;)");
        auto begin = std::sregex_iterator(body.begin(), body.end(), decl_re);
        auto end   = std::sregex_iterator();
        for (auto it = begin; it != end; ++it) {
            const std::smatch& m = *it;
            char sigil = m[1].str()[0];
            std::string vname = m[2].str();
            VarInfo vi;
            vi.name = vname;
            vi.cpp_type = infer_cpp_type(vname, sigil);
            vi.is_local = true;
            local_vars[vname] = vi;
            // Track variables that received the default std::string type
            if (vi.cpp_type == "std::string" &&
                known_type_table.find(vname) == known_type_table.end() &&
                !vname.empty() && !std::isdigit((unsigned char)vname.back()))
                untyped_vars_seen.insert(vname);
        }
    }

    // -----------------------------------------------------------------------
    // Convert a body of Perl code line by line
    // -----------------------------------------------------------------------
    std::string convert_body(const std::string& body) {
        in_lines = split_lines(body);
        out_lines.clear();

        // Emit local variable declarations first
        emit_declarations();

        // Then convert each line
        for (size_t i = 0; i < in_lines.size(); i++) {
            std::string orig     = in_lines[i];
            std::string converted = convert_line(orig, i);
            converted = flag_if_problematic(converted, orig);
            if (!converted.empty()) {
                out_lines.push_back(converted);
            }
        }

        return join_lines(out_lines);
    }

    // -----------------------------------------------------------------------
    // Emit C++ variable declarations from collected `my` vars
    // -----------------------------------------------------------------------
    void emit_declarations() {
        if (local_vars.empty()) return;
        for (const auto& kv : local_vars) {
            const VarInfo& vi = kv.second;
            std::string ws = "    ";
            std::string decl;
            if (vi.cpp_type == "int") {
                decl = ws + vi.cpp_type + " " + vi.name + " = 0;";
            } else if (vi.cpp_type == "bool") {
                decl = ws + vi.cpp_type + " " + vi.name + " = false;";
            } else if (vi.cpp_type.rfind("std::vector", 0) == 0) {
                decl = ws + vi.cpp_type + " " + vi.name + ";";
            } else if (vi.cpp_type.rfind("std::unordered_map", 0) == 0) {
                decl = ws + vi.cpp_type + " " + vi.name + ";";
            } else {
                decl = ws + vi.cpp_type + " " + vi.name + ";";
            }
            out_lines.push_back(decl);
        }
        out_lines.push_back("");
    }

    // -----------------------------------------------------------------------
    // If a converted line still contains untranslatable Perl constructs,
    // replace it with a PERL2CPP_TODO comment so the output still compiles.
    // -----------------------------------------------------------------------
    std::string flag_if_problematic(const std::string& converted,
                                    const std::string& original_perl) {
        // Skip blank lines and lines that are already comments
        std::string t = trim(converted);
        if (t.empty() || (t.size() >= 2 && t[0] == '/' && t[1] == '/')) return converted;

        static const std::vector<std::string> bad_patterns = {
            " . \"",      // Perl string concat before literal
            "\" . ",      // Perl string concat after literal
            " . ",        // Perl string concat between variables
            "=~ /",       // unconverted Perl regex match
            "!~ /",       // unconverted Perl regex non-match
            "keys(",      // unconverted Perl keys()
            "keys (",
            "foreach ",   // unconverted foreach
            "^O",         // unconverted $^O special var
            "exit\n",     // bare exit without semicolon
        };

        // Check for unconverted Perl sigil $ that is NOT inside a string literal
        auto has_bare_dollar = [](const std::string& s) {
            bool in_dq = false;
            for (size_t i = 0; i < s.size(); i++) {
                if (s[i] == '"' ) in_dq = !in_dq;
                else if (s[i] == '$' && !in_dq) return true;
            }
            return false;
        };

        for (const auto& pat : bad_patterns) {
            if (converted.find(pat) != std::string::npos) {
                std::string orig = trim(original_perl);
                std::string ws_str;
                for (char c : converted) {
                    if (c == ' ' || c == '\t') ws_str += c;
                    else break;
                }
                todo_pairs.push_back({orig, t});
                return ws_str + "// PERL2CPP_TODO: " + orig + "\n"
                     + ws_str + t;
            }
        }
        if (has_bare_dollar(converted)) {
            std::string orig = trim(original_perl);
            std::string ws_str;
            for (char c : converted) {
                if (c == ' ' || c == '\t') ws_str += c;
                else break;
            }
            todo_pairs.push_back({orig, t});
            return ws_str + "// PERL2CPP_TODO: " + orig + "\n"
                 + ws_str + t;
        }
        return converted;
    }

    std::string convert_line(const std::string& raw, size_t /*line_idx*/) {
        std::string ws  = leading_ws(raw);
        std::string line = trim(raw);

        if (line.empty()) return "";
        // Full-line comments
        if (line[0] == '#') return ws + "//" + line.substr(1);

        // Strip trailing inline comment:  `stmt ; # comment`  → keep both parts
        std::string trailing_comment;
        {
            // Walk the line looking for a `#` that is outside quotes
            bool in_sq = false, in_dq = false;
            for (size_t ci = 0; ci < line.size(); ci++) {
                char cc = line[ci];
                if (cc == '\'' && !in_dq) in_sq = !in_sq;
                else if (cc == '"' && !in_sq) in_dq = !in_dq;
                else if (cc == '#' && !in_sq && !in_dq) {
                    // Don't treat `$#` (Perl last-index operator) as a comment
                    if (ci > 0 && line[ci - 1] == '$') {
                        continue;
                    }
                    trailing_comment = "  // " + trim(line.substr(ci + 1));
                    line = trim(line.substr(0, ci));
                    break;
                }
            }
        }
        // After stripping comment, re-check for empty
        if (line.empty()) {
            if (!trailing_comment.empty()) return ws + trailing_comment.substr(2);
            return "";
        }

        // `my $var ;` declarations → already emitted; skip
        if (std::regex_match(line, std::regex(R"(my\s+[\$\@\%]\w+\s*;)"))) {
            return ""; // suppress, already declared above
        }
        // `my @arr = ( ) ;`
        if (std::regex_match(line, std::regex(R"(my\s+[\$\@\%]\w+\s*=.*)"))) {
            // Treat as an assignment; fall through after stripping `my`
            line = std::regex_replace(line, std::regex(R"(^my\s+)"), "");
        }

        // ---- Control flow ----
        if (line == "next ;")   return ws + "continue;";
        if (line == "last ;")   return ws + "break;";
        if (line == "return '' ;") return ws + "return \"\";";

        // return $var ;
        {
            std::smatch m;
            if (std::regex_match(line, m, std::regex(R"(return\s+\$(\w+)\s*;)"))) {
                return ws + "return " + m[1].str() + ";";
            }
        }

        // -----------------------------------------------------------------------
        // Convert a single Perl line to C++
        // LINE-SPECIFIC CONVERSIONS — add new cases here, one per Perl pattern.
        // Each entry: check for a unique string in `line`, return the C++ equivalent.
        // -----------------------------------------------------------------------

        // `chmod( OCTAL , $var ) ;` → `chmod( OCTAL, var.c_str() );`
        {
            std::smatch m;
            static const std::regex chmod_re(R"(chmod\s*\(\s*([0-9]+)\s*,\s*\$(\w+)\s*\)\s*;)");
            if (std::regex_match(line, m, chmod_re)) {
                return ws + "chmod( " + m[1].str() + ", " + m[2].str() + ".c_str() );";
            }
        }

        // `if ( scalar( @_ ) == 1 ) {` — true when one argument was supplied
        if (line == "if ( scalar( @_ ) == 1 ) {") {
            return ws + "if ( supplied_arg.size() > 0 ) {";
        }

        // `} else {`
        if (line == "} else {") return ws + "} else {";

        // `while ( ... ) {`
        {
            std::smatch m;
            if (std::regex_match(line, m, std::regex(R"(while\s*\((.*)\)\s*\{)"))) {
                std::string cond = convert_expr(m[1].str());
                return ws + "while (" + cond + ") {";
            }
        }
        // `while ( ... ) {` across possible spacing
        {
            std::smatch m;
            if (std::regex_match(line, m, std::regex(R"(while\s*\((.*)\)\s*\{.*)"))) {
                std::string cond = convert_expr(m[1].str());
                return ws + "while (" + cond + ") {";
            }
        }

        // `if ( ... ) {`
        {
            std::smatch m;
            if (std::regex_match(line, m, std::regex(R"(if\s*\((.*)\)\s*\{)"))) {
                std::string cond = convert_expr(m[1].str());
                return ws + "if (" + cond + ") {";
            }
        }

        // `} elsif ( ... ) {`
        {
            std::smatch m;
            if (std::regex_match(line, m, std::regex(R"(\}\s*elsif\s*\((.*)\)\s*\{)"))) {
                std::string cond = convert_expr(m[1].str());
                return ws + "} else if (" + cond + ") {";
            }
        }

        // foreach $var ( keys( %hash ) )
        {
            std::smatch m;
            if (std::regex_match(line, m,
                std::regex(R"(foreach\s+\$(\w+)\s*\(\s*keys\s*\(\s*%(\w+)\s*\)\s*\)\s*\{)"))) {
                return ws + "for (auto& kv_" + m[1].str() + " : " + m[2].str() + ") {";
            }
        }

        // foreach $var ( @array )
        {
            std::smatch m;
            if (std::regex_match(line, m,
                std::regex(R"(foreach\s+\$(\w+)\s*\(\s*@(\w+)\s*\)\s*\{)"))) {
                return ws + "for (auto& " + m[1].str() + " : " + m[2].str() + ") {";
            }
        }

        // Closing brace
        if (line == "}") return ws + "}";

        // `# end of function` → comment
        if (line.rfind("# ", 0) == 0) return ws + "// " + line.substr(2);

        // ---- Variable declarations / assignments ----

        // `$supplied_text = $_[ 0 ] ;` → `supplied_text = supplied_arg;`
        {
            std::smatch m;
            if (std::regex_match(line, m, std::regex(R"(\$(\w+)\s*=\s*\$_\[\s*0\s*\]\s*;)"))) {
                return ws + m[1].str() + " = supplied_arg;";
            }
        }

        // `@array = ( ) ;` → `array.clear();`
        {
            std::smatch m;
            if (std::regex_match(line, m, std::regex(R"(@(\w+)\s*=\s*\(\s*\)\s*;)"))) {
                return ws + m[1].str() + ".clear();";
            }
        }

        // `$array[ $n ] = value ;` → `array[n] = value;`
        // handled inside convert_expr for the RHS; full line below

        // `$var ++ ;` → `var++;`
        {
            std::smatch m;
            if (std::regex_match(line, m, std::regex(R"(\$(\w+)\s*\+\+\s*;)"))) {
                return ws + m[1].str() + "++;";
            }
        }
        // `$var -- ;` → `var--;`
        {
            std::smatch m;
            if (std::regex_match(line, m, std::regex(R"(\$(\w+)\s*--\s*;)"))) {
                return ws + m[1].str() + "--;";
            }
        }

        // `.=` string append → `var += expr;`
        {
            std::smatch m;
            if (std::regex_match(line, m, std::regex(R"(\$(\w+)\s*\.\=\s*(.*)\s*;)"))) {
                std::string rhs = convert_expr(trim(m[2].str()));
                return ws + m[1].str() + " += " + rhs + ";";
            }
        }

        // `$var =~ s/pattern/replacement/flags ;`
        // Parsed manually so spaces inside the pattern are handled correctly
        {
            std::smatch vm;
            if (std::regex_search(line, vm, std::regex(R"(\$(\w+)\s*=~\s*s/)"))) {
                std::string var = vm[1].str();
                size_t si = (size_t)vm.position() + (size_t)vm[0].length();
                std::string pat_raw, repl_raw, flags_raw;
                while (si < line.size() && line[si] != '/') {
                    if (line[si] == '\\' && si + 1 < line.size()) { pat_raw += line[si]; si++; }
                    pat_raw += line[si++];
                }
                if (si < line.size()) si++;
                while (si < line.size() && line[si] != '/') {
                    if (line[si] == '\\' && si + 1 < line.size()) { repl_raw += line[si]; si++; }
                    repl_raw += line[si++];
                }
                if (si < line.size()) si++;
                while (si < line.size() && line[si] != ' ' && line[si] != ';') flags_raw += line[si++];
                std::string pat  = perl_regex_to_cpp(pat_raw);
                std::string opts = regex_flags_to_cpp(flags_raw);
                bool global = flags_raw.find('g') != std::string::npos;
                if (global) {
                    std::string repl = perl_replacement_to_cpp_global(repl_raw);
                    return ws + var + " = std::regex_replace(" + var + ", std::regex(\"" +
                           pat + "\"" + opts + "), \"" + repl + "\");";
                } else {
                    std::string repl_expr = perl_replacement_to_cpp_smatch(repl_raw);
                    return ws + "{ std::smatch _m; if (std::regex_search(" + var +
                           ", _m, std::regex(\"" + pat + "\"" + opts + "))) { " + var +
                           " = _m.prefix().str() + " + repl_expr + " + _m.suffix().str(); } }";
                }
            }
        }


        // `$var = expr ;` plain assignment
        {
            std::smatch m;
            if (std::regex_match(line, m, std::regex(R"(\$(\w+)\s*=\s*(.*)\s*;)"))) {
                std::string rhs = convert_expr(trim(m[2].str()));
                return ws + m[1].str() + " = " + rhs + ";";
            }
        }

        // `$array[$idx] = expr ;`
        {
            std::smatch m;
            if (std::regex_match(line, m,
                std::regex(R"(\$(\w+)\[\s*(.*?)\s*\]\s*=\s*(.*)\s*;)"))) {
                std::string arr  = m[1].str();
                std::string idx  = convert_expr(m[2].str());
                std::string rhs  = convert_expr(trim(m[3].str()));
                return ws + arr + "[" + idx + "] = " + rhs + ";";
            }
        }

        // `$hash{$key} = expr ;` or `$hash{ $key } ++`
        {
            std::smatch m;
            if (std::regex_match(line, m,
                std::regex(R"(\$(\w+)\{\s*(.*?)\s*\}\s*([\+\-]?=|\+\+|--)\s*(.*)\s*;)"))) {
                std::string hname = m[1].str();
                std::string key   = convert_expr(m[2].str());
                std::string op    = m[3].str();
                std::string rhs   = convert_expr(trim(m[4].str()));
                if (op == "++") return ws + hname + "[" + key + "]++;";
                if (op == "--") return ws + hname + "[" + key + "]--;";
                return ws + hname + "[" + key + "] " + op + " " + rhs + ";";
            }
        }


        // `print $var . "\n" ;` → `std::cout << var << "\n";`
        {
            std::smatch m;
            if (std::regex_match(line, m, std::regex(R"(print\s+(.*)\s*;)"))) {
                std::string expr = convert_print_expr(m[1].str());
                return ws + "std::cout << " + expr + ";";
            }
        }


        // Subroutine call: `&func_name( ... ) ;` → `func_name( ... );`
        {
            std::smatch m;
            if (std::regex_match(line, m, std::regex(R"(&(\w+)\s*(\(.*\))\s*;)"))) {
                return ws + m[1].str() + "(" + convert_expr(trim(m[2].str().substr(1, m[2].str().size()-2))) + ");";
            }
        }

        // generic fallback
        // Generic: try to convert as expression statement
        std::string converted = convert_expr(line);
        // Remove trailing ` ;` if present
        if (converted.size() >= 2 && converted.substr(converted.size() - 2) == " ;")
            converted = converted.substr(0, converted.size() - 2) + ";";
        return ws + converted + trailing_comment;
    }

    // -----------------------------------------------------------------------
    // Convert Perl sprintf( "fmt", expr ) to C++ equivalent.
    //   "%d"    → std::to_string( expr )
    //   "%f"    → std::to_string( expr )
    //   "%05d"  → snprintf lambda with zero-padded format
    //   "%02x"  → snprintf lambda with hex format
    // Returns empty string if pattern not recognised.
    // -----------------------------------------------------------------------
    std::string convert_sprintf(const std::string& e) {
        // Match: sprintf ( "fmt" , inner )
        // Called BEFORE convert_variables so the % in format strings is intact.
        // The pre/post parts are converted via convert_expr (which will call
        // convert_variables on them).  The format string itself is kept verbatim.
        std::string t = e;
        size_t sp = t.find("sprintf");
        if (sp == std::string::npos) return "";
        size_t op = t.find('(', sp + 7);
        if (op == std::string::npos) return "";
        // Find the format string between the first pair of " after (
        size_t fq1 = t.find('"', op + 1);
        if (fq1 == std::string::npos) return "";
        size_t fq2 = t.find('"', fq1 + 1);
        if (fq2 == std::string::npos) return "";
        std::string fmt = t.substr(fq1 + 1, fq2 - fq1 - 1); // e.g. "%05d"
        // Find comma after format string
        size_t comma = t.find(',', fq2 + 1);
        if (comma == std::string::npos) return "";
        // Find closing paren of sprintf — match depth from op
        int depth = 0;
        size_t cp = std::string::npos;
        for (size_t i = op; i < t.size(); i++) {
            if (t[i] == '(') depth++;
            else if (t[i] == ')') { depth--; if (depth == 0) { cp = i; break; } }
        }
        if (cp == std::string::npos) return "";
        std::string inner_raw = trim(t.substr(comma + 1, cp - comma - 1));
        std::string inner = convert_expr(inner_raw);
        // pre and post are the parts of the expression around the sprintf call.
        // They are already in their raw Perl form here; convert_expr will be
        // applied to the whole result by the caller, so we convert them now.
        std::string pre_raw  = t.substr(0, sp);
        std::string post_raw = t.substr(cp + 1);
        // Convert pre/post by running convert_variables on them directly
        std::string pre  = convert_variables(pre_raw);
        std::string post = convert_variables(post_raw);
        std::string replacement;
        if (fmt == "%d" || fmt == "%f") {
            replacement = "std::to_string(" + inner + ")";
        } else {
            // Width/base formatted: "%05d", "%02x", etc. — use snprintf lambda
            replacement = "[&]{ char _buf[64]; snprintf(_buf, sizeof(_buf), \""
                        + fmt + "\", " + inner + "); return std::string(_buf); }()";
        }
        return pre + replacement + post;
    }

    // -----------------------------------------------------------------------
    // Convert a Perl expression to C++
    // -----------------------------------------------------------------------
    std::string convert_expr(const std::string& raw) {
        std::string e = trim(raw);

        // Remove trailing semicolon from expression if present
        while (!e.empty() && (e.back() == ';' || e.back() == ' '))
            e.pop_back();

        // String literals: "\n" → "\n", '' → ""
        e = replace_all(e, "''",   "\"\"");

        // `'string'` → `"string"`  (simple single-quoted strings without embedded quotes)
        e = convert_single_quotes(e);

        // Handle sprintf: replace it with a placeholder before convert_variables
        // runs (so % in format strings is not stripped), then restore after.
        std::string sprintf_saved;
        if (e.find("sprintf") != std::string::npos) {
            std::string r = convert_sprintf(e);
            if (!r.empty()) {
                // r is pre + replacement + post, all already converted.
                // Still need to run string concat on the whole thing.
                r = convert_string_concat(r);
                return r;
            }
        }

        // Variable sigils: $var → var, @arr → arr, %hash → hash
        // But careful: $arr[$idx] → arr[idx], $hash{$key} → hash[key]
        e = convert_variables(e);

        // Perl operators
        e = replace_all(e, " eq ",  " == ");
        e = replace_all(e, " ne ",  " != ");
        e = replace_all(e, " le ",  " <= ");
        e = replace_all(e, " ge ",  " >= ");
        e = replace_all(e, " lt ",  " < ");
        e = replace_all(e, " gt ",  " > ");
        e = replace_all(e, " && ",  " && ");
        e = replace_all(e, " || ",  " || ");
        e = replace_all(e, " and ", " && ");
        e = replace_all(e, " or ",  " || ");
        e = replace_all(e, " not ", " !");
        e = replace_all(e, "\\.=",  "+=");

        // String concatenation: ` . ` → ` + ` (but NOT `.=`)
        e = convert_string_concat(e);

        // `ord( expr )` → `(unsigned char)(expr)[0]`
        // Perl ord() returns the ASCII/Unicode value of the first char of a string.
        if (e.find("ord(") != std::string::npos || e.find("ord (") != std::string::npos) {
            std::string result;
            size_t i = 0;
            while (i < e.size()) {
                size_t op = e.find("ord", i);
                if (op == std::string::npos) { result += e.substr(i); break; }
                // Make sure it's not part of a longer word (e.g. "border")
                if (op > 0 && (std::isalnum((unsigned char)e[op-1]) || e[op-1] == '_')) {
                    result += e.substr(i, op - i + 1);
                    i = op + 1;
                    continue;
                }
                // Find the opening paren
                size_t p = op + 3;
                while (p < e.size() && e[p] == ' ') p++;
                if (p >= e.size() || e[p] != '(') { result += e.substr(i, op - i + 1); i = op + 1; continue; }
                // Match closing paren
                int depth = 0;
                size_t cp = std::string::npos;
                for (size_t k = p; k < e.size(); k++) {
                    if (e[k] == '(') depth++;
                    else if (e[k] == ')') { depth--; if (depth == 0) { cp = k; break; } }
                }
                if (cp == std::string::npos) { result += e.substr(i, op - i + 1); i = op + 1; continue; }
                std::string inner = e.substr(p + 1, cp - p - 1);
                result += e.substr(i, op - i);
                result += "(unsigned char)(" + inner + ")[0]";
                i = cp + 1;
            }
            e = result;
        }

        // `chr( expr )` → `std::string(1, (char)(expr))`
        // Perl chr() returns a one-character string for a given ASCII/Unicode value.
        if (e.find("chr(") != std::string::npos || e.find("chr (") != std::string::npos) {
            std::string result;
            size_t i = 0;
            while (i < e.size()) {
                size_t cp = e.find("chr", i);
                if (cp == std::string::npos) { result += e.substr(i); break; }
                // Ensure it's not part of a longer word (e.g. "chroot")
                if (cp > 0 && (std::isalnum((unsigned char)e[cp-1]) || e[cp-1] == '_')) {
                    result += e.substr(i, cp - i + 1);
                    i = cp + 1;
                    continue;
                }
                // Find opening paren
                size_t p = cp + 3;
                while (p < e.size() && e[p] == ' ') p++;
                if (p >= e.size() || e[p] != '(') { result += e.substr(i, cp - i + 1); i = cp + 1; continue; }
                // Match closing paren
                int depth = 0;
                size_t ep = std::string::npos;
                for (size_t k = p; k < e.size(); k++) {
                    if (e[k] == '(') depth++;
                    else if (e[k] == ')') { depth--; if (depth == 0) { ep = k; break; } }
                }
                if (ep == std::string::npos) { result += e.substr(i, cp - i + 1); i = cp + 1; continue; }
                std::string inner = e.substr(p + 1, ep - p - 1);
                result += e.substr(i, cp - i);
                result += "std::string(1, (char)(" + inner + "))";
                i = ep + 1;
            }
            e = result;
        }

        // `length( $var )` or `length( arr[idx] )` → `(int)expr.size()`
        e = std::regex_replace(e,
            std::regex(R"(length\s*\(\s*([\w\[\]]+)\s*\))"),
            "(int)$1.size()");
        // Fallback: length( any expr )
        e = std::regex_replace(e,
            std::regex(R"(length\s*\(\s*([^)]+)\s*\))"),
            "(int)($1).size()");

        // `substr( $var , $pos , $len )` → `var.substr(pos, len)`
        e = std::regex_replace(e,
            std::regex(R"(substr\s*\(\s*(\w+)\s*,\s*([^,)]+)\s*,\s*([^)]+)\s*\))"),
            "$1.substr($2, $3)");

        // `substr( $var , $pos )` → `var.substr(pos)`
        e = std::regex_replace(e,
            std::regex(R"(substr\s*\(\s*(\w+)\s*,\s*([^)]+)\s*\))"),
            "$1.substr($2)");

        // `index( $str , $sub , $from )` → `(int)str.find(sub, from)`
        e = std::regex_replace(e,
            std::regex(R"(index\s*\(\s*(\w+)\s*,\s*([^,)]+)\s*,\s*([^)]+)\s*\))"),
            "(int)$1.find($2, $3)");

        // `index( $str , $sub )` → `(int)str.find(sub)`
        e = std::regex_replace(e,
            std::regex(R"(index\s*\(\s*(\w+)\s*,\s*([^)]+)\s*\))"),
            "(int)$1.find($2)");

        // `exists( $hash{ $key } )` → `hash.count(key) > 0`
        e = std::regex_replace(e,
            std::regex(R"(exists\s*\(\s*(\w+)\[\s*([^\]]+)\s*\]\s*\))"),
            "$1.count($2) > 0");

        // `scalar( @arr )` → `(int)arr.size()`
        e = std::regex_replace(e,
            std::regex(R"(scalar\s*\(\s*@?(\w+)\s*\))"),
            "(int)$1.size()");

        // `keys( %hash )` used in foreach → already handled; here just emit as-is
        e = std::regex_replace(e,
            std::regex(R"(keys\s*\(\s*%?(\w+)\s*\))"),
            "$1");  // will be wrapped by for (auto& kv : ...)

        // `== -1` when comparing find result → `== std::string::npos`
        // Only for patterns that look like find comparisons
        e = std::regex_replace(e,
            std::regex(R"((\w+\.find\([^)]+\))\s*==\s*-1)"),
            "$1 == (int)std::string::npos");
        e = std::regex_replace(e,
            std::regex(R"((\w+\.find\([^)]+\))\s*==\s*-1)"),
            "$1 == (int)std::string::npos");

        // `=~ /regex/flags` → std::regex_search
        // Pattern matches: $var, $_[0], or a bare word before =~
        {
            std::smatch m;
            // Normalise $_[0] / $_[ 0 ] before pattern matching
            std::string tmp = e;
            tmp = std::regex_replace(tmp, std::regex(R"(\$_\[\s*0\s*\])"), "supplied_arg");
            static const std::regex match_re(R"(\$?(\w+)\s*=~\s*/([^/]+)/([a-z]*))");
            if (std::regex_search(tmp, m, match_re)) {
                std::string var  = m[1].str();
                std::string pat  = perl_regex_to_cpp(m[2].str());
                std::string opts = regex_flags_to_cpp(m[3].str());
                e = std::regex_replace(tmp, match_re,
                    "std::regex_search(" + var + ", std::regex(\"" + pat + "\"" + opts + "))");
            }
        }

        // `!~ /regex/` → !std::regex_search
        {
            std::smatch m;
            std::string tmp = e;
            tmp = std::regex_replace(tmp, std::regex(R"(\$_\[\s*0\s*\])"), "supplied_arg");
            static const std::regex nmatch_re(R"(\$?(\w+)\s*!~\s*/([^/]+)/([a-z]*))");
            if (std::regex_search(tmp, m, nmatch_re)) {
                std::string var  = m[1].str();
                std::string pat  = perl_regex_to_cpp(m[2].str());
                std::string opts = regex_flags_to_cpp(m[3].str());
                e = std::regex_replace(tmp, nmatch_re,
                    "!std::regex_search(" + var + ", std::regex(\"" + pat + "\"" + opts + "))");
            }
        }

        // `$_[0]` → `supplied_arg`
        e = replace_all(e, "$_[0]", "supplied_arg");
        e = replace_all(e, "$_[ 0 ]", "supplied_arg");

        // `"\n"` literal
        e = replace_all(e, "\"\\n\"", "\"\\n\""); // already fine

        return e;
    }

    // -----------------------------------------------------------------------
    // Convert `'single quoted'` Perl strings to `"double quoted"` C++ strings.
    // Each quoted token is converted independently; concatenation is left as `+`.
    // -----------------------------------------------------------------------
    std::string convert_single_quotes(const std::string& s) {
        std::string result;
        size_t i = 0;
        while (i < s.size()) {
            if (s[i] == '\'' ) {
                // Find closing quote
                size_t j = i + 1;
                while (j < s.size() && s[j] != '\'') {
                    if (s[j] == '\\') j++;
                    j++;
                }
                std::string content = s.substr(i + 1, j - i - 1);
                // Escape double quotes inside
                content = replace_all(content, "\"", "\\\"");
                result += "\"" + content + "\"";
                i = j + 1;
            } else {
                result += s[i++];
            }
        }
        return result;
    }

    // -----------------------------------------------------------------------
    // Convert Perl variable sigils to C++ identifiers
    // -----------------------------------------------------------------------
    std::string convert_variables(const std::string& s) {
        // Handle $_[0] / $_[ 0 ] before any other sigil stripping
        std::string pre = std::regex_replace(s, std::regex(R"(\$_\[\s*0\s*\])"), "supplied_arg");

        std::string result;
        size_t i = 0;
        while (i < pre.size()) {
            char c = pre[i];

            if (c == '$' && i + 1 < pre.size() && pre[i+1] == '#') {
                // $#array → (int)array.size() - 1
                size_t j = i + 2;
                while (j < pre.size() && (std::isalnum((unsigned char)pre[j]) || pre[j] == '_')) j++;
                std::string aname = pre.substr(i + 2, j - i - 2);
                result += "(int)" + aname + ".size() - 1";
                i = j;
                continue;
            }
            if (c == '$' || c == '@' || c == '%') {
                // Collect variable name
                size_t j = i + 1;
                while (j < pre.size() && (std::isalnum((unsigned char)pre[j]) || pre[j] == '_'))
                    j++;
                std::string vname = pre.substr(i + 1, j - i - 1);
                if (vname.empty()) {
                    result += c;
                    i++;
                    continue;
                }

                // Check for subscript: $arr[expr] or $hash{expr}
                size_t k = j;
                while (k < pre.size() && pre[k] == ' ') k++;

                if (k < pre.size() && pre[k] == '[') {
                    // Array subscript
                    size_t close = find_matching(s, k, '[', ']');
                    std::string idx = convert_expr(pre.substr(k + 1, close - k - 1));
                    result += vname + "[" + idx + "]";
                    i = close + 1;
                } else if (k < pre.size() && pre[k] == '{') {
                    // Hash subscript
                    size_t close = find_matching(s, k, '{', '}');
                    std::string key = convert_expr(pre.substr(k + 1, close - k - 1));
                    result += vname + "[" + key + "]";
                    i = close + 1;
                } else {
                    result += vname;
                    i = j;
                }
            } else {
                result += c;
                i++;
            }
        }
        return result;
    }

    // Find matching closing bracket, starting at open_pos
    size_t find_matching(const std::string& s, size_t open_pos, char open, char close) {
        int depth = 0;
        for (size_t i = open_pos; i < s.size(); i++) {
            if (s[i] == open) depth++;
            else if (s[i] == close) {
                depth--;
                if (depth == 0) return i;
            }
        }
        return s.size() - 1;
    }

    // -----------------------------------------------------------------------
    // Convert Perl string concatenation `.` to C++ `+`
    // Rule: a dot surrounded by spaces ` . ` is always a concat operator in Perl.
    // Must not touch `..` ranges, `./` paths, `.=` append, or decimal numbers.
    // -----------------------------------------------------------------------
    std::string convert_string_concat(const std::string& s) {
        // Simple token-level replacement: replace every " . " with " + "
        // provided it is not ".. " or ".=" or a decimal digit context.
        std::string result;
        size_t i = 0;
        while (i < s.size()) {
            // Look for space-dot-space pattern
            if (i + 2 < s.size() && s[i] == ' ' && s[i+1] == '.' && s[i+2] == ' ') {
                // Make sure it's not part of `..`
                if ((i == 0 || s[i] != '.') && (i + 3 >= s.size() || s[i+3] != '.')) {
                    result += " + ";
                    i += 3;
                    continue;
                }
            }
            result += s[i++];
        }
        return result;
    }

    // -----------------------------------------------------------------------
    // Convert `print expr` to `std::cout << expr`
    // -----------------------------------------------------------------------
    std::string convert_print_expr(const std::string& raw) {
        std::string e = convert_expr(trim(raw));
        // Split on ` . ` → ` << `
        e = replace_all(e, " + ", " << ");
        return e + " << \"\\n\"";
    }

    // -----------------------------------------------------------------------
    // Convert Perl regex syntax to C++ regex syntax
    // -----------------------------------------------------------------------
    std::string perl_regex_to_cpp(const std::string& pat) {
        std::string p = pat;
        // Only escape characters that would break a C++ string literal.
        // Do NOT double-escape backslashes — Perl regex escapes like \-,
        // \d, \s, \.  are valid in C++ std::regex too.
        p = replace_all(p, "\"", "\\\"");  // escape embedded double quotes
        return p;
    }

    // Convert Perl replacement string for s/// to C++ regex_replace format
    // Convert Perl replacement string for use with std::regex_replace (global flag).
    // In this context $1, $2 etc. are already valid C++ regex_replace back-references.
    std::string perl_replacement_to_cpp_global(const std::string& repl) {
        std::string r = repl;
        r = replace_all(r, "\"", "\\\"");
        r = replace_all(r, "\\n", "\\n");
        return r;
    }

    // Convert Perl replacement string for use with std::smatch (non-global).
    // Builds a C++ string expression: literal parts stay quoted, $1..$9 become
    // _m[N].str() so the caller can concatenate prefix + replacement + suffix.
    // Returns a C++ expression suitable for use after `_m.prefix().str() + `.
    std::string perl_replacement_to_cpp_smatch(const std::string& repl) {
        // Walk the replacement, collecting literal chars and $N references.
        // Output: a sequence of C++ string fragments joined with +
        std::string result;
        std::string literal;
        auto flush_literal = [&]() {
            if (!literal.empty()) {
                // Escape inner double-quotes
                std::string escaped;
                for (char c : literal) {
                    if (c == '"') escaped += "\\\"";
                    else escaped += c;
                }
                if (!result.empty()) result += " + ";
                result += "\"" + escaped + "\"";
                literal.clear();
            }
        };
        size_t i = 0;
        while (i < repl.size()) {
            if (repl[i] == '$' && i + 1 < repl.size() && std::isdigit((unsigned char)repl[i+1])) {
                flush_literal();
                std::string num;
                i++;
                while (i < repl.size() && std::isdigit((unsigned char)repl[i])) num += repl[i++];
                if (!result.empty()) result += " + ";
                result += "_m[" + num + "].str()";
            } else {
                literal += repl[i++];
            }
        }
        flush_literal();
        if (result.empty()) result = "\"\"";;
        return result;
    }

    // Convert Perl regex flags to C++ std::regex option string
    std::string regex_flags_to_cpp(const std::string& flags) {
        std::string opts;
        if (flags.find('i') != std::string::npos)
            opts += " | std::regex_constants::icase";
        if (flags.find('s') != std::string::npos)
            opts += " | std::regex_constants::ECMAScript"; // dotall not native; note it
        if (!opts.empty()) opts = ", std::regex_constants::ECMAScript" + opts;
        return opts;
    }
};

// ---------------------------------------------------------------------------
// main
// ---------------------------------------------------------------------------

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: perl_to_cpp_converter <input.pl> [output.cpp]\n";
        return 1;
    }

    std::string input_path  = argv[1];
    std::string output_path = (argc >= 3) ? argv[2] : "";

    std::string src = read_file(input_path);

    Converter conv;
    conv.convert(src);

    if (output_path.empty()) {
        // Derive from input: foo.pl → foo_converted.cpp
        output_path = input_path;
        size_t dot = output_path.rfind('.');
        if (dot != std::string::npos) output_path = output_path.substr(0, dot);
        output_path += "_converted.cpp";
    }

    write_file(output_path, conv.output);
    std::cout << "Converted: " << input_path << " → " << output_path << "\n";
    return 0;
}
