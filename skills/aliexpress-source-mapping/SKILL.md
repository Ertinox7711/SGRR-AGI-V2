---
name: aliexpress-source-mapping
description: >
  Retrouver la ou les fiches AliExpress SOURCE d'un catalogue e-commerce (boutique
  dropship clonée : SHOP-B, SHOP-A, ou toute boutique Shopify sourcée sur AliExpress).
  Déclencheurs : « trouve les produits AliExpress d'origine », « fais un XLS produit →
  fournisseur Ali », « d'où viennent ces produits », « mappe chaque produit à sa source »,
  « trouve avec les images ceux qui ont le plus de commande », « reverse-source le
  catalogue ». À invoquer AVANT de commencer toute recherche de fournisseur Ali —
  contient la méthode qui évite les faux positifs (fiches mortes, mauvais produits)
  qui ont coûté des sessions entières auparavant.
---

# AliExpress source-mapping — reverse-sourcing d'un catalogue dropship

But : pour chaque produit d'une boutique (clonée depuis AliExpress via un concurrent),
retrouver la **fiche AliExpress d'origine**, vérifiée **par l'image**, avec le **nombre de
commandes**, sans jamais se tromper de produit.

## DOCTRINE CENTRALE — reçus d'abord, devine ensuite

**La cause n°1 des échecs passés = partir de devinettes (ids trouvés en SERP / vieux
fichier non vérifié) au lieu de partir des reçus.** Inverser cet ordre = la clé.

1. **Cherche le reçu AVANT tout.** Un import réel laisse une trace : fichier fournisseur
   (`*_fournisseurs_aliexpress.xlsx` dans `~/Downloads`), mémoire projet
   (`shop-b-import-*`, `*-source-*`), note dans le `CLAUDE.md` du dossier boutique.
   Ces liens = **vérité maximale** (ce sont les VRAIS achats). Ne jamais re-deviner un
   produit dont on a déjà le reçu.
2. **Cross-check les candidats existants contre le reçu.** Si un `candidates.json` /
   vieux XLS traîne : compare ses ids à ceux du reçu. S'ils **matchent** sur les produits
   connus → le fichier est fiable pour ceux-là, et ça **isole exactement** les produits
   restants (inconnus) sur lesquels concentrer l'effort. (SHOP-B : 12/12 boho matchaient →
   restaient 4 inconnus au lieu de re-traiter 23.)
3. **Ne devine QUE le résidu.** Tout le reste est déjà résolu.

## PIPELINE

### 1. Catalogue live
`https://<boutique>/collections/<coll>/products.json?limit=250&page=N` (endpoint public
Shopify, pas d'auth). Extraire key/titre/handle/prix/image. Handle du produit =
`t.split("|")[0]` normalisé NFD sans accents.

### 2. Fiches AliExpress — Scrapling StealthyFetcher sur pages ITEM
**Seul moyen fiable de passer l'anti-bot.** `WebFetch`/`curl`/`https.get` Node / in-app
browser = 403/captcha/page vide. **Ne jamais résoudre un captcha.**

```python
# fetchers, PAS `from scrapling import` (0.4.8+)
from scrapling.fetchers import StealthyFetcher
page = StealthyFetcher.fetch(f'https://fr.aliexpress.com/item/{cid}.html',
                             headless=True, network_idle=True, timeout=60000)
html = page.html_content
```
- **Pages ITEM uniquement.** Les pages **search** (`/w/…`, `/wholesale-…`) = fines,
  lazy-loaded, polluées de pubs (même id sponsorisé revient sur toutes les requêtes) →
  inexploitables. Ne pas s'en servir pour matcher.
- Extraire par regex : `og:image` (image héro), `subject`/`og:title` (titre),
  `tradeCount`/`…vendu|sold` (commandes), urls `alicdn.com/kf/…\.(jpg|png|webp)` (les
  **images-variantes**, précieuses — voir §4).
- `PYTHONIOENCODING=utf-8` obligatoire (Windows cp1252 crash). Prompts longs → Write un
  `.py` puis `python script.py`, jamais `python -c`.
- Scrapling lent (Camoufox ~15-40 s/fiche) → **run_in_background**, poll le `.json` final.

### 3. Détecter les fiches MORTES (piège majeur)
Un vieil id peut être **recyclé / supprimé** → la fiche répond 200 mais est un shell :
- **image ≈ 5500 octets** = spinner/placeholder gif, PAS une vraie photo produit.
- **titre vide** + **`orders` = un petit nombre identique sur plusieurs fiches** (ex
  "22") = **faux match regex**, pas une vraie donnée.
- 2+ fiches renvoient la **même longueur HTML** exacte = shell générique.
→ **Écarter ces ids.** Ne JAMAIS reporter leur nombre de commandes (souvent un gros
chiffre attractif "10 000" hérité d'un vieux fichier — c'est un mirage).

### 4. Correspondance VISION (jamais par titre seul)
Télécharger l'`og:image` (et 3-5 `alicdn` de variantes) → **Read l'image** → comparer au
rendu boutique. Le titre ment (« nordic wood fan » colle à 50 produits) ; **l'image
tranche** : nombre de pales, type de moyeu (flush/cylindre vs tige/dôme), couleur bois,
présence LED. C'est ce qui attrape les mismatches (candidat « dôme 5 pales » ≠ produit
« flush 3 pales »).
- Si plusieurs candidats plausibles → prendre celui à **fort volume de commandes /
  boutique établie** (demande courante « le plus de commande »).

