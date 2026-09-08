# GO-SHOPS — the multi-store operating system

> **What this is.** One file that explains **every folder structure** used to run several
> Shopify stores from a single Claude Code rig without ever confusing one store for another.
>
> **Store names are stripped on purpose.** Stores are referenced as `SHOP-A`, `SHOP-B`,
> `SHOP-C`. Handles, myshopify domains, custom domains and tokens are placeholders.
> The *structure*, the *rituals* and the *guard rails* are the deliverable — those are what
> transfer to any store. Names are not.

---

## 0. The one rule everything else hangs on

**A store's identity is derived from the FOLDER you are in — never from memory, never from a
previous session, never from a `<system-reminder>`.**

Every failure mode in multi-store work is the same failure: the agent "remembers" store X
while sitting in store Y's folder, then writes Y's file with X's handle — or worse, fires a
mutation at the wrong store with the wrong token. The whole architecture below exists to make
that physically hard rather than merely discouraged.

Three layers, in increasing hardness:

| Layer | Mechanism | Can it block? |
|---|---|---|
| **1. Human ritual** | `SESSION-INIT.md §0` — a 6-step identity lock run at the top of every session | No — discipline |
| **2. Advisory hook** | `shop-identity-guard.ps1` (PreToolUse) — names the targeted store on every edit, shouts `CROSS-SHOP` when one command references two stores | Only one case: an MCP **write** tool fired while cwd is a `read-only` store |
| **3. Hard gates** | `protected-path-denylist.ps1` (file writes into a read-only store) + `shop-token-identity-block.ps1` (the folder's token must actually reach the store on its registry line) | **Yes — hard deny** |

Reads are always allowed everywhere. **Writes and mutations are what's gated.**

---

## 1. The registry — single source of truth

**`~/.claude/shops-registry.md`** (+ a generated `.json` mirror that the hooks actually read).

- Lives **outside** every store folder → non-shadowable, and outside the read-only store →
  stays editable and authoritative.
- One store = **one row**. Adding a store = adding **one row** + running the sync script.
  Zero per-store wiring: every hook does boundary-safe longest-prefix matching over all rows.

Columns, and why each one exists:

| Column | Role |
|---|---|
| `shop_name` | Human label. Never the identity source. |
| `folder_root` | **The identity key.** Normalised lowercase + forward slashes, no trailing slash. |
| `store_handle` | The myshopify handle (`xxxxxx-yy`). Must never appear in another store's files. |
| `myshopify_domain` | `<handle>.myshopify.com`. Empty / `<TODO>` means the hard token gate cannot verify and therefore **allows** (documented limit, not a bug). |
| `currency` | Asserted live by the probe script. A currency mismatch = wrong store. |
| `niche` | Used in the banner and in the spoken announcement. |
| `token_path` | **Always** `<folder_root>/.secrets/access-token.txt`. Never shared, never cross-referenced. |
| `creds_path` | Same rule, for `app-credentials.txt`. |
| `app_name` | The custom Shopify app that mints the token. One app = one store. |
| `write_policy` | `read-only` (hard-blocked at file level) or `read-write-gated` (allowed, identity-gated, double-confirmed). |
| `status` | `live` / `setup` / `paused` — drives how careful the agent has to be. |

**Invariants the sync script aborts on:**

1. `folder_root` unique.
2. `token_path` and `creds_path` sit inside the store's own `.secrets/`.
3. No duplicate `store_handle`, `myshopify_domain` or `token_path` across rows.
4. `write_policy` is one of the two allowed values.

**Boundary-safe matching (a real bug that was paid for):** a path maps to a store only if
`path == folder_root` **or** `path` starts with `folder_root + '/'`. So `business/shop-b-pro`
and `business/shop-b2` are **different stores**, never folded into `SHOP-B`. A naive
`StartsWith` silently merges them — that is exactly how a token ends up pointed at the wrong
store.

---

## 2. The store folder — the structure every store shares

Every store, live or brand-new, has the same skeleton. Knowing one means knowing all of them.

```
BUSINESS/<store-slug>/
├─ CLAUDE.md              ← master memory + IDENTITY BANNER (stamped, never hand-edited)
├─ SESSION-INIT.md        ← the §0 identity ritual, run at the top of EVERY session
├─ .gitignore             ← .secrets/ hard-excluded
├─ package.json           ← node deps for the theme / API scripts
├─ .secrets/              ← app-credentials.txt, access-token.txt, CLAUDE.md. NEVER committed.
├─ scripts/               ← token, identity probe, theme push/pull, cache purge, feature builders
│  └─ lib/shop.js         ← identity helper: derives the store from the registry, gql(), assertShop()
├─ sections/              ← custom Liquid sections (one file = one section, scoped CSS)
├─ snippets/              ← reusable Liquid partials
├─ blocks/                ← theme blocks
├─ data/                  ← catalogue, CSV, design tokens, live pulls, *-backup snapshots
├─ docs/                  ← brand brief, design system, launch checklist, legal gates, research
└─ tools/                 ← one-off utilities (margin calc, image pipelines…)
```

### 2.1 `CLAUDE.md` — master memory + identity banner

At the top of the file, between `<!-- BANNER:START -->` and `<!-- BANNER:END -->`, sits a
**generated** identity block:

```
> ## SHOP = SHOP-C . NICHE = chess boards
> FOLDER = c:/users/<you>/documents/business/<shop-c-slug>
> HANDLE = <shop-c-handle> . API = <shop-c-handle>.myshopify.com
> CURRENCY = EUR . WRITE = read-write-gated . STATUS = setup
> TOKEN = <folder>/.secrets/access-token.txt (never another shop's token)
> ----------------------------------------------------------------
> IDENTITY COMES FROM THIS FOLDER, NEVER FROM MEMORY.
> - If cwd != this FOLDER -> STOP, you are not on SHOP-C. A sibling whose name merely
>   starts the same (e.g. <shop-c-slug>-pro) is a DIFFERENT shop.
> - NEVER touch another shop this session: SHOP-A (<path>) ; SHOP-B (<path>).
> - Before ANY write / API mutation: re-state 'Shop = SHOP-C (chess boards) - sure?' and
>   get an explicit GO.
> - Every handle/domain/GID you write must be COPIED from this banner / the registry,
>   never typed from memory.
> Registry = ~/.claude/shops-registry.md. Banner != registry -> STOP, reconcile (registry wins).
```

Rules: **stamped by a script, never hand-edited.** Banner ≠ registry ⇒ stop and reconcile,
registry wins. The banner also names the *other* stores explicitly, so "never touch these" is
stated rather than implied.

Below the banner the file carries:

- **`ÉTAT BOUTIQUE (live)`** — the dated journal of what actually exists (theme id, product
  count, which pages are wired). This section, not the agent's memory, is authoritative.
- **`OÙ EST QUOI`** — a lookup table mapping "I'm looking for X" → the exact file. This is what
  makes a 200-file store folder navigable in a single read.
- **Mode opératoire** — the non-negotiables for that specific store.

### 2.2 `SESSION-INIT.md` — the §0 ritual (6 steps, no action before step 6)

1. **Pin the folder.** `pwd` → the absolute cwd. *That* is the identity source.
2. **Read this folder's banner** (top of `CLAUDE.md`).
3. **Cross-check the registry.** Find the row whose `folder_root` == cwd (longest-prefix,
   boundary-safe). Banner ≠ row ⇒ **STOP, reconcile**. No matching row ⇒ **STOP** (store not
   activated).
4. **Announce out loud**, first line of the reply: *"Session on SHOP-C · niche chess boards ·
   handle `…` · API `….myshopify.com` · token `<slug>/.secrets/access-token.txt` · EUR ·
   write read-write-gated."*
5. **Live proof.** Mint a fresh token from *this* folder, run the probe, and **assert**
   `shop.name` and `currencyCode` match the registry. If the API answers with a different
   store ⇒ wrong creds in `.secrets/` ⇒ **STOP**.
6. **Wait for the GO.** Every subsequent write re-states the target store and waits again.

### 2.3 `.secrets/` — one token, one store, never shared

- `app-credentials.txt` — `SHOP` / `CLIENT_ID` / `CLIENT_SECRET` of that store's custom app.
- `access-token.txt` — minted by `get-token.sh`, **24 h TTL**.
- `app-credentials.txt.example` — the committed template (structure only, no values).
- `CLAUDE.md` — the local rules ("nothing leaves this folder, nothing is committed").
- Hard-excluded by `.gitignore` **and** by the repo-level secret scan.

A `SessionStart` hook checks the token's age and prints the exact refresh command when it is
stale, so a 24 h-old token never turns into a mid-task surprise.

### 2.4 `scripts/` — the store-agnostic core

Seven files are identical in every store; everything else is per-feature.

| Script | What it does | Why it matters |
|---|---|---|
| `get-token.sh` | OAuth `client_credentials` → 24 h admin token into `.secrets/` | Never hardcodes a handle: reads `app-credentials.txt` of the **current** folder |
| `shop-context.sh` | Sources `SHOP`, scopes, API version for bash | Same derivation rule in shell |
| `lib/shop.js` | Node helper: identity from the registry, `gql()`, `assertShop()`, `mainThemeId()`, `--go` gate on mutations | **Every mutation goes through here**, so the identity assert cannot be skipped |
| `shop-probe.js` | Live identity proof: name, domain, currency, MAIN theme, counts | Step 5 of the ritual |
| `pull-theme-file.js` | Pull a theme file **from live** before editing it | Local files drift both behind *and ahead* of live |
| `push-any.js` | Upsert theme files + read-back + cache purge, identity guard built in | The read-back is the proof, not the API's 200 |
| `theme-purge-cache.js` | `themePublish` + etag proof | The public render stays cached for minutes after a push |

### 2.5 `data/` — the evidence folder

- **Live pulls** (`_live-pull/`, `_live-sections/`) — what the store *actually* serves right now.
- **`*-backup/`** — a snapshot taken **before** each structural change. Cheap insurance, and the
  reason a bad wiring script has never been unrecoverable.
- **Design tokens** — computed styles extracted from the reference site, so "does it match?" is
  a diff rather than an opinion.
- **Catalogue / CSV / sourcing** — product data and supplier mapping.
- **Verifiers** (`_*-verify.js`) — one per feature: re-reads the live page and asserts the
  feature is present. `done` means a verifier passed, not that a script exited 0.

### 2.6 `docs/` — the decisions, not the code

`BRAND-BRIEF.md` (name, promise, tone) · `DESIGN-SYSTEM.md` (locked tokens — written **before**
the first section) · `LAUNCH-CHECKLIST.md` (technical → content → legal → ads runbook) ·
`GMC-GATES.md` (Merchant Center / legal gates; misrepresentation = account ban) ·
`PITFALLS-HERITES.md` (traps already paid for elsewhere — read before touching Liquid or the
API) · competitor research, keyword plans, strategic dossiers.

---

## 3. The four structures, side by side

### `SHOP-A` — the live store, **READ-ONLY**

- **Status:** live, revenue-generating. **Write policy: `read-only`.**
- Hard-blocked by `protected-path-denylist.ps1`: any `Edit` / `Write` / `Bash` write into this
  folder is **denied at the hook level**, regardless of what the registry says. The MCP write
  channel is covered too, by the identity guard.
- Reading, analysing and proposing are always allowed. Modifications happen **only** on an
  explicit, in-session request from the operator.
- **Extra structures unique to this store** (it is the oldest, so it accumulated the most):
  - `validation/` — the product-validation grids (`/105` scoring, Search S1–S5 and Shopping
    P1–P5), 9 sourcing methods, the metrics recipe that needs no paid SEO tool, and a probe
    script. **Shared read-only with the other stores** — this is the common product doctrine.
  - `docs/<course>-doctrine.md` — the operational synthesis of the paid e-com course
    (see [`../shopify/GO-SHOPIFY.md`](../shopify/GO-SHOPIFY.md)). Also shared read-only.
  - `data/*-images/`, `sections/*.liquid` — a full custom section library built to clone a
    reference site pixel-close.
  - `ai-dashboard/`, `save/` — local tooling and snapshots.
- **Why read-only matters:** the most dangerous store is the one that already takes money.
  Making it physically unwritable removes the entire class of "the agent helpfully improved
  production".

### `SHOP-B` — the built store, **read-write-gated**

- **Status:** live-ish. Store exists, domain bought and wired, app installed, API proven.
- Full content build already done: home, PDP, collections, blog, footer, filters, hero slider,
  brand marquee, cart drawer.
- Structure = the standard skeleton, plus:
  - `pivot-<date>/` — a dated folder holding a strategic pivot's research and decisions.
  - `docs/<incident>-<date>/` — an incident dossier (payout hold): diagnostic, chargeback file,
    verification dossier, customer emails, remediation plan. **Incidents get a folder, not a
    chat message** — that is how the fix survives the session.
  - `docs/<course>-gmc/` — the Merchant Center compliance playbook plus the store's own audit
    against it.
  - `data/_*-backup/` — roughly twenty dated snapshot folders, one per structural change.
  - `tools/marge/` — margin calculator.
- **Gated:** writes are allowed, but each one re-states the store and waits for a GO.

### `SHOP-C` — the newest store, **read-write-gated**

- **Status:** setup. Store created, domain bought and live, custom app installed with 14 scopes,
  token minting and live identity proof both working. **Content deliberately blank**: 0 products,
  default theme, no custom sections — built only on explicit request.
- Structure = the standard skeleton, and it is the cleanest reference implementation of it:
  every subfolder (`blocks/`, `data/`, `docs/`, `scripts/`, `sections/`, `snippets/`, `tools/`)
  carries its own `CLAUDE.md` explaining what belongs there.
- Notable additions:
  - `README-INIT.done.md` — the trace left by the activation script (what it created, when).
  - `docs/PITFALLS-HERITES.md` — pitfalls *inherited* from the other stores before a single line
    is written. A new store starts with the scar tissue of the old ones.
  - `data/_claims-*.js` + `data/specs-produits.json` — a **claims control** system: every factual
    claim on the site must resolve to a sourced number in a single JSON. No unsourced number
    reaches a page.
  - `scripts/_*-verify.js` — a verifier per feature, plus section-by-section screenshots.

### `_newshop` — the scaffold (deliberately unactivated)

- A **generic, name-less, token-less** clone of the skeleton. It is not in the registry, so no
  hook protects it and no API can be reached from it — **by design**.
- `scripts/init-shop.ps1` turns it into a first-class store in **one command**:
  1. Copies itself to a temp dir (so it can rename its own folder without locking itself), then
     renames `_newshop` → `<slug>`.
  2. Replaces every placeholder (`__SHOP_NAME__`, `__NICHE__`, `<TODO>`…) across all
     `.md` / `.js` / `.sh` / `.json` files.
  3. Appends **one row** to the registry — aborting if the name, folder or handle already exists.
  4. Runs the registry sync → regenerates the `.json` the hooks read, re-checking the invariants.
  5. Runs the banner stamper → writes the identity block into the new `CLAUDE.md`.
  6. Creates the project memory folder plus a blank `MEMORY.md`.
  7. Rewrites its own `README-INIT.md` → `README-INIT.done.md` as a trace.
- **Accents caveat:** run it from PowerShell, not Git Bash — accented arguments get mangled in
  the bash → PowerShell hand-off. The folder slug is de-accented either way.

---

## 4. Adding store #N — the whole procedure

```powershell
# 1. activate the scaffold (renames, fills placeholders, registers, stamps, creates memory)
powershell -NoProfile -File "<BUSINESS>/_newshop/scripts/init-shop.ps1" -Name "MyStore" -Niche "my niche in english" -Currency EUR
```

```bash
# 2. create the Shopify store + a custom app (Dev Dashboard, client_credentials)
#    -> fill <slug>/.secrets/app-credentials.txt from the .example

# 3. mint the 24h admin token
bash scripts/get-token.sh

# 4. PROVE the token reaches THIS store (never trust, assert)
node scripts/shop-probe.js
```

```powershell
# 5. complete handle/domain in the registry row, then re-sync
powershell -File "$env:USERPROFILE\.claude\scripts\shops-registry-sync.ps1"
```

Then follow `docs/LAUNCH-CHECKLIST.md`. Nothing else to wire — no hook, no rule and no script is
edited per store.

---

## 5. The hooks, in detail

All of them live in `~/.claude/scripts/` and are registered as `PreToolUse` / `SessionStart`
entries in `settings.json`.

| Hook | Event | Behaviour |
|---|---|---|
| `shops-whoami.ps1` | SessionStart | Prints the active store banner **before** the agent's first token, derived from cwd |
| `shop-identity-guard.ps1` | PreToolUse on `Edit`/`Write`/`Bash`/MCP-write | Advisory: names the target store; shouts `CROSS-SHOP` when one command references two stores, or when a copied script carries another store's handle. **Hard-denies** exactly one case: an MCP write tool fired while cwd is a `read-only` store |
| `shop-token-identity-block.ps1` | PreToolUse on `Bash`/`PowerShell` | **Hard gate, fail-open.** On any Shopify-ish command, verifies that the folder's creds and token actually reach the store on its registry row. Mismatch ⇒ **deny**. Uncertainty (missing file, no network, `<TODO>` domain) ⇒ **allow**, so it never breaks legitimate work |
| `protected-path-denylist.ps1` | PreToolUse on `Edit`/`Write`/`Bash` | **Hard gate.** Denies any write into a `read-only` store folder, independently of the registry |
| `shops-registry-sync.ps1` | manual | Regenerates the `.json` mirror and asserts the invariants |
| `shops-banner.ps1` | manual | Stamps the identity banner into a store's `CLAUDE.md` |

### By-design limits (documented, not bugs)

- **Empty domain ⇒ the hard gate allows.** With no target domain there is nothing to verify.
  Protection falls back to ritual + folder + advisory + double-confirm. The gate arms itself the
  moment `myshopify_domain` is filled in.
- **The advisory cannot deny** (except the MCP-write-on-read-only case). It is a reminder backed
  by the ritual and by the human double-confirmation.
- **The hard gate engages by regex** (`get-token`, `.myshopify.com`, `admin/api`, `shpat_`,
  `shop-context`, …). An exotic custom wrapper can slip past it. Defence in depth, not a single
  wall.

### ASCII rule (an incident that was paid for)

The `.ps1` hooks are read as **ANSI** by Windows PowerShell 5.1. A single non-ASCII character
(an em-dash, a curly quote) inside a `"…"` literal breaks parsing → **the hook dies silently**,
fail-OPEN, i.e. zero protection with zero error message.

**Every hook script is pure ASCII.** Verify after any edit — this must print nothing:

```bash
LC_ALL=C grep -nP '[^\x00-\x7F]' ~/.claude/scripts/*.ps1
```

---

## 6. The non-negotiables, condensed

1. **Identity = the folder.** Never memory, never the previous session, never a system reminder.
2. **Announce the store on line 1** of every session inside a store folder.
3. **Double-confirm every write / mutation** — re-state the store *and* the exact effect, then
   wait for a GO.
4. **One token = one store.** Never cross-referenced, always in that store's own `.secrets/`.
5. **Never cross-store without asking.**
6. **Every handle / domain / GID written is COPIED** from the banner or the registry — never
   typed from memory.
7. **Live > local. Disk > memory.** Pull the theme file before editing it; read the file before
   citing it.
8. **`done` = a verifier passed**, not that a script exited 0.
9. **Read-before-write on any `templates/*.json`** — merge, never rebuild from scratch.
   (A from-scratch rebuild once wiped an entire homepage.)
10. **Snapshot the folder before every structural change.**
