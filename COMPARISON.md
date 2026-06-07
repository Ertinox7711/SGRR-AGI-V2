<div align="center">

# ⚔️ SGRR AGI V2 vs the Claude Code Ecosystem

**How we outclass the competition.**

</div>

Dozens of "Claude Code config" repos exist on GitHub. Most are
**directories** (link lists) or **catalogues** (pick your agents manually).
None delivers the **integrated package** you install in a single prompt: config + behavior
+ memory + **anti-leak security pipeline**. Here's the lay of the land (June 2026),
ranked from most starred to most niche.

---

## 📊 Comparison table

| Repo | ⭐ (order of magnitude) | What it offers | What it lacks vs SGRR AGI V2 |
|------|----------------------|----------------|-------------------------------|
| **[shanraisshan/claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice)** | ~50k | Best-practice reference: skills, subagents, hooks, commands — the most starred repo in the ecosystem | No 1-prompt install; no secret anti-leak pipeline; no AGI behavioral philosophy; no author anonymization; English only |
| **[hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)** | ~45k | Exhaustive "awesome" list: skills, hooks, slash-commands, orchestrators, plugins, MCPs | Read-only directory; **nothing to install**; no opinionated coherence or security guardrails; no deliverable `settings.json` or `CLAUDE.md` |
| **[wshobson/agents](https://github.com/wshobson/agents)** | ~36k | Multi-harness marketplace: 84 plugins, 192 agents, 156 skills, 102 commands | No `settings.json`, no philosophy; no secret scanning; fragmented install; no dedicated security layer |
| **[davila7/claude-code-templates](https://github.com/davila7/claude-code-templates)** | ~27k | CLI + aitmpl.com dashboard, 400+ components (agents, hooks, settings, MCPs) | A-la-carte catalogue without unified philosophy; no secret scan; multi-step setup; no "proactive AGI" layer; English only |
| **[VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)** | ~8-20k | 100+ specialized subagents (frontend, backend, DevOps, OWASP security, data/ML) | Collection of `.md` files with no global scaffold; no 1-prompt install; no opinionated `settings.json` or memory system |
| **[Pimzino/claude-code-spec-workflow](https://github.com/Pimzino/claude-code-spec-workflow)** | ~3.6k | Spec-driven workflows: Requirements → Design → Tasks → Implementation | Covers **only** the dev workflow; no `settings.json`, no security, no memory, no AGI behavior |
| **[disler/claude-code-hooks-mastery](https://github.com/disler/claude-code-hooks-mastery)** | ~2-3k | Hooks mastery: lifecycle, Meta-Agent, team validation, TTS feedback | Pedagogical/demo, not a production scaffold; no secret scan; no turnkey install |
| **[centminmod/my-claude-code-setup](https://github.com/centminmod/my-claude-code-setup)** | ~1k | Template + memory bank (`.md` files) for cross-session context | macOS-centric; no gitleaks or preflight scrub; no anonymization; manual install |
| **[0xfurai/claude-code-subagents](https://github.com/0xfurai/claude-code-subagents)** | ~0.5k | 100+ production-grade dev subagents | Agent `.md` files only; zero orchestration, settings, or security pipeline |
| 🏆 **SGRR AGI V2** | *(new)* | `settings.json` with guardrails + cost-efficient Sonnet subagents · `CLAUDE.md` **proactive AGI** philosophy · injection hooks (**tips every turn**) · file-based memory system · lazy `paths:` rules · 12-plugin manifest · **integrated security pipeline** (gitleaks CI + pre-commit hook + preflight scrub + anonymized author) · **1-prompt install** · **parity self-test** · **native English** | — |

---

## 🔥 Why we outclass them

- **End-to-end security pipeline — unique in the ecosystem.** No competitor combines
  gitleaks in CI + a blocking pre-commit hook + a `preflight-scrub` script that
  catches personal data *before* the push + an anonymized git author. Result: you
  share your setup **publicly** without leaking tokens, email addresses, or file paths.
  Everyone else publishes their dotfiles and crosses their fingers.

- **1-prompt install, for real.** One `git clone` + one pasted prompt = a complete,
  working environment (settings, `CLAUDE.md`, hooks, memory, rules). The most popular
  alternatives (wshobson, davila7) send you through a 200-400-item catalogue to
  copy-paste by hand.

- **A behavioral philosophy, not just a file collection.** The `CLAUDE.md` encodes a
  *way of operating*: maximum proactivity, parallelization, verify-before-done,
  zero hedging, structured auto-memory, **tips + next-step proposals every turn**. Others
  ship artifacts; we ship an **agent that behaves** like an AGI.

- **Opinionated `settings.json` with real guardrails.** Granular permissions, model
  routing (Sonnet for subagents = **bill ÷5**), active injection hooks. Most repos have
  **no `settings.json` at all**.

- **Parity self-test.** A script verifies your install is **identical** to the original
  rig — not "close enough." Nobody else guarantees reproducibility.

- **Native English — an underserved market.** The entire ecosystem is anglophone. This
  is the only Claude Code scaffold built with English as a first-class concern.

- **Security codified in behavior.** Refusals (credential theft, malware,
  mass-targeting) live inside `CLAUDE.md` and **resist prompt injections via config
  files** — a real, documented threat vector. No competitor addresses this.

---

> **A note on star counts.** shanraisshan (~50k⭐) and hesreallyhim (~45k⭐) dominate
> in visibility, but they provide a *reference* and a *directory* — neither delivers
> the **security + install + behavior** package. Popularity measures discoverability,
> not operational depth. Figures are **orders of magnitude** (June 2026) and shift over
> time; we cite the category, not the decimal.

<div align="center">
<sub>Built by <b>SGRR</b> · <code>SGRR AGI V2</code></sub>
</div>
