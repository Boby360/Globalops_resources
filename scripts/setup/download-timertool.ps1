$globalopspath = Get-Content .\globalopspath.txt -Raw
##Download might not work due to format
Invoke-WebRequest -InFile https://vvvv.org/sites/all/modules/general/pubdlcnt/pubdlcnt.php?file=https://vvvv.org/sites/default/files/uploads/TimerToolV3.zip&nid=112931 -OutFile $globalopspath\TimerToolV3.zip
Expand-Archive -Force -LiteralPath '.\TimerToolV3.zip' -DestinationPath '.\'

