# Safe GitHub Repository Analyzer (fp-ts Project)

## Goal

Build a CLI tool using **fp-ts** that:

1. Accepts a GitHub repository URL
2. Fetches repository metadata from the GitHub API
3. Safely validates and parses the response
4. Computes a “coolness score”
5. Handles all failure cases using `Either` and `TaskEither`
6. Never uses `throw` for control flow

Time estimate: ~2 hours

---

## What You Will Practice

- `pipe`
- `Either`
- `Option`
- `TaskEither`
- `map`
- `chain`
- `fromNullable`
- `tryCatch`
- Functional error handling
- Async composition

---

## Setup

```bash
npm init -y
npm install fp-ts
npm install node-fetch
npm install -D typescript ts-node @types/node

Create:

analyze.ts
tsconfig.json

Run with:

npx ts-node analyze.ts <github-url>


⸻

Expected Usage

npx ts-node analyze.ts https://github.com/facebook/react

Expected output:

Repository: react
Stars: 218000
Forks: 45000
Language: TypeScript
Coolness score: 263000


⸻

Required Features

1. Parse CLI Argument

Return:

Either<string, string>

	•	If no argument → Left("Usage: analyze <github-url>")
	•	If provided → Right(url)

⸻

2. Validate GitHub URL

Accept only URLs matching:

https://github.com/<owner>/<repo>

Return:

Either<string, { owner: string; repo: string }>

Invalid → Left("Invalid GitHub URL")

⸻
  * [ ] 
3. Fetch Repository Data (TaskEither)

Call:

https://api.github.com/repos/:owner/:repo

Use:

TE.tryCatch

Return:

TaskEither<string, unknown>

On network error → Left("Network request failed")

⸻

4. Safely Parse API Response

Extract:
	•	name
	•	stargazers_count
	•	forks_count
	•	language

Use:
	•	fromNullable
	•	Either
	•	chain
	•	map

Return:

Either<string, {
  name: string
  stars: number
  forks: number
  language: string | null
}>

If any required field is missing → Left("Unexpected API response")

⸻

5. Compute Coolness Score

Define:

score = stars + forks

Pure function.

⸻

6. Compose Everything With pipe

Final structure should resemble:

pipe(
  parseArgs(),
  E.chain(validateUrl),
  TE.fromEither,
  TE.chain(fetchRepo),
  TE.chain(parseRepo),
  TE.map(computeScore)
)

Then execute the Task and print:
	•	On success → formatted output
	•	On failure → error message

⸻

Error Handling Requirements

You must not:
	•	Use throw
	•	Use try/catch outside tryCatch
	•	Use ! non-null assertion

All failures must flow through Either or TaskEither.

⸻

Suggested File Structure

analyze.ts

Keep everything in one file for this exercise.

⸻

Minimal Function Checklist

You must implement:
	•	parseArgs(): Either<string, string>
	•	validateUrl(url: string): Either<string, RepoRef>
	•	fetchRepo(ref: RepoRef): TaskEither<string, unknown>
	•	parseRepo(json: unknown): Either<string, Repo>
	•	computeScore(repo: Repo): Result
	•	main(): Task<void>

⸻

Stretch Goals (Optional)

If time remains:
	•	Add --raw flag to print raw JSON
	•	Add stars-to-forks ratio
	•	Add validation for HTTP status code
	•	Add support for GitHub enterprise URLs
	•	Add colored CLI output

⸻

What This Project Proves

You understand:
	•	How to compose async computations safely
	•	How Either differs from exceptions
	•	How to lift Either into TaskEither
	•	How pipe replaces nested function calls
	•	How to model failure explicitly
	•	How to eliminate null checks with Option
	•	How to design small composable functions

⸻

Reflection Questions (After Completing)
	1.	Where did TaskEither become necessary?
	2.	What happens if you remove pipe?
	3.	Which parts are pure?
	4.	Which parts are effectful?
	5.	How would you write this without fp-ts?
	6.	Which version feels safer?


