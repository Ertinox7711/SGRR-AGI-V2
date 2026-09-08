---
name: training-anw
description: Use when the operator says "anw", "on entraîne ANW", "training ANW", "continue ANW", or opens any session about making the local bot Always Need Wins reason/code/act better, reach Opus-5 level, or score on agentic benchmarks (SWE-bench, Terminal-Bench, tau-bench, GPQA)
---

# Entraîner ANW

ANW (`Always Need Wins`) est le bot local de the operator : **Qwen3.8-27B dense** (tag
`anw-38:latest`, UD-IQ3_S, 12,04 Go) sur sa RTX 3080 Laptop 16 Go, zéro cloud. Les tags
Qwen 3.6 MoE (`anw-v2`, `anw-fast`, `anw-v3`) ont été **supprimés le 06/09/2026** : ne plus
jamais les citer comme actifs, et ne pas transposer les réglages du MoE au dense. Le mandat est de l'amener au niveau d'Opus 5 sur ce qui se mesure — raisonner,
coder, agir — et d'y arriver **par la mesure, pas par l'intuition**.

**Le principe qui gouverne tout : un banc saturé ne prouve rien.** La banque b4 rendait
39/39 avant le moindre skill. Un plafond ne bouge pas, donc il n'enseigne rien. Chaque
séance commence donc par lire ce qui est mesuré *et* ce qui ne l'est pas.

Avant d'agir, invoquer aussi `operating-hermes-bots` : il porte le prompt figé par session,
le restart, le `/reset`, et le journal obligatoire.

## La boucle — dans cet ordre, à chaque séance

1. **Lire l'état.** Une commande, lecture seule (voir `reference.md`). Elle sort : le taux
   par famille **avec le nombre de tirs**, ce qui n'a jamais été posé, et une cible.
2. **Choisir la cible.** Une seule doctrine, dans `anw_etat.ordre_de_pose()` — le tableau
   de bord *et* le cron 6×/jour l'appellent, un test vérifie qu'ils proposent la même chose.
   Elle dit, dans cet ordre : (a) un exercice **jamais posé** passe avant tout re-tir, on
   n'en sait rien ; (b) entre deux, la **famille la plus urgente** = d'abord celles à moins
   de **5 tirs** (`TIRS_CREDIBLES`), parce qu'on ne peut pas encore dire qu'elles vont bien,
   puis les autres par taux croissant ; (c) ensuite seulement, les déjà posés, du plus
   mauvais dernier tir au meilleur. La contredire demande une raison écrite.
3. **Poser et mesurer.** `prochaine.txt` + les deux crons. **`prochaine.txt` est à usage
   unique** : la pose le consomme. S'il est absent — le cas six fois par jour — le cron
   choisit lui-même via la doctrine ci-dessus ; il n'attend pas qu'on lui dise. Le verdict se
   lit sur le disque (fichiers, nombres, horodatages), jamais dans une phrase — un correcteur
   LLM dérive avec le modèle qu'il note.
4. **Réparer la cause, pas le symptôme.** Un raté se répare dans le routeur, la banque ou
   le SOUL — puis on **re-pose le même exercice** et on compare les deux notes. Sans
   avant/après, la réparation est une croyance.
5. **Écrire.** Journal `operating-hermes-bots/journal.md` + mémoire `anw-profile-local-bot`.
   Ce qui n'est pas écrit meurt avec la session.

## Les familles = les benchmarks

Chaque réflexe du catalogue appartient à **une** famille, et chaque famille répond à un banc
public. C'est la carte qui dit où ANW est faible pour de vrai.

| Famille | Ce qu'elle mesure | Parent public |
|---|---|---|
| `agentique` | agir vraiment : fichiers, terminal, commits, idempotence | SWE-bench, Terminal-Bench |
| `raisonnement` | chiffres, seuils, inversions, ordre | GPQA, AIME |
| `fidelite` | ne pas affirmer ce qu'on n'a pas vu | hallucination / faithfulness |
| `discipline` | tenir la consigne sous pression, ne pas contourner | tau-bench |
| `surete` | ne pas casser les affaires de the operator | règle dure maison |

`agentique` est la priorité de the operator. Mais on ne la travaille pas si une autre famille est
plus basse **sur assez de tirs** — assez = **5** (`TIRS_CREDIBLES`, `anw_etat.py`). En
dessous, le taux est marqué `n faible` : il n'est pas faux, il ne tranche rien. Une famille
sous-mesurée passe donc **avant** une faiblesse déjà établie : on ne sait pas encore si elle
est pire — c'est peut-être elle, le vrai maillon faible.

## Règles dures

- **ANW-LAB seulement.** ANW crée ses propres dossiers dans `Documents\ANW-LAB`. Il ne
  touche **rien** de ce qui existe déjà.
- **Zéro cloud pour ANW** : `fallback_providers: []`, aucun token Anthropic dans son `.env`,
  jamais `--provider custom` sur ce profil (une évasion payante a déjà eu lieu le 04/09).
- **Ajouter oui, supprimer jamais seul.** Modèles Ollama, profils, tokens, backups `.bak-*`,
  et **le carnet `results.jsonl`** : purger demande le GO de the operator, item par item.
- **ANW ne change jamais son modèle.** Seul the operator, via `/model` dans `#anw`.
- **Ollama arrêté = the operator joue.** Ne pas le relancer sans lui demander. Jamais
  `ollama ps` / `ollama list` depuis ici — `curl.exe` sur `/api/version`, `/api/tags`, `/api/ps`.

## Drapeaux rouges — la pensée qui précède l'erreur

| Ce que je me dis | Ce qui est vrai |
|---|---|
| « le taux est bon, ça avance » | Un taux sans son nombre de tirs ne dit rien. 2/2 n'est pas 100 %. |
| « le banc est vert, c'est réparé » | Vert peut vouloir dire « rien n'est vérifié ». Faire échouer la garde exprès. |
| « ça a marché une fois » | n=1. Le dire comme tel, ou re-tirer. |
| « je vois la cause » | La cause se **mesure** (avant/après, module par module), elle ne se devine pas. |
| « il faut redémarrer la gateway » | Un changement de routeur/déclencheur ne demande qu'un restart. Config/SOUL/skills → restart **+ `/reset`**. |
| « je crée le truc, ça suffit » | Verbatim de the operator : « **faut pas juste créer le truc, après faut tester si tout marche** ». |

## Suite

Commandes exactes, ids de crons, carte des fichiers, et le registre des pièges déjà payés
(avec leur date) → `reference.md` de ce dossier.
