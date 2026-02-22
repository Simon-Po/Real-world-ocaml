open Base
open Stdio

let hi () = print_endline "Hello world"

let max_widths header rows =
  let lengths l = List.map ~f:String.length l in
  List.fold rows ~init:(lengths header) ~f:(fun acc row ->
      List.map2_exn ~f:Int.max acc (lengths row))

let render_separator widths =
  let pieces = List.map widths ~f:(fun w -> String.make w '-') in
  "|-" ^ String.concat ~sep:"-+-" pieces ^ "-|"

let pad s length = s ^ String.make (length - String.length s) ' '

let render_row row widths =
  let padded = List.map2_exn row widths ~f:pad in
  "| " ^ String.concat ~sep:" | " padded ^ " |"

let render_starter complete_width = "|-" ^ String.make (complete_width+6) '-' ^ "-|"


let render_table header rows =
  let widths = max_widths header rows in
  let complete_width = match List.reduce widths ~f:(+) with
    | Some(i) -> i
    | None -> 0
  in

  String.concat ~sep:"\n"
    (render_starter complete_width
     :: render_row header widths
     :: render_separator widths
     :: List.map rows ~f:(fun row -> render_row row widths)
    )

(* let render_table header rows = *)
(*   let m_w = max_widths header rows in *)
