Switch ($InstallerType) {
    1 {
        if ($InstallSwitches -ne $null) {
            [String]$Json20_34 += '                    "InstallCommand": "msiexec /i ' + ' /qn"' + $OFS
        } else {
            [String]$Json20_34 += '                    "InstallCommand": "msiexec /i ' + $InstallSwitches + ' /qn"' + $OFS
        }
    }
    2 {
        if ($InstallSwitches -ne $null) {
            [String]$Json20_34 += '                    "InstallCommand": ""' + $OFS
        } else {
            [String]$Json20_34 += '                    "InstallCommand": " ' + $InstallSwitches + '"' + $OFS
        }
    }
    3 {
        if ($InstallSwitches -ne $null) {
            [String]$Json20_34 += '                    "InstallCommand": "msiexec /i ' + ' /qn"' + $OFS
        } else {
            [String]$Json20_34 += '                    "InstallCommand": "msiexec /i ' + $InstallSwitches + ' /qn"' + $OFS
        }
    }
    Default { }
}

# browser mozilla firefox admin foss cross-platform



<#
"checkver": {
    "url": "https://www.mozilla.org/zh-CN/firefox/all/",
    "re": "data-latest-firefox="([\d.]+)"
},#>



((Invoke-WebRequest –Uri ‘http://howtogeek.com’).Links | Where-Object {$_.href -like “http*”} | Where class -eq “title”).Title


$r = Invoke-WebRequest -Uri 'https://www.mozilla.org/firefox/all/' -UserAgent $null
$r.Links | Where-Object {$_.href -like "https://download.mozilla.org/?product=firefox-msi-latest-ssl&amp;os=win64&amp;lang=zh-CN" } | Select-Object href

$t = @()
Get-ChildItem -Path C:\tmp\software-matrix\test\scoop-extras\bucket -Filter "*.json" | ForEach-Object {
    $r = Get-Content -Path $_.FullName | ConvertFrom-Json
    if($r.license -like 'GPL-3.0-or-later,GPL-2.0-or-later,GPL-3.0-only,GPL-2.0-only,Apache-2.0,MIT,Artistic-2.0,BSD-3-Clause,BSD-2-Clause-FreeBSD,Xerox,OFL-1.1,Public Domain') {
        $r
    }
    #if (($r.license).GetType().Name -like 'String') {
    #    $t += $r.license
    #}
}
$t | Sort-Object -Unique





$r = 




function Get-RegexVersionLookup() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [Uri]$URI,
        [Parameter(Mandatory=$true, Position=1)]
        [String]$Regex   
    )

    $request_url = $URI
    return (([Regex]::New($Regex)).Matches($(Invoke-WebRequest -Uri $request_url -UserAgent $null -WebSession $null).RawContent)).Value -replace '<[^>]+>',''
}

Get-RegexVersionLookup -URI 'https://www.mozilla.org/en-US/firefox/notes' -Regex '<div class="c-release-version">([\d.]+)</div>'


(Get-RegexVersionLookup -URI 'https://code.visualstudio.com/updates' -Regex '<p><strong>Update ([\d.]+)</strong>').Replace('Update ','')
