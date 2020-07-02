<#
RePass Cloud Create-Manifest.ps1
Copyright 2020 RePass Cloud Pty Ltd

This product includes software developed at
RePass Cloud (https://repasscloud.com/).
#>

# The intent of this file is to help you generate a JSON file for publishing 
# to the Windows Package Manager repository.

# Set TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Encoding utf-8
[Console]::OutputEncoding=[System.Text.Encoding]::UTF8
$OFS="`r`n"  #linebreak

#region LoadFunctions
# This function was designed to pull down a file from even a redirected URL via PowerShell
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

            if ($response.BaseResponse.ResponseUri -ne $null) {
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
            } elseif ( ($_.Exception.GetType() -match "HttpResponseException") -and ($_.Exception -match "403") ) {
                $result=($request_url).OriginalString
                $retry=$false
            } else {
                throw $_
            }
        }  
    }
    while($retry)

    return $result
}
function Get-UrlStatusCode() {
    #Source: https://stackoverflow.com/a/20262872
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [Uri] $Url
    )
    # First we create the request
    $HTTP_Request=[System.Net.WebRequest]::Create('https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v7.8.8/npp.7.8.8.Installer.x64.exe')
    # We then get a response from the site.
    $HTTP_Response=$HTTP_Request.GetResponse()
    # We then get the HTTP code as an integer.
    $HTTP_Status = [int]$HTTP_Response.StatusCode
    return $HTTP_Status
    # Finally, we clean up the http request by closing it.
    if ($null -eq $HTTP_Response) { } else { $HTTP_Response.Close() }
}
function New-LanguageInstallerSelection () {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [String] $Language
    )

    $architecture=$null
    do {
        Clear-Host;
        $ArchPrompt = @"
For installer language ${Language}, select architecture
  [1]  x86
  [2]  x64
  [3]  x86_x64
  
  Make selection
"@
        [Int16]$architecture=Read-Host -Prompt $ArchPrompt
        Switch ($architecture) {
            1 { [Int16]$archType=1 }  #x64
            2 { [Int16]$archType=2 }  #x86
            3 { [Int16]$archType=3 }  #x86_x64
            Default { }
        }
        
    } until ($architecture -lt 4 -and $architecture -gt 0)
    return [int]$archType
    Clear-Host;
}
#endregion LoadFunctions


# Define variables
Clear-Host;
# Create a temporary file to generate a sha256 value.
Switch ($IsMacOS) {  #system is MacOS
    $true {
        $tempFolder='/var/tmp'; 
        $Hashfile64=$tempFolder + "/TempfileName64.txt"
        $Hashfile32=$tempFolder + "/TempfileName32.txt"
    }
    Default { }
}
Switch ($IsLinux) {  #system is Linux
    $true {
        $tempFolder='/var/tmp'; 
        $Hashfile64=$tempFolder + "/TempfileName64.txt"
        $Hashfile32=$tempFolder + "/TempfileName32.txt"
    }
    Default { }
}
Switch ($IsWindows) {  #system is WindowsOS
    $true {
        $tempFolder=$env:TEMP
        $Hashfile64=$tempFolder + "\TempfileName64.txt"
        $Hashfile32=$tempFolder + "\TempfileName32.txt"
    }
    Default { }
}

# Set FillerTexts for x86 and x64
$fillerText_x86 = @"
                "x86": {
                    "Url": "",
                    "FollowUrl": "",
                    "Sha256": "",
                    "InstallerType": "",
                   "Switches": ""
                }
"@  + $OFS
$fillerText_x64 = @"
                "x64": {
                    "Url": "",
                    "FollowUrl": "",
                    "Sha256": "",
                    "InstallerType": "",
                    "Switches": ""
                },
"@  + $OFS


