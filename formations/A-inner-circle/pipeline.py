#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Download Skool Ecom Inner Circle audio + transcribe FR (Whisper large-v3).
Organizes one folder per module, one .md per episode. Resumable."""
import json, os, re, sys, subprocess, time, glob

ROOT = os.path.dirname(os.path.abspath(__file__))
MANIFEST = os.path.join(ROOT, 'ecom_tokens.json')
TMP = os.path.join(ROOT, '_audio')
os.makedirs(TMP, exist_ok=True)

# --- make CUDA DLLs (from nvidia pip pkgs) discoverable for ctranslate2 ---
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
        print('nvidia dll setup skipped:', e)
add_nvidia_dlls()

UA = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36'

def slug(s, n=70):
    s = (s or '').strip()
    s = s.replace('/', '-').replace('\\', '-').replace(':', ' -')
    s = re.sub(r'[<>"|?*\n\r\t]', '', s)
    s = re.sub(r'\s+', ' ', s).strip()
    return s[:n].strip()

def download_audio(playback_id, token, out_base):
    url = f"https://stream.video.skool.com/{playback_id}.m3u8?token={token}"
    mp3 = out_base + '.mp3'
    if os.path.exists(mp3) and os.path.getsize(mp3) > 1000:
        return mp3
    for f in glob.glob(out_base + '.*'):
        try: os.remove(f)
        except: pass
    r = subprocess.run([
        'yt-dlp', '--referer', 'https://www.skool.com/', '--add-header',
        'Origin:https://www.skool.com', '--user-agent', UA,
        '-f', 'bestaudio/best', '-x', '--audio-format', 'mp3',
        '--no-progress', '-o', out_base + '.%(ext)s', url
    ], capture_output=True, text=True)
    if r.returncode != 0 or not os.path.exists(mp3):
        raise RuntimeError('yt-dlp failed: ' + r.stderr[-400:])
    return mp3

def main():
    data = json.load(open(MANIFEST, encoding='utf-8'))
    from faster_whisper import WhisperModel
    dev, ct = 'cuda', 'float16'
    try:
        model = WhisperModel('large-v3', device='cuda', compute_type='float16')
    except Exception as e:
        print('CUDA unavailable, CPU fallback:', str(e)[:200])
        model = WhisperModel('large-v3', device='cpu', compute_type='int8'); dev, ct = 'cpu', 'int8'
    print(f'== model large-v3 on {dev}/{ct} ==', flush=True)

    total = sum(len(v) for v in data.values())
    n = 0
    for module, lessons in data.items():
        mo = lessons[0]['moduleOrder'] if lessons else 0
        mdir = os.path.join(ROOT, f"{mo:02d} - {slug(module,50)}")
        os.makedirs(mdir, exist_ok=True)
        for L in lessons:
            n += 1
            tag = f"[{n}/{total}] {module} / {L['title']}"
            fname = f"{L['order']:02d} - {slug(L['title'])}.md"
            fpath = os.path.join(mdir, fname)
            if os.path.exists(fpath) and os.path.getsize(fpath) > 200:
                print('SKIP (done):', tag, flush=True); continue
            if not L.get('hasVideo'):
                open(fpath, 'w', encoding='utf-8').write(
                    f"# {L['title']}\n\n- Module: {module}\n- Section: {L.get('section')}\n"
                    f"- Épisode: {L['order']}\n\n_Pas de vidéo dans cette leçon (contenu texte/ressource uniquement)._\n")
                print('NO-VIDEO stub:', tag, flush=True); continue
            try:
                t0 = time.time()
                base = os.path.join(TMP, L['playbackId'])
                mp3 = download_audio(L['playbackId'], L['playbackToken'], base)
                segs, info = model.transcribe(mp3, language='fr', vad_filter=True, beam_size=5)
                lines, plain = [], []
                for s in segs:
                    ts = time.strftime('%H:%M:%S', time.gmtime(s.start))
                    lines.append(f"[{ts}] {s.text.strip()}")
                    plain.append(s.text.strip())
                dur = info.duration
                body = (
                    f"# {L['title']}\n\n"
                    f"- **Module:** {module} (#{mo})\n"
                    f"- **Section:** {L.get('section')}\n"
                    f"- **Épisode:** {L['order']}\n"
                    f"- **Durée:** {time.strftime('%H:%M:%S', time.gmtime(dur))}\n"
                    f"- **videoId:** `{L['videoId']}`\n\n"
                    f"## Transcript (français, horodaté)\n\n" + '\n'.join(lines) +
                    f"\n\n## Transcript (texte continu)\n\n" + ' '.join(plain) + "\n")
                open(fpath, 'w', encoding='utf-8').write(body)
                try: os.remove(mp3)
                except: pass
                print(f"OK {tag}  ({dur:.0f}s audio, {time.time()-t0:.0f}s proc)", flush=True)
            except Exception as e:
                print(f"FAIL {tag}: {str(e)[:300]}", flush=True)
                open(fpath + '.error', 'w', encoding='utf-8').write(str(e))
    print('== DONE ==', flush=True)

if __name__ == '__main__':
    main()
