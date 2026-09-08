export const meta = {
  name: 'regles-live-extract',
  description: 'Lecture exhaustive dun live de REGLES Arthur : mecanique, paliers, dates, obligations, recompenses, verbatim horodate',
  whenToUse: 'Live qui explique un fonctionnement ou un reglement (concours, programme, prep Q4) plutot quune doctrine produit. args = {live, date, dir, chunks:[{name,from,to}]}',
  phases: [
    { title: 'Lecture', detail: 'un lecteur par segment de ~10 min' },
    { title: 'Synthese', detail: 'fusion en reglement horodate' },
    { title: 'Critique', detail: 'fidelite + completude' },
    { title: 'Reparation', detail: 'recolle ce que la synthese a compresse' },
    { title: 'Recontrole', detail: 'verification finale element par element' },
  ],
}

let A = args || {}
if (typeof A === 'string') {
  try { A = JSON.parse(A) } catch (e) { return { error: 'args illisible: ' + e.message } }
}
const LIVE = A.live || 'live inconnu'
const DIR = A.dir
const CHUNKS = A.chunks || []
const DATE = A.date || ''
if (!DIR || !CHUNKS.length) return { error: 'args attendus: {live, dir, chunks:[{name,from,to}]}' }

const FIDELITE = [
  'Regles de fidelite, non negociables :',
  '- Le transcript vient de Whisper : ponctuation absente ou fausse, phrases coupees en segments de ~5 s.',
  '  Tu RECONSTRUIS le passage en recollant les segments consecutifs, mais tu ne CHANGES aucun mot.',
  '- verbatim = les mots exacts. Ajouter ponctuation et majuscules : oui. Ajouter, retirer ou remplacer un mot : jamais.',
  '- Whisper massacre les noms propres et les termes techniques. Si un mot est manifestement mal transcrit,',
  '  garde le verbatim tel quel MAIS signale la correction probable entre crochets dans le champ regle ou note.',
  '  Jamais de correction silencieuse.',
  '- PIEGE CONNU ET AVERE sur ces lives : Whisper transcrit "k a day" (mille par jour) en "cadeau", "cadet",',
  '  "cadeilles" ou "carton". Un passage du type "4 5 cadeaux par jour" veut dire "4-5 K par jour".',
  '  Tu gardes le verbatim brut ET tu signales "[K infere]" dans la note. Ne corrige jamais en silence,',
  '  mais ne prends jamais un palier de chiffre daffaires pour un cadeau.',
  '- Un chiffre entendu se recopie tel quel : pas darrondi, pas de conversion, pas dunite inventee.',
  '- Une date se recopie telle quelle. Si Arthur dit "le 15" sans mois, ecris "le 15" et note lambiguite.',
  '- Doute sur la valeur dun passage : inclus-le. Un faux positif se filtre en aval, une regle manquee est perdue.',
].join('\n')

