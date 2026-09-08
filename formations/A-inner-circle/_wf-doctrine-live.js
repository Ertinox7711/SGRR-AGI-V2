export const meta = {
  name: 'doctrine-live-extract',
  description: 'Lecture exhaustive dun live Arthur : doctrines verbatim horodatees, produits nommes, gates chiffres, cadre Q4',
  whenToUse: 'Apres transcription dun live Ecom Inner Circle, pour en tirer les regles citables. args = {live, dir, chunks:[{name,from,to}]}',
  phases: [
    { title: 'Lecture', detail: 'un lecteur par segment de 10 min' },
    { title: 'Synthese', detail: 'fusion en document horodate' },
    { title: 'Critique', detail: 'fidelite + completude' },
  ],
}

// args arrive parfois deja parse, parfois en chaine JSON selon lappelant
let A = args || {}
if (typeof A === 'string') {
  try { A = JSON.parse(A) } catch (e) { return { error: 'args illisible: ' + e.message } }
}
const LIVE = A.live || 'live inconnu'
const DIR = A.dir
const CHUNKS = A.chunks || []
const DATE = A.date || ''
if (!DIR || !CHUNKS.length) return { error: 'args attendus: {live, dir, chunks:[{name,from,to}]}' }

const READER_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['segment', 'doctrines', 'produits_cites', 'gates_chiffres', 'cadre_q4', 'questions_membres', 'resume'],
  properties: {
    segment: { type: 'string' },
    resume: { type: 'string', description: 'ce qui se passe dans ce segment, 3 phrases max' },
    doctrines: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['ts', 'theme', 'regle', 'verbatim'],
        properties: {
          ts: { type: 'string' },
          theme: { type: 'string', description: 'q4-calendrier | selection-produit | kill-criteria | google-ads | marche-pays | operations | mindset' },
          regle: { type: 'string', description: 'la regle reformulee en une phrase imperative actionnable' },
          verbatim: { type: 'string', description: 'citation EXACTE, ponctuation nettoyee, aucun mot ajoute ni retire' },
          chiffres: { type: 'string' },
        },
      },
    },
    produits_cites: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['nom', 'ts', 'verdict_arthur', 'verbatim'],
        properties: {
          nom: { type: 'string' },
          ts: { type: 'string' },
          verdict_arthur: { type: 'string', description: 'marche / a eviter / exemple neutre / cite par un membre' },
          prix_ou_metrique: { type: 'string' },
          verbatim: { type: 'string' },
        },
      },
    },
    gates_chiffres: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['ts', 'gate', 'verbatim'],
        properties: { ts: { type: 'string' }, gate: { type: 'string' }, verbatim: { type: 'string' } },
      },
    },
    cadre_q4: {
      type: 'array',
      description: 'tout passage sur Q4, Noel, Black Friday, cadeau, saisonnalite, calendrier de lancement, evergreen',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['ts', 'verbatim', 'ce_que_ca_dit'],
        properties: { ts: { type: 'string' }, verbatim: { type: 'string' }, ce_que_ca_dit: { type: 'string' } },
      },
    },
    questions_membres: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['ts', 'question', 'reponse'],
        properties: { ts: { type: 'string' }, question: { type: 'string' }, reponse: { type: 'string' } },
      },
    },
  },
}

const FIDELITE = [
  'Regles de fidelite, non negociables :',
  '- Le transcript vient de Whisper : ponctuation absente ou fausse, phrases coupees en segments de ~5 s.',
  '  Tu RECONSTRUIS le passage en recollant les segments consecutifs, mais tu ne CHANGES aucun mot.',
  '- verbatim = les mots exacts. Ajouter ponctuation et majuscules : oui. Ajouter, retirer ou remplacer un mot : jamais.',
  '- Whisper massacre les noms propres et les termes techniques. Si un mot est manifestement mal transcrit',
  '  (ex "Shane" pour Shein, "brande" pour brand), garde le verbatim tel quel MAIS signale la correction probable',
  '  entre crochets dans le champ regle. Jamais de correction silencieuse.',
  '- Un chiffre entendu se recopie tel quel : pas d arrondi, pas de conversion, pas d unite inventee.',
  '- Doute sur la valeur de regle d un passage : inclus-le. Un faux positif se filtre en aval, une doctrine manquee est perdue.',
].join('\n')

