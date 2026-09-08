---
description: Diagnostiquer une VM WSL morte ou degradee (Hermes muet, getpwuid failed 5, erreurs d'E-S, C: sature) et appliquer la sequence de recuperation deja verifiee.
argument-hint: "(sans argument)"
allowed-tools: Read, Bash
---

Symptomes couverts : Hermes ne repond plus, `getpwuid failed 5`, commandes WSL
en erreur d'entree-sortie, VM qui s'arrete toute seule.

## Le diagnostic d'abord, l'action ensuite

1. **L'espace sur C:.** `getpwuid failed 5` n'est **pas** un probleme de
   permissions : c'est EIO. L'ext4 du VHDX est tombe parce que C: est arrive a
   zero (evenement NTFS 141 sur `wslservice.exe`). **Verifie l'espace libre de
   C: avant toute autre hypothese** — c'est deja arrive, cause par un
   `ollama pull` lance en tache de fond.
2. `wsl -l -v` — l'etat des distributions.
3. Si la VM repond encore : `wsl -u YOU -- bash -lc 'df -h /'`.

## La recuperation

Seulement si le diagnostic ci-dessus confirme le disque ou une ext4 en vrac :

```
wsl --shutdown
```

puis relance une commande WSL. Le journal ext4 rejoue tout seul au montage et
l'espace est rendu. **Confirme avec the operator avant de couper** : `wsl --shutdown`
tue tous les processus WSL, y compris Hermes et <RETIRED-BOT>.

## Apres redemarrage

- Hermes : `wsl -u YOU -- bash -lc 'systemctl --user is-active hermes-gateway'`
  (scope `--user`, jamais system).
- <RETIRED-BOT> : `wsl -u YOU -- bash /home/YOU/<retired-bot>-kit/<retired-bot>-status.sh`, ou
  `C:\Users\YOU\Desktop\RETIRED-BOT.bat start` pour le relancer.
- Le garde-fou en place : le cron `disk-watchdog-c-drive` (60 min, `--no-agent`,
  donc il tourne meme si l'auth LLM est morte).

## Le piege de la VM qui s'eteint seule

La VM WSL s'arrete environ 110 secondes apres la sortie du dernier client
`wsl.exe`. Ni `linger=yes`, ni `vmIdleTimeout=-1` ne l'empechent — c'est mesure.
La seule chose qui marche est de garder un client attache
(`hermes-pin.vbs` dans `AppData\Local\hermes-keepalive\`). Si Hermes « meurt »
regulierement quand personne ne touche au PC, c'est ca, pas un bug de Hermes.

## Espace a recuperer si C: est plein

Environ 200 Go de modeles Ollama existent en double : cote WSL et cote Windows.
Ne supprime rien sans le GO explicite de the operator — dis-lui juste combien il y a
et ou.
