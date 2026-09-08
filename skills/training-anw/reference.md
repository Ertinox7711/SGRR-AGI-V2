# Entraîner ANW — commandes, carte, pièges payés

## 1. Lire l'état (toujours en premier)

```bash
wsl -u YOU -- bash -lc "cd /home/YOU/.hermes/profiles/anw/scripts && HERMES_HOME=/home/YOU/.hermes/profiles/anw /home/YOU/.hermes/hermes-agent/venv/bin/python3 anw_etat.py"
```

Sort le taux **par famille avec le nombre de tirs**, les exercices jamais posés, les derniers
tirs perdants, les réflexes du catalogue sans exercice, et la cible à poser.
`--json` pour un script. Lecture seule : un test vérifie qu'il n'écrit rien sur le disque.

Un taux sur moins de 5 tirs est marqué `n faible` ; une famille jamais mesurée est
`JAMAIS MESUREE` et **ne peut pas** être élue maillon faible (inconnue ≠ bonne).

## 2. Poser un exercice et le corriger

```bash
wsl -u YOU -- bash -lc "echo <id-exercice> > /home/YOU/.hermes/profiles/anw/logs/train/prochaine.txt"
```

```bash
wsl -u YOU -- bash -lc "cd /home/YOU/.hermes && hermes cron run 4acfd2a45d93 --profile anw"
```

```bash
wsl -u YOU -- bash -lc "cd /home/YOU/.hermes && hermes cron run f179c9a6576b --profile anw"
```

**`cron run` ne fait que DÉCLENCHER** : le job part au tick suivant du planificateur (60 s).
Ne pas conclure « ça n'a rien fait » avant d'avoir attendu et relu `agent.log`.

| Cron | Id | Rythme |
|---|---|---|
| `anw-exercice` (pose) | `4acfd2a45d93` | `0 8,11,14,17,20,23 * * *` — 6×/jour |
| `anw-correction` | `f179c9a6576b` | `35 8,11,14,17,20,23 * * *` — +35 min |
| `anw-bilan` | `46704be32e5d` | `0 20 * * 0` — dimanche 20 h |

Les trois livrent dans `#anw` (`<DISCORD_ID>`), en mode `no-agent` : zéro appel LLM
pour corriger. C'est voulu — un correcteur qui devine apprend ses propres approximations.

## 3. Le banc

```bash
wsl -u YOU -- bash -lc "cd /home/YOU/.hermes/profiles/anw/scripts && HERMES_HOME=/home/YOU/.hermes/profiles/anw /home/YOU/.hermes/hermes-agent/venv/bin/python3 -m pytest -q"
```