function readerPrompt(c, i, n) {
  return [
    'Tu lis un segment du transcript dun live de coaching e-commerce en francais (Arthur, formation Ecom Inner Circle).',
    'Live : ' + LIVE + (DATE ? ' (' + DATE + ')' : '') + '.',
    '',
    'FICHIER A LIRE EN ENTIER (outil Read, lis TOUT le fichier, ~19 Ko) :',
    DIR + '\\' + c.name,
    'Il couvre ' + c.from + ' -> ' + c.to + ' (segment ' + (i + 1) + '/' + n + ').',
    '',
    'Mission : extraire de facon EXHAUSTIVE tout ce qui a valeur de regle ou de donnee, avec horodatage.',
    '',
    FIDELITE,
    '',
    'Ce qui compte particulierement :',
    '1. Q4 / Noel / cadeau / calendrier de lancement / saisonnalite / evergreen -> cadre_q4, sois exhaustif.',
    '2. Les produits nommes, avec prix et verdict -> produits_cites.',
    '3. Les seuils chiffres (marge, volume de recherche, CPC, CPA, prix, ROAS, budget de test, nombre de concurrents,',
    '   nombre dinstitutionnels) -> gates_chiffres.',
    '4. Les questions des membres et les reponses dArthur -> questions_membres.',
    '',
    'Tu ne juges pas, tu ne resumes pas a la place dArthur, tu ne completes pas avec ta propre connaissance du e-commerce.',
    'Segment de bavardage sans regle : tableaux vides et dis-le dans resume.',
    'segment = "' + c.from + ' -> ' + c.to + '".',
  ].join('\n')
}

phase('Lecture')
const reads = await parallel(CHUNKS.map((c, i) => () =>
  agent(readerPrompt(c, i, CHUNKS.length), {
    label: 'lit ' + c.from.slice(0, 5) + '-' + c.to.slice(0, 5),
    phase: 'Lecture',
    schema: READER_SCHEMA,
  })
))

const ok = reads.filter(Boolean)
const cnt = {
  doctrines: ok.reduce((a, r) => a + (r.doctrines || []).length, 0),
  produits: ok.reduce((a, r) => a + (r.produits_cites || []).length, 0),
  q4: ok.reduce((a, r) => a + (r.cadre_q4 || []).length, 0),
  gates: ok.reduce((a, r) => a + (r.gates_chiffres || []).length, 0),
  questions: ok.reduce((a, r) => a + (r.questions_membres || []).length, 0),
}
log(ok.length + '/' + CHUNKS.length + ' segments lus - ' + cnt.doctrines + ' doctrines, ' + cnt.produits +
  ' produits, ' + cnt.q4 + ' passages Q4, ' + cnt.gates + ' gates, ' + cnt.questions + ' questions membres')
if (!ok.length) return { error: 'aucun lecteur na abouti' }
if (ok.length < CHUNKS.length) log('ATTENTION couverture partielle : ' + (CHUNKS.length - ok.length) + ' segment(s) perdu(s)')

const payload = JSON.stringify(ok, null, 1)

const CONTEXTE = [
  'Contexte indispensable :',
  '- Mathieu est coache par Arthur. Le 27/07/2026, en appel prive, Arthur lui a dit : marche UK, produit EVERGREEN,',
  '  "plus de chasse Q4", mid-ticket 300-1500 EUR en visant ~500 EUR, produit qui se bundle, sans enfer logistique,',
  '  et que le testing Search/Shopping va mourir au profit de PMax.',
  '- La doctrine deja ecrite (C:\\Users\\maths\\Documents\\BUSINESS\\shopify\\docs\\arthur-doctrine.md, l. 1044-1048) dit :',
  '  preparer le shop en juillet-aout, lancer les ads mi-septembre, accepter 10-15 % de marge en apprentissage pour',
  '  accumuler la data Google, ROAS qui peut doubler (6-7) en Q4 sur un produit cadeau.',
  '- Gates durs deja connus : marge < 50 % = DROP (GO >= 65 %), institutionnels dans les ads = DROP,',
  '  recherche de marque cachee = DROP, volume < 20-30k/mois sauf prix > 500 EUR, introuvable sur AliExpress = DROP,',
  '  CPA pire cas = CPC x 150 compare a la MARGE en euros (jamais au prix de vente), cycle dachat > 1 semaine = DROP.',
].join('\n')

