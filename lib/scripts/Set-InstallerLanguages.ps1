function Set-InstallerLanguages {

<#
.SYNOPSIS
  <Overview of script>

.DESCRIPTION
  <Brief description of script>
  
.PARAMETER Arch
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER Lang
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER MsiExe
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER MsiExe_x64
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER MsiExe_x86
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER SilentInstallString
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER SilentInstallString_x64
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER SilentInstallString_x86
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER SilentUninstallString
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER SilentUninstallString_x64
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER SilentUninstallString_x86
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER UpdateURI
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER UpdateURI_x64
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER UpdateURI_x86
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER UpdateRegex
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER UpdateRegex_x64
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER InstallURI
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER InstallURI_x64
  <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER InstallURI_x86
  <Brief description of parameter input required. Repeat this attribute if required>

.INPUTS
  None

.OUTPUTS
  TBA

.NOTES
  Version:        2.2.3.83
  Author:         Copyright © 2020 RePass Cloud Pty Ltd (https://repasscloud.com/). All rights reserved.
  License:        Apache-2.0
  Creation Date:  2020-07-13
  Purpose/Change: Return variable includes multidimensional indexable array.
  
.EXAMPLE
  Set-ApplicationParticulars -Publisher 'Google' `
    -AppName 'Chrome' `
    -Version 83.0.4103.116 `
    -AppCopyright 'Copyright © 2020 Google LLC. All rights reserved.' `
    -License 'Proprietary freeware, based on open source components' `
    -LicenseURI https://www.google.com/intl/en/chrome/terms/ `
    -Tags 'google','chrome','web','internet','browser' `
    -Description 'Chrome is a fast, simple, and secure web browser, built for the modern web.' `
    -Homepage https://www.google.com/chrome/browser/ `
    -Arch x86_64 `
    -Languages @('en-US','en-AU')

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateScript({
                $_ -in @('x64','x86','x86_64','arm','arm64')
        })]
        [String]
        $Arch,

        [Parameter(Mandatory=$false,Position=1)]
        [ValidateScript({
                $_ -in (((Import-Csv -Path 'C:\tmp\software-matrix\lib\public\LCID.csv' -Delimiter ',').'BCP 47 Code'))
        })]  #this path needs to be changed
        [Array]
        $Lang=@('en-US'),

        [Parameter(Mandatory=$false,Position=2)]
        [ValidateSet('MSI','EXE')]
        [String]
        $MsiExe,

        [Parameter(Mandatory=$false,Position=3)]
        [ValidateSet('MSI','EXE')]
        [String]
        $MsiExe_x64,

        [Parameter(Mandatory=$false,Position=4)]
        [ValidateSet('MSI','EXE')]
        [String]
        $MsiExe_x86,

        [Parameter(Mandatory=$false,Position=5)]
        [ValidateScript({
            $_ -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w') -or $_ -match [System.Text.RegularExpressions.Regex]::New('')
        })]
        [String]
        $SilentInstallString,

        [Parameter(Mandatory=$false,Position=6)]
        [ValidateScript({
            $_ -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w') -or $_ -match [System.Text.RegularExpressions.Regex]::New('')
        })]
        [String]
        $SilentInstallString_x64,

        [Parameter(Mandatory=$false,Position=7)]
        [ValidateScript({
            $_ -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w') -or $_ -match [System.Text.RegularExpressions.Regex]::New('')
        })]
        [String]
        $SilentInstallString_x86,

        [Parameter(Mandatory=$false,Position=8)]
        [ValidateScript({
            $_ -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w') -or $_ -match [System.Text.RegularExpressions.Regex]::New('')
        })]
        [String]
        $SilentUninstallString,

        [Parameter(Mandatory=$false,Position=9)]
        [ValidateScript({
            $_ -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w') -or $_ -match [System.Text.RegularExpressions.Regex]::New('')
        })]
        [String]
        $SilentUninstallString_x64,

        [Parameter(Mandatory=$false,Position=10)]
        [ValidateScript({
            $_ -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w') -or $_ -match [System.Text.RegularExpressions.Regex]::New('')
        })]
        [String]
        $SilentUninstallString_x86,

        [Parameter(Mandatory=$false,Position=11)]
        [ValidateScript({
            $_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200
        })]
        [uri]
        $UpdateURI,

        [Parameter(Mandatory=$false,Position=12)]
        [ValidateScript({
            $_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200
        })]
        [uri]
        $UpdateURI_x64,

        [Parameter(Mandatory=$false,Position=13)]
        [ValidateScript({
            $_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200
        })]
        [uri]
        $UpdateURI_x86,

        [Parameter(Mandatory=$false,Position=14)]
        [ValidateScript({
            $_ -match [System.Text.RegularExpressions.Regex]::New('\W\w') -or $null
        })]
        [String]
        $UpdateRegex,

        [Parameter(Mandatory=$false,Position=15)]
        [ValidateScript({
            $_ -match [System.Text.RegularExpressions.Regex]::New('\W\w') -or $null
        })]
        [String]
        $UpdateRegex_x64,

        [Parameter(Mandatory=$false,Position=16)]
        [ValidateScript({
            $_ -match [System.Text.RegularExpressions.Regex]::New('\W\w') -or $null
            #$_ -match [System.Text.RegularExpressions.Regex]::New('\W\w') -or $_ -match [System.Text.RegularExpressions.Regex]::New('')
        })]
        [String]
        $UpdateRegex_x86,

        [Parameter(Mandatory=$false,Position=17)]
        [ValidateScript({
            $_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200
        })]
        [uri]
        $InstallURI,

        [Parameter(Mandatory=$false,Position=18)]
        [ValidateScript({
            $_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200
        })]
        [uri]
        $InstallURI_x64,

        [Parameter(Mandatory=$false,Position=19)]
        [ValidateScript({
            $_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200
        })]
        [uri]
        $InstallURI_x86
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

        # Switch [Arch] to create manifest for
        Switch ($Arch) {
            'x64' {

                # Add x64 once to the section
                $json_ArchOpen='      "x64": {'
                $l_json += ($json_ArchOpen + $OFS)
                
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
                    if (-not($SilentInstallString)) {
                        [String]$silent_switch_prompt="[OPTIONAL] Provide SILENT INSTALL string for language ${l}"
                        $silent_install_switches=$null
                        do {
                            Clear-Host;
                            [String]$silent_install_switches=Read-Host -Prompt $silent_switch_prompt
                        } until ($silent_install_switches -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w') -or $silent_install_switches -match [System.Text.RegularExpressions.Regex]::New(''))
                    } else {
                        [String]$silent_install_switches=$SilentInstallString
                    }

                    # Prompt for silent uninstall string on loop until valid ~> must be provided
                    if (-not($SilentUninstallString)) {
                        [String]$silent_uninstall_prompt="Provide UNINSTALL string for language ${l}"
                        $silent_uninstall_string=$null
                        do {
                            Clear-Host;
                            [String]$silent_uninstall_string=Read-Host -Prompt $silent_uninstall_prompt
                        } until ($silent_uninstall_string -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w'))
                    } else {
                        [String]$silent_uninstall_string=$SilentUninstallString
                    }

                    # Prompt for update URI
                    if (-not($UpdateURI)) {
                        [String]$update_URI_prompt="Provide UPDATE URI for reference for language ${l}"
                        $update_URI_lookup=$null
                        do {
                            Clear-Host;
                            [uri]$update_URI_lookup=Read-Host -Prompt $update_URI_prompt
                        } until ($update_URI_lookup -match [System.Text.RegularExpressions.Regex]::New('\W\w') -and (Get-UrlStatusCode -Url $update_URI_lookup) -like 200)
                    } else {
                        [String]$update_URI_lookup=$UpdateURI
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
                        [String]$update_regex_lookup=$UpdateRegex
                    }

                    # Prompt for URL64 on loop until valid
                    if (-not($InstallURI)) {
                        [String]$url64_prompt="Enter the 64-bit URL to the installer for language ${l}"
                        $url64=$null
                        do {
                            Clear-Host;
                            [uri]$url64=Read-Host -Prompt $url64_prompt
                        } until ($url64.Length -gt 0 -and (Get-UrlStatusCode -Url $url64) -like 200)  #URL must be valid and exist, tests to confirm is valid
                        Clear-Host;
                    } else {
                        [String]$url64=$InstallURI
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
                    $json_LanguageOpen='        "' + $l + '": {'
                    $json_URL='          "Url": "' + $url64 + '",'
                    $json_followURL='          "FollowUrl": "' + $followURL + '",'
                    $json_SHA256='          "Sha256": "' + $sha256 + '",'
                    $json_SHA512='          "Sha512": "' + $sha512 + '",'
                    $json_InstallerType='          "InstallerType": "' + $exec_type + '",'
                    $json_SilentSwitches='          "InstallSwitches": "'+ $silent_install_switches.Replace('"','\"') + '",'
                    $json_SilentUninstallString='          "UninstallString": "'+ $silent_uninstall_string.Replace('"','\"') + '",'
                    $json_UpdateURI='          "UpdateURI": "'+ $update_URI_lookup + '",'
                    $json_UpdateRegex='          "UpdateRegex": "'+ $update_regex_lookup.Replace('"','\"') + '"'
                    if ($l_count -lt 2) {
                        $json_LanguageClose='        }' + $OFS + '      }'
                        #$json_ArchClose
                        # the ArchClose is removed because it gets added on $json_LanguageClose selection
                    } else {
                        $json_LanguageClose='        },' + $OFS  #returning the comma, this _is_ required here
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
                    $l_json += ($json_LanguageClose)
                }
            }
            'x86' {

                # Add x86 once to the section
                $json_ArchOpen='      "x86": {'
                $l_json += ($json_ArchOpen + $OFS)
                
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
                    if (-not($SilentInstallString)) {
                        [String]$silent_switch_prompt="[OPTIONAL] Provide SILENT INSTALL string for language ${l}"
                        $silent_install_switches=$null
                        do {
                            Clear-Host;
                            [String]$silent_install_switches=Read-Host -Prompt $silent_switch_prompt
                        } until ($silent_install_switches -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w') -or $silent_install_switches -match [System.Text.RegularExpressions.Regex]::New(''))
                    } else {
                        [String]$silent_install_switches=$SilentInstallString
                    }
            
                    # Prompt for silent uninstall string on loop until valid ~> must be provided
                    if (-not($SilentUninstallString)) {
                        [String]$silent_uninstall_prompt="Provide UNINSTALL string for language ${l}"
                        $silent_uninstall_string=$null
                        do {
                            Clear-Host;
                            [String]$silent_uninstall_string=Read-Host -Prompt $silent_uninstall_prompt
                        } until ($silent_uninstall_string -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w'))
                    } else {
                        [String]$silent_uninstall_string=$SilentUninstallString
                    }
            
                    # Prompt for update URI
                    if (-not($UpdateURI)) {
                        [String]$update_URI_prompt="Provide UPDATE URI for reference for language ${l}"
                        $update_URI_lookup=$null
                        do {
                            Clear-Host;
                            [uri]$update_URI_lookup=Read-Host -Prompt $update_URI_prompt
                        } until ($update_URI_lookup -match [System.Text.RegularExpressions.Regex]::New('\W\w') -and (Get-UrlStatusCode -Url $update_URI_lookup) -like 200)
                    } else {
                        [String]$update_URI_lookup=$UpdateURI
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
                        [String]$update_regex_lookup=$UpdateRegex
                    }
            
                    # Prompt for URL32 on loop until valid
                    if (-not($InstallURI)) {
                        [String]$url32_prompt="Enter the 32-bit URL to the installer for language ${l}"
                        $url32=$null
                        do {
                            Clear-Host;
                            [uri]$url32=Read-Host -Prompt $url32_prompt
                        } until ($url32.Length -gt 0 -and (Get-UrlStatusCode -Url $url32) -like 200)  #URL must be valid and exist, tests to confirm is valid
                        Clear-Host;
                    } else {
                        [String]$url32=$InstallURI
                    }
            
                    # Main Region
                    $followURL=Get-RedirectedUrl -Url $url32  #find the URL to download
                    Write-Host "Downloading application package...${OFS}" -ForeGroundColor Yellow
                    $WebClient=New-Object System.Net.WebClient
                    $WebClient.DownloadFile($followURL, $Hashfile32)
                    Write-Host "Getting SHA-256 checksum...${OFS}" -ForeGroundColor Yellow
                    $sha256=(Get-FileHash -Path $hashfile32 -Algorithm SHA256).Hash
                    Start-Sleep -Seconds 1
                    Write-Host "Getting SHA-512 checksum...${OFS}" -ForeGroundColor Yellow
                    $sha512=(Get-FileHash -Path $hashfile32 -Algorithm SHA512).Hash
                    Start-Sleep -Seconds 1
            
            
                    # Set the all the JSON data lines
                    $json_LanguageOpen='        "' + $l + '": {'
                    $json_URL='          "Url": "' + $url32 + '",'
                    $json_followURL='          "FollowUrl": "' + $followURL + '",'
                    $json_SHA256='          "Sha256": "' + $sha256 + '",'
                    $json_SHA512='          "Sha512": "' + $sha512 + '",'
                    $json_InstallerType='          "InstallerType": "' + $exec_type + '",'
                    $json_SilentSwitches='          "InstallSwitches": "'+ $silent_install_switches.Replace('"','\"') + '",'
                    $json_SilentUninstallString='          "UninstallString": "'+ $silent_uninstall_string.Replace('"','\"') + '",'
                    $json_UpdateURI='          "UpdateURI": "'+ $update_URI_lookup + '",'
                    $json_UpdateRegex='          "UpdateRegex": "'+ $update_regex_lookup.Replace('"','\"') + '"'
                    if ($l_count -lt 2) {
                        $json_LanguageClose='        }' + $OFS + '      }'
                        #$json_ArchClose
                        # the ArchClose is removed because it gets added on $json_LanguageClose selection
                    } else {
                        $json_LanguageClose='        },' + $OFS  #returning the comma, this _is_ required here
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
                    $l_json += ($json_LanguageClose)
                }
            }
            'x86_64' {

                # Add x64 once to the section
                $json_ArchOpen='      "x64": {'
                $l_json += ($json_ArchOpen + $OFS)
                [Int16]$l_count=$Lang.Count  #total number of languages being created into the manifest

                foreach ($l in $Lang) {

                    # Prompt for executable type on loop until valid
                    if (-not($MsiExe_x64 -like 'MSI' -or $MsiExe_x64 -like 'EXE')) {
                        $executable_type=$null
                        do {
                            Clear-Host;
                            [Int16]$executable_type=Read-Host -Prompt "Select 64-bit INSTALLER TYPE for language ${l}${OFS}${OFS}  [1]  MSI${OFS}  [2]  EXE${OFS}${OFS}  Enter selection"
                        } until ($executable_type -lt 3 -and $executable_type -gt 0)
                        Switch ($executable_type) {
                            1 { [String]$64exec_type='MSI' }
                            2 { [String]$64exec_type='EXE' }
                            Default {}
                        }
                    } else {
                        Switch ($MsiExe_x64) {
                            'MSI' { [String]$64exec_type='MSI' }
                            'EXE' { [String]$64exec_type='EXE' }
                        }
                    }
            
                    # Prompt for silent install switch(es) on loop until valid
                    if (-not($SilentInstallString_x64)) {
                        [String]$silent_switch_prompt="[OPTIONAL] Provide SILENT INSTALL string for language ${l}"
                        $silent_install_switches=$null
                        do {
                            Clear-Host;
                            [String]$silent_install_switches=Read-Host -Prompt $silent_switch_prompt
                        } until ($silent_install_switches -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w') -or $silent_install_switches -match [System.Text.RegularExpressions.Regex]::New(''))
                    } else {
                        [String]$silent_install_switches=$SilentInstallString_x64
                    }
            
                    # Prompt for silent uninstall string on loop until valid ~> must be provided
                    if (-not($SilentUninstallString_x64)) {
                        [String]$silent_uninstall_prompt="Provide UNINSTALL string for language ${l}"
                        $silent_uninstall_string=$null
                        do {
                            Clear-Host;
                            [String]$silent_uninstall_string=Read-Host -Prompt $silent_uninstall_prompt
                        } until ($silent_uninstall_string -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w'))
                    } else {
                        [String]$silent_uninstall_string=$SilentUninstallString_x64
                    }
            
                    # Prompt for update URI
                    if (-not($UpdateURI_x64)) {
                        [String]$64update_URI_prompt="Provide UPDATE URI for reference for language ${l}"
                        $64update_URI_lookup=$null
                        do {
                            Clear-Host;
                            [uri]$64update_URI_lookup=Read-Host -Prompt $64update_URI_prompt
                        } until ($64update_URI_lookup -match [System.Text.RegularExpressions.Regex]::New('\W\w') -and (Get-UrlStatusCode -Url $64update_URI_lookup) -like 200)
                    } else {
                        [String]$64update_URI_lookup=$UpdateURI_x64
                    }
            
                    # Prompt for update regex
                    if (-not($UpdateRegex_x64)) {
                        [String]$64update_regex_prompt="[OPTIONAL] Provide UPDATE URI regex string for language ${l}"
                        $64update_regex_lookup=$null
                        do {
                            Clear-Host;
                            [String]$64update_regex_lookup=Read-Host -Prompt $64update_regex_prompt
                        } until ($64update_regex_lookup -match [System.Text.RegularExpressions.Regex]::New('\W\w') -or $64update_regex_lookup -match [System.Text.RegularExpressions.Regex]::New(''))
                    } else {
                        [String]$64update_regex_lookup=$UpdateRegex_x64
                    }
            
                    # Prompt for URL64 on loop until valid
                    if (-not($InstallURI_x64)) {
                        [String]$url64_prompt="xxEnter the 64-bit URL to the installer for language ${l}"
                        $url64=$null
                        do {
                            Clear-Host;
                            [uri]$url64=Read-Host -Prompt $url64_prompt
                        } until ($url64.Length -gt 0 -and (Get-UrlStatusCode -Url $url64) -like 200)  #URL must be valid and exist, tests to confirm is valid
                        Clear-Host;
                    } else {
                        [String]$url64=$InstallURI_x64
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
                    $json_LanguageOpen='        "' + $l + '": {'
                    $json_URL='          "Url": "' + $url64 + '",'
                    $json_followURL='          "FollowUrl": "' + $followURL + '",'
                    $json_SHA256='          "Sha256": "' + $sha256 + '",'
                    $json_SHA512='          "Sha512": "' + $sha512 + '",'
                    $json_InstallerType='          "InstallerType": "' + $64exec_type + '",'
                    $json_SilentSwitches='          "InstallSwitches": "'+ $silent_install_switches.Replace('"','\"') + '",'
                    $json_SilentUninstallString='          "UninstallString": "'+ $silent_uninstall_string.Replace('"','\"') + '",'
                    $json_UpdateURI='          "UpdateURI": "'+ $64update_URI_lookup + '",'
                    $json_UpdateRegex='          "UpdateRegex": "'+ $64update_regex_lookup.Replace('"','\"') + '"'
                    if ($l_count -lt 2) {
                        $json_LanguageClose='        }' + $OFS + '      },' + $OFS
                        #$json_ArchClose
                        # the ArchClose is removed because it gets added on $json_LanguageClose selection
                    } else {
                        $json_LanguageClose='        },' + $OFS
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
                    $l_json += ($json_LanguageClose)
            

                }

                # Add x86 once to the section
                $json_ArchOpen='      "x86": {'
                $l_json += ($json_ArchOpen + $OFS)
                [Int16]$l_count=$Lang.Count  #total number of languages being created into the manifest

                foreach ($l in $Lang) {

                    # Prompt for executable type on loop until valid
                    if (-not($MsiExe_x86 -like 'MSI' -or $MsiExe_x86 -like 'EXE')) {
                        $executable_type=$null
                        do {
                            Clear-Host;
                            [Int16]$executable_type=Read-Host -Prompt "Select 32-bit INSTALLER TYPE for language ${l}${OFS}${OFS}  [1]  MSI${OFS}  [2]  EXE${OFS}${OFS}  Enter selection"
                        } until ($executable_type -lt 3 -and $executable_type -gt 0)
                        Switch ($executable_type) {
                            1 { [String]$32exec_type='MSI' }
                            2 { [String]$32exec_type='EXE' }
                            Default {}
                        }
                    } else {
                        Switch ($MsiExe_x86) {
                            'MSI' { [String]$32exec_type='MSI' }
                            'EXE' { [String]$32exec_type='EXE' }
                        }
                    }
            
                    # Prompt for silent install switch(es) on loop until valid
                    if (-not($SilentInstallString_x86)) {
                        [String]$silent_switch_prompt="[OPTIONAL] Provide SILENT INSTALL string for language ${l}"
                        $silent_install_switches=$null
                        do {
                            Clear-Host;
                            [String]$silent_install_switches=Read-Host -Prompt $silent_switch_prompt
                        } until ($silent_install_switches -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w') -or $silent_install_switches -match [System.Text.RegularExpressions.Regex]::New(''))
                    } else {
                        [String]$silent_install_switches=$SilentInstallString_x86
                    }
            
                    # Prompt for silent uninstall string on loop until valid ~> must be provided
                    if (-not($SilentUninstallString_x86)) {
                        [String]$silent_uninstall_prompt="Provide UNINSTALL string for language ${l}"
                        $silent_uninstall_string=$null
                        do {
                            Clear-Host;
                            [String]$silent_uninstall_string=Read-Host -Prompt $silent_uninstall_prompt
                        } until ($silent_uninstall_string -match [System.Text.RegularExpressions.Regex]::New('\W|\w|\W\w'))
                    } else {
                        [String]$silent_uninstall_string=$SilentUninstallString_x86
                    }
            
                    # Prompt for update URI
                    if (-not($UpdateURI_x86)) {
                        [String]$32update_URI_prompt="Provide UPDATE URI for reference for language ${l}"
                        $32update_URI_lookup=$null
                        do {
                            Clear-Host;
                            [uri]$32update_URI_lookup=Read-Host -Prompt $32update_URI_prompt
                        } until ($32update_URI_lookup -match [System.Text.RegularExpressions.Regex]::New('\W\w') -and (Get-UrlStatusCode -Url $32update_URI_lookup) -like 200)
                    } else {
                        [String]$32update_URI_lookup=$UpdateURI_x86
                    }
            
                    # Prompt for update regex
                    if (-not($UpdateRegex_x86)) {
                        [String]$32update_regex_prompt="[OPTIONAL] Provide UPDATE URI regex string for language ${l}"
                        $32update_regex_lookup=$null
                        do {
                            Clear-Host;
                            [String]$32update_regex_lookup=Read-Host -Prompt $32update_regex_prompt
                        } until ($32update_regex_lookup -match [System.Text.RegularExpressions.Regex]::New('\W\w') -or $32update_regex_lookup -match [System.Text.RegularExpressions.Regex]::New(''))
                    } else {
                        [String]$32update_regex_lookup=$UpdateRegex_x86
                    }
            
                    # Prompt for URL32 on loop until valid
                    if (-not($InstallURI_x86)) {
                        [String]$url32_prompt="Enter the 32-bit URL to the installer for language ${l}"
                        $url32=$null
                        do {
                            Clear-Host;
                            [uri]$url32=Read-Host -Prompt $url32_prompt
                        } until ($url32.Length -gt 0 -and (Get-UrlStatusCode -Url $url32) -like 200)  #URL must be valid and exist, tests to confirm is valid
                        Clear-Host;
                    } else {
                        [String]$url32=$InstallURI_x86
                    }
            

                    # Main Region
                    $followURL=Get-RedirectedUrl -Url $url32  #find the URL to download
                    Write-Host "Downloading application package...${OFS}" -ForeGroundColor Yellow
                    $WebClient=New-Object System.Net.WebClient
                    $WebClient.DownloadFile($followURL, $Hashfile32)
                    Write-Host "Getting SHA-256 checksum...${OFS}" -ForeGroundColor Yellow
                    $sha256=(Get-FileHash -Path $hashfile32 -Algorithm SHA256).Hash
                    Start-Sleep -Seconds 1
                    Write-Host "Getting SHA-512 checksum...${OFS}" -ForeGroundColor Yellow
                    $sha512=(Get-FileHash -Path $hashfile32 -Algorithm SHA512).Hash
                    Start-Sleep -Seconds 1
            
            
                    # Set the all the JSON data lines
                    $json_LanguageOpen='        "' + $l + '": {'
                    $json_URL='          "Url": "' + $url32 + '",'
                    $json_followURL='          "FollowUrl": "' + $followURL + '",'
                    $json_SHA256='          "Sha256": "' + $sha256 + '",'
                    $json_SHA512='          "Sha512": "' + $sha512 + '",'
                    $json_InstallerType='          "InstallerType": "' + $32exec_type + '",'
                    $json_SilentSwitches='          "InstallSwitches": "'+ $silent_install_switches.Replace('"','\"') + '",'
                    $json_SilentUninstallString='          "UninstallString": "'+ $silent_uninstall_string.Replace('"','\"') + '",'
                    $json_UpdateURI='          "UpdateURI": "'+ $32update_URI_lookup + '",'
                    $json_UpdateRegex='          "UpdateRegex": "'+ $32update_regex_lookup.Replace('"','\"') + '"'
                    if ($l_count -lt 2) {
                        $json_LanguageClose='        }' + $OFS + '      }'
                        #$json_LanguageClose='        }' + $OFS + '      },' + $OFS
                        #~> the $OFS is removed, because it's a blank line not required with the next line entry starting blank
                        #~> the comma needs to be removed, because it's a closing statement, this only applies to $x86_64
                        #$json_ArchClose
                        #~> the ArchClose is removed because it gets added on $json_LanguageClose selection
                    } else {
                        $json_LanguageClose='        },' + $OFS
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
                    $l_json += ($json_LanguageClose)
                }
            }
        }
    }
    
    end {
        return $l_json
        [System.GC]::Collect()
    }
}

