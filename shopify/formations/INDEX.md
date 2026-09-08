# Training libraries — index

The doctrine in [`../GO-SHOPIFY.md`](../GO-SHOPIFY.md) is distilled from four libraries.
This file is the **index** — what each library holds, module by module, so you can find a
lesson without opening it.

**Where the verbatim content lives.** It used to be nowhere but your own disk, because three
of these four are paid third-party products. It now ships in this repo under
[`/formations/`](../../formations/README.md) — 343 files, seven libraries, ~32 MB of text —
and the installer mirrors it into `~/.claude/formations/` so the agent reads it directly.
That is only acceptable while the repo stays private, which is its normal state. **Do not
republish those folders, do not fork this repo outward.**

The **loader** still works and is still how you rebuild the bundles from your own copies:

```powershell
.\load-formations.ps1            # report only, writes nothing
.\load-formations.ps1 -Bundle    # build ~/.claude/formations/<library>.md
```

The **audio** is the one part that is not in git: 82 files, 3.36 GB, one of them past
GitHub's hard 100 MB per-file limit. Every file is listed with its SHA-256 in
[`/formations/AUDIO-MANIFEST.md`](../../formations/AUDIO-MANIFEST.md), and
`formations/scripts/add-audio.ps1` puts it back from a local copy. Nearly every replay ships
its written transcript anyway, so the words are here — only the voice is not.

If you don't own these courses, §4–§7 of `GO-SHOPIFY.md` still gives you the whole method —
it is written to stand alone.

---

## The four libraries

| Id | Library | Shape | Typical local location |
|---|---|---|---|
| **A** | E-com course, "inner circle" programme | 7 modules · 64 lessons · one `.md` per lesson (timestamped transcript + continuous text + metadata) | `BUSINESS/<store>/<course folder>/` and/or `Documents/<Course-Name>/` |
| **B** | E-com community live replays | ~76 dated `.md` transcripts + a `GMC_INDEX.md` | `Documents/<Community-Name>/transcripts/` |
| **C** | Merchant Center compliance playbook | 6 `.md` — curriculum map, playbook, per-store audit, legal data, benchmark | `BUSINESS/<store>/docs/<course>-gmc/` |
| **D** | The store's own research dossiers | Per store, free-form `.md` | `BUSINESS/<store>/docs/` |

Library **D** is the operator's own work and travels with the store folder — it is not part of
the loader's scope by default.

---

## Library A — module map

| Module | Lessons | Contents |
|---|---|---|
| 01 — Introduction | 4 | The decision · programme mechanics · rules · legal basics |
| 02 — Product research | 27 | 3 intro lessons · **9 discovery methods** · **11 validation criteria** + 1 bonus · the research table · the scoring grid |
| 03 — Choosing a market | 3 | Personal advantage · data verification (volume + CPC per country) · competitor verification on the local SERP |
| 04 — Persona & brand platform | 3 | Why persona is non-negotiable · building one via a structured AI prompt · turning it into a brand platform |
| 05 — Shopify | 16 | Import · photos · descriptions · pricing · homepage · product page · collections · about · contact · order tracking · cart · checkout · Liquid snippets · Google Ads connection + tracking |
| 06 — Google Ads | 8 | Mechanics · account structure · keywords & match types · the converting Search ad · Shopping · Performance Max · bidding · analysis |
| 07 — Live replays | 2 | Two recorded sessions |
| *locked (VIP)* | 10 | Merchant Center (9) · testing analysis (1) |

Everything operational from modules 02–06 is already condensed into `GO-SHOPIFY.md` §4–§7.
Read the transcript when you need the *reasoning* behind a threshold; read `GO-SHOPIFY.md` when
you need the threshold.

## Library B — what the replays cover

CRO · email/Klaviyo · Merchant Center experts · feed management · Google Ads · copywriting ·
beginners' sessions · bundles · high-ticket · expatriation and tax · AI-expert panels · seminar
interventions. Indexed by date; the Merchant-Center-relevant ones are additionally listed in
`GMC_INDEX.md`.

## Library C — what is applied and what is not

**Applied:** GMC configuration and validation · Shopping campaign setup · Search campaign setup ·
optimisation and analysis · the ban-recovery section (as *prevention*).

**Not applied:** the playbook also documents "forcing" / proxy circumvention techniques. They are
recorded there for completeness and are deliberately **not used**. Misrepresentation is an
account-level ban and a burnt merchant identity is very hard to recover. The compliance half is
the half that ships: complete legal pages, honest shipping/returns, consistent price and
availability, matching business identity, no unsubstantiated claims.

---

## The loader

```powershell
# report only - shows what it found, writes nothing
powershell -NoProfile -ExecutionPolicy Bypass -File .\load-formations.ps1

# build one bundled .md per library into ~/.claude/formations/
powershell -NoProfile -ExecutionPolicy Bypass -File .\load-formations.ps1 -Bundle

# point it at your own locations
powershell -NoProfile -ExecutionPolicy Bypass -File .\load-formations.ps1 -Bundle -Roots "D:\Courses","E:\Backup\Courses"
```

- Reads **only** from the local disk. Downloads nothing, uploads nothing, publishes nothing.
- Output goes to `~/.claude/formations/<library>.md` — outside any git repo, so a bundle can
  never be committed by accident.
- Skips anything already bundled unless `-Force` is passed.
- The bundle carries a header stating it is a local, private copy.
- **A second copy is merged, never dropped.** The same course usually exists twice (once inside
  a store folder, once in `Documents`). The loader keeps the copy with the most files, then adds
  from every other copy the files whose **SHA256 is not already present** — so a pure duplicate
  costs nothing and a lesson that exists in only one copy is never lost. The header lists every
  source it merged, and the report line tells you how many extra files came from where.
