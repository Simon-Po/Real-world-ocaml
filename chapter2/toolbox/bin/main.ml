open Core
type command =
  | Greet of string * int option
  | Calc of string * int * int
  | Banner of string * int option

let dispatch = function
  | Greet (name, times) ->
    Toolbox.greet ~name ?times ()
  | Calc (op, x, y) ->
    Toolbox.calc ~op ~x ~y
  | Banner (text, width) ->
    Toolbox.banner ~text ?width ()




(* Build a command tree with subcommands.
   Each subcommand only parses CLI flags and writes one [command] value. *)
let build_parser ~(set_parsed : command -> unit) : Command.t =
  let greet_cmd =
    Command.basic
      ~summary:"Parse greet flags: --name STRING [--times INT]"
      (let open Command.Let_syntax in
       (* ppx_jane: [let%map_open] combines multiple flag parsers into one parser.
          Think of it as: parse each flag, then build a function from the results. *)
       let%map_open name =
         flag
           "-name"
           ~aliases:[ "--name" ]
           (required string)
           ~doc:"STRING Name to greet"
       and times =
         flag
           "-times"
           ~aliases:[ "--times" ]
           (optional int)
           ~doc:"INT Optional repeat count"
       in
       (* The final value of a [Command.basic] parser is a [unit -> unit] callback
          that runs after parsing succeeds. *)
       fun () -> set_parsed (Greet (name, times)))
  in
  let calc_cmd =
    Command.basic
      ~summary:"Parse calc flags: --op OP --x INT --y INT"
      (let open Command.Let_syntax in
       (* ppx_jane: [and] inside [let%map_open] parses these flags in one parser and
          passes all parsed values to the expression below [in]. *)
       let%map_open op =
         flag
           "-op"
           ~aliases:[ "--op" ]
           (required string)
           ~doc:"OP Operation (add|sub|mul|div)"
       and x =
         flag "-x" ~aliases:[ "--x" ] (required int) ~doc:"INT Left operand"
       and y =
         flag "-y" ~aliases:[ "--y" ] (required int) ~doc:"INT Right operand"
       in
       fun () -> set_parsed (Calc (op, x, y)))
  in
  let banner_cmd =
    Command.basic
      ~summary:"Parse banner flags: --text STRING [--width INT]"
      (let open Command.Let_syntax in
       let%map_open text =
         flag
           "-text"
           ~aliases:[ "--text" ]
           (required string)
           ~doc:"STRING Banner text"
       and width =
         flag
           "-width"
           ~aliases:[ "--width" ]
           (optional int)
           ~doc:"INT Optional banner width"
       in
       fun () -> set_parsed (Banner (text, width)))
  in
  Command.group
    ~summary:"Command parser for greet, calc, and banner"
    [ ("greet", greet_cmd); ("calc", calc_cmd); ("banner", banner_cmd) ]

(* Parse argv with Core's command framework.
   Example argv:
   [| "my_program"; "greet"; "--name"; "sp"; "--times"; "3" |] *)
let parse_exn ?(argv = Sys.get_argv ()) () : command =
  let parsed = ref None in
  let parser = build_parser ~set_parsed:(fun c -> parsed := Some c) in
  (* Compatibility shim:
     this Core setup parses single-dash long flags (e.g. [-name]).
     We accept user-friendly [--name] by rewriting [--foo] -> [-foo]
     before handing argv to Core. *)
  let normalize_arg arg =
    if String.is_prefix arg ~prefix:"--" && not (String.equal arg "--")
    then "-" ^ String.drop_prefix arg 2
    else arg
  in
  Command_unix.run ~argv:(Array.to_list argv |> List.map ~f:normalize_arg) parser;
  Option.value_exn !parsed ~message:"No command was parsed"



let () =
  dispatch (parse_exn ())
