# LIS-MOI D'ABORD — squelette de boutique NON ACTIVÉ

Ce dossier est un **squelette générique** (clone structurel de SHOP-B, purgé de tout ce qui est ventilateurs/SHOP-B). Il n'a **pas encore de nom, pas de handle, pas de token**. Tant qu'il s'appelle `_newshop`, il n'existe **pas** dans le registre `~/.claude/shops-registry.md` → aucun hook ne le protège, aucune API n'est joignable. C'est voulu.

## Activer la boutique (1 commande, quand tu as le nom)

Depuis n'importe où :

```bash
powershell -NoProfile -File "C:/Users/YOU/Documents/BUSINESS/_newshop/scripts/init-shop.ps1" -Name "MonNom" -Niche "ma niche en anglais" -Currency EUR
```

Options : `-Handle xxxxxx-yy` (si la boutique Shopify existe déjà) · `-NicheFr "niche en français"` · `-App MONNOM-API` · `-Folder monnom` (nom de dossier si différent du slug auto) · `-DryRun` (affiche tout, n'écrit rien).

⚠ Si le nom contient des **accents**, lancer depuis **PowerShell** (pas depuis bash/Git Bash : le passage d'arguments accentués y est mangé). Le slug du dossier, lui, est toujours désaccentué (`Lumèa` → `lumea`).

Le script fait, dans l'ordre, **tout** ce que la procédure « ajouter la boutique #N » du registre demande :

1. **Renomme** `_newshop` → `<slug>` (il se recopie dans `%TEMP%` avant, pour ne pas se verrouiller lui-même).
2. **Remplace tous les placeholders** `__SHOP_NAME__` / `__NICHE__` / `<TODO>` / … dans chaque `.md`, `.js`, `.sh`, `.json` du dossier.
3. **Ajoute UNE ligne** dans `~/.claude/shops-registry.md` (abort si le nom, le dossier ou le handle existe déjà).
4. Lance **`shops-registry-sync.ps1`** → régénère le `.json` que lisent les 4 hooks d'identité (invariants vérifiés : zéro doublon).
5. Lance **`shops-banner.ps1`** → stampe le banner d'identité entre les marqueurs `BANNER:START/END` du `CLAUDE.md`.
6. Crée le **dossier mémoire projet** `~/.claude/projects/C--Users-YOU-Documents-BUSINESS-<slug>/memory/` + un `MEMORY.md` vierge.
7. Réécrit ce fichier en `README-INIT.done.md` (trace de ce qui a été posé).

Après ça : la boutique est une citoyenne de plein droit du système multi-boutiques (hooks d'identité, gate token, double-confirmation, banner au SessionStart).

## Puis, dans l'ordre

1. Créer la boutique Shopify + l'app custom (Dev Dashboard, OAuth `client_credentials`) → `.secrets/app-credentials.txt` (modèle dans `.secrets/app-credentials.txt.example`).
2. `bash scripts/get-token.sh` → `.secrets/access-token.txt` (24 h).
3. `node scripts/shop-probe.js` → **preuve live** que le token atteint bien CETTE boutique (et pas une autre).
4. Compléter le handle/domaine dans le banner **et** la ligne du registre, re-run `shops-registry-sync.ps1`.
5. Suivre [`docs/LAUNCH-CHECKLIST.md`](docs/LAUNCH-CHECKLIST.md) — le runbook de lancement complet, écrit à partir de ce qui a réellement été fait (et raté) sur SHOP-B.

## Ce que le squelette contient déjà

| Fichier | Rôle |
|---|---|
| `CLAUDE.md` | Mémoire maître + banner d'identité + règles opératoires + leçons héritées |
| `SESSION-INIT.md` | Rituel §0 de verrou d'identité (à faire au début de CHAQUE session) |
| `scripts/get-token.sh`, `shop-context.sh` | Token 24 h + contexte boutique dérivé du dossier (store-agnostic, zéro handle en dur) |
| `scripts/lib/shop.js` | Helper Node : identité dérivée du registre, `gql()`, `assertShop()`, `mainThemeId()`, gate `--go` sur les mutations |
| `scripts/shop-probe.js` | Preuve live d'identité (nom, domaine, devise, thème MAIN, compteurs) |
| `scripts/push-any.js` | Upsert de fichiers thème + read-back + purge (garde d'identité automatique) |
| `scripts/pull-theme-file.js` | Pull d'un fichier thème live (le live est l'autorité, pas le local) |
| `scripts/theme-purge-cache.js` | Purge du `page_cache` via `themePublish` + preuve etag |
| `scripts/init-shop.ps1` | L'activation décrite ci-dessus |
| `docs/LAUNCH-CHECKLIST.md` | Runbook de lancement (technique → contenu → légal → ads) |
| `docs/PITFALLS-HERITES.md` | Les pièges déjà payés ailleurs. **À lire avant de coder du Liquid/API.** |
| `docs/GMC-GATES.md` | Les gates légaux/Merchant Center (misrepresentation = ban compte) |
| `docs/BRAND-BRIEF.md` | Brief de marque à remplir (nom, promesse, DA, ton) |
| `docs/DESIGN-SYSTEM.md` | Tokens de DA à verrouiller AVANT d'écrire la moindre section |
| `data/`, `docs/`, `sections/`, `snippets/`, `blocks/`, `tools/` | Dossiers prêts, chacun avec son `CLAUDE.md` ou `.gitkeep` |
