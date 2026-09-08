# init-shop.ps1 v2 - active une COPIE du squelette _newshop en vraie boutique.
#
# ASCII PUR (Windows PowerShell 5.1 lit les .ps1 en ANSI : un caractere accentue
# casse le parsing en silence). Ne jamais ajouter d'accent dans ce fichier.
#
#   powershell -NoProfile -File scripts/init-shop.ps1 -Name "Nom" -Niche "english niche" -Currency EUR
#   ... -NicheFr "niche en francais" -Handle abcd12-xy -App NOM-API -Folder nom -DryRun
#
# Fait, dans l'ordre :
#   1. COPIE le squelette -> dossier cible   5. banner d'identite stampe dans CLAUDE.md
#   2. remplace les placeholders             6. dossier memoire projet + MEMORY.md
#   3. ligne dans shops-registry.md          7. README-INIT.md -> README-INIT.done.md
#   4. shops-registry-sync.ps1
#
# CE QUI A CHANGE EN v2 (bugs payes le 2026-07-24, boutique SHOP-C) :
#   a) COPIE au lieu de renommer. v1 faisait Move-Item : le squelette etait CONSOMME,
#      plus rien pour la boutique suivante. La copie supprime aussi la relance depuis
#      %TEMP% (le dossier n'est plus verrouille) - donc plus aucun saut de processus,
#      donc plus aucun risque d'argument abime en route.
#   b) Le nom ecrit dans le REGISTRE est ASCII-folde. Le miroir .json est genere par
#      shops-registry-sync.ps1 qui ecrit en ASCII : un "E accent" y devenait "??",
#      et ce "??" repartait dans le banner stampe. Les fichiers du dossier, eux,
#      gardent le nom accentue ($Name). scripts/lib/shop.js compare les deux sans
#      accents ni casse (fold()), donc assertShop() ne se declenche pas a tort.
#   c) Les .ps1 sont EXCLUS de la substitution : v1 se remplacait elle-meme et
#      detruisait sa propre table de placeholders ('__SHOP_NAME__' devenait le nom).
#   d) Dump des codepoints non-ASCII de -Name au demarrage : un accent abime par le
#      shell appelant se voit AVANT d'ecrire quoi que ce soit.
#      (Piege connu : PowerShell est CASE-INSENSITIVE sur les variables, donc
#       $E et $e sont la MEME variable. Construire des accents par code point
#       avec deux variables qui ne different que par la casse = collision.)
param(
  [Parameter(Mandatory=$true)][string]$Name,
  [Parameter(Mandatory=$true)][string]$Niche,
  [string]$NicheFr = '',
  [string]$Currency = 'EUR',
  [string]$Handle = '',
  [string]$App = '',
  [string]$Folder = '',
  [string]$Source = '',
  [switch]$DryRun
)
$ErrorActionPreference = 'Stop'
$UTF8 = New-Object System.Text.UTF8Encoding($false)
function RT([string]$p) { [System.IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8) }
function WT([string]$p, [string]$s) { [System.IO.File]::WriteAllText($p, $s, $UTF8) }
function Say([string]$m) { Write-Host $m }

# --- source du squelette ---
if (-not $Source) { $Source = (Resolve-Path (Join-Path (Split-Path -Parent $PSCommandPath) '..')).Path }
if (-not (Test-Path -LiteralPath (Join-Path $Source 'CLAUDE.md'))) { Write-Error "source invalide (pas de CLAUDE.md): $Source"; exit 1 }

