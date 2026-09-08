#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Cut a live transcript into ~10-minute chunks so reader agents can each read one whole file.

Usage: python _slice-live.py "<fichier .md du live>" [segments-par-chunk]
Writes _chunks-<slug>/chunkNN_<from>-<to>.md + _index.json, prints the index.
"""
import io, os, re, sys, json, glob
sys.stdout.reconfigure(encoding='utf-8')

ROOT = r'C:\Users\maths\Documents\Ecom-Inner-Circle'
LIVES = os.path.join(ROOT, 'lives-recherche-produit-2026-07')

H_TS = re.compile(r'^##\s*Transcript\s*(?:\(fran[cç]ais,\s*)?horodat.*$', re.I | re.M)
H_PLAIN = re.compile(r'^##\s*Transcript\s*(?:\(texte\s*)?continu', re.I | re.M)


def segments(fp):
    txt = io.open(fp, encoding='utf-8').read()
    m = H_TS.search(txt)
    if not m:
        raise SystemExit('pas de header transcript horodate dans ' + fp)
    body = txt[m.end():]
    m2 = H_PLAIN.search(body)
    if m2:
        body = body[:m2.start()]
    return [l for l in body.splitlines() if l.strip().startswith('[')]


def slug(name):
    m = re.match(r'(\d{4}-\d{2}-\d{2})', name)
    return m.group(1) if m else re.sub(r'[^a-z0-9]+', '-', name.lower())[:20]


def main():
    if len(sys.argv) < 2:
        for f in sorted(glob.glob(os.path.join(LIVES, '2026-*.md'))):
            print(os.path.basename(f))
        raise SystemExit('donne un fichier')
    fp = sys.argv[1]
    if not os.path.isabs(fp):
        fp = os.path.join(LIVES, fp)
    per = int(sys.argv[2]) if len(sys.argv) > 2 else 600

    segs = segments(fp)
    sl = slug(os.path.basename(fp))
    out = os.path.join(ROOT, '_chunks-' + sl)
    os.makedirs(out, exist_ok=True)
    title = os.path.basename(fp).replace('.md', '')

    idx = []
    n = (len(segs) + per - 1) // per
    for i in range(n):
        part = segs[i * per:(i + 1) * per]
        if not part:
            break
        t0, t1 = part[0][1:9], part[-1][1:9]
        f = os.path.join(out, 'chunk%02d_%s-%s.md' % (i + 1, t0.replace(':', ''), t1.replace(':', '')))
        io.open(f, 'w', encoding='utf-8').write(
            '# %s - segment %d/%d : %s -> %s\n\n' % (title, i + 1, n, t0, t1) + '\n'.join(part) + '\n')
        idx.append({'file': os.path.abspath(f), 'name': os.path.basename(f), 'from': t0, 'to': t1, 'segs': len(part)})
        print(os.path.basename(f), len(part), t0, '->', t1, os.path.getsize(f), 'bytes')

    io.open(os.path.join(out, '_index.json'), 'w', encoding='utf-8').write(
        json.dumps({'live': title, 'dir': os.path.abspath(out), 'segments': len(segs), 'chunks': idx},
                   ensure_ascii=False, indent=1))
    print('total', len(segs), 'segments ->', n, 'chunks in', out)


if __name__ == '__main__':
    main()
