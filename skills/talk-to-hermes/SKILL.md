---
name: talk-to-hermes
description: |
  Talk DIRECTLY to Hermes (a.k.a. NeverGiveUp), the operator's personal Jarvis agent
  running in WSL, WITHOUT going through Discord DMs. Use when you (Claude Code)
  are about to do work that overlaps Hermes's domain — the operator's projects,
  deadlines, objectives, notes, or kanban tasks (the NGU "second brain") — and
  want to query what Hermes already knows / tracks instead of re-deriving it, OR
  to delegate/hand off a task to Hermes, OR to have Hermes remember something.
  Hermes shares one persistent brain (memories/ + kanban.db), so asking it
  avoids duplicating its work. Triggers: "ask Hermes", "demande à Hermes",
  "check with NeverGiveUp", "parle à Hermes", "que sait Hermes sur...",
  "delegate to Hermes", "fais suivre à Hermes", "Hermes sans Discord".
allowed-tools:
  - Bash
  - Write
  - Read
---

# talk-to-hermes — direct bridge to the Hermes agent (no Discord)

Hermes = the **NeverGiveUp** agent (Nous Research Hermes fork) in WSL Ubuntu-22.04.
It runs on the operator's Claude Max OAuth. Same agent that answers his Discord DMs,
but here you reach it **directly from a shell** — no Discord round-trip.

## The command

```bash
wsl -- bash -lc 'ask-hermes "your prompt here"'
```

`ask-hermes` wraps `hermes -z` (oneshot): it loads Hermes's tools, memory, rules,
SOUL.md persona, and any AGENTS.md in the CWD, auto-bypasses approvals, and prints
**only the final response text** to stdout. Wrapper lives at
`~/.local/bin/ask-hermes` in WSL (on the login PATH).

Check it's installed:

```bash
wsl -- bash -lc 'command -v ask-hermes'
```

## Long or tricky prompts → use a file (`-f`)

WSL invoked through Windows mangles `$`, backticks, parens, and nested quotes.
For anything beyond a short single-quoted sentence, **write the prompt to a temp
file and pass `-f`** — no escaping headaches:

1. `Write` the prompt to `C:\Users\YOU\AppData\Local\Temp\hermes-prompt.txt`
2. Run:

```bash
wsl -- bash -lc 'ask-hermes -f /mnt/c/Users/YOU/AppData/Local/Temp/hermes-prompt.txt'
```

(Windows `C:\...\Temp\x.txt` → WSL `/mnt/c/.../Temp/x.txt`.) Stdin also works:
`echo "..." | ask-hermes`.

## Gotchas (read before every call)

- **Quota.** Each call = one LLM turn billed to the operator's Claude Max. Don't spam;
  batch your question into one well-formed prompt.
- **Approvals are auto-bypassed — Hermes CAN act.** Be explicit about intent:
  - Info only → start the prompt with `Réponds seulement, n'agis pas :`
  - Action wanted → say plainly what to do (e.g. `Ajoute une tâche kanban : ...`).
- **No conversation thread.** Each call is independent (oneshot ignores
  `--continue`/`--resume`). But Hermes's **persistent** `memories/` + `kanban.db`
  load every time — that's the shared brain. Put needed context IN the prompt.
- **Never set `ANTHROPIC_API_KEY`.** It would make Hermes prune its OAuth credential
  and break the gateway. The wrapper unsets it defensively; just never pass one.
- **French.** Hermes + the operator operate in French; write prompts in French.

## When to use vs not

USE IT to: read what Hermes knows about the operator's projects/deadlines/objectives;
delegate a task; ask Hermes to log/remember something in its brain; avoid
redoing tracking work Hermes already owns.

DON'T USE IT for: trivia you can answer yourself, or work that needs none of
Hermes's brain — that just burns quota.

## Verify a fresh call (benign, read-only)

```bash
wsl -- bash -lc 'ask-hermes "Réponds juste OK pour tester le pont, n'"'"'agis pas."'
```

A persona-flavored short reply on stdout (no Discord) = bridge healthy.
