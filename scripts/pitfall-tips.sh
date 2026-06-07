#!/usr/bin/env bash
# pitfall-tips.sh — live pitfall coach (SGRR AGI V2, macOS/Linux)
#
# PreToolUse(Bash) hook. Reads the tool call on stdin, matches the command against a
# small ordered table of known traps, and injects the matching PITFALLS lesson as
# additionalContext BEFORE the command runs. First match wins.
#
# - Destructive matches (--no-verify, force-push, reset --hard, git clean, rm -rf) fire
#   EVERY time.
# - Coaching matches (plain push, commit) are throttled to once per few hours via marker
#   files, so they nudge without nagging.
#
# It ONLY ever injects advice — never a permission decision — so it can never auto-allow
# or block a command. That stays the job of permissions.ask.
#
# Robust: exits 0 no matter what. No personal data.
# Markers: $HOME/.claude/.pitfall-tips/<id>
set -u

input="$(cat 2>/dev/null)" || exit 0
[ -z "$input" ] && exit 0

# Extract tool_input.command. Prefer python3 (correct), fall back to a coarse sed grab
# (enough for substring matching).
cmd=""
if command -v python3 >/dev/null 2>&1; then
  cmd="$(printf '%s' "$input" | python3 -c 'import json,sys
try:
    d=json.load(sys.stdin); print(d.get("tool_input",{}).get("command",""))
except Exception:
    pass' 2>/dev/null)"
else
  cmd="$(printf '%s' "$input" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(.*\)/\1/p' | sed 's/"[^"]*$//')"
fi
[ -z "$cmd" ] && exit 0

tdir="${HOME}/.claude/.pitfall-tips"

m() { printf '%s' "$cmd" | grep -Eiq -e "$1"; }

emit() {
  # $1 = additionalContext (kept free of " and \ so it's JSON-safe as-is)
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"%s"}}\n' "$1"
  exit 0
}

# Throttled emit: suppress if this id fired within $2 hours, else touch marker + emit.
emit_throttled() {
  id="$1"; ttl_h="$2"; msg="$3"
  marker="$tdir/$id"
  mins=$(( ttl_h * 60 ))
  if [ -f "$marker" ] && [ -n "$(find "$marker" -mmin -"$mins" 2>/dev/null)" ]; then
    exit 0   # fired recently → stay quiet
  fi
  mkdir -p "$tdir" 2>/dev/null || true
  touch "$marker" 2>/dev/null || true
  emit "$msg"
}

# Ordered trap table. Destructive first (always fire), coaching last (throttled).
if   m '--no-verify'; then
  emit 'PITFALLS/the-bypass: a failing hook is a signal, not an obstacle. --no-verify ships the bug with the alarm disabled. Root-cause what the hook caught; never skip a check to make the bar green. (PITFALLS.md)'
elif m 'git[[:space:]]+push[^|;&]*(--force|-f)([[:space:]]|$)'; then
  emit 'PITFALLS/destructive-op: force-push rewrites published history - anyone who pulled is now broken. Confirm the branch is yours, prefer --force-with-lease, never force a shared branch. (PITFALLS.md)'
elif m 'git[[:space:]]+reset[[:space:]]+--hard'; then
  emit 'PITFALLS/destructive-op: reset --hard discards uncommitted work with NO undo. Check git status / git stash first; confirm there is nothing you want to keep. (PITFALLS.md)'
elif m 'git[[:space:]]+clean([[:space:]]|$)'; then
  emit 'PITFALLS/destructive-op: git clean permanently deletes untracked files. Dry-run first (git clean -nd) and read the list before the real run. (PITFALLS.md)'
elif m '(^|[[:space:]])rm[[:space:]]+-[a-zA-Z]*[rf]'; then
  emit 'PITFALLS/destructive-op: recursive/forced rm has no undo. Echo the exact target, make sure no glob expands wider than intended, confirm a backup or clean git state exists. (PITFALLS.md)'
elif m 'git[[:space:]]+push([[:space:]]|$)'; then
  emit_throttled 'push' 4 'PITFALLS/secret-leak + false-done: push is visible to others and history is forever. Before it: secret-scan/preflight exit 0, diff reviewed, build+tests green. Done = verified, not assumed. (PITFALLS.md)'
elif m 'git[[:space:]]+commit([[:space:]]|$)'; then
  emit_throttled 'commit' 4 'PITFALLS/blind-commit: read git diff --cached in full before committing. One feature per commit, nothing out-of-scope staged; type-check typed code first. (PITFALLS.md)'
fi

exit 0
