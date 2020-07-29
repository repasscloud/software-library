Get-ChildItem -Path C:\projects\software-matrix\app -Recurse -Filter "latest.json" | ForEach-Object {
    [String]$m=$_.FullName
    $json=Get-Content -Path $m -Raw | ConvertFrom-Json -Depth 5
    
    foreach($i in $json.Id.Languages) {
        Switch($json.Id.Arch) {
            'x64' {
                Switch($json.Id.Installers.x64.$i.MsiExe) {
                    'msi' {
                        [String]$outFile="$($Env:TEMP)\$($json.Id.Installers.x64.$i.InstallExe)"
                        Write-Output "Downloading $($json.Id.Name) by $($json.Id.Publisher), version $($json.Id.Version) in language $($i)"
                        Write-Output "Download URL: $($json.Id.Installers.x64.$i.FollowURI)"
                        Write-Output "Output File: $($outFile)"
                        Invoke-WebRequest -Uri $json.Id.Installers.x64.$i.FollowURI -OutFile $outFile -UserAgent $null
                        Write-Output 'Testing file hash'
                        (Get-FileHash -Path $outFile -Algorithm SHA512 | Select-Object -ExpandProperty Hash) -eq $json.Id.Installers.x64.$i.Sha512
                        Start-Sleep -Seconds 1
                        Write-Output 'Installing application...'
                        Write-Output "Install Args: $($json.Id.Installers.x64.$i.InstallArgs)"
                        Start-Process -FilePath msiexec -ArgumentList "/i $($outFile) $($json.Id.Installers.x64.$i.InstallArgs)" -Wait
                        Write-Output 'Application installed!'
                        Write-Output 'Uninstalling application now'
                        Write-Output "Uninstall Exe: $($json.Id.Installers.x64.$i.UninstallExe)"
                        Write-Output "Uninstall Args: $($json.Id.Installers.x64.$i.UninstallArgs)"
                        Write-Output "Uninstall application $($json.Id.Installers.x64.$i.UninstallExe)"
                        if (-not(Test-Path -Path $json.Id.Installers.x64.$i.UninstallExe)) {
                            pause
                        }
                        else {
                            Start-Process -FilePath $json.Id.Installers.x64.$i.UninstallExe -ArgumentList $json.Id.Installers.x64.$i.UninstallArgs -Wait
                            Remove-Item -Path $outFile -Force -Confirm:$false
                            Write-Host '=============[ END ]============='
                        }
                    }
                    Default {
                        # do nothing
                    }
                }
            }
            Default {
                # do nothing
            }
        }
    }    
}