# --- normalisation ---
function StripMarks([string]$s) {
  $n = $s.Normalize([Text.NormalizationForm]::FormD)
  $sb = New-Object Text.StringBuilder
  foreach ($c in $n.ToCharArray()) { if ([Globalization.CharUnicodeInfo]::GetUnicodeCategory($c) -ne 'NonSpacingMark') { [void]$sb.Append($c) } }
  return $sb.ToString()
}
function Slugify([string]$s) {
  $out = (StripMarks $s).ToLower() -replace '[^a-z0-9]+','-'
  return $out.Trim('-')
}
# Nom pour le registre + les hooks : ASCII pur, apostrophes droites, sans accents.
# Les caracteres de ponctuation typographique sont construits PAR CODE POINT :
# ecrire un guillemet courbe en dur remettrait des octets non-ASCII dans ce .ps1.
function AsciiFold([string]$s) {
  $txt = StripMarks $s
  $quoteSingle = [string][char]0x2018 + [string][char]0x2019 + [string][char]0x201B
  $quoteDouble = [string][char]0x201C + [string][char]0x201D
  $dashLong    = [string][char]0x2013 + [string][char]0x2014
  foreach ($ch in $quoteSingle.ToCharArray()) { $txt = $txt.Replace([string]$ch, "'") }
  foreach ($ch in $quoteDouble.ToCharArray()) { $txt = $txt.Replace([string]$ch, '"') }
  foreach ($ch in $dashLong.ToCharArray())    { $txt = $txt.Replace([string]$ch, '-') }
  $txt = $txt.Replace([string][char]0x00A0, ' ')
  return ($txt -replace '[^\x20-\x7E]', '?')
}

$slug = Slugify $Name
if (-not $slug) { Write-Error "nom invalide (slug vide): $Name"; exit 1 }
if (-not $Folder) { $Folder = $slug }
$Folder = Slugify $Folder
if (-not $NicheFr) { $NicheFr = $Niche }
if (-not $App) { $App = ($slug.ToUpper() + '-API') }

$NameAscii = AsciiFold $Name
if ($NameAscii.Contains('?')) { Write-Error "le nom contient un caractere non convertible en ASCII : '$NameAscii'. Choisis un nom que le registre peut porter."; exit 1 }

$parent    = Split-Path -Parent $Source
$target    = Join-Path $parent $Folder
$rootLower = ($target -replace '\\','/').ToLower().TrimEnd('/')
$targetFwd = ($target -replace '\\','/')
$domain    = if ($Handle) { "$Handle.myshopify.com" } else { '<TODO>.myshopify.com' }
$handleOut = if ($Handle) { $Handle } else { '<TODO>' }
$regMd     = Join-Path $env:USERPROFILE '.claude/shops-registry.md'
$hookDir   = Join-Path $env:USERPROFILE '.claude/scripts'
$memDir    = Join-Path $env:USERPROFILE ('.claude/projects/' + (($target -replace '[:\\/]','-')) + '/memory')

# --- preuve que -Name est arrive intact (d) ---
$cps = @()
foreach ($c in $Name.ToCharArray()) { if ([int]$c -gt 127) { $cps += ('U+' + ('{0:X4}' -f [int]$c) + ' ' + $c) } }

Say ""
Say "=== INIT BOUTIQUE (v2 : le squelette est COPIE, pas consomme) ==="
Say ("  nom (fichiers) : " + $Name)
Say ("  nom (registre) : " + $NameAscii)
if ($cps.Count) { Say ("  accents recus  : " + ($cps -join ', ')) } else { Say "  accents recus  : aucun (nom ASCII)" }
Say ("  slug           : " + $slug)
Say ("  source         : " + $Source)
Say ("  dossier cible  : " + $target)
Say ("  niche          : " + $Niche + "  (fr: " + $NicheFr + ")")
Say ("  devise         : " + $Currency)
Say ("  handle         : " + $handleOut + "   domaine: " + $domain)
Say ("  app            : " + $App)
Say ("  memoire        : " + $memDir)
Say ""
Say "  >> Verifie la ligne 'accents recus' AVANT de continuer : un accent abime ici"
Say "     se retrouverait dans les 35 fichiers du dossier."
Say ""

# --- garde-fous AVANT toute ecriture ---
if (Test-Path -LiteralPath $target) { Write-Error "le dossier cible existe deja: $target"; exit 1 }
if (-not (Test-Path -LiteralPath $regMd)) { Write-Error "registre introuvable: $regMd"; exit 1 }
$regText = RT $regMd
$regLower = $regText.ToLower()
if ($regLower -match ('(?m)^\|\s*' + [regex]::Escape($NameAscii.ToLower()) + '\s*\|')) { Write-Error "une ligne de registre porte deja le nom '$NameAscii'"; exit 1 }
if ($regLower.Contains('| ' + $rootLower + ' |')) { Write-Error "folder_root deja dans le registre: $rootLower"; exit 1 }
if ($Handle -and $regLower.Contains('| ' + $Handle.ToLower() + ' |')) { Write-Error "store_handle deja dans le registre: $Handle"; exit 1 }

