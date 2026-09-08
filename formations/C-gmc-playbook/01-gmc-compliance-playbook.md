# Brizea — Master GMC & Google Ads Compliance Playbook

> **Store:** Brizea (`pa7duq-jd.myshopify.com`) · ventilateurs de plafond premium · marché France · EUR
> **Owner:** Serrano Mathieu Julien — entreprise individuelle (EI) · SIREN/RCS **935 076 471 RCS Paris** · établissement **47 rue Vivienne, 75002 Paris**
> **Channel target:** Google Merchant Center + Google Ads (Shopping / Performance Max)
> **Last updated:** 2026-06-26 · **Status of store:** built/clone phase, contains several KNOWN misrepresentation triggers that MUST be removed before any feed submission.

This is the permanent reference. The store is a dropshipping-style mono-product premium build cloned from a competitor. Dropshipping is allowed by Google, but it gets **heightened scrutiny** and a new domain with no history is a high-risk profile. The goal of this document: get approved on the first try, never burn the limited appeal attempts, and survive the first campaign.

---

## 1. TL;DR — The 10 highest-risk things that get THIS store suspended (ranked)

Ranked by probability × severity for Brizea specifically. The top 6 are things the store **is documented to currently have** — they are textbook, machine-detectable Misrepresentation violations and any one of them can suspend the account *upon detection, without prior warning*.

1. **Fake simulated "recent purchase" sales-pop notifications** (`brizea-sales-pop.liquid`, seeded with fabricated names/cities/timestamps, zero real orders). Explicitly named by Google as fabricated social proof / untrustworthy promotion. **MUST REMOVE before feed submission.**
2. **Trustpilot-styled review widget with NO real Trustpilot feed** + **placeholder fabricated reviews + hardcoded star ratings** (hero, testimonials section, PDP reviews). Fabricated ratings = misrepresentation; the Trustpilot wordmark with no feed behind it also implies a false third-party endorsement. **MUST REMOVE / replace with real owned reviews.**
3. **Third-party brand-logo marquee** (IKEA, Maisons du Monde, Leroy Merlin, MUJI, Pottery Barn, etc.) implying partnership/endorsement that does not exist. Falsely implying affiliation with another brand is a named Unacceptable Business Practice. **MUST REMOVE.**
4. **Delivery claim contradiction**: home `brizea-process` says **"Recevez sous 24 à 72h"** while the Livraison page honestly says **3–8 jours ouvrés**. Inconsistent/inflated delivery claims on a dropship store = misrepresentation. **MUST RECONCILE to the honest 3–8 day figure everywhere.**
5. **Placeholder legal-entity identity** on the legal pages (SIRET / médiateur / directeur de publication left as placeholders). An unverifiable identity is the core "we cannot verify your business" failure. **MUST FILL with the real EI data (now available: SIREN/RCS 935 076 471 RCS Paris, 47 rue Vivienne 75002 Paris).**
6. **Inflated compare-at / fake "solde" prices** the products never genuinely sold at, and perpetual/"today only" urgency. Cloned products carried compare-at prices from the competitor; if the product never sold at the strike-through price this is an untrustworthy offer. **MUST verify every compare-at is real or remove it.**
7. **Identity inconsistency (NAP) + personal Gmail as contact.** Shop email is currently `alterrp12@gmail.com` (personal). Legal name / address / phone / email must match byte-for-byte across site footer + Contact + About + Merchant Center + Google Ads payment profile + verification docs. A free Gmail looks non-legitimate. **MUST switch to `contact@brizea.fr` and unify NAP.**
8. **Storefront still password-protected** (`yeizau`). A passworded Shopify store cannot be crawled/verified → automatic disapproval. Removing it requires a **paid Shopify plan first** (owner action). **MUST be public before submitting.**
9. **Feed ↔ landing-page ↔ checkout price/availability/currency mismatch.** Must all be EUR (VAT-included), and the price Googlebot reads in static HTML must equal the cart/checkout price with no surprise fees. **MUST verify parity end-to-end.**
10. **Brand-new advertiser + brand-new domain ramping spend fast = Circumventing Systems / Suspicious Payments scrutiny.** No history, possible card/IP/email overlap with other accounts, aggressive day-1 spend. **MUST verify identity, keep payment profile consistent, warm the account slowly.**

> **The single rule that governs everything:** Google now (Oct 28 2025 clarification) simulates the *whole* shopping experience — it crawls multiple times over hours/days, adds to cart, checks checkout price vs feed, reads your policies, and evaluates on-page urgency/scarcity/social-proof. The test is: *can Google verify your identity, your claims, and your post-purchase commitments, and is everything a shopper sees accurate, realistic and truthful?* Sources: https://support.google.com/merchants/answer/6150127 · https://trustedwebeservices.com/blog/gmc-misrepresentation-policy-update-october-2025/

---

## 2. Misrepresentation deep-dive — the killer policy

Misrepresentation is the **#1 cause of GMC suspensions (~90% of cases)**, it is **account-level** (it propagates to the linked Google Ads account), Google suspends **"upon detection and without prior warning"**, and reinstatement happens **"only in compelling circumstances."** The Oct 28 2025 clarification reframed it as a **store-trust violation, not just a feed violation**. This is the section to internalize completely.

