---
name: shop-b-design
description: >
  OBLIGATOIRE pour TOUT travail visible sur SHOP-B (shop-b.example, ventilateurs de plafond,
  dossier C:\Users\YOU\Documents\BUSINESS\shop-b, store shop-b-handle) : nouvelle section,
  page, copy, fiche produit, email, bannière, design, CSS, refonte, image, SEO, blog,
  quiz, menu, footer. Déclencheurs typiques : « fais une section », « réécris »,
  « nouvelle page », « change le design », « ajoute un truc sur shop-b », « améliore la
  home », « écris la fiche », « fais le mail ». Contient la DA verrouillée (tokens hex,
  typo, formes), la grammaire de section, la voix de marque FR, le catalogue anti-AI-slop
  BANNI→À LA PLACE, les gates légaux GMC et le process technique (wiring, cache, vérif).
  Invoquer AVANT d'écrire la moindre ligne visible. Ne s'applique PAS à SHOP-A.
---

# SHOP-B Design — DA verrouillée + anti-AI-slop

> SHOP-B = ventilateurs de plafond premium FR (shop-b.example, store `shop-b-handle`, EUR, marché FR,
> thème Horizon). Esthétique : Japandi/méditerranéen chaud, calme, honnête. TOUT contenu
> visible (texte, section, image, CSS) passe par ce skill. Une valeur hors des listes
> ci-dessous (hex, font, radius, mot) = red flag AI-slop → corriger avant livraison.
>
> Références durables : `shop-b/pivot-2026-07/README.md` (journal des décisions),
> `shop-b/sections/shop-b-*.liquid` (36 sections sources), thème live via Admin API
> (token `shop-b/.secrets/access-token.txt`, 24h, `bash scripts/get-token.sh`).

---

## 0. VERROU IDENTITÉ (avant tout, prioritaire sur tout)

- SHOP-B = `shop-b-handle` / `shop-b-handle.myshopify.com`. JAMAIS confondre avec SHOP-A `shop-a-handle` (même owner, store différent). Handle/GID = COPIÉ du banner/registry, jamais de mémoire.
- Identité = LE DOSSIER : si `cwd` ≠ `C:\Users\YOU\Documents\BUSINESS\shop-b` → STOP, vérifier `pwd` + fingerprints (sections `shop-b-*` présentes, pas `wolf-*`). Le cwd Bash DÉRIVE silencieusement → chemins absolus toujours, token en chemin absolu.
- Un token = un store. Sanity check dans chaque script : `shop.myshopifyDomain === 'shop-b-handle.myshopify.com'` sinon `exit 1`.
- Double-confirmation avant TOUTE mutation (themeFilesUpsert/productUpdate/metafieldsSet…) : re-citer « Sur **SHOP-B**, je vais `<effet exact>` » + GO explicite de the operator (sa demande directe = GO).

---

## 1. PALETTE (hex exacts — rien d'autre)

⚠ Les noms de variables mentent (`--bz-clay` = un bleu). Se fier au HEX, jamais au nom.

| Rôle | Hex |
|---|---|
| **Accent signature** (overlines, CTA hover, liens, badges, barre suivi) | `#2E7DA1` |
| Bleu icônes/étoiles | `#3E93BC` (décoratif only, jamais en texte sur fond clair) |
| Bleu pastel | `#8FC6E0` (décoratif only) |
| Bleu foncé (petits textes AA, PDP trust) | `#2A7491` |
| Bleu profond (gradients réels) | `#1E5F7E` · `#9DC9DE` |
| **Fonds crème** (JAMAIS `#fff` en fond de section) | `#F7F4EF` (principal) · `#F6F2EA` (défaut schema) · `#FBF9F4` · `#F8F6F1` · `#FAF8F4` |
| Sable | `#E9E2D2` · `#E8E0D4` |
| Encre titres | `#1A1A1A` ; soft `#2B2B2B` / `#3A352F` |
| Muted chaud (body secondaire) | `#6B6760` / `#6F6A63` ; body sur sombre `#CFC8BE` / `#CFCCC7` |
| Fonds sombres (bandes en-action / product-story) | `#171411` · `#0B0B0B` · `#0E0E10` |
| Bordures | `rgba(26,26,26,.08)` · `#E3DCCF` · `#E0D6C4` |
| Sémantique | forêt `#2E4034` (hover CTA featured) · succès `#1F7A52` / stock `#2E7D32` · Trustpilot `#00B67A`/`#DCDCE6` · sale `#C8381E` (existe mais INUTILISÉ — compareAt retirés) |

