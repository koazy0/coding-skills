---
name: api-doc-style
description: API documentation annotation style for Go Swagger. Use when adding or modifying API endpoints, handler structs, or swagger comments.
---

# Swagger Auto Generator

## Principles
- Documentation is code. If the endpoint changes, the comment changes.
- Examples must be realistic, not placeholder empty strings.
- Host / Base URL is injected at runtime (env/config), never hardcoded in annotations.

## Annotation Rules
- Every public handler needs `@Summary`, `@Tags`, `@Router`
- Request/response structs need `example` tags
- Arrays return `[]T{}` or `make([]T, 0)`, never nil
- Recursive structs show 2-3 levels max, use `[...]` for deeper

## Workflow
1. `which swag || go install github.com/swaggo/swag/cmd/swag@latest`
2. `swag init --parseDependency --parseInternal --parseDepth 3`
3. Verify `docs/swagger.json` exists and is valid
