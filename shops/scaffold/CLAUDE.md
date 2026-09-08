<!-- BANNER:START - genere par ~/.claude/scripts/shops-banner.ps1, ne pas editer a la main. -->
> ## SQUELETTE NON ACTIVE - aucune boutique derriere ce dossier.
> Ce bloc est remplace par le vrai banner d identite au moment de l activation :
>     powershell -NoProfile -File scripts/init-shop.ps1 -Name "Nom" -Niche "english niche" -NicheFr "niche fr" -Folder slug -App NOM-API
> Tant qu il affiche ceci : pas de ligne de registre, pas de token, AUCUNE mutation Shopify.
<!-- BANNER:END -->

# __SHOP_NAME__ — Boutique __NICHE_FR__ · Mémoire maître

> Lis ce fichier en premier chaque session. Puis `SESSION-INIT.md` (rituel §0 = verrou d'identité).
> On gère une entreprise, pas un jouet. Tout doit marcher au redémarrage, zéro bug.
> **État actuel : BLANC.** Rien n'est créé : pas de boutique Shopify, zéro produit, zéro thème choisi, domaine pas acheté. Ce dossier est le squelette propre, prêt à être rempli — uniquement sur demande explicite de the operator.

## 📁 OÙ EST QUOI — index (cherche un truc → regarde ici d'abord)

| Je cherche… | C'est là |
|---|---|
| **Mémoire maître / état projet** | ce `CLAUDE.md` |
| **Bootstrap session (token, accès API, rituel identité)** | `SESSION-INIT.md` |
| **Activer la boutique (nom, registre, banner, mémoire)** | `README-INIT.md` + `scripts/init-shop.ps1` |
| **Mémoires cross-session** | `~/.claude/projects/C--Users-YOU-Documents-BUSINESS-__SHOP_SLUG__/memory/MEMORY.md` |
| **Registre central des boutiques (anti-confusion)** | `~/.claude/shops-registry.md` |
| **Runbook de lancement (quoi faire, dans quel ordre)** | `docs/LAUNCH-CHECKLIST.md` |
| **Pièges déjà payés ailleurs (Liquid, cache, API)** | `docs/PITFALLS-HERITES.md` |
| **Gates légaux / Google Merchant Center** | `docs/GMC-GATES.md` |
| **Brief de marque (nom, promesse, ton)** | `docs/BRAND-BRIEF.md` |
| **DA verrouillée (couleurs, typo, formes)** | `docs/DESIGN-SYSTEM.md` |
| **Scripts (token, contexte, thème)** | `scripts/CLAUDE.md` |
| **Tokens / creds (jamais commit)** | `.secrets/CLAUDE.md` |
| **Catalogue, CSV import, sourcing** | `data/CLAUDE.md` |
| **Dossiers stratégiques (marché, concurrents, SEO)** | `docs/CLAUDE.md` |
| **Validation produit (grilles /105, methode <COACH>)** | `C:\Users\YOU\Documents\BUSINESS\shopify\validation\` (partagé, lecture seule) + skill `product-hunter` |
| **Doctrine <COACH> (<COURSE-NAME>)** | `C:\Users\YOU\Documents\BUSINESS\shopify\docs\coach-doctrine.md` (partagé, lecture seule) |

## Mode opératoire (NON NÉGOCIABLE — chaque session dans ce dossier)

- **Verrou d'identité D'ABORD.** Avant toute action (même une question) : rituel `SESSION-INIT.md` §0 (pwd → registre → banner → annonce → preuve token live). Personne ne se trompe de boutique.
- **Double-confirmation avant toute écriture / mutation.** Edit/Write d'un fichier de cette boutique, ou tout `productUpdate` / `themePublish` / `themeFilesUpsert` / `metafieldsSet` / `get-token` / tool MCP Shopify write → re-cite « Sur **__SHOP_NAME__** (__NICHE_FR__), je vais `<effet exact>` → OK ? » + attends GO. Pas de GO = pas de mutation.
- **Jamais cross-boutique sans demander.** Toucher SHOP-A / SHOP-B / un autre dossier ou token = STOP, demander. **Un token = un store.**
- **Lis avant d'affirmer.** Avant de citer un fichier/script/réglage → Read/Grep pour confirmer son état réel. **État disque > mémoire. Live > local.**
- **Vérifie avant de dire « fait ».** Run le script, lis le rendu réel, screenshot si c'est visuel.
- **Mets à jour ce CLAUDE.md** après chaque changement structurel (une entrée ✅ datée, avec la commande de re-run et ce qui a été vérifié).

## Marketing / SEO / Copy — skills à chaîner (NON NÉGOCIABLE pour tout contenu)

Tout texte visible (page, fiche produit, collection, email, post, titre, bouton) DOIT mélanger : **copywriting** (SEO-aware) + **marketing-psychology** + **page-cro**. Pricing → **pricing-strategy**. Logo/identité → **brandkit**. Emails → **email-campaigns**. Social → **social-content**. GTM → **launch-strategy**. Sourcing/validation produit → **product-hunter** puis **persona-market-analysis**. Jamais de copy brute.

⭐ **Dès que la DA est figée** (`docs/DESIGN-SYSTEM.md` rempli), créer un **skill maître de marque** sur le modèle de `~/.claude/skills/shop-b-design/SKILL.md` : DA verrouillée (hex exacts, fonts, radius, easing), grammaire de section, voix de marque FR, catalogue anti-AI-slop BANNI→À LA PLACE, gates légaux, process technique. Ensuite : **toute** écriture visible passe par ce skill. Une valeur (hex, font, mot, radius) hors des listes du skill = AI-slop → corriger avant livraison.

## Identité de marque — À REMPLIR

| Champ | Valeur |
|---|---|
| Nom | __SHOP_NAME__ |
| Niche | __NICHE_FR__ |
| Domaine `.fr` | `<TODO — vérifier dispo AFNIC/RDAP avant de s'attacher au nom>` |
| Domaine `.com` | `<TODO>` |
| Angle / positionnement | `<TODO — cf. docs/BRAND-BRIEF.md>` |
| Mot-clé SEO principal | `<TODO>` |
| Marché / langue / devise | FR / français / __CURRENCY__ |

⚠ **Ordre correct** : vérifier la dispo des domaines **AVANT** de figer le nom, la DA et le logo. Un nom pris = tout est à refaire.

## Objectif

`<TODO — 1 paragraphe : modèle (mono-produit premium vs catalogue), canal d'acquisition (Google Ads Search / Shopping / Meta), saison cible, ticket moyen visé, marge cible ≥ 65 %.>`

## Identité boutique

| Champ | Valeur |
|---|---|
| Store handle | `__HANDLE__` |
| Domaine API | `__DOMAIN__` |
| Admin | https://admin.shopify.com/store/__HANDLE__ |
| Devise | __CURRENCY__ |
| Timezone | Europe/Paris |
| Langue | FR par défaut du domaine |
| Propriétaire | Serrano the operator |
| Nom affiché (site, copy, `shop.name`) | **__SHOP_NAME__** — orthographe reelle, accents compris |
| Nom registre + hooks | `__SHOP_NAME_ASCII__` — **ASCII volontaire** (voir ci-dessous) |
| Thème | `<TODO — Horizon est le meilleur gratuit ; le garder sauf raison forte>` |
| App API | `__APP_NAME__` (Dev Dashboard, OAuth client_credentials) |
| Token | `.secrets/access-token.txt` (shpat_, 24 h, via `bash scripts/get-token.sh`) |

> **Deux orthographes du nom, c'est voulu — ce n'est PAS un désaccord banner/registre.**
> La couche infra (`~/.claude/shops-registry.md` + son miroir `.json` + les hooks PowerShell + le banner ci-dessus) est **ASCII pur** : le sync global transcode, un caractere accentue y devient `?`. Le nom y est donc `__SHOP_NAME_ASCII__`.
> Le nom **affiché** (ce `CLAUDE.md`, la copy, le site, `shop.name` côté Shopify) garde l'accent : **__SHOP_NAME__**.
> `scripts/lib/shop.js` compare les deux **sans accents ni casse** (`fold()`), donc `assertShop()` ne se déclenche pas à tort. Ne « corrige » pas le registre en y remettant un accent : ça réintroduit les `??`.

## Accès API — méthode (store-agnostic, identique à SHOP-B/SHOP-A)

Token Admin GraphQL via **OAuth client_credentials** (app custom installée sur le store).

```bash
bash scripts/get-token.sh          # régénère .secrets/access-token.txt (24h) + affiche les scopes
AT=$(bash scripts/get-token.sh -q) # silencieux → token sur stdout
node scripts/shop-probe.js         # PREUVE live : nom, domaine, devise, thème MAIN
```

- `get-token.sh` et `shop-context.sh` sont **store-agnostic** : ils ne changent pas d'une boutique à l'autre. Seul `.secrets/app-credentials.txt` (SHOP/CLIENT_ID/CLIENT_SECRET, jamais commit) diffère.
- API version cible : `2025-01`. Token `shpat_` expirant en 24 h → relancer chaque session.
- **Scopes à demander dès la création de l'app** (sinon on se fait bloquer en plein travail, cf. SHOP-B) : `write_products`, `write_themes`, `write_files`, `write_content` (pages/blogs), `write_publications`, `read_orders`+`read_customers` (outil marge), `write_online_store_navigation` (**menus** — sans lui, impossible d'éditer la nav par API), `write_legal_policies` (**policies natives `/policies/*`** — sans lui, obligé de faire des pages), `write_inventory`, `write_translations`, `write_discounts`, `write_metaobjects`+`write_metaobject_definitions`.

