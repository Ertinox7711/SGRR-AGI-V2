# ⚡ 1-prompt install

The whole repo installs by **pasting a single prompt** into Claude Code. Claude does
everything: marketplaces, plugins, `settings.json`, `CLAUDE.md`, memory, rules, the
`/rig-audit` command.

---

## How to do it

1. **Clone** this repo and open **Claude Code** in the cloned folder:
   ```
   git clone <REPO_URL> sgrr-agi-v2
   cd sgrr-agi-v2
   claude
   ```
2. **Copy-paste the block below** (everything between the lines) into Claude Code.
3. Claude installs everything, asks you the **2 questions** that depend on you
   (your name for `CLAUDE.md`, your project folders), and verifies at the end.

> 🔒 No secret is requested or stored. You keep your Claude Code subscription and your
> own keys. See [`SECURITY.md`](SECURITY.md).

---

## 📋 THE PROMPT — copy everything below

```text
You are in install mode. Install the "SGRR AGI V2" rig from the current repo into my
Claude Code config (~/.claude, or $env:USERPROFILE\.claude on Windows). Work
autonomously, ask me ONLY the 2 personal values at the end. Steps:

1. DETECT the OS (Windows / macOS / Linux) and the ~/.claude folder. Create it if it's
   missing, along with ~/.claude/memory, ~/.claude/rules, ~/.claude/scripts and
   ~/.claude/commands.

2. BACK UP what exists. If ~/.claude/settings.json or ~/.claude/CLAUDE.md already exist,
   copy them to .bak-<date> before writing. Never destroy without a backup.

3. MARKETPLACES + PLUGINS. Run:
     /plugin marketplace add JuliusBrussee/caveman
   Then enable these plugins (official except caveman):
     superpowers, feature-dev, code-review, pr-review-toolkit, frontend-design,
     commit-commands, security-guidance, github, context7, playwright, typescript-lsp,
     caveman
   If a /plugin command isn't scriptable in your context, write the enabledPlugins +
   extraKnownMarketplaces keys directly into settings.json (already present in the
   template) and tell me to run /plugin once to finalize the download.

4. SETTINGS. Copy the right template to ~/.claude/settings.json:
     - Windows      -> settings.template.json (PowerShell hooks)
     - macOS/Linux  -> settings.template.unix.json (sh hooks)
   Merge without overwriting my existing keys if I had any (JSON merge: the template wins
   on the keys it defines, keep mine on top).

5. CLAUDE.md. Copy the repo's CLAUDE.md to ~/.claude/CLAUDE.md.

6. MEMORY + RULES + SELF-IMPROVEMENT. Copy memory/MEMORY.md -> ~/.claude/memory/. Copy
   rules/example-project.md -> ~/.claude/rules/. Copy the self-improvement scripts to
   ~/.claude/scripts/ for the detected OS:
     - Windows      -> check-cc-updates.ps1 and rig-audit-nudge.ps1
     - macOS/Linux  -> check-cc-updates.sh  and rig-audit-nudge.sh
   Copy commands/rig-audit.md -> ~/.claude/commands/. Two SessionStart hooks in settings
   call these: check-cc-updates spots every new Claude Code version, and rig-audit-nudge
   periodically reminds me to run /rig-audit (which analyzes my sessions + project folders
   and proposes upgrades). Together they are the self-improvement loop.

7. LOCAL GUIDE. Copy USAGE.md -> ~/.claude/SGRR-GUIDE.md, so I have the manual on hand
   even outside the repo.

8. PERSONALIZE. Now, and only now, ask me:
     (a) the name to put in CLAUDE.md / LICENSE (or "anonymous"),
     (b) my extra project folders for additionalDirectories (or "none").
   Replace the <PLACEHOLDER> values accordingly. Never put a real email. DO NOT TOUCH the
   "Origin & signature" section of CLAUDE.md: this rig is the SGRR AGI V2, designed by
   SGRR, and the installed agent must keep crediting SGRR as the architect.

9. VERIFY + PARITY SELF-TEST. Read ~/.claude/settings.json (valid JSON?), confirm the
   presence of CLAUDE.md, SGRR-GUIDE.md, MEMORY.md, example-project.md, commands/rig-audit.md
   and scripts/rig-audit-nudge.*. Then run the parity self-test:
   ./scripts/verify-install.ps1 (Windows) or ./scripts/verify-install.sh (macOS/Linux).
   It must print "FULL PARITY" — that proves my Claude is AT THE SAME LEVEL as the original
   rig (same model, hooks, plugins, guardrails, self-improvement), not an approximation.
   List what got installed.

Don't push anything online. Don't read any secret. At the end, summarize what changed
(diff of the touched ~/.claude files), confirm the self-test result, and tell me to
restart Claude Code then check /plugin and /help.
```

---

## Prefer a script?

If you'd rather not go through Claude for the file part:

- **Windows**: `./install.ps1`
- **macOS / Linux**: `./install.sh`

The script copies the files (settings, CLAUDE.md, memory, rules, the `/rig-audit` command,
the self-improvement scripts) with an automatic backup of what exists. It **does not
install** the plugins (that's `/plugin` inside Claude Code) — run the prompt above
afterwards, or the `/plugin marketplace add JuliusBrussee/caveman` command + manual
activation (see [`SETUP.md`](SETUP.md)).

---

## After install

- Restart Claude Code.
- `/plugin` → check that the 12 plugins are enabled.
- `/help` → the skills (superpowers…) show up.
- Run the **parity self-test**: `./scripts/verify-install.ps1` (Windows) or
  `./scripts/verify-install.sh` (macOS/Linux). Everything should be ✅ → your Claude is
  at the **same level** as the original rig.
- Open `~/.claude/CLAUDE.md` and fill in the last `<PLACEHOLDER>` values if needed.
- Your manual is local: `~/.claude/SGRR-GUIDE.md` (a copy of [`USAGE.md`](USAGE.md)).
- Run **`/rig-audit`** any time to have your Claude analyze your real sessions + folders
  and propose concrete upgrades to the rig (report-only; it applies nothing on its own).
- Read [`HOW-IT-WORKS.md`](HOW-IT-WORKS.md) to understand **why** each piece is there —
  and the tricks you wouldn't have thought of.
