# RUNBOOK DE LANCEMENT — __SHOP_NAME__

> Ordre issu de ce qui a réellement été fait (et refait) sur SHOP-B. Chaque phase se termine par une **preuve**, pas par une impression. Coche au fur et à mesure ; note la date + la commande de re-run dans le journal de `CLAUDE.md`.
>
> Légende : **[MOI]** = automatisable par l'agent · **[OWNER]** = the operator uniquement (compte, mot de passe, paiement, publication payante).

---

## Phase 0 — Décider (avant toute ligne de code)

- [ ] **[MOI]** Niche + produit validés : skill `product-hunter` (grille /105) puis `persona-market-analysis`. Verdict écrit dans `docs/analyse-marche.md`.
- [ ] **[MOI]** Concurrents cartographiés : qui est en tête sur le mot-clé, institutionnels présents ou pas (si la SERP est saturée d'enseignes nationales → Shopping risqué, Search exact d'abord).
- [ ] **[MOI]** **Gate marge** : coût landed réel → marge ≥ 65 % sur le prix cible. Back-check obligatoire : re-substituer le seuil trouvé dans l'inégalité de départ (un seuil dérivé non re-vérifié = de l'argent perdu).
- [ ] **[OWNER]** Nom choisi **après** vérification de dispo `.fr` (RDAP AFNIC) **et** `.com`. Un nom pris = DA, logo et SEO à refaire.
- [ ] **[MOI]** `docs/BRAND-BRIEF.md` rempli (promesse, persona, ton, naming produits).
- [ ] **[MOI]** `docs/DESIGN-SYSTEM.md` rempli et **verrouillé** (hex exacts, 2 fonts max, radius, easing, espacements). Puis créer le **skill de marque** (`~/.claude/skills/<shop>-design/SKILL.md`) sur le modèle `shop-b-design` : toute copy/section visible passera par lui.

## Phase 1 — Socle technique

- [ ] **[OWNER]** Boutique Shopify créée (même compte que les autres = OK, mais **jamais** le même token).
- [ ] **[OWNER]** App custom (Dev Dashboard) avec **tous** les scopes du jour 1 : `write_products`, `write_themes`, `write_files`, `write_content`, `write_publications`, `write_inventory`, `write_translations`, `write_discounts`, `write_metaobjects`, `write_metaobject_definitions`, `read_orders`, `read_customers`, **`write_online_store_navigation`**, **`write_legal_policies`**. Les deux derniers manquaient sur SHOP-B → menus et policies natives impossibles par API, contournés en thème = jours perdus.
- [ ] **[MOI]** `.secrets/app-credentials.txt` rempli → `bash scripts/get-token.sh` → **`node scripts/shop-probe.js`** = preuve.
- [ ] **[MOI]** Handle + domaine renseignés dans le banner **et** la ligne de registre → `shops-registry-sync.ps1`.
- [ ] **[MOI]** Réglages : devise __CURRENCY__, timezone Europe/Paris, **langue FR par défaut du domaine** (publier le locale `fr` ; le locale « primary » backend peut rester `en` sans impact storefront), unités métriques.
- [ ] **[MOI]** Thème : **Horizon** (meilleur gratuit) gardé, sauf raison écrite. Noter le GID MAIN (mais ne jamais le hardcoder : `shop.mainThemeId()`).
- [ ] **[OWNER]** Domaine acheté + rattaché + SSL actif ; email pro `contact@<domaine>` (Workspace/Zoho) → **le mettre en email de la boutique**.
- [ ] **[OWNER]** Mot de passe storefront retiré **le jour où on veut être crawlé** (bloque Google et les vérifications).

## Phase 2 — Catalogue

