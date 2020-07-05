<#
RePass Cloud Create-Manifest.ps1
Copyright 2020 RePass Cloud Pty Ltd

This product includes software developed at
RePass Cloud (https://repasscloud.com/).
#>

# The intent of this file is to help you generate a JSON file for publishing 
# to the Windows Package Manager repository.

# Set TLS 1.2
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

# Encoding utf-8
#[Console]::OutputEncoding=[System.Text.Encoding]::UTF8

# Linebreak
$OFS="`r`n"

# Script current directory
$currentDir = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
$ManifestDirectory = Join-Path -Path (Split-Path -Path (Split-Path -Path $currentDir -Parent) -Parent) -ChildPath 'app'

# Get all scripts in the manifest directory
Get-ChildItem -Path $ManifestDirectory -Recurse -Filter "latest.json" | ForEach-Object {
    Clear-Host;
    $j = Get-Content -Raw -Path $_.FullName | ConvertFrom-Json

    Write-Host "Installing " -ForegroundColor DarkGreen -NoNewLine
    Write-Host "$($j.Id.Name)" -ForegroundColor Yellow -NoNewline
    Write-host " from " -ForegroundColor DarkGreen -NoNewLine
    Write-Host "$($j.Id.Publisher)" -ForegroundColor Cyan
    Start-Sleep -Seconds 1;
    $j.Id.Languages | ForEach-Object {
        $lang = $_;
        Switch ($lang) {
            'en-US' {
                Write-Host "Language: " -ForegroundColor DarkGreen -NoNewline
                Write-host "en-US" -ForegroundColor Yellow
                Start-Sleep -Seconds 1;
                $j.Id.Arch | ForEach-Object {
                    $arch = $_;
                    Write-Host "Arch: " -ForegroundColor DarkGreen -NoNewline
                    Write-host "${arch}" -ForegroundColor Yellow
                    Start-Sleep -Seconds 1;
                    $j.Id.Installers.$lang.$arch
                    Start-Sleep -Seconds 1
                    Switch ($j.Id.Installers.$lang.$arch.InstallerType) {
                        'msi' {
                            $patch_17 = $j.Id.Installers.$lang.$arch.FollowUrl -replace '%20','_'
                            $outFile = Split-Path -Path $patch_17 -Leaf
                            Invoke-WebRequest -Uri $j.Id.Installers.$lang.$arch.FollowUrl -OutFile $env:TEMP\$outFile -UserAgent $null
                            if (-not((Get-FileHash -Path $env:TEMP\$outFile -Algorithm SHA512).Hash -match $j.Id.Installers.$lang.$arch.Sha512)) { break; }
                            else {Write-Host "SHA512 match" -ForegroundColor DarkGreen }
                            $install_args = "/i ${env:TEMP}\${outFile} " + $j.Id.Installers.$lang.$arch.Switches
                            $install_args
                            Start-Sleep -Seconds 3
                            Switch ($arch) {
                                'x64' {
                                    Start-Process -FilePath msiexec -ArgumentList $install_args -Wait
                                    break;
                                }
                            }
                            break;
                        }
                        'exe' {
                            $patch_17 = $j.Id.Installers.$lang.$arch.FollowUrl -replace '%20','_'
                            $outFile = Split-Path -Path $patch_17 -Leaf
                            Invoke-WebRequest -Uri $j.Id.Installers.$lang.$arch.FollowUrl -OutFile $env:TEMP\$outFile -UserAgent $null
                            if (-not((Get-FileHash -Path $env:TEMP\$outFile -Algorithm SHA512).Hash -match $j.Id.Installers.$lang.$arch.Sha512)) { break; }
                            else {Write-Host "SHA512 match" -ForegroundColor DarkGreen }
                            $install_args = $j.Id.Installers.$lang.$arch.Switches
                            $install_args
                            Start-Sleep -Seconds 3
                            Switch ($arch) {
                                'x64' {
                                    Start-Process -FilePath "${env:TEMP}\${outFile}" -ArgumentList $install_args -Wait
                                    break;
                                }
                            }
                            break;
                        }
                    }
                }
                break;
            }
        }
    }
    Clear-Host;
}

