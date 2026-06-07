#!/usr/bin/env bash
# rig-audit-nudge.sh — periodic self-improvement nudge (SGRR AGI V2, macOS/Linux)
#
# SessionStart hook. Every 7 days (throttled via a local cache), it injects a single
# additionalContext line reminding you that the user can run /rig-audit — the command
# that analyzes all their sessions + project folders and proposes how the rig could
# improve. It never runs the audit itself and never acts unprompted; it only reminds.
#
# Robust: exits 0 no matter what. No personal data.
# Cache: $HOME/.claude/.rig-audit-cache.json
set -u

cache_dir="${HOME}/.claude"
cache="${cache_dir}/.rig-audit-cache.json"
interval=$(( 7 * 24 * 3600 ))

now=$(date -u +%s 2>/dev/null) || exit 0
last=0
if [ -f "$cache" ]; then
  last=$(sed -n 's/.*"lastNudgeEpoch"[[:space:]]*:[[:space:]]*\([0-9]*\).*/\1/p' "$cache" 2>/dev/null)
  [ -z "$last" ] && last=0
fi

# First run: set the baseline silently, never nudge on day zero.
if [ "$last" -eq 0 ]; then
  mkdir -p "$cache_dir" 2>/dev/null || true
  printf '{"lastNudgeEpoch":%s}\n' "$now" > "$cache" 2>/dev/null || true
  exit 0
fi

# Throttle: nudge at most once every 7 days.
[ $(( now - last )) -lt "$interval" ] && exit 0

# Due: re-baseline, then nudge once.
mkdir -p "$cache_dir" 2>/dev/null || true
printf '{"lastNudgeEpoch":%s}\n' "$now" > "$cache" 2>/dev/null || true

msg="SGRR AGI V2 self-improvement: it has been over 7 days since the last rig review. You MAY remind the user (once, briefly) that they can run /rig-audit - it analyzes their sessions and project folders and proposes concrete upgrades to the rig (rules, memory, commands, hooks, settings). Do NOT run it unprompted; only mention it if it fits the moment."
printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$msg"
exit 0
