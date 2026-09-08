# Setup — Manual Installation Manifest

> ⚡ **Want it in one click?** Double-click **`GO.bat`** (Windows) / **`GO.command`**
> (macOS), or run **`./GO.sh`** (Linux). That does everything on this page except the
> plugins, which only Claude Code itself can install.
>
> ⚡ **Want Claude to do it?** Paste [`INSTALLER-PROMPT.md`](INSTALLER-PROMPT.md).
>
> This file is the **manual** version, step by step, if you prefer to control
> everything yourself. ~15 min.

---

## 0. What lands where

| Repo | Installs to | Contents |
|---|---|---|
| `CLAUDE.md` | `~/.claude/CLAUDE.md` | Always-loaded philosophy + hard rules |
| `PITFALLS.md` | `~/.claude/PITFALLS.md` | The trap catalogue the hook quotes from |
| `USAGE.md` | `~/.claude/SGRR-GUIDE.md` | The practical guide |
| `memory/` | `~/.claude/memory/` | Memory index + format |
| `rules/` | `~/.claude/rules/` | 9 lazy `paths:` rules |
| `commands/` | `~/.claude/commands/` | 20 slash commands |
| `agents/` | `~/.claude/agents/` | 6 sub-agent definitions |
| `scripts/` | `~/.claude/scripts/` | 24 hook scripts + self-tests |
| `skills/` | `~/.claude/skills/` | 132 skills |
| `docs/` | `~/.claude/docs/` | External skill-library index |
| `shops/` | `~/.claude/shops/` | `GO-SHOPS.md` + the store `scaffold/` |
| `shopify/` | `~/.claude/shopify/` | `GO-SHOPIFY.md` + the training-library loader |
| `protected-zones.example.json` | `~/.claude/protected-zones.json` | **Seeded once, then never touched** |
| `shops/shops-registry.template.md` | `~/.claude/shops-registry.md` | **Seeded once, then never touched** |
| `settings.template*.json` | `~/.claude/settings.json` | **Smart-merged**, never clobbered |

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
| `hookify` | official | Turn a recurring correction into a hook. |
| `github` | official | GitHub operations from Claude. |
| `context7` | official | Live library docs (MCP). |
| `playwright` | official | Browser automation (MCP). |
| `typescript-lsp` | official | Real TS language server (defs, refs, diagnostics). |
| `caveman` | caveman | Optional — terse "caveman" output mode + statusline. |

Off by default in the template: `skill-creator`, `claude-md-management`,
`pyright-lsp`, `ralph-loop`, `firebase`, `claude-mem`.

## 2. settings.json

> ⚠️ **Already have a `~/.claude/settings.json`?** `install.ps1` / `install.sh`
> **smart-merge** the rig config into it (backup first, your keys preserved,
> idempotent) — prefer them over a raw copy, which overwrites the file wholesale.

```
# Windows
.\install.ps1                      # smart-merge (recommended)
# macOS / Linux
./install.sh
```

The Windows template stores paths as the token `__USERPROFILE__`; **`install.ps1`
expands it** to your real home directory, so the installed file holds plain absolute
paths and nothing has to be expanded at hook runtime. If you copy the template by hand,
replace that token yourself.

What the settings give you:

- **`defaultMode: acceptEdits`** — file edits flow with zero friction.
- **12 hooks.** 3 `SessionStart` (Claude Code update watch, rig-audit nudge, store-token
  freshness) and 9 `PreToolUse` gates:

  | Hook | Matcher | Effect |
  |---|---|---|
  | `browser-nav-denylist.ps1` | browser navigate / evaluate | deny |
  | `protected-path-denylist.ps1` | Edit/Write/Notebook/Bash | **deny** writes inside your protected zones |
  | `asset-delete-guard.ps1` | Bash / PowerShell | **deny** deletion of your durable assets without a 24 h unlock |
  | `shop-identity-guard.ps1` | edits + store API mutations | advisory: which store is this? |
  | `shop-token-identity-block.ps1` | Bash / PowerShell | **deny** a credential reaching the wrong store |
  | `destructive-block.ps1` | Bash / PowerShell | **deny** raw force-push and friends |
  | `pitfall-tips.ps1` ×2 | Bash, PowerShell | advisory: surfaces the matching PITFALLS lesson |
  | `trio-fanout-cap.ps1` | Task | caps sub-agent fan-out |

  All gates **fail open** on a parse error — they are defense in depth, not the sole
  guard. The prose rules in `CLAUDE.md` are the layer that does not depend on a parser.
