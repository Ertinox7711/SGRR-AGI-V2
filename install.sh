#!/usr/bin/env bash
# install.sh — SGRR AGI V2 (macOS / Linux)
#
# Installs the whole rig into ~/.claude: CLAUDE.md, PITFALLS.md, memory, rules,
# commands, agents, scripts, skills, docs, and the shop / Shopify GO files.
#
# settings.json is NOT clobbered: it is SMART-MERGED, so the rig config lands in YOUR
# OWN live Claude without throwing away your keys, plugins, env, permissions, or your
# own hooks. Re-running is idempotent. Every file it would overwrite with DIFFERENT
# content is backed up next to itself as <file>.bak-<timestamp>; identical files are
# skipped silently.
#
# Does NOT install plugins (that's /plugin inside Claude Code — see INSTALLER-PROMPT.md).
# Never reads, asks for, or stores any secret.
#
# NOTE: the PowerShell guards (protected paths, asset-delete, shop identity, destructive
# block, browser denylist) are Windows-only. On macOS/Linux you get the portable subset:
# pitfall-tips, update check, rig audit, and the prompt/session hooks. The prose rules in
# CLAUDE.md still apply — they are the layer that does not depend on an OS.
#
# Usage:
#   ./install.sh                       # install
#   ./install.sh --dry-run             # show what would happen, write nothing
#   ./install.sh --minimal             # core only (no skills/, docs/, shops/, shopify/)
#   ./install.sh --target /tmp/.claude # install somewhere else (sandbox / second profile)
set -euo pipefail

DRY=0
MINIMAL=0
TARGET=""
while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY=1 ;;
    --minimal) MINIMAL=1 ;;
    --target)  shift; TARGET="${1:-}"; [ -n "$TARGET" ] || { echo "--target needs a path" >&2; exit 2; } ;;
    --target=*) TARGET="${1#--target=}" ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE="${TARGET:-$HOME/.claude}"
STAMP="$(date +%Y%m%d-%H%M%S)"
N_COPIED=0; N_SKIPPED=0; N_BACKED=0

cyan()  { printf '\033[36m==> %s\033[0m\n' "$1"; }
green() { printf '\033[32m    ok  %s\033[0m\n' "$1"; }
yellow(){ printf '\033[33m    !!  %s\033[0m\n' "$1"; }

hash_of() { if command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1" | cut -d' ' -f1; else sha256sum "$1" | cut -d' ' -f1; fi; }

# Copy one file, backing up the destination ONLY when it exists with different content.
copy_one() {
  src="$1"; dst="$2"
  if [ -f "$dst" ]; then
    if [ "$(hash_of "$src")" = "$(hash_of "$dst")" ]; then N_SKIPPED=$((N_SKIPPED+1)); return; fi
    if [ "$DRY" = 1 ]; then N_BACKED=$((N_BACKED+1)); N_COPIED=$((N_COPIED+1)); return; fi
    cp "$dst" "$dst.bak-$STAMP"; N_BACKED=$((N_BACKED+1))
  fi
  if [ "$DRY" = 1 ]; then N_COPIED=$((N_COPIED+1)); return; fi
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  case "$dst" in *.sh) chmod +x "$dst" ;; esac
  N_COPIED=$((N_COPIED+1))
}

# Copy a whole tree from the repo into ~/.claude, file by file (granular backups).
copy_tree() {
  rel="$1"
  src_root="$REPO/$rel"
  dst_root="$CLAUDE/$rel"
  if [ ! -d "$src_root" ]; then yellow "source missing, skipping: $rel"; return; fi
  before=$N_COPIED
  while IFS= read -r f; do
    copy_one "$f" "$dst_root/${f#$src_root/}"
  done < <(find "$src_root" -type f)
  printf '\033[32m    ok  %-28s %4d file(s)\033[0m\n' "$rel" "$((N_COPIED - before))"
}

