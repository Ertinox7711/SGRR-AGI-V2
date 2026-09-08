// pdf-titre.mjs — change le titre d'un PDF sans rien casser (update incrémental).
// Usage : node pdf-titre.mjs <fichier.pdf> "Nouveau titre"
// Ne RÉÉCRIT aucun octet existant : il ajoute à la fin du fichier un update incrémental
// (nouvel objet Info avec /Title + XMP dc:title + section xref + trailer /Prev).
// Backup auto : <nom>.backup-pdf-titre.pdf | Vérification auto après écriture.
import { readFile, writeFile, copyFile } from 'node:fs/promises';
import { deflateSync, inflateSync } from 'node:zlib';
import { execFileSync } from 'node:child_process';

const [file, newTitle] = process.argv.slice(2);
if (!file) { console.error('usage : node pdf-titre.mjs <fichier.pdf> "Nouveau titre"'); process.exit(2); }
const TITLE = newTitle ?? 'test';

const buf = await readFile(file);
const str = buf.toString('latin1');
const pad10 = (n) => String(n).padStart(10, '0');

// ---------- utilitaires ----------
function lastStartxref(s) {
  let last = 0, i = 0;
  while ((i = s.indexOf('startxref', i)) !== -1) {
    const m = s.slice(i + 9, i + 60).match(/\s*(\d+)/);
    if (m) last = parseInt(m[1]);
    i += 9;
  }
  return last;
}

// ---------- 1. parser une section xref (classique OU stream) à un offset ----------
function parseXrefAt(offset) {
  const head = str.slice(offset, offset + 14);
  if (head.startsWith('xref')) {
    const end = str.indexOf('trailer', offset);
    if (end < 0) throw new Error('trailer introuvable après ' + offset);
    const trailer = str.slice(end, str.indexOf('>>', end) + 2);
    const re = /(\d+)\s+(\d+)\s*\r?\n((?:\d{10}\s+\d{5}\s+[nf][ \t]*\r?\n)+)/g;
    const entries = {};
    let m;
    while ((m = re.exec(str.slice(offset, end)))) {
      const base = parseInt(m[1]);
      m[3].trim().split(/\r?\n/).forEach((l, i) => {
        const p = l.match(/^(\d{10})\s+(\d{5})\s+([nf])[ \t]*$/);
        if (!p) throw new Error('entrée xref illisible: ' + JSON.stringify(l));
        entries[base + i] = { type: p[3] === 'f' ? 0 : 1, off: parseInt(p[1]), gen: parseInt(p[2]) };
      });
    }
    return { entries, trailer };
  }
  // xref stream (/Type /XRef)
  const mObj = str.slice(offset, offset + 90).match(/^[\r\n ]*(\d+)\s+0\s+obj/);
  if (!mObj) throw new Error(`ni table classique ni xref stream à ${offset} : ${JSON.stringify(str.slice(offset, offset + 14))}`);
  const o = offset + mObj[0].length - (mObj[1].length + 8);
  const dictEnd = str.indexOf('>>', o);
  if (dictEnd < 0) throw new Error('dict du xref stream introuvable');
  const dict = str.slice(o, dictEnd + 2);
  if (!/\/Type\s*\/XRef/.test(dict)) throw new Error(`obj @${offset} n'est pas /Type/XRef`);
  const streamKw = str.indexOf('stream', dictEnd);
  let ds = streamKw + 6;
  if (str[ds] === '\r') ds++;
  if (str[ds] === '\n') ds++;
  let de = str.indexOf('endstream', ds);
  if (str[de - 1] === '\n') de--;
  if (str[de - 1] === '\r') de--;
  let data = Buffer.from(str.slice(ds, de), 'latin1');
  if (/\/Filter\s*\/FlateDecode/.test(dict)) data = inflateSync(data);
  const WM = dict.match(/\/W\s*\[\s*(\d+)\s+(\d+)\s+(\d+)\s*\]/);
  const W = WM ? [+WM[1], +WM[2], +WM[3]] : [1, 4, 2];
  const sizeM2 = dict.match(/\/Size\s+(\d+)/);
  const idxM = dict.match(/\/Index\s*\[([\d\s]+)\]/);
  const pairs = idxM ? idxM[1].trim().split(/\s+/).map(Number) : [0, sizeM2 ? +sizeM2[1] : 0];
  const rowSize = W[0] + W[1] + W[2];
  const entries = {};
  let oi = 0;
  for (let pi = 0; pi + 1 < pairs.length; pi += 2) {
    const start = pairs[pi], count = pairs[pi + 1];
    for (let k = 0; k < count; k++) {
      const row = data.slice(oi, oi + rowSize);
      oi += rowSize;
      const t = W[0] ? row[0] : 1;
      const f2 = W[1] ? row.slice(W[0], W[0] + W[1]).readUIntBE(0, W[1]) : 0;
      const f3 = W[2] ? row.slice(W[0] + W[1], rowSize).readUIntBE(0, W[2]) : 0;
      const num = start + k;
      if (t === 1) entries[num] = { type: 1, off: f2, gen: f3 };
      else if (t === 2) entries[num] = { type: 2, objstm: f2, gen: f3 };
      else entries[num] = { type: 0, off: 0, gen: 65535 };
    }
  }
  return { entries, trailer: dict };
}

