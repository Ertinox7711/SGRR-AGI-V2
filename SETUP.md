# Setup — Manual Installation Manifest

> ⚡ **Want to do it in 1 prompt?** Open [`INSTALLER-PROMPT.md`](INSTALLER-PROMPT.md)
> and paste its contents into Claude Code. This file is the **manual** version,
> step by step, if you prefer to control everything yourself. ~15 min.

---

## 1. Plugins

Claude Code plugins are installed from marketplaces. The official one ships by default.
Add the `caveman` marketplace once:

```
/plugin marketplace add JuliusBrussee/caveman
```

Then enable these (via the `/plugin` menu, or they are pre-listed in
`settings.template.json`):

| Plugin | Marketplace | Why |
|--------|-------------|-----|
| `superpowers` | official | Skills system — brainstorming, TDD, debugging, planning workflows. The backbone. |
| `feature-dev` | official | Architect / explorer / reviewer sub-agents for feature work. |
| `code-review` | official | `/code-review` on the current diff. |
| `pr-review-toolkit` | official | Multi-agent PR review (silent-failure hunter, type-design, etc.). |
| `frontend-design` | official | Distinctive, non-generic UI generation. |
| `commit-commands` | official | `/commit`, commit-push-PR helpers. |
| `security-guidance` | official | Security-review skill + guardrails. |
| `github` | official | GitHub operations from Claude. |
| `context7` | official | Live library docs (MCP). |
| `playwright` | official | Browser automation (MCP). |
| `typescript-lsp` | official | Real TS language server (defs, refs, diagnostics). |
| `caveman` | caveman | Optional — terse "caveman" output mode + statusline. |

Optional / off by default: `skill-creator`, `claude-md-management`, `hookify`,
`pyright-lsp`, `ralph-loop`, `firebase`.

## 2. settings.json

> ⚠️ **Already have a `~/.claude/settings.json`?** The `install.ps1` / `install.sh`
> scripts **smart-merge** the rig config into it (backup first, your keys preserved,
> idempotent) — prefer them over this manual step. The raw `cp` below **overwrites**
> the file wholesale: only use it on a fresh `~/.claude`, or back up and merge your
> existing keys by hand first.

```
# Windows
cp settings.template.json  $env:USERPROFILE\.claude\settings.json
# macOS / Linux
cp settings.template.unix.json  ~/.claude/settings.json
```

Then fill in the placeholders:
- `additionalDirectories` → your extra project folders (or remove the key).
- The `hooks` block in the Windows template uses **PowerShell**. The
  `settings.template.unix.json` variant provides the `echo` equivalent for macOS/Linux.

What this settings file gives you:
- **Permission guardrails** — broad `allow`, but an `ask` gate on every destructive
  command (`rm`, `dd`, `mkfs`, `chmod`, `kill`, `git push --force`,
  `git reset --hard`, `docker`, `kubectl`, `gcloud`, `npm publish`). Prose in
  CLAUDE.md is *not* enforced; these rules *are*.
- **Cheap sub-agents** — `CLAUDE_CODE_SUBAGENT_MODEL: sonnet` runs sub-agents on
  Sonnet while you keep Opus on the main loop.
- **Context-injection hooks** — every turn reminds: run `tsc` before commit,
  save durable facts to memory, verify before saying "done".

## 3. CLAUDE.md

```
cp CLAUDE.md  ~/.claude/CLAUDE.md   # ($env:USERPROFILE on Windows)
```

Fill in the `<PLACEHOLDER>` blocks. Move project-specific autonomy rules out of
this always-loaded file and put them in `rules/*.md` with a `paths:` frontmatter
(see step 5) — this keeps your global context light.

## 4. Memory

```
mkdir ~/.claude/memory
cp memory/MEMORY.md  ~/.claude/memory/MEMORY.md
```

One fact per file, indexed by a line in `MEMORY.md`. The format is specified
in that file.

## 5. Rules (lazy context)

```
mkdir ~/.claude/rules
cp rules/example-project.md  ~/.claude/rules/
```

A rule with a `paths:` frontmatter loads **only** when Claude touches a matching
file — unlike `CLAUDE.md`, which loads every session. Use this for per-project
autonomy blocks so they don't bloat unrelated sessions.

## 6. Skills

Large skill libraries are **other people's work** — install from the source,
don't copy. Most arrive *with* the plugins above (e.g. `superpowers` brings its
skill set). For standalone skill packs, add their marketplace and enable according
to their README. Respect each pack's license.

**The one skill this rig ships itself:** `skills/session-check/SKILL.md` — the
`/session-check` readiness check (it's both a slash command and an auto-firing skill).
The installers copy it to `~/.claude/skills/session-check/`. It fires when you ask things
like "am I in the right repo?" or "is the rig actually loaded?", and returns a GO/NO-GO
verdict. It's the only skill the rig owns — everything else comes bundled with the plugins.

---

Done. Restart Claude Code. Verify with `/plugin` (active plugins) and a quick
`/help` (listed skills).
