# asset-delete-guard.ps1 — PreToolUse gate (Bash): Claude Code never deletes or overwrites the operator's assets.
#
# Rule (the operator, 2026-09-04): "que toi tu ne supprimes plus jamais ses trucs a lui" — a profile purge had cost
# him a Discord bot token + 2 unique Ollama tags. Prose (global CLAUDE.md) is layer 1; this is the technical
# layer 2 so even a confused/unattended run cannot rm his stuff.
#
# Assets: Ollama models/tags (delete, cp, create over an EXISTING tag, API delete/copy/push), the ~/.hermes tree
# (profiles, .env/tokens, backups *.bak-*), ~/.ollama store, .credentials files, WSL distros (--unregister/--import).
# Reads and additions always pass. Adding a NEW Ollama tag passes (ollama create <new-name>).
#
# Unlock: ~/.claude/.asset-delete-unlock containing an ISO-8601 timestamp, valid 24h. Created ONLY after the operator
# gave an explicit GO naming the exact item to delete. Fail-OPEN on parse error; ASCII-only output.

$ErrorActionPreference = 'SilentlyContinue'

try {
    $raw = [Console]::In.ReadToEnd()
    if (-not $raw) { exit 0 }
    $payload = $raw | ConvertFrom-Json
} catch { exit 0 }

if (@('Bash', 'PowerShell') -notcontains [string]$payload.tool_name) { exit 0 }
$cmd = [string]$payload.tool_input.command
if (-not $cmd) { exit 0 }
$n = (($cmd -replace '\\', '/') -replace '\s+', ' ').ToLower()

function Test-Unlocked {
    $f = Join-Path $env:USERPROFILE '.claude\.asset-delete-unlock'
    if (-not (Test-Path $f)) { return $false }
    try {
        $stamp = (Get-Content $f -Raw).Trim()
        $when = [datetime]::Parse($stamp, [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::AdjustToUniversal)
        return ((Get-Date).ToUniversalTime() - $when).TotalHours -lt 24
    } catch { return $false }
}
if (Test-Unlocked) { exit 0 }

$why = $null
$oll = 'ollama(\.exe)?[^a-z0-9]{1,8}'

if ($n -match ($oll + '(rm|delete)\b')) {
    $why = 'ollama rm/delete = suppression d un modele/tag de the operator'
} elseif ($n -match ($oll + 'cp\b')) {
    $why = 'ollama cp = peut ecraser un tag existant (creer un nouveau nom avec ollama create a la place)'
} elseif ($n -match ($oll + 'create[^a-z0-9]{1,8}([a-z0-9._:/-]+)')) {
    $name = $Matches[2]
    $existing = @()
    try { $existing = (& ollama list 2>$null | Select-Object -Skip 1 | ForEach-Object { (($_ -split '\s+')[0]).ToLower() }) } catch {}
    $tag = if ($name -match ':') { $name } else { $name + ':latest' }
    if ($existing -contains $tag) { $why = "ollama create $name = ce tag EXISTE deja, ce serait un ecrasement" }
} elseif ($n -match '11434/api/(delete|copy|create|push)') {
    $why = 'API Ollama delete/copy/create/push'
} elseif ($n -match '\bhermes\b[^;&|]*\bprofile\b[^;&|]*\b(delete|rm|remove|purge)\b') {
    $why = 'hermes profile delete'
} elseif ($n -match 'wsl(\.exe)? [^;&|]*(--unregister|--import)\b') {
    $why = 'wsl --unregister/--import = distro WSL'
} elseif ($n -match '(\brm\b|\brmdir\b|remove-item|\bri\b|\bdel\b|\berase\b|\bunlink\b|\bshred\b|\bmv\b|move-item|rename-item|\bren\b)[^;&|]*(\.hermes\b|\.ollama\b|\.credentials|\.env\b|\.bak-)') {
    $why = 'suppression/deplacement sous ~/.hermes, ~/.ollama, d un .env, .credentials ou d un backup .bak-*'
}

if ($why) {
    $reason = "BLOCKED by asset-delete-guard: " + $why + ". Regle dure the operator 2026-09-04: Claude Code n efface ni n ecrase jamais ses affaires " +
              "(modeles Ollama, profils Hermes, tokens, backups). Ajouter = OK. Supprimer = lister l item, GO explicite de the operator, " +
              "puis unlock ~/.claude/.asset-delete-unlock (timestamp ISO, 24h)."
    $out = @{ hookSpecificOutput = @{
        hookEventName = 'PreToolUse'
        permissionDecision = 'deny'
        permissionDecisionReason = $reason
    } }
    $out | ConvertTo-Json -Compress -Depth 5
    exit 0
}

exit 0