const READER_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['segment', 'resume', 'regles', 'paliers_recompenses', 'dates_echeances', 'obligations_membres',
    'chiffres_seuils', 'produits_ou_niches_cites', 'questions_membres'],
  properties: {
    segment: { type: 'string' },
    resume: { type: 'string', description: 'ce qui se passe dans ce segment, 3 phrases max' },
    regles: {
      type: 'array',
      description: 'toute regle de fonctionnement : qui peut participer, comment on compte, ce qui compte ou pas, exclusions, arbitrages',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['ts', 'theme', 'regle', 'verbatim'],
        properties: {
          ts: { type: 'string' },
          theme: { type: 'string', description: 'participation | comptage | preuve | calendrier | recompense | sanction | accompagnement | strategie-q4 | autre' },
          regle: { type: 'string', description: 'la regle en une phrase claire et actionnable' },
          verbatim: { type: 'string' },
          note: { type: 'string' },
        },
      },
    },
    paliers_recompenses: {
      type: 'array',
      description: 'chaque palier de performance et ce quil donne droit. Le palier est un CHIFFRE DAFFAIRES, la recompense est un LOT.',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['ts', 'palier', 'recompense', 'verbatim'],
        properties: {
          ts: { type: 'string' },
          palier: { type: 'string', description: 'le seuil a atteindre, recopie tel quel' },
          recompense: { type: 'string', description: 'le lot, recopie tel quel' },
          conditions: { type: 'string', description: 'duree de maintien, preuve exigee, date limite, cumul ou non' },
          verbatim: { type: 'string' },
        },
      },
    },
    dates_echeances: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['ts', 'date', 'ce_qui_se_passe', 'verbatim'],
        properties: { ts: { type: 'string' }, date: { type: 'string' }, ce_qui_se_passe: { type: 'string' }, verbatim: { type: 'string' } },
      },
    },
    obligations_membres: {
      type: 'array',
      description: 'ce quun membre doit faire, fournir, poster ou eviter pour etre dans les clous',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['ts', 'obligation', 'verbatim'],
        properties: { ts: { type: 'string' }, obligation: { type: 'string' }, verbatim: { type: 'string' } },
      },
    },
    chiffres_seuils: {
      type: 'array',
      description: 'tout seuil chiffre : marge, CA, ROAS, budget, CPC, delais, nombre de sites, nombre de produits',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['ts', 'seuil', 'verbatim'],
        properties: { ts: { type: 'string' }, seuil: { type: 'string' }, verbatim: { type: 'string' } },
      },
    },
    produits_ou_niches_cites: {
      type: 'array',
      description: 'un produit ou une niche nommee. ATTENTION : un objet cite comme LOT du concours nest PAS une piste produit, marque-le nature="lot".',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['nom', 'ts', 'nature', 'verdict_arthur'],
        properties: {
          nom: { type: 'string' },
          ts: { type: 'string' },
          nature: { type: 'string', description: 'piste-produit | niche | lot | outil | concurrent | exemple-illustratif' },
          verdict_arthur: { type: 'string' },
          prix_ou_metrique: { type: 'string' },
          verbatim: { type: 'string' },
        },
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

function readerPrompt(c, i, n) {
  return [
    'Tu lis un segment du transcript dun live de coaching e-commerce en francais (Arthur, formation Ecom Inner Circle).',
    'Live : ' + LIVE + (DATE ? ' (' + DATE + ')' : '') + '.',
    'Ce live nest PAS une session de recherche produit : il explique les REGLES et le FONCTIONNEMENT dun dispositif',
    'de preparation au Q4 (vraisemblablement un challenge interne avec des paliers et des lots). Tu extrais la mecanique.',
    '',
    'FICHIER A LIRE EN ENTIER (outil Read, lis TOUT le fichier) :',
    DIR + '\\' + c.name,
    'Il couvre ' + c.from + ' -> ' + c.to + ' (segment ' + (i + 1) + '/' + n + ').',
    '',
    'Mission : extraire de facon EXHAUSTIVE la mecanique et tout chiffre, avec horodatage.',
    '',
    FIDELITE,
    '',
    'Ce qui compte particulierement :',
    '1. La mecanique : qui participe, comment on mesure, sur quelle periode, quelle preuve est exigee -> regles.',
    '2. Les paliers et les lots : chaque seuil de chiffre daffaires et ce quil rapporte -> paliers_recompenses.',
    '3. Les dates : debut, fin, jalons, deadlines de preparation -> dates_echeances.',
    '4. Ce quun membre doit FAIRE concretement -> obligations_membres.',
    '5. Tout seuil chiffre -> chiffres_seuils.',
    '6. Les produits et niches nommes, en distinguant une PISTE PRODUIT dun LOT du concours -> produits_ou_niches_cites.',
    '7. Les questions des membres et les reponses dArthur -> questions_membres.',
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
  regles: ok.reduce((a, r) => a + (r.regles || []).length, 0),
  paliers: ok.reduce((a, r) => a + (r.paliers_recompenses || []).length, 0),
  dates: ok.reduce((a, r) => a + (r.dates_echeances || []).length, 0),
  obligations: ok.reduce((a, r) => a + (r.obligations_membres || []).length, 0),
  seuils: ok.reduce((a, r) => a + (r.chiffres_seuils || []).length, 0),
  produits: ok.reduce((a, r) => a + (r.produits_ou_niches_cites || []).length, 0),
  questions: ok.reduce((a, r) => a + (r.questions_membres || []).length, 0),
}
log(ok.length + '/' + CHUNKS.length + ' segments lus - ' + cnt.regles + ' regles, ' + cnt.paliers + ' paliers, ' +
  cnt.dates + ' dates, ' + cnt.obligations + ' obligations, ' + cnt.seuils + ' seuils, ' + cnt.produits +
  ' produits/niches, ' + cnt.questions + ' questions')
if (!ok.length) return { error: 'aucun lecteur na abouti' }
if (ok.length < CHUNKS.length) log('ATTENTION couverture partielle : ' + (CHUNKS.length - ok.length) + ' segment(s) perdu(s)')

const payload = JSON.stringify(ok, null, 1)

const CONTEXTE = [
  'Contexte indispensable, a utiliser pour relier ce live au reste, jamais pour inventer :',
  '- Mathieu est coache par Arthur. Appel prive du 27/07/2026 : marche UK, produit evergreen, mid-ticket 300-1500 EUR',
  '  en visant ~500 EUR, produit qui se bundle, sans enfer logistique.',
  '- Trois lives de juillet 2026 deja depouilles : 10/07 et 16/07 (recherche produit), 22/07 (RECHERCHE PROD Q4).',
  '  Il en ressort que "Q4" chez Arthur = un multiplicateur calendaire applique a ce qui tourne deja,',
  '  pas une categorie de produit ; larchetype cite est le remontoir (evergreen + vocation cadeau).',
  '  Marge NETTE structurelle annoncee : 35 % par an, couple avec un ROAS denviron 3,3. Aucun de ces trois lives',
  '  ne pose de gate de marge brute.',
  '- Un concours interne existe deja dans ces lives : paliers 1 K/jour, 2 K/jour, 5 K/jour avec des lots',
  '  (AirPods Pro, AirPods Max, workshop, bracelet, chaise Herman Miller, MacBook Pro). Ce live est probablement',
  '  celui qui en pose les regles : sil precise, complete ou CONTREDIT ces paliers, dis-le explicitement.',
].join('\n')

phase('Synthese')
const SYNTH_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['markdown', 'resume_mecanique', 'paliers_table', 'calendrier', 'ce_que_mathieu_doit_faire', 'contradictions'],
  properties: {
    markdown: { type: 'string', description: 'le document complet, pret a ecrire sur disque' },
    resume_mecanique: { type: 'string', description: 'en 5 phrases : quest-ce que ce dispositif, qui, quand, comment on gagne' },
    paliers_table: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['palier', 'recompense', 'source_ts'],
        properties: { palier: { type: 'string' }, recompense: { type: 'string' }, conditions: { type: 'string' }, source_ts: { type: 'string' } },
      },
    },
    calendrier: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['date', 'evenement', 'source_ts'],
        properties: { date: { type: 'string' }, evenement: { type: 'string' }, source_ts: { type: 'string' } },
      },
    },
    ce_que_mathieu_doit_faire: {
      type: 'array',
      description: 'les actions concretes qui decoulent des regles, chacune sourcee. Zero conseil personnel non issu du live.',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['action', 'echeance', 'source_ts'],
        properties: { action: { type: 'string' }, echeance: { type: 'string' }, source_ts: { type: 'string' } },
      },
    },
    contradictions: { type: 'string', description: 'ce qui contredit ou precise les 3 lives de juillet, ou "aucune"' },
  },
}

