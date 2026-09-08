# GMC & Google Ads — Index Actionnable Ecom Boss

> **Source** : 8 lives Ecom Boss (Gaspard) sur Google Merchant Center & Google Ads — épisodes 04, 05, 06, 42, 47, 48, 49, 69.
> **Date de synthèse** : 2026-06-27
> **Cible** : Mathieu, lancement **Brizea** (ventilateurs de plafond premium, marché FR) — `pa7duq-jd.myshopify.com` / `brizea.fr`.
> **Format timestamps** : `[MM:SS · ÉpXX]`.

---

## 0. Résumé exécutif (les 5 choses qui font 80% du résultat)

- **Misrepresentation = 80-90% des bans** `[11:13 · Ép47]` `[20:45 · Ép42]`. Ce n'est PAS un problème de société, c'est un problème de **cohérence** : nom / téléphone / email / adresse / délais de livraison / délai de retour doivent être **identiques au pixel** entre GMC, footer, page Contact, FAQ et politiques. Une virgule de différence flag tout le compte.
- **Ordre d'exécution sacré** : (1) infos entreprise GMC → (2) revendiquer + vérifier le domaine → (3) politiques livraison + retour validées → (4) site validé → (5) **SEULEMENT APRÈS** soumettre le flux produits `[02:38 · Ép04]`. **Ne JAMAIS rien modifier après connexion du feed** `[20:55 · Ép06]`.
- **Naissance naturelle du site** : connecter Search Console + sitemap, laisser le site **vivre 1-2 semaines** (indexation + premiers clics naturels) AVANT d'ouvrir le GMC. Google sait reconnaître un site né trop vite = pas naturel `[33:51 · Ép47]` `[23:25 · Ép47]`.
- **Système de points red flag / green flag** : aucun élément seul ne ban, c'est l'**accumulation** `[33:02 · Ép42]` `[10:09 · Ép47]`. Green flags forts pour Brizea : email pro Google Workspace `contact@brizea.fr` `[31:34 · Ép42]`, entité FR vendant en FR `[51:31 · Ép42]`, zéro faux avis/promo/timer.
- **NE JAMAIS lier le GMC à Google Ads tant que les 18 produits ne sont pas tous en VERT depuis 24h** `[25:34 · Ép04]`. Et la vraie validation ≠ statut "valide" affiché : c'est quand les fiches **ressortent dans l'onglet Shopping** de Google `[60:36 · Ép49]` `[63:43 · Ép49]`.

> ⚠️ **Désaccord d'experts à connaître — le mythe du CSS** : Ép05 (Feedcast, qui VEND du CSS) promet **-20% de CPC** sur les emplacements Shopping UE `[05:39 · Ép05]`. Ép42 (expert indépendant) déclare après test sur plusieurs centaines de milliers d'€ : **0 impact sur le CPC, mythe vendu par les agences**, et même contre-productif (GMC neuf → ré-apprentissage) `[29:55 · Ép42]`. **Verdict pour Brizea : ignorer le CSS au lancement, garder le GMC direct.**

---

## 1. Checklist setup GMC complet (ordonnée — Ép04 + Ép47)

### 1.1 — AVANT de toucher au GMC : naissance naturelle du site (Ép47)

- [ ] **MVP réellement prêt** avant de retirer le mot de passe Shopify + connecter le domaine — page d'accueil correcte, assez de produits (pas 2), prêt à vendre. Domaine connecté trop tôt = Google tombe sur la page mot de passe Shopify = mauvais signal d'entrée `[23:25 · Ép47]`.
- [ ] **Search Console + GA4 + sitemap** : connecter Search Console, soumettre `brizea.fr/sitemap.xml`, valider la propriété via enregistrement DNS TXT (host `@`) `[24:33 · Ép47]`.
- [ ] **Laisser vivre 1 à 2 semaines** : attendre indexation des 1res pages (Search Console au vert), premières impressions/clics naturels, ajouter quelques produits/articles de blog `[33:51 · Ép47]`. Résultat revendiqué : 0 blocage GMC à vie.
- [ ] **Optimiser/vérifier la version MOBILE** : Google scanne en version téléphone, ~80% des users sont sur mobile `[49:00 · Ép47]`.

### 1.2 — Infos entreprise GMC (Ép04)

- [ ] **Nom de l'entreprise** = le **NOM COMMERCIAL** du site (ex "Decathlon"), PAS l'entité juridique. Pour Brizea → **"Brizea"** `[02:53 · Ép04]`.
- [ ] **Adresse** = siège social de la société qui gère le shop `[02:53 · Ép04]`.
- [ ] **Téléphone** = celui affiché sur le site, **réellement joignable** par les clients `[02:53 · Ép04]`. VoIP/OnOff OK tant que quelqu'un répond `[27:51 · Ép04]`.
- [ ] **Infos SERVICE CLIENT** (lien SAV, email shop, tél SAV) → **NE PAS les remplir au départ**. Les ajouter UNIQUEMENT une fois le GMC validé, en revenant dans les infos d'entreprise `[03:31 · Ép04]`.
- [ ] **Vérification de l'annonceur** = désormais OBLIGATOIRE, à faire directement. Numéro de TVA hyper important ; en micro-entreprise sans TVA → mettre le **SIRET** (récupérable sur societe.com) `[64:45 · Ép04]`.

### 1.3 — Revendiquer + vérifier le domaine

- [ ] Nom de domaine **revendiqué ET vérifié** dans le GMC `[13:51 · Ép04]`.
- [ ] Email **PRO @nomdedomaine.fr**, jamais @gmail.com `[13:51 · Ép04]`. Faisable gratuitement via redirection Shopify + import Gmail, ou via Workspace `[42:42 · Ép47]`.

### 1.4 — Politiques de livraison (Ép04 + Ép47)

- [ ] **Une politique par pays vendu**. Pour la France : sélectionner France + tous les produits `[04:08 · Ép04]`.
- [ ] **Délai d'acheminement < 10 jours ouvrés** (ex 4-7 j). Au-delà de 10 j = risque catégorisation dropshipping + red flag `[04:08 · Ép04]`. Le délai de traitement (1-2 j lun-ven) est moins critique que l'acheminement `[04:08 · Ép04]`.
- [ ] **Recopier EXACTEMENT les mentions légales** dans la config GMC : temps de traitement (min/max), délai d'acheminement, livraison gratuite à partir de 0€ (= offerte), zone France `[58:49 · Ép47]`.

