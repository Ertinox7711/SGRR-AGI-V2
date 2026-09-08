# Ecom Boss (Gaspard) — Carte du curriculum GMC

> Source : skool.com/ecom-boss-7033 · **Module 4 — ADS (« Ads & GMC »)**. Capturé 2026-06-26.
> Leçons = vidéos Vimeo sans transcript texte. Ci-dessous = la **structure exacte** (titres) + l'interprétation de ce que chaque leçon couvre (méthode Gaspard), à recouper avec le playbook autoritaire `01-gmc-compliance-playbook.md`.

## Module 4 — ADS, parties liées au GMC

### 2 — Configuration & validation du GMC
Mise en place initiale du Merchant Center + validation des produits (raccord avec playbook §4 flux produit, §5 vérif).

### 3 — Google Ads Shopping
- A — Google Shopping et ses stratégies d'enchères
- B — Créer une campagne Shopping
- C — Optimiser les paramètres
- D — Comprendre le comportement des clients
- **E — Suspension Google ADS : Paiement suspect** → cf. playbook §6 (Suspicious Payments : profil de paiement cohérent, carte à soi, EUR, pas de carte partagée entre comptes).

### 4 — Google Ads Search
A Présentation · B Pourquoi Search en + de Shopping · C Broad/Phrase/Exact Match · D Créer la campagne Search · E Mots-clés négatifs. (Hors scope GMC pur — stratégie ads.)

### 5 — Optimisation des campagnes et analyses

### 6 — En cas de Ban GMC (Bonus) — **LA SECTION CŒUR**
> C'est « la section où il parle pour les GMC ». Map leçon → équivalent playbook autoritaire :

| Leçon Gaspard | Sujet | Playbook autoritaire |
|---|---|---|
| Infos importantes : intervention Expert Google | Intervention d'un expert Google | §8 réinstatement |
| A — Présentation et explication | Vue d'ensemble bans GMC | §2 misrepresentation |
| **B — Éviter les bans GMC avec Spectea** | **Spectea** = scanner de conformité GMC (pré-audit du store avant soumission) | §8.4 (outils type AdNabu/ClearCheck/ComplianceGuard) |
| **C — Check up boutique** | Checklist d'audit du store avant soumission | §9 checklist + §2/§3 |
| D — Méthode 1 — Classique | Création GMC propre, voie normale | §5 + §7 |
| E — Création et paramétrage d'un GMC | Setup compte Merchant Center | §4 + §7 |
| F — Importer son flux de produit | Flux produits (canal Google & YouTube Shopify) | §4 |
| G — Validation du statut des produits | Résoudre les statuts/approbation produits | §4 |
| H — Stock limité que faire ? | Gestion availability / out-of-stock | §4.3 |
| **I — Comment résoudre les refus de produits** | Fix des disapprovals produits | §4 |
| **J — Gestion des suspensions de GMC et faire appel** | Process d'appel / re-review | §8 |
| **K — Suspension GMC : « Misrepresentation »** | LA suspension la + dure | §2 (le cœur) |
| **L — Suspension GMC : « Website Needs Improvement »** | Suspension site insuffisant | §3 pages requises + §2.10 |
| M — Méthode 2 — Forcing | ⚠️ Méthode « forcing » (grey-hat) | voir note risque ci-dessous |
| O — Méthode 3 — Proxy (MÉTHODE ULTIME) | ⚠️ Proxy pour contourner le linking de comptes Google | voir note risque ci-dessous |
| **P — Éviter les bannissements GMC** | Prévention bans | §2 + §9 |
| Q — Délier un GMC d'un compte Google Ads | Admin GMC/Ads | §7 |
| R — Supprimer correctement un GMC | Admin GMC | §7 |
| **S — Passer votre boutique en mono produit** | Conversion mono-produit (Brizea = déjà mono-produit premium) | aligné stratégie Brizea |
| T — Installer un proxy | ⚠️ Setup proxy | voir note risque |
| U — Fiche Google My Business / Réseaux S | GBP + réseaux = footprint de marque | §5.4 / §2.11 |
| V — La technique de search | Tactique Search | stratégie ads |
| W — Alterner et savoir mixer les techniques | Mixer les méthodes | — |

### 7 — Ancien module bonus

## ⚠️ Note risque — Méthodes « Forcing » / « Proxy » (M, O, T)

Le cours enseigne des méthodes de **contournement** (forcing, proxy « méthode ultime ») pour faire passer/remonter un GMC quand la voie propre échoue, ou pour exploiter plusieurs comptes. Honnêteté technique :

- **Le proxy pour échapper au linking de comptes Google = « Circumventing Systems »** = ~37 % des suspensions Google Ads 2025, ban **sur détection, sans avertissement** (playbook §6). C'est exactement le risque qu'on veut éviter avec « t'as qu'une chance ».
- **La voie durable = conformité propre** (playbook §2→§9) : retirer les éléments de fausse preuve sociale, identité légale réelle, pages conformes, parité prix/flux. Un GMC qui passe proprement ne se fait pas re-suspendre.
- Les méthodes proxy/forcing = **filet de secours en cas de ban déjà subi**, pas la stratégie de lancement. Pour un **1er** GMC sur un domaine neuf (brizea.fr), on joue propre. Je n'implémente pas de proxy d'évasion (ça crée le risque qu'on cherche à éviter).

## Ce que Brizea applique de cette doctrine

1. **Check up boutique (C) + Éviter les bans (P) + Misrepresentation (K) + Website Needs Improvement (L)** → c'est le travail concret sur le site (voir `02-brizea-gmc-audit.md`).
2. **Mono-produit (S)** → déjà le modèle Brizea.
3. **Spectea / scanner (B)** → passer un scanner de conformité (AdNabu/ClearCheck) en pré-soumission, après les fixes.
4. **Setup GMC propre (D/E/F/G) + appel (J) + paiement suspect (Ads E)** → playbook §4–§8, exécution owner au moment du lancement.