**Contraste (WCAG, mesuré)** : `#2E7DA1` sur crème ≈ 3.3:1 → OK titres ≥18px + décoratif, **INTERDIT en texte <16px**. Petits textes sur clair → `#2A7491` (~4.6:1 AA) ou `#6B6760` (~4.7:1). `#8FC6E0`/`#3E93BC` = jamais en texte sur clair.

**Gradients** : uniquement bleus-forêt réels (`#1E5F7E`→…). **JAMAIS violet/magenta** (marqueur AI-slop n°1).

---

## 2. TYPO

- **Fraunces** 400/500 UNIQUEMENT — titres éditoriaux (H1/H2 manifestes). **JAMAIS bold/600+.** `letter-spacing:-.01em` à `-.03em`. H1 hero `clamp(2.6rem,4.6vw,4.4rem)` ; H2 section `clamp(2rem,4vw,3rem)`.
- **Poppins** 600-700 — overlines / boutons / nav / UI. UPPERCASE, `letter-spacing:.16em~.22em`, overlines `.72rem 700`.
- **Inter** 400 — body. Theme settings : body 14px `inter_n4`, heading `poppins_n7`.
- **RÈGLE PERF DURE — fonts chargées UNE fois site-wide** (23 sections injectaient chacune leur `<link>` → ~14 requêtes css2). Une nouvelle section `shop-b-*` NE remet PAS son `<link>` fonts — elle assume les familles chargées. URL canonique unique (layout/snippet partagé) :
  `css2?family=Fraunces:opsz,wght@9..144,400;9..144,500&family=Inter:wght@400;500;600&family=Poppins:wght@400;500;600;700;800&display=swap`

---

## 3. FORMES, BOUTONS, MOUVEMENT

