---
name: pdf-titre
description: Change le titre d'un PDF (métadonnées /Title et XMP dc:title) par update incrémental — AUCUN octet existant n'est réécrit, donc rien ne casse. Backup automatique + vérification (re-parcours xref + pdftotext). Usage : node pdf-titre.mjs <fichier.pdf> "Nouveau titre".
---

# pdf-titre — modifier le titre d'un PDF sans rien casser

## Quand l'utiliser
- L'utilisateur demande de changer le titre affiché d'un PDF (barre de titre du lecteur, Explorateur Windows, Adobe, Chrome…).
- On veut modifier ~/Title et le XMP dc:title **sans ré-encoder le PDF** (aucun risque de casser polices, mise en page, liens, images).

## Comment
```bash
node ~/.claude/skills/pdf-titre/pdf-titre.mjs "Chemin/vers/fichier.pdf" "Nouveau titre"
```
- Travaille **sur le fichier en place** : un update incrémental est simplement *ajouté à la fin* (mécanisme officiel PDF) — les 100 % d'octets d'origine restent intacts.
- Backup automatique : `<nom>.backup-pdf-titre.pdf` à côté du fichier.
- Vérif automatique : re-parcours de la chaîne xref comme un lecteur (le titre résolu doit être exactement celui demandé) + `pdftotext` si disponible.

## Ce qui est géré
- Fichiers Word 2024 (table classique + section finale vide avec `/Prev`, objet-streams, XMP optionnel).
- PDF générés par bibliothèques (xref **stream** `/Type/XRef` + catalogues/Info dans des **obj-streams**).
- Titres ASCII ou accentués (UTF-16BE si nécessaire), `<`, `&`, `>` échappés dans le XMP.

## Ne PAS faire
- Ne jamais ré-écrire un PDF entier (pdftotext n'est pas un éditeur ; exiftool ne modifie pas l'Info ; pad de `/Title` changeant la longueur sans recalculer la xref corrompt le fichier).
- Ne jamais point-à-point écrire les offsets manuellement : toujours recalculer depuis la fin du fichier réel.
- Si le script dit « xref stream non supporté » (vieille version) → mettre à jour le script depuis `.freebuff/pdf-titre.mjs` du projet Formation-SGRR.
- PDF chiffrés : non gérés (Erreur).