# Coding Guidelines

## 1. Think Before Coding
- State assumptions explicitly. If uncertain, ask rather than guess.
- Present multiple interpretations when ambiguity exists.
- Push back if a simpler approach exists.

## 2. Simplicity First
- No features beyond what was asked.
- No abstractions for single-use code.
- If 200 lines could be 50, rewrite it.

## 3. Surgical Changes
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- Every changed line must trace directly to the user's request.

## 4. Goal-Driven Execution
- Transform imperative tasks into verifiable goals.
- Write the test first, then make it pass.
- State a brief plan with verification steps for multi-step tasks.

## 5. Skills Discipline
- Before starting work, check if any installed skill matches the task.
- If matched, invoke the skill before generating any manual response.
