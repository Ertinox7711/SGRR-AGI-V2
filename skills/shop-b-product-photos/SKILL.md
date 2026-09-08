---
name: shop-b-product-photos
description: "Refaire les photos produit SHOP-B (ventilateurs de plafond), UN PRODUIT À LA FOIS. Déclencheur = the operator nomme un produit + colle son lien AliExpress. Pipeline figé : scrape AliExpress (autorité produit) → 1 packshot studio par VRAI coloris Ali (Nano Banana Pro, 2K, 1:1, fond crème #F7F4EF, même cadrage/échelle sur toute la boutique) → galerie storytelling <COACH> 6 images → réconcilier le sélecteur Shopify sur la vérité Ali → MONTRER tout, publier sur GO explicite → câbler couleur↔photo + mettre la base FONCÉE en défaut. Images main/présentation JAMAIS base blanche. AliExpress > site SHOP-B toujours."
metadata:
  type: project
  shop: shop-b
---

# SHOP-B — Refonte photos produit (workflow FIGÉ)

> Un produit à la fois. the operator nomme le produit + colle le lien AliExpress = c'est le GO
> pour générer les photos de CE produit. Générateur, résolution, format, DA = identiques du
> 1er au dernier ventilo (cohérence = une seule série de marque). AliExpress = autorité
> produit ; le site SHOP-B sert juste à savoir quelle page refaire.
>
> Complément obligatoire : skill **shop-b-design** (palette, typo, anti-slop, gates) pour tout
> texte/overlay rendu dans une image. Mémoire liée : [[shop-b-product-photo-workflow]],
> [[shop-b-identity]], [[coach-carousel-7-images]], [[no-generation-without-explicit-go]].

---

## 0. VERROU IDENTITÉ (avant toute action, prioritaire)

- Boutique = **SHOP-B** `shop-b-handle` / `shop-b-handle.myshopify.com`, EUR, dossier `C:\Users\YOU\Documents\BUSINESS\shop-b`. JAMAIS SHOP-A `shop-a-handle` (même owner, autre store).
- Identité = LE DOSSIER. `cwd` Bash dérive silencieusement vers SHOP-A → **token en chemin ABSOLU** `C:/Users/YOU/Documents/BUSINESS/shop-b/.secrets/access-token.txt`, jamais relatif.
- Token 24h → régén depuis le dossier SHOP-B : `cd C:/Users/YOU/Documents/BUSINESS/shop-b && bash scripts/get-token.sh -q`.
- **Un token = un store.** Sanity check en tête de CHAQUE script mutant : `shop.myshopifyDomain === 'shop-b-handle.myshopify.com'` sinon `exit 1`.
- **Double-confirmation avant TOUTE mutation Shopify** (`productCreateMedia`/`productVariantsBulkUpdate`/`productOptionsReorder`/`productDeleteMedia`/…) : re-citer « Sur **SHOP-B** (ventilateurs), je vais `<effet exact>` → OK ? » + GO explicite. La demande directe de the operator (« publie le X ») = GO pour CE produit.
- **Dépense de crédits (Higgsfield) = GO explicite obligatoire** avant chaque batch. « check si ça marche » ≠ GO. Seuls `balance`/`models_explore`/`show_generations`/`get_cost:true` sont gratuits-safe. Le pattern « jtenvoie le [produit] tu fais les photos » EST le GO pour générer CE produit.

---

## 1. SCRAPE ALIEXPRESS = AUTORITÉ (jamais le sélecteur SHOP-B)

