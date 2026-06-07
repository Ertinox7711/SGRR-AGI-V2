#Requires -Version 5.1
<#
  check-cc-updates.ps1 — veille des mises a jour Claude Code (SGRR AGI V2, Windows)

  Hook SessionStart. Compare la DERNIERE version publiee de Claude Code (en-tete du
  CHANGELOG officiel) a la derniere version dont on t'a deja parle (cache local).
  Si une nouvelle version est sortie, injecte un additionalContext qui te demande
  d'aller LIRE le changelog, de PREVENIR l'utilisateur des nouveautes actionnables,
  et de PROPOSER ce qu'on peut adopter dans le rig. C'est la boucle d'auto-amelioration :
  chaque release => tu verifies => tu proposes.

  Robuste par conception : tout est encadre en try/catch, sortie 0 quoi qu'il arrive,
  appel reseau limite a 1 fois / 12 h (throttle via cache). Aucune donnee perso.

  Cache : %USERPROFILE%\.claude\.cc-update-cache.json
#>
$ErrorActionPreference = 'SilentlyContinue'
try {
  $changelogUrl = 'https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md'
  $changelogView = 'https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md'
  $cacheDir = Join-Path $env:USERPROFILE '.claude'
  $cache    = Join-Path $cacheDir '.cc-update-cache.json'

  $prevVersion = $null
  $lastCheckUtc = $null
  if (Test-Path -LiteralPath $cache) {
    $state = Get-Content -Raw -LiteralPath $cache | ConvertFrom-Json
    $prevVersion  = $state.lastVersion
    $lastCheckUtc = $state.lastCheckUtc
  }

  # Throttle : pas plus d'un appel reseau toutes les 12 h
  if ($lastCheckUtc) {
    $elapsed = (Get-Date).ToUniversalTime() - ([datetime]::Parse($lastCheckUtc)).ToUniversalTime()
    if ($elapsed.TotalHours -lt 12) { exit 0 }
  }

  $resp = Invoke-WebRequest -UseBasicParsing -TimeoutSec 4 -Uri $changelogUrl
  $latest = ([regex]::Match($resp.Content, '(?m)^##\s*([0-9]+\.[0-9]+\.[0-9]+)')).Groups[1].Value
  if (-not $latest) { exit 0 }

  # Persiste le nouveau point de controle (meme si rien de neuf -> juste l'horodatage)
  if (-not (Test-Path -LiteralPath $cacheDir)) { New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null }
  @{ lastCheckUtc = (Get-Date).ToUniversalTime().ToString('o'); lastVersion = $latest } |
    ConvertTo-Json | Set-Content -LiteralPath $cache -Encoding UTF8

  # Nouvelle version par rapport au dernier point connu -> nudge (jamais au tout 1er run)
  if ($prevVersion -and $latest -ne $prevVersion) {
    $msg = "Veille Claude Code : nouvelle version publiee = $latest (precedente connue : $prevVersion). " +
           "ACTION : va lire le CHANGELOG ($changelogView), previens l'utilisateur des nouveautes " +
           "actionnables, et propose ce qu'on peut adopter dans le rig SGRR AGI V2 (settings.json, hooks, " +
           "CLAUDE.md, scripts). Ne modifie rien sans son accord."
    @{ hookSpecificOutput = @{ hookEventName = 'SessionStart'; additionalContext = $msg } } |
      ConvertTo-Json -Compress -Depth 5 | Write-Output
  }
} catch { }
exit 0