phase('Synthese')
const SYNTH_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['markdown', 'verdict_q4_vs_evergreen', 'criteres_operationnels', 'produits_shortlist', 'contradictions', 'nouveaux_gates'],
  properties: {
    markdown: { type: 'string', description: 'le document complet, pret a ecrire sur disque' },
    verdict_q4_vs_evergreen: { type: 'string' },
    criteres_operationnels: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['critere', 'seuil', 'source_ts'],
        properties: { critere: { type: 'string' }, seuil: { type: 'string' }, source_ts: { type: 'string' } },
      },
    },
    produits_shortlist: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['nom', 'verdict', 'source_ts'],
        properties: { nom: { type: 'string' }, verdict: { type: 'string' }, prix: { type: 'string' }, source_ts: { type: 'string' } },
      },
    },
    nouveaux_gates: { type: 'string', description: 'gates chiffres par Arthur dans ce live et ABSENTS de la liste des gates deja connus' },
    contradictions: { type: 'string', description: 'ce qui contredit la doctrine deja ecrite, ou "aucune"' },
  },
}

const synth = await agent([
  'Tu fusionnes ' + ok.length + ' extractions du meme live en un seul document de doctrine.',
  'Live : ' + LIVE + (DATE ? ' (' + DATE + ')' : '') + '.',
  '',
  CONTEXTE,
  '',
  'LA QUESTION A TRANCHER, avec citations horodatees comme preuve :',
  '  "Q4" chez Arthur veut-il dire (A) chasser un produit saisonnier de Noel, (B) chasser un evergreen qui se vend',
  '  comme cadeau et quon prepare lete pour encaisser en Q4, ou (C) autre chose ?',
  '  Si les extractions ne permettent pas de trancher, dis-le franchement au lieu de choisir.',
  '',
  'Produis :',
  '1. markdown = document complet. Structure : titre, ligne de source (live, date, duree, nb de segments),',
  '   section "Le cadre Q4" (verdict + citations), "Grille de selection" (tableau critere/seuil/source),',
  '   "Gates chiffres" (tableau), "Produits cites par Arthur" (tableau nom/verdict/prix/source),',
  '   "FAQ des membres" (question -> reponse, horodatee), "Ce qui precise ou contredit la doctrine deja ecrite".',
  '   Chaque affirmation porte son horodatage entre crochets, ex [00:22:32]. Citations en italique.',
  '   Info manquante : ecris "non aborde dans ce live". Aucun mot invente.',
  '2. les champs structures.',
  '',
  'Regles : aucune donnee absente des extractions. Aucune extrapolation e-commerce personnelle.',
  'Erreurs probables de Whisper signalees entre crochets, jamais corrigees en silence.',
  'Francais correct et lisible, sans tiret cadratin ni demi-cadratin.',
  '',
  'EXTRACTIONS (JSON) :',
  payload,
].join('\n'), { label: 'synthese ' + (DATE || LIVE).slice(0, 10), phase: 'Synthese', schema: SYNTH_SCHEMA })

if (!synth) return { error: 'synthese echouee', lus: ok.length, compte: cnt }

phase('Critique')
const CRIT_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['verdict', 'trous', 'corrections'],
  properties: {
    verdict: { type: 'string', enum: ['complet', 'trous-mineurs', 'trous-majeurs'] },
    trous: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['quoi', 'ou_chercher'],
        properties: { quoi: { type: 'string' }, ou_chercher: { type: 'string' } },
      },
    },
    corrections: { type: 'string', description: 'affirmations du document non soutenues par les extractions' },
  },
}

const crit = await agent([
  'Tu es le critique de completude. Tu ne reecris pas le document, tu dis ce qui manque et ce qui est faux.',
  '',
  'Le document produit :',
  synth.markdown,
  '',
  'Les extractions brutes dont il est cense sortir (JSON) :',
  payload,
  '',
  'Tu verifies, dans cet ordre :',
  '1. FIDELITE : chaque affirmation est-elle soutenue par une extraction ? Toute phrase qui ajoute du savoir',
  '   e-commerce generique absent des extractions est une invention -> liste-la dans corrections.',
  '2. COMPLETUDE : quelque chose des extractions a-t-il ete perdu ? En particulier un produit nomme, un chiffre,',
  '   un passage Q4, une question de membre.',
  '3. TROUS REELS : quelle information un chasseur de produit aurait besoin et que ce live ne donne pas ?',
  '   Pour chacun, dis quel segment horaire relire, ou si linfo est simplement absente.',
  '',
  'Sois severe et concret. "Ca a lair bien" nest pas une reponse.',
].join('\n'), { label: 'critique ' + (DATE || LIVE).slice(0, 10), phase: 'Critique', schema: CRIT_SCHEMA })

