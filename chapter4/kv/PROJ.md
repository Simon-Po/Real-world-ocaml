Project: Pluggable Key–Value Store (Modules & Abstraction)

Goal

Build a small key–value store CLI application in OCaml that:
	1.	Defines a clean abstract module interface
	2.	Provides two different internal implementations
	3.	Allows swapping implementations without changing client code
	4.	Enforces abstraction boundaries via .mli

This project focuses entirely on:
	•	Modules
	•	.ml / .mli
	•	Abstract types
	•	Interface-first design
	•	Representation hiding
	•	Implementation swapping
	•	Clean API design

⸻

Program Behavior

Executable:

kvstore

Reads commands from stdin:

SET name Simon
GET name
SET city Berlin
GET city
GET age

Outputs:

Simon
Berlin
NOT FOUND

Rules:
	•	SET key value stores the value.
	•	GET key prints the value or NOT FOUND.
	•	Unknown commands should produce a readable error.

⸻

Required Project Structure

lib/
  store.mli
  store_list.ml
  store_map.ml
bin/
  main.ml

Use dune.

⸻

Step 1 — Design the Interface First

File: store.mli

You must define:

type t

val empty : t

val set : t -> key:string -> value:string -> t

val get : t -> key:string -> string option

val to_list : t -> (string * string) list

Rules:
	•	type t must be abstract.
	•	Do not expose internal representation.
	•	Client code must not depend on how storage works.

⸻

Step 2 — First Implementation (Association List)

File: store_list.ml

Internal representation:

type t = (string * string) list

Implement:
	•	empty
	•	set
	•	get
	•	to_list

Use List.Assoc from Base.

⸻

Step 3 — Second Implementation (Map-Based)

File: store_map.ml

Internal representation:

type t = string Map.M(String).t

Implement the same interface.

Use Map from Base.

⸻

Step 4 — Client Code (main.ml)

In main.ml, choose implementation like this:

let module Store = Store_list in

Or:

let module Store = Store_map in

Nothing else in main.ml should change.

If you must change anything else, your abstraction failed.

⸻

Parsing Commands

In main.ml, you will:
	•	Read lines from stdin
	•	Split by spaces
	•	Pattern match on:

| ["SET"; key; value] -> ...
| ["GET"; key] -> ...

	•	Maintain store state recursively

Example loop structure:

let rec loop store =
  match In_channel.input_line In_channel.stdin with
  | None -> ()
  | Some line ->
      (* parse and update store *)
      loop new_store


⸻

Design Requirements
	1.	No implementation details may leak through the interface.
	2.	main.ml must not know how Store.t is implemented.
	3.	You must be able to swap implementations safely.
	4.	Follow the “t-first” convention.
	5.	Use labeled arguments in set.

⸻

What This Project Teaches

You will understand:
	•	Why .mli files matter
	•	How abstract types protect invariants
	•	Why interface-first design is powerful
	•	How module boundaries enforce discipline
	•	How swapping implementations becomes trivial
	•	The difference between open and include
	•	That files are modules

This is the core mental model of large OCaml systems.

⸻

Stretch Goals

After basic functionality works:
	1.	Add:

val remove : t -> key:string -> t

	2.	Add:

val size : t -> int

	3.	Benchmark both implementations.
	4.	Add a third implementation (e.g., sorted list).
	5.	Add persistence (save/load from file).

⸻

Strict Abstraction Test

After finishing:
	1.	Replace Store_list with Store_map in main.ml.
	2.	Recompile.
	3.	If it builds and runs without modification, you succeeded.
	4.	If it breaks, you leaked representation somewhere.

⸻

Reflection Questions
	1.	Why is type t abstract?
	2.	What would break if you exposed the concrete type?
	3.	Which implementation is asymptotically better?
	4.	Where does representation hiding matter most?
	5.	Why is interface-first design powerful?


