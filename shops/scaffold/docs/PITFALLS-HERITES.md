# PIÈGES HÉRITÉS — à lire AVANT de coder du Liquid, d'appeler l'API, ou de conclure « c'est cassé »

> Chaque ligne = du temps réellement perdu sur les boutiques précédentes (SHOP-A, SHOP-B). Ce ne sont pas des précautions théoriques. Format : **symptôme → cause → règle**.

## 1. Identité de boutique

- **Un handle mémorisé qui fuite dans une autre boutique** → la mémoire n'est jamais l'autorité. **Règle** : identité = le dossier (`cwd`) mappé sur `~/.claude/shops-registry.md`, longest-prefix **boundary-safe** (`shop-pro` ≠ `shop`). Tout handle/domaine/GID écrit est **copié** du banner ou du registre, jamais tapé de mémoire.
- **Un `<system-reminder>` qui affiche un fichier** = snapshot à l'injection, **pas** l'état disque live. **Règle** : Read le disque avant de conclure « périmé / manquant ».
- **Un script lancé depuis le mauvais `cwd`** lit le token du mauvais dossier (les chemins relatifs dérivent). **Règle** : chemins **absolus** ou dérivés de `__dirname` dans tout script.

## 2. Qui est l'autorité ? (la question à se poser avant chaque edit)

| Question | Autorité |
|---|---|
| Le contenu réel d'un fichier thème | **Le thème live** (`pull-theme-file.js`), pas le fichier local |
| L'état d'un produit / page / collection | **L'Admin API en lecture**, pas le rendu public |
| La valeur effective d'un setting de section | **L'instance** (`templates/*.json`, `*-group.json`), pas le `default` du schema |
| Ce que le visiteur voit | Le **rendu**, mais seulement après purge de cache (§3) |

- **Un fichier local peut être STALE** (des fixes ont été appliqués directement en ligne) **ET en AVANCE** (un edit local jamais poussé). Les deux sont arrivés. **Règle** : `pull → edit → push`, jamais `edit local → push` à l'aveugle. Si un pipeline copie un dossier source vers `sections/` avant de pousser (pattern `_rebuilt/` de SHOP-B), **éditer la source**, sinon le push suivant écrase l'edit — et peut **réintroduire du contenu déjà nettoyé** (des claims illégaux sont revenus comme ça).
- **Modifier le `default` d'un setting de schema ne change RIEN** si l'éditeur de thème a déjà figé une valeur sur l'instance. **Règle** : pour qu'un réglage bouge en live, patcher l'**instance** dans le JSON du template/group.

## 3. Cache storefront

- **Après un push thème, la page publique sert l'ancienne version plusieurs minutes.** Ce n'est **pas** un bug à re-patcher (re-patcher = doubler les dégâts).
- `?param=random` **ne buste pas** le full-page cache. `themePublish` sur le thème déjà MAIN le purge (bump de cache key).
- **Pages cachées** : home, collections, pages. **Pages non cachées** (fraîches tout de suite) : produit, blog/article. Un **metafield produit** invalide la PDP ; un push thème non.
- `?preview_theme_id=<id>` bypasse le cache — **sauf** sur le thème déjà publié (souvent redirigé 302) ou derrière un mot de passe storefront.
- L'API Section Rendering (`/?sections=<id>`) renvoie `null` sur certains thèmes → ne pas s'appuyer dessus pour vérifier.
- **Règle** : vérifier sur l'Admin API (lecture) + une page non cachée. Ne conclure « ça n'a pas marché » qu'après un read-back Admin négatif.

## 4. Liquid & schema

