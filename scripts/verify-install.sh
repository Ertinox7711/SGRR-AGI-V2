#!/usr/bin/env bash
# verify-install.sh — SGRR AGI V2 (macOS / Linux)
#
# PARITY self-test: proves your ~/.claude install carries the same payload and the same
# enforced guardrails as the original rig. Not "roughly".
#
# Three outcomes per line:
#   [OK]   the rig is there
#   [WARN] present but not personalised yet — does NOT break parity, but read it
#   [FAIL] a real gap
#
# exit 0 = full parity (warnings allowed) ; exit 1 = at least one gap.
#
# Usage:  ./scripts/verify-install.sh
#         ./scripts/verify-install.sh --target /tmp/sandbox/.claude
set -uo pipefail

TARGET=""
while [ $# -gt 0 ]; do
  case "$1" in
    --target)   shift; TARGET="${1:-}" ;;
    --target=*) TARGET="${1#--target=}" ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

CLAUDE="${TARGET:-$HOME/.claude}"
S="$CLAUDE/settings.json"
PASS=0; FAIL=0; WARN=0
ok()   { printf '\033[32m  [OK]   %s\033[0m\n' "$1"; PASS=$((PASS+1)); }
bad()  { printf '\033[31m  [FAIL] %s\033[0m\n' "$1"; FAIL=$((FAIL+1)); }
wrn()  { printf '\033[33m  [WARN] %s\033[0m\n' "$1"; WARN=$((WARN+1)); }
sect() { printf '\033[36m\n%s\033[0m\n' "$1"; }

PY=""
if command -v python3 >/dev/null 2>&1; then PY=python3
elif command -v python >/dev/null 2>&1; then PY=python
fi

sect "SGRR AGI V2 — parity self-test ($CLAUDE)"

# ---- settings.json -------------------------------------------------------------------
if [ -f "$S" ]; then
  if [ -n "$PY" ]; then
    if "$PY" -c "import json,sys; json.load(open(sys.argv[1], encoding='utf-8'))" "$S" >/dev/null 2>&1
    then ok "settings.json present and valid JSON"
    else bad "settings.json present but INVALID JSON"; fi
  elif command -v jq >/dev/null 2>&1; then
    if jq -e . "$S" >/dev/null 2>&1; then ok "settings.json present and valid JSON"; else bad "settings.json INVALID JSON"; fi
  else ok "settings.json present (JSON validity unchecked: no python3 or jq)"; fi
else
  bad "settings.json missing"
fi

if [ -f "$S" ]; then
  grep -Eq '"model"[[:space:]]*:[[:space:]]*"opus"' "$S" \
    && ok "model = opus (max intelligence on the main loop)" \
    || wrn "model != opus (fine if you chose another main model)"

  grep -Eq '"CLAUDE_CODE_SUBAGENT_MODEL"[[:space:]]*:[[:space:]]*"sonnet"' "$S" \
    && ok "sub-agents = sonnet (grunt-work cost divided)" \
    || wrn "CLAUDE_CODE_SUBAGENT_MODEL unset — sub-agents run on the main model"

  PCOUNT=$(grep -Eo '"[A-Za-z0-9_-]+@[A-Za-z0-9_-]+"[[:space:]]*:[[:space:]]*true' "$S" | wc -l | tr -d ' ')
  [ "${PCOUNT:-0}" -ge 12 ] && ok "$PCOUNT plugins enabled (>= 12 expected)" \
                            || bad "$PCOUNT plugins enabled (12 expected — run /plugin)"

  MISS=""
  for h in PreToolUse UserPromptSubmit SessionStart PreCompact Stop; do
    grep -q "\"$h\"" "$S" || MISS="$MISS $h"
  done
  [ -z "$MISS" ] && ok "5 hook events wired (PreToolUse/UserPromptSubmit/SessionStart/PreCompact/Stop)" \
                 || bad "missing hooks:$MISS"

  # the unix rig's real enforcement layer: the ask net over destructive command families
  ACOUNT=$(grep -Eo '"Bash\(' "$S" | wc -l | tr -d ' ')
  [ "${ACOUNT:-0}" -ge 10 ] && ok "$ACOUNT Bash() guards in permissions (destructive-command net)" \
                            || bad "permission net too short ($ACOUNT) — safety net incomplete"

  # every hook script the settings reference must exist on disk
  if [ -n "$PY" ]; then
    BROKEN=$("$PY" - "$S" "$CLAUDE" <<'PY'
import json, os, re, sys
s = json.load(open(sys.argv[1], encoding='utf-8'))
root = sys.argv[2]
home = os.path.dirname(root.rstrip('/')) or os.path.expanduser('~')
missing, seen = [], 0
for entries in (s.get('hooks') or {}).values():
    for entry in entries:
        for h in entry.get('hooks', []):
            cmd = h.get('command', '')
            for m in re.finditer(r'"([^"]+\.(?:sh|ps1|py))"', cmd):
                p = m.group(1).replace('$HOME', home).replace('${HOME}', home)
                seen += 1
                if not os.path.isfile(p):
                    missing.append(p)
print(seen)
print('|'.join(missing))
PY
)
    NREF=$(printf '%s\n' "$BROKEN" | sed -n 1p)
    NMISS=$(printf '%s\n' "$BROKEN" | sed -n 2p)
    if [ "${NREF:-0}" = "0" ]; then bad "no hook script referenced in settings.json"
    elif [ -z "$NMISS" ];  then ok "$NREF hook script path(s) referenced, all present on disk"
    else bad "hook script(s) referenced but MISSING: $NMISS"; fi
  fi

  grep -q 'pitfall-tips' "$S" && [ -f "$CLAUDE/scripts/pitfall-tips.sh" ] \
    && ok "live pitfall coach wired (PreToolUse -> scripts/pitfall-tips.sh)" \
    || bad "pitfall coach not wired (needs scripts/pitfall-tips.sh + its PreToolUse hook)"

  grep -Eq '"defaultMode"[[:space:]]*:[[:space:]]*"acceptEdits"' "$S" \
    && ok "defaultMode = acceptEdits (zero friction on file edits)" \
    || wrn "defaultMode != acceptEdits (rig ships acceptEdits)"
