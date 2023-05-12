@echo off



:check_Permissions
REM checking if script ran as Administrator    
    net session >nul 2>&1
    if %errorLevel% == 0 (
	echo 
    ) else (
        echo You did not run this script as an Administrator.
		echo This is required for this script to run properly.
		echo Right click the script, and select "Run as administrator"
		pause
		exit
    )

REM Get the full path of the batch file
set "batchfile=%~f0"

REM Extract the directory from the batch file path
set "batchdir=%~dp0"

echo.|set /p="%batchdir%">%batchdir%\batchpath.txt 


:Get Global Ops Directory

set globalopspath=0
set globalopsdrive=C


if exist "C:\PROGRA~1\Crave\Global~1\globalops.exe" (
 set globalopspath=C:\PROGRA~1\Crave\Global~1
)
if exist "C:\PROGRA~2\Crave\Global~1\globalops.exe" (
 set globalopspath=C:\PROGRA~2\Crave\Global~1
)

if %globalopspath%==0 (
echo Install was not found on C drive. What drive is globalops installed on
set /p "globalopsdrive=Drive letter WITHOUT ":" infront:"
echo %globalopsdrive%

if exist "%globalopsdrive%:\PROGRA~1\Crave\Global~1\globalops.exe" (
set globalopspath=%globalopsdrive%:\PROGRA~1\Crave\Global~1
 )
)

if exist "%globalopsdrive%:\PROGRA~2\Crave\Global~1\globalops.exe" (
set globalopspath=%globalopsdrive%:\PROGRA~2\Crave\Global~1
  
)
REM echo %globalopspath%> globalopspath.txt
echo.|set /p="%globalopspath%">%batchdir%\globalopspath.txt 
REM this method only puts 1 line in the text file. This is needed for the registry check.


:Get RTSS Directory
set "rivapath="
set "rivadrive="
set "rivainstalled="

if exist "C:\Program Files\RivaTuner Statistics Server\RTSS.exe" (
    set "rivapath=C:\Program Files\RivaTuner Statistics Server"
	echo Found a Riva install
) else if exist "C:\Program Files (x86)\RivaTuner Statistics Server\RTSS.exe" (
    set "rivapath=C:\Program Files (x86)\RivaTuner Statistics Server"
	echo Found a Riva install							   
)

if not defined rivapath (
    echo Is RivaTuner Statistics Server installed?
    echo This limits game FPS and is critical to smooth gameplay.
    echo.
    set /p "rivainstalled=If yes, type 1. If not, type 0: "
    if "%rivainstalled%"=="1" (
        echo What drive is it installed on?
        set /p "rivadrive=Type in drive letter WITHOUT ':' in front: "
        set "rivapath=%rivadrive%:\Program Files\RivaTuner Statistics Server"
    )
)

echo %rivapath% > %batchdir%\rivapath.txt
 
:Download RTSS
if "%rivainstalled%"=="0" (
	echo Attemping to download RTSS
    Powershell.exe -executionpolicy bypass -Command "Invoke-WebRequest -Uri https://ftp.nluug.nl/pub/games/PC/guru3d/afterburner/[Guru3D.com]-RTSS.zip -OutFile %batchdir%\RTSS.zip"
    Powershell.exe -executionpolicy bypass -Command Expand-Archive -Force -LiteralPath %batchdir%\RTSS.zip -DestinationPath %batchdir%\
	echo This limits game FPS and is critical to smooth gameplay.
	echo The run script will use it. please install it:
	start "" "%batchdir%\[Guru3D.com]-RTSSSetup734.exe"
)

pause

REM Is the folder already excluded?
:Windows Defender Exclusion check
REM Check if the folder is excluded from Windows Defender
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "%globalopspath%" > nul 2>nul
if %errorlevel% equ 0 (
   echo The folder is excluded from Windows Defender.
) else (
	echo The folder is not excluded from Windows Defender.
	Powershell.exe -executionpolicy bypass -Command "Add-MpPreference -ExclusionPath %globalopspath%"
	echo It has now been added
)
pause

:Download and install patch 3.5
REM Check if 3.5 is already applied. If so, prompt asking if they want to override anyways.


