# destructive-block.ps1 - PreToolUse gate for Bash + PowerShell.
#
# TWO TIERS:
#   ALWAYS (every session, incl. the operator interactive): block raw force-push
#     (git push --force / -f) - rewrites published history. --force-with-lease ok.
#   STRICT (only when env TRIO_AUTOEXEC=1, i.e. the unattended auto_executor's
#     spawned agent): also block the catastrophic, hard-to-reverse ops an
#     unsupervised agent should never run on its own - rm -rf, git reset --hard,
#     git clean -f, recursive force deletes, drive format/wipe. Interactive
#     sessions stay lenient so the operator's normal rm -rf node_modules / reset --hard
#     are unaffected. The agent is told (SAFE_PREAMBLE) to stop+report instead.
#
# ASCII only (PS 5.1 cp1252 trap). Fail-open on parse error (defense in depth).

$ErrorActionPreference = 'SilentlyContinue'

function Deny([string]$reason) {
    $out = @{ hookSpecificOutput = @{
        hookEventName            = 'PreToolUse'
        permissionDecision       = 'deny'
        permissionDecisionReason = $reason
    } }
    $out | ConvertTo-Json -Compress -Depth 5 | Write-Output
    exit 0
}

try {
    $raw = [Console]::In.ReadToEnd()
    if (-not $raw) { exit 0 }
    $j = $raw | ConvertFrom-Json
    $cmd = [string]$j.tool_input.command
    if (-not $cmd) { exit 0 }
} catch { exit 0 }

# --- ALWAYS: raw force-push ---------------------------------------------------
if ($cmd -match 'git\s+push' -and $cmd -match '(--force(?!-with-lease))|(\s-f(\s|$))') {
    Deny('BLOCKED (destructive-block.ps1): raw force-push rewrites published history. Use git push --force-with-lease after explicit the operator confirmation.')
}

# --- STRICT: only for the unattended auto_executor agent ----------------------
if ($env:TRIO_AUTOEXEC -eq '1') {
    $hasR = ($cmd -match '\brm\b' -and $cmd -match '\s-{1,2}[a-zA-Z]*r' -and $cmd -match '\s-{1,2}[a-zA-Z]*f')
    if ($hasR) {
        Deny('BLOCKED (destructive-block STRICT/auto-exec): recursive-force rm is irreversible. Unattended agent must not bulk-delete - do the reversible work and report what needs deleting for the operator to confirm.')
    }
    if ($cmd -match 'git\s+reset\b' -and $cmd -match '--hard') {
        Deny('BLOCKED (STRICT): git reset --hard discards work irreversibly. Use git stash or reset --soft, or stop and report.')
    }
    if ($cmd -match 'git\s+clean\b' -and $cmd -match '\s-{1,2}[a-zA-Z]*f') {
        Deny('BLOCKED (STRICT): git clean -f deletes untracked files irreversibly. Stop and report instead.')
    }
    if ($cmd -match 'remove-item\b' -and $cmd -match '-(recurse|r)\b' -and $cmd -match '-(force|f)\b') {
        Deny('BLOCKED (STRICT): Remove-Item -Recurse -Force is irreversible bulk delete. Stop and report.')
    }
    if ($cmd -match '\b(rmdir|rd|del)\b\s+/[sq]') {
        Deny('BLOCKED (STRICT): recursive cmd delete (/s) is irreversible. Stop and report.')
    }
    if ($cmd -match '\bformat\s+[a-zA-Z]:' -or $cmd -match 'clear-disk\b' -or $cmd -match 'cipher\s+/w' -or $cmd -match '\bmkfs' -or ($cmd -match '\bdd\b' -and $cmd -match '\bof=')) {
        Deny('BLOCKED (STRICT): disk format/wipe is catastrophic and irreversible. Never run unattended.')
    }
}

exit 0
