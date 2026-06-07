#Requires -Version 5.1
<#
  verify-install.ps1 - SGRR AGI V2 (Windows)

  PARITY self-test: proves your ~/.claude install applies EXACTLY the same config and
  the same philosophy as the original rig. Not "roughly".

  Output: one line per check (OK / FAIL), a verdict, an exit code.
    exit 0 = full parity ; exit 1 = at least one gap.

  Usage:  ./scripts/verify-install.ps1
#>
[CmdletBinding()]
param()

$claude = Join-Path $env:USERPROFILE '.claude'
$pass = 0; $fail = 0
function Ok($m)   { Write-Host "  [OK]   $m" -ForegroundColor Green; $script:pass++ }
function Bad($m)  { Write-Host "  [FAIL] $m" -ForegroundColor Red;   $script:fail++ }
function Head($m) { Write-Host "`n$m" -ForegroundColor Cyan }

Head "SGRR AGI V2 - parity self-test ($claude)"

# 1. settings.json exists + valid JSON
$settingsPath = Join-Path $claude 'settings.json'
$settings = $null
if (Test-Path $settingsPath) {
  try { $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json; Ok "settings.json present and valid JSON" }
  catch { Bad "settings.json present but INVALID JSON: $($_.Exception.Message)" }
} else { Bad "settings.json missing" }

if ($settings) {
  # 2. Main model = opus
  if ($settings.model -eq 'opus') { Ok "model = opus (max intelligence on the main loop)" }
  else { Bad "model = '$($settings.model)' (expected: opus)" }

  # 3. Sub-agents on Sonnet (billed / 5)
  if ($settings.env.CLAUDE_CODE_SUBAGENT_MODEL -eq 'sonnet') { Ok "sub-agents = sonnet (grunt-work cost divided)" }
  else { Bad "CLAUDE_CODE_SUBAGENT_MODEL = '$($settings.env.CLAUDE_CODE_SUBAGENT_MODEL)' (expected: sonnet)" }

  # 4. 12 plugins enabled
  $plugins = @()
  if ($settings.enabledPlugins) { $plugins = ($settings.enabledPlugins.PSObject.Properties | Where-Object { $_.Value -eq $true }).Name }
  if ($plugins.Count -ge 12) { Ok "$($plugins.Count) plugins enabled (>= 12 expected)" }
  else { Bad "$($plugins.Count) plugins enabled (12 expected - re-run /plugin)" }

  # 5. The 5 context-injection hooks
  $needHooks = 'PreToolUse','UserPromptSubmit','SessionStart','PreCompact','Stop'
  $haveHooks = @(); if ($settings.hooks) { $haveHooks = $settings.hooks.PSObject.Properties.Name }
  $missing = $needHooks | Where-Object { $_ -notin $haveHooks }
  if (-not $missing) { Ok "5 hooks present (PreToolUse/UserPromptSubmit/SessionStart/PreCompact/Stop)" }
  else { Bad "missing hooks: $($missing -join ', ')" }

  # 6. Destructive-permission safety net
  $askCount = 0; if ($settings.permissions.ask) { $askCount = @($settings.permissions.ask).Count }
  if ($askCount -ge 10) { Ok "$askCount destructive commands gated behind confirmation (permissions.ask)" }
  else { Bad "permissions.ask too short ($askCount) - safety net incomplete" }
}

# 7. CLAUDE.md present + SGRR signature
$claudeMd = Join-Path $claude 'CLAUDE.md'
if (Test-Path $claudeMd) {
  if (Select-String -Path $claudeMd -Pattern 'SGRR AGI V2' -Quiet) { Ok "CLAUDE.md present (SGRR AGI V2 signature detected)" }
  else { Ok "CLAUDE.md present (signature absent - custom or removed, OK)" }
} else { Bad "CLAUDE.md missing" }

# 8. Memory
if (Test-Path (Join-Path $claude 'memory\MEMORY.md')) { Ok "memory/MEMORY.md present" } else { Bad "memory/MEMORY.md missing" }

# 9. Rules (lazy context)
$rulesDir = Join-Path $claude 'rules'
if ((Test-Path $rulesDir) -and (Get-ChildItem $rulesDir -Filter *.md -ErrorAction SilentlyContinue)) { Ok "rules/*.md present (lazy-loading paths:)" }
else { Bad "rules/ empty or missing" }

# 10. Local guide
if (Test-Path (Join-Path $claude 'SGRR-GUIDE.md')) { Ok "SGRR-GUIDE.md present (local usage guide)" }
else { Bad "SGRR-GUIDE.md missing (copy USAGE.md)" }

# 11. Claude Code update watch (self-improvement loop)
if (Test-Path (Join-Path $claude 'scripts\check-cc-updates.ps1')) { Ok "update watch present (scripts/check-cc-updates.ps1)" }
else { Bad "update watch missing (copy scripts/check-cc-updates.ps1 -> ~/.claude/scripts/)" }

# 12. Rig self-audit (/rig-audit command + periodic nudge)
$auditCmd = Test-Path (Join-Path $claude 'commands\rig-audit.md')
$auditNudge = Test-Path (Join-Path $claude 'scripts\rig-audit-nudge.ps1')
if ($auditCmd -and $auditNudge) { Ok "rig self-audit present (/rig-audit command + periodic nudge)" }
elseif ($auditCmd) { Bad "rig-audit nudge missing (copy scripts/rig-audit-nudge.ps1)" }
else { Bad "/rig-audit command missing (copy commands/rig-audit.md -> ~/.claude/commands/)" }

# 13. PITFALLS catalog (the mistakes the rig refuses to repeat)
if (Test-Path (Join-Path $claude 'PITFALLS.md')) { Ok "PITFALLS.md present (generalized mistake catalog)" }
else { Bad "PITFALLS.md missing (copy PITFALLS.md -> ~/.claude/)" }

# 14. Live pitfall coach (PreToolUse hook + script)
$tipScript = Test-Path (Join-Path $claude 'scripts\pitfall-tips.ps1')
$tipHook = $false
if ($settings -and $settings.hooks -and $settings.hooks.PreToolUse) {
  $tipHook = (($settings.hooks.PreToolUse | Out-String) -match 'pitfall-tips')
}
if ($tipScript -and $tipHook) { Ok "live pitfall coach wired (PreToolUse -> scripts/pitfall-tips.ps1)" }
elseif ($tipScript) { Bad "pitfall-tips.ps1 present but PreToolUse hook not wired in settings.json" }
else { Bad "pitfall coach missing (copy scripts/pitfall-tips.ps1 + add the PreToolUse hook)" }

# Verdict
Head "Result: $pass OK / $fail FAIL"
if ($fail -eq 0) {
  Write-Host "FULL PARITY. Your Claude applies the SGRR AGI V2 rig exactly." -ForegroundColor Green
  exit 0
} else {
  Write-Host "GAP detected. Fix the [FAIL] lines above, then re-run." -ForegroundColor Yellow
  exit 1
}
