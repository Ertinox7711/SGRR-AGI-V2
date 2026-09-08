#!/usr/bin/env bash
# preflight-scrub.sh — full repo audit before a push (SGRR AGI V2, macOS/Linux)
# Scans ALL tracked files for secrets, real emails, absolute paths, and checks the
# commit author. Exits 1 if a leak is found. Usage: ./scripts/preflight-scrub.sh
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 2

issues=0
notes=0
ok()   { printf '\033[32m  ok  %s\033[0m\n' "$1"; }
printf '\033[36m==> Preflight audit: %s\033[0m\n' "$(pwd)"

# Reviewed third-party trees listed in .scrubignore are reported as NOTE, not LEAK: still
# printed and counted, never silently dropped. A scanner whose real findings drown in 200
# vendored test fixtures is a scanner nobody reads.
IGNORE_RX=''
if [ -f .scrubignore ]; then
  while IFS= read -r line; do
    line="${line%%$'\r'}"
    case "$line" in ''|'#'*) continue ;; esac
    IGNORE_RX="${IGNORE_RX:+$IGNORE_RX|}^$(printf '%s' "$line" | sed 's/[.[\*^$()+?{|]/\\&/g')"
  done < .scrubignore
  [ -n "$IGNORE_RX" ] && printf '\033[90m    .scrubignore active\033[0m\n'
fi

# flag <file> <message> [hard]
# "hard" = a credential. .scrubignore demotes PII (an address, a home path) in reviewed
# third-party code and in the owner's own training libraries; it NEVER demotes a token,
# because a live key committed under one of those paths is exactly as dead as anywhere
# else. The single exception is named in $ALLOW, not a whole directory.
flag() {
  if [ -z "${3:-}" ] && [ -n "$IGNORE_RX" ] && printf '%s' "$1" | grep -Eq "$IGNORE_RX"; then
    printf '\033[90m  note   %s\033[0m\n' "$2"; notes=$((notes+1)); return
  fi
  printf '\033[31m  [LEAK] %s\033[0m\n' "$2"; issues=$((issues+1))
}

ALLOW='<[A-Z_]+>|users\.noreply\.github\.com|example\.(com|org)|\b(you|user|name|runner|youruser)\b|EXAMPLE|AKIAABCDEFGHIJKLMNOP'
# Addresses that are documentation, not contact details: test fixtures, git remotes in a
# README, sample DSNs. Narrow on purpose - a real personal address still fails the run.
EMAIL_ALLOW='noreply|users\.noreply\.github\.com|example\.(com|org)|placeholder|@(test|t|x|y)\.com$|@test\.[a-z]+$|@yourdomain\.|^your@|@evil\.com$|git@(github|gitlab)\.com|@[a-z0-9.-]*supabase\.(com|co)$|@localhost'
# A scanner must exclude its own patterns AND its own config, or it reports itself
# (PITFALLS.md -> secret leak).
SKIP='\.gitleaks\.toml$|\.scrubignore$|SECURITY\.md$|preflight-scrub\.(ps1|sh)$|scripts/hooks/pre-commit$|secret-scan\.yml$|^assets/|/assets/'

# Tracked + non-ignored files (includes new ones not yet committed).
# core.quotePath=false or this scanner reads NOTHING for 87 of the course files: git's
# default renders a non-ASCII name as a quoted, octal-escaped string
# ("formations/.../d\303\251cision.md"), grep then fails to open a file by that literal
# name, and 2>/dev/null swallows the error - a silent skip that still prints CLEAN.
files=$(git -c core.quotePath=false ls-files --cached --others --exclude-standard 2>/dev/null || find . -type f -not -path './.git/*')

# targets -> the file list, NUL-separated, minus the scanner's own meta-files.
targets() { printf '%s\n' "$files" | grep -Ev "$SKIP" | tr '\n' '\0'; }

