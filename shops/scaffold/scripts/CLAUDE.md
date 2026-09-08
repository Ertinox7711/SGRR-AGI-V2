# scripts/ — Outils (__SHOP_NAME__)

> **Tout script qui parle à l'API dérive l'identité du dossier**, jamais d'un handle en dur : bash → `source scripts/shop-context.sh` ; Node → `require('./lib/shop')`. Un script copié d'une autre boutique s'auto-corrige donc à la boutique du dossier où il tourne.

## Socle (déjà là)

| Script | Rôle | Commande |
|---|---|---|
| `get-token.sh` | Régénère le token Admin (OAuth client_credentials) → `.secrets/access-token.txt`, 24 h. **Store-agnostic.** | `bash scripts/get-token.sh` (`-q` = silencieux) |
| `shop-context.sh` | À **sourcer** par tout script bash : exporte `SHOP` / `HANDLE` / `API_DOMAIN` / `AT`. | `source scripts/shop-context.sh` |
| `lib/shop.js` | Helper Node : identité dérivée du registre + creds, `gql()`, `assertShop()`, `mainThemeId()`, `readThemeFiles()`, `upsertThemeFiles()` (read-back inclus), `publishTheme()`, `requireGo()`. | `const shop = require('./lib/shop')` |
| `shop-probe.js` | **Preuve live** d'identité + état (thème MAIN, produits, collections, pages, blogs). `--dump` → `data/_audit-snapshot.json`. | `node scripts/shop-probe.js` |
| `push-any.js` | Upsert de fichiers thème locaux + read-back + purge. DRY par défaut. | `node scripts/push-any.js sections/x.liquid --go` |
| `pull-theme-file.js` | Pull de la version **LIVE** d'un fichier thème (= l'autorité). `--diff` compare au local. | `node scripts/pull-theme-file.js templates/product.json --diff` |
| `theme-purge-cache.js` | `themePublish` sur le thème déjà MAIN → purge le full-page cache + preuve etag. | `node scripts/theme-purge-cache.js --go` |
| `init-shop.ps1` | Activation du squelette (nom, registre, banner, mémoire). ASCII pur. | cf. `README-INIT.md` |

## Contrat de tout nouveau script (non négociable)

Un script qui mute le store DOIT avoir les 7 propriétés suivantes. Elles ne sont pas du zèle : chacune correspond à un dégât déjà payé ailleurs.

1. **Garde d'identité** : `await shop.assertShop()` en premier (abort si le token n'atteint pas cette boutique).
2. **DRY par défaut** : `shop.requireGo('<effet exact>')` — rien ne mute sans `--go`. C'est la double-confirmation, mécanisée.
3. **Idempotent** : re-run = « déjà fait, rien à changer », jamais un double effet.
4. **Backup pristine** : sauver l'état AVANT dans `data/_<sujet>-backup/` (la 1ʳᵉ exécution seulement — sinon le backup devient une copie de l'état modifié).
5. **`--revert`** : restaure exactement le backup.
6. **Fail-loud** : chaque cible attendue doit matcher un nombre **exact** de fois ; 0 ou N+1 → abort, jamais « on continue ». Un post-check final (« le terme interdit est bien à 0 ») avant de dire OK.
7. **Read-back** : relire depuis l'Admin API ce qu'on vient d'écrire et comparer. `themeFilesUpsert` n'est pas atomique et certains types de settings **suppriment silencieusement** une valeur (cf. `docs/PITFALLS-HERITES.md`).

Nommage : `_<sujet>-<action>.js` pour les scripts one-shot/maintenance, nom simple pour le socle réutilisable.

## Règle anti-handle-en-dur

Un `xxx.myshopify.com` ou un GID de thème écrit en dur dans un script = bug de confusion en puissance (et casse au prochain thème). `lib/shop.js` résout le domaine depuis `.secrets/` et le thème MAIN par requête. Le hook `shop-identity-guard.ps1` détecte par grep un handle d'une autre boutique dans un fichier d'ici et alerte cross-shop.
