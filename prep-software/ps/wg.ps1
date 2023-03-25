
$WebClient = New-Object System.Net.WebClient
Write-Host "WatchGuard System Manager 12.9 Update 1 wird geladen."
$WebClient.DownloadFile("https://cdn.watchguard.com/SoftwareCenter/Files/WSM/12_9_U1/wsm_12_9_U1.exe")
Write-Host "WatchGuard System Manager 12.9 Update 1 wurde geladen."
Write-Host "Starte WatchGuard System Manager 12.9 Update 1 Installation"
Start-Process -FilePath ./wsm_12_9.exe -Args "/SILENT" -Verb RunAs -Wait