# Set application category $Json2
$appCategory=$null
do {
    Clear-Host;
    [Int16]$appCategory=Read-Host -Prompt "Application category`r`n  [1]  browser`r`n  [2]  business`r`n  [3]  entertainment`r`n  [4]  graphic & design`r`n  [5]  photo`r`n  [6]  social`r`n  [7]  productivity`r`n  [8]  games`r`n  [9]  microsoft`r`n`r`nMake selection"
    Switch ($appCategory) {
        1 { [String]$Json2='    "Category": "browser",' }
        2 { [String]$Json2='    "Category": "buiness",' }
        3 { [String]$Json2='    "Category": "entertainment",' }
        4 { [String]$Json2='    "Category": "graphic_design",' }
        5 { [String]$Json2='    "Category": "photo",' }
        6 { [String]$Json2='    "Category": "social",' }
        7 { [String]$Json2='    "Category": "productivity",' }
        8 { [String]$Json2='    "Category": "games",' }
        9 { [String]$Json2='    "Category": "microsoft",' }
        Default {
            $appCategory=$null #reassign to $null if nothing selected
        }
    }
} until ($appCategory -lt 10 -and $appCategory -gt 0)
Clear-Host;


# Set application name and publisher ~> this gets used in json8, json9
$id=$null
do {
    Clear-Host;
    $id=Read-Host 'Enter Publisher/AppName for manifest in format "<Publisher>.<AppName>". For example "Google.Chrome"'
} until ($id -match '.*\w\.\w.*'-and $id.Length -gt 3)
$appName=$id.Split('.')[1]
$publisher=$id.Split('.')[0]
if ($publisher.Length -lt 1) {
    do {
        $publisher=Read-Host -Prompt 'Publisher name is too short. Enter the publisher'
    } until ($publisher.Length -gt 1)  #expect this to be prevented by earlier code
}
if ($appName.Length -lt 1) {
    do {
        $appName=Read-Host -Prompt 'Application name is too short. Enter the application name'
    } until ($appName.Length -gt 1)  #expect this to be prevented by earlier code
}


# Ask for application version number
$version=$null
do {
    Clear-Host;
    $version=Read-Host -Prompt 'Enter the version. For example: 1.0, 1.0.0.0'
} until ($version -match [System.Text.RegularExpressions.Regex]::New('\w\.\w') -and $version -match '[a-zA-Z0-9]$')
[String]$filename=$version + ".json"  #Set filename used for output
Clear-Host;


# Ask for license type of application $Json11
$License=$null
$LicensePrompt = @"
Select Application License type
  [1]  MIT
  [2]  BSD
  [3]  GNU
  [4]  Apache 2.0
  [5]  GPLv2
  [6]  LGPLv2.1+
  [7]  Proprietary
  [8]  Other
  
  Make selection
"@
do {
    Clear-Host;
    $License=Read-Host -Prompt $LicensePrompt
    Switch ($License) {
        1 { $LicenseType='MIT'; }
        2 { $LicenseType='BSD'; }
        3 { $LicenseType='GNU'; }
        4 { $LicenseType='Apache 2.0'; }
        5 { $LicenseType='GPLv2'; }
        6 { $LicenseType='LGPLv2.1+'; }
        7 { $LicenseType='Proprietary'; }
        8 { $LicenseType='Other'; }
        Default {
            #[VOID]
        }
    }
} until ($License -gt 0 -and $License -lt 8)
Clear-Host;


# Ask for License URL [OPTIONAL] $Json12
$LicenseURL=$null
do {
    Clear-Host;
    $LicenseURL=Read-Host -Prompt '[OPTIONAL] Enter the license URL'
} until ($LicenseURL.Length -eq 0 -or (Get-UrlStatusCode -Url $LicenseURL) -like 200)
Clear-Host;


