@echo off
setlocal enabledelayedexpansion
set debug=0
set makelink=0
echo Global Operations Extra Install/Optimize script
echo Created by Boby with invalable support from MasTa
REM set unpackingPassword=

REM Todo:
REM Install/Figure out mappack situation.
REM Figure out shortcut code
REM Detect other common antivirus and tell users how to exclude manually

:check_Permissions
REM checking if script ran as Administrator    
    net session >nul 2>&1
    if !errorLevel! == 0 (
	echo 
    ) else (
        echo You did not run this script as an Administrator.
		echo This is required for this script to run properly.
		echo Right click the script, and select "Run as administrator"
		pause
		exit
    )
echo verified permissions
pause
REM Get the full path of the batch file
set "batchfile=%~f0"

REM Extract the directory from the batch file path
set "batchdir=%~dp0"

echo |set /p ="!batchdir!">!batchdir!\batchpath.txt 

if "!debug!"=="1" (
echo Batch Directory:
echo !batchdir!
)

echo got batch path
pause
:Get Global Ops Directory
set "globalopspath="
set "globalopsdrive="


if exist "C:\PROGRA~1\Crave\Global~1\globalops.exe" (
 set globalopspath=C:\PROGRA~1\Crave\Global~1
)
if exist "C:\PROGRA~2\Crave\Global~1\globalops.exe" (
 set globalopspath=C:\PROGRA~2\Crave\Global~1
)
if "!debug!"=="1" (
echo We found the path:
echo !globalopspath!
)
IF NOT DEFINED globalopspath (
	echo Globalops install was not found on C drive.
	REM Is it installed?
	set /p globalopsinstalled='Is it installed? If so, type y to select a non default drive.'
	if "!globalopsinstalled!"=="y" (
	set /p globalopsdrive=What drive letter is globalops installed on: 
		if "!debug!"=="1" (
		echo !globalopsdrive!
		echo !globalopspath!
		)

		IF EXIST "!globalopsdrive!:\PROGRA~1\Crave\Global~1\Globalops.exe" (
			set "globalopspath=!globalopsdrive!:\PROGRA~1\Crave\Global~1"
			echo Globalops install path confirmed: !globalopspath!
		) ELSE IF EXIST "!globalopsdrive!:\PROGRA~2\Crave\Global~1\Globalops.exe" (
			set globalopspath="!globalopsdrive!:\PROGRA~2\Crave\Global~1"
			echo Globalops install path confirmed: !globalopspath!
		) ELSE (
			echo Could not find Globalops installation on !globalopsdrive! drive.
			set /p "globalopspath=What is the weird path to Globalops.exe?"
			IF EXIST "!globalopspath!\Globalops.exe" (
			echo Confirmed install!
			) else (
			echo There is no Globalops.exe file at the end of that path.
			pause
			GOTO Get Global Ops Directory
			)
		)
	) else (
		set /p globalopsinstall='Do you want the script to download the game? Type y if so.'
		if "!globalopsinstall!"=="y" (
		GOTO Download Global Operations
		) else (
		echo Installation required to continue.
		pause
		exit
		)
	)
)

if "!debug!"=="1" (
echo Finished globalops directory code
)
pause
if "!debug!"=="1" (
echo Go to Tools
)

GOTO Tools



:Download Global Operations
REM To extract zip with password, we need something with more beef than powershell zip extractor.
REM download NuGet(2.8.5.201 or newer) module, as it is a dependancy for 7zip4powershell module.


echo starting game download
set /p "unpackingPassword=Password please"
REM We should do a SHA-1 check to see if the file already exists, and is proper.
Powershell.exe -executionpolicy bypass -Command $WebClient1 = New-Object System.Net.WebClient; $GameDLUrl = "'https://drive.google.com/uc?export=download&id=1xN6xXK1hqq9DJeouT0UxiUC--OGzUrYt&confirm=t'"; $WebClient1.DownloadFile($GameDLUrl, '!batchdir!\gop.zip' );
echo Downloaded game
pause
echo installing unpacking script dependencies
REM Add check to see if package/modules exist.
Powershell.exe -executionpolicy bypass -Command Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Scope AllUsers -Force
Powershell.exe -executionpolicy bypass -Command Install-Module 7Zip4PowerShell -Scope AllUsers -Force

