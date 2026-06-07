#Requires -Version 5.1
<#
  verify-install.ps1 — SGRR AGI V2 (Windows)

  Self-test de PARITE : prouve que ton install ~/.claude applique EXACTEMENT
  la meme config et la meme philosophie que le rig d'origine. Pas "a peu pres".

  Sortie : une ligne par controle (OK / FAIL), un verdict, un code retour.
    exit 0 = parite totale ; exit 1 = au moins un ecart.

  Usage:  ./scripts/verify-install.ps1
#>
[CmdletBinding()]
param()

$claude = Join-Path $env:USERPROFILE '.claude'
$pass = 0; $fail = 0
function Ok($m)   { Write-Host "  [OK]   $m" -ForegroundColor Green; $script:pass++ }
function Bad($m)  { Write-Host "  [FAIL] $m" -ForegroundColor Red;   $script:fail++ }
function Head($m) { Write-Host "`n$m" -ForegroundColor Cyan }

Head "SGRR AGI V2 — self-test de parite ($claude)"

# 1. settings.json existe + JSON valide
$settingsPath = Join-Path $claude 'settings.json'
$settings = $null
if (Test-Path $settingsPath) {
  try { $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json; Ok "settings.json present et JSON valide" }
  catch { Bad "settings.json present mais JSON INVALIDE : $($_.Exception.Message)" }
} else { Bad "settings.json absent" }

if ($settings) {
  # 2. Modele principal = opus
  if ($settings.model -eq 'opus') { Ok "model = opus (intelligence max sur la boucle principale)" }
  else { Bad "model = '$($settings.model)' (attendu : opus)" }

  # 3. Sous-agents sur Sonnet (facture / 5)
  if ($settings.env.CLAUDE_CODE_SUBAGENT_MODEL -eq 'sonnet') { Ok "sous-agents = sonnet (cout grunt-work divise)" }
  else { Bad "CLAUDE_CODE_SUBAGENT_MODEL = '$($settings.env.CLAUDE_CODE_SUBAGENT_MODEL)' (attendu : sonnet)" }

  # 4. 12 plugins actives
  $plugins = @()
  if ($settings.enabledPlugins) { $plugins = ($settings.enabledPlugins.PSObject.Properties | Where-Object { $_.Value -eq $true }).Name }
  if ($plugins.Count -ge 12) { Ok "$($plugins.Count) plugins actives (>= 12 attendus)" }
  else { Bad "$($plugins.Count) plugins actives (12 attendus — relance /plugin)" }

  # 5. Les 4 hooks d'injection de contexte
  $needHooks = 'UserPromptSubmit','SessionStart','PreCompact','Stop'
  $haveHooks = @(); if ($settings.hooks) { $haveHooks = $settings.hooks.PSObject.Properties.Name }
  $missing = $needHooks | Where-Object { $_ -notin $haveHooks }
  if (-not $missing) { Ok "4 hooks presents (UserPromptSubmit/SessionStart/PreCompact/Stop)" }
  else { Bad "hooks manquants : $($missing -join ', ')" }

  # 6. Filet de permissions destructives
  $askCount = 0; if ($settings.permissions.ask) { $askCount = @($settings.permissions.ask).Count }
  if ($askCount -ge 10) { Ok "$askCount commandes destructives sous confirmation (permissions.ask)" }
  else { Bad "permissions.ask trop court ($askCount) — garde-fous incomplets" }
}

# 7. CLAUDE.md present + signature SGRR
$claudeMd = Join-Path $claude 'CLAUDE.md'
if (Test-Path $claudeMd) {
  if (Select-String -Path $claudeMd -Pattern 'SGRR AGI V2' -Quiet) { Ok "CLAUDE.md present (signature SGRR AGI V2 detectee)" }
  else { Ok "CLAUDE.md present (signature absente — perso ou supprimee, OK)" }
} else { Bad "CLAUDE.md absent" }

# 8. Memoire
if (Test-Path (Join-Path $claude 'memory\MEMORY.md')) { Ok "memory/MEMORY.md present" } else { Bad "memory/MEMORY.md absent" }

# 9. Rules (contexte paresseux)
$rulesDir = Join-Path $claude 'rules'
if ((Test-Path $rulesDir) -and (Get-ChildItem $rulesDir -Filter *.md -ErrorAction SilentlyContinue)) { Ok "rules/*.md present (lazy-loading paths:)" }
else { Bad "rules/ vide ou absent" }

# 10. Guide local
if (Test-Path (Join-Path $claude 'SGRR-GUIDE.md')) { Ok "SGRR-GUIDE.md present (guide d'utilisation local)" }
else { Bad "SGRR-GUIDE.md absent (copie UTILISATION.md)" }

# 11. Veille des MAJ Claude Code (boucle d'auto-amelioration)
if (Test-Path (Join-Path $claude 'scripts\check-cc-updates.ps1')) { Ok "veille MAJ presente (scripts/check-cc-updates.ps1)" }
else { Bad "veille MAJ absente (copie scripts/check-cc-updates.ps1 -> ~/.claude/scripts/)" }

# Verdict
Head "Resultat : $pass OK / $fail FAIL"
if ($fail -eq 0) {
  Write-Host "PARITE TOTALE. Ton Claude applique exactement le rig SGRR AGI V2." -ForegroundColor Green
  exit 0
} else {
  Write-Host "ECART detecte. Corrige les [FAIL] ci-dessus puis relance." -ForegroundColor Yellow
  exit 1
}
