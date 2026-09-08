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
$notes  = New-Object System.Collections.Generic.List[string]
function Ok($m)   { Write-Host "  ok  $m" -ForegroundColor Green }

# git speaks UTF-8; PowerShell 5.1 decodes a native command's output with the console's
# OEM code page (cp850 on a French Windows). Without this line every accented filename
# comes back mangled, Test-Path says it does not exist, and the file is skipped in
# silence - the same 87 files, missed a second way.
$prevOutEnc = [Console]::OutputEncoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Reviewed third-party trees listed in .scrubignore are reported as NOTE, not LEAK. They
# are still counted and printed - a suppressed finding is never a silent one. A scanner
# whose real findings drown in 200 vendored test fixtures is a scanner nobody reads.
$ignoreGlobs = @()
$scrubIgnore = Join-Path $repo '.scrubignore'
if (Test-Path $scrubIgnore) {
  $ignoreGlobs = @(Get-Content $scrubIgnore | ForEach-Object { $_.Trim() } |
                   Where-Object { $_ -and -not $_.StartsWith('#') })
}
function Test-Ignored([string]$path) {
  $p = $path -replace '\\', '/'
  foreach ($g in $ignoreGlobs) { if ($p.StartsWith($g) -or ($p -like $g)) { return $true } }
  return $false
}
# $hard = a credential. .scrubignore demotes PII (an address, a home path) in reviewed
# third-party code and in the owner's own training libraries; it NEVER demotes a token,
# because a live key committed under one of those paths is exactly as dead as anywhere
# else. The single exception is named below, not a whole directory.
function Flag($file, $m, [switch]$hard) {
  if (-not $hard -and (Test-Ignored $file)) {
    Write-Host "  note   $m" -ForegroundColor DarkGray; $notes.Add($m); return
  }
  Write-Host "  [LEAK] $m" -ForegroundColor Red; $issues.Add($m)
}

Write-Host "==> Preflight audit: $repo" -ForegroundColor Cyan
if ($ignoreGlobs.Count) { Write-Host "    .scrubignore: $($ignoreGlobs.Count) reviewed path(s) demoted to notes" -ForegroundColor DarkGray }

# Tracked + non-ignored files (includes new ones not yet committed).
# core.quotePath=false is load-bearing. By default git renders a non-ASCII filename as a
# QUOTED, octal-escaped string - "formations/.../d\303\251cision.md" - and 87 of the
# course files have accented names. Test-Path then threw
# "Caracteres non conformes dans le chemin d'acces" on the embedded quote, and with
# $ErrorActionPreference = 'Stop' this whole script died on the first one, having scanned
# almost nothing. Its bash twin failed the other way: grep could not open the literal
# name, the error went to a discarded stderr, and it printed CLEAN over 87 unread files.
# Same root cause, opposite symptom - which is why both are pinned here.
$tracked = (git -c core.quotePath=false ls-files --cached --others --exclude-standard 2>$null)
if (-not $tracked) { $tracked = Get-ChildItem -Recurse -File | Resolve-Path -Relative }

# Non-ASCII names also need the byte-level encoding declared, or PowerShell 5.1 mangles
# them coming out of git and Test-Path misses files that are really there.
$unreadable = New-Object System.Collections.Generic.List[string]

# Secret/PII patterns: name -> regex ; placeholder exclusions handled afterwards.
# Every pattern carries (?i) because its bash twin runs `grep -Ei` on all of them, and the
# two scanners have to reach the same verdict or neither can be trusted. Found by diffing
# their output line for line: 182 findings against 181. The gap was real, not cosmetic -
# without (?i) this scanner reads "C:\Users\..." but not "C:\USERS\...", on the one
# platform where paths are actually case-insensitive.
$patterns = [ordered]@{
  'Shopify token'      = '(?i)shp(at|ca|pa|ss)_[a-fA-F0-9]{32}'
  'Anthropic key'      = '(?i)sk-ant-[a-zA-Z0-9_\-]{20,}'
  'OpenAI key'         = '(?i)sk-[a-zA-Z0-9]{20,}T3BlbkFJ'
  'GitHub token'       = '(?i)gh[pousr]_[A-Za-z0-9]{36,}'
  'AWS key'            = '(?i)AKIA[0-9A-Z]{16}'
  'Slack token'        = '(?i)xox[baprs]-[A-Za-z0-9\-]{10,}'
  'assigned secret'    = '(?i)(api[_-]?key|secret|password|passwd|token)\s*[:=]\s*["''][A-Za-z0-9_\-]{24,}["'']'
  # A home path is a real one only when a plausible USERNAME follows the slash. Requiring
  # word characters here is what keeps "/home/…" in a prose ellipsis, "/Users/`," in a code
  # fence, and "/home/`" out of the report - noise that used to bury the real findings.
  'absolute home path' = '(?i)([A-Za-z]:\\Users\\[A-Za-z0-9._\-]{2,})|(/home/[A-Za-z0-9._\-]{2,})|(/Users/[A-Za-z0-9._\-]{2,})'
}
$allow = '<[A-Z_]+>|users\.noreply\.github\.com|example\.(com|org)|\b(you|user|name|runner|youruser)\b|EXAMPLE|AKIAABCDEFGHIJKLMNOP'
# Credential classes: a hit here blocks wherever it is found, .scrubignore or not.
$hardNames = @('Shopify token','Anthropic key','OpenAI key','GitHub token','AWS key','Slack token')

