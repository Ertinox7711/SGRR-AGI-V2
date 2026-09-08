# GO-SHOPIFY — the whole Shopify operating system, in one file

> **What this is.** Everything the rig knows about running Shopify stores end-to-end:
> the build pipeline, the product-validation system, the Google Ads doctrine, the site/CRO
> conventions, the legal/Merchant-Center gates, the skill inventory, the API traps — plus the
> **index of the training libraries** the doctrine was distilled from and a one-command loader
> for them.
>
> Store names, handles, domains and account ids are stripped. See
> [`../shops/GO-SHOPS.md`](../shops/GO-SHOPS.md) for the multi-store identity architecture that
> sits underneath all of this.
>
> **On the training material:** the *method* below is the operator's own distilled synthesis and
> ships here. The **verbatim transcripts of the paid courses do not** — they are third-party
> paid products. Section 8 indexes them and gives you a loader that reads them **from your own
> local disk**.

---

## 1. The stack

| Layer | What runs |
|---|---|
| **Identity** | `shops-registry.md` + 4 hooks — see [`../shops/GO-SHOPS.md`](../shops/GO-SHOPS.md) |
| **Admin API** | Custom app per store, OAuth `client_credentials`, 24 h token, GraphQL Admin API |
| **MCP** | The Shopify MCP server (products, collections, orders, customers, inventory, discounts, analytics, `graphql_query` / `graphql_mutation` for everything without a dedicated tool) |
| **Theme** | Horizon-family themes; **custom Liquid sections**, never `settings_data.json` edits |
| **Browser** | The logged-in browser extension for admin pages; a stealth fetcher for public/bot-blocked pages |
| **Skills** | ~30 of the rig's skills are Shopify-relevant — inventory in §9 |
| **Rules** | `rules/shopify.md` — a lazy `paths:` rule that loads the 5 pillars only when a Shopify path or a `.liquid` file is touched |

