# Relance Ollama (Windows) avec les variables OLLAMA* du registre User, puis prechauffe le modele d'ANW.
# Pourquoi : "ollama ps" / "ollama list" relancent "ollama app.exe" avec l'env du PROCESS APPELANT
# (Claude Code porte OLLAMA_KV_CACHE_TYPE=q8_0 / OLLAMA_KEEP_ALIVE=30m perimes) ; ce script recopie le
# registre (q4_0 / -1) dans son propre env avant de lancer, puis prouve l'env charge via server.log.
# Usage : powershell -NoProfile -ExecutionPolicy Bypass -File ollama-restart-anw.ps1 [-NoPreheat] [-Model <tag>] [-Force]
#   -Model     : par defaut LU dans profiles/anw/config.yaml (model.default). Ne jamais coder un tag en dur :
#                "anw-v2" a disparu le 06/09 et le prechauffage visait un tag inexistant.
#   -NoPreheat : ne charge aucun modele (Ollama up, VRAM libre)
#   -Force     : passe outre "un modele est charge" et "VRAM occupee (jeu ?)"
param([switch]$NoPreheat, [string]$Model = "", [switch]$Force)

if (-not $Model) {
    $cfg = "/home/YOU/.hermes/profiles/anw/config.yaml"
    $m = (wsl.exe -u YOU -- sed -n 's/^  default: //p' $cfg 2>$null | Select-Object -First 1)
    if ($m) { $m = $m.Trim() }
    if ($m -and $m -match '^[A-Za-z0-9._:/-]+$') { $Model = $m } else { $Model = "anw-38" }
    Write-Output "modele lu dans config.yaml : $Model"
}

$app = "$env:LOCALAPPDATA\Programs\Ollama\ollama app.exe"
if (-not (Test-Path $app)) { Write-Output "introuvable : $app"; exit 1 }

$loaded = $null
try { $loaded = (Invoke-WebRequest -Uri "http://127.0.0.1:11434/api/ps" -UseBasicParsing -TimeoutSec 3).Content } catch {}
if ($loaded -and $loaded -notmatch '"models":\[\]' -and -not $Force) {
    Write-Output "un modele est charge (requete en vol ?) : $loaded"
    Write-Output "relancer quand api/ps est vide, ou -Force"
    exit 1
}

$gpu = & nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader 2>$null
Write-Output "VRAM avant : $gpu"
$usedMiB = 0
if ($gpu -match '^\s*(\d+)') { $usedMiB = [int]$Matches[1] }

Get-Process -Name "ollama app","ollama","llama-server" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 3
$left = Get-Process -Name "ollama app","ollama","llama-server" -ErrorAction SilentlyContinue
if ($left) { Write-Output "encore vivants :"; $left | Select-Object Id,ProcessName; exit 1 }

[Environment]::GetEnvironmentVariables("User").GetEnumerator() |
    Where-Object { $_.Key -like "OLLAMA*" } |
    ForEach-Object { [Environment]::SetEnvironmentVariable($_.Key, $_.Value, "Process") }
Start-Process -FilePath $app -WindowStyle Hidden

$ok = $false
foreach ($i in 1..40) {
    Start-Sleep -Seconds 1
    try { $r = Invoke-WebRequest -Uri "http://127.0.0.1:11434/api/version" -UseBasicParsing -TimeoutSec 2; $ok = $true; break } catch {}
}
if (-not $ok) { Write-Output "Ollama ne repond pas apres 40 s"; exit 1 }
Write-Output "Ollama up : $($r.Content)"

Start-Sleep -Seconds 2
$line = (Get-Content "$env:LOCALAPPDATA\Ollama\server.log" | Select-String -Pattern "server config" | Select-Object -Last 1).Line
Write-Output "env charge par le serveur :"
[regex]::Matches($line, "OLLAMA_(KV_CACHE_TYPE|KEEP_ALIVE|FLASH_ATTENTION|NUM_PARALLEL|CONTEXT_LENGTH):[^ \]]+") | ForEach-Object { "  " + $_.Value }

if ($NoPreheat) { Write-Output "pas de prechauffe (-NoPreheat)"; exit 0 }
if ($usedMiB -gt 6000 -and -not $Force) {
    Write-Output "VRAM deja occupee ($usedMiB MiB : un jeu ?) : pas de prechauffe. -Force pour passer outre."
    exit 0
}
$sw = [Diagnostics.Stopwatch]::StartNew()
$body = '{"model":"' + $Model + '","prompt":"ok","stream":false,"options":{"num_predict":1}}'
Invoke-WebRequest -Uri "http://127.0.0.1:11434/api/generate" -Method Post -Body $body -ContentType "application/json" -UseBasicParsing -TimeoutSec 300 | Out-Null
Write-Output ("{0} charge en {1:N1} s" -f $Model, $sw.Elapsed.TotalSeconds)
(Invoke-WebRequest -Uri "http://127.0.0.1:11434/api/ps" -UseBasicParsing -TimeoutSec 5).Content
Write-Output ("VRAM apres : " + (& nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader 2>$null))
