@echo off

REM TODO:
REM Assume this is going to be placed in the global ops folder and get rid of all the globalops path stuff??

:Get Global Ops Directory

set globalopspath="0"
set globalopsdrive="0"


if exist "C:\PROGRA~1\Crave\Global~1\globalops.exe" (
 set "globalopspath=C:\PROGRA~1\Crave\Global~1"
 )
if exist "C:\PROGRA~2\Crave\Global~1\globalops.exe" (
 set "globalopspath=C:\PROGRA~2\Crave\Global~1"
 )

if %globalopspath%=="0" (
echo Install was not found on C drive. What drive is globalops installed on
set /p "globalopsdrive=Drive letter WITHOUT ":" infront:"
echo %globalopsdrive%

if exist "%globalopsdrive%":\PROGRA~1\Crave\Global~1\globalops.exe" (
set "globalopspath=%globalopsdrive%:\PROGRA~1\Crave\Global~1"
 )
)

if exist "%drive%"":\PROGRA~2\Crave\Global~1\globalops.exe" (
set "globalopspath=%globalopsdrive%:\PROGRA~2\Crave\Global~1"
 )
)
echo %globalopspath%> globalopspath.txt


:Get RTSS Directory
set rivapath="0"
set rivadrive="0"
set rivainstalled="0"

if exist "C:\PROGRA~1\RivaT~1\RTSS.exe" (
 set "rivapath=C:\PROGRA~1\RivaT~1"
 )
if exist "C:\PROGRA~2\RivaT~1\RTSS.exe" (
 set "rivapath=C:\PROGRA~2\RivaT~1"
 )

if %rivapath%=="0" (
echo Is RivaTuner Stats Server installed?
echo This limits game FPS and is critical to smooth gameplay
echo 
set /p "rivainstalled= If yes, type in 1, if not, type in 0"
if %rivainstalled%=="1" (
echo What drive is it installed on?
set /p "rivadrive=Type in drive letter WITHOUT ":" infront:"

echo Install was not found on C drive. What drive is globalops installed on
set /p "rivadrive=Drive letter WITHOUT ":" infront:"
echo %rivadrive%

if exist "%rivadrive%"":\PROGRA~1\RivaT~1\RTSS.exe" (
set "rivapath=%rivadrive%:\PROGRA~1\RivaT~1"
 )

if exist "%rivadrive%"":\PROGRA~2\RivaT~1\RTSS.exe" (
set "rivapath=%rivadrive%:\PROGRA~2\RivaT~1"
 )
echo %rivapath%> rivapath.txt
)
)
:Download RTSS
if %rivainstalled%=="0" (
Powershell.exe -executionpolicy bypass -File  "download-RTSS.ps1"
)
REM echo %rivadrive%> globalopspath.txt

:Download and install patch 3.5
REM Check if 3.5 is already applied. If so, prompt asking if they want to override anyways.

:: Set the path to the file you want to check the version of
set FILEPATH="%globalopspath%""\globalops.exe"

:: Use WMIC to get the file version information
for /f "tokens=2 delims==" %%v in ('wmic datafile where name^="%FILEPATH:\=\\%" get version /value') do set "GAMEVERSION=%%v"

:: Remove any unwanted characters from the version string
set GAMEVERSION=%GAMEVERSION:~0,-1%

:: Print the file version
echo %GAMEVERSION%

if %GAMEVERSION%=="1.29.0.0" (
echo Patch 3.5 is already installed. Do you want to override what is currently installed?
set /p "installpatch=Type 1 if you want to install the patch anyways
)

if %installpatch%==1 (
Powershell.exe -executionpolicy bypass -File  "disable-real-time.ps1"
Powershell.exe -executionpolicy bypass -File  "download-3.5.ps1"
Powershell.exe -executionpolicy bypass -File  "enable-real-time.ps1"
)

if not %GAMEVERSION%=="1.29.0.0" (
Powershell.exe -executionpolicy bypass -File  "disable-real-time.ps1"
Powershell.exe -executionpolicy bypass -File  "download-3.5.ps1"
Powershell.exe -executionpolicy bypass -File  "enable-real-time.ps1"
)


