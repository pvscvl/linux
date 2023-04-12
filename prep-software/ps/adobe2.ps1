cd C:\prep
$ftp = "ftp://ftp.adobe.com/pub/adobe/reader/win/AcrobatDC/"
Write-Host "Downloading Adobe Acrobat Reader DC Deutsch"

$request = [System.Net.FtpWebRequest]::Create($ftp);
$request.Credentials = [System.Net.NetworkCredential]::new("anonymous", "password");
$request.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectoryDetails;
[System.Net.FtpWebResponse]$response = [System.Net.FtpWebResponse]$request.GetResponse();
[System.IO.Stream]$responseStream = $response.GetResponseStream();
[System.IO.StreamReader]$reader = [System.IO.StreamReader]::new($responseStream);
$DirList = $reader.ReadToEnd()
$reader.Close()
$response.close()

$DirByLine = $DirList.split("`n")

$folders = @()

foreach ($line in $DirByLine ) {
$endtoken = ($line.split(' '))[-1]
if ($endtoken -match "[0-9]") {
$folders += $endtoken
}
}

$currentfolder = ($folders | sort -Descending | select -First 1).trim()

Write-Verbose "Setting Arguments" -Verbose
$StartDTM = (Get-Date)

$Vendor = "Adobe"
$Product = "Reader DC"
$PackageName = "AcroRdrDC"
$Version = "$currentfolder"
$InstallerType = "exe"

$Source = "$PackageName" + "_" + "$Version" + "_de_DE" + "." + "$InstallerType"
$LogPS = "${env:SystemRoot}" + "\Temp\$Vendor $Product $Version PS Wrapper.log"
$LogApp = "${env:SystemRoot}" + "\Temp\$PackageName.log"
$Destination = "${env:ChocoRepository}" + "\$Vendor\$Product\$Version\$packageName.$installerType"
$UnattendedArgs = '/sAll /msi /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES'
$ProgressPreference = 'Continue'


If (!(Test-Path -Path $Source)) {
Write-Verbose "Downloading $Vendor $Product $Version" -Verbose
$EXEDownload = "$($ftp)$($currentfolder)`/AcroRdrDC$($currentfolder)_de_DE.exe"
$filename = ($EXEDownload.split("/"))[-1]

wget -uri $EXEDownload -outfile $Source
}
Else {
Write-Verbose "File Exists. Skipping Download." -Verbose
}


#Write-Verbose "Before install Line" -Verbose
#Start-Process -FilePath .\AcroRdrDC.exe -Args "/sAll /rs /msi EULA_ACCEPT=YES"
#Write-Verbose "After install line" -Verbose