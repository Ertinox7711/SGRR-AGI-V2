#Requires -Version 5.1
<#
  verify-install.ps1 - SGRR AGI V2 (Windows)

  PARITY self-test: proves your ~/.claude install carries the same payload and the same
  enforced guardrails as the original rig. Not "roughly".

  Three outcomes per line:
    [OK]   the rig is there
    [WARN] present but not personalised yet - does NOT break parity, but read it
    [FAIL] a real gap

  exit 0 = full parity (warnings allowed) ; exit 1 = at least one gap.

  Usage:  ./scripts/verify-install.ps1
          ./scripts/verify-install.ps1 -Target D:\sandbox\.claude   # check another install
#>
[CmdletBinding()]
param([string]$Target)

$claude = if ($Target) { [System.IO.Path]::GetFullPath($Target) } else { Join-Path $env:USERPROFILE '.claude' }
$pass = 0; $fail = 0; $warn = 0
function Ok($m)   { Write-Host "  [OK]   $m" -ForegroundColor Green;  $script:pass++ }
function Bad($m)  { Write-Host "  [FAIL] $m" -ForegroundColor Red;    $script:fail++ }
function Wrn($m)  { Write-Host "  [WARN] $m" -ForegroundColor Yellow; $script:warn++ }
function Head($m) { Write-Host "`n$m" -ForegroundColor Cyan }

function Count-Files($rel, $filter) {
  $p = Join-Path $claude $rel
  if (-not (Test-Path $p)) { return 0 }
  return @(Get-ChildItem $p -Recurse -File -Filter $filter -ErrorAction SilentlyContinue).Count
}

Head "SGRR AGI V2 - parity self-test ($claude)"

# ---- settings.json -----------------------------------------------------------------
$settingsPath = Join-Path $claude 'settings.json'
$settings = $null
if (Test-Path $settingsPath) {
  try { $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json; Ok "settings.json present and valid JSON" }
  catch { Bad "settings.json present but INVALID JSON: $($_.Exception.Message)" }
} else { Bad "settings.json missing" }

if ($settings) {
  # the installer expands __USERPROFILE__; a leftover token means broken hook paths
  if ((Get-Content $settingsPath -Raw) -match '__USERPROFILE__') {
    Bad "settings.json still contains the literal __USERPROFILE__ token (re-run install.ps1)"
  } else { Ok "no unexpanded path token in settings.json" }

  $plugins = @()
  if ($settings.enabledPlugins) { $plugins = ($settings.enabledPlugins.PSObject.Properties | Where-Object { $_.Value -eq $true }).Name }
  if ($plugins.Count -ge 12) { Ok "$($plugins.Count) plugins enabled (>= 12 expected)" }
  else { Bad "$($plugins.Count) plugins enabled (12 expected - run /plugin)" }

  foreach ($evt in 'SessionStart','PreToolUse') {
    if ($settings.hooks -and $settings.hooks.$evt) { Ok "hooks.$evt wired ($(@($settings.hooks.$evt).Count) group(s))" }
    else { Bad "hooks.$evt missing" }
  }

  # every hook script referenced by settings.json must actually exist on disk
  $refs = @(); $broken = @()
  if ($settings.hooks) {
    foreach ($evt in $settings.hooks.PSObject.Properties.Name) {
      foreach ($entry in @($settings.hooks.$evt)) {
        foreach ($h in @($entry.hooks)) {
          $cmd = [string]$h.command
          foreach ($m in [regex]::Matches($cmd, '"([^"]+\.(?:ps1|sh|py))"')) {
            $p = $m.Groups[1].Value
            $refs += $p
            if (-not (Test-Path $p)) { $broken += $p }
          }
        }
      }
    }
  }
  if ($refs.Count -eq 0) { Bad "no hook script referenced in settings.json" }
  elseif ($broken.Count -eq 0) { Ok "$($refs.Count) hook script path(s) referenced, all present on disk" }
  else { Bad "hook script(s) referenced but MISSING: $($broken -join ', ')" }

  # the guards that actually deny (the layer prose cannot provide)
  $joined = ($refs -join ' ')
  $needGuards = 'protected-path-denylist','asset-delete-guard','destructive-block','shop-identity-guard','shop-token-identity-block','browser-nav-denylist','pitfall-tips','trio-fanout-cap'
  $missGuards = $needGuards | Where-Object { $joined -notmatch [regex]::Escape($_) }
  if (-not $missGuards) { Ok "all 8 PreToolUse guards wired (deny + advisory layer complete)" }
  else { Bad "guards not wired: $($missGuards -join ', ')" }

  if ($settings.permissions.defaultMode -eq 'acceptEdits') { Ok "defaultMode = acceptEdits (zero friction on file edits)" }
  else { Wrn "defaultMode = '$($settings.permissions.defaultMode)' (rig ships acceptEdits)" }

  if ($settings.env.CLAUDE_CODE_SUBAGENT_MODEL) { Ok "sub-agents = $($settings.env.CLAUDE_CODE_SUBAGENT_MODEL) (grunt-work cost divided)" }
  else { Wrn "CLAUDE_CODE_SUBAGENT_MODEL unset - sub-agents run on the main model (opt-in, see SETUP.md)" }
}

