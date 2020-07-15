#Requires -PSEdition Core


# Start json manifest file
[String]$global:TempFile+='{' + $OFS

#region Category
# Set application category
$appCat = Get-ApplicationCategory -Category 'browser'
[String]$global:TempFile+=$appCat
#endregion Category

function Invoke-CreateCManiCore {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory=$false,
            ValueFromPipeline=$false,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            Position=0)]
        [ValidateNotNull]
        [ValidateNotNullOrEmpty]
        [ValidateCount(5,14)]
        [ValidateSet('browser','business','entertainment','graphic_design','photo','social','productivity','games','security','microsoft')]
        [ValidateScript(
            {
                [Array]$CategoryArray=@('browser','business','entertainment','graphic_design','photo','social','productivity','games','security','microsoft')
                if ( $_ -in $CategoryArray ) {
                    $_
                }
                else {
                    Throw "'$_' does NOT use an approved Publisher name."
                }
            }
        )]
        [Alias('cat')]
        [String]$Category,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$false,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            Position=1)]
        [ValidateNotNull]
        [ValidateNotNullOrEmpty]
        [ValidateCount(1,120)]
        [Alias('pub')]
        [String]$Publisher,

        [Parameter(Mandatory=$false,
            ValueFromPipeline=$false,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            Position=2)]
        [ValidateNotNull]
        [ValidateNotNullOrEmpty]
        [ValidateCount(5,14)]
        [ValidateSet('browser','business','entertainment','graphic_design','photo','social','productivity','games','security','microsoft')]
        [ValidateScript(
            {
                [Array]$catList = @('browser','business','entertainment','graphic_design','photo','social','productivity','games','security','microsoft')
                if ( $_ -in $catList ) {
                    $_
                }
                else {
                    Throw "'$_' does NOT use an approved Publisher name."
                }
            }
        )]
        [Alias('cat')]
        [String]$Category
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
        [String]$dir_tmp=$env:TMPDIR

        # Import all functions
        Get-ChildItem -Path $dir_Scripts -Filter "*.ps1" -Recurse | ForEach-Object { . $_.FullName }

        # Create temporary file
        [String]$file_tmp=Join-Path -Path $dir_tmp -ChildPath $([System.GUID]::NewGuid().GUID + '.json')
    }
    
    process {
        Get-ApplicationCategory -Category $Category

        Get-ApplicationParticulars `
            -Publisher $Publisher `
            -AppName $Application `
            -Version $Version `
            -AppCopyright $CopyrightNotice `
            -License $LicenseType `
            -LicenseURI $LicenseURI `
            -Tags $Tags `
            -Description $Description `
            -Homepage $Homepage `
            -Arch $Architecture `
            -Languages $Languages
    }
    
    end {
        
    }
}


#region Application particulars

[String]$global:TempFile+='    "Intallers": {' + $OFS
#endregion Application particulars