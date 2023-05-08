$globalopspath = Get-Content .\globalopspath.txt -Raw 
$settings = @{
    "updaterate"        = 'updaterate "20"'
    "inputrate"         = 'inputrate "100.000000"'
    "ConcUpdates"       = 'ConcUpdates "100"'
    "backbuffercount"   = 'backbuffercount "4"'
}

Get-ChildItem -Path "$globalopspath\globalops\profile" -Filter "*.cfg" -Recurse | ForEach-Object {
    (Get-Content $_.FullName) | ForEach-Object {
        foreach ($key in $settings.Keys) {
            if ($_ -match "$key\s+\".*\"") {
                $newLine = $settings[$key]
                $_ = $_ -replace "$key\s+\".*\"", $newLine
            }
        }
        $_
    } | Set-Content $_.FullName
}