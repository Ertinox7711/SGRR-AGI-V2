# Récupère l'IP WSL et met à jour ANTHROPIC_BASE_URL dans settings.json de Claude Code
$wslIp = (wsl -d Ubuntu-22.04 -u YOU -- bash -c "hostname -I" | Select-Object -First 1).Trim().Split(' ')[0]
Write-Output "WSL IP: $wslIp"
$settingsPath = "$env:USERPROFILE\.claude\settings.json"
$json = Get-Content $settingsPath -Raw | ConvertFrom-Json
$json.env.ANTHROPIC_BASE_URL = "http://$wslIp`:11434"
$json | ConvertTo-Json -Depth 20 | Set-Content $settingsPath -Encoding UTF8
Write-Output "settings.json mis à jour: http://$wslIp`:11434"
