---
name: product-hunter
description: Use when the operator asks to find, hunt, validate, or compare e-commerce products or niches (FR "trouve des produits", "recherche produit", "produit gagnant", "valide ce produit", "niche premium", "façon <COACH>"), or before adding ANY new product idea to a store. Also when deciding if a product fits Google Ads Search vs Shopping.
---

# Product Hunter — recherche + validation produit methode <COACH> (<COURSE-NAME>)

## Overview

Trouver et valider des produits e-commerce EN DATA, jamais à l'intuition. Source de vérité = `C:\Users\YOU\Documents\BUSINESS\shopify\validation\` (grilles reconstruites depuis la formation) + `docs/coach-doctrine.md`. Un produit n'existe que s'il a une fiche remplie et un verdict chiffré.

## Pipeline obligatoire (dans l'ordre, aucun saut)

1. **Découverte** : appliquer 1-2 des 9 méthodes de `validation/00-METHODE-COMPLETE.md` (Flippa filtres exacts, Amazon Movers & Shakers, BigBuy, Vevor best-sellers, Pinterest Trends, Temu, Europages, DotMarket, Cdiscount). Sortie = liste brute, zéro jugement.
2. **Pré-filtre 30 s/produit** : prix ≥ 300 € plausible · trouvable recherche image AliExpress · requête précise · zéro institutionnel dans les ads. Échec = poubelle immédiate.
3. **Métriques** : lancer `python scripts/validation-probe.py "<keyword>" --gl <pays> --hl <langue> --price X --cost Y [--cpc Z]` (cwd = `C:\Users\YOU\Documents\BUSINESS\shopify`). **PAS optionnel et ne demande AUCUN navigateur** : le script rend la SERP via Scrapling et compte les blocs d'annonces (`id="tads"`) + extrait les domaines concurrents — « pas de navigateur dans cette session » n'est PAS une excuse valable. Volume/CPC précis = Keyword Planner (compte <ADS_ACCOUNT_ID>) ; suivre `validation/04-METRIQUES-PROTOCOLE.md`. **Toute métrique non vérifiée = marquée `[estimé]`, jamais présentée comme un fait.**
4. **Concurrents** : `validation/03-CONCURRENTS-SANS-SEMRUSH.md` (Transparency Center, opérateurs Google, Shopping tab). Compter les drop (2-6 = idéal).
5. **Grille + verdict** : remplir UNE fiche `validation/produits/_TEMPLATE.md` PAR produit. Test S1-S5 (`01-GRILLE-SEARCH.md`) et P1-P5 (`02-GRILLE-SHOPPING.md`) → score /105 → verdict GO / RISKY / DROP en une phrase.

## Gates durs (un seul déclenché = DROP, peu importe le score)

Marge < 50 % (GO ≥ 65 %) · institutionnels dans les ADS · recherche de marque cachée (« chaise de bureau de luxe » = Herman Miller) · volume < 20-30k/mois cumulé SAUF prix > 500 € · introuvable AliExpress · **CPA worst (CPC × 150) ≥ MARGE en € — comparer à la MARGE, jamais au prix de vente** · cycle d'achat > 1 mois.

## Erreurs constatées à ne pas refaire (baseline testée)

| Erreur | Correction |
|---|---|
| « CPC×150 ≤ prix de vente » | Faux. CPA worst se compare à la **marge €** (prix − coût − 10 % frais) |
| Volume « estimé ≥ 20-30k » sans source | Probe + Keyword Planner, ou tag `[estimé — à confirmer KP]` |
| 3 produits listés sans fiche ni score | 1 fiche `_TEMPLATE.md` par produit, score /105, gates cochés |
| Search vs Shopping « au feeling » | Dérouler S1-S5 et P1-P5, écrire les réponses |
| Concurrents non énumérés | Les NOMMER (domaines) + compter les drop, preuve à l'appui |

## Règles permanentes

- Recommandation finale = max 2 produits lancés en parallèle, dont 1 Search-viable (chauffe le compte, GMC ensuite).
- Phase 1 ads = Search + Shopping only. Jamais PMax seul, jamais requête large, jamais « Maximiser conversions » sans data.
- Rien en boutique sans validation the operator. Verdicts honnêtes : un DROP est un livrable aussi valable qu'un GO.