set "filename=Globalops.exe"
set "hash=df07a775aeeefbdaf2b2109cf912b50742a13acc"

for /f "tokens=*" %%a in ('CertUtil -hashfile "%globalopspath%\%filename%" SHA1 ^| find /v ":"') do set "filehash=%%a"
set "filehash=%filehash: =%"
echo Checking to see if patch 3.5 is installed. If not, install it.
if "%filehash%"=="%hash%" (
    echo Patch 3.5 is already installed. Do you want to override what is currently installed?
    set /p "installpatch=Type 1 if you want to install the patch anyways: "
) else (
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
    Powershell.exe -executionpolicy bypass -Command "Invoke-WebRequest -Uri 'https://github.com/Boby360/Globalops_resources/raw/main/patches/3.5/globalops-35-manual-installer.zip' -OutFile %batchdir%\globalops-35-manual-installer.zip"
    Powershell.exe -executionpolicy bypass -Command "Expand-Archive -Force -LiteralPath '%batchdir%\globalops-35-manual-installer.zip' -DestinationPath %globalopspath%"
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
    echo Downloaded, installed 3.5, and disabled and enabled windows defender.
)


if "%installpatch%"=="1" (
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
    Powershell.exe -executionpolicy bypass -Command "Invoke-WebRequest -Uri 'https://github.com/Boby360/Globalops_resources/raw/main/patches/3.5/globalops-35-manual-installer.zip' -OutFile globalops-35-manual-installer.zip"
    Powershell.exe -executionpolicy bypass -Command "Expand-Archive -Force -LiteralPath '.\globalops-35-manual-installer.zip' -DestinationPath %globalopspath%"
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
	echo Installed 3.5, despite theoretically being installed due to your request.
)

pause

:Global ops Game Cd key randomizer

set "key=HKLM:SOFTWARE\WOW6432Node\Electronic Arts\EA Games\Global Operations\ergc"
set "value=(default)"

powershell -Command "$NewValue = Get-Random -Minimum 5000000000000000000000 -Maximum 6000000000000000000000; Set-ItemProperty -Path '%key%' -Name '%value%' -Value $NewValue"



echo CD key randomized!
pause

:High Res Timer Download
if not exist "%globalopspath%\Tools" (
    echo made Tools folder
	mkdir "%globalopspath%\Tools"
)

if not exist "%globalopspath%\Tools\TimerTool.exe" (
	echo file does not exist.
    Powershell.exe -executionpolicy bypass -Command Invoke-WebRequest -Uri 'https://vvvv.org/sites/all/modules/general/pubdlcnt/pubdlcnt.php?file=https://vvvv.org/sites/default/files/uploads/TimerToolV3.zip' -OutFile %globalopspath%\Tools\TimerToolV3.zip
	Powershell.exe -executionpolicy bypass -Command Expand-Archive -Force -LiteralPath %globalopspath%\Tools\TimerToolV3.zip -DestinationPath %globalopspath%\Tools\
)

echo High Res Timer install complete
pause
:Riva Profile for Global Ops
if not exist "%rivapath%\Profiles\Globalops.exe.cfg" (
	echo Downloading Globalops Riva Profile from Github repo
	Powershell.exe -executionpolicy bypass -Command "Invoke-WebRequest -Uri https://github.com/Boby360/Globalops_resources/raw/main/profiles/rivatuner-limit100-Globalops.exe.cfg -OutFile %batchdir%\Globalops.exe.cfg"
	copy "%batchdir%\Globalops.exe.cfg" "%rivapath%\Profiles\"
)

echo Globalops Riva Profile install complete
pause



:Gamespy Patch
REM This applies a patch to your computer that will make all/most gamespy games use the OpenSpy master gameserver.


set "hostsPath=%SystemRoot%\System32\drivers\etc\hosts"
set "desiredIP=157.245.212.59"
set "desiredHostname=master.gamespy.com"

echo This script will attempt to add the OpenSpy (Gamespy alternative) to your Windows Hosts file.
echo .
pause

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
    attrib +r "%hostsPath%" >nul
)

pause
