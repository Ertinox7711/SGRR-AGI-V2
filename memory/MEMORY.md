<!--
  MEMORY.md — l'index de ta mémoire persistante, basée fichiers.
  Chargé dans le contexte à chaque session. UNE LIGNE par mémoire. Aucun contenu de mémoire ici.

  Chaque mémoire est son propre fichier dans ce dossier, avec un frontmatter :

  ---
  name: <slug-court-en-kebab-case>
  description: <résumé une ligne — sert à juger la pertinence au rappel>
  metadata:
    type: user | feedback | project | reference
  ---

  <le fait. Pour feedback/project, enchaîne avec des lignes **Why:** et **How to apply:**.
   Lie les mémoires liées avec [[leur-name]].>

  Types :
    user      — qui est l'utilisateur (rôle, expertise, préférences)
    feedback  — guidance sur ta façon de bosser (corrections + approches validées) ; inclus le pourquoi
    project   — travail en cours / objectifs / contraintes non dérivables du code ou du git
    reference — pointeurs vers des ressources externes (URLs, dashboards, tickets)

  Ajoute une ligne pointeur ci-dessous par mémoire :  - [Titre](fichier.md) — accroche
  Supprime ce bloc de commentaire dès que tu as de vraies mémoires.
-->

# Index Mémoire

<!-- Exemple (supprime quand tu en ajoutes des vraies) :
- [Commande de build](build-command.md) — le projet build avec `pnpm turbo build`, pas `pnpm build`
-->
