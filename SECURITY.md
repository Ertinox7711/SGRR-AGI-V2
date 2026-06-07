# Politique de sécurité

GitHub reconnaît ce fichier comme la politique de sécurité du repo.

➡️ **Le modèle de menace complet, les garanties et la checklist sont dans
[`SECURITE.md`](SECURITE.md).**

## Signaler une vulnérabilité / une fuite

Tu as repéré un secret oublié, un email, un chemin perso, ou tout autre donnée
identifiante qui aurait dû être scrubbée ?

1. **Ne recopie pas la valeur sensible** dans une issue publique — décris l'endroit
   (fichier, ligne), pas la valeur.
2. Ouvre une issue privée (Security advisory) ou contacte le mainteneur.
3. La donnée trouvée doit être **purgée de tout l'historique git**, pas seulement du
   dernier commit.

Le repo est protégé en continu par `gitleaks` (GitHub Actions, à chaque push), un hook
`pre-commit`, et le script `scripts/preflight-scrub`. Si l'un d'eux a laissé passer
quelque chose, c'est un bug à corriger.