Official policy: https://support.google.com/merchants/answer/6150127 · Clarification: https://support.google.com/merchants/community-video/379501229 · https://feedarmy.com/kb/google-clarifies-misrepresentation-policy-what-merchants-need-to-know-2025-update/

Legend: 🔴 **MUST-FIX — Brizea is known to have this** · 🟠 verify/watch · 🟢 likely fine if built honestly.

### 2.1 Fabricated social proof — 🔴 MUST-FIX (Brizea has it)
- **What Google bans:** simulated "recent purchase" popups ("Maria from Chicago just bought this") generated from randomized/fabricated data with no real transactions.
- **Brizea's status:** `brizea-sales-pop.liquid` is a byte-clone of the Windury sales-pop, seeded with a hard-coded FR buyer list (Julien M. · Paris …) and random timing, NOT real order data. This is exactly the documented violation. The store's own notes already flag it as an FTC/DGCCRF risk.
- **Detection:** Google crawls repeatedly and sees the same fabricated pattern; it is also visible in the page source.
- **FIX:** **Remove the sales-pop entirely** before feed submission. Only re-enable if driven by *real* order data (e.g. a real "recently sold" app reading actual Shopify orders). Do not seed fake buyers.

### 2.2 Fake reviews / fabricated star ratings / fake review widget — 🔴 MUST-FIX (Brizea has it)
- **What Google bans:** displaying ratings/reviews that aren't genuine, owned, and honestly solicited; AI/automated-generated reviews; reviews from people with a vested interest; converting a non-5-star system to a 5-star display; **a Trustpilot-styled widget showing an aggregate score with no real Trustpilot feed behind it**; hardcoded testimonials/star counts. Product Ratings policy requires you to *collect and own* the reviews, minimum 50, no syndicated reviews. (https://support.google.com/merchants/answer/13585221)
- **Brizea's status:** hero shows "Excellent 4.9/5" Trustpilot block; testimonials section shows "4.8/5 · 312 avis" with the Trustpilot wordmark; PDP has 15 placeholder FR reviews. There is **no real Trustpilot feed and no real reviews**. The fabricated star ratings AND the false-endorsement implication (Trustpilot wordmark) are both triggers.
- **FIX:** **Remove all fabricated ratings, the Trustpilot wordmark, and the placeholder reviews.** Either (a) run a real reviews app (Judge.me, Loox, Shopify Product Reviews) and let genuine reviews — including <5-star — accumulate from real customers, or (b) ship with no reviews/ratings at all until you have real ones. Never display a star aggregate you can't substantiate.

### 2.3 False affiliation / endorsement — third-party brand marquee — 🔴 MUST-FIX (Brizea has it)
- **What Google bans:** "Make it seem like you're supported by another brand, organization, or government entity when you're not"; "falsely implying affiliation with, or endorsement by, another individual, organization, product, or service"; fake "As Seen On"; falsely claiming authorized-reseller/certified status.
- **Brizea's status:** the `brizea-brand-marquee` displays 15 third-party brand logos (IKEA, Maisons du Monde, La Redoute, Leroy Merlin, Castorama, Conforama, Zara Home, H&M Home, MUJI, Westwing, Wayfair, Pottery Barn, Crate & Barrel, West Elm, Williams Sonoma) under "Un design pensé pour tous les intérieurs." Even framed as "univers déco," displaying brand logos implies a partnership/endorsement Brizea does not have. The store's own notes flag the endorsement risk.
- **FIX:** **Remove the third-party brand-logo marquee entirely.** Replace with your own value props / icons, your own brand assets, or genuine certifications you actually hold. Do not show any logo of a company you are not partnered with.

### 2.4 Untrustworthy / misleading offers (inflated prices, fake urgency) — 🔴/🟠 MUST-VERIFY (Brizea is at risk)
- **What Google bans:** inflated reference prices ("199€ → 99€" when it never sold at 199€); "−50% sur tout" when only some items qualify; "BOGO free" where the free item is lower value; endless "sale" banners; "Aujourd'hui seulement!" that runs every day.
- **Brizea's status:** the 18 products were cloned from the competitor (Alizé) with their compare-at prices. If any compare-at is a price the product never genuinely sold at on Brizea, it's a fake reference price.
- **FIX:** Only keep a compare-at/strike price the product **genuinely sold at**; otherwise remove it. Scope discount claims accurately ("jusqu'à −X%" or list eligible items). Kill any perpetual/"today only" banner that never actually ends.

### 2.5 Deceptive countdown timers — 🟠 watch
- **What Google bans:** timers that reset on refresh / per session, or restart after expiry while the offer doesn't change. Google revisits over hours/days and detects identical countdown values. A timer is allowed **only** if tied to a real, fixed end date after which the offer actually changes.
- **Brizea's status:** none documented in the home build. If any timer app is added later, it must obey this rule.
- **FIX:** No resetting timers. If a timer is used, hard-wire it to a real promotion end date and make the price change when it expires.

