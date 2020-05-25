<#
RePass Cloud Create-Manifest.ps1
Copyright 2020 RePass Cloud

This product includes software developed at
RePass Cloud (https://repasscloud.com/).
#>

# The intent of this file is to help you generate a JSON file for publishing 
# to the Windows Package Manager repository.

<#########################################
# TLS 1.2
##########################################>
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


<#########################################
# Encoding utf-8
##########################################>
[Console]::OutputEncoding=[System.Text.Encoding]::UTF8


#region LoadFunctions
<#########################################
# This function was designed to pull down a file from even a redirected URL via PowerShell
##########################################>

function Get-RedirectedUrl() {
    
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [uri] $Url,
        [Parameter(Position=1)]
        [Microsoft.PowerShell.Commands.WebRequestSession] $Session=$null
    )

    $request_url=$Url
    $retry=$false
  
    do {
        try {
            $response=Invoke-WebRequest -Method Head -WebSession $Session -Uri $request_url

            if($response.BaseResponse.ResponseUri -ne $null) {
                # PowerShell 5
                $result=$response.BaseResponse.ResponseUri.AbsoluteUri
            } elseif ($response.BaseResponse.RequestMessage.RequestUri -ne $null) {
                # PowerShell Core
                $result=$response.BaseResponse.RequestMessage.RequestUri.AbsoluteUri
            }

            $retry=$false
        } catch {
            if ( ($_.Exception.GetType() -match "HttpResponseException") -and ($_.Exception -match "302") ) {
                $request_url=$_.Exception.Response.Headers.Location.AbsoluteUri
                $retry=$true
            } else {
                throw $_
            }
        }  
    }
    while($retry)

    return $result
}
#endregion LoadFunctions


<#########################################
# Define variables
##########################################>
$OFS="`r`n"  #linebreak
Clear-Host;
$tempFolder='/var/tmp'; 
# Create a temporary file to generate a sha256 value.
Switch ($IsMacOS) {
    $true {
        $Hashfile64=$tempFolder + "/TempfileName64.txt"
        $Hashfile32=$tempFolder + "/TempfileName32.txt"
    }
    Default {
        $tempFolder=$env:TEMP
        $Hashfile64=$tempFolder + "\TempfileName64.txt"
        $Hashfile32=$tempFolder + "\TempfileName32.txt"
    }
}


<#########################################
# Set application name and publisher
#########################################>
$id=$null
while ($id -notmatch '.' -and $id.Length -lt 3) {
    $id=Read-Host 'Enter Publisher/AppName for manifest in format "<Publisher>.<AppName>". For example "Google.Chrome"'
}
$appName=$id.Split('.')[1]
$publisher=$id.Split('.')[0]
while ($publisher.Length -lt 1) {
    $publisher=Read-Host -Prompt 'Publisher name is too short. Enter the publisher'
}
while ($AppName.Length -lt 1) {
    $AppName=Read-Host -Prompt 'Appliation name is too short. Enter the application name'
}
[String]$json8='        "Name": "' + $appName + '",'
[String]$json9='        "Publisher": "' + $publisher + '",'
$OFS="`r`n"  #linebreak
Clear-Host;


<#########################################
# Set application category
#########################################>
$appCategory=$null
while ($appCategory.Length -eq 0) {
    [Int16]$appCategory=Read-Host -Prompt "App categories:`r`n  1 - browser`r`n  2 - business`r`n  3 - entertainment`r`n  4 - graphic & design`r`n  5 - photo`r`n  6 - social`r`n  7 - productivity`r`n  8 - games`r`n  9 - microsoft`r`n`r`nMake selection"
    switch ($appCategory) {
        1 {
            [String]$json2='    "Category": "browser",'
        }
        2 {
            [String]$json2='    "Category": "buiness",'
        }
        3 {
            [String]$json2='    "Category": "entertainment",'
        }
        4 {
            [String]$json2='    "Category": "graphic_design",'
        }
        5 {
            [String]$json2='    "Category": "photo",'
        }
        6 {
            [String]$json2='    "Category": "social",'
        }
        7 {
            [String]$json2='    "Category": "productivity",'
        }
        8 {
            [String]$json2='    "Category": "games",'
        }
        9 {
            [String]$json2='    "Category": "microsoft",'
        }
        Default {
            $appCategory=$null
        }
    }
}
$OFS="`r`n"  #linebreak
Clear-Host;


