#Requires -Version 5.1
<#
  pitfall-tips.ps1 - live pitfall coach (SGRR AGI V2, Windows)

  PreToolUse(Bash) hook. Reads the tool call on stdin, matches the command against a
  small ordered table of known traps, and injects the matching PITFALLS lesson as
  additionalContext BEFORE the command runs. First match wins.

  - Destructive matches (--no-verify, force-push, reset --hard, git clean, rm -rf):
    fire EVERY time.
  - Coaching matches (plain push, commit): throttled to once per few hours via a local
    cache, so they nudge without nagging.

  It ONLY ever injects advice. It never emits a permission decision, so it can never
  auto-allow or block a command - that stays the job of permissions.ask.

  Robust by design: wrapped in try/catch, exits 0 no matter what. No personal data.
  Cache: %USERPROFILE%\.claude\.pitfall-tips-cache.json
#>
$ErrorActionPreference = 'SilentlyContinue'
try {
  $raw = [Console]::In.ReadToEnd()
  if (-not $raw) { exit 0 }

  $cmd = $null
  $cwd = ''
  try {
    $obj = $raw | ConvertFrom-Json
    $cmd = $obj.tool_input.command
    if ($obj.cwd) { $cwd = [string]$obj.cwd }
  } catch { exit 0 }
  if (-not $cmd) { exit 0 }

  # Ordered trap table. ttl = throttle window in hours (0 = always fire).
  $rules = @(
    @{ id = 'no-verify';  ttl = 0; re = '--no-verify';
       msg = 'PITFALLS/the-bypass: a failing hook is a signal, not an obstacle. --no-verify ships the bug with the alarm disabled. Root-cause what the hook caught; never skip a check to make the bar green. (PITFALLS.md)' },
    @{ id = 'force-push'; ttl = 0; re = 'git\s+push\b[^|;&]*(--force|-f)\b';
       msg = 'PITFALLS/destructive-op: force-push rewrites published history - anyone who pulled is now broken. Confirm the branch is yours, prefer --force-with-lease, never force a shared branch. (PITFALLS.md)' },
    @{ id = 'reset-hard'; ttl = 0; re = 'git\s+reset\s+--hard';
       msg = 'PITFALLS/destructive-op: reset --hard discards uncommitted work with NO undo. Check git status / git stash first; confirm there is nothing you want to keep. (PITFALLS.md)' },
    @{ id = 'git-clean';  ttl = 0; re = 'git\s+clean\b';
       msg = 'PITFALLS/destructive-op: git clean permanently deletes untracked files. Dry-run first (git clean -nd) and read the list before the real run. (PITFALLS.md)' },
    @{ id = 'rm-rf';      ttl = 0; re = '\brm\s+-[a-zA-Z]*[rf]';
       msg = 'PITFALLS/destructive-op: recursive/forced rm has no undo. Echo the exact target, make sure no glob expands wider than intended, confirm a backup or clean git state exists. (PITFALLS.md)' },
    @{ id = 'push';       ttl = 4; re = 'git\s+push\b';
       msg = 'PITFALLS/secret-leak + false-done: push is visible to others and history is forever. Before it: secret-scan/preflight exit 0, diff reviewed, build+tests green. Done = verified, not assumed. (PITFALLS.md)' },
    @{ id = 'commit';     ttl = 4; re = 'git\s+commit\b';
       msg = 'PITFALLS/blind-commit: read git diff --cached in full before committing. One feature per commit, nothing out-of-scope staged; type-check typed code first. (PITFALLS.md)' },
    @{ id = 'liquid-sections'; ttl = 4; re = 'push-sections\.js|push-blocks\.js|themeFilesUpsert';
       msg = 'SHOPIFY/liquid-modular: before pushing, every custom .liquid section MUST carry a complete {% schema %} (every visible text/image/color/spacing an editable setting, CSS scoped via section.id, sensible defaults, a preset name) and the wiring must be NON-DESTRUCTIVE (read templates/*.json, insert by anchor, skip-if-present, never rewrite a template wholesale). After the push: purge the theme cache. Watch for unterminated {% %} blocks - heredocs eat %} sequences.' },
    @{ id = 'dev-server'; ttl = 0; re = 'npm\s+run\s+dev|pnpm\s+dev|yarn\s+dev|node\s+index\.js';
       msg = 'PITFALLS/runaway-process: check for an ALREADY-RUNNING dev server before starting another (double work, double side effects, port conflict). List the processes / check the port first; kill or reuse the stale instance.' },
    @{ id = 'outward-artifact'; ttl = 0; re = '\.prv\b|publish|deploy|--prod\b';
       msg = 'PITFALLS/visible-to-others: this touches an outward-facing pipeline. Confirm the content is final and approved BEFORE creating or editing the artifact - published output is not reliably retractable.' }
    # Add project-scoped tips of your own with cwdRe, so they only fire inside that
    # project:  @{ id = 'myproj-x'; ttl = 0; cwdRe = 'MyProject'; re = '...'; msg = '...' }
  )

  $opts = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
  $hit = $null
  foreach ($r in $rules) {
    if ($r.cwdRe -and -not [regex]::IsMatch($cwd, $r.cwdRe, $opts)) { continue }
    if ([regex]::IsMatch($cmd, $r.re, $opts)) { $hit = $r; break }
  }
  if (-not $hit) { exit 0 }

  # Coaching tips (ttl > 0) are throttled; destructive tips always fire.
  if ($hit.ttl -gt 0) {
    $cacheFile = Join-Path $env:USERPROFILE '.claude\.pitfall-tips-cache.json'
    $state = @{}
    if (Test-Path -LiteralPath $cacheFile) {
      try {
        $obj = Get-Content -Raw -LiteralPath $cacheFile | ConvertFrom-Json
        foreach ($p in $obj.PSObject.Properties) { $state[$p.Name] = $p.Value }
      } catch { }
    }
    $last = $state[$hit.id]
    if ($last) {
      $elapsedH = ((Get-Date).ToUniversalTime() - ([datetime]::Parse($last)).ToUniversalTime()).TotalHours
      if ($elapsedH -lt $hit.ttl) { exit 0 }   # fired recently -> stay quiet
    }
    $state[$hit.id] = (Get-Date).ToUniversalTime().ToString('o')
    try {
      $dir = Split-Path -Parent $cacheFile
      if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
      $state | ConvertTo-Json | Set-Content -LiteralPath $cacheFile -Encoding UTF8
    } catch { }
  }

  @{ hookSpecificOutput = @{ hookEventName = 'PreToolUse'; additionalContext = $hit.msg } } |
    ConvertTo-Json -Compress -Depth 5 | Write-Output
} catch { }
exit 0