- **macOS/Linux**: those guards are PowerShell-only. The unix template compensates with a
  `permissions.ask` net over the same destructive command families, plus the portable
  hooks (`pitfall-tips.sh`, update check, rig-audit nudge, prompt/session/precompact
  injections) and `CLAUDE_CODE_SUBAGENT_MODEL: sonnet`.
- **Optional hooks** that depend on software only you have (a local bridge, a WSL digest,
  a local-LLM IP sync) live in [`settings.optional-hooks.json`](settings.optional-hooks.json),
  deliberately **out** of the default install. Paste in only what you actually run.

## 3. CLAUDE.md

```
cp CLAUDE.md  ~/.claude/CLAUDE.md   # ($env:USERPROFILE on Windows)
```

Fill in the `<PLACEHOLDER>` blocks. Move project-specific autonomy rules out of
this always-loaded file and put them in `rules/*.md` with a `paths:` frontmatter
(step 5) — this keeps your global context light.

## 4. Memory

```
mkdir ~/.claude/memory
cp memory/MEMORY.md  ~/.claude/memory/MEMORY.md
```

One fact per file, indexed by a line in `MEMORY.md`. The format is specified
in that file.

## 5. Rules (lazy context)

```
cp -r rules  ~/.claude/
```

A rule with a `paths:` frontmatter loads **only** when Claude touches a matching
file — unlike `CLAUDE.md`, which loads every session. `rules/example-project.md` is the
skeleton; the others are working examples (a store, a SaaS client, a docs convention, a
bot project, the Shopify doctrine).

## 6. Protected zones — do not skip this

```
cp protected-zones.example.json  ~/.claude/protected-zones.json
# then EDIT it: name your own folders
```

The example ships with **placeholder folder names**, which match nothing. Until you edit
it, `protected-path-denylist.ps1` protects **nothing** (it exits 0 when no zone matches).
Each entry is:

```json
{ "match": "business/my-client-work",
  "why":   "client work (READ-ONLY: read and analyze, never modify)",
  "unlock": ".claude/.my-client-write-unlock" }
```

`match` is a lowercase forward-slash path fragment matched with a boundary, so
`business/shopify` will **not** match a sibling `business/shopify-clone`. Omit `unlock`
for a zone that must never be writable; with it, creating that file (ISO-8601 timestamp
inside) grants a 24 h supervised window.

## 7. Skills

```
cp -r skills  ~/.claude/
```

132 skills. Claude **auto-invokes** the relevant one the moment it applies — no slash
command required. A handful are thin wrappers around third-party libraries; each keeps
its own `SKILL.md` and license notice. If you'd rather start light, `GO.bat /minimal`
(or `./install.sh --minimal`) skips `skills/`, `docs/`, `shops/` and `shopify/`.

## 8. Stores (optional)

Only if you operate one or more stores / tenants:

```
cp shops/shops-registry.template.md  ~/.claude/shops-registry.md
# edit it, one line per store, then:
powershell -File scripts/shops-registry-sync.ps1     # writes the .json the hooks read
```

Read [`shops/GO-SHOPS.md`](shops/GO-SHOPS.md) before creating store number two — the
whole failure mode it prevents is *acting on store B while believing you are on A*.

---

Done. Restart Claude Code. Verify with:

```
/session-check          # GO/NO-GO: is the rig actually live THIS session?
/plugin                 # active plugins
scripts/verify-install.ps1   (or .sh)   # parity self-test
```