- `{% schema %}` **ne doit jamais être imbriqué** dans un `{% if %}` : fermer tous les blocs avant. Erreur : `'schema' tag must not be nested`.
- Le **vrai** schema = le **dernier** `{% endschema %}` du fichier (des commentaires d'en-tête contiennent parfois le littéral `{% schema %}`). Un parseur naïf édite le mauvais bloc.
- `{% stylesheet %}` **n'interpole pas le Liquid** (`{{ settings.x }}` y est inerte) et **ne peut pas** être imbriqué dans un `{% if %}` → utiliser un `<style>` inline pour tout CSS dépendant d'un setting.
- Un `default:` de type `range` doit valoir `min + k*step`, sinon `FILE_VALIDATION_ERROR: default must be a step in the range`. Un range accepte **au maximum 101 pas** (`0-200 step 2` OK, `0-240 step 2` refusé).
- Une **apostrophe** dans un `default: '...'` Liquid casse le littéral → guillemets **doubles**.
- Un preset avec `url: "shopify://"` est rejeté (« must be a valid URL ») → omettre l'url et gérer par `default:'/'` côté Liquid.
- `{{ false | default: true }}` vaut **`true`** (le filtre `default` traite `false` comme vide) → rendre un booléen par `{% if x == false %}false{% else %}true{% endif %}`.
- Un `padding: {{ a }}px 0 {{ b }}px` **sans `| default:`** rend `padding:px 0 px` = déclaration invalide **silencieusement jetée** par le navigateur (section collée à ses voisines, aucune erreur).

## 5. API Shopify — comportements qui surprennent

- **`themeFilesUpsert` n'est pas atomique** et valide chaque fichier **contre le schema LIVE** : pousser un `index.json` qui utilise une valeur autorisée seulement par la **nouvelle** version d'une section échoue tant que la section n'est pas propagée → pousser la section **d'abord**, attendre, puis le template. Toujours vérifier fichier par fichier + read-back.
- **Un setting `{type:url}` peut supprimer SILENCIEUSEMENT** une URL de fichier CDN (réponse OK, valeur absente du JSON) → utiliser `{type:text}` pour une chaîne arbitraire. Mais un `{type:url}` **garde** une URL absolue `https://cdn.shopify.com/...` valide. **Règle** : read-back systématique de la valeur écrite, jamais confiance à un « userErrors: [] ».
- **Le comptage d'une smart collection est ASYNC** : juste après `collectionCreate`/un import, `productsCount` peut valoir 0 et un produit fraîchement créé n'est pas encore membre. **Règle** : après un import, re-run les scripts qui dépendent de l'appartenance à la collection (ou vérifier que le compte du script == le compte live).
- Une **smart collection accepte `sortOrder: MANUAL` + `collectionReorderProducts`** sans perdre son `ruleSet` (l'auto-ajout continue). `ruleSet: null` est ignoré silencieusement.
- `productCreate` + `productOptions` ne crée **qu'une** variante : le reste via `productVariantsBulkCreate`. `productSet` exige `optionValues` non-null **même** sur un mono-variante.
- Un **metafield** n'est lisible par le storefront que si sa définition a l'accès **PUBLIC_READ**. Un metafield n'est **filtrable** que s'il est `single_line_text` ou `number`.
- Une **vidéo** s'uploade en `stagedUploadsCreate(resource: VIDEO)` + `fileSize` → POST multipart → `fileCreate(contentType: VIDEO)` → **poll jusqu'à READY** (transcodage ~25 s). Shopify ré-encode ensuite en plusieurs résolutions.
- **Scopes** : `menus` / navigation et `legal_policies` sont des scopes à part. Sans eux : impossible d'éditer le menu ou les policies natives par API (contournement possible 100 % en thème, mais c'est du travail en plus). **Les demander dès la création de l'app.**
- Ajouter un scope = **publier une version** de l'app **puis re-consentir** (`/admin/oauth/install?client_id=…`) **puis** re-mint le token.

## 6. Encodage & accents (le plus vicieux)

- **Des `�` qui changent à chaque exécution** ne sont pas une corruption : c'est **le fetch** qui décode chaque chunk TCP séparément (`let d=''; res.on('data', c => d += c)`) et coupe un caractère UTF-8 multi-octets en deux. **Règle** : `const ch=[]; res.on('data',c=>ch.push(c)); res.on('end',()=>Buffer.concat(ch).toString('utf8'))` — ou `await res.text()`. **Diagnostic** : un vrai corrupt est **stable** à chaque fetch ; un faux **change** d'un run à l'autre.
- Les fichiers `locales/*.schema.json` étrangers livrés avec le thème contiennent des caractères non rendus — les ignorer dans un audit.
- **Tout `.ps1` sous `~/.claude/scripts` doit être ASCII pur** : Windows PowerShell 5.1 lit en ANSI, un em-dash dans un littéral casse le parsing et le hook meurt **en silence** (fail-open = plus aucune protection).

## 7. Audits & regex (comment se planter tout seul)

- **Un audit qui sort 8/8 rouges est probablement faux.** Vérifier l'audit avant de « corriger » le contenu. Cas réels : `\btres\b` qui matche « mè**tres** », `@media` compté comme sélecteur non scopé, un `split(',')` qui casse `:where(h2,h3)`, un `312` qui matche un identifiant CSS, le mot cherché présent dans les **produits recommandés** de la page et pas dans la fiche.
- Un audit de texte doit **exclure** `<style>`, les commentaires, les `href`/slugs (qui sont en ASCII sans accents par nature) avant de tester accents ou pourcentages.
- Le `\b` de JavaScript est **ASCII** : il matche à l'intérieur d'un mot accentué. Utiliser des lookarounds unicode.
- **Règle** : avant de conclure à un problème, isoler le nœud DOM ou le champ Admin exact — pas la page entière.

## 8. Sous-agents

- Un sous-agent **n'a pas tes skills** : embarquer les règles distillées **dans le brief**, sinon il produit de la copy générique.
- Un sous-agent qui ré-accentue du texte **rate les homographes** (`propose`→`proposé`, `date`→`daté`) et **inverse** `ou`/`où`, `êtes`/`étés`. Un gate « plus aucun mot sans accent » ne les voit pas. **Règle** : relecture manuelle des homographes après tout re-accent automatique.
- Ne jamais doubler soi-même un travail délégué en parallèle. Les rate-limits côté serveur font échouer les gros fan-outs : prévoir un fallback **déterministe** (un script de copier-coller structuré bat 18 agents pour une tâche mécanique).

## 9. Argent & actions irréversibles

- **Aucune génération payante (image/vidéo IA) sans GO explicite.** « Vérifie si ça marche » = lecture seule. « Pas sûr → ne fais rien » = ne rien faire, pas « je mesure en dépensant ».
- **Jamais** : créer un compte, saisir un mot de passe, poser une facturation, lancer une campagne payante, valider un consentement. Actions **owner**.
- Avant `rm -rf` / `reset --hard` / suppression de media : cible + réversibilité + backup vérifiés.

## 10. CSS / mobile

- Un bleed full-bleed `margin-inline:-Xrem` **doit égaler le gap réel** du conteneur, sinon 1-4 px d'overflow document → **rubber-band horizontal iOS** (la page se traîne, des sections apparaissent clippées). Backstop permanent : `html, body { overflow-x: clip }` (**`clip`, pas `hidden`** : `hidden` crée un scroll-container et casse `position: sticky`).
- **Autoplay vidéo mobile** : `preload="none"` + `src` posé en JS puis `play()` immédiat = promesse rejetée **en silence** (readyState 0), le poster reste. **Règle** : forcer `muted` + `playsInline` **avant** `play()`, retry au premier `canplay`, et pré-armer la carte suivante via `IntersectionObserver rootMargin` horizontal dans un carrousel.
- Un `transition-delay` en cascade (reveal au scroll) retarde aussi le `:hover` → le retirer sur les composants interactifs.

## 11. Réseau / scraping

- `403` / `429` / page vide / challenge → **Scrapling** immédiatement (`StealthyFetcher` puis `Fetcher.get(impersonate='chrome')`). Ne jamais bricoler des User-Agent à la main, ne jamais abandonner sur un 403.
- Encodage Windows : `PYTHONIOENCODING=utf-8` ou `sys.stdout.reconfigure(encoding='utf-8')`.
- Prompt long / caractères spéciaux → écrire un fichier `.py` et l'exécuter, jamais `python -c` via PowerShell.