# Addresses that are documentation, not contact details: test fixtures, git remotes shown
# in a README, sample DSNs. Kept narrow on purpose - a real gmail/proton address never
# matches these, so a genuine leak still fails the run.
$emailAllow = 'noreply|users\.noreply\.github\.com|example\.(com|org)|placeholder|' +
              '@(test|t|x|y)\.com$|@test\.[a-z]+$|@yourdomain\.|^your@|@evil\.com$|' +
              'git@(github|gitlab)\.com|@[a-z0-9.\-]*supabase\.(com|co)$|@localhost'
# A scanner must exclude its OWN patterns and its OWN config, or it reports itself
# (PITFALLS.md -> secret leak). .scrubignore lists example paths; skipping it is not a hole.
$skipFiles = '\.gitleaks\.toml$|\.scrubignore$|SECURITY\.md$|preflight-scrub\.(ps1|sh)$|(^|[\\/])scripts[\\/]hooks[\\/]pre-commit$|secret-scan\.yml$|(^|[\\/])assets[\\/]'

foreach ($file in $tracked) {
  if ($file -match $skipFiles) { continue }
  if (-not (Test-Path -LiteralPath $file)) { $unreadable.Add($file) | Out-Null; continue }
  $content = Get-Content -Raw -LiteralPath $file -ErrorAction SilentlyContinue
  if (-not $content) { continue }
  foreach ($name in $patterns.Keys) {
    $rx = $patterns[$name]
    foreach ($m in [regex]::Matches($content, $rx)) {
      if ($m.Value -match $allow) { continue }
      Flag $file "$name in $file  ->  $($m.Value.Substring(0,[Math]::Min(40,$m.Value.Length)))" -hard:($hardNames -contains $name)
    }
  }
}

# Real email outside placeholders
foreach ($file in $tracked) {
  if ($file -match $skipFiles) { continue }
  if (-not (Test-Path -LiteralPath $file)) { $unreadable.Add($file) | Out-Null; continue }
  $content = Get-Content -Raw -LiteralPath $file -ErrorAction SilentlyContinue
  if (-not $content) { continue }
  foreach ($m in [regex]::Matches($content, '[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}')) {
    if ($m.Value -match $emailAllow) { continue }
    Flag $file "real email in $file  ->  $($m.Value)"
  }
}

# Commit author
$authors = (git log --format='%ae' 2>$null | Sort-Object -Unique)
if ($authors) {
  $bad = $authors | Where-Object { $_ -and ($_ -notmatch 'noreply|users\.noreply\.github\.com') -and ($_ -match '@') }
  if ($bad) { Flag '' "real email in the git author: $($bad -join ', ')" } else { Ok "anonymous git author ($($authors -join ', '))" }
}

[Console]::OutputEncoding = $prevOutEnc

# A scanner that could not open its inputs must SAY so rather than print CLEAN over them.
# Each of these is a file git listed and this script never read - an unknown, not a pass.
$missed = @($unreadable | Sort-Object -Unique)
foreach ($f in $missed) { Write-Host "  [LEAK] unreadable target (scan incomplete): $f" -ForegroundColor Red; $issues.Add("unreadable: $f") }

Write-Host ""
if ($notes.Count -gt 0) {
  Write-Host "note: $($notes.Count) finding(s) in reviewed third-party paths (.scrubignore) - shown above, not blocking." -ForegroundColor DarkGray
}
if ($issues.Count -gt 0) {
  Write-Host "FAIL: $($issues.Count) potential leak(s). Fix before pushing." -ForegroundColor Red
  exit 1
}
Write-Host "CLEAN: no leak detected. Repo ready to share." -ForegroundColor Green
