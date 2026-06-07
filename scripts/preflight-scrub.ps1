#Requires -Version 5.1
<#
  preflight-scrub.ps1 — audit complet du repo avant un push (SGRR AGI V2, Windows)

  Scanne TOUS les fichiers suivis pour secrets, emails réels, chemins absolus,
  et vérifie l'auteur des commits. À lancer avant le premier push ou après un gros ajout.
  Sort code 1 si une fuite est trouvée.

  Usage : ./scripts/preflight-scrub.ps1
#>
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
Set-Location $repo

$issues = New-Object System.Collections.Generic.List[string]
function Flag($m) { Write-Host "  [FUITE] $m" -ForegroundColor Red; $issues.Add($m) }
function Ok($m)   { Write-Host "  ok  $m" -ForegroundColor Green }

Write-Host "==> Audit preflight : $repo" -ForegroundColor Cyan

# Fichiers suivis + non-ignorés (inclut les nouveaux pas encore commités)
$tracked = (git ls-files --cached --others --exclude-standard 2>$null)
if (-not $tracked) { $tracked = Get-ChildItem -Recurse -File | Resolve-Path -Relative }

# Motifs de secrets/PII : nom -> regex ; exclusions placeholders gérées après
$patterns = [ordered]@{
  'token Shopify'      = 'shp(at|ca|pa|ss)_[a-fA-F0-9]{32}'
  'cle Anthropic'      = 'sk-ant-[a-zA-Z0-9_\-]{20,}'
  'cle OpenAI'         = 'sk-[a-zA-Z0-9]{20,}T3BlbkFJ'
  'token GitHub'       = 'gh[pousr]_[A-Za-z0-9]{36,}'
  'cle AWS'            = 'AKIA[0-9A-Z]{16}'
  'token Slack'        = 'xox[baprs]-[A-Za-z0-9\-]{10,}'
  'secret assigne'     = '(?i)(api[_-]?key|secret|password|passwd|token)\s*[:=]\s*["''][A-Za-z0-9_\-]{24,}["'']'
  'chemin home absolu' = '([A-Za-z]:\\Users\\[^\\/<> "'']+)|(/home/[^/<> "'']+)|(/Users/[^/<> "'']+)'
}
$allow = '<[A-Z_]+>|users\.noreply\.github\.com|example\.(com|org)|\b(you|user|name|runner|youruser)\b|EXAMPLE'
$skipFiles = '\.gitleaks\.toml$|SECURITE\.md$|preflight-scrub\.(ps1|sh)$|(^|[\\/])scripts[\\/]hooks[\\/]pre-commit$|secret-scan\.yml$|(^|[\\/])assets[\\/]'

foreach ($file in $tracked) {
  if ($file -match $skipFiles) { continue }
  if (-not (Test-Path $file)) { continue }
  $content = Get-Content -Raw -LiteralPath $file -ErrorAction SilentlyContinue
  if (-not $content) { continue }
  foreach ($name in $patterns.Keys) {
    $rx = $patterns[$name]
    foreach ($m in [regex]::Matches($content, $rx)) {
      if ($m.Value -match $allow) { continue }
      Flag "$name dans $file  ->  $($m.Value.Substring(0,[Math]::Min(40,$m.Value.Length)))"
    }
  }
}

# Email reel hors placeholders
foreach ($file in $tracked) {
  if ($file -match $skipFiles) { continue }
  if (-not (Test-Path $file)) { continue }
  $content = Get-Content -Raw -LiteralPath $file -ErrorAction SilentlyContinue
  if (-not $content) { continue }
  foreach ($m in [regex]::Matches($content, '[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}')) {
    if ($m.Value -match 'noreply|users\.noreply\.github\.com|example\.(com|org)|placeholder') { continue }
    Flag "email reel dans $file  ->  $($m.Value)"
  }
}

# Auteur des commits
$authors = (git log --format='%ae' 2>$null | Sort-Object -Unique)
if ($authors) {
  $bad = $authors | Where-Object { $_ -and ($_ -notmatch 'noreply|users\.noreply\.github\.com') -and ($_ -match '@') }
  if ($bad) { Flag "email reel dans l'auteur git : $($bad -join ', ')" } else { Ok "auteur git anonyme ($($authors -join ', '))" }
}

Write-Host ""
if ($issues.Count -gt 0) {
  Write-Host "ECHEC : $($issues.Count) fuite(s) potentielle(s). Corrige avant de pousser." -ForegroundColor Red
  exit 1
}
Write-Host "PROPRE : aucune fuite detectee. Repo pret a partager." -ForegroundColor Green
