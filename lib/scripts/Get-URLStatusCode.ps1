<#
RePass Cloud Get-URLStatusCode.ps1
Copyright 2020 RePass Cloud Pty Ltd

This product includes software developed at
RePass Cloud (https://repasscloud.com/).

Version: 2.0.0.1
#>

# Stems from issue #24
# Returns the Status Code of a web URL that is passed in as an arg
# Should always return a 200 result to be successful
# List of URL status codes can be found here: https://www.w3.org/Protocols/HTTP/HTRESP.html

# Usage:
#
#    $query = Get-URLStatusCode -Url https://www.com/
#    $query


function Get-UrlStatusCode {
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