**Token refresh (per store, from that store's folder):**

```bash
bash scripts/get-token.sh          # 24h admin token -> .secrets/access-token.txt
node scripts/shop-probe.js         # PROVE it reaches this store: name + currency + domain
```

A `SessionStart` hook warns when the token is stale and prints the exact command. It never
mints one for you — minting is a per-store, identity-gated action.

---

## 2. P0 — Operating mode

- **Autonomous end-to-end**: edit, run the script, verify visually, without asking. Confirm
  **only** what is destructive (mass delete, template overwrite) or visible to others (publish,
  deploy, send).
- **On a `read-only` store: propose, never modify.** Enforced by a hook, not by discipline.
- **Read before asserting.** Disk state beats memory; **live beats local**. Before citing a
  file, script or setting → read it.
- **Verify before saying "done".** Run the script, screenshot the preview theme, purge the cache
  if the change is public. `done` = a verifier passed.
- **Update the store's master `CLAUDE.md`** after every structural change: a dated ✅ entry with
  the re-run command and what was actually verified.
- **Anything customer-visible mixes three skills** — `copywriting` (SEO-aware) +
  `marketing-psychology` + `page-cro`. Never raw copy, never a headline written straight into
  Liquid.

---

## 3. P1 — Cloning a reference site (pixel-close, not pixel-identical)

Mandatory procedure for any "make it look like X":

1. **Access.** 403 / Cloudflare / bot-block ⇒ **stealth fetcher immediately**. Never hand-tune
   User-Agent headers — see [`../PITFALLS.md`](../PITFALLS.md) *bot-block*.
2. **Baseline.** Full-page screenshots of the reference (desktop 1440 + mobile 390) **before**
   writing any code.
3. **Design tokens** extracted from the reference via `getComputedStyle` (font-family, sizes,
   colors, radius, spacing, uppercase) → recorded in `data/<ref>-design-tokens.md`.
4. **Implementation** = custom Liquid sections with a complete `{% schema %}` — **never** by
   editing `settings_data.json`.
5. **Screenshot the clone through the preview theme** (`?preview_theme_id=…`), never the public
   URL (anonymous cache serves stale HTML).
6. **Visual diff** ref vs clone (pixelmatch). Thresholds: **< 3 %** ship · **3–10 %** fix ·
   **> 10 %** redo.
7. **Token check**: the clone's computed styles must equal the recorded tokens.
8. Purge the theme cache, then re-verify on the public URL.
9. **Faithful look-alike, never a copy.** Structure, type scale and layout are replicated;
   brand names, copy and trademarked imagery are **not** — placeholders, replaced by the
   operator.

---

## 4. P2 — Product research, sourcing and validation

The single highest-leverage system in this file. Everything below is a **method**: criteria,
thresholds, and the order they are applied in.

### 4.1 The premise

**Search ads capture existing demand; they do not create it.** A boring product with real
search volume beats a beautiful product nobody looks for. Any product whose demand has to be
*created* belongs on a feed platform, not on Search.

### 4.2 The economics, computed before anything else

| Quantity | How it is obtained |
|---|---|
| **Cost** | Real landed cost at **MOQ 1** + real shipping. **Never** a wholesale/FOB quote. |
| **Resale price** | The **lowest** price visible among dropship competitors (worst case), never the average and never the optimistic one. |
| **Gross margin** | resale − cost |
| **Average CPC** | Keyword Planner, the target market and language |
| **Worst-case CPA** | **CPC × 150** (storefront conversion 0.7–0.8 % ⇒ 1 sale per 120–150 clicks) |
| **Verdict** | **GO** when gross margin > CPA × 2 |

> **Back-check every derived threshold.** Any inverted bound ("so the cost must be ≤ X") gets
> substituted back into the original inequality **before** it is stated. Fees are included
> consistently or not at all — never in the verdict but missing from the thresholds. One line
> of check costs two seconds; a wrong threshold costs real money.

**Hard price floor:** below **~150** (store currency) the margin cannot absorb the CPA.
Exceptions exist only with an extremely low CPC and are decided explicitly, never assumed.

### 4.3 The 11 criteria (+ 1 bonus) — the validation funnel

| # | Criterion | Pass condition | Eliminatory? |
|---|---|---|---|
| 1 | **Strong margin** | margin > CPA × 2, computed as in §4.2 | **Yes** |
| 2 | **Dropship competitors present** | Real dropshippers already running Search/Shopping ads on the keyword. Zero competitors = unproven market. An *ugly* competitor site is an opportunity, not a warning | **Yes** |
| 3 | **Search volume** | ≥ 20–30 k monthly searches summed across the keyword's variants (a > 500-price product may pass with less) | **Yes** |
| 4 | **Precise keyword, bottom-up** | Start on the sub-niche of the sub-niche, scale to broad after revenue exists. Never start broad | **Yes** |
| 5 | **No institutional players** | Big-box retailers / marketplaces in the Shopping ads ⇒ **STOP**. Rare exception: a market where expertise is still required | **Yes** |
| 6 | **Brandable** | Brands already exist in the niche ⇒ buyers *want* a brand, not a commodity. Range extension possible | Bonus |
| 7 | **Easy sourcing** | Findable by **image search** from a competitor's photo, at MOQ 1. Hard to source = weak real demand | **Yes** |
| 8 | **Buyer wants an expert** | Enthusiast buyer ⇒ high intent, short decision. Indifferent buyer ⇒ they go to a big-box retailer | Bonus |
| 9 | **Short purchase cycle** | 2–3 days to 1 week max. A 3-week cycle desynchronises cashflow **and** poisons ad data — a sale lands after you already killed a winning campaign | **Yes** |
| 10 | **Not a brand search** | Type the keyword: only recognised brands in Shopping ⇒ trap product. High volume, terrible CTR, near-zero CVR for a generic store | **Yes** |
| 11 | **Single precise intent** | The keyword must map to **one** product. If Shopping shows ten different product types, it is too broad | **Yes** |
| B | **Works on Search, not only Shopping** | Text ads present on the keyword ⇒ launch on Search immediately, without waiting for Merchant Center approval | Bonus (large) |

**Scoring:** the criteria are scored on a **/105** grid. **< 50 % ⇒ STOP · 50–64 % ⇒ wait ·
≥ 65 % ⇒ GO.** The grid records, per product: cost · worst-case resale · gross margin · avg CPC ·
estimated CPA · search volume · competitor count · keyword precision · institutionals ·
sourcing · expert need · cycle · brand-search · Search-capable · score · **a one-sentence
verdict written in your own words** (that sentence is what trains pattern recognition after
~15 analyses).

**Order is non-negotiable:** research methods → product list → **validation grid** → validated
product → site → ads. Skipping validation is how four months disappear.

### 4.4 The 9 sourcing / discovery methods

| # | Source | What you are looking for | Note |
|---|---|---|---|
| 1 | **Business-for-sale marketplaces** | Listings with *verified* revenue (store + analytics connected). Filter: revenue-generating, e-commerce, min monthly revenue, recently sold | Highest signal — the revenue is audited. Do not sign NDAs, do not filter on profit (the operator may simply be bad) |
| 2 | **Marketplace movers & shakers** | Fast-rising best-sellers by category | Good: sports/outdoor, pet, baby. Avoid: electronics, appliances, clothing |
| 3 | **Visual-discovery trends** | Shopping trends by region; paid posts in the feed | ~3 weeks ahead for decor/fashion. Skip seasonal |
| 4 | **EU dropship-friendly wholesaler** | Under-served categories, bulky items sourceable without a Chinese marketplace | Ignore their displayed margin |
| 5 | **EU supplier directory** | Large items that are hard to source elsewhere (pergola, hanging chair, outdoor kitchen) | Displayed prices are wholesale, ignore them |
| 6 | **Chinese drop distributor best-sellers** | Publicly published best-sellers, filter > 150 | Only stocks marketplace-sourceable goods |
| 7 | **Ultra-low-cost marketplace** | The *expensive*, niche items only | Controversial: buyers may price-anchor to that marketplace |
| 8 | **Local business-for-sale marketplace** | Same as #1, local-language market | Fewer listings, better local fit |
| 9 | **Domestic marketplace best-sellers** | Garden, furniture, kids | Skip computing/electronics |

Every method ends the same way: **note the idea → validate it against §4.3 on the live SERP.**

### 4.5 Sourcing verification — triangulate, never trust one signal

Three signals, in order of trust:

- **(A) Image-search proliferation — PRIMARY, non-falsifiable.** Reverse-image the competitor's
  product photo. Threshold: **≥ 5 distinct stores** selling the same mould ⇒ real demand.
- **(B) Marketplace "N sold" badge** — corroborating.
- **(C) A store's "best selling" HTML sort** — corroborating **only**. `products.json?sort_by`
  is provably ignored by some themes; treating it as truth produces confident nonsense.

**Sacred constraint:** the product must be buyable at **MOQ 1**. Margin is computed on the
MOQ-1 landed cost **plus real shipping** — never a wholesale quote.

**Nothing is imported into a store without an explicit operator GO.** The sourcing deliverable
is a dossier in `docs/`; zero product API calls before the GO.

---

## 5. P3 — Google Ads doctrine

### 5.1 Channels and sequence

- **Phase 1 — testing:** Search + Shopping only. Capture demand.
- **Phase 2 — scaling:** Performance Max, once Search/Shopping have produced conversion data.
  Watch that the budget does not silently drain into video placements.
- **Never start** with Display, video or demand-generation.

### 5.2 Account structure

- Campaign naming: **`[COUNTRY]_[TYPE]_[PRODUCT]`**. Never `Search 1 / Search 2`.
- One campaign = one product/theme = one targeting.
- One ad group = one keyword sub-cluster.
- Bad structure is unanalysable: keywords blend, landing pages stop matching, scaling dies.

### 5.3 Keywords and match types

- **Never generic.** Precise keywords, or competitor-brand keywords, win on CPC, CTR and ROAS.
- Start **exact match `[…]`** for testing. If volume is thin (< ~20 k/mo), use phrase match
  `"…"` so you do not lose half the traffic. **Broad = the algorithm decides everything** —
  only ever in a separate, deliberately-labelled discovery campaign.
- Pull the top 5 keywords by volume from Keyword Planner, all in exact match, one ad group.

### 5.4 The Search ad — 15 headlines, 4 descriptions, 4 sitelinks

**Headlines (aim for ~30 characters each, Title Case):**

| Count | Type | Example shape |
|---|---|---|
| 2 | Brand | `<Brand> — <Category> N°1 <Country>` |
| 3–4 | Product keyword | the exact searched terms |
| 3–4 | USP / differentiator | what only you can claim |
| **1** | **Promotion, PINNED to position 1** | this is consistently the highest-CTR headline (+5–9 %) |
| 2 | CTA | `Discover The Collection` |
| 2 | Reassurance | `Free Shipping And Returns` · `Rated 4.8/5` |

**Descriptions:** 2–4 (4 is the target), ~90 characters, full sentences that expand the
headlines — brand name, primary keyword, a trust lever, a USP. Vary the wording; do not restate.

**Sitelinks:** 4, each = CTA text + 2 micro-USP lines, each pointing at the **matching
collection URL**, never the homepage.

**Campaign settings:** objective Sales · Search network · **Display network off** · search
partners on · target country explicit · **automatic asset rewriting off** · "new customers
only" off · use both display-path fields to show the category in the URL.

**Images in Search ads** unlock after roughly 50–100 of spend. Use lifestyle imagery, never a
grey/white studio background — up to 16.

### 5.5 Bidding — the three phases

| Phase | Strategy | Trigger to move on |
|---|---|---|
| **1 — testing** | Maximise clicks, **max CPC = market average + ~10 %** | 5–15 conversions collected |
| **2 — scaling** | Conversion **value**, **no** target ROAS | break-even reached (~1000–2000 revenue) |
| **3 — optimisation** | Conversion value **with** a target ROAS | ROAS stable over several days |

- **Never bid under the market.** An invisible ad collects no data. Slightly overpaying early is
  the cheapest data you will ever buy; the CPC falls on its own as the ad earns its rank.
- **Never "maximise conversions" alone** — it optimises toward the cheapest possible buyers.
- CPC exploding when you switch to phase 2 (e.g. 0.50 → 1.50 in a day) is expected, not a bug.

### 5.6 Ad rank

`ad rank = ad quality × bid`. The three quality pillars: **ad/keyword relevance**, **expected
CTR**, **landing-page quality and speed**. This is why collections without SEO metadata hurt:
ads pointing at them score worse.

---

## 6. P4 — Site, copy and CRO conventions

### 6.1 Product data

- Prefer importing from a competitor export over manual creation. If manual: title, description,
  images, price + compare-at, stock high and **inventory untracked**.
- **Never** use the platform's built-in AI description generator.
- Variants: colour → swatches, size/capacity → dropdown, **each variant bound to its own image**.
  Never mix picker styles.

### 6.2 Product images — the 7-slot carousel

All images share **one** background/environment. Mixed contexts destroy credibility.

1. Product on a plain background (hero)
2. Aspirational lifestyle
3. Feature image with the primary USP as a text overlay
4. **Video** of the product in use
5. Rational details (dimensions, materials)
6. Social proof (person + review text + guarantee + customer count) — *breaks rational hesitation*
7. Closing testimonial, persona-matched — *closes the emotional loop*

### 6.3 Product description — 6 blocks

1. **Hook** — a problem or a desire. **Never** a specification.
2. Transformation promise + expert validation.
3. USP bullets.
4. Technical details, **each translated into a plain-language benefit**.
5. Reassurance + CTA (returns window, packaging, bonus).
6. A **specific persona** — never "for all enthusiasts".

Define the persona **before** writing. Nobody buys a spec sheet.

### 6.4 Pricing

Testing phase: sit at the **lowest** price in the dropship competitor band (same exact product —
not established brands). Not lower than that: suspiciously cheap reads as fake. Re-price after
the product is validated.

### 6.5 Homepage

- **Announcement bar**: 3 rotating messages — offer + code · current promotion · reassurance.
- **Banner** answers three questions: what you do · the current offer · why buy here.
  Text **left-aligned**, thin/small heading. Centred banner text reads generic.
- **Featured products**: a **carousel**, never a grid; max 6; titled editorially
  ("Featured"), not "Best-sellers" — the latter reads promotional/cheap.
- **Buttons**: `border-radius: 0`, **UPPERCASE** label. Rounded corners read cheap.
- **Reviews** sit under the products: ≥ 10, different personas *and* different fears, varied
  timestamps.
- **FAQ** answers the persona's actual objections (origin, guarantee, delivery, discreet
  packaging) — never generic filler.
