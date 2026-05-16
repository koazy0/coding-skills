# Coding Skills

<p align="center">
  <b>Minimalist AI coding discipline for Claude, Kimi, Codex & CodeBuddy</b><br>
  One-line install · Auto-detect · Zero config
</p>

<p align="center">
  <a href="#installation">⚡ Quick Install</a> ·
  <a href="#skills">📦 Skills</a> ·
  <a href="#how-it-works">🧠 How It Works</a>
</p>

---

## Why

AI coding agents are capable — but undisciplined. They over-engineer, refactor unrelated code, hide confusion, and ship "done" without verifying.

**Coding Skills** gives your agent a set of lightweight, behavior-level rules that enforce:

- **Clarity** — State assumptions, surface tradeoffs, ask when uncertain
- **Simplicity** — No speculative features, no single-use abstractions
- **Precision** — Touch only what you must, match existing style
- **Accountability** — Define verifiable goals before writing code

Inspired by [Andrej Karpathy's observations](https://twitter.com/karpathy) on LLM coding pitfalls and the community's enthusiasm for structured agent behavior.

---

## Installation

### One-liner (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/koazy0/coding-skills/main/install.sh | bash
```

### Or clone manually

```bash
git clone https://github.com/koazy0/coding-skills.git
cd coding-skills
bash install.sh
```

The installer auto-detects which AI coding tools you have and installs skills to all of them.

### Add project-level baseline

```bash
cp CLAUDE.md /path/to/your-project/CLAUDE.md
```

This gives your agent universal coding guidelines *before* any skill-specific rules kick in.

---

## Supported Platforms

| Platform | Global Path | Status |
|----------|-------------|--------|
| **Claude Code** | `~/.claude/skills/` | ✅ Supported |
| **Kimi Code CLI** | `~/.kimi/skills/` | ✅ Supported |
| **OpenAI Codex** | `~/.codex/skills/` | ✅ Supported |
| **CodeBuddy** | `~/.codebuddy/skills/` | ✅ Supported |

> Kimi Code CLI automatically merges skills from `.kimi/skills`, `.claude/skills`, and `.codex/skills` — so installing to any one of them works.

---

## Skills

Each skill is intentionally **under 30 lines**. No filler. No tutorials. Just rules that stick.

| Skill | When It Triggers | What It Enforces |
|-------|-----------------|------------------|
| `karpathy-style` | Writing, reviewing, or refactoring code | Think before coding. Simplicity first. Surgical changes only. |
| `code-audit` | Code review, PRs, diffs | Correctness, scope control, simplicity, security checks. |
| `commit-style` | Git commits, branches, merges | `[feat]` prefix, 72-char subjects, rebase-only merges. |
| `feature-workflow` | New features, tests, merges | TDD flow: branch → red test → green → rebase → merge. |
| `project-init` | Creating new projects | Scaffold from template, global rename, `go build` ready. |
| `api-doc-style` | API endpoints, Go handlers | Swagger annotations. No hardcoded hosts. No nil arrays. |

---

## How It Works

AI coding tools scan `SKILL.md` files at startup. When your request matches a skill's `description`, the full rules are loaded into context.

```
User: "review this PR"
      ↓
Agent: scans descriptions → matches "code-audit"
       ↓
Agent: loads code-audit/SKILL.md → follows audit rules
```

Because only the `description` (a single line) is loaded at startup, you can install all 6 skills and pay near-zero token cost until one fires.

---

## Project Structure

```
.
├── install.sh              # Auto-detect platforms & install
├── CLAUDE.md               # Universal coding baseline
└── skills/
    ├── karpathy-style/
    ├── code-audit/
    ├── commit-style/
    ├── feature-workflow/
    ├── project-init/
    └── api-doc-style/
```

---

## Contributing

Found a skill that doesn't trigger when it should? Open an issue.

Have a new coding discipline that fits the minimalist style? PRs welcome.

1. Fork the repo
2. Create a new skill in `skills/<your-skill>/SKILL.md`
3. Keep it under 30 lines
4. Submit a PR

---

## Acknowledgments

- **Andrej Karpathy** for his [public observations](https://twitter.com/karpathy) on LLM coding pitfalls that shaped the core principles
- The community behind [andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) (MIT License) for demonstrating the impact of concise agent instructions

---

## License

MIT