- **Radii** : pills `999px` (TOUS les CTA/badges/barres) · cartes `12px` (jusqu'à 16) · médias `20px` · inputs `4px` · boutons Horizon natifs `14px`.
- **Bouton canonique** : pill, fond `#1A1A1A`, texte crème `#F7F4EF` (PAS blanc pur), Poppins 600 `.78rem` uppercase `.08em`, hover `translateY(-2px)` + ombre. Variantes hover : featured → forêt `#2E4034` ; bestsellers → azur `#2E7DA1`.
- **Ombres** : douces, diffuses, teintées par la couleur de l'élément (ex badge `rgba(46,125,161,.4)`). Jamais d'ombre dure/néomorphisme.
- **Easing signature** : `cubic-bezier(.22,1,.36,1)` (var `--bz-ease`). Reveals via IntersectionObserver classe `.in` + failsafe `setTimeout` 1.2s. **`prefers-reduced-motion:reduce` neutralise TOUT, dans chaque section** (non négociable). Jamais bounce/néon/parallax lourd.
- Paddings section : 72–88px par défaut (settings `pad_top`/`pad_bottom`).
- Breakpoints canoniques : **749px** (mobile, standard Horizon) et **990px** (tablette) UNIQUEMENT. Ne pas inventer 640/899/520.
- `overflow-x:clip` site-wide déjà en place (`shop-b-noscroll`) — ne pas casser.

---

## 4. GRAMMAIRE DE SECTION (ouverture rigide)

Chaque section s'ouvre : **overline** (azur `#2E7DA1` — ou `#2A7491` si <16px — uppercase `.22em .72rem 700`) → **H2 Fraunces 400 phrase-manifeste** `clamp(2rem,4vw,3rem)` → **sous-titre muted** `#6B6760` `max-width:640px`.

CSS scoping (obligatoire) :
- Tokens `--bz-*` posés sur `#shopify-section-{{ section.id }}`, **JAMAIS `:root`**.
- Classes `.bzXXX-{{ sid }}` avec `sid = section.id | replace:'_','' | replace:'-',''`.
- Zéro classe globale ; deux instances de la même section ne doivent pas se marcher dessus.

Grilles : 4-col `auto-fit minmax(220px,1fr)` · 3-col · 2-col split. Images : cartes collection carré/cover (ratio `square`, jamais `adapt`) ; featured 4/3 contain white-bg ; hero 16:9 desktop / portrait mobile, Ken Burns 16s.

**Ordre home LIVE (index.json = vérité, le README est STALE)** : announce → hero → quiz → bestsellers → reassurance → team → [savings DISABLED] → en_action → featured → video_gallery → [silent DISABLED] → [comparison DISABLED] → process → blog_teaser → faq.
**Ordre PDP** : main(buy-box 13 blocs : rating[DISABLED]→title/price→installments→divider→variant_picker→shipbar→promise→buy_buttons→payments→trust→service→description→jsonld) → recommendations → team → reels → en_action → why → [specs/silence/energy DISABLED] → pdp-process → product-story → faq.
**Dormantes (aucun template) : testimonials (faux avis), whatsapp, sales-pop — JAMAIS câbler sans données réelles.** Ré-activer une section DISABLED = repasser les gates §7 (dB, avis, claims) AVANT GO.

Templates pages : contact=`shop-b-contact` (grid `1fr 1.35fr`) · faq/story=`shop-b-page-raw` · blog=`shop-b-blog` · article=`shop-b-article`. Mega-menu = CSS-only `:hover`, panneau enfant du `<li>`, pont invisible `::after` 14px. Trustpilot = SVG dessiné main (carrés `#00b67a`). Logos paiement = SVG inline, jamais images.

### Checklist « nouveau composant SHOP-B » (10 points, TOUS cochés avant d'écrire le .liquid)
1. Tokens `--bz-*` scopés `#shopify-section-{{section.id}}` (jamais `:root`)
2. Classes `.bzXXX-{{sid}}`
3. Fonts NON re-chargées (§2)
4. Overline + H2 Fraunces 400 aux specs §4
5. Fond crème `#F7F4EF` (jamais `#fff`)
6. Accent `#2E7DA1` (jamais violet)
7. `@media (max-width:749px)` breakpoint principal (990px tablette si besoin)
8. Reveal `.in` + garde `prefers-reduced-motion`
9. `:focus-visible` sur tout interactif : `outline:2px solid #2E7DA1;outline-offset:2px;border-radius:inherit;` (scopé sid — Horizon ne le fournit PAS sur les sections custom ; 31/37 sections l'avaient oublié)
10. Chaque texte/couleur/image/spacing = `setting` de schema, `default` NON-blank (un default vide = `FILE_VALIDATION_ERROR`)

---

## 5. VOIX DE MARQUE (copy FR)

- **Vouvoiement strict** (mesuré : vous=48, tu=0). La marque dit **« on »** (38×), pas « nous » corporate (réservé légal).
- Phrases courtes. Fragments assumés (« Voilà. C'est lui. »). Règle de trois. Émotion/bénéfice AVANT specs (specs → accordéons).
- **Naming produits** : nature/vent/lieux, mono-bisyllabique — Alba, Plume, Fjord, Sylva, Opale, Boréal, Ambre, Cèdre, Palma, Cap, Éclipse, Zénith, Alto, Méridien, Levant. Finitions poétiques : Nuit=noir, Ivoire=blanc, Moka=marron. **JAMAIS préfixe « SHOP-B <Nom> ».**
- Format titre produit : `<Nom> | Ventilateur <descripteur minuscule> <diamètre cm>`.
- **Lexique signature** : murmure / souffle / chuchotement · brise / l'air circule / la pièce respire · se fait oublier / se fond / disparaître / épuré · une fois pour longtemps · été comme hiver · SAV français / petite équipe / une vraie personne au bout du mail.
- Slogans en stock : « Le silence, notre signature. » · « Simple comme un souffle » · « Le bon air, toute l'année » · « Pensé pour disparaître, conçu pour se remarquer » · « Une petite équipe. Et ça change tout. » · « Trois questions, zéro jargon. »
- **Honnêteté** : chiffre quantifié uniquement sourçable, avec « jusqu'à » (« jusqu'à 70 % d'énergie en moins qu'un moteur AC classique ») ; limites assumées (« ne remplace pas une climatisation par très forte chaleur ») ; garantie « 2 ans (légale UE) » jamais lifetime ; newsletter « jamais de spam ».
- **SEO** : page title `<Sujet> | SHOP-B` ou `| SHOP-B · Ventilateurs de plafond` ; produit seoTitle ≤62c keyword-first (`Ventilateur <descripteur> | <Nom> SHOP-B`) ; seoDesc 120–165c finissant « Garantie 2 ans. ».
- **Gabarit body PDP** : lead sensoriel → accordéons Description(open) / Caractéristiques / Spécifications(table) / Livraison & retours (boilerplate fixe).
- États vides = copy SHOP-B, jamais défaut Shopify EN : panier vide (« Votre panier est vide. Découvrez nos ventilateurs. » + CTA), 0 résultat recherche/collection, fallback quiz (le MAP JS doit avoir un produit par défaut). Retours d'action = pattern `shop-b-contact` : `form.posted_successfully?` message merci FR `role="status"` + `form.errors` gérés.

---

## 6. ANTI-SLOP : BANNI → À LA PLACE

| BANNI (marqueur AI-slop) | À LA PLACE |
|---|---|
| Ouvertures « Découvrez / Sublimez / Transformez » | Entrer par la scène ou le bénéfice concret (« La pièce respire. ») |
| Superlatifs vides : révolutionnaire, incroyable, ultime, parfait, premium, n°1 | Fait concret ou adjectif sensoriel sobre |
| dB / tr-min / cfm chiffrés | Adjectifs : « ultra-silencieux », « à peine plus qu'un murmure » (voir gate §7) |
| Urgence : soldes, -30 %, offre limitée, dernière chance, compteurs | Rien. Prix nu, honnête |
| Anglicismes, franglais | FR courant |
| `!` hype, tutoiement | Sobriété, vouvoiement |
| Em/en-dashes (— –) | Virgule, deux-points, point |
| « Pourquoi nous choisir » + 3 icônes génériques | Réassurance bornée exacte : « Garantie 2 ans (légale UE) », « Retours 30 jours », « SAV français » |
| Stats/avis/compteurs inventés | Rien tant que pas de données réelles |
| FAQ générique | Questions réellement posées, réponses spécifiques produit |
| Fake heritage (« depuis 1987 ») | « Une petite équipe » — vrai |
| Emoji (n'importe où, y compris ✅ en puce) | Icônes SVG outline stroke 1.5 ; check SVG `M5 13l4 4L19 7` couleur accent |
| Gradients violet/magenta | Gradients bleus-forêt réels uniquement |
| Glassmorphism gratuit | 1 seul usage justifié existant : carte témoignage hero `blur(12px)` |
| Hero centré générique | Hero SHOP-B = asymétrique gauche, preuve AVANT titre |
| Ombres lourdes, néomorphisme, bounce, néon | §3 |
| Photos fond studio néon / gradient IA | Palette photo bois/lin/crème/bleu-mer |

**Discipline image** : (a) position 1 = TOUJOURS lifestyle (ventilateur en situation, lumière chaude, bois/lin/crème) ; white-bg/détail après. (b) Une grille ne mélange jamais lifestyle et white-bg en position 1 (ratio carré uniforme en place, le garder). (c) Zéro image brandée fournisseur — vérif à l'ŒIL sur planche, jamais au filename (2 fausses « lifestyle » étaient des photos ARIAZE). (d) Match média post-reorder par BASENAME (`shop-b-<handle>-NN`), jamais par position.

**5 règles d'or** : (1) rien d'affiché qui ne soit prouvable ; (2) zéro marqueur IA ; (3) palette+typo verrouillées, hex/font hors liste = red flag ; (4) copy FR courante, courte, concrète, honnête ; (5) accessibilité non négociable (reduced-motion partout, aria, H1 unique).

---

## 7. GATES LÉGAUX / GMC (durs, non négociables)

1. **ZÉRO claim inventée** — tout chiffre sourçable (risque GMC + DGCCRF).
2. **ZÉRO dB chiffré nulle part** — la source ariaze n'annonce AUCUN dB, tout nombre est inventé. ⚠ `index.json` `shop-b-silent` porte encore `"db":30/35/60/50` mais `disabled:true` ; ré-activer = réintroduire des dB = INTERDIT sans purge préalable.
3. **Garantie = 2 ans légale UE SEULEMENT.**
4. **ZÉRO faux avis / urgence / compteur** — `shop_b_rating` (« 4,8/5 · 312 avis ») est `disabled:true` dans product.json : ne PAS ré-activer avant avis réels. Testimonials/whatsapp/sales-pop dormantes : jamais câbler avec de l'inventé.
5. **compareAt jamais inventé** — retirés (15 produits/78 variants). ⚠ `_pivot-import.js` les re-pousse depuis le CSV → re-run `_remove-compareat.js` après tout re-import. Sourcing : compareAt CSV gardé si remise ≤40 %, sinon cap ×1,3−0,10.
6. **ZÉRO mention ariaze / fournisseur / Chine** côté client (images brandées supprimées par filename ; ParcelWILL dropshipping ON + mots-clés cachés).
7. **Adresse perso jamais publiée** (adresse business GMC = 47 rue Vivienne 75002 Paris ; entité légale = placeholders post-incorporation).

---

## 8. PROCESS TECHNIQUE (wiring, cache, vérif)

**Wiring thème** :
- Sections ADDITIVES, jamais reconstruire un template (les settings d'instance saisis à la main seraient perdus).
- Read-before-write sur `themeFilesUpsert` (il remplace le fichier ENTIER).
- Markers idempotents pour toute insertion (`shop-b-mega-2lines`, `bztrust`…) : re-run = skip-si-présent ; revert = retirer le bloc marqué.
- JSONC : strip `/* … */` avant `JSON.parse` (tous les `templates/*.json` ont le header auto-generated).
- `themeFilesUpsert` NON-atomique (batch partiel possible) → vérifier chaque fichier individuellement après un batch.
- Gate de complétude fail-loud sur tout remplacement de chaîne : chaque `from` introuvable = abort ; post-check regex du pattern interdit = 0 sinon abort.
- Remplacements FR : flexibiliser espace/nbsp(c2a0)/narrow-nbsp(202f) + apostrophes `'`/`'` + tirets des DEUX côtés ; straggler → hexdump.
- `files(first:250)` tronque → fetch par `filenames:` explicites.
- CSS : écrire dans `{% stylesheet %}` de la source Liquid (compile → `compiled_assets/styles.css` nouveau `?v=`), jamais dans le bundle généré. `min-height` 2 lignes (`2.6em`) sur titres clampés = zéro écart d'alignement.
- Nav = section custom `shop-b-nav`, items = blocks de `header-group.json`/`footer-group.json` (le token n'a PAS le scope menus natifs).

**Cache** :
- `page_cache` desktop STICKY (heures) ; mobile ~minutes. `themePublish` ne flush pas tout (`PageDetailsController` jamais).
- Preuve fraîche = Section Rendering API `/?sections=<id>` (seul endpoint jamais caché) ou header `server-timing` avec `render;dur`.
- **JAMAIS re-patcher sur du stale** : Admin API = autorité ; live en retard = attendre TTL.

**Vérification avant « fait »** :
- Admin API d'abord (état écrit), live ensuite (propagation) — deux checks distincts.
- Screenshot/navigateur pour tout visuel ; décision image à l'œil, jamais au filename.
- Idempotence prouvée : re-run = 0 changement ; `--dry` sur tout script mutant.
- Crawl throttlé (429 auto-infligé = faux 404).

**Gates head avant toute refonte visuelle (gaps durs mesurés live)** :
- (a) `social_image` 1200×630 (crème `#F7F4EF` + logo + 1 lifestyle) dans Réglages thème → og:image/twitter:image (actuellement ABSENT partout = partage WhatsApp/iMessage vignette blanche) ;
- (b) favicon propre 32×32 (actuellement un `Capture_d_ecran_*.png`) ;
- (c) `theme-color` = `#1A1A1A` (actuellement vide).

**Vestiges connus à purger (proposés, pas encore GO)** : `templates/product.json` ~L810 note « Valeurs indicatives en décibels (dB) » (dernier dB survivant) ; `templates/index.json` placeholders « SHOP-B Solstice/Zéphyr/Aria/Boréal » + « Onyx » ; `product_recommendations` → `_product-card-gallery` encore `image_ratio:"adapt"`.
