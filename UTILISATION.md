# 📖 Bien utiliser le rig — guide pratique

> Ce guide est **copié en local** pendant l'install, dans `~/.claude/SGRR-GUIDE.md`.
> Tu l'as donc toujours sous la main, même hors du repo. Ouvre-le quand tu veux
> tirer le maximum de ton Claude Code « SGRR AGI V2 ».

L'install te donne le **rig**. Ce guide te donne la **conduite**. Un agent puissant mal
piloté reste lent ; bien piloté, il bosse comme une AGI. Voilà comment.

---

## 0. Le réflexe en 10 secondes

1. Ouvre Claude Code **dans le dossier du projet** (pas un dossier random).
2. Donne **l'intention, pas la procédure** : « répare le bug de login », pas « ouvre
   tel fichier ligne 42 ». L'agent déduit, explore, agit.
3. Laisse-le **vérifier avant de dire fait** (il lance les tests/build tout seul).
4. À chaque réponse tu reçois un **💡 tip** + une **→ proposition** : sers-t'en, dis
   « oui » à ce qui t'intéresse, ça enchaîne.

---

## 1. Premier lancement — checklist (2 min)

Après l'install, dans Claude Code :

- `/plugin` → les **12 plugins** sont activés (superpowers, feature-dev, code-review,
  pr-review-toolkit, frontend-design, commit-commands, security-guidance, github,
  context7, playwright, typescript-lsp, caveman). Sinon `/plugin marketplace add
  JuliusBrussee/caveman` puis ré-active.
- `/help` → les skills apparaissent (brainstorming, debugging, TDD…).
- `/memory` ou ouvre `~/.claude/memory/MEMORY.md` → ton index mémoire (vide au départ).
- Lance le **self-test de parité** : `./scripts/verify-install.ps1` (Windows) ou
  `./scripts/verify-install.sh` (macOS/Linux). Tout doit être ✅.

Si les 4 passent, ton Claude est **au même niveau que le rig d'origine**. Pas « presque » :
identique.

---

## 2. La boucle de travail qui sort de l'AGI

| Étape | Ce que tu fais | Ce que le rig fait pour toi |
|------|----------------|-----------------------------|
| **Cadrer** | Décris l'objectif en 1-2 phrases | Process-skills (brainstorming) si le sujet est flou |
| **Explorer** | Rien | Sous-agents Sonnet explorent le code (pas chers, contexte isolé) |
| **Faire** | Valide la direction | Edits directs (acceptEdits), commits atomiques |
| **Vérifier** | Rien | Hook `Stop` force tests + `tsc` + check du non-commité |
| **Mémoriser** | Rien | Hook `PreCompact` sauve les faits durables avant compression |

Tu cadres et tu valides. Le reste est automatisé par la config.

---

## 3. Les leviers que 95 % des gens ratent

- **Parallélise.** Demande plusieurs choses indépendantes d'un coup → l'agent lance les
  outils/sous-agents **en parallèle**. C'est encodé dans `CLAUDE.md`, mais le formuler
  groupé (« fais A, B et C ») l'accélère encore.
- **Sous-agents = facture ÷5.** `CLAUDE_CODE_SUBAGENT_MODEL=sonnet` : la boucle qui
  *décide* reste sur Opus, le *grunt-work* (explorer, lire, reviewer) part sur Sonnet.
  Sur un gros chantier, énorme économie. Dis « lance un sous-agent pour explorer X ».
- **`/cost` et `/context`.** Surveille ta dépense et le remplissage du contexte. Quand
  le contexte se charge, l'auto-compact + le hook `PreCompact` préservent l'essentiel.
- **Mode plan.** Pour un gros refactor, demande un **plan d'abord** (« fais-moi un plan,
  ne code pas encore »). Tu valides, puis tu lâches l'exécution.
- **`effortLevel`** dans `settings.json` : `medium` par défaut. Monte-le pour du
  raisonnement profond, baisse-le pour du débit brut.

---

## 4. Mémoire — comment t'en servir

- **Sauve** : un feedback que tu redonnes souvent, un fait projet non dérivable du code,
  une URL/dashboard, ton profil. Un fait = un fichier dans `~/.claude/memory/`.
- **Ne sauve jamais** : ce que le code/git dit déjà (structure, conventions, log).
- Dis simplement « **mémorise que…** » et l'agent écrit le fichier + l'index `MEMORY.md`.
- Au démarrage de chaque session, le hook `SessionStart` rappelle de lire la mémoire.

---

## 5. Scraping / fetch qui bloque

Un `403` / `429` / page vide / challenge Cloudflare ? **Ne bricole pas de headers.**
Le rig a le réflexe encodé : bascule sur **Scrapling** (stealth fetch). Dis juste
« le fetch est bloqué, passe en Scrapling ». Install si besoin :
`pip install scrapling && scrapling install`.

---

## 6. Sécurité au quotidien

- Les commandes destructives (`rm`, `git reset --hard`, `git push --force`, `docker`,
  `kubectl`…) **demandent confirmation** automatiquement (`permissions.ask`). C'est le
  seul vrai garde-fou — la prose ne protège rien, le filet `ask` oui.
- Mets tes **secrets de machine** dans `~/.claude/settings.local.json` (gitignoré),
  jamais dans `settings.json` partagé.
- Avant de **partager ton propre setup** : lance `scripts/preflight-scrub.*`. Il scanne
  secrets + PII + auteur git. Voir [`SECURITE.md`](SECURITE.md).

---

## 7. Quand ça part en vrille

- **L'agent dérive / oublie la discipline ?** Normal sur une longue session — les hooks
  le re-cadrent chaque tour. Si besoin, rappelle l'objectif en une phrase.
- **Trop bavard ?** `/caveman full` → sortie terse. `/caveman lite` → intermédiaire.
  « stop caveman » → normal.
- **Une commande refuse de passer ?** C'est `permissions.ask` qui fait son boulot.
  Confirme, ou ajoute le pattern à `allow` si tu le fais 50× par jour.
- **Contexte plein ?** `/compact` manuellement, ou laisse l'auto-compact. La mémoire +
  le hook `PreCompact` gardent les faits durables.

---

## 8. Vérifier que ton Claude est « aussi intelligent que l'original »

Le rig garantit la **parité** — pas une approximation. Pour le prouver :

```
./scripts/verify-install.ps1     # Windows
./scripts/verify-install.sh      # macOS / Linux
```

Le script confirme : `settings.json` valide, Opus + sous-agents Sonnet, 12 plugins
activés, 4 hooks en place, `CLAUDE.md` chargé, mémoire + rules présentes. Si tout est
✅, ton agent applique **exactement** la même config et la même philosophie que le rig
de SGRR. Mêmes leviers, même comportement, même niveau.

---

> Construit par **SGRR** · `SGRR AGI V2`. Tu pilotes une réplique 1:1 — sers-t'en comme
> telle : intention claire, validation rapide, et laisse l'agent courir.
