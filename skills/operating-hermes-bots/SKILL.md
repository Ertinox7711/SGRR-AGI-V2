---
name: operating-hermes-bots
description: Use when a session touches Hermes Agent (WSL) or its Discord bots — NeverGiveUp (#<AGENT_CHANNEL>) and Always Need Wins / ANW (#anw) — editing a profile's config.yaml, SOUL.md, .env, hooks or skills, restarting hermes-gateway*, changing an Ollama model, testing or measuring the bot in Discord, or when the operator says "reset", "redémarre le bot", "teste dans #anw", "parle à ma place", "vérifie que ça marche", "il rame", "il est bridé", or asks to remember what was decided about Hermes.
---

# Operating Hermes bots

## Principe

Le prompt système d'une session Hermes est **figé à la création de la session** (cache d'agent par session ; SOUL.md et la plupart des clés config ne sont pas dans la signature du cache). Donc : **tout changement de config / SOUL / skills / hooks = restart de la gateway + `/reset` dans le canal**, sinon rien ne change et on croit à tort que « ça ne marche pas ».
Deuxième principe : **tout ce qui se dit et se décide dans une session Hermes se journalise** (voir « Enregistrer »). Les leçons de la nuit meurent avec le chat si on ne les écrit pas.

## Carte — deux bots, jamais confondre

| | NeverGiveUp | Always Need Wins (ANW) |
|---|---|---|
| Profil / HERMES_HOME | `default` / `~/.hermes` | `anw` / `~/.hermes/profiles/anw` |
| Unité systemd (scope `--user`) | `hermes-gateway` | `hermes-gateway-anw` |
| Canal | `#<AGENT_CHANNEL>` `<DISCORD_ID>` | `#anw` `<DISCORD_ID>` |
| Modèle | claude-sonnet-5 (Anthropic, setup-token) | **`anw-38:latest`** (Qwen3.8-27B dense, IQ3_S) local Ollama Windows `127.0.0.1:11434/v1`, zéro cloud |
| Parler au bot | `ask-hermes` / `tell-hermes` | **claude-in-chrome dans `#anw`** (voir ci-dessous) |
| Logs | `~/.hermes/logs/` | `~/.hermes/profiles/anw/logs/{agent,gateway}.log`, sessions `state.db` |

Détails (clés config, hooks, chiffres, rollbacks) : `reference.md` de ce dossier. Historique des décisions : `journal.md`.

## Boucle de changement (dans cet ordre)