<#########################################
# Set the Architecture Type and determine installers to use
#########################################>
$architecture=$null
while ($architecture.Length -eq 0) {
    #$architecture=Read-Host -Prompt 'Enter the architecture (x86, x64, x86_x64, arm, arm64, Neutral)'
    [Int16]$architecture=Read-Host -Prompt "Select architecture`r`n  1 x86`r`n  2 x64`r`n  3 x86_x64`r`n`r`nMake selection"
    switch ($architecture) {
        1 {
            [String]$json16='        "Arch": ["x86"],'
            [Int16]$archtype=1
        }
        2 {
            [String]$json16='        "Arch": ["x64"],'
            [Int16]$archtype=2
        }
        3 {
            [String]$json16='        "Arch": ["x64","x86"],'
            [Int16]$archtype=3
        }
        Default {
        }
    }
}
$OFS="`r`n"  #linebreak
Clear-Host;


<#########################################
# Set download URL, FollowURL, SHA256, InstallerType, Switches for x64 and/or x86
#########################################>
switch ($archtype) {
    1 {
        # Prompt for URL32
        $url32=$null
        while ($url32.Length -eq 0) {
            $url32=Read-Host -Prompt 'Enter the 32-bit URL to the installer'
        }
        $OFS="`r`n"  #linebreak
        Clear-Host;

        # Find the URL to be used for downloading
        $absoluteURL32=Get-RedirectedUrl -Url $url32
        if ($absoluteURL32 -notlike $url32) {
            $urlx32=$absoluteURL32
            [String]$json26='                "Url": "' + $url32 + '",'
            [String]$json27='                "FollowUrl": "' + $absoluteURL32 + '",'
        } else {
            $urlx32=$url32
            [String]$json26='                "Url": "' + $url32 + '",'
            [String]$json27='                "FollowUrl": "' + $url32 + '",'
        }

        # Download the installer file
        write-host "Downloading urlx32.  This will take a while...  " -ForeGroundColor Blue
        $WebClient=New-Object System.Net.WebClient
        $WebClient.DownloadFile($urlx32, $Hashfile32)

        # This command will get the sha256 hash
        $Hash32=(Get-FileHash $hashfile32).Hash
        [String]$json28='                "Sha256": "' + $Hash32 + '",'
        $OFS="`r`n"  #linebreak
        Clear-Host;

        [String]$json19='                "Url": "",'
        [String]$json20='                "FollowUrl": "",'
        [String]$json21='                "Sha256": "",'
    }
    2 {
        # Prompt for URL64
        $url64=$null
        while ($url64.Length -eq 0) {
            $url64=Read-Host -Prompt 'Enter the 64-bit URL to the installer'
        }
        $OFS="`r`n"  #linebreak
        Clear-Host;

        # Find the URL to be used for downloading
        $absoluteURL64=Get-RedirectedUrl -Url $url64
        if ($absoluteURL64 -notlike $url64) {
            $urlx64=$absoluteURL64
            [String]$json19='                "Url": "' + $url64 + '",'
            [String]$json20='                "FollowUrl": "' + $absoluteURL64 + '",'
        } else {
            $urlx64=$url64
            [String]$json19='                "Url": "' + $url64 + '",'
            [String]$json20='                "FollowUrl": "' + $url64 + '",'
        }

        # Download the installer file
        write-host "Downloading urlx64.  This will take a while...  " -ForeGroundColor Blue
        $WebClient=New-Object System.Net.WebClient
        $WebClient.DownloadFile($urlx64, $Hashfile64)

        # This command will get the sha256 hash
        $Hash64=(Get-FileHash $hashfile64).Hash
        [String]$json21='                "Sha256": "' + $Hash64 + '",'
        $OFS="`r`n"  #linebreak
        Clear-Host;
        write-host "64-bit file downloaded. Please Fill out required fields."
        $OFS="`r`n"  #linebreak
        Clear-Host;
        [String]$json26='                "Url": "",'
        [String]$json27='                "FollowUrl": "",'
        [String]$json28='                "Sha256": "",'
    }
    3 {
        # Prompt for URL64
        $url64=$null
        while ($url64.Length -eq 0) {
            $url64=Read-Host -Prompt 'Enter the 64-bit URL to the installer'
        }
        $OFS="`r`n"  #linebreak
        Clear-Host;
        # Find the URL to be used for downloading
        $absoluteURL64=Get-RedirectedUrl -Url $url64
        if ($absoluteURL64 -notlike $url64) {
            $urlx64=$absoluteURL64
            [String]$json19='                "Url": "' + $url64 + '",'
            [String]$json20='                "FollowUrl": "' + $absoluteURL64 + '",'
        } else {
            $urlx64=$url64
            [String]$json19='                "Url": "' + $url64 + '",'
            [String]$json20='                "FollowUrl": "' + $url64 + '",'
        }
        # Download the installer file
        write-host "Downloading urlx64.  This will take a while...  " -ForeGroundColor Blue
        $WebClient=New-Object System.Net.WebClient
        $WebClient.DownloadFile($urlx64, $Hashfile64)
        # This command will get the sha256 hash
        $Hash64=(Get-FileHash $hashfile64).Hash
        [String]$json21='                "Sha256": "' + $Hash64 + '",'
        $OFS="`r`n"  #linebreak
        Clear-Host;
        write-host "64-bit file downloaded. Please Fill out required fields."
        $OFS="`r`n"  #linebreak
        Clear-Host;


        # Prompt for URL32
        $url32=$null
        while ($url32.Length -eq 0) {
            $url32=Read-Host -Prompt 'Enter the 32-bit URL to the installer'
        }
        $OFS="`r`n"  #linebreak
        Clear-Host;
        # Find the URL to be used for downloading
        $absoluteURL32=Get-RedirectedUrl -Url $url32
        if ($absoluteURL32 -notlike $url32) {
            $urlx32=$absoluteURL32
            [String]$json26='                "Url": "' + $url32 + '",'
            [String]$json27='                "FollowUrl": "' + $absoluteURL32 + '",'
        } else {
            $urlx32=$url32
            [String]$json26='                "Url": "' + $url32 + '",'
            [String]$json27='                "FollowUrl": "' + $url32 + '",'
        }
        # Download the installer file
        write-host "Downloading urlx32.  This will take a while...  " -ForeGroundColor Blue
        $WebClient=New-Object System.Net.WebClient
        $WebClient.DownloadFile($urlx32, $Hashfile32)
        # This command will get the sha256 hash
        $Hash32=(Get-FileHash $hashfile32).Hash
        [String]$json28='                "Sha256": "' + $Hash32 + '",'
        $OFS="`r`n"  #linebreak
        Clear-Host;
    }
    Default {}
}
$OFS="`r`n"  #linebreak
Clear-Host;


