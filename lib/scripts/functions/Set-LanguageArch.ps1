<#
RePass CloudSet-LanguageArch.ps1
Copyright 2020 RePass Cloud Pty Ltd

This product includes software developed at
RePass Cloud (https://repasscloud.com/).
#>

# Architecture choices come from: https://gitlab.com/reform-cloud/r-and-d/software-matrix/-/raw/patch/20/lib/public/installer_type.ini
# Update in future release to ensure is pointing to Master branch only

[String]$m = @"
  For installer language ${Language}, select architecture
"@
[int]$c = 1
$f = 'https://gitlab.com/reform-cloud/r-and-d/software-matrix/-/raw/patch/20/lib/public/installer_type.ini'
$wc = [System.Net.WebClient]::new()
$stream = $wc.OpenRead($f)
$reader = [System.IO.StreamReader]($stream)
while (-not($reader.EndOfStream)) {
    $line = $reader.ReadLine();
    $m += "`r`n" + '    [' + $c + ']  ' + $line;
    $c += 1;
}
$reader.Close()
$wc.Dispose()
$m





