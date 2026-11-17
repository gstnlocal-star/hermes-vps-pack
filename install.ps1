# Installation Hermes sur le VPS depuis le disque partage \\tsclient\C
$ErrorActionPreference = "Stop"
$src = "\\tsclient\C\Users\googl\hermes-vps"
$hh  = Join-Path $env:LOCALAPPDATA "hermes"

Write-Output "== source =$src"
Write-Output "== cible  =$hh"
if (-not (Test-Path $src)) { Write-Output "ERREUR: source inaccessible (partage de lecteur absent)"; exit 1 }

New-Item -ItemType Directory -Force -Path $hh | Out-Null
Copy-Item "$src\SOUL.md" $hh -Force
foreach ($d in @("skills","memories")) {
  if (Test-Path "$src\$d") {
    Copy-Item "$src\$d" $hh -Recurse -Force
  }
}
$envFile = Join-Path $hh ".env"
if (-not (Test-Path $envFile)) { Copy-Item "$src\.env.base" $envFile -Force }

# modele / provider
$env:HERMES_HOME = $hh
Write-Output "== fichiers copies"
Get-ChildItem $hh | Select-Object -First 20 Name | ForEach-Object { $_.Name }
