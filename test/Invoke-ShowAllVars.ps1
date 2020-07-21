0..($var.Length-1) | ForEach-Object {
    [Int16]$number=$_;
    Write-Host "-----$number" -ForegroundColor Yellow
    $var[$number]
}