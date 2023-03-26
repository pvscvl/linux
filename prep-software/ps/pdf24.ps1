 Write-Host "#### PDF24 Creator"
 # Define the URL of the page containing the download links
$url = 'https://creator.pdf24.org/listVersions.php'

# Create a new HTTP client object
$client = New-Object System.Net.WebClient

# Download the HTML content of the page
$content = $client.DownloadString($url)

# Use regular expressions to extract the download link for the latest .msi file
$regex = '<a href="(.*?\.msi)"'
$link = [regex]::Matches($content, $regex)[0].Groups[1].Value

# Download the .msi file using the extracted link
$filename = Split-Path $link -Leaf
$file = "C:\prep\$filename"
Write-Host "Downloading: $link"
Write-Host "Download-Folder: $file"
$client.DownloadFile($link, $file)
Write-Host "Downloaded file: $file" 
