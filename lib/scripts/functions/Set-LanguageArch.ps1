<#
RePass Cloud Set-LanguageArch.ps1
Copyright 2020 RePass Cloud Pty Ltd

This product includes software developed at
RePass Cloud (https://repasscloud.com/).

Version: 2.0.0.26
#>

# Architecture choices come from: https://gitlab.com/reform-cloud/r-and-d/software-matrix/-/raw/patch/20/lib/public/installer_type.ini
# Update in future release to ensure is pointing to Master branch only
# Uses 'en-US' as default language, unless specified

# Usage:
#
#    $query = Read-Host -Prompt $(Set-LanguageArch)
#    $query

function Set-LanguageArch() {
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [Uri]$Url='https://gitlab.com/reform-cloud/r-and-d/software-matrix/-/raw/patch/20/lib/public/installer_type.ini',
        [Parameter(Mandatory=$false, Position=1)]
        [String]$Language='en-US'
    )

    $request_url=$Url
    [String]$m = @"
    For installer language ${Language}, select architecture
"@
    [int]$c = 1
    $wc = [System.Net.WebClient]::new()
    $stream = $wc.OpenRead($request_url)
    $reader = [System.IO.StreamReader]($stream)
    while (-not($reader.EndOfStream)) {
        $line = $reader.ReadLine();
        $m += "`r`n" + '    [' + $c + ']  ' + $line;
        $c += 1;
    }
    $reader.Close()
    $wc.Dispose()
    $m += "`r`n`r`n" + '  Make selection'
    
    return $m
}
