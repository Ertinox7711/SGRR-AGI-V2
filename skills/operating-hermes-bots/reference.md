# Référence — Hermes / ANW (état au 2026-09-04 05:00)

## Chemins

- Hermes source : `~/.hermes/hermes-agent/` (venv `venv/bin/python`). Gateway ANW : `python -m hermes_cli.main --profile anw gateway run --replace`, `HERMES_HOME=/home/YOU/.hermes/profiles/anw` posé dans l'unité.
- Profil ANW : `config.yaml`, `SOUL.md`, `.env` (600, secret `DISCORD_BOT_TOKEN`), `memories/{MEMORY.md,USER.md}` (USER.md = copie du profil NGU, contenu intime), `state.db` (sessions + messages), `shell-hooks-allowlist.json`, `logs/{agent,gateway,errors}.log`.
- Hooks Hermes (partagés, `~/.hermes/agent-hooks/`) : `anw-model-lock.sh` (escape `HERMES_ALLOW_MODEL_CHANGE=1`), `protected-path-guard.sh` (`HERMES_ALLOW_PROTECTED=1`), `destructive-guard.sh` (`HERMES_ALLOW_DESTRUCTIVE=1`). Un hook modifié doit être ré-approuvé : entrée `{approved_at, command, event, script_mtime_at_approval}` dans `shell-hooks-allowlist.json` avec le mtime exact (`%Y-%m-%dT%H:%M:%S.%fZ`), sinon il est ignoré (`hooks_auto_accept: false`).
- Côté Windows : `~/.claude/scripts/asset-delete-guard.ps1` (PreToolUse `Bash|PowerShell`), unlock `~/.claude/.asset-delete-unlock` (ISO, 24 h, seulement après GO explicite par item), règle 4 des zones interdites du CLAUDE.md global.
- `hermes-self` décrit NGU ; pour ANW le script honore `HERMES_HOME` (patch `hermes_self.py`, backup `.bak-20260904-040353`).

## Clés de `config.yaml` (profil anw) qui comptent

