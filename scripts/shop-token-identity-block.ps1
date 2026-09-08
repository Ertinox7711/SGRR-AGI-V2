# shop-token-identity-block.ps1 - PreToolUse HARD gate (fail-open).
#
# The non-spoofable identity check: the creds/token in a shop folder must actually
# belong to that shop (registry ~/.claude/shops-registry.json). Catches "wrong
# token/creds dropped in the right folder". DENIES only on a CONFIRMED mismatch;
# on ANY uncertainty (missing files, no network, parse error, registry domain not
# yet filled) it ALLOWS (exit 0). Boundary-safe folder resolution. All domain
# comparisons are trimmed + lowercased + de-schemed + de-slashed so whitespace/URL
# noise can never cause a FALSE-DENY. ASCII output only.
#
# Engages on Bash OR PowerShell commands that touch Shopify. Two checks:
#   (1) STATIC, no network: app-credentials.txt SHOP= must equal registry domain
#       (matches plain / export / https:// / quoted / trailing-slash forms).
#   (2) LIVE, cached 30 min (key bound to the expected domain; mismatches are
#       NOT cached, so fixing the token/registry clears the block immediately).

$ErrorActionPreference = 'SilentlyContinue'

function NormDom([string]$d) {
  if (-not $d) { return '' }
  $x = $d.ToLower().Trim()
  $x = $x -replace '^https?://',''
  return $x.TrimEnd('/')
}
function PathInRoot([string]$path, [string]$root) {
  if (-not $path -or -not $root) { return $false }
  $n = ($path -replace '\\','/').ToLower().TrimEnd('/')
  $r = ($root -replace '\\','/').ToLower().TrimEnd('/')
  if (-not $r) { return $false }
  return ($n -eq $r) -or $n.StartsWith($r + '/')
}