REM Is the folder already excluded?
:Windows Defender Exclusion check
:: Check if the folder is excluded from Windows Defender
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "%globalopspath%" > nul
if %errorlevel% equ 0 (
   echo The folder is excluded from Windows Defender.
) else (
   echo The folder is not excluded from Windows Defender.
   Powershell.exe -executionpolicy bypass -File  "exclusion.ps1"
   echo It has now been added
)


:Global Ops game profile performance tweaks

Powershell.exe -executionpolicy bypass -File  "profile_update.ps1"

REM If exists, then don't download
REM Put this in the globalops folder for simplicity? 

:High Res Timer Download
if not exist "%globalopsdrive%":\PROGRA~1\Crave\Global~1\Tools\" (
mkdir Tools
)

if not exist "%globalopsdrive%":\PROGRA~1\Crave\Global~1\Tools\TimerTool.exe" (
Powershell.exe -executionpolicy bypass -File  "download-timertool.ps1"
 )

if not exist "%rivadrive%":\PROGRA~1\Crave\Global~1\Tools\TimerTool.exe" (
Powershell.exe -executionpolicy bypass -File  "download-timertool.ps1"
 )
 
:Riva Profile for Global Ops
if not exist "%rivapath%""\Profiles\Globalops.exe.cfg" (
Powershell.exe -executionpolicy bypass -File  "download-rivaprofile.ps1"
 )

rename .\rivatuner-limit100-Globalops.exe.cfg .\Globalops.exe.cfg
copy ".\Globalops.exe.cfg" "%rivapath%""\Profiles\"
pause


:Gamespy Patch
REM This applies a patch to your computer that will make all/most gamespy games use the OpenSpy master gameserver.


set "hostsPath=%SystemRoot%\System32\drivers\etc\hosts"
set "desiredIP=157.245.212.59"
set "desiredHostname=master.gamespy.com"

echo This script will attempt to add the OpenSpy (Gamespy alternative) to your Windows Hosts file.
echo .
pause
echo .

REM Check if the hosts file is read-only and remove the attribute if necessary
set "hostsReadOnly="
for %%F in ("%hostsPath%") do (
    if %%~aF equ "r" (
        echo Removing read-only attribute from hosts file...
        attrib -r "%hostsPath%" >nul
        set "hostsReadOnly=yes"
    )
)

REM Check if desired hostname already exists in the hosts file
set "lineFound="
for /f "usebackq tokens=1,2,*" %%A in ("%hostsPath%") do (
    if "%%B" == "%desiredHostname%" (
        set "lineFound=yes"
        if "%%A %%B" == "%desiredIP% %desiredHostname%" (
            echo The script has already succeeded. The hosts file already contains the correct entry for %desiredHostname%.
        ) else (
            echo Found an existing entry for %desiredHostname% but with a different IP address. Replacing it with the correct IP address...
            type "%hostsPath%" | findstr /v /c:"%%A %%B">"%hostsPath%.tmp"
            echo %desiredIP% %desiredHostname%>>"%hostsPath%.tmp"
            move /y "%hostsPath%.tmp" "%hostsPath%" >nul
        )
    )
)

REM If the desired hostname is not in the file, add it
if not defined lineFound (
    echo Adding entry for %desiredHostname% to hosts file.
    echo %desiredIP% %desiredHostname%>>"%hostsPath%"
)

REM Verify that the entry was added or replaced correctly
set "lineFound="
for /f "usebackq tokens=1,2,*" %%A in ("%hostsPath%") do (
    if "%%B" == "%desiredHostname%" (
        set "lineFound=yes"
        if "%%A %%B" == "%desiredIP% %desiredHostname%" (
            echo The entry for %desiredHostname% was successfully added to the hosts file or updated with the correct IP address.
        ) else (
            echo Failed to update the IP address for %desiredHostname% in the hosts file.
			echo .
			echo Did you right click the file and click "Run as administrator"?.
			echo If so and this still doesn't work, its possible that Windows has ransomware protection enabled, limiting access to the file.
			echo As an alternative to this script, you can open %hostsPath% in notepad with administrative rights, and add:
			echo %desiredIP% %desiredHostname% 
)
        )
    )
)

REM Set the hosts file back to read-only if it was read-only to begin with
if defined hostsReadOnly (
    echo Setting read-only attribute back on hosts file...
    attrib +r "%hostsPath%" >nul
)

pause
