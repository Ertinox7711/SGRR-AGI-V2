#Requires -Version 5.1
<#
  preflight-scrub.ps1 — full repo audit before a push (SGRR AGI V2, Windows)

  Scans ALL tracked files for secrets, real emails, absolute paths, and checks the
  commit author. Run it before the first push or after a big addition. Exits 1 if a
  leak is found.

  Usage: ./scripts/preflight-scrub.ps1
#>
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
Set-Location $repo

$issues = New-Object System.Collections.Generic.List[string]
function Flag($m) { Write-Host "  [LEAK] $m" -ForegroundColor Red; $issues.Add($m) }
function Ok($m)   { Write-Host "  ok  $m" -ForegroundColor Green }

Write-Host "==> Preflight audit: $repo" -ForegroundColor Cyan

# Tracked + non-ignored files (includes new ones not yet committed)
$tracked = (git ls-files --cached --others --exclude-standard 2>$null)
if (-not $tracked) { $tracked = Get-ChildItem -Recurse -File | Resolve-Path -Relative }

# Secret/PII patterns: name -> regex ; placeholder exclusions handled afterwards
$patterns = [ordered]@{
  'Shopify token'      = 'shp(at|ca|pa|ss)_[a-fA-F0-9]{32}'
  'Anthropic key'      = 'sk-ant-[a-zA-Z0-9_\-]{20,}'
  'OpenAI key'         = 'sk-[a-zA-Z0-9]{20,}T3BlbkFJ'
  'GitHub token'       = 'gh[pousr]_[A-Za-z0-9]{36,}'
  'AWS key'            = 'AKIA[0-9A-Z]{16}'
  'Slack token'        = 'xox[baprs]-[A-Za-z0-9\-]{10,}'
  'assigned secret'    = '(?i)(api[_-]?key|secret|password|passwd|token)\s*[:=]\s*["''][A-Za-z0-9_\-]{24,}["'']'
  'absolute home path' = '([A-Za-z]:\\Users\\[^\\/<> "'']+)|(/home/[^/<> "'']+)|(/Users/[^/<> "'']+)'
}
$allow = '<[A-Z_]+>|users\.noreply\.github\.com|example\.(com|org)|\b(you|user|name|runner|youruser)\b|EXAMPLE'
$skipFiles = '\.gitleaks\.toml$|SECURITY\.md$|preflight-scrub\.(ps1|sh)$|(^|[\\/])scripts[\\/]hooks[\\/]pre-commit$|secret-scan\.yml$|(^|[\\/])assets[\\/]'

foreach ($file in $tracked) {
  if ($file -match $skipFiles) { continue }
  if (-not (Test-Path $file)) { continue }
  $content = Get-Content -Raw -LiteralPath $file -ErrorAction SilentlyContinue
  if (-not $content) { continue }
  foreach ($name in $patterns.Keys) {
    $rx = $patterns[$name]
    foreach ($m in [regex]::Matches($content, $rx)) {
      if ($m.Value -match $allow) { continue }
      Flag "$name in $file  ->  $($m.Value.Substring(0,[Math]::Min(40,$m.Value.Length)))"
    }
  }
}

# Real email outside placeholders
foreach ($file in $tracked) {
  if ($file -match $skipFiles) { continue }
  if (-not (Test-Path $file)) { continue }
  $content = Get-Content -Raw -LiteralPath $file -ErrorAction SilentlyContinue
  if (-not $content) { continue }
  foreach ($m in [regex]::Matches($content, '[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}')) {
    if ($m.Value -match 'noreply|users\.noreply\.github\.com|example\.(com|org)|placeholder') { continue }
    Flag "real email in $file  ->  $($m.Value)"
  }
}

# Commit author
$authors = (git log --format='%ae' 2>$null | Sort-Object -Unique)
if ($authors) {
  $bad = $authors | Where-Object { $_ -and ($_ -notmatch 'noreply|users\.noreply\.github\.com') -and ($_ -match '@') }
  if ($bad) { Flag "real email in the git author: $($bad -join ', ')" } else { Ok "anonymous git author ($($authors -join ', '))" }
}

Write-Host ""
if ($issues.Count -gt 0) {
  Write-Host "FAIL: $($issues.Count) potential leak(s). Fix before pushing." -ForegroundColor Red
  exit 1
}
Write-Host "CLEAN: no leak detected. Repo ready to share." -ForegroundColor Green