# Ask for License URL [REQUIRED]/[OPTIONAL] $Json10
Switch ($LicenseType) {
    'Proprietary' {  #Required for Proprietary application license
        $AppCopyright=$null
        do {
            Clear-Host;
            $AppCopyright=Read-Host -Prompt $('[REQUIRED] Enter the app Copyright notice with "(c)" or "' + [char]0x00A9 + '"')
        } until ($AppCopyright.Length -gt 4 -and $AppCopyright -match [System.Text.RegularExpressions.Regex]::New([char]0x00A9) -or $AppCopyright -match [System.Text.RegularExpressions.Regex]::New('(c)'))
        Clear-Host;
    }
    Default {
        $AppCopyright=$null
        do {
            Clear-Host;
            $AppCopyright=Read-Host -Prompt $('[OPTIONAL] Enter the app Copyright notice with "(c)" or "' + [char]0x00A9 + '"')
        } until ($AppCopyright.Length -eq 0 -or $AppCopyright -match [System.Text.RegularExpressions.Regex]::New([char]0x00A9) -or $AppCopyright -match [System.Text.RegularExpressions.Regex]::New('(c)'))
        Clear-Host;
    }
}


# Ask for tags to create the array or blank array $Json13
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
    [String]$Json13='        "Tags": [' + $moniker + '],'
} else {
    [String]$Json13='        "Tags": [],'
}
Clear-Host;


# Ask for Description [OPTIONAL] $Json14
$AppDescription=$null
do {
    Clear-Host;
    $AppDescription=Read-Host -Prompt '[OPTIONAL] Provide a description of the application (max 255 characters)'
} until ($AppDescription.Length -eq 0 -or $AppDescription.Length -gt 4 -and $AppDescription.Length -lt 256)
Clear-Host;


# Ask for License URL [OPTIONAL] $Json12
$AppHomepage=$null
do {
    Clear-Host;
    $AppHomepage=Read-Host -Prompt '[OPTIONAL] Provide the Application homepage URL'
} until ($AppHomepage.Length -eq 0 -or (Get-UrlStatusCode -Url $AppHomepage) -like 200)
Clear-Host;


# Ask for languages to create the array or blank array
[System.Collections.ArrayList]$LangList = @()  #Create blank array
do {
    Clear-Host;
    $Lang=Read-Host -Prompt '[OPTIONAL] Enter language code (for example "en-US" for English US, etc) '
    $LangList += $Lang
} until ($Lang -like $null)
if ($LangList.Count -gt 1) {
    [String]$LangMoniker = ''
    $LangList | ForEach-Object {
        [String]$LangData = '"' + $_ + '",';
        $LangMoniker += $LangData
    }
    $LangMoniker = $LangMoniker.SubString(0,$LangMoniker.Length-4)
    [String]$Json16='        "Languages": [' + $LangMoniker + '],'
} else {
    [System.Collections.ArrayList]$LangList = @('en-US')
    [String]$LangMoniker='"en-US"'
    [String]$Json16='        "Languages": [' + $LangMoniker + '],'
}
Clear-Host;


# Ask for any dependancies $Json17
$Depends=$null
do {
    Clear-Host;
    $Depends=Read-Host -Prompt '[OPTIONAL] Enter required dependancy to be met. For example <Publisher>.<AppName>'
} until ($Depends.Length -eq 0 -or ($Depends -match [System.Text.RegularExpressions.Regex]::New('\w\.\w') -and $Depends -match '[a-zA-Z0-9]$'))
Clear-Host;



