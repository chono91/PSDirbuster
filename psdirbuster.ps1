


$check = 1 #loop seed
if ($check -le 3) { #check loop
    $testUrl = "https://www.google.com/654654" #debug testing url
    $dirObject = new-object -TypeName PSObject #create on object to store the response in
    $dirObject | Add-Member -type NoteProperty -name URL -Value $testUrl  #store the url being tested
    try {$response = Invoke-WebRequest -Uri $testUrl -method Get -UserAgent ([Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer)} #try the webrequest (400 codes error)
    catch {$response = $_} # Catch any 400 codes
    if ($response.StatusCode) { #if not a 400 code, store the code
    $dirObject | Add-Member -type NoteProperty -name response -Value $response.StatusCode}
    else { #If error code, store that
    $dirObject | Add-Member -type NoteProperty -name response -Value $response}
    $check ++ #loop increment
    $results.add($dirObject)
    #------------------#
    #the key could be the url, the dirobject could store the other info, something to consider
    #$key = $testUrl
    #$results.add($key, $dirobject)
    #------------------#
}
   
   #Invoke-WebRequest -Uri http://www.google.com -method Get -UserAgent ([Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer)