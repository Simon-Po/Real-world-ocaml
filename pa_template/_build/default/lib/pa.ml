open Core




let world (  ) = "world"

let%test "world is world" =
  String.equal (world ()) "world"

let main ( ) = print_endline @@ "Hello, " ^ world (  )

let%expect_test "main" =
  main();
  [%expect {|Hello, world|}]
