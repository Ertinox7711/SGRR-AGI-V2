---
paths:
  - "**/SGRR JARVIS BOT/**"
---

# SGRR JARVIS BOT — Local J.A.R.V.I.S. Voice Assistant

## What it is
Local Iron Man-style voice assistant: French voice (Kokoro, 100% local), arc-reactor HUD
(pywebview desktop app), STT (faster-whisper `small`), brain = Claude Haiku via OAuth Max.

## Stack
- **Python 3.13** (not 3.14 — PyAudio/webrtcvad no cp314 wheels yet)
- `uv` for dependency isolation (`.venv/`)
- `jarvis` package in `jarvis/` (app.py, brain.py, ears.py, voice.py, etc.)
- `pywebview` → native desktop HUD window (not browser tab)
- `openWakeWord` → neural "Hey Jarvis" wake word (no API key)
- Optional: Google Calendar + Gmail via MCP (`google` extras)

## Run
```powershell
.\start-jarvis.ps1          # preferred — opens HUD + voice core
start-jarvis.bat            # double-click alternative
# or: .venv\Scripts\activate && jarvis
```

## Setup (one-shot)
```powershell
powershell -ExecutionPolicy Bypass -File scripts\setup.ps1
# Then: claude setup-token  (paste CLAUDE_CODE_OAUTH_TOKEN into .env)
# Keep ANTHROPIC_API_KEY unset — SGRR strips it if both present
```

## Key modules
- `jarvis/brain.py` — Claude Haiku calls (OAuth, no API key)
- `jarvis/ears.py` — STT (faster-whisper, `min(8,cores)` threads, `JARVIS_STT_THREADS`)
- `jarvis/voice.py` — Kokoro local TTS
- `jarvis/delegate.py` — heavy tasks → Hermes WSL (`ask-hermes`)
- `data/settings.json` — runtime settings (assistant name, mode, trigger phrase)
- `hud/` — arc-reactor HUD frontend

## Rules
- Listening modes: **auto** (default, always-on), **trigger** (phrase prefix), **wake** (neural)
- Settings editable live in HUD (⚙ icon) except wake mode → needs restart
- `ANTHROPIC_API_KEY` must stay unset — OAuth Max only
- Heavy/background tasks → delegate to Hermes (`ask-hermes`), not inline LLM calls
- Safe-by-design: no destructive actions without confirmation; whitelist-only action set
