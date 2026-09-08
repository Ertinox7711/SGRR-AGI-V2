# `formations/` — the training libraries

> **PRIVATE.** This repository went private before this folder landed in it. What follows
> is paid third-party course material plus the owner's own notes. It is here so that the
> owner and one friend can work from it. **Do not make this repository public again, do
> not fork it outward, do not redistribute these files.** Flipping the repo back to public
> republishes every file below — the history keeps them even if they are deleted later.

341 files, ~32 MB of text. Every library is a folder; every folder is exactly what was on
disk, minus the audio (see [AUDIO-MANIFEST.md](AUDIO-MANIFEST.md)).

---

## What is in each folder

| folder | what it is | files |
|---|---|--:|
| `A-inner-circle/` | The Inner Circle course: module transcripts in Markdown, the platform's chapter index (`ecom_tokens.json`), the supplier/prospect research that came with it, the transcription run log. | 157 |
| `A2-arthur-inner-circle/` | The same course as re-downloaded into the Shopify project folder. Kept as its own folder on purpose — see *Why two copies* below. | 66 |
| `B-ecom-boss-transcripts/` | The community live replays, written out. One `.md` per replay, numbered in the order they aired. This is where the 3.4 GB of audio came from. | 75 |
| `C-gmc-playbook/` | The Google Merchant Center playbook: feed rules, disapproval loops, what actually got accounts reinstated. | 6 |
| `D-formation-tiktok/` | The TikTok course: the PDF, the two DOCX, the fonts and image it ships with, and the two Python helpers that go with them. | 16 |
| `E-formation-html/` | The owner's OWN formation, 13 HTML modules plus annexes and stylesheet. Not third-party. | 16 |
| `F-underrated-formation/` | A single `CLAUDE.md` — the brief for an unfinished formation. | 1 |
| `bundles/` | The three libraries concatenated into one Markdown file each, ready to paste into a chat: `A-course-inner-circle.md` (3.4 MB), `B-community-live-replays.md` (8.1 MB), `C-gmc-playbook.md` (75 KB). Derived — rebuild them any time with `load-formations.ps1`. | 3 |

### Why two copies of the Inner Circle course

`A2-arthur-inner-circle/` is the folder named explicitly in the original request. It was
checked file by file against `A-inner-circle/`: **64 files, 0 unique names, 0 unique
content** — it is fully contained in the other copy. It ships anyway, because "fully
contained" is a fact that should be visible rather than a reason to silently drop a
folder someone asked for by name. The loader now merges by SHA-256 instead of picking one
copy and discarding the rest, so a file that exists in only one copy can never be lost.

---

## How to use it

**Read a whole library in one go** — paste a file from `bundles/` into the chat. Each
bundle carries a header saying which folders it was built from and how many files.

**Rebuild the bundles from your own disk** — [`shopify/formations/load-formations.ps1`](../shopify/formations/load-formations.ps1):

```powershell
.\shopify\formations\load-formations.ps1                      # report only, writes nothing
.\shopify\formations\load-formations.ps1 -Bundle              # build into ~/.claude/formations/
.\shopify\formations\load-formations.ps1 -Bundle -Force       # rebuild over an existing bundle
.\shopify\formations\load-formations.ps1 -Roots "D:\Courses"  # look somewhere else
```

It finds a library by folder-name pattern rather than a hard-coded path, so it survives
the course folder being renamed or moved to another drive. It reads only local paths,
downloads nothing, and writes to `~/.claude/formations/` — deliberately outside any git
repository, so a freshly built bundle cannot be committed by accident. When it finds the
same library twice it merges them, deduplicating by SHA-256, instead of picking a winner
and discarding the rest.

**Get the audio back** — [`scripts/add-audio.ps1`](scripts/add-audio.ps1):

```powershell
.\formations\scripts\add-audio.ps1 -Verify                        # what is present / missing / corrupt
.\formations\scripts\add-audio.ps1 -From "$env:USERPROFILE\Documents" -WhatIf   # rehearse
.\formations\scripts\add-audio.ps1 -From "$env:USERPROFILE\Documents"           # do it
.\formations\scripts\add-audio.ps1 -EnableLfs                     # what Git LFS would cost
```

Every copy is checked against the SHA-256 in the manifest. A file with the right name and
a different hash is a *different recording*, so it is refused rather than installed —
otherwise the manifest would quietly become a lie.

**Search across everything** — `grep -ril "<term>" formations/` beats scrolling. The
transcripts keep the speakers' own words, so search the way it was said, not the way you
would summarise it.

---

## What is deliberately NOT here

- **The audio: 82 files, 3.44 GB.** GitHub rejects any single file over 100 MB and one
  replay is 104.7 MB, so a plain `git push` of this folder cannot succeed at all. Git LFS
  would accept it, but its free tier is 1 GB of storage and 1 GB of bandwidth per month.
  Every file is listed with its size and SHA-256 in [AUDIO-MANIFEST.md](AUDIO-MANIFEST.md),
  and `scripts/add-audio.ps1` puts the bytes back — from a local copy, or through LFS once
  someone decides to pay for the data pack. **Nearly every replay ships its written
  transcript here, so the words are in the repo; only the voice is missing.**
- **`.pyc` caches** and `node_modules`, which are rebuildable noise.
- **The Merchant Center feed backups** under the shop's own `data/_gmc-backup/`. Those are
  live shop data, not training material; the shop docs cover them.

---

## What the leak gate does with this folder

`formations/` is listed in `.scrubignore`, so the scanners print its personal data —
supplier addresses, prospect addresses, the shop's own contact address — as grey **notes**
instead of blocking the commit. That demotion covers **PII only**. A Shopify, Anthropic,
OpenAI, GitHub, AWS or Slack token under this path still **blocks the commit**, exactly as
it would anywhere else: the folder is trusted with names and addresses, never with keys.

`ecom_tokens.json` is an exception worth knowing about. Its name matches the `*token*`
rule in `.gitignore`, so it was being dropped from the repo **silently**. It is the course
platform's table of contents — module titles, video ids, and Mux signed playback JWTs that
expired in June 2026. It is committed on purpose through a named exception, because a file
disappearing because of its *filename* is exactly the failure this repo keeps writing down.