REM Check to see if packages are already there
for /f "tokens=*" %%a in ('CertUtil -hashfile "!batchdir!\gop.zip" SHA1 ^| find /v ":"') do set "filehash=%%a"
set "gopfilehash=!filehash: =!"
echo gop !gopfilehash!

for /f "tokens=*" %%a in ('CertUtil -hashfile "!batchdir!\gop2.zip" SHA1 ^| find /v ":"') do set "filehash=%%a"
set "gop2filehash=!filehash: =!"
echo gop2 !gop2filehash!

echo unpacking zip1
Powershell.exe -executionpolicy bypass -Command Expand-7Zip -ArchiveFileName "!batchdir!\gop.zip" -TargetPath !batchdir! -Password !unpackingPassword!
echo unpackaged zip 1
pause
if exist "C:\PROGRA~2\" (
	echo make x86 crave folder
	mkdir C:\PROGRA~2\Crave\
	echo extract gop2 into crave folder
	Powershell.exe -executionpolicy bypass -Command Expand-Archive -Force -LiteralPath '!batchdir!\gop2.zip' -DestinationPath 'C:\PROGRA~2\Crave\'
	echo extracted
) else (
	if exist "C:\PROGRA~1\" (
	echo make x64 crave folder
	mkdir C:\PROGRA~1\Crave\
	echo extract gop2 into crave folder
	Powershell.exe -executionpolicy bypass -Command Expand-Archive -Force -LiteralPath '!batchdir!\gop2.zip' -DestinationPath 'C:\PROGRA~1\Crave\'
	echo extracted
	)
	)
pause
echo Registery install
Powershell.exe -executionpolicy bypass -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://github.com/Boby360/Globalops_resources/raw/main/patches/registry/Install-Key.reg -OutFile !batchdir!\Install-Key.reg"
echo registry downloaded
pause
REM will create the paths required. add will not.
echo registry import attempt:
REG IMPORT !batchdir!\Install-Key.reg
pause

:Tools
REM echo !globalopspath!> globalopspath.txt
REM if "!debug!"=="1" (
REM echo Starting Tools check
REM )
REM if not exist "!globalopspath!\Tools" (
    REM echo I made a Tools folder in your Global Ops install to store things
	REM mkdir "!globalopspath!\Tools"
REM )
REM if not exist "!globalopspath!\cross-script-variables" (
	REM if "!debug!"=="1" (
	  REM echo I made a folder inside of Tools folder in the global ops install for various script stuff
	REM )
  	REM mkdir "!globalopspath!\Tools\cross-script-variables"
REM )

REM echo |set /p="!globalopspath!">!globalopspath!\Tools\cross-script-variables\globalopspath.txt 
REM this method only puts 1 line in the text file. This is needed for the registry check.
REM pause

:Get RTSS Directory
REM set "rivapath="
REM set "rivadrive="
REM set "rivainstalled=0"

REM if exist "C:\Program Files\RivaTuner Statistics Server\RTSS.exe" (
    REM set "rivapath=C:\Program Files\RivaTuner Statistics Server"
	REM echo Found a Riva install
	REM set "rivainstalled=1"
REM ) else if exist "C:\Program Files (x86)\RivaTuner Statistics Server\RTSS.exe" (
    REM set "rivapath=C:\Program Files (x86)\RivaTuner Statistics Server"
	REM echo Found a Riva install
	REM set "rivainstalled=1"	
REM )

