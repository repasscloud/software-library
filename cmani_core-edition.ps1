#Requires -PSEdition Core
#Requires -Module Get.URLStatusCode
#Requires -Module GetRedirectedUrl

function Invoke-CreateCManiCore {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Category of application.',
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
            HelpMessage='Application version number using SemVer Standards.',
            Position=3)]
        [Alias('ver')]
        [System.Version]$Version,

        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Copyright notice. Must include "©" symbol or "Copyright" text.',
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
            HelpMessage='License list available online. Link: https://github.com/repasscloud/software-library/blob/ci/auto-builder-macdev/lib/public/licenses.md',
            Position=5)]
        [ValidateScript(
            {
                # Set Temp directory variable to $dir_tmp by OS selection, with backwards compatibility for Windows PS5.1
                if ($IsWindows -or $Env:OS) {
                    [String]$dir_tmpj=$Env:TEMP
                } else {
                    if ($IsLinux) {
                        Write-Output "Linux"
                    }
                    elseif ($IsMacOS) {
                        [String]$dir_tmpj=$Env:TMPDIR
                    }
                }
                # Set TLS 1.2
                [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
                $urlg='https://raw.githubusercontent.com/repasscloud/software-library/ci/auto-builder-macdev/lib/public/licenses.csv'
                $outputb=[System.IO.Path]::Combine($dir_tmpj,$([System.GUID]::NewGUID().Guid)+'.txt')
                (New-Object System.Net.WebClient).DownloadFile($urlg, $outputb)
                if ($_ -in ((Import-Csv -Path $outputb -Delimiter ',').'License Code')) {
                    $_
                }
                else{
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
                # Set TLS 1.2
                [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
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
                # Set TLS 1.2
                [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
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
                        Write-Output "Linux"
                    }
                    elseif ($IsMacOS) {
                        [String]$dir_tmp=$Env:TMPDIR
                    }
                }
                # Set TLS 1.2
                [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
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
                # Set TLS 1.2
                [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
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
            HelpMessage='Provided as [Array], URI for x64 application installation.',
            Position=17)]
        [ValidateScript(
            {
                foreach ($i in $_) {
                    # Set TLS 1.2
                    [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
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
            HelpMessage='Provided as [Array], URI for x86 application installation.',
            Position=18)]
        [ValidateScript(
            {
                foreach ($i in $_) {
                    # Set TLS 1.2
                    [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
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
            HelpMessage='Provided as [Array], installer file name.',
            Position=19)]
        [Alias('inst64')]
        [Array]$InstallExe_x64,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Provided as [Array], installer file name.',
            Position=20)]
        [Alias('inst86')]
        [Array]$InstallExe_x86,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Provided as [Array], silent install arguments.',
            Position=21)]
        [Alias('iargs64')]
        [Array]$InstallArgs_x64,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Provided as [Array], silent install arguments.',
            Position=22)]
        [Alias('iargs86')]
        [Array]$InstallArgs_x86,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Provided as [Array], installed application detection.',
            Position=23)]
        [Alias('funst64')]
        [Array]$FindUninstall_x64,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Provided as [Array], installed application detection.',
            Position=24)]
        [Alias('funst86')]
        [Array]$FindUninstall_x86,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Provided as [Array], uninstaller executable.',
            Position=25)]
        [Alias('unstexe64')]
        [Array]$UninstallExe_x64,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Provided as [Array], uninstaller executable.',
            Position=26)]
        [Alias('unstexe86')]
        [Array]$UninstallExe_x86,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Provided as [Array], uninstaller arguments.',
            Position=27)]
        [Alias('unstargs64')]
        [Array]$UninstallArgs_x64,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Provided as [Array], uninstaller arguments.',
            Position=28)]
        [Alias('unstargs86')]
        [Array]$UninstallArgs_x86,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Provided as [Array], update URI.',
            Position=29)]
        [ValidateScript(
            {
                foreach ($i in $_) {
                    # Set TLS 1.2
                    [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
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
            HelpMessage='Provided as [Array], update URI.',
            Position=30)]
        [ValidateScript(
            {
                foreach ($i in $_) {
                    # Set TLS 1.2
                    [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
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
            HelpMessage='Regex string for checking updates.',
            Position=31)]
        [Alias('updreg64')]
        [Array]$UpdateRegex_x64,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage='Regex string for checking updates.',
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
        [String]$dir_Manifests=Join-Path -Path $dir_CurrentWorking -ChildPath 'app'
        
        # Set Temp directory variable to $dir_tmp by OS selection, with backwards compatibility for Windows PS5.1
        if ($IsWindows -or $ENV:OS) {
            [String]$dir_tmp=$Env:TEMP
        } else {
            if ($IsLinux) {
                Write-Output "Linux"  #~> This needs to be tested still
            }
            elseif ($IsMacOS) {
                [String]$dir_tmp=$Env:TMPDIR
            }
        }

        # Create temporary file
        [String]$file_tmp=[System.IO.Path]::Combine($dir_tmp,$([System.GUID]::NewGUID().Guid))

        # Set UserAgent for downloading data
        $userAgent=[Microsoft.PowerShell.Commands.PSUserAgent]::Chrome

        # Manifest Copyright Notice
        $zClient=[System.Net.WebClient]::new()
        $zString=$zClient.DownloadString('https://raw.githubusercontent.com/repasscloud/software-library/ci/auto-builder-macdev/lib/public/json_copyright_notice.json')
        [String]$RePassCloudManifestCopyrightNotice=($zString | ConvertFrom-Json).Copyright
        $zClient.Dispose()
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

        # Set some variables for the output and clear out any spaces in the names of the files/folders
        [String]$Name=$Name.Replace(' ','')
        [String]$Publisher=$Publisher.Replace(' ','')
        [String]$ExtractPath=[System.IO.Path]::Combine($dir_Manifests,$Publisher,$Name)
        [String]$full_extract=[System.IO.Path]::Combine($ExtractPath,$Version.ToString()+'.json')
        [String]$latest_extract=[System.IO.Path]::Combine($ExtractPath,'latest.json')

        # Write out the new application manifest and close off
        if (-not(Test-Path -Path $ExtractPath)) {
            New-Item -Path $ExtractPath -ItemType Directory -Force -Confirm:$false
        }
        $maniDict | ConvertTo-Json -Depth 5 | Out-File -FilePath $full_extract -Encoding utf8 -Force -Confirm:$false
        $maniDict | ConvertTo-Json -Depth 5 | Out-File -FilePath $latest_extract -Encoding utf8 -Force -Confirm:$false

        # Create script return object
        $obj_r=@{}
        $obj_r.Add('Name',$Name)
        $obj_r.Add('Publisher',$Publisher)
        $obj_r.Add('Version',$Version)
        $obj_r.Add('full_extract',$full_extract)
        $obj_r.Add('maniDict',$maniDict)
        return $obj_r
    }
    end {
        [System.GC]::Collect()
    }
}
