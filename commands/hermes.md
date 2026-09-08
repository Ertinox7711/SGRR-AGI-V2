---
description: Parler a NeverGiveUp (Hermes, Claude Sonnet 5 dans WSL) — lui poser une question, lui faire passer une info, ou verifier son etat et son authentification.
argument-hint: "[status | self | auth | dis: <message Discord> | <question a lui poser>]"
allowed-tools: Bash, Read, Write
---

**NeverGiveUp** est l'assistant personnel de the operator : Hermes Agent dans WSL
Ubuntu, modele `claude-sonnet-5` via l'abonnement Max, canal Discord
`#<AGENT_CHANNEL>`. Il connait les projets, le kanban et les memoires de the operator.
Chaque question lui coute **un tour de quota Max** — groupe tes demandes, ne le
spamme pas.

Argument recu : `$ARGUMENTS`

## Ce que tu fais selon l'argument

- **`status`** → est-il en vie ?
  `wsl -u YOU -- bash -lc 'systemctl --user is-active hermes-gateway; systemctl --user show hermes-gateway -p MainPID'`
- **`self`** → son portrait derive du disque (modele reel, replis, services,
  skills, crons) : `wsl -u YOU -- bash -lc 'hermes-self'`
- **`auth`** → controle de la regle 9 (le jeton Anthropic qui meurt en silence) :
  `wsl -u YOU -- bash -lc 'grep -c "^ANTHROPIC_TOKEN=" ~/.hermes/.env'`
  Si c'est `0`, la reparation ne peut etre faite que par the operator :
  `claude setup-token` sous Windows, puis
  `bash ~/.hermes/scripts/hermes-set-anthropic-token.sh` dans WSL.
- **`dis: <message>`** → poste sur Discord sans consommer de tour LLM :
  `wsl -u YOU -- bash -lc 'tell-hermes "<message>"'`
- **toute autre chose** → une vraie question. Ecris-la d'abord dans un fichier
  (les caracteres speciaux ne survivent pas a la ligne de commande) puis :
  `wsl -u YOU -- bash -lc 'ask-hermes -f /mnt/c/Users/YOU/AppData/Local/Temp/hermes-prompt.txt'`

## Regles

- `ANTHROPIC_API_KEY` doit rester **absente** de l'environnement WSL : sa
  presence detruit le jeton OAuth de Hermes. Les wrappers la retirent seuls —
  ne l'exporte jamais a la main.
- Ne relance jamais les daemons Discord archives (`responder.py`,
  `presence_bot.py`, `discord_poller.py`, `watchdog.py`, `auto_executor.py`,
  ni les crons `trio-*`). Claude Code n'a plus de voix dans Discord.
- Avant de demander quoi que ce soit a the operator, cherche d'abord :
  `wsl -u YOU -- bash -lic 'brain-rag "<la question>"'`.
