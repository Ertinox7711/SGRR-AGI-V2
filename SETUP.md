# Setup — Manifeste d'installation manuel

> ⚡ **Tu veux le faire en 1 prompt ?** Ouvre [`INSTALLER-PROMPT.md`](INSTALLER-PROMPT.md)
> et colle son contenu dans Claude Code. Ce fichier-ci, c'est la version **manuelle**,
> étape par étape, si tu préfères tout contrôler à la main. ~15 min.

---

## 1. Plugins

Les plugins Claude Code s'installent depuis des marketplaces. L'officielle est livrée
par défaut. Ajoute la marketplace `caveman` une fois :

```
/plugin marketplace add JuliusBrussee/caveman
```

Puis active ceux-ci (via le menu `/plugin`, ou ils sont pré-listés dans
`settings.template.json`) :

| Plugin | Marketplace | Pourquoi |
|--------|-------------|----------|
| `superpowers` | officielle | Système de skills — brainstorming, TDD, debugging, workflows de planning. La colonne vertébrale. |
| `feature-dev` | officielle | Sous-agents architecte / explorer / reviewer pour le travail de feature. |
| `code-review` | officielle | `/code-review` sur le diff courant. |
| `pr-review-toolkit` | officielle | Review de PR multi-agents (silent-failure hunter, type-design, etc.). |
| `frontend-design` | officielle | Génération d'UI distinctive, non générique. |
| `commit-commands` | officielle | `/commit`, helpers commit-push-PR. |
| `security-guidance` | officielle | Skill de security-review + garde-fous. |
| `github` | officielle | Opérations GitHub depuis Claude. |
| `context7` | officielle | Docs de librairies en live (MCP). |
| `playwright` | officielle | Automatisation navigateur (MCP). |
| `typescript-lsp` | officielle | Vrai language server TS (defs, refs, diagnostics). |
| `caveman` | caveman | Optionnel — mode de sortie « caveman » terse + statusline. |

Optionnels / off par défaut : `skill-creator`, `claude-md-management`, `hookify`,
`pyright-lsp`, `ralph-loop`, `firebase`.

## 2. settings.json

```
# Windows
cp settings.template.json  $env:USERPROFILE\.claude\settings.json
# macOS / Linux
cp settings.template.unix.json  ~/.claude/settings.json
```

Puis remplis les placeholders :
- `additionalDirectories` → tes dossiers projets supplémentaires (ou supprime la clé).
- Le bloc `hooks` du template Windows utilise **PowerShell**. La variante
  `settings.template.unix.json` fournit l'équivalent `echo` pour macOS/Linux.

Ce que ce fichier settings t'apporte :
- **Filet de permissions** — `allow` large, mais un gate `ask` sur chaque commande
  destructive (`rm`, `dd`, `mkfs`, `chmod`, `kill`, `git push --force`,
  `git reset --hard`, `docker`, `kubectl`, `gcloud`, `npm publish`). La prose dans
  CLAUDE.md n'est *pas* appliquée ; ces règles, *si*.
- **Sous-agents pas chers** — `CLAUDE_CODE_SUBAGENT_MODEL: sonnet` fait tourner les
  sous-agents sur Sonnet pendant que tu gardes Opus sur la boucle principale.
- **Hooks d'injection de contexte** — chaque tour rappelle : run `tsc` avant commit,
  sauve les faits durables en mémoire, vérifie avant de dire « fait ».

## 3. CLAUDE.md

```
cp CLAUDE.md  ~/.claude/CLAUDE.md   # ($env:USERPROFILE sur Windows)
```

Remplis les blocs `<PLACEHOLDER>`. Sors les règles d'autonomie spécifiques d'un projet
de ce fichier toujours-chargé et mets-les dans `rules/*.md` avec un frontmatter
`paths:` (voir étape 5) — ça garde ton contexte global léger.

## 4. Mémoire

```
mkdir ~/.claude/memory
cp memory/MEMORY.md  ~/.claude/memory/MEMORY.md
```

Un fait par fichier, indexé par une ligne dans `MEMORY.md`. Le format est spécifié
dans ce fichier.

## 5. Rules (contexte paresseux)

```
mkdir ~/.claude/rules
cp rules/example-project.md  ~/.claude/rules/
```

Une rule avec frontmatter `paths:` se charge **uniquement** quand Claude touche un
fichier qui matche — contrairement à `CLAUDE.md`, qui se charge à chaque session.
Utilise ça pour les blocs d'autonomie par projet, pour qu'ils n'alourdissent pas les
sessions sans rapport.

## 6. Skills

Les grosses librairies de skills sont **le travail d'autres gens** — installe depuis
la source, ne copie pas. La plupart arrivent *avec* les plugins ci-dessus (ex :
`superpowers` amène son jeu de skills). Pour les packs de skills autonomes, ajoute
leur marketplace et active selon leur README. Respecte la licence de chaque pack.

---

Fini. Redémarre Claude Code. Vérifie avec `/plugin` (plugins activés) et un petit
`/help` (skills listés).
