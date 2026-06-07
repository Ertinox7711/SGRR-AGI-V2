#Requires -Version 5.1
<#
  rig-audit-nudge.ps1 — periodic self-improvement nudge (SGRR AGI V2, Windows)

  SessionStart hook. Every 7 days (throttled via a local cache), it injects a single
  additionalContext line reminding you that the user can run /rig-audit — the command
  that analyzes all their sessions + project folders and proposes how the rig could
  improve. It never runs the audit itself and never acts unprompted; it only reminds.

  Robust by design: wrapped in try/catch, exits 0 no matter what. No personal data.
  Cache: %USERPROFILE%\.claude\.rig-audit-cache.json
#>
$ErrorActionPreference = 'SilentlyContinue'
try {
  $cacheDir = Join-Path $env:USERPROFILE '.claude'
  $cache    = Join-Path $cacheDir '.rig-audit-cache.json'
  $intervalDays = 7

  $lastNudgeUtc = $null
  if (Test-Path -LiteralPath $cache) {
    $state = Get-Content -Raw -LiteralPath $cache | ConvertFrom-Json
    $lastNudgeUtc = $state.lastNudgeUtc
  }

  # First run: set the baseline silently, never nudge on day zero.
  if (-not $lastNudgeUtc) {
    if (-not (Test-Path -LiteralPath $cacheDir)) { New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null }
    @{ lastNudgeUtc = (Get-Date).ToUniversalTime().ToString('o') } |
      ConvertTo-Json | Set-Content -LiteralPath $cache -Encoding UTF8
    exit 0
  }

  # Throttle: nudge at most once every 7 days.
  $elapsed = (Get-Date).ToUniversalTime() - ([datetime]::Parse($lastNudgeUtc)).ToUniversalTime()
  if ($elapsed.TotalDays -lt $intervalDays) { exit 0 }

  # Due: re-baseline, then nudge once.
  @{ lastNudgeUtc = (Get-Date).ToUniversalTime().ToString('o') } |
    ConvertTo-Json | Set-Content -LiteralPath $cache -Encoding UTF8

  $msg = "SGRR AGI V2 self-improvement: it has been over $intervalDays days since the last rig review. " +
         "You MAY remind the user (once, briefly) that they can run /rig-audit - it analyzes their " +
         "sessions and project folders and proposes concrete upgrades to the rig (rules, memory, " +
         "commands, hooks, settings). Do NOT run it unprompted; only mention it if it fits the moment."
  @{ hookSpecificOutput = @{ hookEventName = 'SessionStart'; additionalContext = $msg } } |
    ConvertTo-Json -Compress -Depth 5 | Write-Output
} catch { }
exit 0
