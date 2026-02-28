open Core
open Ports

let () =
  let connections =
    Ports.get_lsof_output () |> List.filter_map ~f:Ports.Connection.of_lsof_line  |> List.filter ~f:(fun el -> Option.is_some el.state)
  in
  List.iter
    ~f:(fun el -> print_endline (Ports.Connection.to_string el))
    connections
