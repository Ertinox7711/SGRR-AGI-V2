# 🧠 Fonctionnement — le verso complet

Ce document explique **comment chaque pièce marche**, **pourquoi elle est là**, et —
en fin de page — **les trucs auxquels on ne pense pas** mais qui font 80 % de la
différence entre un Claude Code « normal » et un agent qui se comporte comme une AGI.

> TL;DR : l'intelligence vient de Claude (le modèle). Ce repo, c'est le **scaffold**
> qui décide *comment* cette intelligence est cadrée, nourrie en contexte, et
> protégée. Une recette, pas un cerveau.

---

## 0. La carte mentale

```
            ┌─────────────────────────────────────────────┐
            │                  CLAUDE (Opus)               │  ← l'intelligence
            └─────────────────────────────────────────────┘
                                │ orchestré par ↓
   ┌──────────┬──────────┬──────────┬──────────┬──────────┬──────────┐
   │ settings │  hooks   │ mémoire  │   MCP    │ plugins  │  rules   │  ← le scaffold (ce repo)
   │ permis-  │ contexte │ fichiers │ docs/web │ skills + │ contexte │
   │ sions    │ par tour │ durables │ live     │ agents   │ paresseux│
   └──────────┴──────────┴──────────┴──────────┴──────────┴──────────┘
                                │ produit ↓
            Commande  →  Agent (sous-agent)  →  Skill
            (entrée)     (spécialiste isolé)    (savoir réutilisable)
```

---

## 1. `settings.json` — le seul truc qui est *vraiment* appliqué

La distinction la plus importante de tout le setup :

> **La prose dans `CLAUDE.md` est une suggestion. `settings.json` est une loi.**

`CLAUDE.md` dit « confirme avant un `rm -rf` ». Mais c'est du texte — le modèle peut
le rater sous pression. `settings.json` `permissions.ask` *intercepte la commande
avant exécution* et te demande. C'est le seul filet réellement contraignant.

Notre template fait 3 choses :

1. **Filet de permissions** — `allow` large (pour ne pas spammer de prompts sur le
   travail trivial), mais un gate `ask` explicite sur **chaque** commande destructive :
   `rm`, `rmdir`, `shred`, `dd`, `mkfs`, `fdisk`, `chmod`, `chown`, `kill`, `pkill`,
   `git push --force`, `git reset --hard`, `git clean`, `npm publish`, `docker`,
   `kubectl`, `gcloud`, `firebase`. `deny` est vide par défaut (tu ajoutes tes
   interdits durs si besoin).

2. **Sous-agents pas chers** — `env.CLAUDE_CODE_SUBAGENT_MODEL: "sonnet"`. La boucle
   principale reste sur Opus (intelligence max), mais quand tu lances un sous-agent
   (explorer, reviewer…), il tourne sur Sonnet. Tu paies Sonnet pour le grunt-work,
   Opus pour le raisonnement. Énorme économie sur les gros chantiers.

3. **`defaultMode: acceptEdits`** — les edits de fichiers passent sans confirmation
   (réversibles, c'est du local), pendant que les commandes dangereuses restent
   gatées par `ask`. Le bon équilibre vitesse/sécurité.

## 2. Hooks — l'injection de contexte par tour

Les hooks lancent une commande à des moments clés et **injectent leur sortie dans le
contexte de Claude**. On les utilise pour des piqûres de rappel automatiques :

| Hook | Quand | Ce qu'il injecte |
|------|-------|------------------|
| `SessionStart` | début de session | « Lis MEMORY.md. Anticipe, parallélise, vérifie avant de dire fait. » |
| `UserPromptSubmit` | à chaque message | « Avant un commit client/ : `npx tsc --noEmit`. Commits atomiques. Vérifie avant fait. » |
| `PreCompact` | avant compression du contexte | « Sauve les faits durables en mémoire avant de perdre le contexte. » |
| `Stop` | fin de tour | « Si du code a changé : tests passent ? tsc clean ? rien d'oublié non commité ? » |

C'est ça qui maintient la discipline **sans que tu aies à la répéter**. Le modèle
oublie ? Le hook lui re-dit, chaque tour. La version Windows utilise PowerShell ; la
variante `settings.template.unix.json` utilise `echo`.

## 3. Mémoire — des fichiers, pas une base de données

`~/.claude/memory/` contient un fichier par fait, plus un index `MEMORY.md` chargé à
chaque session. Chaque fichier a un frontmatter (`name`, `description`, `type`).

Pourquoi des fichiers : versionnable, lisible, éditable à la main, zéro dépendance.
Le hook `SessionStart` rappelle de le lire ; `PreCompact` rappelle d'y écrire avant
de perdre le contexte. Types : `user` (qui tu es), `feedback` (comment bosser),
`project` (faits non dérivables du code), `reference` (URLs/dashboards).

Règle d'or : **ne sauvegarde jamais ce que le repo sait déjà** (structure du code,
git log, conventions). La mémoire, c'est pour le non-dérivable.

## 4. MCP — les sens de l'agent

