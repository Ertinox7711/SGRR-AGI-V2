// pull-theme-file.js — récupère la version LIVE d'un fichier thème (l'autorité).
//   node scripts/pull-theme-file.js sections/foo.liquid                  -> affiche + écrit data/_live-pull/
//   node scripts/pull-theme-file.js templates/product.json --to sections -> écrit aussi dans le dossier local
//   node scripts/pull-theme-file.js sections/foo.liquid --diff           -> compare live vs local
// Lecture seule : ne mute jamais le thème.
const fs = require('fs');
const path = require('path');
const shop = require('./lib/shop');

const targets = process.argv.slice(2).filter(a => !a.startsWith('--'));
const WRITE_LOCAL = process.argv.includes('--to');
const DIFF = process.argv.includes('--diff');
if (!targets.length) shop.die('passe un chemin thème, ex: templates/product.json');

(async () => {
  await shop.assertShop();
  const themeId = await shop.mainThemeId();
  const got = await shop.readThemeFiles(themeId, targets);

  const dir = path.join(shop.ROOT, 'data', '_live-pull');
  fs.mkdirSync(dir, { recursive: true });

  for (const t of targets) {
    const live = got[t];
    if (live === undefined) { console.log(`${t}: ABSENT du thème live`); continue; }
    const out = path.join(dir, t.replace(/[\\/]/g, '__'));
    fs.writeFileSync(out, live);
    console.log(`${t}: ${live.length} caractères → ${path.relative(shop.ROOT, out)}`);

    const localPath = path.join(shop.ROOT, t);
    if (DIFF) {
      if (!fs.existsSync(localPath)) { console.log('   local: ABSENT'); }
      else {
        const local = fs.readFileSync(localPath, 'utf8');
        console.log('   local vs live:', local === live ? 'IDENTIQUE' : `DIFFÉRENT (local ${local.length}c / live ${live.length}c) — le LIVE gagne`);
      }
    }
    if (WRITE_LOCAL) {
      fs.mkdirSync(path.dirname(localPath), { recursive: true });
      fs.writeFileSync(localPath, live);
      console.log('   écrit dans', t);
    }
  }
})();
