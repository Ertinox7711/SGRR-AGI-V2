---
description: Lister tout ce qui est reellement invocable en slash dans CETTE session — commandes perso, skills perso, commandes et skills de plugins — avec leur source sur le disque, et signaler ce qui est installe mais pas charge.
argument-hint: "[filtre optionnel, ex 'hermes', 'shopify', '<retired-bot>']"
allowed-tools: Read, Glob, Grep, Bash
---

Inventaire des slash commands **de cette session**. Filtre : `$ARGUMENTS`

Depuis Claude Code 2.1.x les commandes personnalisees et les skills sont
fusionnes dans le meme menu `/`. Le menu n'est donc pas vide : il est **noye**.
Cette commande sert a retrouver ce qui existe vraiment.

## Regles de nommage (verite disque, ne pas deviner)

- Commande perso = un fichier sous `C:\Users\YOU\.claude\commands\`.
  `foo.md` donne `/foo` · `bar/foo.md` donne `/bar:foo` · `bar/baz/foo.md`
  donne `/bar:baz:foo`.
- Skill perso = un dossier sous `C:\Users\YOU\.claude\skills\<nom>\SKILL.md`.
  **Un SKILL.md sans frontmatter `name:` + `description:` n'apparait pas dans
  le menu** — c'est le mode de disparition silencieuse le plus frequent.
- Commande de plugin = `<plugin>/commands/*.md`, invoquee `/<plugin>:<nom>`,
  et **seulement si le plugin est a `true`** dans `enabledPlugins` de
  `C:\Users\YOU\.claude\settings.json`.

## Ce que tu fais

1. Liste les commandes perso :
   `Glob C:\Users\YOU\.claude\commands\**\*.md` — donne le nom d'invocation
   de chacune, plus sa `description` lue dans le frontmatter.
2. Liste les skills perso et **repere ceux sans frontmatter valide** (ils sont
   installes mais muets) :
   `Glob C:\Users\YOU\.claude\skills\**\SKILL.md`
3. Lis `enabledPlugins` dans `settings.json`, puis pour chaque plugin **actif**
   liste `C:\Users\YOU\.claude\plugins\marketplaces\*\plugins\<plugin>\commands\*.md`.
   Signale separement les plugins a `false` : leurs commandes existent sur le
   disque mais ne sont pas chargees.
4. Compare a la liste de skills reellement injectee dans cette session. Ce qui
   est sur le disque mais absent de la session = **installe, non charge** —
   dis-le explicitement, c'est l'information utile.

## Piege de version

Le binaire du terminal et l'app Desktop peuvent etre a des versions
differentes : dans ce cas les deux menus `/` ne sont pas les memes. Verifie
avec `claude --version` et signale l'ecart s'il existe, plutot que de conclure
qu'une commande a disparu.

Rends un tableau court groupe par source, filtre par `$ARGUMENTS` s'il y en a
un. Pas de recitation complete si un filtre est donne.