### 1.5 — Politiques de retour (Ép04 + Ép47)

- [ ] Coller la politique de retour/remboursement du site (15 ou 30 j, gratuit, sans contrainte client) `[06:49 · Ép04]`.
- [ ] Config retours GMC : URL = page `/policies/` retour, pays France, **accepter retours + échanges**, produits neufs, délai 30 j, méthode envoi postal, étiquette incluse, aucun frais de remise en stock, délai de remboursement aligné aux légales `[61:14 · Ép47]`.
- [ ] La politique doit répondre concrètement au parcours client : échanges ? changement d'avis / erreur / objet cassé / mauvais produit / colis jamais arrivé / annulation ? sous quel délai ? garantie ? étapes (renvoyer à telle adresse → contrôle → remboursement) + forme (moyen d'origine ou avoir) + méthode de renvoi `[11:50 · Ép04]`.
- [ ] **Les 2 politiques (livraison ET retour) doivent être VALIDÉES par le GMC avant de soumettre le flux** `[06:49 · Ép04]`.

### 1.6 — Footer + pages du site (Ép04 + Ép06 + Ép47)

- [ ] **Footer en 3 colonnes** `[08:09 · Ép04]` :
  1. **Aide/support** : à propos, nous contacter, suivi de commande, barre de recherche.
  2. **Politiques** : retour/remboursement, CGU, confidentialité, livraison, mentions légales, CGV, paiement.
  3. **Identité** : nom commercial, téléphone, email, adresse physique, **TVA intracom/SIRET**, **horaires d'ouverture** (ex lun-ven 8h-18h) + **icônes de paiement**.
- [ ] **Réseaux sociaux visibles** = signal d'autorité `[20:50 · Ép06]`. Une page avec nom + URL + photo de profil passe même sans publication, mais poster quelques publis prouve un compte réel `[68:54 · Ép06]`.
- [ ] **Page d'accueil reflète toute la gamme** : ne jamais réutiliser le même bouton vers le même produit, chaque section renvoie vers du différent, privilégier collections `[45:03 · Ép47]`.
- [ ] **Page produit** : action principale = "Ajouter au panier", **SUPPRIMER "Acheter maintenant"** (checkout direct) en phase de validation `[47:17 · Ép47]`.
- [ ] **Site vivant** : storytelling, FAQ, page À propos, page suivi colis (Parcel Panel / 17track) avec du texte `[45:38 · Ép47]`.
- [ ] **Email PRO + chat + horaires SAV + tél** sur page Contact ET footer `[42:42 · Ép47]` `[22:43 · Ép06]`.
- [ ] **Bannière cookies** a minima ; mieux = outil compatible **Consent Mode V2** `[51:18 · Ép47]`.
- [ ] **Cohérence emplacement/stock** : adresse "emplacement de traitement des commandes" = onglet Emplacement = Marchés Shopify (même adresse) `[49:38 · Ép47]`.

### 1.7 — Validation finale avant feed

- [ ] **Cliquer/auditer TOUS les liens manuellement** : hypertextes, menus, boutons de bannière, page "tous nos produits". Un seul 404 suffit à bloquer le GMC `[26:44 · Ép04]`.
- [ ] **Toutes les pages légales uniques et personnalisées** : pas de copier-coller template, pas de lorem ipsum oublié `[13:38 · Ép42]`. Tout texte 100% unique (zéro duplicate content) `[47:17 · Ép47]`.
- [ ] **Ne PAS soumettre tant que le site n'est pas parfaitement fini** : un site avec petites erreurs = flag, très chiant à débloquer ensuite `[28:07 · Ép04]`.

### 1.8 — Connexion du feed (Ép47 + Ép69)

- [ ] **Méthode de connexion** : connecteur/plugin recommandé (crée + met à jour le flux en temps réel). Fichier manuel = à PROSCRIRE `[05:00 · Ép47]`.
- [ ] **Commencer par le canal Google natif** (gratuit, officiel, multilangue auto) ; basculer sur Simprosys seulement si besoin avancé une fois validé `[08:33 · Ép47]`.
- [ ] **Associer LE MÊME compte Google** que celui de création de la boutique `[53:30 · Ép47]`.
- [ ] **Test de validation réelle** : taper `brizea` dans Google → onglet **Shopping** ; l'apparition des fiches (free listings) = feu vert, même avant 2 semaines `[47:34 · Ép69]` `[60:36 · Ép49]`. **"Images" ≠ "Produits/Shopping"** : seul l'onglet Produits prouve l'éligibilité `[63:43 · Ép49]`.

---

## 2. Causes de suspension et fixes (Ép04 + Ép42 + Ép47 + Ép06)

### 2.1 — Misrepresentation (déclaration trompeuse) — LA cause n°1

- **Définition** : manque de transparence / cacher des infos essentielles (retours, frais, **délais de livraison**, douanes). Avant tout une histoire de **cohérence des données** `[20:45 · Ép42]` `[11:13 · Ép47]`. 80-90% des blocages.
- **Le piège classique** : 14 j de retour quelque part, 7 j dans la FAQ → incohérence = ban `[26:28 · Ép42]`. "Google scanne le GMC, le flux, la fiche produit, toutes les pages" `[27:02 · Ép42]`.
- **FIX** : auditer que nom / numéro / délais livraison / délai retour / délai SAV soient **identiques partout** — GMC, fiche produit, mentions légales, FAQ, page Contact, footer `[44:38 · Ép47]`.
- **Diagnostic** : GMC → "Attention requise" → cliquer **CHAQUE produit** pour voir le sous-motif sous le Miss Rep → corriger les produits → demander une levée de réserve `[18:53 · Ép04]`.

### 2.2 — "Website Needs Improvement" (site bugué)

- **Causes** : liens cassés/404, images manquantes/floues, images avec logo ou texte dessus, navigation impossible, erreurs de stock (souvent sync externe Dsers) `[11:51 · Ép47]`.
- **FIX** : corriger les 404/images **ET souvent rajouter du texte sur les pages** `[11:51 · Ép47]` `[45:38 · Ép47]`. Liens morts diagnostiqués live comme cause directe de misrep `[31:33 · Ép69]`.

### 2.3 — Politiques manquantes (Ép06)

- Causes récurrentes de suspension : (1) promotions abusives, (2) absence des données d'entreprise, (3) oubli de la **politique de confidentialité**, (4) absence de **politique de paiement** `[20:17 · Ép06]`.
- Incohérence nom-shop vs nom-entreprise dans la politique de confidentialité → révision manuelle + blocage `[22:25 · Ép06]`.

