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
        [ValidateNotNull]
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
        [ValidateNotNull]
        [ValidateCount(1,30)]
        [Alias('pub')]
        [String]$Publisher,
        

        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Name of application. Max 30 characters.',
            Position=2)]
        [ValidateNotNull]
        [ValidateCount(1,30)]
        [Alias('nom')]
        [String]$Name,

        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Application version number using SemVer standards.',
            Position=3)]
        [ValidateNotNull]
        [Alias('ver')]
        [System.Version]$Version,
        

        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Copyright notice, including "'+$([char]0x00A9)+'" or "Copyright" text.',
            Position=4)]
        [ValidateNotNull]
        [ValidateCount(10,120)]
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
        [ValidateNotNull]
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
        [ValidateNotNull]
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
            HelpMessage='Tags associated to application. Provided in [Array] format.',
            Position=7)]
        [ValidateNotNull]
        [Alias('tag')]
        [Array]$Tags,


        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Brief description of application',
            Position=8)]
        [ValidateNotNull]
        [Alias('info')]
        [uri]$Description,


        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Homepage of product',
            Position=9)]
        [ValidateNotNull]
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
            HelpMessage='Architectures associated to application. Provided in [Array] format.',
            Position=10)]
        [ValidateNotNull]
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


        [Parameter(Mandatoryfalse,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Supported languages of application in [Array] format.',
            Position=11)]
        [ValidateNotNull]
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
            HelpMessage='Chocolatey Nuspec file URI.',
            Position=12)]
        [ValidateNotNull]
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
            HelpMessage='Depends that require to be met first in [Array] format.',
            Position=13)]
        [ValidateNotNull]
        [ValidateScript(
            {
                if ($_ -match '\.' -and $_ -notmatch ' ') {
                    $_
                }
                else {
                    Throw "'$_' does NOT provide a valid URL."
                }
            }
        )]
        [Alias('needs')]
        [Array]$Depends=@(),


        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Select either "MSI" or "EXE"',
            Position=14)]
        [ValidateNotNull]
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
        [String]$MsiExe_x64,


        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Select either "MSI" or "EXE"',
            Position=15)]
        [ValidateNotNull]
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
        [String]$MsiExe_x86,


        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='',
            Position=16)]
        [ValidateNotNull]
        [Alias('inst64')]
        [Array]$InstallArgs_x64,


        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='',
            Position=17)]
        [ValidateNotNull]
        [Alias('inst86')]
        [Array]$InstallArgs_x86,


        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='',
            Position=18)]
        [ValidateNotNull]
        [Alias('unstexe64')]
        [Array]$UninstallExe_x64,


        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='',
            Position=19)]
        [ValidateNotNull]
        [Alias('unstexe86')]
        [Array]$UninstallExe_x86,


        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='',
            Position=20)]
        [ValidateNotNull]
        [Alias('unstargs64')]
        [Array]$UninstallArgs_x64,


        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='',
            Position=21)]
        [ValidateNotNull]
        [Alias('unstargs86')]
        [Array]$UninstallArgs_x86,


        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='',
            Position=22)]
        [ValidateNotNull]
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
            HelpMessage='',
            Position=23)]
        [ValidateNotNull]
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
            HelpMessage='',
            Position=24)]
        [ValidateNotNull]
        [Alias('updreg64')]
        [Array]$UpdateRegex_x64,


        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='',
            Position=25)]
        [ValidateNotNull]
        [Alias('updreg86')]
        [Array]$UpdateRegex_x86,


        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='',
            Position=26)]
        [ValidateNotNull]
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
        [Alias('insturi64')]
        [Array]$InstallURI_x64,


        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='',
            Position=27)]
        [ValidateNotNull]
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
        [Alias('insturi86')]
        [Array]$InstallURI_x86
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
                Write-Host "Linux"
            }
            elseif ($IsMacOS) {
                [String]$dir_tmp=$Env:TMPDIR
            }
        }
        

        # Import all functions
        Get-ChildItem -Path $dir_Scripts -Filter "*.ps1" -Recurse | ForEach-Object { . $_.FullName }

        # Create temporary file
        [String]$file_tmp=[System.IO.Path]::Combine($dir_tmp,$([System.GUID]::NewGUID().Guid)+'.json')
    }
    
    process {

        
        # Initialise blank OrderedDictionary
        $maniDict=[System.Collections.Specialized.OrderedDictionary]@{}
        $maniDict.Category=$Category
        $maniDict.Manifest="4.2.4.6"
        $maniDict.Nuspec=if($null -ne $NuspecFile){[bool]$true}else{[bool]$false}
        $maniDict.NuspecURI=if($null -ne $NuspecFile){[String]$NuspecFile}else{[String]''}
        $maniDict.Copyright='our license goes here'

        # Initialise the sub OrderedDictionary
        $maniDict.Id=[System.Collections.Specialized.OrderedDictionary]@{}
        $maniDict.Id.Version=$Version.ToString()
        $maniDict.Id.Name=$Name
        $maniDict.Id.Publisher=$Publisher
        $maniDict.Id.Copyright=$CopyrightNotice
        $maniDict.Id.Tags=$Tags
        $maniDict.Id.Description=$Description
        $maniDict.Id.Homepage=$Homepage  #if($Homepage.EndsWith('/')){$Homepage}else{$Homepage+'/'}
        $maniDict.Id.Arch=$Arch
        $maniDict.Id.Languages=$Languages
        $maniDict.Id.Depends=$Depends

        # Initialise the sub-sub OrderedDictionary
        $maniDict.Id.Installers=[System.Collections.Specialized.OrderedDictionary]@{}

        # Index and apply each $Arch to sub-sub OrderedDictionary
        foreach ($i in $Arch) {
            $maniDict.Id.Installers.$i=[System.Collections.Specialized.OrderedDictionary]@{}
        
            # Index and apply each $Language to sub-sub-sub OrderedDictionary
            foreach ($f in $Languages) {
                $maniDict.Id.Installers.$i.$f=[System.Collections.Specialized.OrderedDictionary]@{}
            }
        }

        # x64 Section
        if ('x64' -in $Arch) {

            # Inject the data for x64
            foreach($f in $Languages) {

                # Everything concerting URI of the input
                foreach ($uri in $InstallURI_x64) {
                    $maniDict.Id.Installers.x64.$f.InstallURI=$uri
                    $maniDict.Id.Installers.x64.$f.FollowURI='put-follow-uri-function-result-here'
                    $maniDict.Id.Installers.x64.$f.Sha256='put-sha256-func-result-here'
                    $maniDict.Id.Installers.x64.$f.Sha512='put-sha256-func-result-here'
                }

                # Msi vs Exe
                foreach ($e in $MsiExe_x64) {
                    $maniDict.Id.Installers.x64.$f.MsiExe=$e
                }

                # Install Args (for Msi/Exe)
                foreach ($argy in $InstallURI_x64) {
                    $maniDict.Id.Installers.x64.$f.InstallArgs=$argy
                }

                # Uninstall Path (for Msi/Exe - because of Firefox)
                foreach ($removeExe in $UninstallExe_x64) {
                    $maniDict.Id.Installers.x64.$f.Uninstaller=$removeExe
                }

                # Uninstall Args (for Msi/Exe - because of Firefox)
                foreach ($removeArgy in $UninstallArgs_x64) {
                    $maniDict.Id.Installers.x64.$f.UninstallArgs=$removeArgy
                }

                # Update URI (tba)
                foreach ($webNotify in $UpdateRegex_x64) {
                    $maniDict.Id.Installers.x64.$f.UpdateURI=$webNotify
                }

                # Update Regex (for Update URI, tba)
                foreach ($reggie in $UpdateRegex_x64) {
                    $maniDict.Id.installers.x64.$f.UpdateRegex=$reggie
                }
            }
        }

        # x86 Section
        if ('x86' -in $Arch) {
            # Inject the data for x86
            foreach($f in $Languages) {

                # Everything concerting URI of the input
                foreach ($uri in $InstallURI_x86) {
                    $maniDict.Id.Installers.x86.$f.InstallURI=$uri
                    $maniDict.Id.Installers.x86.$f.FollowURI='put-follow-uri-function-result-here'
                    $maniDict.Id.Installers.x86.$f.Sha256='put-sha256-func-result-here'
                    $maniDict.Id.Installers.x86.$f.Sha512='put-sha256-func-result-here'
                }

                # Msi vs Exe
                foreach ($e in $MsiExe_x86) {
                    $maniDict.Id.Installers.x86.$f.MsiExe=$e
                }

                # Install Args (for Msi/Exe)
                foreach ($argy in $InstallURI_x86) {
                    $maniDict.Id.Installers.x86.$f.InstallArgs=$argy
                }

                # Uninstall Path (for Msi/Exe - because of Firefox)
                foreach ($removeExe in $UninstallExe_x86) {
                    $maniDict.Id.Installers.x86.$f.Uninstaller=$removeExe
                }

                # Uninstall Args (for Msi/Exe - because of Firefox)
                foreach ($removeArgy in $UninstallArgs_x86) {
                    $maniDict.Id.Installers.x86.$f.UninstallArgs=$removeArgy
                }

                # Update URI (tba)
                foreach ($webNotify in $UpdateRegex_x86) {
                    $maniDict.Id.Installers.x86.$f.UpdateURI=$webNotify
                }

                # Update Regex (for Update URI, tba)
                foreach ($reggie in $UpdateRegex_x86) {
                    $maniDict.Id.installers.x86.$f.UpdateRegex=$reggie
                }
            }
        }

    }
    
    end {
        
    }
}


#region Application particulars

[String]$global:TempFile+='    "Intallers": {' + $OFS
#endregion Application particulars