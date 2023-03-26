$WebClient = New-Object System.Net.WebClient
Write-Host "WSM 12.9.2 wird geladen"
$WebClient.DownloadFile("https://cdn.watchguard.com/SoftwareCenter/Files/WSM/12_9_2/wsm_12_9_2.exe","C:\prep\wsm_12_9_2.exe")
Write-Host "WSM 12.9.2 wurde geladen"
#Start-Process -FilePath ./wsm_12_9.exe -Args "/SILENT" -Verb RunAs -Wait
 
