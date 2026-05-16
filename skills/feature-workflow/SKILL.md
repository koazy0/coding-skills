---
name: feature-workflow
description: Feature development workflow. Use when starting a new feature, writing tests, running tests, or merging code.
---

# Dev Workflow

## Principles
- One feature, one branch.
- No code without tests.
- Linear history via rebase.

## Feature Workflow
1. Pull latest main, create branch: `feat-<feature-name>`
2. Write tests first (TDD). Red → Green → Refactor.
3. Implement feature. Keep commits atomic.
4. Run full test suite locally. All green before merge.
5. Rebase onto latest main: `git rebase main`
6. Fast-forward merge to main. Delete branch.

## Rules
- Never commit directly to main.
- Never merge with merge commits. Rebase only.
- Tests must cover happy path + edge cases + error handling.
- If tests fail after rebase, fix before merging.
