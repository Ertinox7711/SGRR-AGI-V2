# SESSION-INIT — Bootstrap boutique __SHOP_NAME__ (__NICHE_FR__)

> Checklist au début de **CHAQUE** session dans `C:\Users\YOU\Documents\BUSINESS\__SHOP_SLUG__`.
> But : redémarrer sans bug même 24 h plus tard (token frais), accès vérifié, **zéro confusion de boutique**.

## §0 — RÈGLE D'OR : VERROU D'IDENTITÉ (avant toute action, même une question)

Le rituel en 6 pas. L'agent **n'agit pas** tant que le pas 6 n'a pas un GO.

1. **Épingle le dossier.** `pwd` → capture le `cwd` absolu. **C'est ça la source d'identité** — jamais la mémoire, jamais un `<system-reminder>`, jamais la session précédente.
2. **Lis le banner de CE dossier.** Ouvre `CLAUDE.md`, lis le banner en haut (nom, handle, domaine, token path, write policy).
3. **Cross-check le registre.** Ouvre `~/.claude/shops-registry.md`, trouve la ligne dont `folder_root` == `cwd` (longest-prefix, **boundary-safe** : un dossier voisin qui commence pareil est une AUTRE boutique). Banner == ligne registre ? Sinon → **STOP, reconcilie** (le registre gagne). `cwd` ne matche aucune ligne → **STOP** (boutique pas activée, cf. `README-INIT.md`).
4. **Annonce à voix haute** (1ʳᵉ ligne de la réponse) : « Session sur **__SHOP_NAME__** · niche __NICHE_FR__ · handle `__HANDLE__` · API `__DOMAIN__` · token `__SHOP_SLUG__/.secrets/access-token.txt` · __CURRENCY__ · write read-write-gated. Confirme avant que je touche quoi que ce soit. »
5. **Preuve live (gate dur).** Le token vit-il bien dans `<cwd>\.secrets\access-token.txt` (jamais un autre dossier) ? Si un token frais est requis : `bash scripts/get-token.sh` **depuis ce dossier**, puis `node scripts/shop-probe.js` → **ASSERT** `shop.name` == __SHOP_NAME__ et `currencyCode` == registre. Si l'API répond une AUTRE boutique → mauvais token/creds dans `.secrets/` → **STOP**. (Le hook `shop-token-identity-block.ps1` bloque dur ce mismatch.)
6. **Attends le GO.** Aucune action avant l'annonce affichée. Chaque écriture/mutation re-cite « Sur __SHOP_NAME__ … → OK ? » (double-confirmation).

> Lecture OK partout, tout le temps. C'est l'**écriture / mutation** qui est gatée.

## §0bis — Auto-bootstrap superpowers

Dans ce dossier : invoque `superpowers:using-superpowers`. Lis en parallèle AVANT toute action : les mémoires projet (`MEMORY.md` index + toute mémoire `errors-to-not-repeat` / `audit-state`), ce `CLAUDE.md`, le `CLAUDE.md` du sous-dossier concerné, et `docs/PITFALLS-HERITES.md` si tu vas toucher du Liquid ou l'API. Mode autonome bout-en-bout ; confirme le destructif, le visible aux autres, **et toute mutation (double-confirm)**.

## §1 — Refresh token (24 h)

```bash
bash scripts/get-token.sh        # attendu : "OK token écrit … (valide 24h)" + scopes
```

Prérequis : `.secrets/app-credentials.txt` rempli (SHOP/CLIENT_ID/CLIENT_SECRET de l'app __APP_NAME__). Modèle : `.secrets/app-credentials.txt.example`.

## §2 — Vérifier l'accès API (preuve, pas confiance)

```bash
node scripts/shop-probe.js
```

Attendu : `name` == **__SHOP_NAME__**, `currencyCode` == __CURRENCY__, `myshopifyDomain` == `__DOMAIN__`, un thème `MAIN` listé. Si `app_not_installed` ou token vide → réinstaller l'app via OAuth (Dev Dashboard : publier une version PUIS re-consentir sur `/oauth/install?client_id=…`) puis re-run `get-token.sh`.

Fallback curl si Node indisponible :

```bash
AT=$(cat .secrets/access-token.txt); source scripts/shop-context.sh
curl -s "https://$SHOP/admin/api/2025-01/graphql.json" -H "X-Shopify-Access-Token: $AT" -H "Content-Type: application/json" -d '{"query":"{ shop { name currencyCode myshopifyDomain } }"}'
```

## §3 — Vérifier l'état réel

État courant : **RIEN LANCÉ** (cf. `CLAUDE.md` § État boutique). Quand la boutique existera : dumper shop / thème / produits / collections / pages / menus dans `data/_audit-snapshot.json` **avant toute affirmation**. Une affirmation sur l'état du store sans dump frais = interdite.

## §4 — Pièges à ne jamais refaire

- **Confusion de boutique** = le pire. Identité = le dossier (§0), jamais la mémoire. Un handle mémorisé d'une autre boutique ne doit JAMAIS fuiter dans un fichier d'ici.
- **Handle/domaine en dur** dans un script copié d'une autre boutique → toujours dériver de `.secrets/app-credentials.txt` (`source scripts/shop-context.sh` en bash, `require('./lib/shop')` en Node).
- **Le live est l'autorité, pas le local.** Avant d'éditer un fichier thème : `node scripts/pull-theme-file.js <chemin>`. Un fichier local peut être en retard ET en avance sur le live (fixes appliqués directement en ligne).
- **Le rendu public est en cache** : après un push thème, la page peut servir l'ancienne version plusieurs minutes. L'**Admin API en lecture** est l'autorité → ne jamais re-patcher sur un rendu stale.
- Scraping 403/429 → **Scrapling** (réflexe global, cf. `~/.claude/CLAUDE.md`).
- Git : `git diff --cached` lu en entier ; 1 feature = 1 commit ; type-check avant stage.
- Le catalogue complet des pièges Liquid/API/cache : **`docs/PITFALLS-HERITES.md`**.

## §5 — Fin de session

- Journal à jour dans `CLAUDE.md` § État boutique (entrée ✅ datée + commande de re-run + preuve).
- Mémoire projet : un fichier par fait non dérivable du code, + une ligne dans `MEMORY.md`.
- Aucun secret hors de `.secrets/`.
