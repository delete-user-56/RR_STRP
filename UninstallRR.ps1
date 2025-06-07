# Script de nettoyage complet - supprime CLRCache + cle registre OfficeUpdater

# Couleurs pour debug visuel
function Write-Info($msg)   { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Success($msg){ Write-Host "[OK]   $msg" -ForegroundColor Green }
function Write-Warning($msg){ Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-ErrorMsg($msg){ Write-Host "[ERR]  $msg" -ForegroundColor Red }

try {
    Write-Info "Debut du nettoyage..."

    $AppData = $env:APPDATA
    $CLRCachePath = Join-Path $AppData "Microsoft\CLRCache"
    $RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    $RegName = "OfficeUpdater"

    # Suppression dossier CLRCache
    if (Test-Path $CLRCachePath) {
        Write-Info "Suppression du dossier CLRCache : $CLRCachePath"
        Remove-Item -Path $CLRCachePath -Recurse -Force -ErrorAction Stop
        Write-Success "Dossier CLRCache supprime."
    } else {
        Write-Warning "Dossier CLRCache non trouve, rien a supprimer."
    }

    # Nettoyer fichier player.vbs s'il reste ailleurs
    $VbsCandidates = @(
        Join-Path $CLRCachePath "player.vbs"
        Join-Path $AppData "Microsoft\Windows\Start Menu\Programs\Startup\OfficeUpdate.vbs"
    )
    foreach ($file in $VbsCandidates) {
        if (Test-Path $file) {
            Write-Info "Suppression du fichier VBS : $file"
            Remove-Item $file -Force -ErrorAction Stop
            Write-Success "Fichier $file supprime."
        } else {
            Write-Info "Fichier VBS $file non trouve."
        }
    }

    # Suppression cle registre OfficeUpdater
    if (Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction SilentlyContinue) {
        Write-Info "Suppression de la cle de registre : $RegName"
        Remove-ItemProperty -Path $RegPath -Name $RegName -ErrorAction Stop
        Write-Success "Cle de registre supprimee."
    } else {
        Write-Warning "Cle de registre $RegName non trouvee."
    }

    Write-Success "Nettoyage termine avec succes !"
} catch {
    Write-ErrorMsg "Erreur durant le nettoyage : $_"
}

Write-Host ""
Write-Host "Appuie sur Entree pour terminer..."
[void][System.Console]::ReadLine()
