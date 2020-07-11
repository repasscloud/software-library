<#
RePass Cloud Set-ApplicationParticulars.ps1
Copyright 2020 RePass Cloud Pty Ltd

This product includes software developed at
RePass Cloud (https://repasscloud.com/).

Version: 1.0.1.4
#>

# Usage:
#    $var = Set-ApplicationParticulars -Publisher 'Google' `
#      -AppName 'Chrome' `
#      -Version 83.0.4103.116 `
#      -AppCopyright 'Copyright 2020 Google LLC. All rights reserved' `
#      -License 'Proprietary freeware, based on open source components' `
#      -LicenseURI https://www.google.com/intl/en/chrome/terms/ `
#      -Tags 'cats','dogs' `
#      -Description 'Chrome is a fast, simple, and secure web browser, built for the modern web.' `
#      -Homepagehttps://www.google.com/chrome/browser/ `
#      -Arch x86_x64 `
#      -Languages 'en-us'
#    $var
#
#    [Array]$var
#      0 - manifest array
#      1 - Publisher
#      2 - AppName
#      3 - Version
#      4 - AppCopyright
#      5 - License
#      6 - Arch
#      7 - Languages
#      8 - Depends
#
#
#


function Set-ApplicationParticulars {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateScript( {$_ -match [System.Text.RegularExpressions.Regex]::New('[A-Za-z0-9]')} )]
        [String]
        $Publisher,
        
        [Parameter(Mandatory=$true,Position=1)]
        [ValidateScript( {$_ -match [System.Text.RegularExpressions.Regex]::New('[A-Za-z0-9]')} )]
        [String]
        $AppName,
        
        [Parameter(Mandatory=$true,Position=2)]
        [System.Version]
        $Version,

        [Parameter(Mandatory=$true,Position=3)]
        [ValidateScript( {$_ -match [System.Text.RegularExpressions.Regex]::New('[A-Za-z0-9]')} )]
        [String]
        $AppCopyright,

        [Parameter(Mandatory=$true,Position=4)]
        [ValidateScript(
            {
                [Array]$LicenseList=@('0BSD','BSD-1-Clause','BSD-2-Clause','BSD-3-Clause','AFL-3.0','APL-1.0','Apache-1.1','Apache-2.0','APSL-2.0','Artistic-1.0','Artistic-2.0','AAL','BSL-1.0','BSD-3-Clause-LBNL','BSD-2-Clause-Patent','CECILL-2.1','CDDL-1.0','CPAL-1.0','CPL-1.0','CATOSL-1.1','CAL-1.0','CUA-OPL-1.0','EPL-1.0','EPL-2.0','eCos-2.0','ECL-1.0','ECL-2.0','EFL-2.0','Entessa','EUDatagrid','EUPL-1.2','Fair','Frameworx-1.0','AGPL-3.0','GPL-2.0','GPL-3.0','LGPL-2.1','LGPL-3.0','HPND','IPL-1.0','Intel','IPA','ISC','Jabber','LPPL-1.3c','BSD-3-Clause-LBNL','LiliQ-P','LiliQ-R','LiliQ-R+','LPL-1.0','LPL-1.02','MS-PL','MS-RL','MirOS','MIT','CVW','Motosoto','MPL-1.0','MPL-1.1','MPL-2.0','MulanPSL-2.0','Multics','NASA-1.3','Naumen','NGPL','Nokia','NPOSL-3.0','NTP','OCLC-2.0','OGTSL','OSL-1.0','OSL-2.1','OSL-3.0','OLDAP-2.8','OPL-2.1','PHP-3.0','PHP-3.01','PostgreSQL','Python-2.0','CNRI-Python','QPL-1.0','RPSL-1.0','RPL-1.1','RPL-1.5','RSCPL','OFL-1.1','SimPL-2.0','Sleepycat','SISSL','SPL-1.0','Watcom-1.0','UPL','NCSA','UCL-1.0','Unlicense','VSL-1.0','W3C','WXwindows','Xnet','ZPL-2.0','Zlib','Other','Proprietary')
                $_ -in $LicenseList
            }
        )]
        [String]
        $License,

        [Parameter(Mandatory=$true,Position=5)]
        [ValidateScript( {$_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200} )]
        [uri]
        $LicenseURI,

        [Parameter(Mandatory=$true,Position=6)]
        [Array]
        $Tags,

        [Parameter(Mandatory=$true,Position=7)]
        [String]
        $Description,

        [Parameter(Mandatory=$true,Position=8)]
        [ValidateScript( {$_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200} )]
        [uri]
        $Homepage,

        [Parameter(Mandatory=$true,Position=9)]
        [ValidateScript( {$_ -in @('x64','x86','x86_64')} )]  #~>this code needs to be updated per version, or added to a compile script somehow?
        [Array]
        $Arch,

        [Parameter(Mandatory=$false,Position=10)]
        [ValidateScript( {$_ -in ((Import-Csv -Path 'C:\tmp\software-matrix\lib\public\LCID.csv' -Delimiter ',').'BCP 47 Code')} )]  #this path needs to be changed
        [Array]
        $Languages=@('en-US'),  #default to en-US

        [Parameter(Mandatory=$false,Position=11)]
        [ValidateScript( {$_ -match [System.Text.RegularExpressions.Regex]::New('[A-Za-z0-9]\.[A-Za-z0-9]')} )]
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

        # Create return data array
        $function_return_array += $json_data_return
        $function_return_array += $AppCopyright
        $function_return_array += $Version
        $function_return_array += $Publisher
        $function_return_array += $AppName
        $function_return_array += $Version
        $function_return_array += $AppCopyright
        $function_return_array += $License
        $function_return_array += $Arch
        $function_return_array += $Languages
        $function_return_array += $Depends
        
        return $function_return_array
    }
    
    end {
        [System.GC]::Collect()
    }
}


