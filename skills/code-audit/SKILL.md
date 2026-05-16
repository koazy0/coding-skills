---
name: code-audit
description: Code audit discipline. Use when reviewing diffs, PRs, or asked to check code quality, security, or performance.
---

# Code Review

## Principles
- Review only what changed. Don't critique unrelated code.
- Every finding must include a specific fix suggestion, not just complaints.
- Performance claims must be quantified, not based on intuition.

## Checklist
1. **Correctness** - Does the change solve the stated problem?
2. **Scope** - Are there unrelated modifications mixed in?
3. **Simplicity** - Can it be simpler? Would a senior engineer call this overcomplicated?
4. **Tests** - Is new logic covered by tests?
5. **Security** - Is user input validated? Are secrets logged?

## Output Format
- `[Severity]` `file:line` - Problem → Suggested fix
- Severities: `[Block]` `[Warn]` `[Style]`