### 2.6 Fake scarcity — 🟠 watch
- **What Google bans:** hard-coded/static "Plus que 2 !" not wired to real inventory; stock counters that never change after purchases.
- **Brizea's status:** the sales-pop includes a "Plus que X" stock-style notification (fabricated). Removing the sales-pop (2.1) handles it. Do not add hard-coded low-stock badges elsewhere.
- **FIX:** Only show "Plus que X en stock" if it reflects **live** Shopify inventory; otherwise don't show it.

### 2.7 Delivery-time claim contradiction — 🔴 MUST-FIX (Brizea has it)
- **What Google bans:** delivery promises that contradict reality or the store's own shipping page; claiming fast delivery a dropship model can't meet.
- **Brizea's status:** home `brizea-process` says **"Recevez sous 24 à 72h"**; the Livraison legal page honestly says **3–8 jours ouvrés**. Direct internal contradiction + an aggressive claim for dropship fulfillment.
- **FIX:** **Change every on-site delivery claim to the honest range (expédition sous 24–72h ≠ réception; réception 3–8 jours ouvrés).** Phrase it as "Expédié sous 24–72h · Livraison en 3–8 jours ouvrés" and make Merchant Center shipping settings + feed + shipping page all say the same thing.

### 2.8 Hidden / undisclosed costs — 🟠 verify
- **What Google bans:** undisclosed taxes, shipping, handling, recurring/subscription charges, or "free trial → paid" conversions; feed price ≠ checkout price; mandatory add-ons not disclosed upfront. Reinforced with **no grace period** since Oct 28 2025.
- **FIX:** All prices TTC (VAT included) in EUR. Free shipping for France must be true. Show shipping/any fees before the final checkout step. Feed price = product page price = cart = checkout, exactly.

### 2.9 Business identity hidden / inconsistent — 🔴 MUST-FIX (Brizea has placeholders + Gmail)
- **What Google bans:** false/missing identity, business name, or contact info; impersonation; NAP mismatch across site / Merchant Center / Ads / Business Profile.
- **Brizea's status:** legal pages carry placeholder entity info (now fillable with real EI data), and the shop/contact email is a personal Gmail.
- **FIX:** Fill the real EI identity everywhere (see §3), unify NAP byte-for-byte, switch to `contact@brizea.fr`.

### 2.10 Missing / inoperable policies — 🔴 reconcile (Brizea has pages but a delivery contradiction)
- **What Google bans (named Oct 2025 examples):** non-delivery, and inoperable return/refund processes; missing/hard-to-find return/refund policy; denying returns despite a stated policy.
- **Brizea's status:** 5 legal pages exist and are good (retours 30j, garantie 2 ans, livraison, confidentialité, mentions légales, CGV) — but the delivery contradiction (2.7) and placeholder entity (2.9) undermine them. The Shopify-native consent banner still points to an auto `/policies/privacy-policy`.
- **FIX:** Reconcile delivery wording, fill entity placeholders, ensure refund/return is reachable without login from the footer AND from each product page, and confirm the contact channel actually works.

### 2.11 Third-party reputation — 🟢 watch
- Google reviews the brand's external footprint. A brand-new store has none yet, which is neutral, but ensure searching "Brizea" returns a legitimate footprint over time and resolve any complaints before appealing.

### 2.12 Cloned/thin-site risk — 🟠 verify
- **What Google bans:** thin dropshipping sites with copied policy pages, copied supplier descriptions, undisclosed supplier, no verifiable identity.
- **Brizea's status:** structure cloned from Alizé; product descriptions were reworked into accordions (good), vendor was changed from "ALIZÉ" to "Brizea" (good), competitor media filenames ("sovala") were swept (good). Remaining risk = the fabricated trust elements above + identity. Once §2.1–2.10 are fixed, the thin-site risk drops sharply.

---

## 3. Required website pages & content (French legal specifics for an entreprise individuelle)

In France the GMC trust pages map almost 1:1 to legally mandatory content. Missing/incomplete French legal info is the single most common cause of "no clear reason" GMC suspensions because it makes the merchant identity look unverifiable. Build a **permanent footer** with one-click, indexable (no `noindex`, no login-redirect) links to all of these, on every page.

### 3.1 Mentions légales (LCEN art. 6 — mandatory on every public site)
For an **entreprise individuelle**, the page MUST show:
- **Full personal name**: Serrano Mathieu Julien
- **The mandatory "EI" mention** next to/after the name: e.g. "Serrano Mathieu Julien — Entrepreneur Individuel (EI)"
- **Identification number — RCS**: e-commerce selling physical goods = commercial activity, so the EI is registered at the RCS → display **"RCS Paris 935 076 471"** (city + SIREN). The SIREN is 935 076 471; SIRET = SIREN + 5-digit NIC of the establishment (47 rue Vivienne).
- **Postal address**: 47 rue Vivienne, 75002 Paris
- **Email**: contact@brizea.fr · **Phone**: a reachable number in +33 international format
- **Directeur de la publication**: Serrano Mathieu Julien (the entrepreneur himself)
- **TVA**: if under franchise en base, carry **"TVA non applicable, article 293 B du CGI"**; once VAT-liable, display the n° TVA intracommunautaire and prices TTC.
- **NOT applicable for an EI** (do NOT invent these): no "capital social", no "forme juridique" société (SARL/SAS). Showing a société-style capital for an individual = false/inconsistent identity.
- **Hébergeur**: Shopify Inc., 151 O'Connor Street, Ground floor, Ottawa, Ontario, K2P 2L8, Canada (name, address, phone).

