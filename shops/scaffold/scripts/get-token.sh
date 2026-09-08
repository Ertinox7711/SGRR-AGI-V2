#!/usr/bin/env bash
# Régénère le token Admin API de la boutique via OAuth client_credentials.
# STORE-AGNOSTIC : ce script ne change JAMAIS d'une boutique à l'autre.
# Seul .secrets/app-credentials.txt (SHOP/CLIENT_ID/CLIENT_SECRET, jamais commit) diffère.
# Le token shpat_ expire après 24h → relancer ce script à chaque session.
# Usage:  bash scripts/get-token.sh            (écrit .secrets/access-token.txt + affiche scopes)
#         AT=$(bash scripts/get-token.sh -q)   (silencieux, renvoie juste le token sur stdout)
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
SECRETS="$ROOT/.secrets"
CREDS="$SECRETS/app-credentials.txt"
OUT="$SECRETS/access-token.txt"

[ -f "$CREDS" ] || { echo "ERREUR: $CREDS introuvable (copie .secrets/app-credentials.txt.example et remplis-le)" >&2; exit 1; }
# app-credentials.txt fournit SHOP, CLIENT_ID, CLIENT_SECRET
# shellcheck disable=SC1090
source "$CREDS"

RESP=$(curl -s -X POST "https://$SHOP/admin/oauth/access_token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials&client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET")

AT=$(echo "$RESP" | sed -n 's/.*"access_token":"\([^"]*\)".*/\1/p')
if [ -z "$AT" ]; then
  echo "ERREUR: pas de token. Réponse:" >&2
  echo "$RESP" >&2
  echo "→ Si app_not_installed: réinstaller l'app sur la boutique (voir SESSION-INIT.md §2)." >&2
  exit 1
fi

printf '%s' "$AT" > "$OUT"

if [ "${1:-}" = "-q" ]; then
  printf '%s' "$AT"
else
  SCOPE=$(echo "$RESP" | sed -n 's/.*"scope":"\([^"]*\)".*/\1/p')
  echo "OK token écrit dans $OUT (valide 24h)"
  echo "scopes: $SCOPE"
fi
