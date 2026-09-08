#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Tableau des entites nommees par Arthur dans les 3 lives de juillet 2026 -> HTML + PDF.

Le classement (piste produit / niche / lot de concours / service / outil / concurrent) vient de
_cls-175.json, produit par le workflow de reclassement qui lit le VERDICT de chaque entree.
Un tri par mots-cles sur le NOM se trompe : AirPods Pro est un lot de son concours interne,
pas une piste produit ; le done-for-you GMC a 2500 est une prestation ; Argon Audio un concurrent.

Usage: python _build-produits-lives.py
Sortie: lives-recherche-produit-2026-07/PRODUITS-CITES-3-LIVES.{html,pdf}
"""
import io, os, re, json, sys, html, subprocess

sys.stdout.reconfigure(encoding='utf-8')

ROOT = r'C:\Users\maths\Documents\Ecom-Inner-Circle'
OUT = os.path.join(ROOT, 'lives-recherche-produit-2026-07')

# ordre d affichage : ce qui sert a chasser un produit d abord, le reste en annexe
SECTIONS = [
    ('PRODUIT/VALIDE', 'PISTES PRODUIT - IL VALIDE', 'go', 'IL VALIDE',
     "Arthur dit que ca marche, le recommande, ou le vend lui-meme."),
    ('PRODUIT/NUANCE', 'PISTES PRODUIT - IL NUANCE', 'nu', 'IL NUANCE',
     "Il developpe avec des conditions ou des reserves, sans trancher franchement."),
    ('PRODUIT/NEUTRE', 'PISTES PRODUIT - AUCUN AVIS', 'ne', 'AUCUN AVIS',
     "Cite comme exemple ou illustration. Aucun verdict porte."),
    ('PRODUIT/DECONSEILLE', 'PISTES PRODUIT - IL DECONSEILLE', 'no', 'IL DECONSEILLE',
     "Il dit d eviter, il ecarte, il disqualifie."),
    ('NICHE/*', 'NICHES ET MARCHES (categorie entiere, pas un article a chasser)', 'ni', 'NICHES',
     "Le verdict porte sur un marche complet, pas sur un produit precis."),
    ('RECOMPENSE/*', 'ANNEXE - LOTS DE SON CONCOURS INTERNE (offerts aux membres, PAS des produits a vendre)', 'rc', 'LOTS CONCOURS',
     "Cadeaux qu Arthur remet a ses membres quand ils atteignent un palier de chiffre d affaires."),
    ('SERVICE_FORMATION/*', 'ANNEXE - SERVICES DE L ACCOMPAGNEMENT (vendus par Arthur ou son entourage)', 'sv', 'SERVICES',
     "Prestations : done for you, consulting, theme via son contact, modules de la formation."),
    ('OUTIL/*', 'ANNEXE - OUTILS, APPS, PLATEFORMES DE SOURCING', 'ou', 'OUTILS',
     "Logiciels, extensions, annuaires, plateformes. Pas des articles a vendre."),
    ('CONCURRENT/*', 'ANNEXE - CONCURRENTS, MARQUES ET ENSEIGNES', 'cc', 'CONCURRENTS',
     "Cites comme acteurs d un marche, pas comme des produits a sourcer."),
    ('AUTRE/*', 'ANNEXE - AUTRES MENTIONS', 'au', 'AUTRES',
     "Resultats de membres, produits non nommes, personnes, chiffres isoles."),
]

CSS = '''
@page { size: A4 landscape; margin: 10mm 8mm; }
* { box-sizing: border-box; }
body { font-family: "Segoe UI", Arial, sans-serif; font-size: 8.2pt; color: #1a1a1a; margin: 0; }
h1 { font-size: 17pt; margin: 0 0 2mm; letter-spacing: -.3px; }
.sub { color: #444; font-size: 8.4pt; margin-bottom: 3mm; max-width: 255mm; }
.kpi { display: flex; gap: 3mm; margin-bottom: 3mm; flex-wrap: wrap; }
.kpi div { border: 1px solid #ddd; border-radius: 3px; padding: 1.4mm 2.4mm; white-space: nowrap; }
.kpi b { font-size: 10.5pt; }
table { width: 100%; border-collapse: collapse; }
thead { display: table-header-group; }
th { background: #f2f2f2; text-align: left; padding: 1.4mm 1.6mm; border-bottom: 1.2px solid #bbb;
     font-size: 7.6pt; text-transform: uppercase; letter-spacing: .3px; }
td { padding: 1.3mm 1.6mm; border-bottom: .5px solid #e8e8e8; vertical-align: top; }
tr { page-break-inside: avoid; }
.nom { font-weight: 600; width: 19%; }
.verd { width: 40%; }
.prix { width: 17%; color: #333; }
.can { width: 6%; }
.lv { width: 5%; font-weight: 600; }
.ts { width: 13%; font-variant-numeric: tabular-nums; color: #666; font-size: 7.2pt; }
.b { display: inline-block; padding: .3mm 1.4mm; border-radius: 2px; font-size: 7pt;
     font-weight: 700; letter-spacing: .2px; white-space: nowrap; }
.go { background: #d8f0dc; color: #14622a; } .nu { background: #fff0d0; color: #7a5200; }
.ne { background: #eeeeee; color: #555; }   .no { background: #fadadb; color: #8e1c1f; }
.ni { background: #e4dcf3; color: #4a2c7a; } .rc { background: #ffe3f0; color: #8a1c5c; }
.sv { background: #fde9d5; color: #8a4b12; } .ou { background: #dde6f7; color: #1c3c7a; }
.cc { background: #e0e0e0; color: #333; }    .au { background: #f0f0f0; color: #555; }
.sec { background: #1a1a1a; color: #fff; padding: 1.6mm 2mm; font-weight: 700; font-size: 8.8pt;
       margin: 5mm 0 0; page-break-after: avoid; }
.sec .n { float: right; font-weight: 400; opacity: .85; }
.secsub { color: #555; font-size: 7.6pt; margin: 1mm 0 1.6mm; page-break-after: avoid; }
.note { color: #444; font-size: 7.8pt; margin: 2mm 0 3mm; border-left: 2px solid #ccc;
        padding-left: 2.5mm; max-width: 255mm; }
.na { color: #8a1c5c; font-size: 7.2pt; }
'''


def clean(s):
    s = str(s if s is not None else '').replace('\n', ' ').strip()
    if s.lower() in ('none', 'null', 'n/a', 'na'):
        return ''
    return re.sub(r'\s{2,}', ' ', s)


def esc(s):
    return html.escape(clean(s))


# un commentaire ne merite la colonne prix que s il porte un chiffre a expliquer.
# « Prix non aborde » n en porte pas : la colonne affiche un tiret, c est deja dit.
RE_CHIFFRE = re.compile(r'\d')


RE_AUCUN_PRIX = re.compile(r'^(le\s+)?(verdict|prix|aucun prix|pas de prix)\b[^.]{0,60}'
                           r'(pas de prix|prix non abord|aucun prix|rien a recopier)', re.I)


def toks(s):
    return set(re.findall(r'[a-zà-ÿ]{4,}', (s or '').lower()))


def note_prix(note, verdict, cap=190):
    """Du commentaire du classificateur, ne garde que ce qui explique un chiffre ecarte.

    Tout le reste redit le verdict, qui occupe deja la colonne d a cote."""
    note = clean(note)
    if not note:
        return ''
    tv = toks(verdict)
    keep = []
    for p in re.split(r'(?<=[.;])\s+', note):
        p = p.strip(' .;')
        if not p or not RE_CHIFFRE.search(p):
            continue
        if p.lower().startswith('verdict') or RE_AUCUN_PRIX.search(p):
            continue
        tp = toks(p)
        if tp and len(tp & tv) / len(tp) >= 0.6:      # recopie du verdict, pas une explication
            continue
        keep.append(p)
    s = '. '.join(keep)
    if len(s) > cap:
        s = s[:cap].rsplit(' ', 1)[0] + '...'
    return s


def main():
    base = {r['i']: r for r in json.loads(io.open(os.path.join(ROOT, '_produits-175.json'), encoding='utf-8').read())}
    fc = os.path.join(ROOT, '_cls-175.json')
    if not os.path.exists(fc):
        raise SystemExit('_cls-175.json absent : lance le workflow de reclassement dabord')
    cls = {c['i']: c for c in json.loads(io.open(fc, encoding='utf-8').read())}

    rows, manquants = [], []
    for i, b in base.items():
        c = cls.get(i)
        if not c:
            manquants.append((i, b['nom']))
            continue
        cat = (c.get('categorie') or 'AUTRE').upper()
        va = (c.get('verdict_arthur') or 'NEUTRE').upper()
        key = ('PRODUIT/' + va) if cat == 'PRODUIT' else (cat + '/*')
        if key not in dict((k, 1) for k, *_ in SECTIONS):
            key = 'AUTRE/*'
        pu = clean(c.get('prix_utile'))
        # la note ne sert qu a expliquer un chiffre ecarte : inutile si le prix produit est la,
        # inutile aussi si la source ne portait aucun chiffre a ecarter
        note = '' if (pu or not clean(b.get('prix'))) else note_prix(c.get('note'), b.get('verdict'))
        rows.append(dict(b, key=key, cat=cat, prix_utile=pu, note=note,
                         corrige=bool(c.get('corrige'))))
    for i, nom in manquants:
        print('NON CLASSE idx %d : %s' % (i, nom))

    par_key = {}
    for r in rows:
        par_key.setdefault(r['key'], []).append(r)
    nb_prod = sum(1 for r in rows if r['cat'] == 'PRODUIT')
    nb_corr = sum(1 for r in rows if r['corrige'])
    par_live = {}
    for r in rows:
        par_live[r['live']] = par_live.get(r['live'], 0) + 1

    h = ['<!doctype html><html lang="fr"><head><meta charset="utf-8">',
         '<title>Ce qu Arthur a cite - 3 lives de juillet 2026</title>',
         '<style>%s</style></head><body>' % CSS]
    h.append('<h1>Tout ce qu\'Arthur a cit&eacute; &mdash; 3 lives de juillet 2026</h1>')
    h.append('<div class="sub">Ecom Inner Circle. %d entit&eacute;s nomm&eacute;es, extraites des transcripts avec le verdict d\'Arthur et son horodatage. '
             'Lives du 10/07 (52 min), 16/07 (1 h 03) et 22/07 &mdash; RECHERCHE PROD Q4 (1 h 14).<br>'
             '<b>%d sont de vraies pistes produit.</b> Le reste est rang&eacute; en annexe : les lots de son concours interne, '
             'les services de son accompagnement, les outils, les concurrents. Chaque entr&eacute;e a &eacute;t&eacute; class&eacute;e en lisant '
             'ce qu\'Arthur en dit, pas son nom.</div>' % (len(rows), nb_prod))

    h.append('<div class="kpi">')
    for key, _lbl, css, short, _d in SECTIONS:
        n = len(par_key.get(key, []))
        if n:
            h.append('<div><span class="b %s">%s</span> <b>%d</b></div>' % (css, esc(short), n))
    for k in sorted(par_live):
        h.append('<div>%s : <b>%d</b></div>' % (k, par_live[k]))
    h.append('</div>')

    h.append('<div class="note">Le verdict est celui d\'Arthur, recopi&eacute; tel quel, jamais reformul&eacute;. '
             'La colonne <b>prix</b> ne porte un chiffre que s\'il concerne le produit lui-m&ecirc;me : un palier de concours, '
             'un tarif de prestation, un prix d\'abonnement ou le chiffre d\'affaires d\'un membre est &eacute;cart&eacute; et expliqu&eacute; &agrave; sa place. '
             'La mention <b>[K inf&eacute;r&eacute;]</b> signale un endroit o&ugrave; Whisper transcrit &laquo;&nbsp;k a day&nbsp;&raquo; en &laquo;&nbsp;cadeau&nbsp;&raquo; : lire &laquo;&nbsp;1 K/jour&nbsp;&raquo;. '
             'Les noms &eacute;tranges sont des erreurs Whisper conserv&eacute;es telles quelles, correction probable entre crochets.'
             + (' %d entr&eacute;e(s) reclass&eacute;e(s) par le contr&ocirc;leur, marqu&eacute;es d\'un ast&eacute;risque.' % nb_corr if nb_corr else '')
             + '</div>')

    for key, lbl, _css, _short, desc in SECTIONS:
        part = par_key.get(key, [])
        if not part:
            continue
        part.sort(key=lambda r: (r['live'], r['nom'].lower()))
        h.append('<div class="sec">%s<span class="n">%d</span></div>' % (esc(lbl), len(part)))
        h.append('<div class="secsub">%s</div>' % esc(desc))
        h.append('<table><thead><tr><th class="nom">Nom</th><th class="verd">Ce qu\'Arthur en dit</th>'
                 '<th class="prix">Prix / chiffres du produit</th><th class="can">Canal</th>'
                 '<th class="lv">Live</th><th class="ts">Horodatage</th></tr></thead><tbody>')
        for r in part:
            prix = esc(r['prix_utile'])
            if r['note']:
                prix = (prix + ' ' if prix else '') + '<span class="na">%s</span>' % esc(r['note'])
            canal = clean(r['canal'])
            canal = '&mdash;' if (not canal or canal.lower().startswith('non pr')) else esc(canal)
            h.append('<tr><td class="nom">%s%s</td><td class="verd">%s</td><td class="prix">%s</td>'
                     '<td class="can">%s</td><td class="lv">%s</td><td class="ts">%s</td></tr>' % (
                         esc(r['nom']), ' <span class="na">*</span>' if r['corrige'] else '',
                         esc(r['verdict']), prix or '&mdash;', canal, esc(r['live']), esc(r['ts'])))
        h.append('</tbody></table>')
    h.append('</body></html>')

    os.makedirs(OUT, exist_ok=True)
    fh = os.path.join(OUT, 'PRODUITS-CITES-3-LIVES.html')
    io.open(fh, 'w', encoding='utf-8').write('\n'.join(h))
    print('HTML %s  %d bytes  %d lignes' % (fh, os.path.getsize(fh), len(rows)))
    for key, lbl, _c, _s, _d in SECTIONS:
        n = len(par_key.get(key, []))
        if n:
            print('  %-4d %s' % (n, lbl))

    fp = os.path.join(OUT, 'PRODUITS-CITES-3-LIVES.pdf')
    EXE = [r'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe',
           r'C:\Program Files\Microsoft\Edge\Application\msedge.exe',
           r'C:\Program Files\Google\Chrome\Application\chrome.exe']
    exe = next((e for e in EXE if os.path.exists(e)), None)
    if not exe:
        raise SystemExit('pas de navigateur headless pour le PDF')
    if os.path.exists(fp):
        os.remove(fp)
    subprocess.run([exe, '--headless=new', '--disable-gpu', '--no-pdf-header-footer',
                    '--print-to-pdf=' + fp, 'file:///' + fh.replace('\\', '/')],
                   timeout=180, capture_output=True)
    if not os.path.exists(fp):
        raise SystemExit('PDF ECHEC')
    raw = io.open(fp, 'rb').read()
    print('PDF %s  %d bytes  %d pages' % (fp, len(raw), len(re.findall(rb'/Type\s*/Page[^s]', raw))))


if __name__ == '__main__':
    main()
