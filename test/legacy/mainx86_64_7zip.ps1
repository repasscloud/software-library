git add .
git commit -m 'stash for testing'
git push -u github 'patch/20'

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
[String]$OutTempFile=$env:TEMP + '\' + [System.Guid]::NewGuid().Guid + '.json'
$global:TempFile=$null

# Load functions used
Get-ChildItem -Path "${repo_root_dir}\lib\scripts" -Filter "Set-NuspecValue.ps1" | ForEach-Object { . $_.FullName }
Get-ChildItem -Path "${repo_root_dir}\lib\scripts" -Filter "Set-JsonCopyrightNotice.ps1" | ForEach-Object { . $_.FullName }
Get-ChildItem -Path "${repo_root_dir}\lib\scripts" -Filter "Set-ApplicationParticulars.ps1" | ForEach-Object { . $_.FullName }
Get-ChildItem -Path "${repo_root_dir}\lib\scripts" -Filter "Set-ApplicationCategory.ps1" | ForEach-Object { . $_.FullName }

#[void][System.Console]::Clear()
#[void][System.Console]::WriteLine($appCategoryPrompt)

# Start json manifest file
[String]$global:TempFile+='{' + $OFS


#region Category
# Set application category
$appCat = Set-ApplicationCategory -Category 'productivity'
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
[String]$ns_val=Set-NuspecValue
[String]$global:TempFile+=$ns_val + $OFS

# Add Copyright value to [String]$json_output
[String]$global:TempFile+='  "Copyright": "Copyright © 2020 RePassCloud.com\nLicensed under the Apache License, Version 2.0 (the \"License\");\nyou may not use this file except in compliance with the License.\nYou may obtain a copy of the License at\n\nhttp://www.apache.org/licenses/LICENSE-2.0\n\nUnless required by applicable law or agreed to in writing, software\ndistributed under the License is distributed on an \"AS IS\" BASIS,\nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\nSee the License for the specific language governing permissions and\nlimitations under the License.",'
[String]$global:TempFile+=$OFS

# Add Id value to [String]$json_output
[String]$global:TempFile+='  "Id": {' + $OFS
#endregion Nuspec & Copyright & Id


#region Application particulars
Set-ApplicationParticulars `
  -Publisher '7Zip' `
  -AppName '7Zip' `
  -Version 19.00 `
  -AppCopyright '7-Zip Copyright © 1999-2016 Igor Pavlov' `
  -License LGPL-2.1 `
  -LicenseURI 'https://www.7-zip.org/license.txt' `
  -Tags @('7zip','zip','archiver') `
  -Description '7-Zip is a file archiver with a high compression ratio.' `
  -Homepage 'http://www.7-zip.org/' `
  -Arch x86_64 `
  -Languages @('en-US','en-GB')
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

Set-InstallerLanguages `
  -Arch $global:_Arch `  `
  -Lang $global:_langList `
  -SilentSwitch '/qn /norestart' `
  -UninstallSwitch "Start-Process -FilePath msiexec -ArgumentList '/x {23170F69-40C1-2702-1900-000001000000} /qn' -Wait" `
  -InstallURI_x64 'https://www.7-zip.org/a/7z1900-x64.msi' `
  -InstallURI_x86 'https://www.7-zip.org/a/7z1900.msi' `
  -MsiExe_x64 MSI `
  -MsiExe_x86 MSI `
  -UpdateURI_x64 https://www.google.com/ `
  -UpdateURI_x86 https://www.google.com/ `
  -UpdateRegex_x64 '(+.*/S)' `
  -UpdateRegex_x86 '(+.*/S)'
[String]$global:TempFile+=[String]$ves + $OFS
#[String]$json_output += [String]$ves + $OFS
#endregion Application languages for installers


#region Close Json
[String]$CloseJson=@"
    }
  }
}
"@
[String]$global:TempFile+=[String]$CloseJson
#endregion Close Json

[String]$gitBranch="app/$($global:_Publisher).$($global:_AppName)/$($global:_Version)"
git checkout -b $gitBranch
git push --set-upstream github $gitBranch

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

git add "app/$($global:_Publisher).*"
git commit -m "[autoupdate] :: ${gitBranch}"
git push
git checkout 'patch/20'
git branch -d $gitBranch
git pull
#endregion Write Manifest and Push


