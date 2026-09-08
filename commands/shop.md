---
description: Savoir sur QUELLE boutique Shopify on travaille avant de toucher quoi que ce soit — identite derivee du dossier, jamais de la memoire. Lecture seule.
argument-hint: "[chemin du dossier, sinon le dossier courant]"
allowed-tools: Bash, Read, Grep
---

the operator a plusieurs boutiques Shopify, **une boutique = un dossier**. La seule
source de verite est `C:\Users\YOU\.claude\shops-registry.md` (miroir `.json`
lu par les hooks). Confondre deux boutiques est la faute la plus couteuse ici.

Dossier a identifier : `$ARGUMENTS` (vide = dossier courant)

## Marche a suivre

1. Lis `C:\Users\YOU\.claude\shops-registry.md`.
2. Prends le chemin cible, mappe-le sur la registry par **prefixe le plus long**.
   L'identite se derive du DOSSIER, jamais de ce dont tu te souviens.
3. Annonce en une ligne, avant toute autre chose :
   `Boutique = <NOM> (<niche>), dossier <root>, handle <handle>`
   Tous ces champs sont **copies** de la registry, jamais tapes de memoire.
4. Verifie l'etat du jeton si une action API est prevue : un jeton
   `shpat_`/session vaut pour **un seul store**, jamais partage.

## Ce que cette commande ne fait pas

- Elle **n'ecrit rien**. Aucun `Edit`, `Write`, `productUpdate`, `themePublish`,
  `themeFilesUpsert`, `metafieldsSet`, `get-token`.
- Toute mutation demande ensuite une double confirmation explicite :
  « t'es sur que c'est <NOM> ? » + l'effet exact re-cite + un GO de the operator.
  Pas de GO = pas de mutation.
- **SHOP-A (`Documents\BUSINESS\shopify`) est en LECTURE SEULE**, point.
  `OFM HUB` et `OFM HUB V2` sont des zones protegees au meme titre.

Si le dossier cible n'est dans aucune ligne de la registry : dis-le et
arrete-toi. Ne devine pas la boutique.
