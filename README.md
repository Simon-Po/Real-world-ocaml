# Real World OCaml Study 

https://dev.realworldocaml.org

This repository contains my work and projects while reading Real World OCaml.

i do enjoy, when learning something new to build a small project with every chapter, llms are pretty good at coming up with fitting ones and giving reviews after



## 1 — A Guided Tour

Content:
Functions, pattern matching, lists, options, basic CLI programs.

Project: toolbox
Small CLI utilities to practice recursion, list processing, and simple I/O.
> Starting out ocaml had a pretty weird syntax to be honest.



## 2 — Variables & Functions

Content:
Labeled arguments, optional arguments, partial application, variants, command routing.

Project: Extended toolbox
Built a multi-command CLI using variants and structured argument parsing.

> Learned about Base Core Stdio, The jane street ecosystem



## 3 — Lists & Pattern Matching

Focus:
Structural recursion, tail recursion, folds, manual aggregation (no maps).

Project: fa — Text Analyzer
CLI tool that computes line count, word count, character count, longest line, and most frequent word using only lists.
> i have always thought every language should have pattern matching, additionally here i actually felt that i am writing a compiled language for the first time, i used the text analyzer on biger files and it was pretty quick




## 4 — Modules & Abstraction

Content:
Modules, .ml / .mli, abstract types, representation hiding, interface-first design.

Project: kv — Pluggable Key–Value Store
	•	Defined an abstract Store.S interface
	•	Implemented two backends:
	•	Association list
	•	Map-based
	•	Swappable implementations without changing client code
	•	Strict abstraction boundaries enforced via .mli

> One of the most important things i want to get out of this book, i feel like strong abstraction and the idea of modeling with types is something missing from my work right now. Actually pretty enjoyable with ocaml



## Aside: Functional Programming Comparison

Reimplemented the GitHub repository analyzer in:
	•	Go (explicit error handling)
	•	TypeScript + fp-ts (Either, TaskEither)

Goal:
	•	Compare explicit error handling models
	•	Explore functional composition in different ecosystems
	•	Understand trade-offs between FP-heavy and pragmatic approaches

> This was actually a pretty cool tool to try out hard a imperative approach with go and a (unpure) but still functional with typescript and fp-ts as always fp-ts is a huge amount of boilerplate but i do really enjoy using it. I actually think the Github Repo analyzer will become one of my new goto tech-tryout projects it covers quite a bit.