REM if not defined rivapath (
    REM echo Is RivaTuner Statistics Server installed?
    REM echo This limits game FPS and is critical to smooth gameplay.
    REM echo.
    REM set /p "rivainstalled=If yes, type 1. If not, type 0: "
    REM if "!rivainstalled!"=="1" (
        REM echo What drive is it installed on?
        REM set /p "rivadrive=Type in drive letter WITHOUT ':' in front: "
        REM set "rivapath=!rivadrive!:\Program Files\RivaTuner Statistics Server"
        REM pause
    REM )
REM )
REM echo |set /p ="!rivapath!">!globalopspath!\Tools\cross-script-variables\rivapath.txt
REM pause
:Download RTSS
REM if "!debug!"=="1" (
REM echo !rivainstalled!
REM echo !rivapath!
REM )
REM if "!rivainstalled!"=="0" (
    REM echo Attempting to download RTSS
    REM Powershell.exe -executionpolicy bypass -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://ftp.nluug.nl/pub/games/PC/guru3d/afterburner/[Guru3D.com]-RTSS.zip -OutFile !batchdir!\RTSS.zip" ^
    REM && Powershell.exe -executionpolicy bypass -Command Expand-Archive -Force -LiteralPath !batchdir!\RTSS.zip -DestinationPath !batchdir!\
    REM echo This limits game FPS and is critical to smooth gameplay.
    REM echo The run script will use it. Please install it:
    REM start "" "!batchdir!\[Guru3D.com]-RTSSSetup734.exe"
    REM pause
    REM GOTO Get RTSS Directory
REM )

REM if "!debug!"=="1" (
REM pause
REM )

:Download Map Pack
IF NOT EXIST "!globalopspath!\globalops\worlds\4way.dat" (

echo Downloading/Installing Mappack
REM Powershell.exe -executionpolicy bypass -Command "$WebClient2 = New-Object System.Net.WebClient; $MapPackUrl = "'https://drive.google.com/uc?export=download&id=1PTSnVKbqJ4MBCm8J4BPcKt6BUtg4j58t&confirm=t'"; $WebClient2.DownloadFile($MapPackUrl, !batchdir!\mappack.zip" );
for /f "tokens=*" %%a in ('CertUtil -hashfile "!batchdir!\mappack.zip" SHA1 ^| find /v ":"') do set "filehash=%%a"
set "calcmappackfilehash=!filehash: =!"
set "realmappackfilehash=decd1cd02ebcfcd9f1e02b420c45f02b49181e50"
REM decd1cd02ebcfcd9f1e02b420c45f02b49181e50
echo Map Pack File Hash: !calcmappackfilehash!

	if NOT "!calcmappackfilehash!"=="!realmappackfilehash!" (
	Powershell.exe -ExecutionPolicy Bypass -Command "$WebClient2 = New-Object System.Net.WebClient; $MapPackUrl = 'https://drive.google.com/uc?export=download&id=10WTOThhz0rj2eQLdOu5XU62wjiQEGfA1&confirm=t'; $WebClient2.DownloadFile($MapPackUrl, '!batchdir!\mappack.zip');"
	)
Powershell.exe -executionpolicy bypass -Command Expand-Archive -Force -LiteralPath '!batchdir!\mappack.zip' -DestinationPath '!globalopspath!\globalops\'
)

REM Is the folder already excluded?
:Windows Defender Exclusion check
REM Check if the folder is excluded from Windows Defender
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "!globalopspath!" > nul 2>nul
if !errorlevel! equ 0 (
   echo The folder is excluded from Windows Defender.
) else (
	echo The folder is not excluded from Windows Defender
	Powershell.exe -executionpolicy bypass -Command Add-MpPreference -ExclusionPath '!globalopspath!'
	echo It has now been added
)
pause

:Download and install patch 3.5
REM Check if 3.5 is already applied. If so, prompt asking if they want to override anyways.

