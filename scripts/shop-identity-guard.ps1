# shop-identity-guard.ps1 - PreToolUse guard. ADVISORY for writable shops;
# HARD DENY for one case: an MCP write tool while the working folder is a
# read-only shop (extends the SHOP-A read-only wall to the MCP channel, which
# the path denylist cannot see). Identity derives from the FOLDER, boundary-safe
# (registry ~/.claude/shops-registry.json). Screams CROSS-SHOP on commands that
# reference 2 shops (named, or via a copied script's content). ASCII output only.
# try/catch, always exit 0 (a guard crash must never break a tool call).

$ErrorActionPreference = 'SilentlyContinue'

function PathInRoot([string]$path, [string]$root) {
  # boundary-safe: path == root OR path starts with root + '/'. Stops
  # business/shopify-clone from matching business/shopify, shop-bX from shop-b.
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
  $ti = $p.tool_input
  $cwd = ''
  if ($p.cwd) { $cwd = ([string]$p.cwd -replace '\\','/').ToLower() }

  $regPath = Join-Path $env:USERPROFILE '.claude/shops-registry.json'
  if (-not (Test-Path -LiteralPath $regPath)) { exit 0 }
  $shops = @((Get-Content -Raw -LiteralPath $regPath | ConvertFrom-Json).shops)
  if (-not $shops -or $shops.Count -eq 0) { exit 0 }

  function Match-Shop([string]$path) {
    if (-not $path) { return $null }
    $best = $null; $bestLen = -1
    foreach ($s in $shops) {
      $fr = [string]$s.folder_root
      if ($fr -and (PathInRoot $path $fr) -and $fr.Length -gt $bestLen) { $best = $s; $bestLen = $fr.Length }
    }
    return $best
  }

  $sessionShop = Match-Shop $cwd
  $msgs = @()
  $denyReason = $null

  # ---- File tools ----
  if ($tool -match 'Edit|Write|NotebookEdit|MultiEdit') {
    $fp = ''
    foreach ($f in 'file_path','notebook_path','path') { if ($ti.$f) { $fp = [string]$ti.$f; break } }
    $tgt = Match-Shop $fp
    if ($tgt) {
      if ([string]$tgt.write_policy -ne 'read-only') {
        $msgs += "SHOP-GUARD: this write targets shop '" + $tgt.shop_name + "' (" + $tgt.niche + ", handle " + $tgt.store_handle + "). Token=" + $tgt.token_path + ". Re-state the shop and get an explicit GO from the operator before applying. Do NOT touch any other shop."
      } else {
        $msgs += "SHOP-GUARD: this write targets READ-ONLY shop '" + $tgt.shop_name + "' (" + $tgt.niche + "). Writes there are blocked by policy (protected-path-denylist) - modify only if the operator explicitly asks in a supervised session."
      }
      if ($sessionShop -and ([string]$sessionShop.folder_root -ne [string]$tgt.folder_root)) {
        $msgs += "CROSS-SHOP WARNING: session cwd is shop '" + $sessionShop.shop_name + "' but this write lands in '" + $tgt.shop_name + "'. Almost always a wrong-shop mistake. STOP and confirm."
      }
    }
  }

  # ---- Bash ----
  if ($tool -eq 'Bash') {
    $cmd = [string]$ti.command
    $nc = ($cmd -replace '\\','/').ToLower()
    # shops named directly in the command - boundary-safe (root/domain/handle as a token).
    $named = @()
    foreach ($s in $shops) {
      $fr = ([string]$s.folder_root).ToLower().TrimEnd('/'); $dom = ([string]$s.myshopify_domain).ToLower(); $h = ([string]$s.store_handle).ToLower()
      $isN = $false
      if ($fr -and ($nc -match ([regex]::Escape($fr) + '(?:$|[/\s"''<>;|&)])'))) { $isN = $true }
      if ($dom -and $dom.Length -ge 6 -and ($nc -match ('(?<![a-z0-9.\-])' + [regex]::Escape($dom)))) { $isN = $true }
      if ($h -and $h.Length -ge 4 -and ($nc -match ("(?<![a-z0-9\-])" + [regex]::Escape($h) + "(?![a-z0-9\-])"))) { $isN = $true }
      if ($isN) { $named += $s }
    }
    # content-grep an invoked node/python/bash/ruby/go/ts script: read it, look for
    # ANOTHER shop's domain/handle inside (copied-script-with-hardcoded-handle).
    $scriptShops = @()
    if ($cmd -match '(?:node|python3?|bash|sh|ruby|deno|ts-node|tsx)\s+["'']?([^\s;|&><"'']+\.(?:js|mjs|cjs|ts|py|sh|rb))') {
      $sp = $Matches[1] -replace '\\','/'
      try {
        $abs = $sp
        if ($sp -notmatch '^[a-zA-Z]:' -and $sp -notmatch '^/') {
          $base = $cwd; if (-not $base) { $base = ((Get-Location).Path -replace '\\','/') }
          $abs = ($base.TrimEnd('/') + '/' + $sp)
        }
        while ($abs -match '/[^/]+/\.\./') { $abs = $abs -replace '/[^/]+/\.\./','/' }
        if (Test-Path -LiteralPath $abs) {
          $content = Get-Content -Raw -LiteralPath $abs -ErrorAction SilentlyContinue
          if ($content -and $content.Length -lt 400000) {
            $lc = $content.ToLower()
            foreach ($s in $shops) {
              $dom = ([string]$s.myshopify_domain).ToLower(); $h = ([string]$s.store_handle).ToLower()
              if (($dom -and $dom.Length -ge 6 -and $lc.Contains($dom)) -or ($h -and $h.Length -ge 6 -and $lc.Contains($h))) { $scriptShops += $s }
            }
          }
        }
      } catch {}
    }
    $allRef = @()
    foreach ($s in ($named + $scriptShops)) { if ($allRef -notcontains $s.shop_name) { $allRef += $s.shop_name } }
    if ($allRef.Count -ge 2) {
      $msgs += "CROSS-SHOP WARNING: this command references " + $allRef.Count + " shops (" + ($allRef -join ', ') + "). That usually means a wrong-shop mistake (e.g. a script copied from another shop with a hardcoded handle/domain). STOP and confirm the exact target shop."
    } elseif ($allRef.Count -eq 1 -and $sessionShop -and ($allRef[0] -ne $sessionShop.shop_name)) {
      $msgs += "CROSS-SHOP WARNING: session cwd is shop '" + $sessionShop.shop_name + "' but this command references shop '" + $allRef[0] + "'. The command may 'cd' away to that shop - confirm you really mean to act on '" + $allRef[0] + "'."
    } elseif ($sessionShop -and ($nc -match 'get-token|myshopify\.com|admin/api|x-shopify-access-token|shpat_|productupdate|themepublish|themefilesupsert|metafieldsset|productset')) {
      if ([string]$sessionShop.write_policy -ne 'read-only') {
        $msgs += "SHOP-GUARD: Shopify command on shop '" + $sessionShop.shop_name + "' (" + $sessionShop.niche + "). Confirm the shop + GO before mutating. One token = one store (" + $sessionShop.token_path + ")."
      }
    }
  }

  # ---- MCP Shopify write tools (identity = MCP session, not folder) ----
  if ($tool -match '^mcp__.*(update-product|create-product|bulk-update-product-status|update-collection|create-collection|graphql_mutation|create-discount|set-inventory|switch-shop)') {
    if ($sessionShop -and ([string]$sessionShop.write_policy -eq 'read-only')) {
      # extend the read-only wall to the MCP channel (the path denylist can't see MCP).
      $denyReason = "working folder = READ-ONLY shop '" + $sessionShop.shop_name + "' (" + $sessionShop.niche + "). MCP write tools must not mutate a read-only shop. If this MCP session targets a DIFFERENT, writable shop, run it from that shop's folder; otherwise the operator must explicitly authorize a supervised SHOP-A change."
    } else {
      $who = 'unknown (cwd not a registered shop)'
      if ($sessionShop) { $who = $sessionShop.shop_name + ' (' + $sessionShop.niche + ')' }
      $msgs += "SHOP-GUARD (MCP write): this acts on the shop bound to the MCP SESSION, not the working folder. Working folder shop = " + $who + ". Confirm the MCP session points at the SAME shop (check switch-shop / get-shop-info) and get a GO before mutating."
    }
  }

  if ($denyReason) {
    @{ hookSpecificOutput = @{ hookEventName = 'PreToolUse'; permissionDecision = 'deny'; permissionDecisionReason = ("SHOP-GUARD BLOCK: " + $denyReason) } } | ConvertTo-Json -Compress -Depth 5 | Write-Output
  } elseif ($msgs.Count -gt 0) {
    $ctx = ($msgs -join ' || ')
    @{ hookSpecificOutput = @{ hookEventName = 'PreToolUse'; additionalContext = $ctx } } | ConvertTo-Json -Compress -Depth 5 | Write-Output
  }
} catch {}
exit 0