- [ ] **[MOI]** Produits créés **par API** (jamais à la main), avec : titre on-DA, `descriptionHtml` structuré (accordéons Description / Caractéristiques / **Spécifications sourcées** / Livraison), vendor = la marque (jamais le fournisseur ou un concurrent), type, tags.
- [ ] **[MOI]** **Specs en metafields par produit** dès le départ (dimension, puissance, matière, poids…). Ne **jamais** hardcoder les chiffres d'un produit dans le template PDP partagé — dette n°1 héritée.
- [ ] **[MOI]** Variantes réelles (couleur/taille) = celles du fournisseur, **la base foncée/naturelle en 1ʳᵉ valeur** (c'est le défaut affiché sur la PDP).
- [ ] **[MOI]** Images : 6-7 par produit, ordre <COACH> (émotion → situation → feature → action → cotes/détails → preuve). Alt texte = titre produit (jamais vide : c'est du SEO gratuit). Zéro image de concurrent, zéro watermark.
- [ ] **[MOI]** Catégorie produit Google (taxonomie) posée sur 100 % du catalogue → indispensable pour Merchant Center.
- [ ] **[MOI]** Collections : au moins `frontpage` + une collection « tous les produits » (smart, règle `VARIANT_PRICE > 0` = auto-inclut les futurs produits) publiée sur le canal Online Store, avec image et SEO.
- [ ] **[MOI]** SEO produit/collection/page : `seo.title` (≤ 60 c, mot-clé d'abord) + `seo.description` (140-160 c). Pour les **pages** et **articles**, le champ SEO n'existe pas en API 2025-01 → metafields `global.title_tag` / `global.description_tag`.
- [ ] **[MOI]** Après tout import : re-run les scripts qui dérivent du catalogue (ordre de collection, filtres, quiz…). Attention aux scripts qui **dérivent du titre** et écrasent des metafields sourcés → les reposer après.

## Phase 3 — Storefront

- [ ] **[MOI]** Sections maison poussées via `push-any.js` (DRY par défaut, read-back, purge).
- [ ] **[MOI]** Home : annonce → hero → réassurance → best-sellers (carrousel) → preuve → produit vedette → process → avis → FAQ → newsletter → footer. Chaque section **paramétrable** (espacement gaté par une case à cocher, couleurs et textes en settings) — sinon rien n'est réglable depuis l'éditeur.
- [ ] **[MOI]** PDP : galerie carrousel + miniatures, buy-box (prix, variantes, livraison datée, réassurance, paiement), description en accordéons, sections bas de page, JSON-LD Product + BreadcrumbList.
- [ ] **[MOI]** Nav header + méga-menu + footer 3 colonnes (si le scope `menus` manque : injection en thème, mais demander le scope d'abord).
- [ ] **[MOI]** Panier : drawer natif enrichi (bandeau livraison, upsell via le quick-add **natif**, icônes paiement, bouton checkout stylé). Pas d'app payante nécessaire.
- [ ] **[MOI]** Mobile : `html, body { overflow-x: clip }` posé ; **zéro** scroll horizontal testé à 320 / 360 / 390 / 414 px ; vidéos en autoplay muet vérifiées sur mobile.
- [ ] **[MOI]** Perf : images en `?width=` + `loading=lazy` (sauf au-dessus du pli : `fetchpriority=high`), vidéos `preload="none"` + poster, armées par IntersectionObserver.
- [ ] **[MOI]** Accents et encodage vérifiés sur le **rendu** (crawl de toutes les pages), pas seulement dans l'API.

## Phase 4 — Contenu & confiance

- [ ] **[MOI]** Pages : Accueil, Collection, Produit, **Notre histoire**, **FAQ**, **Contact** (email pro réel, jamais inventé).
- [ ] **[MOI]** 5 pages légales FR : rétractation/retours (14 j légal + extension commerciale annoncée), livraison (délais **honnêtes**, cohérents partout), confidentialité (RGPD), CGV (+ médiateur conso), mentions légales (entité, SIRET/RCS, hébergeur, directeur de publication). Avec le scope `write_legal_policies` → policies natives `/policies/*` ; sinon pages + liens footer.
- [ ] **[OWNER]** Compléter l'entité légale réelle (SIRET/RCS/TVA/adresse/directeur de publication) + souscrire un **médiateur de la consommation** (obligatoire en FR).
- [ ] **[MOI]** Blog : 6-10 articles utiles (voix de marque **ou** guides SEO d'intention d'achat), maillage interne, 1 CTA par article, JSON-LD Article + FAQPage.
- [ ] **[OWNER]** **App d'avis réelle** (Loox / Judge.me) **dès 0 avis**. Zéro avis = sûr ; faux avis = ban compte + DGCCRF. Voir `GMC-GATES.md`.
- [ ] **[MOI]** Cohérence des promesses : le délai de livraison, la garantie et la politique de retour affichés sur la home, la PDP, la FAQ et la page Livraison doivent être **identiques**. C'est le n°1 des incohérences trouvées en audit.

## Phase 5 — Conformité (avant toute pub)

- [ ] **[MOI]** Passe complète `docs/GMC-GATES.md` : zéro fausse preuve, zéro faux prix barré, zéro claim non sourcé, zéro urgence artificielle inventée.
- [ ] **[MOI]** Audit du rendu **visible** (pas du markup) : une note, une jauge d'étoiles ou une citation peuvent s'afficher indépendamment du composant qu'on croyait avoir désactivé.
- [ ] **[OWNER]** Bannière de consentement cookies active et fonctionnelle.

## Phase 6 — Mesure & acquisition

- [ ] **[OWNER]** **Un store = un Merchant Center = un compte Ads = un domaine.** Ne jamais réutiliser le MC ou le compte Ads d'une autre boutique (pollution irréversible des données).
- [ ] **[OWNER]** Canal Google & YouTube dans l'Admin → MC dédié, domaine revendiqué, produits synchronisés, diagnostics à zéro.
- [ ] **[OWNER]** Compte Google Ads dédié, mode Expert, devise/timezone corrects, 2FA, **auto-apply des recommandations DÉSACTIVÉ**, conversion « Achat » configurée et vérifiée.
- [ ] **[MOI]** Vérifier que les tags de conversion **remontent** (Purchase, AddToCart, BeginCheckout, ViewItem) — « non validée » avec peu de trafic est normal, absente ne l'est pas.
- [ ] **[MOI]** `docs/ads-runbook.md` : mots-clés exacts + phrase, négatifs, RSA (15 titres ≤ 30 c, **zéro note ou avis inventé**), sitelinks, callouts, structure de campagne, séquence d'enchères, **seuil de kill** (dépense sans vente > prix produit → couper).
- [ ] **[OWNER]** Budget, lancement, paiement.

## Phase 7 — Exploitation

- [ ] **[MOI]** Outil marge (commandes × coûts fournisseur) — nécessite `read_orders` + `read_customers`.
- [ ] **[MOI]** Après **chaque** import : re-run ordre de collection / filtres / scripts dérivés (×2 si smart collection, cf. comptage async).
- [ ] **[MOI]** Journal à jour dans `CLAUDE.md` : chaque entrée = quoi, commande de re-run, ce qui a été vérifié live, pièges rencontrés.
- [ ] **[MOI]** Mémoire projet : un fichier par fait non dérivable du code + une ligne d'index dans `MEMORY.md`.
