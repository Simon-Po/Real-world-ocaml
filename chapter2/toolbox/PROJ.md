# Command Router with Labeled APIs

## Goal

Build a small CLI command router that demonstrates:

- Labeled arguments
- Optional arguments
- Optional argument erasure behavior
- Currying
- Partial application
- Pattern matching using `function`
- Variants for command modeling
- Scope and shadowing
- Higher-order dispatch

This project focuses on mastering the mechanics introduced in Chapter 2 of *Real World OCaml*.

---

## Overview

You will build a CLI tool called:

./toolbox  [arguments]

Supported commands:

greet
calc
banner

Each command must be implemented as a curried function using labeled and optional arguments.

---

## Core Type

Define a command type:

```ocaml
type command =
  | Greet of string * int option
  | Calc of string * int * int
  | Banner of string * int option

You must parse CLI arguments into this type before dispatching.

⸻

Command Specifications

1. greet

Signature:

val greet : name:string -> ?times:int -> unit -> unit

Behavior:
	•	Prints “Hello ”
	•	If ~times is provided, prints it that many times
	•	Default times = 1

Examples:

./toolbox greet --name=sp

Output:

Hello sp

./toolbox greet --name=sp --times=3

Output:

Hello sp
Hello sp
Hello sp


⸻

2. calc

Signature:

val calc : op:string -> x:int -> y:int -> int

Supported operations:
	•	add
	•	sub
	•	mul
	•	div

Examples:

./toolbox calc --op=add --x=3 --y=4

Output:

7

./toolbox calc --op=mul --x=3 --y=4

Output:

12


⸻

3. banner

Signature:

val banner : text:string -> ?width:int -> string

Behavior:
	•	Surround text with *
	•	If width is provided and larger than text, center text within stars
	•	Default width = length of text + 4

Example:

./toolbox banner --text=hello

Output:

**hello**

./toolbox banner --text=hello --width=12

Output:

***hello***


⸻

Dispatch

Implement:

val dispatch : command -> unit

Use the function keyword for pattern matching:

let dispatch = function
  | Greet (name, times) -> ...
  | Calc (op, x, y) -> ...
  | Banner (text, width) -> ...


⸻

Required Features to Demonstrate

1. Partial Application

Example:

let greet_sp = greet ~name:"sp"

Test whether optional argument can still be passed.

You must explore optional argument erasure behavior by modifying argument order and observing effects.

⸻

2. Optional Argument Forwarding

Create:

let loud_greet ?times name =
  greet ?times ~name:(String.uppercase name) ()

This must forward the optional argument using ?times.

⸻

3. Custom Operator

Define a custom operator for handler registration:

let ( ==> ) name handler = (name, handler)

Use it to build a command table:

let routes =
  [
    "greet" ==> ...
    "calc" ==> ...
    "banner" ==> ...
  ]


⸻

CLI Parsing

Use Sys.argv.

Expected formats:

--name=sp
--times=3
--op=add
--x=3
--y=4
--text=hello
--width=10

You may implement simple string parsing using:
	•	String.split
	•	String.is_prefix
	•	Pattern matching

No external CLI library.

⸻

Required Tests

greet

./toolbox greet --name=sp

Expected:

Hello sp

./toolbox greet --name=sp --times=2

Expected:

Hello sp
Hello sp


⸻

calc

./toolbox calc --op=add --x=5 --y=7

Expected:

12

./toolbox calc --op=sub --x=5 --y=7

Expected:

-2


⸻

banner

./toolbox banner --text=hi

Expected:

**hi**

./toolbox banner --text=hi --width=8

Expected:

***hi***


⸻

What This Project Proves

You understand:
	•	Labeled arguments and their ordering
	•	Optional arguments and erasure rules
	•	Forwarding optional arguments with ?
	•	Partial application mechanics
	•	Currying
	•	Higher-order function dispatch
	•	Variant modeling
	•	Shadowing vs rebinding
	•	function pattern matching

⸻

Stretch Goals (Optional)
	•	Add a help command
	•	Add validation for missing arguments
	•	Refactor parsing into reusable helpers
	•	Add a custom pipeline operator using |>

⸻

Deliverables
	•	Working CLI binary
	•	Clean separation between parsing, command modeling, and execution
	•	Tests verifying behavior
	•	Exploration notes on optional argument erasure


