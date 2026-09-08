// shop-probe.js — PREUVE LIVE d'identité + snapshot d'état. Lecture seule.
//   node scripts/shop-probe.js            (identité + thème MAIN + compteurs)
//   node scripts/shop-probe.js --dump     (écrit data/_audit-snapshot.json)
// À lancer au §2 de SESSION-INIT.md, et avant toute affirmation sur l'état du store.
const fs = require('fs');
const path = require('path');
const shop = require('./lib/shop');

(async () => {
  await shop.assertShop();

  const d = await shop.gql(`{
    shop { name myshopifyDomain primaryDomain { url } currencyCode ianaTimezone email }
    themes(first: 20) { nodes { id name role } }
    products(first: 1) { nodes { id } }
    productsCount { count }
    collections(first: 50) { nodes { handle title productsCount { count } } }
    pages(first: 50) { nodes { handle title } }
    blogs(first: 20) { nodes { handle title articlesCount { count } } }
  }`);

  const main = d.themes.nodes.find(t => t.role === 'MAIN');
  console.log('\n--- ÉTAT ---');
  console.log('domaine public :', d.shop.primaryDomain?.url || '(aucun)');
  console.log('email shop     :', d.shop.email);
  console.log('thème MAIN     :', main ? `${main.name} (${main.id})` : 'AUCUN');
  console.log('thèmes         :', d.themes.nodes.map(t => `${t.name}[${t.role}]`).join(', '));
  console.log('produits       :', d.productsCount.count);
  console.log('collections    :', d.collections.nodes.map(c => `${c.handle}(${c.productsCount.count})`).join(', ') || '(aucune)');
  console.log('pages          :', d.pages.nodes.map(p => p.handle).join(', ') || '(aucune)');
  console.log('blogs          :', d.blogs.nodes.map(b => `${b.handle}(${b.articlesCount.count})`).join(', ') || '(aucun)');

  if (process.argv.includes('--dump')) {
    const out = path.join(shop.ROOT, 'data', '_audit-snapshot.json');
    fs.mkdirSync(path.dirname(out), { recursive: true });
    fs.writeFileSync(out, JSON.stringify({ at: new Date().toISOString(), shop: shop.SHOP, data: d }, null, 2));
    console.log('\nsnapshot →', out);
  }
})();
