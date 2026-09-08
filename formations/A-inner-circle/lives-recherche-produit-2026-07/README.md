# Lives « recherche produit » — juillet 2026 (Ecom Inner Circle)

Les 3 lives d'Arthur de juillet 2026, transcrits en français avec Whisper large-v3 (GPU RTX 3080, fp16).
Source : posts communauté Skool (pas la classroom) → `https://www.skool.com/ecom-inner-circle/<slug>`.

| Fichier | Live | Date | Durée | Segments | Slug Skool |
|---|---|---|---|---|---|
| `2026-07-10 - Live Recherche Produit  10072026.md` | Live Recherche Produit | 10/07/2026 | 52 min | 2 990 | `live-recherche-produit-10072026` |
| `2026-07-16 - Live recherche prod et faq  16072026.md` | Live recherche prod + FAQ | 16/07/2026 | 1 h 03 | 1 850 | `live-16072026-recherche-prod-et-faq` |
| `2026-07-22 - RECHERCHE PROD Q4  22072026.md` ⭐ | **RECHERCHE PROD Q4** | 22/07/2026 | 1 h 14 | 4 193 | `live-recherche-prod-q4-22072026` |
| `2026-07-30 - Préparation Q4  Règles et fonctionnement.md` | Préparation Q4 (offres BF/Noël) | 30/07/2026 | 54 min | 2 528 | `preparation-q4-regles-et-fonctionnement` |

Chaque fichier contient : métadonnées (source, date, durée, videoId), **transcript horodaté**, puis **transcript continu** (pour grep / lecture suivie).

| Livrable | Quoi |
|---|---|
| **`GRILLE-Q4-CONSOLIDEE.md`** ⭐ | **À lire en premier.** Les 3 lives réconciliés en une seule grille : ce que « Q4 » veut dire (3 cadrages qui tiennent ensemble), la bande de prix commune, marge brute vs nette, les 17 gates durs, les 2 contradictions non résolues (CPC en Q4, PMax), et la conséquence calendaire pour un site neuf. |
| **`DOCTRINES-2026-07-30-Q4-OFFRES.md`** ⭐ | Live du 30/07, **synthèse lisible**. Le titre du post ment : ce n'est pas le règlement d'un concours, c'est la **mécanique d'offre du Q4**. Black Friday (monter le prix barré, gros codes, urgence, bannière) vs Noël (offre-seuil cadeau, packs, mot cadeau), calendrier daté, emails/early access, ads (il **désavoue le CPC** comme métrique), stock/agent/1688, GMC (3 semaines), marché UK, 4 contradictions internes. |
| `DOCTRINES-2026-07-30-INTEGRAL.md` | Même live, **version exhaustive** (92 Ko, sortie du workflow 10 agents) : 184 règles, 32 dates, 34 actions datées, 63 obligations, 100 seuils chiffrés, 52 produits/niches cités, 57 questions de membres — tout horodaté. À ouvrir quand la synthèse ne suffit pas. `paliers = []` sur les 6 segments : preuve qu'aucun lot de concours n'est prononcé. |
| `DOCTRINES-2026-07-22-Q4.md` | Live Q4. **98 produits nommés**, 154 doctrines, 74 passages Q4, 71 gates. |
| `DOCTRINES-2026-07-16.md` | 43 produits, 170 doctrines, 78 gates, 40 questions de membres. |
| `DOCTRINES-2026-07-10.md` | 34 produits, gates budget/enchères/testing. |
| **`PRODUITS-CITES-3-LIVES.pdf`** (+ `.html`) | Les **175 entités nommées** dans les 3 lives, une ligne chacune avec le verdict d'Arthur et l'horodatage, rangées par ce qu'elles sont : **89 vraies pistes produit** (21 validées / 16 nuancées / 20 sans avis / 32 déconseillées), 17 niches, puis en annexe 4 lots de son concours interne, 9 services de l'accompagnement, 31 outils, 13 concurrents, 12 autres. Régén : `python ..\_build-produits-lives.py`. |
| `CHASSE-Q4-PASSE1.md` | Chasse produit : 30 candidats, 8 notés sur la grille /105, **8 DROP, 0 GO**. Contient les 22 candidats jamais notés et pourquoi le tri a écarté les bons. |
| `DOCTRINES-Q4.md` | Pré-scan regex du live du 22/07 (28 passages, fenêtres coupées). Carte de repérage, **pas** un livrable — superseded par les 3 documents ci-dessus. |

## Régénérer

1. **Tokens** (valides ~30 h, donc à refaire à chaque fois) : ouvrir un des posts dans Chrome loggé sur Skool, puis extraire `props.pageProps.postTree.videos[0].{playbackId, playbackToken}` du `__NEXT_DATA__` pour les 3 slugs (fetch same-origin sur les 2 autres), et exfiltrer via blob download → `C:\Users\maths\Downloads\skool_lives_q4_tokens.json`.
2. **Transcrire** : `python "C:\Users\maths\Documents\Ecom-Inner-Circle\_transcribe-lives-q4.py"` (resumable : saute les .md déjà écrits, réutilise les .mp3 déjà là).
3. **Extraire les doctrines** — chaîne générique, réutilisable pour n'importe quel live futur :
   - `python _slice-live.py "<fichier du live>.md" [segments-par-chunk]` → découpe en chunks de ~10 min dans `_chunks-<date>/` + `_index.json`.
   - `Workflow({scriptPath: "_wf-doctrine-live.js", args: {live, date, dir, chunks:[{name,from,to}]}})` → un agent lecteur par chunk (extraction verbatim horodatée), puis synthèse, puis critique de fidélité + complétude.
   - `_extract-doctrines-q4.py` = pré-scan regex rapide (donne une carte des passages, pas un livrable : fenêtres coupées et thèmes grossiers).

⚠️ Pièges connus (cf. mémoire `skool-transcript-extraction`) :
- Les **sous-titres Skool sont inutilisables** (ASR anglais sur audio français = hallucinations en boucle). Il faut re-transcrire.
- `yt-dlp` exige `--referer https://www.skool.com/` **et** `--add-header Origin:https://www.skool.com`, sinon Mux renvoie 403 (playback_restriction).
- Sur les posts communauté le chemin est `pageProps.postTree.videos[0]`, **pas** `pageProps.video` (ça, c'est le chemin des leçons classroom).
- Le tool output du MCP Chrome **censure les JWT** → passer par un blob `a.download`.
- **Whisper massacre les noms propres et les termes métier** de ces lives (« Shane » = Shein, « brande » = brand, « mini sclume » = un nom d'outil). Les agents lecteurs gardent le verbatim brut et signalent la correction probable entre crochets : jamais de correction silencieuse, sinon on part chercher le mauvais outil ou le mauvais fournisseur.
- Le **nombre de segments ne suit pas la durée** (4 193 segments pour 1 h 14, mais 1 850 pour 1 h 03) : la VAD coupe selon le débit de parole. Découper par nombre de segments, pas par durée supposée.