### 2.4 — Faux avis / faux signaux

- Google scanne **TOUT le web**, pas seulement l'affiché : une page test avec faux avis ou avis-template (vus sur 200 autres sites) = contenu trompeur détecté `[14:55 · Ép42]`.
- On passe difficilement le GMC avec des avis ajoutés artificiellement ou des promos trop agressives ; Google finit par voir la triche `[11:42 · Ép06]`.
- La boutique de démo passe justement parce qu'elle n'a NI promo, NI avis, NI garantie hardcodée `[57:39 · Ép47]`.

### 2.5 — Signaux dropshipping

- Google ne "détecte" pas le drop directement, il le **classifie** via : délais de livraison très longs, politiques de retour mal mises, outils d'urgence/scarcity génériques "vus et revus" `[24:20 · Ép42]`. Si un humain sent le drop, Google le détecte x1000.
- Au déblocage Shopping, à la question business model → répondre **"vente de produits / marchandises en ligne"**, JAMAIS le mot "dropshipping" / "drop" `[65:54 · Ép04]`.

### 2.6 — Mécanique des bans (Ép42)

- **Site neuf = éléments "touchy"**, vérifs renforcées les premiers mois `[05:13 · Ép42]`. Marge d'erreur quasi nulle.
- **1ère suspension → fichier spécial** : la 2e devient beaucoup plus facile, le moindre écart sanctionne `[07:50 · Ép42]`.
- **Account/IP ban** : Google relie via SIRET, adresse, société, **moyen de paiement**, email, connexions, wifi partagé, géoloc `[35:19 · Ép42]`. SIRET déjà flaggé (société radiée) = ban à chaque recréation, même sous proxy.
- **Norme ~3 misrepresentations** d'affilée avant que ça devienne très compliqué ; mais **contrefaçon de marque = ban immédiat** sans tolérance `[59:51 · Ép42]`.
- **Compte hacké / impayé Google = pire red flag** : peut bannir tous les shops liés à l'email `[27:24 · Ép42]`.
- **Périodes de contrôle renforcé** : Q4/novembre + fin d'été 2025 (arrivée d'Amazon sur Shopping). Meilleure fenêtre nouveau GMC = post-Q4 (janvier+) `[37:32 · Ép42]`.
- **Les vérifs sont progressives** : "passer" au début ≠ immunité, Google revient re-checker et peut bannir un best-seller du jour au lendemain `[53:11 · Ép42]`.

### 2.7 — Quoi faire / NE PAS faire face à un ban

