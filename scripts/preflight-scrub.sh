#!/usr/bin/env bash
# preflight-scrub.sh — full repo audit before a push (SGRR AGI V2, macOS/Linux)
# Scans ALL tracked files for secrets, real emails, absolute paths, and checks the
# commit author. Exits 1 if a leak is found. Usage: ./scripts/preflight-scrub.sh
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 2

issues=0
flag() { printf '\033[31m  [LEAK] %s\033[0m\n' "$1"; issues=$((issues+1)); }
ok()   { printf '\033[32m  ok  %s\033[0m\n' "$1"; }
printf '\033[36m==> Preflight audit: %s\033[0m\n' "$(pwd)"

ALLOW='<[A-Z_]+>|users\.noreply\.github\.com|example\.(com|org)|\b(you|user|name|runner|youruser)\b|EXAMPLE'
SKIP='\.gitleaks\.toml$|SECURITY\.md$|preflight-scrub\.(ps1|sh)$|scripts/hooks/pre-commit$|secret-scan\.yml$|^assets/|/assets/'

# Tracked + non-ignored files (includes new ones not yet committed)
files=$(git ls-files --cached --others --exclude-standard 2>/dev/null || find . -type f -not -path './.git/*')

scan() { # name regex
  local name="$1" rx="$2"
  while IFS= read -r f; do
    [[ "$f" =~ $SKIP ]] && continue
    [ -f "$f" ] || continue
    while IFS= read -r hit; do
      [ -z "$hit" ] && continue
      echo "$hit" | grep -Eq "$ALLOW" && continue
      flag "$name in $f  ->  $(echo "$hit" | cut -c1-40)"
    done < <(grep -Eioh "$rx" "$f" 2>/dev/null || true)
  done <<< "$files"
}

scan "Shopify token"      'shp(at|ca|pa|ss)_[a-f0-9]{32}'
scan "Anthropic key"      'sk-ant-[a-zA-Z0-9_-]{20,}'
scan "OpenAI key"         'sk-[a-zA-Z0-9]{20,}T3BlbkFJ'
scan "GitHub token"       'gh[pousr]_[A-Za-z0-9]{36,}'
scan "AWS key"            'AKIA[0-9A-Z]{16}'
scan "Slack token"        'xox[baprs]-[A-Za-z0-9-]{10,}'
scan "assigned secret"    '(api[_-]?key|secret|password|passwd|token)[[:space:]]*[:=][[:space:]]*["'"'"'][A-Za-z0-9_-]{24,}["'"'"']'
scan "absolute home path" '([A-Za-z]:\\Users\\[^\\/<> ]+)|(/home/[^/<> ]+)|(/Users/[^/<> ]+)'

# Real email
while IFS= read -r f; do
  [[ "$f" =~ $SKIP ]] && continue
  [ -f "$f" ] || continue
  while IFS= read -r mail; do
    [ -z "$mail" ] && continue
    echo "$mail" | grep -Eiq 'noreply|users\.noreply\.github\.com|example\.(com|org)|placeholder' && continue
    flag "real email in $f  ->  $mail"
  done < <(grep -Eioh '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' "$f" 2>/dev/null || true)
done <<< "$files"

# Git author
authors=$(git log --format='%ae' 2>/dev/null | sort -u || true)
if [ -n "$authors" ]; then
  if echo "$authors" | grep -Eiv 'noreply|users\.noreply\.github\.com' | grep -q '@'; then
    flag "real email in the git author: $(echo "$authors" | tr '\n' ' ')"
  else
    ok "anonymous git author ($(echo "$authors" | tr '\n' ' '))"
  fi
fi

echo
if [ "$issues" -gt 0 ]; then
  printf '\033[31mFAIL: %s potential leak(s). Fix before pushing.\033[0m\n' "$issues"
  exit 1
fi
printf '\033[32mCLEAN: no leak detected. Repo ready to share.\033[0m\n'