# ---- core docs ----------------------------------------------------------------------
Head "Core files"
$claudeMd = Join-Path $claude 'CLAUDE.md'
if (Test-Path $claudeMd) {
  if (Select-String -Path $claudeMd -Pattern 'SGRR AGI V2' -Quiet) { Ok "CLAUDE.md present (SGRR AGI V2 signature detected)" }
  else { Ok "CLAUDE.md present (signature absent - custom or removed, OK)" }
} else { Bad "CLAUDE.md missing" }
if (Test-Path (Join-Path $claude 'PITFALLS.md'))    { Ok "PITFALLS.md present (generalized mistake catalog)" } else { Bad "PITFALLS.md missing" }
if (Test-Path (Join-Path $claude 'SGRR-GUIDE.md'))  { Ok "SGRR-GUIDE.md present (local usage guide)" }        else { Bad "SGRR-GUIDE.md missing (copy USAGE.md)" }
if (Test-Path (Join-Path $claude 'memory\MEMORY.md')) { Ok "memory/MEMORY.md present" }                        else { Bad "memory/MEMORY.md missing" }

# ---- payload ------------------------------------------------------------------------
Head "Payload"
$nRules = Count-Files 'rules' '*.md'
$nCmds  = Count-Files 'commands' '*.md'
$nSkill = @(Get-ChildItem (Join-Path $claude 'skills') -Directory -ErrorAction SilentlyContinue).Count
$nAgent = Count-Files 'agents' '*.md'
$nScript = @(Get-ChildItem (Join-Path $claude 'scripts') -Recurse -File -ErrorAction SilentlyContinue).Count

if ($nRules  -ge 5)   { Ok "rules/    $nRules lazy paths: rules" }      else { Bad "rules/ only $nRules (>= 5 expected)" }
if ($nCmds   -ge 15)  { Ok "commands/ $nCmds slash commands" }          else { Bad "commands/ only $nCmds (>= 15 expected)" }
if ($nSkill  -ge 100) { Ok "skills/   $nSkill skills" }                 else { Bad "skills/ only $nSkill (>= 100 expected - re-run install without -Minimal)" }
if ($nAgent  -ge 1)   { Ok "agents/   $nAgent sub-agent definitions" }  else { Bad "agents/ empty" }
if ($nScript -ge 20)  { Ok "scripts/  $nScript hook scripts + tools" }  else { Bad "scripts/ only $nScript (>= 20 expected)" }

foreach ($f in @(
  @{ p = 'commands\session-check.md';      m = '/session-check command' },
  @{ p = 'skills\session-check\SKILL.md';  m = 'session-check skill' },
  @{ p = 'commands\rig-audit.md';          m = '/rig-audit command' },
  @{ p = 'scripts\rig-audit-nudge.ps1';    m = 'rig-audit periodic nudge' },
  @{ p = 'scripts\check-cc-updates.ps1';   m = 'Claude Code update watch' },
  @{ p = 'scripts\preflight-scrub.ps1';    m = 'preflight leak scrub' },
  @{ p = 'shops\GO-SHOPS.md';              m = 'GO-SHOPS.md (multi-store manual)' },
  @{ p = 'shopify\GO-SHOPIFY.md';          m = 'GO-SHOPIFY.md (Shopify manual)' }
)) {
  if (Test-Path (Join-Path $claude $f.p)) { Ok $f.m } else { Bad "$($f.m) missing ($($f.p))" }
}

# ---- machine-local config -----------------------------------------------------------
Head "Local config"
$zones = Join-Path $claude 'protected-zones.json'
if (Test-Path $zones) {
  $zRaw = Get-Content $zones -Raw
  if ($zRaw -match '<your-') { Wrn "protected-zones.json still has PLACEHOLDER folders - the write-gate blocks NOTHING until you edit it" }
  else {
    try {
      $zc = @(($zRaw | ConvertFrom-Json).zones).Count
      if ($zc -gt 0) { Ok "protected-zones.json: $zc zone(s) armed" } else { Wrn "protected-zones.json has no zones - write-gate inactive (deliberate?)" }
    } catch { Bad "protected-zones.json is invalid JSON - the gate exits 0 and protects nothing" }
  }
} else { Wrn "protected-zones.json absent - write-gate inactive (copy protected-zones.example.json)" }

$reg = Join-Path $claude 'shops-registry.md'
if (Test-Path $reg) { Ok "shops-registry.md present" } else { Wrn "shops-registry.md absent (only needed if you run stores)" }

# ---- verdict ------------------------------------------------------------------------
Head "Result: $pass OK / $warn WARN / $fail FAIL"
if ($fail -eq 0) {
  Write-Host "FULL PARITY. Your Claude applies the SGRR AGI V2 rig exactly." -ForegroundColor Green
  if ($warn -gt 0) { Write-Host "($warn warning(s) above are personalisation steps, not gaps.)" -ForegroundColor Yellow }
  exit 0
} else {
  Write-Host "GAP detected. Fix the [FAIL] lines above, then re-run." -ForegroundColor Yellow
  exit 1
}