<#########################################
# Ask for Installer type
##########################################>
$InstallerType=$null
while ($InstallerType.Length -eq 0) {
    #$InstallerType=Read-Host -Prompt "Enter the InstallerType. For example: exe, msi, msix, inno, nullsoft"
    [Int16]$InstallerType=Read-Host -Prompt "Select installer type`r`n  1 - MSI`r`n  2 - EXE`r`n`r`nMake selection"
    switch ($InstallerType) {
        1 {
            [String]$InstallerType='msi'
        }
        2 {
            [String]$InstallerType='exe'
        }
        Default {
            $InstallerType=$null
        }
    }
}
[String]$json22_29='                "InstallerType": "' + $InstallerType + '",'
$OFS="`r`n"  #linebreak
Clear-Host;


<#########################################
# Ask for install switches
##########################################>
$InstallSwitches=$null
while ($InstallSwitches.Length -eq 0) {
    $InstallSwitches=Read-Host -Prompt 'Provide install switches or "NA"'
    [String]$json23_30='                "Switches": "' + $InstallSwitches + '"'
}
$OFS="`r`n"  #linebreak
Clear-Host;


<#########################################
# Read in metadata
#########################################>
# Ask for application version number
$version=$null
while ($version.Length -eq 0) {
    $version=Read-Host -Prompt 'Enter the version. For example: 1.0, 1.0.0.0'
    [String]$filename=$version + ".json"
    [String]$json7='        "Version": "' + $version + '",'
}
$OFS="`r`n"  #linebreak
Clear-Host;