Le site SHOP-B peut mentir (coloris inventés copiés d'un autre produit, coloris manquants). **La vérité = la fiche AliExpress.** Forme, coloris, variantes, tailles, images de réf → toujours Ali.

- Bot-block → **Scrapling `StealthyFetcher`** (réflexe global 403/429). Script `.py` écrit sur disque puis `python script.py` (jamais `python -c`). `PYTHONIOENCODING=utf-8`.
- Les SKU sont chargés en XHR, absents du HTML statique → `StealthyFetcher.fetch(url, headless=True, network_idle=True, wait_selector='[class*=sku-item--property]')` puis `page.css('img[class*=sku]')`.
- Chaque swatch : `alt`/`title` = nom du coloris, `src` = image. **Lire chaque swatch À L'ŒIL** (les noms seuls trompent : « Ivoire » = couleur du HOUSING, pas tout blanc).
- Swatch pleine résolution = l'URL `ae-pic-a1.aliexpress-media.com/kf/…jpg` **sans le suffixe `_NxN`** (meilleure réf : fond blanc, géométrie + coloris nets).
- Sortie = la liste EXACTE des vrais coloris + tailles. Ex Éclipse (payé) : site = 6 couleurs dont 2 inventées + nickel manquant ; Ali = exactement 5 (Pure black · Pure white · White grain · Black walnut · Nickel sand walnut) × 2 tailles (45″=113 cm / 52″=132 cm).

---

## 2. GÉNÉRATION — réglages FIGÉS (aucune exception)

- **Générateur unique = Nano Banana Pro** (Higgsfield MCP `63ade1fb-ae60-418c-8698-012debffd964`, `model:"nano_banana_pro"`, interne `nano_banana_2`). Vérifié valide sur le catalogue live (2026-07-11).
  - ⚠ **NE PAS switcher vers `marketing_studio_image`** même si la description de `generate_image` le donne comme défaut « commercial/product ». Nano Banana Pro est choisi exprès : cohérence de série (même moteur du 1er au dernier ventilo), rendu fiable du **texte FR d'overlay** (titres galerie), et **identité produit verrouillée par image de réf** (swatch Ali en `medias role:"image"`). Changer de moteur = casser la série.
- **`resolution:"2k"`, `aspect_ratio:"1:1"`**, fond studio crème **`#F7F4EF`**. Même distance caméra, même échelle du ventilo par slot, mêmes pièces-types d'un produit à l'autre.
  - `aspect_ratio` = param 1ère classe du schéma. `resolution:"2k"` = param **model-specific** (passé en clé additionnelle, validé server-side) — valeur éprouvée sur Éclipse+Méridien ; si un jour on change de modèle, re-checker les valeurs acceptées via `models_explore(action:"get", model_id:…)` avant de générer. `get_cost:true` = préflight coût 0-crédit (sûr).
- Async : l'appel renvoie `id` + `status:"pending"` → récupérer via `show_generations(type:"image", size:N)` → `results.rawUrl` (PNG 2K) → `curl` local → **Read pour QA visuelle** (jamais publier sans avoir regardé).
- **Réf produit** = swatch du BON coloris uploadé Higgsfield : `media_upload` → `curl` PUT bytes `image/jpeg` → `media_confirm` type image → passer `medias:[{value:MEDIA_ID, role:"image"}]`. L'identité produit (forme, pales, coloris) est alors conservée.
- **Coût = 2 crédits/image.** Batcher, ne pas spammer.

---

## 3. ⚠ RÈGLE BASE BLANCHE (dure, override « 1ère image Ali = le main »)

**Images MAIN / présentation = JAMAIS base blanche (housing blanc). TOUJOURS base foncée (noir) ou bois/marron/noyer.** S'applique au **hero, aux 6 storytelling lifestyle ET à l'image de tête de galerie**. Le boîtier blanc (« white grain », « pure white ») est moche en principal.

- La base blanche reste générée mais **UNIQUEMENT en packshot variant** (s'affiche quand on sélectionne cette couleur au sélecteur, jamais en photo principale).
- **Vaut MÊME si la 1ère image AliExpress est base blanche** (override la règle « 1ère photo Ali = le main » pour la BASE ; le reste — forme, cadrage — suit toujours Ali).
- **Technique recolor validée** (préserve cadrage/scène/texte FR rendu, plus fiable que régénérer) : passer un packshot/storytelling PROPRE déjà généré comme `medias:[{value:JOB_ID, role:"image"}]` + prompt : *« keep EXACTLY identical, ONLY recolor housing/canopy/downrod white→matte black, keep walnut blades + all rendered text »*. 2 crédits.
- Ex Méridien : 3 coloris = white-walnut-grain (blanc) · pure-white · black-walnut (noir) → galerie + storytelling menés par **black-walnut** ; les 2 blancs = variants seulement.

---

## 4. GALERIE = doctrine <COACH>, 6 images (jamais la 7ᵉ)

Ordre [[coach-carousel-7-images]], **#7 témoignage JAMAIS** (pas d'avis réels) :

1. **Produit seul** — wow, fond crème DA, zéro texte.
2. **En situation** — villa / vue mer, lumière chaude (bois/lin/crème/bleu-mer).
3. **Feature n°1** — overlay 1 titre. **ZÉRO dB chiffré** → qualitatif (« ultra-silencieux », « à peine un murmure »).
4. **En action** — ventilateur en fonctionnement.
5. **Détails & cotes** — cm réels OK (le GMC est passé, cotes autorisées), dB toujours interdit.
6. **Réassurance** — garantie 2 ans (légale UE) / livraison offerte / **SAV français** (cédille). Vraies claims, JAMAIS fausse note/avis.

Base foncée sur 01/02/04 (règle §3). Cohérence dure : même série visuelle sur toute la boutique.

**Packshots variants = 1 par VRAI coloris Ali** (pas une image « lineup »). Même angle/échelle pour tous les coloris d'un produit. Le main packshot (celui montré en tête) = base FONCÉE (§3).

---

## 5. MONTRER → GO → PUBLIER

Générer les 6 storytelling + N packshots → **MONTRER TOUT à the operator, NE RIEN publier sans GO** (« la publie rien, juste montre-moi »). Publication = mutation → double-confirm + GO explicite.

### Recette de publication (vérifiée Éclipse + Méridien, PUBLIÉS live)

Token SHOP-B absolu, guard shop, **backup produit AVANT** (lire `media{nodes{id}}` + variants + options → JSON scratchpad, ne jamais l'écraser). Deux helpers gql coexistent : le helper **https** renvoie la réponse COMPLÈTE (`.data.x`) ; le helper **fetch** renvoie déjà `j.data` (`.x`, pas `.data.x`). Ne pas doubler `.data`. Throttle `THROTTLED` → retry backoff.

1. **Upload chaque packshot** → `stagedUploadsCreate(resource:IMAGE, httpMethod:POST, fileSize)` → multipart POST (params + `file`) vers `stagedTarget.url` → `productCreateMedia(media:[{originalSource:resourceUrl, mediaContentType:IMAGE, alt}])` → **poll `node{... on MediaImage{status image{url}}}` jusqu'à `READY`** (transcodage async).
2. **Réconcilier le sélecteur sur la vérité Ali :**
   - Coloris inventés → `productVariantsBulkDelete(productId, variantsIds)` (**supprime auto les valeurs d'option devenues inutilisées**).
   - Renommer une valeur → `productOptionUpdate(option:{id}, optionValuesToUpdate:[{id, name}])`. Naming FR fidèle Ali (ex : Ivoire & chêne=White grain · Blanc=Pure white · Noir=Pure black · Noir & noyer=Black walnut · Nickel & noyer=Nickel sand walnut).
   - Fiche sans option Couleur → `productOptionsCreate(options:[{name:"Couleur", position:2, values:[…]}], variantStrategy:CREATE)` (garde Taille, produit cartésien ; **les nouveaux variants héritent les prix par taille** — rien à re-set).
3. **Câbler couleur ↔ photo** → `productVariantsBulkUpdate(variants:[{id, mediaId}])`. Le champ **`mediaId` REMPLACE `variant.image`** = le swap. Les 2 tailles d'une même couleur pointent le MÊME mediaId. NE PAS supprimer les packshots couleur (liés aux variants).
4. **Supprimer les vieux médias importés** (`shop-b-<handle>-NN.jpg` moches) → `productDeleteMedia(mediaIds)` (ids lus du backup).
5. **Ordre galerie <COACH>** → `productReorderMedia(moves:[{id, newPosition}])` = [packshot MAIN foncé, 6 storytelling, autres packshots couleur]. Poll `job{done}`.

### 6. ⚠ DÉFAUT PDP = BASE FONCÉE (ordre des valeurs de couleur) — ne pas oublier

Horizon affiche au chargement (sans `?variant`) l'image du **variant par défaut = 1ᵉʳ variant DISPONIBLE = Taille[0] × Couleur[0]**, qui **OVERRIDE** `media[0]` de la galerie. Donc mettre la galerie en tête foncée NE SUFFIT PAS : il faut que la **première VALEUR de l'option Couleur** soit la base foncée.

- Mutation = **`productOptionsReorder(productId, options:[OptionReorderInput!])`**, `OptionReorderInput = {id, name?, values:[{id, name?}]}`.
- **PIÈGE : passer TOUTES les options** (Taille inchangée + Couleur réordonnée), sinon `userErrors: MISSING_OPTION_NAME "Missing option name 'Taille'"`.
- Ordre cible des valeurs Couleur = **foncé d'abord** (ex Méridien : `Noir & noyer` → `Blanc & noyer` → `Blanc`).
- **Vérifier ensuite `variants[0].available === true`** (Horizon prend le 1ᵉʳ *disponible* — si le foncé est en rupture, il saute au blanc). Tous en stock → défaut = foncé. OK.

---

## 7. VÉRIFICATION (Admin = autorité, live = propagation)

- **Admin GraphQL d'abord** : `options{optionValues{name}}` (couleur foncée en 1ᵉʳ) + `variants{selectedOptions image{url}}` (N images distinctes, variants[0]=foncé) + galerie ordre <COACH>.
- **Storefront ensuite** : `https://shop-b.example/products/<handle>.js` (JSON, PAS page-caché mais **edge-caché** → toujours un cache-buster `?_=Date.now()`, sinon état stale). Vérifier : `options` Couleur foncé-1er, `variants[0]` foncé + `available:true`, `variants[].featured_image` = N distinctes, `images[0]` = packshot foncé.
- **Click-test** = chromium **bundlé** (`require('playwright')` depuis `node_modules`), **PAS le MCP** (qui veut Chrome système). Horizon rend Couleur en **`<select name="options[Couleur]">` (dropdown), pas en swatch** → `page.selectOption`, pas de clic sur input.
- Idempotence : re-run = 0 changement. Page PDP HTML lag qq min sur `page_cache` → ne PAS re-patcher sur du stale, autorité = Admin + `.js`.
- **⚠ PIÈGE `?variant=` (Méridien 2026-07-10) : un lien avec `?variant=<id>` FORCE cette couleur et ÉCRASE le défaut — ce n'est PAS un bug.** Pour juger le défaut d'une fiche, TOUJOURS tester l'URL PROPRE `/products/<handle>` (sans param). Un `?variant=<id blanc>` qui montre du blanc = comportement voulu (deep-link), pas une régression. Vérif définitive = fetch du HTML de base + lire l'`<option selected>` du `<select name="options[Couleur]">` (doit être la couleur foncée) + la 1ʳᵉ image `product-media` (doit être le packshot foncé). Le param collé vient souvent de l'onglet/historique de the operator, pas d'un défaut du site.

---

## 8. Gates maintenus (photos)

- **ZÉRO dB chiffré** nulle part (skill shop-b-design §7). Cotes en cm = OK.
- Garantie = **2 ans légale UE** only. Zéro faux avis / urgence / compteur / prix barré inventé.
- the operator 2026-07-10 : « le GMC est passé » → pour le CONTENU PHOTO les gates dB/preuve ne re-bloquent plus (cotes cm, réassurance garantie 2 ans OK). Les gates STRUCTURELS (faux avis câblés, compareAt inventé) restent hors-scope de ce skill.
- Palette Japandi : crème `#F7F4EF` / bois / lin / bleu-mer. Zéro fond néon/gradient IA violet.

---

## Rappel boucle

Un produit → scrape Ali → générer (GO) → montrer tout → publier (GO + double-confirm) → câbler couleur↔photo → **défaut = base foncée (§6)** → vérifier Admin + `.js`. Puis produit suivant quand the operator l'envoie.
