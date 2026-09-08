#!/usr/bin/env bash
# anw-ask.sh - une question au profil Hermes "anw" en une passe (appele par anw-tool.ps1 / ANW.bat).
# Le texte arrive par fichier : les accents, guillemets et & de Windows survivent tels quels.
# Attention : ce fichier doit rester en fins de ligne LF (il est lu par bash depuis /mnt/c).
set -u
export PATH="$HOME/.local/bin:$PATH"
unset ANTHROPIC_API_KEY

Q_FILE="${1:-}"
if [ -z "$Q_FILE" ] || [ ! -f "$Q_FILE" ]; then
  echo "Usage : anw-ask.sh <fichier-question>"
  exit 2
fi
Q=$(tr -d '\r' < "$Q_FILE")
[ -z "$Q" ] && { echo "Question vide."; exit 2; }

if ! curl -s -m 4 http://127.0.0.1:11434/api/version >/dev/null 2>&1; then
  echo "Ollama est eteint (jeu en cours ?) : ANW ne peut pas repondre. Le gardien le rallume quand le GPU est libre."
  exit 3
fi
echo "> $Q"
echo "..."
timeout 900 hermes -p anw chat -Q -q "$Q" 2>&1 | grep -v '^session_id:'
exit 0
