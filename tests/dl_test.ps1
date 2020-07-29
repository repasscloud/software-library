if ($IsWindows -or $ENV:OS) {
    [String]$dir_tmp=$Env:TEMP
} else {
    if ($IsLinux) {
        Write-Output "Linux"  #~> This needs to be tested still
        exit 0
    }
    elseif ($IsMacOS) {
        [String]$dir_tmp=$Env:TMPDIR
    }
}
[String]$file_tmp=[System.IO.Path]::Combine($dir_tmp,$([System.GUID]::NewGUID().Guid))

[String]$u=Get-RedirectedUrl -Url 'https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win&lang=en-GB'
# [String]$u=(Get-RedirectedUrl -Url 'https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win&lang=en-GB').Replace('%20','_')
# [Microsoft.PowerShell.Commands.PSUserAgent].GetProperties() | Select-Object Name, @{n='UserAgent';e={ [Microsoft.PowerShell.Commands.PSUserAgent]::$($_.Name) }}

$userAgent=[Microsoft.PowerShell.Commands.PSUserAgent]::Chrome
Invoke-WebRequest -Uri $u -OutFile $file_tmp -WebSession $null -UserAgent $userAgent

$256=Get-FileHash -Path $file_tmp -Algorithm SHA256 | Select-Object -ExpandProperty Hash
$512=Get-FileHash -Path $file_tmp -Algorithm SHA512 | Select-Object -ExpandProperty Hash

$wc=[System.Net.WebClient]::New()
$FileHash = Get-FileHash -InputStream ($wc.OpenRead($u)) -Algorithm SHA256
$FileHash.Hash
$wc.Dispose()

