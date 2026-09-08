# Benchmark — tipi-cabane.fr (a PASSÉ GMC) vs Brizea

> Scrapé live 2026-06-26 (`tipi-cabane.fr`, Shopify FR, niche tipis enfants, dropship). Référence d'une boutique qui passe Google Merchant Center. But : copier ce qui les fait passer, corriger les écarts Brizea. Sources brutes : scratchpad session (`tc_policies_*.txt`, `home.html`, `tc_products_*.html`).

## 1. Ce que fait tipi-cabane (boutique qui PASSE) — les faits

### Identité légale (mentions légales = `/policies/legal-notice`, policy NATIVE Shopify)
- **Éditeur** : « Tipi Cabane by **ARCANESEO LLP**, 71-75 Shelton Street, London, WC2H 9JQ, UK » (un LLP UK = shell dropship classique, mais **divulgué en entier avec adresse enregistrée**).
- **Représentant légal NOMMÉ** : « Dissac Denis ».
- Responsable publication / Webmaster / DPO : « Tipi Cabane – contact@tipi-cabane.fr ».
- **Hébergeur divulgué en entier** : « Shopify – Google LLC, 1600 Amphitheatre Parkway, Mountain View CA 94043 USA, +1 650 253 0000 ».
- Cite **LCEN art.6** (loi 2004-575), **RGPD complet** (art. 15/16/17/18/20/21, loi 78-17), IP/contrefaçon (L.335-2). = template générateur légal FR standard, exhaustif.

