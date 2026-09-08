#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Download + transcribe the 3 July-2026 'recherche produit' Skool lives (FR, Whisper large-v3)."""
import json, os, re, sys, subprocess, time, glob
sys.stdout.reconfigure(encoding='utf-8')

ROOT = r'C:\Users\maths\Documents\Ecom-Inner-Circle'
OUT = os.path.join(ROOT, 'lives-recherche-produit-2026-07')
TMP = os.path.join(ROOT, '_audio')
TOK = sys.argv[1] if len(sys.argv) > 1 else r'C:\Users\maths\Downloads\skool_lives_q4_tokens.json'
os.makedirs(OUT, exist_ok=True); os.makedirs(TMP, exist_ok=True)

def add_nvidia_dlls():
    try:
        import nvidia
        base = list(nvidia.__path__)[0]
        for sub in ('cublas/bin', 'cudnn/bin'):
            p = os.path.join(base, *sub.split('/'))
            if os.path.isdir(p):
                os.add_dll_directory(p)
                os.environ['PATH'] = p + os.pathsep + os.environ.get('PATH', '')
    except Exception as e:
        print('nvidia dll setup skipped:', e, flush=True)
add_nvidia_dlls()

UA = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36'

def download_audio(pid, tok, base):
    mp3 = base + '.mp3'
    if os.path.exists(mp3) and os.path.getsize(mp3) > 100000:
        print('   audio already there', flush=True); return mp3
    for f in glob.glob(base + '.*'):
        try: os.remove(f)
        except: pass
    url = f"https://stream.video.skool.com/{pid}.m3u8?token={tok}"
    r = subprocess.run(['yt-dlp', '--referer', 'https://www.skool.com/', '--add-header',
        'Origin:https://www.skool.com', '--user-agent', UA, '-f', 'bestaudio/best',
        '-x', '--audio-format', 'mp3', '--no-progress', '-o', base + '.%(ext)s', url],
        capture_output=True, text=True, encoding='utf-8', errors='replace')
    if r.returncode != 0 or not os.path.exists(mp3):
        raise RuntimeError('yt-dlp failed: ' + (r.stderr or '')[-600:])
    return mp3

lives = json.load(open(TOK, encoding='utf-8'))
print(f'== {len(lives)} lives ==', flush=True)

# 1. download all audio first (fast, tokens expire in ~30h)
for L in lives:
    if L.get('error'): print('SKIP (no token):', L['slug']); continue
    print(f"DL {L['slug']}", flush=True)
    t0 = time.time()
    try:
        L['mp3'] = download_audio(L['playbackId'], L['playbackToken'], os.path.join(TMP, L['playbackId']))
        print(f"   OK {os.path.getsize(L['mp3'])/1e6:.1f} MB in {time.time()-t0:.0f}s", flush=True)
    except Exception as e:
        L['dlerr'] = str(e)[:600]; print('   FAIL', L['dlerr'], flush=True)

# 2. transcribe
from faster_whisper import WhisperModel
try:
    model = WhisperModel('large-v3', device='cuda', compute_type='float16'); dev='cuda/fp16'
except Exception as e:
    print('CUDA unavailable ->CPU:', str(e)[:200], flush=True)
    model = WhisperModel('large-v3', device='cpu', compute_type='int8'); dev='cpu/int8'
print(f'== large-v3 on {dev} ==', flush=True)

def fname(L):
    d = (L.get('created') or '')[:10]
    s = re.sub(r'[<>:"/\\|?*]', '', L.get('title') or L['slug']).strip()
    return f"{d} - {s[:70]}.md"

for L in lives:
    if not L.get('mp3'): continue
    fp = os.path.join(OUT, fname(L))
    if os.path.exists(fp) and os.path.getsize(fp) > 2000:
        print('SKIP (done):', fp, flush=True); continue
    print(f"TRANSCRIBE {L['slug']}", flush=True)
    t0 = time.time()
    segs, info = model.transcribe(L['mp3'], language='fr', vad_filter=True, beam_size=5)
    lines, plain = [], []
    for s in segs:
        ts = time.strftime('%H:%M:%S', time.gmtime(s.start))
        lines.append(f"[{ts}] {s.text.strip()}")
        plain.append(s.text.strip())
        if len(lines) % 200 == 0:
            print(f"   ... {len(lines)} segs, t={s.start:.0f}s", flush=True)
    body = (f"# {L.get('title')}\n\n"
            f"- **Source:** https://www.skool.com/ecom-inner-circle/{L['slug']}\n"
            f"- **Publié:** {L.get('created')}\n"
            f"- **Durée:** {time.strftime('%H:%M:%S', time.gmtime(info.duration))}\n"
            f"- **videoId:** `{L.get('videoId')}`\n"
            f"- **Transcription:** Whisper large-v3 ({dev}), français\n\n"
            f"## Transcript horodaté\n\n" + '\n'.join(lines) +
            f"\n\n## Transcript continu\n\n" + ' '.join(plain) + "\n")
    open(fp, 'w', encoding='utf-8').write(body)
    print(f"OK {fp} ({info.duration:.0f}s audio, {time.time()-t0:.0f}s proc, {len(lines)} segs)", flush=True)

print('== DONE ==', flush=True)
