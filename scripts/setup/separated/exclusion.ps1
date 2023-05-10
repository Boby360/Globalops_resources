$ExclusionPath = Get-Content .\globalopspath.txt -Raw 
Add-MpPreference -ExclusionPath $ExclusionPath