<#########################################
# Ask for copyright notice
##########################################>
$Copyright=$null
while ($Copyright.Length -eq 0) {
    $Copyright=Read-Host -Prompt 'Enter the copyright notice. For example: Copyright (c) Microsoft Corporation'
}
[String]$json10='        "Copyright": "' + $Copyright + '",'
$OFS="`r`n"  #linebreak
Clear-Host;


<#########################################
# Ask for license type
##########################################>
$License=$null
while ($License.Length -eq 0) {
    $License=Read-Host -Prompt 'Enter the License type. For example: MIT, BSD, GNU, Proprietary'
}
[String]$json11='        "License": "' + $License + '",'
$OFS="`r`n"  #linebreak
Clear-Host;


<#########################################
# Ask for License URL
##########################################>
$LicenseURL=Read-Host -Prompt '[OPTIONAL] Enter the license URL'
[String]$json12='        "LicenseURL": "' + $LicenseURL + '",'
$OFS="`r`n"  #linebreak
Clear-Host;


<#########################################
# Ask for tags to create the array or blank array
##########################################>

$TagList = @()
do { 
    $Tag=Read-Host -Prompt '[OPTIONAL] Enter any tags that would be useful to discover this tool. For example: zip, c++'
    $TagList += $Tag
} until ($tag -like $null)
if ($TagList -gt 0) {
    [String]$moniker = ''
    $TagList | ForEach-Object {
        [String]$data = '"' + $_ + '",'
        $moniker += $data
    }
    $moniker = $moniker.SubString(0,$moniker.Length-4)
    [String]$json13='        "Tags": [' + $moniker + '],'
} else {
    [String]$json13='        "Tags": [],'
}
$OFS="`r`n"  #linebreak
Clear-Host;


<#########################################
# Ask for description
##########################################>
$Description=Read-Host -Prompt '[OPTIONAL] Enter a description of the application'
$json14='        "Description": "' + $Description + '",'
$OFS="`r`n"  #linebreak
Clear-Host;


<#########################################
# Ask for homepage
#########################################>
$Homepage=Read-Host -Prompt '[OPTIONAL] Enter the Url to the homepage of the application'
$json15='        "Homepage": "' + $Homepage + '",'
$OFS="`r`n"  #linebreak
Clear-Host;


<#########################################
# Set application category
#########################################>
$appCategory=$null
while ($appCategory.Length -eq 0) {
    [Int16]$appCategory=Read-Host -Prompt "App categories:`r`n  1 - browser`r`n  2 - business`r`n  3 - entertainment`r`n  4 - graphic & design`r`n  5 - photo`r`n  6 - social`r`n  7 - productivity`r`n  8 - games`r`n  9 - microsoft`r`n`r`nMake selection"
    switch ($appCategory) {
        1 {
            [String]$json2='    "Category": "browser",'
        }
        2 {
            [String]$json2='    "Category": "buiness",'
        }
        3 {
            [String]$json2='    "Category": "entertainment",'
        }
        4 {
            [String]$json2='    "Category": "graphic_design",'
        }
        5 {
            [String]$json2='    "Category": "photo",'
        }
        6 {
            [String]$json2='    "Category": "social",'
        }
        7 {
            [String]$json2='    "Category": "productivity",'
        }
        8 {
            [String]$json2='    "Category": "games",'
        }
        9 {
            [String]$json2='    "Category": "microsoft",'
        }
        Default {
            $appCategory=$null
        }
    }
}
$OFS="`r`n"  #linebreak
Clear-Host;


<#########################################
# Ask for any dependancies
#########################################>
$Depends=$null
$Depends=Read-Host -Prompt '[OPTIONAL] Enter required dependancy to be met. For example <Publisher>.<AppName>'
if ($Depends.Length -gt 0) {
    [String]$json15_2='        "Depends": "' + $Depends + '",'
} else {
    [String]$json15_2='        "Depends": "",'
}
$OFS="`r`n"  #linebreak
Clear-Host;


