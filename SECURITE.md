# 🔒 Sécurité & modèle de menace

Ce repo est conçu pour une hypothèse précise : **quelqu'un de malin va le lire ligne
par ligne, fouiller l'historique git, et tester chaque fichier pour en extraire des
infos sur le propriétaire.** Tout ici est construit pour qu'il n'y ait **rien à
trouver**.

> Principe : on partage la **capacité** (la recette), jamais la **donnée** (secrets,
> identité, projets privés). Si une info n'est pas nécessaire pour reproduire le rig,
> elle n'est pas dans le repo.

---

## 1. Modèle de menace — contre quoi on défend

| Attaquant | Ce qu'il tente | Notre défense |
|-----------|----------------|---------------|
| **Le curieux** | Lire les fichiers pour trouver un nom, un email, un projet | 0 donnée perso ; tout est `<PLACEHOLDER>` |
| **Le fouineur git** | `git log`, `git blame`, anciens commits pour un email d'auteur ou un secret supprimé | Auteur anonymisé ; historique réécrit propre ; jamais de secret commité (donc rien à retrouver) |
| **Le scanner auto** | Bot qui scanne GitHub pour clés API / tokens | Aucun secret n'existe dans le repo ; `.gitignore` + gitleaks + hook pre-commit le garantissent en continu |
| **L'ingénieur social** | Recouper noms de projets / personas / habitudes pour profiler | Aucun nom de projet privé, persona, ou business n'est listé ni référencé |
| **Le copieur négligent** | Un ami qui fork et re-push **ses** secrets par accident | `.gitignore` blinde les formes de secrets ; `preflight-scrub` + pre-commit l'arrêtent avant le push |

---

## 2. Ce qui n'est **jamais** dans ce repo

- ❌ Tokens, clés API, credentials (Shopify, Stripe, Anthropic, OpenAI… aucun).
- ❌ Email réel — **y compris dans l'auteur des commits git** (piège classique).
- ❌ Vrai nom, pseudo lié à l'identité réelle, handle Discord, IDs de serveurs.
- ❌ Chemins absolus de la machine (`C:\Users\...`, `/home/...`).
- ❌ Noms de projets privés, business, automations perso, personas.
- ❌ `settings.local.json`, `.credentials.json`, historiques, caches, logs.

## 3. Les couches de défense (defense-in-depth)

La sécurité n'est pas un fichier, c'est **5 couches** qui se rattrapent l'une l'autre :

### Couche 1 — `.gitignore` (prévention)
Hard-block des **formes** de secrets et des fichiers sensibles, pas juste des noms
précis : `*.env`, `.env*`, `*secret*`, `*token*`, `*apikey*`, `*.key`, `*.pem`,
`.credentials.json`, `settings.local.json`, et des préfixes de tokens connus
(`shpat_*`, `sk-*`, `rk_*`, `shpss_*`…). Un secret de cette forme ne peut pas être
ajouté par accident.

### Couche 2 — Templates scrubbés (pas d'original)
`settings.json` et `CLAUDE.md` sont fournis en **`.template`** déjà nettoyés. La donnée
sensible est remplacée par `<PLACEHOLDER>`. Il n'y a pas de version « vraie » à fuiter
parce qu'elle n'a jamais été commitée.

### Couche 3 — Hook `pre-commit` (barrage local)
`scripts/hooks/pre-commit` scanne le diff **staged** avant chaque commit et **refuse**
le commit si un motif de secret apparaît (clé API, email réel, chemin absolu, préfixe
de token). Le secret n'atteint jamais l'historique.

### Couche 4 — `preflight-scrub` (audit manuel)
`scripts/preflight-scrub.ps1` (et `.sh`) scanne **tout le repo** à la demande et liste
toute fuite potentielle. À lancer avant un premier push public, ou après un gros ajout.

### Couche 5 — GitHub Actions (défense continue)
`.github/workflows/secret-scan.yml` relance **gitleaks** à **chaque push et chaque PR**.
Même si une couche locale est contournée, le scan côté serveur lève l'alerte. C'est le
filet de sécurité qui ne dépend pas de la discipline humaine.

---

## 4. Garanties sur l'historique git

L'auteur des commits est **anonymisé** : aucun email réel, aucun nom réel dans
`git log` / `git blame`. L'historique est réécrit propre avant publication.

Vérifie toi-même :
```bash
git log --format='%an <%ae>' | sort -u    # ne doit montrer aucun email réel
git log -p | grep -Ei 'shpat_|sk-|api[_-]?key|password'   # ne doit rien sortir
```

## 5. Checklist avant de rendre le repo public/partagé

```
[ ] preflight-scrub passe sans alerte      (scripts/preflight-scrub.*)
[ ] git log --format='%ae' | sort -u  →  aucun email réel
[ ] git log -p | grep secrets  →  vide
[ ] aucun nom de projet privé / persona dans les fichiers
[ ] .gitignore présent et couvre *.env, *secret*, *token*, *.key, .credentials.json
[ ] le hook pre-commit est installé (scripts/hooks/pre-commit -> .git/hooks/)
[ ] secret-scan.yml actif (onglet Actions une fois pushé)
[ ] repo réglé en PRIVÉ si destiné à des potes, pas au monde
```

## 6. Pour celui qui installe (toi, l'ami)

- Tes secrets restent **chez toi**. Ce repo ne te demande **aucune** clé.
- Tu fournis ton propre abonnement Claude Code et tes propres clés API, **hors** du repo
  (variables d'environnement, gestionnaire de secrets, `settings.local.json` qui est
  git-ignoré).
- Si tu forkes pour partager **ton** setup à ton tour : relance `preflight-scrub`,
  installe le hook `pre-commit`, et anonymise l'auteur de tes commits **avant** de pousser.

---

## 7. Signaler un problème

Tu as trouvé une fuite, un secret oublié, un chemin perso qui traîne ? C'est un bug de
sécurité. Ouvre une issue **sans recopier la donnée sensible dedans** (décris l'endroit,
pas la valeur), ou corrige et propose une PR. La donnée trouvée doit être purgée de
l'historique, pas seulement du dernier commit.
