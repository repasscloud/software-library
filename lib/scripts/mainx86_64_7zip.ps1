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

# Load functions used
Get-ChildItem -Path "${repo_root_dir}\lib\scripts" -Filter "Set-NuspecValue.ps1" | ForEach-Object { . $_.FullName }
Get-ChildItem -Path "${repo_root_dir}\lib\scripts" -Filter "Set-JsonCopyrightNotice.ps1" | ForEach-Object { . $_.FullName }
Get-ChildItem -Path "${repo_root_dir}\lib\scripts" -Filter "Set-ApplicationParticulars.ps1" | ForEach-Object { . $_.FullName }
Get-ChildItem -Path "${repo_root_dir}\lib\scripts" -Filter "Set-ApplicationCategory.ps1" | ForEach-Object { . $_.FullName }

#[void][System.Console]::Clear()
#[void][System.Console]::WriteLine($appCategoryPrompt)

# Start of [String]$json_output
[String]$json_output=$null
[String]$json_output='{' + $OFS


#region Category
# Set application category
$appCat = Set-ApplicationCategory -Category 'productivity'
$json_output += $appCat
#endregion Category


#region Manifest Version
# Read current manifest version to [String]$json_output directly in-place
$manifest_json='https://gitlab.com/reform-cloud/r-and-d/software-matrix/-/raw/patch/20/lib/public/manifest_version.json'
$wc = [System.Net.WebClient]::new()
$dl = $wc.DownloadString($manifest_json)
[String]$json_output += '  "Manifest": "' + $($dl | ConvertFrom-Json).Manifest_Version + '",' + $OFS
$wc.Dispose()
#endregion Manifest Version


#region Nuspec & Copyright & Id
# Add Nuspec value to [String]$json_output
[String]$ns_val=Set-NuspecValue
[String]$json_output += $ns_val + $OFS

# Add Copyright value to [String]$json_output
#[String]$json_output += $(Set-JsonCopyrightNotice) + $OFS
[String]$json_output += '  "Copyright": "Copyright © 2020 RePassCloud.com\nLicensed under the Apache License, Version 2.0 (the \"License\");\nyou may not use this file except in compliance with the License.\nYou may obtain a copy of the License at\n\nhttp://www.apache.org/licenses/LICENSE-2.0\n\nUnless required by applicable law or agreed to in writing, software\ndistributed under the License is distributed on an \"AS IS\" BASIS,\nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\nSee the License for the specific language governing permissions and\nlimitations under the License.",'
[String]$json_output += $OFS

# Add Id value to [String]$json_output
[String]$json_output += '  "Id": {' + $OFS
#endregion Nuspec & Copyright & Id


#region Application particulars
$var=Set-ApplicationParticulars -Publisher 'Mozilla' `
    -AppName '7Zip' `
    -Version 19.00 `
    -AppCopyright '7-Zip Copyright © 1999-2016 Igor Pavlov' `
    -License LGPL-2.1 `
    -LicenseURI 'https://www.7-zip.org/license.txt' `
    -Tags @('7zip','zip','archiver') `
    -Description '7-Zip is a file archiver with a high compression ratio.' `
    -Homepage 'http://www.7-zip.org/' `
    -Arch x86_64 `
    -Languages @('en-US')
[String]$json_output += [String]$var[2] + $OFS + '    "Intallers": {' + $OFS

#endregion Application particulars


#region Application languages for installers
[String]$Arch=$var[8]
[Array]$Lang=$var[10]
$ves=Set-InstallerLanguages `
  -Arch $Arch `
  -Lang $Lang `
  -SilentSwitch '/qn /norestart' `
  -UninstallSwitch '-ms' `
  -InstallURI_x64 'https://www.7-zip.org/a/7z1900-x64.msi' `
  -InstallURI_x86 'https://www.7-zip.org/a/7z1900.msi' `
  -MsiExe_x64 MSI `
  -MsiExe_x86 MSI `
  -UpdateURI_x64 https://www.google.com/ `
  -UpdateURI_x86 https://www.google.com/ `
  -UpdateRegex_x64 '(+.*/S)' `
  -UpdateRegex_x86 '(+.*/S)'
[String]$json_output += [String]$ves + $OFS
#endregion Application languages for installers


#region Close Json
[String]$CloseJson=@"
    }
  }
}
"@
[String]$json_output += [String]$CloseJson
#endregion Close Json

git checkout -b "app/$($var[4].ToString().ToLower()).$($var[5].ToString().ToLower())/$($var[3].ToString().ToLower())"
git push --set-upstream github "app/$($var[4].ToString().ToLower()).$($var[5].ToString().ToLower())/$($var[3].ToString().ToLower())"

#region Write Manifest and Push
$filepath=$manifest_root_dir + '\' + $var[4].ToString() + '\' + $var[5].ToString()
$filename=$var[3].ToString().ToLower() + '.json'
$latestjson='latest.json'
if (-not(Test-Path -Path $filepath)) {
    New-Item -Path $filepath -ItemType Directory -Force -Confirm:$false
}

$json_output | ForEach-Object {
    $_ | Set-Content -Path $(Join-Path -Path $filepath -ChildPath $filename) -Force -Confirm:$false
    $_ | Set-Content -Path $(Join-Path -Path $filepath -ChildPath $latestjson) -Force -Confirm:$false
}

git add "app/$($var[4].ToString().ToLower())/*"
git commit -m "[autoupdate] :: $($var[4].ToString().ToLower()).$($var[5].ToString().ToLower())/$($var[3].ToString().ToLower())"
git push
git checkout 'patch/20'
git branch -d "app/$($var[4].ToString().ToLower()).$($var[5].ToString().ToLower())/$($var[3].ToString().ToLower())"
git pull
#endregion Write Manifest and Push

$json_output | Set-Content -Path C:\tmp\jjjj-dual.json -Force -Confirm:$false
