[System.Collections.ArrayList]$ArrayList=@()


$OFS="`r`n"


$ArrayList.Add('{') | Out-Null
$ArrayList.Add($(Export-NuspecValue -NuspecURI 'https://raw.githubusercontent.com/chocolatey-community/chocolatey-coreteampackages/master/automatic/cutepdf/cutepdf.nuspec')) | Out-Null

$ArrayList