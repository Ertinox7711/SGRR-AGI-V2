---
name: persona-market-analysis
description: >-
  Run an advanced direct-response market + persona analysis on any product BEFORE
  validating positioning, writing ads, or building a product/landing page. Produces
  <COACH> / <COURSE-FOLDER>-style structured TABLES covering USP, Gene Schwartz mass
  desire + awareness/sophistication levels, desired transformation, dominant emotions,
  psychological triggers, the 3 top objections + rebuttals, UMP (why the problem still
  exists), UMS (why this product is superior), competitor review-mining (Amazon /
  Trustpilot / GigaBrain), and the top 3 ad angles to test — then ALWAYS ends with a
  blunt persona-fit verdict (GO / ADJUST / WRONG AVATAR). Use this whenever the user
  asks "est-ce qu'on est dans le bon persona / on est dans le bon", "analyse le marché
  pour X", wants to check avatar/positioning fit, mine competitor reviews for friction
  points, find advertising angles, or pastes the <COACH> 10-section market-analysis
  prompt. Trigger on FR ("analyse marché", "persona", "avatar client", "désir de masse",
  "angle pub", "USP", "UMP", "UMS", "on est dans le bon") and EN ("market analysis",
  "customer avatar", "persona fit", "ad angles", "review mining", "mass desire"). Pair
  with product-hunter (sourcing/validation upstream) and copywriting + marketing-psychology
  (execution downstream). Output is analysis only — never modifies a live store.
---

# Persona & Market Analysis (direct-response / <COACH> method)

Turn raw market inputs into an actionable persona + positioning map using classic
direct-response and persuasion theory (Eugene Schwartz, Gary Halbert, Stefan Georgi),
the way the <COURSE-NAME> / <COACH> method teaches it. The deliverable is a set of
structured tables plus a verdict on whether the current offer hits the right avatar.

This skill is **analysis only**. It never edits a store, runs ads, or ships copy. When
the analysis is done, hand off to `copywriting` + `marketing-psychology` for execution
and `page-cro` for the page.

## When to use

- "Est-ce qu'on est dans le bon persona ?" / "on est dans le bon ?" → run the full grid, end with the verdict.
- "Analyse le marché pour [produit]" → fill the 10-section grid.
- Before writing ads, a landing page, or a product description for a new product/angle.
- Before scaling spend on a product whose avatar hasn't been pinned down.
- When the user pastes the <COACH> 10-point prompt (USP / désir de masse / UMP / UMS / angles).

## Step 1 — Get the data (don't analyze on vibes)

