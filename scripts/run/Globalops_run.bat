@echo off

set globalopspath="0"
set drive="0"


if exist "C:\PROGRA~1\Crave\Global~1\globalops.exe" (
 set "globalopspath=C:\PROGRA~1\Crave\Global~1\"
 )
if exist "C:\PROGRA~2\Crave\Global~1\globalops.exe" (
 set "globalopspath=C:\PROGRA~2\Crave\Global~1\"
 )

if %globalopspath%=="0" (
echo Install was not found on C drive. What drive is globalops installed on
set /p "drive=Drive letter WITHOUT ":" infront:"
echo %drive%

if exist "%drive%"":\PROGRA~1\Crave\Global~1\globalops.exe" (
set "globalopspath=%drive%:\PROGRA~1\Crave\Global~1\"
 )
)

if exist "%drive%"":\PROGRA~2\Crave\Global~1\globalops.exe" (
set "globalopspath=%drive%:\PROGRA~2\Crave\Global~1\"
 )
)
echo %globalopspath%

:: Look for what GPU you have

start dxdiag /t "%temp%\dxdiag.txt"

:: Wait for dxdiag to finish generating the report
%SYSTEMROOT%\system32\ping 127.0.0.1 -n 7 > nul

for /f "tokens=2 delims=: " %%A in ('%SYSTEMROOT%\System32\findstr /i /c:"Name:" "%temp%\dxdiag.txt"') do (
    set "gpu=%%A"
    if /i "%%A"=="AMD" set isAMD=1
    if /i "%%A"=="NVIDIA" set isNvidia=1
    if /i "%%A"=="Intel" set isIntel=1
)

:: Clean up the temporary file
del "%temp%\dxdiag.txt" /q




:: High Resolution Monitor/Force tool https://github.com/tebjan/TimerTool
:: This will start Minimized and force a 0.5 resolution timer.
:: Stop it after the game is closed.
:: start "" "C:\PathToTool\TimerTool.exe" -t 0.5 -minimized

::Global ops executable PID
setlocal


for /f "tokens=2" %%a in ('%SYSTEMROOT%\System32\tasklist /nh /fi "imagename eq globalops.exe"') do (
  set "pid=%%a"
)

echo Globalops PID: %pid%


:: FPS Limiters:
pause




:: If AMD:
::if %isAMD%==1 (
	::Start Game
	::start %globalopspath%
	::if %drive%=="0" (
		::start "C:\Program Files\AMD\CNext\CNext\radeonsoftware.exe" --fid %pid% --chill 50-60
		::exit
	::)
	::else
	::(
	::	start "%drive%:\Program Files\AMD\CNext\CNext\radeonsoftware.exe" --fid %pid% --chill 50-60
	::	exit
	::)
	
::)


echo 1

REM Nvidia: Requires extra download. https://github.com/Orbmu2k/nvidiaProfileInspector

REM "C:\Program Files (x86)\NVIDIA Corporation\Inspector\nvidiaProfileInspector.exe" -set BaseProfile [PROFILE NAME] -forcepstate:0,[MAXIMUM POWER STATE] -forceGpuClock:0,[MAXIMUM CORE CLOCK] -forceGpuMemClock:0,[MAXIMUM MEMORY CLOCK] -forceRenderAheadLimit:0,[MAX FRAMES RENDERED AHEAD LIMIT] [YOUR GAME'S EXE NAME]

REM Riva Stats Server
if exist "C:\PROGRA~2\RivaTu~1\RTSS.exe" (
	if exist "C:\PROGRA~2\RivaTu~1\Profiles\Globalops.exe.cfg" (
		start "" "C:\PROGRA~2\RivaTu~1\RTSS.exe"
		goto start
	) else (
		copy Globalops.exe.cfg "C:\PROGRA~2\RivaTu~1\Profiles\"
		start "" "C:\PROGRA~2\RivaTu~1\RTSS.exe"
		exit
	)
)

 
if exist "%drive%:\PROGRA~2\RivaTu~1\RTSS.exe" (
	if exist "%drive%:\PROGRA~2\RivaTu~1\Profiles\Globalops.exe.cfg" 
	(
	start "" "%drive%:\PROGRA~2\RivaTu~1\RTSS.exe"
	) else (
	copy Globalops.exe.cfg "%drive%:\PROGRA~2\RivaTu~1\Profiles\"
	start "" "%drive%:\PROGRA~2\RivaTu~1\RTSS.exe"
	)
 )



:start 
echo %globalopspath%
cd %globalopspath%
start "" globalops.exe

pause