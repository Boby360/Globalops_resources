@echo off
setlocal enabledelayedexpansion
echo Global Operations Cd key randomizer
echo By Boby
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

powershell -executionpolicy bypass -Command "$cdkey = !start!!randomNumber1!!randomNumber2!2!randomNumber3!!randomNumber4!; Set-ItemProperty -Path '!key!' -Name '!value!' -Value $cdkey"


echo CD key randomized!