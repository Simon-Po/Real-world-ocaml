import * as E from "fp-ts/lib/Either";
import * as TE from "fp-ts/lib/TaskEither";
import { identity, pipe } from "fp-ts/lib/function";
import * as J from "fp-ts/Json";

const parseArguments = (): E.Either<string, string> => {
  const usage = "Usage: analyze <github-url>";
  const [url, ...rest] = Bun.argv.slice(2);
  if (url === undefined) return E.left("Github url missing : " + usage);
  if (rest.length !== 0) return E.left("Too many arguments: " + usage);
  return E.right(url);
};

type GithubRepo = {
  owner: string;
  repo: string;
};

const githubRegex =
  /^https?:\/\/github\.com\/([^\/]+)\/([^\/]+?)(?:\.git)?\/?$/;

const validateUrl = (url: string): E.Either<string, GithubRepo> =>
  pipe(
    url,
    E.fromPredicate(
      (u) => u.startsWith("http") && u.includes("github.com/"),
      () => `${url} is not a valid GitHub URL`,
    ),
    E.chain((u) =>
      pipe(
        u.match(githubRegex),
        E.fromNullable("Invalid GitHub URL format: expected /owner/repo"),
      ),
    ),
    E.map(([, owner, repo]) => ({ owner, repo })),
  );

const panic = (err: string) => {
  console.error("Error:", err);
  process.exit(1);
};

const getRepo = (repo: GithubRepo): TE.TaskEither<string, string> =>
  TE.tryCatch(
    async () => {
      const response = await fetch(
        `https://api.github.com/repos/${repo.owner}/${repo.repo}`,
      );

      if (!response.ok) {
        throw new Error(`GitHub API returned ${response.status}`);
      }

      return await response.text();
    },
    (err) => (err instanceof Error ? err.message : "Unknown fetch error"),
  );

type GithubRepoStats = {
  name: string;
  stargazers_count: number;
  forks_count: number;
  language: string;
};

type statsWithScore = GithubRepoStats & { score: number };

const isGithubRepoStats = (u: unknown): u is GithubRepoStats =>
  typeof u === "object" &&
  u !== null &&
  "name" in u &&
  "stargazers_count" in u &&
  "forks_count" in u &&
  "language" in u &&
  typeof (u as any).name === "string" &&
  typeof (u as any).stargazers_count === "number" &&
  typeof (u as any).forks_count === "number" &&
  typeof (u as any).language === "string";

const parseApiResponse = (
  text: string,
): TE.TaskEither<string, GithubRepoStats> =>
  pipe(
    text,
    J.parse,
    E.mapLeft(() => "Could not parse JSON"),
    E.chain(
      E.fromPredicate(
        isGithubRepoStats,
        () => "Invalid GitHub API response shape",
      ),
    ),
    TE.fromEither,
  );

async function main() {
  await pipe(
    parseArguments(),
    // chain is pretty much flatMap so if we receive right(x) we keep going
    // otherwise we just forward left(err)
    E.chain(validateUrl),
    TE.fromEither,
    TE.chain(getRepo),
    TE.chain(parseApiResponse),
    TE.map((stats: GithubRepoStats): statsWithScore => {
      return {
        name: stats.name,
        stargazers_count: stats.stargazers_count,
        forks_count: stats.forks_count,
        language: stats.language,
        score: stats.forks_count + stats.stargazers_count,
      };
    }),
    TE.match(panic, (result) => {
      console.log(`=== ${result.name.toUpperCase()}  ===
Most used Language: ${result.language}
Score:              ${result.score}
Forks:              ${result.forks_count}
Stargazers:         ${result.stargazers_count}`);
    }),
  )();
}

main();
