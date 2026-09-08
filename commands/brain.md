---
description: Chercher dans tout ce qu'on sait deja (brain Hermes, 225 skills Hermes, skills Claude Code, CLAUDE.md, PITFALLS, registry boutiques, memoires) avant de dire "je ne sais pas".
argument-hint: "<la question en langage naturel>  [--scope brain|hermes|claude|memory] [-k N] [--full]"
allowed-tools: Bash, Read
---

`brain-rag` est le RAG maison : environ 66 000 extraits couvrant le brain de
Hermes (notes, dossiers, reels archives, journal), les skills Hermes, les skills
Claude Code, le `CLAUDE.md` global, `PITFALLS.md`, `shops-registry.md` et les
memoires des deux agents. Il rend des passages avec `fichier:ligne`.

Recherche demandee : `$ARGUMENTS`

## Marche a suivre

1. Lance la recherche :
   `wsl -u YOU -- bash -lic 'brain-rag "<la question>"'`
   - hybride BM25 + bge-m3 par defaut, environ 2 s
   - `--fast` = BM25 seul · `--scope brain|hermes|claude|memory` · `-k N` · `--full`
   - l'index se rafraichit tout seul (au plus une fois toutes les 10 min) ;
     `--refresh` force le controle, `--index` reconstruit tout (30 s)
2. **Si la premiere formulation ne rend rien, reformule avec les mots du
   document** (« no-verify », « 403 Cloudflare », « keep_alive ») plutot qu'avec
   les tiens. C'est ce qui fait la difference entre trouver et ne pas trouver.
3. `brain-rag` retrouve des passages, il ne raisonne pas : **ouvre le fichier
   cite** avant d'agir dessus. Un extrait indexe reflete l'etat au moment de
   l'indexation, pas forcement le disque d'aujourd'hui.
4. Reponds avec la reponse d'abord, puis les sources en `fichier:ligne`.

Si vraiment rien ne sort apres deux formulations differentes, dis-le
franchement et propose la source suivante (le fichier a lire, ou la question
precise a poser a the operator) — n'invente pas.
