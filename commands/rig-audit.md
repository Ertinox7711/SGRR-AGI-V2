---
description: Analyze your real sessions + project folders and propose concrete, prioritized upgrades to the SGRR AGI V2 rig — report only, applies nothing.
argument-hint: "[optional: a focus area, e.g. 'hooks' or a project path]"
allowed-tools: Read, Glob, Grep, Bash, WebFetch
---

You are running the **SGRR AGI V2 self-audit**. Goal: study how this user actually works, compare it to what the rig currently provides, and produce a **prioritized proposal** of upgrades.

This run is **report-only**. You MUST NOT modify settings, CLAUDE.md, memory, rules, commands, hooks, or any file. Propose; let the user choose what to apply.

Optional focus from the user: **$ARGUMENTS** (if empty, audit everything).

Work through these five steps, then output the report.

### 1. Read the current rig
Read what is actually installed under the user's `~/.claude` (Windows: `$env:USERPROFILE\.claude`):
- `settings.json` — model, env, permissions, hooks, enabledPlugins, effortLevel
- `CLAUDE.md` — behavioral philosophy
- `rules/*.md` — lazy per-project rules and their `paths:`
- `memory/MEMORY.md` + memory files
- `commands/*.md` — existing slash commands
- `scripts/*` — existing hooks

Build a model of what the rig CAN do today.

### 2. Sample real usage (do NOT ingest everything)
Session transcripts live in `~/.claude/projects/<encoded-path>/*.jsonl` (one JSON object per line, files can be huge). **Sample, don't load whole files** — list the dirs, pick a handful of recent/large transcripts, read only their first and last slices. Extract signal only:
- recurring intents / task types the user asks for
- tools and skills used most (and ones never used)
- friction: repeated corrections, retries, the same thing explained twice, dead ends

**Never copy secrets, tokens, emails, or private project content into your output.** Summarize patterns, not raw data.

### 3. Scan the project folders
For each working directory (see `additionalDirectories` in settings, plus the cwd), survey:
- languages / frameworks / tooling in use
- candidate `paths:` rules that don't exist yet
- commands the user runs by hand repeatedly (build, test, deploy) that could be a slash command or a hook

### 4. Cross-reference and find the gaps
Compare step 1 against steps 2+3. Look for:
- missing **rules** — a project worked on often with no `rules/` entry
- missing **memory** — facts re-explained across sessions that should be persisted
- missing **commands** — a repeated multi-step flow worth a `/command`
- useful **skills/plugins** not enabled
- **settings drift** — permissions too tight or too loose, model/effort mismatch, a hook that never fires
- **stale references** — a rule/memory naming a file/flag that no longer exists (verify before flagging)
- new **hook opportunities** — a check the user always does by hand

### 5. Output the proposal
Structure the report exactly like this:

**🎯 Top 3 high-leverage upgrades** — the 3 changes with the best effort-to-impact ratio, each one line + why.

**📋 Full findings** — grouped by area (Rules · Memory · Commands · Skills/Plugins · Settings · Hooks · Stale refs). For each: what's missing or wrong, the evidence (which pattern or session signal), and the proposed fix.

**🛠️ Ready-to-apply patches** — for each item, the exact change (file + diff/snippet), each labeled `[apply on request]`.

End with: *"Reply with the numbers you want applied and I'll make those changes."*

Do not apply anything in this run.