Les serveurs MCP donnent à Claude des capacités hors-modèle :
- **context7** → docs de librairies **à jour** (pas la connaissance figée du modèle).
- **playwright** → piloter un vrai navigateur (tester une UI, scraper du DOM).

Réflexe clé encodé dans `CLAUDE.md` : sur un **403 / bot-block**, ne bricole pas des
headers — bascule sur **Scrapling** (stealth fetch). C'est un de ces réglages
« niveau global » qui résout 90 % des galères de scraping d'un coup.

## 5. Plugins — skills + sous-agents packagés

Un plugin apporte des skills, des commandes slash, parfois des serveurs MCP. Le socle :
- **superpowers** → le système de skills (brainstorming, TDD, debugging, planning).
  C'est la colonne vertébrale ; presque tout en dépend.
- **feature-dev** → sous-agents architecte / explorer / reviewer.
- **code-review**, **pr-review-toolkit** → review de diff et de PR multi-agents.
- **frontend-design** → UI non générique.
- **commit-commands**, **github** → flux git/GitHub.
- **context7**, **playwright**, **typescript-lsp** → docs live, navigateur, LSP TS.
- **caveman** → mode de sortie terse (optionnel, cosmétique).

## 6. Rules — le contexte qui ne se charge que quand il faut

Une rule dans `~/.claude/rules/*.md` avec un frontmatter `paths:` se charge
**uniquement** quand Claude touche un fichier qui matche le glob. Contrairement à
`CLAUDE.md` (chargé à chaque session), une rule ne pèse rien tant que tu n'es pas dans
le bon projet.

C'est LE truc pour scaler : tu peux avoir 20 projets avec chacun ses règles
d'autonomie, sans alourdir d'un octet une session qui n'y touche pas.

## 7. Le patron canonique : Commande → Agent → Skill

- **Commande** (`/ma-commande`) = point d'entrée, orchestrateur léger.
- **Agent (sous-agent)** = spécialiste avec un jeu d'outils restreint et un **contexte
  isolé** — il fait son travail sans polluer ton contexte principal, et te renvoie
  juste sa conclusion.
- **Skill** = un savoir/procédure réutilisable, injecté dans le contexte au besoin.

La composition : une commande dispatche un ou plusieurs agents ; chaque agent invoque
les skills pertinentes. Isolation de contexte + spécialisation + réutilisation.

---

## 🎁 Les trucs auxquels on ne pense pas

Ceux qui font la vraie différence et que 95 % des gens ratent :

1. **`CLAUDE_CODE_SUBAGENT_MODEL: sonnet` = diviser la facture par ~5** sur les gros
   chantiers, sans perdre en qualité de raisonnement (Opus reste sur la boucle qui
   décide). La plupart laissent tout sur Opus et brûlent leur quota.

2. **Le filet `ask`, pas la prose.** Écrire « sois prudent » dans CLAUDE.md ne protège
   rien. Le seul garde-fou réel, c'est `permissions.ask`. Mets-y tes commandes
   destructives, point.

3. **Les hooks battent la mémoire pour la discipline.** Tu peux écrire « commits
   atomiques » 10 fois dans CLAUDE.md, le modèle dérive. Un hook `UserPromptSubmit`
   le re-injecte *chaque tour* — c'est ça qui tient.

4. **Parallélise les tool calls indépendants.** Un seul message avec 5 appels d'outils
   indépendants = 5× plus rapide que 5 messages. Encodé dans CLAUDE.md comme réflexe.

5. **`paths:` rules > un gros CLAUDE.md.** Tout entasser dans CLAUDE.md pourrit le
   contexte de chaque session. Le contexte paresseux par projet garde l'agent vif.

6. **Mémoire = non-dérivable seulement.** Sauver des trucs que le code/git dit déjà,
   c'est du bruit qui noie les vrais faits. Discipline : un fait par fichier, et
   seulement s'il n'est pas re-dérivable.

7. **Le réflexe 403 → Scrapling.** Un seul réglage global qui transforme « le scraping
   marche pas » en « le scraping marche ». Avant de bricoler des headers : stealth fetch.

8. **Sauvegarde avant d'écraser.** L'installeur fait des `.bak-<date>` de ton
   `settings.json`/`CLAUDE.md` existants. Jamais détruire une config sans backup —
   évident une fois qu'on s'est fait avoir une fois.

9. **`effortLevel: medium` est un curseur.** Monte-le quand tu veux du raisonnement
   profond, baisse-le pour du débit. Peu de gens savent que ça existe.

10. **Sécurité du *partage* du setup.** Le piège invisible : ton setup contient tes
    secrets, ton email (jusque dans l'auteur des commits git !), tes chemins, tes noms
    de projets. Partager le rig sans le scrubber, c'est une fuite. Tout ce repo est
    construit pour partager la **capacité** sans la **donnée perso** → [`SECURITE.md`](SECURITE.md).

---

Suite logique : [`SECURITE.md`](SECURITE.md) (modèle de menace + garanties), puis
[`INSTALLER-PROMPT.md`](INSTALLER-PROMPT.md) (le prompt unique) ou [`SETUP.md`](SETUP.md)
(à la main).
