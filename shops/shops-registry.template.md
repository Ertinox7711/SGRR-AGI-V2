# SHOPS REGISTRY — source de vérité unique pour CHAQUE boutique Shopify

> Vit hors de tout dossier boutique (non-shadowable) et hors de `business/shopify` (read-only) → reste éditable et autoritaire.
> **L'identité d'une boutique est DÉRIVÉE de `folder_root`, jamais de la mémoire.** Le hook `shop-identity-guard.ps1` mappe tout chemin édité → une boutique par longest-prefix sur `folder_root`. Le gate dur `shop-token-identity-block.ps1` prouve que le token/creds d'un dossier atteint bien la boutique de sa ligne.
>
> **Ajouter une boutique = ajouter UNE ligne ici + lancer `shops-registry-sync.ps1`** (régénère le `.json` que les hooks lisent). Rien d'autre à câbler.
>
> Invariants (un manquement = bug à corriger avant d'agir) :
> 1. `folder_root` unique (normalisé minuscules + `/`).
> 2. `token_path` et `creds_path` TOUJOURS dans le propre `folder_root/.secrets/` de la boutique — jamais partagés, jamais cross-référencés.
> 3. Aucun doublon de `store_handle`, `myshopify_domain` ou `token_path` entre deux lignes.
> 4. `write_policy` : `read-only` (bloqué dur par `protected-path-denylist.ps1`) ou `read-write-gated` (écriture autorisée mais identité-gatée + double-confirm).

| shop_name | folder_root | store_handle | myshopify_domain | currency | niche | token_path | creds_path | app_name | write_policy | status |
|-----------|-------------|--------------|------------------|----------|-------|------------|------------|----------|--------------|--------|
| SHOP-A | c:/users/YOU/documents/business/shopify | shop-a-handle | shop-a-handle.myshopify.com | USD | watch winders | C:/Users/YOU/Documents/BUSINESS/shopify/.secrets/access-token.txt | C:/Users/YOU/Documents/BUSINESS/shopify/.secrets/app-credentials.txt | SHOP-A-API | read-only | live |
| SHOP-B | c:/users/YOU/documents/business/shop-b | shop-b-handle | shop-b-handle.myshopify.com | EUR | ceiling fans | C:/Users/YOU/Documents/BUSINESS/shop-b/.secrets/access-token.txt | C:/Users/YOU/Documents/BUSINESS/shop-b/.secrets/app-credentials.txt | SHOP-B-API | read-write-gated | setup |
| SHOP-C | c:/users/YOU/documents/business/shop-c | shop-c-handle | shop-c-handle.myshopify.com | EUR | chess boards | C:/Users/YOU/Documents/BUSINESS/shop-c/.secrets/access-token.txt | C:/Users/YOU/Documents/BUSINESS/shop-c/.secrets/app-credentials.txt | SHOP-C-API | read-write-gated | setup |

## Comment ça protège (3 couches)

1. **Rituel humain** (`SESSION-INIT.md §0`) : pwd → registre → banner → annonce → preuve token live. L'agent dérive l'identité du dossier, jamais de la mémoire.
2. **Hook advisory** (`shop-identity-guard.ps1`, PreToolUse) : à chaque Edit/Write/Bash/MCP-write, rappelle quelle boutique est ciblée + crie « CROSS-SHOP » si une commande référence 2 boutiques (ou un script copié contient le handle/domaine d'une autre). **Une seule chose qu'il DENY dur** : un MCP write tool (`update-product`/`graphql_mutation`/…) lancé alors que le dossier courant = une boutique `read-only` (SHOP-A) → étend le mur read-only au canal MCP que le denylist ne voit pas.
3. **Gate dur fail-open** (`shop-token-identity-block.ps1`, PreToolUse) : sur toute commande Shopify (Bash **ou PowerShell**), vérifie que le `SHOP=` des creds + le token réel du dossier atteignent la boutique de la ligne registre. Mismatch → **deny dur**. Incertitude (fichier manquant, pas de réseau, registre TODO) → **allow** (ne casse jamais le travail légitime).

> SHOP-A reste **read-only** : `protected-path-denylist.ps1` bloque dur toute écriture dans `business/shopify` indépendamment de ce registre. La boutique live la plus dangereuse est protégée au niveau matériel.

> **Matching boundary-safe** (red-team 2026-06-24) : tous les hooks mappent un chemin → une boutique seulement si `chemin == folder_root` OU `chemin` commence par `folder_root + '/'`. Donc `business/shopify-clone`, `business/shopify-2`, `shop-bX`, `shop-b-pro` = boutiques DIFFÉRENTES, jamais confondues avec SHOP-A/SHOP-B (le bug `StartsWith` sans frontière est corrigé). Le denylist garde `business/ofm hub` en préfixe (frontière espace) pour couvrir `ofm hub v2`.

## Procédure « ajouter la boutique #N »

1. Créer le dossier `…\BUSINESS\<newshop>` ; scaffolder depuis le squelette SHOP-B (CLAUDE.md+banner, SESSION-INIT.md, .gitignore, scripts/get-token.sh + shop-context.sh, .secrets/CLAUDE.md + app-credentials.txt.example, data/ docs/ CLAUDE.md).
2. Ajouter UNE ligne ici, puis lancer `powershell -File ~/.claude/scripts/shops-registry-sync.ps1` (régénère le `.json` que les hooks lisent + vérifie les invariants : abort si doublon `folder_root`/handle/domaine/token).
3. Stamper le banner : `powershell -File ~/.claude/scripts/shops-banner.ps1 -Folder <root>` → coller en tête du `CLAUDE.md` du nouveau dossier.
4. Créer le dossier mémoire projet `~/.claude/projects/<encoded-path>/memory/` + `MEMORY.md` vierge.

Zéro hook/règle à modifier par boutique : les hooks font du longest-prefix boundary-safe sur toutes les lignes.

## Limites by-design (PAS des bugs - red-team 2026-06-24)

- **Boutique à domaine vide** (`<TODO>`, ex SHOP-B avant achat) : le gate dur ne peut RIEN vérifier (aucun domaine cible) → il **allow**. Protection = rituel + dossier + advisory + double-confirm. Le gate dur s'active dès que `myshopify_domain` est rempli dans la registry.
- **L'advisory ne peut pas DENY** (sauf le cas MCP-write-sur-read-only) : c'est un rappel, adossé au rituel + à la double-confirmation humaine. Le seul mur dur = denylist (écritures fichiers SHOP-A) + token-gate (mauvais token) + MCP-write-sur-read-only.
- **Le gate dur engage par regex** (`get-token|.myshopify.com|admin/api|shpat_|shop-context|…`) : ne peut pas attraper un wrapper exotique arbitraire. Défense en profondeur, pas défense unique.

> **RÈGLE ASCII (incident payé)** : les 4 hooks `.ps1` sont lus en ANSI par Windows PowerShell 5.1. Un caractère non-ASCII (em-dash `—`, guillemet courbe…) dans un littéral `"…"` casse le parsing → le hook meurt en silence (fail-OPEN = aucune protection). **Tout `.ps1` ici = ASCII pur.** Vérifier après édition : 0 octet > 127.