- **Footer**: dark background (end-of-page signal) + the three universal trust icons
  (shipping, returns, secure payment).

### 6.6 Product page

- Thumbnails under the carousel **on mobile too** — never dots.
- **Buy-box order:** star rating → small title (H5) → sale price **then** struck-through
  compare-at → instalment badge (if > ~150) → variant pickers → delivery date → **`Add to cart`
  only** → payment icons → dark trust block.
- **Remove `Buy it now` / accelerated checkout.** It creates decision paralysis and skips the
  cart, where the upsells live.
- **4 accordions:** Description (bound dynamically to the product description — never typed
  twice) · Shipping & Returns · Manufacturing · Guarantee.

---

## 7. P5 — Liquid and non-destructive wiring

### 7.1 A section is shippable only when

1. **CSS is scoped to `section.id`** (prefix every selector). Zero global classes.
2. **`{% schema %}` is complete**: every text = a `text`/`richtext` setting, every image an
   `image_picker`, every visible colour a `color`, every spacing a `range` (max one decimal
   step). Defaults are non-blank; a `richtext` default starts with `<p>`.
3. **Blocks are declared** and `presets[]` ships pre-filled example blocks — without them the
   section never appears in "Add section".
4. **Zero hardcoded CDN URLs** in the Liquid. `image_picker` plus an `{% else %}` fallback for
   the empty state.

