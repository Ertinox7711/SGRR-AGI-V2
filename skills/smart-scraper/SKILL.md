---
name: smart-scraper
description: Scrape any URL or TikTok profile with local LLM (qwen2.5:7b via Ollama) and optionally send result to Discord via Hermes
---

# /smart-scraper

Scrape a URL → extract structured JSON → optionally send to Discord.

Uses `C:\Users\YOU\Documents\SMART_SCRAPER\smart_scraper.py`.
Zero API cost. Ollama local. Playwright stealth + OpenCV captcha solver built-in.

## Step 1 — Parse intent

From the user message, extract:
- `URL` — the page to scrape
- `PROMPT` — what to extract (natural language)
- `JS` — use `--js` flag if site is TikTok / React / SPA
- `SEND` — true if user says "envoie", "send", "balance sur Discord"
- `CHANNEL_ID` — Discord channel ID if provided

If URL or PROMPT missing, ask once. Don't ask both in the same question.

## Step 2 — Run scraper

```powershell
cd "C:\Users\YOU\Documents\SMART_SCRAPER"
C:\Python314\python.exe smart_scraper.py scrape <URL> "<PROMPT>" [--js]
```

For TikTok / Instagram / JS-heavy sites → always add `--js`.

Capture stdout as JSON. Show result to user formatted.

## Step 3 — Send to Discord (if SEND=true)

Use the Discord API v10 directly with DISCORD_BOT_TOKEN from env.

Format as embed for readability:

```bash
curl -s -X POST "https://discord.com/api/v10/channels/<CHANNEL_ID>/messages" \
  -H "Authorization: Bot $DISCORD_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "embeds": [{
      "title": "Scrape result — <URL>",
      "description": "```json\n<JSON_RESULT>\n```",
      "color": 5763719
    }]
  }'
```

Truncate JSON to 3900 chars max (Discord embed limit).

## Step 4 — Report

Show:
- Extracted data (formatted)
- If sent: "✅ Envoyé sur Discord (message ID: ...)"
- If captcha was solved: mention it

## Supported modes

| Command | What it does |
|---|---|
| `/smart-scraper https://tiktok.com/@x "bio et followers"` | Scrape TikTok profile |
| `/smart-scraper https://site.com "prix des produits"` | Scrape any page |
| `/smart-scraper https://site.com "titres" envoie sur Discord` | Scrape + send |
| `/smart-scraper search "best AI tools" "noms et descriptions"` | DDG search + scrape |

## Error handling

- Ollama not running → `ollama serve` then retry
- Captcha not solved → retry with different timing, report if still fails
- Discord 401 → check DISCORD_BOT_TOKEN in env
- Site blocks → already handled by Playwright stealth fallback
