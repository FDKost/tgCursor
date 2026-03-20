---
name: commit
description: Create a clean atomic git commit for current changes
---

Create a git commit for the current repository.

Steps:

1. Run the following commands to inspect the repository state:
   - `git status`
   - `git diff HEAD`
   - `git status --porcelain`

2. Determine which files were:
   - added
   - modified
   - deleted

3. Stage all relevant files:
   - new files
   - modified files

4. Generate an **atomic commit message** using conventional commits.

Allowed prefixes:
- feat: new feature
- fix: bug fix
- refactor: code change without behavior change
- docs: documentation
- style: formatting / lint changes
- test: adding or updating tests
- chore: maintenance tasks

5. Commit using:

`git add -A`
`git commit -m "<type>: <short clear description>"`

Rules for the commit message:
- lowercase
- max 72 characters
- describe WHAT changed, not HOW
- one logical change per commit

If multiple unrelated changes exist, suggest splitting into multiple commits.