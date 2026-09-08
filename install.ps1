#Requires -Version 5.1
<#
  install.ps1 - SGRR AGI V2 (Windows)

  Installs the whole rig into ~/.claude: CLAUDE.md, PITFALLS.md, memory, rules,
  commands, agents, skills, hook scripts, docs, and the shop / Shopify GO files.

  settings.json is NOT clobbered: it is SMART-MERGED, so the rig config lands in YOUR
  OWN live Claude without throwing away your keys, plugins, env, permissions or your
  own hooks. Re-running is idempotent. Every file it would overwrite with DIFFERENT
  content is backed up next to itself as <file>.bak-<timestamp>; identical files are
  skipped silently.

  Does NOT install plugins (that's /plugin inside Claude Code - see INSTALLER-PROMPT.md).
  Never reads, asks for, or stores any secret.

  Usage:
    ./install.ps1                    # install
    ./install.ps1 -DryRun            # show what would happen, write nothing
    ./install.ps1 -Minimal           # core only (no skills/, no docs/, no shops/, no shopify/)
    ./install.ps1 -Target D:\x\.claude   # install somewhere else (sandbox / second profile)
#>
[CmdletBinding()]
param([switch]$DryRun, [switch]$Minimal, [string]$Target)

$ErrorActionPreference = 'Stop'
$repo   = $PSScriptRoot
$claude = if ($Target) { [System.IO.Path]::GetFullPath($Target) } else { Join-Path $env:USERPROFILE '.claude' }
$stamp  = Get-Date -Format 'yyyyMMdd-HHmmss'

$script:nCopied = 0
$script:nSkipped = 0
$script:nBackedUp = 0

function Step($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }
function Ok($msg)   { Write-Host "    ok  $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "    !!  $msg" -ForegroundColor Yellow }

# Stable tokens that identify each rig-injected hook entry, so the merge can tell
# "the rig already added this" from "the user wrote their own hook here".
$hookTokens = @(
  'pitfall-tips','check-cc-updates','rig-audit-nudge','shopify-token-check',
  'browser-nav-denylist','protected-path-denylist','asset-delete-guard',
  'shop-identity-guard','shop-token-identity-block','destructive-block',
  'trio-fanout-cap','SGRR AGI V2 rig','Read MEMORY.md','PRE-COMPACT','END-OF-TURN'
)

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

function Get-Sha256([string]$path) {
  try { return (Get-FileHash -Path $path -Algorithm SHA256).Hash } catch { return $null }
}

# Copy one file, backing up the destination ONLY when it exists with different content.
function Copy-OneFile([string]$src, [string]$dst, [switch]$Dry) {
  $rel = $dst.Substring($claude.Length).TrimStart('\','/')
  if (Test-Path $dst) {
    if ((Get-Sha256 $src) -eq (Get-Sha256 $dst)) { $script:nSkipped++; return }
    if ($Dry) { Warn "would back up $rel -> .bak-$stamp and overwrite" ; $script:nBackedUp++; $script:nCopied++; return }
    Copy-Item $dst "$dst.bak-$stamp" -Force
    $script:nBackedUp++
  }
  if ($Dry) { $script:nCopied++; return }
  $parent = Split-Path $dst -Parent
  if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
  Copy-Item $src $dst -Force
  $script:nCopied++
}

# Copy a whole tree from the repo into ~/.claude, file by file (so backups stay granular).
function Copy-Tree([string]$relSrc, [string]$relDst, [switch]$Dry) {
  $srcRoot = Join-Path $repo $relSrc
  if (-not (Test-Path $srcRoot)) { Warn "source missing, skipping: $relSrc"; return }
  $dstRoot = Join-Path $claude $relDst
  $before = $script:nCopied
  Get-ChildItem -Path $srcRoot -Recurse -File | ForEach-Object {
    $rel = $_.FullName.Substring($srcRoot.Length).TrimStart('\','/')
    Copy-OneFile $_.FullName (Join-Path $dstRoot $rel) -Dry:$Dry
  }
  Ok ("{0,-28} {1,4} file(s)" -f $relDst, ($script:nCopied - $before))
}

# Smart-merge the rig settings template INTO the user's live settings.json.
#   - no live file  -> write the template verbatim (fresh install)
#   - live present  -> back it up, then UNION in: top-level keys the user lacks, env vars,
#                      permissions.allow/ask/deny, enabledPlugins, extraKnownMarketplaces,
#                      and hooks (per event, deduped by marker). User values always win;
#                      nothing the user has is ever removed. Idempotent on re-run.
function Merge-Settings($templatePath, $livePath, $dry) {
  if (-not (Test-Path $templatePath)) { Warn "settings template missing, skipping: $templatePath"; return }

  # The template carries __USERPROFILE__ instead of a hard-coded home dir; expand it now
  # so the installed settings.json holds real absolute paths (no runtime expansion needed).
  # Backslashes are doubled because we substitute INTO raw JSON text, where \ is an escape.
  # "__USERPROFILE__\.claude" is resolved against the real install root first, so a custom
  # -Target still produces hook paths that point at the files we actually copied.
  $homeForTpl = Split-Path $claude -Parent
  $tplRaw = (Get-Content $templatePath -Raw).
    Replace('__USERPROFILE__\\.claude', $claude.Replace('\', '\\')).
    Replace('__USERPROFILE__', $homeForTpl.Replace('\', '\\'))
  $tpl = ConvertTo-HashtableDeep ($tplRaw | ConvertFrom-Json)

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
if (-not (Test-Path $claude)) {
  if ($DryRun) { Warn "would create $claude" } else { New-Item -ItemType Directory -Force -Path $claude | Out-Null; Ok "created $claude" }
}

# ---- single files at the root of ~/.claude ---------------------------------------
Step "Core files"
$files = @(
  @{ src = 'CLAUDE.md';   dst = 'CLAUDE.md' },
  @{ src = 'PITFALLS.md'; dst = 'PITFALLS.md' },
  @{ src = 'USAGE.md';    dst = 'SGRR-GUIDE.md' }
)
foreach ($f in $files) {
  $srcPath = Join-Path $repo $f.src
  if (-not (Test-Path $srcPath)) { Warn "source missing, skipping: $($f.src)"; continue }
  Copy-OneFile $srcPath (Join-Path $claude $f.dst) -Dry:$DryRun
  Ok "installed $($f.dst)"
}

# ---- trees ------------------------------------------------------------------------
Step "Trees"
Copy-Tree 'memory'   'memory'   -Dry:$DryRun
Copy-Tree 'rules'    'rules'    -Dry:$DryRun
Copy-Tree 'commands' 'commands' -Dry:$DryRun
Copy-Tree 'agents'   'agents'   -Dry:$DryRun
Copy-Tree 'scripts'  'scripts'  -Dry:$DryRun
if (-not $Minimal) {
  Copy-Tree 'skills'  'skills'  -Dry:$DryRun
  Copy-Tree 'docs'    'docs'    -Dry:$DryRun
  Copy-Tree 'shops'   'shops'   -Dry:$DryRun
  Copy-Tree 'shopify' 'shopify' -Dry:$DryRun
  # The training libraries. ~32 MB of text, and the reason the repo is private - the
  # bundles under formations/bundles/ are meant to be pasted straight into a chat, so
  # they have to land next to everything else for the install to be one click.
  Copy-Tree 'formations' 'formations' -Dry:$DryRun
} else {
  Warn "-Minimal: skipped skills/, docs/, shops/, shopify/, formations/"
}

# ---- machine-local config the hooks read (never overwritten once it exists) --------
Step "Local config"
$zonesSrc = Join-Path $repo 'protected-zones.example.json'
$zonesDst = Join-Path $claude 'protected-zones.json'
if (Test-Path $zonesDst) {
  Ok "protected-zones.json already exists - left untouched"
} elseif (Test-Path $zonesSrc) {
  if ($DryRun) { Warn "would seed protected-zones.json from the example" }
  else { Copy-Item $zonesSrc $zonesDst -Force; Ok "seeded protected-zones.json (EDIT IT: it currently lists placeholder folders)" }
}
$regSrc = Join-Path $repo 'shops\shops-registry.template.md'
$regDst = Join-Path $claude 'shops-registry.md'
if (Test-Path $regDst) {
  Ok "shops-registry.md already exists - left untouched"
} elseif (Test-Path $regSrc) {
  if ($DryRun) { Warn "would seed shops-registry.md from the template" }
  else { Copy-Item $regSrc $regDst -Force; Ok "seeded shops-registry.md (edit it, then run scripts/shops-registry-sync.ps1)" }
}

# ---- settings.json - smart-merge into the user's OWN live Claude settings ----------
Step "settings.json"
Merge-Settings (Join-Path $repo 'settings.template.json') (Join-Path $claude 'settings.json') $DryRun

# ---- pre-commit hook into THIS repo (protects your future commits from leaks) ------
$gitHooks = Join-Path $repo '.git\hooks'
$preCommitSrc = Join-Path $repo 'scripts\hooks\pre-commit'
if ((Test-Path $gitHooks) -and (Test-Path $preCommitSrc)) {
  if ($DryRun) { Warn "would install the pre-commit hook" }
  else { Copy-Item $preCommitSrc (Join-Path $gitHooks 'pre-commit') -Force; Ok "pre-commit hook installed" }
}

Write-Host ""
Step ("Files: {0} written, {1} identical (skipped), {2} backed up as .bak-{3}" -f $script:nCopied, $script:nSkipped, $script:nBackedUp, $stamp)
Step "Usage guide -> ~/.claude/SGRR-GUIDE.md"
Step "Remaining steps (inside Claude Code):"
Write-Host "    1. /plugin marketplace add JuliusBrussee/caveman"
Write-Host "    2. enable the plugins (see SETUP.md) or paste INSTALLER-PROMPT.md"
Write-Host "    3. edit ~/.claude/protected-zones.json - name YOUR read-only folders"
Write-Host "    4. edit ~/.claude/shops-registry.md if you run stores, then scripts\shops-registry-sync.ps1"
Write-Host "    5. open ~/.claude/CLAUDE.md and fill in the <PLACEHOLDER>s"
Write-Host "    6. .\scripts\verify-install.ps1   (parity self-test)"
Write-Host "    7. restart Claude Code, check /plugin and /help"
if ($DryRun) { Write-Host "`n(Dry-run: nothing was written.)" -ForegroundColor Yellow }
