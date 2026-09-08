# Hermes Skills Catalog — 220 skills réutilisables par Claude Code

> Compté le 2026-08-25 : `find ~/.hermes/skills -name SKILL.md | wc -l` = **224** (208 en `<catégorie>/<skill>/`, 14 imbriqués sous `mlops/<domaine>/<skill>/`, 2 à la racine). Le gateway Hermes en enregistre **214** dans l'autocomplete Discord `/skill`. L'ancien total « 205 » était déjà périmé avant cet ajout.
>
> **Copie publiée** : une catégorie privée (4 skills, workflows business perso) est retirée de ce fichier — 220 listés ici sur 224 sur disque. Le mécanisme et la méthode sont intacts ; seul le contenu perso ne sort pas du PC.

**Source** : `\\wsl.localhost\Ubuntu-22.04\home\YOU\.hermes\skills\` (WSL path `/home/YOU/.hermes/skills/`).
**Statut** : skills de l'agent Hermes (WSL), mais 100 % lisibles + applicables par Claude Code. Chacun = un `SKILL.md` (frontmatter + instructions/scripts).

## Réflexe (à chaque tâche, chaque session)

1. **Avant toute tâche non-triviale**, scanne ce catalogue : un skill Hermes matche-t-il (≥1 % de pertinence) ?
2. Si oui → **Read son `SKILL.md`** avant d'agir :
   ```bash
   wsl -- bash -lc 'cat /home/YOU/.hermes/skills/<categorie>/<skill>/SKILL.md'
   ```
   (ou via UNC : `\\wsl.localhost\Ubuntu-22.04\home\YOU\.hermes\skills\<...>\SKILL.md` avec Read).
3. Beaucoup de skills ont des fichiers compagnons (scripts `.py`/`.sh`, `references/`, assets) dans leur dossier — `ls` le dossier, lis ce qui sert.
4. Applique la méthode du skill. Skills de PROCESS d'abord (recon-avant-action, systematic-debugging, TDD, writing-plans), skills d'IMPLÉMENTATION ensuite.
5. Priorité d'ordre quand collision avec un skill Claude Code natif : instructions user > superpowers/Hermes process-skills > défaut. Le contenu FR spécifique à l'opérateur (social-media/, media/) gagne pour ses projets perso.

## Skills haute-valeur (raccourcis fréquents)

- **scraping / 403** → `research/scrapling`, `research/smart-scraper`, `social-media/api-sniff-flash`
- **X / Twitter persona** → `social-media/x-reply-game-reach`, `social-media/x-account-safety-multicompte`, `social-media/xurl`
- **vidéo / reels décodage** → `social-media/video-decoder-local`, `media/voir-visages-video`, `social-media/instagram-reel-understanding`
- **mains locales (Brave loggé + PC)** → `social-media/local-browser-pc-hands`, `social-media/sgrr-eyes-extension`
- **dé-IA image avant post** → `social-media/deia-image-anti-ia-label`
- **enquête côté sombre** → `social-media/claim-triage-investigation`, `social-media/tableau-liege-enquete`
- **question sur Claude / Claude Code / MCP / API Anthropic** → `autonomous-ai-agents/claude-stack` (hub) + corpus hors ligne `claude-doc search <regex>` — **jamais répondre de mémoire**

---

## apple (5)
- **apple-notes** — `apple/apple-notes` — Apple Notes via memo CLI : create, search, edit (macOS).
- **apple-reminders** — `apple/apple-reminders` — Apple Reminders via remindctl : add, list, complete.
- **findmy** — `apple/findmy` — Track Apple devices/AirTags via FindMy.app.
- **imessage** — `apple/imessage` — Send/receive iMessages/SMS via imsg CLI.
- **macos-computer-use** — `apple/macos-computer-use` — Drive macOS desktop en background (screenshot, souris, clavier) sans voler le curseur user.

## autonomous-ai-agents (25)
- **blackbox** — `autonomous-ai-agents/blackbox` — Déléguer du code à Blackbox AI CLI (multi-modèle + judge).
- **claude-code** — `autonomous-ai-agents/claude-code` — Déléguer du code à Claude Code CLI.
- **codex** — `autonomous-ai-agents/codex` — Déléguer du code à OpenAI Codex CLI.
- **hermes-agent** — `autonomous-ai-agents/hermes-agent` — Configurer/étendre/contribuer à Hermes Agent.
- **honcho** — `autonomous-ai-agents/honcho` — Mémoire Honcho cross-session, multi-profil, dialectic reasoning.
- **kanban-codex-lane** — `autonomous-ai-agents/kanban-codex-lane` — Codex CLI comme lane d'implémentation isolée sous Hermes Kanban.
- **opencode** — `autonomous-ai-agents/opencode` — Déléguer du code à OpenCode CLI.
- **openhands** — `autonomous-ai-agents/openhands` — Déléguer du code à OpenHands CLI (model-agnostic, LiteLLM).
- **claude-stack** — `autonomous-ai-agents/claude-stack` — HUB — toute la techno Claude, index + routage vers les 16 autres. À charger en premier.
- **claude-code-cli-runtime** — `autonomous-ai-agents/claude-code-cli-runtime` — CLI Claude Code : flags, sous-commandes, headless JSON, sessions, exit codes, auth.
- **claude-code-tools-and-loop** — `autonomous-ai-agents/claude-code-tools-and-loop` — Les 44 outils built-in, règles de permission, filtres de sous-agents, compaction, boucle agent.
- **claude-code-config-permissions** — `autonomous-ai-agents/claude-code-config-permissions` — settings.json, précédence, modes de permission, chemins protégés, sandbox.
- **claude-code-memory-context** — `autonomous-ai-agents/claude-code-memory-context` — CLAUDE.md, auto-memory, fenêtre de contexte, compaction, /rewind.
- **claude-code-extensibility** — `autonomous-ai-agents/claude-code-extensibility` — Skills, slash commands, sous-agents, hooks (31 events), plugins, marketplaces.
- **claude-code-internals** — `autonomous-ai-agents/claude-code-internals` — Ce qui se passe sous le capot : ~/.claude, transcripts, supervision, télémétrie.
- **claude-code-surfaces** — `autonomous-ai-agents/claude-code-surfaces` — CLI, desktop, web, mobile, IDE (VS Code/JetBrains), Slack, fullscreen, remote control.
- **claude-code-orchestration** — `autonomous-ai-agents/claude-code-orchestration` — Sous-agents, forks, agent teams, workflows, cron//loop/routines, worktrees, checkpoints.
- **claude-code-enterprise-deploy** — `autonomous-ai-agents/claude-code-enterprise-deploy` — Managed settings, IAM, gateways, Bedrock/Vertex/Foundry, conformité, ZDR.
- **claude-code-integrations** — `autonomous-ai-agents/claude-code-integrations` — GitHub Actions, GitLab CI, devcontainers, code review, hooks CI.
- **claude-mcp-everything** — `autonomous-ai-agents/claude-mcp-everything` — MCP de bout en bout : transports, scopes, OAuth, tunnels, managed MCP, sécurité.
- **claude-internet-access** — `autonomous-ai-agents/claude-internet-access` — Toutes les voies d'accès au web : web_search/web_fetch API, WebFetch/WebSearch CLI, browser tool.
- **claude-pc-integration** — `autonomous-ai-agents/claude-pc-integration` — Intégration PC : computer use, terminal, fichiers, WSL, notifications, keybindings.
- **claude-agent-sdk-automation** — `autonomous-ai-agents/claude-agent-sdk-automation` — Agent SDK Python/TS + headless -p : options, outils custom, sorties structurées, hosting, déploiement sûr.
- **claude-api-platform** — `autonomous-ai-agents/claude-api-platform` — API Claude : lineup modèles + IDs, server tools et leurs version strings, caching, batches, effort, Managed Agents.
- **claude-vs-hermes-parity** — `autonomous-ai-agents/claude-vs-hermes-parity` — Ce que Claude Code a et que Hermes n'a pas — et l'inverse. Table de parité.

## blockchain (3)
- **evm** — `blockchain/evm` — Client EVM read-only : wallets, tokens, gas sur 8 chains.
- **hyperliquid** — `blockchain/hyperliquid` — Hyperliquid market data, account history, trade review.
- **solana** — `blockchain/solana` — Données Solana + pricing USD (balances, portfolios, NFTs, whales). No API key.

## communication (1)
- **one-three-one-rule** — `communication/one-three-one-rule` — Cadre décision 1-3-1 : 1 problème, 3 options pros/cons, 1 reco + plan.

## creative (25)
- **architecture-diagram** — `creative/architecture-diagram` — Diagrammes archi/cloud/infra SVG dark-theme en HTML.
- **ascii-art** — `creative/ascii-art` — ASCII art : pyfiglet, cowsay, boxes, image→ascii.
- **ascii-video** — `creative/ascii-video` — Convertir vidéo/audio en ASCII coloré MP4/GIF.
- **baoyu-article-illustrator** — `creative/baoyu-article-illustrator` — Illustrations d'article : type × style × palette cohérente.
- **baoyu-comic** — `creative/baoyu-comic` — Comics de savoir (知识漫画) : éducatif, bio, tutoriel.
- **baoyu-infographic** — `creative/baoyu-infographic` — Infographies : 21 layouts × 21 styles.
- **blender-mcp** — `creative/blender-mcp` — Piloter Blender via socket MCP (objets 3D, matériaux, anim, bpy Python).
- **claude-design** — `creative/claude-design` — Artefacts HTML one-off (landing, deck, prototype).
- **comfyui** — `creative/comfyui` — Générer image/vidéo/audio avec ComfyUI (comfy-cli + REST/WS).
- **concept-diagrams** — `creative/concept-diagrams` — SVG éducatifs flat light/dark (physique, chimie, math, anatomie...).
- **ideation** — `creative/creative-ideation` — Générer des idées de projet via contraintes créatives.
- **design-md** — `creative/design-md` — Author/validate/export DESIGN.md token specs (Google).
- **excalidraw** — `creative/excalidraw` — Diagrammes Excalidraw JSON hand-drawn (arch, flow, seq).
- **humanizer** — `creative/humanizer` — Humaniser le texte : virer les AI-isms, ajouter une vraie voix.
- **hyperframes** — `creative/hyperframes` — Compositions vidéo HTML→MP4/WebM (title cards, overlays, captions, TTS).
- **kanban-video-orchestrator** — `creative/kanban-video-orchestrator` — Pipeline vidéo multi-agent via Hermes Kanban (route vers ascii-video/manim/comfyui/blender...).
- **manim-video** — `creative/manim-video` — Animations Manim CE (style 3Blue1Brown math/algo).
- **meme-generation** — `creative/meme-generation` — Vrais memes : template + overlay texte via Pillow → .png.
- **p5js** — `creative/p5js` — Sketches p5.js : gen art, shaders, interactif, 3D.
- **pixel-art** — `creative/pixel-art` — Pixel art avec palettes d'époque (NES, Game Boy, PICO-8).
- **popular-web-designs** — `creative/popular-web-designs` — 54 design systems réels (Stripe, Linear, Vercel) en HTML/CSS.
- **pretext** — `creative/pretext` — Démos browser créatives avec @chenglou/pretext (ASCII, typo, text-as-geometry).
- **sketch** — `creative/sketch` — Mockups HTML jetables : 2-3 variantes à comparer.
- **songwriting-and-ai-music** — `creative/songwriting-and-ai-music` — Craft songwriting + prompts Suno AI.
- **touchdesigner-mcp** — `creative/touchdesigner-mcp` — Piloter TouchDesigner via twozero MCP (36 tools, visuels temps réel).

## data-science (1)
- **jupyter-live-kernel** — `data-science/jupyter-live-kernel` — Python itératif via kernel Jupyter live (hamelnb).

## devops (7)
- **inference-sh-cli** — `devops/cli` — Run 150+ AI apps via inference.sh CLI (image, vidéo, LLM, flux, veo, seedance).
- **docker-management** — `devops/docker-management` — Conteneurs/images/volumes/réseaux/Compose : lifecycle, debug, cleanup, Dockerfile.
- **kanban-orchestrator** — `devops/kanban-orchestrator` — Playbook décomposition + anti-temptation pour profil orchestrateur Kanban.
- **kanban-worker** — `devops/kanban-worker` — Pitfalls/edge-cases worker Hermes Kanban.
- **pinggy-tunnel** — `devops/pinggy-tunnel` — Tunnels localhost zero-install via SSH (Pinggy).
- **watchers** — `devops/watchers` — Poll RSS/JSON/GitHub avec dédup watermark.
- **webhook-subscriptions** — `devops/webhook-subscriptions` — Webhooks : runs d'agent event-driven.

## dogfood (2)
- **dogfood** — `dogfood` — QA exploratoire d'apps web : trouver bugs, preuves, rapports.
- **adversarial-ux-test** — `dogfood/adversarial-ux-test` — Roleplay l'utilisateur le plus difficile → tickets UX actionnables.

## email (2)
- **agentmail** — `email/agentmail` — Inbox email dédiée à l'agent (send/receive/manage autonome).
- **himalaya** — `email/himalaya` — Himalaya CLI : email IMAP/SMTP depuis le terminal.

## finance (8)
- **3-statement-model** — `finance/3-statement-model` — Modèle 3 états intégré (IS/BS/CF) en Excel.
- **comps-analysis** — `finance/comps-analysis` — Analyse comparables (multiples, benchmark peers) en Excel.
- **dcf-model** — `finance/dcf-model` — Modèle DCF institutionnel (FCF, WACC, terminal value, sensibilités).
- **excel-author** — `finance/excel-author` — Workbooks Excel auditables headless (openpyxl, conventions, balance checks).
- **lbo-model** — `finance/lbo-model` — Modèle LBO (sources/uses, dette, cash sweep, IRR/MOIC).
- **merger-model** — `finance/merger-model` — Modèle accretion/dilution M&A (pro-forma, synergies, EPS).
- **pptx-author** — `finance/pptx-author` — Decks PowerPoint headless (python-pptx) adossés aux modèles.
- **stocks** — `finance/stocks` — Quotes/historique/compare actions + crypto via Yahoo.

## gaming (2)
- **minecraft-modpack-server** — `gaming/minecraft-modpack-server` — Héberger serveurs Minecraft moddés (CurseForge, Modrinth).
- **pokemon-player** — `gaming/pokemon-player` — Jouer Pokemon via emulateur headless + lecture RAM.

## github (6)
- **codebase-inspection** — `github/codebase-inspection` — Inspecter codebases via pygount (LOC, langages, ratios).
- **github-auth** — `github/github-auth` — Setup auth GitHub : tokens HTTPS, SSH, gh login.
- **github-code-review** — `github/github-code-review` — Review PRs : diffs, commentaires inline (gh/REST).
- **github-issues** — `github/github-issues` — Créer/trier/labelliser/assigner issues GitHub.
- **github-pr-workflow** — `github/github-pr-workflow` — Lifecycle PR : branch, commit, open, CI, merge.
- **github-repo-management** — `github/github-repo-management` — Clone/create/fork repos ; remotes, releases.

## health (2)
- **fitness-nutrition** — `health/fitness-nutrition` — Planner gym + tracker nutrition (690+ exercices wger, 380k aliments USDA, BMI/TDEE/1RM).
- **neuroskill-bci** — `health/neuroskill-bci` — État cognitif/émotionnel temps réel via wearable BCI (Muse/OpenBCI).

## mcp (3)
- **fastmcp** — `mcp/fastmcp` — Build/test/deploy serveurs MCP en Python (FastMCP).
- **mcporter** — `mcp/mcporter` — CLI mcporter : list/config/auth/call serveurs MCP (HTTP/stdio).
- **native-mcp** — `mcp/native-mcp` — Client MCP : connecter serveurs, register tools (stdio/HTTP).

## media (9)
- **dofus-pilotage-hpc** — `media/dofus-pilotage-hpc` — Piloter le perso Dofus de the operator (Sgrr, Ouginak) via hpc — automation EXTERNE only.
- **felt-audio-analysis** — `media/felt-audio-analysis` — Ressentir/analyser un track (features spectrales librosa) "dis-moi ce que TU en penses".
- **find-movie-stream-vf** — `media/find-movie-stream-vf` — Trouver un film/série streaming gratuit EN VF (TMDB/IMDb + sites SPA anti-bot).
- **gif-search** — `media/gif-search` — Search/download GIFs Tenor via curl + jq.
- **heartmula** — `media/heartmula` — HeartMuLa : génération de chanson Suno-like depuis lyrics + tags.
- **songsee** — `media/songsee` — Spectrogrammes/features audio (mel, chroma, MFCC) via CLI.
- **spotify** — `media/spotify` — Spotify : play, search, queue, playlists, devices.
- **voir-visages-video** — `media/voir-visages-video` — Décoder vidéo/reel local : "à tel moment ça se passe" + qui apparaît (vision local + Opus). RGPD-aware.
- **youtube-content** — `media/youtube-content` — Transcripts YouTube → résumés, threads, blogs.

## migration (1)
- **openclaw-migration** — `migration/openclaw-migration` — Migrer la config OpenClaw vers Hermes (mémoires, SOUL.md, allowlists, skills).

## mlops (37)
- **huggingface-accelerate** — `mlops/accelerate` — Distributed training en 4 lignes (DeepSpeed/FSDP/Megatron/DDP).
- **chroma** — `mlops/chroma` — Embedding DB open-source : vector + full-text search, RAG.
- **clip** — `mlops/clip` — CLIP vision-langage : zero-shot classif, image-text matching.
- **evaluating-llms-harness** — `mlops/evaluation/lm-evaluation-harness` — lm-eval-harness : benchmark LLMs (MMLU, GSM8K...).
- **weights-and-biases** — `mlops/evaluation/weights-and-biases` — W&B : log expériences ML, sweeps, model registry.
- **faiss** — `mlops/faiss` — FAISS : similarity search milliards de vecteurs, GPU.
- **optimizing-attention-flash** — `mlops/flash-attention` — Flash Attention : 2-4× speedup, 10-20× mémoire transformers.
- **guidance** — `mlops/guidance` — Guidance : output LLM contraint (regex/grammars, JSON/XML valide).
- **huggingface-hub** — `mlops/huggingface-hub` — hf CLI : search/download/upload models, datasets.
- **huggingface-tokenizers** — `mlops/huggingface-tokenizers` — Tokenizers Rust rapides (BPE/WordPiece/Unigram), vocab custom.
- **llama-cpp** — `mlops/inference/llama-cpp` — llama.cpp : inférence GGUF locale + discovery HF Hub.
- **obliteratus** — `mlops/inference/obliteratus` — OBLITERATUS : abliterate refus LLM (diff-in-means).
- **outlines** — `mlops/inference/outlines` — Outlines : génération LLM structurée JSON/regex/Pydantic.
- **serving-llms-vllm** — `mlops/inference/vllm` — vLLM : serving LLM haut débit, OpenAI API, quantization.
- **instructor** — `mlops/instructor` — Instructor : extraction structurée LLM + validation Pydantic + retry.
- **lambda-labs-gpu-cloud** — `mlops/lambda-labs` — GPU cloud Lambda Labs (reserved/on-demand, SSH, multi-node).
- **llava** — `mlops/llava` — LLaVA : vision-langage, VQA, chat sur image multi-tour.
- **modal-serverless-gpu** — `mlops/modal` — Modal : GPU serverless on-demand, déployer modèles en API.
- **audiocraft-audio-generation** — `mlops/models/audiocraft` — AudioCraft : MusicGen text-to-music, AudioGen text-to-sound.
- **segment-anything-model** — `mlops/models/segment-anything` — SAM : segmentation zero-shot (points, boxes, masks).
- **nemo-curator** — `mlops/nemo-curator` — Curation données LLM GPU (dédup fuzzy/sémantique, qualité, PII, NSFW).
- **peft-fine-tuning** — `mlops/peft` — PEFT : LoRA/QLoRA + 25 méthodes, <1 % params, multi-adapter.
- **pinecone** — `mlops/pinecone` — Pinecone : vector DB managée, hybrid search, prod RAG.
- **pytorch-fsdp** — `mlops/pytorch-fsdp` — FSDP : sharding params, mixed precision, CPU offload, FSDP2.
- **pytorch-lightning** — `mlops/pytorch-lightning` — Lightning : Trainer, distributed auto, callbacks, peu de boilerplate.
- **qdrant-vector-search** — `mlops/qdrant` — Qdrant : moteur vector search Rust, RAG prod, hybrid + filtres.
- **dspy** — `mlops/research/dspy` — DSPy : programmes LM déclaratifs, auto-optimize prompts, RAG.
- **sparse-autoencoder-training** — `mlops/saelens` — SAELens : entraîner/analyser SAE, features interprétables, superposition.
- **simpo-training** — `mlops/simpo` — SimPO : alignement LLM reference-free (alternative DPO, +6.4 AlpacaEval).
- **slime-rl-training** — `mlops/slime` — slime : post-training RL LLM (Megatron+SGLang, modèles GLM).
- **stable-diffusion-image-generation** — `mlops/stable-diffusion` — SD via Diffusers : text→image, img2img, inpainting.
- **tensorrt-llm** — `mlops/tensorrt-llm` — TensorRT-LLM : inférence NVIDIA max throughput, FP8/INT4, in-flight batching.
- **distributed-llm-pretraining-torchtitan** — `mlops/torchtitan` — torchtitan : pretraining distribué 4D (FSDP2/TP/PP/CP), 8→512+ GPU.
- **axolotl** — `mlops/training/axolotl` — Axolotl : fine-tuning LLM en YAML (LoRA, DPO, GRPO).
- **fine-tuning-with-trl** — `mlops/training/trl-fine-tuning` — TRL : SFT, DPO, PPO, GRPO, reward modeling RLHF.
- **unsloth** — `mlops/training/unsloth` — Unsloth : LoRA/QLoRA 2-5× plus rapide, moins de VRAM.
- **whisper** — `mlops/whisper` — Whisper : STT 99 langues, transcription/traduction.

## note-taking (1)
- **obsidian** — `note-taking/obsidian` — Read/search/create/edit notes du vault Obsidian.


## productivity (16)
- **airtable** — `productivity/airtable` — Airtable REST via curl : records CRUD, filters, upserts.
- **canvas** — `productivity/canvas` — Canvas LMS : cours + assignments via API token.
- **google-workspace** — `productivity/google-workspace` — Gmail/Calendar/Drive/Docs/Sheets via gws CLI ou Python.
- **here.now** — `productivity/here-now` — Publier sites statiques {slug}.here.now + Drives privés agent-to-agent.
- **linear** — `productivity/linear` — Linear : issues/projects/teams via GraphQL + curl.
- **maps** — `productivity/maps` — Geocode, POIs, routes, timezones via OSM/OSRM.
- **memento-flashcards** — `productivity/memento-flashcards` — Flashcards spaced-repetition, quiz depuis transcripts YouTube, CSV.
- **nano-pdf** — `productivity/nano-pdf` — Éditer texte/typos/titres de PDF via nano-pdf CLI (prompts NL).
- **notion** — `productivity/notion` — Notion API + ntn CLI : pages, databases, markdown, Workers.
- **ocr-and-documents** — `productivity/ocr-and-documents` — Extraire texte de PDF/scans (pymupdf, marker-pdf).
- **powerpoint** — `productivity/powerpoint` — Create/read/edit decks .pptx, slides, notes, templates.
- **shop-app** — `productivity/shop-app` — Shop.app : recherche produit, suivi commande, retours, reorder.
- **shopify** — `productivity/shopify` — Shopify Admin & Storefront GraphQL via curl (products, orders, inventory, metafields).
- **siyuan** — `productivity/siyuan` — SiYuan Note API : search/read/create blocks & docs self-hosted.
- **teams-meeting-pipeline** — `productivity/teams-meeting-pipeline` — Pipeline résumé réunions Teams via Hermes CLI (Graph subscriptions).
- **telephony** — `productivity/telephony` — Numéro Twilio persistant, SMS/MMS, appels, outbound AI (Bland.ai/Vapi).

## red-teaming (1)
- **godmode** — `red-teaming/godmode` — Jailbreak LLMs : Parseltongue, GODMODE, ULTRAPLINIAN. (usage red-team autorisé)

## research (17)
- **arxiv** — `research/arxiv` — Search arXiv par keyword, auteur, catégorie, ID.
- **bioinformatics** — `research/bioinformatics` — Gateway 400+ skills bioinfo (génomique, single-cell, variant calling...).
- **blogwatcher** — `research/blogwatcher` — Monitorer blogs + flux RSS/Atom via blogwatcher-cli.
- **darwinian-evolver** — `research/darwinian-evolver` — Évoluer prompts/regex/SQL/code via loop d'évolution Imbue.
- **domain-intel** — `research/domain-intel` — Recon passive domaine (sous-domaines, SSL, WHOIS, DNS). Stdlib only.
- **drug-discovery** — `research/drug-discovery` — Recherche pharma : ChEMBL, drug-likeness (Ro5/QED/TPSA), DDI OpenFDA, ADMET.
- **duckduckgo-search** — `research/duckduckgo-search` — Web search gratuit DuckDuckGo (text/news/images/videos), ddgs CLI.
- **gitnexus-explorer** — `research/gitnexus-explorer` — Indexer codebase via GitNexus → knowledge graph interactif + tunnel CF.
- **llm-wiki** — `research/llm-wiki` — LLM Wiki de Karpathy : build/query KB markdown interlinkée.
- **osint-investigation** — `research/osint-investigation` — OSINT public-records (SEC, USAspending, OFAC, ICIJ, ACRIS, CourtListener...). Stdlib only.
- **parallel-cli** — `research/parallel-cli` — Parallel CLI : web search/extract/deep-research/FindAll/monitoring agent-native.
- **polymarket** — `research/polymarket` — Query Polymarket : markets, prices, orderbooks, historique.
- **qmd** — `research/qmd` — Search KB perso/notes/transcripts local (BM25 + vector + rerank LLM). CLI + MCP.
- **research-paper-writing** — `research/research-paper-writing` — Écrire papers ML NeurIPS/ICML/ICLR : design→submit.
- **scrapling** — `research/scrapling` — Scraping Scrapling : HTTP fetch, stealth browser, bypass Cloudflare, spider. (réflexe 403/bot-block)
- **searxng-search** — `research/searxng-search` — Meta-search gratuit SearXNG (70+ moteurs). Fallback web search.
- **smart-scraper** — `research/smart-scraper` — Scrape URL/profil TikTok via LLM local (qwen2.5:7b Ollama). Bridge Windows :7779.

## security (5)
- **1password** — `security/1password` — 1Password CLI (op) : install, sign-in, read/inject secrets.
- **oss-forensics** — `security/oss-forensics` — Forensics supply-chain GitHub (recovery commits supprimés, force-push, IOC, rapport).
- **sherlock** — `security/sherlock` — Sherlock : recherche username OSINT sur 400+ réseaux sociaux.
- **web-pentest-lab-setup** — `security/web-pentest-lab-setup` — Setup lab pentest web (Burp, PortSwigger Academy) — cibles légales.
- **web-pentest** — `security/web-pentest` — Pentest web AUTORISÉ : recon, exploit prouvé, rapport. Guardrails scope/autorisation.

## smart-home (1)
- **openhue** — `smart-home/openhue` — Contrôler lumières/scènes/rooms Philips Hue via OpenHue CLI.

## social-media (17)
- **api-sniff-flash** — `social-media/api-sniff-flash` — "Flash" : sniffer l'API JSON d'un site loggé puis fetch direct (stats exactes, instantané). X / Shopify / tout site loggé.
- **browser-game-automation** — `social-media/browser-game-automation` — Piloter jeu/canvas WebGL/WASM temps réel 60fps via hbrowse (sans API/DOM).
- **claim-triage-investigation** — `social-media/claim-triage-investigation` — Trier/enquêter contenu "côté sombre" (3 cases 🟢🟡🔴, 7 règles enquêteur, board HTML).
- **deia-image-anti-ia-label** — `social-media/deia-image-anti-ia-label` — Dé-IA une image avant post : virer C2PA/Content Credentials, EXIF iPhone crédible, garder qualité.
- **instagram-reel-understanding** — `social-media/instagram-reel-understanding` — Comprendre n'importe quel reel IG depuis l'URL (transcript, OCR, frames, caption+stats).
- **linkscale-landing-api** — `social-media/linkscale-landing-api` — Éditer la landing LinkScale de Victoire par l'API (POST /api/links 31 champs, Bearer XHR).
- **linkscale-tracker** — `social-media/linkscale-tracker` — Lire le tracker smart-links LinkScale (clics, géo, referrers) via flash, Brave local.
- **local-browser-pc-hands** — `social-media/local-browser-pc-hands` — Piloter Brave LOCAL loggé + bureau Windows depuis WSL (hbrowse/hpc/hweb, CDP 9789). Les vraies mains.
- **reddit-account-warmup** — `social-media/reddit-account-warmup` — Warmup karma/trust compte Reddit neuf (SFW, zéro promo, cadence humaine, cron).
- **sgrr-eyes-extension** — `social-media/sgrr-eyes-extension` — Extension Chrome read-only SGRR-Eyes : vision continue des onglets Brave loggé.
- **stats-watchdog** — `social-media/stats-watchdog` — Capture stats N'IMPORTE quelle plateforme → embed Discord, 100 % auto cron, zéro LLM.
- **tableau-liege-enquete** — `social-media/tableau-liege-enquete` — Artefacts HTML interactifs depuis brain/ (tableau de liège enquête + carte astrale lumineuse).
- **video-decoder-local** — `social-media/video-decoder-local` — Décoder N'IMPORTE QUELLE vidéo en local GPU : timeline horodatée + tous les visages. Gratuit illimité.
- **voice-assistant-realtime** — `social-media/voice-assistant-realtime` — Assistant VOCAL temps réel (mic→STT local→Opus→edge-tts FR) dans le browser.
- **x-account-safety-multicompte** — `social-media/x-account-safety-multicompte` — Protéger comptes X (<SOCIAL_HANDLE>) du ban + monter 2nd compte redondance non-lié.
- **x-reply-game-reach** — `social-media/x-reply-game-reach` — Reply-game X autonome persona Victoire → funnel OF (recon→reply_post.py→vérif, cap <40/j).
- **xurl** — `social-media/xurl` — X/Twitter via xurl CLI : post, search, DM, media, API v2.

## software-development (19)
- **code-wiki** — `software-development/code-wiki` — Générer wiki docs + diagrammes Mermaid pour n'importe quel codebase.
- **debugging-hermes-tui-commands** — `software-development/debugging-hermes-tui-commands` — Debug commandes slash TUI Hermes (Python, gateway, Ink).
- **hermes-agent-skill-authoring** — `software-development/hermes-agent-skill-authoring` — Écrire des SKILL.md in-repo (frontmatter, validator, structure).
- **hermes-memory-management** — `software-development/hermes-memory-management` — Gérer la mémoire persistante Hermes (compaction, briefing, USER.md vs MEMORY.md).
- **hermes-s6-container-supervision** — `software-development/hermes-s6-container-supervision` — Modifier/debug l'arbre s6-overlay du Docker Hermes (services, gateways).
- **nevergiveup-personal-assistant** — `software-development/nevergiveup-personal-assistant` — Règles persona NeverGiveUp (jamais d'outputs terminal dans Discord, résultat final only, boundaries).
- **node-inspect-debugger** — `software-development/node-inspect-debugger` — Debug Node.js via --inspect + Chrome DevTools Protocol CLI.
- **nvr-voice-assistant** — `software-development/nvr-voice-assistant` — Construire/relancer NVR Voice (archi v3 browser + WSL faster-whisper + API Anthropic + edge-tts).
- **plan** — `software-development/plan` — Plan mode : écrire un plan markdown dans .hermes/plans/, no exec.
- **python-debugpy** — `software-development/python-debugpy` — Debug Python : pdb REPL + debugpy remote (DAP).
- **recon-avant-action** — `software-development/recon-avant-action` — Méthode "au prime" : RECONNAISSANCE d'abord (structure interne + qui l'a résolu), action ensuite.
- **requesting-code-review** — `software-development/requesting-code-review` — Review pre-commit : security scan, quality gates, auto-fix.
- **rest-graphql-debug** — `software-development/rest-graphql-debug` — Debug API REST/GraphQL : status, auth, schémas, repro.
- **self-improvement-safe** — `software-development/self-improvement-safe` — Protocole auto-amélioration sûre (mes outils OUI / core Hermes NON, backup→modif→test).
- **spike** — `software-development/spike` — Expériences jetables pour valider une idée avant de build.
- **subagent-driven-development** — `software-development/subagent-driven-development` — Exécuter plans via subagents delegate_task (review 2-stage).
- **systematic-debugging** — `software-development/systematic-debugging` — Debug root-cause 4 phases : comprendre le bug avant de fixer.
- **test-driven-development** — `software-development/test-driven-development` — TDD : RED-GREEN-REFACTOR, tests avant code.
- **writing-plans** — `software-development/writing-plans` — Écrire plans d'implémentation : tâches bite-size, paths, code.

## web-development (1)
- **page-agent** — `web-development/page-agent` — Embarquer alibaba/page-agent (copilot GUI in-page JS) dans sa propre web app.

## yuanbao (1)
- **yuanbao** — `yuanbao` — Yuanbao (元宝) groups : @mention users, query info/members.

---

## Maintenance

Re-générer ce catalogue quand des skills sont ajoutés/retirés :
```bash
wsl -- bash -lc 'find /home/YOU/.hermes/skills/ -iname SKILL.md | grep -v /.venv/ | wc -l'
# si ≠ 205 → re-scanner name+description de chaque SKILL.md et MAJ ce fichier.
```
Dernière synchro : 2026-06-30 (205 skills, 32 catégories).