### 7.2 Any script that touches `templates/*.json`

5. **READ-BEFORE-WRITE.** Read the live JSON and **merge**. Never rebuild from scratch —
   a from-scratch rebuild once wiped an entire homepage.
6. **Insert by anchor, skip if present.** Never delete an existing section. Anchor missing ⇒
   `exit 1` with a clear message.
7. Every wiring script exposes `--dry` and `--remove`. A full reset lives behind an explicit
   `--reset` / `--force`.
8. **Always finish with a theme cache purge.**

Deprecated scripts keep an `exit 1` guard with a conscious `--force-deprecated` escape hatch.
Do not delete them, do not bypass the guard.

---

## 8. Training libraries — index and local loader

Four libraries feed the doctrine above. **Their verbatim content is not in this repo** — it is
third-party paid material. What ships is the index, plus a loader that reads **your own local
copies**.

### 8.1 Library A — e-com course, "inner circle" programme (64 lessons, ~1.5 MB of transcripts)

Transcribed locally (Whisper large-v3, GPU), one folder per module, one `.md` per lesson with a
timestamped transcript, continuous text and metadata.

| Module | Lessons | Covers |
|---|---|---|
| **01 — Introduction** | 4 | The decision · how the programme works · rules · legal basics |
| **02 — Product research** | 27 | Search vs feed platforms · the 9 discovery methods · the 11 validation criteria · the research table · the scoring grid |
| **03 — Choosing a market** | 3 | Personal advantage · data verification (volume + CPC per country) · competitor verification via VPN on the local SERP |
| **04 — Persona & brand platform** | 3 | Why persona is non-negotiable · how to build one (structured AI prompt) · turning it into a brand platform |
| **05 — Shopify** | 16 | Product import · perfect product photos · descriptions · pricing · homepage · product page · collections · about · contact · order tracking · cart · checkout · Liquid snippets · connecting and tracking Google Ads |
| **06 — Google Ads** | 8 | Why/how it works · account structure · keywords & match types · the converting Search ad · Shopping · Performance Max · bidding strategies · analysing and optimising |
| **07 — Live replays** | 2 | Two recorded sessions (incl. a US-market / high-end-site session) |
| *locked (VIP)* | 10 | Merchant Center (9) · testing analysis (1) — not accessible |

