$url = "https://www.citrix.com/downloads/workspace-app/windows/workspace-app-for-windows-latest.html"
$versionFilePath = "C:\citrix\citrix-version.txt"

# Get the previous version number from the version file
$previousVersion = Get-Content $versionFilePath
Write-Host "Current version number: $previousVersion"

# Create a new WebClient object
$webClient = New-Object System.Net.WebClient

# Get the current version number
$html = $webClient.DownloadString($url)
$title = [regex]::Match($html, "<title>(.*?)</title>").Groups[1].Value
$currentVersion = [regex]::Match($title, "\d+").Value

# Check if the current version is greater than the previous version
if ($currentVersion -gt $previousVersion) {
    # Update the version file with the new version number
    Set-Content -Path $versionFilePath -Value $currentVersion
    Write-Host "Version number has been updated to: $currentVersion"
}
else {
    Write-Host "No update available."
}