[String]$Json1='{'
[String]$Json2  #No need to apply data, built in the funtion
[String]$Json3='    "Manifest": "4.2.4.6",'  #This will be updated in the future to read live from the repo
[String]$Json4='    "Nuspec": false,'  #This will be updated to change later
[String]$Json5='    "Copyright": "Copyright © 2020 RePassCloud.com\nLicensed under the Apache License, Version 2.0 (the \"License\");\nyou may not use this file except in compliance with the License.\nYou may obtain a copy of the License at\n\nhttp://www.apache.org/licenses/LICENSE-2.0\n\nUnless required by applicable law or agreed to in writing, software\ndistributed under the License is distributed on an \"AS IS\" BASIS,\nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\nSee the License for the specific language governing permissions and\nlimitations under the License.",'
[String]$Json6='    "Id": {'
[String]$Json7='        "Version": "' + $version + '",'
[String]$Json8='        "Name": "' + $appName + '",'
[String]$Json9='        "Publisher": "' + $publisher + '",'
[String]$Json10='        "AppCopyright": "' + $AppCopyright + '",'
[String]$Json11='        "License": "' + $LicenseType + '",'
[String]$Json12='        "LicenseURL": "' + $LicenseURL + '",'
[String]$Json13  #No need to apply data, built in the funtion
[String]$Json14='        "Description": "' + $AppDescription + '",'
[String]$Json15='        "Homepage": "' + $AppHomepage + '",'
[String]$Json16  #No need to apply data, built in the funtion
[String]$Json17='        "Depends": "' + $Depends + '",'
[String]$Json19='        "Installers": {'
Clear-Host;