// ---------- 2. remonter la chaîne /Prev jusqu'à une table exploitable ----------
const prevStart = lastStartxref(str);
const entries = {};
let xrefAt = prevStart, trailers = [];
for (let hops = 0; hops < 4; hops++) {
  const { entries: e, trailer: tr } = parseXrefAt(xrefAt);
  Object.assign(entries, e);
  trailers.push(tr);
  if (Object.keys(e).length > 0 || !/\/Prev\s+\d+/.test(tr)) break;
  const pm = tr.match(/\/Prev\s+(\d+)/);
  console.log(`↳ section vide @${xrefAt}, remontée /Prev -> ${pm[1]}`);
  xrefAt = parseInt(pm[1]);
}
if (Object.keys(entries).length === 0) throw new Error('aucune entrée xref exploitable');

// ---------- 3. clés du trailer (le plus profond contenant /Root) ----------
let trailer = null;
for (let i = trailers.length - 1; i >= 0; i--) {
  const t = trailers[i];
  if (/\/Root\s+\d+\s+0\s+R/.test(t)) { trailer = t; break; }
}
trailer = trailer ?? trailers[0];
const infoNum = (trailer.match(/\/Info\s+(\d+)\s+0\s+R/) || [])[1] || null;
const rootNum = (trailer.match(/\/Root\s+(\d+)\s+0\s+R/) || [])[1] || null;
const idM = trailer.match(/\/ID\s*\[([^\]]+)\]/);
const sizeM = trailer.match(/\/Size\s+(\d+)/);
if (!rootNum) throw new Error('/Root introuvable');

// ---------- 4. récupérer un objet (direct, ou via un obj-stream) ----------
function getObjSpan(num) {
  const e = entries[num];
  if (!e) throw new Error(`entrée xref manquante pour obj ${num}`);
  if (e.type === 1) {
    const head = str.slice(e.off, e.off + 60);
    const strip = (head.match(/^[\r\n ]*/) ?? [''])[0].length;
    const o = e.off + strip;
    if (!str.startsWith(`${num} 0 obj`, o)) throw new Error(`obj ${num} introuvable @${e.off}`);
    const end = str.indexOf('endobj', o);
    return { o, txt: str.slice(o, end + 6), inObjStm: false };
  }
  if (e.type === 2) {
    if (process.env.PDFTITRE_DEBUG) console.log('DBG obj', num, '-> objstm', e.objstm, JSON.stringify(entries[e.objstm]));
    const stm = entries[e.objstm];
    if (!stm || stm.type !== 1) throw new Error(`obj-stream ${e.objstm} irrécupérable`);
    const sRaw = getObjSpan(e.objstm); // attention : type 2 imbriqué improbable
    const n = (sRaw.txt.match(/\/N\s+(\d+)/) || [])[1];
    const first = (sRaw.txt.match(/\/First\s+(\d+)/) || [])[1];
    if (!n || !first) throw new Error('ObjStm sans /N ou /First');
    const kw = sRaw.txt.indexOf('stream');
    let ds = kw + 6;
    if (sRaw.txt[ds] === '\r') ds++;
    if (sRaw.txt[ds] === '\n') ds++;
    let de = sRaw.txt.indexOf('endstream', ds);
    if (sRaw.txt[de - 1] === '\n') de--;
    if (sRaw.txt[de - 1] === '\r') de--;
    let data = new Uint8Array(de - ds);
    for (let i = 0; i < data.length; i++) data[i] = sRaw.txt.charCodeAt(ds + i) & 0xff;
    const flate = /\/Filter\s*\/FlateDecode/.test(sRaw.txt.slice(sRaw.txt.indexOf('<<'), sRaw.txt.indexOf('>>')));
    if (flate) data = inflateSync(data);
    const F = parseInt(first);
    const header = data.slice(0, F).toString('latin1');
    if (process.env.PDFTITRE_DEBUG) console.log('DBG ObjStm header:', JSON.stringify(header), '| cherché:', num);
    const pairs = [...header.matchAll(/(\d+)\s+(\d+)/g)].map(m => [+m[1], +m[2]]);
    const idx = pairs.findIndex(([pn]) => pn === Number(num));
    if (idx < 0) throw new Error(`obj ${num} absent de l'obj-stream`);
    const off = F + pairs[idx][1];
    const next = idx + 1 < pairs.length ? F + pairs[idx + 1][1] : data.length;
    return { o: null, txt: Buffer.from(data.slice(off, next)).toString('latin1'), inObjStm: true };
  }
  throw new Error(`obj ${num} libre/détruit`);
}

