# Proxy de statusline caveman.
# Le hook livre par le plugin vit sous ...\plugins\cache\caveman\caveman\<sha-du-commit>\hooks\,
# donc pointer settings.json dessus en dur casse la statusline en silence a chaque
# mise a jour du plugin (nouveau dossier = nouveau sha). On resout la version au vol.
$ErrorActionPreference = 'SilentlyContinue'

$ClaudeDir = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HOME '.claude' }
$Root = Join-Path $ClaudeDir 'plugins\cache\caveman\caveman'
if (-not (Test-Path -LiteralPath $Root)) { exit 0 }

$Hook = Get-ChildItem -LiteralPath $Root -Directory |
    Sort-Object LastWriteTime -Descending |
    ForEach-Object { Join-Path $_.FullName 'hooks\caveman-statusline.ps1' } |
    Where-Object { Test-Path -LiteralPath $_ } |
    Select-Object -First 1

if (-not $Hook) { exit 0 }
& $Hook
