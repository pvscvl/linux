Invoke-WebRequest -UserAgent "Wget" -Uri https://sourceforge.net/projects/winscp/files/latest/download -OutFile .\setups\WinSCP-Latest.exe
Start-Process -FilePath ./setups/WinSCP-Latest.exe -Args "/SP /VERYSILENT /NORESTART" -Verb RunAs -Wait
