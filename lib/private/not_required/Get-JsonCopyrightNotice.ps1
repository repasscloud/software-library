function Get-JsonCopyrightNotice {
    [CmdletBinding()]
    [OutputType([String])]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [uri]
        $JsonCopyrightNoticeURI
    )
    if (-not($JsonCopyrightNoticeURI)) {
        $f='https://gitlab.com/reform-cloud/r-and-d/software-matrix/-/raw/patch/20/lib/public/json_copyright_notice.json'
        $wc = [System.Net.WebClient]::new()
        $dl = $wc.DownloadString($f)
        $return_value='    "Copyright": "' + $($dl | ConvertFrom-Json).Copyright + '",'
        $wc.Dispose()
        [System.Threading.Thread]::Sleep(100)
        return $return_value
    }
    else {
        $f=$JsonCopyrightNoticeURI
        $wc = [System.Net.WebClient]::new()
        $dl = $wc.DownloadString($f)
        $return_value='    "Copyright": "' + $($dl | ConvertFrom-Json).Copyright + '",'
        $wc.Dispose()
        [System.Threading.Thread]::Sleep(100)
        return [String]$return_value
    }
}
