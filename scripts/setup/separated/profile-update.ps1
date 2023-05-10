$globalopspath = Get-Content .\globalopspath.txt -Raw 
#$globalopspath\Globalops\profile\

# Get the list of files in the directory
$files = Get-ChildItem "$globalopspath\Globalops\profile" -Filter *.cfg

# Loop through each file in the directory
foreach ($file in $files) {

    # Read the file contents
    $content = Get-Content $file.FullName

    # Loop through each line in the file
    for ($i = 0; $i -lt $content.Length; $i++) {

        # Check if the line contains one of the target strings
        if ($content[$i] -match "ConcUpdates|updaterate|inputrate|backbuffercount") {

            # Replace the entire line with the new value
            if ($content[$i] -match "ConcUpdates") {
                $content[$i] = '"ConcUpdates" "100"'
            }
            elseif ($content[$i] -match "updaterate") {
                $content[$i] = '"updaterate" "20"'
            }
            elseif ($content[$i] -match "inputrate") {
                $content[$i] = '"inputrate" "100.000000"'
            }
            elseif ($content[$i] -match "backbuffercount") {
                $content[$i] = '"backbuffercount" "4"'
            }
        }
    }

    # Write the modified contents back to the file
    $content | Set-Content $file.FullName
}
