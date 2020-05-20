[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# The intent of this file is to help you generate a YAML file for publishing 
# to the Windows Package Manager repository.

# define variables
$OFS = "`r`n"  #linebreak
$tempFolder=$env:TEMP; 
# Create a temporary file to generate a sha256 value.
$Hashfile=$tempFolder + "\TempfileName.txt"

# Prompt for URL
While ($url.Length -eq 0) {
$url = Read-Host -Prompt 'Enter the URL to the installer' }
$OFS

write-host "Downloading URL.  This will take awhile...  "  -ForeGroundColor Blue 
$WebClient = New-Object System.Net.WebClient
# This downloads the installer
$WebClient.DownloadFile($URL, $Hashfile)

# This command will get the sha256 hash
$Hash=get-filehash $hashfile


$string = "Url: " + $URL  ;
Write-Output $string
$string =  "Sha256: " + $Hash.Hash
$string
$OFS
write-host "File downloaded. Please Fill out required fields. "   

##########################################
# Read in metadata
##########################################

While ($id.Length -eq 0) {
write-host  'Enter the package Id, in the following format <Publisher.Appname>' 
$id = Read-Host -Prompt 'For example: Microsoft.Excel'
}

$host.UI.RawUI.ForegroundColor = "White"
While ($publisher.Length  -eq 0) {
$publisher = Read-Host -Prompt 'Enter the publisher'
}

While ($AppName.Length -eq 0) {
$AppName = Read-Host -Prompt 'Enter the application name'
}

While ($version.Length  -eq 0) {
$version = Read-Host -Prompt 'Enter the version. For example: 1.0, 1.0.0.0'
$filename=$version + ".yaml"
}

While ($License.Length  -eq 0) {
$License = Read-Host -Prompt 'Enter the License, For example: MIT, or Copyright (c) Microsoft Corporation'
}

While ($InstallerType.Length  -eq 0) {
$InstallerType = Read-Host -Prompt   'Enter the InstallerType. For example: exe, msi, msix, inno, nullsoft'
}

While ($architecture.Length  -eq 0) {
$architecture = Read-Host -Prompt 'Enter the architecture (x86, x64, arm, arm64, Neutral)'
} 

$LicenseUrl = Read-Host -Prompt   '[OPTIONAL] Enter the license URL'
$AppMoniker = Read-Host -Prompt   '[OPTIONAL] Enter the AppMoniker (friendly name). For example: vscode'
$Tags = Read-Host -Prompt   '[OPTIONAL] Enter any tags that would be useful to discover this tool. For example: zip, c++'
$Homepage = Read-Host -Prompt   '[OPTIONAL] Enter the Url to the homepage of the application'
$Description = Read-Host -Prompt '[OPTIONAL] Enter a description of the application'



##########################################
# Write  metadata
##########################################

$OFS
$string = "Id: " + $id
write-output $string | out-file $filename
write-host "Id: "  -ForeGroundColor Blue -NoNewLine
write-host $id  -ForeGroundColor White  

$string = "Version: " + $Version
write-output $string | out-file $filename -append
write-host "Version: "  -ForeGroundColor Blue -NoNewLine
write-host $Version -ForeGroundColor White


$string = "Name: " + $AppName
write-output $string | out-file $filename -append
write-host "Name: "  -ForeGroundColor Blue -NoNewLine
write-host $AppName  -ForeGroundColor White

$string = "Publisher: " + $Publisher
write-output $string | out-file $filename -append
write-host "Publisher: "  -ForeGroundColor Blue -NoNewLine
write-host $Publisher -ForeGroundColor White

$string = "License: " + $License
write-output $string | out-file $filename -append
write-host "License: "  -ForeGroundColor Blue -NoNewLine
write-host $License  -ForeGroundColor White

if (!($LicenseUrl.length -eq 0)) {

$string = "LicenseUrl: " + $LicenseUrl
write-output $string | out-file $filename -append
write-host "LicenseUrl: "  -ForeGroundColor Blue -NoNewLine
write-host $LicenseUrl  -ForeGroundColor White

}
if (!($AppMoniker.length -eq 0)) {

$string = "AppMoniker: " + $AppMoniker
write-output $string | out-file $filename -append
write-host "AppMoniker: "  -ForeGroundColor Blue -NoNewLine
write-host $AppMoniker  -ForeGroundColor White

}
if (!($Commands.length -eq 0)) {

$string = "Commands: " + $Commands
write-output $string | out-file $filename -append
write-host "Commands: "  -ForeGroundColor Blue -NoNewLine
write-host $Commands  -ForeGroundColor White

}
if (!($Tags.length -eq 0)) {

$string = "Tags: " + $Tags
write-output $string | out-file $filename -append
write-host "Tags: "  -ForeGroundColor Blue -NoNewLine
write-host $Tags  -ForeGroundColor White

}


if (!($Description.length -eq 0)) {

$string = "Description: " + $Description
write-output $string | out-file $filename -append
write-host "Description: "  -ForeGroundColor Blue -NoNewLine
write-host $Description  -ForeGroundColor White

}



if (!($Homepage.Length -eq 0))  {

$string = "Homepage: "+ $Homepage
write-output $string | out-file $filename -append
write-host "Homepage: "  -ForeGroundColor Blue -NoNewLine
write-host $Homepage  -ForeGroundColor White

}

write-output "Installers:" | out-file $filename -append 


$string = "  - Arch: " + $architecture
write-output $string | out-file $filename -append
write-host "Arch: "  -ForeGroundColor Blue -NoNewLine
write-host $architecture  -ForeGroundColor White


$string = "    Url: " + $Url
write-output $string | out-file $filename -append
write-host "Url: "  -ForeGroundColor Blue -NoNewLine
write-host $Url -ForeGroundColor White

$string = "    Sha256: " + $Hash.Hash
write-output $string | out-file $filename -append
write-host "Sha256 "  -ForeGroundColor Blue -NoNewLine
write-host $Hash.Hash  -ForeGroundColor White

$string = "    InstallerType: " + $InstallerType
write-output $string | out-file $filename -append
write-host "InstallerType "  -ForeGroundColor Blue -NoNewLine
write-host $InstallerType  -ForeGroundColor White


$string = "Yaml file created:  " + $filename
write-output $string

write-host "Now place this file in the following location: \manifests\<publisher>\<appname>  " 