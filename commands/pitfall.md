---
description: Passer une action risquee au crible des 13 pieges deja payes (PITFALLS.md) avant de la lancer — commit, push, rm, reset, scraping, secrets, process longs.
argument-hint: "<ce que tu t'appretes a faire>"
allowed-tools: Bash, Read, Grep
---

`C:\Users\YOU\.claude\PITFALLS.md` recense 13 pieges payes en vrai temps
perdu. Cette commande sert a les relire **avant** l'action, pas apres.

Action envisagee : `$ARGUMENTS`

## Marche a suivre

1. Lis `C:\Users\YOU\.claude\PITFALLS.md`.
2. Retiens **seulement** les pieges que cette action peut declencher. Pour
   chacun : le risque en une phrase, et le controle concret a passer maintenant.
3. Passe les controles toi-meme (lance-les), puis dis ce qui est vert et ce qui
   ne l'est pas.
4. Verdict net : **GO** ou **NO-GO**, avec la raison. Si NO-GO, dis ce qu'il
   faut corriger d'abord.

## Les controles qui reviennent le plus

| Action | Le controle a passer |
|---|---|
| commit | `git diff --cached` lu en entier ; une feature = un commit |
| commit TypeScript | `npx tsc --noEmit` vert avant de stager |
| push / PR / deploy | confirmation de the operator — c'est visible par d'autres |
| `rm -rf`, `reset --hard`, force-push | cible verifiee, reversibilite verifiee, sauvegarde faite |
| scraping qui rend 403/429 | passer a Scrapling (`StealthyFetcher`), pas bricoler les en-tetes |
| hook ou test rouge | trouver la cause, jamais `--no-verify` ni desactiver le test |
| process long, boucle, modele local | plafond CPU/RAM/parallelisme pose |
| tout ce qui touche l'auth | environnement minimal ; `ANTHROPIC_API_KEY` reste absente cote WSL |
| « c'est fait » | tests verts + build OK + diff lu — sinon ce n'est pas fait |

Si l'action ne declenche aucun piege, dis-le en une ligne et laisse passer.
Pas de ceremonie inutile.
