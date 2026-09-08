---
name: demand-validator
description: Valide la DEMANDE d'un produit e-com / mot-clé via 3 sources gratuites cross-checkées (Google Trends tendance+saisonnalité, Google Suggest intention d'achat, Amazon Suggest) + serp_scout optionnel (concurrence/marques/search-ads). Sort un score 0-100 + verdict GO/WATCH/SKIP + confiance + gate marge CPC×150. Utiliser quand the operator demande de "valider un produit", "checker la demande", "tendance / saisonnalité d'un mot-clé", "est-ce que ce produit a du volume", "score ce produit", avant d'ajouter un produit au store, ou pour comparer des niches. Complète serp_scout + product-hunter (ne les remplace pas). HONNÊTE : directionnel, PAS un volume exact.
---

# Demand Validator

Outil local de validation de demande produit e-com. **Stdlib-only**, gratuit, sans clé API.
Vit dans `C:\Users\YOU\Documents\BUSINESS\recherche produit\`.

## Quand l'utiliser
- Valider la demande d'un produit / mot-clé avant de l'ajouter au store
- Lire tendance (12 mois) + saisonnalité (5 ans, pic/creux) d'un mot-clé
- Mesurer l'ampleur d'intention d'achat (autocomplete Google + Amazon)
- Donner un verdict chiffré GO / WATCH / SKIP + niveau de confiance
- Vérifier le gate marge : CPC×150 (CPA pire-cas) vs **marge nette** (prix − coût − 10% frais)

## CLI (ce que TOI Claude tu appelles dans les autres conversations)
Depuis `C:\Users\YOU\Documents\BUSINESS\recherche produit\` :

```bash
PYTHONIOENCODING=utf-8 python demand_validator.py "remontoir montre" --gl fr --json
```

Options : `--gl fr|us|de|uk|es` · `--hl <langue>` · `--price X --cost Y --cpc Z` (gate marge)
· `--seed-keyword "montre automatique" --seed-volume 40000` (estimation volume par ancrage Trends)
· `--amazon-fr` (vraie largeur amazon.fr via Playwright, lent) · `--no-scout` · `--no-cache`

Sortie `--json` = dict : `score`, `verdict`, `confidence`, `partial`, `signals_known`,
`detail.S1..S8` (chaque signal : `level` GO/WATCH/SKIP/?, `why`), `cpa_gate`, `manual_checks`, `disclaimer`.
Sans `--json` = rapport lisible FR.

**Cache disque 24h** (`demand_cache.json`) → 2e appel instantané + évite le 429 Google Trends.

## Les 8 signaux (poids)
| | Signal | Source | Poids |
|--|--|--|--|
| S1 | Tendance 12m (hausse/stable/déclin) | Google Trends | 1.5 |
| S2 | Saisonnalité (ratio bas/haut, pic) | Google Trends 5y | 1.5 |
| S3 | Volume cumulé estimé (si seed fourni) | Trends ancrage | 2.0 |
| S4 | Concurrence ecom | serp_scout c2 | 1.5 |
| S5 | Anti-marques (kill switch) | serp_scout c5 | 1.5 |
| S6 | Intention d'achat Google | Google Suggest | 1.0 |
| S7 | Demande physique Amazon | Amazon Suggest | 0.5 |
| S8 | Viabilité Search (ads texte) | serp_scout c12 | 0.5 |

Score = signaux connus renormalisés sur 100. **GO exige ≥5 signaux mesurés** (sinon bridé à WATCH —
un 100/100 sur 2 signaux ne prouve rien). Kill switches : S5 SKIP, ou (S3 SKIP & prix<200€), ou (S1+S2 SKIP).

## VRAI volume Google (signal S3) — via export Keyword Planner
S3 utilise le **vrai volume Google Ads Keyword Planner** dès qu'un export CSV est présent.
- Télécharger un export KP (`Keyword Stats *.csv`, UTF-16) dans `Downloads/` ou `recherche produit/`.
- `kp_ingest.py` le détecte/parse automatiquement (`lookup()` → `ensure_fresh()` reconstruit `kp_data.json` si un CSV plus récent apparaît).
- S3 devient **mesuré** : volume réel + niche cumulée + **CPC réel auto-injecté dans le gate CPA** (si `--cpc` non fourni). `head>=10K→GO`, `>=1K→WATCH`, `<1K→SKIP`.
- Pour générer un export : Google Ads → Outils → Keyword Planner → « Trouver de nouveaux mots clés » → mot-clé → Télécharger → .csv. (Sans campagne active = volumes bucketisés 50/500/5000, directionnel.)
- CLI direct : `python kp_ingest.py "<chemin.csv>"` → écrit `kp_data.json` + table triée par volume.

## Pour DÉBLOQUER les signaux S4/S5/S8
Lance le backend SERP existant (ne pas réimplémenter) :
```bash
python serp_scout.py    # port 7789
```
Le validator le détecte automatiquement (sinon ces signaux restent "à vérifier manuellement").

## Site web local pour the operator
```bash
python demand_server.py   # -> http://127.0.0.1:7800
```
UNE page : tape un produit → jauge score, 8 cartes signaux, chart saisonnalité, chips intentions, gate marge.

## Honnêteté (à toujours rappeler)
Aucune source gratuite ne donne le **volume de recherche exact**. C'est du **directionnel cross-source** :
l'accord entre Trends + Google + Amazon = confiance. Pour un chiffre de volume → Google Keyword Planner
(gratuit, fourchettes) ou SEMrush (payant). Ne JAMAIS présenter le score comme un volume.

## Liens rig
Complète : `serp_scout.py` (SERP/concurrence), `product-hunter` skill (pipeline 5 étapes + 8 gates),
`validation/` (grilles Search/Shopping methode <COACH>), `ROBOT_VALIDATION_PRODUIT.html` (UI riche existante).
Le gate marge suit la doctrine <COURSE-NAME> : CPC×150 vs MARGE NETTE, jamais vs prix de vente.
