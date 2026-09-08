# trio-fanout-cap.ps1 — PreToolUse cap on Task fan-out for the UNATTENDED trio executor.
#
# Purpose (rank 6, the operator /goal 2026-06-16 "Strict + validation"): the auto_executor
# child (Opus 4.8) may decompose a heavy multi-volet task into up to 3 PARALLEL
# sub-Opus via the Task tool ("un enfant = une equipe"). The SAFE_PREAMBLE asks for
# depth=1 / max-3 in prose, but prose alone is insufficient under prompt-injection
# (red-team finding). This hook is the STRUCTURAL ceiling: it caps the TOTAL number of
# Task sub-agent spawns per execution at MAX, DEPTH-AGNOSTIC (a grandchild's Task call
# counts against the same budget, since it inherits the same env+counter) — so the
# worst-case fan-out is bounded even if the model is steered to ignore the prose.
#
# SCOPE: fires ONLY when env TRIO_AUTOEXEC=1 (set exclusively by auto_executor child
# spawns). the operator's interactive sessions and Workflow runs have it unset -> this hook
# allows every Task call (no restriction on the human).
#
# Counter file: <bridge>\.fanout.count — reset to empty by auto_executor.execute() at
# the start of each run. The daemon is single-in-flight (one execution at a time), so a
# single fixed counter file is race-safe across runs; concurrent sub-agents within one
# run append to it (append is atomic enough; over/under-shoot by 1 is harmless and the
# 900s EXEC_TIMEOUT is the ultimate hard bound on total burn).
#
# Output contract (Claude Code PreToolUse): emit JSON permissionDecision 'deny' to
# block; emit nothing (exit 0) to allow. Fail-OPEN on any error — the cap is a backstop,
# never the sole guard.

$ErrorActionPreference = 'SilentlyContinue'

# Drain stdin (hook contract) regardless; we don't need the payload.
try { [void][Console]::In.ReadToEnd() } catch {}

# Not the unattended hand -> no cap (human sessions / Workflow stay free).
if ($env:TRIO_AUTOEXEC -ne '1') { exit 0 }

$MAX = 3
$counter = 'C:\Users\YOU\Documents\HERMES\bridge\.fanout.count'

try {
    Add-Content -LiteralPath $counter -Value 'x' -ErrorAction Stop
    $n = @(Get-Content -LiteralPath $counter -ErrorAction Stop).Count
} catch {
    exit 0   # fail-open (see header) — 900s timeout still bounds total burn
}

if ($n -gt $MAX) {
    $reason = "BLOCKED par trio-fanout-cap : l'enfant auto-executor a deja lance $MAX " +
              "sous-agents Opus (plafond structurel, depth 1 / max $MAX par execution). " +
              "Ne relance pas de sous-agent : termine avec ceux deja lances ou fais le " +
              "reste toi-meme en direct."
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

exit 0
