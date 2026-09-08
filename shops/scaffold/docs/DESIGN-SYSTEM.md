# DESIGN SYSTEM — __SHOP_NAME__ · À VERROUILLER AVANT LA PREMIÈRE SECTION

> Une valeur (hex, font, radius, easing) utilisée sur le site et **absente de ce fichier** = dérive. Le jour où ce fichier est rempli, il est copié dans un **skill de marque** (`~/.claude/skills/<shop>-design/SKILL.md`) que toute écriture visible doit invoquer.
> Modèle de référence à imiter dans la forme : `~/.claude/skills/shop-b-design/SKILL.md`.

## 1. Palette (hex EXACTS, aucune improvisation)

| Rôle | Variable | Hex | Usage |
|---|---|---|---|
| Encre / texte | `--bg-ink` | `<TODO>` | titres, corps |
| Texte secondaire | `--bg-muted` | `<TODO>` | légendes, labels |
| Fond principal | `--bg-base` | `<TODO>` | fond de page |
| Fond alterné | `--bg-alt` | `<TODO>` | une section sur deux |
| Accent | `--bg-acc` | `<TODO>` | liens, prix, puces, boutons secondaires |
| Accent foncé | `--bg-acc-dk` | `<TODO>` | hover, contraste sur clair |
| Accent clair | `--bg-acc-lt` | `<TODO>` | fonds teintés, illustrations |
| Bordure | `--bg-line` | `<TODO>` | séparateurs, cartes |
| Succès | `--bg-ok` | `<TODO>` | stock, confirmation |
| Solde | `--bg-sale` | `<TODO>` | prix barré / badge remise |

Règles :
- **Un seul accent** + ses deux dérivés. Un deuxième accent non listé = AI-slop.
- Les couleurs **sémantiques** (succès, solde, alerte) ne changent jamais lors d'un recolor de marque.
- Contraste AA minimum sur tout texte (4,5:1 corps, 3:1 grands titres).

## 2. Typographie (2 familles maximum)

| Rôle | Famille | Graisse | Taille (desktop → mobile) |
|---|---|---|---|
| H1 | `<TODO>` | `<700>` | `<TODO>` |
| H2 | `<TODO>` | `<700>` | `<TODO>` |
| Overline (surtitre) | `<TODO>` | `<600>` | `12-13 px`, `letter-spacing .08-.12em`, MAJ |
| Corps | `<TODO>` | `<400>` | `16-17 px` / `line-height 1.6` |
| UI / boutons / prix | `<TODO>` | `<600-700>` | `<TODO>` |

- Les fonts sont chargées **une fois** dans `layout/theme.liquid` (marqueur commenté), jamais par section.
- Jamais de 3ᵉ famille « pour faire joli ».

## 3. Formes & mouvement

| Token | Valeur |
|---|---|
| Radius carte | `<TODO>` |
| Radius bouton / pill | `<TODO>` |
| Ombre carte | `<TODO>` |
| Easing standard | `cubic-bezier(.22,1,.36,1)` |
| Durée transition | `180-260 ms` |
| Largeur de contenu | `min(100% - 2rem, <TODO>px)` |
| Hauteur de cible tactile | `≥ 44 px` |

## 4. Grammaire de section (toute section maison suit ce squelette)

```
overline (MAJ, accent)
H2 (famille titre)
sous-titre (1 phrase, muted)
[contenu]
[CTA unique]
```

- CSS **scopé** par l'id de section (`.xx-{{ section.id }}`) — jamais de sélecteur global.
- **Espacement paramétrable** : groupe « Espacement », case à cocher `sp_custom` **décochée par défaut** (sinon les `clamp()` fluides sont détruits par des valeurs px fixes), + 4 ranges (haut/bas × desktop/mobile).
- Chaque couleur et chaque texte visible = un **setting**, jamais une valeur en dur (sinon rien n'est réglable dans l'éditeur).
- `@media (max-width: 749px)` obligatoire : les carrousels passent en swipe, les grilles en 1 colonne, les flèches disparaissent.
- Reveal au scroll : animation CSS qui **finit visible même sans JS** (jamais une classe posée par JS, sinon la section reste invisible si le JS casse).

## 5. Checklist « nouveau composant » (10 points)

1. Toutes les couleurs viennent de la palette ci-dessus.
2. Deux familles de fonts maximum, celles ci-dessus.
3. CSS scopé, aucun sélecteur global.
4. Tous les textes visibles sont des settings.
5. Groupe Espacement présent, décoché par défaut.
6. Responsive testé à 320 / 390 / 768 / 1366.
7. Zéro overflow horizontal (bleed = gap réel du conteneur).
8. Images `?width=` + `loading=lazy` ; vidéos `preload="none"` + poster.
9. Accessibilité : contraste, focus visible, `alt` réels, cible ≥ 44 px.
10. Zéro signal interdit par `GMC-GATES.md` (fausse note, faux prix barré, urgence inventée).

## 6. Anti-AI-slop (à compléter au fil des dérives constatées)

| Banni | À la place |
|---|---|
| Dégradé violet/bleu « SaaS » | la palette ci-dessus |
| Icônes décoratives sans information | rien, ou un chiffre utile |
| Capsule teintée + bordure + icône autour d'une info simple | typographie (gras, taille, couleur) |
| Ombres multiples empilées | une ombre, celle du token |
| Emoji dans l'UI | rien |
| Trois CTA dans une même section | un seul |
