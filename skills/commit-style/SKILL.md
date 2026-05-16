---
name: commit-style
description: Commit message and branch naming style guide. Use when writing commits, creating branches, or preparing to merge.
---

# Git Helper

## Commit Messages
- Format: `[type] description` — e.g. `[feat] add user login`, `[fix] resolve nil pointer`
- Types: `[feat]`, `[fix]`, `[refactor]`, `[docs]`, `[test]`, `[chore]`
- Keep subject under 72 chars
- Body explains **why** and **what**

## Branches
- Prefix: `feat-`, `fix-`, `refactor-`, `docs-`
- Delete after merge
- Clean up local branches older than 2 weeks

## Safety Rules
- Run `git diff --staged` before every commit
- Never force-push to shared branches
- Rebase before merging, keep history linear
- `git reflog` to recover lost commits
