

#seed
    #Pure brute force option DONE
    #allow different libraries to be selected
    #allow self loaded libraries



function geturl($seed) {
    $alphachars = @("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
    $charset = $alphachars
    while ($seed -ge $charset.count) {
        $url = $charset[($seed % $charset.count)] + $url
        $seed = [math]::floor($seed/$charset.Count-1)
        }
    $url = $charset[$seed] + $url
    return $url
    }


<# another attempt at brute force enumeration
function getseed($a) {
    $input = $a
    $alphachars = @("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
    #$alphachars = @([byte][char]"a", [byte][char]"z")
    $numchars = 0,1,2,3,4,5,6,7,8,9
    #$numchars = @([byte][char]"0", [byte][char]"9")
    $specchars = @('!','@','#','$','%','^','&','*','(',')','_','-','+','=','~','`','<','>',',','.','?','/',"'",'"',':',';','{','[',']','}','|','\')
    #$htmlchars = @([byte][char]'!', [byte][char]'~')

    $seed = $alphachars

    [System.Collections.ArrayList]$inputarray = [char[]]$input
    $lastchar = $inputarray[-1]
    $lastchar = "$lastchar"

    if($seed::indexof($seed,$lastchar) -eq -1) {
        Write-Host "ERROR does not exist in char set"
        } #check if the input is a valid char

    elseif($lastchar -ne $seed[-1]){
        $inputarray[-1] = $seed[$seed::indexof($seed,$lastchar)+1]
        $inputarray = ($inputarray | ?{$_})
        }

    else { 
        $inputarray[-1] = $seed[0]
        $inputarray+=$seed[0]
        }

 #   write-host $inputarray[0] "," $inputarray[1] "," $inputarray[2] "final"
    return $inputarray
}

#>

    <#old asciinumber dependent

    if($asciin -lt $seed[1] -and $asciin -ge $seed[0]){ #test if last char is greater than the lowest valid input and less than the highest valid input -1 (eg. between a and y)
        $asciin ++ #increment by 1 y-> z
        $inputarray[$inputarray.Count-1] = [char]$asciin #over write the last char in the string
        write-host "HERE1" $inputarray #write out debug
        return $inputarray
        }

    elseif($asciin -eq $seed[1]){ #check if last char is equal to the greatest valid input (eg. z)
        $asci = [char]$seed[0] #set var asci to lowest valide input (eg. a)
        $inputarray+=($asci) #add asci to end of input array
        $i = 2 #seed i 
        while ([byte][char]$inputarray[$inputarray.count-$i] -eq $seed[1]){ #check if the char -1 is at the highest,  eg. z -> a
            $asci = [char]$seed[0] #ascii = lowest input eg. a
            $inputarray[$inputarray.count-$i]=($asci) #set the charecter at position -i to the lowest input eg. zz -> za then repetes to aa
            $i ++
            }
        if ([byte][char]$inputarray[$inputarray.count-$i] -lt $seed[1] -and $i -le $inputarray.count){ #if not z, then just increment, not including (i)s greater than count
            $ascii = [byte][char]$inputarray[$inputarray.count-$i] #get ascii
            $ascii ++ #increment
            $inputarray[$inputarray.count-$i] = [char]$ascii #save eg. zzzgzzz -> zzzfaaa

            }
        write-host "HERE2" $inputarray #debug
        return $inputarray
        }

    else{write-host "ERROR"}
}
#>
<# loop to create library for brute force, too big
$d1 = @()
$d2 = @()
$seed = $alphachars
$i = 0

$x = 0
$d1 = $seed
while ($x -lt 3 ){

while ($i -le $d1.count){

    foreach ($char in $d1){
        $v = $d1[$i]
        [void]$d2.add($v + $char)
    }
$i++
}

foreach ($char in $d2) {[void]$d1.add($char)}

$i = 0
$x ++
}

write-host "D1: "$d1
write-host "D2: "$d2
#>

function dirbuster($baseUrl) {#check loop
    #$baseUrl = "https://www.google.com/" #debug testing url
    $maxlength = 2
    $searchUrl = 'aa'
    $seed = 0
    while($searchUrl.length -le $maxLength){
        
        $searchUrl = geturl($seed)
        $seed ++
        
        $testUrl = $baseUrl + $searchurl

        $dirObject = new-object -TypeName PSObject #create on object to store the response in
        $dirObject | Add-Member -type NoteProperty -name URL -Value $testUrl  #store the url being tested
    
        try {$response = Invoke-WebRequest -Uri $testUrl -method Get -UserAgent ([Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer)} #try the webrequest (400 codes error)
        catch {$response = $_} # Catch any 400 codes
    
        if ($response.StatusCode) {
            $dirObject | Add-Member -type NoteProperty -name response -Value $response.StatusCode
            $dirobject | Out-File success.txt -Append
            } #if not a 400 code, store the code 
        else {
            $dirObject | Add-Member -type NoteProperty -name response -Value $response
            $dirObject | Out-File fail.txt -Append
            } #If 400 error code, store that
    
        $check ++ #loop increment
        $results += $dirObject
        
    }
    #------------------#
    #the key could be the url, the dirobject could store the other info, something to consider
    #$key = $testUrl
    #$results.add($key, $dirobject)
    #------------------#
}
   
   #Invoe-WebRequest -Uri http://www.google.com -method Get -UserAgent ([Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer)
