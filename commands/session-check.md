---
description: GO / NO-GO session readiness check - confirms you're in the right repo/dir AND the SGRR AGI V2 rig + superpowers skills are actually LOADED this session (not merely installed on disk).
argument-hint: "(no args - run it whenever you want to be sure you're not working in the void)"
allowed-tools: Read, Grep, Glob, Bash
---

You are running the **SGRR AGI V2 session-check** - a fast GO / NO-GO readiness verdict.
The user wants certainty on two things before they trust this session:

1. **Right place** - they are in the repo / directory they think they are ("le bon rep").
2. **Not in the void** - the rig + superpowers + skills are genuinely **loaded in THIS
   session**, not just sitting installed on disk.

Run the three groups below, then print the verdict. Be terse. Read real state - never assume.

### A. Location - "am I in the right repo?"
Use the shell for the current OS (PowerShell on Windows, bash on macOS/Linux):
- **cwd** - print the current working directory.
- **git root** - `git rev-parse --show-toplevel`. If it errors, this folder is not a git
  repo: fine for a scratchpad, a red flag if the user expected to be inside a project.
- **remote** - `git remote -v` - show the origin URL so the user can confirm it really is
  the project they meant (not a same-named look-alike or a stale clone).
- **branch + state** - `git status -sb` - current branch, ahead/behind, clean vs dirty.
- **void check** - if there is NO git root AND cwd is a generic dump folder (home root,
  Downloads, Desktop, Documents) with no project marker (`.git`, `package.json`,
  `pyproject.toml`, `go.mod`, `Cargo.toml`), flag it: that is the classic "working in
  the void" signal - the user is probably not where they think they are.

### B. Rig loaded - "is my Claude actually souped-up right now?"
Read the live config under `~/.claude` (Windows: `$env:USERPROFILE\.claude`):
- **CLAUDE.md** present AND carries the rig signature - grep `SGRR AGI V2`, or the
  `anticipate, verify, execute` philosophy line. No signature = a default Claude.
- **model** = `opus` in settings.json (max intelligence on the main loop).
- **sub-agents** = `sonnet` (`env.CLAUDE_CODE_SUBAGENT_MODEL`) - cheap grunt-work.
- **context hooks** - settings.hooks defines UserPromptSubmit / SessionStart / PreCompact /
  Stop, plus the **PreToolUse pitfall coach** (a hook whose command names `pitfall-tips`).
- **superpowers** - `enabledPlugins` has `superpowers@claude-plugins-official` set to true.
  Report the total count of enabled plugins too (>= 12 expected).
- **memory + pitfalls** - the memory index present at EITHER `~/.claude/memory/MEMORY.md`
  OR a project-scoped `~/.claude/projects/<encoded-cwd>/memory/MEMORY.md` (Claude Code stores
  memory globally or per-project - accept either, only flag if BOTH are missing), and
  `PITFALLS.md` present.

### C. Live proof - "are skills actually firing for ME, right now?"
This is the part disk checks cannot prove. Attest from your OWN session context, honestly:
- Is the **Skill tool** available to you right now?
- Did **superpowers / using-superpowers** load this session (you would have seen the
  "you have superpowers" preamble and the >1%-invoke rule)?
- Both yes -> skills are LIVE. If you cannot see them -> say so plainly: the plugin is
  installed but **not active in this session** (usually fixed by restarting Claude Code).

### Verdict
End with exactly ONE of:
- **GO** - a single line:
  `GO - repo <name> | <branch> (<clean|dirty>) | rig active | superpowers ON | <N> plugins | coach wired | skills live`.
- **NO-GO** - list ONLY the failing items, each with a one-line fix. Nothing that passed.

Keep the whole thing tight - a scan, not an essay.