### 5. Pattern « 1 listing → N SKU boutique » (colorways)
Les boutiques dropship **padent leur catalogue** : un seul ventilateur AliExpress
(vendu en plusieurs coloris via les SKU-variantes) devient **plusieurs fiches boutique**
renommées/repricées. Signe : plusieurs produits boutique visuellement **identiques sauf la
couleur** (noyer/noir vs blanc/chêne). **Inspecter les images-variantes** (`alicdn` §2) du
listing : si elles contiennent les deux coloris → **un seul id source couvre tous ces
SKU**. (SHOP-B : Sylva+Opale [noyer/noir] + Cap LED Ivoire+Alba [blanc/chêne] = 1 listing.)
Résout N produits d'un coup au lieu de chasser N mauvaises fiches.

### 6. Livrable XLSX (openpyxl)
- 1 ligne/produit : N° · **vignette boutique** · nom · titre · prix · **vignette Ali** ·
  id · lien Ali · commandes · prix fournisseur · **correspondance (confiance)** · lien
  boutique · note. Les 2 vignettes côte à côte = la preuve vision demandée.
- Vignettes = PIL `thumbnail((115,115))` → embed `openpyxl.drawing.image.Image`.
- Onglet 2 « Méthode & fiabilité » : tranches de fiabilité + avertissements.
- Sortir dans `~/Downloads`, **NOM DISTINCT** (ne jamais écraser le fichier d'import réel).

## HONNÊTETÉ — « te trompe pas » (règle dure)
- **Confiance explicite par ligne** : `Confirmé (import)` > `Confirmé (image)` >
  `Probable (même modèle/variante)`. Un « probable » honnête > un faux « confirmé ».
- **`n/d` jamais inventé** : commandes non extractibles (page lazy / anti-bot) = `n/d`,
  pas un chiffre bricolé. Prix fournisseur seulement là où il y a un reçu.
- Reporter fidèlement : listing écarté (mort/mismatch) → le dire dans la note.

## À NE JAMAIS FAIRE
- Partir des ids d'un SERP / vieux fichier sans les vérifier image (= cause des faux :
  id « sac à main », « jupe » sortis pour des ventilateurs).
- Matcher par titre seul.
- Faire confiance à un gros nombre de commandes venu d'une fiche à image 5500 B.
- Utiliser les pages search Ali pour conclure.
- Résoudre un captcha / bricoler des headers 10 min sur un 403 → Scrapling direct.

## Réutilisable
Vaut pour toute boutique dropship clonée (SHOP-A watch winders, SHOP-B ventilateurs,
futures boutiques). La chaîne de sourcing type : boutique ← clonée d'un concurrent Shopify
← lui-même sourcé AliExpress. Le vrai fournisseur = ce que le concurrent a utilisé ; à
défaut de sa liste, le meilleur match-image du listing le plus commandé.
