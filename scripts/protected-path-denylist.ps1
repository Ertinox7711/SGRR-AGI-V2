# protected-path-denylist.ps1 - PreToolUse gate blocking WRITES into protected zones.
#
# Purpose: harden an unattended full-tool run (and any session). The hard autonomy
# rules in CLAUDE.md declare some folders read-only or write-protected. Prose + the
# model's judgment are layer 1; this is the TECHNICAL layer-2 gate, so even an
# injected or confused run physically cannot Write/Edit/rm into those zones.
# READS stay allowed - a protected zone is read-only, not no-access.
#
# The zone list is DATA, not code: it lives in ~/.claude/protected-zones.json so your
# own folder names never travel with this repo. Copy protected-zones.example.json to
# ~/.claude/protected-zones.json and edit it (install.ps1 does that for you).
#
# Covers Edit / Write / NotebookEdit / MultiEdit (file_path) and Bash (command
# containing a protected path + a mutation token). Non-matching calls pass (exit 0).
# Fail-OPEN on parse error or missing config (defense in depth, not sole guard).
# ASCII output only (a cp1252 console mangles non-ASCII -> would corrupt the JSON
# the harness parses).

$ErrorActionPreference = 'SilentlyContinue'

try {
    $raw = [Console]::In.ReadToEnd()
    if (-not $raw) { exit 0 }
    $payload = $raw | ConvertFrom-Json
} catch { exit 0 }

$tool = [string]$payload.tool_name
$ti = $payload.tool_input

# Per-zone explicit-consent unlock. A zone may name an "unlock" file; the user creates
# it (ISO-8601 timestamp inside) when asking for modifications in a supervised session.
# It auto-expires after 24h so an unattended run can never inherit it. A zone with no
# "unlock" field stays blocked always.
function Test-ZoneUnlocked([string]$relPath) {
    if (-not $relPath) { return $false }
    $f = Join-Path $env:USERPROFILE $relPath
    if (-not (Test-Path $f)) { return $false }
    try {
        $stamp = (Get-Content $f -Raw).Trim()
        $when = [datetime]::Parse($stamp, [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::AdjustToUniversal)
        return ((Get-Date).ToUniversalTime() - $when).TotalHours -lt 24
    } catch { return $false }
}

# Zones are matched in normalized form: lowercase, forward slashes. A zone that is a
# prefix of another ("business/ofm hub" vs "... v2") catches both.
$cfgPath = Join-Path $env:USERPROFILE '.claude\protected-zones.json'
if (-not (Test-Path $cfgPath)) { exit 0 }
try { $cfg = Get-Content $cfgPath -Raw | ConvertFrom-Json } catch { exit 0 }

$zones = @()
foreach ($z in @($cfg.zones)) {
    if (-not $z.match) { continue }
    if ($z.unlock -and (Test-ZoneUnlocked ([string]$z.unlock))) { continue }
    $why = if ($z.why) { [string]$z.why } else { [string]$z.match }
    $zones += @{ rx = ([string]$z.match).ToLower(); why = $why }
}
if ($zones.Count -eq 0) { exit 0 }

# Path boundary: end-of-string, slash, whitespace or quote. Appended to each zone so
# 'business/shopify' matches that dir and its children but NOT a sibling named
# 'business/shopify-clone'. A zone ending in a space still catches its ' v2' variant.
$bnd = '(?:$|[/\s"''])'

function Test-Path-Blocked([string]$p) {
    if (-not $p) { return $null }
    $n = ($p -replace '\\', '/').ToLower()
    foreach ($z in $zones) { if ($n -match ([regex]::Escape($z.rx) + $bnd)) { return $z.why } }
    return $null
}

$hit = $null

# File-path tools: any path landing in a protected zone = a write there.
if ($tool -match 'Edit|Write|NotebookEdit|MultiEdit') {
    foreach ($f in 'file_path','notebook_path','path') {
        $r = Test-Path-Blocked ([string]$ti.$f)
        if ($r) { $hit = $r; break }
    }
}

# Bash: block only when a protected path appears alongside a mutation token
# (reads - cat/ls/grep/Get-Content - into a read-only zone stay allowed).
if (-not $hit -and $tool -eq 'Bash') {
    $cmd = ([string]$ti.command)
    $n = ($cmd -replace '\\', '/').ToLower()
    $mut = '(\brm\b|\bmv\b|\bcp\b|\bmove-item\b|\bcopy-item\b|\bnew-item\b|\brobocopy\b|\bxcopy\b|>>|[^>]>[^>]|\btee\b|sed\s+-i|\btruncate\b|\bdd\b|remove-item|set-content|add-content|out-file|\bdel\b|\bmove\b|\bmkdir\b|\brmdir\b|chmod|chown|writefilesync|writefile|fs\.write|\.write\(|\[io\.file\]|io\.file|open\([^)]*[\x27\x22][rab+]*w)'
    foreach ($z in $zones) {
        if ($n -match ([regex]::Escape($z.rx) + $bnd) -and $n -match $mut) { $hit = $z.why; break }
    }
}

if ($hit) {
    $reason = "BLOCKED by protected-path-denylist: write/mutation inside " + $hit +
              ". Reading is fine, modifying is not (global autonomy rule, CLAUDE.md). " +
              "If you really want to modify this zone, say so explicitly in a supervised session."
    $out = @{ hookSpecificOutput = @{
        hookEventName = 'PreToolUse'
        permissionDecision = 'deny'
        permissionDecisionReason = $reason
    } }
    $out | ConvertTo-Json -Compress -Depth 5
    exit 0
}

exit 0