| Clé | Valeur actuelle | Effet |
|---|---|---|
| `model.default` / `provider` | **`anw-38:latest`** / `ollama-local` (vérifié disque 06/09 21 h) | modèle du bot ; `/model --global` réécrit ce fichier |
| `model.context_length`, `ollama_num_ctx`, `max_tokens` | 81920 / 81920 / 8192 | fenêtre et cap de sortie |
| `providers.ollama-local.models` | `qwen3.8-27b: {}`, `anw-27b: {}`, `anw-38: {}` (les tags 3.6 morts ont été retirés) | tags autorisés pour `/model` |
| `fallback_providers` | `[]` | **jamais** remettre Anthropic : le profil héritait de NGU et 31K tokens sont partis sur l'abo Max |
| `agent.disabled_toolsets` | tts, image_gen, video, moa, delegation | schémas retirés du prompt (delegation = sous-agent qui évince le cache KV) |
| `HERMES_REASONING_TAP` (`.env` anw) | `…/profiles/anw/logs/thinking.log` | **robinet de raisonnement en direct** (04/09 14:35) : patch `gateway/run.py` (`_make_reasoning_tap` + `agent.reasoning_callback` + `_reasoning_tap_footer`, backup `run.py.bak-thinktap-20260904-143507`) écrit chaque chunk `reasoning` du stream dans le fichier, en-tête par tour (heure, user, chat), pied « réponse en Xs, N appels ». Variable absente (NeverGiveUp) = callback `None`. Lecture : `Desktop\ANW-THINK.bat` (= `wsl -u YOU -- tail -F` ; depuis Git Bash ajouter `MSYS2_ARG_CONV_EXCL='*'`). Coût nul (append fichier, zéro requête). `display.show_reasoning` reste `false` |
| `HERMES_THINKING_OFF_FILE` (`.env` anw) | `…/profiles/anw/thinking.off` | **interrupteur chaud** (04/09 14:39, patch `gateway/run.py` après `agent.request_overrides = _turn_overrides`, backup `run.py.bak-thinkswitch-20260904-143937`) : fichier présent = `extra_body.reasoning_effort: none` pour ce tour, absent = thinking ON. Lu à chaque message → **pas de restart, pas de `/reset`**. Bascule : bouton du panneau `http://localhost:8790`, ou `Desktop\ANW-THINKING.bat`, ou `touch`/`rm` du fichier. Prouvé : « test » 14:43 = `out=5`, 4,6 s, rien dans le tap |
| Panneau local `anw-panel` | `http://localhost:8790` — `profiles/anw/panel/{server.py,index.html}`, unité `--user anw-panel.service`, `Desktop\ANW-PANEL.bat` | onglets Contrôle / Pensée en direct / Conversation / Tours / Logs / Config. Écrit : `thinking.off`, `config.yaml` (7 clés bornées, backup `.bak-panel-<ts>`), `thinking.log` (vider), `systemctl --user restart|start|stop hermes-gateway-anw` (restart refusé si tour en vol, stop pose le `pause` du gardien). Ne change jamais le modèle. Ports voisins : 8765 = ancien dashboard « Free AI » (`bridge/dashboard.py`), 9119 = dashboard Hermes NGU |
| `providers.ollama-local.extra_body` | **absent depuis 04/09 14:35 = thinking ON pour le chat** (the operator veut voir le raisonnement, accepte la latence). Le remettre (`{reasoning_effort: none}`) = thinking OFF. Les tâches `auxiliary.*` gardent `reasoning_effort: none` | mesuré 14:35 : tour simple 16,1 s / `out=694` avec thinking vs ~3 s sans |
| `agent.reasoning_effort` | `''` (était `none` 13:xx-14:35) | inerte seul (Hermes en fait `think:false` dans `extra_body`, qu'Ollama /v1 ignore). **Ce qui coupe vraiment le thinking = `providers.ollama-local.extra_body: {reasoning_effort: none}`** (clé à la racine du JSON ; `gateway/run.py:17009` la fusionne à chaque tour). Mesuré 04/09 : 7,1 s / 1 132 car. de raisonnement avec `think:false`, 0,2 s / 0 avec `reasoning_effort` racine ; l'appel n°5 du reel = 149 s / 23,5K car. pour rien |
| `skills.disabled` | `[]` (222 skills visibles depuis 04:40) | liste de noms cachés de l'index ; 163 noms = index 9 940 → 2 500 tokens si besoin de vitesse (plan `skills_plan.py` de la nuit) |
| `skills.creation_nudge_interval` / `memory.nudge_interval` | 15 / 10 | déclenchent le job de fond `background_review` (« update the skill library », 2 appels de 36-42K tokens ≈ 70 s GPU) ; 0 = off |
| `compression.threshold` / `protect_last_n` / `protect_first_n` | 0.85 / 8 / 3 | compaction de session |
| `auxiliary.compression` | ollama-local / **anw-38**, `base_url` explicite, `api_key: ollama`, timeout 900, `extra_body: {reasoning_effort: none}`, `fallback_chain: []` | même modèle que le chat = préfixe KV chaud, zéro swap VRAM. Avant (anw-fast, timeout 120) : `connection error` le 04/09 13:32 → fallback `main-agent(custom)` = **historique Discord envoyé à Gemini** (404) + « fallback context marker » = session cassée + 94,7 s de re-prefill au tour suivant |
| toutes les autres tâches `auxiliary.*` (web_extract, skills_hub, approval, mcp, triage_specifier, kanban_decomposer, profile_describer, curator, goal_judge) | ollama-local / **anw-38** explicites + `fallback_chain: []` (vérifié : 10 tâches, toutes sur `anw-38`) | étaient `auto` (résolution par les clés d'env du `.env` → cloud) ; `goal_judge` était sur `gpt-oss:120b:cloud` |
| `auxiliary.title_generation` | endpoint mort `http://127.0.0.1:9/v1` | pas de flag off dans le code ; 1 WARNING inoffensif, zéro requête parasite |
| `auxiliary.vision` | free-gemini, `fallback_chain: []` | seul chemin cloud restant, images seulement (un texte-seul ne peut pas lire une capture) ; the operator décide |
| `.env` → `HERMES_AUX_NO_MAIN_FALLBACK=1` | garde ajoutée dans `agent/auxiliary_client.py::_try_main_agent_model_fallback` (backup `.bak-auxguard-20260904-134350`) | aucune tâche auxiliaire ne retombe sur `main-agent(custom)` (= Gemini/OpenRouter via les clés du `.env`). NGU n'a pas la variable → inchangé. Une mise à jour de Hermes peut écraser le patch : re-grep `HERMES_AUX_NO_MAIN_FALLBACK` après un `git pull` |
| `display.runtime_truth.enabled` | true | injecte `model=` / `provider=` réels à chaque appel (identité juste) |
| `hooks.pre_tool_call` | anw-model-lock, protected-path-guard, destructive-guard | ordre = ordre d'exécution |
| `discord.history_backfill_limit` | 15 | vieux messages du canal réinjectés à la création de session (source de « on m'a retiré tel modèle ») |

## Modèles Ollama (Windows, RTX 3080 16 Go)

> **Plus aucun Qwen 3.6 sur la machine depuis le 2026-09-06.** Les tags MoE `anw-v2`,
> `anw-v2-t1`, `anw-fast`, `anw-v3` et les poids `hf.co/unsloth/Qwen3.6-35B-A3B-GGUF:*` ont
> été supprimés sur GO de the operator (51,91 Go rendus). Vérifié le 06/09 à 21 h : `/api/tags`
> n'en contient aucun, et **zéro blob orphelin** (27 blobs, 49,15 Go, tous référencés).
> Ne jamais proposer `/model anw-v2` ni `FROM anw-fast` : ces tags n'existent plus.

- **`anw-38:latest`** = le modèle du bot. Qwen3.8-27B **dense** UD-IQ3_S, 12,04 Go, archi
  `qwen35` (27,32 B, `block_count 65`, `full_attention_interval 4` → ~16 couches d'attention
  pleine sur 65, donc cache KV petit), `num_ctx 81920`. `parent_model: anw-27b:latest`.
- **`anw-27b:latest`** = le tag précédent, **même blob de poids** que `anw-38` (12 040,9 Mo
  partagés) : le garder ne coûte 0 Go.
- `qwen3.8-27b`, `qwen38`, `qwen38-98k`, `q38-txt-80k-d4` : autres tags 3.8 sur disque, non
  défaut. `bge-m3` (1,16 Go) = l'embetteur de brain-rag — **le charger évince le bot**
  (Ollama mono-slot).
- Registre User Ollama : `OLLAMA_KV_CACHE_TYPE=q4_0`, `OLLAMA_FLASH_ATTENTION=1`,
  `OLLAMA_KEEP_ALIVE=-1`, `OLLAMA_NUM_PARALLEL=1` (mono-slot), `OLLAMA_CONTEXT_LENGTH=40960`
  — mais le serveur en cours a chargé `4096` (env périmé, **sans effet** : le tag impose
  `num_ctx 81920`). Le GGUF déclare `context_length: 262144` : c'est pour ça que le
  « Honor GGUF model defined default parameters » d'Ollama 0.33.3 est un **risque**.
- Diagnostic « ça rame » : prefill à 16-36 tok/s = VRAM qui déborde en RAM ; `ollama ps` dit « 100 % GPU » quand même ; signal = `nvidia-smi` power.draw ~50 W ou `Shared Usage` > 0 sur `llama-server`. Un jeu (LoL) prend de la VRAM.

## Mesure

```bash
# WSL — dernier appel et temps vu côté Discord
grep "API call" /home/YOU/.hermes/profiles/anw/logs/agent.log | tail -n 3
grep "response ready" /home/YOU/.hermes/profiles/anw/logs/gateway.log | tail -n 3
# tour en vol ? (conversation turn plus récent que le dernier response ready)
grep "conversation turn" /home/YOU/.hermes/profiles/anw/logs/agent.log | tail -n 1
# hooks chargés
grep "shell hook registered" /home/YOU/.hermes/profiles/anw/logs/agent.log | tail -n 3
```

Chiffres de référence (04:54) : prompt fixe `in=24 399`, tour à froid 27,2 s API / 31,2 s Discord, tour à chaud 2-5 s, footer contexte 30 % au départ. Avant la nuit : 27B en débordement, 36 s / 218 s, identité fausse.

Test mental utile (calcul + concision, sans outil) : « produit 26 €, vendu 199 €, 10 % de frais sur le prix de vente : marge nette, et prix plancher pour garder 120 € ? » → 153,10 € et 162,22 €.

## Discord

- Guild <GUILD> COMPANY `<DISCORD_ID>`, `#anw` `<DISCORD_ID>`, bot Always Need Wins#6579. Guild NGU `<DISCORD_ID>`, `#<AGENT_CHANNEL>` `<DISCORD_ID>`.
- Commandes gateway : `/reset` = `/new` (même handler, vide la file, bypass l'agent en cours), `/model <tag>`, `/stop` (ne coupe pas un appel Ollama en vol : `systemctl --user kill -s SIGKILL hermes-gateway-anw` puis `resume_pending: false` si un tour à vide repart au boot), `/compress` (éviction du cache d'agent déduite du code, pas testée).
- Un restart de gateway = « Session hygiene » : vu 70 376 → 722 tokens sur la session courante.
- `/reset` via claude-in-chrome : voir SKILL.md. Le picker montre aussi les slash commands skills de NGU (`/market_research_agent`…) : ne rien sélectionner d'autre.

## Rollbacks (tous horodatés, `cp` puis restart puis `/reset`)

| Retour à | Commande |
|---|---|
| sampling d'origine | ~~`/model anw-fast`~~ **impossible : tag supprimé le 06/09**. Retour = `/model anw-27b` (même blob) |
| avant leviers 1+2+3 (04:53) | `cp config.yaml.bak-20260904-045313 config.yaml ; cp SOUL.md.bak-20260904-045313 SOUL.md` |
| 64 skills seulement (prompt −5K) | `cp config.yaml.bak-20260904-044021 config.yaml` |
| sans verrou modèle | `cp config.yaml.bak-20260904-042804 config.yaml ; cp SOUL.md.bak-20260904-042914 SOUL.md` (le hook reste sur disque, inactif) |
| 27B dense | `cp config.yaml.bak-20260904-034710 config.yaml` |
| début de la nuit | `config.yaml.bak-20260904-032256` + `SOUL.md.bak-20260904-032256` ; `.env.bak-20260904-034053` (contient des tokens : ne jamais l'afficher) |
| hooks Claude Code | `~/.claude/settings.json.bak-20260904-042154`, `~/.claude/CLAUDE.md.bak-20260904-042154` |

Toujours depuis `~/.hermes/profiles/anw/`, puis `systemctl --user restart hermes-gateway-anw` et `/reset`.

## Scripts de ce dossier

- `scripts/check_prompt.py <profil> "<phrase>"` : preuve sans GPU qu'une règle est dans le prompt de la session Discord vivante (lecture seule de `state.db`).
- `scripts/ollama-restart-anw.ps1 [-NoPreheat] [-Model <tag>] [-Force]` (depuis le 06/09 le tag par défaut est **lu dans `config.yaml`**, repli `anw-38` — il était codé en dur sur `anw-v2`, tag disparu) : relance Ollama Windows avec l'env du registre User (jamais via `ollama ps`), affiche l'env chargé (`server config`), préchauffe `anw-v2` sauf VRAM occupée. Refuse si un modèle est chargé (requête en vol) sans `-Force`.

## Gardien `ANW-Watchdog` (the operator, 2026-09-04 : « fais en sorte qu'il soit tout le temps bien »)

- Tâche planifiée Windows `ANW-Watchdog` (session de the operator, pas d'admin, cachée) : à l'ouverture de session +1 min puis **toutes les 2 min sans fin**, zéro LLM. Script `C:\Users\YOU\AppData\Local\anw-watchdog\anw-watchdog.ps1`, installeur `install-task.ps1` (idempotent, `-Force`), log `anw-watchdog.log` (actions seulement), `state.json` (`lastTick` = preuve de vie), `games.txt` (exe supplémentaires), fichier `pause` = le gardien ne fait rien.
- Chaque tour : (1) pin WSL `HERMESPIN` présent sinon `hermes-pin.vbs` ; unité `hermes-gateway-anw` active sinon `start` ; modèle lu dans `config.yaml` du profil (`model.default`) ; (2) jeu = process > 400 Mo sous `steamapps\common`, `Riot Games\…\Game`, `Epic Games`, `XboxGames`, `GOG Galaxy\Games`, `Ubisoft…\games` ou nom dans `games.txt` → modèles déchargés (`keep_alive: 0`) puis Ollama arrêté (VRAM au jeu) ; (3) pas de jeu : Ollama arrêté + VRAM < 6 Go → `ollama-restart-anw.ps1` (env registre + préchauffe) ; VRAM ≥ 6 Go → attente loggée une fois ; Ollama up avec env périmé (`server config` ≠ registre) et rien de chargé → relance propre ; rien de chargé et VRAM libre → préchauffe du modèle.
- Tester à blanc : `powershell -NoProfile -ExecutionPolicy Bypass -File anw-watchdog.ps1 -DryRun -Verbose [-SimulateNoGame]`. État de la tâche : `Get-ScheduledTask ANW-Watchdog | Get-ScheduledTaskInfo`.
- Conséquence pour la boucle de changement : un restart de gateway fait par moi est vu par le gardien comme « unité active » (rien) ; si je dois arrêter la gateway ou Ollama volontairement, créer le fichier `pause` d'abord, le retirer après.

## Bot muet : lire dans cet ordre

1. `grep -c "APIConnectionError" …/anw/logs/agent.log` et la dernière ligne `API call failed after 3 retries … base_url=http://127.0.0.1:11434` → Ollama down.
2. `%LOCALAPPDATA%\Ollama\app.log` (rotations `app-1.log`…) : « shutting down desktop server » = quitté par the operator (pour jouer) ; absence de ligne = crash. `server.log` ligne `server config` = env réellement chargé (comparer au `reg query "HKCU\Environment"`).
3. `curl.exe -s -m 5 http://127.0.0.1:11434/api/ps` + `nvidia-smi` : modèle chargé ? VRAM prise par un jeu (`Get-Process | Sort-Object WS -Descending`) ?
4. `gateway.log` : `Agent cache idle-TTL evict` après ~1 h d'inactivité (prochain tour = tour à froid) ; `discord.client: Attempting a reconnect` = réseau Discord, pas Ollama.

## Lanceurs sur le Bureau (audit 2026-09-04)

- **`ANW.bat`** (écrit le 04/09, ASCII + CRLF) = le seul lanceur à jour. Menu : Allumer / Éteindre / Redémarrer la gateway / État détaillé / Question / Discord `#anw` / Journal / Chat WSL / Pause du gardien. Sous-commandes non interactives : `ANW.bat start|stop|restart|status|log|ask "question"`. Toute la logique est dans `scripts/anw-tool.ps1` (zéro `ollama ps`, tout en `curl`/`Invoke-WebRequest` + `systemctl --user`) ; la question passe par `%TEMP%\anw_question.txt` UTF-8 puis `scripts/anw-ask.sh` (**LF obligatoire**, lu depuis `/mnt/c`). « Éteindre » pose d'abord le fichier `pause` du gardien (sinon relance en 2 min), décharge les modèles par l'API, stoppe l'unité, **laisse Ollama allumé** ; « Allumer » retire `pause`, démarre l'unité et joue un tour du gardien.
- **`Lancer Hermes.lnk`** → `Documents\HERMES\RESTORE-HERMES.bat` → `tools\hub\restore-hermes.ps1` (auto-élévation admin). Outil de **restauration** : répare WSL seulement si `wsl --status` échoue, ré-importe `C:\Users\YOU\WSL\Ubuntu-22.04\ext4.vhdx` seulement si la distro n'est pas enregistrée, `enable-linger`, démarre `hermes-gateway` + `hermes-dashboard`, ouvre `localhost:9119`. Sain et idempotent, mais **ne démarre pas `hermes-gateway-anw`** et son pin `tail -f /dev/null` n'a pas le marqueur `HERMESPIN` (le gardien en lancera un second, sans conflit). Pas un outil du quotidien.
- **`RETIRED-BOT.bat`** (+ copie `Documents\HERMES\RETIRED-BOT-KIT\`, kit WSL `/home/YOU/<retired-bot>-kit/`, wrapper `~/.local/bin/<retired-bot>`, `~/.claude/commands/<retired-bot>.md`) = **obsolète sur toutes ses références** : profil `<retired-bot>` absent (`hermes -p <retired-bot>` refuse, « Named profiles must already exist »), modèle `<retired-bot>-x`/`<retired-bot>-96k` absents des manifests, canal `#<retired-bot>` = l'id de `#anw`. Inoffensif si cliqué (sort en erreur, `<retired-bot>-down.sh` décharge un modèle inexistant). Biens de the operator : **pas supprimés**, à lui de décider.

## Zéro fenêtre (2026-09-04)

the operator ne veut aucune console qui apparaisse (le sort du jeu plein écran). Le gardien passe par `anw-watchdog\run-hidden.vbs` (wscript, fenêtre 0, attend la fin). Pour tout autre script de fond : `wscript.exe //B //Nologo C:\Users\YOU\AppData\Local\run-hidden\run-hidden.vbs "<exe>" <args>`. `powershell -WindowStyle Hidden` seul ne suffit pas.


## Puissance ANW (2026-09-04 soir) — outils, skills, mémoire, activité

- **Activité en direct** : `HERMES_ACTIVITY_TAP=/home/YOU/.hermes/profiles/anw/logs/activity.jsonl` dans `profiles/anw/.env` (patch `gateway/run.py`, backup `run.py.bak-activitytap-20260904-183044`). Événements `turn.start / tool.start / tool.end / turn.end`. Retirer la variable = robinet fermé. Onglet **Activité** du panneau (touche 2), `/api/activity?offset=`, `/api/activity/clear`.
- **Livraison Discord** : ligne finale `MEDIA:/chemin/absolu` — regex de `gateway/platforms/base.py` élargie à ~60 extensions (`.py .md .sh .html .json…`, backup `base.py.bak-mediaext-20260904-184248`). Fichier partagé avec NGU (actif chez lui après son prochain restart).
- **Outils maison** `profiles/anw/tools/` : `make_pdf.py SRC OUT.pdf [--landscape] [--title]` (Chromium Playwright du venv, repli reportlab, tolère args inversés) ; `webtext.py URL [--max]` (exit 2 = bloqué → navigateur). Python utile = `/home/YOU/.hermes/hermes-agent/venv/bin/python3` (playwright, reportlab, matplotlib, python-docx, openpyxl, pypdf, PIL). `/usr/bin/python3` = 3.10 nu.
- **Skills perso** `profiles/anw/skills/anw/anw-{deliver-files,make-pdf,coding-protocol,web-research,reasoning-doctrine,delegate-big-tasks}/SKILL.md`. Frontmatter : mettre `description` entre guillemets si elle contient `:`.
- **Config** (`config.yaml.bak-tools-20260904-185048`) : `disabled_toolsets: [tts, image_gen, video, moa]` (delegation ON), `delegation.max_concurrent_children 2 / max_iterations 30 / child_timeout_seconds 900`, `tool_output.max_bytes 16000`.
- **Mémoire** : `profiles/anw/memories/` = index 14 302 car (limite 16 384) + 43 notes héritées de NGU (mots remplacés), backup `MEMORY.md.bak-20260904-185048`. Garde-fou `identite-runtime` dans l'index.
- **SOUL v2** : 7 667 o (`SOUL.md.bak-20260904-185405` = v1 5 984 o). Prompt système vivant ≈ 66 000 car.
- **Panneau** : mot de passe dans `profiles/anw/panel/.password` (600). Tunnel externe : pas installé (GO the operator).

## Pont `anw_bridge` (2026-09-04 19:20) — la boucle Claude Code câblée dans la gateway

- **Interrupteur** : `HERMES_ANW_GUARDS=1` + `HERMES_ANW_TOOLS=/home/YOU/.hermes/profiles/anw/tools` dans `profiles/anw/.env` (lignes 520-521). `0` ou absent = gateway Hermes pure (NGU n'a pas la variable = inchangé). Restart requis (import paresseux au premier message ; log `anw_bridge installed` dans `gateway.log`).
- **Code** : `profiles/anw/tools/anw_guards.py` (garde livrable + routeur BM25, `test_anw_guards.py` 5 tests) ; `anw_bridge.py` (hooks in-process, état par chat, `test_anw_bridge.py` 4 tests avec stub du plugin manager). Lancer : `cd profiles/anw/tools && venv/bin/python3 test_anw_bridge.py`. Patch `gateway/run.py` : `_anw()` + 6 ancrages (`_make_reasoning_tap`, `_make_activity_tool_taps` ×2, `turn.start`, `finish_turn` après le sentinel `(empty)`, `bind` près de `agent.reasoning_callback`). Backup `run.py.bak-anwbridge-20260904-192141`. Re-vérifier après `git pull`.
- **Ce que ça fait par tour** : (1) `pre_llm_call` → `[indice skills : …]` ajouté au message user (jamais au prompt système : cache KV) ; (2) `pre_tool_call` → `patch`/`write_file` bloqué sur un fichier existant jamais vu dans un argument/résultat d'outil de la session (message en français qui dit quoi faire) ; (3) raisonnement → événements `think` dans `activity.jsonl` (vidés avant chaque outil, à 3 000 car, en fin de tour) ; (4) fin de tour → `MEDIA:` ajouté pour tout fichier frais (mtime ≥ début du tour) nommé dans la réponse, événement `guard`. Panneau : carte 💭 violette, ligne 📚 (indice), ligne 🛡️ (garde).
- **Réglages** dans `anw_guards.py` : `min_hits 2 / min_score 6.0`, boost `anw-*` ×1,3, `MAX_ATTACH 25 Mo`, `SKIP_EXT` ; dans `anw_bridge.py` : `THINK_FLUSH 3000`, `ROUTER_TTL 300`, `EDIT_TOOLS`.
- **Tag `anw-v3`** (IQ3_XXS, MoE 3.6, jamais activé — **supprimé le 06/09**) : 13,63 Go VRAM, 80,7 tok/s vs anw-v2 85,4. Historique. Bench reproductible : `python bench_v3.py` (Windows, scratchpad de la session ; saute la création si le tag existe).

### Pont `anw_bridge` v2 (2026-09-04 19:45) — hooks in-process supplémentaires

- `transform_tool_result` : table `TIPS` (9 regex, 1 conseil/tour/famille) → ajoute `conseil_anw` au JSON du résultat ; tous les `TODO_EVERY=5` résultats → `todo_en_cours` depuis `agent._todo_store.format_for_injection()` (agent capté en weakref via `bind(session_id, chat, agent=agent)`).
- `pre_llm_call` : `CORRECTION_RE` → contexte « the operator te corrige… memory » (+ indice skills, même string, séparés par `\n`).
- `finish_turn` : `CLAIM_RE` sans outil de `EXEC_TOOLS={terminal,execute_code,process}` → `guard affirmation-sans-preuve` ; `PROMISE_RE` sur la dernière ligne → `guard promesse-en-fin-de-message`. Événements panneau seulement.
- Événements activity.jsonl : `tip {name, tool, text}`, `hint`, `guard {kind, text|added|tool,path}`, `think`.
- Tunables en tête de `anw_bridge.py` : `TIPS`, `TODO_EVERY`, `CLAIM_RE`, `PROMISE_RE`, `CORRECTION_RE`, `EXEC_TOOLS`.
- Tests : `cd /home/YOU/.hermes/profiles/anw/tools && /home/YOU/.hermes/hermes-agent/venv/bin/python3 test_anw_bridge.py` (8) ; install = scratchpad `install_bridge.sh`.
- Eval v2/v3 : `eval_v2_v3.py` (scratchpad) → 11/15 = 11/15. anw-v2 avait été gardé ; les deux tags sont **supprimés depuis le 06/09**.

### Pont `anw_bridge` v3/v4 (2026-09-04 20:00 / 23:40) — mains réelles, relecture, « je sais ce que je dis »
- `tools/anw_playbook.py` : `PLAYBOOKS` (regex → bloc « [outils pour ce message] »), `LOGGED_DOMAINS` (sites avec compte → `hbrowse` obligatoire, `browser_navigate` bloqué par `pre_tool_call`). Tips ajoutés : `curl-page`, `login-wall`.
- Relecture : `relecture(st, response)` dans `finish_turn`, rejoue la liste de messages capturée par `pre_api_request` + `build_api_kwargs` (préfixe KV conservé, +3-4 s/tour). Tunables : `RELECTURE_MIN/MAX/TOKENS/TIMEOUT`, `RELECTURE_PROMPT` ; `HERMES_ANW_RELECTURE=0` coupe. Événement `relecture` dans activity.jsonl (`verdict` ok/corrige/error:*).
- Citation : `last_reply_context` (`CITE_RE`, `_CITE_STOP`) → dernier message d'ANW réinjecté quand the operator y réagit ; hint `kind=relecture`.
- SOUL : puce « Mes vraies mains », ligne Vision, règle dure 8. Backups `SOUL.md.bak-hands-20260904-195647`, `SOUL.md.bak-relecture-20260904-233031`.
- Tests : 17 (`test_anw_bridge.py`) + 5 guards ; install = scratchpad `install_bridge.sh` ; le module est importé au premier message → restart gateway après toute modif.
