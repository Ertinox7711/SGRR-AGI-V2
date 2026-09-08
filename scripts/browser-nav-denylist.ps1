# browser-nav-denylist.ps1 - PreToolUse gate for browser navigation tools.
#
# Purpose: make "a READ-ONLY shop's admin is off-limits in the browser" a TECHNICAL
# gate, not just prose. Blocks navigating a browser to the ADMIN/backend of any shop
# the registry marks write_policy=read-only (SHOP-A) - so even an unattended run
# cannot open its backend in the operator's logged-in Brave session. Writable shops'
# admin (e.g. SHOP-B shop-b-handle) is ALLOWED so multi-shop work is possible.
#
# Registry-aware (~/.claude/shops-registry.json). Hardcoded SHOP-A fallback
# (shop-a-handle) still blocks SHOP-A if the registry is missing/unreadable. Partners
# and account dashboards stay blocked outright. Non-navigation tools / no URL ->
# allow. Fail-OPEN on parse error (defense in depth, not the sole guard).
#
# Output contract (Claude Code PreToolUse): emit JSON permissionDecision 'deny' to
# block; emit nothing (exit 0) to allow. ASCII output only (PS5.1 reads .ps1 as ANSI;
# a non-ASCII char in a string literal would break parsing and silently kill the hook).

$ErrorActionPreference = 'SilentlyContinue'

try {
    $raw = [Console]::In.ReadToEnd()
    if (-not $raw) { exit 0 }
    $payload = $raw | ConvertFrom-Json
} catch {
    exit 0   # fail-open (see header)
}

$tool = [string]$payload.tool_name
$ti = $payload.tool_input

# Collect any URL-ish strings from the tool input.
$urls = @()
foreach ($field in 'url','href','address','location') {
    $v = $ti.$field
    if ($v) { $urls += [string]$v }
}
# computer/javascript tools can carry a URL inside free text; scan serialized input.
if ($tool -match 'computer|javascript_tool|browser_evaluate|browser_run_code') {
    $urls += ($ti | ConvertTo-Json -Compress -Depth 6)
}
if ($urls.Count -eq 0) { exit 0 }

# Build the set of READ-ONLY shop handles + domains from the registry.
$roHandles = @{}
$roDomains = @{}
try {
    $regPath = Join-Path $env:USERPROFILE '.claude/shops-registry.json'
    if (Test-Path -LiteralPath $regPath) {
        $shops = @((Get-Content -Raw -LiteralPath $regPath | ConvertFrom-Json).shops)
        foreach ($s in $shops) {
            if (([string]$s.write_policy) -eq 'read-only') {
                $h = ([string]$s.store_handle).ToLower().Trim()
                $d = ([string]$s.myshopify_domain).ToLower().Trim()
                if ($h) { $roHandles[$h] = $true }
                if ($d) { $roDomains[$d] = $true }
            }
        }
    }
} catch {}
# Hardcoded fallback: SHOP-A is read-only no matter what the registry says.
$roHandles['shop-a-handle'] = $true
$roDomains['shop-a-handle.myshopify.com'] = $true

function DenyNav([string]$why) {
    $reason = "BLOCKED by browser-nav-denylist: $why. That shop is READ-ONLY " +
              "(registry / global CLAUDE.md autonomy rule). Other shops' admin is " +
              "allowed - this one is not. Read its stats via the read-only API token, " +
              "never the admin UI in the browser."
    $out = @{
        hookSpecificOutput = @{
            hookEventName            = 'PreToolUse'
            permissionDecision       = 'deny'
            permissionDecisionReason = $reason
        }
    }
    $out | ConvertTo-Json -Compress -Depth 5
    exit 0
}

foreach ($u in $urls) {
    $lu = ([string]$u).ToLower()

    # Account-level surfaces: always blocked.
    if ($lu -match 'partners\.shopify\.com')  { DenyNav 'Shopify Partners dashboard (protected)' }
    if ($lu -match 'accounts\.shopify\.com')  { DenyNav 'Shopify account/login (protected)' }

    # Extract a store handle from an admin URL form.
    $handle = $null
    $m = [regex]::Match($lu, 'admin\.shopify\.com/store/([a-z0-9\-]+)')
    if ($m.Success) { $handle = $m.Groups[1].Value }
    if (-not $handle) {
        $m2 = [regex]::Match($lu, '([a-z0-9\-]+)\.myshopify\.com/admin')
        if ($m2.Success) { $handle = $m2.Groups[1].Value }
    }
    if ($handle) {
        if ($roHandles.ContainsKey($handle) -or $roDomains.ContainsKey($handle + '.myshopify.com')) {
            DenyNav ("admin of READ-ONLY shop '" + $handle + "'")
        }
        # writable / unknown store admin -> allow (fall through)
    }

    # Read-only store backend host (with or without /admin), e.g. shop-a-handle.myshopify.com.
    foreach ($d in $roDomains.Keys) {
        if ($lu -match [regex]::Escape($d)) { DenyNav ("READ-ONLY store backend '" + $d + "'") }
    }
}

exit 0