# One grep per BATCH of files, not one per file: the per-file version spawned ~13 000
# processes on this repo and had not finished after 40 minutes on Windows. -H restores the
# attribution that -o alone would drop, so the batching costs nothing in the report.
# The loop stays in THIS shell (process substitution, not a pipe) or the counters vanish.
scan() { # name regex [hard]
  local name="$1" rx="$2" hard="${3:-}" hit f m
  while IFS= read -r hit; do
    [ -z "$hit" ] && continue
    f=${hit%%:*}; m=${hit#*:}
    # -i on purpose: the placeholder this repo publishes is "YOU" in caps
    # (C:\Users\YOU, /home/YOU). Without it this scanner reported 111 leaks that its
    # PowerShell twin - where -match is case-insensitive by default - reported as clean.
    printf '%s' "$m" | grep -Eiq "$ALLOW" && continue
    flag "$f" "$name in $f  ->  $(printf '%s' "$m" | cut -c1-40)" "$hard"
  done < <(targets | xargs -0 -r grep -EioHI -e "$rx" -- 2>/dev/null || true)
}

# A scanner that cannot OPEN its inputs has to say so instead of printing CLEAN. grep's
# "No such file" goes to the stderr this script discards, so nothing else would notice.
# This is the check that would have caught the quoted-path bug on the day it appeared:
# 87 real files, 0 bytes scanned, green verdict. Pure bash loop, no subprocess per file.
while IFS= read -r -d '' f; do
  [ -r "$f" ] || { printf '\033[31m  [LEAK] unreadable target (scan incomplete): %s\033[0m\n' "$f"; issues=$((issues+1)); }
done < <(targets)

scan "Shopify token"      'shp(at|ca|pa|ss)_[a-f0-9]{32}'          hard
scan "Anthropic key"      'sk-ant-[a-zA-Z0-9_-]{20,}'              hard
scan "OpenAI key"         'sk-[a-zA-Z0-9]{20,}T3BlbkFJ'            hard
scan "GitHub token"       'gh[pousr]_[A-Za-z0-9]{36,}'             hard
scan "AWS key"            'AKIA[0-9A-Z]{16}'                       hard
scan "Slack token"        'xox[baprs]-[A-Za-z0-9-]{10,}'           hard
scan "assigned secret"    '(api[_-]?key|secret|password|passwd|token)[[:space:]]*[:=][[:space:]]*["'"'"'][A-Za-z0-9_-]{24,}["'"'"']'
# A home path is a real one only when a plausible USERNAME follows the slash; requiring
# word characters keeps prose ellipses and code-fence artefacts out of the report.
scan "absolute home path" '([A-Za-z]:\\Users\\[A-Za-z0-9._-]{2,})|(/home/[A-Za-z0-9._-]{2,})|(/Users/[A-Za-z0-9._-]{2,})'

# Real email
while IFS= read -r hit; do
  [ -z "$hit" ] && continue
  f=${hit%%:*}; mail=${hit#*:}
  printf '%s' "$mail" | grep -Eiq "$EMAIL_ALLOW" && continue
  flag "$f" "real email in $f  ->  $mail"
done < <(targets | xargs -0 -r grep -EioHI -e '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' -- 2>/dev/null || true)

# Git author
authors=$(git log --format='%ae' 2>/dev/null | sort -u || true)
if [ -n "$authors" ]; then
  if echo "$authors" | grep -Eiv 'noreply|users\.noreply\.github\.com' | grep -q '@'; then
    flag '' "real email in the git author: $(echo "$authors" | tr '\n' ' ')"
  else
    ok "anonymous git author ($(echo "$authors" | tr '\n' ' '))"
  fi
fi

echo
if [ "$notes" -gt 0 ]; then
  printf '\033[90mnote: %s finding(s) in reviewed third-party paths (.scrubignore) - shown above, not blocking.\033[0m\n' "$notes"
fi
if [ "$issues" -gt 0 ]; then
  printf '\033[31mFAIL: %s potential leak(s). Fix before pushing.\033[0m\n' "$issues"
  exit 1
fi
printf '\033[32mCLEAN: no leak detected. Repo ready to share.\033[0m\n'
