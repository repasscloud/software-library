#Requires -Version 5.1

Write-Output 'Install Get.URLStatusCode'
#Install-Module -Name Get.URLStatusCode

Write-Output 'Install GetRedirectedUrl'
#Install-Module -Name GetRedirectedUrl

Write-Output 'Import function'
#. $(Join-Path -Path (Get-Item $PSScriptRoot).Parent.FullName -ChildPath 'cmani_desktop-edition.ps1')

Write-Output 'Create VLC manifests'
$s = Join-Path -Path $PSScriptRoot -ChildPath test_func-vlc.ps1
& "$s"