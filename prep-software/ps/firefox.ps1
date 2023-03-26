Write-Host "#### Firefox"
$jsonUrl = 'https://product-details.mozilla.org/1.0/firefox_versions.json'
$webClient = New-Object System.Net.WebClient
$jsonContent = $webClient.DownloadString($jsonUrl)
$jsonObject = ConvertFrom-Json $jsonContent
$latestVersion = $jsonObject.LATEST_FIREFOX_VERSION
Write-Host "Downloading latest Firefox Setup ($latestVersion)"
$WebClient.DownloadFile("https://download.mozilla.org/?product=firefox-latest&os=win64&lang=de","C:\prep\firefox_x64_DE_$latestversion.exe")
Write-Host "Download of Firefox $latestVersion Setup complete"
#Start-Process -FilePath ./Firefox.exe -Args "/silent" -Verb RunAs -Wait
