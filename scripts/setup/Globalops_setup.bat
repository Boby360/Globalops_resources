REM Install:
REM add the folder exclusion to windows defender
REM download and install 3.5 (Between disable and enable real-time)
REM install rivatuner profile (C:\Program Files (x86)\RivaTuner Statistics Server\Profiles)

REM RUN:
REM run rivatuner
REM run high res timer (start "" "C:\PathToTool\TimerTool.exe" -t 0.5 -minimized)
REM alter globalops profile
REM run globalops with RunFirst?
REM
REM

@echo off

set globalopspath="0"
set drive="0"


if exist "C:\PROGRA~1\Crave\Global~1\globalops.exe" (
 set "globalopspath=C:\PROGRA~1\Crave\Global~1"
 )
if exist "C:\PROGRA~2\Crave\Global~1\globalops.exe" (
 set "globalopspath=C:\PROGRA~2\Crave\Global~1"
 )

if %globalopspath%=="0" (
echo Install was not found on C drive. What drive is globalops installed on
set /p "drive=Drive letter WITHOUT ":" infront:"
echo %drive%

if exist "%drive%"":\PROGRA~1\Crave\Global~1\globalops.exe" (
set "globalopspath=%drive%:\PROGRA~1\Crave\Global~1"
 )
)

if exist "%drive%"":\PROGRA~2\Crave\Global~1\globalops.exe" (
set "globalopspath=%drive%:\PROGRA~2\Crave\Global~1"
 )
)
echo %globalopspath%> globalopspath.txt





REM Powershell.exe -executionpolicy bypass -File  "exclusion.ps1"
REM Powershell.exe -executionpolicy bypass -File  "disable-real-time.ps1"
REM Powershell.exe -executionpolicy bypass -File  "download-3.5.ps1"
REM Powershell.exe -executionpolicy bypass -File  "enable-real-time.ps1"
copy "G:\My Drive\globalops\Globalops.exe.cfg" "C:\Program Files (x86)\RivaTuner Statistics Server\Profiles"
REM Powershell.exe -executionpolicy bypass -File  "profile_update.ps1"
REM Powershell.exe -executionpolicy bypass -File  "downloadtimertool.ps1"

pause