
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://download.mozilla.org/?product=firefox-latest&os=win64&lang=de","C:\_tmp\firefox.exe")