# Smart-merge the rig settings template INTO the user's live settings.json.
#   - no live file   -> copy the template verbatim (fresh install)
#   - live + python3 -> back up, then UNION in top-level keys / env / permissions /
#                       enabledPlugins / extraKnownMarketplaces / hooks. User values win;
#                       nothing the user has is removed. Idempotent on re-run.
#   - live, no python -> leave settings.json UNTOUCHED (never clobber), point to the
#                        template so the user can merge by hand.
merge_settings() {
  tpl="$1"; live="$2"
  if [ ! -f "$tpl" ]; then yellow "settings template missing, skipping: $tpl"; return; fi

  if [ ! -f "$live" ]; then
    if [ "$DRY" = 1 ]; then yellow "would create settings.json (fresh, from template)"; return; fi
    cp "$tpl" "$live"; green "installed settings.json (fresh)"; return
  fi

  if ! command -v python3 >/dev/null 2>&1; then
    yellow "python3 not found — cannot smart-merge; your settings.json is left UNTOUCHED."
    yellow "merge the rig config by hand from: $tpl"
    return
  fi

  if [ "$DRY" = 1 ]; then yellow "would back up settings.json -> .bak-$STAMP and smart-merge the rig config in"; return; fi

  out="$(python3 - "$tpl" "$live" <<'PY'
import json, sys
tpl  = json.load(open(sys.argv[1], encoding='utf-8'))
live = json.load(open(sys.argv[2], encoding='utf-8'))
if not isinstance(live, dict):
    sys.exit(1)

TOKENS = ['pitfall-tips','check-cc-updates','rig-audit-nudge','shopify-token-check',
          'browser-nav-denylist','protected-path-denylist','asset-delete-guard',
          'shop-identity-guard','shop-token-identity-block','destructive-block',
          'trio-fanout-cap','SGRR AGI V2 rig','Read MEMORY.md','PRE-COMPACT','END-OF-TURN']

def marker(entry):
    if not isinstance(entry, dict):
        return ''
    cmds = ' '.join(h.get('command','') for h in entry.get('hooks',[]) if isinstance(h, dict))
    for t in TOKENS:
        if t in cmds:
            return t
    return cmds

# 1. top-level scalar keys — inject only if the user lacks them
for k, v in tpl.items():
    if k in ('hooks','permissions','enabledPlugins','env','extraKnownMarketplaces'):
        continue
    live.setdefault(k, v)

# 2. env — union
if isinstance(tpl.get('env'), dict):
    le = live.setdefault('env', {})
    if isinstance(le, dict):
        for k, v in tpl['env'].items():
            le.setdefault(k, v)

# 3. permissions — union allow/ask/deny arrays, inject other keys if absent
if isinstance(tpl.get('permissions'), dict):
    lp = live.setdefault('permissions', {})
    if isinstance(lp, dict):
        tp = tpl['permissions']
        for sub in ('allow','ask','deny'):
            if sub not in tp:
                continue
            cur = lp.get(sub) or []
            for item in tp[sub]:
                if item not in cur:
                    cur.append(item)
            lp[sub] = cur
        for pk, pv in tp.items():
            if pk in ('allow','ask','deny'):
                continue
            lp.setdefault(pk, pv)

# 4. plugin / marketplace maps — union
for mk in ('enabledPlugins','extraKnownMarketplaces'):
    if isinstance(tpl.get(mk), dict):
        lm = live.setdefault(mk, {})
        if isinstance(lm, dict):
            for k, v in tpl[mk].items():
                lm.setdefault(k, v)

# 5. hooks — union per event by marker
if isinstance(tpl.get('hooks'), dict):
    lh = live.setdefault('hooks', {})
    if isinstance(lh, dict):
        for evt, entries in tpl['hooks'].items():
            cur = lh.get(evt) or []
            have = set(marker(e) for e in cur)
            for te in entries:
                m = marker(te)
                if m not in have:
                    cur.append(te); have.add(m)
            lh[evt] = cur

print(json.dumps(live, indent=2, ensure_ascii=False))
PY
)" || { yellow "merge failed — settings.json left untouched"; return; }

  if [ -n "$out" ]; then
    cp "$live" "$live.bak-$STAMP"; green "backup settings.json -> .bak-$STAMP"
    printf '%s\n' "$out" > "$live"; green "smart-merged settings.json (rig config unioned in)"
  else
    yellow "merge produced no output — settings.json left untouched"
  fi
}

