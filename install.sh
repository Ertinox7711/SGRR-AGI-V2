#!/usr/bin/env bash
# install.sh — SGRR AGI V2 (macOS / Linux)
#
# Copie la partie FICHIERS du rig vers ~/.claude avec backup automatique de l'existant.
# N'installe PAS les plugins (via /plugin dans Claude Code — voir INSTALLER-PROMPT.md).
# Ne lit, ne demande, ne stocke aucun secret.
#
# Usage:
#   ./install.sh            # installe
#   ./install.sh --dry-run  # montre ce qui serait fait, sans rien ecrire
set -euo pipefail

DRY=0
[ "${1:-}" = "--dry-run" ] && DRY=1

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE="$HOME/.claude"
STAMP="$(date +%Y%m%d-%H%M%S)"

cyan()  { printf '\033[36m==> %s\033[0m\n' "$1"; }
green() { printf '\033[32m    ok  %s\033[0m\n' "$1"; }
yellow(){ printf '\033[33m    !!  %s\033[0m\n' "$1"; }

cyan "Cible : $CLAUDE"
for d in "$CLAUDE" "$CLAUDE/memory" "$CLAUDE/rules"; do
  if [ ! -d "$d" ]; then
    if [ "$DRY" = 1 ]; then yellow "creerait $d"; else mkdir -p "$d"; green "cree $d"; fi
  fi
done

# Sur macOS/Linux on prend la variante hooks-sh du settings.
declare -a SRC=( "settings.template.unix.json" "CLAUDE.md" "UTILISATION.md" "memory/MEMORY.md" "rules/example-project.md" )
declare -a DST=( "settings.json"               "CLAUDE.md" "SGRR-GUIDE.md"  "memory/MEMORY.md" "rules/example-project.md" )

for i in "${!SRC[@]}"; do
  s="$REPO/${SRC[$i]}"; d="$CLAUDE/${DST[$i]}"
  if [ ! -f "$s" ]; then yellow "source absente, saute : ${SRC[$i]}"; continue; fi
  if [ -f "$d" ]; then
    if [ "$DRY" = 1 ]; then yellow "sauvegarderait ${DST[$i]} -> ${DST[$i]}.bak-$STAMP"
    else cp "$d" "$d.bak-$STAMP"; green "backup ${DST[$i]} -> .bak-$STAMP"; fi
  fi
  if [ "$DRY" = 1 ]; then yellow "copierait ${SRC[$i]} -> ${DST[$i]}"
  else cp "$s" "$d"; green "installe ${DST[$i]}"; fi
done

# Installe le hook pre-commit dans CE repo
if [ -d "$REPO/.git/hooks" ] && [ -f "$REPO/scripts/hooks/pre-commit" ]; then
  if [ "$DRY" = 1 ]; then yellow "installerait le hook pre-commit"
  else cp "$REPO/scripts/hooks/pre-commit" "$REPO/.git/hooks/pre-commit"; chmod +x "$REPO/.git/hooks/pre-commit"; green "hook pre-commit installe"; fi
fi

echo
cyan "Fichiers ok. Guide d'utilisation -> ~/.claude/SGRR-GUIDE.md"
cyan "Etapes restantes (dans Claude Code) :"
echo "    1. /plugin marketplace add JuliusBrussee/caveman"
echo "    2. active les plugins (voir SETUP.md) ou colle INSTALLER-PROMPT.md"
echo "    3. ouvre ~/.claude/CLAUDE.md et remplis les <PLACEHOLDER>"
echo "    4. ./scripts/verify-install.sh  (self-test de parite)"
echo "    5. redemarre Claude Code, verifie /plugin et /help"
[ "$DRY" = 1 ] && echo && yellow "(Dry-run : rien n'a ete ecrit.)"