// Une synthese en un coup perd de la matiere (constate sur le live du 22/07 : 12 produits nommes regroupes
// en une ligne "catalogue X"). Phase de reparation systematique : on recolle ce que le critique signale.
phase('Reparation')

const REPAIR_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['markdown', 'produits_complets', 'ajouts'],
  properties: {
    markdown: { type: 'string', description: 'le document complet corrige, pret a ecrire sur disque' },
    produits_complets: {
      type: 'array',
      description: 'TOUS les produits nommes dans le live, un par entree, aucun regroupement',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['nom', 'verdict', 'source_ts'],
        properties: {
          nom: { type: 'string' },
          verdict: { type: 'string' },
          prix: { type: 'string' },
          canal: { type: 'string', description: 'Search / Shopping / non precise' },
          source_ts: { type: 'string' },
        },
      },
    },
    ajouts: { type: 'string' },
  },
}

const repaired = crit ? await agent([
  'Tu repares un document de doctrine incomplet. Un critique a liste ce qui manque. Tu produis la version complete.',
  '',
  'REGLE ABSOLUE : tu n enleves RIEN du document existant. Tu ne reformules pas ce qui est deja juste.',
  'Tu ajoutes ce qui manque, aux bons endroits, et tu corriges seulement ce que le critique signale comme faux.',
  '',
  'Exigence de completude sur les produits : ces lives citent des dizaines de produits un par un, avec un verdict',
  'dArthur pour chacun. CHAQUE produit nomme doit apparaitre dans le tableau, avec horodatage et verdict.',
  'Regrouper plusieurs produits en une ligne "catalogue X" est exactement lerreur a corriger : un chasseur perd',
  'ses leads. Un produit sans verdict explicite se note "pas davis" plutot que detre supprime.',
  '',
  'Fidelite : aucune donnee absente des extractions, aucune extrapolation e-commerce personnelle.',
  'Erreurs probables de Whisper signalees entre crochets, jamais corrigees en silence.',
  'Chaque affirmation garde son horodatage. Francais correct, sans tiret cadratin ni demi-cadratin.',
  '',
  '=== DOCUMENT INITIAL ===',
  synth.markdown,
  '',
  '=== CE QUE LE CRITIQUE DIT QUI MANQUE OU EST FAUX ===',
  JSON.stringify(crit, null, 1),
  '',
  '=== EXTRACTIONS BRUTES, SOURCE DE VERITE (JSON) ===',
  payload,
].join('\n'), { label: 'reparation ' + (DATE || LIVE).slice(0, 10), phase: 'Reparation', schema: REPAIR_SCHEMA }) : null

const finalMd = (repaired && repaired.markdown) ? repaired.markdown : synth.markdown

phase('Recontrole')
const crit2 = repaired ? await agent([
  'Second controle de completude, apres reparation. Meme severite.',
  '',
  'Tu verifies UNIQUEMENT :',
  '1. Chaque produit nomme dans les extractions apparait-il nominativement dans le document ? Liste les manquants.',
  '2. Chaque chiffre des extractions (gates_chiffres) apparait-il ? Liste les manquants.',
  '3. Chaque question de membre apparait-elle ? Liste les manquantes.',
  '4. Le document affirme-t-il quelque chose qui nest dans aucune extraction ? Liste-le dans corrections.',
  '',
  'Si tout est couvert, verdict = complet. Ne cherche pas des trous imaginaires, mais ne laisse rien passer.',
  '',
  '=== DOCUMENT REPARE ===',
  finalMd,
  '',
  '=== EXTRACTIONS BRUTES (JSON) ===',
  payload,
].join('\n'), { label: 'recontrole ' + (DATE || LIVE).slice(0, 10), phase: 'Recontrole', schema: CRIT_SCHEMA }) : null

return {
  live: LIVE,
  lus: ok.length + '/' + CHUNKS.length,
  compte: cnt,
  verdict_q4: synth.verdict_q4_vs_evergreen,
  criteres: synth.criteres_operationnels,
  produits: (repaired && repaired.produits_complets && repaired.produits_complets.length)
    ? repaired.produits_complets : synth.produits_shortlist,
  nouveaux_gates: synth.nouveaux_gates,
  contradictions: synth.contradictions,
  markdown: finalMd,
  ajouts_reparation: repaired ? repaired.ajouts : 'reparation non executee',
  critique_1: crit || { verdict: 'critique indisponible' },
  critique_2: crit2 || { verdict: 'recontrole non execute' },
}