cyan "Target: $CLAUDE"
[ -d "$CLAUDE" ] || { if [ "$DRY" = 1 ]; then yellow "would create $CLAUDE"; else mkdir -p "$CLAUDE"; green "created $CLAUDE"; fi; }

cyan "Core files"
copy_one "$REPO/CLAUDE.md"   "$CLAUDE/CLAUDE.md"      && green "installed CLAUDE.md"
copy_one "$REPO/PITFALLS.md" "$CLAUDE/PITFALLS.md"    && green "installed PITFALLS.md"
copy_one "$REPO/USAGE.md"    "$CLAUDE/SGRR-GUIDE.md"  && green "installed SGRR-GUIDE.md"

cyan "Trees"
copy_tree memory
copy_tree rules
copy_tree commands
copy_tree agents
copy_tree scripts
if [ "$MINIMAL" = 0 ]; then
  copy_tree skills
  copy_tree docs
  copy_tree shops
  copy_tree shopify
  # The training libraries. ~32 MB of text, and the reason the repo is private - the
  # bundles under formations/bundles/ are meant to be pasted straight into a chat, so
  # they have to land next to everything else for the install to be one click.
  copy_tree formations
else
  yellow "--minimal: skipped skills/, docs/, shops/, shopify/, formations/"
fi

cyan "Local config"
if [ -f "$CLAUDE/protected-zones.json" ]; then
  green "protected-zones.json already exists — left untouched"
elif [ -f "$REPO/protected-zones.example.json" ]; then
  if [ "$DRY" = 1 ]; then yellow "would seed protected-zones.json from the example"
  else cp "$REPO/protected-zones.example.json" "$CLAUDE/protected-zones.json"
       green "seeded protected-zones.json (EDIT IT: it currently lists placeholder folders)"; fi
fi
if [ -f "$CLAUDE/shops-registry.md" ]; then
  green "shops-registry.md already exists — left untouched"
elif [ -f "$REPO/shops/shops-registry.template.md" ]; then
  if [ "$DRY" = 1 ]; then yellow "would seed shops-registry.md from the template"
  else cp "$REPO/shops/shops-registry.template.md" "$CLAUDE/shops-registry.md"; green "seeded shops-registry.md"; fi
fi

cyan "settings.json"
merge_settings "$REPO/settings.template.unix.json" "$CLAUDE/settings.json"

# Install the pre-commit hook into THIS repo
if [ -d "$REPO/.git/hooks" ] && [ -f "$REPO/scripts/hooks/pre-commit" ]; then
  if [ "$DRY" = 1 ]; then yellow "would install the pre-commit hook"
  else cp "$REPO/scripts/hooks/pre-commit" "$REPO/.git/hooks/pre-commit"; chmod +x "$REPO/.git/hooks/pre-commit"; green "pre-commit hook installed"; fi
fi

echo
cyan "Files: $N_COPIED written, $N_SKIPPED identical (skipped), $N_BACKED backed up as .bak-$STAMP"
cyan "Usage guide -> ~/.claude/SGRR-GUIDE.md"
cyan "Remaining steps (inside Claude Code):"
echo "    1. /plugin marketplace add JuliusBrussee/caveman"
echo "    2. enable the plugins (see SETUP.md) or paste INSTALLER-PROMPT.md"
echo "    3. edit ~/.claude/protected-zones.json — name YOUR read-only folders"
echo "    4. edit ~/.claude/shops-registry.md if you run stores"
echo "    5. open ~/.claude/CLAUDE.md and fill in the <PLACEHOLDER>s"
echo "    6. ./scripts/verify-install.sh   (parity self-test)"
echo "    7. restart Claude Code, check /plugin and /help"
[ "$DRY" = 1 ] && echo && yellow "(Dry-run: nothing was written.)"
exit 0
