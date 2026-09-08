---
name: instagram-reel-understanding
description: Download an Instagram reel/post/IGTV and produce a full understanding (transcript with timestamps, detected language, key visual frames, caption + author + engagement metadata) so the user can ask follow-up questions about it. Trigger this skill the moment the user pastes ANY instagram.com link (`/reel/`, `/p/`, `/reels/`, `/tv/`), drops an Instagram URL with no instructions, says things like "regarde ce reel", "what does this reel say", "comprends ce reel", "transcribe this", "résume ce reel", "extract the hook from this reel", or asks for the script / hooks / message of an Instagram video. Use it even if the user does not explicitly say "transcribe" — if there is an Instagram link, run the skill so you actually know the content before answering. Do not guess what the reel contains from the URL.
---

# Instagram Reel Understanding

Goal: turn an Instagram URL into something you can reason about — full transcript (any language), key frames you can look at, and post metadata. After processing, hold all of it in context and wait for what the user wants to do with it (résumé, hooks, traduction, copy adaptation, fact-check, etc.).

## When to run

Run as soon as you see an `instagram.com/...` URL in the user's message, OR when the user refers to an Instagram reel they just sent. If the user pastes several URLs, process them one after another (or in parallel if you have subagents and they're independent). Do not ask "voulez-vous que je le télécharge?" — that's the whole point of the skill, just do it.

Skip only if the user explicitly says "ne télécharge pas" / "don't fetch it".

## How to run

Use the bundled script. It handles download, audio extraction, frame sampling, and Whisper transcription end-to-end. Use Python 3.11 — faster-whisper has prebuilt wheels there; Python 3.14 may fail to install.

```powershell
& "C:\Users\YOU\AppData\Local\Programs\Python\Python311\python.exe" `
  "C:\Users\YOU\.claude\skills\instagram-reel-understanding\scripts\process_reel.py" `
  "<INSTAGRAM_URL>"
```

Defaults: model `small` (good multilingual quality, ~500MB one-time download), 8 key frames, output dir `./reel_output_<id>` in the current working directory.

Useful overrides:
- `--model tiny` → fastest, lower quality. Use for very short reels or when the user wants speed.
- `--model medium` or `--model large-v3` → better quality, slower. Use when transcript fidelity really matters (legal, fact-check, careful translation).
- `--frames 0` (or `--skip-frames`) → audio-only, much faster. Use when the user only cares about what is *said*.
- `--frames 16` → denser visual sampling for reels where the visual changes a lot.
- `--out <dir>` → control where files land.

First run on a fresh machine will:
1. `pip install faster-whisper` (auto, ~200MB),
2. download the Whisper model weights (cached under `~/.cache/huggingface/`).
Both are one-time. Tell the user briefly so the wait isn't surprising.

## What the script outputs

Inside the output directory:

| File | What it is |
|---|---|
| `video.mp4` | the downloaded reel |
| `audio.wav` | mono 16kHz, fed to Whisper |
| `transcript.txt` | plain transcript, one big block |
| `transcript.json` | segments with `start`/`end`/`text` + detected language + language probability |
| `metadata.json` | url, uploader, caption, duration, view/like/comment counts, upload date, thumbnail, paths to all artifacts |
| `frames/000.jpg` … | evenly-spaced key frames |

## What to do after the script finishes

Read everything and synthesize before responding. Concretely:

1. **Read `metadata.json`** with the `Read` tool — gives you the caption, uploader, duration, language detected.
2. **Read `transcript.txt`** — that's the spoken content.
3. **Read every frame in `frames/`** with the `Read` tool — Read accepts images and you'll see them. This is how you understand on-screen text, products shown, slides, hand gestures, location, faces visible, anything visual the audio doesn't carry. Without this step you only know what was *said*, not what was *shown*.
4. Optionally skim `transcript.json` if the user might ask about timing ("at what second does he say X").

Then write a short synthesis for the user — match the language the user is writing in (often French here):
- Author + duration + detected language
- 1-line gist of what the reel is about
- 3–6 bullet key points (what is said + what is shown if relevant)
- Stand-out lines (hook / punchline / CTA) quoted verbatim if useful

End the synthesis with an open invitation like "Dis-moi ce que tu veux en faire" so the user can pivot to whatever they need next (résumé long, traduction, adaptation copy, script remake, fact-check…). Don't preemptively dump every possible analysis — keep the first response readable.

## Working memory

Keep the output directory path in mind for the rest of the conversation. If the user follows up with "extrait les hooks", "donne-moi le script mot pour mot", "traduis en anglais", "que dit-il à 0:42", you should re-read `transcript.json` or the frames instead of re-running the script. Re-run only if it's a new URL, or the user explicitly asks for higher quality (`--model medium`/`large-v3`) or more frames.

## Failure modes and what to do

- **`yt-dlp` says the post is private / login required** → the reel is from a private account. Tell the user — they need to either give you a public URL, or set up `yt-dlp` cookies (`yt-dlp --cookies-from-browser chrome <url>`). Don't try to bypass.
- **`yt-dlp` says rate-limited / 429** → wait a moment, retry once. If it persists, mention it; offer to retry later.
- **Audio is music only / no speech** → Whisper returns near-empty text and a low language probability. That's fine — say so, lean entirely on the frames + caption to describe the reel.
- **Reel is very long (IGTV)** → warn the user before running with `--model small` if it's >5 min; suggest `--model tiny` or audio-only.
- **`pip install faster-whisper` fails on Python 3.14** → fall back to `C:\Python314\python.exe` only if 3.11 path doesn't exist; otherwise stick with 3.11 which has wheels.

## Privacy

The downloaded video sits on disk in the output directory. Don't upload it anywhere, don't share frames externally, don't post the transcript to third-party services. Treat it as the user's local material.
