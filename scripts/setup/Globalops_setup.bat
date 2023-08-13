@echo off
setlocal enabledelayedexpansion
set debug=1
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
	set /p globalopsinstalled='Do you have a working install? If so, type y, if no, type n'
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
goto Download_Map_Pack
pause



:Download Global Operations
REM To extract zip with password, we need something with more beef than powershell zip extractor.
REM download NuGet(2.8.5.201 or newer) module, as it is a dependancy for 7zip4powershell module.


echo starting game download
set /p "unpackingPassword=Password please "
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


:Download_Map_Pack
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
REM Check if 4.0 is already applied. If so, prompt asking if they want to override anyways.

set "patchfile=Globalops-4.0-beta6.zip"
set "filename=Globalops.exe"
set "3.5globalopshash=03c6fea302fb53a2c3265522d901c945d4ddd309"
set "4.0hash=c3608c61e59df65844a670c1c398e591cc8f5b10"
set "4.0ahash=591950eafdfb98c0999782829c4424c0e29ba251"
for /f "tokens=*" %%a in ('CertUtil -hashfile "!globalopspath!\!filename!" SHA1 ^| find /v ":"') do set "filehash=%%a"
set "filehash=!filehash: =!"
echo Checking to see if patch 4.0 is installed. If not, install it.
if "!debug!"=="1" (
echo Actual file Hash: !filehash!
echo Script stored Hash: !4.0ahash!
echo What antivirus/protection software is installed.
REM We need to split each results into a line, record known results and make the user open up a link explaining how to temp disable.
Powershell.exe -executionpolicy bypass -Command "Get-CimInstance -Namespace root/SecurityCenter2 -Classname AntiVirusProduct | Select-Object -ExpandProperty displayName"

)

if NOT "!filehash!"=="!4.0ahash!"(
echo Patch 4.0a is not installed
if NOT "!filehash!"=="!4.0hash!" (
echo Installing 4.0 patch
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


if "!filehash!"=="!4.0hash!" (
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableArchiveScanning $true"
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableIntrusionPreventionSystem $true"
REM Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -MAPSReporting Disable"
	timeout /t 1
    Powershell.exe -executionpolicy bypass -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://github.com/Boby360/Globalops_resources/raw/main/patches/4.0/globalops4.0a-beta.zip' -OutFile !batchdir!\Globalops-4.0a-beta.zip"
    timeout /t 1
	Powershell.exe -executionpolicy bypass -Command Expand-Archive -Force -LiteralPath '!batchdir!\Globalops-4.0a-beta.zip' -DestinationPath '!globalopspath!'
	timeout /t 4
REM Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -MAPSReporting Enable"
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableIntrusionPreventionSystem $false"
	Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableArchiveScanning $false"
    Powershell.exe -executionpolicy bypass -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
	echo Downloaded and installed Patch 4.0a
)
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
