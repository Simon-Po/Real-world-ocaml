package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"regexp"
	"time"
)

func usage() string {
	return "Usage: analyze https://github.com/<owner>/<repo>"
}

func getUrl() (string, error) {
	args := os.Args[1:]
	if len(args) != 1 {
		return "", fmt.Errorf("%v", usage())
	}
	return args[0], nil
}

type Repo struct {
	owner    string
	repoName string
}

var githubRegex = regexp.MustCompile(
	`^https?://github\.com/([^/]+)/([^/]+?)(?:\.git)?/?$`,
)

func validateUrl(unvalidated_url string) (Repo, error) {
	matches := githubRegex.FindStringSubmatch(unvalidated_url)
	if matches == nil || len(matches) != 3 {
		return Repo{}, fmt.Errorf("Error: could not match url\n%v", usage())
	}
	owner := matches[1]
	repo := matches[2]
	return Repo{
		owner:    owner,
		repoName: repo,
	}, nil
}

func fetchRepo(repo Repo) ([]byte, error) {
	client := &http.Client{
		Timeout: 10 * time.Second,
	}
	resp, err := client.Get(fmt.Sprintf("https://api.github.com/repos/%s/%s", repo.owner, repo.repoName))
	if err != nil {
		return []byte{}, fmt.Errorf("Errror: Could not fetch repo: %v", err)
	}
	if resp.StatusCode != http.StatusOK {
		return []byte{}, fmt.Errorf("GitHub API returned status %d", resp.StatusCode)
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return []byte{}, fmt.Errorf("Error: Could not read from body: %v", err)
	}

	return body, nil
}

// This is ok since we are inside of a cli main function,
// otherwise this would be bad design
func check(err error) {
	if err != nil {
		fmt.Fprintln(os.Stderr,err)
		os.Exit(1)
	}
}

type GithubRepoStats struct {
	Name            string `json:"name"`
	StargazersCount int    `json:"stargazers_count"`
	ForksCount      int    `json:"forks_count"`
	Language        string `json:"language"`
}

type GithubRepoStatsWithScore struct {
	GithubRepoStats
	Score int `json:"score"`
}

func parseResponseBody(body []byte) (GithubRepoStats, error) {
	grs := GithubRepoStats{}
	err := json.Unmarshal(body, &grs)
	if err != nil {
		return GithubRepoStats{}, fmt.Errorf("Error: could not unmarshal body: %v", err)
	}
	if grs.Language == "" {
		grs.Language = "Undefined Language"
	}
	return grs, nil
}

func computeScore(grs GithubRepoStats) GithubRepoStatsWithScore {
	return GithubRepoStatsWithScore{
		grs,
		grs.StargazersCount + grs.ForksCount,
	}
}

func printResult(grsws GithubRepoStatsWithScore) {
	fmt.Printf("Repository: %v\nStars: %v\nForks: %v\nLanguage: %v\nScore: %v\n", grsws.Name, grsws.StargazersCount, grsws.ForksCount, grsws.Language, grsws.Score)
}


func main() {
	unvalidated_url, err := getUrl()
	check(err)
	repo, err := validateUrl(unvalidated_url)
	check(err)
	body, err := fetchRepo(repo)
	check(err)
	grs, err := parseResponseBody(body)
	check(err)
	grsws := computeScore(grs)
	printResult(grsws)
}
