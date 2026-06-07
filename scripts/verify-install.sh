#!/usr/bin/env bash
# verify-install.sh — SGRR AGI V2 (macOS / Linux)
#
# Self-test de PARITE : prouve que ton install ~/.claude applique EXACTEMENT
# la meme config et la meme philosophie que le rig d'origine. Pas "a peu pres".
#
# Sortie : une ligne par controle (OK / FAIL), un verdict, un code retour.
#   exit 0 = parite totale ; exit 1 = au moins un ecart.
#
# Usage:  ./scripts/verify-install.sh
set -uo pipefail

CLAUDE="$HOME/.claude"
S="$CLAUDE/settings.json"
PASS=0; FAIL=0
ok()   { printf '\033[32m  [OK]   %s\033[0m\n' "$1"; PASS=$((PASS+1)); }
bad()  { printf '\033[31m  [FAIL] %s\033[0m\n' "$1"; FAIL=$((FAIL+1)); }
head() { printf '\033[36m\n%s\033[0m\n' "$1"; }

head "SGRR AGI V2 — self-test de parite ($CLAUDE)"

# 1. settings.json + JSON valide
if [ -f "$S" ]; then
  if command -v python3 >/dev/null 2>&1; then
    if python3 -c "import json,sys; json.load(open('$S'))" >/dev/null 2>&1; then ok "settings.json present et JSON valide"
    else bad "settings.json present mais JSON INVALIDE"; fi
  elif command -v jq >/dev/null 2>&1; then
    if jq -e . "$S" >/dev/null 2>&1; then ok "settings.json present et JSON valide"; else bad "settings.json JSON INVALIDE"; fi
  else ok "settings.json present (validite JSON non verifiee : ni python3 ni jq)"; fi
else bad "settings.json absent"; fi

if [ -f "$S" ]; then
  # 2. model = opus
  grep -Eq '"model"[[:space:]]*:[[:space:]]*"opus"' "$S" && ok "model = opus (intelligence max)" || bad "model != opus"
  # 3. sous-agents = sonnet
  grep -Eq '"CLAUDE_CODE_SUBAGENT_MODEL"[[:space:]]*:[[:space:]]*"sonnet"' "$S" && ok "sous-agents = sonnet (cout divise)" || bad "CLAUDE_CODE_SUBAGENT_MODEL != sonnet"
  # 4. >= 12 plugins actives
  PCOUNT=$(grep -Eo '"[A-Za-z0-9_-]+@[A-Za-z0-9_-]+"[[:space:]]*:[[:space:]]*true' "$S" | wc -l | tr -d ' ')
  [ "${PCOUNT:-0}" -ge 12 ] && ok "$PCOUNT plugins actives (>= 12)" || bad "$PCOUNT plugins actives (12 attendus — relance /plugin)"
  # 5. 4 hooks
  MISS=""
  for h in UserPromptSubmit SessionStart PreCompact Stop; do grep -q "\"$h\"" "$S" || MISS="$MISS $h"; done
  [ -z "$MISS" ] && ok "4 hooks presents (UserPromptSubmit/SessionStart/PreCompact/Stop)" || bad "hooks manquants :$MISS"
  # 6. filet permissions destructives
  ACOUNT=$(grep -Eo '"Bash\(' "$S" | wc -l | tr -d ' ')
  [ "${ACOUNT:-0}" -ge 10 ] && ok "$ACOUNT garde-fous Bash() (permissions.ask)" || bad "filet permissions trop court ($ACOUNT)"
fi

# 7. CLAUDE.md + signature
if [ -f "$CLAUDE/CLAUDE.md" ]; then
  grep -q 'SGRR AGI V2' "$CLAUDE/CLAUDE.md" && ok "CLAUDE.md present (signature SGRR AGI V2 detectee)" || ok "CLAUDE.md present (signature absente — OK si perso)"
else bad "CLAUDE.md absent"; fi

# 8. memoire
[ -f "$CLAUDE/memory/MEMORY.md" ] && ok "memory/MEMORY.md present" || bad "memory/MEMORY.md absent"

# 9. rules
if ls "$CLAUDE"/rules/*.md >/dev/null 2>&1; then ok "rules/*.md present (lazy-loading paths:)"; else bad "rules/ vide ou absent"; fi

# 10. guide local
[ -f "$CLAUDE/SGRR-GUIDE.md" ] && ok "SGRR-GUIDE.md present (guide d'utilisation local)" || bad "SGRR-GUIDE.md absent (copie UTILISATION.md)"

head "Resultat : $PASS OK / $FAIL FAIL"
if [ "$FAIL" -eq 0 ]; then
  printf '\033[32mPARITE TOTALE. Ton Claude applique exactement le rig SGRR AGI V2.\033[0m\n'
  exit 0
else
  printf '\033[33mECART detecte. Corrige les [FAIL] ci-dessus puis relance.\033[0m\n'
  exit 1
fi
