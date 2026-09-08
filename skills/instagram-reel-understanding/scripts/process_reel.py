#!/usr/bin/env python3
"""Process an Instagram reel: download, transcribe, extract key frames.

Usage:
    python process_reel.py <instagram_url> [--out DIR] [--model MODEL] [--frames N]

Outputs in --out (default: ./reel_output_<id>):
    video.mp4         downloaded reel
    audio.wav         extracted mono 16k audio
    transcript.txt    plain transcript
    transcript.json   segments with timestamps + detected language
    metadata.json     reel metadata (caption, uploader, duration, etc.)
    frames/000.jpg ... key frames (default 8 evenly-spaced)

Auto-installs faster-whisper on first run if missing.
Requires yt-dlp + ffmpeg on PATH (already shipped with the user's setup).
"""
from __future__ import annotations

import argparse
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path


def run(cmd: list[str], **kw) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, check=True, **kw)


def ensure_faster_whisper() -> None:
    try:
        import faster_whisper  # noqa: F401
        return
    except ImportError:
        pass
    print("[setup] installing faster-whisper (one-time, ~200MB incl deps)...", flush=True)
    run([sys.executable, "-m", "pip", "install", "--quiet", "faster-whisper"])


def reel_id_from_url(url: str) -> str:
    m = re.search(r"/(reel|p|tv)/([A-Za-z0-9_-]+)", url)
    return m.group(2) if m else "reel"


def download_reel(url: str, out_dir: Path) -> tuple[Path, dict]:
    out_dir.mkdir(parents=True, exist_ok=True)
    video_tpl = str(out_dir / "video.%(ext)s")
    info_path = out_dir / "info.json"
    run([
        "yt-dlp",
        "--no-warnings",
        "--write-info-json",
        "-o", video_tpl,
        "--merge-output-format", "mp4",
        url,
    ])
    video_exts = {".mp4", ".mkv", ".webm", ".mov", ".m4v", ".avi", ".flv"}
    candidates = [p for p in out_dir.glob("video.*") if p.suffix.lower() in video_exts]
    if not candidates:
        raise FileNotFoundError("yt-dlp produced no video file")
    video = next((p for p in candidates if p.suffix.lower() == ".mp4"), candidates[0])
    if video.suffix.lower() != ".mp4":
        mp4 = video.with_suffix(".mp4")
        run(["ffmpeg", "-y", "-i", str(video), "-c", "copy", str(mp4)])
        video.unlink()
        video = mp4
    info_files = list(out_dir.glob("video.info.json"))
    info: dict = {}
    if info_files:
        info = json.loads(info_files[0].read_text(encoding="utf-8"))
        info_files[0].rename(info_path)
    return video, info


def extract_audio(video: Path, out: Path) -> Path:
    audio = out / "audio.wav"
    run([
        "ffmpeg", "-y", "-i", str(video),
        "-ac", "1", "-ar", "16000", "-vn",
        str(audio),
    ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return audio


def extract_frames(video: Path, out: Path, n: int, duration: float) -> list[Path]:
    frames_dir = out / "frames"
    frames_dir.mkdir(exist_ok=True)
    if duration <= 0 or n <= 0:
        return []
    step = max(duration / (n + 1), 0.5)
    frames: list[Path] = []
    for i in range(n):
        t = step * (i + 1)
        path = frames_dir / f"{i:03d}.jpg"
        run([
            "ffmpeg", "-y", "-ss", f"{t:.2f}", "-i", str(video),
            "-frames:v", "1", "-q:v", "3", str(path),
        ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        frames.append(path)
    return frames


def transcribe(audio: Path, model_size: str) -> dict:
    from faster_whisper import WhisperModel
    print(f"[whisper] loading model={model_size} (first run downloads weights)...", flush=True)
    model = WhisperModel(model_size, device="cpu", compute_type="int8")
    segments_iter, info = model.transcribe(str(audio), beam_size=1, vad_filter=True)
    segments = []
    full_text_parts = []
    for seg in segments_iter:
        segments.append({
            "start": round(seg.start, 2),
            "end": round(seg.end, 2),
            "text": seg.text.strip(),
        })
        full_text_parts.append(seg.text.strip())
    return {
        "language": info.language,
        "language_probability": round(info.language_probability, 3),
        "duration": round(info.duration, 2),
        "text": " ".join(full_text_parts).strip(),
        "segments": segments,
    }


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("url")
    p.add_argument("--out", default=None, help="output directory (default ./reel_output_<id>)")
    p.add_argument("--model", default="small", help="faster-whisper size: tiny/base/small/medium/large-v3")
    p.add_argument("--frames", type=int, default=8, help="number of key frames to extract (0 to skip)")
    p.add_argument("--skip-frames", action="store_true", help="alias for --frames 0")
    args = p.parse_args()

    if not shutil.which("yt-dlp"):
        print("ERROR: yt-dlp not on PATH", file=sys.stderr)
        return 1
    if not shutil.which("ffmpeg"):
        print("ERROR: ffmpeg not on PATH", file=sys.stderr)
        return 1

    ensure_faster_whisper()

    rid = reel_id_from_url(args.url)
    out = Path(args.out) if args.out else Path.cwd() / f"reel_output_{rid}"
    out.mkdir(parents=True, exist_ok=True)

    print(f"[1/4] downloading {args.url}", flush=True)
    video, info = download_reel(args.url, out)

    duration = float(info.get("duration") or 0)
    print(f"[2/4] extracting audio (duration={duration}s)", flush=True)
    audio = extract_audio(video, out)

    n_frames = 0 if args.skip_frames else args.frames
    print(f"[3/4] extracting {n_frames} key frames", flush=True)
    frames = extract_frames(video, out, n_frames, duration or 30.0)

    print("[4/4] transcribing", flush=True)
    tr = transcribe(audio, args.model)

    (out / "transcript.txt").write_text(tr["text"], encoding="utf-8")
    (out / "transcript.json").write_text(json.dumps(tr, ensure_ascii=False, indent=2), encoding="utf-8")

    meta = {
        "url": args.url,
        "reel_id": rid,
        "uploader": info.get("uploader") or info.get("channel"),
        "uploader_id": info.get("uploader_id"),
        "title": info.get("title"),
        "description": info.get("description"),
        "duration": duration,
        "view_count": info.get("view_count"),
        "like_count": info.get("like_count"),
        "comment_count": info.get("comment_count"),
        "upload_date": info.get("upload_date"),
        "thumbnail": info.get("thumbnail"),
        "language_detected": tr["language"],
        "language_probability": tr["language_probability"],
        "frames": [str(f.relative_to(out)) for f in frames],
        "files": {
            "video": str(video.relative_to(out)),
            "audio": str(audio.relative_to(out)),
            "transcript_txt": "transcript.txt",
            "transcript_json": "transcript.json",
        },
    }
    (out / "metadata.json").write_text(json.dumps(meta, ensure_ascii=False, indent=2), encoding="utf-8")

    print(f"\nDONE. Output dir: {out}")
    print(f"  language: {tr['language']} (p={tr['language_probability']})")
    print(f"  transcript chars: {len(tr['text'])}")
    print(f"  frames: {len(frames)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
