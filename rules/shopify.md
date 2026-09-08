---
paths:
  - "**/BUSINESS/shopify/**"
  - "**/shopify/**"
  - "**/*.liquid"
---

# Projet Shopify SHOP-A (shop-a-handle) — règle complète, 5 piliers

Lis `CLAUDE.md` du dossier en premier (mémoire maître ; section « État boutique (live) » fait foi sur l'état réel). Applique les 5 piliers ci-dessous sur CHAQUE tâche Shopify.

## P0 — Mode opératoire

- **Autonome bout-en-bout** : Edit / run script / vérif visuelle sans demander. Confirme SEULEMENT destructif (suppression masse, écrasement template) + visible aux autres.
- **Lis avant d'affirmer** (état repo > mémoire). **Modifie en vrai.** **Vérifie avant « fait »** : run script + screenshot preview `?preview_theme_id=202012623179` + `node scripts/theme-purge-cache.js` si changement public.
- Token Admin 24h : `bash scripts/get-token.sh` (hook SessionStart prévient si périmé).
- Mets à jour le CLAUDE.md maître après tout changement structurel.
- Slash commands projet : `/shop-a-token` · `/shop-a-deploy` · `/shop-a-verify` · `/shop-a-purge` · `/shop-a-repivot`.
- Avant action structurelle : relire la mémoire `errors-to-not-repeat.md` (19 pièges payés en vrai).

## P1 — Reproduction pixel-perfect d'un site de référence

Procédure obligatoire pour toute demande « clone / copie le look de X » :

1. **Accès ref** : 403/CF/bot-block → Scrapling immédiat (`StealthyFetcher`), jamais bricoler headers.
2. **Baseline** : screenshots pleine page du ref (desktop 1440 + mobile 390) AVANT tout code.
3. **Tokens design** extraits du ref via `getComputedStyle` (font-family, sizes, couleurs, radius, spacing, uppercase) → consignés dans `data/<ref>-design-tokens.md` (modèle : `data/wolf-design-tokens.md`).
4. **Implémentation** = sections Liquid custom (pattern `sections/wolf-*.liquid`) avec `{% schema %}` complet — JAMAIS dans `settings_data.json` (Horizon pur, cf. P5).
5. **Screenshot clone** via preview (`?preview_theme_id=`) — jamais l'URL publique (cache anon stale).
6. **Diff visuel** ref vs clone (pixelmatch ; seuils : <3 % OK · 3-10 % corriger · >10 % refaire). Script standard `scripts/_diff_ref_vs_clone.js` — le créer au premier besoin s'il n'existe pas encore.
7. **Vérif tokens** : computed styles du clone == tokens consignés (font/couleur/radius).
8. `node scripts/theme-purge-cache.js` puis re-verify public.
9. **Look-alike fidèle, PAS pixel-identique** : structure/police/layout répliqués ; jamais noms de marque, copy, ni images trademark du ref (placeholders, the operator remplace).

## P2 — Dropshipping / sourcing AliExpress — JAMAIS se tromper

- **Triangulation 3 signaux** avant de déclarer un « best-seller » : (A) Google Lens proliferation = signal PRIMAIRE non-falsifiable (seuil ≥5 boutiques distinctes vendant le même moule) ; (B) badge « X vendus » AliExpress ; (C) HTML Shopify best-selling = corroborant SEULEMENT (`products.json?sort_by` prouvé ignoré par certains thèmes).
- **Contrainte SACRÉE** : produit trouvable AliExpress MOQ 1. Marge calculée sur coût MOQ1 + port réel (8-15 €) — JAMAIS sur prix FOB Alibaba.
- **Gates** : ✅ GO ≥65 % · ⚠️ ATTENDRE 50-64 % · ❌ STOP <50 %. Prix vente <150 € = STOP absolu (exception actée par the operator uniquement, ex. compact 99 € validé entrée de gamme).
- **VALIDATION THE OPERATOR OBLIGATOIRE avant tout import produit en boutique** (« rien en boutique sans validation »). Livrable sourcing = dossier dans `docs/`, zéro appel API produit avant le go.
- Création produit (après GO) : pattern `scripts/core-create.js` (GraphQL idempotent, skip si handle existe, SKU `WD-<GAMME3L>-<FINITION>`, tag `core-2026`, `inventoryPolicy:CONTINUE tracked:false`, SEO title/desc, publication 3 canaux). SKU `RW-*` = clones legacy.
- Doctrine complète : `docs/coach-doctrine.md` · `docs/fournisseurs-aliexpress-match.md` · `data/sourcing/CLAUDE.md`.

## P3 — SEO — checklist permanente (chaque page/produit/article/collection)

- **Title tag 50-60c** : `[keyword primaire] | SHOP-A` — toujours « watch winder » + qualificatif capacité/usage. Jamais de titre sans keyword.
- **Meta description 150-160c** : bénéfice + keyword secondaire + CTA/preuve.
- **H1 unique** par page, avec keyword. `templates/page.json` rend déjà `<h1>{{ page.title }}</h1>` → JAMAIS de 2e H1 dans un body/hero (violations passées strippées dans wolf-article.liquid).
- **Alt text descriptif** : `[Produit] – [capacité] – [matériau] watch winder`. Jamais vide, jamais le filename.
- **PIÈGE API 2025-01** : Page/Article/Collection n'ont PAS de champ `seo` dans leurs inputs → EXCLUSIVEMENT `metafieldsSet` namespace `global`, keys `title_tag`/`description_tag` (pattern `blog-create.js:setSeo()`).
- **Maillage interne** : chaque article → ≥2 liens `/collections/<handle>` + ≥1 article frère. Cluster « watch winder » entièrement connecté.
- **Honnêteté NON NÉGOCIABLE** : zéro stat inventée ; volumes/CPC toujours labellés estimations ; avis placeholders remplacés avant scaling.
- **Head keywords** à placer dans toute copy : watch winder(s), best watch winder, watch winder for Rolex, single/double watch winder, automatic watch winder, watch winder box. Long-tail + plan complet : `docs/shop-a-seo-watch-winder-keywords.md`.
- **Gap #1 connu** : 9 collections SEO vides → fix via `metafieldsSet` (script `update-collections-seo.js` à créer, titres cibles dans le doc SEO).

## P4 — Formation <COACH> (<COURSE-NAME>) — alignement

- Source : `C:\Users\YOU\Documents\BUSINESS\shopify\<course-folder>` (64 .md) ; synthèse opérationnelle : `docs/coach-doctrine.md`.
- Cœur : **Google Ads = capture de demande existante, pas création**. CPA worst-case = CPC × 150 (conversion 0,7-0,8 %). 11 critères produit : marge forte ; concurrents drop présents dans le sponsorisé (= preuve que ça tourne) ; volume ≥20-30k/mois ; mot-clé précis bottom-up ; éviter SERP institutionnels (Amazon/Darty/FNAC) ; marque possible = bonus ; sourcing AliExpress facile ; besoin d'expertise = bonus ; cycle achat ≤1 semaine ; pas de recherche de marque ; mono-clé précis.
- Toute décision produit/pricing/ads se justifie contre ces critères — citer le critère, pas l'intuition.
- **Recherche/validation produit = dossier `validation/`** (grilles /105 Search S1-S5 + Shopping P1-P5, 9 méthodes, métriques sans SEMrush, `scripts/validation-probe.py`) + **skill `product-hunter`** à invoquer pour toute chasse produit. CPA worst se compare à la MARGE €, jamais au prix de vente. Volume non vérifié = tag `[estimé]`.

## P5 — Liquid modulable + wiring NON-destructif (chaque section/template)

Section conforme AVANT `push-sections.js` :
1. CSS scopé section.id (préfixe `.w<abbr>-{{ sid }}`), zéro classe globale.
2. `{% schema %}` COMPLET : chaque texte = setting `text`/`richtext`, chaque image = `image_picker`, chaque couleur visible = `color`, espacements = `range` (step max 1 décimale). Defaults non-blank ; richtext default commence par `<p>`.
3. Blocs déclarés + `presets[]` avec blocs d'exemple pré-remplis (sinon la section n'apparaît pas dans « Ajouter une section »).
4. Zéro URL CDN hardcodée dans le HTML Liquid (image_picker + fallback `{% else %}` uniquement pour le cas « aucun bloc »).