set "patchfile=Globalops-4.0-beta6.zip"
set "filename=Globalops.exe"
set "3.5globalopshash=03c6fea302fb53a2c3265522d901c945d4ddd309"
set "hash=c3608c61e59df65844a670c1c398e591cc8f5b10"
for /f "tokens=*" %%a in ('CertUtil -hashfile "!globalopspath!\!filename!" SHA1 ^| find /v ":"') do set "filehash=%%a"
set "filehash=!filehash: =!"
echo Checking to see if patch 4.0 is installed. If not, install it.
if "!debug!"=="1" (
echo Actual file Hash: !filehash!
echo Script stored Hash: !hash!
echo What antivirus/protection software is installed.
REM We need to split each results into a line, record known results and make the user open up a link explaining how to temp disable.
Powershell.exe -executionpolicy bypass -Command "Get-CimInstance -Namespace root/SecurityCenter2 -Classname AntiVirusProduct | Select-Object -ExpandProperty displayName"

)
if "!filehash!"=="!hash!" (
    echo Patch 4.0 is already installed. Do you want to override what is currently installed?
    set /p "installpatch=Type 1 if you want to install the patch anyways: "
) else (
REM Does one of these below disable cloud scanning and not re enable it?
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableArchiveScanning $true"
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableIntrusionPreventionSystem $true"
REM	Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -MAPSReporting Disable"
	timeout /t 1
    Powershell.exe -executionpolicy bypass -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://github.com/Boby360/Globalops_resources/raw/main/patches/4.0/Globalops-4.0-beta6.zip' -OutFile !batchdir!\Globalops-4.0-beta6.zip"
    timeout /t 1
	Powershell.exe -executionpolicy bypass -Command Expand-Archive -Force -LiteralPath '!batchdir!\Globalops-4.0-beta6.zip' -DestinationPath '!globalopspath!'
	timeout /t 4
REM	Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -MAPSReporting Enable"
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableIntrusionPreventionSystem $false"
	Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableArchiveScanning $false"
	Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
    echo Downloaded and installed Patch 4.0
)


if "!installpatch!"=="1" (
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableArchiveScanning $true"
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableIntrusionPreventionSystem $true"
REM Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -MAPSReporting Disable"
	timeout /t 1
    Powershell.exe -executionpolicy bypass -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://github.com/Boby360/Globalops_resources/raw/main/patches/4.0/Globalops-4.0-beta6.zip'' -OutFile !batchdir!\Globalops-4.0-beta6.zip"
    timeout /t 1
	Powershell.exe -executionpolicy bypass -Command Expand-Archive -Force -LiteralPath '!batchdir!\Globalops-4.0-beta6.zip' -DestinationPath '!globalopspath!'
	timeout /t 4
REM Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -MAPSReporting Enable"
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableIntrusionPreventionSystem $false"
	Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableArchiveScanning $false"
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
	echo Downloaded and installed Patch 4.0 over pre existing install
)

pause

:Global ops Game Cd key randomizer

set "key=HKLM:SOFTWARE\WOW6432Node\Electronic Arts\EA Games\Global Operations\ergc"
set "value=(default)"

set /a "minValue=1000"
set /a "maxValue=9999"
set /a "start=5000"
set /a "rangeSize=maxValue - minValue + 1"
set /a "randomNumber1=(%RANDOM% %% rangeSize) + minValue"
set /a "randomNumber2=(%RANDOM% %% rangeSize) + minValue"
set /a "randomNumber3=(%RANDOM% %% rangeSize) + minValue"
set /a "randomNumber4=(%RANDOM% %% rangeSize) + minValue"
echo Random number: !start!!randomNumber1!!randomNumber2!2!randomNumber3!!randomNumber4!

powershell -Command "$cdkey = !start!!randomNumber1!!randomNumber2!2!randomNumber3!!randomNumber4!; Set-ItemProperty -Path '!key!' -Name '!value!' -Value $cdkey"


echo CD key randomized!
pause

:High Res Timer Download

