#Requires -PSEdition Core

function Invoke-CreateCManiCore {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Select Category of application from list provided.',
            Position=0)]
        [ValidateCount(5,14)]
        [ValidateSet('browser','business','entertainment','graphic_design','photo','social','productivity','games','security','microsoft')]
        [ValidateScript(
            {
                [Array]$CategoryArray=@('browser','business','entertainment','graphic_design','photo','social','productivity','games','security','microsoft')
                if ( $_ -in $CategoryArray ) {
                    $_
                }
                else {
                    Throw "'$_' does NOT use an approved Category selection."
                }
            }
        )]
        [Alias('cat')]
        [String]$Category,
        
        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Publisher of application. Max 30 characters.',
            Position=1)]
        [ValidateCount(1,30)]
        [Alias('pub')]
        [String]$Publisher,
        
        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Name of application. Max 30 characters.',
            Position=2)]
        [ValidateCount(1,30)]
        [Alias('nom')]
        [String]$Name,

        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Application version number using SemVer standards.',
            Position=3)]
        [Alias('ver')]
        [System.Version]$Version,

        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Copyright notice, including "©" or "Copyright" text.',
            Position=4)]
        [ValidateCount(8,563)]
        [ValidateScript(
            {
                if ( $_ -match 'Copyright' -or $_ -match [char]0x00A9 ) {
                    $_
                }
                else {
                    Throw "'$_' does NOT text `"Copyright`" or `"$([char]0x00A9)`" in notice."
                }
            }
        )]
        [Alias('copy')]
        [String]$CopyrightNotice,
        
        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='License list available online.',  #~> Update with URL
            Position=5)]
        [ValidateSet('0BSD','BSD-1-Clause','BSD-2-Clause','BSD-3-Clause','AFL-3.0','APL-1.0','Apache-1.1','Apache-2.0','APSL-2.0','Artistic-1.0','Artistic-2.0','AAL','BSL-1.0','BSD-3-Clause-LBNL','BSD-2-Clause-Patent','CECILL-2.1','CDDL-1.0','CPAL-1.0','CPL-1.0','CATOSL-1.1','CAL-1.0','CUA-OPL-1.0','EPL-1.0','EPL-2.0','eCos-2.0','ECL-1.0','ECL-2.0','EFL-2.0','Entessa','EUDatagrid','EUPL-1.2','Fair','Frameworx-1.0','AGPL-3.0','GPL-2.0','GPL-3.0','LGPL-2.1','LGPL-3.0','HPND','IPL-1.0','Intel','IPA','ISC','Jabber','LPPL-1.3c','BSD-3-Clause-LBNL','LiliQ-P','LiliQ-R','LiliQ-R+','LPL-1.0','LPL-1.02','MS-PL','MS-RL','MirOS','MIT','CVW','Motosoto','MPL-1.0','MPL-1.1','MPL-2.0','MulanPSL-2.0','Multics','NASA-1.3','Naumen','NGPL','Nokia','NPOSL-3.0','NTP','OCLC-2.0','OGTSL','OSL-1.0','OSL-2.1','OSL-3.0','OLDAP-2.8','OPL-2.1','PHP-3.0','PHP-3.01','PostgreSQL','Python-2.0','CNRI-Python','QPL-1.0','RPSL-1.0','RPL-1.1','RPL-1.5','RSCPL','OFL-1.1','SimPL-2.0','Sleepycat','SISSL','SPL-1.0','Watcom-1.0','UPL','NCSA','UCL-1.0','Unlicense','VSL-1.0','W3C','WXwindows','Xnet','ZPL-2.0','Zlib','Other','Proprietary','Proprietary freeware, based on open source components')]
        [ValidateScript(
            {
                [Array]$LicenseList=@('0BSD','BSD-1-Clause','BSD-2-Clause','BSD-3-Clause','AFL-3.0','APL-1.0','Apache-1.1','Apache-2.0','APSL-2.0','Artistic-1.0','Artistic-2.0','AAL','BSL-1.0','BSD-3-Clause-LBNL','BSD-2-Clause-Patent','CECILL-2.1','CDDL-1.0','CPAL-1.0','CPL-1.0','CATOSL-1.1','CAL-1.0','CUA-OPL-1.0','EPL-1.0','EPL-2.0','eCos-2.0','ECL-1.0','ECL-2.0','EFL-2.0','Entessa','EUDatagrid','EUPL-1.2','Fair','Frameworx-1.0','AGPL-3.0','GPL-2.0','GPL-3.0','LGPL-2.1','LGPL-3.0','HPND','IPL-1.0','Intel','IPA','ISC','Jabber','LPPL-1.3c','BSD-3-Clause-LBNL','LiliQ-P','LiliQ-R','LiliQ-R+','LPL-1.0','LPL-1.02','MS-PL','MS-RL','MirOS','MIT','CVW','Motosoto','MPL-1.0','MPL-1.1','MPL-2.0','MulanPSL-2.0','Multics','NASA-1.3','Naumen','NGPL','Nokia','NPOSL-3.0','NTP','OCLC-2.0','OGTSL','OSL-1.0','OSL-2.1','OSL-3.0','OLDAP-2.8','OPL-2.1','PHP-3.0','PHP-3.01','PostgreSQL','Python-2.0','CNRI-Python','QPL-1.0','RPSL-1.0','RPL-1.1','RPL-1.5','RSCPL','OFL-1.1','SimPL-2.0','Sleepycat','SISSL','SPL-1.0','Watcom-1.0','UPL','NCSA','UCL-1.0','Unlicense','VSL-1.0','W3C','WXwindows','Xnet','ZPL-2.0','Zlib','Other','Proprietary','Proprietary freeware, based on open source components')
                if ($_ -in $LicenseList) {
                    $_
                }
                else {
                    Throw "'$_' does NOT use an approved License type."
                }
            }
        )]
        [Alias('lic')]
        [String]$License,

        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Provide URL to license online.',  #~> Update with URL
            Position=6)]
        [ValidateScript(
            {
                if ($_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200) {
                    $_
                }
                else {
                    Throw "'$_' does NOT provide a valid URL."
                }
            }
        )]
        [Alias('licURI')]
        [uri]$LicenseURI,

        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Homepage of product',
            Position=7)]
        [ValidateScript(
            {
                if ($_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200) {
                    $_
                }
                else {
                    Throw "'$_' does NOT provide a valid URL."
                }
            }
        )]
        [Alias('web')]
        [uri]$Homepage,
        
        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Brief description of application',
            Position=8)]
        [Alias('info')]
        [String]$Description,

        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Architectures associated to application. Provided in [Array] format.',
            Position=9)]
        [ValidateSet('x64','x86')]
        [ValidateScript(
            {
                [Array]$ArchList=@('x64','x86')  #~> ARM, ARM64 support later. Link here: https://docs.microsoft.com/en-US/windows/msix/package/device-architecture
                if ($_ -in $ArchList) {
                    $_
                }
                else {
                    Throw "'$_' is NOT an approved CPU architecture."
                }
            }
        )]
        [Alias('x86_64')]
        [Array]$Arch,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Supported languages of application in [Array] format.',
            Position=10)]
        [ValidateScript(
            {
                # Set Temp directory variable to $dir_tmp by OS selection, with backwards compatibility for Windows PS5.1
                if ($IsWindows -or $Env:OS) {
                    [String]$dir_tmp=$Env:TEMP
                } else {
                    if ($IsLinux) {
                        Write-Host "Linux"
                    }
                    elseif ($IsMacOS) {
                        [String]$dir_tmp=$Env:TMPDIR
                    }
                }
                $url='https://raw.githubusercontent.com/repasscloud/software-library/master/lib/public/LCID.csv'
                $output=[System.IO.Path]::Combine($dir_tmp,$([System.GUID]::NewGUID().Guid)+'.txt')
                (New-Object System.Net.WebClient).DownloadFile($url, $output)
                if ($_ -in ((Import-Csv -Path $output -Delimiter ',').'BCP 47 Code')) {  #~> issue 53
                    $_
                }
                else{
                    Throw "'$_' does NOT provide a valid L10n Language selection."
                }
            }
        )]
        [Alias('lang')]
        [Array]$Languages='en-US',
    
        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Tags associated to application. Provided in [Array] format.',
            Position=11)]
        [Alias('tag')]
        [Array]$Tags,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Depends that require to be met first in [Array] format.',
            Position=12)]
        [ValidateScript(
            {
                if ($_ -match '(\w+\.\w+)' -and $_ -notmatch ' ') {
                    $_
                }
                else {
                    Throw "'$_' does NOT provide a valid URL." #~> this is not a URL?
                }
            }
        )]
        [Alias('needs')]
        [Array]$Depends=@(),

        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Has a Nuspec file from Chocolatey? True/False.',
            Position=13)]
        [ValidateSet($true,$false)]
        [Alias('chocofile')]
        [Bool]$HasNuspec,
        
        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Chocolatey Nuspec file URI.',
            Position=14)]
        [ValidateScript(
            {
                if ($_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200) {
                    $_
                }
                else {
                    Throw "'$_' does NOT provide a valid URL."
                }
            }
        )]
        [Alias('nuspec')]
        [uri]$NuspecFile,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Select either "MSI" or "EXE"',
            Position=15)]
        [ValidateSet('msi','exe')]
        [ValidateScript(
            {
                [Array]$ExeList=@('msi','exe')
                if ($_ -in $ExeList) {
                    $_
                }
                else {
                    Throw "'$_' is NOT an approved installer type for x64 application type."
                }
            }
        )]
        [Alias('exe64')]
        [Array]$MsiExe_x64,

        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Select either "MSI" or "EXE"',
            Position=16)]
        [ValidateSet('msi','exe')]
        [ValidateScript(
            {
                [Array]$ExeList=@('msi','exe')
                if ($_ -in $ExeList) {
                    $_
                }
                else {
                    Throw "'$_' is NOT an approved installer type for x86 application type."
                }
            }
        )]
        [Alias('exe86')]
        [Array]$MsiExe_x86,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='__cannot_be_blank__',  #~> this needs to be updated
            Position=17)]
        [ValidateScript(
            {
                foreach ($i in $_) {
                    if ($_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200) {
                        $_
                    }
                    else {
                        Throw "'$_' does NOT provide a valid URL."
                    }
                }
            }
        )]
        [Alias('webinst64')]
        [Array]$InstallURI_x64,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='__cannot_be_blank__',  #~> this needs to be updated
            Position=18)]
        [ValidateScript(
            {
                foreach ($i in $_) {
                    if ($_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200) {
                        $_
                    }
                    else {
                        Throw "'$_' does NOT provide a valid URL."
                    }
                }
            }
        )]
        [Alias('webinst86')]
        [Array]$InstallURI_x86,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='__cannot_be_blank__',  #~> this needs to be updated
            Position=19)]
        [Alias('inst64')]
        [Array]$InstallExe_x64,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='__cannot_be_blank__',  #~> this needs to be updated
            Position=20)]
        [Alias('inst86')]
        [Array]$InstallExe_x86,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='__cannot_be_blank__',  #~> this needs to be updated
            Position=21)]
        [Alias('iargs64')]
        [Array]$InstallArgs_x64,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='__cannot_be_blank__',  #~> this needs to be updated
            Position=22)]
        [Alias('iargs86')]
        [Array]$InstallArgs_x86,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='__cannot_be_blank__',  #~> this needs to be updated
            Position=23)]
        [Alias('funst64')]
        [Array]$FindUninstall_x64,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='__cannot_be_blank__',  #~> this needs to be updated
            Position=24)]
        [Alias('funst86')]
        [Array]$FindUninstall_x86,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='__cannot_be_blank__',  #~> this needs to be updated
            Position=25)]
        [Alias('unstexe64')]
        [Array]$UninstallExe_x64,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='__cannot_be_blank__',  #~> this needs to be updated
            Position=26)]
        [Alias('unstexe86')]
        [Array]$UninstallExe_x86,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='__cannot_be_blank__',  #~> this needs to be updated
            Position=27)]
        [Alias('unstargs64')]
        [Array]$UninstallArgs_x64,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='__cannot_be_blank__',  #~> this needs to be updated
            Position=28)]
        [Alias('unstargs86')]
        [Array]$UninstallArgs_x86,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='__cannot_be_blank__',  #~> this needs to be updated
            Position=29)]
        [ValidateScript(
            {
                foreach ($i in $_) {
                    if ($_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200) {
                        $_
                    }
                    else {
                        Throw "'$_' does NOT provide a valid URL."
                    }
                }
            }
        )]
        [Alias('update64')]
        [Array]$UpdateURI_x64,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='__cannot_be_blank__',  #~> this needs to be updated
            Position=30)]
        [ValidateScript(
            {
                foreach ($i in $_) {
                    if ($_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200) {
                        $_
                    }
                    else {
                        Throw "'$_' does NOT provide a valid URL."
                    }
                }
            }
        )]
        [Alias('update86')]
        [Array]$UpdateURI_x86,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='__cannot_be_blank__',  #~> this needs to be updated
            Position=31)]
        [Alias('updreg64')]
        [Array]$UpdateRegex_x64,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='__cannot_be_blank__',  #~> this needs to be updated
            Position=32)]
        [Alias('updreg86')]
        [Array]$UpdateRegex_x86
    )
    
    begin {
        # Set TLS 1.2
        [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

        # Encoding utf-8
        [Console]::OutputEncoding=[System.Text.Encoding]::UTF8

        # Find the current working directory
        [String]$dir_CurrentWorking=[System.Environment]::CurrentDirectory

        # Set location variables
        [String]$dir_Public=Join-Path -Path $dir_CurrentWorking -ChildPath 'lib/public'
        [String]$dir_Scripts=Join-Path -Path $dir_CurrentWorking -ChildPath 'lib/scripts'
        [String]$dir_Templates=Join-Path -Path $dir_CurrentWorking -ChildPath 'lib/templates'
        [String]$dir_Manifests=Join-Path -Path $dir_CurrentWorking -ChildPath 'app'
        
        # Set Temp directory variable to $dir_tmp by OS selection, with backwards compatibility for Windows PS5.1
        if ($IsWindows -or $ENV:OS) {
            [String]$dir_tmp=$Env:TEMP
        } else {
            if ($IsLinux) {
                Write-Host "Linux"  #~> This needs to be tested still
            }
            elseif ($IsMacOS) {
                [String]$dir_tmp=$Env:TMPDIR
            }
        }
        
        # Import all functions
        Get-ChildItem -Path $dir_Scripts -Filter "*.ps1" -Recurse | ForEach-Object { . $_.FullName }

        # Create temporary file
        #[String]$file_tmp=[System.IO.Path]::Combine($dir_tmp,$([System.GUID]::NewGUID().Guid)+'.json')
        [String]$file_tmp=[System.IO.Path]::Combine($dir_tmp,$([System.GUID]::NewGUID().Guid))

        # Set UserAgent for downloading data
        $userAgent=[Microsoft.PowerShell.Commands.PSUserAgent]::Chrome

        # Manifest Copyright Notice
        [String]$RePassCloudManifestCopyrightNotice=@"
Copyright $([char]0x00A9) 2020 RePassCloud.com
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"@
    }
    process {
        
        # Initialise blank OrderedDictionary
        $maniDict=[System.Collections.Specialized.OrderedDictionary]@{}
        $maniDict.Category=$Category
        $maniDict.Manifest="4.3.7.9"
        $maniDict.Nuspec=if($null -ne $HasNuspec -or $HasNuspec -eq $false){[bool]$true}else{[bool]$false}
        $maniDict.NuspecURI=if($null -ne $NuspecFile){[String]$NuspecFile}else{[String]''}
        $maniDict.Copyright=$RePassCloudManifestCopyrightNotice

        # Initialise the sub OrderedDictionary
        $maniDict.Id=[System.Collections.Specialized.OrderedDictionary]@{}
        $maniDict.Id.Version=$Version.ToString()
        $maniDict.Id.Name=$Name
        $maniDict.Id.Publisher=$Publisher
        $maniDict.Id.Copyright=$CopyrightNotice
        $maniDict.Id.License=$License
        $maniDict.Id.LicenseURI=$LicenseURI
        $maniDict.Id.Homepage=$Homepage  #if($Homepage.EndsWith('/')){$Homepage}else{$Homepage+'/'}
        $maniDict.Id.Description=$Description
        $maniDict.Id.Arch=$Arch
        $maniDict.Id.Languages=$Languages
        $maniDict.Id.Tags=$Tags
        $maniDict.Id.Depends=$Depends

        #Initialise the sub-sub OrderedDictionary
        $maniDict.Id.Installers=[System.Collections.Specialized.OrderedDictionary]@{}

        # Index and apply each $Arch to sub-sub OrderedDictionary
        foreach ($_arch in $Arch) {
            $maniDict.Id.Installers.$_arch=[System.Collections.Specialized.OrderedDictionary]@{}
        
            # Index and apply each $Language to sub-sub-sub OrderedDictionary
            foreach ($_lang in $Languages) {
                $maniDict.Id.Installers.$_arch.$_lang=[System.Collections.Specialized.OrderedDictionary]@{}
            }
        }

        # x64 Section
        if ('x64' -in $Arch) {

            # Inject the data for x64
            foreach($_lang in $Languages) {

                # Msi vs Exe
                $maniDict.Id.Installers.x64.$_lang.MsiExe=$MsiExe_x64[$Languages.IndexOf($_lang)]

                # Everything concenting URI of the input
                $maniDict.Id.Installers.x64.$_lang.InstallURI=$InstallURI_x64[$Languages.IndexOf($_lang)]
                [String]$pkgdl=Get-RedirectedUrl -Url $InstallURI_x64[$Languages.IndexOf($_lang)]
                $maniDict.Id.Installers.x64.$_lang.FollowURI=$pkgdl
                Invoke-WebRequest -Uri $pkgdl -OutFile $file_tmp -WebSession $null -UserAgent $userAgent
                $maniDict.Id.Installers.x64.$_lang.Sha256=Get-FileHash -Path $file_tmp -Algorithm SHA256 | Select-Object -ExpandProperty Hash
                $maniDict.Id.Installers.x64.$_lang.Sha512=Get-FileHash -Path $file_tmp -Algorithm SHA512 | Select-Object -ExpandProperty Hash
                Remove-Item -Path $file_tmp -Force -Confirm:$false

                # Install EXE
                $maniDict.Id.Installers.x64.$_lang.InstallExe=$InstallExe_x64[$Languages.IndexOf($_lang)]

                # Install Args (for Msi/Exe)
                $maniDict.Id.Installers.x64.$_lang.InstallArgs=$InstallArgs_x64[$Languages.IndexOf($_lang)]

                # Find.Uninstall  #~> will be used in next update
                if($null -ne $FindUninstall_x64) {
                    $maniDict.Id.Installers.x64.$_lang.FindUninstall=$FindUninstall_x64[$Languages.IndexOf($_lang)]
                }

                # Uninstall Path (for Msi/Exe - because of Firefox)
                $maniDict.Id.Installers.x64.$_lang.UninstallExe=$UninstallExe_x64[$Languages.IndexOf($_lang)]
                
                # Uninstall Args (for Msi/Exe - because of Firefox)
                $maniDict.Id.Installers.x64.$_lang.UninstallArgs=$UninstallArgs_x64[$Languages.IndexOf($_lang)]

                # Update URI
                $maniDict.Id.Installers.x64.$_lang.UpdateURI=$UpdateURI_x64[$Languages.IndexOf($_lang)]
                
                # Update Regex (for Update URI, tba)
                $maniDict.Id.Installers.x64.$_lang.UpdateRegex=$UpdateRegex_x64[$Languages.IndexOf($_lang)] 
            }
        }

        # x86 Section
        if ('x86' -in $Arch) {

            # Inject the data for x86
            foreach($_lang in $Languages) {

                # Msi vs Exe
                $maniDict.Id.Installers.x86.$_lang.MsiExe=$MsiExe_x86[$Languages.IndexOf($_lang)]

                # Everything concenting URI of the input
                $maniDict.Id.Installers.x86.$_lang.InstallURI=$InstallURI_x86[$Languages.IndexOf($_lang)]
                $maniDict.Id.Installers.x86.$_lang.FollowURI='put-follow-uri-function-result-here'
                $maniDict.Id.Installers.x86.$_lang.Sha256='put-sha256-func-result-here'
                $maniDict.Id.Installers.x86.$_lang.Sha512='put-sha256-func-result-here'

                # Install EXE
                $maniDict.Id.Installers.x86.$_lang.InstallExe=$InstallExe_x86[$Languages.IndexOf($_lang)]

                # Install Args (for Msi/Exe)
                $maniDict.Id.Installers.x86.$_lang.InstallArgs=$InstallArgs_x86[$Languages.IndexOf($_lang)]

                # Find.Uninstall  #~> will be used in next update
                if($null -ne $FindUninstall_x86) {
                    $maniDict.Id.Installers.x86.$_lang.FindUninstall=$FindUninstall_x86[$Languages.IndexOf($_lang)]
                }

                # Uninstall Path (for Msi/Exe - because of Firefox)
                $maniDict.Id.Installers.x86.$_lang.UninstallExe=$UninstallExe_x86[$Languages.IndexOf($_lang)]
                
                # Uninstall Args (for Msi/Exe - because of Firefox)
                $maniDict.Id.Installers.x86.$_lang.UninstallArgs=$UninstallArgs_x86[$Languages.IndexOf($_lang)]

                # Update URI
                $maniDict.Id.Installers.x86.$_lang.UpdateURI=$UpdateURI_x86[$Languages.IndexOf($_lang)]
                
                # Update Regex (for Update URI, tba)
                $maniDict.Id.Installers.x86.$_lang.UpdateRegex=$UpdateRegex_x86[$Languages.IndexOf($_lang)]
            }
        }
        #$maniDict.Id.Version=$Version.ToString()
        #$maniDict.Id.Name=$Name
        #$maniDict.Id.Publisher=$Publisher
        $obj_r=@{}
        $obj_r.Add('Name',$Name)
        $obj_r.Add('Publisher',$Publisher)
        $obj_r.Add('Version',$Version)
        $obj_r.Add('dir_Manifests',$dir_Manifests)
        $obj_r.Add('full_extract',$([System.IO.Path]::Combine($dir_Manifests,$Publisher,$Name,$Version+'.json')))
        $obj_r.Add('maniDict',$maniDict)

        return $obj_r
        
        #$export_file=[System.IO.Path]::Combine($dir_Manifests,$($Publisher.Replace(' ','_')),$($Name.Replace(' ','_')),$($Version.Replace(' ','_')))
        #$dir_Manifests | Out-File -FilePath $export_file -Force -Confirm:$false
        #return $dir_Manifests
        #return $maniDict | ConvertTo-Json -Depth 5
    }
    end {
        [System.GC]::Collect()
    }
}
