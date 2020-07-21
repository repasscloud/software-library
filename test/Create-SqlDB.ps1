<#
$Query = "CREATE TABLE NAMES (fullname VARCHAR(20) PRIMARY KEY, surname TEXT, givenname TEXT, BirthDate DATETIME)"
$DataSource = "C:\Names.SQLite"

Invoke-SqliteQuery -Query $Query -DataSource $DataSource
#>


<#
# Set application unique name, short name, version and update date
        $query = "INSERT INTO APPS (Fullname, ShortName, Version, Date) VALUES (@AppFullName, @AppShortName, @AppVersion, @UpdateDate)"

# Inject data into SQL
Invoke-SqliteQuery -DataSource $Database -Query $query -SqlParameters @{
    AppFullName = $AppFullName
    AppShortName = $AppShortName
    AppVersion = $AppVersion
    UpdateDate = (Get-Date)
}
#>


$Query = "CREATE TABLE APPS (AppFullName VARCHAR(20) PRIMARY KEY, AppShortName TEXT, AppVersion TEXT, UpdateDate DATETIME)"
$DataSource = "S:\SCCM_Software_Update\apps\${BrandName}-${AppShortName}-db.sqlite"

    Invoke-SqliteQuery -Query $Query -DataSource $DataSource

$Query = "CREATE TABLE APPS (FullName VARCHAR(20) PRIMARY KEY, ShortName TEXT, Version, TEXT, Date DATETIME)"
Invoke-SqliteQuery -Query $Query -DataSource $Database



$response = Invoke-RestMethod -Uri $VersionURI | Set-Content -Encoding utf8
$jsonObj = ConvertFrom-Json $([String]::New($response.Content))


ConvertFrom-Json -InputObject $response














# Download URL page to test
$DLPage = Invoke-WebRequest -Uri http://www.videolan.org/ -UseBasicParsing

# Regex for x64/x86
$regex_64='-win64.exe$'
$regex_32='-win32.exe$'

$url_i64 = $DLPage.Links | Where-Object href -match $regex_64 | ForEach-Object href
$url_i32 = $DLPage.Links | Where-Object href -match $regex_32 | ForEach-Object href

$url_d64 = (Split-Path -Path $(if($url_i64.GetType().Name -eq 'String'){$url_i64}else{$url_i64[0]}) -Leaf)
$url_d32 = (Split-Path -Path $(if($url_i32.GetType().Name -eq 'String'){$url_i32}else{$url_i32[0]}) -Leaf)

$url_d64
$url_d32

$url_i = $DLPage.Links | Where-Object href -match '-win32.exe$' | ForEach-Object href
$url64_d = (Split-Path $url_i -Leaf)
$url64_m = $url64_d.Replace('.exe','.msi')
$url_v = (Split-Path $url_i -Leaf).Replace('-win64.exe','').Replace('vlc-','')




(Invoke-WebRequest -Uri 'http://www.videolan.org/vlc/download-windows.html' -UserAgent $null).RawContent | Where-Object {$_ -match '*.Version*.'}



# Set some variables
$DLPage = Invoke-WebRequest -Uri http://www.videolan.org/ -UseBasicParsing
$url_i = $DLPage.Links | Where-Object href -match '-win64.exe$' | ForEach-Object href
$url64_d = (Split-Path $url_i -Leaf)
$url64_m = $url64_d.Replace('.exe','.msi')
$url_v = (Split-Path $url_i -Leaf).Replace('-win64.exe','').Replace('vlc-','')


# Setup the data required into a hashtable
[hashtable]$VLC = @{
    Version = $url_v
    URL64_msi = "https://mirror.aarnet.edu.au/pub/videolan/vlc/${url_v}/win64/vlc-${url_v}-win64.msi"
}

# Read out the data
[string]$AppVersion = $VLC.Version
[string]$DownloadURI = $VLC.URL64_msi
[string]$AppShortName = 'VLC'
[string]$AppFullName = "${AppShortName} ${AppVersion}"
[string]$BrandName = 'VideoLAN'
$database = "S:\SCCM_Software_Update\apps\${AppShortName}.sqlite"
