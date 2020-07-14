<#
RePass Cloud Show-HostOutput.ps1
Copyright 2020 RePass Cloud Pty Ltd

This product includes software developed at
RePass Cloud (https://repasscloud.com/).

Version: 1.0.0.0

This shim function was created to satisfy Issue #41 via Codacy
#>

function Show-HostOutput {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateScript({
                $_.Length -gt 0
        })]
        [String]
        $ScreenOutput
    )
    Write-Host $ScreenOutput
}