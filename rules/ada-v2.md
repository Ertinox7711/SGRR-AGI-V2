---
paths:
  - "**/Documents/ada_v2/**"
---

# A.D.A V2 — Advanced Design Assistant

## What it is
Electron + React desktop app. Multimodal AI assistant: low-latency voice (Gemini 2.5 Native Audio),
gesture control (MediaPipe), 3D CAD generation from voice prompts (build123d → STL).

## Stack
- **Electron 28** + **React 18** + **Vite** + **Tailwind**
- **Google Gemini 2.5 Native Audio** (real-time voice, NOT Claude)
- **MediaPipe** (@mediapipe/tasks-vision) — hand gesture recognition
- **Three.js** (@react-three/fiber + drei) — 3D visualization
- **Python** backend — `build123d` for parametric CAD, `check_cuda.py`, face recognition
- `framer-motion` for animations

## Run
```powershell
npm run dev    # Vite dev server + Electron (concurrently)
npm start      # Electron production
npm run build  # Vite build
```

## Key files / dirs
- `electron/main.js` — Electron main process
- `src/` — React app (App.jsx, components/)
- `backend/` — Python services (CAD, face rec, gesture)
- `requirements.txt` — Python deps
- `public/` — static assets

## Rules
- AI provider = **Google Gemini** (not Anthropic/Claude) — don't add Claude SDK here
- Python ≥3.10, <3.14 (check cuda: `python check_cuda.py`)
- GEMINI_API_KEY in `.env` — never hardcode
- CAD output = STL files via build123d; temp files in `temp_cad_gen.py`
