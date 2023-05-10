$rivapath = Get-Content .\rivapath.txt -Raw
Invoke-WebRequest -Uri https://github.com/Boby360/Globalops_resources/raw/main/profiles/rivatuner-limit100-Globalops.exe.cfg -OutFile .\Globalops.exe.cfg