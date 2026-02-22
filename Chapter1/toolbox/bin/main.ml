open Base
open Stdio

let print_usage () =
  print_endline
    "usage: toolbox <command> [args]\n\
    \ commands:\n\
    \  sum_list\n\
    \    Read integers from stdin (one per line) and print the sum.\n\
    \  grep <substring>\n\
    \    Read lines from stdin and print lines containing <substring>.\n\
    \  remove_duplicates\n\
    \    Read lines from stdin and remove sequential duplicates.\n\
    \  find_first_negative \"<space-separated ints>\"\n\
    \    Print the first negative number (as positive in current behavior)."

let () =
  match Stdlib.Sys.argv with
  | [| _; "sum_list" |] ->
      let answer =
        match Toolbox.sumList () with
        | Some answer -> answer
        | None -> "something went wrong in sum_list"
      in
      print_endline ("Answer: " ^ answer)
  | [| _; "grep"; (grep_with : string) |] ->
      let answer =
        match Toolbox.grep grep_with with
        | Some answer -> answer
        | None -> "something went wrong in grep"
      in
      print_endline ("Answer: " ^ answer)
  | [| _; "remove_duplicates" |] ->
      let answer =
        match Toolbox.remove_duplicates() with
        | Some answer -> answer
        | None -> "something went wrong in remove_duplicates"
      in
      print_endline ("Answer: " ^ answer)
  | [| _; "find_first_negative"; input |] ->
      let answer =
        match Toolbox.find_first_negative(input) with
        | Some answer -> answer
        | None -> "None"
      in
      print_endline ("Answer: " ^"Some " ^ answer)
  | _ -> print_usage ()
