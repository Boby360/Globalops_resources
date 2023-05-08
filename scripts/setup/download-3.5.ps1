$globalopspath = Get-Content .\globalopspath.txt -Raw 
Invoke-WebRequest -InFile https://github.com/Boby360/Globalops_resources/raw/main/patches/3.5/globalops-35-manual-installer.zip -OutFile $globalopspath\globalops-35-manual-installer.zip
Expand-Archive -Force -LiteralPath '.\globalops-35-manual-installer.zip' -DestinationPath '.\'

