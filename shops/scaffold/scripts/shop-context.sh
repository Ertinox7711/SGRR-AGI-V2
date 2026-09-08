#!/usr/bin/env bash
# shop-context.sh — à SOURCER par tout script bash de la boutique.
# Exporte SHOP / HANDLE / API_DOMAIN dérivés du .secrets/app-credentials.txt
# du DOSSIER COURANT → un script copié d'une autre boutique s'auto-corrige à la
# boutique du dossier où il tourne (zéro handle/domaine en dur = anti-confusion).
#
# Usage dans un script:  source "$(dirname "${BASH_SOURCE[0]}")/shop-context.sh"
#   puis utiliser $SHOP (xxx.myshopify.com), $HANDLE (xxx), $AT (token courant).
set -euo pipefail

_HERE="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
_ROOT="$(cd "$_HERE/.." && pwd)"
_SECRETS="$_ROOT/.secrets"
_CREDS="$_SECRETS/app-credentials.txt"

[ -f "$_CREDS" ] || { echo "ERREUR: $_CREDS introuvable — impossible de dériver l'identité boutique." >&2; return 1 2>/dev/null || exit 1; }
# shellcheck disable=SC1090
source "$_CREDS"   # définit SHOP, CLIENT_ID, CLIENT_SECRET

export SHOP
export API_DOMAIN="$SHOP"
export HANDLE="${SHOP%%.myshopify.com}"

# Token courant si présent (sinon le script appellera get-token.sh).
if [ -f "$_SECRETS/access-token.txt" ]; then
  AT="$(cat "$_SECRETS/access-token.txt")"
  export AT
fi
