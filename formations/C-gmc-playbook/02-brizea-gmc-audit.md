# Brizea — Audit GMC du site (live) + punch-list

> Audit read-only effectué 2026-06-26 sur `pa7duq-jd.myshopify.com` (HTTP live, autorité = état disque/live > mémoire).
> Réf : `01-gmc-compliance-playbook.md` (policy autoritaire), `03-kbis-legal-data.md` (identité), `00-curriculum-map.md` (doctrine Gaspard).

## 0. Découverte majeure — le store est DÉJÀ public et crawlable
- `/password` → **302 vers `/`** = **protection par mot de passe DÉSACTIVÉE**. `/products/...` = HTTP 200. `robots.txt` = « Public product, collection, page... is crawlable ».
- **CLAUDE.md disait « mdp yeizau encore actif » = PÉRIMÉ.** L'état live gagne : le store est **ouvert au public et indexable maintenant**.
- **Conséquence GMC** : les éléments de fausse preuve sociale ci-dessous sont **exposés à Googlebot en ce moment**. Soumettre le flux GMC en l'état = **suspension misrepresentation quasi certaine**. Le cleanup doit précéder toute soumission/ads.
- (Le store tourne sur `pa7duq-jd.myshopify.com` ; `brizea.fr` pas encore branché — la vérif GMC exige un TLD custom, cf. owner-TODO.)

## 1. Triggers misrepresentation — ✅ TOUS MASQUÉS (2026-06-26, GO « masque tout », réversible, code gardé)

