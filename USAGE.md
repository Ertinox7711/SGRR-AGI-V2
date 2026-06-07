# 📖 Using the rig — practical guide

> This guide is **copied locally** during install, to `~/.claude/SGRR-GUIDE.md`.
> It's always at hand, even offline. Open it anytime you want to get the most
> out of your Claude Code "SGRR AGI V2".

The install gives you the **rig**. This guide gives you the **driving**. A powerful
agent badly steered stays slow; well steered, it works like an AGI. Here's how.

---

## 0. The 10-second reflex

1. Open Claude Code **in the project folder** (not some random directory).
2. Give **the intent, not the procedure**: "fix the login bug", not "open
   that file at line 42". The agent deduces, explores, acts.
3. Let it **verify before declaring done** (it runs tests/build on its own).
4. Every reply comes with a **💡 tip** + a **→ suggestion**: use them, say
   "yes" to what interests you, and it chains forward.

---

## 1. First launch — checklist (2 min)

After install, inside Claude Code:

- `/plugin` → the **12 plugins** are active (superpowers, feature-dev, code-review,
  pr-review-toolkit, frontend-design, commit-commands, security-guidance, github,
  context7, playwright, typescript-lsp, caveman). If not, run `/plugin marketplace add
  JuliusBrussee/caveman` then re-activate.
- `/help` → skills appear (brainstorming, debugging, TDD…).
- `/memory` or open `~/.claude/memory/MEMORY.md` → your memory index (empty at first).
- Run the **parity self-test**: `./scripts/verify-install.ps1` (Windows) or
  `./scripts/verify-install.sh` (macOS/Linux). Everything must be ✅.

If all four pass, your Claude is **at the same level as the original rig**. Not "close":
identical.

---

## 2. The work loop that gets AGI-level output

| Step | What you do | What the rig does for you |
|------|-------------|---------------------------|
| **Frame** | Describe the goal in 1-2 sentences | Process-skills (brainstorming) if the topic is fuzzy |
| **Explore** | Nothing | Sonnet sub-agents explore the codebase (cheap, isolated context) |
| **Do** | Validate the direction | Direct edits (acceptEdits), atomic commits |
| **Verify** | Nothing | `Stop` hook forces tests + `tsc` + uncommitted-change check |
| **Remember** | Nothing | `PreCompact` hook saves durable facts before context compression |

You frame and validate. Everything else is automated by the config.

---

## 3. The levers 95% of people miss

- **Parallelize.** Ask for several independent things at once → the agent fires tools/sub-agents
  **in parallel**. It's baked into `CLAUDE.md`, but grouping them ("do A, B, and C")
  speeds it up further.
- **Sub-agents = bill ÷5.** `CLAUDE_CODE_SUBAGENT_MODEL=sonnet`: the loop that
  *decides* stays on Opus, the *grunt-work* (exploring, reading, reviewing) goes to Sonnet.
  On a large project, the savings are huge. Say "spin up a sub-agent to explore X".
- **`/cost` and `/context`.** Monitor your spend and context fill. When context gets heavy,
  auto-compact + the `PreCompact` hook preserve what matters.
- **Plan mode.** For a big refactor, ask for a **plan first** ("make me a plan, don't code yet").
  You validate, then you unleash execution.
- **`effortLevel`** in `settings.json`: `medium` by default. Raise it for deep reasoning,
  lower it for raw throughput.

---

## 4. Memory — how to use it

- **Save**: feedback you keep giving, project facts not derivable from the code,
  a URL/dashboard, your profile. One fact = one file in `~/.claude/memory/`.
- **Never save**: what the code/git already says (structure, conventions, log).
- Just say "**remember that…**" and the agent writes the file + updates the `MEMORY.md` index.
- At the start of each session, the `SessionStart` hook reminds it to read memory.

---

## 5. Scraping / fetch that gets blocked

A `403` / `429` / empty page / Cloudflare challenge? **Don't fiddle with headers.**
The rig has the reflex baked in: switch to **Scrapling** (stealth fetch). Just say
"the fetch is blocked, switch to Scrapling". Install if needed:
`pip install scrapling && scrapling install`.

---

## 6. Day-to-day security

- Destructive commands (`rm`, `git reset --hard`, `git push --force`, `docker`,
  `kubectl`…) **ask for confirmation** automatically (`permissions.ask`). That's the
  only real safety net — prose doesn't protect anything, the `ask` net does.
- Put your **machine secrets** in `~/.claude/settings.local.json` (gitignored),
  never in the shared `settings.json`.
- Before **sharing your own setup**: run `scripts/preflight-scrub.*`. It scans for
  secrets + PII + git author. See [`SECURITY.md`](SECURITY.md).

---

## 7. When things go sideways

- **Agent drifts / forgets discipline?** Normal in a long session — hooks re-anchor it
  every turn. If needed, restate the goal in one sentence.
- **Too chatty?** `/caveman full` → terse output. `/caveman lite` → intermediate.
  "stop caveman" → back to normal.
- **A command won't go through?** That's `permissions.ask` doing its job.
  Confirm it, or add the pattern to `allow` if you run it 50× a day.
- **Context full?** `/compact` manually, or let auto-compact handle it. Memory +
  the `PreCompact` hook keep the durable facts safe.

---

## 8. Verifying your Claude is "as smart as the original"

The rig guarantees **parity** — not an approximation. To prove it:

```
./scripts/verify-install.ps1     # Windows
./scripts/verify-install.sh      # macOS / Linux
```

The script confirms: valid `settings.json`, Opus + Sonnet sub-agents, 12 plugins
active, 4 hooks in place, `CLAUDE.md` loaded, memory + rules present. If everything is
✅, your agent is applying **exactly** the same config and philosophy as the SGRR rig.
Same levers, same behavior, same level.

---

> Built by **SGRR** · `SGRR AGI V2`. You're running a 1:1 replica — use it as such:
> clear intent, fast validation, and let the agent run.
