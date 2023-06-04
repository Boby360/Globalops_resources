@echo off

timeout /t 50
REM Set the duration of the capture (in seconds)
set capture_duration=20

REM Set the IP address to filter
set ip_address=91.14.255.236

REM Set the interface name to capture on (change if needed)
set interface=Ethernet

REM Set the output file name
set output_file=capture.csv

REM Start listing packets using Wireshark
echo Starting packet listing...
echo.

REM Add the headers to the capture.csv file
echo Time,Source,Destination,Length,Info,Packets:,=COUNTA(B2:B1000),LengthSum:,=SUM(D2:D1000) > %output_file%

REM Run the command to start Wireshark and list packets to CSV file
"C:\Program Files (x86)\Wireshark\tshark" -i %interface% -a duration:%capture_duration% -Y "ip.src == %ip_address% && udp" -T fields -e _ws.col.Time -e _ws.col.Source -e _ws.col.Destination -e _ws.col.Length -e _ws.col.Info -E separator=, >> %output_file%
echo.
echo Packet listing completed. Output file: %output_file%

REM Proper final formatting
powershell -Command "$content = Get-Content -Path '%output_file%' -Encoding UTF8; Set-Content -Path '%output_file%' -Value $content -Encoding UTF8"





pause