158 tests + 215 sous-tests dans `scripts/` au 05/09/2026 16:10, tous verts (50 de plus
dans `tools/`, comptés à part — le journal du même jour dit « 130 », c'était avant).

**`HERMES_HOME` est obligatoire** : sans lui, `_skills_eteints()` relit le `config.yaml` de
NeverGiveUp et le banc annonce 100 faux fantômes (payé le 05/09).

## 3 bis. Pré-check avant toute sonde

**VRAM : ne pas lire le total brut.** `nvidia-smi` a affiché 14659/16384 Mio — 89 %. Un seuil
naïf conclurait « un jeu tourne, ne touche à rien ». Faux : `anw-38` (12,04 Go) et `bge-m3`
(1,16 Go) en tiennent l'essentiel à eux seuls. Soustraire ce que `/api/ps` déclare **avant** de
conclure qu'un jeu occupe la carte.

```bash
curl.exe -s -m 5 http://127.0.0.1:11434/api/ps
```

Jamais `ollama ps` ni `ollama list` : la CLI Windows relance `ollama app.exe` avec
l'environnement du process appelant, dont des variables périmées.

## 3 ter. Reglages du modele : ou ils vivent, et lesquels sont officiels

**Le Modelfile fait loi.** Le harness n'envoie `temperature` que si `profile.fixed_temperature`
ou `params["temperature"]` existe (`agent/transports/chat_completions.py:452-461`) ; aucun chemin
de config ne les remplit pour le modele principal. Donc changer le sampling = **creer un nouveau
tag Ollama** (ajouter = OK), et l'activation est `/model` **par the operator**, jamais par moi.

**Une fiche par modele -- ne jamais transposer.** Le MoE et le dense ne prescrivent pas la meme
chose, et c'est exactement la valeur qui differe qui compte. Les deux fiches HF sont figees depuis
le 24/04/2026 (verifie le 06/09/2026) : il n'y a jamais eu de « correction fin mai », cette phrase
etait fausse dans cette page.

`Qwen/Qwen3.6-35B-A3B` (MoE -- **plus sur la machine** : tags `anw-v2`/`anw-fast`/`anw-v3`
supprimes le 06/09/2026. Garde ici **uniquement** comme contre-exemple : c'est la valeur qui
differe du dense qui compte) :

| mode | temp | top_p | top_k | min_p | presence_penalty |
|---|---|---|---|---|---|
| thinking, general | 1.0 | 0.95 | 20 | 0 | **1.5** |
| thinking, code precis | 0.6 | 0.95 | 20 | 0 | **0.0** |

`Qwen/Qwen3.8-27B` (dense hybride attention/SSM -- c'est le modele d'`anw-27b`, actif depuis le
06/09/2026) : **temp 1.0 | top_p 0.95 | top_k 20 | min_p 0 | presence_penalty 0.0 |
repetition_penalty 1.0** en thinking. Le 1,5 du MoE **ne s'applique pas ici** : la fiche dense
prescrit 0,0.

`anw-v2` (supprime) portait **temp 0.6 + presence_penalty 0.5** : aucun des deux presets. Le tag
`qwen3.8-27b` portait temp 0.7 / top_p 0.80, soit le preset **non-thinking** ampute de son
presence_penalty -- donc ni l'un ni l'autre non plus, et sans `repeat_penalty` explicite Ollama
appliquait son defaut 1.1 contre le 1.0 prescrit. `anw-27b` corrige les deux (cree le 06/09 via
`/api/create`, jamais la CLI). Banc de comparaison : `banc_params.py` dans le scratchpad du 05/09.

**`draft_num_predict` = la tete MTP du 27B, et elle se mesure.** Sur le vrai prompt systeme d'ANW
(15 958 tokens) : 0 -> 20,4 tok/s ; 2 -> 35,2 ; 3 -> 33,1 et 34,3 ; **4 -> degenere (1 token en
133 s)** alors que 4 est la valeur du blob officiel Ollama ; 5 -> 23,2. `anw-27b` porte **3**, seule
valeur mesuree deux fois. Un banc de vitesse sur du texte **repetitif** ment (le speculatif accepte
tout) : utiliser le prompt systeme reel, lu dans `state.db`.

**Ne jamais descendre a temp 0 / greedy** sur une longue chaine de pensee : les modeles distilles
bouclent plus que leur teacher (ICML 2026 Spotlight). Le probleme n'est pas la creativite, c'est la
repetition infinie.

## 4. Carte des fichiers

| Fichier | Rôle |
|---|---|
| `$H/scripts/anw_etat.py` | tableau de bord de l'entraînement (lecture seule) |
| `$H/scripts/anw_train.py` | pose, correction, `est_reelle()`, bulletin — **écrit** le carnet |
| `$H/scripts/anw_bilan.py` | bilan hebdomadaire |
| `$H/scripts/anw_exercices.py` | la banque : 66 exercices, 270 points, 27 réflexes |
| `$H/tools/anw_lessons.py` | le catalogue des réflexes + carnet de leçons |
| `$H/tools/anw_guards.py` | `_DECLENCHEURS` + `SkillRouter` — quel skill est servi |
| `$H/logs/train/results.jsonl` | le carnet : une ligne par correction |
| `$H/logs/train/prochaine.txt` | l'exercice à poser au prochain tir |

(`$H` = `/home/YOU/.hermes/profiles/anw`)

## 5. Le routeur — comment ANW reçoit un skill

`_DECLENCHEURS` est un **tuple ordonné, premier match gagne**. BM25 ne fait que *classer* ;
les déclencheurs décident **quand enseigner**. Deux régimes :

- déclencheur touché → `[skill pour cette tache : …]` + la méthode inlinée (journalisé `enseigne`)
- lexical seul → `[skills peut-etre utiles : …]` (journalisé `nomme`)

Les regex tournent sur du texte NFKD, accents retirés, minuscules (sauf entrées marquées
`"accent"`). **Un changement de déclencheur ne demande qu'un restart de la gateway**, pas de
`/reset` : l'indice est greffé sur le message au moment de l'envoi, pas dans le prompt figé.

## 6. Pièges déjà payés — ne pas les repayer

| Piège | Ce qui s'est passé | La règle qui en sort |
|---|---|---|
| Ordre des déclencheurs | « deux tests rouges, quel fichier portait la panne » recevait `tdd` : le motif des tests passait avant celui des bugs. 6/8, deux fois le même réflexe. | Premier match gagne. Un nouveau motif se place **avant** ceux qu'il doit battre, et on audite combien d'énoncés il capture. |
| Banc sans `HERMES_HOME` | J'ai annoncé « 100 fantômes, deux tests rouges » — je mesurais le profil de NeverGiveUp. | Toujours `HERMES_HOME=…/profiles/anw`. Vérifier le profil avant de crier. |
| Alarme trop rapide | `anw relecture skip:no-agent` signalé comme régression ; un `relecture ok` existait 48 s plus tôt dans la même session. | Lire la fenêtre entière du log avant de conclure à une panne. |
| Fixture nose | `def setup()` n'est plus appelé automatiquement (retiré en pytest 8). 5 tests ont écrit dans le **vrai** carnet ; 22 tests verts pendant ce temps. | Le bac à sable est `setup_function`, et un test vérifie qu'il est actif. Vert ≠ vérifié. |
| Liste blanche | Filtrer « garder si le dossier s'appelle `NNN-` » a jeté 5 lignes légitimes. | Rejeter ce qu'on reconnaît, garder le reste. Une vraie donnée perdue en silence coûte plus qu'une fausse comptée. |
| Chemins MSYS | `wsl … bash -lc "/home/…"` → `C:/Program: No such file or directory`. | `MSYS_NO_PATHCONV=1`, et commencer la chaîne par un mot de commande (`cd`, `exec`). |
| Métacaractères | `$VAR`, `$(…)`, backticks, heredocs mangés par le harness. | Écrire un `.py` avec l'outil Write, l'exécuter par chemin littéral. |
| `exec` | `exec sed … ; echo …` — la 2ᵉ commande n'est jamais lancée. | `exec` remplace le process : jamais en tête d'une commande composée. |
| Fichiers en root | `anw_etat.py` installé en root → `PermissionError` au patch suivant. | `chown YOU:YOU` tout ce qu'on dépose dans le profil. |
| `num_ctx` dans une sonde | Une sonde avec `options: {num_ctx: 8192}` a fait recharger le modele du bot a 8192 et **evince `bge-m3` de la VRAM**. | Ne JAMAIS passer `num_ctx` a `/api/chat`. Le contexte appartient au tag, pas a l'appelant. |
| Banc en mode `"w"` | Le relancer apres un plantage effacait les 10 tirs deja payes (40 s chacun). | Un banc s'ouvre en `"a"` et saute les triplets deja mesures. Un banc qui ne survit pas a son plantage est un essai, pas un banc. |
| Garde qui teste la mauvaise chose | `if "web_extract" in src` pour eviter un doublon dans `MEMORY.md` : le mot y etait **deja** (ligne « Carte des capacites »), l'ajout a ete declare fait sans l'etre. Deuxieme fois ce week-end. | Le marqueur d'idempotence doit etre **unique au changement** (un horodatage, un titre de section), jamais un mot du contenu. Et il doit matcher **le texte reellement ecrit**, accents compris : chercher `97 requetes` alors que le journal porte `97 requêtes`, c'est une garde qui ne matche jamais et une relance qui duplique. |
| Heredoc plein de backticks | `cat > f <<'EOF'` avec du markdown : `unexpected EOF while looking for matching quote`. | Fichier markdown ou `.py` -> outil Write, jamais heredoc. |
| Deux bancs en meme temps | Cru le 1er banc mort a 10/54, relance la reprise. Les deux tournaient : **97 requetes `/api/chat` pour 54 tirs**, 73 qui se chevauchent, a partir de 16:42:06 pile. Puis le cron `anw-exercice` s'est ajoute a 17:00. Ollama est mono-slot -> toute la latence mesurait la file d'attente. `actuel` 85,3 tok/s (seul) contre 34,2 (a trois). | Avant un banc : verifier qu'aucun autre client ne parle a Ollama, et le re-verifier apres. La preuve est dans `%LOCALAPPDATA%\Ollama\server.log` (lignes `[GIN]`, horodatage de FIN + duree -> on reconstruit `[debut, fin]` et on compte les recouvrements). Un banc mono-thread seul ne peut produire **aucun** recouvrement. Corollaire : justesse et tokens survivent a la contention, la **latence non**. |
| Banc qui ne declare pas son mode | Le banc a bien tourne thinking ON -- mais je ne l'ai su qu'apres coup, en relisant `pensee_car` sur les 54 tirs. Rien ne l'avait verifie. Thinking OFF, il aurait compare autre chose en silence. | Un banc enregistre **et affirme** le mode dans lequel il tourne (thinking, tag du modele, plafond de tokens) avant le premier tir, et l'ecrit dans chaque ligne de resultat. Attention : le panneau ecrit `thinking.off` dans le **profil**, pas dans le dossier du gardien, et un appel direct a `/api/chat` **ne passe pas** par ce drapeau -- il ne vaut que pour les tours de la gateway. |
| Route testee, page jamais ouverte | Les 3 boutons « quand je joue » declares finis apres un `curl` vert sur `/api/jeu` et `/api/status`. La page, elle, etait morte depuis des heures : un litteral JS `'...'` coupe par un **vrai retour a la ligne** (ligne 722) -> `SyntaxError` -> le bloc `<script>` entier ne se parse pas -> aucun JS, aucun `/api/status`, jauges vides, interrupteur fige sur sa position par defaut. the operator a lu « thinking OFF » alors que l'API repondait `thinking_on: true`. | `curl` prouve la route, pas l'interface. Apres toute edition d'`index.html` : extraire chaque bloc `<script>` et le passer a `node --check`, **puis** ouvrir la page et lire la console. « Fait » = le navigateur a fait la requete. |
| Consigne de longueur qui bride le fond | J'avais mis « resultat d'abord, **en 1-3 phrases** » dans le SOUL, « **en une phrase** » a 7 endroits, « **1-4 phrases** » dans les skills, « meme **longueur** » dans la relecture. Resultat : « dis-moi tout ce que tu sais faire » -> **712 caracteres**. Les memes plafonds retires : **11 215 caracteres** sur la MEME question, en sections, avec ce qu'il ne sait pas faire. the operator : « je veux qu'il dise tout ce qu'ils veulent ... et si sa reponse est longue je m'en fous ». | Un plafond de longueur ne rend pas concis, il **fait taire**. Cadrer l'ORDRE (resultat d'abord) et la RIGUEUR (rien d'affirme sans verification), jamais le NOMBRE DE PHRASES. Corollaire mesure : `RELECTURE_MAX` doit suivre, sinon le controle qualite se coupe pile quand il commence a ecrire long. |
| Il memorise l'ordre au lieu de l'executer | « enleve dans ta memoire X » -> ANW appelle `memory` **en ecriture**, note « quand l'utilisateur dit "enleve", je Cire ... en 2 lignes max », repond « c'est note ». Trois defauts : action transformee en regle, mot invente (« je Cire »), et il recopie dedans le plafond qu'on lui demandait d'enlever. | Cause probable de ma part : le conseil du pont disait « note-la avec memory **en une ligne** » -- une demande de suppression ecrasee en une ligne, avec un mot invente pour tenir dedans. Ne jamais demander a un modele de **compresser** ce qu'il ecrit en memoire. Et verifier sur le disque qu'une suppression demandee a bien **retire** quelque chose, jamais croire « c'est note ». |
| Consigne de format vs convertisseur | La regle « pas de tableau, Discord ne les rend pas » ajoutee au SOUL a saute **trois fois de suite** apres un `/reset` propre. Un Q2_K local suit une consigne de format de facon **probabiliste**. | Un format qui doit TOUJOURS tenir se met dans le **code** (`transform_llm_output`), pas dans le prompt. `tableaux_en_listes()` convertit chaque tableau markdown en liste avant l'envoi : deterministe, testable, 11 tests. |
| Trois bugs dans mon propre convertisseur | (1) la ligne `\|---\|---\|` comptee comme une donnee -> `- **---** — Outil : ---` ; mes tests etaient **verts** parce qu'ils verifiaient la presence du contenu, jamais l'absence du parasite. (2) un ``` orphelin desactivait la conversion pour tout le reste du message. (3) la vraie cause : le modele emballe **toute sa reponse** dans ```markdown, donc les tableaux etaient « dans du code ». | Un test qui n'interdit rien ne prouve rien : mettre le parasite exact dans `doit_pas_contenir`. Et rejouer la **vraie sortie** (recuperee dans `state.db`, table `messages`), pas seulement des cas fabriques -- les trois bugs ne sont sortis que la. Chaque correctif vu **rouge** sur son cas reel avant d'etre applique. |
| Afficheur qui invente un etat | L'interrupteur thinking peignait OFF tant que `/api/status` n'etait pas revenu — indistinguable d'un vrai OFF. | Trois positions, pas deux : ON / OFF / **pas encore connu** (classe `unknown`, bouton centre et grise), et le clic refuse de basculer depuis l'inconnu — il relit d'abord. Un afficheur d'etat n'a jamais le droit de deviner. |

## 7. Couverture au 05/09/2026 (à re-mesurer, pas à recopier)

66 exercices, 270 points, 27 réflexes dont 24 exercés. Au 05/09 16:10 : **50 sur 66 jamais
posés** selon le carnet, et le moteur de sélection voit désormais le même chiffre — il en
voyait 46 tant que `state.json` gardait 4 entrées fantômes (corrigé par `historique_reel`).
Ces nombres se **re-mesurent**, ils ne se recopient pas.
Trois réflexes au catalogue sans aucun exercice : `next-steps-interdit`, `reponse-manquante`,
`resultat-dabord` — écrire ces exercices est un chantier ouvert.

## 8. Restart et `/reset`

```bash
wsl -u YOU -- bash -lc "systemctl --user restart hermes-gateway-anw && sleep 9 && systemctl --user is-active hermes-gateway-anw"
```

Avant : vérifier qu'aucun tour de the operator n'est en vol (`grep 'conversation turn' agent.log | tail -1`
sans `response ready` plus récent), et créer le fichier `pause` dans
`C:\Users\YOU\AppData\Local\anw-watchdog\` (le gardien relance sinon), puis le retirer.

`/reset` se tape dans `#anw` via claude-in-chrome sur le Brave de the operator (le picker liste
deux `/reset`, ANW est le **premier**). Nécessaire seulement après un changement de
config / SOUL / skills / hooks — pas après un changement de routeur.
