#!/usr/bin/env bash
# check-cc-updates.sh — veille des mises a jour Claude Code (SGRR AGI V2, macOS/Linux)
#
# Hook SessionStart. Compare la DERNIERE version publiee de Claude Code (en-tete du
# CHANGELOG officiel) a la derniere version dont on t'a deja parle (cache local). Si une
# nouvelle version est sortie, injecte un additionalContext qui te demande d'aller LIRE le
# changelog, de PREVENIR l'utilisateur des nouveautes actionnables, et de PROPOSER les
# adoptions pour le rig. Boucle d'auto-amelioration : chaque release => tu verifies => tu proposes.
#
# Robuste : sortie 0 quoi qu'il arrive, 1 appel reseau / 12 h max (throttle via cache).
# Aucune donnee perso. Cache : $HOME/.claude/.cc-update-cache.json
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

# Throttle : pas plus d'un appel reseau toutes les 12 h (43200 s)
[ $(( now - last_check )) -lt 43200 ] && exit 0

latest=$(curl -fsS --max-time 4 "$changelog_url" 2>/dev/null \
  | grep -oE '^##[[:space:]]+[0-9]+\.[0-9]+\.[0-9]+' | head -1 \
  | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
[ -z "$latest" ] && exit 0

mkdir -p "$cache_dir" 2>/dev/null || true
printf '{"lastCheckEpoch":%s,"lastVersion":"%s"}\n' "$now" "$latest" > "$cache" 2>/dev/null || true

# Nouvelle version par rapport au dernier point connu -> nudge (jamais au tout 1er run)
if [ -n "$prev_version" ] && [ "$latest" != "$prev_version" ]; then
  msg="Veille Claude Code : nouvelle version publiee = ${latest} (precedente connue : ${prev_version}). ACTION : va lire le CHANGELOG (${changelog_view}), previens l utilisateur des nouveautes actionnables, et propose ce qu on peut adopter dans le rig SGRR AGI V2 (settings.json, hooks, CLAUDE.md, scripts). Ne modifie rien sans son accord."
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$msg"
fi
exit 0
