open Core

type t = (string * string) list

let empty = []
let equals_internal k1 k2 = String.equal k1 k2


(* compare entire lists ignoring order *)
let equals (l1 : t) (l2 : t) : bool =
  let compare_pair (k1, v1) (k2, v2) =
    let c = String.compare k1 k2 in
    if c <> 0 then c else String.compare v1 v2
  in
  let sorted1 = List.sort ~compare:compare_pair l1 in
  let sorted2 = List.sort ~compare:compare_pair l2 in
  List.equal
    (fun (a, b) (c, d) -> String.equal a c && String.equal b d)
    sorted1 sorted2

let set (main_list : t) ~key ~value : t =
  List.Assoc.add ~equal:equals_internal main_list key value

let get (main_list : t) ~key : string option =
  List.Assoc.find main_list ~equal:equals_internal key

let to_list (main_list : t) : (string * string) list = main_list

let to_string l =
  List.fold ~init:""
    ~f:(fun acc (k, v) -> String.concat [ acc; k; ": "; v; "\n" ])
    l
