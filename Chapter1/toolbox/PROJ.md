# ocaml-toolbox

A small suite of OCaml command-line utilities demonstrating core language features from the *Guided Tour* chapter of *Real World OCaml*.

This project includes several tools that showcase OCaml’s functions, pattern matching, lists, options, recursion, mutable state, and basic I/O.

## Requirements

- OCaml (>= 4.14)
- dune
- `base`, `stdio` libraries

## Building

1. Create a `dune-project` file:

(lang dune 2.9)
(name ocaml_toolbox)

2. Each command lives in its own `.ml` file with a corresponding `dune` stanza.

3. From the root directory, run:

dune build

4. Executables will be under `_build/default/`.

## Usage

./_build/default/.exe [arguments] < input

### Tools

~~#### sum-list~~

Reads integers (one per line) from standard input and prints the total sum (as float).

Example:

$ echo -e “1\n2\n3\n” | ./_build/default/sum-list.exe
Total: 6.000000

#### grep

Filters lines that contain a given substring.

$ echo -e “apple\nbanana\napricot\n” | ./_build/default/grep.exe ap
apple
apricot

#### remove-duplicates

Removes sequential duplicates from a list of integers.

$ echo “1 1 2 3 3 3 4 4 2 2” | ./_build/default/remove-duplicates.exe
1 2 3 4 2

#### find-first-negative

Finds the first negative number in space-separated integers.

$ echo “1 3 -2 4” | ./_build/default/find-first-negative.exe
Some 2

Returns `None` when no negative number is found.

$ echo “1 2 3” | ./_build/default/find-first-negative.exe
None

## Tests

Place these in `.txt` files and run with redirection.

### sum-list

Input (`nums.txt`):

1
2
3

Expected output:

Total: 6.000000

### grep

Input (`words.txt`):

apple
banana
apricot

Command:

./grep.exe ap < words.txt

Expected output:

apple
apricot

### remove-duplicates

Input:

1 1 2 3 3 3 4

Expected output:

1 2 3 4

### find-first-negative

Input:

1 2 3 -1 5

Expected output:

Some 1 

Input:

1 2 3 4 5

Expected output:

None

## Project Structure

.
├── dune-project
├── sum-list.ml
├── grep.ml
├── remove-duplicates.ml
├── find-first-negative.ml
├── dune
└── README.md

## Suggested Extension Ideas

- Add command-line argument parsing (e.g., optional flags).
- Add error messages for invalid input.
- Support reading from files as well as stdin.