1. Lire `journal.md` (dernières entrées) et la section utile de `reference.md` : connaître l'état avant de toucher.
2. Backup horodaté : `cp fichier fichier.bak-YYYYMMDD-HHMMSS` (cp toujours OK ; jamais rm / mv / écrasement).
3. Éditer via un script `.py` écrit dans le scratchpad et lancé par chemin littéral en WSL. Jamais de sed / heredoc / `python -c` inline sous `wsl -- bash -lic` (métacaractères mangés).
4. **Avant tout restart, vérifier que the operator n'est pas en plein échange** : `grep "conversation turn" agent.log | tail -1` sans `response ready` plus récent dans `gateway.log` = tour en vol ; regarder aussi `#anw`. Un restart coupe le tour en vol et déclenche la « session hygiene » (session compressée brutalement). Si un tour est en vol : attendre.
5. `systemctl --user restart hermes-gateway-anw`, 9 s, `is-active` ; si hooks : `grep "shell hook registered" agent.log`.
6. `/reset` dans le canal. Je le fais moi-même quand the operator a donné carte blanche sur `#anw` et n'est pas en train de travailler avec le bot ; sinon je lui demande de le taper. `/reset` = `/new`, coûte un tour à froid (~30 s).
7. Preuve sans GPU que la règle est dans le prompt vivant : `python3 scripts/check_prompt.py anw "phrase distinctive"` (lit `sessions.system_prompt` dans `state.db`, lecture seule).
8. Pré-check avant toute sonde : Ollama répond (`curl.exe -s -m 5 http://127.0.0.1:11434/api/version` puis `/api/ps` — **jamais `ollama ps`**, voir Pièges) et aucun jeu ne tient la VRAM (`nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader`). Puis test live avec critère de réussite écrit **avant** l'envoi (réponse attendue, sans outil, longueur). Deux sondes réussies = signal, pas garantie (modèle probabiliste).
9. Mesurer, pas supposer : `agent.log` → `API call #N: model=… in=… out=… latency=…` ; `gateway.log` → `response ready … time=…` ; footer Discord `anw-38 · xx%` = modèle réel + % de contexte (le tag y est **lu du runtime**, donc c'est lui la vérité, pas ma mémoire).
10. Enregistrer (section suivante). Rapport à the operator : résultat d'abord, chiffres avant/après, rollback en une commande.

## Parler à la place de the operator dans `#anw`

- Outil : **claude-in-chrome sur SON Brave**, déjà connecté. Les messages partent sous son compte (<GUILD>) : c'est voulu, c'est comme ça qu'on teste ANW. Jamais `tell-hermes` / `ask-hermes` pour ANW (ils parlent à NeverGiveUp), jamais de webhook ni de persona bot (règle dure : Claude Code n'a pas de voix bot dans Discord).
- Charger les outils en un seul ToolSearch : `select:mcp__claude-in-chrome__tabs_context_mcp,mcp__claude-in-chrome__navigate,mcp__claude-in-chrome__computer,mcp__claude-in-chrome__browser_batch,mcp__claude-in-chrome__find,mcp__claude-in-chrome__get_page_text`.
- `tabs_context_mcp` → onglet `discord.com/channels/<DISCORD_ID>/<DISCORD_ID>` (le créer via `navigate` s'il manque) → `find "Message #anw"` → `browser_batch` : clic composer (bande du bas, y ≈ 555-580 sur 1568 px de large) → `type` → `Return` → `wait` de 10 s maximum chacun, en chaîner 3 ou 4 → `zoom` région `[170, 330, 1568, 598]` pour lire la réponse et le footer.
- **`/reset` est une app command** : taper `/reset`, attendre 1 s, le picker liste deux `/reset` (« Always Nee… » = ANW en premier, « NeverGive… » en second) → `Return` sélectionne le premier, `Return` envoie. Attendre l'accusé « Session reset! … Model: `<tag>` » avant la sonde. Si le picker ne s'ouvre pas : screenshot, ne pas marteler Return.
- Ne jamais laisser du texte en attente dans le composer ; Escape + Ctrl+A + Delete pour vider.

## Enregistrer (obligatoire en fin de session Hermes)

1. `journal.md` (ce dossier) : ajouter une entrée datée avec ce que the operator a dit (verbatim court), les décisions, les fichiers changés + backups, les chiffres avant/après, le rollback, ce qui reste ouvert.
2. Mémoire auto Claude Code : mettre à jour la note d'état (`anw-profile-local-bot`, `hermes-*`) — état actuel, pas narration — et sa ligne dans `MEMORY.md`.
3. Côté Hermes : changement sur NeverGiveUp → `hermes-changelog "titre" -f corps.md` (chemin codé en dur sur la mémoire de NGU, ne sert pas pour ANW). Côté ANW → note dans `~/.hermes/profiles/anw/memories/notes/` seulement avec le GO de the operator (c'est la mémoire du bot).

## Interdits

- Afficher `DISCORD_BOT_TOKEN` (`.env` et tous les `.env.bak-*` du profil).
- `ollama rm` / `ollama cp` / `ollama create` sur un tag existant. Nouveau réglage = nouveau tag `FROM anw-38`. Le hook `asset-delete-guard.ps1` bloque de toute façon, y compris ma propre ligne de commande si elle contient `ollama rm` en clair (tests → payloads dans un fichier).
- Changer le modèle à la place de the operator : `/model <tag>` dans `#anw` est à lui. Le bot ne change jamais le sien (hook `anw-model-lock.sh`). Jamais `chmod 444 config.yaml` : la gateway l'écrit sur `/model`.
- Un chemin cloud pour ANW : `fallback_providers: []`, aucun `ANTHROPIC_TOKEN` dans son `.env`, titres de session sur endpoint mort.
- Prononcer devant the operator l'ancien nom du profil purgé (commence par « orn… »).
- Restart pendant un tour de the operator en vol ; `/reset` pendant qu'il travaille avec le bot.

## Pièges

- `wsl -u YOU -- bash -lic '…'` : `$VAR`, `$(…)`, heredocs, `sed '…,$p'` sont mangés → fichiers + chemins littéraux ; ajouter `< /dev/null` sinon un grep sans fichier pend. `hermes cron list` cache les jobs en pause (`--all`).
- `ollama ps` peut afficher un autre tag que celui du bot : `anw-27b` et `anw-38` **partagent le même blob de poids** (12 040,9 Mo), runner partagé, et les paramètres de sampling s'appliquent quand même par requête. Vérité = `agent.log` `model=` et footer Discord.
- Ollama mono-slot : toute autre requête (titre, compression, job de fond `background_review`, brain-rag hybride) évince le cache KV → le tour suivant repaie le prefill.
- Un `find` claude-in-chrome peut renvoyer un `ref` périmé après navigation : refaire le `find` dans le même batch.
- **`ollama ps` / `ollama list` (CLI Windows) relancent `ollama app.exe` s'il est arrêté**, avec l'env du process appelant : Claude Code porte `OLLAMA_KV_CACHE_TYPE=q8_0` / `OLLAMA_KEEP_ALIVE=30m` périmés (registre User : `q4_0` / `-1`). Check passif = `curl.exe` sur `/api/version` et `/api/ps`. Relance propre = `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/ollama-restart-anw.ps1` (recopie le registre, affiche l'env réellement chargé, préchauffe le tag lu dans `config.yaml` sauf VRAM occupée ; `-NoPreheat`, `-Force`).
- **Un gardien tourne toutes les 2 min** (tâche `ANW-Watchdog`, `C:\Users\YOU\AppData\Local\anw-watchdog\`, détail dans `reference.md`) : il relance Ollama/gateway/pin WSL et arrête Ollama pendant un jeu. Avant d'arrêter volontairement Ollama ou `hermes-gateway-anw`, créer le fichier `pause` dans ce dossier, le retirer après. Preuve de vie = `state.json` `lastTick`.
- **Ollama arrêté = the operator l'a quitté**, en général pour jouer (Forza Horizon 6, LoL : 15 Go de VRAM ; `%LOCALAPPDATA%\Ollama\app.log` dit « shutting down desktop server »). ANW muet pendant ce temps est voulu (`agent.log` : `APIConnectionError … 127.0.0.1:11434`). Ne pas le relancer sans lui demander ; un modèle chargé pendant un jeu déborde en RAM et casse les deux.
- **Thinking sur Ollama /v1** : `agent.reasoning_effort: none` et le `think:false` d'Hermes sont ignorés ; seul `providers.ollama-local.extra_body: {reasoning_effort: none}` (racine du JSON) coupe le raisonnement. Vérité = `out=` de `API call` + colonne `reasoning` de `state.db` (`sess_msgs.py`), pas le footer. **Depuis le 04/09 14:35 le thinking est ON pour le chat ANW** (choix de the operator) et chaque raisonnement s'écrit en direct dans `profiles/anw/logs/thinking.log` (`HERMES_REASONING_TAP`, voir `reference.md`) — le lire là avant de supposer ce que le bot « pensait ».
- **Jamais `hermes -p anw chat --provider custom`** : avec les clés du `.env`, « custom » = OpenRouter (payé 04/09 : 1 requête partie dehors). Le profil sans argument suffit.
- **Toute tâche auxiliaire doit nommer un provider local** (`auto` = résolution par clés d'env → cloud) et le `.env` porte `HERMES_AUX_NO_MAIN_FALLBACK=1` (garde patchée dans `auxiliary_client.py`, à re-vérifier après un `git pull` Hermes). Compression = le même modèle que le chat (préfixe KV chaud), jamais un autre tag.
- **Restart sans couper un tour** : `scratchpad/wait_restart.sh` (attend `response ready` > dernier `inbound`, puis restart). `systemctl --user reload` = SIGUSR1 → drain 180 s + `resume_pending` (non testé).
- **`anw-model-lock.sh`** : la règle `:11434` ne vise que les commandes avec un client HTTP ; un fichier de config qui contient l'URL Ollama passe. Le modèle 3 bits tente de contourner un blocage (base64/hex) : le message de blocage lui dit d'arrêter et d'expliquer.
