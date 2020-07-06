<#
RePass Cloud Set-InstallerLanguageCode.ps1
Copyright 2020 RePass Cloud Pty Ltd

This product includes software developed at
RePass Cloud (https://repasscloud.com/).
#>


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
            1 {  #x64
                [Int16]$archType=1;
                [String]$global:Json19b='        "Arch": ["x64"],';
            }
            2 {  #x86
                [Int16]$archType=2
                [String]$global:Json19b='        "Arch": ["x86"],';
            }
            3 {  #x86_x64
                [Int16]$archType=3
                [String]$global:Json19b='        "Arch": ["x64","x86"],';
            }
            Default { }
        }
        
    } until ($architecture -lt 4 -and $architecture -gt 0)
    return [int]$archType
    Clear-Host;
}