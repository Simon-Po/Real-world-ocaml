open Core

module Store = Kv.Store_list


(* SET name Simon *)
(* GET name *)
(* SET city Berlin *)
(* GET city *)
(* GET age *)

type command =
             | Set of (string * string)
             | Get of string


let build_command (sl: string) : command option =
    let str = String.strip sl in
      match str |> String.split ~on:' ' with
      | ["SET";key;value] -> Some (Set (key,value))
      | ["GET";key] -> Some(Get key)
      | line -> None


let rec loop store =
  match In_channel.input_line In_channel.stdin with
  | None -> ()
  | Some line ->
    let new_store = match build_command line with
    | None -> print_endline "Parse Error"; store
    | Some (Set (k,v)) -> Store.set store ~key:k ~value:v
    | Some (Get k) -> match Store.get store ~key:k with
      | Some v -> print_endline v; store
      | None -> print_endline @@ "NOT FOUND"; store
                in
    loop new_store

let () =
  let kv_store = Store.empty in
  loop kv_store
