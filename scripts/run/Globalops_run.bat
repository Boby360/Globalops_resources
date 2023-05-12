@echo off
REM RUN:
REM run rivatuner
REM run high res timer (start "" "C:\PathToTool\TimerTool.exe" -t 0.5 -minimized)
REM run globalops with altered affinity
REM
REM

REM TODO:
REM could check PID for highres and Riva

set "filename1=rivapath.txt"

for /f "usebackq delims=" %%a in ("%filename1%") do (
   set "rivapath=%%a"
)


set "filename2=globalopspath.txt"

for /f "usebackq delims=" %%a in ("%filename2%") do (
   set "globalopspath=%%a"
)

REM TEMP:
set globalopspath=C:\PROGRA~2\Crave\Global~1


:Global Ops game profile performance tweaks


setlocal enabledelayedexpansion

set "search=ConcUpdates updaterate inputrate backbuffercount"
set "replace=ConcUpdates "100" updaterate "20" inputrate "100.000000" backbuffercount "4""

for %%f in (%globalopspath%\Globalops\profile\*.cfg) do (
  echo Processing %%f...
  for /f "usebackq delims=" %%l in ("%%f") do (
    set "line=%%l"
    set "match="
    for %%s in (%search%) do (
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
start "" "%globalopspath%\Tools\TimerTool.exe" -t 0.5 -minimized
echo high res

:: FPS Limiters:
pause

REM Riva Stats Server
if exist "C:\PROGRA~2\RivaTu~1\RTSS.exe" (
	if exist "C:\PROGRA~2\RivaTu~1\Profiles\Globalops.exe.cfg" (
		start "" "C:\PROGRA~2\RivaTu~1\RTSS.exe"
	) else (
		copy Globalops.exe.cfg "C:\PROGRA~2\RivaTu~1\Profiles\"
		start "" "C:\PROGRA~2\RivaTu~1\RTSS.exe"
	)
)

if exist "%drive%:\PROGRA~2\RivaTu~1\RTSS.exe" (
	if exist "%drive%:\PROGRA~2\RivaTu~1\Profiles\Globalops.exe.cfg" (
		start "" "%drive%:\PROGRA~2\RivaTu~1\RTSS.exe"
	) else (
		copy Globalops.exe.cfg "%drive%:\PROGRA~2\RivaTu~1\Profiles\"
		start "" "%drive%:\PROGRA~2\RivaTu~1\RTSS.exe"
	)
)

echo riva
pause

REM Start 

echo %globalopspath%
cd %globalopspath%
start /affinity 1 Globalops.exe

pause