Wiring — tout script qui touche `templates/*.json` :
5. **READ-BEFORE-WRITE** : lire le JSON live, merger — JAMAIS reconstruire from-scratch (incident payé : un build from-scratch avait tout effacé).
6. Insert par **anchor + skip-si-présent** ; jamais supprimer une section existante ; anchor absent → `exit 1` avec message.
7. Flags `--dry` et `--remove` sur tout script de wiring ; reset complet uniquement derrière `--reset`/`--force` explicite.
8. Toujours finir par `node scripts/theme-purge-cache.js`.

- `theme-homepage-wolf-custom.js` = **RESET COMPLET** de `templates/index.json` → création initiale uniquement, JAMAIS en maintenance (écraserait wolf_heritage / wolf_commitment / wolf_blog_teaser / FAQ ajoutés après coup).
- Scripts dépréciés portent des guards `exit 1` (`--force-deprecated` = bouton d'urgence conscient). Ne pas les supprimer, ne pas bypass le guard.

## Marketing / copy (rappel)

Tout contenu visible mélange `copywriting` (SEO-aware) + `marketing-psychology` + `page-cro`. Jamais de copy brute. Site 100 % anglais. Brand → `brandkit` ; emails → `email-campaigns` ; social → `social-content`/`create-viral-content` ; GTM → `launch-strategy` + `market-funnel` ; ops natifs → `shopify-admin`.