Refs: https://entreprendre.service-public.gouv.fr/vosdroits/F37351 · https://www.economie.gouv.fr/entreprises/site-internet-mentions-obligatoires · https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000032226842

### 3.2 CGV (Conditions Générales de Vente) — mandatory B2C
Must contain the pre-contractual info of C. conso. L111-1 / L221-5:
- essential product characteristics, total price **TTC**, payment terms, delivery terms + **delivery deadline (honest 3–8 jours ouvrés)**;
- **droit de rétractation 14 jours** (L221-18 à L221-28) with the **model withdrawal form** (formulaire type, annexe R221-1) — failing to inform extends the withdrawal period to **12 months** (L221-20);
- **garantie légale de conformité 2 ans** (L217-3) **+ garantie des vices cachés** (Code civil art. 1641);
- **médiateur de la consommation** (L612-1): name, postal coordinates AND website URL — also on a dedicated section and ideally in order-confirmation emails. Omission = fine up to 3 000 € (natural person). **(Currently a placeholder on Brizea — owner must adhere to a registered mediator and fill it.)**

Refs: https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000044142579 · https://www.economie.gouv.fr/mediation-conso/vous-etes-un-professionnel/vos-principales-obligations-0 · https://entreprendre.service-public.gouv.fr/vosdroits/F21746

### 3.3 Retours & remboursement
Reachable **without login**, from the footer AND each product page. Must state: return window in a **specific number of days** (Brizea: 30 j commercial + the legal 14 j rétractation), accepted product condition, return method, **who pays return shipping** + any restocking fee, refund method (original payment / store credit / exchange) and **how long the refund takes**. Must cover **buyer's remorse**, not only defects. Must be consistent between the site, the feed, and Merchant Center. Never deny a return the policy permits (named egregious violation).

### 3.4 Livraison
Costs, regions, **honest delivery timeframe (3–8 jours ouvrés)** — must match the home copy (fix the "24–72h" contradiction) and Merchant Center shipping settings.

### 3.5 Politique de confidentialité (RGPD) + cookie consent
- Privacy policy: data collected, purposes, legal basis, retention, recipients, user rights (accès, rectification, effacement, opposition), DPO/contact, and the right to lodge a complaint with the **CNIL**.
- **Cookie consent banner (CNIL / art. 82 Loi I&L)**: "Accepter" / "Refuser" / "Paramétrer" with **equal prominence on the first screen**; **no ads/analytics cookie before explicit consent**; boxes unticked by default; refusal as easy as acceptance. Block Google Ads/Analytics tags until consent (Shopify Customer Privacy API / Consent Mode). The store still routes consent to the Shopify auto `/policies/privacy-policy` — fine, but ensure that page is complete.

Refs: https://www.cnil.fr/fr/cookies-et-autres-traceurs/regles/cookies

### 3.6 Contact + À propos
- **Contact**: full postal address, **clickable mailto contact@brizea.fr**, phone in +33 format, working contact form, business hours. At least **two working channels** (email + phone). These must match Merchant Center business info exactly.
- **À propos / Notre histoire** (Brizea has /notre-histoire): must read as a real business, state what Brizea does, and (best practice for dropship) not pretend to hold physical stock it doesn't.

### 3.7 Footer requirement
Permanent footer, on every page, with indexable one-click links to: **Mentions légales · CGV · Politique de confidentialité · Retours & remboursement · Livraison · Contact · Préférences cookies**.

---

## 4. Product feed / data requirements

Channel: the official **Google & YouTube** Shopify sales channel (auto-syncs, claims the domain, honors the 30-day freshness rule). MCA (multi-client) accounts are NOT supported by that channel — use a single Merchant Center account.

### 4.1 Required attributes per product
- `id` (unique, stable, ≤50 chars), `title` (≤150 chars, plain text, no ALL-CAPS / keyword stuffing), `description` (≤5000 chars, matches landing page), `link` (verified HTTPS domain), `image_link`, `availability`, `price` (numeric + **EUR**, VAT-included).
- `brand` is **required** for new products → must be **"Brizea"** on all 18 (the vendor was already fixed from "ALIZÉ"; verify no supplier/competitor name leaks into the feed). Never "Generic" / "N/A".
- **Identifiers**: provide `gtin` if the product genuinely has a manufacturer GTIN (validate the check digit — bad GTIN = disapproval). If there is no GTIN, provide `mpn`. If a product genuinely has no GTIN, MPN, or brand, set `identifier_exists=no` — but do NOT fake an identifier and do NOT set `=no` just to dodge the requirement. For generic/rebranded fans without a real GTIN, `mpn` + `brand=Brizea` (or `identifier_exists=no`) is the honest path.
- `condition`: "new" for all Brizea fans.
- `sale_price`: submit alongside the regular price and it must match the sale price shown on the landing page and checkout.

