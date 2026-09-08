---
paths:
  - "**/Documents/AI/SHOP-D/**"
---

# SHOP-D — Shopify Camping-Car Store (FR)

## Store identity
- **Domain:** shop-d.fr
- **Shopify admin:** tabraq-kw.myshopify.com
- **API version:** 2024-01
- **Niche:** Camping-car accessories — French market only
- **Method:** <COURSE-NAME> by Gaspard Grosjean

## Token — CRITICAL RULES
- Token lives in `C:/Users/YOU/.claude/scripts/.shop-d-token` (or env `SHOP_D_TOKEN`)
- Helper: `C:/Users/YOU/.claude/scripts/shop-d-accent-fixer.py` reads it from that file
- **NEVER hardcode `shpat_` tokens in scripts**
- **NEVER mix with SHOP-A token** (store shop-a-handle — completely separate)
- Load pattern: `token = open('.shop-d-token').read().strip()` or `os.environ['SHOP_D_TOKEN']`

## Products (priority order)
| Product | Price | Cost | Margin | Status |
|---|---|---|---|---|
| Caméra recul HD | 149€ | 31.39€ | 79% | GO #1 |
| Traceur GPS 4G | 99.90€ | 14.69€ | 85% | GO #2 |
| Chauffage diesel 8kW | 249€ | 84€ | 66% | GO #3 |
| GPS 9 pouces | 269€ | 84€ | 69% | WAIT — do not activate |

## Key files
- `CLAUDE.md` — full project rules + product IDs
- `produit/` — product images by category (numbered 1.png…7.png)
- `sections/` — Shopify Liquid section files
- `build_*.js` — template builders per product
- `compose_collections_v3.py` — collection composer (latest version)
- `deploy-engagement.py` — engagement deployment

## Rules
- All copy, ads, product descriptions = **French**
- Target ROAS ×2.5 on Google Ads
- Competitor to monitor: getnomadia.com
- Never activate GPS 9 pouces without explicit the operator validation
- Images in `produit/` — each subfolder = 1 product, numbered images + GMC compliance
