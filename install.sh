#!/usr/bin/env bash
# install.sh — SGRR AGI V2 (macOS / Linux)
#
# Installs the FILE part of the rig into ~/.claude. Plain docs are copied with an
# automatic backup of anything they overwrite. settings.json is NOT clobbered: it is
# SMART-MERGED, so the rig config lands in YOUR OWN live Claude without throwing away
# your keys, plugins, env, permissions, or your own hooks (re-running is idempotent).
#
# Does NOT install plugins (that's /plugin inside Claude Code — see INSTALLER-PROMPT.md).
# Never reads, asks for, or stores any secret.
#
# Usage:
#   ./install.sh            # install
#   ./install.sh --dry-run  # show what would happen, write nothing
set -euo pipefail

DRY=0
[ "${1:-}" = "--dry-run" ] && DRY=1

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE="$HOME/.claude"
STAMP="$(date +%Y%m%d-%H%M%S)"

cyan()  { printf '\033[36m==> %s\033[0m\n' "$1"; }
green() { printf '\033[32m    ok  %s\033[0m\n' "$1"; }
yellow(){ printf '\033[33m    !!  %s\033[0m\n' "$1"; }

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

TOKENS = ['pitfall-tips','check-cc-updates','rig-audit-nudge','SGRR AGI V2 rig','Read MEMORY.md','PRE-COMPACT','END-OF-TURN']

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
for d in "$CLAUDE" "$CLAUDE/memory" "$CLAUDE/rules" "$CLAUDE/scripts" "$CLAUDE/commands" "$CLAUDE/skills" "$CLAUDE/skills/session-check"; do
  if [ ! -d "$d" ]; then
    if [ "$DRY" = 1 ]; then yellow "would create $d"; else mkdir -p "$d"; green "created $d"; fi
  fi
done

# Plain-copy files (clobber with backup). settings.json is handled separately (smart-merge).
declare -a SRC=( "CLAUDE.md" "PITFALLS.md" "USAGE.md"      "memory/MEMORY.md" "rules/example-project.md" "commands/rig-audit.md" "commands/session-check.md" "skills/session-check/SKILL.md" )
declare -a DST=( "CLAUDE.md" "PITFALLS.md" "SGRR-GUIDE.md" "memory/MEMORY.md" "rules/example-project.md" "commands/rig-audit.md" "commands/session-check.md" "skills/session-check/SKILL.md" )

for i in "${!SRC[@]}"; do
  s="$REPO/${SRC[$i]}"; d="$CLAUDE/${DST[$i]}"
  if [ ! -f "$s" ]; then yellow "source missing, skipping: ${SRC[$i]}"; continue; fi
  if [ -f "$d" ]; then
    if [ "$DRY" = 1 ]; then yellow "would back up ${DST[$i]} -> ${DST[$i]}.bak-$STAMP"
    else cp "$d" "$d.bak-$STAMP"; green "backup ${DST[$i]} -> .bak-$STAMP"; fi
  fi
  if [ "$DRY" = 1 ]; then yellow "would copy ${SRC[$i]} -> ${DST[$i]}"
  else cp "$s" "$d"; green "installed ${DST[$i]}"; fi
done

# settings.json — smart-merge the rig config into the user's OWN live Claude settings
merge_settings "$REPO/settings.template.unix.json" "$CLAUDE/settings.json"

# Install the hook scripts (called by the PreToolUse / SessionStart hooks)
for s in check-cc-updates.sh rig-audit-nudge.sh pitfall-tips.sh; do
  if [ -f "$REPO/scripts/$s" ]; then
    if [ "$DRY" = 1 ]; then yellow "would install scripts/$s"
    else cp "$REPO/scripts/$s" "$CLAUDE/scripts/$s"; chmod +x "$CLAUDE/scripts/$s"; green "installed scripts/$s"; fi
  fi
done

# Install the pre-commit hook into THIS repo
if [ -d "$REPO/.git/hooks" ] && [ -f "$REPO/scripts/hooks/pre-commit" ]; then
  if [ "$DRY" = 1 ]; then yellow "would install the pre-commit hook"
  else cp "$REPO/scripts/hooks/pre-commit" "$REPO/.git/hooks/pre-commit"; chmod +x "$REPO/.git/hooks/pre-commit"; green "pre-commit hook installed"; fi
fi

echo
cyan "Files ready. Usage guide -> ~/.claude/SGRR-GUIDE.md"
cyan "settings.json was smart-merged into your live config (backup kept if it changed)."
cyan "Remaining steps (inside Claude Code):"
echo "    1. /plugin marketplace add JuliusBrussee/caveman"
echo "    2. enable the plugins (see SETUP.md) or paste INSTALLER-PROMPT.md"
echo "    3. open ~/.claude/CLAUDE.md and fill in the <PLACEHOLDER>s"
echo "    4. ./scripts/verify-install.sh  (parity self-test)"
echo "    5. restart Claude Code, check /plugin and /help"
[ "$DRY" = 1 ] && echo && yellow "(Dry-run: nothing was written.)"
