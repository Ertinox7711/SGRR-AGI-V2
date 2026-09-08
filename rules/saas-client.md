---
paths:
  - "**/<CLIENT-SAAS>/**"
  - "**/Users/YOU/<CLIENT-SAAS>/**"
---

# <CLIENT-SAAS> — TikTok AI Video SaaS

## What it is
SaaS for TikTok video generation via Veo 3.1 Fast + Gemini. Economy = GenCoins (GC). 100 GC = 1 video (8s).

## Stack
- **Frontend:** Static HTML/CSS/JS (`index.html`, `dashboard.html`, `pricing.html`)
- **Auth + DB:** Firebase Auth + Firestore
- **Backend:** Firebase Cloud Functions (`functions/index.js`) — Veo, Gemini, TikTok scraper, Stripe
- **CDN/Edge:** Cloudflare Workers (`workers/`, `wrangler.toml`)
- **Deploy:** `firebase deploy` (functions + hosting)

## API costs (real, sourced)
- Veo 3.1 Fast 8s video: ~0.37€ via kie.ai
- Gemini 2.5 Flash-Lite (script/hashtags): ~0€/req
- TikTok scraper: omkarcloud (5K req/mo free)

## Key files
- `dashboard.html` — client space (auth, generation, recharge)
- `js/firebase-config.js` — Firebase config + COSTS + PLANS + REFILL_PACKS constants
- `js/dashboard.js` — UI + Cloud Function calls
- `functions/index.js` — all Cloud Functions
- `firestore.rules` — security rules (MUST verify before deploy)
- `firebase.json` — hosting + functions config

## Rules
- Never expose Firebase API keys in client-side code beyond firebase-config.js (already public pattern, OK)
- Stripe webhooks in Cloud Functions — never process payments client-side
- Firestore rules: verify user owns their GC balance before any deduction
- Wrangler Workers for edge routing — `wrangler.toml` has project config
- `tiktokEYr*.txt` / `tiktokuOm*.txt` = TikTok domain verification files — do not delete
