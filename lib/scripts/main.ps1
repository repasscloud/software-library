# Set TLS 1.2
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

# Encoding utf-8
[Console]::OutputEncoding=[System.Text.Encoding]::UTF8

# Linebreak
$OFS="`r`n"

# Repo directories
$currentDir = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
$repo_root_dir = Split-Path -Path (Split-Path -Path $currentDir -Parent) -Parent
$manifest_root_dir = Join-Path -Path $repo_root_dir -ChildPath 'app'

#[void][System.Console]::Clear()
#[void][System.Console]::WriteLine($appCategoryPrompt)

# Start of $json_output
[String]$json_output='{' + $OFS

# Set application category
$choice=$null
do {
    [void][System.Console]::Clear()
    [String]$menu = @"
Application Category
====================

"@
    $f='https://raw.githubusercontent.com/repasscloud/software-library/patch/20/lib/public/app_taxonomy.ini'
    $output_file="${env:TEMP}\$([GUID]::NewGuid())_app_taxonomy.ini"
    [int]$counter=1
    ([System.Net.WebClient]::new()).DownloadFileAsync($f,$output_file)
    [System.Threading.Thread]::Sleep(50)
    $wc=[System.IO.File]::OpenText($output_file)
    while (-not($wc.EndOfStream)) {
        $line=$wc.ReadLine()
        $menu += "`r`n" + '  [' + $counter + ']' + "`t" + $line
        $counter += 1
    }
    $menu += "`r`n"
    $wc.Close()
    [void][System.Console]::WriteLine($menu)
    [int]$choice=Read-Host -Prompt 'Enter choice'
} until ($choice -in 1..($counter-1))

# Add category to $json_output
Switch ($choice) {
    1 { $json_output += '    "Category": "browser",' + $OFS }
    2 { $json_output += '    "Category": "business",' + $OFS }
    3 { $json_output += '    "Category": "entertainment",' + $OFS }
    4 { $json_output += '    "Category": "graphic & design",' + $OFS }
    5 { $json_output += '    "Category": "photo",' + $OFS }
    6 { $json_output += '    "Category": "social",' + $OFS }
    7 { $json_output += '    "Category": "productivity",' + $OFS }
    8 { $json_output += '    "Category": "games",' + $OFS }
    9 { $json_output += '    "Category": "security",' + $OFS }
    10 { $json_output += '    "Category": "microsoft",' + $OFS }
}

$json_output