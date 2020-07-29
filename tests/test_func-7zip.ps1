$qb=Invoke-CreateCManiCore -Category entertainment `
                           -Publisher '7Zip' `
                           -Name '7Zip' `
                           -Version '19.0' `
                           -CopyrightNotice "7-Zip Copyright $([char]0x00A9) 1999-2016 Igor Pavlov" `
                           -License 'GPL-2.0' `
                           -LicenseURI 'https://www.7-zip.org/license.txt' `
                           -Tags @('7zip','zip','archiver') `
                           -Description '"7-Zip is a file archiver with a high compression ratio.' `
                           -Homepage 'http://www.7-zip.org/' `
                           -Arch @('x64','x86') `
                           -Languages @('en-US','zh-CN','zh-HK','fr-FR','de-DE','id-ID','ja-JP','pt-BR','es-ES','th-TH','vi-VN') `
                           -HasNuspec $true `
                           -NuspecFile 'https://raw.githubusercontent.com/chocolatey-community/chocolatey-coreteampackages/master/automatic/7zip.install/7zip.install.nuspec' `
                           -Depends @() `
                           -InstallURI_x64 @('https://7-zip.org/a/7z1900-x64.msi','https://7-zip.org/a/7z1900-x64.msi','https://7-zip.org/a/7z1900-x64.msi','https://7-zip.org/a/7z1900-x64.msi','https://7-zip.org/a/7z1900-x64.msi','https://7-zip.org/a/7z1900-x64.msi','https://7-zip.org/a/7z1900-x64.msi','https://7-zip.org/a/7z1900-x64.msi','https://7-zip.org/a/7z1900-x64.msi','https://7-zip.org/a/7z1900-x64.msi','https://7-zip.org/a/7z1900-x64.msi') `
                           -InstallURI_x86 @('https://7-zip.org/a/7z1900.msi','https://7-zip.org/a/7z1900.msi','https://7-zip.org/a/7z1900.msi','https://7-zip.org/a/7z1900.msi','https://7-zip.org/a/7z1900.msi','https://7-zip.org/a/7z1900.msi','https://7-zip.org/a/7z1900.msi','https://7-zip.org/a/7z1900.msi','https://7-zip.org/a/7z1900.msi','https://7-zip.org/a/7z1900.msi','https://7-zip.org/a/7z1900.msi') `
                           -MsiExe_x64 @('msi','msi','msi','msi','msi','msi','msi','msi','msi','msi','msi') `
                           -MsiExe_x86 @('msi','msi','msi','msi','msi','msi','msi','msi','msi','msi','msi') `
                           -InstallExe_x64 @('7z1900-x64.msi','7z1900-x64.msi','7z1900-x64.msi','7z1900-x64.msi','7z1900-x64.msi','7z1900-x64.msi','7z1900-x64.msi','7z1900-x64.msi','7z1900-x64.msi','7z1900-x64.msi','7z1900-x64.msi') `
                           -InstallExe_x86 @('7z1900.msi','7z1900.msi','7z1900.msi','7z1900.msi','7z1900.msi','7z1900.msi','7z1900.msi','7z1900.msi','7z1900.msi','7z1900.msi','7z1900.msi') `
                           -InstallArgs_x64 @('/qn','/qn','/qn','/qn','/qn','/qn','/qn','/qn','/qn','/qn','/qn') `
                           -InstallArgs_x86 @('/qn','/qn','/qn','/qn','/qn','/qn','/qn','/qn','/qn','/qn','/qn') `
                           -UninstallExe_x64 @('C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe') `
                           -UninstallExe_x86 @('C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe','C:\Windows\System32\msiexec.exe') `
                           -UninstallArgs_x64 @('/x {23170F69-40C1-2702-1900-000001000000} /qn','/x {23170F69-40C1-2702-1900-000001000000} /qn','/x {23170F69-40C1-2702-1900-000001000000} /qn','/x {23170F69-40C1-2702-1900-000001000000} /qn','/x {23170F69-40C1-2702-1900-000001000000} /qn','/x {23170F69-40C1-2702-1900-000001000000} /qn','/x {23170F69-40C1-2702-1900-000001000000} /qn','/x {23170F69-40C1-2702-1900-000001000000} /qn','/x {23170F69-40C1-2702-1900-000001000000} /qn','/x {23170F69-40C1-2702-1900-000001000000} /qn','/x {23170F69-40C1-2702-1900-000001000000} /qn') `
                           -UninstallArgs_x86 @('/x {23170F69-40C1-2701-1900-000001000000} /qn','/x {23170F69-40C1-2701-1900-000001000000} /qn','/x {23170F69-40C1-2701-1900-000001000000} /qn','/x {23170F69-40C1-2701-1900-000001000000} /qn','/x {23170F69-40C1-2701-1900-000001000000} /qn','/x {23170F69-40C1-2701-1900-000001000000} /qn','/x {23170F69-40C1-2701-1900-000001000000} /qn','/x {23170F69-40C1-2701-1900-000001000000} /qn','/x {23170F69-40C1-2701-1900-000001000000} /qn','/x {23170F69-40C1-2701-1900-000001000000} /qn','/x {23170F69-40C1-2701-1900-000001000000} /qn') `
                           -UpdateURI_x64 @('https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install') `
                           -UpdateURI_x86 @('https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install','https://chocolatey.org/packages/7zip.install') `
                           -UpdateRegex_x64 @('') `
                           -UpdateRegex_x86 @('')
$qb