<#
RePass Cloud Set-InstallerLanguages.ps1
Copyright 2020 RePass Cloud Pty Ltd

This product includes software developed at
RePass Cloud (https://repasscloud.com/).

Version: 2.0.0.68
#>

# Stems from issue #24
# Returns the Status Code of a web URL that is passed in as an arg
# Should always return a 200 result to be successful
# List of URL status codes can be found here: https://www.w3.org/Protocols/HTTP/HTRESP.html

# Usage:
#
#    $jsonLangData = Set-InstallerLanguages -Arch x64 `
#      -Lang en-US `
#      -MsiExe MSI `
#      -SilentSwitch '/S' `
#      -UninstallSwitch 'this cat says hello' `
#      -UpdateURI https://notepad-plus-plus.org/ `
#      -UpdateRegex '(\s)' `
#      -x64InstallURI 'https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win64&lang=en-US'
#    $jsonLangData
#
#    $jsonLangData = Set-InstallerLanguages -Arch x64
#    $jsonLangData
#
#    $jsonLangData = Set-InstallerLanguages -Arch x86_64 `
#      -Lang en-US,en-GB
#    $jsonLangData


function Set-InstallerLanguages {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateSet('x64','x86','x86_64','arm','arm64')]
        [String]
        $Arch,

        [Parameter(Mandatory=$false,Position=1)]
        [ArgumentCompleter({(Import-Csv -Path 'C:\tmp\software-matrix\lib\public\LCID.csv' -Delimiter ',').'BCP 47 Code'})]  #this path needs to be changed
        [ValidateScript({$_ -in (((Import-Csv -Path 'C:\tmp\software-matrix\lib\public\LCID.csv' -Delimiter ',').'BCP 47 Code'))})]  #this path needs to be changed
        [Array]  #array to capture more than one
        $Lang=@('en-US'),  #default to en-US

        [Parameter(Mandatory=$false,Position=2)]
        [ValidateSet('MSI','EXE')]
        [String]
        $MsiExe,

        [Parameter(Mandatory=$false,Position=3)]
        [ValidateScript(
            {
                $_ -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w') -or $_ -match [System.Text.RegularExpressions.Regex]::New('')
            }
        )]
        [String]
        $SilentSwitch,

        [Parameter(Mandatory=$false,Position=4)]
        [ValidateScript(
            {
                $_ -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w')
            }
        )]
        [String]
        $UninstallSwitch,

        [Parameter(Mandatory=$false,Position=5)]
        [ValidateScript(
            {
                $_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200
            }
        )]
        [Uri]
        $UpdateURI,
        
        [Parameter(Mandatory=$false,Position=6)]
        [ValidateScript(
            {
                $_ -match [System.Text.RegularExpressions.Regex]::New('\W\w') -or $_ -match [System.Text.RegularExpressions.Regex]::New('')
            }
        )]
        [String]
        $UpdateRegex,

        [Parameter(Mandatory=$false,Position=7)]
        [ValidateScript(
            {
                $_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200
            }
        )]
        [Uri]
        $x64InstallURI
    )
    

    begin {
        [String]$OFS="`r`n"  # Linebreak
        [Int16]$l_count=$Lang.Count  #total number of languages being created into the manifest
        [String]$l_json=""  #language manifest string to inject


        # Create a temporary file to generate a sha256 value.
        Switch ($IsMacOS) {  #system is MacOS
            $true {
                [String]$tempFolder='/var/tmp'; 
                [String]$Hashfile64=$tempFolder + "/TempfileName64.txt"
                [String]$Hashfile32=$tempFolder + "/TempfileName32.txt"
            }
            Default { }
        }
        Switch ($IsLinux) {  #system is Linux
            $true {
                [String]$tempFolder='/var/tmp'; 
                [String]$Hashfile64=$tempFolder + "/TempfileName64.txt"
                [String]$Hashfile32=$tempFolder + "/TempfileName32.txt"
            }
            Default { }
        }
        Switch ($IsWindows) {  #system is WindowsOS
            $true {
                [String]$tempFolder=$env:TEMP
                [String]$Hashfile64=$tempFolder + "\TempfileName64.txt"
                [String]$Hashfile32=$tempFolder + "\TempfileName32.txt"
            }
            Default { }
        }

    }
    
    process {
        Start-Sleep -Seconds 1

        foreach ($l in $Lang) {

            
            # Prompt for executable type on loop until valid
            if (-not($MsiExe -like 'MSI' -or $MsiExe -like 'EXE')) {
                $executable_type=$null
                do {
                    Clear-Host;
                    [Int16]$executable_type=Read-Host -Prompt "Select INSTALLER TYPE for language ${l}${OFS}${OFS}  [1]  MSI${OFS}  [2]  EXE${OFS}${OFS}  Enter selection"
                } until ($executable_type -lt 3 -and $executable_type -gt 0)
                Switch ($executable_type) {
                    1 { [String]$exec_type='MSI' }
                    2 { [String]$exec_type='EXE' }
                    Default {}
                }
            } else {
                Switch ($MsiExe) {
                    'MSI' { [String]$exec_type='MSI' }
                    'EXE' { [String]$exec_type='EXE' }
                }
            }

            # Prompt for silent install switch(es) on loop until valid
            if (-not($SilentSwitch)) {
                [String]$silent_switch_prompt="[OPTIONAL] Provide SILENT INSTALL switch(es) for language ${l}"
                $silent_install_switches=$null
                do {
                    Clear-Host;
                    [String]$silent_install_switches=Read-Host -Prompt $silent_switch_prompt
                } until ($silent_install_switches -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w') -or $silent_install_switches -match [System.Text.RegularExpressions.Regex]::New(''))
            } else {
                $silent_install_switches=$SilentSwitch
            }

            # Prompt for silent uninstall string on loop until valid ~> must be provided
            if (-not($UninstallSwitch)) {
                [String]$silent_uninstall_prompt="Provide UNINSTALL string for language ${l}"
                $silent_uninstall_string=$null
                do {
                    Clear-Host;
                    [String]$silent_uninstall_string=Read-Host -Prompt $silent_uninstall_prompt
                } until ($silent_uninstall_string -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w'))
            } else {
                $silent_uninstall_string=$UninstallSwitch
            }

            # Prompt for update URI
            if (-not($UpdateURI)) {
                [String]$update_URI_prompt="Provide UPDATE URI for reference for language ${l}"
                $update_URI_lookup=$null
                do {
                    Clear-Host;
                    [Uri]$update_URI_lookup=Read-Host -Prompt $update_URI_prompt
                } until ($update_URI_lookup -match [System.Text.RegularExpressions.Regex]::New('\W\w') -and (Get-UrlStatusCode -Url $update_URI_lookup) -like 200)
            } else {
                $update_URI_lookup=$UpdateURI
            }

            # Prompt for update regex
            if (-not($UpdateRegex)) {
                [String]$update_regex_prompt="[OPTIONAL] Provide UPDATE URI regex string for language ${l}"
                $update_regex_lookup=$null
                do {
                    Clear-Host;
                    [String]$update_regex_lookup=Read-Host -Prompt $update_regex_prompt
                } until ($update_regex_lookup -match [System.Text.RegularExpressions.Regex]::New('\W\w') -or $update_regex_lookup -match [System.Text.RegularExpressions.Regex]::New(''))
            } else {
                $update_regex_lookup=$UpdateRegex
            }

            # Prompt for URL64 on loop until valid
            if (-not($x64InstallURI)) {
                [String]$url64_prompt="Enter the 64-bit URL to the installer for language ${l}"
                $url64=$null
                do {
                    Clear-Host;
                    [Uri]$url64=Read-Host -Prompt $url64_prompt
                } until ($url64.Length -gt 0 -and (Get-UrlStatusCode -Url $url64) -like 200)  #URL must be valid and exist, tests to confirm is valid
                Clear-Host;
            } else {
                $url64=$x64InstallURI
            }

            # Main Region
            $followURL=Get-RedirectedUrl -Url $url64  #find the URL to download
            Write-Host "Downloading application package...${OFS}" -ForeGroundColor Yellow
            $WebClient=New-Object System.Net.WebClient
            $WebClient.DownloadFile($followURL, $Hashfile64)
            Write-Host "Getting SHA-256 checksum...${OFS}" -ForeGroundColor Yellow
            $sha256=(Get-FileHash -Path $hashfile64 -Algorithm SHA256).Hash
            Start-Sleep -Seconds 1
            Write-Host "Getting SHA-512 checksum...${OFS}" -ForeGroundColor Yellow
            $sha512=(Get-FileHash -Path $hashfile64 -Algorithm SHA512).Hash
            Start-Sleep -Seconds 1


            # Set the all the JSON data lines
            $json_LanguageOpen='                "' + $l + '": {'
            $json_URL='                    "Url": "' + $url64 + '",'
            $json_followURL='                    "FollowUrl": "' + $followURL + '",'
            $json_SHA256='                    "Sha256": "' + $sha256 + '",'
            $json_SHA512='                    "Sha512": "' + $sha512 + '",'
            $json_InstallerType='                    "InstallerType": "' + $exec_type + '",'
            $json_SilentSwitches='                    "InstallSwitches": "'+ $silent_install_switches + '",'
            $json_SilentUninstallString='                    "UninstallString": "'+ $silent_uninstall_string.Replace('"','\"') + '",'
            $json_UpdateURI='                    "UpdateURI": "'+ $update_URI_lookup + '",'
            $json_UpdateRegex='                    "UpdateRegex": "'+ $update_regex_lookup.Replace('"','\"') + '"'
            if ($l_count -lt 2) {
                $json_LanguageClose='                }'
            } else {
                $json_LanguageClose='                },'
                $l_count -= 1  #deduct 1 from the language count, so the last line will automatically revent to the first and close off the JSON list
            }

            # Put all the results together
            $l_json += ($json_LanguageOpen + $OFS)
            $l_json += ($json_URL + $OFS)
            $l_json += ($json_followURL + $OFS)
            $l_json += ($json_SHA256 + $OFS)
            $l_json += ($json_SHA512 + $OFS)
            $l_json += ($json_InstallerType + $OFS)
            $l_json += ($json_SilentSwitches + $OFS)
            $l_json += ($json_SilentUninstallString + $OFS)
            $l_json += ($json_UpdateURI + $OFS)
            $l_json += ($json_UpdateRegex + $OFS)
            $l_json += ($json_LanguageClose + $OFS)
        }
    }
    
    end {
        return $l_json
    }
}

