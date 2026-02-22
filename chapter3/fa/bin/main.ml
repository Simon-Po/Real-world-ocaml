open Base
open Stdio

let get_lines () : (string list, string) Result.t =
  let read_lines_res filename =
    try Ok (In_channel.read_lines filename)
    with exn -> Error (Exn.to_string exn)
  in
  let usage name = "Usage: <" ^ name ^ "> file_to_process.txt" in
  let file =
    match Stdlib.Sys.argv with
    | [| _; file |] -> Ok file
    | [| exe_name |] -> Error (usage exe_name)
    | _ -> Error "Error: Parsing failed"
  in
  match file with Ok file -> read_lines_res file | Error _ as err -> err

let () =
  let print_int_pre prefix int = print_endline (prefix ^ Int.to_string int) in
  let lines =
    match get_lines () with
    | Ok lines -> lines
    | Error err ->
        eprintf "Error: %s\n" err;
        Stdlib.exit 1
  in
  let line_count = Fa.count_lines lines in
  let word_count = Fa.count_all_words lines in
  let char_count = Fa.count_all_chars lines in
  let longest_line = Fa.longest_line lines in
  let most_freq = Fa.most_frequent_word lines in
  let empty_non_empty_lines = Fa.count_empty_non_lines lines in
  let dedup_lines = Fa.remove_sequential_duplicates lines in
  print_int_pre "Lines: " line_count;
  print_int_pre "Words: " word_count;
  print_int_pre "Characters: " char_count;
  print_endline ("Longest line: " ^ "\"" ^ longest_line ^ "\"");
  print_endline ("Most frequent word: " ^ "\"" ^ fst most_freq ^ "\"");
  print_int_pre "Empty lines: " (fst empty_non_empty_lines);
  print_int_pre "Non-empty lines: " (snd empty_non_empty_lines);
  print_endline "Deduplicated lines:";
  List.iter ~f:print_endline dedup_lines
