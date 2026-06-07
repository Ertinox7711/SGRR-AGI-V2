#Requires -Version 5.1
<#
  install.ps1 — SGRR AGI V2 (Windows)

  Copies the FILE part of the rig into ~/.claude with automatic backup of anything it
  overwrites. Does NOT install plugins (that's done via /plugin inside Claude Code —
  see INSTALLER-PROMPT.md). Never reads, asks for, or stores any secret.

  Usage:
    ./install.ps1            # install
    ./install.ps1 -DryRun    # show what would happen, write nothing
#>
[CmdletBinding()]
param([switch]$DryRun)

$ErrorActionPreference = 'Stop'
$repo   = $PSScriptRoot
$claude = Join-Path $env:USERPROFILE '.claude'
$stamp  = Get-Date -Format 'yyyyMMdd-HHmmss'

function Step($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }
function Ok($msg)   { Write-Host "    ok  $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "    !!  $msg" -ForegroundColor Yellow }

Step "Target: $claude"
foreach ($d in @($claude, (Join-Path $claude 'memory'), (Join-Path $claude 'rules'), (Join-Path $claude 'scripts'), (Join-Path $claude 'commands'))) {
  if (-not (Test-Path $d)) {
    if ($DryRun) { Warn "would create $d" } else { New-Item -ItemType Directory -Force -Path $d | Out-Null; Ok "created $d" }
  }
}

# (source-relative-to-repo, destination-relative-to-~/.claude)
$files = @(
  @{ src = 'settings.template.json';   dst = 'settings.json' },
  @{ src = 'CLAUDE.md';                dst = 'CLAUDE.md' },
  @{ src = 'USAGE.md';                 dst = 'SGRR-GUIDE.md' },
  @{ src = 'memory\MEMORY.md';         dst = 'memory\MEMORY.md' },
  @{ src = 'rules\example-project.md'; dst = 'rules\example-project.md' },
  @{ src = 'commands\rig-audit.md';    dst = 'commands\rig-audit.md' }
)

foreach ($f in $files) {
  $srcPath = Join-Path $repo $f.src
  $dstPath = Join-Path $claude $f.dst
  if (-not (Test-Path $srcPath)) { Warn "source missing, skipping: $($f.src)"; continue }

  if (Test-Path $dstPath) {
    $bak = "$dstPath.bak-$stamp"
    if ($DryRun) { Warn "would back up $($f.dst) -> $($f.dst).bak-$stamp" }
    else { Copy-Item $dstPath $bak -Force; Ok "backup $($f.dst) -> .bak-$stamp" }
  }

  if ($DryRun) { Warn "would copy $($f.src) -> $($f.dst)" }
  else { Copy-Item $srcPath $dstPath -Force; Ok "installed $($f.dst)" }
}

# Install the self-improvement scripts (called by the SessionStart hooks)
foreach ($s in @('check-cc-updates.ps1','rig-audit-nudge.ps1')) {
  $src = Join-Path $repo "scripts\$s"
  $dst = Join-Path $claude "scripts\$s"
  if (Test-Path $src) {
    if ($DryRun) { Warn "would install scripts\$s" }
    else { Copy-Item $src $dst -Force; Ok "installed scripts\$s" }
  }
}

# Install the pre-commit hook into THIS repo (protects your future commits from leaks)
$gitHooks = Join-Path $repo '.git\hooks'
$preCommitSrc = Join-Path $repo 'scripts\hooks\pre-commit'
if ((Test-Path $gitHooks) -and (Test-Path $preCommitSrc)) {
  if ($DryRun) { Warn "would install the pre-commit hook" }
  else { Copy-Item $preCommitSrc (Join-Path $gitHooks 'pre-commit') -Force; Ok "pre-commit hook installed" }
}

Write-Host ""
Step "Files ready. Usage guide -> ~/.claude/SGRR-GUIDE.md"
Step "Remaining steps (inside Claude Code):"
Write-Host "    1. /plugin marketplace add JuliusBrussee/caveman"
Write-Host "    2. enable the plugins (see SETUP.md) or paste INSTALLER-PROMPT.md"
Write-Host "    3. open ~/.claude/CLAUDE.md and fill in the <PLACEHOLDER>s"
Write-Host "    4. ./scripts/verify-install.ps1  (parity self-test)"
Write-Host "    5. restart Claude Code, check /plugin and /help"
if ($DryRun) { Write-Host "`n(Dry-run: nothing was written.)" -ForegroundColor Yellow }