### Policies — 6, TOUTES natives `/policies/`
`legal-notice` · `privacy-policy` · `refund-policy` · `terms-of-service` (CGU) · `terms-of-sale` (CGV) · `shipping-policy`. → footer + bannière cookies + checkout pointent tous vers ces pages natives.
- **Remboursement** : 30 j pour réclamer retour/échange sur article neuf ; colis endommagé couvert ; **retours à charge client au-delà de 50€** ; remboursement sur moyen d'origine en 7-14 j ; contact email + photos.
- **Expédition** : préparation **24-48h** (hors WE/fériés) ; **France only** ; livraison **3-5 j ouvrés** (jusqu'à 15 en forte activité) ; **gratuite toutes commandes** ; numéro de suivi.

### Preuve sociale — RÉELLE, zéro faux
- **Loox** (app d'avis tierce, widget `87lkXA1uV8`, schéma Loox LD-JSON) = **vrais avis clients avec photos**.
- **AUCUN** wordmark Trustpilot, **aucun** avis inventé/hardcodé, **aucun** sales-pop « X vient d'acheter », **aucun** bandeau de logos de marques.
- Stock honnête : « **rupture de stock** » affiché sur les vrais articles indisponibles.

### Prix — HONNÊTE, zéro faux rabais
- **`compare_at_price = null`** sur les produits = **AUCUN prix barré**, **aucun faux « -30% »**. Prix unique honnête (146,99€ / 191,99€ / 226,99€).
- (Le « -10% » trouvé = offre quantité/bundle, **pas** un barré de prix de référence.) Zéro `<del>` / `price--sale`.

### Contact / domaine
- **contact@tipi-cabane.fr** (email domaine pro) + `/pages/contact`. Domaine **`.fr` custom** (pas `myshopify`).

## 2. Tableau tête-à-tête

| Dimension | tipi-cabane (PASSE) | Brizea (actuel, post-nettoyage) | Écart |
|---|---|---|---|
| **Entité légale** | UK LLP shell + rep nommé, divulgué complet | **EI réelle, Kbis RCS Paris** (Serrano Mathieu) — *base plus solide* | ✅ identité OK (mieux), TVA/tél/médiateur à compléter |
| **Pages légales** | 6 natives `/policies/` | 5 sur `/pages/` (token sans scope `write_legal_policies`) ; cookie+checkout pointent l'auto `/policies/privacy-policy` | 🟠 split pages/policies → demander le scope |
| **Avis** | Loox réel (vrais avis) | **0 avis** (faux masqués, aucune app) | 🟠 installer une vraie app, repartir de 0 |
| **Faux achats / Trustpilot / marques** | aucun | masqués ✅ | ✅ match |
| **Prix barrés** | **AUCUN** (`compare_at`=null) | **18/18 barrés** (faux rabais store neuf) | 🔴 **ban-risk #1** |
| **Livraison (claim)** | 24-48h exp / 3-5 j / gratuite / suivi | exp 24-72h / réception 3-8 j / offerte ✅ | ✅ honnête, match |
| **Retours** | 30 j, retour > 50€ à charge client | 30 j + rétractation 14 j + garantie 2 ans | ✅ (Brizea plus protecteur) |
| **Email** | contact@domaine pro | contact@brizea.fr prévu ; shop = Gmail perso | 🟠 owner |
| **Domaine** | `.fr` custom | `pa7duq-jd.myshopify.com` | 🔴 owner (TLD requis GMC) |

## 3. Lecture clé
La boutique qui passe GMC ne « triche » nulle part sur la preuve : **vrais avis (Loox), zéro faux achat, zéro faux prix barré, claims honnêtes.** Sa seule « astuce » = un montage légal LLP UK + mentions légales générées exhaustives + policies natives. **Brizea a déjà une identité PLUS forte (Kbis FR réel)** ; il lui reste surtout à : (1) **tuer les 18 prix barrés** (le seul vrai ban-risk restant), (2) **vraie app d'avis depuis 0**, (3) **policies natives** (scope) + **domaine .fr** (owner).

## 4. Punch-list — exécutée + restante (vérifiée 2026-06-26)

> ⚠️ La synthèse auto du workflow `tipi-vs-brizea-gmc` (7 agents) était **contaminée** (un agent a halluciné/croisé une autre boutique : « climatiseur 12000 BTU », « store 4 jours », « aucune mentions légales » = FAUX pour Brizea). **Punch-list ci-dessous = mes vérifs directes (autorité), pas la synthèse.** Les analyses par dimension (legal/reviews/pricing) étaient, elles, Brizea-correctes.

### ✅ FAIT + vérifié live (claude-now, réversible)
1. **Prix barrés supprimés** — `compareAtPrice` retiré sur **41 variantes / 18 produits** (`_gmc-fix-prices.js`, backup `prices.json`, revert OK). API = 0 compareAt. → matche tipi-cabane (compare_at=null).
2. **Faux rabais hardcodés supprimés** (`_gmc-fix-claims.js`, backup index v3) : bandeau « Offre été -30% » → message honnête ; section `featured` (badge -30% + faux barré 428,40€ + « économisez 128,50€ » + **produit fictif « Aria »**) → neutralisée + pointée sur le vrai **Cygnéo 132 cm** ; cards fallback bestsellers (4 barrés/badges) vidées.
3. **Faux claims « bois véritable/massif » supprimés** : `en_action` (« pales en bois massif, pas du plastique imité ») + `video_gallery` (« Bois massif ») → finition honnête.
4. **Fausse preuve sociale** (sales-pop, Trustpilot, 15 faux avis, bandeau marques, faux rating PDP) → déjà masquée (passe précédente). Vérifié 0 rendu.
5. **Entité légale réelle** (Kbis : Serrano Mathieu Julien, EI, RCS Paris 935 076 471) remplie dans mentions légales.
6. **Livraison réconciliée** honnête (exp 24-72h / réception 3-8 j).

### 🟡 RESTE — soft, flaggé (ta décision, pas du ban-tier)
- Claims énergie `jusqu'à -70%` (DC vs AC) + `économisez ~571€/saison` (vs climatisation, avec disclaimer). Hedgés + grounded → pas la catégorie misrepresentation qui bannit. **Reco** : softener le chiffre précis « 571€ » avant de lancer les Ads (comparer un ventilo à une clim = maillon faible). Dis-moi si je le fais.

### 🔴 OWNER-ONLY (irréductible, je ne peux pas)
1. **Domaine `brizea.fr`** acheté + branché (TLD custom requis GMC ; tipi a `.fr`).
2. **Email pro** `contact@brizea.fr` (BAL active) + le mettre en email boutique (aujourd'hui = Gmail perso).
3. **Scope `write_legal_policies`** sur l'app BRIZEA-API → republier les 6 docs en **policies natives `/policies/`** (comme tipi : footer+cookie+checkout pointent les vraies pages ; sinon Shopify sert une privacy auto vide au checkout). + scope `write_online_store_navigation` pour le menu.
4. **Médiateur conso** agréé (adhésion) → nom+URL+adresse à insérer dans la CGV.
5. **App d'avis réelle** (Loox/Judge.me gratuit) — comme tipi — et collecter de VRAIS avis dès 0. (0 avis = safe ; faux avis = ban.)
6. **Tél +33** (si tu veux l'afficher — pas obligatoire si email fourni ; je n'expose pas ton numéro perso sans ton accord).
7. **Comptes Google** : GMC + Ads + vérif identité (ton Kbis suffit) + connecter le canal Google & YouTube ; scanner conformité avant soumission.

### Séquence de soumission GMC (ordre correct)
1. Domaine `brizea.fr` branché + email pro actif. → 2. Scope policies → publier natives `/policies/`. → 3. Médiateur dans CGV. → 4. (option) softener claim énergie. → 5. App avis installée (0 avis OK). → 6. Créer GMC+Ads, vérifier identité (Kbis), connecter canal. → 7. Scanner conformité → soumettre.

**Bottom line** : côté contenu/preuve/prix, Brizea est maintenant **au niveau d'une boutique qui passe** (tout le faux est retiré, réversible) et **au-dessus sur l'identité** (Kbis FR réel > LLP offshore de tipi). Ce qui reste = **owner** (domaine, email, scope, médiateur, app avis, comptes Google) + 1 soft (claim énergie).