if ($DryRun) { Say "DRY-RUN : rien n'est ecrit. Relance sans -DryRun pour appliquer."; exit 0 }

# --- 1. copier le squelette ---
Copy-Item -LiteralPath $Source -Destination $target -Recurse
# jamais de secret ni de trace d'une autre boutique dans une copie fraiche
foreach ($junk in @('.secrets\access-token.txt', '.secrets\app-credentials.txt', 'README-INIT.done.md')) {
  $j = Join-Path $target $junk
  if (Test-Path -LiteralPath $j) { Remove-Item -LiteralPath $j -Force }
}
$nodeMods = Join-Path $target 'node_modules'
if (Test-Path -LiteralPath $nodeMods) { Remove-Item -LiteralPath $nodeMods -Recurse -Force }
Say "1/7 squelette copie -> $target   (source intacte : $Source)"

# --- 2. remplacer les placeholders ---
# ORDRE = du plus specifique au plus general (sinon __SHOP_SLUG__ mange les chemins).
$map = @(
  @('__FOLDER_WIN_FWD__', $targetFwd),
  @('__FOLDER_WIN__',     $target),
  @('__FOLDER_ROOT__',    $rootLower),
  @('__SHOP_UPPER__',     $Name.ToUpper()),
  @('__SHOP_NAME_ASCII__',$NameAscii),
  @('__SHOP_NAME__',      $Name),
  @('__NICHE_FR__',       $NicheFr),
  @('__NICHE__',          $Niche),
  @('__CURRENCY__',       $Currency),
  @('__DOMAIN__',         $domain),
  @('__HANDLE__',         $handleOut),
  @('__APP_NAME__',       $App),
  @('__SHOP_SLUG__',      $Folder)
)
# (c) .ps1 volontairement absent : ce script ne doit pas se substituer lui-meme.
$exts = @('.md','.js','.sh','.json','.txt','.liquid','.py')
$touched = 0
Get-ChildItem -LiteralPath $target -Recurse -File | Where-Object { $exts -contains $_.Extension.ToLower() } | ForEach-Object {
  $t = RT $_.FullName
  $o = $t
  foreach ($pair in $map) { $t = $t.Replace($pair[0], $pair[1]) }
  if ($t -ne $o) { WT $_.FullName $t; $touched++ }
}
Say ("2/7 placeholders remplaces dans " + $touched + " fichier(s)")

$leftover = @()
Get-ChildItem -LiteralPath $target -Recurse -File | Where-Object { $exts -contains $_.Extension.ToLower() } | ForEach-Object {
  if ((RT $_.FullName) -match '__[A-Z_]+__') { $leftover += $_.FullName }
}
if ($leftover.Count) { Say ("    WARN placeholders restants dans : " + ($leftover -join ', ')) }

# --- 3. ligne de registre (nom ASCII : le miroir .json et les hooks sont ASCII) ---
$row = '| ' + (@(
  $NameAscii, $rootLower, $handleOut, $domain, $Currency, $Niche,
  ($target + '\.secrets\access-token.txt').Replace('\','/'),
  ($target + '\.secrets\app-credentials.txt').Replace('\','/'),
  $App, 'read-write-gated', 'setup'
) -join ' | ') + ' |'
$nl = if ($regText -match "`r`n") { "`r`n" } else { "`n" }
$lines = $regText -split "`r?`n"
$last = -1
for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i].TrimStart().StartsWith('|')) { $last = $i } }
if ($last -lt 0) { Write-Error "table du registre introuvable dans $regMd"; exit 1 }
$new = @()
$new += $lines[0..$last]
$new += $row
if ($last + 1 -le $lines.Count - 1) { $new += $lines[($last+1)..($lines.Count-1)] }
WT $regMd (($new -join $nl))
Say "3/7 ligne ajoutee dans shops-registry.md (nom ASCII : $NameAscii)"

