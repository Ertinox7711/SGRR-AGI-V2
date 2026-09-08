---
description: Brief d'ouverture de journee — Discord, etat de Hermes et d'<RETIRED-BOT>, crons, disque C:, VRAM — tout en parallele et sans consommer un seul tour de quota LLM.
argument-hint: "(sans argument)"
allowed-tools: Read, Glob, Grep, Bash
---

Brief du jour. **Aucun `ask-hermes`, aucun `<retired-bot> chat`** : rien ici ne doit
consommer un tour LLM ni mobiliser le GPU. Tous les appels sont independants,
donc ils partent **dans un seul message multi-blocs**.

## A collecter

1. **Discord** — ce qui s'est dit depuis hier :
   `wsl -u YOU -- bash -lic 'discord-history recent 40'`
2. **NeverGiveUp** — service et modele reel :
   `wsl -u YOU -- bash -lc 'systemctl --user is-active hermes-gateway'`
   puis la cle `model.default` de `/home/YOU/.hermes/config.yaml`
   (les unites Hermes sont en scope `--user`, jamais system).
3. **Crons** — `wsl -u YOU -- bash -lc 'hermes cron list --all'`.
   **Sans `--all`, les jobs en pause sont caches** et on croit qu'il n'y en a
   que trois. Verifie au passage que le watchdog de la regle 9
   (`rule9-anthropic-token-watchdog`) est bien actif.
4. **<RETIRED-BOT>** — `wsl -u YOU -- bash /home/YOU/<retired-bot>-kit/<retired-bot>-status.sh`
5. **Disque C:** — un C: tombe a zero tue la VM WSL en silence et emporte
   Hermes avec (`getpwuid failed 5` = EIO, pas un souci de droits).
6. **VRAM** — `ollama ps`, en lisant la colonne `PROCESSOR` : un `35%/65%`
   signale un debordement VRAM, pas un CPU faible.

## Ce que tu rends

Cinq a huit lignes, resultat d'abord : ce qui a change, ce qui est casse, ce
qui attend une decision de the operator. Pas de tableau exhaustif, pas de
recitation de ce qui va bien — juste « tout est vert cote X » en une ligne.

Si quelque chose est casse et reparable sans risque, **repare-le maintenant**
plutot que de l'annoncer. Si la reparation demande une action que seul the operator
peut faire (re-auth, achat, redemarrage machine), pose la question precise.
