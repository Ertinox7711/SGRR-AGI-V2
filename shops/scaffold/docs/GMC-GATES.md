# GATES LÉGAUX & GOOGLE MERCHANT CENTER — __SHOP_NAME__

> La cause n°1 de suspension Merchant Center est la **misrepresentation** (déclaration trompeuse) : suspension **au niveau du compte**, sans préavis, qui se propage à Google Ads. Ces gates s'appliquent au **rendu visible**, pas au code : si un visiteur peut le lire, c'est une déclaration.
>
> Ces règles recoupent le droit français (DGCCRF, pratiques commerciales trompeuses, directive Omnibus sur les prix barrés) — donc elles restent vraies même sans Google.

## Gate 1 — Preuve sociale : vraie ou absente

| Interdit | À la place |
|---|---|
| Avis inventés, noms/villes générés, « Achat vérifié » posé à la main | Une app d'avis réelle (Loox, Judge.me) **dès 0 avis**. Zéro avis = parfaitement sûr. |
| Note agrégée hardcodée (« 4,8/5 · 250 avis ») | Note calculée par l'app, ou rien |
| Wordmark ou visuel d'une plateforme d'avis (Trustpilot…) sans compte ni flux réel | Rien, ou le vrai widget de la plateforme |
| Compteur « N personnes regardent ce produit », faux achats en pop-up | Rien (ou basé sur de vraies commandes) |

⚠ Piège vécu : masquer le *wordmark* d'une plateforme ne suffit pas — la **jauge d'étoiles** et la **citation** rendues par un autre bloc restent visibles. Auditer le **rendu**, élément par élément.

## Gate 2 — Prix

- Un `compareAt` (prix barré) doit correspondre à un **prix réellement pratiqué** : en UE, le prix de référence est **le plus bas des 30 derniers jours**. Un `compareAt` inventé = faux rabais.
- Le prix affiché doit être **exactement** celui du checkout (TTC, devise correcte).
- Pas de « à partir de » qui masque le vrai prix, pas de frais surprise après le panier.

## Gate 3 — Allégations produit

- **Zéro chiffre non sourcé** : puissance, décibels, débit, autonomie, économies, pourcentages. Si la fiche fournisseur ne le dit pas, ça ne s'écrit pas.
- **Zéro fausse matière** (« bois massif » sur du plastique effet bois) : c'est une allégation trompeuse, pas une préférence de copy. Vérifier **à l'œil** sur la photo.
- Les économies/comparaisons doivent porter leurs **hypothèses** (« sur la base de X h/jour à Y €/kWh ») et rester qualitatives si l'hypothèse est fragile.
- **Garantie** : la garantie légale de conformité (2 ans, art. L217-3) est un droit, pas un argument commercial exclusif. Ne pas vendre comme « offert » ce qui est obligatoire.

## Gate 4 — Urgence & rareté

- Pas de compte à rebours qui se réinitialise à chaque visite en prétendant être une fin de promotion réelle.
- Pas de « plus que 3 en stock » si le stock n'est pas suivi.
- Une promotion doit avoir une **vraie** date de fin.

## Gate 5 — Marques tierces

- Aucun logo, nom ou visuel de marque tierce laissant croire à un partenariat, une certification ou une recommandation.
- Aucune image, vidéo ou description copiée d'un concurrent (droit d'auteur **et** misrepresentation).
- Le `vendor` du produit = la marque de la boutique, jamais le fournisseur ni un concurrent (il fuite dans le JSON-LD, l'analytics et les cartes de recommandation).

## Gate 6 — Transparence exigée par Google

- **Coordonnées** : email professionnel (au minimum) visible et fonctionnel + page Contact.
- **Politiques accessibles** depuis chaque page : retours/remboursement, livraison (délais **réalistes**), confidentialité, CGV, mentions légales avec l'entité réelle.
- **Cohérence** : le même délai de livraison et la même politique de retour partout (home, PDP, FAQ, page dédiée). Une divergence = signal de misrepresentation.
- Site **crawlable** : pas de mot de passe storefront, produits accessibles sans compte.

## Gate 7 — Feed produit

- Titres sans texte promotionnel (« -50 % », « LIVRAISON GRATUITE »), sans MAJUSCULES criardes.
- Images ≥ 500 px, produit visible, **sans watermark ni texte incrusté**.
- `identifier_exists: false` si le produit n'a ni GTIN ni MPN (c'est légitime — ne pas inventer un GTIN).
- Catégorie Google (taxonomie) renseignée, prix et disponibilité synchronisés.
- Parité stricte entre le feed et la page produit (prix, dispo, titre).

## Procédure avant toute soumission / campagne

1. Crawl du **rendu** de toutes les pages (home, PDP, collection, pages, articles) → chercher : notes, « avis », « vérifié », prix barrés, compteurs, marques tierces, chiffres non sourcés.
2. Chaque signal trouvé : le tracer jusqu'au bloc qui le rend (Admin API = autorité) et le désactiver **à la source**, avec backup et `--revert`.
3. Re-crawl après purge de cache, sur une page **non cachée** (PDP) pour éviter un faux positif de cache.
4. Consigner dans le journal de `CLAUDE.md` : ce qui a été retiré, ce qui reste **assumé** par the operator (une décision explicite est une décision valide — elle doit juste être écrite).

> Un signal retiré aujourd'hui peut revenir demain si un push réintroduit une version ancienne d'une section. Après tout push massif : re-passer le gate 1 et 3.
