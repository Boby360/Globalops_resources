$globalopspath = Get-Content .\globalopspath.txt -Raw
Invoke-WebRequest -Uri https://vvvv.org/sites/all/modules/general/pubdlcnt/pubdlcnt.php?file=https://vvvv.org/sites/default/files/uploads/TimerToolV3.zip -OutFile $globalopspath\Tools\TimerToolV3.zip
Expand-Archive -Force -LiteralPath "$globalopspath\Tools\TimerToolV3.zip" -DestinationPath "$globalopspath\Tools\"