<#########################################
# Write the manifest
#########################################>
Write-Host '{'
$json2
Write-Host '    "Manifest": "4.1.3.4",'
Write-Host '    "Release": "1",'
Write-Host '    "Copyright": "Copyright © 2020 RePassCloud.com\nLicensed under the Apache License, Version 2.0 (the \"License\");\nyou may not use this file except in compliance with the License.\nYou may obtain a copy of the License at\n\nhttp://www.apache.org/licenses/LICENSE-2.0\n\nUnless required by applicable law or agreed to in writing, software\ndistributed under the License is distributed on an \"AS IS\" BASIS,\nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\nSee the License for the specific language governing permissions and\nlimitations under the License.",'
Write-Host '    "Id": {'
$json7
$json8
$json9
$json10
$json11
$json12
$json13
$json14
$json15
$json15_2
$json16
Write-Host '        "Installers": {'
Write-Host '            "x64": {'
$json19
$json20
$json21
$json22_29
$json23_30
Write-Host '            },'
Write-Host '            "x86": {'
$json26
$json27
$json28
$json22_29
$json23_30
Write-Host '            }'
Write-Host '        }'
Write-Host '    }'
Write-Host '}'


mkdir -p "/Users/danijeljw/Developer/software-matrix/lib/app/${publisher}/${appName}"
$outFile="/Users/danijeljw/Developer/software-matrix/lib/app/${publisher}/${appName}/${version}.json"

'{' | Out-File $outFile -Append -Encoding utf8
$json2 | Out-File $outFile -Append -Encoding utf8
'    "Manifest": "4.1.3.4",' | Out-File $outFile -Append -Encoding utf8
'    "Release": "1",' | Out-File $outFile -Append -Encoding utf8
'    "Copyright": "Copyright © 2020 RePassCloud.com\nLicensed under the Apache License, Version 2.0 (the \"License\");\nyou may not use this file except in compliance with the License.\nYou may obtain a copy of the License at\n\nhttp://www.apache.org/licenses/LICENSE-2.0\n\nUnless required by applicable law or agreed to in writing, software\ndistributed under the License is distributed on an \"AS IS\" BASIS,\nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\nSee the License for the specific language governing permissions and\nlimitations under the License.",'
'    "Id": {' | Out-File $outFile -Append -Encoding utf8
$json7 | Out-File $outFile -Append -Encoding utf8
$json8 | Out-File $outFile -Append -Encoding utf8
$json9 | Out-File $outFile -Append -Encoding utf8
$json10 | Out-File $outFile -Append -Encoding utf8
$json11 | Out-File $outFile -Append -Encoding utf8
$json12 | Out-File $outFile -Append -Encoding utf8
$json13 | Out-File $outFile -Append -Encoding utf8
$json14 | Out-File $outFile -Append -Encoding utf8
$json15 | Out-File $outFile -Append -Encoding utf8
$json15_2 | Out-File $outFile -Append -Encoding utf8
$json16 | Out-File $outFile -Append -Encoding utf8
'        "Installers": {' | Out-File $outFile -Append -Encoding utf8
'            "x64": {' | Out-File $outFile -Append -Encoding utf8
$json19 | Out-File $outFile -Append -Encoding utf8
$json20 | Out-File $outFile -Append -Encoding utf8
$json21| Out-File $outFile -Append -Encoding utf8
$json22_29 | Out-File $outFile -Append -Encoding utf8
$json23_30 | Out-File $outFile -Append -Encoding utf8
'            },' | Out-File $outFile -Append -Encoding utf8
'            "x86": {' | Out-File $outFile -Append -Encoding utf8
$json26 | Out-File $outFile -Append -Encoding utf8
$json27 | Out-File $outFile -Append -Encoding utf8
$json28 | Out-File $outFile -Append -Encoding utf8
$json22_29 | Out-File $outFile -Append -Encoding utf8
$json23_30 | Out-File $outFile -Append -Encoding utf8
'            }' | Out-File $outFile -Append -Encoding utf8
'        }' | Out-File $outFile -Append -Encoding utf8
'    }' | Out-File $outFile -Append -Encoding utf8
'}' | Out-File $outFile -Append -Encoding utf8

