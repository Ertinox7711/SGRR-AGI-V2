#!/usr/bin/env bash
# preflight-scrub.sh — audit complet du repo avant un push (SGRR AGI V2, macOS/Linux)
# Scanne TOUS les fichiers suivis pour secrets, emails réels, chemins absolus,
# et vérifie l'auteur des commits. Sort 1 si fuite. Usage : ./scripts/preflight-scrub.sh
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 2

issues=0
flag() { printf '\033[31m  [FUITE] %s\033[0m\n' "$1"; issues=$((issues+1)); }
ok()   { printf '\033[32m  ok  %s\033[0m\n' "$1"; }
printf '\033[36m==> Audit preflight : %s\033[0m\n' "$(pwd)"

ALLOW='<[A-Z_]+>|users\.noreply\.github\.com|example\.(com|org)|\b(you|user|name|runner|youruser)\b|EXAMPLE'
SKIP='\.gitleaks\.toml$|SECURITE\.md$|preflight-scrub\.(ps1|sh)$|scripts/hooks/pre-commit$|^assets/|/assets/'

# Fichiers suivis + non-ignorés (inclut les nouveaux pas encore commités)
files=$(git ls-files --cached --others --exclude-standard 2>/dev/null || find . -type f -not -path './.git/*')

scan() { # nom regex
  local name="$1" rx="$2"
  while IFS= read -r f; do
    [[ "$f" =~ $SKIP ]] && continue
    [ -f "$f" ] || continue
    while IFS= read -r hit; do
      [ -z "$hit" ] && continue
      echo "$hit" | grep -Eq "$ALLOW" && continue
      flag "$name dans $f  ->  $(echo "$hit" | cut -c1-40)"
    done < <(grep -Eioh "$rx" "$f" 2>/dev/null || true)
  done <<< "$files"
}

scan "token Shopify"      'shp(at|ca|pa|ss)_[a-f0-9]{32}'
scan "cle Anthropic"      'sk-ant-[a-zA-Z0-9_-]{20,}'
scan "cle OpenAI"         'sk-[a-zA-Z0-9]{20,}T3BlbkFJ'
scan "token GitHub"       'gh[pousr]_[A-Za-z0-9]{36,}'
scan "cle AWS"            'AKIA[0-9A-Z]{16}'
scan "token Slack"        'xox[baprs]-[A-Za-z0-9-]{10,}'
scan "secret assigne"     '(api[_-]?key|secret|password|passwd|token)[[:space:]]*[:=][[:space:]]*["'"'"'][A-Za-z0-9_-]{24,}["'"'"']'
scan "chemin home absolu" '([A-Za-z]:\\Users\\[^\\/<> ]+)|(/home/[^/<> ]+)|(/Users/[^/<> ]+)'

# Email reel
while IFS= read -r f; do
  [[ "$f" =~ $SKIP ]] && continue
  [ -f "$f" ] || continue
  while IFS= read -r mail; do
    [ -z "$mail" ] && continue
    echo "$mail" | grep -Eiq 'noreply|users\.noreply\.github\.com|example\.(com|org)|placeholder' && continue
    flag "email reel dans $f  ->  $mail"
  done < <(grep -Eioh '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' "$f" 2>/dev/null || true)
done <<< "$files"

# Auteur git
authors=$(git log --format='%ae' 2>/dev/null | sort -u || true)
if [ -n "$authors" ]; then
  if echo "$authors" | grep -Eiv 'noreply|users\.noreply\.github\.com' | grep -q '@'; then
    flag "email reel dans l'auteur git : $(echo "$authors" | tr '\n' ' ')"
  else
    ok "auteur git anonyme ($(echo "$authors" | tr '\n' ' '))"
  fi
fi

echo
if [ "$issues" -gt 0 ]; then
  printf '\033[31mECHEC : %s fuite(s) potentielle(s). Corrige avant de pousser.\033[0m\n' "$issues"
  exit 1
fi
printf '\033[32mPROPRE : aucune fuite detectee. Repo pret a partager.\033[0m\n'
