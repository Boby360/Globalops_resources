$globalopspath = Get-Content .\globalopspath.txt -Raw 
Invoke-WebRequest -InFile https://ftp.nluug.nl/pub/games/PC/guru3d/afterburner/[Guru3D.com]-RTSS.zip -OutFile .\RTSS.zip
Expand-Archive -Force -LiteralPath '.\RTSS.zip' -DestinationPath '.\'

