Project — ports

Typed Local Port Inspector (macOS, lsof)

⸻

Goal

Build a CLI tool that:
	•	Executes lsof -i -P -n
	•	Parses its output into strongly typed records
	•	Displays listening ports in a clean, structured format
	•	Uses proper record modeling and module boundaries

This project focuses on:
	•	Record design
	•	Optional fields
	•	Field punning
	•	Record patterns
	•	Functional updates
	•	Namespacing records inside modules
	•	Handling messy real-world data safely

⸻

Example Usage

$ ports
PORT   PROTOCOL   PROCESS      USER
5432   TCP        postgres     _postgres
3000   TCP        node         simon

Optional extensions:

$ ports --user simon
$ ports --protocol TCP


⸻

System Command

You will execute:

lsof -i -P -n

Typical output:

COMMAND     PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
node       1234 simon  23u  IPv4 0x...      0t0  TCP *:3000 (LISTEN)
postgres   5678 _postgres  5u  IPv4 0x...   0t0  TCP *:5432 (LISTEN)

You care about:
	•	COMMAND
	•	PID
	•	USER
	•	NAME (contains protocol, port, state)

⸻

Required Architecture

Module: Connection

Create a module that encapsulates the record.

module Connection : sig
  type t =
    { command  : string
    ; pid      : int
    ; user     : string
    ; protocol : string
    ; port     : int
    ; state    : string option
    }

  val of_lsof_line : string -> t option
end

Rules
	•	state must be string option
	•	Return None for lines that cannot be parsed
	•	Do not expose internal parsing helpers

⸻

Parsing Requirements

Your of_lsof_line function must:
	1.	Split the line safely.
	2.	Extract:
	•	command
	•	pid
	•	user
	3.	Parse the final NAME column:
	•	Example: TCP *:3000 (LISTEN)
	•	Extract:
	•	protocol = "TCP"
	•	port = 3000
	•	state = Some "LISTEN" or None
	4.	Use safe integer parsing (Int.of_string_opt or equivalent).
	5.	Avoid partial functions.

⸻

Running the System Command

Implement:

val get_lsof_output : unit -> string list

Use:

Core_unix.open_process_in

Steps:
	•	Execute command
	•	Read all lines
	•	Close process
	•	Drop header row

⸻

CLI Behavior

In main.ml:
	1.	Fetch lines
	2.	Parse with Connection.of_lsof_line
	3.	Filter out None
	4.	Keep only connections with:

state = Some "LISTEN"

	5.	Pretty print results

⸻

Pretty Printing (Use Record Patterns)

Example:

let print_connection { command; port; protocol; user; _ } =
  printf "%-6d %-8s %-12s %s\n" port protocol command user

Enable warning 9 for missing record fields and explicitly handle ignored fields using ; _.

⸻

Functional Update Practice

Add a derived record:

type enriched =
  { conn : Connection.t
  ; is_system_process : bool
  }

Implement:

let enrich conn =
  { conn
  ; is_system_process = String.is_prefix conn.user ~prefix:"_"
  }


⸻

Stretch Goals
	1.	Add filtering flags:
	•	--user
	•	--protocol
	2.	Sort by port.
	3.	Group by user.
	4.	Count open ports per process.
	5.	Add JSON output mode.
	6.	Detect duplicate ports.
	7.	Add remote_host : string option.

⸻

Design Constraints
	•	Connection.t must live inside a module.
	•	Use field punning when constructing records.
	•	Use record patterns when printing.
	•	Do not use mutation.
	•	Handle optional data properly.
	•	Add a new field later and observe compiler behavior.

⸻

What You Will Learn
	•	Records as real-world domain models
	•	Optional field modeling
	•	Parsing unsafe system output safely
	•	Field punning clarity
	•	Record evolution safety
	•	Functional update trade-offs
	•	Namespacing to avoid field ambiguity

⸻

Success Criteria

The project is complete when:
	•	ports runs successfully
	•	Only listening ports are displayed
	•	Output is formatted cleanly
	•	Swapping or evolving fields requires minimal changes
	•	The codebase reflects clean record modeling discipline