→ Distilled into the operator's own `docs/<course>-doctrine.md`, which is what §4–§7 above are
built from, **with a "gaps" section per module** listing what the store has *not* yet done
against the doctrine. That gap list is the actual to-do list.

### 8.2 Library B — e-com community live replays (76 transcripts)

Weekly expert sessions, transcribed the same way: CRO, Klaviyo/email, Merchant Center experts,
feed management, Google Ads, copywriting, beginners' specials, bundles, high-ticket, expatriation
and tax, AI-expert panels, seminar interventions. Indexed by date and topic, plus a dedicated
`GMC_INDEX.md`.

### 8.3 Library C — Merchant Center compliance playbook

Distilled from the module of Library B that covers ads-and-GMC. Sections: GMC configuration and
validation · Shopping campaigns · Search campaigns · campaign optimisation and analysis ·
**what to do when the account is banned** (the core section) · a legacy bonus module.

⚠️ It also carries an explicit **risk note** on the "forcing" / proxy circumvention methods it
documents: they are recorded for completeness and are **not applied**. Misrepresentation is an
account-level ban, and a banned merchant identity is very hard to recover.

**What is actually applied** is the compliance half: complete legal pages, honest shipping and
returns data, consistent prices and availability, matching business identity, no unsubstantiated
claims.

