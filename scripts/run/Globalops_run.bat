@echo off
setlocal enabledelayedexpansion
REM RUN:
REM run rivatuner
REM run high res timer (start "" "C:\PathToTool\TimerTool.exe" -t 0.5 -minimized)
REM run globalops with altered affinity
REM
REM

REM TODO:
REM could check PID for highres and Riva

:check for admin permissions
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



:check for setup generated files
if not exist ".\Tools\cross-script-variables\globalopspath.txt" (
	echo The Globalops path file from the setup script is missing. Did you run it?
	echo Maybe do that.
)




:get variables from setup
set "filename1=.\Tools\cross-script-variables\rivapath.txt"

for /f "usebackq delims=" %%a in ("!filename1!") do (
   set "rivapath=%%a"
)


set "filename2=.\Tools\cross-script-variables\globalopspath.txt"

for /f "usebackq delims=" %%a in ("!filename2!") do (
   set "globalopspath=%%a"
)

:Global Ops game profile performance tweaks

set "search=ConcUpdates updaterate inputrate backbuffercount"
set "replace=ConcUpdates "100" updaterate "20" inputrate "100.000000" backbuffercount "4""

for %%f in (.\Globalops\profile\*.cfg) do (
  echo Processing %%f...
  for /f "usebackq delims=" %%l in ("%%f") do (
    set "line=%%l"
    set "match="
    for %%s in (!search!) do (
      echo !line! | findstr /c:"%%s" >nul
      if not errorlevel 1 set "match=1"
    )
    if defined match (
      set "line=!line:%search%=%replace%!"
    )
    echo !line!>>"%%~dpnf_modified%%~xf"
  )
  move /y "%%~dpnf_modified%%~xf" "%%~f"
)

echo Done game profile performance tweaks
pause

REM High Res Timer
:: High Resolution Monitor/Force tool https://github.com/tebjan/TimerTool
:: This will start Minimized and force a 0.5 resolution timer.
:: Stop it after the game is closed.
start "" ".\Tools\TimerTool.exe" -t 0.5 -minimized
echo Starting High Hesolution Timer

:: FPS Limiters:
pause

REM Riva Stats Server
if exist "!rivapath!\Profiles\Globalops.exe.cfg" (
	start "" "!rivapath!\RTSS.exe"
	) else (
	echo Hey... you are missing the Globalops.exe profile for Rivia..
	echo Did the setup script run successfully?
	)
	
	
	
if exist "C:\PROGRA~2\RivaTu~1\RTSS.exe" (
	
		start "" "C:\PROGRA~2\RivaTu~1\RTSS.exe"
	) else (
		copy Globalops.exe.cfg "C:\PROGRA~2\RivaTu~1\Profiles\"
		start "" "C:\PROGRA~2\RivaTu~1\RTSS.exe"
	)
)

if exist "!drive!:\PROGRA~2\RivaTu~1\RTSS.exe" (
	if exist "!drive!:\PROGRA~2\RivaTu~1\Profiles\Globalops.exe.cfg" (
		start "" "!drive!:\PROGRA~2\RivaTu~1\RTSS.exe"
	) else (
		copy Globalops.exe.cfg "!drive!:\PROGRA~2\RivaTu~1\Profiles\"
		start "" "!drive!:\PROGRA~2\RivaTu~1\RTSS.exe"
	)
)

echo riva
pause

REM Start 

echo !globalopspath!
cd !globalopspath!
start /affinity 1 Globalops.exe


REM Adjust tickrate to... 70?
REM We need to find PID, add it to tickrate.gdb. `pidof Globalops.exe`
REM Loop this to ensure it is applied?
REM gdb -batch -x !globalopspath!\Tools\tickrate.gdb


set "search='<pid>'"
set "replace=`pidof Globalops.exe`"
set "inputFile=!globalopspath!\Tools\tickrate.gdb" REM Make a template file?
set "outputFile=!globalopspath!\Tools\tickrate.gdb"

(for /F "usebackq delims=" %%L in ("%inputFile%") do (
    set "line=%%L"
    setlocal enabledelayedexpansion
    set "line=!line:%search%=%replace%!"
    echo !line!
    endlocal
)) > "%outputFile%"




pause