// lib/shop.js — helper Shopify STORE-AGNOSTIC.
// L'identité est DÉRIVÉE du dossier (creds + registre ~/.claude/shops-registry.json),
// jamais tapée en dur. Un script copié d'une autre boutique s'auto-corrige ici.
//
//   const shop = require('./lib/shop');            // depuis scripts/xxx.js
//   await shop.assertShop();                       // preuve live (abort si mauvaise boutique)
//   const id = await shop.mainThemeId();
//   const d  = await shop.gql('{ shop { name } }');
//   shop.requireGo('poser compareAt sur 25 produits');   // gate: rien ne mute sans --go
//
// Toute mutation DOIT être précédée de assertShop() + requireGo().

const fs = require('fs');
const os = require('os');
const path = require('path');

const ROOT = path.resolve(__dirname, '..', '..');
const SECRETS = path.join(ROOT, '.secrets');
const API_VERSION = process.env.SHOPIFY_API_VERSION || '2025-01';

function norm(p) { return String(p).replace(/\\/g, '/').toLowerCase().replace(/\/+$/, ''); }
function inRoot(p, root) { const n = norm(p), r = norm(root); return !!r && (n === r || n.startsWith(r + '/')); }

function readCreds() {
  const f = path.join(SECRETS, 'app-credentials.txt');
  if (!fs.existsSync(f)) die(`.secrets/app-credentials.txt introuvable — copie app-credentials.txt.example et remplis-le.`);
  const out = {};
  for (const line of fs.readFileSync(f, 'utf8').split(/\r?\n/)) {
    const m = line.match(/^\s*([A-Z_]+)\s*=\s*(.*?)\s*$/);
    if (m && !line.trim().startsWith('#')) out[m[1]] = m[2];
  }
  if (!out.SHOP) die('SHOP= manquant dans .secrets/app-credentials.txt');
  return out;
}

function readRegistryRow() {
  const f = path.join(os.homedir(), '.claude', 'shops-registry.json');
  if (!fs.existsSync(f)) return null;
  let rows;
  try { rows = JSON.parse(fs.readFileSync(f, 'utf8')).shops || []; } catch { return null; }
  let best = null;
  for (const r of rows) if (r.folder_root && inRoot(ROOT, r.folder_root) && (!best || r.folder_root.length > best.folder_root.length)) best = r;
  return best;
}

function die(msg) { console.error('ABORT: ' + msg); process.exit(1); }

const creds = readCreds();
const row = readRegistryRow();

if (!row) die(`aucune ligne de registre ne couvre ${ROOT}. Active la boutique (README-INIT.md) avant toute API.`);
if (row.myshopify_domain && row.myshopify_domain !== creds.SHOP) {
  die(`MISMATCH IDENTITÉ — creds SHOP=${creds.SHOP} mais le registre dit ${row.myshopify_domain} pour ce dossier. Un token = un store.`);
}

const SHOP = creds.SHOP;
const HANDLE = SHOP.replace(/\.myshopify\.com$/, '');
const SHOP_NAME = row.shop_name;
const WRITE_POLICY = row.write_policy || 'read-write-gated';
const ENDPOINT = `https://${SHOP}/admin/api/${API_VERSION}/graphql.json`;

function token() {
  const f = path.join(SECRETS, 'access-token.txt');
  if (!fs.existsSync(f)) die('.secrets/access-token.txt absent — lance `bash scripts/get-token.sh`.');
  const t = fs.readFileSync(f, 'utf8').trim();
  if (!t) die('.secrets/access-token.txt vide — relance `bash scripts/get-token.sh`.');
  return t;
}

async function gql(query, variables = {}) {
  const r = await fetch(ENDPOINT, {
    method: 'POST',
    headers: { 'X-Shopify-Access-Token': token(), 'Content-Type': 'application/json' },
    body: JSON.stringify({ query, variables }),
  });
  const text = await r.text();               // lire en une fois (jamais de concat de chunks)
  let j;
  try { j = JSON.parse(text); } catch { die(`réponse non-JSON (${r.status}): ${text.slice(0, 300)}`); }
  if (j.errors) die('GraphQL errors: ' + JSON.stringify(j.errors));
  return j.data;
}

// Le registre (et son miroir .json lu par les hooks PowerShell) est ASCII pur :
// le sync global transcode, un accent y devient "?". Le nom LIVE Shopify, lui,
// est accentué. On compare donc sans accents ni casse — le domaine reste
// l'ancre d'identité stricte.
function fold(x) {
  return String(x).normalize('NFD').replace(/[̀-ͯ]/g, '')
    .replace(/[‘’]/g, "'").replace(/\s+/g, ' ').trim().toLowerCase();
}

