Write-Host "#### WinSCP"
Write-Host "Downloading latest WinSCP Setup"
Invoke-WebRequest -UserAgent "Wget" -Uri https://sourceforge.net/projects/winscp/files/latest/download -OutFile C:\prep\WINSCP-Latest.exe
Write-Host "Download of WinSCP Setup complete"