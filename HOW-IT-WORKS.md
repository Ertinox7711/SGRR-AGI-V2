# 🧠 How It Works — the full picture

This document explains **how each piece works**, **why it's there**, and —
at the bottom — **the things nobody thinks about** that account for 80% of the
difference between a "normal" Claude Code and an agent that behaves like an AGI.

> TL;DR: the intelligence is Claude (the model). This repo is the **scaffold**
> that decides *how* that intelligence is framed, fed context, and
> protected. A recipe, not a brain.

---

## 0. The mental map

```
            ┌─────────────────────────────────────────────┐
            │                  CLAUDE (Opus)               │  ← the intelligence
            └─────────────────────────────────────────────┘
                                │ orchestrated by ↓
   ┌──────────┬──────────┬──────────┬──────────┬──────────┬──────────┐
   │ settings │  hooks   │ memory   │   MCP    │ plugins  │  rules   │  ← the scaffold (this repo)
   │ permis-  │ context  │ durable  │ docs/web │ skills + │ lazy     │
   │ sions    │ per turn │ files    │ live     │ agents   │ context  │
   └──────────┴──────────┴──────────┴──────────┴──────────┴──────────┘
                                │ produces ↓
            Command  →  Agent (sub-agent)  →  Skill
            (entry)     (isolated specialist)  (reusable knowledge)
```

---

## 1. `settings.json` — the only thing that's *actually* enforced

The most important distinction in the entire setup:

> **Prose in `CLAUDE.md` is a suggestion. `settings.json` is law.**

`CLAUDE.md` says "confirm before `rm -rf`". But that's text — the model can
miss it under pressure. `settings.json` `permissions.ask` *intercepts the command
before execution* and asks you. It's the only truly binding safety net.

Our template does 3 things:

