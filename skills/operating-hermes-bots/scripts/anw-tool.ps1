# anw-tool.ps1 - pilotage du bot Discord "Always Need Wins" (profil Hermes "anw" dans WSL) depuis Windows.
# Appele par C:\Users\YOU\Desktop\ANW.bat. Aucun appel au LLM sauf "ask".
# Actions : state | status | start | stop | restart | log | pause | resume | ask <fichier-question>
param([Parameter(Position = 0)][string]$Action = "state", [Parameter(Position = 1)][string]$Arg = "")

$Distro = "Ubuntu-22.04"
$Unit = "hermes-gateway-anw"
$WdDir = "C:\Users\YOU\AppData\Local\anw-watchdog"
$Prof = "/home/YOU/.hermes/profiles/anw"
$Skill = "/mnt/c/Users/YOU/.claude/skills/operating-hermes-bots/scripts"
$PauseFile = Join-Path $WdDir "pause"

function Wsl([string]$cmd) {
    try { $o = & wsl.exe -d $Distro -u YOU -- /bin/bash -lc $cmd 2>&1; return ((($o | Out-String) -replace "`0", "")).TrimEnd() } catch { return "" }
}
function Http($path) { try { return (Invoke-WebRequest -Uri "http://127.0.0.1:11434$path" -UseBasicParsing -TimeoutSec 4).Content } catch { return $null } }
function Say($s) { Write-Output ("   " + $s) }
function Lines($text) { if ($text) { ($text -split "`n") | ForEach-Object { Say $_.TrimEnd() } } }
function State {
    $unit = Wsl "systemctl --user is-active $Unit"
    $up = [bool](Http "/api/version")
    $loaded = "-"
    if ($up) {
        $ps = Http "/api/ps"
        if ($ps) { try { $n = @((($ps | ConvertFrom-Json).models) | ForEach-Object { $_.name }); $loaded = $(if ($n.Count) { $n -join "," } else { "aucun" }) } catch {} }
    }
    $vram = "?"; try { $vram = (& nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader 2>$null | Out-String).Trim() } catch {}
    $tick = "?"; try { $tick = (Get-Content (Join-Path $WdDir "state.json") -Raw | ConvertFrom-Json).lastTick } catch {}
    Say ("Gateway ANW : {0}   Ollama : {1} (charge : {2})   VRAM : {3}" -f $unit, $(if ($up) { "up" } else { "ETEINT" }), $loaded, $vram)
    Say ("Gardien     : dernier tour {0}{1}" -f $tick, $(if (Test-Path $PauseFile) { "   [EN PAUSE - fichier pause]" } else { "" }))
}

switch ($Action) {
    "state" { State }
    "status" {
        State
        Say ""; Say "Unite systemd :"; Lines (Wsl "systemctl --user status $Unit --no-pager 2>&1 | head -n 5")
        Say ""; Say "Derniers appels au modele (agent.log) :"; Lines (Wsl "grep 'API call' $Prof/logs/agent.log | tail -n 3 | cut -c1-170")
        Say ""; Say "Dernieres reponses Discord (gateway.log) :"; Lines (Wsl "grep 'response ready' $Prof/logs/gateway.log | tail -n 3 | cut -c1-170")
        Say ""; Say "Session Discord vivante (state.db) :"; Lines (Wsl "python3 $Skill/check_prompt.py anw '' | head -n 1")
        Say ""; Say "Gardien (5 dernieres lignes) :"
        if (Test-Path (Join-Path $WdDir "anw-watchdog.log")) { Get-Content (Join-Path $WdDir "anw-watchdog.log") -Tail 5 | ForEach-Object { Say $_ } }
        try { $i = Get-ScheduledTask -TaskName "ANW-Watchdog" | Get-ScheduledTaskInfo; Say ("Tache ANW-Watchdog : dernier run {0} (code {1}), prochain {2}" -f $i.LastRunTime, $i.LastTaskResult, $i.NextRunTime) }
        catch { Say "Tache ANW-Watchdog : ABSENTE -> powershell -File $WdDir\install-task.ps1" }
    }
    "start" {
        Remove-Item $PauseFile -ErrorAction SilentlyContinue
        Say "Demarrage de la gateway ANW..."; Wsl "systemctl --user start $Unit" | Out-Null
        Say "Tour du gardien (Ollama + modele prechauffe s'il n'y a pas de jeu)..."
        & powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $WdDir "anw-watchdog.ps1") -Verbose 2>&1 | ForEach-Object { Say $_ }
        State
    }
    "stop" {
        New-Item -ItemType File -Path $PauseFile -Force | Out-Null
        Say "Gardien mis en pause (sinon il rallume tout dans 2 min). [1] Allumer ou ANW.bat start le reactive."
        $ps = Http "/api/ps"
        if ($ps) {
            try {
                foreach ($m in (($ps | ConvertFrom-Json).models)) {
                    Invoke-WebRequest -Uri "http://127.0.0.1:11434/api/generate" -Method Post -Body ('{"model":"' + $m.name + '","keep_alive":0}') -ContentType "application/json" -UseBasicParsing -TimeoutSec 60 | Out-Null
                    Say ("VRAM rendue : " + $m.name)
                }
            } catch {}
        }
        Say "Arret de la gateway ANW..."; Wsl "systemctl --user stop $Unit" | Out-Null
        Say "Ollama reste allume (il sert a d'autres choses). NeverGiveUp n'est pas touche."
        State
    }
    "restart" {
        Say "Redemarrage de la gateway ANW..."; Wsl "systemctl --user restart $Unit" | Out-Null; Start-Sleep -Seconds 8
        State
        Say "Rappel : tape /reset dans #anw pour une session neuve (le prompt est fige par session)."
    }
    "log" {
        Say "Gardien (20 dernieres lignes) :"
        if (Test-Path (Join-Path $WdDir "anw-watchdog.log")) { Get-Content (Join-Path $WdDir "anw-watchdog.log") -Tail 20 | ForEach-Object { Say $_ } }
        Say ""; Say "Erreurs / avertissements recents du bot (agent.log) :"; Lines (Wsl "grep -E 'ERROR|WARNING' $Prof/logs/agent.log | tail -n 10 | cut -c1-170")
    }
    "pause" { New-Item -ItemType File -Path $PauseFile -Force | Out-Null; Say "Gardien en pause."; State }
    "resume" { Remove-Item $PauseFile -ErrorAction SilentlyContinue; Say "Gardien reactive."; State }
    "ask" {
        if (-not $Arg -or -not (Test-Path $Arg)) { Say "ask : fichier question manquant"; exit 2 }
        $wslPath = "/mnt/" + $Arg.Substring(0, 1).ToLower() + "/" + ($Arg.Substring(3) -replace "\\", "/")
        & wsl.exe -d $Distro -u YOU -- /bin/bash "$Skill/anw-ask.sh" $wslPath 2>&1 | ForEach-Object { Say (($_ | Out-String).TrimEnd()) }
    }
    default { Say "action inconnue : $Action (state|status|start|stop|restart|log|pause|resume|ask <fichier>)"; exit 2 }
}
