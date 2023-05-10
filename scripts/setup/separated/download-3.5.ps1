#$globalopspath = 'C:\Program Files (x86)\Crave\Global Operations\'
Get-Content .\globalopspath.txt -Raw
Echo 'Downloading and installing patch 3.5'
echo $globalopspath
Invoke-WebRequest -Uri 'https://github.com/Boby360/Globalops_resources/raw/main/patches/3.5/globalops-35-manual-installer.zip' -OutFile globalops-35-manual-installer.zip
Expand-Archive -Force -LiteralPath '.\globalops-35-manual-installer.zip' -DestinationPath $globalopspath
echo 'Back to Batch'
