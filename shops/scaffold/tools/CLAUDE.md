# tools/ — Outils locaux (__SHOP_NAME__)

Petits outils qui tournent en local (jamais déployés) : dashboard de marge, visualiseur de catalogue, comparateur de prix…

Conventions :
- Node sans dépendance quand c'est possible (serveur HTTP natif), sinon dépendance justifiée dans le README de l'outil.
- Un outil = un sous-dossier + un `start.bat` + un port fixe déclaré dans `.claude/launch.json` (le lancer via `preview_start`, jamais via un shell en tâche de fond).
- **Lecture seule sur le store** par défaut. Un outil qui mute passe par `scripts/lib/shop.js` (garde d'identité + `requireGo`).
- Les commandes réelles nécessitent les scopes `read_orders` + `read_customers` : à demander dès la création de l'app, sinon il faut republier une version + re-consentir.
