<#
RePass Cloud Get-URLStatusCode.ps1
Copyright 2020 RePass Cloud Pty Ltd

This product includes software developed at
RePass Cloud (https://repasscloud.com/).
#>


function Get-UrlStatusCode() {
    #Source: https://stackoverflow.com/a/20262872
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [Uri]$Url
    )
    # First we create the request.
    $HTTP_Request=[System.Net.WebRequest]::Create($Url)
    # We then get a response from the site.
    $HTTP_Response=$HTTP_Request.GetResponse()
    # We then get the HTTP code as an integer.
    $HTTP_Status = [int]$HTTP_Response.StatusCode
    return $HTTP_Status
    # Finally, we clean up the http request by closing it.
    if ($null -eq $HTTP_Response) { } else { $HTTP_Response.Close() }
}