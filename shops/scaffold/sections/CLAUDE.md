# sections/ snippets/ blocks/ — sources Liquid (__SHOP_NAME__)

Sources locales des fichiers thème poussés vers le thème MAIN.

## Règles

- **Le LIVE est l'autorité.** Avant d'éditer : `node scripts/pull-theme-file.js sections/x.liquid --diff`. Un fichier ici peut être **stale** (un fix a été appliqué en ligne) ou **en avance** (edit jamais poussé). Pousser un local stale **réintroduit** ce qui avait été nettoyé — piège déjà payé.
- Push : `node scripts/push-any.js sections/x.liquid --go` (DRY sans `--go`, read-back + purge inclus).
- Un seul dossier source. Si un jour un pipeline copie un dossier « rebuilt » vers `sections/` avant de pousser, **éditer la source du pipeline**, jamais `sections/` — sinon l'edit est écrasé au push suivant.
- Convention de nom : `<prefixe-marque>-<sujet>.liquid` (ex `__SHOP_SLUG__-hero.liquid`) pour ne jamais entrer en collision avec une section native du thème.
- Contrat de chaque section : cf. `docs/DESIGN-SYSTEM.md` § grammaire de section + checklist 10 points.
- Pièges Liquid (schema imbriqué, `{% stylesheet %}`, ranges, apostrophes, `default` manquant) : `docs/PITFALLS-HERITES.md` §4.
