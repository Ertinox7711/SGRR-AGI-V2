# shops-whoami.ps1 - SessionStart announce (advisory). Maps cwd to a shop in
# ~/.claude/shops-registry.json (boundary-safe) and injects the session's shop
# identity so the agent derives identity from the FOLDER, not memory. exit 0. ASCII.
$ErrorActionPreference = 'SilentlyContinue'

function PathInRoot([string]$path, [string]$root) {
  if (-not $path -or -not $root) { return $false }
  $n = ($path -replace '\\','/').ToLower().TrimEnd('/')
  $r = ($root -replace '\\','/').ToLower().TrimEnd('/')
  if (-not $r) { return $false }
  return ($n -eq $r) -or $n.StartsWith($r + '/')
}

try {
  $raw = [Console]::In.ReadToEnd()
  $cwd = ''
  if ($raw) { try { $o = $raw | ConvertFrom-Json; if ($o.cwd) { $cwd = ([string]$o.cwd -replace '\\','/').ToLower() } } catch {} }
  if (-not $cwd) { $cwd = ((Get-Location).Path -replace '\\','/').ToLower() }

  $regPath = Join-Path $env:USERPROFILE '.claude/shops-registry.json'
  if (-not (Test-Path -LiteralPath $regPath)) { exit 0 }
  $shops = @((Get-Content -Raw -LiteralPath $regPath | ConvertFrom-Json).shops)
  if (-not $shops) { exit 0 }

  $shop = $null; $bestLen = -1
  foreach ($s in $shops) { $fr = [string]$s.folder_root; if ($fr -and (PathInRoot $cwd $fr) -and $fr.Length -gt $bestLen) { $shop = $s; $bestLen = $fr.Length } }

  if ($shop) {
    $h = [string]$shop.store_handle; if (-not $h) { $h = '<TODO>' }
    $dom = [string]$shop.myshopify_domain; if (-not $dom) { $dom = '<TODO>.myshopify.com' }
    $ctx = "SHOP THIS SESSION = " + $shop.shop_name + " (" + $shop.niche + "), derived from cwd folder " + $shop.folder_root + " | handle " + $h + " | " + $dom + " | currency " + $shop.currency + " | WRITE=" + $shop.write_policy + " | status " + $shop.status + ". Identity comes from THIS folder, never from memory. Before ANY file write or Shopify API mutation: re-state the shop and get an explicit GO from the operator (double-confirm 't es sur que c est " + $shop.shop_name + "?'). Never touch another shop's folder/token/API without asking. One token = one store. Registry: ~/.claude/shops-registry.md"
  } else {
    $names = (@($shops | ForEach-Object { $_.shop_name + ' (' + $_.folder_root + ')' }) -join '; ')
    $ctx = "Current cwd is NOT a registered shop folder (and not inside one). Known shops: " + $names + ". If about to work on a shop, cd into its folder first so identity derives from the folder. A sibling folder whose name merely starts with a shop's (e.g. shopify-clone, shop-b-pro) is a DIFFERENT shop - register it before working on it. Registry: ~/.claude/shops-registry.md"
  }
  @{ hookSpecificOutput = @{ hookEventName = 'SessionStart'; additionalContext = $ctx } } | ConvertTo-Json -Compress -Depth 5 | Write-Output
} catch {}
exit 0
