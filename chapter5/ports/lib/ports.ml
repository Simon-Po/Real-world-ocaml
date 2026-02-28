open Core

module Connection = struct
  type t = {
    command : string;
    pid : int;
    user : string;
    protocol : string;
    port : int;
    state : string option;
  }
  [@@deriving fields]
  (* "Raycast    4604 spohl   42u  IPv4 0x80b75638319ce910      0t0  TCP 127.0.0.1:7265 (LISTEN)";
*)

  let of_lsof_line (input : string) : t option =
    let open Option.Let_syntax in
    let split_once s = String.lsplit2 s ~on:':' in

    let unpack_portstr pstr =
      match split_once pstr with Some (_, port) -> port | None -> pstr
    in

    let parts =
      String.split ~on:' ' input |> List.filter ~f:(Fn.non String.is_empty)
    in

    match parts with
    | command :: pid_str :: user :: _ :: _ :: _ :: _ :: name_parts ->
        let%bind pid = Int.of_string_opt pid_str in
        let%bind protocol, portstr, state =
          match name_parts with
          | [ protocol; portstr; state ] -> Some (protocol, portstr, Some state)
          | [ protocol; portstr ] -> Some (protocol, portstr, None)
          | _ -> None
        in
        let%bind port = Int.of_string_opt (unpack_portstr portstr) in
        Some { command; pid; user; protocol; port; state }
    | _ -> None

  let to_string { command; pid; user; protocol; port; state } =
    let s = Option.value ~default:"" state in
    Printf.sprintf "%d %-6d %-8s %-12s %s %s" pid port protocol command user s
end

type enriched = {
  conn : Connection.t ; is_system_process : bool
}

let enrich (conn:Connection.t): enriched =
  {conn; is_system_process = String.is_prefix conn.user ~prefix:"_"}

let get_lsof_output () : string list =
  let in_chan = Core_unix.open_process_in "lsof -i -P -n" in
  In_channel.input_lines in_chan
