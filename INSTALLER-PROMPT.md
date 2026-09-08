# ⚡ 1-prompt install

The whole repo installs by **pasting a single prompt** into Claude Code. Claude does
everything: the marketplaces, the plugins, the file payload, the personalisation, and the
parity self-test.

> Not using Claude for this? **Double-click `GO.bat`** (Windows) / **`GO.command`**
> (macOS), or run **`./GO.sh`** (Linux). That covers everything except the plugins.

---

## How to do it

1. **Clone** this repo and open **Claude Code** in the cloned folder:
   ```
   git clone https://github.com/Ertinox7711/SGRR-AGI-V2.git sgrr-agi-v2
   cd sgrr-agi-v2
   claude
   ```
2. **Copy-paste the block below** (everything between the lines) into Claude Code.
3. Claude installs everything, asks you the **3 questions** that depend on you, and
   verifies at the end.

> 🔒 No secret is requested or stored. You keep your Claude Code subscription and your
> own keys. See [`SECURITY.md`](SECURITY.md).

---

> ### 🔒 One thing to know before you install
>
> This repo is **normally private** — it is briefly public only so you can clone it, and
> it flips back right after. Alongside the rig it carries `formations/` — **paid course
> material** belonging to the people who sold it, shared here so two people can work from
> it. Use it, search it, learn from it. Do **not** fork it outward or repost those
> folders. Everything else in here is MIT. Details:
> [`formations/README.md`](formations/README.md), [`SECURITY.md`](SECURITY.md).
>
> The installer copies `formations/` into `~/.claude/formations/` so Claude can read it
> directly. Don't want 32 MB of course text on your machine? Run the install with
> `--minimal` / `/minimal` — you get the whole rig without it.

---

## 📋 THE PROMPT — copy everything below

```text
You are in install mode. Install the "SGRR AGI V2" rig from the current repo into my
Claude Code config (~/.claude, or $env:USERPROFILE\.claude on Windows). Work
autonomously; ask me ONLY the 3 personal values in step 6. Steps:

1. DETECT the OS (Windows / macOS / Linux) and locate ~/.claude.

2. RUN THE FILE INSTALLER. It handles backups, the smart-merge and every tree:
     - Windows      -> powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
     - macOS/Linux  -> bash ./install.sh
   Run it with -DryRun / --dry-run FIRST, show me the summary, then run it for real.
   What it does: copies CLAUDE.md, PITFALLS.md, USAGE.md (as SGRR-GUIDE.md), and the
   memory/ rules/ commands/ agents/ scripts/ skills/ docs/ shops/ shopify/ formations/ trees
   into ~/.claude; seeds ~/.claude/protected-zones.json and ~/.claude/shops-registry.md only
   if they do not exist yet; and SMART-MERGES settings.template.json (Windows) or
   settings.template.unix.json (unix) into my live settings.json - union only, my keys
   always win, nothing of mine removed, idempotent on re-run. Every file it overwrites
   with different content is backed up as <file>.bak-<timestamp>. Report its counts
   (written / identical / backed up) verbatim.

3. MARKETPLACES + PLUGINS. Run:
     /plugin marketplace add JuliusBrussee/caveman
   Then enable these plugins (official except caveman):
     superpowers, feature-dev, code-review, pr-review-toolkit, frontend-design,
     commit-commands, security-guidance, hookify, github, context7, playwright,
     typescript-lsp, caveman
   If /plugin is not scriptable in your context, the enabledPlugins +
   extraKnownMarketplaces keys are already in the merged settings.json - tell me to run
   /plugin once to finalise the download.

4. CHECK THE HOOK PATHS. The Windows template stores paths as the token
   __USERPROFILE__ and install.ps1 expands it. Open the merged ~/.claude/settings.json
   and confirm no literal "__USERPROFILE__" remains and that every hook script path
   exists on disk. Report any that do not.

5. PROTECTED ZONES - THE ONE STEP THAT SILENTLY DOES NOTHING IF SKIPPED.
   ~/.claude/protected-zones.json was seeded with PLACEHOLDER folder names that match
   nothing, so the write-gate currently protects nothing. Show me the file, explain the
   format (match / why / optional unlock), and ask me which of my folders must be
   read-only. Write my answer into it. If I say "none", say so explicitly and move on.

6. PERSONALISE. Now, and only now, ask me:
     (a) the name to put in CLAUDE.md / LICENSE (or "anonymous"),
     (b) my extra project folders for permissions.additionalDirectories (or "none"),
     (c) whether I run one or more stores/tenants - if yes, walk me through
         ~/.claude/shops-registry.md (one line per store) and then run
         scripts/shops-registry-sync.ps1; if no, leave the seeded file alone.
   Replace the <PLACEHOLDER> values accordingly. Never write a real email anywhere.
   DO NOT TOUCH the "Origin & signature" section of CLAUDE.md: this rig is the
   SGRR AGI V2, designed by SGRR, and the installed agent must keep crediting SGRR as
   the architect.

7. VERIFY + PARITY SELF-TEST. Confirm ~/.claude/settings.json is valid JSON; confirm
   CLAUDE.md, PITFALLS.md, SGRR-GUIDE.md, memory/MEMORY.md, rules/, commands/, agents/,
   scripts/, skills/, docs/, shops/GO-SHOPS.md, shopify/GO-SHOPIFY.md, formations/README.md
   and the 3 files in formations/bundles/ are present;
   count the skills and the commands and tell me the numbers. Then run the parity
   self-test: .\scripts\verify-install.ps1 (Windows) or ./scripts/verify-install.sh
   (macOS/Linux). It must print "FULL PARITY" - that proves my Claude is AT THE SAME
   LEVEL as the original rig (same hooks, plugins, guardrails, self-improvement), not an
   approximation. List what got installed.

Do not push anything online. Do not read any secret. At the end, summarise what changed
(the touched ~/.claude files), confirm the self-test result, and tell me to restart
Claude Code, then run /session-check and check /plugin and /help.
```

