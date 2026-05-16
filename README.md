# Coding Skills

> One-line install. Multi-platform AI coding discipline. Zero configuration.

A curated collection of **minimalist, battle-tested coding skills** for AI coding agents. Inspired by Andrej Karpathy's viral 110k⭐ coding guidelines.

Compatible with **Claude Code**, **Kimi Code CLI**, **OpenAI Codex**, and **CodeBuddy**.

---

## ✨ What It Does

Tired of AI over-engineering your code, refactoring unrelated files, or writing bloated abstractions? These skills enforce **coding discipline** at the agent level:

- **Think Before Coding** — No silent assumptions. Surface tradeoffs.
- **Simplicity First** — No speculative features. No single-use abstractions.
- **Surgical Changes** — Touch only what you must. Every line traces to the request.
- **Goal-Driven Execution** — Tests first. Verify before claiming "done".

---

## 🚀 One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/koazy0/coding-skills/main/install.sh | bash
```

Or clone and run locally:

```bash
git clone https://github.com/koazy0/coding-skills.git
cd coding-skills
bash install.sh
```

**That's it.** The installer auto-detects your AI coding tools and installs all skills in one shot.

### What Gets Installed

| Platform | Global Path |
|----------|-------------|
| Claude Code | `~/.claude/skills/` |
| Kimi Code CLI | `~/.kimi/skills/` |
| OpenAI Codex | `~/.codex/skills/` |
| CodeBuddy | `~/.codebuddy/skills/` |

---

## 📦 Skills Included

| Skill | Trigger | Purpose |
|-------|---------|---------|
| `karpathy-style` | Writing / reviewing / refactoring code | Minimalist discipline. Prevents overengineering. |
| `code-audit` | Code review, PRs, diffs | Audit for correctness, scope, simplicity, security. |
| `commit-style` | Git commits, branches, merges | `[feat]` prefix convention, linear history via rebase. |
| `feature-workflow` | New features, tests, merges | TDD workflow: branch → test → implement → rebase → merge. |
| `project-init` | Creating new projects | Scaffold new projects from a template with global rename. |
| `api-doc-style` | API endpoints, handlers | Go Swagger annotation rules. No hardcoded hosts. No nil arrays. |

Each skill is **under 30 lines**. No bloat. No filler. Just rules that work.

---

## 🎯 Why Minimalist?

> *"Every token a skill spends is one the agent can't use on your code."*

These skills follow the same philosophy that made [Karpathy's CLAUDE.md](https://github.com/forrestchang/andrej-karpathy-skills) hit #1 on GitHub Trending:

- **Under 1K tokens** per skill
- **Actions, not explanations** — Tell the agent what to do, not what things are
- **Every "don't" has a "do instead"** — Bare prohibitions leave the agent guessing
- **One good default per decision** — A single best practice beats a menu of options

---

## 🛠 Project-Level Baseline

Drop `CLAUDE.md` into your project root for an additional layer of discipline:

```bash
cp CLAUDE.md /path/to/your-project/CLAUDE.md
```

This gives your AI agent **universal coding guidelines** before any skill-specific rules kick in.

---

## 📂 Structure

```
.
├── install.sh              # Auto-detect + install to all platforms
├── CLAUDE.md               # Project-level coding baseline
└── skills/
    ├── karpathy-style/     # Minimalist coding discipline
    ├── code-audit/         # Code review rules
    ├── commit-style/       # Git commit & branch conventions
    ├── feature-workflow/   # TDD feature development flow
    ├── project-init/       # Scaffold from template
    └── api-doc-style/      # Go Swagger documentation rules
```

---

## 📝 License

MIT

---

If this improves your AI workflow, ⭐ star it!