const synth = await agent([
  'Tu fusionnes ' + ok.length + ' extractions du meme live en un seul document de reglement.',
  'Live : ' + LIVE + (DATE ? ' (' + DATE + ')' : '') + '.',
  '',
  CONTEXTE,
  '',
  'LA QUESTION A TRANCHER, avec citations horodatees comme preuve :',
  '  Ce live decrit-il (A) le reglement dun concours interne avec des lots, (B) un programme de preparation',
  '  operationnelle au Q4 avec un calendrier impose, (C) les deux, ou (D) autre chose ?',
  '  Si les extractions ne permettent pas de trancher, dis-le franchement au lieu de choisir.',
  '',
  'Produis :',
  '1. markdown = document complet. Structure : titre, ligne de source (live, date, duree, nb de segments),',
  '   "En une page" (la mecanique resumee), "Les regles" (tableau theme/regle/source), "Paliers et lots" (tableau),',
  '   "Calendrier" (tableau date/evenement/source), "Ce quun membre doit faire", "Chiffres et seuils" (tableau),',
  '   "Produits et niches cites" (tableau nom/nature/verdict/source, en separant clairement les LOTS des PISTES PRODUIT),',
  '   "Questions des membres", "Ce que ca precise ou contredit dans les 3 lives de juillet".',
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
].join('\n'), { label: 'synthese regles', phase: 'Synthese', schema: SYNTH_SCHEMA })

if (!synth) return { error: 'synthese echouee', lus: ok.length, compte: cnt }

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