[String]$Json20_34 = ''
# Request ArchType to install
$LangList| ForEach-Object {
    $Lang=$_;
    if ($Lang -notlike $null ){
        $archSelection = New-LanguageInstallerSelection -Language $Lang
        $Json20_34 += '            "' + $Lang + '": {' + $OFS
    }
   
    Switch ($archSelection) {
        1 {
            # Add the filler text
            $Json20_34 += $fillerText_x64

            # Prompt for URL32
            $url32=$null
            do {
                Clear-Host;
                $url32=Read-Host -Prompt 'Enter the 32-bit URL to the installer'
            } until ($url32.Length -gt 0 -and (Get-UrlStatusCode -Url $url32) -like 200)
            Clear-Host;
    
            # Find the URL to be used for downloading
            $absoluteURL32=Get-RedirectedUrl -Url $url32
            if ($absoluteURL32 -notlike $url32) {
                $urlx32=$absoluteURL32
                $Json20_34 += '                "x86": {' + $OFS
                $Json20_34 += '                    "Url": "' + $url32 + '",' + $OFS
                $Json20_34 += '                    "FollowUrl": "' + $absoluteURL32 + '",' + $OFS
            } else {
                $urlx32=$url32
                $Json20_34 += '                "x86": {' + $OFS
                $Json20_34 += '                    "Url": "' + $url32 + '",' + $OFS
                $Json20_34 += '                    "FollowUrl": "' + $urlx32 + '",' + $OFS
            }
    
            # Download the installer file
            Write-Host "Downloading urlx32.  This will take a while...  " -ForeGroundColor Yellow
            $WebClient=New-Object System.Net.WebClient
            $WebClient.DownloadFile($urlx32, $Hashfile32)
    
            # This command will get the sha256 hash
            $Hash32=(Get-FileHash $hashfile32).Hash
            $Json20_34 += '                    "Sha256": "' + $Hash32 + '",' + $OFS
            Clear-Host;

            # Set the Installer type
            $InstallerType=$null
            do {
                Clear-Host;
                [String]$InstallerPrompt = @"
Select installer type
  [1]  MSI
  [2]  EXE
  
  Make selection
"@
                [Int16]$InstallerType=Read-Host -Prompt $InstallerPrompt
                Switch ($InstallerType) {
                    1 {
                        $Json20_34 += '                    "InstallerType": "msi",' + $OFS
                    }
                    2 {
                        $Json20_34 += '                    "InstallerType": "exe",' + $OFS
                    }
                    3 {
                        $Json20_34 += '                    "InstallerType": "msix",' + $OFS
                    }
                    Default {
                    }
                }
            } until ($InstallerType -lt 3 -and $InstallerType -gt 0)
            Clear-Host;

            # Set silent install switches
            $InstallSwitches=$null
            do {
                Clear-Host;
                $InstallSwitches=Read-Host -Prompt '[OPTIONAL] Provide silent install switches or press Enter to ignore'
            } until ($InstallSwitches -match [System.Text.RegularExpressions.Regex]::New('\W\w') -or $InstallSwitches -match [System.Text.RegularExpressions.Regex]::New(''))
            [String]$Json20_34 += '                    "Switches": "' + $InstallSwitches + '"' + $OFS
            $Json20_34 += '                }' + $OFS
            Clear-Host;
        }
        2 {
            # Prompt for URL64
            $url64=$null
            do {
                Clear-Host;
                $url64=Read-Host -Prompt 'Enter the 64-bit URL to the installer'
            } until ($url64.Length -gt 0 -and (Get-UrlStatusCode -Url $url64) -like 200)
            Clear-Host;
    
            # Find the URL to be used for downloading
            $absoluteURL64=Get-RedirectedUrl -Url $url64
            if ($absoluteURL64 -notlike $url64) {
                $urlx64=$absoluteURL64
                $Json20_34 += '                "x64": {' + $OFS
                $Json20_34 += '                    "Url": "' + $url64 + '",' + $OFS
                $Json20_34 += '                    "FollowUrl": "' + $absoluteURL64 + '",' + $OFS
            } else {
                $urlx64=$url64
                $Json20_34 += '                "x64": {' + $OFS
                $Json20_34 += '                    "Url": "' + $url64 + '",' + $OFS
                $Json20_34 += '                    "FollowUrl": "' + $urlx64 + '",' + $OFS
            }
    
            # Download the installer file
            Write-Host "Downloading urlx64.  This will take a while...  " -ForeGroundColor Yellow
            $WebClient=New-Object System.Net.WebClient
            $WebClient.DownloadFile($urlx64, $Hashfile64)
    
            # This command will get the sha256 hash
            $Hash64=(Get-FileHash $hashfile64).Hash
            $Json20_34 += '                    "Sha256": "' + $Hash64 + '",' + $OFS
            Clear-Host;

            # Set the Installer type
            $InstallerType=$null
            do {
                Clear-Host;
                [String]$InstallerPrompt = @"
Select installer type
  [1]  MSI
  [2]  EXE
  
  Make selection
"@
                [Int16]$InstallerType=Read-Host -Prompt $InstallerPrompt
                Switch ($InstallerType) {
                    1 {
                        $Json20_34 += '                    "InstallerType": "msi",' + $OFS
                    }
                    2 {
                        $Json20_34 += '                    "InstallerType": "exe",' + $OFS
                    }
                    3 {
                        $Json20_34 += '                    "InstallerType": "msix",' + $OFS
                    }
                    Default {
                    }
                }
            } until ($InstallerType -lt 3 -and $InstallerType -gt 0)
            Clear-Host;

            # Set silent install switches
            $InstallSwitches=$null
            do {
                Clear-Host;
                $InstallSwitches=Read-Host -Prompt '[OPTIONAL] Provide silent install switches or press Enter to ignore'
            } until ($InstallSwitches -match [System.Text.RegularExpressions.Regex]::New('\W\w') -or $InstallSwitches -match [System.Text.RegularExpressions.Regex]::New(''))
            [String]$Json20_34 += '                    "Switches": "' + $InstallSwitches + '",' + $OFS
            

            $Json20_34 += '                },' + $OFS
            Clear-Host;

            # Add the filler text
            $Json20_34 += $fillerText_x86
        }
        3 {
            #
            #  x64 of x86_x64
            #
        
            # Prompt for URL64
            $url64=$null
            do {
                Clear-Host;
                $url64=Read-Host -Prompt 'Enter the 64-bit URL to the installer'
            } until ($url64.Length -gt 0 -and (Get-UrlStatusCode -Url $url64) -like 200)  #URL must be valid and exist, tests to confirm is valid
            Clear-Host;
        
            # Find the URL to be used for downloading
            $absoluteURL64=Get-RedirectedUrl -Url $url64
            if ($absoluteURL64 -notlike $url64) {
                $urlx64=$absoluteURL64
                $Json20_34 += '                "x64": {' + $OFS
                $Json20_34 += '                    "Url": "' + $url64 + '",' + $OFS
                $Json20_34 += '                    "FollowUrl": "' + $absoluteURL64 + '",' + $OFS
            } else {
                $urlx64=$url64
                $Json20_34 += '                "x64": {' + $OFS
                $Json20_34 += '                    "Url": "' + $url64 + '",' + $OFS
                $Json20_34 += '                    "FollowUrl": "' + $urlx64 + '",' + $OFS
            }
        
            # Download the installer file
            Write-Host "Downloading urlx64.  This will take a while...  " -ForeGroundColor Yellow
            $WebClient=New-Object System.Net.WebClient
            $WebClient.DownloadFile($urlx64, $Hashfile64)
        
            # Set SHA256 and SHA512 of the downloaded file
            $Hash64=(Get-FileHash -Path $hashfile64 -Algorithm SHA256).Hash
            $Json20_34 += '                    "Sha256": "' + $Hash64 + '",' + $OFS
            $Hash64=(Get-FileHash -Path $hashfile64 -Algorithm SHA512).Hash
            $Json20_34 += '                    "Sha512": "' + $Hash64 + '",' + $OFS
            Clear-Host;
        
            # Set the Installer type
            $InstallerType=$null
            do {
                Clear-Host;
                [String]$InstallerPrompt = @"
Select installer type
  [1]  MSI
  [2]  EXE

  Make selection
"@
                [Int16]$InstallerType=Read-Host -Prompt $InstallerPrompt
                Switch ($InstallerType) {
                    1 {
                        $Json20_34 += '                    "InstallerType": "msi",' + $OFS
                    }
                    2 {
                        $Json20_34 += '                    "InstallerType": "exe",' + $OFS
                    }
                    3 {
                        $Json20_34 += '                    "InstallerType": "msix",' + $OFS
                    }
                    Default {
                    }
                }
            } until ($InstallerType -lt 3 -and $InstallerType -gt 0)
            Clear-Host;
        
            # Set silent install switches
            $InstallSwitches=$null
            do {
                Clear-Host;
                $InstallSwitches=Read-Host -Prompt '[OPTIONAL] Provide silent install switches or press Enter to ignore'
            } until ($InstallSwitches -match [System.Text.RegularExpressions.Regex]::New('\W\w') -or $InstallSwitches -match [System.Text.RegularExpressions.Regex]::New(''))
            [String]$Json20_34 += '                    "Switches": "' + $InstallSwitches + '"' + $OFS
            $Json20_34 += '                },' + $OFS
            Clear-Host;
        
        
            #
            #  x86 of x86_x64
            #
        
            # Prompt for URL32
            $url32=$null
            do {
                Clear-Host;
                $url32=Read-Host -Prompt 'Enter the 32-bit URL to the installer'
            } until ($url32.Length -gt 0 -and (Get-UrlStatusCode -Url $url32) -like 200)
            Clear-Host;
        
            # Find the URL to be used for downloading
            $absoluteURL32=Get-RedirectedUrl -Url $url32
            if ($absoluteURL32 -notlike $url32) {
                $urlx32=$absoluteURL32
                $Json20_34 += '                "x86": {' + $OFS
                $Json20_34 += '                    "Url": "' + $url32 + '",' + $OFS
                $Json20_34 += '                    "FollowUrl": "' + $absoluteURL32 + '",' + $OFS
            } else {
                $urlx32=$url32
                $Json20_34 += '                "x86": {' + $OFS
                $Json20_34 += '                    "Url": "' + $url32 + '",' + $OFS
                $Json20_34 += '                    "FollowUrl": "' + $urlx32 + '",' + $OFS
            }
        
            # Download the installer file
            Write-Host "Downloading urlx32.  This will take a while...  " -ForeGroundColor Yellow
            $WebClient=New-Object System.Net.WebClient
            $WebClient.DownloadFile($urlx32, $Hashfile32)
        
            # Set SHA256 and SHA512 of the downloaded file
            $Hash32=(Get-FileHash -Path $hashfile32 -Algorithm SHA256).Hash
            $Json20_34 += '                    "Sha256": "' + $Hash32 + '",' + $OFS
            $Hash32=(Get-FileHash -Path $hashfile32 -Algorithm SHA512).Hash
            $Json20_34 += '                    "Sha512": "' + $Hash32 + '",' + $OFS
            Clear-Host;
        
            # Set the Installer type
            $InstallerType=$null
            do {
                Clear-Host;
                [String]$InstallerPrompt = @"
Select installer type
  [1]  MSI
  [2]  EXE

  Make selection
"@
                [Int16]$InstallerType=Read-Host -Prompt $InstallerPrompt
                Switch ($InstallerType) {
                    1 {
                        $Json20_34 += '                    "InstallerType": "msi",' + $OFS
                    }
                    2 {
                        $Json20_34 += '                    "InstallerType": "exe",' + $OFS
                    }
                    3 {
                        $Json20_34 += '                    "InstallerType": "msix",' + $OFS
                    }
                    Default {
                    }
                }
            } until ($InstallerType -lt 3 -and $InstallerType -gt 0)
            Clear-Host;
        
            # Set silent install switches
            $InstallSwitches=$null
            do {
                Clear-Host;
                $InstallSwitches=Read-Host -Prompt '[OPTIONAL] Provide silent install switches or press Enter to ignore'
            } until ($InstallSwitches -match [System.Text.RegularExpressions.Regex]::New('\W\w') -or $InstallSwitches -match [System.Text.RegularExpressions.Regex]::New(''))
            [String]$Json20_34 += '                    "Switches": "' + $InstallSwitches + '"' + $OFS
            $Json20_34 += '                }' + $OFS
            Clear-Host;
        }
        Default {
        }
    }
    Clear-Host;
}
$Json20_34 += '            }' + $OFS
$Json20_34 += '        }' + $OFS
$Json20_34 += '    }' + $OFS
$Json20_34 += '}' + $OFS


