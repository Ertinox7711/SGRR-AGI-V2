---
description: Trouver le skill Hermes qui correspond a une tache (225 methodes ecrites d'avance) et appliquer sa methode au lieu d'improviser.
argument-hint: "<la tache, en clair : 'scraper un site en 403', 'comprendre un reel Instagram', 'auditer un compte X'>"
allowed-tools: Bash, Read, Grep, Glob
---

Hermes porte environ 225 skills `SKILL.md` dans `/home/YOU/.hermes/skills/`,
tous lisibles et applicables ici. L'index complet est
`C:\Users\YOU\.claude\hermes-skills-catalog.md` (nom + chemin + une ligne de
description, groupe en 32 categories).

Tache : `$ARGUMENTS`

## Marche a suivre

1. **Trouve le candidat.** Deux voies, prends la plus rapide :
   - recherche semantique : `wsl -u YOU -- bash -lic 'brain-rag "<la tache>" --scope hermes'`
   - ou lis l'index : `C:\Users\YOU\.claude\hermes-skills-catalog.md`
2. **Lis-le en entier** :
   `wsl -u YOU -- bash -lc 'cat /home/YOU/.hermes/skills/<categorie>/<skill>/SKILL.md'`
3. **Regarde ce qui l'accompagne** — beaucoup de skills embarquent des scripts
   ou des references : `wsl -u YOU -- bash -lc 'ls -la /home/YOU/.hermes/skills/<categorie>/<skill>/'`
4. **Applique la methode du skill**, ne la resume pas. Si un script fourni fait
   le travail, lance-le plutot que de le reecrire.

## Ordre de priorite

Les skills de **processus** d'abord (`recon-avant-action`,
`systematic-debugging`, `test-driven-development`, `writing-plans`), les skills
d'**implementation** ensuite.

## Raccourcis frequents

- scraping bloque / 403 → `research/scrapling`, `research/smart-scraper`, `social-media/api-sniff-flash`
- persona X / reach → `social-media/x-reply-game-reach`, `social-media/x-account-safety-multicompte`
- video, reels → `social-media/video-decoder-local`, `social-media/instagram-reel-understanding`
- mains sur le navigateur local → `social-media/local-browser-pc-hands`

Les skills `kanban-*`, `hermes-*`, `nevergiveup-*`, `self-improvement-safe`
servent a piloter Hermes lui-meme : on les lit, on ne les execute pas ici.
Si un skill Claude Code natif couvre deja le sujet, l'ordre est :
instructions de the operator > skills de processus > defaut.
