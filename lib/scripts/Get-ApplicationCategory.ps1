function Get-ApplicationCategory {
<#
.SYNOPSIS
  Sets category for Application.

.DESCRIPTION
  From selection provided, sets the category in the Application Manifest. This is used to help group software in the GUI.
  
.PARAMETER Category
  Category of application the manifest is being created for. Pre-defined list.

.INPUTS
  None

.OUTPUTS
  JSON-formatted string value showing Category:<category> for direct injection into manifest.

.NOTES
  Version:        2.0.0.6
  Author:         Copyright © 2020 RePass Cloud Pty Ltd (https://repasscloud.com/). All rights reserved.
  License:        Apache-2.0
  Creation Date:  2020-07-12
  Purpose/Change: Initial creation.
  
.EXAMPLE
  Set-ApplicationParticulars -Publisher 'Google' `
    -AppName 'Chrome' `
    -Version 83.0.4103.116

#>
[CmdletBinding()]
    param (
        [Parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Application category from list.',
            Position=0)]
        [ValidateScript({
            [Array]$catList = @('browser','business','entertainment','graphic_design','photo','social','productivity','games','security','microsoft')
            if ( $_ -in $catList ) {
                $_
            }
            else {
                Throw "'$_' does NOT use an approved Publisher name."
            }
        })]
        [String]
        $Category
    )

    process {

        # Linebreak
        $OFS="`r`n"

        Switch ($Category) {
            'browser'        { [int16]$choice = 1; }
            'business'       { [int16]$choice = 2; }
            'entertainment'  { [int16]$choice = 3; }
            'graphic_design' { [int16]$choice = 4; }
            'photo'          { [int16]$choice = 5; }
            'social'         { [int16]$choice = 6; }
            'productivity'   { [int16]$choice = 7; }
            'games'          { [int16]$choice = 8; }
            'security'       { [int16]$choice = 9; }
            'microsoft'      { [int16]$choice = 10; }
        }

        if (-not($choice)) {
            do {
                [void][System.Console]::Clear()
                [String]$menu = @"
Application Category
====================

"@
                $f='https://raw.githubusercontent.com/repasscloud/software-library/patch/20/lib/public/app_taxonomy.ini'
                $output_file="${env:TEMP}\$([GUID]::NewGuid())_app_taxonomy.ini"
                [int]$counter=1
                $snwc=[System.Net.WebClient]::new()
                $snwc.DownloadFileAsync($f,$output_file)
                $snwc.Dispose()
                [System.Threading.Thread]::Sleep(100)
                $wcssa=[System.IO.File]::OpenText($output_file)
                while (-not($wcssa.EndOfStream)) {
                    $line=$wcssa.ReadLine()
                    $menu += "`r`n" + '  [' + $counter + ']' + "`t" + $line
                    $counter += 1
                }
                $menu += "`r`n"
                $wcssa.Close()
                $wcssa.Dispose()
                #[void][System.Console]::WriteLine($menu)  #~> issue #38 via Codacy
                Show-HostOutput -ScreenOutput $menu  #~> issue #41 via Codacy
                [int]$choice=Read-Host -Prompt 'Enter choice'
            } until ($choice -in 1..($counter-1))
        }

        # Add category to [String]$json_return_value
        Switch ($choice) {
            1 { [String]$json_return_value += '  "Category": "browser",' + $OFS }
            2 { [String]$json_return_value += '  "Category": "business",' + $OFS }
            3 { [String]$json_return_value += '  "Category": "entertainment",' + $OFS }
            4 { [String]$json_return_value += '  "Category": "graphic & design",' + $OFS }
            5 { [String]$json_return_value += '  "Category": "photo",' + $OFS }
            6 { [String]$json_return_value += '  "Category": "social",' + $OFS }
            7 { [String]$json_return_value += '  "Category": "productivity",' + $OFS }
            8 { [String]$json_return_value += '  "Category": "games",' + $OFS }
            9 { [String]$json_return_value += '  "Category": "security",' + $OFS }
            10 { [String]$json_return_value += '  "Category": "microsoft",' + $OFS }
        }
        return [String]$json_return_value
    }

    end {
        [System.GC]::Collect()
    }
}