let metaNum = null;
try {
  const cat = getObjSpan(rootNum);
  const mm = cat.txt.match(/\/Metadata\s+(\d+)\s+0\s+R/);
  if (mm) metaNum = mm[1];
} catch (err) { console.warn('⚠ catalogue inaccessible, on saute le XMP :', err.message); }

// ---------- 5. titre littéral ----------
function pdfLiteral(t) {
  if ([...t].every(c => { const cc = c.charCodeAt(0); return cc >= 32 && cc <= 126; })) {
    return '(' + t.replace(/\\/g, '\\\\').replace(/\(/g, '\\(').replace(/\)/g, '\\)') + ')';
  }
  let lit = '\u00FE\u00FF';
  for (const ch of t) { const c = ch.charCodeAt(0); lit += String.fromCharCode((c >> 8) & 0xff, c & 0xff); }
  return '(' + lit + ')';
}

// ---------- 6. Info : /Title ----------
let infoTxt = null;
if (infoNum) {
  try {
    const info = getObjSpan(infoNum);
    const re = /\/Title\s*(\((?:\\.|[^\\()])*\)|<[0-9A-Fa-f\s]+>)/;
    const all = info.txt.match(new RegExp(re.source, 'g'));
    if (all && all.length === 1) infoTxt = info.txt.replace(re, () => `/Title${pdfLiteral(TITLE)}`);
    else console.warn(`⚠ /Title absent ou multiple dans obj ${infoNum} (${all ? all.length : 0}) — Info sautée`);
  } catch (err) { console.warn('⚠ Info inaccessible:', err.message); }
}

// ---------- 7. XMP : dc:title ----------
let metaTxt = null;
if (metaNum) {
  try {
    const meta = getObjSpan(metaNum);
    if (meta.inObjStm) throw new Error('métadonnées dans un obj-stream — non géré');
    const dict = meta.txt.slice(meta.txt.indexOf('<<') + 2, meta.txt.indexOf('>>'));
    const flate = /\/Filter\s*\/FlateDecode/.test(dict);
    const kw = meta.txt.indexOf('stream');
    let ds = kw + 6;
    if (meta.txt[ds] === '\r') ds++;
    if (meta.txt[ds] === '\n') ds++;
    let de = meta.txt.indexOf('endstream', ds);
    if (meta.txt[de - 1] === '\n') de--;
    if (meta.txt[de - 1] === '\r') de--;
    let xmpBytes = new Uint8Array(de - ds);
    for (let i = 0; i < xmpBytes.length; i++) xmpBytes[i] = meta.txt.charCodeAt(ds + i) & 0xff;
    let xmp = (flate ? inflateSync(xmpBytes) : Buffer.from(xmpBytes)).toString('utf8');
    const esc = TITLE.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    const re = /(<dc:title><rdf:Alt><rdf:li xml:lang="x-default">)[\s\S]*?(<\/rdf:li><\/rdf:Alt><\/dc:title>)/;
    if (re.test(xmp)) {
      xmp = xmp.replace(re, `$1${esc}$2`);
      const outBytes = flate ? deflateSync(Buffer.from(xmp, 'utf8')) : Buffer.from(xmp, 'utf8');
      const newDict = meta.txt.slice(meta.txt.indexOf('<<'), meta.txt.indexOf('>>') + 2).replace(/\/Length\s+\d+/, `/Length ${outBytes.length}`);
      metaTxt = `${metaNum} 0 obj${newDict}stream\r\n${outBytes.toString('latin1')}\r\nendstream\r\nendobj`;
    } else {
      console.warn('⚠ XMP sans dc:title exploitable — XMP sauté');
    }
  } catch (err) { console.warn('⚠ XMP non modifiable :', err.message); }
}

