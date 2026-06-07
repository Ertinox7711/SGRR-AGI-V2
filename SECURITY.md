# Security Policy

GitHub recognizes this file as the repository's security policy.

---

# 🔒 Security & Threat Model

This repo is built around one precise assumption: **a smart adversary will read it line
by line, dig through the git history, and probe every file to extract information about
the owner.** Everything here is designed so there is **nothing to find**.

> Principle: we share the **capability** (the recipe), never the **data** (secrets,
> identity, private projects). If a piece of information is not necessary to reproduce
> the rig, it has no place in the repo.

---

## 1. Threat Model — What We Defend Against

| Attacker | What they attempt | Our defense |
|----------|-------------------|-------------|
| **The curious reader** | Browse files looking for a name, email, or project | Zero personal data; everything is `<PLACEHOLDER>` |
| **The git digger** | `git log`, `git blame`, old commits hunting for an author email or deleted secret | Anonymized author; history rewritten clean; secrets never committed (nothing to recover) |
| **The automated scanner** | Bot scanning GitHub for API keys / tokens | No secret exists in the repo; `.gitignore` + gitleaks + pre-commit hook enforce this continuously |
| **The social engineer** | Cross-referencing project names / personas / habits to build a profile | No private project name, persona, or business is listed or referenced |
| **The careless copier** | A friend who forks and accidentally re-pushes **their own** secrets | `.gitignore` hard-blocks common secret patterns; `preflight-scrub` + pre-commit stop them before the push |

---

## 2. What Is **Never** in This Repo

- ❌ Tokens, API keys, credentials (Shopify, Stripe, Anthropic, OpenAI… none of them).
- ❌ Real email address — **including in git commit author metadata** (a classic leak).
- ❌ Real name, pseudonym tied to a real identity, Discord handle, server IDs.
- ❌ Absolute machine paths (`C:\Users\<home>\...`, `/home/<home>/...`).
- ❌ Private project names, businesses, personal automations, personas.
- ❌ `settings.local.json`, `.credentials.json`, history files, caches, logs.

## 3. Defense Layers (Defense-in-Depth)

Security is not a single file — it is **5 layers** that catch each other's failures:

### Layer 1 — `.gitignore` (prevention)
Hard-blocks **patterns** of secrets and sensitive files, not just specific names:
`*.env`, `.env*`, `*secret*`, `*token*`, `*apikey*`, `*.key`, `*.pem`,
`.credentials.json`, `settings.local.json`, and known token prefixes
(`shpat_*`, `sk-*`, `rk_*`, `shpss_*`…). A secret matching these patterns cannot be
added by accident.

### Layer 2 — Scrubbed templates (no original to leak)
`settings.json` and `CLAUDE.md` are provided as **`.template`** files, already cleaned.
Sensitive data is replaced with `<PLACEHOLDER>`. There is no "real" version to leak
because it was never committed.

### Layer 3 — `pre-commit` hook (local barrier)
`scripts/hooks/pre-commit` scans the **staged diff** before every commit and **rejects**
the commit if any secret pattern is detected (API key, real email, absolute path, token
prefix). The secret never reaches history.

### Layer 4 — `preflight-scrub` (manual audit)
`scripts/preflight-scrub.ps1` (and `.sh`) scans the **entire repo** on demand and lists
any potential leak. Run it before a first public push, or after a large addition.

### Layer 5 — GitHub Actions (continuous defense)
`.github/workflows/secret-scan.yml` runs **gitleaks** on **every push and every PR**.
Even if a local layer is bypassed, the server-side scan raises the alert. This is the
safety net that does not depend on human discipline.

---

## 4. Git History Guarantees

Commit authors are **anonymized**: no real email, no real name appears in
`git log` / `git blame`. History is rewritten clean before publication.

Verify yourself:
```bash
git log --format='%an <%ae>' | sort -u    # must show no real email
git log -p | grep -Ei 'shpat_|sk-|api[_-]?key|password'   # must return nothing
```

## 5. Pre-Publication Checklist

```
[ ] preflight-scrub passes with no alert      (scripts/preflight-scrub.*)
[ ] git log --format='%ae' | sort -u  →  no real email
[ ] git log -p | grep secrets  →  empty
[ ] no private project name / persona in any file
[ ] .gitignore present and covers *.env, *secret*, *token*, *.key, .credentials.json
[ ] pre-commit hook installed (scripts/hooks/pre-commit -> .git/hooks/)
[ ] secret-scan.yml active (Actions tab once pushed)
[ ] repo set to PRIVATE if intended for friends, not the general public
```

## 6. For the Installer (You, the User)

- Your secrets stay **with you**. This repo asks for **no** keys whatsoever.
- You supply your own Claude Code subscription and your own API keys, **outside** the repo
  (environment variables, a secrets manager, or `settings.local.json` which is
  git-ignored).
- If you fork to share **your** setup in turn: run `preflight-scrub`, install the
  `pre-commit` hook, and anonymize your commit author **before** pushing.

---

## 7. Reporting a Vulnerability / Leak

You found a leak, a forgotten secret, or a stray personal path? That is a security bug.

1. **Do not paste the sensitive value** into a public issue — describe the location
   (file, line), not the value.
2. Open a private issue (Security advisory) or contact the maintainer.
3. The leaked data must be **purged from the entire git history**, not just the latest
   commit.

The repo is continuously protected by `gitleaks` (GitHub Actions, on every push), a
`pre-commit` hook, and the `scripts/preflight-scrub` script. If any of them let
something through, that is a bug to fix.