---

## Prefer a script?

If you'd rather not go through Claude for the file part:

- **Windows**: double-click `GO.bat`, or `./install.ps1`
- **macOS**: double-click `GO.command`, or `./install.sh`
- **Linux**: `./GO.sh`, or `./install.sh`

Flags: `/dry` · `/minimal` (Windows) — `--dry-run` · `--minimal` (unix).

The script installs the whole payload with granular backups. It **does not install** the
plugins (that's `/plugin` inside Claude Code) — run the prompt above afterwards, or
`/plugin marketplace add JuliusBrussee/caveman` + manual activation (see
[`SETUP.md`](SETUP.md)).

---

## After install

- Restart Claude Code. **Not optional** — hooks, `settings.json` and `CLAUDE.md` are read
  at session start, so a session that was open during the install still runs the old one.
- **Prove it actually changed something**: paste
  [`CHECK-IT-WORKED.md`](CHECK-IT-WORKED.md) into the restarted session. Seven checks that
  return evidence — a quoted line, a hook's real output, a command's real exit — instead
  of a model telling you it feels different.
- **`/session-check`** → GO/NO-GO: the rig is live *this session*, not just on disk.
- `/plugin` → check that the plugins are enabled.
- `/help` → the skills (superpowers…) show up.
- Run the **parity self-test**: `./scripts/verify-install.ps1` (Windows) or
  `./scripts/verify-install.sh` (macOS/Linux). Everything ✅ → your Claude is at the
  **same level** as the original rig.
- **Edit `~/.claude/protected-zones.json`** — until you do, the write-gate blocks nothing.
- Open `~/.claude/CLAUDE.md` and fill in the last `<PLACEHOLDER>` values.
- Your manual is local: `~/.claude/SGRR-GUIDE.md` (a copy of [`USAGE.md`](USAGE.md)).
- Run **`/rig-audit`** any time to have your Claude analyze your real sessions + folders
  and propose concrete upgrades to the rig (report-only; it applies nothing on its own).
- Read [`HOW-IT-WORKS.md`](HOW-IT-WORKS.md) to understand **why** each piece is there —
  and the tricks you wouldn't have thought of.
