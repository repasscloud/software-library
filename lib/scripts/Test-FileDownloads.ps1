[array]$k = @(
  'https://zoom.us/client/5.0.24046.0510/ZoomInstallerFull.msi'
)

# Remove the files we had previously
$appDL = $env:HOME + '/Developer/software-matrix/lib/.public/'
Get-ChildItem -Path $appDL | ForEach-Object { Remove-Item -Path $_.FullName -Confirm:$false -Force }


# This function was designed to pull down a file from even a redirected URL via PowerShell
function Get-RedirectedUrl() {
    
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [uri] $Url,
        [Parameter(Position = 1)]
        [Microsoft.PowerShell.Commands.WebRequestSession] $Session = $null
    )

    $request_url = $Url
    $retry = $false
  
    do {
        try {
            $response = Invoke-WebRequest -Method Head -WebSession $Session -Uri $request_url

            if($response.BaseResponse.ResponseUri -ne $null)
            {
            # PowerShell 5
            $result = $response.BaseResponse.ResponseUri.AbsoluteUri
            } elseif ($response.BaseResponse.RequestMessage.RequestUri -ne $null) {
            # PowerShell Core
            $result = $response.BaseResponse.RequestMessage.RequestUri.AbsoluteUri
            }

            $retry = $false
        } catch {
            if(($_.Exception.GetType() -match "HttpResponseException") -and ($_.Exception -match "302")) {
                $request_url = $_.Exception.Response.Headers.Location.AbsoluteUri
                $retry = $true
            } else {
                throw $_
            }
        }  
    }
    while($retry)

    return $result
}

function Invoke-PullDownThatFile() {  
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [uri] $URI
    )
    $UrlX = Get-RedirectedUrl -Url $URI
    Invoke-Webrequest -Uri $UrlX -OutFile $($env:HOME + '/Developer/software-matrix/lib/.public/' + (Split-Path -Path $UrlX -Leaf))
}

$k | ForEach-Object { Invoke-PullDownThatFile -URI $_ }

Get-ChildItem -Path $appDL | ForEach-Object { Get-FileHash -Path $_.FullName }