> Vérifié live site-wide (home + collection + 2 PDP + page) : 0 marker rendu. Méthode = masquage non-destructif (unwire de l'ordre pour les sections, `disabled:true` pour les blocs nichés). Revert dispo.

| # | Élément | Verdict | Action APPLIQUÉE | Statut live |
|---|---|---|---|---|
| 1 | **Sales-pop faux achats** | 🔴 fausse preuve sociale | `_salespop-install.js --revert` (dé-câblé du footer-group) | ✅ 0 sur home/collection/PDP/page |
| 2 | **Trustpilot + notes inventées** | 🔴 notes fabriquées + faux endorsement | `_gmc-mask.js` : hero.show_rating=false (home) + `_gmc-mask-rating.js` : PDP buy-box `brizea_rating` (niché `main>product-details`) → `disabled:true` | ✅ home Trustpilot rendu=0 (reste 1 commentaire CSS inerte, non affiché) ; PDP Trustpilot/312/avis vérifiés/bzrt = 0 |
| 3 | **Avis placeholder** | 🔴 faux avis | `_gmc-mask.js` : section home `testimonials` dé-câblée + PDP `brizea_reviews_pp` (15 faux avis) dé-câblée | ✅ 0 |
| 4 | **Bandeau marques tierces** | 🔴 faux endorsement/affiliation | `_gmc-mask.js` : section home `brand_marquee` dé-câblée | ✅ `bzbm-`=0 |
| 5 | **Claim livraison contradictoire** | 🔴 claim livraison faux/incohérent | `_gmc-mask.js` : `brizea-process` « Recevez sous 24 à 72h » → « Livraison en 3 à 8 jours ouvrés » + texte honnête (expédition 24-72h / réception 3-8 j) ; FAQ home+PDP alignées | ✅ « Recevez sous 24 »=0, « 3 à 8 jours » rendu |

**Buy-box PDP préservée** (non touchée) : prix, Ajouter au panier, badges paiement (`bzpay` VISA/MC = factuel, autorisé), promesse stock, cartes confiance (`bztr` Livraison/Garantie 2 ans/SAV FR), JSON-LD. Seul le faux rating a été désactivé.

**Revert** : `node scripts/_salespop-install.js && node scripts/_gmc-mask.js --revert && node scripts/_gmc-mask-rating.js --revert`.

## 2. Identité / légal (🔴 vérif business Google)

| Élément | État | Action |
|---|---|---|
| Mentions légales / CGV — entité | placeholders (SIRET/médiateur/dir. publication) | **Remplir** données Kbis réelles (`03-kbis-legal-data.md`) |
| Email boutique/contact | `alterrp12@gmail.com` (Gmail perso) | **→ `contact@brizea.fr`** (owner : créer la BAL) |
| Téléphone | absent | owner : fournir un +33 |
| Médiateur conso | placeholder | owner : adhérer médiateur agréé → nom+adresse+URL |
| NAP cohérent (nom/adresse/tel/email) | incohérent (Gmail, pas d'adresse uniforme) | **Unifier** byte-for-byte (site/GMC/Ads) |

## 3. Prix / flux / availability (audit 2026-06-26 `_gmc-audit-claims.js`)

| Élément | Résultat audit | Action |
|---|---|---|
| **Compare-at (prix barrés)** | ✅ **CORRIGÉ (2026-06-26, GO Mathieu)** — `compareAtPrice` retiré sur **41 variantes / 18 produits** (`_gmc-fix-prices.js`, backup `data/_gmc-backup/prices.json`, revert OK). API = 0 compareAt. Matche le benchmark tipi-cabane (compare_at=null). | Fait. |
| **Faux rabais hardcodés (thème)** | ✅ **CORRIGÉ** — bandeau « Offre été -30% », section `featured` (badge -30% + faux barré 428,40€ + « économisez 128,50€ » + produit fictif « Aria »), cards fallback bestsellers → `_gmc-fix-claims.js` (backup index v3, revert OK). featured re-pointé sur le vrai Cygnéo 132 cm. | Fait. |
| **Faux claims « bois véritable/massif »** | ✅ **CORRIGÉ** — `en_action` (« pales en bois massif, pas du plastique imité ») + `video_gallery` (« Bois massif ») → finition honnête. | Fait. |
| **Claims énergie** (`-70%` DC-vs-AC, `~571€/saison`) | 🟡 RESTE soft — hedgés + disclaimer, défendables, pas ban-tier. **Reco** : softener le « 571€ » avant Ads. | Owner-decision. |
| **Claims bois massif/véritable** | ✅ **0/18** dans les descriptions (« bois foncé/clair/naturel » = couleur finition, pas claim matériau) | Aucun (risque écarté) |
| `brand` / vendor | ✅ **18/18 = Brizea**, zéro fuite fournisseur | Aucun |
| GTIN/MPN | inconnu (pas encore de flux) | au branchement : `mpn`+`brand` ou `identifier_exists=no` (jamais faux GTIN) |
| Parité prix flux↔page↔checkout | EUR TTC | vérifier au branchement canal |
| JSON-LD Product/Offer | Breadcrumb/Org/WebSite présents ; bloc `brizea_jsonld` PDP conservé | vérifier `priceCurrency=EUR` au branchement |

## 4. Pages requises (🟢 globalement OK)
- 5 pages légales existent (retours 30j, garantie 2 ans, livraison, confidentialité, mentions, CGV) + /contact + /notre-histoire + /faq → **structure conforme**, manque = remplissage entité + réconciliation livraison (§1.5, §2).
- Footer popover légal présent (7 liens). Bannière cookies → `/policies/privacy-policy` auto (OK si page complète).

## 5. Ce que JE peux faire (theme + API, sous GO) vs OWNER-only

**Moi (GO-gated)** : retirer salespop · retirer Trustpilot+notes (hero/testimonials/PDP) · retirer avis placeholder · retirer brand marquee · réconcilier claim livraison partout · remplir entité légale (Kbis) dans mentions/CGV · auditer compare-at · vérifier brand flux + JSON-LD Product/Offer.

**Owner-only (irréductible)** : choisir forfait payant (déjà fait ? password OFF) · **acheter brizea.fr** + brancher (TLD custom requis GMC) · BAL `contact@brizea.fr` · téléphone +33 · adhérer médiateur · créer/vérifier GMC + Google Ads + identité (Kbis dispo) · connecter canal Google & YouTube · passer un scanner conformité (AdNabu/ClearCheck) en pré-soumission.

## 6. Ordre d'exécution recommandé
1. **Cleanup misrepresentation** (§1.1-1.5) — priorité absolue, c'est ce qui bannit.
2. **Entité légale** (§2) — remplir Kbis, placeholders restants owner.
3. **Flux/prix** (§3) — compare-at + brand + JSON-LD.
4. **Owner** : domaine, email, tel, médiateur, comptes Google, scanner, puis soumission.