the coach's rule: the analysis is only as good as the **voice-of-customer (VOC)** behind it.
Pull real data from at least these three sources before filling cells. If you can't, say
so explicitly and mark the affected cells `[needs live VOC]` — never invent review quotes
or stats (fabrication = FTC risk + you'll mis-target the avatar).

| Source | What you mine | How to get it |
|---|---|---|
| **Amazon reviews** | exact pain language, 1–3★ friction, what buyers expected vs got, gift context | Search the product category on Amazon, open top sellers, read 1–3★ AND 5★. On 403/bot-block → **Scrapling** (`StealthyFetcher` / `Fetcher.get(impersonate='chrome')`), never hand-craft headers. |
| **Competitor site(s)** | their angle, headline, offer, guarantees, which desire they sell, price anchoring | Fetch the competitor PDP + landing page. Note the *promise*, the *mechanism*, the *triggers*. |
| **GigaBrain / Reddit / forums** | unfiltered desires, objections, "what should I buy" threads, slang | GigaBrain query or Reddit/forum search for the category + "worth it / vs / recommend / problem". |
| (bonus) **Trustpilot** | post-purchase regret, service friction, returns | Mine the competitor's Trustpilot 1–2★. |

Capture **verbatim phrases** — the customer's own words beat your paraphrase every time
(mirror them straight into headlines and objection rebuttals).

## Step 2 — Apply the theory (this is what makes it <COACH>-grade)

Don't just describe the product. Force every section through these lenses:

**Gene Schwartz — Mass Desire.** You can't create desire, only *channel existing desire*
onto your product. Name the deep, pre-existing desire (status, security, convenience,
love, belonging, pride). The product is the *vehicle*, not the desire.

**5 Awareness levels** (decide where the prospect sits — it dictates the angle):
1. *Unaware* — doesn't know they have the problem.
2. *Problem-aware* — feels the pain, doesn't know solutions exist.
3. *Solution-aware* — knows solutions exist, not your product.
4. *Product-aware* — knows your product, not convinced.
5. *Most aware* — ready, just needs the offer/deal.

**5 Sophistication stages** (how tired is the market of the claims?):
1. First to claim → make the claim plainly. 2. Amplify the claim. 3. Introduce a *unique
mechanism*. 4. Amplify the mechanism. 5. Identify with the prospect / experience. Most
ecom categories are stage 3–4 → **you win on a unique mechanism, not a louder claim.**

**USP / UMP / UMS:**
- **USP** = Unique Selling Proposition — the one promise only you make well.
- **UMP** = Unique Mechanism of the **Problem** — *why the problem still exists* / why other solutions failed (the missing piece).
- **UMS** = Unique Mechanism of the **Solution** — the specific feature/material/tech that makes *your* result better/faster/safer. UMS should answer UMP.

**The hard rule (<COACH>):** **one avatar, one awareness level, one core desire per funnel.**
A page/ad that targets two personas at once converts neither. If the offer is split across
avatars, that's a finding — call it out in the verdict.

## Step 3 — Output the grid (always tables)

Use this exact 10-section structure. Tables, not prose. Tie claims to evidence (cite the
review/competitor) or mark `[needs live VOC]`.

```
## Market Analysis — [Product]

### 1. USP — Unique value
| Question | Answer |
|---|---|
| Major problem eliminated | … |
| Unique differentiating mechanism (UMS seed) | … |
| Irresistible promise (immediate-buy trigger) | … |

### 2. Mass desire (Schwartz)
| Question | Answer |
|---|---|
| Deep psychological desire satisfied | … |
| Conscious (actively searching) or latent (must be triggered)? | … + awareness level (1–5) |

### 3. Desired transformation
| Question | Answer |
|---|---|
| Before → After end-state the customer wants | … |
| How to amplify the emotional impact in marketing | … |

### 4. Emotional impact & triggers
| Question | Answer |
|---|---|
| Dominant emotions on this market | … |
| How to structure messages to amplify them | … |

### 5. Key psychological triggers
| Trigger | How to use it | How top competitors use it |
|---|---|---|
| Scarcity / urgency / social proof / FOMO / authority / anchoring | … | … |

### 6. Objections & rebuttals
| # | Objection | Pre-empt it in message / positioning |
|---|---|---|
| 1 | … | … |
| 2 | … | … |
| 3 | … | … |

### 7. UMP — why the problem still exists
| Question | Answer |
|---|---|
| Why existing solutions failed | … |
| The missing element that keeps customers searching | … |

### 8. UMS — why this product is superior
| Question | Answer |
|---|---|
| Specific feature / material / technology | … |
| How that mechanism delivers a better / faster / safer result | … |

### 9. Competitor analysis
| Question | Finding (cite source) |
|---|---|
| Recurring friction in Amazon/Trustpilot reviews | … |
| Message angles that WORK for competitors | … |
| Angles that FAIL / fall flat | … |
| Unmet needs to exploit for differentiation | … |

### 10. Top 3 ad angles to test
| # | Angle | Example headline |
|---|---|---|
| 1 | … | … |
| 2 | … | … |
| 3 | … | … |

**3 key messages** (reuse in ads, PDP, landing): 1) … 2) … 3) …
```

## Step 4 — ALWAYS end with the persona-fit verdict

This is the answer to "on est dans le bon ?". Lead with it; don't bury it.

```
## Verdict — persona fit
**[GO / ADJUST / WRONG AVATAR]** — one-line reason.

- ✅ What's right: …
- ⚠️ What's off / risk: … (e.g. two avatars in one funnel, price floor undercutting premium positioning, wrong awareness level for the angle)
- 🔧 Recommendation: pick ONE hero avatar + awareness level for the next funnel; match hero product, price band, and copy to it.
```

Be blunt. "Directionally right but split across two personas" is a more useful answer than
a polite "looks good." If the offer targets the wrong avatar, say WRONG AVATAR and name the
right one.

## Honesty guard

- No invented review quotes, ratings, or stats. Missing data → `[needs live VOC]` + offer to scrape it.
- Don't claim a material/spec the product doesn't have (it leaks into copy → returns + FTC).
- Distinguish *category-true* friction (well-documented across the niche) from *this competitor's* friction (needs their actual reviews).

## Project hook (SHOP-A / watch winders)

For the watch-winder store, the established avatar + market research already lives at:
- `C:\Users\YOU\Documents\BUSINESS\shopify\docs\coach-doctrine.md` (103 doctrines, 19 hard gates)
- `…\shopify\validation\` (grilles, 100 produits)
- memory `shop-a-competitors-20260605` (who runs Google Ads per market)
Read those before re-deriving; this skill complements them with the persona/persuasion layer.

## Related skills

- `product-hunter` — upstream: is the product even worth selling (sourcing, margin, Search vs Shopping).
- `copywriting` + `marketing-psychology` — downstream: turn this analysis into the actual copy.
- `page-cro` — structure the page around the chosen avatar.
