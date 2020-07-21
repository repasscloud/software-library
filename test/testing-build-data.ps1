



[String]$m = @"
  For installer language ${Language}, select architecture
"@
[int]$c = 1
$f = 'C:\tmp\software-matrix\lib\public\installer_type.ini'
$x = [System.IO.File]::OpenText($f)
while (-not($x.EndOfStream)) {
    $line = $x.ReadLine()
    $m += "`r`n" + '    [' + $c + ']  ' + $line
    $c += 1
}
$x.Close()
$m




[String]$m = @"
  For installer language ${Language}, select architecture
"@
[int]$c = 1
$f = 'C:\tmp\software-matrix\lib\public\installer_type.ini'
$x = [System.IO.File]::OpenText($f)
while (-not($x.EndOfStream)) {
    $line = $x.ReadLine()
    $m += "`r`n" + '    [' + $c + ']  ' + $line
    $c += 1
}
$x.Close()
$m


([System.Net.WebClient]::new()).DownloadFile('https://gitlab.com/reform-cloud/r-and-d/software-matrix/-/raw/patch/20/lib/public/installer_type.ini',"${env:TEMP}\installer_type.ini")
$x = [System.IO.File]::OpenText("${env:TEMP}\installer_type.ini")
while (-not($x.EndOfStream)) {
  $line=$x.ReadLine()
  $line
}
$x.Close()



$f = 'https://gitlab.com/reform-cloud/r-and-d/software-matrix/-/raw/patch/20/lib/public/installer_type.ini'
$wc = [System.Net.WebClient]::new()
$dl = $wc.DownloadString($f)
$dl
$wc.Dispose()

















[String]$m = @"
  For installer language ${Language}, select architecture
"@
[int]$c = 1
$f = 'https://gitlab.com/reform-cloud/r-and-d/software-matrix/-/raw/patch/20/lib/public/installer_type.ini'
$wc = [System.Net.WebClient]::new()
$stream = $wc.OpenRead($f)
$reader = [System.IO.StreamReader]($stream)
while (-not($reader.EndOfStream)) {
    $line = $reader.ReadLine();
    $m += "`r`n" + '    [' + $c + ']  ' + $line;
    $c += 1;
}
$reader.Close()
$wc.Dispose()
$m






$wc = [System.Net.WebClient]::new()
$stream = $wc.OpenRead($f)
$reader = [System.IO.StreamReader]($stream)
$reader.ReadToEnd() | ForEach-Object {

}
$wc.Disposed

[String]$m = @"
  For installer language ${Language}, select architecture
"@
[int]$c = 1
$f = 'https://gitlab.com/reform-cloud/r-and-d/software-matrix/-/raw/patch/20/lib/public/installer_type.ini'
$wc = [System.Net.WebClient]::new()
$stream = $wc.OpenRead($f)
$reader = [System.IO.StreamReader]($stream)
$reader.ReadToEnd() | ForEach-Object {
    $m += "`r`n" + '    [' + $c + ']  ' + $_
    $c += 1
}
$wc.Dispose()
$m







$x = [System.IO.File]::OpenText($f)
while (-not($x.EndOfStream)) {
    $line = $x.ReadLine()
    $m += "`r`n" + '    [' + $c + ']  ' + $line
    $c += 1
}
$x.Close()
$m