let _asserted = null;
async function assertShop() {
  if (_asserted) return _asserted;
  const d = await gql('{ shop { name myshopifyDomain currencyCode ianaTimezone } }');
  const s = d.shop;
  if (s.myshopifyDomain !== SHOP) die(`le token atteint ${s.myshopifyDomain} au lieu de ${SHOP}. STOP.`);
  if (SHOP_NAME && fold(s.name) !== fold(SHOP_NAME)) die(`shop.name = "${s.name}" mais le registre dit "${SHOP_NAME}". Reconcilie avant d'agir.`);
  if (row.currency && s.currencyCode !== row.currency) console.warn(`WARN devise live ${s.currencyCode} != registre ${row.currency}`);
  _asserted = s;
  console.log(`Shop OK: ${s.name} | ${s.myshopifyDomain} | ${s.currencyCode} | ${s.ianaTimezone}`);
  return s;
}

// Gate mécanique de la double-confirmation : par défaut tout est DRY.
// Le script n'écrit que si `--go` est passé explicitement.
function requireGo(effect) {
  if (WRITE_POLICY === 'read-only') die(`${SHOP_NAME} est read-only dans le registre — aucune mutation permise ici.`);
  const go = process.argv.includes('--go');
  console.log(`\n>> MUTATION sur ${SHOP_NAME} (${SHOP}) : ${effect}`);
  if (!go) {
    console.log('>> DRY-RUN (aucune écriture). Re-lance avec --go après validation de the operator.\n');
    process.exit(0);
  }
  console.log('>> --go présent → exécution.\n');
}

async function mainThemeId() {
  const d = await gql('{ themes(first: 20, roles: [MAIN]) { nodes { id name role } } }');
  const t = d.themes.nodes[0];
  if (!t) die('aucun thème MAIN trouvé.');
  return t.id;
}

async function readThemeFiles(themeId, filenames) {
  const d = await gql(`query($id:ID!,$fn:[String!]){ theme(id:$id){ files(first:50, filenames:$fn){ nodes{ filename body{ ... on OnlineStoreThemeFileBodyText { content } } } } } }`, { id: themeId, fn: filenames });
  const out = {};
  for (const n of d.theme.files.nodes) out[n.filename] = n.body?.content ?? '';
  return out;
}

// Upsert + read-back obligatoire (themeFilesUpsert n'est PAS atomique).
async function upsertThemeFiles(themeId, files /* [{filename, content}] */) {
  const d = await gql(`mutation($id:ID!,$files:[OnlineStoreThemeFilesUpsertFileInput!]!){
    themeFilesUpsert(themeId:$id, files:$files){ upsertedThemeFiles{ filename } userErrors{ filename code message } } }`,
    { id: themeId, files: files.map(f => ({ filename: f.filename, body: { type: 'TEXT', value: f.content } })) });
  const errs = d.themeFilesUpsert.userErrors;
  if (errs.length) die('UPSERT ERRORS: ' + JSON.stringify(errs, null, 2));
  const up = d.themeFilesUpsert.upsertedThemeFiles.map(x => x.filename);
  for (const f of files) if (!up.includes(f.filename)) die('fichier manquant dans la réponse upsert: ' + f.filename);
  const back = await readThemeFiles(themeId, files.map(f => f.filename));
  const bad = files.filter(f => back[f.filename] !== f.content).map(f => f.filename);
  if (bad.length) die('READ-BACK DIFF (le live ne contient pas ce qu\'on a envoyé): ' + bad.join(', '));
  console.log('upsert + read-back OK: ' + up.join(', '));
  return up;
}

// Re-publier le thème MAIN bump la cache key server-side => purge le page_cache.
async function publishTheme(themeId) {
  const d = await gql('mutation($id:ID!){ themePublish(id:$id){ theme{ role } userErrors{ message } } }', { id: themeId });
  const e = d.themePublish.userErrors;
  if (e.length) die('themePublish: ' + JSON.stringify(e));
  console.log('themePublish OK (role=' + d.themePublish.theme.role + ') — le rendu public peut rester stale quelques minutes.');
}

module.exports = {
  ROOT, SECRETS, SHOP, HANDLE, SHOP_NAME, WRITE_POLICY, API_VERSION, ENDPOINT, registryRow: row,
  token, gql, assertShop, requireGo, mainThemeId, readThemeFiles, upsertThemeFiles, publishTheme, die,
};