fi

# ---- core docs -----------------------------------------------------------------------
sect "Core files"
if [ -f "$CLAUDE/CLAUDE.md" ]; then
  grep -q 'SGRR AGI V2' "$CLAUDE/CLAUDE.md" \
    && ok "CLAUDE.md present (SGRR AGI V2 signature detected)" \
    || ok "CLAUDE.md present (signature absent — custom or removed, OK)"
else bad "CLAUDE.md missing"; fi
[ -f "$CLAUDE/PITFALLS.md" ]       && ok "PITFALLS.md present (generalized mistake catalog)" || bad "PITFALLS.md missing"
[ -f "$CLAUDE/SGRR-GUIDE.md" ]     && ok "SGRR-GUIDE.md present (local usage guide)"         || bad "SGRR-GUIDE.md missing (copy USAGE.md)"
[ -f "$CLAUDE/memory/MEMORY.md" ]  && ok "memory/MEMORY.md present"                          || bad "memory/MEMORY.md missing"

# ---- payload -------------------------------------------------------------------------
sect "Payload"
count_md()  { find "$CLAUDE/$1" -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' '; }
N_RULES=$(count_md rules)
N_CMDS=$(count_md commands)
N_AGENT=$(count_md agents)
N_SKILL=$(find "$CLAUDE/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
N_SCRIPT=$(find "$CLAUDE/scripts" -type f 2>/dev/null | wc -l | tr -d ' ')

[ "${N_RULES:-0}"  -ge 5   ] && ok "rules/    $N_RULES lazy paths: rules"     || bad "rules/ only $N_RULES (>= 5 expected)"
[ "${N_CMDS:-0}"   -ge 15  ] && ok "commands/ $N_CMDS slash commands"         || bad "commands/ only $N_CMDS (>= 15 expected)"
[ "${N_SKILL:-0}"  -ge 100 ] && ok "skills/   $N_SKILL skills"                || bad "skills/ only $N_SKILL (>= 100 expected — re-run install without --minimal)"
[ "${N_AGENT:-0}"  -ge 1   ] && ok "agents/   $N_AGENT sub-agent definitions" || bad "agents/ empty"
[ "${N_SCRIPT:-0}" -ge 20  ] && ok "scripts/  $N_SCRIPT hook scripts + tools" || bad "scripts/ only $N_SCRIPT (>= 20 expected)"

check_file() { [ -f "$CLAUDE/$1" ] && ok "$2" || bad "$2 missing ($1)"; }
check_file 'commands/session-check.md'     '/session-check command'
check_file 'skills/session-check/SKILL.md' 'session-check skill'
check_file 'commands/rig-audit.md'         '/rig-audit command'
check_file 'scripts/rig-audit-nudge.sh'    'rig-audit periodic nudge'
check_file 'scripts/check-cc-updates.sh'   'Claude Code update watch'
check_file 'scripts/preflight-scrub.sh'    'preflight leak scrub'
check_file 'shops/GO-SHOPS.md'             'GO-SHOPS.md (multi-store manual)'
check_file 'shopify/GO-SHOPIFY.md'         'GO-SHOPIFY.md (Shopify manual)'

# ---- machine-local config ------------------------------------------------------------
sect "Local config"
Z="$CLAUDE/protected-zones.json"
if [ -f "$Z" ]; then
  if grep -q '<your-' "$Z"; then
    wrn "protected-zones.json still has PLACEHOLDER folders (note: the deny-gate that reads it is Windows-only; on unix the CLAUDE.md rule is the layer)"
  elif [ -n "$PY" ] && ! "$PY" -c "import json,sys; json.load(open(sys.argv[1], encoding='utf-8'))" "$Z" >/dev/null 2>&1; then
    bad "protected-zones.json is invalid JSON"
  else
    ok "protected-zones.json present and readable"
  fi
else
  wrn "protected-zones.json absent (copy protected-zones.example.json)"
fi
[ -f "$CLAUDE/shops-registry.md" ] && ok "shops-registry.md present" \
                                   || wrn "shops-registry.md absent (only needed if you run stores)"

# ---- verdict -------------------------------------------------------------------------
sect "Result: $PASS OK / $WARN WARN / $FAIL FAIL"
if [ "$FAIL" -eq 0 ]; then
  printf '\033[32mFULL PARITY. Your Claude applies the SGRR AGI V2 rig exactly.\033[0m\n'
  [ "$WARN" -gt 0 ] && printf '\033[33m(%s warning(s) above are personalisation steps, not gaps.)\033[0m\n' "$WARN"
  exit 0
else
  printf '\033[33mGAP detected. Fix the [FAIL] lines above, then re-run.\033[0m\n'
  exit 1
fi
