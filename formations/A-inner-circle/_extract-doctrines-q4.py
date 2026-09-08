#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Extract Arthur's Q4 / product-research doctrines from the July-2026 live transcripts.

Reads every .md in lives-recherche-produit-2026-07/, isolates the timestamped
transcript, and pulls the passages that carry an actionable rule: Q4 framing,
numeric gates, product names cited, ads doctrine, kill-criteria.
Writes DOCTRINES-Q4.md (grouped, with timestamps) so every later claim can cite a source.
"""
import io, os, re, sys, glob, json
sys.stdout.reconfigure(encoding='utf-8')

ROOT = r'C:\Users\maths\Documents\Ecom-Inner-Circle\lives-recherche-produit-2026-07'
OUT = os.path.join(ROOT, 'DOCTRINES-Q4.md')

# theme -> regex. Ordered: a line lands in the first theme it matches.
THEMES = [
    ('Q4 / calendrier / saisonnalite',
     r"\bq4\b|quatri[eè]me trimestre|no[eë]l|black friday|cyber monday|f[eê]tes|cadeau|gifting|saison|septembre|octobre|novembre|d[eé]cembre|janvier"),
    ('Gates chiffres (marge, volume, CPC, CPA, prix)',
     r"\b\d+\s?%|\bmarge\b|\bcpc\b|\bcpa\b|\broas\b|\bpanier\b|\d+\s?(?:euros?|balles|k)\b|volume|recherches? par mois|\bmoq\b"),
    ('Criteres de selection / kill-criteria',
     r"crit[eè]re|valid|\bgate\b|[eé]cart|jette|poubelle|c'est mort|[eé]viter|jamais|surtout pas|red flag|institutionnel|marque gagnera"),
    ('Methodes de recherche / sources',
     r"flippa|amazon|movers|shakers|vevor|bigbuy|big buy|europages|pinterest|temu|dotmarket|cdiscount|alibaba|aliexpress|keyword planner|transparency"),
    ('Google Ads / structure de campagne',
     r"google ads|\bsearch\b|shopping|\bpmax\b|performance max|ench[eè]re|mot[- ]cl[eé]|requ[eê]te|campagne|\bgmc\b|merchant center|budget|\bcpc\b"),
    ('Marche / pays',
     r"\buk\b|angleterre|royaume|\bus\b|am[eé]ricain|[eé]tats[- ]unis|allemagne|\bde\b\b|suisse|canada|march[eé]"),
    ('Produits nommes / exemples concrets',
     r"remontoir|winder|panneau|parquet|pergola|brasero|sauna|jacuzzi|spa|matelas|canap[eé]|fauteuil|v[eé]lo|trampoline|piscine|barbecue|plancha|humidificateur|purificateur|projecteur|cave [aà] vin|machine [aà] caf[eé]"),
]

TS = re.compile(r'^\[(\d{2}:\d{2}:\d{2})\]\s*(.+)$')
# a passage only matters if it states a rule, not just chatter.
# deliberately NOT matching a bare digit: numbers alone catch every sentence.
SIGNAL = re.compile(
    r"il faut|faut que|faut pas|tu dois|vous devez|je conseille|mon conseil|la r[eè]gle|r[eè]gle num|"
    r"l'id[eé]e c'est|le truc c'est|ce qui marche|ce qui compte|le probl[eè]me c'est|"
    r"attention|surtout pas|jamais|toujours|"
    r"minimum|maximum|au moins|moins de \d|plus de \d|au[- ]del[aà] de \d|en dessous de \d|"
    r"c'est mort|c'est non|[eé]vitez?|[eé]cartez?|jetez?|"
    r"par exemple|typiquement|"
    r"\d+\s?%|\d+\s?(?:euros?|balles|k\b|000)", re.I)

# two header dialects exist: pipeline.py writes "## Transcript (français, horodaté)",
# _transcribe-lives-q4.py writes "## Transcript horodaté". Accept both.
H_TS = re.compile(r'^##\s*Transcript\s*(?:\(fran[cç]ais,\s*)?horodat', re.I | re.M)
H_PLAIN = re.compile(r'^##\s*Transcript\s*(?:\(texte\s*)?continu', re.I | re.M)

def load(fp):
    txt = io.open(fp, encoding='utf-8').read()
    m = H_TS.search(txt)
    if not m:
        return []
    body = txt[m.end():]
    m2 = H_PLAIN.search(body)
    if m2:
        body = body[:m2.start()]
    out = []
    for line in body.splitlines():
        m = TS.match(line.strip())
        if m:
            out.append((m.group(1), m.group(2).strip()))
    return out

def theme_of(s):
    for name, pat in THEMES:
        if re.search(pat, s, re.I):
            return name
    return None

def main():
    files = sorted(glob.glob(os.path.join(ROOT, '*.md')))
    files = [f for f in files if not os.path.basename(f).startswith(('README', 'DOCTRINES'))]
    if not files:
        print('no transcript yet in', ROOT); return

    chunks = []   # (theme, live, ts, text)
    stats = {}
    for fp in files:
        live = os.path.basename(fp).replace('.md', '')
        segs = load(fp)
        stats[live] = {'segments': len(segs), 'retenus': 0}
        # merge into ~3-sentence windows so a rule split over segments stays readable
        i = 0
        while i < len(segs):
            ts, _ = segs[i]
            win = ' '.join(s[1] for s in segs[i:i + 4])
            th = theme_of(win)
            if th and SIGNAL.search(win) and len(win) > 90:
                chunks.append((th, live, ts, re.sub(r'\s+', ' ', win).strip()))
                stats[live]['retenus'] += 1
            i += 4

    lines = ['# Doctrines Arthur — lives « recherche produit » de juillet 2026', '',
             'Extraction automatique des passages porteurs de règle, groupés par thème, horodatés.',
             'Chaque citation renvoie au transcript complet du live correspondant dans ce dossier.', '',
             '| Live | Segments | Passages retenus |', '|---|---|---|']
    for k, v in stats.items():
        lines.append(f"| {k} | {v['segments']} | {v['retenus']} |")
    lines.append('')

    for name, _ in THEMES:
        sel = [c for c in chunks if c[0] == name]
        if not sel:
            continue
        lines.append(f'## {name}  ({len(sel)} passages)')
        lines.append('')
        for _, live, ts, txt in sel:
            lines.append(f'- **[{ts}]** *({live})* — {txt}')
        lines.append('')

    io.open(OUT, 'w', encoding='utf-8').write('\n'.join(lines) + '\n')
    print('wrote', OUT)
    for name, _ in THEMES:
        n = len([c for c in chunks if c[0] == name])
        print(f'  {name}: {n}')

if __name__ == '__main__':
    main()
