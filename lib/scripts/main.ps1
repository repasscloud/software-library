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
$appCat = Set-ApplicationCategory -Category 'browser'
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
$var=Set-ApplicationParticulars -Publisher 'Google' `
    -AppName 'Chrome' `
    -Version 83.0.4103.116 `
    -AppCopyright 'Copyright © 2020 Google LLC. All rights reserved.' `
    -License 'Proprietary freeware, based on open source components' `
    -LicenseURI https://www.google.com/intl/en/chrome/terms/ `
    -Tags @('google','chrome','web','internet','browser') `
    -Description 'Chrome is a fast, simple, and secure web browser, built for the modern web.' `
    -Homepage https://www.google.com/chrome/browser/ `
    -Arch x86_64 `
    -Languages @('en-US','en-GB')
[String]$json_output += [String]$var[2] + $OFS + '    "Intallers": {' + $OFS

#endregion Application particulars


#region Application languages for installers
[String]$Arch=$var[9]
[Array]$Lang=$var[11]
$ves=Set-InstallerLanguages `
  -Arch $Arch `
  -Lang $Lang `
  -SilentSwitch '/qn' `
  -UninstallSwitch '/uninstall_string_here' `
  -InstallURI_x64 'https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi' `
  -InstallURI_x86 'https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise.msi' `
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

$json_output | Set-Content -Path C:\tmp\jjjj-dual.json -Force -Confirm:$false


#############################################################################################################################################

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
$appCat = Set-ApplicationCategory -Category 'browser'
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
$var=Set-ApplicationParticulars -Publisher 'Google' `
    -AppName 'Chrome' `
    -Version 83.0.4103.116 `
    -AppCopyright 'Copyright © 2020 Google LLC. All rights reserved.' `
    -License 'Proprietary freeware, based on open source components' `
    -LicenseURI https://www.google.com/intl/en/chrome/terms/ `
    -Tags @('google','chrome','web','internet','browser') `
    -Description 'Chrome is a fast, simple, and secure web browser, built for the modern web.' `
    -Homepage https://www.google.com/chrome/browser/ `
    -Arch x64 `
    -Languages @('en-US','en-GB')
[String]$json_output += [String]$var[2] + $OFS + '    "Intallers": {' + $OFS

#endregion Application particulars


#region Application languages for installers
[String]$Arch=$var[9]
[Array]$Lang=$var[11]
$ves=Set-InstallerLanguages -Lang $Lang `
  -SilentSwitch '/qn' `
  -UninstallSwitch '/uninstall_string_here' `
  -Arch $Arch `
  -MsiExe MSI `
  -UpdateURI https://www.google.com/ `
  -UpdateRegex '(+.*/S)' `
  -InstallURI_x64 'https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi'
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

$json_output | Set-Content -Path C:\tmp\jjjj.json -Force -Confirm:$false




#############################################################################################################################################


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
$appCat = Set-ApplicationCategory -Category 'browser'
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
$var=Set-ApplicationParticulars -Publisher 'Google' `
    -AppName 'Chrome' `
    -Version 83.0.4103.116 `
    -AppCopyright 'Copyright © 2020 Google LLC. All rights reserved.' `
    -License 'Proprietary freeware, based on open source components' `
    -LicenseURI https://www.google.com/intl/en/chrome/terms/ `
    -Tags @('google','chrome','web','internet','browser') `
    -Description 'Chrome is a fast, simple, and secure web browser, built for the modern web.' `
    -Homepage https://www.google.com/chrome/browser/ `
    -Arch x86 `
    -Languages @('en-US','en-GB')
[String]$json_output += [String]$var[2] + $OFS + '    "Intallers": {' + $OFS
#endregion Application particulars


#region Application languages for installers
[String]$Arch=$var[9]
[Array]$Lang=$var[11]
$ves=Set-InstallerLanguages -Lang $Lang `
  -SilentSwitch '/qn' `
  -UninstallSwitch '/uninstall_string_here' `
  -Arch $Arch `
  -MsiExe MSI `
  -UpdateURI https://www.google.com/ `
  -UpdateRegex '(+.*/S)' `
  -InstallURI_x86 'https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi'
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


$json_output | Set-Content -Path C:\tmp\jjjj-x86.json -Force -Confirm:$false