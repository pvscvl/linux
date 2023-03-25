@echo off
:: requires Administrator privileges.
call :isAdmin
if %errorlevel% == 0 (
  goto :run
) else if "%1" == "admin_session" (
  goto :run
) else if %errorlevel% == 1 (
  goto :UACPrompt
) else (
  echo "Could not get administrative privileges"
  pause
  exit /b
)

:isAdmin
  fsutil dirty query %systemdrive% >nul 2>&1
  exit /b

:run


:UACPrompt
powershell "New-Item -ItemType Directory -Force -Path .\setups"
powershell -NonInteractive -Command 'date'
pause
powershell -ExecutionPolicy Bypass -f .\ps\npp.ps1
powershell -NonInteractive -Command 'date'
pause
powershell -ExecutionPolicy Bypass -f .\ps\firefox.ps1
powershell -NonInteractive -Command 'date'
pause
powershell -ExecutionPolicy Bypass -f .\ps\winscp.ps1
powershell -NonInteractive -Command 'date'
pause
powershell -ExecutionPolicy Bypass -f .\ps\7zip.ps1
powershell -NonInteractive -Command 'date'
pause
powershell -ExecutionPolicy Bypass -f .\ps\vsc.ps1
powershell -NonInteractive -Command 'date'
powershell -ExecutionPolicy Bypass -f .\ps\adobe.ps1
powershell -NonInteractive -Command 'date'
pause
powershell -NonInteractive -Command 'Start-Process -FilePath $scriptfolder\setups\AcroRdrDC.exe -Args "/sAll /rs /msi EULA_ACCEPT=YES"'
powershell -NonInteractive -Command 'date'
pause

pause
exit /b