### 8.4 Library D — the store's own research dossiers

Per store, in `docs/`: competitor analyses, supplier mapping, keyword plans, persona documents,
strategic dossiers, incident files. These are the operator's own work and travel with the store
folder.

### 8.5 The loader — pull your local copies into one bundle

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\shopify\formations\load-formations.ps1
```

It scans the known local locations, reports what it found, and (with `-Bundle`) concatenates each
library into a single navigable `.md` per library under `~/.claude/formations/`. It **only reads
from your disk** — it downloads nothing and it publishes nothing.

Point it elsewhere with `-Roots "D:\path\one","D:\path\two"`. See
[`formations/INDEX.md`](formations/INDEX.md) for the per-library detail.

---

## 9. The Shopify skill inventory

The rig ships ~143 skills; these are the ones that fire on store work.

| Skill | Use it for |
|---|---|
| `shopify-admin` | Native admin operations through the API/MCP |
| `product-hunter` | **Any** product/niche hunt — carries the §4 funnel. Invoke *before* adding any product idea |
| `aliexpress-source-mapping` | Reverse-source a catalogue to its supplier listings without false positives |
| `demand-validator` | Is there real demand behind this keyword |
| `persona-market-analysis` | Build the persona document that feeds ad headlines |
| `pricing-strategy` | Positioning inside the competitor band |
| `copywriting` | SEO-aware copy — **mandatory** on anything customer-visible |
| `marketing-psychology` | The buying levers behind the copy |
| `page-cro` · `signup-flow-cro` · `paywall-upgrade-cro` | Conversion work per surface |
| `landing-report` · `market-landing` · `market-funnel` | Landing and funnel construction |
| `launch-strategy` | Go-to-market sequencing |
| `email-campaigns` | Flows and campaigns |
| `brandkit` · `logo-generator` | Brand system and identity |
| `high-end-visual-design` · `minimalist-ui` · `industrial-brutalist-ui` · `ui-ux-pro-max` | Art direction |
| `design-review` · `design-consultation` · `design-shotgun` | Critique before shipping |
| `frontend-design` · `image-to-code` · `tailwind` · `css-animations` · `gsap` · `animejs` · `lottie` | Implementation |
| `gmc-pass` | Merchant Center gate check before ads |
| `google-analytics` · `youtube-analytics` | Measurement |
| `smart-scraper` · `scrape` · `spider-king` | Competitor and catalogue extraction |
| `playwright-skill` · `browse` · `agent-browser` | Live verification in a real browser |
| `stripe-payments` · `stripe-best-practices` · `stripe-dispute` | Payments and disputes |
| `make-pdf` · `docx` · `xlsx` · `pptx` | Deliverables (dossiers, grids, decks) |
| `shop-b-design` | A per-store design system — the template for writing your own |

**Chaining rule:** process skills first (`brainstorming`, `systematic-debugging`,
`writing-plans`), implementation skills second. Anything customer-visible always goes through
`copywriting` + `marketing-psychology` + `page-cro`.

---

## 10. Traps already paid for

| Trap | The rule that came out of it |
|---|---|
| **Template wipe** | A from-scratch `templates/*.json` rebuild erased a whole homepage. **Read-before-write, merge, never rebuild.** |
| **Stale public render** | The public page serves cached HTML for minutes after a push. The **Admin API read** is the authority — never re-patch against a stale render. |
| **Local file drift** | A local theme file can be both behind *and* ahead of live (fixes applied straight in the admin). **Pull before editing.** |
| **SEO fields that do not exist** | Page / Article / Collection have **no `seo` field** in their API inputs. SEO goes exclusively through `metafieldsSet`, namespace `global`, keys `title_tag` / `description_tag`. |
| **Duplicate H1** | The page template already renders `<h1>{{ page.title }}</h1>`. A second H1 in a hero or body is an SEO violation. |
| **`products.json?sort_by`** | Provably ignored by some themes. Never a primary best-seller signal. |
| **Bot-block** | 403/429/challenge ⇒ stealth fetcher **immediately**. Never spend ten minutes hand-tuning headers. |
| **Wrong-store token** | One token = one store, always in that store's own `.secrets/`. A copied script carrying another store's handle is the classic vector. |
| **Invented numbers** | Zero invented statistics. Volumes and CPCs are always labelled as estimates until verified in Keyword Planner. Placeholder reviews are replaced before scaling. |
| **Threshold not back-checked** | Every derived bound is substituted back into the original inequality before being stated. |
| **Non-ASCII in a hook** | A single em-dash in a `.ps1` string literal kills the hook **silently**, fail-open. Hooks are pure ASCII. |

---

## 11. The gates before spending a euro on ads

1. Validation grid complete for the exact SKUs being launched — score ≥ 65 %, CPA computed
   against **margin**, not against price.
2. Products **active**, with real images (7-slot carousel) and 6-block descriptions.
3. Collections carry SEO title/description via `metafieldsSet` (ad rank depends on the landing
   page).
4. Legal pages complete and truthful; shipping and returns match reality.
5. Merchant Center gates green — `gmc-pass`.
6. Conversion tracking wired and **proved with a test event**, not assumed.
7. Search ad composed to the §5.4 structure, with the promotional headline pinned at 1.
8. Bidding set to phase 1 (max clicks, market CPC + 10 %).
9. A written verdict sentence per product in the grid.
10. **Explicit operator GO.** Nothing goes live in a store without it.