REM if not exist "!globalopspath!\Tools\TimerTool.exe" (
	REM echo High Res Timer not detected in Global Operations\Tools\ Downloading.....
    REM Powershell.exe -executionpolicy bypass -Command $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://vvvv.org/sites/all/modules/general/pubdlcnt/pubdlcnt.php?file=https://vvvv.org/sites/default/files/uploads/TimerToolV3.zip' -OutFile '!globalopspath!\Tools\TimerToolV3.zip'
	REM if "!debug!"=="1" (
		REM echo downloaded
		REM pause
	REM )
	REM Powershell.exe -executionpolicy bypass -Command Expand-Archive -Force -LiteralPath '!globalopspath!\Tools\TimerToolV3.zip' -DestinationPath '!globalopspath!\Tools\'
REM )

REM echo High Res Timer install complete
REM pause

REM :High tick rate requirement
REM if not exist "!globalopspath!\Tools\gdb.exe" (
REM	echo High tickrate tool not detected in Global Operations\Tools\ Downloading.....
REM    Powershell.exe -executionpolicy bypass -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri http://www.equation.com/ftpdir/gdb/64/gdb.exe -OutFile !batchdir!\gdb.exe"
REM	copy "!batchdir!\gdb.exe" "!globalopspath!\Tools\gdb.exe"
REM )

:Game optimizations
REM echo Downloading optimized cshell file for better tickrate values and built in tracker code.
REM for /f "tokens=*" %%a in ('CertUtil -hashfile "!globalopspath!\globalops\cshell.dll" SHA1 ^| find /v ":"') do set "filehash=%%a"
REM set "localcshellfilehash=!filehash: =!"
REM echo !localcshellfilehash!
REM for /f "tokens=*" %%a in ('CertUtil -hashfile "!globalopspath!\globalops\cshell-new.dll" SHA1 ^| find /v ":"') do set "filehash=%%a"
REM set "newcshellfilehash=!filehash: =!"
REM echo !newcshellfilehash!
REM get cshell old and new hash. If !=, then download new.

REM Powershell.exe -executionpolicy bypass -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://github.com/Boby360/Globalops_resources/raw/main/patches/optimizations/cshell.dll.packed -OutFile !globalopspath!\Globalops\cshell-new.dll"
REM del !globalopspath!\Globalops\cshell.dll"
REM move "!globalopspath!\Globalops\cshell-new.dll" "!globalopspath!\Globalops\cshell.dll"

REM Powershell.exe -executionpolicy bypass -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://github.com/Boby360/Globalops_resources/raw/main/patches/optimizations/object.lto.packed -OutFile !globalopspath!\Globalops\object-new.lto"
REM del !globalopspath!\Globalops\object.lto"
REM move "!globalopspath!\Globalops\object-new.lto" "!globalopspath!\Globalops\object.lto"
REM echo updated cshell complete
REM pause
:Riva Profile for Global Ops
REM if not exist "!rivapath!\Profiles" (
	REM mkdir "!rivapath!\Profiles"
REM )
REM if not exist "!rivapath!\Profiles\Globalops.exe.cfg" (
	
	REM echo Downloading Globalops Riva Profile from Github repo
	REM Powershell.exe -executionpolicy bypass -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://github.com/Boby360/Globalops_resources/raw/main/profiles/rivatuner-limit100-Globalops.exe.cfg -OutFile !batchdir!\Globalops.exe.cfg"
	REM copy "!batchdir!\Globalops.exe.cfg" "!rivapath!\Profiles\"
REM )

REM echo Globalops Riva Profile install complete
REM pause



:Gamespy Patch
REM This applies a patch to your computer that will make all/most gamespy games use the OpenSpy master gameserver.


set "hostsPath=!SystemRoot!\System32\drivers\etc\hosts"
set "desiredIP=157.245.212.59"
set "desiredHostname=master.gamespy.com"

echo This script will attempt to add the OpenSpy (Gamespy alternative) to your Windows Hosts file.
echo .
pause

REM Check if the hosts file is read-only and remove the attribute if necessary
set "hostsReadOnly="
for %%F in ("!hostsPath!") do (
    if !%%~aF! equ "r" (
        echo Removing read-only attribute from hosts file...
        attrib -r "!hostsPath!" >nul
        set "hostsReadOnly=yes"
    )
)

