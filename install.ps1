#Requires -Version 5.1
<#
  install.ps1 — SGRR AGI V2 (Windows)

  Copie la partie FICHIERS du rig vers ~/.claude avec backup automatique de l'existant.
  N'installe PAS les plugins (ça se fait via /plugin dans Claude Code — voir INSTALLER-PROMPT.md).
  Ne lit, ne demande, ne stocke aucun secret.

  Usage:
    ./install.ps1            # installe
    ./install.ps1 -DryRun    # montre ce qui serait fait, sans rien écrire
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

Step "Cible : $claude"
foreach ($d in @($claude, (Join-Path $claude 'memory'), (Join-Path $claude 'rules'))) {
  if (-not (Test-Path $d)) {
    if ($DryRun) { Warn "creerait $d" } else { New-Item -ItemType Directory -Force -Path $d | Out-Null; Ok "cree $d" }
  }
}

# (source-relative-au-repo, destination-relative-a-~/.claude)
$files = @(
  @{ src = 'settings.template.json';   dst = 'settings.json' },
  @{ src = 'CLAUDE.md';                dst = 'CLAUDE.md' },
  @{ src = 'memory\MEMORY.md';         dst = 'memory\MEMORY.md' },
  @{ src = 'rules\example-project.md'; dst = 'rules\example-project.md' }
)

foreach ($f in $files) {
  $srcPath = Join-Path $repo $f.src
  $dstPath = Join-Path $claude $f.dst
  if (-not (Test-Path $srcPath)) { Warn "source absente, saute : $($f.src)"; continue }

  if (Test-Path $dstPath) {
    $bak = "$dstPath.bak-$stamp"
    if ($DryRun) { Warn "sauvegarderait $($f.dst) -> $($f.dst).bak-$stamp" }
    else { Copy-Item $dstPath $bak -Force; Ok "backup $($f.dst) -> .bak-$stamp" }
  }

  if ($DryRun) { Warn "copierait $($f.src) -> $($f.dst)" }
  else { Copy-Item $srcPath $dstPath -Force; Ok "installe $($f.dst)" }
}

# Installe le hook pre-commit dans CE repo (protege tes futurs commits de fuites)
$gitHooks = Join-Path $repo '.git\hooks'
$preCommitSrc = Join-Path $repo 'scripts\hooks\pre-commit'
if ((Test-Path $gitHooks) -and (Test-Path $preCommitSrc)) {
  if ($DryRun) { Warn "installerait le hook pre-commit" }
  else { Copy-Item $preCommitSrc (Join-Path $gitHooks 'pre-commit') -Force; Ok "hook pre-commit installe" }
}

Write-Host ""
Step "Fichiers ok. Etapes restantes (dans Claude Code) :"
Write-Host "    1. /plugin marketplace add JuliusBrussee/caveman"
Write-Host "    2. active les plugins (voir SETUP.md) ou colle INSTALLER-PROMPT.md"
Write-Host "    3. ouvre ~/.claude/CLAUDE.md et remplis les <PLACEHOLDER>"
Write-Host "    4. redemarre Claude Code, verifie /plugin et /help"
if ($DryRun) { Write-Host "`n(Dry-run : rien n'a ete ecrit.)" -ForegroundColor Yellow }
