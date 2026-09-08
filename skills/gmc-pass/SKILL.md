---
name: gmc-pass
description: Use when launching a new Shopify store toward Google Merchant Center / Google Shopping, auditing a storefront BEFORE feed submission, fixing GMC statuses (Limited, Not approved, Misrepresentation, suspension, "we cannot verify your business"), building or refreshing a product feed / supplemental white-bg feed, or linking Merchant Center to Google Ads. Triggers: "passer le GMC", "GMC clean", nouvelle boutique, feed Shopping, suspension GMC, appel/re-review.
---

# GMC Pass — faire passer une boutique Shopify au Google Merchant Center du premier coup

## Overview

Google simule TOUT le parcours d'achat (crawl multi-jours, add-to-cart, checkout, policies, urgence/preuve sociale). Le test : identité vérifiable + zéro claim faux + parité prix/dispo feed↔page↔checkout. **90 % des suspensions = Misrepresentation, account-level, sans préavis, appels limités (1-3).** Donc : tout corriger AVANT de soumettre, jamais après.

**Référence maître (à lire pour toute exécution)** : `C:\Users\YOU\Documents\BUSINESS\shopify\docs\gmc-pass-playbook.md` (recette complète issue du pass SHOP-B 2026-07, 200/201 approved). Source amont : `C:\Users\YOU\Documents\BUSINESS\shop-b\docs\ecom-boss-gmc\01-gmc-compliance-playbook.md` (policy exhaustive + URLs officielles).

## Séquence de naissance (ordre NON négociable)

1. **Plan Shopify payant + password OFF + domaine custom TLD** (`.fr`/`.com` — myshopify.com = inéligible) + HTTPS + email pro du domaine (`contact@<domaine>`) en email boutique.
2. **Site nu et honnête** : zéro fake (kill-list ci-dessous), pages légales complètes, prix simples sans compareAt inventé, 0 avis plutôt que faux avis.
3. **Laisser vivre le site 1-2 semaines + Search Console** avant de créer le GMC (domaine neuf sans vie = profil à risque).
4. **Canal Shopify « Google & YouTube »** → crée/branche UN Merchant Center NEUF (jamais réutiliser un compte lié à une autre boutique ou suspendu). OAuth avec l'email pro du domaine. Verify + Claim auto.
5. **Business info + shipping + returns dans MC** = EXACTEMENT ce que dit le site (mêmes chiffres).
6. **Examen initial** : produits « Limited » 24-72 h+ = NORMAL compte neuf. **Ne RIEN changer de structurel pendant l'examen** (adresse, domaine, prix massifs, catalogue).
7. **Shopping gratuit d'abord ; lier Google Ads seulement quand les produits sont Approved.** Campagne créée EN PAUSE, budget warm-up progressif.

## Kill-list Misrepresentation (chaque item = ban-tier, vérifier RENDU live)

| Interdit | Remplacement conforme |
|---|---|
| Sales-pop faux achats (« X vient d'acheter ») | Rien, ou app branchée sur vraies commandes |
| Avis/notes inventés, wordmark Trustpilot sans feed | 0 avis, ou vraie app (Judge.me/Loox) dès 0 |
| Logos marques tierces (« vu chez », marquee) | Ses propres assets |
| compareAt/-X % jamais vendu à ce prix | Prix simple (`compareAtPrice: null`) |
| Countdown qui reset, « aujourd'hui seulement » permanent | Vraie promo datée ou rien |
| « Plus que X » hardcodé | Stock live ou rien |
| Claim livraison gonflé/contradictoire | UNE vérité partout : « Expédié 24-72 h · Livraison 3-8 j ouvrés » = pages = MC |
| Specs/chiffres invérifiables (dB, -70 %, « bois massif » faux) | Qualitatif honnête ou donnée fournisseur réelle |
| Frais cachés, prix HT | TTC partout, feed = page = checkout, même devise |

## Légal FR (boutique EI) — pages requises, footer 1-clic partout

- **Mentions légales** : « Prénom Nom — Entrepreneur Individuel (EI) », RCS + SIREN, adresse établissement, email pro, directeur de publication, « TVA non applicable, art. 293 B du CGI » (si franchise), hébergeur Shopify Inc. complet. JAMAIS de capital social/forme SARL pour une EI.
- **CGV** : prix TTC, délais honnêtes, rétractation 14 j + formulaire type, garantie conformité 2 ans + vices cachés, **médiateur conso (nom+adresse+URL)**.
- **Retours** (30 j, qui paie, délai remboursement, buyer's remorse couvert) · **Livraison** (délais = home = MC) · **Confidentialité RGPD** (droits + CNIL) · **Contact** (adresse + mailto pro + formulaire, 2 canaux).
- **Policies NATIVES `/policies/*`** de préférence (checkout/cookie banner pointent dessus). Scope API `write_legal_policies` absent → TinyMCE au browser.
- **NAP byte-for-byte identique** : site footer/contact/mentions = MC Business info = Ads payment profile = documents (Kbis). Un accent d'écart = échec vérif.

## Feed — pièges payés (non-dérivables, lire avant tout refresh)

- **Offer ID app = `shopify_ZZ_{productId}_{variantId}`** (pas `shopify_FR_`). Vérité = lire un Product ID réel dans MC Products. Préfixe faux = Matched 0.
- **Feed supplémentaire white-bg** (site lifestyle, Shopping white-bg) : TSV `id + image_link` hébergé Shopify Files ; onglet gated derrière add-on gratuit **« Advanced data source management »** (Settings → Add-ons).
- **CDN Shopify Files max-age 1 AN** → après remplacement du fichier, MC doit pointer l'**URL versionnée `?v=<ts>`**, jamais l'URL de base.
- Identifiants honnêtes : GTIN réel sinon `mpn` + `brand`, sinon `identifier_exists=no`. Jamais de faux GTIN. `brand` = ta marque, zéro fuite fournisseur.
- Image principale : produit réel, zéro texte/watermark/logo, ≥ 500×500 (800+ conseillé). JSON-LD Product/Offer server-rendered (`priceCurrency`, `availability`).

## Common mistakes

- Soumettre le feed avant le cleanup → suspension immédiate, appels brûlés. **Fix everything first.**
- Éditer business info pendant un examen en cours.
- Réutiliser carte/email/domaine/IP d'un compte suspendu (= Circumventing Systems). Méthodes « proxy/forcing » des formations = ce risque exact → jamais en 1er lancement.
- Supprimer un GMC bloqué (le domaine reste grillé) — on répare, on ne supprime pas.
- Conclure sur un rendu storefront stale (buckets cache desktop/mobile désync) → autorité = Admin API / Section Rendering API.
- Liaison MC⇄Ads qui ne se propage pas → initier DEPUIS Ads (Gestionnaire de données → Envoyer la demande au MC).

## Vérif finale avant soumission

Re-marcher le site en acheteur (mobile + desktop) : 0 faux signal, policies accessibles sans login, prix = checkout, contact visible. Scanner conformité (AdNabu misrepresentation checker) en dernier filet. Puis soumettre UNE fois, propre.
