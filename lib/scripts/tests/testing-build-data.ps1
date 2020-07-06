

[String]$m = @"
  For installer language ${Language}, select architecture
"@
[int]$c = 1
$x = [System.IO.File]::OpenText('C:\tmp\software-matrix\test\installer_type.ini')
while (-not($x.EndOfStream)) {
    $line = $x.ReadLine()
    $m += "`r`n" + '    [' + $c + ']  ' + $line
    $c += 1
}
$x.Close()
$m


    $reader = [System.IO.File]::OpenText($($i.FullName))

    while (!($reader.EndOfStream))
    {
        $line = $reader.ReadLine()
        # Perform action on each line of the log here
    }

    $reader.Close()
