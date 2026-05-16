---
name: project-init
description: Initialize new projects from a scaffold template. Use when creating a new service, module, or repository from an existing scaffold.
---

# Project Scaffold

## Principles
- Copy from scaffold, don't create from scratch.
- Rename everything consistently: project name, package path, module name.
- Verify it compiles before declaring done.

## Workflow
1. Copy scaffold directory to new project location
2. Replace all occurrences of the old project name/package with the new one
3. Run `go mod init <new-module>` and tidy dependencies
4. Verify `go build` passes
5. Remove scaffold-specific artifacts (example data, demo configs)

## Rename Checklist
- `go.mod` module path
- Package imports across all `.go` files
- Config defaults referencing project name
- **Makefile** targets, binary names, and build flags
- Docker image names / compose service names
- README title and usage examples

## Defaults
- SQLite for dev, PostgreSQL for prod (already wired in scaffold)
- No test files unless explicitly requested
- No extra Markdown summaries
