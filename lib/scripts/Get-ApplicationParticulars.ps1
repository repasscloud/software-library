$currentDir = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
$repo_root_dir = Split-Path -Path (Split-Path -Path $currentDir -Parent) -Parent

Get-ChildItem -Path "${repo_root_dir}\lib\scripts" -Filter "Get-RedirectedURL.ps1" | ForEach-Object { . $_.FullName }
Get-ChildItem -Path "${repo_root_dir}\lib\scripts" -Filter "Get-URLStatusCode.ps1" | ForEach-Object { . $_.FullName }
Get-ChildItem -Path "${repo_root_dir}\lib\scripts" -Filter "Export-InstallerLanguages.ps1" | ForEach-Object { . $_.FullName }
Get-ChildItem -Path "${repo_root_dir}\lib\scripts" -Filter "Show-HostOutput.ps1" | ForEach-Object { . $_.FullName } #~> Issue #41

function Get-ApplicationParticulars {
<#
.SYNOPSIS
  <Overview of script>

.DESCRIPTION
  <Brief description of script>
  
.PARAMETER Publisher
    <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER AppName
    <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER Version
    <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER AppCopyright
    <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER License
    <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER LicenseURI
    <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER Tags
    <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER Description
    <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER Homepage
    <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER Arch
    <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER Languages
    <Brief description of parameter input required. Repeat this attribute if required>

.PARAMETER Depends
    <Brief description of parameter input required. Repeat this attribute if required>

.INPUTS
  None

.OUTPUTS
  Array variable made up of the following components at each index:
    0 - [void]
    1 - [void]
    2 - [void]
    3 - [String] Data to inject into application manifest
    4 - [String] Application copyright notice
    5 - [System.Version] Application version
    6 - [String] Publisher of application
    7 - [String] Name of application
    8 - [String] Copyright notice of application
    9 - [String] License type of application
   10 - [String] Architecture of application
   11 - [void]
   12 - [System.Collections.ArrayList] List of languages application available to be installed for
   13 - Complete output as single variable with no discernation for types or result info

.NOTES
  Version:        1.2.4.22
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
        [Parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Publisher of application by commonly adopted name.',
            Position=0)]
        [ValidateScript({
            if ($_ -match [System.Text.RegularExpressions.Regex]::New('[A-Za-z0-9]')) {
                $_
            }
            else {
                Throw "'$_' does NOT use an approved Publisher name."
            }
        })]
        [String]
        $Publisher,
        
        [Parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Publisher of application by commonly adopted name.',
            Position=1)]
        [ValidateScript({
            if ($_ -match [System.Text.RegularExpressions.Regex]::New('[A-Za-z0-9]')) {
                $_
            }
            else {
                Throw "'$_' does NOT use an approved Application name."
            }
        })]
        [String]
        $AppName,
        
        [Parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Application version number using SemVer standards.',
            Position=2)]
        [System.Version]
        $Version,

        [Parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Publisher of application by commonly adopted name.',
            Position=3)]
        [ValidateScript({
            if ($_ -match [System.Text.RegularExpressions.Regex]::New('[A-Za-z0-9]')) {
                $_
            }
            else {
                Throw "'$_' does NOT use an approved Copyright notice."
            }
        })]
        [String]
        $AppCopyright,

        [Parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='License type of application from standard OSI or Proprietary licenses.',
            Position=4)]
        [ValidateScript({
            [Array]$LicenseList=@('0BSD','BSD-1-Clause','BSD-2-Clause','BSD-3-Clause','AFL-3.0','APL-1.0','Apache-1.1','Apache-2.0','APSL-2.0','Artistic-1.0','Artistic-2.0','AAL','BSL-1.0','BSD-3-Clause-LBNL','BSD-2-Clause-Patent','CECILL-2.1','CDDL-1.0','CPAL-1.0','CPL-1.0','CATOSL-1.1','CAL-1.0','CUA-OPL-1.0','EPL-1.0','EPL-2.0','eCos-2.0','ECL-1.0','ECL-2.0','EFL-2.0','Entessa','EUDatagrid','EUPL-1.2','Fair','Frameworx-1.0','AGPL-3.0','GPL-2.0','GPL-3.0','LGPL-2.1','LGPL-3.0','HPND','IPL-1.0','Intel','IPA','ISC','Jabber','LPPL-1.3c','BSD-3-Clause-LBNL','LiliQ-P','LiliQ-R','LiliQ-R+','LPL-1.0','LPL-1.02','MS-PL','MS-RL','MirOS','MIT','CVW','Motosoto','MPL-1.0','MPL-1.1','MPL-2.0','MulanPSL-2.0','Multics','NASA-1.3','Naumen','NGPL','Nokia','NPOSL-3.0','NTP','OCLC-2.0','OGTSL','OSL-1.0','OSL-2.1','OSL-3.0','OLDAP-2.8','OPL-2.1','PHP-3.0','PHP-3.01','PostgreSQL','Python-2.0','CNRI-Python','QPL-1.0','RPSL-1.0','RPL-1.1','RPL-1.5','RSCPL','OFL-1.1','SimPL-2.0','Sleepycat','SISSL','SPL-1.0','Watcom-1.0','UPL','NCSA','UCL-1.0','Unlicense','VSL-1.0','W3C','WXwindows','Xnet','ZPL-2.0','Zlib','Other','Proprietary','Proprietary freeware, based on open source components')
            if ($_ -in $LicenseList) {
                $_
            }
            else {
                Throw "'$_' does NOT use an approved License type."
            }
        })]
        [String]
        $License,

        [Parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Publisher of application by commonly adopted name.',
            Position=5)]
        [ValidateScript({
            if ($_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200) {
                $_
            }
            else {
                Throw "'$_' does NOT provide a valid URL."
            }
        })]
        [uri]
        $LicenseURI,

        [Parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Tags associated to application. Provided in [Array] format.',
            Position=6)]
        [Array]
        $Tags,

        [Parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Abbreviated single-line description of application.',
            Position=7)]
        [String]
        $Description,

        [Parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Homepage of application by Publisher.',
            Position=8)]
        [ValidateScript({
            if ($_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200) {
                $_
            }
            else{
                Throw "'$_' does NOT provide a valid URL."
            }
        })]
        [uri]
        $Homepage,

        [Parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Publisher of application by commonly adopted name.',
            Position=9)]
        [ValidateScript( {$_ -in @('x64','x86','x86_64')} )]  #~>this code needs to be updated per version, or added to a compile script somehow?
        [Array]
        $Arch,

        [Parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Publisher of application by commonly adopted name.',
            Position=10)]
        [ValidateScript({
            if ($_ -in ((Import-Csv -Path 'C:\tmp\software-matrix\lib\public\LCID.csv' -Delimiter ',').'BCP 47 Code')) {
                $_
            }
            else{
                Throw "'$_' does NOT provide a L10n Language selection."
            }
        })]  #this path needs to be changed
        [Array]
        $Languages=@('en-US'),  #default to en-US

        [Parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Publisher of application by commonly adopted name.',
            Position=11)]
        [ValidateScript({
            $_ -match [System.Text.RegularExpressions.Regex]::New('[A-Za-z0-9]\.[A-Za-z0-9]')
        })]
        [Array]
        $Depends=@()
    )

    process {
        [Array]$function_return_array=@()
        
        [String]$json_data_return=@"
    "Version": "$Version",
    "Name": "$AppName",
    "Publisher": "$Publisher",
    "AppCopyright": "$AppCopyright",
    "License": "$License",
    "LicenseURL": "$LicenseURI",
    "Tags": [$($result=$null; foreach($i in $Tags){$result+='"' + $i + '",'}; $result.Substring(0,$result.Length-1))],
    "Description": "$Description",
    "Homepage": "$Homepage",
    "Arch": [$($result=$null; foreach($i in $Arch){$result+='"' + $i + '",'}; $result.Substring(0,$result.Length-1))],
    "Languages": [$($result=$null; foreach($i in $Languages){$result+='"' + $i + '",'}; $result.Substring(0,$result.Length-1))],
    "Depends": [$(if (-not($null -like $Depends)){$result=$null;foreach($i in $Depends){$result+='"' + $i + '",'};$result.Substring(0,$result.Length-1);}else{'""'})],
"@
        # Create blank array for data to be returned
        [Array]$function_return_array=@()

        # Create ArrayList of languages
        [System.Collections.ArrayList]$langList=@()
        foreach($i in $Languages) {
            $langList.Add($i)
        }

        # Add data to return array
        $function_return_array += $json_data_return
        $function_return_array += $AppCopyright
        $function_return_array += $Version
        $function_return_array += $Publisher
        $function_return_array += $AppName
        $function_return_array += $AppCopyright
        $function_return_array += $License
        $function_return_array += $Arch
        $function_return_array += $Depends
        $function_return_array += $langList
        
        # Inject all the data to test the change to a global variable
        [String]$global:TempFile+=$json_data_return
        [String]$global:TempFile+=$OFS

        # Multidimensional array that gets returned, including return array
        #[System.Collections.ArrayList]$multi_dimensional_array = @($json_data_return,$AppCopyright,$Version,$Publisher,$AppName,$AppCopyright,$License,$Arch,$Depends,$langList,$function_return_array)
            [String]$global:_AppCopyright=$AppCopyright
            [String]$global:_Version=$Version
            [String]$global:_Publisher=$Publisher
            [String]$global:_AppName=$AppName
            [String]$global:_AppCopyright=$AppCopyright
            [String]$global:_License=$License
            [String]$global:_Arch=$Arch
            [String]$global:_Depends=$Depends
            [Array]$global:_langList=$langList
    }
    
    end {
        [System.GC]::Collect()
    }
}
