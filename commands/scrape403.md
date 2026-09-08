---
description: Recuperer une page bloquee (403, 429, 503, page vide, challenge Cloudflare / Akamai / DataDome) avec Scrapling ou hbrowse, sans perdre de temps a bricoler des en-tetes.
argument-hint: "<URL> [ce qu'il faut en extraire]"
allowed-tools: Read, Write, Bash
---

Cible : `$ARGUMENTS`

Des qu'un `WebFetch`, un `curl`, un `https.get` Node ou un `requests` Python
rend **403, 429, 503**, une page vide ou un challenge, la reponse n'est pas
« c'est bloque » : c'est de passer a l'outil suivant. Ne jamais abandonner sur
un 403, ne jamais bricoler des User-Agent a la main.

## L'ordre a suivre

1. **La page exige-t-elle une session connectee ?** Alors ce n'est pas un
   probleme de bot-block : passe par `hbrowse`, qui pilote le Brave dedie ou
   les comptes sont deja ouverts.
   `wsl -u YOU -- bash -lc 'hbrowse text "<url>"'`
   (verbes : `text` `info` `dom` `snapshot` `screenshot <out.png>`
   `click <sel>` `eval <js>`. Un `rc=3` veut dire URL interdite par la
   denylist — zone Shopify/OFM protegee — pas une panne.)
2. **Sinon, Scrapling.** Ecris un **fichier** `.py` (jamais `python -c` :
   PowerShell mange les `$` et les backticks), avec
   `sys.stdout.reconfigure(encoding='utf-8')` en tete, sinon
   `UnicodeEncodeError` cp1252 des le premier `print`.

```python
from scrapling import StealthyFetcher, Fetcher

# 1er essai — Playwright stealth, passe les challenges JS Cloudflare
page = StealthyFetcher.fetch('https://cible.com', headless=True, network_idle=True)
html = page.html_content

# variante rapide — empreinte TLS Chrome (curl_cffi)
page = Fetcher.get('https://cible.com', impersonate='chrome')
html = page.html_content
```

3. Installation si absent : `pip install scrapling && scrapling install`
   (telecharge un Chromium stealth, une seule fois).
4. Dernier recours si Scrapling echoue aussi : MCP Playwright
   (`browser_navigate` + `browser_evaluate` pour extraire le DOM).

## Apres coup

Ne memorise rien si c'etait un 403 ordinaire — le reflexe Scrapling est deja
une regle globale. Ne note dans la memoire du projet que si **ce domaine
precis** demande une astuce particuliere : cookie de session, en-tete maison,
selecteur DOM non evident.
