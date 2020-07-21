$R = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayVersion -like '78.0.1'} | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate, HelpLink, UninstallString

$R | ForEach-Object {
    $obj = $_
    if ($obj.DisplayName -like 'Mozilla Firefox 78.0.1 (x64 en-US)') {
        Write-Host 'OK' -ForegroundColor Green
        return 0
    } else {
        return 1
    }
}