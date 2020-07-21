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