### 4.2 Images
- **Main image**: actual product, **no promotional text, no watermark, no border, no logo/CTA, no placeholder**. Accepted: JPEG/WebP/PNG/GIF/BMP/TIFF. A **500×500px minimum is enforced from Jan 31 2027** — use larger now.
- **additional_image_link**: up to 10; staging/graphics allowed there but not on the main image.
- **Brizea note**: the home placeholder photos are royalty-free Unsplash (free tier only — premium `plus.unsplash.com`/`premium_photo` carry a baked watermark and were correctly avoided). The competitor "sovala" media was swept. Before scaling, replace placeholders with your own product photography.

### 4.3 Price / availability / currency parity (top auto-disapproval cause)
- The price + currency Googlebot reads on the **crawled landing page** must equal the **feed** exactly, in **EUR**, at crawl time.
- **Avoid JS-injected prices** the crawler may not see — prefer **server-rendered** price + valid **schema.org Product/Offer** JSON-LD (`price`, `priceCurrency=EUR`, `availability`, `itemCondition`). The Horizon theme emits this; validate with Google's Rich Results Test (https://search.google.com/test/rich-results). Brizea already injects BreadcrumbList + Organization + WebSite JSON-LD; verify Product/Offer is present and correct on each PDP.
- `availability` on the page must match the feed (in_stock / out_of_stock / preorder / backorder). Remove/mark out-of-stock promptly.

### 4.4 Shipping & returns config (account level)
- Configure **at least one shipping service for France** in Merchant Center matching the storefront (free shipping FR is fine). Keep all rates in Shopify's **General** shipping profile — custom shipping profiles sync incorrectly and cause errors.
- Configure a **return policy in Merchant Center** (window ≥14 days legal; use 30 to match the storefront). EU prices include VAT so no separate US-style tax setting is needed (US tax settings were removed from MC on July 1 2025). Since March 2025, return-policy JSON-LD must include `return_policy_country` (FR).

### 4.5 Automatic item updates
Enable as a **safety net** (it only auto-corrects price/availability/condition by reading schema.org markup) but treat the scheduled feed / Content API as the source of truth. Auto-updates never touch titles, descriptions, GTIN, or shipping.

Refs: https://support.google.com/merchants/answer/7052112 · https://support.google.com/merchants/answer/6324461 · https://support.google.com/merchants/answer/6324350 · https://help.shopify.com/en/manual/online-sales-channels/google/requirements

---

## 5. Identity & website verification — how to pass on the first try

"Account suspended — we cannot verify your business" is an identity/misrepresentation block. Google must confirm you are a real, contactable, legitimate business and that your identity tells **ONE consistent story** across website + Merchant Center business info + submitted documents.

### 5.1 The core test: NAP consistency
Lock a **single canonical NAP** and stamp it **identically** everywhere — site footer, Contact page, About page, Merchant Center → Settings → Business information, Google Ads payment profile, and every uploaded document. For Brizea:
- **Legal/business name**: Serrano Mathieu Julien (EI) — trading as Brizea
- **Address**: 47 rue Vivienne, 75002 Paris, France
- **Phone**: +33 … (a real reachable number)
- **Email**: contact@brizea.fr (NOT a Gmail)
Even small mismatches (accent, abbreviation, different phone) cause failure.

### 5.2 Verify AND claim the domain (two separate steps)
- Use a **real custom TLD** (`brizea.fr`) on **HTTPS site-wide** — the `myshopify.com` subdomain is **ineligible** to verify.
- **Verify** = prove edit-control (HTML meta tag on the index page is the most reliable on Shopify; GA-based verification often fails on Shopify; or pre-verify in Search Console then claim).
- **Claim** = bind the URL exclusively to your Merchant Center account. The Google & YouTube channel auto-claims unless the domain is already tied to another Google account — confirm it isn't claimed elsewhere.

### 5.3 Disclose identity on the site
Visible contact info (phone, email, address, hours) in the footer + Contact page, plus a substantive **À propos / Notre histoire**. All easily discoverable.

