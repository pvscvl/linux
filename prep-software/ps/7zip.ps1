Write-Host "#### 7zip"
$dlurl = 'https://7-zip.org/' + (Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' | Select-Object -ExpandProperty Links | Where-Object {($_.outerHTML -match 'Download')-and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe")} | Select-Object -First 1 | Select-Object -ExpandProperty href)
# modified to work without IE
# above code from: https://perplexity.nl/windows-powershell/installing-or-updating-7-zip-using-powershell/
#$installerPath = Join-Path $env:TEMP (Split-Path $dlurl -Leaf)
$installerPath = Join-Path C:\prep (Split-Path $dlurl -Leaf)
Write-Host "Downloading latest 7zip Setup (x64)"
Invoke-WebRequest $dlurl -OutFile $installerPath
Write-Host "Download of 7zip Setup complete"
#Start-Process -FilePath $installerPath -Args "/S" -Verb RunAs -Wait
#Remove-Item $installerPath


Write-Host "#### 7zip"
Write-Host "Downloading latest 7zip Setup (x64)"

Write-Host "Download of 7zip Setup complete"