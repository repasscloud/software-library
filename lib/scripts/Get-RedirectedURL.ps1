function Get-RedirectedUrl {
<#
RePass Cloud Get-RedirectedURL.ps1
Copyright 2020 RePass Cloud Pty Ltd

This product includes software developed at
RePass Cloud (https://repasscloud.com/).

Version: 2.0.0.3
#>
[CmdletBinding()]
[OutputType([String])]
param(
    [Parameter(Mandatory=$true, Position=0)]
    [Uri] $Url,
    [Parameter(Position=1)]
    [Microsoft.PowerShell.Commands.WebRequestSession] $Session=$null
)

$request_url=$Url
$retry=$false

do {
    try {
        $response=Invoke-WebRequest -Method Head -WebSession $Session -Uri $request_url
        if ($null -ne $response.BaseResponse.ResponseUri) {
            # PowerShell 5
            $result=$response.BaseResponse.ResponseUri.AbsoluteUri
        } elseif ($null -ne $response.BaseResponse.RequestMessage.RequestUri) {
            # PowerShell Core
            $result=$response.BaseResponse.RequestMessage.RequestUri.AbsoluteUri
        }
        $retry=$false
    } catch {
        if ( ($_.Exception.GetType() -match "HttpResponseException") -and ($_.Exception -match "302") ) {
            $request_url=$_.Exception.Response.Headers.Location.AbsoluteUri
            $retry=$true
        } elseif ( ($_.Exception.GetType() -match "HttpResponseException") -and ($_.Exception -match "403") ) {
            $result=($request_url).OriginalString
            $retry=$false
        } else {
            throw $_
        }
    }  
}
while($retry)

return [String]$result
}