### 5.4 Triggered identity verification (since March 2024) + document pack
If prompted, choose **Business** or **Personal** correctly (for an EI, the individual = the business). Prepare in advance, full-page, legible, unexpired, FR, annotated with your **Merchant ID**:
- **Government photo ID** (passport / carte d'identité / permis) of Serrano Mathieu Julien
- **Business registration**: extrait **Kbis** (the EI is RCS-registered → a Kbis exists) or avis SIRENE/INSEE showing SIREN 935 076 471 and the 47 rue Vivienne establishment
- **Address proof**: recent bank statement or utility bill matching the registered address (for payments verification you may black out the first 12 card digits)
The document address must match the profile address (or attach extra current-address proof); document country must match the account's target/registration country (FR).

### 5.5 Possible video verification (post-suspension on some reviews)
One continuous, unedited 3–5 min walkthrough. For an online-only store: show **admin control of the Shopify store** and real fulfillment/packing; business proof matching "Brizea". No customer faces, no private docs.

### 5.6 Don'ts that fail verification
- Personal Gmail instead of a domain email · NAP mismatch · cropped/expired/wrong-country docs · **editing key business fields while a review is in progress** · registering a business in a country you don't physically operate in · a domain already claimed by another account.

Refs: https://support.google.com/merchants/answer/14286818 · https://support.google.com/merchants/answer/11586344 · https://support.google.com/paymentscenter/answer/7159033 · https://feedarmy.com/kb/google-merchant-center-suspensions-new-video-identity-verification-what-merchants-must-know/

---

## 6. Google Ads account safety for a brand-new advertiser

New advertisers face heightened scrutiny because they lack history. The two account-killers in Ads are **Circumventing Systems** (~37% of 2025 suspensions, suspended on detection, no warning) and **Suspicious Payments**.

- **Complete advertiser identity + business verification immediately** when prompted (don't wait the full ~30 days). Use the real government ID / business registration matching the account's legal name exactly. **Submitting false info during verification is itself a Circumventing Systems violation.**
- **Bulletproof payment profile**: legal name, business name, billing address and tax info identical everywhere, on a card **you own**, in **EUR** (matching the account currency). Avoid prepaid/foreign cards, repeated failed transactions, or a card shared across accounts.
- **No association with any suspended account**: never reuse a card, email, domain, browser, or IP previously tied to a suspended Google Ads account — association alone triggers Circumventing Systems. Start Brizea cleanly with its own credentials.
- **No cloaking** (never show Googlebot a clean page while users see different content) — egregious, permanent-ban risk.
- **Warm the account**: start with a modest daily budget, let it run a few days, then scale — don't ramp big spend on day one with a brand-new domain.
- **Destination must work**: HTTPS everywhere, a working add-to-cart → checkout flow, at least one conventional payment method. A down/broken destination triggers `destination_url_down` (severe, account-level). Test a real order end-to-end.
- **Don't use a brand name in titles/ads** for products you're not authorized to resell (counterfeit/brand-misuse risk).
- **Keep it clean**: remove paused junk ads, fix any disapproval immediately, enable 2FA, don't run multiple accounts pushing the same content.

Refs: https://support.google.com/adspolicy/answer/15938075 · https://support.google.com/adspolicy/answer/9703665 · https://stubgroup.com/blog/the-state-of-google-ads-suspensions-2025/

---

## 7. Shopify-specific setup (incl. the storefront-password blocker)

- **Storefront password = hard blocker.** A passworded Shopify store (current password `yeizau`) cannot be crawled or verified by Google → automatic disapproval/suspension. **Removing the password requires first choosing a paid Shopify plan** (it cannot be removed during a free trial). Then: Online Store → Preferences → Store access → uncheck Password protection → Save. **This is an owner action** (selecting/paying for a plan is the owner's decision — never select a plan automatically).
- **Connect via the official Google & YouTube channel** (apps.shopify.com/google) to a **single** Merchant Center account; let it auto-claim `brizea.fr` (verify+claim manually if needed).
- **Currency/market**: Settings → Markets → set market = France, currency = **EUR**; confirm all on-site prices render in EUR and the feed sends EUR.
- **Policies**: ensure Refund Policy + Terms of Service exist and are linked in the footer menu (the Google & YouTube channel requires Refund + ToS). Brizea built its legal pages as custom Pages (token lacked `write_legal_policies`); make sure they're all footer-linked and indexable.
- **Shipping**: configure FR shipping in Merchant Center; keep rates in Shopify's **General** profile only.
- **Variants/options in English** to sync via the channel (the displayed storefront copy stays FR; this is the option *handle* requirement).
- **Product structured data**: confirm Product + Offer JSON-LD with `priceCurrency=EUR`; validate with Rich Results Test.
- **Re-check the channel after any product edit** — edits can break previously-synced products; keep the 30-day re-sync clean.
- **Remove the misrepresentation widgets at the theme level** before going public: disable/remove `brizea-sales-pop`, the Trustpilot blocks + placeholder reviews, and the `brizea-brand-marquee`; reconcile the "24–72h" copy.

Refs: https://help.shopify.com/en/manual/online-store/themes/password-page · https://help.shopify.com/en/manual/online-sales-channels/google/getting-setup/connect

---

## 8. Reinstatement / appeal process + what "Spectra"-type tools do

### 8.1 The golden rule
**Fix EVERYTHING before requesting a review.** Google re-checks your **entire site**, not just the flagged area, and **review requests are limited (commonly 1–3 per account)**. Each rejection triggers an **escalating cool-down (typically 7 → 14 → 30 days)** and, for misrepresentation, an extended human review plus a **~90-day post-reinstatement surveillance window**. Most appeals fail for one reason: merchants appeal before fixes are complete, with vague text and no evidence.

### 8.2 Timelines
- Warning phase → products go to "limited visibility"; fix before the window expires (auto-review at period end).
- Standard review: ~3–7 business days. Misrepresentation human review: ~7–15 business days. Payments identity verification: ~2–3 business days.

### 8.3 How to appeal correctly
1. Fix every issue and confirm each fix is **live and crawlable**.
2. Submit **one** re-review (Merchant Center → Settings/Diagnostics → Request review). Do **not** edit business fields mid-review.
3. Write a **specific, point-by-point** appeal: list each issue + its fix with **exact URLs, screenshots, and dates**. Never resubmit an identical/vague appeal.
4. If rejected: read the rejection, fix the re-flagged item, **wait out the full cool-down**, then submit a **materially different** appeal. Don't burn attempts on partial fixes — too many deep appeals can permanently ban the domain from Shopping.

### 8.4 What "Spectra"-type tools actually are
**"Spectra" could not be confirmed** as a real GMC anti-suspension / account-warming tool in any 2023–2026 source — no Shopify app, SaaS, or FR dropshipping tool by that exact name surfaced. The category it describes is **GMC compliance scanners**: they crawl your store and AI-check policy/identity/feed/price consistency against Google's misrepresentation policy, flagging fixes **before** you submit. Real, currently-used tools that do this:
- **AdNabu free Misrepresentation Checker** — https://www.adnabu.com/free-tools/misrepresentation-checker
- **ClearCheck Compliance** — https://apps.shopify.com/gmc-compliance-tool
- **ComplianceGuard AI** — https://apps.shopify.com/complianceguard-ai
- **GMC Store Readiness Scanner** — https://apps.shopify.com/gmc-store-readiness-scanner
- **GMCCheck / GMC Guard / GMC Protect** — https://gmccheck.com · https://gmcguard.ai · https://www.gmcprotect.com

Use one of these as a pre-submission audit — but a scanner does **not** replace manually removing the fabricated sales-pop, fake reviews, and brand marquee; those are the items that actually suspend this store.

Refs: https://support.google.com/merchants/answer/13693195 · https://stubgroup.com/blog/fix-your-google-merchant-center-suspension-2026-step-by-step-guide/ · https://searchengineland.com/fix-suspended-google-merchant-center-account-474404

---

## 9. PRE-LAUNCH CHECKLIST — Brizea (do every item before submitting a feed or running ads)

### A. Remove the documented misrepresentation triggers (do these FIRST — they suspend the account)
- [ ] **Remove the fake sales-pop notifications** (`brizea-sales-pop.liquid`) entirely. Only re-add if driven by real Shopify order data.
- [ ] **Remove the Trustpilot wordmark + fabricated star ratings** from the hero, testimonials, and PDP.
- [ ] **Remove the placeholder/fake reviews** (15 PDP reviews, testimonial cards). Replace with a real reviews app + genuine reviews, or ship with none.
- [ ] **Remove the third-party brand-logo marquee** (`brizea-brand-marquee`, IKEA/MUJI/Leroy Merlin/etc.). Replace with your own assets.
- [ ] **Reconcile the delivery claim**: change "Recevez sous 24 à 72h" → honest "Expédié sous 24–72h · Livraison en 3–8 jours ouvrés" everywhere (home `brizea-process`, PDP, CGV, Livraison page, Merchant Center shipping).
- [ ] **Audit every compare-at / strike price**: remove any reference price the product never genuinely sold at; scope all discount claims accurately; kill any perpetual/"today only" banner.
- [ ] Confirm there are **no resetting countdown timers** and **no hard-coded "Plus que X" scarcity** anywhere.

### B. Identity & legal pages (fill the real EI data — now available)
- [ ] **Mentions légales** complete: "Serrano Mathieu Julien — Entrepreneur Individuel (EI)" · **RCS Paris 935 076 471** · 47 rue Vivienne, 75002 Paris · contact@brizea.fr · +33 phone · directeur de publication = Serrano Mathieu Julien · TVA mention ("293 B du CGI" if franchise, or n° TVA intracom) · hébergeur Shopify Inc. (Ottawa).
- [ ] **No société fields**: confirm no "capital social"/"forme juridique" SARL/SAS appears (false for an EI).
- [ ] **CGV** complete: pre-contractual info, prix TTC, délai 3–8 j, **14-day rétractation + formulaire type (annexe R221-1)**, **garantie conformité 2 ans + vices cachés**, **médiateur de la consommation (nom + adresse + URL)** — adhere to a registered mediator and fill the placeholder.
- [ ] **Retours & remboursement**: window (30 j + 14 j légal), condition, who pays return shipping, refund method + timeline, covers buyer's remorse, reachable without login from footer **and each product page**.
- [ ] **Livraison**: honest 3–8 j, costs/regions — matches home + Merchant Center.
- [ ] **Politique de confidentialité (RGPD/CNIL)** complete (data, purposes, basis, retention, rights, CNIL complaint right).
- [ ] **Cookie banner CNIL-compliant**: Accepter / Refuser / Paramétrer equal on first screen; no ads/analytics cookie before consent; block Google tags until consent (Consent Mode / Customer Privacy API).
- [ ] **Contact page**: postal address + mailto contact@brizea.fr + +33 phone + working form + hours; **two working channels**.
- [ ] **À propos / Notre histoire** reads as a real business.
- [ ] **Footer** links (indexable, one-click, every page): Mentions légales · CGV · Confidentialité · Retours · Livraison · Contact · Préférences cookies.

### C. NAP consistency (one story everywhere)
- [ ] Switch shop/contact email from `alterrp12@gmail.com` to **contact@brizea.fr** and confirm it receives mail.
- [ ] Stamp the canonical NAP (name / 47 rue Vivienne 75002 Paris / +33 phone / contact@brizea.fr) **byte-for-byte identical** on: site footer, Contact, À propos, Merchant Center Business info, Google Ads payment profile, and all verification docs.
- [ ] Confirm WHOIS/domain owner doesn't contradict the legal name.

### D. Shopify / storefront
- [ ] **Owner**: choose a **paid Shopify plan**, then **remove the storefront password** (`yeizau`) so the site is public and crawlable.
- [ ] HTTPS site-wide on **brizea.fr** (custom TLD, not myshopify.com).
- [ ] Settings → Markets: France + **EUR**; all prices render TTC in EUR.
- [ ] Refund Policy + Terms of Service exist and are footer-linked (Google & YouTube channel requirement).
- [ ] Theme widgets in §A removed/disabled; re-check the Google & YouTube channel for errors after edits.

### E. Feed / product data
- [ ] All 18 products: `brand=Brizea` (no leaked supplier/competitor name, no "Generic").
- [ ] `gtin` only where genuinely correct (valid check digit); else `mpn`; else `identifier_exists=no` (don't fake).
- [ ] `condition=new`; titles plain (no ALL-CAPS/keyword stuffing); descriptions match landing page.
- [ ] Main images: real product, **no text/watermark/border/logo/placeholder**, ≥500×500.
- [ ] **Price parity**: feed price = product page (server-rendered) = cart = checkout, EUR/VAT-included, no surprise fees.
- [ ] **Availability parity** feed ↔ page; out-of-stock removed/updated.
- [ ] Valid **Product/Offer JSON-LD** (`priceCurrency=EUR`, `availability`, `itemCondition`) on every PDP — validate with Rich Results Test.
- [ ] Merchant Center: FR shipping service configured (rates in Shopify General profile only); return policy set (30 j), `return_policy_country=FR` in markup.

### F. Verification readiness
- [ ] Verify **and** claim brizea.fr in Merchant Center (HTML meta-tag method); confirm not claimed elsewhere.
- [ ] Document pack ready (full-page, legible, unexpired, annotated with Merchant ID): government photo ID of Serrano Mathieu Julien · Kbis / avis SIRENE (SIREN 935 076 471, 47 rue Vivienne) · address proof (bank statement / utility bill).
- [ ] Optional: create + verify a Google Business Profile with the exact same NAP.

### G. Google Ads safety (before first campaign)
- [ ] Complete advertiser identity/business verification immediately when prompted (real docs, matching legal name).
- [ ] Payment profile: legal name + address + tax info consistent, EUR, a card you own (no prepaid/foreign).
- [ ] No card/email/domain/IP overlap with any previously-suspended account.
- [ ] Test a real end-to-end order (add to cart → checkout → payment step) so the destination works.
- [ ] Start with a modest daily budget; warm the account a few days before scaling.

### H. Final pre-submission audit
- [ ] Run a GMC compliance scanner (AdNabu free checker / ClearCheck / ComplianceGuard) and clear every flag.
- [ ] Manually re-walk the live storefront as a shopper: no fake social-proof, no fake ratings, no brand-endorsement logos, honest delivery, working policies, prices match checkout, contact info visible.
- [ ] Only then connect the feed / request review. **Do not submit until every box above is checked** — the first review re-crawls the whole site, and burned appeals cost weeks.

---

### Sources (primary)
- Google Misrepresentation policy: https://support.google.com/merchants/answer/6150127
- Oct 28 2025 clarification: https://trustedwebeservices.com/blog/gmc-misrepresentation-policy-update-october-2025/ · https://feedarmy.com/kb/google-clarifies-misrepresentation-policy-what-merchants-need-to-know-2025-update/
- Website requirements: https://support.google.com/merchants/answer/12756116 · https://support.google.com/merchants/answer/13693195
- Product data spec: https://support.google.com/merchants/answer/7052112
- Product Ratings policy: https://support.google.com/merchants/answer/13585221
- Business info / verify / claim: https://support.google.com/merchants/answer/14286818 · https://support.google.com/merchants/answer/11586344
- Payments identity docs: https://support.google.com/paymentscenter/answer/7159033
- Google Ads Circumventing Systems: https://support.google.com/adspolicy/answer/15938075
- Shopify Google channel + password: https://help.shopify.com/en/manual/online-sales-channels/google/requirements · https://help.shopify.com/en/manual/online-store/themes/password-page
- France legal: https://entreprendre.service-public.gouv.fr/vosdroits/F37351 · https://www.economie.gouv.fr/entreprises/site-internet-mentions-obligatoires · https://www.cnil.fr/fr/cookies-et-autres-traceurs/regles/cookies · médiateur: https://www.economie.gouv.fr/mediation-conso/vous-etes-un-professionnel/vos-principales-obligations-0
- Suspension/appeal: https://stubgroup.com/blog/fix-your-google-merchant-center-suspension-2026-step-by-step-guide/ · https://searchengineland.com/fix-suspended-google-merchant-center-account-474404
- Compliance scanners: https://www.adnabu.com/free-tools/misrepresentation-checker · https://apps.shopify.com/gmc-compliance-tool
