// theme-purge-cache.js — purge le full-page cache (page_cache) du storefront.
// Re-publier le thème DÉJÀ MAIN bump la cache key server-side => flush l'anonyme, zéro action owner.
//   node scripts/theme-purge-cache.js --go [--probe=/collections/all]
//
// ⚠ Limites connues (payées ailleurs) :
//   - un `?param=random` ne buste PAS le page_cache ;
//   - les pages produit/blog ne sont pas dans ce cache (fraîches tout de suite),
//     les pages home/collection/page le sont (stale quelques minutes) ;
//   - un metafield produit invalide la PDP, un push thème non ;
//   - AUTORITÉ = l'Admin API en lecture. Un rendu stale n'est pas un bug à re-patcher.
const shop = require('./lib/shop');

const PROBE = (process.argv.find(a => a.startsWith('--probe=')) || '--probe=/').slice(8);

(async () => {
  await shop.assertShop();
  shop.requireGo(`themePublish (purge cache) + sonde HEAD ${PROBE}`);

  const etag = async () => {
    try { const r = await fetch(`https://${shop.SHOP}${PROBE}`, { method: 'HEAD' }); return r.headers.get('etag') || `(status ${r.status})`; }
    catch (e) { return '(injoignable: ' + e.message + ')'; }
  };

  const before = await etag();
  console.log('etag before :', before);
  await shop.publishTheme(await shop.mainThemeId());
  await new Promise(r => setTimeout(r, 4000));
  const after = await etag();
  console.log('etag after  :', after);
  console.log(before === after ? 'NO CHANGE (cache collé, page protégée par mot de passe, ou sonde non cachée)' : 'PURGÉ');
})();