if (!infoTxt && !metaTxt) throw new Error('rien à modifier (ni /Title ni dc:title accessibles)');

// ---------- 8. composition de l'update incrémental ----------
const sep = Buffer.from('\r\n', 'latin1');
const parts = [];
let pos = buf.length + sep.length;
const place = (b) => { const o = pos; parts.push(Buffer.from(b, 'latin1')); pos += b.length; return o; };
const offInfo = infoTxt ? place(infoTxt) : null;
const offMeta = metaTxt ? place(metaTxt) : null;

let xref = 'xref\r\n0 1\r\n0000000000 65535 f\r\n';
if (infoNum && offInfo) xref += `${infoNum} 1\r\n${pad10(offInfo)} 00000 n\r\n`;
if (metaNum && offMeta) xref += `${metaNum} 1\r\n${pad10(offMeta)} 00000 n\r\n`;
xref += `trailer\r\n<</Size ${sizeM ? sizeM[1] : '9999'}/Root ${rootNum} 0 R${infoNum && offInfo ? `/Info ${infoNum} 0 R` : ''}${idM ? `/ID[${idM[1]}]` : ''}/Prev ${prevStart}>>\r\n`;
const xrefStart = pos;
const tail = Buffer.from(`${xref}startxref\r\n${xrefStart}\r\n%%EOF\r\n`, 'latin1');

// ---------- 9. backup + écriture ----------
const bak = file.replace(/\.pdf$/i, '') + '.backup-pdf-titre.pdf';
await copyFile(file, bak);
const out = Buffer.concat([buf, sep, ...parts, tail]);
await writeFile(file, out);
console.log(`OK : titre -> ${JSON.stringify(TITLE)} (${buf.length} -> ${out.length} octets, +${out.length - buf.length})`);
console.log(`   backup : ${bak} | Prev=${prevStart} | Info=${infoNum ? '#' + infoNum : '-'} XMP=${metaNum ? '#' + metaNum : '-'}`);

// ---------- 10. vérification (re-parcours complet comme un lecteur) ----------
const vstr = (await readFile(file)).toString('latin1');
const vStart = lastStartxref(vstr);
const vEnd = vstr.indexOf('trailer', vStart);
const vEntries = {};
const vre = /(\d+)\s+(\d+)\s*\r?\n((?:\d{10}\s+\d{5}\s+[nf][ \t]*\r?\n)+)/g;
let vm;
while ((vm = vre.exec(vstr.slice(vStart, vEnd)))) {
  const base = parseInt(vm[1]);
  vm[3].trim().split(/\r?\n/).forEach((l, i) => {
    const p = l.match(/^(\d{10})\s+(\d{5})\s+([nf])[ \t]*$/);
    vEntries[base + i] = parseInt(p[1]);
  });
}
let ok = true;
if (infoTxt && vEntries[infoNum] !== undefined) {
  const vInfo = vstr.slice(vEntries[infoNum], vstr.indexOf('endobj', vEntries[infoNum]));
  const mt = vInfo.match(/\/Title\((\u00FE\u00FF(?:[^\\()]|\\.)*?)\)/) || vInfo.match(/\/Title\(((?:[^\\()]|\\.)*?)\)/);
  let shown = mt ? mt[1] : '??';
  if (shown.startsWith('\u00FE\u00FF')) shown = Buffer.from(shown.slice(2), 'latin1').swap16().toString('utf16le');
  else shown = shown.replace(/\\([()\\])/g, '$1');
  if (shown !== TITLE) { ok = false; console.error(`✗ /Title résolu = ${JSON.stringify(shown)} (attendu ${JSON.stringify(TITLE)})`); }
  else console.log('✓ /Title résolu via xref :', JSON.stringify(shown));
}
if (metaTxt && vEntries[metaNum] !== undefined) {
  const vMeta = vstr.slice(vEntries[metaNum], vstr.indexOf('endobj', vEntries[metaNum]));
  const esc = TITLE.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  if (vMeta.includes(`>${esc}</rdf:li>`)) console.log('✓ XMP dc:title vérifié');
  else { ok = false; console.error('✗ XMP dc:title non conforme'); }
}
try {
  const txt = execFileSync('pdftotext', ['-q', file, '-'], { encoding: 'latin1' });
  console.log(`✓ pdftotext relit le document (${txt.split('\f').length - 1} pages)`);
} catch { console.warn('⚠ pdftotext indisponible — ouvrir le PDF pour confirmer'); }
if (!ok) process.exit(1);