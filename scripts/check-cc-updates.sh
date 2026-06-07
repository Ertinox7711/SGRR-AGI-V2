#!/usr/bin/env bash
# check-cc-updates.sh — Claude Code update watch (SGRR AGI V2, macOS/Linux)
#
# SessionStart hook. Compares the LATEST published Claude Code version (top of the
# official CHANGELOG) with the last version you were told about (local cache). If a new
# version shipped, it injects an additionalContext asking you to go READ the changelog,
# TELL the user about the actionable changes, and PROPOSE the adoptions for the rig.
# Self-improvement loop: every release => you check => you propose.
#
# Robust: exits 0 no matter what, 1 network call / 12 h max (throttled via the cache).
# No personal data. Cache: $HOME/.claude/.cc-update-cache.json
set -u

changelog_url='https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md'
changelog_view='https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md'
cache_dir="${HOME}/.claude"
cache="${cache_dir}/.cc-update-cache.json"

now=$(date -u +%s 2>/dev/null) || exit 0
prev_version=""
last_check=0
if [ -f "$cache" ]; then
  prev_version=$(sed -n 's/.*"lastVersion"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$cache" 2>/dev/null)
  last_check=$(sed -n 's/.*"lastCheckEpoch"[[:space:]]*:[[:space:]]*\([0-9]*\).*/\1/p' "$cache" 2>/dev/null)
  [ -z "$last_check" ] && last_check=0
fi

# Throttle: no more than one network call every 12 h (43200 s)
[ $(( now - last_check )) -lt 43200 ] && exit 0

latest=$(curl -fsS --max-time 4 "$changelog_url" 2>/dev/null \
  | grep -oE '^##[[:space:]]+[0-9]+\.[0-9]+\.[0-9]+' | head -1 \
  | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
[ -z "$latest" ] && exit 0

mkdir -p "$cache_dir" 2>/dev/null || true
printf '{"lastCheckEpoch":%s,"lastVersion":"%s"}\n' "$now" "$latest" > "$cache" 2>/dev/null || true

# New version vs the last known checkpoint -> nudge (never on the very first run)
if [ -n "$prev_version" ] && [ "$latest" != "$prev_version" ]; then
  msg="Claude Code update watch: new version published = ${latest} (last known: ${prev_version}). ACTION: go read the CHANGELOG (${changelog_view}), tell the user about the actionable changes, and propose what the SGRR AGI V2 rig can adopt (settings.json, hooks, CLAUDE.md, scripts). Do not change anything without their approval."
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$msg"
fi
exit 0
