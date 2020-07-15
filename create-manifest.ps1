Push-Location
Set-Location C:\tmp\software-matrix

git add .
git commit -m 'stash for app matrix'
git push -u origin master

# Set TLS 1.2
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

# Encoding utf-8
[Console]::OutputEncoding=[System.Text.Encoding]::UTF8

# Linebreak
$OFS="`r`n"

# Repo directories
#$currentDir = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
#$repo_root_dir = Split-Path -Path (Split-Path -Path $currentDir -Parent) -Parent
#$manifest_root_dir = Join-Path -Path $repo_root_dir -ChildPath 'app'
$repo_root_dir='C:\tmp\software-matrix'
$manifest_root_dir='C:\tmp\software-matrix\app'

# Set temporary file for writing information to, as a global variable
$global:TempFile=$null

# Load functions used
Get-ChildItem -Path "${repo_root_dir}\lib\scripts" -Filter "Export-NuspecValue.ps1" | ForEach-Object { . $_.FullName }
Get-ChildItem -Path "${repo_root_dir}\lib\scripts" -Filter "Get-JsonCopyrightNotice.ps1" | ForEach-Object { . $_.FullName }
Get-ChildItem -Path "${repo_root_dir}\lib\scripts" -Filter "Get-ApplicationParticulars.ps1" | ForEach-Object { . $_.FullName }
Get-ChildItem -Path "${repo_root_dir}\lib\scripts" -Filter "Get-ApplicationCategory.ps1" | ForEach-Object { . $_.FullName }

#[void][System.Console]::Clear()
#[void][System.Console]::WriteLine($appCategoryPrompt)

# Start json manifest file
[String]$global:TempFile+='{' + $OFS


#region Category
# Set application category
$appCat = Get-ApplicationCategory -Category 'browser'
[String]$global:TempFile+=$appCat
#endregion Category


#region Manifest Version
# Read current manifest version to [String]$json_output directly in-place
$manifest_json='https://gitlab.com/reform-cloud/r-and-d/software-matrix/-/raw/patch/20/lib/public/manifest_version.json'
$wc = [System.Net.WebClient]::new()
$dl = $wc.DownloadString($manifest_json)
[String]$global:TempFile+='  "Manifest": "' + $($dl | ConvertFrom-Json).Manifest_Version + '",' + $OFS
$wc.Dispose()
#endregion Manifest Version


#region Nuspec & Copyright & Id
# Add Nuspec value to [String]$json_output
[String]$ns_val=Export-NuspecValue -NuspecURI 'https://raw.githubusercontent.com/chocolatey-community/chocolatey-coreteampackages/master/automatic/firefox/firefox.nuspec'
[String]$global:TempFile+=$ns_val + $OFS

# Add Copyright value to [String]$json_output
[String]$global:TempFile+='  "Copyright": "Copyright © 2020 RePassCloud.com\nLicensed under the Apache License, Version 2.0 (the \"License\");\nyou may not use this file except in compliance with the License.\nYou may obtain a copy of the License at\n\nhttp://www.apache.org/licenses/LICENSE-2.0\n\nUnless required by applicable law or agreed to in writing, software\ndistributed under the License is distributed on an \"AS IS\" BASIS,\nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\nSee the License for the specific language governing permissions and\nlimitations under the License.",'
[String]$global:TempFile+=$OFS

# Add Id value to [String]$json_output
[String]$global:TempFile+='  "Id": {' + $OFS
#endregion Nuspec & Copyright & Id


#region Application particulars
Get-ApplicationParticulars `
  -Publisher 'Mozilla' `
  -AppName 'Firefox' `
  -Version 78.0.2 `
  -AppCopyright 'Copyright © 1998–2020 Mozilla Foundation' `
  -License 'MPL-2.0' `
  -LicenseURI 'https://www.mozilla.org/en-US/MPL/' `
  -Tags @('browser','mozilla','firefox') `
  -Description 'Bringing together all kinds of awesomeness to make browsing better for you..' `
  -Homepage 'https://www.mozilla.org/en-US/firefox/new/' `
  -Arch x86_64 `
  -Languages @('en-US')
[String]$global:TempFile+='    "Intallers": {' + $OFS
#endregion Application particulars


#region Application languages for installers
#[String]$global:_AppCopyright=$AppCopyright
#[String]$global:_Version=$Version
#[String]$global:_Publisher=$Publisher
#[String]$global:_AppName=$AppName
#[String]$global:_AppCopyright=$AppCopyright
#[String]$global:_License=$License
#[String]$global:_Arch=$Arch
#[String]$global:_Depends=$Depends
#[String]$global:_langList=$langList
#[String]$Arch=$global:_Arch
#[Array]$Lang=$global:_langList


$ves=Export-InstallerLanguages `
  -Arch $global:_Arch `  `
  -Lang $global:_langList `
  -MsiExe_x64 MSI `
  -MsiExe_x86 MSI `
  -SilentInstallString_x64 '/qn' `
  -SilentInstallString_x86 '/qn' `
  -SilentUninstallString_x64 "Start-Process -FilePath 'C:\Program Files\Mozilla Firefox\uninstall\helper.exe' -ArgumentList '/s' -Wait" `
  -SilentUninstallString_x86 "Start-Process -FilePath 'C:\Program Files (x86)\Mozilla Firefox\uninstall\helper.exe' -ArgumentList '/s' -Wait" `
  -UpdateURI_x64 'https://www.mozilla.org/en-US/firefox/releasenotes/' `
  -UpdateURI_x86 'https://www.mozilla.org/en-US/firefox/releasenotes/' `
  -UpdateRegex_x64 'none' `
  -UpdateRegex_x86 'none' `
  -InstallURI_x64 'https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win64&lang=en-US' `
  -InstallURI_x86 'https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win&lang=en-US'
[String]$global:TempFile+=[String]$ves + $OFS
#endregion Application languages for installers


#region Close Json
[String]$CloseJson=@"
    }
  }
}
"@
[String]$global:TempFile+=[String]$CloseJson
#endregion Close Json

[String]$gitBranch="app/$($global:_Publisher).$($global:_AppName)/$($global:_Version)".Replace(' ','_')
git checkout -b $gitBranch
git push --set-upstream origin $gitBranch

#region Write Manifest and Push
$filepath=$manifest_root_dir + '\' + $global:_Publisher.ToString() + '\' + $global:_AppName.ToString()
$filename=$global:_Version.ToLower() + '.json'
$latestjson='latest.json'
if (-not(Test-Path -Path $filepath)) {
    New-Item -Path $filepath -ItemType Directory -Force -Confirm:$false
}

[String]$global:TempFile | ForEach-Object {
    $_ | Set-Content -Path $(Join-Path -Path $filepath -ChildPath $filename) -Force -Confirm:$false
    $_ | Set-Content -Path $(Join-Path -Path $filepath -ChildPath $latestjson) -Force -Confirm:$false
}

git add .
git commit -m "[autoupdate] :: ${gitBranch}"
git push
git checkout 'master'
#git branch -d $gitBranch
#git pull
#endregion Write Manifest and Push

Pop-Location