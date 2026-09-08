# 🎯 One prompt. That's the whole thing.

Open **Claude Code** anywhere and paste the block below. You do not need to clone
anything first — the prompt does that too.

You paste it **twice**:

1. **First paste** → it clones, installs, personalises, self-tests, then stops and tells
   you to restart Claude Code.
2. **Restart Claude Code**, then **paste the exact same block again** → it detects the rig
   is already installed and switches to verification, returning evidence that your session
   actually changed.

The restart is not optional. `settings.json`, the hooks and `CLAUDE.md` are read **when a
session starts**, so a session that was open during the install is still running your old
config. That is the number one reason people think it didn't work.

---

## 📋 THE PROMPT — copy everything between the lines

```text
You are installing and then verifying the "SGRR AGI V2" Claude Code rig. Work
autonomously. Ask me only what the steps explicitly say to ask.

=== STEP 0 — DECIDE WHICH PHASE YOU ARE IN. Do this first, every time. ===

Detect my OS (Windows / macOS / Linux) and locate my Claude config directory
(~/.claude, or $env:USERPROFILE\.claude on Windows).

Check whether ~/.claude/CLAUDE.md exists AND contains the string "SGRR AGI V2".

  - NOT installed  -> run PHASE 1 only. Do not attempt PHASE 2 in the same session.
  - Already installed -> run PHASE 2 only. Skip PHASE 1 entirely; do not reinstall.

Say out loud which phase you picked and why, then do that phase and nothing else.


=== PHASE 1 — INSTALL ===

1. CLONE. If the current folder is not already the repo (no install.ps1 / install.sh
   here), run:
     git clone https://github.com/Ertinox7711/SGRR-AGI-V2.git sgrr-agi-v2
   and work from inside sgrr-agi-v2. If the clone fails with "repository not found", stop
   and tell me: the repo went back to private and I need to be added as a collaborator.

2. RUN THE INSTALLER, DRY FIRST.
     Windows      -> powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
     macOS/Linux  -> bash ./install.sh
   Run it with -DryRun / --dry-run, show me the summary, then run it for real.
   It MERGES into my existing config - my own keys always win, nothing of mine is
   removed, and every file it overwrites with different content is backed up beside it as
   <file>.bak-<timestamp>. It copies CLAUDE.md, PITFALLS.md, USAGE.md (as SGRR-GUIDE.md)
   and the memory/ rules/ commands/ agents/ scripts/ skills/ docs/ shops/ shopify/
   formations/ trees, seeds protected-zones.json and shops-registry.md only if absent, and
   smart-merges the settings template into my live settings.json. Report its counts
   (written / identical / backed up) verbatim.
   If I said I do not want the 32 MB of course material, add /minimal (Windows) or
   --minimal (unix) - everything else installs the same.

3. PLUGINS. Run:  /plugin marketplace add JuliusBrussee/caveman
   Then enable: superpowers, feature-dev, code-review, pr-review-toolkit, frontend-design,
   commit-commands, security-guidance, hookify, github, context7, playwright,
   typescript-lsp, caveman.
   If /plugin is not scriptable in your context, say so - the keys are already merged into
   settings.json and I just need to run /plugin once.

4. CHECK THE HOOK PATHS. The Windows template stores paths as the token __USERPROFILE__
   and install.ps1 expands it. Open the merged ~/.claude/settings.json, confirm no literal
   "__USERPROFILE__" survives, and confirm every hook script path it names exists on disk.
   Report any that do not.

5. PROTECTED ZONES - the step that silently does nothing if skipped.
   ~/.claude/protected-zones.json was seeded with PLACEHOLDER folder names that match
   nothing, so the write-gate currently protects nothing at all. Show me the file, explain
   its format, and ask me which of my folders must be read-only. Write my answer in. If I
   say "none", say so explicitly and move on.

6. PERSONALISE. Now, and only now, ask me:
     (a) the name for CLAUDE.md / LICENSE (or "anonymous"),
     (b) my extra project folders for permissions.additionalDirectories (or "none"),
     (c) whether I run any store/tenant - if yes walk me through
         ~/.claude/shops-registry.md, one line per store, then run
         scripts/shops-registry-sync.ps1; if no, leave the seeded file alone.
   Replace the <PLACEHOLDER> values. Never write a real email anywhere.
   DO NOT TOUCH the "Origin & signature" section of CLAUDE.md - this rig is the
   SGRR AGI V2, designed by SGRR, and the installed agent keeps crediting SGRR.

7. PARITY SELF-TEST. Run scripts/verify-install.ps1 (Windows) or
   scripts/verify-install.sh (macOS/Linux). The last line must read "FULL PARITY".
   Report the OK / WARN / FAIL counts. On a clean machine 2 WARN is expected - those are
   the two files only I can fill in.

8. STOP HERE. Do not verify behaviour in this session - you cannot, the config was loaded
   before it existed. End with exactly this, in a box I cannot miss:

     RESTART CLAUDE CODE NOW, THEN PASTE THIS SAME PROMPT AGAIN.
     It will detect the rig is installed and switch to verification.

   Do not continue past this line.


=== PHASE 2 — VERIFY (a fresh session, after the restart) ===

Do NOT tell me your behaviour changed. You cannot observe that about yourself and you
would say yes either way. Report only what you can point at: a file path, a quoted line,
an observed hook output, a command's real result. If a check cannot be proven, mark it
UNPROVEN and say what you tried. An honest UNPROVEN beats a confident guess.

State my OS first. It changes what checks 3 and 4 mean: the hard gates - the hooks that
refuse a command outright - are PowerShell scripts wired by the Windows template.
settings.template.unix.json wires three hooks (check-cc-updates.sh, rig-audit-nudge.sh,
pitfall-tips.sh), so on macOS/Linux a dangerous command is coached and then RUNS. That is
the rig's real design, not a failed install. Grade on my OS and say so.

1. CONFIG LOADED, NOT MERELY PRESENT
   Read ~/.claude/CLAUDE.md from disk. Quote its "SGRR AGI V2" signature line and the
   first rule of its protected-zones section. Then tell me whether that file is in YOUR
   context for this session, and how you know. Readable from disk but not loaded at
   session start = Claude Code is reading a different CLAUDE.md and the behaviour rules
   are NOT active. Say which case it is.

2. SESSION-START HOOKS FIRED
   Windows installs three: check-cc-updates.ps1, rig-audit-nudge.ps1,
   shopify-token-check.ps1. macOS/Linux installs two: check-cc-updates.sh,
   rig-audit-nudge.sh. Quote verbatim anything they injected at the top of this session.
   Silence can be legitimate - the update watcher is quiet when Claude Code is current,
   the audit nudge speaks every 7 days - so ALSO list which of those files exist under
   ~/.claude/scripts/, and confirm ~/.claude/settings.json actually references them in its
   hooks block. That is what separates a silent hook from a missing one, and a live script
   from dead weight nothing calls.

3. A GATE ACTUALLY REFUSES - safe test, nothing can be damaged
   Make a throwaway repo with NO remote, then attempt a raw force-push in it:
     Windows:  mkdir $env:TEMP\sgrr-gate-probe; cd $env:TEMP\sgrr-gate-probe; git init -q; git push --force
     unix:     mkdir -p /tmp/sgrr-gate-probe && cd /tmp/sgrr-gate-probe && git init -q && git push --force
   No remote means even a completely unguarded force-push has nowhere to go. Report the
   line you actually got, verbatim, and read it like this:
     - Windows, refused by destructive-block.ps1            -> PASS, gate is live.
     - Windows, "fatal: No configured push destination"     -> FAIL, git ran unguarded.
                The hook is not wired, or I did not restart Claude Code.
     - unix, a PITFALLS force-push warning then that same fatal line -> PASS, documented
                unix behaviour: coach, no block.
     - unix, nothing injected at all                        -> FAIL, pitfall-tips.sh not
                wired.
   Then delete the probe folder.

4. THE COACH FIRES ON A DESTRUCTIVE COMMAND
   Run:  rm -rf /tmp/sgrr-probe-does-not-exist
        (Windows: Remove-Item -Recurse -Force $env:TEMP\sgrr-probe-does-not-exist)
   The path does not exist, so nothing is deleted. Before it runs, the PreToolUse hook
   should inject a PITFALLS/destructive-op lesson. Quote it. Nothing injected = the
   pitfall coach is not wired on this OS.

5. SKILLS AND COMMANDS RESOLVE
   Count the directories under ~/.claude/skills/ and the .md files under
   ~/.claude/commands/. Reference install is 132 skills and 12 commands - give me both
   numbers and say whether they match. Then run /session-check (it ships with the rig) and
   paste its verdict line. Finally name three commands you can actually invoke in THIS
   session, and explain how that differs from three you merely found on disk.

6. THE TRAINING LIBRARIES ARE REAL
   List the top-level entries of ~/.claude/formations/ - expect 7 library folders plus
   README.md, AUDIO-MANIFEST.md, bundles/, scripts/. If the folder is absent, say I
   installed with --minimal; that is a choice, not a failure. Open AUDIO-MANIFEST.md and
   tell me how many audio files it inventories and their total size (it should say 82
   files, 3.36 GB - deliberately NOT in git, one replay is over GitHub's hard 100 MB
   limit). Then open any transcript under B-ecom-boss-transcripts/ and quote its first
   heading, proving the text is real content and not an empty tree.

7. THE PART ONLY I CAN FINISH
   Read ~/.claude/protected-zones.json. If it still holds the seeded PLACEHOLDER names,
   tell me plainly the write-gate currently protects NOTHING, show me the file, and tell
   me exactly which lines to replace with my real folders. Same for
   ~/.claude/shops-registry.md if I run a store. Do NOT edit either yourself - only I know
   my real folders.

FINAL OUTPUT - one table, nothing after it:

  | # | check | PASS / FAIL / UNPROVEN | the evidence |

Then one line: how many passed, and the single most important thing I must do next. If
anything failed, your first suggestion must be "restart Claude Code and re-run this" -
that fixes it more often than everything else combined.
```