- ✅ **Réflexe n°1 = CONTACTER Google** (support GMC) en transparence ("j'ai fait cette erreur, comment la régler"), envoyer preuves/factures. Google beaucoup plus joignable que Meta `[11:09 · Ép42]`.
- ✅ Souvent le déblocage misrep = juste une **validation de l'annonceur déguisée** : cliquer "Valider votre identité" → vérif → redemander un examen → vert en 1 j à qq jours `[83:16 · Ép69]`.
- ❌ **NE JAMAIS recréer un GMC/compte sur le même compte pour contourner = ban DÉFINITIF** `[08:55 · Ép42]` `[66:17 · Ép47]`. Régler le problème, pas le contourner.
- ❌ Proxy = dernier recours absolu (6-7 GMC bannés d'affilée, détecté comme contournement) `[11:09 · Ép42]`.
- ✅ **Plan B** : si ça bloque après 2-3 vérifs, ne pas s'acharner → nouvelle boutique. Export CSV produits → Google Sheets → rechercher/remplacer le nom vendeur → réimport nouveau Shopify (~1h) `[64:17 · Ép47]`. Le GMC bloqué = le laisser tel quel, repartir avec nouvelle boutique + nouvelle adresse mail.
- ℹ️ **Ads suspendu ≪ GMC suspendu** : les Ads peuvent tourner depuis un autre compte ; si le GMC saute → réimporter sur nouvelle boutique `[78:32 · Ép47]`.

### 2.8 — Faux positifs à ne PAS paniquer

- **Statut "stock limité"** sur quelques produits après validation (ou au lancement des Ads) = **normal et transitoire**, repasse en "normal" seul, n'empêche PAS l'Ads `[55:34 · Ép04]` `[84:42 · Ép69]` `[62:39 · Ép47]`.
- **Mindset Google = marathon long terme**, pas Facebook Ads `[20:25 · Ép47]`. Patience = mindset "vraie entreprise".

---

## 3. Qualité du feed produit (Ép05 + Ép42 + Ép06)

### 3.1 — Règle d'or : le feed est un "cheat code" qualité

- Plus on donne d'infos à Google, mieux les algos fonctionnent, plus la note de qualité monte `[46:46 · Ép42]`. Connaître les attributs **obligatoires ET facultatifs** pour dépasser la concurrence.
- L'optimisation des fiches = jusqu'à **~50% de la performance** des campagnes Shopping `[21:18 · Ép05]`.
- Google scanne le catalogue : plus il est optimisé, mieux la diffusion sur des requêtes qualifiées → meilleur ROAS `[06:41 · Ép05]`.

### 3.2 — Catégorie Google (taxonomie) — OBLIGATOIRE

- Taxonomie sur **TOUS les produits** = optimisation minimale obligatoire `[14:24 · Ép06]`. Chercher "taxonomie produits Google Merchant Center France" = Excel officiel ; renseigner le n° de catégorie ou le chemin avec crochets.
- ✅ **Brizea : DÉJÀ FAIT** — catégorie "Ceiling Fans" (`hg-9-1-6-1`) posée 18/18 via `_gmc-category.js`.

### 3.3 — GTIN (code-barres)

- Attribut **très important** : si disponible, le mettre `[15:30 · Ép06]`. Google identifie alors exactement le produit → à prix égal (meilleure négo) **vous passez automatiquement devant la concurrence** dans la même catégorie.
- GTIN manquant = cause typique de produit refusé `[08:42 · Ép05]`. Corriger l'attribut suffit souvent à revalider.
- **Brizea** : `noGtin=18` (le canal mettra `identifier_exists:false` → produit non refusé pour autant). **Action sourcing/owner** : demander les GTIN/EAN fournisseur des 18 ventilateurs pour gagner l'avantage concurrentiel vs institutionnels FR.

### 3.4 — Titres produits = la requête Shopping

- **En Shopping, le terme de recherche EST le titre du produit** `[81:25 · Ép48]`. Optimiser le titre = optimiser la requête. (Cibler manuellement 500 produits × variantes serait ingérable.)
- SEO du feed = mettre **TOUS les attributs dans le titre** (façon Amazon) : ex "chaussures bleues taille X" `[10:24 · Ép06]`. Erreur fréquente : catégorie "chaussures" mais titre = nom du modèle seul → le bot ne comprend pas.
- **NE JAMAIS modifier le titre manuellement dans le GMC** : l'API cesse de se synchroniser avec le site `[16:53 · Ép06]`. Tout le travail (SEO title, meta, attributs, GTIN, catégorisation) se fait **depuis le shop**.
- Réglage canal Google : cocher "utiliser le titre produit" pour le SEO, mais choisir **"Description du produit par défaut"** (plus riche) plutôt que la méta-description (~160 c) `[55:25 · Ép47]`.

### 3.5 — Images

- **1ère image = UNIQUEMENT le produit, FOND BLANC, meilleure qualité, AUCUN logo ni texte** (interdit) `[42:32 · Ép42]` `[16:03 · Ép04]`. C'est elle qui est publiée sur Shopping.
- Min **4 photos** : les images supplémentaires = ambiance/lifestyle, n'importe quel fond `[42:32 · Ép42]`.
- **Hack "gris" validé pour la déco** : pour un produit qui rend mal sur fond blanc, mettre des photos d'**ambiance** (produit posé dans un salon) → passe très bien `[43:36 · Ép42]`. **Directement pertinent Brizea** : un ventilateur de plafond se montre mieux installé au plafond dans une pièce qu'isolé sur fond blanc.
- **Ne jamais utiliser les photos AliExpress brutes**, les retravailler `[16:03 · Ép04]`.
- **Images IA** : pas un red flag SAUF si toutes dégueulasses/mal générées `[72:18 · Ép47]`. Nano Banana laisse un marquage invisible dans les pixels (flip/saturation ne l'enlèvent pas). Alternative non détectée : Seedream (gère moins bien le texte).

### 3.6 — Stock & feed clean

- Indiquer clairement le stock (en stock ou non) `[15:11 · Ép04]`.
- **Rupture mal gérée** : retirer un produit puis le remettre après 2-3 sem → l'algo (fenêtre 45/90 j) ne le repositionne pas comme avant, fait chuter le ROAS global `[69:26 · Ép06]`.
- Pendant la validation : feed le plus **clean et lean** possible, pas de pseudo-produits (e-book offert, assurance panier) qui se font refuser `[85:36 · Ép47]`.
- **Custom labels** (top produits / top ROI / exclusions) pour segmenter les campagnes par performance `[10:25 · Ép05]`.

### 3.7 — Éditions post-validation (rassurant)

- Modifier une fiche APRÈS validation **ne redéclenche PAS de vérification** `[30:35 · Ép69]`. Seuls **1ère image + titre** sont sensibles **au tout début**.
- Une fois validé = définitif : ajouter 500-1000 nouveaux produits ne nécessite **aucune revalidation**, le flux API les pousse en ~10 min à 2h `[82:24 · Ép47]`.
- Après validation : attendre ~5 j que la campagne tourne avant de retravailler photos/copy ; si modif urgente → dupliquer en BROUILLON, pas sur le live `[71:48 · Ép04]`.

---

## 4. Structure Google Ads (Ép06 + Ép49 + Ép48)

### 4.1 — Structure du compte

- 3 niveaux : **Compte** (1 email dédié boutique, facturation, conversions, audiences, sync Shopify) > **Campagnes** (budget jour, géo/langue, enchères) > **Groupes d'annonces** (mots-clés segmentés) `[03:30 · Ép49]`.
- **Funnel** : Notoriété/Considération = YouTube + Display ; **Conversion = Search + Shopping** (priorité e-commerce, meilleur ROI) `[10:40 · Ép49]`. En e-com, **80% du budget part sur Shopping/GMC** `[03:30 · Ép42]`.

### 4.2 — Shopping standard au lancement

- **Commencer par Shopping STANDARD** (pas PMax) : conversion pure, la plus rentable `[43:01 · Ép49]`. Cocher les 3 objectifs (achat + ajout panier + paiement initié).
- Enchères au lancement (sans data) : **"Maximiser les clics" + limite CPC max manuelle** basée sur la fourchette haute du Keyword Planner, légèrement au-dessus de la moyenne `[44:54 · Ép49]`. Ex live : fourchette 0,14-0,72€ → CPC 0,55€, budget 40€/j.
- **Mono-produit / peu de produits = dur à positionner** (peu d'impressions, aucune autorité). Solution : créer des **variantes** (Shopping duplique → vous devenez référent). Avec 3 produits : standard shopping CPC manuel + PMax Shopping-only en parallèle, comparer. **Au-delà de 50 produits → PMax obligatoire** `[63:23 · Ép06]`.

### 4.3 — Search

- Lancer une **Search sur mots-clés intentionnistes** ("acheter ventilateur de plafond en ligne", "ventilateur plafond silencieux") `[60:03 · Ép49]`. Ne pas négliger, tester systématiquement.
- **Campagne de marque (brand)** : stratégie "Taux d'impression cible 100%" en haut de page, verrouille son nom, empêche les concurrents d'enchérir dessus. CPC dérisoire si nom unique (ex 10 cts) `[68:33 · Ép49]`. **Brizea = nom ownable → brand campaign quasi gratuite.**
- **Exclure son propre nom de marque** des campagnes de conquête (listes d'exclusion "Brands") pour ne pas gaspiller `[64:24 · Ép49]`. Conquête concurrents = enchérir sur les 3-4 meilleurs (rentable, cadrer juridiquement le comparatif).
- **Segments d'audience "concurrents"** : Outils > Bibliothèque partagée > Segments personnalisés > "utilisateur ayant recherché ces termes" = noms/URLs concurrents (ex Alizé) `[30:08 · Ép49]`.

### 4.4 — Performance Max

- **PMax = boîte noire**, moins de contrôle, tend à surdépenser → **PAS recommandée seule au lancement** `[61:38 · Ép49]`. La réserver à un compte mûr/rentable.
- Variante Maxime : **PMax Shopping-Only sans assets** (pas de titres ni images), créable via le canal feed/Simprosys → évite l'obligation Google Ads de fournir titres/images `[24:33 · Ép06]`.
- **Update début 2025** : PMax Shopping-only ET standard shopping peuvent désormais tourner **en parallèle** (le bug "PMax tue la standard" est corrigé). Config idéale : 1 PMax Shopping-only + 1 PMax sans flux (Display/YouTube/Search) + 1 standard shopping `[44:56 · Ép06]`.
- Sur PMax on ne voit pas où partent les conversions → **script Google (export Excel)** `[46:46 · Ép06]`. ⚠️ **Si le CPC chute brutalement = Google bascule sur du Display** (mal dépensé), inutile d'augmenter le budget.
- **Pas de vidéo → formulaire à Google pour bloquer YouTube** dans la PMax (sinon Google fabrique une vidéo bidon depuis vos images) `[47:17 · Ép06]`.

### 4.5 — Enchères, ROAS, scaling

- **Lancement : aucun objectif** (pas de CPA/ROAS/CPC max) ou "Maximize Conversions". Récolter **30 à 50 conversions** PUIS fixer un objectif (jamais passer brutalement le ROAS à 400) `[56:55 · Ép06]` `[76:30 · Ép69]`.
- **Stratégie d'enchères au niveau COMPTE** = combiner **ROAS cible + plafond CPC max** dans Options avancées (impossible dans une campagne standard) `[37:32 · Ép49]`. Garde-fou clé contre les clics trop chers.
- **NE JAMAIS toucher le CPC max trop souvent** : chaque grosse modif relance l'apprentissage (~5-7 j) `[71:58 · Ép69]`. Viser une fourchette au milieu et laisser tourner.
- **NE JAMAIS mettre en pause** une campagne quelques jours puis reprendre : des comptes tombent pour ça `[34:46 · Ép06]`. Si pause budgétaire → descendre le budget (ex 100€ → 5€/j). Google travaille sur fenêtre 45/90 j ; couper = tout perdre.
- **Constance des paiements** : dépenser régulièrement avec bon ROAS → Google ouvre une fenêtre d'impressions qui convertit mieux ; couper après avoir été boosté → il ne redonne plus `[36:42 · Ép06]`.
- **Scaling par paliers de +15 à +30% max**, jamais d'un coup (témoignage : 30€→80€ = ban) `[37:43 · Ép06]` `[59:06 · Ép49]`. Sous 100€/j peu critique ; au-delà toute variation brutale est risquée.
- **Budget "quotidien" = plafond MENSUEL** (jour × 30,4). Certains jours +, d'autres −. Rattrapage post-déblocage normal `[41:36 · Ép49]`.
- **Subdiviser les produits** (Groupe d'annonces > Subdiviser par ID ou par "type") pour isoler les meilleurs ROAS/marges et les sortir en campagne dédiée `[51:51 · Ép49]`. Renseigner le champ **"type"** dans les fiches Shopify pour piloter par segment `[52:08 · Ép49]`.
- **Structure de scaling** : 1 campagne BEST-SELLERS (grosses marges) à scaler + 1 campagne SUPPORT (break-even). Bien segmenter par mot-clé/produit `[75:36 · Ép69]`.

### 4.6 — Quality Score & marge

- **CPC réel = enchère × Quality Score** `[47:32 · Ép42]` `[16:54 · Ép49]`. Le QS est le cheat code qui fait baisser le CPC. 4 critères : pertinence (mot-clé dans annonce ET page : H1/title/contenu), CTR au-dessus des concurrents, qualité landing page (intention), historique compte.
- Vérifier le QS : Google Ads > campagne > Mots clés > Colonnes > cocher "Niveau de qualité", "CTR attendu" `[81:38 · Ép48]`. Viser 8-10/10.
- **Le SEO est la fondation du QS** : mot-clé dans H1 + title + contenu = critère pertinence coché. Mot-clé large → pointer vers une **COLLECTION** (meilleure intention) `[18:43 · Ép49]`.
- **CPA max admissible = la marge produit** `[16:30 · Ép49]`. Sur Shopping, piloter à la **MARGE** (remontée depuis Shopify) plutôt qu'au ROAS classique `[47:32 · Ép42]`. ROAS générique observé = 200-300% `[27:08 · Ép06]`.
- **Seuil de kill = dépend de la marge + l'enchère**, pas d'un montant fixe : produit 50€ + CPC 0,15€ + 300€ sans vente = problème ; high-ticket 800€ + CPC 1,50€ + 500€ sans vente = normal `[91:02 · Ép48]`. **Bon taux de conversion Shopping ≈ 1%** `[70:06 · Ép49]`.

### 4.7 — Promo & comptes

- **Bon promo Google : jusqu'à 1200€ offerts pour 800€ dépensés** (le seuil a augmenté) `[13:48 · Ép05]`. À activer à la création du compte Ads Brizea.
- Google détecte une re-création si **même site + mêmes données de facturation** → refuse le crédit/re-flag `[14:20 · Ép05]`. Brizea = nouveau compte distinct = OK.
- **GMC + Ads avec la MÊME adresse email** (cohérence) `[31:31 · Ép42]`. Green flag fort = email pro Workspace avec ancienneté `[31:34 · Ép42]`.
- **Vérification de l'annonceur** : à anticiper côté Google Ads (Admin > Facturation > option validation), à faire dès la création (Google laisse 5 j avant de couper les pubs) `[50:50 · Ép69]` `[83:37 · Ép47]`.
- **Astuce chauffe compte** : paiement manuel 5-10€ dès l'ouverture (Google ne prélève rien à l'ajout des infos, juste vérif 0€) `[51:26 · Ép69]`.

---

## 5. Tracking & attribution (Ép69 + Ép49 + Ép06)

### 5.1 — Non négociable : tracking AVANT tout lancement

- Sans balises de conversion = **diffusion à l'aveugle**, Google envoie du trafic au hasard `[05:31 · Ép49]`. Toute première étape.
- 3 balises e-commerce clés : **Achat** (principale, valeur dynamique), **Paiement initié**, **Ajout au panier** `[06:47 · Ép49]`. Mettre 2 balises Achat en secondaire comme sécurité.
- Via le canal Google sur Shopify (cocher la balise) → les 3 conversions remontent auto `[22:50 · Ép49]`. État "inactif" normal tant qu'aucune ad n'a tourné ; vérifier sur les 1res semaines que les ajouts panier remontent.
- Alternative GTM : balise déclenchée sur "URL contient `thank_you`" (page remerciement Shopify) `[24:39 · Ép49]`. À garder en sécurité.

### 5.2 — Astuce nourrissage algo au lancement

- Basculer **Ajout panier + Paiement initié en PRINCIPALES** mais **décocher la valeur dynamique** et fixer une valeur fixe artificiellement basse : ajout panier ≈ 0,05€, paiement initié ≈ 1,50€ `[25:19 · Ép49]`.
- Sinon Google voit que les ajouts panier "valent" la valeur produit dynamique et **optimise pour les ajouts panier au lieu des achats** `[25:19 · Ép49]`.
- Principale = optimise l'enchère ; Secondaire = observation seule `[27:15 · Ép49]`. D'où conversions intermédiaires en principale (signal pour l'algo neuf) MAIS valeur basse (l'achat reste prioritaire).

### 5.3 — Google Tag Gateway (GRATUIT — le plus gros gain tracking)

- Équivalent **server-side mais gratuit** : sert tes balises depuis ton propre domaine → script first-party → contourne le blocage cookies/ITP Apple `[00:19 · Ép69]`.
- **Jusqu'à +11% de conversions mesurées** `[04:44 · Ép69]` → nourrit mieux le Smart Bidding → meilleur ROAS. Perte réelle démontrée sans tracking : 600€ remontés vs 2000€ réels (~60-70% de perte) `[07:03 · Ép69]`.
- Setup : Google Ads > Outils > **Gestionnaire de données > Balise Google > onglet Admin > "Google Tag Gateway"** (fonction très cachée) `[09:43 · Ép69]`. Sur Shopify → via **Cloudflare** : Analyser le domaine (détecte Cloudflare) > se connecter.
- Étape technique : **changer les serveurs de noms (NS) du domaine vers Cloudflare** (plan gratuit = >100 000 requêtes) `[14:15 · Ép69]`. Shopify > Domaines > serveurs de noms personnalisés > coller les 2 NS Cloudflare.
- ⚠️ **Changer les DNS vers Cloudflare NE déclenche AUCUN ban/re-review GMC** : ce n'est pas une modif du CNAME ni du pointage du site, juste où tu stockes ta data `[17:51 · Ép69]`.

### 5.4 — GA4, Consent Mode, robustesse

- Activer **Enhanced Conversions** (améliore la précision des rapports) + son propre tracking (Data Layer/script vers GTM) + **Consent Mode V2** (obligatoire, cookies disparus) `[52:54 · Ép06]`.
- **GA4 ET Simprosys en parallèle**, GA4 importé en **Secondary Goal** : si une source saute, basculer Primary/Secondary en 2 s sans interrompre l'algo `[52:54 · Ép06]`.
- ⚠️ Avec Simprosys : **NE PAS activer son Consent Mode intégré** (fait sauter le tracking) ; le faire via GTM + banner RGPD `[50:50 · Ép06]`. Ne PAS installer le Canal Google EN PLUS de Simprosys (doublon de flux) `[23:18 · Ép69]`.
- Le tracking ne sert vraiment **qu'en enchères intelligentes** : en max-clics/CPC manuel, l'algo n'en a pas besoin (tu pilotes) `[22:33 · Ép69]`. Crucial dès "maximiser la valeur de conversion".
- **UTM sur l'URL de campagne** (source=google, medium=shopping/pmax) pour traquer dans Shopify l'origine de chaque clic `[48:53 · Ép49]`.
- **Audiences Shopify→Google Ads** : Gestionnaire de données > connexion directe Shopify (autoriser dans Shopify > Domaine) > cocher Audience. Plus besoin de Klaviyo. **Utilisable à partir de 1000 clients** `[35:35 · Ép49]`.
- Balise en "mauvaise configuration" → passe en "éligible" dès une vraie vente/ajout panier ; sinon déclencher via "Dépannage" + Tag Assistant `[53:24 · Ép69]`.

---

## 6. SEO Google (Ép48)

### 6.1 — Architecture 3 niveaux de mots-clés

- **Courte traîne** (mot principal, ex "ventilateur de plafond") → **page d'accueil** `[25:07 · Ép48]`.
- **Moyenne traîne** (ex "ventilateur de plafond silencieux", "ventilateur DC") → **pages COLLECTION**.
- **Longue traîne** (ex "ventilateur de plafond silencieux 132cm noir") → **pages PRODUIT**.
- **Prioriser la longue traîne au lancement** : faible concurrence, intention d'achat élevée, taux de conversion "monstrueux" `[33:11 · Ép48]`. En Shopping le produit ressort exactement sur ce mot-clé car il est dans le titre.

### 6.2 — Mots-clés grand public, pas jargon

- **Piège mortel** : nommer "expert" au lieu du terme grand public. Exemple réel : "quadricoptère" (590 rech/mois) au lieu de "drone" (135 000) = invisible `[23:44 · Ép48]`. Pour Brizea → **"ventilateur de plafond"** partout, pas de jargon technique seul.

### 6.3 — Balises

- **Meta Title = balise LA PLUS IMPORTANTE** : DOIT contenir le mot-clé, ~70 c, format "mot-clé + nom du site" (ex "Suspension rotin | Brizea"). Foirer le Meta Title = invisible partout. **Un seul mot-clé par page** `[50:46 · Ép48]`.
- **Meta Description ~160 c** : mot-clé + avantages concurrentiels (ex "Livraison offerte en France"). Pas d'impact SEO direct mais sur le CTR `[53:21 · Ép48]`. ⚠️ Google la réécrit souvent depuis ~3 ans (pioche dans la page) — pas un levier majeur `[52:18 · Ép69]`. Extension : "SEO Meta in One Click".
- **Structure HN** : 1 seul H1 unique = mot-clé principal (= Meta Title) ; H2 = mots-clés sémantiques + "pas cher" ; H3 = titres produits `[55:00 · Ép48]`. **Vérifier que le thème ne sorte pas "Mon panier" ou le footer en H2/H3** (tester avec SEO Meta in One Click).

### 6.4 — Images, maillage, contenu

- **Images SEO (sous-estimé en déco)** : 2 éléments comptent = **nom du fichier + balise ALT**. Format : `ventilateur-de-plafond-silencieux.jpg` + alt descriptif avec mot-clé, déclinaisons par image `[57:54 · Ép48]`.
- **Maillage interne** PDP→collections avec **ancre optimisée** ("Voir nos ventilateurs de plafond design"). Non pénalisé en interne. ⚠️ Pour les **backlinks externes**, ne PAS abuser des ancres optimisées (pénalité Pingouin) `[61:09 · Ép48]`.
- **Intention de recherche** : la bonne TYPE de page selon le mot-clé (collection vs produit vs article) `[34:08 · Ép48]`.
- **Contenu informationnel (blog top-funnel)** peut générer **80% des ventes SEO** sur certaines niches : "comment choisir", "X vs Y", "meilleur pour…" avec comparatif mettant son produit en avant `[35:49 · Ép48]`. ✅ Brizea : blog "Le Journal" déjà créé (DC vs AC, silencieux, choisir la taille…).
- **Contenu 100% IA = pénalisé** : créer la base IA PUIS retoucher à la main. Récurrence = critère : 1 article/mois min, 1/semaine idéal `[66:14 · Ép48]`.

### 6.5 — Économie SEO vs Ads

- Trafic SEO = **full marge** (non payé). Sur certaines boutiques SEO = 20% du CA mais **60-70% du résultat NET** `[72:48 · Ép48]`. Fondation long terme à poser dès le lancement ; Ads = test rapide + scaling.
- 3 piliers SEO : (1) Contenu (pertinence/qualité/unicité/intention) ; (2) Technique (thème rapide, structure HN/title) ; (3) Popularité (backlinks + mentions de marque) `[16:31 · Ép48]`.
- ⚠️ SEO 2025 : les critères "sociaux" (trafic hors Google, ex TikTok à millions de vues) deviennent déterminants. Pour un nouveau site, ne plus compter sur le SEO comme moteur principal (bonus 10-20% au mieux) `[58:06 · Ép69]`.

---

## 7. Actions BRIZEA immédiates (`pa7duq-jd.myshopify.com` / `brizea.fr`)

> Légende : **[MOI]** = faisable par l'IA dans le shop · **[OWNER]** = action Mathieu (OAuth / facturation / compte Google — jamais l'IA).

### 7.1 — Bloqueurs cohérence / misrepresentation (priorité absolue)

1. **[MOI/OWNER] Téléphone FR joignable = trou de concordance** : Brizea n'a **PAS de téléphone affiché**. Le GMC exige nom + tél + email + adresse identiques sur GMC = footer = page Contact `[09:51 · Ép04]` `[44:38 · Ép47]`. → Owner : obtenir un numéro (OnOff OK `[27:51 · Ép04]`) ; MOI : l'afficher au footer + page Contact + le déclarer au GMC à l'identique.
2. **[MOI] Délais de livraison harmonisés au RENDU LIVE** : déjà corrigés (`_fix-delivery.js` → expédition 24-72h / réception 3-8j partout), mais re-vérifier qu'aucun résidu "24-72h" agressif ou "5-10j" ne subsiste sur la home/PDP/FAQ/`/policies/`. **Délai d'acheminement doit rester < 10 j ouvrés** `[04:08 · Ép04]`. Recopier ces valeurs **exactes** dans la config livraison/retours du GMC `[58:49 · Ép47]`.
3. **[OWNER] Compléter l'entité légale** : RCS 935 076 471 présent, mais TVA / directeur de publication / téléphone manquants ; + nom du **médiateur de la consommation** (souscrire). Via `pageUpdate` ciblé — **ne PAS re-run `_legal-pages.js`** (écrase Kbis + recolor). Cohérence nom-shop = nom-entreprise dans la politique de confidentialité `[22:25 · Ép06]`.
4. **[MOI] Auditer + corriger TOUS les liens morts** : le footer a un "Préférences cookies" qui pointe `/policies/` en 404 + popover légal + liens FAQ/Contact/Suivi. Un seul 404 bloque le GMC `[26:44 · Ép04]` `[31:33 · Ép69]`. Crawler les 18 produits + pages + footer (Screaming Frog ou script), fixer chaque 404.
5. **[MOI] Maintenir 0 faux signal** : faux avis / sales-pop / Trustpilot / countdown / prix barré DÉJÀ retirés (passes 06-26/06-27, vérifié 0). **NE JAMAIS les réactiver** avant une vraie app d'avis avec de vrais avis `[14:55 · Ép42]` `[11:42 · Ép06]`. Garder `compareAt=0`.

### 7.2 — Feed produit (les 18 ventilateurs)

6. **[MOI] Images conformes** : auditer que la 1ère image de chaque produit = produit seul fond blanc sans logo/texte, OU appliquer le **hack ambiance** (ventilateur installé au plafond dans un salon) qui passe très bien pour la déco `[42:32 · Ép42]` `[43:36 · Ép42]`. Min 4 images. Vérifier 0 résidu logo concurrent (Sovala déjà nettoyé).
7. **[MOI] Titres feed = requête Shopping** : réécrire les 18 titres en longue traîne grand-public, **mot-clé en tête** : "Ventilateur de plafond silencieux DC 132cm Noir — Cygnéo" `[81:25 · Ép48]` `[10:24 · Ép06]`. Travail fait dans le **Meta Title Shopify** (pas le titre de page ni le GMC) `[17:01 · Ép06]`.
8. **[OWNER/SOURCING] GTIN/EAN fournisseur** : demander les codes-barres des 18 ventilateurs → avantage concurrentiel direct vs Leroy Merlin/Castorama à prix égal `[15:30 · Ép06]`. Sinon `identifier_exists:false` (déjà le cas, non bloquant).
9. **[MOI] Enrichir le feed (cheat code qualité)** : metafields specs par-produit — Ø cm, moteur DC/AC, nb pales, lumens, dB, couleur, matériau (attributs facultatifs en plus des obligatoires) `[46:46 · Ép42]`. ✅ Catégorie "Ceiling Fans" déjà 18/18.
10. **[MOI] Champ "type" Shopify** sur les 18 fiches (ex DC/AC, taille Ø, usage) pour subdiviser les campagnes par segment `[52:08 · Ép49]`.

### 7.3 — SEO / structure

11. **[MOI] Gap collections** : Brizea n'a que `best-sellers` + `frontpage`. Créer des **collections moyenne traîne** : "ventilateur de plafond silencieux", "ventilateur DC", "ventilateur design" `[25:07 · Ép48]` — gap SEO + Shopping + meilleure landing page pour le QS `[18:43 · Ép49]`.
12. **[MOI] Vérifier structure HN** : home cible "ventilateur de plafond" (H1), thème Horizon ne doit pas sortir footer/panier en H2/H3 (tester SEO Meta in One Click) `[55:00 · Ép48]`. ✅ 164 alt images déjà corrigées — maintenir la convention nom-fichier + alt `[57:54 · Ép48]`.
13. **[MOI] Renforcer le maillage interne** PDP→collections avec ancres "ventilateur de plafond [attribut]" `[61:09 · Ép48]`.

### 7.4 — Setup GMC + Ads (séquence OWNER)

14. **[OWNER] Compte Google + GMC DISTINCTS Brizea** : via canal Google&YouTube sur Shopify `pa7duq-jd` → crée un MC Brizea **séparé** (JAMAIS le MC Essantiel ni les Ads Windury — un store = un MC = un compte Ads = un domaine) + revendiquer brizea.fr + sync 18 produits. Email = `contact@brizea.fr` (Workspace = green flag) pour GMC **et** Ads `[31:31 · Ép42]` `[21:35 · Ép47]`.
15. **[OWNER] Naissance naturelle** : Search Console + `brizea.fr/sitemap.xml` sur le compte Brizea dédié, laisser indexer 1-2 sem AVANT d'ouvrir le GMC `[33:51 · Ép47]`. Les 8 articles du blog + pages aident au "site vivant".
16. **[OWNER] Respecter l'ordre** : infos entreprise GMC → domaine → politiques validées → site validé → flux `[02:38 · Ép04]`. **Ne rien modifier après connexion du feed** `[20:55 · Ép06]`.
17. **[OWNER] Checkpoint validation réelle** : taper `brizea` dans Google → onglet **Shopping** (pas Images), attendre que les fiches y ressortent = feu vert `[63:43 · Ép49]` `[47:34 · Ép69]`. **NE lier le GMC à Google Ads qu'une fois les 18 produits tous en VERT depuis 24h** `[25:34 · Ép04]`.
18. **[OWNER] Vérification de l'annonceur** dès la création (Admin > Facturation), avec SIRET/TVA `[64:45 · Ép04]` `[50:50 · Ép69]`. Au déblocage Shopping → "vente de produits/marchandises en ligne", jamais "dropshipping" `[65:54 · Ép04]`.
19. **[OWNER] Promo Google** : activer le crédit (jusqu'à 1200€ pour 800€ dépensés) à la création `[13:48 · Ép05]`. Pré-charger 5-10€ pour chauffer `[51:26 · Ép69]`.
20. **[OWNER] Tag Gateway gratuit** : Gestionnaire de données > Balise Google > Admin > Google Tag Gateway via Cloudflare (changer les NS) → +11% conversions, zéro risque GMC `[09:43 · Ép69]` `[17:51 · Ép69]`. Activer Enhanced Conversions + GA4 en Secondary Goal `[52:54 · Ép06]`.

### 7.5 — Structure de campagne Brizea (au runbook `docs/google-ads-launch-runbook.md`)

21. **[OWNER] Tracking AVANT lancement** : cocher la balise conversion du canal Google → Achat (principale, valeur dynamique) + Ajout panier + Paiement initié (principales, **valeur fixe basse** 0,05€/1,50€) `[25:19 · Ép49]`.
22. **[OWNER] Shopping standard all-products** en "Maximiser les clics" + CPC max manuel (fourchette haute du Keyword Planner) `[44:54 · Ép49]` + **Search exact-match** intentionniste + **brand campaign "Brizea"** Taux d'impression 100% (quasi gratuite) `[68:33 · Ép49]`. Ciblage France en "Présence" uniquement.
23. **[OWNER] Bloquer YouTube** par formulaire si pas de vidéo `[47:17 · Ép06]`. Pas de PMax seule au lancement `[61:38 · Ép49]`.
24. **[OWNER] Enchères** : aucun objectif → 30-50 conversions → puis "Maximiser la valeur de conversion" `[56:55 · Ép06]`. Combiner ROAS cible + plafond CPC au niveau compte `[37:32 · Ép49]`. **NE JAMAIS pauser** (descendre à 5€/j si besoin) `[34:46 · Ép06]` ; scaler par +15-30% `[37:43 · Ép06]`.
25. **[OWNER/SOURCING] Gate marge = bloqueur budget** : le CPA max = la marge nette réelle `[16:30 · Ép49]`. **Confirmer le landed-cost fournisseur** avant de scaler — sans lui, le seuil de kill et le ROAS break-even ne sont pas calculables. Le gate marge Brizea est tendu (CPC ≤ 0,46€ à 65% de marge) → le QS élevé (PDP riches) aide à baisser le CPC réel `[47:32 · Ép42]`.

### 7.6 — Verdicts stratégiques à garder en tête

- ⚠️ **Shopping risqué Phase 1** : SERP ventilateur saturée d'institutionnels (Leroy Merlin/Castorama/Conforama/Darty/Amazon/ManoMano/Cdiscount) → canal le plus viable = **Search exact-match**, différer Shopping. Cohérent avec le verdict du runbook existant.
- ⚠️ **Ignorer le CSS au lancement** : mythe (-20% CPC réfuté par test, Ép42) ; même contre-productif (ré-apprentissage GMC neuf) `[29:55 · Ép42]`. Réévaluer un CSS FR (type Feedcast) seulement plus tard si on veut tester, et **jamais sur le store phare en 1er** `[26:05 · Ép05]`.
- ⚠️ **Produits = placeholders clonés d'alizefans** : créer 6-8 produits ORIGINAUX (descriptions 100% uniques, zéro duplicate content) `[80:34 · Ép47]` avant de scaler — critère le plus surveillé pour les boutiques similaires.
- ✅ **Éditions post-validation sûres** : une fois le GMC passé, on peut génériciser les specs PDP hardcodées Onyx + ajuster les claims SANS risque de ban (seuls 1re image + titre sensibles au début) `[30:35 · Ép69]` — à faire APRÈS validation, pas avant.
- ✅ **Lancer avant le pic été** (saisonnier mai-août) ; idéalement hors période de contrôle renforcé Q4/fin d'été `[37:32 · Ép42]`.

---

*Fin de l'index. Sources : Ecom Boss lives 04 (setup GMC A-Z Sébastien), 05 (Feedcast/CSS), 06 (Maxime Bédé), 42 (expert 250M€), 47 (Tristan déblocage/naissance), 48 (Tristan SEO), 49 (structure Ads), 69 (Tag Gateway/tracking).*
