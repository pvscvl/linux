Write-Host "#### Watchguard System Manager"
$WebClient = New-Object System.Net.WebClient
Write-Host "Downloading latest Watchguard System Manager Setup"
$WebClient.DownloadFile("https://cdn.watchguard.com/SoftwareCenter/Files/WSM/12_9_2/wsm_12_9_2.exe","C:\prep\wsm_12_9_2.exe")
Write-Host "Download of Watchguard System Manager  Setup complete"
#Start-Process -FilePath ./wsm_12_9.exe -Args "/SILENT" -Verb RunAs -Wait
 
