#!/usr/bin/env bash
# ===================================================================
#  SGRR AGI V2 — ONE CLICK INSTALL (macOS / Linux)
#
#  Run:  ./GO.sh              (macOS: double-click GO.command instead)
#        ./GO.sh --dry-run    show what would happen, write nothing
#        ./GO.sh --minimal    core only (no skills, docs, shops, shopify)
#
#  Installs the whole rig into ~/.claude and smart-merges the settings WITHOUT
#  destroying your own keys, plugins, permissions or hooks. Nothing is uploaded.
#  No secret is ever read, asked for, or stored. Anything overwritten with
#  different content is backed up as <file>.bak-<date>.
# ===================================================================
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

printf '\n  ===========================================================\n'
printf '    SGRR AGI V2  -  installing into ~/.claude\n'
printf '  ===========================================================\n\n'

bash ./install.sh "$@"

printf '\n  -----------------------------------------------------------\n'
printf '   Files are in place. Two things left, INSIDE Claude Code:\n\n'
printf '     1) /plugin marketplace add JuliusBrussee/caveman\n'
printf '        then enable the plugins listed in SETUP.md\n'
printf '        (or paste INSTALLER-PROMPT.md and let Claude do it)\n\n'
printf '     2) restart Claude Code, then run  /session-check\n'
printf '        -> GO/NO-GO verdict that the rig is actually live\n\n'
printf '   Then personalise:\n'
printf '     ~/.claude/protected-zones.json   (your read-only folders)\n'
printf '     ~/.claude/shops-registry.md      (your stores, if any)\n'
printf '     ~/.claude/CLAUDE.md              (fill the <PLACEHOLDER>s)\n'
printf '  -----------------------------------------------------------\n\n'