phase('Critique')
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
  '2. COMPLETUDE : quelque chose des extractions a-t-il ete perdu ? En particulier un palier, une date, une obligation,',
  '   un chiffre, un produit nomme, une question de membre.',
  '3. CONFUSION LOT / PRODUIT : un objet donne en recompense est-il presente comme une piste produit ? Cest la faute',
  '   la plus grave possible sur ce live. Liste chaque cas.',
  '4. TROUS REELS : quelle information un membre aurait besoin pour participer et que ce live ne donne pas ?',
  '   Pour chacun, dis quel segment horaire relire, ou si linfo est simplement absente.',
  '',
  'Sois severe et concret. "Ca a lair bien" nest pas une reponse.',
].join('\n'), { label: 'critique regles', phase: 'Critique', schema: CRIT_SCHEMA })

phase('Reparation')
const REPAIR_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['markdown', 'regles_completes', 'ajouts'],
  properties: {
    markdown: { type: 'string', description: 'le document complet corrige, pret a ecrire sur disque' },
    regles_completes: {
      type: 'array',
      description: 'TOUTES les regles du live, une par entree, aucun regroupement',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['theme', 'regle', 'source_ts'],
        properties: { theme: { type: 'string' }, regle: { type: 'string' }, verbatim: { type: 'string' }, source_ts: { type: 'string' } },
      },
    },
    ajouts: { type: 'string' },
  },
}

const repaired = crit ? await agent([
  'Tu repares un document de reglement incomplet. Un critique a liste ce qui manque. Tu produis la version complete.',
  '',
  'REGLE ABSOLUE : tu nenleves RIEN du document existant. Tu ne reformules pas ce qui est deja juste.',
  'Tu ajoutes ce qui manque, aux bons endroits, et tu corriges seulement ce que le critique signale comme faux.',
  '',
  'Exigence de completude : chaque regle, chaque palier, chaque date, chaque obligation et chaque question de membre',
  'des extractions doit apparaitre nominativement. Regrouper plusieurs regles en une ligne fourre-tout est exactement',
  'lerreur a corriger. Une regle sans verdict explicite se note telle quelle plutot que detre supprimee.',
  '',
  'Un objet donne en LOT du concours ne doit jamais apparaitre comme une piste produit a vendre. Si le document fait',
  'cette confusion, corrige-la et dis-le dans ajouts.',
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
].join('\n'), { label: 'reparation regles', phase: 'Reparation', schema: REPAIR_SCHEMA }) : null

const finalMd = (repaired && repaired.markdown) ? repaired.markdown : synth.markdown

phase('Recontrole')
const crit2 = repaired ? await agent([
  'Second controle de completude, apres reparation. Meme severite.',
  '',
  'Tu verifies UNIQUEMENT :',
  '1. Chaque regle, palier, date et obligation des extractions apparait-il dans le document ? Liste les manquants.',
  '2. Chaque chiffre des extractions apparait-il ? Liste les manquants.',
  '3. Chaque question de membre apparait-elle ? Liste les manquantes.',
  '4. Un lot du concours est-il encore presente comme une piste produit ? Liste chaque cas.',
  '5. Le document affirme-t-il quelque chose qui nest dans aucune extraction ? Liste-le dans corrections.',
  '',
  'Si tout est couvert, verdict = complet. Ne cherche pas des trous imaginaires, mais ne laisse rien passer.',
  '',
  '=== DOCUMENT REPARE ===',
  finalMd,
  '',
  '=== EXTRACTIONS BRUTES (JSON) ===',
  payload,
].join('\n'), { label: 'recontrole regles', phase: 'Recontrole', schema: CRIT_SCHEMA }) : null

return {
  live: LIVE,
  lus: ok.length + '/' + CHUNKS.length,
  compte: cnt,
  resume_mecanique: synth.resume_mecanique,
  paliers: synth.paliers_table,
  calendrier: synth.calendrier,
  actions: synth.ce_que_mathieu_doit_faire,
  contradictions: synth.contradictions,
  regles: (repaired && repaired.regles_completes && repaired.regles_completes.length) ? repaired.regles_completes : [],
  markdown: finalMd,
  ajouts_reparation: repaired ? repaired.ajouts : 'reparation non executee',
  critique_1: crit || { verdict: 'critique indisponible' },
  critique_2: crit2 || { verdict: 'recontrole non execute' },
}
