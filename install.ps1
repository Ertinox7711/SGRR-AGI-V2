#Requires -Version 5.1
<#
  install.ps1 - SGRR AGI V2 (Windows)

  Installs the FILE part of the rig into ~/.claude. Plain docs are copied with an
  automatic backup of anything they overwrite. settings.json is NOT clobbered: it is
  SMART-MERGED, so the rig config lands in YOUR OWN live Claude without throwing away
  your keys, plugins, env, permissions, or your own hooks (re-running is idempotent).

  Does NOT install plugins (that's /plugin inside Claude Code - see INSTALLER-PROMPT.md).
  Never reads, asks for, or stores any secret.

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

# Stable tokens that identify each rig-injected hook entry, so the merge can tell
# "the rig already added this" from "the user wrote their own hook here".
$hookTokens = @('pitfall-tips','check-cc-updates','rig-audit-nudge','SGRR AGI V2 rig','Read MEMORY.md','PRE-COMPACT','END-OF-TURN')

# ConvertFrom-Json yields PSCustomObjects, which are painful to merge. Turn the whole
# tree into ordered hashtables / arrays / scalars so we can union keys cleanly.
function ConvertTo-HashtableDeep($obj) {
  if ($null -eq $obj) { return $null }
  if ($obj -is [System.Management.Automation.PSCustomObject]) {
    $h = [ordered]@{}
    foreach ($p in $obj.PSObject.Properties) { $h[$p.Name] = ConvertTo-HashtableDeep $p.Value }
    return $h
  }
  if ($obj -is [System.Collections.IEnumerable] -and $obj -isnot [string]) {
    $arr = @()
    foreach ($item in $obj) { $arr += ,(ConvertTo-HashtableDeep $item) }
    return ,$arr
  }
  return $obj
}

# A hook entry's identity = the first known token found in its command strings,
# else the full joined command text (so a user's custom hook stays unique).
function Get-HookMarker($entry) {
  $cmds = @()
  if ($entry -is [System.Collections.IDictionary]) {
    $hooks = $entry['hooks']
    if ($hooks) { foreach ($h in @($hooks)) { if (($h -is [System.Collections.IDictionary]) -and $h['command']) { $cmds += [string]$h['command'] } } }
  }
  $joined = ($cmds -join ' ')
  foreach ($tok in $hookTokens) { if ($joined -like "*$tok*") { return $tok } }
  return $joined
}

# Write JSON as UTF-8 WITHOUT BOM - a leading BOM breaks Claude Code's settings parse.
function Write-JsonNoBom($obj, $path) {
  $json = $obj | ConvertTo-Json -Depth 30
  [System.IO.File]::WriteAllText($path, $json, (New-Object System.Text.UTF8Encoding($false)))
}

# Smart-merge the rig settings template INTO the user's live settings.json.
#   - no live file  -> write the template verbatim (fresh install)
#   - live present  -> back it up, then UNION in: top-level keys the user lacks, env vars,
#                      permissions.allow/ask/deny, enabledPlugins, extraKnownMarketplaces,
#                      and hooks (per event, deduped by marker). User values always win;
#                      nothing the user has is ever removed. Idempotent on re-run.
function Merge-Settings($templatePath, $livePath, $dry) {
  if (-not (Test-Path $templatePath)) { Warn "settings template missing, skipping: $templatePath"; return }
  $tpl = ConvertTo-HashtableDeep (Get-Content $templatePath -Raw | ConvertFrom-Json)

  if (-not (Test-Path $livePath)) {
    if ($dry) { Warn "would create settings.json (fresh, from template)"; return }
    Write-JsonNoBom $tpl $livePath
    Ok "installed settings.json (fresh)"
    return
  }

  try { $live = ConvertTo-HashtableDeep (Get-Content $livePath -Raw | ConvertFrom-Json) }
  catch { Warn "live settings.json is invalid JSON - leaving it untouched (merge skipped)"; return }
  if ($live -isnot [System.Collections.IDictionary]) { Warn "live settings.json is not a JSON object - leaving it untouched"; return }

  $added = @()

  # 1. top-level scalar keys - inject only if the user lacks them (never overwrite a user value)
  foreach ($k in $tpl.Keys) {
    if ($k -in @('hooks','permissions','enabledPlugins','env','extraKnownMarketplaces')) { continue }
    if (-not $live.Contains($k)) { $live[$k] = $tpl[$k]; $added += "key:$k" }
  }

  # 2. env - union (add rig vars the user lacks, keep theirs)
  if ($tpl.Contains('env')) {
    if (-not $live.Contains('env') -or $live['env'] -isnot [System.Collections.IDictionary]) { $live['env'] = [ordered]@{} }
    foreach ($k in $tpl['env'].Keys) { if (-not $live['env'].Contains($k)) { $live['env'][$k] = $tpl['env'][$k]; $added += "env:$k" } }
  }

  # 3. permissions.allow/ask/deny - union arrays; other permission keys injected if absent
  if ($tpl.Contains('permissions')) {
    if (-not $live.Contains('permissions') -or $live['permissions'] -isnot [System.Collections.IDictionary]) { $live['permissions'] = [ordered]@{} }
    foreach ($sub in 'allow','ask','deny') {
      if (-not $tpl['permissions'].Contains($sub)) { continue }
      $merged = @(); if ($live['permissions'].Contains($sub) -and $live['permissions'][$sub]) { $merged = @($live['permissions'][$sub]) }
      foreach ($item in @($tpl['permissions'][$sub])) { if ($item -notin $merged) { $merged += $item; $added += "perm.$sub" } }
      $live['permissions'][$sub] = $merged
    }
    foreach ($pk in $tpl['permissions'].Keys) {
      if ($pk -in @('allow','ask','deny')) { continue }
      if (-not $live['permissions'].Contains($pk)) { $live['permissions'][$pk] = $tpl['permissions'][$pk]; $added += "perm:$pk" }
    }
  }

  # 4. enabledPlugins + extraKnownMarketplaces - union maps (add rig entries the user lacks)
  foreach ($mapKey in 'enabledPlugins','extraKnownMarketplaces') {
    if (-not $tpl.Contains($mapKey)) { continue }
    if (-not $live.Contains($mapKey) -or $live[$mapKey] -isnot [System.Collections.IDictionary]) { $live[$mapKey] = [ordered]@{} }
    foreach ($k in $tpl[$mapKey].Keys) { if (-not $live[$mapKey].Contains($k)) { $live[$mapKey][$k] = $tpl[$mapKey][$k]; $added += "${mapKey}:$k" } }
  }

  # 5. hooks - union per event by marker token (idempotent; user hooks preserved alongside)
  if ($tpl.Contains('hooks')) {
    if (-not $live.Contains('hooks') -or $live['hooks'] -isnot [System.Collections.IDictionary]) { $live['hooks'] = [ordered]@{} }
    foreach ($evt in $tpl['hooks'].Keys) {
      $merged = @(); if ($live['hooks'].Contains($evt) -and $live['hooks'][$evt]) { $merged = @($live['hooks'][$evt]) }
      $haveMarkers = @(); foreach ($e in $merged) { $haveMarkers += (Get-HookMarker $e) }
      foreach ($te in @($tpl['hooks'][$evt])) {
        $m = Get-HookMarker $te
        if ($m -notin $haveMarkers) { $merged += $te; $haveMarkers += $m; $added += "hook:$evt/$m" }
      }
      $live['hooks'][$evt] = $merged
    }
  }

  if ($dry) {
    if ($added.Count) { Warn ("would back up settings.json -> .bak-$stamp and smart-merge +$($added.Count): " + ($added -join ', ')) }
    else { Warn "settings.json already carries the full rig - nothing to add" }
    return
  }

  if ($added.Count) {
    Copy-Item $livePath "$livePath.bak-$stamp" -Force; Ok "backup settings.json -> .bak-$stamp"
    Write-JsonNoBom $live $livePath
    Ok ("smart-merged settings.json (+$($added.Count): " + ($added -join ', ') + ")")
  } else {
    Ok "settings.json already complete - no changes"
  }
}

Step "Target: $claude"
foreach ($d in @($claude, (Join-Path $claude 'memory'), (Join-Path $claude 'rules'), (Join-Path $claude 'scripts'), (Join-Path $claude 'commands'), (Join-Path $claude 'skills'), (Join-Path $claude 'skills\session-check'))) {
  if (-not (Test-Path $d)) {
    if ($DryRun) { Warn "would create $d" } else { New-Item -ItemType Directory -Force -Path $d | Out-Null; Ok "created $d" }
  }
}

# Plain-copy files (clobber with backup). settings.json is handled separately (smart-merge).
# (source-relative-to-repo, destination-relative-to-~/.claude)
$files = @(
  @{ src = 'CLAUDE.md';                dst = 'CLAUDE.md' },
  @{ src = 'PITFALLS.md';              dst = 'PITFALLS.md' },
  @{ src = 'USAGE.md';                 dst = 'SGRR-GUIDE.md' },
  @{ src = 'memory\MEMORY.md';         dst = 'memory\MEMORY.md' },
  @{ src = 'rules\example-project.md'; dst = 'rules\example-project.md' },
  @{ src = 'commands\rig-audit.md';    dst = 'commands\rig-audit.md' },
  @{ src = 'commands\session-check.md';     dst = 'commands\session-check.md' },
  @{ src = 'skills\session-check\SKILL.md'; dst = 'skills\session-check\SKILL.md' }
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

# settings.json - smart-merge the rig config into the user's OWN live Claude settings
Merge-Settings (Join-Path $repo 'settings.template.json') (Join-Path $claude 'settings.json') $DryRun

# Install the hook scripts (called by the PreToolUse / SessionStart hooks)
foreach ($s in @('check-cc-updates.ps1','rig-audit-nudge.ps1','pitfall-tips.ps1')) {
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
Step "settings.json was smart-merged into your live config (backup kept if it changed)."
Step "Remaining steps (inside Claude Code):"
Write-Host "    1. /plugin marketplace add JuliusBrussee/caveman"
Write-Host "    2. enable the plugins (see SETUP.md) or paste INSTALLER-PROMPT.md"
Write-Host "    3. open ~/.claude/CLAUDE.md and fill in the <PLACEHOLDER>s"
Write-Host "    4. ./scripts/verify-install.ps1  (parity self-test)"
Write-Host "    5. restart Claude Code, check /plugin and /help"
if ($DryRun) { Write-Host "`n(Dry-run: nothing was written.)" -ForegroundColor Yellow }
