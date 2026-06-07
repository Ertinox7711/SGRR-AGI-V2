#Requires -Version 5.1
<#
  check-cc-updates.ps1 — Claude Code update watch (SGRR AGI V2, Windows)

  SessionStart hook. Compares the LATEST published Claude Code version (top of the
  official CHANGELOG) with the last version you were told about (local cache). If a new
  version shipped, it injects an additionalContext asking you to go READ the changelog,
  TELL the user about the actionable changes, and PROPOSE what the rig can adopt. This is
  the self-improvement loop: every release => you check => you propose.

  Robust by design: everything is wrapped in try/catch, exits 0 no matter what, the
  network call is limited to once / 12 h (throttled via the cache). No personal data.

  Cache: %USERPROFILE%\.claude\.cc-update-cache.json
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

  # Throttle: no more than one network call every 12 h
  if ($lastCheckUtc) {
    $elapsed = (Get-Date).ToUniversalTime() - ([datetime]::Parse($lastCheckUtc)).ToUniversalTime()
    if ($elapsed.TotalHours -lt 12) { exit 0 }
  }

  $resp = Invoke-WebRequest -UseBasicParsing -TimeoutSec 4 -Uri $changelogUrl
  $latest = ([regex]::Match($resp.Content, '(?m)^##\s*([0-9]+\.[0-9]+\.[0-9]+)')).Groups[1].Value
  if (-not $latest) { exit 0 }

  # Persist the new checkpoint (even if nothing is new -> just the timestamp)
  if (-not (Test-Path -LiteralPath $cacheDir)) { New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null }
  @{ lastCheckUtc = (Get-Date).ToUniversalTime().ToString('o'); lastVersion = $latest } |
    ConvertTo-Json | Set-Content -LiteralPath $cache -Encoding UTF8

  # New version vs the last known checkpoint -> nudge (never on the very first run)
  if ($prevVersion -and $latest -ne $prevVersion) {
    $msg = "Claude Code update watch: new version published = $latest (last known: $prevVersion). " +
           "ACTION: go read the CHANGELOG ($changelogView), tell the user about the actionable " +
           "changes, and propose what the SGRR AGI V2 rig can adopt (settings.json, hooks, " +
           "CLAUDE.md, scripts). Do not change anything without their approval."
    @{ hookSpecificOutput = @{ hookEventName = 'SessionStart'; additionalContext = $msg } } |
      ConvertTo-Json -Compress -Depth 5 | Write-Output
  }
} catch { }
exit 0