try {
  $raw = [Console]::In.ReadToEnd()
  if (-not $raw) { exit 0 }
  $p = $raw | ConvertFrom-Json
  $tool = [string]$p.tool_name
  if ($tool -ne 'Bash' -and $tool -ne 'PowerShell') { exit 0 }
  $cmd = [string]$p.tool_input.command
  if (-not $cmd) { exit 0 }
  $lc = ($cmd -replace '\\','/').ToLower()
  if ($lc -notmatch 'get-token|\.myshopify\.com|admin/api|x-shopify-access-token|oauth/access_token|shpat_|shop-context') { exit 0 }

  $cwd = ''
  if ($p.cwd) { $cwd = ([string]$p.cwd -replace '\\','/').ToLower() }
  $regPath = Join-Path $env:USERPROFILE '.claude/shops-registry.json'
  if (-not (Test-Path -LiteralPath $regPath)) { exit 0 }
  $shops = @((Get-Content -Raw -LiteralPath $regPath | ConvertFrom-Json).shops)
  if (-not $shops) { exit 0 }

  # Resolve the shop folder this command operates in: prefer a folder_root named
  # in the command (boundary-safe token), else the cwd's shop (boundary-safe).
  $shop = $null; $bestLen = -1
  foreach ($s in $shops) {
    $fr = ([string]$s.folder_root).ToLower().TrimEnd('/')
    if ($fr -and ($lc -match ([regex]::Escape($fr) + '(?:$|[/\s"''<>;|&)])')) -and $fr.Length -gt $bestLen) { $shop = $s; $bestLen = $fr.Length }
  }
  if (-not $shop) {
    $bestLen = -1
    foreach ($s in $shops) { $fr = [string]$s.folder_root; if ($fr -and (PathInRoot $cwd $fr) -and $fr.Length -gt $bestLen) { $shop = $s; $bestLen = $fr.Length } }
  }
  if (-not $shop) { exit 0 }

  $expect = NormDom ([string]$shop.myshopify_domain)
  if (-not $expect -or $expect -match 'todo' -or $expect -notmatch '\.myshopify\.com') { exit 0 }  # registry not filled -> allow

  $deny = $null

  # (1) STATIC creds check (no network) - plain / export / https:// / quoted forms.
  $creds = [string]$shop.creds_path
  if ($creds -and (Test-Path -LiteralPath $creds)) {
    try {
      $cl = Get-Content -Raw -LiteralPath $creds
      $m = [regex]::Match($cl, '(?im)^\s*(?:export\s+)?SHOP\s*=\s*["'']?\s*(?:https?://)?([a-z0-9.\-]+\.myshopify\.com)')
      if ($m.Success) {
        $credsDom = NormDom $m.Groups[1].Value
        if ($credsDom -ne $expect) {
          $deny = "app-credentials.txt in this folder defines SHOP=" + $credsDom + " but the registry says this folder (" + $shop.shop_name + ") = " + $expect + ". WRONG CREDENTIALS in the folder -> get-token would reach the wrong store. STOP; fix .secrets/app-credentials.txt or the registry row."
        }
      }
    } catch {}
  }

  # (2) LIVE token check (network, cache 'ok' verdicts 30 min; never cache a mismatch).
  if (-not $deny) {
    $tokenPath = [string]$shop.token_path
    if ($tokenPath -and (Test-Path -LiteralPath $tokenPath)) {
      $tok = (Get-Content -Raw -LiteralPath $tokenPath -ErrorAction SilentlyContinue)
      if ($tok) { $tok = $tok.Trim() }
      if ($tok -and $tok.StartsWith('shpat_')) {
        $cacheFile = Join-Path $env:USERPROFILE '.claude/.shop-token-cache.json'
        try {
          $sha = [System.Security.Cryptography.SHA256]::Create()
          $hash = [System.BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($tok))).Replace('-','').Substring(0,16)
        } catch { $hash = 'x' }
        $key = [string]$shop.shop_name + ':' + $hash + ':' + $expect   # bound to expected domain
        $cache = @{}
        if (Test-Path -LiteralPath $cacheFile) { try { $o = Get-Content -Raw -LiteralPath $cacheFile | ConvertFrom-Json; foreach ($pr in $o.PSObject.Properties) { $cache[$pr.Name] = $pr.Value } } catch {} }
        $freshOk = $false
        $c = $cache[$key]
        if ($c) { try { $age = ((Get-Date).ToUniversalTime() - ([datetime]::Parse([string]$c.ts)).ToUniversalTime()).TotalMinutes; if ($age -ge 0 -and $age -lt 30 -and [string]$c.verdict -eq 'ok') { $freshOk = $true } } catch {} }
        if (-not $freshOk) {
          $api = 'https://' + $expect + '/admin/api/2025-01/graphql.json'
          $resp = & curl.exe -s --max-time 6 -X POST $api -H ("X-Shopify-Access-Token: " + $tok) -H "Content-Type: application/json" -d '{"query":"{ shop { myshopifyDomain } }"}' 2>$null
          if ($resp -and ($resp -match '"myshopifyDomain"\s*:\s*"([^"]+)"')) {
            $actual = NormDom $Matches[1]
            if ($actual -ne $expect) {
              $deny = "The token in this folder's .secrets reaches " + $actual + " but the registry says this folder (" + $shop.shop_name + ") = " + $expect + ". WRONG TOKEN in the folder. STOP."
              # do NOT cache a mismatch (so fixing token/registry clears the block at once)
            } else {
              $cache[$key] = @{ ts = (Get-Date).ToUniversalTime().ToString('o'); verdict = 'ok' }
              try { $cache | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $cacheFile -Encoding ASCII } catch {}
            }
          }
          # no/invalid response -> fail-open (don't deny)
        }
      }
    }
  }

  if ($deny) {
    @{ hookSpecificOutput = @{ hookEventName = 'PreToolUse'; permissionDecision = 'deny'; permissionDecisionReason = ("SHOP-TOKEN-BLOCK: " + $deny) } } | ConvertTo-Json -Compress -Depth 5 | Write-Output
  }
} catch {}
exit 0