# --- 4. sync du .json lu par les hooks ---
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $hookDir 'shops-registry-sync.ps1')
if ($LASTEXITCODE -ne 0) { Write-Error "shops-registry-sync.ps1 a echoue (invariant casse ?) - corrige la table avant de continuer"; exit 1 }
Say "4/7 shops-registry.json regenere"

# --- 5. banner d'identite dans CLAUDE.md ---
$banner = (& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $hookDir 'shops-banner.ps1') -Folder $target) -join "`n"
if (-not $banner) { Write-Error "shops-banner.ps1 n'a rien renvoye"; exit 1 }
if ($banner.Contains('??')) { Write-Error "le banner contient '??' : un caractere non-ASCII a fuite dans le registre. Corrige la ligne avant de continuer."; exit 1 }
$cmPath = Join-Path $target 'CLAUDE.md'
$cm = RT $cmPath
$pattern = '(?s)<!-- BANNER:START.*?-->.*?<!-- BANNER:END -->'
$block = "<!-- BANNER:START - genere par ~/.claude/scripts/shops-banner.ps1, ne pas editer a la main. -->`n" + $banner + "`n<!-- BANNER:END -->"
if ($cm -match $pattern) { $cm = [regex]::Replace($cm, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $block }) }
else { $cm = $block + "`n`n" + $cm }
WT $cmPath $cm
Say "5/7 banner stampe dans CLAUDE.md"

# --- 6. memoire projet ---
New-Item -ItemType Directory -Force -Path $memDir | Out-Null
$memIndex = Join-Path $memDir 'MEMORY.md'
if (-not (Test-Path -LiteralPath $memIndex)) {
  $memBody = @(
    ('# MEMORY - ' + $Name + ' (' + $Niche + ')'),
    '',
    'Index des memoires projet : une ligne par memoire, format',
    '    - [Titre](fichier.md) - hook',
    '',
    'Une memoire = un fait. Types : user / feedback / project / reference.',
    'Jamais de contenu ici, seulement l index.',
    ''
  ) -join "`n"
  WT $memIndex $memBody
}
Say ("6/7 memoire projet prete : " + $memIndex)

# --- 7. trace ---
$ri = Join-Path $target 'README-INIT.md'
if (Test-Path -LiteralPath $ri) {
  $done = Join-Path $target 'README-INIT.done.md'
  $txt = RT $ri
  $stamp = "> INIT EXECUTE le " + (Get-Date -Format 'yyyy-MM-dd HH:mm') + " : dossier=" + $target + " | handle=" + $handleOut + " | app=" + $App + " | nom registre=" + $NameAscii + " | ligne de registre + banner + memoire poses.`n`n"
  WT $done ($stamp + $txt)
  Remove-Item -LiteralPath $ri -Force
}
# le script d'init n'a plus rien a faire dans une boutique activee
$selfCopy = Join-Path $target 'scripts\init-shop.ps1'
if (Test-Path -LiteralPath $selfCopy) { Remove-Item -LiteralPath $selfCopy -Force }
Say "7/7 README-INIT.md -> README-INIT.done.md  (+ init-shop.ps1 retire de la copie)"

Say ""
Say "=== FAIT. Suite (dans l'ordre) ==="
Say "  1. Creer la boutique Shopify + l'app custom ($App) -> CLIENT_ID / CLIENT_SECRET"
Say ("  2. cp .secrets/app-credentials.txt.example .secrets/app-credentials.txt  puis remplir SHOP/CLIENT_ID/CLIENT_SECRET")
Say "  3. bash scripts/get-token.sh"
Say "  4. node scripts/shop-probe.js        (preuve live d'identite)"
if (-not $Handle) { Say "  5. Renseigner le handle reel dans la ligne du registre PUIS re-run shops-registry-sync.ps1 + shops-banner.ps1" }
Say "  6. Suivre docs/LAUNCH-CHECKLIST.md"
Say ""
Say "  Le squelette $Source est INTACT - prochaine boutique = re-run ce script."
Say ""
