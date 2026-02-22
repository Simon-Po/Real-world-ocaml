GitHub Repository Analyzer — Language-Agnostic Specification

Overview

Create a command-line tool named analyze that:
	1.	Reads a GitHub repository URL from the command line.
	2.	Validates that the URL refers to a valid GitHub repository.
	3.	Requests repository metadata from the GitHub API.
	4.	Parses the response safely.
	5.	Computes a score based on repository statistics.
	6.	Prints a summary or clear error messages for all failure cases.

Every step must explicitly handle errors. Do not rely on exceptions for control flow.

⸻

Input and Usage

The program must accept exactly one argument:

analyze <github-url>

Examples:

analyze https://github.com/facebook/react

If no arguments are provided or more than one is provided, the program must print an error and exit.

⸻

1. Parse Command-Line Argument

Function: parseArguments
	•	If no argument is provided, return an error with a message like:

Usage: analyze <github-url>


	•	If more than one argument is provided, return an error message indicating the misuse.
	•	If exactly one argument is provided, return it for further processing.

Output:
Either a valid input string or an error message.

⸻

2. Validate GitHub URL

Function: validateUrl(url)

Given a URL string, verify that it matches the pattern:

https://github.com/<owner>/<repo>

	•	<owner> and <repo> must be present and non-empty.
	•	If the URL is valid, return an object/struct with fields:
	•	owner
	•	repo
	•	If invalid, return an error message such as:

Invalid GitHub URL



Output:
Either a validated repository reference or an error message.

⸻

3. Fetch Repository Metadata

Function: fetchRepo(owner, repo)

Given a valid owner/repo pair:
	•	Build and issue an HTTP GET request to:

https://api.github.com/repos/<owner>/<repo>


	•	If the request fails due to network issues or the response status is not 200, return an error message such as:

Network request failed


	•	If the request succeeds, return the response body as text.

Output:
Either response text or an error message.

⸻

4. Parse API Response JSON

Function: parseRepo(jsonText)

Given the raw JSON text from the HTTP response:
	•	Parse the JSON.
	•	Extract the following required fields:
	•	name (string)
	•	stargazers_count (integer)
	•	forks_count (integer)
	•	language (string or null)
	•	If parsing fails or any required field is missing or of the wrong type, return an error message such as:

Unexpected API response



Output:
Either a structured repository data record with the above fields or an error.

⸻

5. Compute Score

Function: computeScore(repoData)

Given the parsed repository data:
	•	Compute:

coolness_score = stargazers_count + forks_count


	•	Return an object/struct that includes:
	•	name
	•	stargazers_count
	•	forks_count
	•	language
	•	coolness_score

Output: A pure data record with the computed score.

⸻

6. Composition and Execution

Compose the functions in the following order:

parseArguments()
→ validateUrl
→ fetchRepo
→ parseRepo
→ computeScore

At each stage, if an error occurs, the program must:
	•	Print the error message (exactly as returned)
	•	Terminate execution

If all stages succeed, the program must print a summary with the following fields:

Repository: <name>
Stars: <stargazers_count>
Forks: <forks_count>
Language: <language>
Coolness score: <coolness_score>


⸻

Failure Handling

The program must explicitly handle all error cases:
	•	No exceptions for normal control flow.
	•	If an operation fails, propagate a clear error message.
	•	Do not crash or produce stack traces in normal error conditions.

⸻

Outputs

Success Example

Repository: react
Stars: 218000
Forks: 45000
Language: JavaScript
Coolness score: 263000

Failure Examples

Error: Usage: analyze <github-url>

Error: Invalid GitHub URL

Error: Network request failed

Error: Unexpected API response


⸻

Function Checklist (Core Interfaces)

Function	Input	Output
parseArguments	CLI arguments	URL string or error
validateUrl	string	{owner, repo} or error
fetchRepo	owner, repo	JSON text or error
parseRepo	JSON text	parsed repo data or error
computeScore	repo data	enriched data with score


⸻

Design Principles
	•	Keep each function focused on a single responsibility.
	•	Return errors explicitly rather than throwing exceptions.
	•	Separate parsing, validation, networking, and scoring logic.
	•	Avoid assumptions about input; check every required value.
	•	Make it possible to test each step independently.

⸻

Testing Recommendations
	•	Test with valid URLs and real GitHub repositories.
	•	Test with malformed URLs.
	•	Test with missing fields in JSON.
	•	Test network failures (simulate offline mode).
	•	Confirm output text matches the expected format exactly.  ￼
