#Requires -Version 5.1
<#
  shopify-token-check.ps1 - SessionStart hook (SGRR AGI V2)
  The SHOP-A Admin token (.secrets/access-token.txt) is a 24h OAuth shpat_.
  Warn at session start when it is near/over expiry so the session regenerates
  it BEFORE burning API calls on 401s. Advisory only, never blocks. Exit 0 always.
#>
$ErrorActionPreference = 'SilentlyContinue'
try {
  $tok = 'C:\Users\YOU\Documents\BUSINESS\shopify\.secrets\access-token.txt'
  if (-not (Test-Path -LiteralPath $tok)) { exit 0 }
  $ageH = ((Get-Date) - (Get-Item -LiteralPath $tok).LastWriteTime).TotalHours
  if ($ageH -lt 20) { exit 0 }
  $severity = if ($ageH -ge 24) { 'EXPIRED' } else { 'APPROACHING EXPIRY' }
  $msg = "SHOPIFY TOKEN $severity ($([math]::Round($ageH,1))h old). Run: bash scripts/get-token.sh (from BUSINESS/shopify) before any Shopify Admin API call."
  @{ hookSpecificOutput = @{ hookEventName = 'SessionStart'; additionalContext = $msg } } |
    ConvertTo-Json -Compress -Depth 5 | Write-Output
} catch { }
exit 0
