---
paths:
  - "**/Documents/HERMES/**"
---

# Hermes — NeverGiveUp Personal AI Assistant

## Architecture
- Hermes Agent (Nous Research) running in **WSL Ubuntu-22.04**
- LLM: **claude-sonnet-4-6** via **OAuth Max** (the operator's Claude Max subscription)
- Discord DM bridge: @<BOT>, guild <GUILD> (ID <DISCORD_ID>)
- Channel #<AGENT_CHANNEL_OLD> (ID <DISCORD_ID>) for Claude Code ↔ Hermes comms

## Bridges (from Windows PowerShell/Claude Code)
```bash
# 1 LLM turn = 1 Max quota — batch, don't spam
wsl -- bash -lc 'ask-hermes "prompt here"'

# Long prompts or special chars ($, backticks) → always use file
# Write to C:\Users\YOU\AppData\Local\Temp\hermes-prompt.txt first
wsl -- bash -lc 'ask-hermes -f /mnt/c/Users/YOU/AppData/Local/Temp/hermes-prompt.txt'

# Discord post only (no LLM, async)
wsl -- bash -lc 'tell-hermes "message"'
wsl -- bash -lc 'tell-hermes --dm "DM to the operator"'
wsl -- bash -lc 'ask-hermes --quiet-discord "prompt"'  # skip Discord notification
```

## CRITICAL: ANTHROPIC_API_KEY must stay UNSET in WSL
Its presence kills the OAuth token. Wrappers auto-`unset` it — never export it to WSL env.

## Key files
- `config.yaml` — model config, provider = auto (OAuth Max when no API key)
- `SOUL.md` — NeverGiveUp personality + instructions
- `USER.md` — the operator's profile (preferences, style)
- `MEMORY.md` — persistent notes on projects + environment
- `NGU_Dashboard.html` — project tracking dashboard
- `state/` — history.jsonl, brain.json, progress.json

## Projects tracked by Hermes (source of truth)
Hermes keeps the ranked project list in its own `MEMORY.md` / kanban — ask it (`ask-hermes "liste mes projets par priorite"`) instead of hardcoding a copy here that goes stale.

## Rules
- Each `ask-hermes` call = 1 quota turn. Batch questions, never loop-spam.
- Hermes knows all project memories/kanban — delegate tracking tasks there.
- `tell-hermes` for fire-and-forget Discord notifications (no quota).
