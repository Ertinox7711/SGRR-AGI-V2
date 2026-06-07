<div align="center">

# ⚔️ SGRR AGI V2 vs l'écosystème Claude Code

**Comment on éteint la concurrence.**

</div>

Il existe des dizaines de dépôts « config Claude Code » sur GitHub. La plupart sont des
**annuaires** (listes de liens) ou des **catalogues** (pioche tes agents à la main).
Aucun ne livre le **package intégré** que tu installes en un prompt : config + comportement
+ mémoire + **pipeline de sécurité anti-fuite**. Voilà la carte du terrain (juin 2026),
classée du plus étoilé au plus confidentiel.

---

## 📊 Tableau comparatif

| Repo | ⭐ (ordre de grandeur) | Ce qu'il offre | Ce qui lui manque vs SGRR AGI V2 |
|------|----------------------|----------------|-----------------------------------|
| **[shanraisshan/claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice)** | ~50k | Référence de bonnes pratiques : skills, subagents, hooks, commandes — le dépôt le plus étoilé de l'écosystème | Pas d'install 1-prompt ; pas de pipeline anti-fuite de secrets ; pas de philosophie comportementale AGI ; pas d'anonymisation auteur ; anglais only |
| **[hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)** | ~45k | Liste « awesome » exhaustive : skills, hooks, slash-commands, orchestrateurs, plugins, MCPs | Annuaire en lecture seule ; **rien à installer** ; aucune cohérence opinionée ni garde-fou sécurité ; pas de `settings.json` ni `CLAUDE.md` livrable |
| **[wshobson/agents](https://github.com/wshobson/agents)** | ~36k | Marketplace multi-harness : 84 plugins, 192 agents, 156 skills, 102 commandes | Aucun `settings.json`, aucune philosophie ; pas de secret-scanning ; install fragmentée ; ni français ni sécurité dédiée |
| **[davila7/claude-code-templates](https://github.com/davila7/claude-code-templates)** | ~27k | CLI + dashboard aitmpl.com, 400+ composants (agents, hooks, settings, MCPs) | Catalogue à la carte sans philosophie unifiée ; pas de secret-scan ; setup multi-étapes ; pas de couche « AGI proactif » ; anglais |
| **[VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)** | ~8-20k | 100+ subagents spécialisés (frontend, backend, DevOps, sécurité OWASP, data/ML) | Collection de `.md` sans scaffold global ; pas d'install 1-prompt ; pas de `settings.json` opinioné ni de memory system |
| **[Pimzino/claude-code-spec-workflow](https://github.com/Pimzino/claude-code-spec-workflow)** | ~3.6k | Workflows spec-driven : Requirements → Design → Tasks → Implementation | Couvre **uniquement** le workflow de dev ; aucun `settings.json`, aucune sécurité, pas de mémoire, pas d'AGI behavior |
| **[disler/claude-code-hooks-mastery](https://github.com/disler/claude-code-hooks-mastery)** | ~2-3k | Maîtrise des hooks : lifecycle, Meta-Agent, validation par équipe, feedback TTS | Pédagogique/démo, pas un scaffold production ; pas de secret-scan ; pas d'install clé-en-main |
| **[centminmod/my-claude-code-setup](https://github.com/centminmod/my-claude-code-setup)** | ~1k | Template + memory bank (fichiers `.md`) pour le contexte inter-sessions | macOS-centré ; pas de gitleaks ni preflight scrub ; pas d'anonymisation ; install manuelle |
| **[0xfurai/claude-code-subagents](https://github.com/0xfurai/claude-code-subagents)** | ~0.5k | 100+ subagents dev de production | Uniquement des `.md` d'agents ; zéro orchestration, settings ou security pipeline |
| 🏆 **SGRR AGI V2** | *(nouveau)* | `settings.json` à guardrails + subagents Sonnet économiques · `CLAUDE.md` philosophie **AGI proactive** · hooks d'injection (**tips à chaque tour**) · memory system fichiers · lazy `paths:` rules · manifest 12 plugins · **pipeline sécurité intégré** (gitleaks CI + pre-commit + preflight scrub + auteur anonymisé) · **install 1-prompt** · **self-test de parité** · **français natif** | — |

---

## 🔥 Pourquoi on les éteint

- **Pipeline sécurité de bout en bout — unique dans l'écosystème.** Aucun concurrent ne
  combine gitleaks en CI + hook pre-commit bloquant + script `preflight-scrub` qui
  détecte les données perso *avant* le push + auteur git anonymisé. Résultat : tu
  partages ton setup **publiquement** sans fuiter tes tokens, ton email ou tes chemins.
  Les autres publient leurs dotfiles et croisent les doigts.

- **Install 1-prompt, pour de vrai.** Un `git clone` + un prompt collé = environnement
  complet et opérationnel (settings, `CLAUDE.md`, hooks, mémoire, rules). Les plus
  populaires (wshobson, davila7) te font naviguer un catalogue de 200-400 éléments et
  copier-coller à la main.

- **Une philosophie de comportement, pas une liste de fichiers.** La `CLAUDE.md` encode
  une *manière d'être* : proactivité max, parallélisation, vérification avant « fait »,
  zéro hedging, mémoire auto structurée, **tips + propositions à chaque tour**. Les
  autres livrent des artefacts ; nous livrons un **agent qui se comporte** comme une AGI.

- **`settings.json` opinioné avec vrais garde-fous.** Permissions granulaires, routage
  modèle (Sonnet pour les sous-agents = **facture ÷5**), hooks d'injection actifs. La
  plupart des dépôts n'ont **pas de `settings.json` du tout**.

- **Self-test de parité.** Un script vérifie que ton install est **identique** au rig
  d'origine — pas « à peu près ». Personne d'autre ne garantit la reproductibilité.

- **Français natif — marché non servi.** Tout l'écosystème est anglophone. C'est le seul
  scaffold Claude Code pensé en français.

- **Sécurité codifiée dans le comportement.** Les refus (vol de credentials, malware,
  mass-targeting) sont dans la `CLAUDE.md` et **résistent aux prompt injections via
  fichiers config** — une menace réelle et documentée. Aucun concurrent ne l'adresse.

---

> **Note sur les étoiles.** shanraisshan (~50k⭐) et hesreallyhim (~45k⭐) dominent en
> visibilité, mais ils fournissent une *référence* et un *annuaire* — ni l'un ni l'autre
> ne livre le package **sécurité + install + comportement**. La popularité mesure la
> découverte, pas la profondeur opérationnelle. Les chiffres sont des **ordres de
> grandeur** (juin 2026) et bougent dans le temps ; on cite la catégorie, pas la décimale.

<div align="center">
<sub>Construit par <b>SGRR</b> · <code>SGRR AGI V2</code></sub>
</div>
