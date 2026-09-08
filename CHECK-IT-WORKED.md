# ✅ Did it actually work? — the 2-minute proof

The installer said `FULL PARITY`. That proves the **files** landed. It does **not** prove
your Claude is behaving differently — config on disk and config *loaded into a running
session* are two different things, and only the second one changes anything.

This page is the second half of the check. Paste the prompt below into Claude Code and it
will prove it with evidence, or tell you exactly what is missing.

---

## 🔴 Do this first, or the test fails for the wrong reason

**Restart Claude Code.** Close it completely and reopen it in the cloned folder.

`settings.json`, the hooks and `CLAUDE.md` are read **when a session starts**. A session
that was already open while you installed is still running the old config — it will fail
every check below and nothing is actually wrong. This is the single most common
"it didn't work".

```bash
claude
```

---

## ⚠️ One thing that is not a bug: Windows gets more gates than macOS/Linux

The **hard gates** — the hooks that refuse a command outright — are PowerShell scripts:
`destructive-block.ps1`, `protected-path-denylist.ps1`, `asset-delete-guard.ps1`,
`shop-identity-guard.ps1`, `shop-token-identity-block.ps1`, `browser-nav-denylist.ps1`,
`trio-fanout-cap.ps1`. They are wired by `settings.template.json`, the **Windows** template.

`settings.template.unix.json` wires three hooks: `check-cc-updates.sh` and
`rig-audit-nudge.sh` at session start, and `pitfall-tips.sh` before every Bash call.

So on macOS/Linux the coaching layer is live and **nothing blocks you** — a dangerous
command gets a warning, then runs. That is the current state of the rig, not a failed
install. The prompt below knows this and grades your OS accordingly. Everything else —
`CLAUDE.md`, the 132 skills, the 12 commands, `PITFALLS.md`, `formations/` — is identical
on all three platforms.

---

## 📋 The prompt — paste everything between the lines