## Méthode d'import — RÈGLE FERME

Produits ajoutés **par commandes/API avec le token**, JAMAIS en cliquant dans l'Admin. Même règle que SHOP-A et SHOP-B : tout est reproductible, scripté, réversible.

## Structure fichiers

```
__SHOP_SLUG__/
├─ CLAUDE.md              ← ce fichier (mémoire maître + banner identité)
├─ SESSION-INIT.md        ← checklist bootstrap + rituel verrou d'identité §0
├─ README-INIT.md         ← activation du squelette (supprimé/renommé après init)
├─ .gitignore             ← ignore .secrets/, scratch, images générées
├─ .claude/               ← settings.local.json + launch.json (serveurs locaux)
├─ .secrets/              ← tokens + creds (LOCAL, jamais commit) — voir .secrets/CLAUDE.md
├─ scripts/               ← get-token.sh, shop-context.sh, lib/shop.js, probe, push, pull, purge
├─ data/                  ← catalogue, CSV import, backups de scripts, captures
├─ docs/                  ← runbook, pièges, gates GMC, brief marque, design system
├─ sections/ snippets/ blocks/  ← sources Liquid poussées vers le thème
└─ tools/                 ← outils locaux (dashboard marge, etc.)
```

## État boutique (live)

**BLANC — rien n'est créé.** Aucune boutique, aucun produit, aucun thème.

> Journal : à chaque changement structurel, ajouter ici une entrée **✅ TITRE (date, demande citée)** avec : ce qui a été fait, **la commande de re-run**, **ce qui a été vérifié live** (et comment), et les pièges rencontrés. C'est ce journal qui rend la boutique reprenable 3 mois plus tard.

## Sécurité

- Token = **store-local**, jamais réutilisé ailleurs, jamais exfiltré. **Un token = un store.**
- `.secrets/` jamais commit ni collé dans un chat/fichier.
- Confirmer avant destructif (`rm -rf`, delete produit/media, reset) + avant tout ce qui est visible aux autres (push, deploy, ads live, envoi d'email).
- **Jamais** : créer un compte, saisir un mot de passe, mettre une facturation, lancer une campagne payante. Ce sont des actions **owner** (the operator), pas les miennes.
- Discipline multi-boutiques : `~/.claude/CLAUDE.md` § « Discipline multi-boutiques Shopify » + registre `~/.claude/shops-registry.md`.
