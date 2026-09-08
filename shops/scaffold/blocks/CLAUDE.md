# blocks/ — __SHOP_NAME__

Blocs de thème (Horizon accepte des blocs custom dans les conteneurs dont l'allowlist vaut `{"type":"@theme"}`).

Mêmes règles que `sections/` : voir [`../sections/CLAUDE.md`](../sections/CLAUDE.md).

Cas d'usage typique : convertir des blocs `custom-liquid` (non configurables) en bloc maison qui rend le même Liquid **byte-identique** mais expose des réglages (marges desktop/mobile). Prévoir un mode « invisible » rendu en `display: contents` pour les blocs utilitaires (CSS, JSON-LD) — sinon ils occupent un slot flex et créent un espace fantôme.
