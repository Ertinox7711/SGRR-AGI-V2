#!/usr/bin/env bash
# install.sh — SGRR AGI V2 (macOS / Linux)
#
# Copies the FILE part of the rig into ~/.claude with automatic backup of anything it
# overwrites. Does NOT install plugins (that's /plugin inside Claude Code — see
# INSTALLER-PROMPT.md). Never reads, asks for, or stores any secret.
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

cyan "Target: $CLAUDE"
for d in "$CLAUDE" "$CLAUDE/memory" "$CLAUDE/rules" "$CLAUDE/scripts" "$CLAUDE/commands"; do
  if [ ! -d "$d" ]; then
    if [ "$DRY" = 1 ]; then yellow "would create $d"; else mkdir -p "$d"; green "created $d"; fi
  fi
done

# On macOS/Linux we use the sh-hooks variant of settings.
declare -a SRC=( "settings.template.unix.json" "CLAUDE.md" "USAGE.md"      "memory/MEMORY.md" "rules/example-project.md" "commands/rig-audit.md" )
declare -a DST=( "settings.json"               "CLAUDE.md" "SGRR-GUIDE.md" "memory/MEMORY.md" "rules/example-project.md" "commands/rig-audit.md" )

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

# Install the self-improvement scripts (called by the SessionStart hooks)
for s in check-cc-updates.sh rig-audit-nudge.sh; do
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
cyan "Remaining steps (inside Claude Code):"
echo "    1. /plugin marketplace add JuliusBrussee/caveman"
echo "    2. enable the plugins (see SETUP.md) or paste INSTALLER-PROMPT.md"
echo "    3. open ~/.claude/CLAUDE.md and fill in the <PLACEHOLDER>s"
echo "    4. ./scripts/verify-install.sh  (parity self-test)"
echo "    5. restart Claude Code, check /plugin and /help"
[ "$DRY" = 1 ] && echo && yellow "(Dry-run: nothing was written.)"
