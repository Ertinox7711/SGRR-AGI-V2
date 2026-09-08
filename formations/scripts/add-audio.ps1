#Requires -Version 5.1
<#
  add-audio.ps1 - put the 82 audio files back next to their transcripts.

  The repo carries every WORD of the training libraries and none of the SOUND: 3.36 GB
  across 82 files, one of them 104.7 MB, and GitHub rejects any single file over 100 MB
  outright. formations/AUDIO-MANIFEST.md lists all of them with size and SHA-256, and this
  script is the other half of that manifest - it restores the bytes from a local copy and
  checks each one against the recorded hash.

  MODES
    -Verify              Report only: which of the 82 are present, missing, or corrupt.
    -From <dir>          Restore from a local copy of the original library folders.
    -EnableLfs           Print (and optionally apply) the Git LFS setup, with its cost.

  EXAMPLES
    ./formations/scripts/add-audio.ps1 -Verify
    ./formations/scripts/add-audio.ps1 -From "$env:USERPROFILE\Documents"
    ./formations/scripts/add-audio.ps1 -From D:\backup\formations -WhatIf
    ./formations/scripts/add-audio.ps1 -EnableLfs

  Nothing here downloads anything, and nothing here deletes anything.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [string] $From,
  [switch] $Verify,
  [switch] $EnableLfs
)
$ErrorActionPreference = 'Stop'
# ...and so the accented replay names print readably instead of as mojibake.
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

$formations = Split-Path -Parent $PSScriptRoot
$manifest   = Join-Path $formations 'AUDIO-MANIFEST.md'
if (-not (Test-Path -LiteralPath $manifest)) { throw "manifest not found: $manifest" }

# ---------------------------------------------------------------------------
# Where each library came from, relative to a root you pass with -From.
# Only these two hold audio; the other five libraries are text only.
# No absolute path is hard-coded on purpose: a real home path in a committed file is
# exactly what scripts/preflight-scrub.ps1 blocks, and it would be wrong on your friend's
# machine anyway. -From defaults to your Documents folder, which is where they live.
# ---------------------------------------------------------------------------
$sourceOf = @{
  'A-inner-circle'          = 'Ecom-Inner-Circle'
  'B-ecom-boss-transcripts' = 'Ecom-Boss\transcripts'
}

# ---------------------------------------------------------------------------
# Parse the manifest table: | # | `library` | `relative/path.mp3` | 39.7 MB | `cc703eb…` |
# The stored hash is TRUNCATED for readability, so a match is a prefix match. That still
# catches the failure this check exists for - the right name holding the wrong recording.
# ---------------------------------------------------------------------------
# -Encoding UTF8 is required, not tidy: PowerShell 5.1's Get-Content defaults to the ANSI
# code page, so "spécial" (0xC3 0xA9 on disk) comes back as two mojibake characters and
# the path built from it matches nothing. That is 4 of the 82 replays silently reported
# "not in source" while sitting right there - the manifest was correct all along.
$rows = @()
foreach ($line in Get-Content -LiteralPath $manifest -Encoding UTF8) {
  $m = [regex]::Match($line, '^\|\s*(\d+)\s*\|\s*`([^`]+)`\s*\|\s*`([^`]+)`\s*\|\s*([\d.]+)\s*MB\s*\|\s*`([0-9a-f]+)')
  if (-not $m.Success) { continue }
  $rows += [pscustomobject]@{
    Index   = [int]$m.Groups[1].Value
    Library = $m.Groups[2].Value
    Rel     = $m.Groups[3].Value -replace '/', '\'
    SizeMB  = [double]$m.Groups[4].Value
    Sha     = $m.Groups[5].Value
  }
}
if ($rows.Count -eq 0) { throw "parsed 0 rows from $manifest - has its table format changed?" }
Write-Host "manifest: $($rows.Count) audio file(s), $([math]::Round(($rows | Measure-Object SizeMB -Sum).Sum / 1024, 2)) GB" -ForegroundColor Cyan

function Get-Target($row) { Join-Path (Join-Path $formations $row.Library) $row.Rel }

# Hashing is a READ, so it has to happen on a dry run too - otherwise -WhatIf rehearses
# everything EXCEPT the check it exists to rehearse. Get-FileHash cannot do that here:
# it is a PowerShell-level function in 5.1, $WhatIfPreference leaks into its body and it
# returns $null ("Impossible d'appeler une methode dans une expression Null"), yet it does
# not declare -WhatIf, so pinning -WhatIf:$false is a NamedParameterNotFound error. Both
# were hit in that order. Going straight to .NET is immune to the preference entirely, and
# streams the file instead of loading 100 MB of mp3 into memory.
function Get-Sha($path) {
  $full = (Resolve-Path -LiteralPath $path).ProviderPath
  $sha  = [System.Security.Cryptography.SHA256]::Create()
  try {
    $fs = [System.IO.File]::OpenRead($full)
    try { ([BitConverter]::ToString($sha.ComputeHash($fs)) -replace '-', '').ToLowerInvariant() }
    finally { $fs.Dispose() }
  } finally { $sha.Dispose() }
}

function Test-Row($row) {
  $dest = Get-Target $row
  if (-not (Test-Path -LiteralPath $dest)) { return 'missing' }
  if ((Get-Sha $dest).StartsWith($row.Sha)) { return 'ok' }
  return 'corrupt'
}