```text
You are running a post-install verification of the "SGRR AGI V2" rig, in a NEW session
started after the install.

Do NOT tell me your behaviour changed. You cannot observe that about yourself, and you
would say yes either way. Report only what you can point at: a file path, a quoted line,
an observed hook output, a command's real result. If a check cannot be proven, mark it
UNPROVEN and say what you tried. An honest UNPROVEN is worth more to me than a confident
guess.

First, state my OS (Windows / macOS / Linux). It changes what checks 3 and 4 mean - the
hard gates are PowerShell-only, so on macOS/Linux "no block" is the correct result, not a
failure. Grade accordingly and say so.

Then run these seven checks.

1. CONFIG LOADED, NOT MERELY PRESENT
   Read ~/.claude/CLAUDE.md from disk (Windows: $env:USERPROFILE\.claude\CLAUDE.md).
   Quote its rig signature line ("SGRR AGI V2") and the first rule of its protected-zones
   section. Then tell me whether that file is in YOUR context for this session and how you
   know. Readable from disk but not loaded at session start = Claude Code is reading a
   different CLAUDE.md and the behaviour rules are NOT active. Say which case it is.

2. SESSION-START HOOKS FIRED
   Windows installs three: check-cc-updates.ps1, rig-audit-nudge.ps1,
   shopify-token-check.ps1. macOS/Linux installs two: check-cc-updates.sh,
   rig-audit-nudge.sh. Quote verbatim anything they injected at the top of this session.
   Silence can be legitimate - the update watcher is quiet when Claude Code is current and
   the audit nudge speaks every 7 days - so ALSO list which of those script files exist
   under ~/.claude/scripts/. That is what separates a silent hook from a missing one.
   Then open ~/.claude/settings.json and confirm those scripts are actually referenced in
   the hooks block. A script on disk that nothing calls is dead weight.

3. A GATE ACTUALLY REFUSES - safe test, nothing can be damaged
   Make a throwaway repo with NO remote, then attempt a raw force-push inside it:
     Windows:   mkdir $env:TEMP\sgrr-gate-probe; cd $env:TEMP\sgrr-gate-probe; git init -q; git push --force
     macOS/Lx:  mkdir -p /tmp/sgrr-gate-probe && cd /tmp/sgrr-gate-probe && git init -q && git push --force
   The repo has no remote, so even a completely unguarded force-push has nowhere to go.
   Report the line you actually got, verbatim, and read it like this:
     - Windows, "BLOCKED"/refused by destructive-block.ps1  -> PASS, the gate is live.
     - Windows, "fatal: No configured push destination"     -> FAIL, git ran unguarded.
                 The hook is not wired, or you did not restart Claude Code.
     - macOS/Linux, a PITFALLS force-push warning then that same fatal line -> PASS.
                 That is the documented unix behaviour: coach, no block.
     - macOS/Linux, nothing injected at all                 -> FAIL, pitfall-tips.sh is
                 not wired.
   Then delete the probe folder.

4. THE COACH FIRES ON A DESTRUCTIVE COMMAND
   Run:  rm -rf /tmp/sgrr-probe-does-not-exist
        (Windows: Remove-Item -Recurse -Force $env:TEMP\sgrr-probe-does-not-exist)
   The path does not exist, so nothing is deleted. Before it runs, the PreToolUse hook
   should inject a PITFALLS/destructive-op lesson. Quote it. Nothing injected = the
   pitfall coach is not wired on this OS.

5. SKILLS AND COMMANDS RESOLVE
   Count the directories under ~/.claude/skills/ and the .md files under
   ~/.claude/commands/. The reference install is 132 skills and 12 commands - tell me your
   two numbers and whether they match. Then run /session-check (it ships with the rig) and
   paste its verdict line. Finally: name three commands you can actually invoke in THIS
   session, and explain how that differs from three you merely found on disk.

6. THE TRAINING LIBRARIES ARE REAL
   List the top-level entries of ~/.claude/formations/ (expect 7 library folders plus
   README.md, AUDIO-MANIFEST.md, bundles/, scripts/). Open AUDIO-MANIFEST.md and tell me
   how many audio files it inventories and their total size - it should say 82 files,
   3.36 GB, and those files are deliberately NOT in git. Then open any transcript under
   B-ecom-boss-transcripts/ and quote its first heading, to prove the text is real content
   and not an empty tree.

7. THE PART ONLY I CAN FINISH
   Read ~/.claude/protected-zones.json. If it still holds the seeded PLACEHOLDER folder
   names, tell me plainly that the write-gate currently protects NOTHING, show me the
   file, and tell me exactly which lines to replace with my real folders. Same for
   ~/.claude/shops-registry.md if I run any store. Do NOT edit either file yourself - only
   I know what my real folders are.

FINAL OUTPUT - one table, nothing after it:

  | # | check | PASS / FAIL / UNPROVEN | the evidence |

Then one line: how many passed, and the single most important thing I have to do next.
If anything failed, your first suggestion must be "restart Claude Code and re-run this" -
that fixes it more often than everything else combined.
```

---

## Reading the result

| you got | it means | do this |
|---|---|---|
| 7 PASS | The rig is live and behaving. | Nothing. Go use it. |
| Everything fails, check 1 included | You did not restart. | Close Claude Code fully, reopen, paste again. |
| 3 and 4 fail on **Windows**, rest pass | Files copied, hooks not wired into `settings.json`. | Re-run the installer, then restart. It merges — re-running is safe and idempotent. |
| 3 says "coach, no block" on **macOS/Linux** | Correct and expected. | Nothing. See the note above. |
| Check 5 counts are lower | Partial copy, or `--minimal`. | Re-run the installer without `--minimal` / `/minimal`. |
| Check 6 fails | You installed with `--minimal` / `/minimal`. | That is the flag that skips `formations/`. Re-run without it. |
| Check 7 says "protecting NOTHING" | Expected on a fresh install. | Edit `~/.claude/protected-zones.json` with your own folders. Until you do, that gate blocks nothing. |

## Why the prompt is written that way

Asking a model "did your behaviour change?" gets you "yes" whether or not it did — it has
no privileged view of its own configuration, and agreeing is the path of least resistance.
So every check demands an artefact instead: a quoted line, a hook's actual output, a
command's real exit code. Check 3 is built so that **both** outcomes are informative and
**neither** can damage anything: a repo with no remote has nowhere to push.

That is the same rule the rig applies to its own leak scanners, written down in
[`PITFALLS.md`](PITFALLS.md) § 6 — *a green check proves nothing until you have watched it
go red*. A verification that can only return "fine" is not a verification.