1. **Permission net** — broad `allow` (so trivial work doesn't spam prompts),
   but an explicit `ask` gate on **every** destructive command:
   `rm`, `rmdir`, `shred`, `dd`, `mkfs`, `fdisk`, `chmod`, `chown`, `kill`, `pkill`,
   `git push --force`, `git reset --hard`, `git clean`, `npm publish`, `docker`,
   `kubectl`, `gcloud`, `firebase`. `deny` is empty by default (add hard bans as needed).

2. **Cheap sub-agents** — `env.CLAUDE_CODE_SUBAGENT_MODEL: "sonnet"`. The main loop
   stays on Opus (max intelligence), but when a sub-agent launches
   (explorer, reviewer…), it runs on Sonnet. You pay Sonnet for grunt-work,
   Opus for reasoning. Massive savings on large projects.

3. **`defaultMode: acceptEdits`** — file edits go through without confirmation
   (reversible, local), while dangerous commands stay gated by `ask`. The right
   speed/safety balance.

## 2. Hooks — per-turn context injection

Hooks run a command at key moments and **inject their output into Claude's
context**. We use them as automatic reminder injections:

| Hook | When | What it injects |
|------|------|-----------------|
| `SessionStart` | session start | "Read MEMORY.md. Anticipate, parallelize, verify before saying done." |
| `SessionStart` (update watcher) | session start, **throttled 12h** | detects a **new Claude Code version** and tells you to read the changelog + propose adoptions to the rig. |
| `UserPromptSubmit` | every message | "Before a client/ commit: `npx tsc --noEmit`. Atomic commits. Verify before done." |
| `PreCompact` | before context compression | "Save durable facts to memory before losing context." |
| `Stop` | end of turn | "If code changed: tests passing? tsc clean? nothing uncommitted?" |
| `PreToolUse` (pitfall coach) | before a Bash command runs | matches the command against known traps and injects the relevant **PITFALLS** lesson *before* it executes — advice only, never auto-allow/block. |

This is what maintains discipline **without you having to repeat it**. Model
drifts? The hook re-injects it, every turn. The Windows version uses PowerShell;
the `settings.template.unix.json` variant uses `echo`.

> 🔄 **The self-improvement loop.** The 2nd `SessionStart` hook (`scripts/check-cc-updates.*`)
> compares the latest published Claude Code version to the one it already flagged for you. The
> moment a new version ships, it injects an instruction: *go read the changelog, notify me, propose
> what to adopt*. The rig keeps itself current — it never goes stale. Network call capped at
> once per 12h, fails silently, **zero personal data**, cache at `~/.claude/.cc-update-cache.json`.

## 3. Memory — files, not a database

`~/.claude/memory/` holds one file per fact, plus a `MEMORY.md` index loaded at
every session. Each file has frontmatter (`name`, `description`, `type`).

Why files: versionable, human-readable, hand-editable, zero dependencies.
The `SessionStart` hook reminds Claude to read it; `PreCompact` reminds it to write
before losing context. Types: `user` (who you are), `feedback` (how to work),
`project` (facts not derivable from code), `reference` (URLs/dashboards).

Golden rule: **never save what the repo already knows** (code structure,
git log, conventions). Memory is for the non-derivable.

## 4. MCP — the agent's senses

MCP servers give Claude capabilities beyond the model itself:
- **context7** → library docs that are **up to date** (not the model's frozen knowledge).
- **playwright** → drive a real browser (test a UI, scrape DOM).

Key reflex encoded in `CLAUDE.md`: on a **403 / bot-block**, don't fiddle with
headers — switch to **Scrapling** (stealth fetch). This is one of those
"global-level" settings that solves 90% of scraping headaches in one shot.

## 5. Plugins — packaged skills + sub-agents

A plugin brings skills, slash commands, sometimes MCP servers. The foundation:
- **superpowers** → the skills system (brainstorming, TDD, debugging, planning).
  The backbone; almost everything depends on it.
- **feature-dev** → architect / explorer / reviewer sub-agents.
- **code-review**, **pr-review-toolkit** → multi-agent diff and PR review.
- **frontend-design** → non-generic UI work.
- **commit-commands**, **github** → git/GitHub workflow.
- **context7**, **playwright**, **typescript-lsp** → live docs, browser, TS LSP.
- **caveman** → terse output mode (optional, cosmetic).

## 6. Rules — context that only loads when needed

A rule in `~/.claude/rules/*.md` with a `paths:` frontmatter loads
**only** when Claude touches a file matching the glob. Unlike
`CLAUDE.md` (loaded every session), a rule costs nothing unless you're in
the right project.

This is THE thing that scales: 20 projects each with their own autonomy rules,
without adding a single byte of overhead to a session that doesn't touch them.

## 7. The canonical pattern: Command → Agent → Skill

- **Command** (`/my-command`) = entry point, lightweight orchestrator.
- **Agent (sub-agent)** = specialist with a restricted toolset and an **isolated context** —
  does its job without polluting your main context, returns just its conclusion.
- **Skill** = reusable knowledge/procedure, injected into context on demand.

The composition: a command dispatches one or more agents; each agent invokes
the relevant skills. Context isolation + specialization + reuse.

> 🟢 **Installed ≠ loaded.** The one trap this pattern hides: a plugin can sit installed
> on disk while being inactive in *your current session*. `/session-check` (a rig command
> **and** an auto-firing skill) gives a GO/NO-GO verdict — right repo/dir, rig config
> present, superpowers enabled, and skills genuinely live *this* session. That last part
> is the thing no disk check can tell you; the agent attests it from its own context.

---

## 🎁 The things nobody thinks about

The ones that make the real difference — and that 95% of people miss:

1. **`CLAUDE_CODE_SUBAGENT_MODEL: sonnet` = cut the bill by ~5×** on large
   projects, without sacrificing reasoning quality (Opus stays on the decision loop).
   Most people leave everything on Opus and burn through their quota.

2. **The `ask` net, not the prose.** Writing "be careful" in CLAUDE.md protects
   nothing. The only real safeguard is `permissions.ask`. Put your destructive
   commands there, full stop.

3. **Hooks beat memory for discipline.** You can write "atomic commits" 10 times
   in CLAUDE.md — the model will drift. A `UserPromptSubmit` hook re-injects it
   *every turn*. That's what holds.

4. **Parallelize independent tool calls.** One message with 5 independent tool calls
   = 5× faster than 5 messages. Encoded in CLAUDE.md as a reflex.

5. **`paths:` rules > one big CLAUDE.md.** Piling everything into CLAUDE.md
   pollutes every session's context. Per-project lazy context keeps the agent sharp.

6. **Memory = non-derivable only.** Saving things the code/git already knows
   is noise that drowns the real facts. Discipline: one fact per file, and
   only if it can't be re-derived.

7. **The 403 → Scrapling reflex.** One global setting that turns "scraping is broken"
   into "scraping works". Before fiddling with headers: stealth fetch.

8. **Backup before touching anything.** The installer makes `.bak-<date>` copies before it
   **smart-merges** your `settings.json` (unions the rig in, keeps your keys) or overwrites
   `CLAUDE.md`. Never destroy a config without a backup — obvious once you've been burned once.

9. **`effortLevel: medium` is a dial.** Crank it up for deep reasoning, dial it down
   for throughput. Most people don't know it exists.

10. **Security of *sharing* your setup.** The invisible trap: your setup contains your
    secrets, your email (right down to the git commit author!), your paths, your project
    names. Sharing the rig without scrubbing it is a data leak. This entire repo is
    built to share the **capability** without the **personal data** → [`SECURITY.md`](SECURITY.md).

11. **A rig that updates itself.** Claude Code moves fast (multiple versions per week).
    A frozen setup misses new features — new `settings.json` settings,
    new hook events, new capabilities. The **update watcher** (`scripts/check-cc-updates.*`,
    `SessionStart` hook) detects every release and has you *propose* adoptions. The rig
    is never more than one version behind — it self-improves instead of going stale.

12. **It learns from mistakes, not just features.** Chasing *new* capabilities is half
    the game; the other half is never re-paying for *old* mistakes. `PITFALLS.md` encodes
    13 hard-won traps, and a `PreToolUse` hook (`scripts/pitfall-tips.*`) surfaces the
    matching lesson the instant you're about to repeat one — advice only, throttled for
    coaching tips, every-time for destructive ones. Avoiding a known trap beats adding a feature.

---

Logical next steps: [`SECURITY.md`](SECURITY.md) (threat model + guarantees), then
[`INSTALLER-PROMPT.md`](INSTALLER-PROMPT.md) (the one-shot prompt) or [`SETUP.md`](SETUP.md)
(manual install).
