---
name: session-check
description: Use when the user wants to confirm their Claude session is correctly set up before trusting it - e.g. "am I in the right repo?", "is the rig loaded?", "am I set up right?", "am I working in the void?", "are my skills / superpowers active?", or any doubt that this session is wired to the SGRR AGI V2 rig. Produces a GO / NO-GO readiness verdict.
---

# Session-Check - GO / NO-GO readiness verdict

The user doubts their session is correctly wired. Give them certainty on two fronts:

1. **Right place** - they are in the repo / directory they intend ("le bon rep").
2. **Not in the void** - the rig + superpowers + skills are LOADED in THIS session,
   not merely installed on disk.

This mirrors the `/session-check` command. Run all three groups, then print the verdict.
Be terse, read real state, never assume.

## A. Location
Shell for the OS (PowerShell on Windows, bash elsewhere):
- cwd; `git rev-parse --show-toplevel`; `git remote -v`; `git status -sb`.
- No git root AND a generic dump cwd (home / Downloads / Desktop / Documents, no project
  marker like `.git` / `package.json` / `pyproject.toml` / `go.mod` / `Cargo.toml`)
  -> flag "working in the void".

## B. Rig loaded (read ~/.claude)
- CLAUDE.md present + rig signature (`SGRR AGI V2` / `anticipate, verify, execute`).
- settings.json: model=opus, env.CLAUDE_CODE_SUBAGENT_MODEL=sonnet.
- hooks: UserPromptSubmit / SessionStart / PreCompact / Stop + PreToolUse `pitfall-tips` coach.
- enabledPlugins has `superpowers@claude-plugins-official`=true (report plugin count, >= 12).
- memory index present at EITHER `~/.claude/memory/MEMORY.md` OR a project-scoped
  `~/.claude/projects/<encoded-cwd>/memory/MEMORY.md` (Claude Code keeps memory global
  or per-project - accept either, only flag if BOTH are absent); PITFALLS.md present.

## C. Live proof (attest from your own session - disk cannot prove this)
- Is the Skill tool available right now? Did using-superpowers load this session?
- Both yes -> skills LIVE. Cannot see them -> installed but NOT active (restart Claude Code).

## Verdict
- **GO** - one line:
  `GO - repo <name> | <branch> (clean) | rig active | superpowers ON | <N> plugins | coach wired | skills live`.
- **NO-GO** - only the failing items, each with a one-line fix.
