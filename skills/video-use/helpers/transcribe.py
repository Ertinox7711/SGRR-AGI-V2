"""Transcribe a video with ElevenLabs Scribe.

Extracts mono 16kHz audio via ffmpeg, uploads to Scribe with verbatim +
diarize + audio events + word-level timestamps, writes the full response
to <edit_dir>/transcripts/<video_stem>.json.

Cached: if the output file already exists, the upload is skipped.

Usage:
    python helpers/transcribe.py <video_path>
    python helpers/transcribe.py <video_path> --edit-dir /custom/edit
    python helpers/transcribe.py <video_path> --language en
    python helpers/transcribe.py <video_path> --num-speakers 2
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import tempfile
import time
from pathlib import Path

import requests


SCRIBE_URL = "https://api.elevenlabs.io/v1/speech-to-text"


def _load_dotenv() -> None:
    for candidate in [Path(__file__).resolve().parent.parent / ".env", Path(".env")]:
        if not candidate.exists():
            continue
        for line in candidate.read_text().splitlines():
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            k, v = line.split("=", 1)
            k = k.strip()
            v = v.strip().strip('"').strip("'")
            os.environ.setdefault(k, v)


_load_dotenv()


def load_api_key() -> str:
    for candidate in [Path(__file__).resolve().parent.parent / ".env", Path(".env")]:
        if candidate.exists():
            for line in candidate.read_text().splitlines():
                line = line.strip()
                if not line or line.startswith("#") or "=" not in line:
                    continue
                k, v = line.split("=", 1)
                if k.strip() == "ELEVENLABS_API_KEY":
                    return v.strip().strip('"').strip("'")
    v = os.environ.get("ELEVENLABS_API_KEY", "")
    if not v:
        sys.exit("ELEVENLABS_API_KEY not found in .env or environment")
    return v


def call_whisper_local(
    audio_path: Path,
    language: str | None = None,
    model_size: str = "large-v3",
    use_whisperx_align: bool = True,
) -> dict:
    """Transcribe locally with faster-whisper + optional WhisperX forced alignment.

    Returns Scribe-compatible JSON. WhisperX alignment (wav2vec2) gives
    ~50-100ms word timestamp precision vs ~200-500ms from raw whisper.
    """
    from faster_whisper import WhisperModel

    model = WhisperModel(
        model_size,
        device="cpu",
        compute_type="int8",
    )
    segments_gen, info = model.transcribe(
        str(audio_path),
        language=language,
        word_timestamps=True,
        vad_filter=True,
        vad_parameters={"min_silence_duration_ms": 200},
        beam_size=5,
        temperature=0.0,
    )
    segments = list(segments_gen)
    detected_lang = info.language

    aligned_words: list[dict] | None = None
    if use_whisperx_align:
        try:
            import whisperx

            wx_segments = [
                {"start": float(s.start), "end": float(s.end), "text": s.text}
                for s in segments
            ]
            align_model, meta = whisperx.load_align_model(
                language_code=detected_lang, device="cpu"
            )
            result = whisperx.align(
                wx_segments,
                align_model,
                meta,
                str(audio_path),
                device="cpu",
                return_char_alignments=False,
            )
            aligned_words = []
            for seg in result.get("segments", []):
                for w in seg.get("words", []):
                    if "start" not in w or "end" not in w:
                        continue
                    aligned_words.append({
                        "word": w.get("word", "").strip(),
                        "start": float(w["start"]),
                        "end": float(w["end"]),
                    })
        except Exception as e:
            print(f"  whisperx align skipped: {e}", flush=True)
            aligned_words = None

    words_out: list[dict] = []
    full_text_parts: list[str] = []
    prev_end: float | None = None

    if aligned_words:
        for w in aligned_words:
            txt = w["word"]
            if not txt:
                continue
            if prev_end is not None and w["start"] > prev_end + 0.01:
                words_out.append({
                    "type": "spacing",
                    "text": " ",
                    "start": prev_end,
                    "end": w["start"],
                })
            words_out.append({
                "type": "word",
                "text": txt,
                "start": w["start"],
                "end": w["end"],
                "speaker_id": "speaker_0",
            })
            full_text_parts.append(txt + " ")
            prev_end = w["end"]
    else:
        for seg in segments:
            if not seg.words:
                continue
            for w in seg.words:
                txt = w.word
                if prev_end is not None and w.start > prev_end + 0.01:
                    words_out.append({
                        "type": "spacing",
                        "text": " ",
                        "start": prev_end,
                        "end": w.start,
                    })
                words_out.append({
                    "type": "word",
                    "text": txt.strip(),
                    "start": float(w.start),
                    "end": float(w.end),
                    "speaker_id": "speaker_0",
                })
                full_text_parts.append(txt)
                prev_end = float(w.end)

    return {
        "language_code": detected_lang,
        "language_probability": float(info.language_probability),
        "text": "".join(full_text_parts).strip(),
        "words": words_out,
    }


def extract_audio(video_path: Path, dest: Path) -> None:
    cmd = [
        "ffmpeg", "-y", "-i", str(video_path),
        "-vn", "-ac", "1", "-ar", "16000", "-c:a", "pcm_s16le",
        str(dest),
    ]
    subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def call_scribe(
    audio_path: Path,
    api_key: str,
    language: str | None = None,
    num_speakers: int | None = None,
) -> dict:
    data: dict[str, str] = {
        "model_id": "scribe_v1",
        "diarize": "true",
        "tag_audio_events": "true",
        "timestamps_granularity": "word",
    }
    if language:
        data["language_code"] = language
    if num_speakers:
        data["num_speakers"] = str(num_speakers)

    with open(audio_path, "rb") as f:
        resp = requests.post(
            SCRIBE_URL,
            headers={"xi-api-key": api_key},
            files={"file": (audio_path.name, f, "audio/wav")},
            data=data,
            timeout=1800,
        )

    if resp.status_code != 200:
        raise RuntimeError(f"Scribe returned {resp.status_code}: {resp.text[:500]}")

    return resp.json()


def transcribe_one(
    video: Path,
    edit_dir: Path,
    api_key: str | None,
    language: str | None = None,
    num_speakers: int | None = None,
    verbose: bool = True,
    backend: str = "scribe",
    whisper_model: str = "base",
) -> Path:
    """Transcribe a single video. Returns path to transcript JSON.

    Cached: returns existing path immediately if the transcript already exists.
    """
    transcripts_dir = edit_dir / "transcripts"
    transcripts_dir.mkdir(parents=True, exist_ok=True)
    out_path = transcripts_dir / f"{video.stem}.json"

    if out_path.exists():
        if verbose:
            print(f"cached: {out_path.name}")
        return out_path

    if verbose:
        print(f"  extracting audio from {video.name}", flush=True)

    t0 = time.time()
    with tempfile.TemporaryDirectory() as tmp:
        audio = Path(tmp) / f"{video.stem}.wav"
        extract_audio(video, audio)
        size_mb = audio.stat().st_size / (1024 * 1024)
        if backend == "whisper":
            if verbose:
                print(f"  whisper-local ({whisper_model}) on {video.stem}.wav ({size_mb:.1f} MB)", flush=True)
            payload = call_whisper_local(audio, language, whisper_model)
        else:
            if verbose:
                print(f"  uploading {video.stem}.wav ({size_mb:.1f} MB)", flush=True)
            payload = call_scribe(audio, api_key, language, num_speakers)

    out_path.write_text(json.dumps(payload, indent=2))
    dt = time.time() - t0

    if verbose:
        kb = out_path.stat().st_size / 1024
        print(f"  saved: {out_path.name} ({kb:.1f} KB) in {dt:.1f}s")
        if isinstance(payload, dict) and "words" in payload:
            print(f"    words: {len(payload['words'])}")

    return out_path


def main() -> None:
    ap = argparse.ArgumentParser(description="Transcribe a video with ElevenLabs Scribe")
    ap.add_argument("video", type=Path, help="Path to video file")
    ap.add_argument(
        "--edit-dir",
        type=Path,
        default=None,
        help="Edit output directory (default: <video_parent>/edit)",
    )
    ap.add_argument(
        "--language",
        type=str,
        default=None,
        help="Optional ISO language code (e.g., 'en'). Omit to auto-detect.",
    )
    ap.add_argument(
        "--num-speakers",
        type=int,
        default=None,
        help="Optional number of speakers when known. Improves diarization accuracy.",
    )
    ap.add_argument(
        "--backend",
        choices=["scribe", "whisper"],
        default=os.environ.get("VIDEO_USE_BACKEND", "scribe"),
        help="Transcription backend (scribe=ElevenLabs API, whisper=local faster-whisper).",
    )
    ap.add_argument(
        "--whisper-model",
        default=os.environ.get("WHISPER_MODEL", "base"),
        help="faster-whisper model size: tiny, base, small, medium, large-v3.",
    )
    args = ap.parse_args()

    video = args.video.resolve()
    if not video.exists():
        sys.exit(f"video not found: {video}")

    edit_dir = (args.edit_dir or (video.parent / "edit")).resolve()
    api_key = None if args.backend == "whisper" else load_api_key()

    transcribe_one(
        video=video,
        edit_dir=edit_dir,
        api_key=api_key,
        language=args.language,
        num_speakers=args.num_speakers,
        backend=args.backend,
        whisper_model=args.whisper_model,
    )


if __name__ == "__main__":
    main()
