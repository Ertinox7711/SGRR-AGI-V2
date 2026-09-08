#Requires -Version 5.1
<#
  load-formations.ps1 - build a local, private bundle of your OWN training libraries.

  Reads ONLY from your local disk. Downloads nothing, uploads nothing, publishes nothing.
  Output lands in ~/.claude/formations/ - deliberately OUTSIDE any git repo, so a bundle
  can never be committed by accident.

  Usage:
    ./load-formations.ps1                       # report only, writes nothing
    ./load-formations.ps1 -Bundle               # build ~/.claude/formations/<library>.md
    ./load-formations.ps1 -Bundle -Force        # rebuild even if a bundle already exists
    ./load-formations.ps1 -Roots "D:\Courses"   # search your own locations
#>
[CmdletBinding()]
param(
  [switch]$Bundle,
  [switch]$Force,
  [string[]]$Roots
)

$ErrorActionPreference = 'Stop'
$home_    = $env:USERPROFILE
$outDir   = Join-Path $home_ '.claude\formations'
$docs     = Join-Path $home_ 'Documents'
$business = Join-Path $docs  'BUSINESS'

function Step($m) { Write-Host "==> $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "    ok  $m" -ForegroundColor Green }
function Warn($m) { Write-Host "    --  $m" -ForegroundColor Yellow }

# A library is identified by a folder-name pattern, not by a hardcoded path, so it keeps
# working when the course folder is renamed or moved to another drive.
$libraries = @(
  @{ Id='A'; Name='course-inner-circle';   Patterns=@('*inner circle*','*inner-circle*');                    MinFiles=10 },
  @{ Id='B'; Name='community-live-replays'; Patterns=@('*transcripts*');                                      MinFiles=20 },
  @{ Id='C'; Name='gmc-playbook';           Patterns=@('*-gmc','*gmc-playbook*','*merchant-center*');          MinFiles=3  }
)

# Where to look. Explicit -Roots wins; otherwise the usual suspects.
if (-not $Roots -or $Roots.Count -eq 0) {
  $Roots = @($business, $docs) | Where-Object { Test-Path $_ }
}

Step "Search roots: $($Roots -join ' ; ')"
if (-not (Test-Path $outDir)) {
  if ($Bundle) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null; Ok "created $outDir" }
}

$report = @()

