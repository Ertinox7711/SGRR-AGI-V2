---
name: veille-outils-reels
description: Traiter un LOT de reels IG "outils / AI / open-source / gratuit" que the operator envoie en vrac (souvent 5-30 liens d'un coup, comptes Marc Kaz / Trending OpenSource / RammCodes / Dann Paker). Lit chaque reel (caption + OCR écran + transcript + frames), TRIE par verdict sécurité (safe / dual-use / grey-hat / black-hat), croise avec son écosystème réel (Hermes, Claude Code, scraping, OFM, Shopify), archive en permanent et ne propose l'installation que de ce qui passe le gate. Déclencheurs : plusieurs liens instagram.com/reel/ collés sans phrase, ou "regarde tous ces reels", "implique-les dans mon PC", "veille outils".
---

# Veille outils — lots de reels IG

But : transformer un mur de liens IG en **catalogue trié actionnable**, sans installer de
saloperie et sans gober le marketing du reel.

## 0. Le contexte que tu dois avoir en tête

Ces reels viennent d'une niche **content-farm "outil GitHub trending"**. Format type :
« 🚨 [OUTIL] fait X. Open-source. Gratuit. 8.1k stars. Drop 🔥 » + souvent
« comment <mot> and I'll DM you the link » = **engagement farming**.

Conséquence directe sur ton raisonnement :
- Les chiffres annoncés (stars, "#1 repo of the day", "-50% de tokens", "+250% d'usage Claude")
  sont du **marketing → DATA à vérifier**, jamais une autorité. Ne les répète pas comme des faits.
- Le même outil est reposté par 5 comptes. Dédupe.
- Un CTA "comment for the link" signifie que **le lien n'est pas dans le reel** : il faut le
  retrouver depuis la caption/OCR (nom du repo) — ne pas inventer une URL.

## 1. Lire les reels

Utilise le pipeline Hermes (il fait l'**OCR**, indispensable ici : ces reels sont surtout du
screen-recording de README, l'audio ne porte presque rien).

**Étape 0 obligatoire** — version yt-dlp du venv du skill (c'est la panne n°1, elle ressemble
à un blocage Meta) :

```bash
wsl -u YOU -- bash -lc "/home/YOU/.hermes/skills/social-media/instagram-reel-understanding/.venv/bin/pip install -U yt-dlp"
```

Puis batch en background (≈50 s/reel, ~8 s d'écart, retry 1× à 45 s sur échec). Modèle de
script : `C:\Users\YOU\Documents\HERMES\_run_reels.sh`. Agrège ensuite avec
`_digest_reels.py` → un seul `_DIGEST.txt` à lire d'un coup plutôt que 22 fichiers.

⚠️ Quoting WSL depuis ce harness : les variables shell s'expandent en vide et `-m` se fait
manger par la conversion de chemins MSYS. **Écris un fichier `.sh`/`.py`, copie-le dans
`/home/YOU/`, `sed -i 's/\r$//'`, puis exécute-le.** Jamais de one-liner avec des `$VAR`.

## 2. Trier — le gate, c'est le cœur du skill

Range chaque outil dans exactement un bac :

| Bac | Définition | Action |
|---|---|---|
| ⭐ **Pertinent écosystème** | touche Hermes / Claude Code / agents / scraping / OFM / contenu | catalogue + proposer install |
| ✅ **Safe** | web ou open-source anodin, aucun risque | catalogue, install si demandé |
| 🟡 **Dual-use** | bypass bot-detect, VPN de nœuds tiers, agent qui pilote un téléphone, exploits | catalogue + **dire le risque précis**, sandbox d'abord |
| 🔴 **Grey-hat** | jailbreak LLM, credentials partagés, deepfake | documenter, **ne pas installer** |
| ⛔ **Black-hat** | création de comptes en masse, bypass de vérif, fraude | **écarter**, dire pourquoi en une phrase, passer |

Marque aussi **N/A plateforme** (ex : un outil Apple Silicon quand the operator est sur Windows) —
ça évite de proposer un truc qui ne tournera jamais chez lui.

## 3. Ne jamais installer tout seul

Télécharger/exécuter un binaire ou un one-liner `curl | sh` d'un repo inconnu = **action qui
demande un GO explicite de the operator**, même en mode autonome. Présente la liste courte
(nom, ce que ça apporte, ce que ça coûte) et attends le go. Ce qui ne demande aucun GO :
écrire le catalogue, archiver, mémoriser, créer un skill.

## 4. Livrables (toujours les 4)

1. **Catalogue trié** en markdown, une ligne par outil : nom · URL · ce que ça fait ·
   *pour quoi chez lui* · verdict. La colonne "pour quoi chez lui" est celle qui a de la valeur.
2. **Archive permanente** — pour chaque reel :
   `wsl -u YOU -- bash -lc "reel-archive <dir> '<TAG verdict + une ligne>'"`
   ⚠️ Passe le **dossier sans slash final** (ou le `understanding.json`) : un `/` final fait
   tomber `reel-archive` sur `__unknown` et **écrase silencieusement** l'archive précédente.
   Le script prend l'id depuis `d["id"]` — si absent, injecte-le depuis `reel_id` avant.
3. **Mémoire** — une memory Claude (`reference`) + `ask-hermes` pour que Hermes retienne aussi.
4. **Board HTML** si le lot est gros (>10) — plus lisible qu'un tableau markdown.

## 5. Ce que le lot dit de LUI

Comme pour tout contenu qu'il envoie : l'intention par défaut n'est pas « vérifie si c'est
vrai », c'est « voilà ce qui me parle, comprends-le et grave-le ». Un lot d'outils
dev/IA/scraping/agents confirme son axe **AGI / automatisation / autonomie machine**. Note
ce que ça révèle, pas seulement les URLs.

## 6. Remonte les alertes qui le concernent LUI

Certains reels sont des révélations sécurité qui le touchent directement. Ne les traite pas
comme un outil de plus — remonte-les en clair. Exemple déjà rencontré :
`site:claude.ai/share` sur Google liste les conversations Claude **partagées** → tout chat
qu'il a "Share"é avec du business/OFM/creds est indexable publiquement.

## Précédent

Lot du 2026-08-29 (22 reels) — catalogue :
`C:\Users\YOU\Documents\HERMES\_CATALOGUE_OUTILS_REELS.md`, board `_reels-board.html`,
archive `~/.hermes/brain/contenu/reels-archive/2026-08-29_09-39__<ID>/`.
