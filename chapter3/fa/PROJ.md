Text Analytics Engine — Lists & Pattern Mastery

Goal

Build a CLI tool that performs structured text analysis using:
	•	Structural list recursion
	•	Pattern matching
	•	As-patterns
	•	Or-patterns
	•	When-guards (only where appropriate)
	•	Tail recursion
	•	List.map
	•	List.fold
	•	List.reduce
	•	List.filter
	•	List.filter_map
	•	List.partition_tf
	•	List.concat_map

No maps, no hash tables, no external data structures.
All aggregation must be implemented using lists and pattern matching.

This project exists to deeply internalize the material from the Lists and Patterns chapter.

⸻

CLI

Binary name:

./analyze <file>

Example:

./analyze sample.txt


⸻

Required Features

Given a text file, compute and print:
	1.	Total number of lines
	2.	Total number of words
	3.	Total number of characters
	4.	Longest line
	5.	Most frequent word (list-based counting only)
	6.	Remove sequential duplicate lines
	7.	Partition lines into:
	•	Empty lines
	•	Non-empty lines

Output format:

Lines: <int>
Words: <int>
Characters: <int>
Longest line: "<string>"
Most frequent word: "<string>"
Empty lines: <int>
Non-empty lines: <int>

Deduplicated lines:
<line1>
<line2>
...


⸻

Architectural Requirements

1. Implement Your Own Tail-Recursive Length

You must implement:

val length : 'a list -> int

Using a tail-recursive helper with an accumulator.

Also implement a naive non-tail version and demonstrate (in comments or notes) why it overflows on large lists.

⸻

2. Sequential Duplicate Removal

Implement:

val remove_sequential_duplicates : 'a list -> 'a list

Must use:
	•	As-pattern
	•	Or-pattern
	•	No unnecessary allocation

Correct style example pattern:

| [] | [_] as l -> l
| first :: (second :: _ as tl) when first = second ->


⸻

3. Word Splitting (Manual List Processing)

You must split lines into words without using high-level helpers like String.split_on_char.

Use:
	•	Recursion
	•	Pattern matching on character lists
	•	Accumulator for building words

You may convert strings to char lists if needed.

⸻

4. Word Frequency Counting (Lists Only)

Define:

type count = string * int

Build frequency counts manually:

val add_word : string -> count list -> count list

This must:
	•	Search list
	•	Update count if found
	•	Insert if not found
	•	Be implemented via recursion and pattern matching

No Map allowed.

⸻

5. Most Frequent Word

Use:
	•	List.reduce
	•	Or tail-recursive maximum search

Return:

None

if no words exist.

⸻

6. Partition Lines

Use:

List.partition_tf

Partition into empty and non-empty lines.

⸻

7. Longest Line

Use either:
	•	List.reduce
	•	Or List.fold

Must handle empty file safely.

⸻

Required Tests

Create test files and verify output matches exactly.

⸻

Test 1 — Basic Stats

File: sample1.txt

hello world
hello ocaml

hello world

Expected output:

Lines: 4
Words: 6
Characters: 34
Longest line: "hello ocaml"
Most frequent word: "hello"
Empty lines: 1
Non-empty lines: 3

Deduplicated lines:
hello world
hello ocaml
hello world


⸻

Test 2 — Sequential Duplicates

File: sample2.txt

a
a
b
b
b
c
a
a

Expected:

Lines: 8
Words: 8
Characters: 14
Longest line: "b"
Most frequent word: "a"
Empty lines: 0
Non-empty lines: 8

Deduplicated lines:
a
b
c
a


⸻

Test 3 — Empty File

File: empty.txt

(empty)

Expected:

Lines: 0
Words: 0
Characters: 0
Longest line: ""
Most frequent word: ""
Empty lines: 0
Non-empty lines: 0

Deduplicated lines:


⸻

Pattern Discipline Requirements

You must demonstrate:
	•	At least one or-pattern
	•	At least one as-pattern
	•	At least one when-guard
	•	A refactor where you remove an unnecessary when-clause and replace it with structural matching
	•	No redundant match warnings
	•	No non-exhaustive match warnings

⸻

Tail Recursion Requirement

Functions that must be tail-recursive:
	•	length
	•	word counting
	•	frequency building
	•	character counting

Document in comments which ones are tail-recursive and why.

⸻

Performance Reflection (Required)

Write short notes answering:
	1.	Why pattern matching is faster than repeated List.hd_exn calls.
	2.	Why naive length overflows stack.
	3.	Why String.concat is preferred over repeated ^.

⸻

Stretch Goals (Optional)
	•	Case-insensitive word counting
	•	Ignore punctuation
	•	Add --top=N to show N most frequent words
	•	Add benchmark comparing naive vs tail-recursive length

⸻

What This Project Proves

You understand:
	•	Structural list recursion
	•	Tail recursion and stack behavior
	•	Pattern exhaustiveness
	•	Shadowing pitfalls
	•	As-patterns
	•	Or-patterns
	•	Guard clauses tradeoffs
	•	Functional accumulation patterns
	•	How to think in lists instead of maps


