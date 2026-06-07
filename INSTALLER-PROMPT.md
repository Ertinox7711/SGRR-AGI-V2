# ⚡ Installation en 1 prompt

Le repo entier s'installe en **collant un seul prompt** dans Claude Code. Claude fait
tout : marketplaces, plugins, `settings.json`, `CLAUDE.md`, mémoire, rules.

---

## Comment faire

1. **Clone** ce repo et ouvre **Claude Code** dans le dossier cloné :
   ```
   git clone <URL_DU_REPO> sgrr-agi-v2
   cd sgrr-agi-v2
   claude
   ```
2. **Copie-colle le bloc ci-dessous** (tout le pavé entre les lignes) dans Claude Code.
3. Claude installe tout, te pose les **2 seules questions** qui dépendent de toi
   (ton nom pour `CLAUDE.md`, tes dossiers projets), et vérifie à la fin.

> 🔒 Aucun secret n'est demandé ni stocké. Tu gardes ton abonnement Claude Code et tes
> propres clés. Voir [`SECURITE.md`](SECURITE.md).

---

## 📋 LE PROMPT — copie tout ce qui suit

```text
Tu es en mode installation. Installe le rig "SGRR AGI V2" depuis le repo courant vers ma
config Claude Code (~/.claude, ou $env:USERPROFILE\.claude sur Windows). Procède de
façon autonome, ne me demande QUE les 2 valeurs perso à la fin. Étapes :

1. DÉTECTE l'OS (Windows / macOS / Linux) et le dossier ~/.claude. Crée-le s'il manque,
   ainsi que ~/.claude/memory et ~/.claude/rules.

2. SAUVEGARDE l'existant. Si ~/.claude/settings.json ou ~/.claude/CLAUDE.md existent
   déjà, copie-les en .bak-<date> avant d'écrire. Ne détruis jamais sans backup.

3. MARKETPLACES + PLUGINS. Exécute :
     /plugin marketplace add JuliusBrussee/caveman
   Puis active ces plugins (officiels sauf caveman) :
     superpowers, feature-dev, code-review, pr-review-toolkit, frontend-design,
     commit-commands, security-guidance, github, context7, playwright, typescript-lsp,
     caveman
   Si une commande /plugin n'est pas scriptable dans ton contexte, écris directement les
   clés enabledPlugins + extraKnownMarketplaces dans settings.json (déjà présentes dans
   le template) et dis-moi de lancer /plugin une fois pour finaliser le téléchargement.

4. SETTINGS. Copie le bon template vers ~/.claude/settings.json :
     - Windows  -> settings.template.json (hooks PowerShell)
     - macOS/Linux -> settings.template.unix.json (hooks sh)
   Fusionne sans écraser mes clés existantes si j'en avais (merge JSON, le template gagne
   sur les clés qu'il définit, garde les miennes en plus).

5. CLAUDE.md. Copie CLAUDE.md du repo vers ~/.claude/CLAUDE.md.

6. MÉMOIRE + RULES. Copie memory/MEMORY.md -> ~/.claude/memory/. Copie
   rules/example-project.md -> ~/.claude/rules/.

7. PERSONNALISE. Maintenant, et seulement maintenant, demande-moi :
     (a) le nom à mettre dans CLAUDE.md / LICENSE (ou "anonyme"),
     (b) mes dossiers projets supplémentaires pour additionalDirectories (ou "aucun").
   Remplace les <PLACEHOLDER> en conséquence. Ne mets jamais d'email réel.

8. VÉRIFIE. Lis ~/.claude/settings.json (JSON valide ?), confirme la présence de
   CLAUDE.md, MEMORY.md, example-project.md. Liste ce qui est installé. Dis-moi de
   redémarrer Claude Code, puis de checker /plugin et /help.

Ne pousse rien sur internet. Ne lis aucun secret. À la fin, résume ce qui a changé
(diff des fichiers ~/.claude touchés) et ce qu'il me reste à faire manuellement.
```

---

## Préfères un script ?

Si tu ne veux pas passer par Claude pour la partie fichiers :

- **Windows** : `./install.ps1`
- **macOS / Linux** : `./install.sh`

Le script copie les fichiers (settings, CLAUDE.md, mémoire, rules) avec backup
automatique de l'existant. Il **n'installe pas** les plugins (ça, c'est `/plugin` dans
Claude Code) — lance ensuite le prompt ci-dessus, ou la commande
`/plugin marketplace add JuliusBrussee/caveman` + l'activation manuelle (voir
[`SETUP.md`](SETUP.md)).

---

## Après l'install

- Redémarre Claude Code.
- `/plugin` → vérifie que les 12 plugins sont activés.
- `/help` → les skills (superpowers…) apparaissent.
- Ouvre `~/.claude/CLAUDE.md` et remplis les derniers `<PLACEHOLDER>` si besoin.
- Lis [`FONCTIONNEMENT.md`](FONCTIONNEMENT.md) pour comprendre **pourquoi** chaque pièce
  est là — et les trucs auxquels tu n'aurais pas pensé.
