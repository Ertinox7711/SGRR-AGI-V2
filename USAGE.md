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

- `/plugin` → the **13 plugins** are active (superpowers, feature-dev, code-review,
  pr-review-toolkit, frontend-design, commit-commands, security-guidance, hookify, github,
  context7, playwright, typescript-lsp, caveman). If not, run `/plugin marketplace add
  JuliusBrussee/caveman` then re-activate.
- `/help` → skills appear (brainstorming, debugging, TDD…).
- `/memory` or open `~/.claude/memory/MEMORY.md` → your memory index (empty at first).
- **Edit `~/.claude/protected-zones.json`.** It was seeded with placeholder folder names
  that match nothing, so until you name your own folders the write-gate blocks **nothing**.
  This is the one install step that fails silently.
- Run the **parity self-test**: `./scripts/verify-install.ps1` (Windows) or
  `./scripts/verify-install.sh` (macOS/Linux). It must print **FULL PARITY**. `[WARN]`
  lines are personalisation steps, not gaps; `[FAIL]` lines are real.
- Run **`/session-check`** inside Claude Code → a GO/NO-GO verdict that you're in the
  right repo **and** the rig + superpowers + skills are live *this* session (not just
  installed). Use it anytime you're unsure you're "in the right place".

All green → your Claude is **at the same level as the original rig**. Not "close":
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

- Destructive commands (`rm`, hard reset, force-push, `docker`, `kubectl`…) are
  intercepted **before** they run — by a `PreToolUse` gate that can `deny` (Windows) or by
  `permissions.ask` (macOS/Linux). That's the only real safety net; prose protects nothing.
- **Name your protected folders** in `~/.claude/protected-zones.json` — that is what turns
  "read-only" from an intention into an enforced rule. Each entry is
  `{ "match": "...", "why": "...", "unlock": "..." }`; `match` is a lowercase
  forward-slash path fragment compared with a boundary, so `business/shopify` will not
  freeze a sibling `business/shopify-clone`. Omit `unlock` for a zone that must never be
  writable; with it, creating that file (ISO-8601 timestamp inside) opens a supervised 24 h
  window.
- **One credential = one store.** If you run several, keep the registry
  (`~/.claude/shops-registry.md`) as the only source of truth and let the folder decide
  identity — see [`shops/GO-SHOPS.md`](shops/GO-SHOPS.md).
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
- **A command won't go through?** That's a gate doing its job. On unix, confirm it (or add
  the pattern to `permissions.allow` if you run it 50× a day). On Windows, the message
  names the script that denied it and why — a protected zone, an asset deletion without an
  unlock, or a store/credential mismatch. Fix the cause; don't disable the gate.
- **Context full?** `/compact` manually, or let auto-compact handle it. Memory +
  the `PreCompact` hook keep the durable facts safe.

---

## 8. Verifying your Claude is "as smart as the original"

The rig guarantees **parity** — not an approximation. To prove it:

```
./scripts/verify-install.ps1     # Windows
./scripts/verify-install.sh      # macOS / Linux
```

It checks, in order: `settings.json` present and valid JSON · no unexpanded path token
left in it · 13 plugins · the hook events wired · **every hook script actually on disk**
· the 8 guards wired (Windows) or the `ask` net + 5 hook events (unix) · `CLAUDE.md`,
`PITFALLS.md`, `SGRR-GUIDE.md`, `memory/MEMORY.md` · the payload counts (rules, commands,
skills, agents, scripts) · `/session-check`, `/rig-audit`, the update watch, the preflight
scrub, `GO-SHOPS.md`, `GO-SHOPIFY.md` · and the machine-local config.

Read the verdict properly:

- **`[FAIL]`** = a real gap. Fix it, re-run.
- **`[WARN]`** = present but not personalised (placeholder protected zones, no
  registry, sub-agent model unset). Parity holds; it's a step *you* still owe.
- **`FULL PARITY`** (exit 0) = your agent applies **exactly** the same config and
  philosophy as the SGRR rig. Same levers, same behavior, same level.

Point it anywhere with `-Target` / `--target` — which is also how you can rehearse the
whole install in a throwaway folder before it touches your real `~/.claude`:

```
./install.ps1 -Target D:\sandbox\.claude
./scripts/verify-install.ps1 -Target D:\sandbox\.claude
```

---

## 9. The rig warns you before you trip

Beyond doing work fast, the rig actively **stops you repeating known mistakes**.

- **Live coaching.** A `PreToolUse` hook (`scripts/pitfall-tips.*`) watches the commands
  about to run. The instant one matches a known trap — `--no-verify`, `git push --force`,
  `git reset --hard`, `git clean`, `rm -rf`, even a plain `push`/`commit` — it injects the
  matching lesson from [`PITFALLS.md`](PITFALLS.md) *before* the command fires. Destructive
  matches warn **every time**; gentle coaching tips are throttled (a few hours) so they
  never nag. It only ever **advises** — the real block is the deny-capable gate next to it.
- **The catalog.** [`PITFALLS.md`](PITFALLS.md) holds all **13** traps in full
  (symptom → rule → cheap check). Read it once end to end; it's the institutional memory
  of a power-user, generalized so it leaks nothing.
- **The installer touches *your own* Claude too.** Install doesn't just drop files in a
  folder — it **smart-merges** the rig's hooks, permissions and plugins into your live
  `~/.claude/settings.json` (backing it up first, preserving every key you already have;
  re-running adds nothing twice). So the coaching, the memory
  nudge, and the update watch are wired into *your* daily Claude, not just a copy on disk.

---

> Built by **SGRR** · `SGRR AGI V2`. You're running a 1:1 replica — use it as such:
> clear intent, fast validation, and let the agent run.
