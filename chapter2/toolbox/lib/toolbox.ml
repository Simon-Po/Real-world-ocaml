open Core

let greet ~name ?(times = 1) () =
  for _ = 1 to times do
    print_endline @@ "Hello " ^ name
  done

(* *)

let%expect_test "greet default times=1" =
  greet ~name:"sp" ();
  [%expect {| Hello sp |}]

let%expect_test "greet times=3" =
  greet ~name:"sp" ~times:3 ();
  [%expect {|
Hello sp
Hello sp
Hello sp
|}]

let calc_internal ~op ~x ~y =
  match op with
  | "add" -> Some (x + y)
  | "sub" -> Some (x - y)
  | "mul" -> Some (x * y)
  | "div" when y = 0 -> None
  | "div" -> Some (x / y)
  | _ -> None

let%test "calc_internal add" =
  match calc_internal ~op:"add" ~x:1 ~y:2 with Some 3 -> true | _ -> false

let%test "calc_internal sub" =
  match calc_internal ~op:"sub" ~x:3 ~y:1 with Some 2 -> true | _ -> false

let%test "calc_internal mul" =
  match calc_internal ~op:"mul" ~x:1 ~y:3 with Some 3 -> true | _ -> false

let%test "calc_internal div" =
  match calc_internal ~op:"div" ~x:6 ~y:2 with Some 3 -> true | _ -> false

let%test "calc_internal unknown" =
  match calc_internal ~op:"something" ~x:6 ~y:2 with None -> true | _ -> false

let%test "calc_internal div by zero" =
  match calc_internal ~op:"div" ~x:6 ~y:0 with None -> true | _ -> false

let calc ~op ~x ~y =
  match calc_internal ~op ~x ~y with
  | Some answer -> print_endline @@ Int.to_string answer
  | None -> print_endline "Division by zero is not possible"

let banner ~text ?width () =
  let (should_center, width) : bool * int =
    match width with
    | Some width -> (String.length text < width, width)
    | None -> (true, String.length text + 4)
  in
  let full_text =
    if should_center then
      let pad = width - String.length text in
      let length_l = pad / 2 in
      let stars_l = String.make length_l '*' in
      let stars_r = String.make (pad - length_l) '*' in
      stars_l ^ text ^ stars_r
    else text
  in
  print_endline full_text

let%expect_test "banner default" =
  banner ~text:"simon" ();
  [%expect {|**simon**|}]

let%expect_test "banner width too small; print default" =
  banner ~text:"simon" ~width:2 ();
  [%expect {|simon|}]

(*  simon = 5 ; 13-5=8; so 4 stars on every side *)
let%expect_test "banner width even" =
  banner ~text:"simon" ~width:13 ();
  [%expect {|****simon****|}]

(*  simon = 5 ; 13-5=8; so 4 stars on every side *)
let%expect_test "banner width odd" =
  banner ~text:"simon" ~width:12 ();
  [%expect {|***simon****|}]
