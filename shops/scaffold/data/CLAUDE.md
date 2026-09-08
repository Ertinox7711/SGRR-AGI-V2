# data/ — Catalogue, sourcing, backups, captures (__SHOP_NAME__)

> **Vide pour l'instant.** Règle n°1 : le CSV/JSON d'import se **régénère** depuis une source, il ne s'édite jamais à la main.

| Chemin | Rôle |
|---|---|
| `catalogue.json` / `catalogue.csv` | Source produits (nom, prix, coût, variantes, specs **sourcées**) |
| `shopify-import.json` | Payload d'import généré (régénéré, jamais hand-edit) |
| `sourcing/` | Fiches fournisseur (AliExpress/autre) : URL source, coût landed, délai, photos d'origine. **Une ligne par produit** = ce qui permet de re-calculer la marge et de prouver une spec. |
| `_audit-snapshot.json` | Dump de l'état live (`node scripts/shop-probe.js --dump`) — **avant** toute affirmation sur le store |
| `_<sujet>-backup/` | Backups **pristine** créés par les scripts (`--revert` les restaure) |
| `_live-pull/` | Versions LIVE de fichiers thème (autorité) — gitignoré |
| `shots/` | Screenshots de vérification (avant/après) — gitignoré |

## Règles

- **Zéro spec inventée.** Une spec produit (dimension, puissance, matière, autonomie, dB, débit) n'est publiable que si elle vient de la fiche fournisseur ou d'une mesure. Si la source ne le dit pas → on ne l'écrit pas. Une spec fausse = allégation trompeuse (gate `docs/GMC-GATES.md`), pas juste une coquille.
- **Une PDP par produit, pas un template de chiffres.** Ne jamais hardcoder les specs d'un produit dans un template partagé par tout le catalogue : c'est la dette n°1 héritée de SHOP-B (les chiffres du produit A servis sur les 20 autres fiches). Les specs vivent en **metafields par produit** dès le départ.
- **Marge avant tout import** : gate GO ≥ 65 % de marge sur le prix de vente, coût landed réel (produit + port + frais PSP ~2,5 % + retours). Pas de devis fournisseur = pas d'import.
- **Photos** : jamais celles d'un concurrent (trademark). Photos fournisseur retravaillées, générées, ou shootées. Une image « premium » sous licence payante laisse un watermark si on prend la mauvaise variante — vérifier **à l'œil** sur planche-contact avant d'uploader.
- **Validation produit avant import** : skill `product-hunter` + grilles `…\BUSINESS\shopify\validation\` (partagé, lecture seule) + `persona-market-analysis`.