foreach ($lib in $libraries) {
  $hits = @()
  foreach ($root in $Roots) {
    foreach ($pat in $lib.Patterns) {
      try {
        $dirs = Get-ChildItem -Path $root -Directory -Recurse -Depth 4 -Filter $pat -ErrorAction SilentlyContinue
      } catch { $dirs = @() }
      foreach ($d in $dirs) {
        $md = @(Get-ChildItem -Path $d.FullName -Filter '*.md' -Recurse -File -ErrorAction SilentlyContinue)
        if ($md.Count -ge $lib.MinFiles) {
          $hits += [pscustomobject]@{ Path = $d.FullName; Count = $md.Count; Files = $md }
        }
      }
    }
  }

  # Overlapping search roots and overlapping patterns can both surface the SAME folder;
  # collapse those first so a directory is never processed (or reported) twice.
  $hits = @($hits | Group-Object Path | ForEach-Object { $_.Group[0] })

  # The winner is the copy with the most files; the others are merged below, not discarded.
  $best = $hits | Sort-Object Count -Descending | Select-Object -First 1

  if (-not $best) {
    Warn "library $($lib.Id) ($($lib.Name)): not found locally - skipped"
    $report += [pscustomobject]@{ Id=$lib.Id; Library=$lib.Name; Files=0; Source='(not found)'; Bundle='-' }
    continue
  }

  Ok "library $($lib.Id) ($($lib.Name)): $($best.Count) .md in $($best.Path)"

  # The same library often exists in two places (a copy inside a store folder AND a copy in
  # Documents). Never drop the smaller one blindly: keep every file from it whose CONTENT is
  # not already in the winner. Deduplication is by SHA256, so a pure duplicate costs nothing
  # and a genuinely different lesson is never lost.
  $seen = @{}
  foreach ($f in $best.Files) { $h = (Get-FileHash $f.FullName -Algorithm SHA256).Hash; $seen[$h] = $true }
  $extra = @()
  foreach ($hit in ($hits | Where-Object { $_.Path -ne $best.Path })) {
    $new = @()
    foreach ($f in $hit.Files) {
      $h = (Get-FileHash $f.FullName -Algorithm SHA256).Hash
      if (-not $seen.ContainsKey($h)) { $seen[$h] = $true; $new += $f }
    }
    if ($new.Count) {
      Ok "     + $($new.Count) file(s) not present in the main copy, merged from $($hit.Path)"
      $extra += [pscustomobject]@{ Path = $hit.Path; Files = $new }
    } else {
      Warn "     also seen, fully duplicated (0 unique file), not merged: $($hit.Path)"
    }
  }
  $totalFiles = $best.Count + ($extra | ForEach-Object { $_.Files.Count } | Measure-Object -Sum).Sum

  $target = Join-Path $outDir ("{0}-{1}.md" -f $lib.Id, $lib.Name)

  if (-not $Bundle) {
    $report += [pscustomobject]@{ Id=$lib.Id; Library=$lib.Name; Files=$totalFiles; Source=$best.Path; Bundle='(dry run)' }
    continue
  }

  if ((Test-Path $target) -and -not $Force) {
    Warn "     bundle already exists, skipping (use -Force to rebuild): $target"
    $report += [pscustomobject]@{ Id=$lib.Id; Library=$lib.Name; Files=$totalFiles; Source=$best.Path; Bundle='(kept)' }
    continue
  }

  $sb = New-Object System.Text.StringBuilder
  [void]$sb.AppendLine("# Library $($lib.Id) - $($lib.Name)")
  [void]$sb.AppendLine()
  [void]$sb.AppendLine("> LOCAL PRIVATE COPY. Built by load-formations.ps1 on $(Get-Date -Format 'yyyy-MM-dd HH:mm').")
  [void]$sb.AppendLine("> Source: ``$($best.Path)``  -  $($best.Count) files.")
  foreach ($x in $extra) { [void]$sb.AppendLine("> Merged: ``$($x.Path)``  -  $($x.Files.Count) file(s) absent from the main copy.") }
  [void]$sb.AppendLine("> Third-party paid material. Do NOT commit, publish or redistribute this file.")
  [void]$sb.AppendLine()
  [void]$sb.AppendLine('---')
  [void]$sb.AppendLine()

  $sources = @([pscustomobject]@{ Path = $best.Path; Files = $best.Files }) + $extra
  foreach ($src in $sources) {
    foreach ($f in ($src.Files | Sort-Object FullName)) {
      $rel = $f.FullName.Substring($src.Path.Length).TrimStart('\','/')
      [void]$sb.AppendLine("## $rel")
      [void]$sb.AppendLine()
      try { [void]$sb.AppendLine((Get-Content $f.FullName -Raw -ErrorAction Stop)) }
      catch { [void]$sb.AppendLine("_(unreadable: $($_.Exception.Message))_") }
      [void]$sb.AppendLine()
      [void]$sb.AppendLine('---')
      [void]$sb.AppendLine()
    }
  }

  [System.IO.File]::WriteAllText($target, $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
  $kb = [math]::Round((Get-Item $target).Length / 1KB)
  Ok "     bundled -> $target ($kb KB)"
  $report += [pscustomobject]@{ Id=$lib.Id; Library=$lib.Name; Files=$best.Count; Source=$best.Path; Bundle="$kb KB" }
}

Write-Host ''
$report | Format-Table -AutoSize
Write-Host ''
if ($Bundle) {
  Step "Bundles are in $outDir - local only, never committed."
} else {
  Step "Dry run. Re-run with -Bundle to build the bundles."
}
