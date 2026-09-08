// push-any.js — pousse des fichiers thème locaux (sections/ snippets/ blocks/ templates/ layout/)
// vers le thème MAIN, avec garde d'identité, read-back et purge.
//   node scripts/push-any.js sections/x.liquid snippets/y.liquid          -> DRY (montre ce qui partirait)
//   node scripts/push-any.js sections/x.liquid --go                       -> pousse + read-back + publish
//   node scripts/push-any.js sections/x.liquid --go --no-publish          -> pousse sans purger le cache
//
// ⚠ Avant d'éditer un fichier : `node scripts/pull-theme-file.js <chemin>`.
//   Le LIVE est l'autorité — un fichier local peut être stale (fix appliqué en ligne)
//   ou en avance (edit jamais poussé). Pousser un local stale = régression silencieuse.
const fs = require('fs');
const path = require('path');
const shop = require('./lib/shop');

const targets = process.argv.slice(2).filter(a => !a.startsWith('--'));
if (!targets.length) shop.die('passe au moins un chemin, ex: sections/foo.liquid');

(async () => {
  await shop.assertShop();

  const files = targets.map(t => {
    const p = path.join(shop.ROOT, t);
    if (!fs.existsSync(p)) shop.die('introuvable: ' + t);
    return { filename: t.replace(/\\/g, '/'), content: fs.readFileSync(p, 'utf8') };
  });
  files.forEach(f => console.log('  ', f.filename, f.content.length, 'caractères'));

  shop.requireGo(`themeFilesUpsert de ${files.length} fichier(s) sur le thème MAIN`);

  const themeId = await shop.mainThemeId();
  await shop.upsertThemeFiles(themeId, files);
  if (!process.argv.includes('--no-publish')) await shop.publishTheme(themeId);
})();
