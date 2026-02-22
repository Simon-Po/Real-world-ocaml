open Base
open Stdio

let join_string (sep : string) (xs : string list) =
  List.fold_left xs ~init:"" ~f:(fun acc str -> acc ^ sep ^ str)

let rec read_lines (lines : string list) =
  match In_channel.input_line In_channel.stdin with
  | Some line -> read_lines (line :: lines)
  | None -> lines

let find_first_negative (input : string) =
  let nums = String.split input ~on:' ' |> List.map ~f:Int.of_string in
  Option.map
    ~f:(fun a -> Int.to_string (-a))
    (List.find ~f:(fun a -> a < 0) nums)

let remove_duplicates () =
  let lines = read_lines [] in
  match lines with
  | [] -> None
  | lines' ->
      Some
        (List.group ~break:(fun a b -> not (String.equal a b)) lines'
        |> List.concat_map ~f:(fun l ->
            match l with [] -> [] | hd :: _ -> [ hd ])
        |> List.rev |> join_string " ")

let grep (grep_with : string) : string option =
  let lines = read_lines [] in
  match lines with
  | [] -> None
  | lines' ->
      Some
        (join_string "\n"
           (List.rev
              (List.filter lines' ~f:(fun x ->
                   String.is_substring x ~substring:grep_with))))

let sumList () : string option =
  let lines = read_lines [] in
  match lines with
  | [] -> None
  | lines' ->
      Some
        (Int.to_string
           (List.fold_left
              (List.filter_map (List.map lines' ~f:Int.of_string_opt) ~f:Fn.id)
              ~init:0 ~f:( + )))
