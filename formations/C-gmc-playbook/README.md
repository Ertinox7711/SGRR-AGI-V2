# Ecom Boss (Gaspard) — Doctrine GMC pour Brizea

> Équivalent de `arthur-doctrine.md` (Ecom Inner Circle / Arthur) mais pour **Gaspard — ECOM-BOSS™** (skool.com/ecom-boss-7033), focalisé **Google Merchant Center (GMC)**.
> Objectif unique : **faire passer le site Brizea (ventilateurs de plafond) au GMC sans bannissement.** « T'as qu'une chance. »
> Marché FR, Google Ads Shopping + Search, boutique mono-produit premium.

## Fichiers de ce dossier

| Fichier | Contenu |
|---|---|
| `README.md` | ce fichier — index + état |
| `00-curriculum-map.md` | carte complète de la section GMC du cours (les 30 leçons, méthode Gaspard) |
| `01-gmc-compliance-playbook.md` | **playbook autoritaire** (policy Google officielle + FR legal) issu de la recherche exhaustive |
| `02-brizea-gmc-audit.md` | audit du site Brizea vs exigences GMC (read-only) + punch-list de fixes |
| `03-kbis-legal-data.md` | données légales réelles du Kbis (pour mentions légales / vérif business Google) |

## ⚠️ Limite honnête sur les transcriptions

Les leçons Ecom Boss sont des **vidéos Vimeo sans transcript texte** (DOM vide côté Skool). Impossible d'extraire le verbatim par scraping. Ce qui est capturé ici :
1. **La carte exacte du curriculum** (titres des 30 leçons = la méthode structurée de Gaspard) → `00-curriculum-map.md`.
2. **La substance compliance autoritaire** (policy Google officielle + droit conso FR) → `01-gmc-compliance-playbook.md`, qui est une source **plus fiable** que l'audio du cours pour le travail concret sur le site.

Si tu veux le verbatim d'une vidéo précise (ex. « K - Misrepresentation »), il faudra transcrire l'audio séparément — dis-moi laquelle.

## État

- [x] Curriculum GMC cartographié (Module 4, sections 2 + 6) → `00-curriculum-map.md`
- [x] Kbis lu → données légales extraites → `03-kbis-legal-data.md`
- [x] Playbook compliance autoritaire (9 agents de recherche) → `01-gmc-compliance-playbook.md`
- [x] Audit Brizea live + punch-list → `02-brizea-gmc-audit.md`
- [x] **Découverte : store DÉJÀ public/crawlable** (password OFF, CLAUDE.md périmé) → cleanup urgent
- [x] **Fixes misrepresentation APPLIQUÉS (2026-06-26, GO « masque tout »)** : sales-pop, faux Trustpilot/notes (home+PDP), faux avis, bandeau marques, claim livraison → tous masqués (réversible, code gardé) + entité légale Kbis remplie. Vérifié live site-wide = 0 marker. Détail → `02-brizea-gmc-audit.md` §1.
- [x] **Benchmark tipi-cabane.fr (boutique qui a PASSÉ GMC) → comparaison + écarts** → `04-tipi-cabane-benchmark.md`. Clé : une boutique qui passe a `compare_at=null` (0 prix barré), avis RÉELS (Loox), 0 faux signal ; sa seule « astuce » = montage légal LLP UK + policies natives.
- [x] **Prix barrés SUPPRIMÉS (2026-06-26, GO)** : `compareAtPrice` retiré 41 variantes/18 produits (`_gmc-fix-prices.js`). API=0.
- [x] **Faux rabais + faux claims bois hardcodés SUPPRIMÉS** : `_gmc-fix-claims.js` (annonce -30%, featured fictif « Aria »/428,40€/économisez 128,50€, cards bestsellers, « bois véritable/massif »). Vérifié live = 0.
- [ ] 🟡 soft : claims énergie `-70%`/`571€/saison` (hedgés, défendables) → softener avant Ads (owner-decision).
- [ ] **Owner-only avant soumission GMC** : `brizea.fr` (TLD requis) · BAL `contact@brizea.fr` · scope `write_legal_policies` → policies natives · médiateur conso · **app avis réelle (Loox/Judge.me) dès 0 avis** · tél +33 (option) · GMC+Ads+identité (Kbis) · scanner pré-soumission. Séquence → `04` §4.