REM Check if desired hostname already exists in the hosts file
set "lineFound="
for /f "usebackq tokens=1,2,*" %%A in ("!hostsPath!") do (
    if "%%B" == "!desiredHostname!" (
        set "lineFound=yes"
        if "%%A %%B" == "!desiredIP! !desiredHostname!" (
            echo The script has already succeeded. The hosts file already contains the correct entry for !desiredHostname!.
			pause
			GOTO last
			REM exit
        ) else (
            echo Found an existing entry for !desiredHostname! but with a different IP address. Replacing it with the correct IP address...
            type "!hostsPath!" | findstr /v /c:"%%A %%B">"!hostsPath!.tmp"
            echo !desiredIP! !desiredHostname!>>"!hostsPath!.tmp"
            move /y "!hostsPath!.tmp" "!hostsPath!" >nul
        )
    )
)

REM If the desired hostname is not in the file, add it
if not defined lineFound (
    echo Adding entry for !desiredHostname! to hosts file.
    echo !desiredIP! !desiredHostname!>>"!hostsPath!"
)

REM Verify that the entry was added or replaced correctly
for /f "usebackq tokens=1,2,*" %%A in ("!hostsPath!") do (
    if "%%B" == "!desiredHostname!" (
        set "lineFound=yes"
        if "%%A %%B" == "!desiredIP! !desiredHostname!" (
            echo The entry for !desiredHostname! has been detected!
			echo It was successfully added or replaced in the hosts file.
        ) else (
            echo Failed to update the IP address for !desiredHostname! in the hosts file.
			echo .
			echo Its possible that Windows has ransomware protection enabled, limiting access to the file.
			echo As an alternative to this script, you can open !hostsPath! in notepad with administrative rights, and add:
			echo !desiredIP! !desiredHostname! 
)
        )
    )
)

REM Set the hosts file back to read-only if it was read-only to begin with
if defined hostsReadOnly (
    attrib +r "!hostsPath!" >nul
)
:last
REM Powershell.exe -executionpolicy bypass -Command $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://github.com/Boby360/Globalops_resources/raw/main/scripts/run/Globalops_run.bat' -OutFile '!globalopspath!\Globalops_run.bat'
REM move !batchdir!\Globalops_run.bat !globalopspath!\Globalops_run.bat
REM echo Assuming you did not see any errors, Great Success!
REM echo There is now a file called Globalops_run.bat in your Global Operations directory.
REM echo !globalopspath!
REM pause
REM if "!makelink!"=="0" (
REM exit
REM )

REM make link?
REM if "!makelink!"=="1" (
    REM set "defaultUsers=Public;Default;All Users;Default User"
    REM set "userFolder="
    REM for /d %%a in ("!systemdrive!\Users\*") do (
        REM set "folderName=%%~nxa"
        REM echo Checking folder: !folderName!
        REM echo Default users: !defaultUsers!
        REM set "isDefaultUser=0"
        REM for %%u in (!defaultUsers!) do (
            REM if "!folderName!"=="%%u" (
                REM set "isDefaultUser=1"
                REM exit /b
            REM )
        REM )
        REM if !isDefaultUser! equ 0 (
            REM if defined userFolder (
                REM echo Multiple non-default user folders found.
                REM set "userFolder=!folderName!"
                REM echo Current username: !folderName!
                REM goto end
            REM )
            REM set "userFolder=!folderName!"
        REM )
    REM )
    REM if not defined userFolder (
        REM echo No non-default user folders found.
        REM goto end
    REM )

    REM :end
    REM echo User folder: !userFolder!
    REM pause




REM set "linkName=Global Operations.lnk"
REM set "linktarget=!globalopspath!\Globalops_run.bat"
REM set "linkLocation=C:\Users\!userFolder!\Desktop"

REM mklink "!linkLocation!\!linkName!" "!linktarget!"
REM pause
REM exit
REM )