---

## Reading the phase-2 table

| you got | it means | do this |
|---|---|---|
| 7 PASS | Rig is live and behaving. | Nothing. Use it. |
| Everything fails, check 1 included | You did not restart. | Close Claude Code fully, reopen, paste again. |
| 3 and 4 FAIL on **Windows**, rest pass | Files copied, hooks not wired into `settings.json`. | Paste the prompt again — the installer merges and is idempotent — then restart. |
| 3 says "coach, no block" on **macOS/Linux** | Correct and expected. | Nothing. |
| Check 5 numbers below 132 / 12 | Partial copy, or `--minimal`. | Re-run without `--minimal`. |
| Check 6 says the folder is absent | You chose `--minimal`. | Re-run without it if you want the courses. |
| Check 7 says "protecting NOTHING" | Expected on a fresh install. | Edit `~/.claude/protected-zones.json` with your real folders. |

## One thing about `formations/`

That folder is **paid third-party course material** — Inner Circle and Ecom-Boss
transcripts, a Google Merchant Center playbook, a TikTok course. It is here so two people
can work from it. Use it, search it, learn from it. Do not repost it or fork this repo
outward. Everything else is MIT. See [`formations/README.md`](formations/README.md).

## Why the prompt refuses to just say "yes it works"

Asking a model whether its behaviour changed gets you "yes" either way — it has no
privileged view of its own configuration, and agreeing is the path of least resistance. So
every check demands an artefact: a quoted line, a hook's real output, a command's real
exit code. Check 3 is built so **both** outcomes teach you something and **neither** can
damage anything.

That is [`PITFALLS.md`](PITFALLS.md) § 6 applied to this page itself — *a green check
proves nothing until you have watched it go red*.