if (-not(Test-Path -Path "C:\tmp\software-matrix\app\${publisher}\${appName}")) {
    mkdir -p "C:\tmp\software-matrix\app\${publisher}\${appName}"
}
$outFile="C:\tmp\software-matrix\app\${publisher}\${appName}\${filename}"
$Json1 | Out-File $outFile -Append -Encoding utf8
$Json2 | Out-File $outFile -Append -Encoding utf8
$Json3 | Out-File $outFile -Append -Encoding utf8
$Json4 | Out-File $outFile -Append -Encoding utf8
$Json5 | Out-File $outFile -Append -Encoding utf8
$Json6 | Out-File $outFile -Append -Encoding utf8
$Json7 | Out-File $outFile -Append -Encoding utf8
$Json8 | Out-File $outFile -Append -Encoding utf8
$Json9 | Out-File $outFile -Append -Encoding utf8
$Json10 | Out-File $outFile -Append -Encoding utf8
$Json11 | Out-File $outFile -Append -Encoding utf8
$Json12 | Out-File $outFile -Append -Encoding utf8
$Json13 | Out-File $outFile -Append -Encoding utf8
$Json14 | Out-File $outFile -Append -Encoding utf8
$Json15 | Out-File $outFile -Append -Encoding utf8
$Json16 | Out-File $outFile -Append -Encoding utf8
$Json17 | Out-File $outFile -Append -Encoding utf8
$Json18 | Out-File $outFile -Append -Encoding utf8
$Json19 | Out-File $outFile -Append -Encoding utf8
$Json20_34 | Out-File $outFile -Append -Encoding utf8



# Git auto-commit
git add .
git commit -m "${publisher}/${AppName}/${version}"
git push
