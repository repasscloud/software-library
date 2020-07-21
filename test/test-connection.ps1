# First we create the request
$HTTP_Request = [System.Net.WebRequest]::Create('https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v7.8.8/npp.7.8.8.Installer.x64.exe')

# We then get a response from the site.
$HTTP_Response = $HTTP_Request.GetResponse()

# We then get the HTTP code as an integer.
$HTTP_Status = [int]$HTTP_Response.StatusCode

If ($HTTP_Status -eq 200) {
    Write-Host "Site is OK!"
}
Else {
    Write-Host "The Site may be down, please check!"
}

# Finally, we clean up the http request by closing it.
If ($HTTP_Response -eq $null) { } 
Else { $HTTP_Response.Close() }



function Get-UrlStatusCode() {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [Uri] $Url
    )
    # First we create the request
    $HTTP_Request=[System.Net.WebRequest]::Create('https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v7.8.8/npp.7.8.8.Installer.x64.exe')
    # We then get a response from the site.
    $HTTP_Response=$HTTP_Request.GetResponse()
    # We then get the HTTP code as an integer.
    $HTTP_Status = [int]$HTTP_Response.StatusCode
    return $HTTP_Status
    # Finally, we clean up the http request by closing it.
    if ($null -eq $HTTP_Response) { } else { $HTTP_Response.Close() }
}