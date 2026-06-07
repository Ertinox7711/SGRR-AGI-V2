---
paths: ["**/mon-projet/**"]
---
# Règle de projet exemple (chargement paresseux)

Ce fichier se charge dans le contexte **uniquement** quand Claude lit ou édite un
fichier dont le chemin matche le glob `paths:` ci-dessus — contrairement à
`CLAUDE.md`, qui se charge à chaque session.

Utilise ce patron pour garder l'autonomie spécifique d'un projet hors de ton contexte global :

- Un fichier de règle par projet, scopé par `paths:`.
- Mets ici les instructions « comment se comporter dans CE projet » (commandes de build,
  étapes de deploy, contraintes métier, pointeur vers la mémoire maître).
- Ton `CLAUDE.md` global reste léger et universel.

Remplace `mon-projet` ci-dessus par le vrai nom de ton dossier projet, et réécris le
corps ci-dessous pour ce projet.

## mon-projet — autonomie

- Lis le `CLAUDE.md` de ce projet d'abord, s'il existe (mémoire maître).
- Autonome de bout en bout : déduis l'intention, agis. Confirme seulement le
  destructif + le visible-aux-autres.
- Vérifie avant « fait » : run le build / les tests, lis le diff.
