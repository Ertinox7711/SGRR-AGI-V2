<div align="center">

<img src="assets/banner.svg" alt="SGRR AGI V2 — Claude Code scaffold" width="100%" />

# SGRR AGI V2 — the Claude Code power-rig

**Turn a fresh Claude Code install into an autonomous, proactive, "AGI"-grade agent. In a single prompt.**

Config (`settings.json`), behavioral philosophy (`CLAUDE.md`), context-injection
hooks, a memory system, a plugin/skill manifest — **and** a security pipeline that
lets you share your setup publicly **without leaking a single piece of personal data**.

![License](https://img.shields.io/badge/license-MIT-22d3ee)
![Claude Code](https://img.shields.io/badge/Claude_Code-ready-818cf8)
![Setup](https://img.shields.io/badge/setup-1_prompt-a78bfa)
![Secrets](https://img.shields.io/badge/secrets-0_included-2ea043)
![Self-improving](https://img.shields.io/badge/self--improving-yes-ef4444)
![Parity](https://img.shields.io/badge/parity-self--test-eab308)
![Pitfalls](https://img.shields.io/badge/pitfalls-13_encoded-f97316)

<sub>🏗️ Designed by **SGRR** · `Claude Code` · `Anthropic` · `AI agent` · `scaffold` · `dotfiles` · `hooks` · `skills` · `subagents` · `MCP` · `memory` · `template`</sub>

### ⭐ If this rig saves you time, drop a star — it helps push it to N°1.

[![GitHub stars](https://img.shields.io/github/stars/Ertinox7711/SGRR-AGI-V2?style=social)](https://github.com/Ertinox7711/SGRR-AGI-V2/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/Ertinox7711/SGRR-AGI-V2?style=social)](https://github.com/Ertinox7711/SGRR-AGI-V2/network/members)

</div>

---

## 🧠 What is it?

A **recipe**, not a **brain**.

The intelligence is Claude (Opus) + the model's orchestration. This repo duplicates
the **scaffold** around it: the settings, the behavioral instructions, the memory
architecture, and the list of *which* plugins/skills to install and *from where*.
You keep your own Claude Code subscription, and you bring your own secrets.

> Someone clones this repo → runs **a single prompt** → they get **exactly the same
> rig I run** (1:1 capability, proven by a parity self-test), without any of my secrets
> or my private projects.

**👉 We benchmark against the whole field (and shut it down) in [`COMPARISON.md`](COMPARISON.md).**

---

## 🚀 Raw performance — what actually makes it fast

No fluff. The concrete levers that make this rig outrun a default Claude Code, in raw terms:

- **~5× cheaper sub-agents.** The main loop stays on **Opus** (max reasoning); every
  sub-agent (explorer, reviewer, translator…) runs on **Sonnet** via
  `CLAUDE_CODE_SUBAGENT_MODEL`. You pay Sonnet for grunt-work, Opus for decisions.
  On a large codebase that's the difference between burning your quota and barely feeling it.
- **Parallelism is a reflex, not an afterthought.** `CLAUDE.md` forces independent tool
  calls into a **single message** — 5 reads at once instead of 5 round-trips. Same for
  sub-agents: independent work is dispatched together.
- **Lazy `paths:` rules instead of one bloated `CLAUDE.md`.** Per-project context loads
  **only** when you touch that project. 20 projects, zero overhead on a session that
  doesn't touch them. The context stays sharp, so the model stays fast.
- **Discipline enforced by hooks, not hope.** A `UserPromptSubmit` hook re-injects the
  rules (atomic commits, `tsc` before commit, verify-before-done) **every turn** — the
  model can't drift. No re-explaining, no wasted turns.
- **The `ask` net is real enforcement.** `permissions.ask` intercepts every destructive
  command *before* it runs, while file edits flow through `acceptEdits` with zero friction.
  Maximum speed on safe work, a hard stop on dangerous work.
- **It self-improves.** Two `SessionStart` hooks keep the rig current: one watches for
  new Claude Code releases, the other nudges you to run **`/rig-audit`** (below). The
  setup never goes stale — it gets *better* the longer you run it.

Full mechanics, with the traps 95% of people miss → **[`HOW-IT-WORKS.md`](HOW-IT-WORKS.md)**.

---

## ⚡ 1-prompt install

The single most important thing in the repo: **you paste one prompt, it installs everything.**

1. Open Claude Code in the cloned folder.
2. Copy-paste the contents of **[`INSTALLER-PROMPT.md`](INSTALLER-PROMPT.md)**.
3. Claude adds the marketplaces, enables the plugins, writes `settings.json` and
   `CLAUDE.md`, creates the memory and the rules, installs the guide locally, then runs
   a **parity self-test**. **Done.**

> Prefer a script? `./install.ps1` (Windows) or `./install.sh` (macOS/Linux) handle the
> file part. Details in **[`SETUP.md`](SETUP.md)**.

---

## 📦 What's inside

| File | Role |
|------|------|
| **[`INSTALLER-PROMPT.md`](INSTALLER-PROMPT.md)** | The single prompt that installs the whole rig. |
| **[`settings.template.json`](settings.template.json)** | Ready `settings.json` (Windows): permission net (`allow`/`ask`/`deny`), cheap sub-agents (Sonnet), injection hooks (**tips every turn**). **Zero secrets.** |
| **[`settings.template.unix.json`](settings.template.unix.json)** | Same thing, `sh` hooks for macOS/Linux. |
| **[`CLAUDE.md`](CLAUDE.md)** | The "proactive AGI" philosophy — depersonalized, with the SGRR signature. |
| **[`USAGE.md`](USAGE.md)** | **Practical guide** to using the rig well — copied locally (`~/.claude/SGRR-GUIDE.md`) at install. |
| **[`PITFALLS.md`](PITFALLS.md)** | **13 hard-won traps** the rig refuses to repeat — each a universal rule, surfaced *live* by a `PreToolUse` hook the moment a risky command matches. |
| **[`COMPARISON.md`](COMPARISON.md)** | The benchmark against the biggest Claude Code repos on GitHub. |
| **[`HOW-IT-WORKS.md`](HOW-IT-WORKS.md)** | The back of the machine: how each piece works, and why. |
| **[`SECURITY.md`](SECURITY.md)** | Security model + threat model ("people will dig for your info"). |
| **[`SETUP.md`](SETUP.md)** | Manual install manifest, plugin by plugin. |
| **[`memory/MEMORY.md`](memory/MEMORY.md)** | Template for the persistent memory system. |
| **[`rules/example-project.md`](rules/example-project.md)** | Example `paths:` rule that loads lazily (light context). |
| **[`commands/rig-audit.md`](commands/rig-audit.md)** | The **`/rig-audit`** command: analyzes all your sessions + project folders and proposes concrete upgrades to the rig. **Report-only.** |
| **[`commands/session-check.md`](commands/session-check.md)** + **[`skills/session-check/SKILL.md`](skills/session-check/SKILL.md)** | The **`/session-check`** command **and** auto-firing skill: a GO/NO-GO readiness verdict — confirms you're in the right repo/dir **and** the rig + superpowers + skills are **loaded this session**, not just installed on disk. |
| **[`install.ps1`](install.ps1)** / **[`install.sh`](install.sh)** | File installers (no Claude), with auto-backup. |
| `scripts/verify-install.*` | **Parity self-test**: proves your install = the original rig. |
| `scripts/check-cc-updates.*` | **Claude Code update watch**: a `SessionStart` hook that spots every new version, tells you, and proposes adoptions — one half of the **self-improvement loop**. |
| `scripts/rig-audit-nudge.*` | Periodic `SessionStart` nudge (every 7 days) reminding you to run `/rig-audit` — the other half of the loop. |
| `scripts/pitfall-tips.*` | `PreToolUse` coach: matches a command against known traps and injects the matching **PITFALLS** lesson before it runs (advice only). |
| `scripts/preflight-scrub.*` | Anti-leak audit of the whole repo, to run before a push. |
| `scripts/hooks/pre-commit` | Local barrier: rejects a commit that contains a secret/PII. |
| `.gitleaks.toml` · `.github/workflows/secret-scan.yml` | **Automatic secret scan on every push** (continuous defense). |

---

## 💾 How the memory works

Files, not a database. The whole point is that it's **versionable, human-readable,
hand-editable, and dependency-free**.

- **`~/.claude/memory/` holds one file per fact**, plus a `MEMORY.md` **index** that's
  loaded into context at **every session**. The index is one line per memory — never the
  content — so it stays cheap to load.
- **Each memory file has frontmatter**: `name` (kebab-case slug), `description` (the
  one-liner used to judge relevance at recall time), and `metadata.type`.
- **Four types**, each with a clear job:
  `user` (who you are), `feedback` (how you want the agent to work — with the *why*),
  `project` (facts not derivable from code or git), `reference` (URLs, dashboards, tickets).
- **Hooks drive it both ways.** `SessionStart` reminds Claude to **read** `MEMORY.md`;
  `PreCompact` reminds it to **write** durable facts before the context is compressed and lost.
- **The golden rule: save only the non-derivable.** Never store what the repo already
  knows (code structure, git log, conventions). One fact per file, and only if it can't
  be re-derived. That discipline is what keeps the signal from drowning in noise.

Deep dive → **[`HOW-IT-WORKS.md`](HOW-IT-WORKS.md)** (section 3).

---

## 🏗️ Architecture

<div align="center">
<img src="assets/architecture.svg" alt="SGRR AGI V2 architecture — model, foundations, skill triggering" width="92%" />
</div>

The canonical pattern: **Command → Agent → Skill** — but with a nuance most people miss.

- **Command** = entry point / orchestrator (`/my-command`).
- **Agent (sub-agent)** = specialist with a restricted toolset, isolated context.
- **Skill** = reusable knowledge/procedure injected into context.

> ⚠️ **A skill doesn't only fire through a command.** Claude **auto-invokes** the relevant
> skill the moment it applies — **even with no command at all**. The command is the explicit
> path; auto-invocation is the default path. The diagram above shows **both**.

It all sits on 6 foundations: `settings.json` (the only law actually enforced),
**hooks** (context injection + tips per turn + **self-improvement** watchers),
**memory** (persistent files),
**MCP** (live docs, browser), **plugins**, **rules** (lazy context). Full detail
→ **[`HOW-IT-WORKS.md`](HOW-IT-WORKS.md)**.

---

## 🔄 A rig that improves itself

Most setups freeze the day you write them and rot from there. This one has a built-in
self-improvement loop, in two halves:

- **Update watch** (`scripts/check-cc-updates.*`) — a `SessionStart` hook (throttled to
  one network call / 12h) that detects every new Claude Code release, has you read the
  changelog, and **proposes** what the rig should adopt. Never more than one version behind.
- **`/rig-audit`** (`commands/rig-audit.md`) — on demand, it analyzes **all your sessions
  and project folders**, cross-references them against what the rig currently provides, and
  outputs a **prioritized proposal** of upgrades (missing rules, memory to persist, commands
  worth creating, settings drift, hook opportunities). It's **report-only** — it changes
  nothing until you pick the items. A `SessionStart` nudge (`scripts/rig-audit-nudge.*`,
  every 7 days) reminds you it exists. **No personal data ever leaves your machine.**

---

## 🧨 A rig that learns from mistakes

A self-improving rig isn't only about *new* features — it's about never re-paying for
*old* mistakes. **[`PITFALLS.md`](PITFALLS.md)** is the institutional memory of a
power-user: **13 traps** (mock drift, blind commits, secret leaks, the `--no-verify`
bypass, destructive ops with no backup, prompt-injection via config…), each generalized
to a universal rule — **symptom → rule → cheap check**.

They don't sit in a file you'll forget. A **`PreToolUse` hook** (`scripts/pitfall-tips.*`)
watches what you're about to run and **injects the matching lesson before the command
executes** — destructive matches every time, coaching tips throttled so they nudge without
nagging. The hook only ever *advises*; blocking stays the job of `permissions.ask`. The
condensed list also rides in `CLAUDE.md`, loaded every session.

---

## 🔒 Security & privacy

This repo is built to **withstand someone trying to extract info about its owner**:

- **0 secrets** — no token, API key, or credential. `.gitignore` hard-blocks secret shapes (`shpat_*`, `sk-*`, `*.env`, `.credentials.json`…).
- **0 personal data** — no email, no real name, no paths, no project/business names. Everything is a `<PLACEHOLDER>`.
- **Active defense** — a GitHub Actions workflow scans for secrets on **every push**, and a `preflight` script + a `pre-commit` hook block leaks before the commit even happens.
- **Anonymized commit author** — no real email address anywhere in the git history.

Full threat model, guarantees, and checklist → **[`SECURITY.md`](SECURITY.md)**.

---

## ✅ Included (1:1) vs ❌ Excluded (private projects)

**Included — a faithful copy of the capability:** the config, the permissions, the generic
hooks, the `CLAUDE.md` philosophy, the memory architecture, every **public plugin**, and the
**public skill** manifest. A friend who installs it gets the same rig — and the **parity
self-test** (`scripts/verify-install.*`) proves it.

**Excluded — for your protection:** all secrets, and every skill/instruction specific to
private projects (business, personal automations, personas). None of it is listed or
referenced here.

---

## 🏗️ Origin & credit

This rig — the config, the hooks, the philosophy, the memory architecture, the
Command→Agent→Skill pattern — was **designed and assembled by [SGRR](https://github.com/Ertinox7711)**.
Once installed, your Claude **knows** it runs on the **SGRR AGI V2** and applies its method:
*anticipate, verify, execute*. You hold a faithful replica of the original rig.

Licensed under **MIT** — use it, modify it, share it. Credit is always appreciated, and a
⭐ even more.

<div align="center">
<sub>Built with Claude Code · designed by <b>SGRR</b> · <code>SGRR AGI V2</code></sub>
<br/>
<sub><code>claude-code</code> · <code>anthropic</code> · <code>ai-agent</code> · <code>llm</code> · <code>scaffold</code> · <code>config</code> · <code>dotfiles</code> · <code>hooks</code> · <code>skills</code> · <code>subagents</code> · <code>mcp</code> · <code>memory</code> · <code>productivity</code> · <code>developer-tools</code></sub>
</div>
