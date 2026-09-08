# shops-banner.ps1 -Folder <root>  - emit the CLAUDE.md identity banner for a shop,
# filled from ~/.claude/shops-registry.json (boundary-safe folder match). Stamp a
# new shop's CLAUDE.md with it (scale to N shops, no hand-typing). ASCII output.
#   Usage: powershell -NoProfile -File ~/.claude/scripts/shops-banner.ps1 -Folder "C:\Users\YOU\Documents\BUSINESS\shop-b"
param([Parameter(Mandatory=$true)][string]$Folder)
$ErrorActionPreference = 'Stop'

function PathInRoot([string]$path, [string]$root) {
  if (-not $path -or -not $root) { return $false }
  $n = ($path -replace '\\','/').ToLower().TrimEnd('/')
  $r = ($root -replace '\\','/').ToLower().TrimEnd('/')
  if (-not $r) { return $false }
  return ($n -eq $r) -or $n.StartsWith($r + '/')
}

$regPath = Join-Path $env:USERPROFILE '.claude/shops-registry.json'
$shops = @((Get-Content -Raw -LiteralPath $regPath | ConvertFrom-Json).shops)
$shop = $null; $bestLen = -1
foreach ($s in $shops) { $fr = [string]$s.folder_root; if ($fr -and (PathInRoot $Folder $fr) -and $fr.Length -gt $bestLen) { $shop = $s; $bestLen = $fr.Length } }
if (-not $shop) { Write-Error "No registry row matches folder (boundary-exact): $Folder"; exit 1 }
$others = (@($shops | Where-Object { $_.folder_root -ne $shop.folder_root } | ForEach-Object { $_.shop_name + ' (' + $_.folder_root + ')' }) -join ' ; ')
if (-not $others) { $others = '(none yet)' }
$h = [string]$shop.store_handle; if (-not $h) { $h = '<TODO>' }
$dom = [string]$shop.myshopify_domain; if (-not $dom) { $dom = '<TODO>.myshopify.com' }
$L = @()
$L += "> ## SHOP = " + $shop.shop_name.ToUpper() + " . NICHE = " + $shop.niche
$L += "> FOLDER = " + $shop.folder_root
$L += "> HANDLE = " + $h + " . API = " + $dom
$L += "> CURRENCY = " + $shop.currency + " . WRITE = " + $shop.write_policy + " . STATUS = " + $shop.status
$L += "> TOKEN = " + $shop.token_path + " (never another shop's token)"
$L += "> ----------------------------------------------------------------"
$L += "> IDENTITY COMES FROM THIS FOLDER, NEVER FROM MEMORY."
$L += "> - If cwd != this FOLDER -> STOP, you are not on " + $shop.shop_name + ". A sibling whose name merely starts the same (e.g. " + $shop.shop_name.ToLower() + "-pro) is a DIFFERENT shop."
$L += "> - NEVER touch another shop this session: " + $others + "."
$L += "> - Before ANY write / API mutation: re-state 'Shop = " + $shop.shop_name + " (" + $shop.niche + ") - sure?' and get an explicit GO from the operator."
$L += "> - Every handle/domain/GID you write must be COPIED from this banner / the registry, never typed from memory."
$L += "> Registry = ~/.claude/shops-registry.md. Banner != registry -> STOP, reconcile (registry wins)."
$L -join "`n"