# ---------------------------------------------------------------------------
if ($EnableLfs) {
  Write-Host ""
  Write-Host "Git LFS - read the cost before running any of this:" -ForegroundColor Yellow
  Write-Host "  * GitHub's free LFS tier is 1 GB of storage and 1 GB of bandwidth PER MONTH."
  Write-Host "  * These files are 3.36 GB, so this needs a paid data pack. Every clone that"
  Write-Host "    pulls the audio also spends a month's free bandwidth in one go."
  Write-Host "  * That is a billing decision, so this script will not turn it on for you."
  Write-Host ""
  Write-Host "  If you decide to pay for it, the setup is:" -ForegroundColor Cyan
  Write-Host '    git lfs install'
  Write-Host '    git lfs track "formations/**/*.mp3"'
  Write-Host '    git add .gitattributes'
  Write-Host '    # then delete the *.mp3 / *.m4a / *.wav / *.mp4 / *.mov block at the'
  Write-Host '    # bottom of .gitignore - LFS cannot see a file git is ignoring'
  Write-Host '    git add formations && git commit -m "chore: add course audio via LFS"'
  Write-Host ""
  Write-Host "  Deleting that .gitignore block WITHOUT doing the lfs track first will make"  -ForegroundColor Red
  Write-Host "  the next push fail on the first file over 100 MB, and GitHub rejects the"    -ForegroundColor Red
  Write-Host "  whole push, not just that file."                                             -ForegroundColor Red
  return
}

# ---------------------------------------------------------------------------
if ($Verify -or -not $From) {
  if (-not $From -and -not $Verify) { Write-Host "no -From given, reporting only" -ForegroundColor DarkGray }
  $tally = @{ ok = 0; missing = 0; corrupt = 0 }
  foreach ($row in $rows) {
    $state = Test-Row $row
    $tally[$state]++
    switch ($state) {
      'corrupt' { Write-Host ("  corrupt  {0}\{1}" -f $row.Library, $row.Rel) -ForegroundColor Red }
      'missing' { Write-Verbose ("  missing  {0}\{1}" -f $row.Library, $row.Rel) }
    }
  }
  Write-Host ""
  Write-Host ("present {0} / missing {1} / corrupt {2}  (of {3})" -f $tally.ok, $tally.missing, $tally.corrupt, $rows.Count) `
    -ForegroundColor $(if ($tally.corrupt) { 'Red' } elseif ($tally.missing) { 'Yellow' } else { 'Green' })
  if ($tally.missing) { Write-Host "run with -From <dir> to restore them from a local copy" -ForegroundColor DarkGray }
  if ($tally.corrupt) { exit 1 }
  return
}

# ---------------------------------------------------------------------------
# Restore
if (-not (Test-Path -LiteralPath $From)) { throw "-From path does not exist: $From" }
Write-Host "restoring from: $From" -ForegroundColor Cyan

$copied = 0; $already = 0; $notFound = @(); $badHash = @()
foreach ($row in $rows) {
  $dest = Get-Target $row
  if ((Test-Path -LiteralPath $dest) -and (Test-Row $row) -eq 'ok') { $already++; continue }

  # Two shapes are accepted for -From: the original Documents folder (so the library maps
  # through $sourceOf), or a flat backup that already mirrors formations/. Try both.
  $candidates = @()
  if ($sourceOf.ContainsKey($row.Library)) { $candidates += Join-Path (Join-Path $From $sourceOf[$row.Library]) $row.Rel }
  $candidates += Join-Path (Join-Path $From $row.Library) $row.Rel
  $candidates += Join-Path $From $row.Rel
  $src = $candidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1

  if (-not $src) { $notFound += ("{0}\{1}" -f $row.Library, $row.Rel); continue }

  $h = Get-Sha $src
  if (-not $h.StartsWith($row.Sha)) {
    # Refuse rather than overwrite: a same-named file with a different hash is a DIFFERENT
    # recording, and silently installing it would make the manifest a lie.
    $badHash += ("{0}  (source sha {1}..., manifest {2}...)" -f $row.Rel, $h.Substring(0, 12), $row.Sha.Substring(0, 12))
    continue
  }

  if ($PSCmdlet.ShouldProcess($dest, "copy from $src")) {
    $dir = Split-Path -Parent $dest
    if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    Copy-Item -LiteralPath $src -Destination $dest -Force
    $copied++
    Write-Host ("  restored  {0}\{1}" -f $row.Library, $row.Rel) -ForegroundColor Green
  }
}

Write-Host ""
Write-Host ("copied {0}, already present {1}, not found {2}, hash mismatch {3}" -f $copied, $already, $notFound.Count, $badHash.Count)
foreach ($f in $notFound) { Write-Host "  not in source: $f" -ForegroundColor DarkGray }
foreach ($f in $badHash)  { Write-Host "  DIFFERENT recording, not copied: $f" -ForegroundColor Red }

# The audio is deliberately ignored by git (.gitignore, bottom block). Restoring it does
# not stage anything, and the next `git status` will not show 3.36 GB of new files.
Write-Host ""
Write-Host "audio stays untracked - .gitignore keeps *.mp3 out. Use -EnableLfs to read what changing that costs." -ForegroundColor DarkGray
if ($badHash.Count) { exit 1 }
