#!/usr/bin/env bash
# verify-install.sh — SGRR AGI V2 (macOS / Linux)
#
# PARITY self-test: proves your ~/.claude install applies EXACTLY the same config and
# the same philosophy as the original rig. Not "roughly".
#
# Output: one line per check (OK / FAIL), a verdict, an exit code.
#   exit 0 = full parity ; exit 1 = at least one gap.
#
# Usage:  ./scripts/verify-install.sh
set -uo pipefail

CLAUDE="$HOME/.claude"
S="$CLAUDE/settings.json"
PASS=0; FAIL=0
ok()   { printf '\033[32m  [OK]   %s\033[0m\n' "$1"; PASS=$((PASS+1)); }
bad()  { printf '\033[31m  [FAIL] %s\033[0m\n' "$1"; FAIL=$((FAIL+1)); }
head() { printf '\033[36m\n%s\033[0m\n' "$1"; }

head "SGRR AGI V2 — parity self-test ($CLAUDE)"

# 1. settings.json + valid JSON
if [ -f "$S" ]; then
  if command -v python3 >/dev/null 2>&1; then
    if python3 -c "import json,sys; json.load(open('$S'))" >/dev/null 2>&1; then ok "settings.json present and valid JSON"
    else bad "settings.json present but INVALID JSON"; fi
  elif command -v jq >/dev/null 2>&1; then
    if jq -e . "$S" >/dev/null 2>&1; then ok "settings.json present and valid JSON"; else bad "settings.json INVALID JSON"; fi
  else ok "settings.json present (JSON validity unchecked: no python3 or jq)"; fi
else bad "settings.json missing"; fi

if [ -f "$S" ]; then
  # 2. model = opus
  grep -Eq '"model"[[:space:]]*:[[:space:]]*"opus"' "$S" && ok "model = opus (max intelligence)" || bad "model != opus"
  # 3. sub-agents = sonnet
  grep -Eq '"CLAUDE_CODE_SUBAGENT_MODEL"[[:space:]]*:[[:space:]]*"sonnet"' "$S" && ok "sub-agents = sonnet (cost divided)" || bad "CLAUDE_CODE_SUBAGENT_MODEL != sonnet"
  # 4. >= 12 plugins enabled
  PCOUNT=$(grep -Eo '"[A-Za-z0-9_-]+@[A-Za-z0-9_-]+"[[:space:]]*:[[:space:]]*true' "$S" | wc -l | tr -d ' ')
  [ "${PCOUNT:-0}" -ge 12 ] && ok "$PCOUNT plugins enabled (>= 12)" || bad "$PCOUNT plugins enabled (12 expected — re-run /plugin)"
  # 5. 4 hooks
  MISS=""
  for h in UserPromptSubmit SessionStart PreCompact Stop; do grep -q "\"$h\"" "$S" || MISS="$MISS $h"; done
  [ -z "$MISS" ] && ok "4 hooks present (UserPromptSubmit/SessionStart/PreCompact/Stop)" || bad "missing hooks:$MISS"
  # 6. destructive-permission safety net
  ACOUNT=$(grep -Eo '"Bash\(' "$S" | wc -l | tr -d ' ')
  [ "${ACOUNT:-0}" -ge 10 ] && ok "$ACOUNT Bash() guards (permissions.ask)" || bad "permission net too short ($ACOUNT)"
fi

# 7. CLAUDE.md + signature
if [ -f "$CLAUDE/CLAUDE.md" ]; then
  grep -q 'SGRR AGI V2' "$CLAUDE/CLAUDE.md" && ok "CLAUDE.md present (SGRR AGI V2 signature detected)" || ok "CLAUDE.md present (signature absent — OK if custom)"
else bad "CLAUDE.md missing"; fi

# 8. memory
[ -f "$CLAUDE/memory/MEMORY.md" ] && ok "memory/MEMORY.md present" || bad "memory/MEMORY.md missing"

# 9. rules
if ls "$CLAUDE"/rules/*.md >/dev/null 2>&1; then ok "rules/*.md present (lazy-loading paths:)"; else bad "rules/ empty or missing"; fi

# 10. local guide
[ -f "$CLAUDE/SGRR-GUIDE.md" ] && ok "SGRR-GUIDE.md present (local usage guide)" || bad "SGRR-GUIDE.md missing (copy USAGE.md)"

# 11. Claude Code update watch (self-improvement loop)
[ -f "$CLAUDE/scripts/check-cc-updates.sh" ] && ok "update watch present (scripts/check-cc-updates.sh)" || bad "update watch missing (copy scripts/check-cc-updates.sh -> ~/.claude/scripts/)"

# 12. rig self-audit (/rig-audit command + periodic nudge)
if [ -f "$CLAUDE/commands/rig-audit.md" ] && [ -f "$CLAUDE/scripts/rig-audit-nudge.sh" ]; then
  ok "rig self-audit present (/rig-audit command + periodic nudge)"
elif [ -f "$CLAUDE/commands/rig-audit.md" ]; then
  bad "rig-audit nudge missing (copy scripts/rig-audit-nudge.sh)"
else
  bad "/rig-audit command missing (copy commands/rig-audit.md -> ~/.claude/commands/)"
fi

head "Result: $PASS OK / $FAIL FAIL"
if [ "$FAIL" -eq 0 ]; then
  printf '\033[32mFULL PARITY. Your Claude applies the SGRR AGI V2 rig exactly.\033[0m\n'
  exit 0
else
  printf '\033[33mGAP detected. Fix the [FAIL] lines above, then re-run.\033[0m\n'
  exit 1
fi
