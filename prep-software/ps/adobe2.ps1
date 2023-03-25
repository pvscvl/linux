
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
#filter out non version folder names
if ($endtoken -match "[0-9]") {
$folders += $endtoken
}
}


$currentfolder = ($folders | sort -Descending | select -First 1).trim()


# PowerShell Wrapper for MDT, Standalone and Chocolatey Installation - (C)2015 xenappblog.com
# Example 1: Start-Process "XenDesktopServerSetup.exe" -ArgumentList $unattendedArgs -Wait -Passthru
# Example 2 Powershell: Start-Process powershell.exe -ExecutionPolicy bypass -file $Destination
# Example 3 EXE (Always use ' '):
# $UnattendedArgs='/qn'
# (Start-Process "$PackageName.$InstallerType" $UnattendedArgs -Wait -Passthru).ExitCode
# Example 4 MSI (Always use " "):
# $UnattendedArgs = "/i $PackageName.$InstallerType ALLUSERS=1 /qn /liewa $LogApp"
# (Start-Process msiexec.exe -ArgumentList $UnattendedArgs -Wait -Passthru).ExitCode

#Clear-Host
Write-Verbose "Setting Arguments" -Verbose
$StartDTM = (Get-Date)

$Vendor = "Adobe"
$Product = "Reader DC"
$PackageName = "AcroRdrDC"
$Version = "$currentfolder"
$InstallerType = "exe"
#$Source = "$PackageName" + "." + "$InstallerType"
$Source = "$PackageName" + "_" + "$Version" + "_de_DE" + "." + "$InstallerType"
$LogPS = "${env:SystemRoot}" + "\Temp\$Vendor $Product $Version PS Wrapper.log"
$LogApp = "${env:SystemRoot}" + "\Temp\$PackageName.log"
$Destination = "${env:ChocoRepository}" + "\$Vendor\$Product\$Version\$packageName.$installerType"
$UnattendedArgs = '/sAll /msi /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES'
$ProgressPreference = 'Continue'
#$ProgressPreference = 'SilentlyContinue'
# wenn keine Anzeige des Fortschritts erfolgen soll > $ProgressPreference = 'SilentlyContinue'
#Start-Transcript $LogPS | Out-Null

#Write-Verbose "Checking Internet Connection" -Verbose

#If (!(Test-Connection -ComputerName www.google.com -Count 1 -quiet)) {
#Write-Verbose "Internet Connection is Down" -Verbose
#}
#Else {
#Write-Verbose "Internet Connection is Up" -Verbose
#}

#Write-Verbose "Writing Version Number to File" -Verbose
#if (!$Version) {
#$Version = Get-Content -Path ".\Version.txt"
#}
#Else {
#$Version | Out-File -FilePath ".\Version.txt" -Force
#}

#if( -Not (Test-Path -Path $Version ) )
#{
#New-Item -ItemType directory -Path $Version | Out-Null
#$Version | Out-File -FilePath ".\Version.txt" -Force
#}

#CD $Version

If (!(Test-Path -Path $Source)) {
Write-Verbose "Downloading $Vendor $Product $Version" -Verbose
$EXEDownload = "$($ftp)$($currentfolder)`/AcroRdrDC$($currentfolder)_de_DE.exe"
#$EXEDownload = "$($ftp)$($currentfolder)`/AcroRdrDC$($Version)_de_DE.exe"
$filename = ($EXEDownload.split("/"))[-1]
#$filename = ($EXEDownload.split("/"))

wget -uri $EXEDownload -outfile $Source
}
Else {
Write-Verbose "File Exists. Skipping Download." -Verbose
}


#Write-Verbose "Before install Line" -Verbose
#Start-Process -FilePath .\AcroRdrDC.exe -Args "/sAll /rs /msi EULA_ACCEPT=YES"
#Write-Verbose "After install line" -Verbose