function Get-RedirectedUrl() {

    param(
      [Parameter(Mandatory = $true, Position = 0)]
      [uri] $url,
      [Parameter(Position = 1)]
      [Microsoft.PowerShell.Commands.WebRequestSession] $session = $null
    )
  
    $request_url = $url
    $retry = $false
  
    do {
      try {
        $response = Invoke-WebRequest -Method Head -WebSession $session -Uri $request_url
  
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
        if(($_.Exception.GetType() -match "HttpResponseException") -and
          ($_.Exception -match "302"))
        {
          $request_url = $_.Exception.Response.Headers.Location.AbsoluteUri
          $retry = $true
        } else {
          throw $_
        }
      }  
    } while($retry)
  
    return $result
}
  
  $url = Get-RedirectedUrl "https://download.macromedia.com/pub/flashplayer/pdc/32.0.0.363/install_flash_player_32_ppapi.msi"
  
  Invoke-Webrequest -Uri $url -OutFile C:\netcore11.zip 




#$url64 = ""
$url32 = "https://download.macromedia.com/pub/flashplayer/pdc/32.0.0.363/install_flash_player_32_ppapi.msi"

#$appDl64 = '/Users/danijeljames/Developer/software-matrix/.public/' + (Split-Path -Path $url64 -Leaf)
$appDl32 = '/Users/danijeljames/Developer/software-matrix/.public/' + (Split-Path -Path $url32 -Leaf)

Get-ChildItem -Path . | ForEach-Object { Remove-Item -Path $_.FullName -Confirm:$false -Force}

#Invoke-WebRequest -Uri $url64 -OutFile $appDl64 -UseBasicParsing
Invoke-WebRequest -Uri $url32 -OutFile $appDl32 -UseBasicParsing

Get-ChildItem -Path . | ForEach-Object { Get-FileHash -Path $_.FullName }