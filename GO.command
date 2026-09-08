#!/usr/bin/env bash
# macOS double-click entry point. Same as GO.sh.
cd "$(dirname "${BASH_SOURCE[0]}")"
exec bash ./GO.sh "$@"
