open Core



type t = string Map.M(String).t


let empty : t = Map.empty (module String)

let set m ~key ~value : t = Map.set m ~key ~data:value

let get m ~key : string option = Map.find m key

let to_list m : (string * string) list = Map.to_alist m
