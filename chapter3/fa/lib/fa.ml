open Base
open Stdio

let rec length_helper ?(acc = 0) li : int =
  match li with [] -> acc | _ :: tl -> length_helper tl ~acc:(acc + 1)

let%test "length_helper empty list" =
  match length_helper [] with 0 -> true | _ -> false

let%test "length_helper normal list" =
  match length_helper [ 1; 2; 3; 4 ] with 4 -> true | _ -> false

let leength l = length_helper l
let count_lines (li : string list) : int = leength li

let count_empty_non_lines (li : string list) : int * int =
  ( List.length (List.filter ~f:String.is_empty li),
    List.length (List.filter ~f:(Fn.non String.is_empty) li))

let remove_sequential_duplicates li =
  let rec helper acc = function
    | [] -> List.rev acc
    | [ x ] -> List.rev (x :: acc)
    | first :: (second :: _ as tl) when String.equal first second ->
        helper acc tl
    | first :: tl -> helper (first :: acc) tl
  in
  helper [] li

let split_words li =
  let rec split_words_in_line ?(acc = (([] : char list), ([] : string list)))
      (str : char list) : string list =
    match str with
    | [] ->
        let current = fst acc in
        let words = snd acc in
        if List.is_empty current then List.rev words
        else List.rev (String.of_char_list (List.rev current) :: words)
    | ' ' :: tl ->
        let word = fst acc in
        let fresh_acc =
          if List.is_empty (fst acc) then acc
          else ([], (String.of_char_list @@ List.rev word) :: snd acc)
        in
        split_words_in_line ~acc:fresh_acc tl
    | hd :: tl ->
        let acc' = (hd :: fst acc, snd acc) in
        split_words_in_line ~acc:acc' tl
  in
  List.map li ~f:(fun el ->
      let line = String.to_list el in
      split_words_in_line line)

type count = string * int

let add_word (search : string) (c_list : count list) : count list =
  let rec aux ?(acc = []) ?(found = false) = function
    | [] -> if found then List.rev acc else List.rev ((search, 1) :: acc)
    | ((word, n) as pair) :: tl ->
        if String.equal search word then
          aux ~acc:((word, n + 1) :: acc) ~found:true tl
        else aux ~acc:(pair :: acc) ~found tl
  in
  aux c_list

let%test "add_word" =
  match add_word "hello" [ ("hello", 2); ("world", 1) ] with
  | [ ("hello", 3); ("world", 1) ] -> true
  | _ -> false

let aggregate (c_list_list : count list list) : count list =
  List.fold c_list_list ~init:[] ~f:(fun acc el_list ->
      List.fold el_list ~init:acc ~f:(fun acc' (word, n) ->
          List.fold (List.range 0 n) ~init:acc' ~f:(fun a _ -> add_word word a)))

let count_words str =
  str |> String.split_lines |> split_words
  |> List.map ~f:(fun el ->
      List.fold el ~init:[] ~f:(fun acc el -> add_word el acc))
  |> aggregate

let most_frequent_word str =
  let counts =
    str |> split_words
    |> List.map ~f:(fun words ->
           List.fold words ~init:[] ~f:(fun acc word -> add_word word acc))
    |> aggregate
  in
  let max_count x y = if snd x >= snd y then x else y in
  Option.value ~default:("", 0) @@ List.reduce ~f:max_count counts

let partition_empty_non_empty (lines : string list) =
  List.partition_tf ~f:String.is_empty lines

let longest_line (lines : string list) : string =
  List.fold ~init:""
    ~f:(fun acc el -> if String.length el >= String.length acc then el else acc)
    lines

let count_all_words strs =
  let counts = List.map strs ~f:count_words in
  List.fold ~init:0
    ~f:(fun acc c_list ->
      acc + (List.fold ~init:0 ~f:(fun acc' el -> acc' + snd el)) c_list)
    counts

let count_all_chars strs =
  List.fold ~init:0 ~f:(fun acc el -> acc + String.length el) strs
