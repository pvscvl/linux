
$WebClient = New-Object System.Net.WebClient
Write-Host "Aktuellstes Firefox Setup wird geladen..."
$WebClient.DownloadFile("https://download.mozilla.org/?product=firefox-latest&os=win64&lang=de",".\setups\firefox.exe")
Write-Host "Aktuellstes Firefox Setup wurde geladen..."
Write-Host "Starte Firefox Installation"

Start-Process -FilePath ./Firefox.exe -Args "/silent" -Verb RunAs -Wait
